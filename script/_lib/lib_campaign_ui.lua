




----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	CAMPAIGN UI MANAGER
--
--- @set_environment campaign
--- @c campaign_ui_manager Campaign UI Manager
--- @desc The campaign UI manager provides support functions for querying and manipulating the UI in campaign. A campaign ui manager is automatically created when the @campaign_manager is created. A handle to the campaign ui manager can be retrieved from the campaign manager with @campaign_manager:get_campaign_ui_manager.
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


-- List of all panels in the game that are considered fullscreen/blocking. Blocking panels will block interventions, are considered fullscreen by cm:progress_on_blocking_panel_dismissed() and may have other effects in script.
-- As new panels are added to the game they should be added to either this list, or the panels_not_blocking list below. A script warning will be generated if a panel is opened that is not on either list - if this is seen, please add it
-- to one of them.
local panels_blocking = {

	-- BASE
	"diplomacy_dropdown",
	"campaign_tactical_map",
	"clan",
	"technology_panel",
	"building_browser",
	"character_details_panel",
	"ally_attacked",
	"agent_options",
	"appoint_new_general",
	"character_panel",		-- recruit lord/hero
	"units_recruitment",
	"unit_exchange",
	"mercenary_recruitment",
	"spell_browser",
	"objectives_screen",
	"finance_screen",
	"esc_menu",
	"move_options",
	"campaign_victory",
	"benchmark_summary",
	"panel_war_coordination",
	"movie_viewer",

	-- WH1
	"offices",
	"book_of_grudges",
	"elector_counts",
	"bloodlines_panel",
	
	-- WH2
	"rituals_panel",
	"intrigue_panel",
	"slaves_panel",
	"quest_details",
	"rite_performed",
	"books_of_nagash", 
	"mortuary_cult",
	"book_of_monster_hunts",
	"treasure_hunts",
	"scripted_sequence",
	"sotek_sacrifices",
	"ikit_workshop_panel",
	"shadowy_dealings_panel",
	"augment_panel",
	"hunters_panel",
	"temples_of_the_old_ones",
	"grom_cauldron_panel",
	"groms_cauldron",
	"athel_tamarha_dungeon",
	"dungeon_of_athel_tamarha",
	"forge_of_daith_panel",
	"oxyotl_threat_map",
	"beastmen_panel",
	"nakai_temples_panel",
	"sotek_sacrifice_panel",

	-- WH3
	"kislev_winter",
	"kislev_ice_court",
	"kislev_atamans",
	"cathay_compass",
	"cathay_caravans",
	"daemonic_progression",
	"great_game_rituals",
	"nurgle_plagues",
	"tzeench_wom_manipulation",
	"tzeentch_changing_of_ways",
	"ogre_bounties",
	"ogre_great_maw",
	"rifts",
	"war_coordination",
	"narrative_viewer",

	--WH3 DLC
	"chaos_gifts",
	"chd_narrative_panel",
	"hellforge_panel_main",
	"tower_of_zharr",
	"military_convoys",
	"labour_economy",
	"dlc24_jade_compass",
	"dlc24_matters_of_state",
	"dlc24_witches_hut",
	"dlc24_schemes",
	"dlc25_don_main",
	"dlc25_tamurkhan_chieftains",
	"dlc25_malakai_oaths",
	"dlc25_bog_main",
	"dlc25_college_of_magic",
	"dlc25_electoral_machinations",
	"dlc25_nurgle_plagues",
	"dlc26_skull_throne",
	"dlc26_cloak_of_skulls",
	"dlc26_wrath_of_khorne",
	"dlc26_ogre_war_contracts",
	"dlc26_tyrants_demands",
	"dlc26_character_panel_camps"
};

-- Panels for which a PanelOpenedCampaign event is sent to script, but the panel should not block interventions or be considered by cm:progress_on_blocking_panel_dismissed()
-- TODO: should events be moved to the blocking list? Or be considered separately?
local panels_not_blocking = {
	"events",
	"popup_pre_battle",
	"popup_battle_results",
	"settlement_captured",
	"settlement_panel",
	"units_panel",
	"recruitment_options",
	"waiting_for_players",
	"malus_quest_details",
	"sea_lanes",
	"chd_end_game_teleport",
	"dlc24_hex_rituals",
	"dlc25_nemesis_crown",
};


----------------------------------------------------------------------------
--	Definition
----------------------------------------------------------------------------

campaign_ui_manager = {
	cm = false,
	
	-- ui overrides
	override_list = {},
	should_save_override_state = true,
	
	-- whitelists
	character_selection_whitelist = {},
	settlement_selection_whitelist = {},
	all_whitelists_disabled = false,
	
	-- end turn warning suppression
	end_turn_warnings_to_suppress = {},
	end_turn_warning_suppression_system_started = false,
	
	-- selection listeners
	--[[
	panels_open = {},
	panels_blocking_open = {},
	]]
	character_selected_cqi = nil,
	character_selected_faction = "",
	mf_selected_cqi = false,
	mf_selected_type = false,
	settlement_selected = "",
	region_selected = "",
	
	-- highlighting
	--[[
	highlighted_settlements_vfx = {},
	highlighted_settlements_markers = {},
	highlighted_settlements_near_camera = {},
	highlighted_characters_vfx = {},
	highlighted_characters_markers = {},
	highlighted_characters_near_camera = {},
	]]
	
	-- ui locking
	ui_locked = false,
	
	-- multiple calling scripts can lock the ui, the ui only gets unlocked when the lock level reaches 0
	ui_lock_level = 0,
	event_panel_auto_open_lock_level = 0,
	
	-- visibility state of various ui features (that get hidden on the first turn)
	faction_buttons_displayed = true,
	resources_bar_displayed = true,
	
	-- list of panels that block interventions
	panels_blocking = panels_blocking,
	panels_blocking_lookup = table.indexed_to_lookup(panels_blocking),

	-- list of panels that don't block interventions
	panels_not_blocking = panels_not_blocking,
	panels_not_blocking_lookup = table.indexed_to_lookup(panels_not_blocking),
	
	output_stamp = 0,
	
	diplomacy_audio_lock_level = 0,
	
	button_pulse_strength = 10,
	panel_pulse_strength = 5,
	
	-- unhighlight_action_list = {},

	help_page_link_highlighting_permitted = true
};


set_class_custom_type_and_tostring(campaign_ui_manager, TYPE_CAMPAIGN_UI_MANAGER);




----------------------------------------------------------------------------
---	@section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns a new campaign ui manager object, or returns an existing one if one was previously created. This function can be used interchangeably with @campaign_manager:get_campaign_ui_manager.
--- @r campaign_ui_manager campaign ui manager
function campaign_ui_manager:new()
	
	-- there can only be one of these objects, if the cm already has a link to one return that instead
	if cm.campaign_ui_manager then
		return cm.campaign_ui_manager;
	end;
	
	-- check that the ui isn't already initialised or the game is not already loaded
	if core:is_ui_created() then
		script_error("ERROR: an attempt was made to create a campaign_ui_manager object but the UI has already been initialised or the game has already been loaded. Create this object earlier.");
		return false;
	end;

	local ui = {};

	set_object_class(ui, self);
	
	ui.cm = cm;
	
	ui.end_turn_warnings_to_suppress = {};
		
	-- ui overrides
	ui.override_list = {};
	
	cm:add_pre_first_tick_callback(
		function(context) 
			if not cm:is_multiplayer() then
				ui:set_all_overrides();
			end;
		end
	);
	
	cm:add_saving_game_callback(function(context) ui:save_override_state(context) end);
	cm:add_loading_game_callback(function(context) ui:load_override_state(context) end);
	
	-- selection whitelists
	ui.character_selection_whitelist = {};
	
	-- selection listeners
	ui.panels_open = {};
	ui.panels_blocking_open = {};
	
	-- highlighting
	ui.highlighted_settlements_vfx = {};
	ui.highlighted_settlements_markers = {};
	ui.highlighted_characters_vfx = {};
	ui.highlighted_characters_markers = {};
	ui.highlighted_settlements_near_camera = {};
	ui.highlighted_characters_near_camera = {};
	ui.unhighlight_action_list = {};
	
	-- register this object with the campaign manager
	cm.campaign_ui_manager = ui;
	
	ui:start_campaign_ui_listeners();
	
	-- load in ui overrides
	ui:load_ui_overrides();
	
	return ui;
end;








----------------------------------------------------------------------------
---	@section Usage
--- @desc Once a <code>campaign_ui_manager</code> object has been created with @campaign_ui_manager:new or @campaign_manager:get_campaign_ui_manager, functions on it may be called using the form showed below.
--- @new_example Specification
--- @example <i>&lt;ui_manager_object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example local uim = campaign_ui_manager:new()
--- @example if uim:is_panel_open("events") then		-- calling a function on the object once created
--- @example 	out("Events panel is open")
--- @example end
--- @result Events panel is open
----------------------------------------------------------------------------










----------------------------------------------------------------------------
---	@section UI Listeners
--- @desc The campaign ui manager keeps track of what settlement and character is selected and what ui panels are open. This information can be queried with the functions in this section.
----------------------------------------------------------------------------


--	starts this system - called internally when the campaign_ui_manager object is set up
function campaign_ui_manager:start_campaign_ui_listeners()
	local cm = self.cm;

	local no_panel_warning_issued = true;

	-- panel opened
	core:add_listener(
		"campaign_selection_listener",
		"PanelOpenedCampaign",
		true,
		function(context)
			local panel = context.string;
			out.ui("Panel opened " .. panel);

			-- Check that this panel has been added to one of our internal lists
			if no_panel_warning_issued and not self.panels_blocking_lookup[panel] and not self.panels_not_blocking_lookup[panel] then
				script_error("WARNING: PanelOpenedCampaign event received for panel with name [" .. tostring(panel) .. "], but this panel has not been added to the panels_blocking or panels_not_blocking list in lib_campaign_ui.lua. Please add it to one of these lists - the blocking list of panels blocks scripted interventions (i.e. prevents normal advice from proceeding), the not-blocking does not. If it dismisses or covers the main UI (e.g. tech, diplomacy) a record will need adding to the overrides list in lib_help_pages.lua too.");
				no_panel_warning_issued = false;		-- only issue this script_error once
			end;
			
			self.panels_open[panel] = true;

			if self.panels_blocking_lookup[panel] then
				self.panels_blocking_open[panel] = true;
			end;

			core:trigger_event("ScriptEventPanelOpenedCampaign", panel);
		end,
		true
	);
	
	-- panel closed
	core:add_listener(
		"campaign_selection_listener",
		"PanelClosedCampaign",
		true,
		function(context)
			local panel = context.string;
			out.ui("Panel closed " .. panel);
			
			self.panels_open[panel] = false;
			self.panels_blocking_open[panel] = false;

			core:trigger_event("ScriptEventPanelClosedCampaign", panel);
		end,
		true
	);
	
	-- panel closed failsafe
	-- when player ends their turn, assume that all panels are closed
	core:add_listener(
		"campaign_selection_listener",
		"ScriptEventPlayerFactionTurnEnd",
		true,
		function()
			out.ui("Player is ending turn - clearing the open panels list");
			self.panels_open = {};
			self.panels_blocking_open = {};
		end,
		false	
	);


	-- character selected
	core:add_listener(
		"campaign_selection_listener",
		"CharacterSelected",
		true,
		function(context)
			local character = context:character();
			
			local str = "Character selected, cqi: " .. character:cqi() .. " || faction: " .. common.get_localised_string("factions_screen_name_" .. character:faction():name()) .. " (key " .. character:faction():name() .. ") || subtype: " .. character:character_subtype_key() .. " || name: ";
			
			-- name
			if character:get_surname() == "" then
				str = str .. common.get_localised_string(character:get_forename()) .. " (key " .. character:get_forename() .. ", no surname)";
			else
				str = str .. common.get_localised_string(character:get_forename()) .. " " .. common.get_localised_string(character:get_surname()) .. " (key " .. character:get_forename() .. ", " .. character:get_surname() .. ")";
			end;
			
			-- position
			local char_pos = character:position();

			if not char_pos:is_null_interface() then
				str = str .. " || position: log [" .. character:logical_position_x() .. ", " .. character:logical_position_y() .. "] dis [" .. character:display_position_x() .. ", " .. character:display_position_y() .. "]"
			end

			if character:has_garrison_residence() then
				str = str .. " || garrisoned in settlement:" .. character:garrison_residence():region():name() .. ")";
			end;
			
			out.ui(str);
			
			self.character_selected_cqi = character:cqi();
			self.character_selected_faction = character:faction():name();
			
			if character:has_military_force() then
				local mf = character:military_force();
				self.mf_selected_cqi = mf:command_queue_index();
				self.mf_selected_type = mf:force_type():key();
			else
				self.mf_selected_cqi = false;
				self.mf_selected_type = false;
			end;
			
			self.settlement_selected = "";
			self.region_selected = "";
		end,
		true
	);
	
	
	-- character deselected (only fired when no other character is selected)
	core:add_listener(
		"campaign_selection_listener",
		"CharacterDeselected",
		true,
		function(context)
			self.character_selected_cqi = -1;
			self.character_selected_faction = "";
			self.mf_selected_cqi = false;
			self.mf_selected_type = false;
		end,
		true
	);
	
	
	-- settlement selected
	core:add_listener(
		"campaign_selection_listener",
		"SettlementSelected",
		true,
		function(context) 
			local gr = context:garrison_residence();
			local region_name = gr:region():name();
			local settlement_name = gr:settlement_interface():key();
			out.ui("Settlement selected [" .. settlement_name .. "] in region [" .. region_name .. "]");
			
			self.region_selected = region_name;
			self.settlement_selected = settlement_name;
			self.character_selected_cqi = -1;
			self.character_selected_faction = "";
			self.mf_selected_cqi = false;
			self.mf_selected_type = false;
		end,
		true
	);
	
	-- settlement deselected (only fired when no other settlement is selected)
	core:add_listener(
		"campaign_selection_listener",
		"SettlementDeselected",
		true,
		function(context) 
			self.region_selected = "";
			self.settlement_selected = "";
		end,
		true
	);
end;


--- @function is_panel_open
--- @desc Returns whether a ui panel with the supplied name is currently open.
--- @p @string panel name
--- @r @boolean is panel open
function campaign_ui_manager:is_panel_open(panel)
	if self.panels_open[panel] then
		return true;
	end;
	return false;
end;


--- @function is_blocking_panel_open
--- @desc Returns whether a ui panel with the supplied name that should block interventions is currently open.
--- @p @string panel name
--- @r @boolean is panel open
function campaign_ui_manager:is_blocking_panel_open(panel)
	if self.panels_open[panel] then
		return true;
	end;
	return false;
end;


--- @function is_event_panel_open
--- @desc Returns whether an event panel is currently open.
--- @r boolean is event panel open
function campaign_ui_manager:is_event_panel_open()
	if self:is_panel_open("events") then
		local uic_events = find_uicomponent(core:get_ui_root(), "events"); 
		return uic_events and uic_events:Visible();
	end;
	return false;
end;


--- @function get_open_panel
--- @desc Returns the name of a ui panel that's open, or <code>false</code> if no panels are open. If more than one ui panel is open then the name of one is returned at random.
--- @r @string open panel
function campaign_ui_manager:get_open_panel()
	local panel_name = table.contains(self.panels_open, true);
	return panel_name;
end;


--- @function get_open_blocking_panel
--- @desc Returns the name of a blocking panel that's open, or <code>false</code> if no panels are open. If more than one blocking panel is open then the name of one is returned at random.
--- @desc Blocking panels are panels that block the progress of @intervention (unless they are configured to disregard this).
--- @r @string open blocking panel
function campaign_ui_manager:get_open_blocking_panel()
	local panel_name = table.contains(self.panels_blocking_open, true);
	return panel_name;
end;


--- @function get_open_blocking_or_event_panel
--- @desc Returns the name of the first blocking panel that's open, including the events panel, or <code>false</code> if no panels are open. Usually only one blocking panel is open at a time but in certain circumstances (such as diplomacy) more than one may be open at a time.
--- @r @string open blocking panel
function campaign_ui_manager:get_open_blocking_or_event_panel()
	local panel = self:get_open_blocking_panel();

	if not panel and self:is_event_panel_open() then
		panel = "events";
	end;

	return panel;
end;


--- @function is_char_selected
--- @desc Returns whether the supplied character is selected.
--- @p character character
--- @r @boolean is character selected
function campaign_ui_manager:is_char_selected(character)
	return self.character_selected_cqi == character:cqi();
end;


--- @function get_char_selected_cqi
--- @desc Returns the cqi of the selected character.
--- @r @boolean is character selected
function campaign_ui_manager:get_char_selected_cqi()
	return self.character_selected_cqi;
end;


--- @function is_char_selected_from_faction
--- @desc Returns whether a character from the supplied faction is selected.
--- @p string faction name
--- @r @boolean is character selected
function campaign_ui_manager:is_char_selected_from_faction(faction_name)
	return self.character_selected_faction == faction_name;
end;


--- @function get_mf_selected_cqi
--- @desc Returns the cqi of the currently selected military force. If no military force is currently selected then <code>false</code> is returned.
--- @return @boolean is character selected
function campaign_ui_manager:get_mf_selected_cqi()
	return self.mf_selected_cqi;
end;


--- @function get_mf_selected_type
--- @desc Returns the force type key of the currently selected military force. If no military force is currently selected then <code>false</code> is returned.
--- @return @string force type key
function campaign_ui_manager:get_mf_selected_type()
	return self.mf_selected_type;
end;


--- @function is_settlement_selected
--- @desc Returns whether a settlement with the supplied key is selected.
--- @p @string settlement name
--- @r @boolean is settlement selected
function campaign_ui_manager:is_settlement_selected(settlement_name)
	return self.settlement_selected == settlement_name;
end;


--- @function get_selected_settlement
--- @desc Returns the string name of the selected settlement. If no settlement is selected a blank string is returned.
--- @r @string selected settlement name
function campaign_ui_manager:get_selected_settlement()
	return self.settlement_selected;
end;


--- @function get_selected_settlement_region
--- @desc Returns the string name of the region containing the selected settlement. If no settlement is selected a blank string is returned.
--- @r @string selected settlement region name
function campaign_ui_manager:get_selected_settlement_region()
	return self.region_selected;
end;













----------------------------------------------------------------------------
---	@section Scripted Sequences
----------------------------------------------------------------------------

--- @function start_scripted_sequence
--- @desc This is a mechanism by which client scripts can notify the ui manager that a scripted sequence has started, which registers "scripted_sequence" in the panel open list. This has the effect of making the ui manager think that a fullscreen panel is open, stalling any pending interventions. Avoid using this unless you really have to, probably the only case where it's valid is in the case of script that must work in singleplayer and also multiplayer.
function campaign_ui_manager:start_scripted_sequence()
	out.ui("Scripted sequence started - spoofing panel opening");
	self.panels_open.scripted_sequence = true;
end;


--- @function stop_scripted_sequence
--- @desc Removes "scripted_sequence" from the panel open list. This must be called after @campaign_ui_manager:start_scripted_sequence.
function campaign_ui_manager:stop_scripted_sequence()
	out.ui("Scripted sequence ended - spoofing panel closing");
	
	if self:is_panel_open("scripted_sequence") then
		self.panels_open.scripted_sequence = false;
		
		-- induce progress_on_blocking_panel_dismissed() to progress
		core:trigger_event("ScriptEventPanelClosedCampaign", "scripted_sequence");
	end;
end;











----------------------------------------------------------------------------
--- @section End Turn Warnings
--- @desc The @campaign_ui_manager:suppress_end_turn_warning function can be used to suppress the following end turn warnings - not all of them may be supported by each project:
----------------------------------------------------------------------------


-- end turn warnings
campaign_ui_manager.end_turn_warnings = {
	["none"] = 0,			--- @desc <ul><li>"none" - None</li>
	["bankrupt"] = 1,		--- @desc <li>"bankrupt" - Low funds</li>
	["tech"] = 2,			--- @desc <li>"tech" - Research available</li>
	["edict"] = 4,			--- @desc <li>"edict" - Commandment available</li>
	["character"] = 8,		--- @desc <li>"character" - Character upgrade available</li>
	["settlement"] = 16,	--- @desc <li>"settlement" - Settlement upgrade available</li>
	["vortex_ritual"] = 32,	--- @desc <li>"vortex_ritual" - Vortex ritual available</li>
	["siege"] = 64,			--- @desc <li>"siege" - Siege construction available</li>
	["army_morale"] = 128,	--- @desc <li>"army_morale" - Low fightiness</li>
	["repair"] = 256,		--- @desc <li>"repair" - Damaged building</li>
	["construction"] = 512,	--- @desc <li>"construction" - Building available</li>
	["office"] = 1024,		--- @desc <li>"office" - Office slot available</li>
	["army_ap"] = 2048,		--- @desc <li>"army_ap" - Army ap available</li>
	["hero_ap"] = 4096,		--- @desc <li>"hero_ap" - Hero ap available</li>
	["rebellion"] = 8192,	--- @desc <li>"rebellion" - Imminent rebellion</li>
	["garrison_ap"] = 16384	--- @desc <li>"garrison_ap" - Garrison army ap available</li></ul>
};

--- @function suppress_end_turn_warning
--- @desc Activates or deactivates a suppression on a specified end-turn warning. If an end-turn warning is suppressed it is prevented from appearing.
--- @p @string type, Warning to suppress. See the documentation for the @"campaign_ui_manager:End Turn Warnings" section for available end turn warnings.
--- @p @boolean suppress, Activate suppression.
function campaign_ui_manager:suppress_end_turn_warning(warning, should_suppress)
	if not is_string(warning) then
		script_error("ERROR: suppress_end_turn_warning() called but supplied warning [" .. tostring(warning) .. "] is not a string");
		return false;
	end;
	
	local warning_id = self.end_turn_warnings[warning];
	
	if not is_number(warning_id) then
		script_error("ERROR: suppress_end_turn_warning() called but supplied warning [" .. tostring(warning) .. "] could not be looked up from the end_turn_warnings table in the campaign ui manager");
		return false;
	end;
	
	-- cast should_suppress to either true or nil
	if should_suppress then
		should_suppress = true;
		self:suppress_end_turn_warning_action(warning_id);
	else
		should_suppress = nil;
	end;
	
	self.end_turn_warnings_to_suppress[warning_id] = should_suppress;
	
	if not self.end_turn_warning_suppression_system_started then
		-- End turn warning reset monitor is not already started, so start it.
		-- The code periodically has to reset its actions mask, but it notifies script through this event so we can re-set the suppressions we're interested in.
		core:add_listener(
			"suppress_end_turn_warning_monitor",
			"PendingActionsMaskReset",
			true,
			function(context)			
				local uic_pending_action_notifications = find_uicomponent(core:get_ui_root(), "faction_buttons_docker", "notification_frame");
								
				local any_warnings_suppressed = false;
				
				for current_warning, current_should_suppress in pairs(self.end_turn_warnings_to_suppress) do
					if current_should_suppress then
						self:suppress_end_turn_warning_action(current_warning, uic_pending_action_notifications);
						any_warnings_suppressed = true;
					end;
				end;
				
				-- if no warnings have been suppressed then stop the monitor
				if not any_warnings_suppressed then
					core:remove_listener("suppress_end_turn_warning_monitor");
					self.end_turn_warning_suppression_system_started = false;
				end;
			end,
			true
		);
		self.end_turn_warning_suppression_system_started = true;
	end;
end;


-- not for external use
function campaign_ui_manager:suppress_end_turn_warning_action(warning, uic_pending_action_notifications)
	if not uic_pending_action_notifications then
		uic_pending_action_notifications = find_uicomponent(core:get_ui_root(), "faction_buttons_docker", "notification_frame");
		
		if not uic_pending_action_notifications then
			script_error("WARNING: suppress_end_turn_warning_action() could not find notification_frame uicomponent, suppression of end turn warning [" .. tostring(warning) .. "] will not occur");
			return false;
		end;
	end;
	
	uic_pending_action_notifications:InterfaceFunction("SetIgnoreMask", warning);
end;













----------------------------------------------------------------------------
--- @section Output Stamps
----------------------------------------------------------------------------


--- @function get_next_output_stamp
--- @desc Returns an incremental number which can be used for matching output between tabs.
--- @r number output stamp
function campaign_ui_manager:get_next_output_stamp()
	self.output_stamp = self.output_stamp + 1;
	return self.output_stamp;
end;









----------------------------------------------------------------------------
--- @section Locking/Unlocking UI
----------------------------------------------------------------------------


--- @function lock_ui
--- @desc Partially locks the ui, preventing the player from ending turn or moving armies and suppressing the events rollout. Subsequent calls to the function will increase the lock level on the ui, with calls to @campaign_ui_manager:unlock_ui reducing the lock level on the ui. The ui will only unlock when the lock level is reduced back to zero.
function campaign_ui_manager:lock_ui()
	self.ui_lock_level = self.ui_lock_level + 1;
	
	-- script_error("lock_ui() called, ui_lock_level is now " .. self.ui_lock_level);

	if self.ui_locked then
		return;
	end;
	
	self.ui_locked = true;
	
	local cm = self.cm;
	
	local stamp = self:get_next_output_stamp();
	local out_str = "lock_ui() called, output stamp is " .. tostring(stamp);
	
	out(out_str);
	out.ui();
	out.ui("****************");
	out.ui(out_str);
	out.inc_tab();
	
	---------------------------------------
	-- Lock ui overrides
	---------------------------------------
	
	--[[
	for override_name, override in pairs(self.override_list) do
		override:lock(false, true, true);
	end;
	]]
	self:override("end_turn"):lock(false, true, true);
	self:override("giving_orders"):lock(false, true, true);
	self:override("events_rollout"):lock(false, true, true);
	
	out.dec_tab();
	out.ui("ending lock_ui() output, stamp " .. tostring(stamp));
	out.ui("****************");
end;


--- @function unlock_ui
--- @desc Attempts to unlock the ui after it has been locked with @campaign_ui_manager:lock_ui. Each call to @campaign_ui_manager:lock_ui increases the lock level on the ui while each call to this function reduces the lock level. The ui is only unlocked when the lock level returns to zero.
function campaign_ui_manager:unlock_ui()

	-- decrement ui_lock_level if it's greater than 0, and only unlock if it was 1 (and is hence now 0)
	local should_unlock = false;
	
	if self.ui_lock_level == 1 then
		should_unlock = true;
	end;
	
	if self.ui_lock_level > 0 then
		self.ui_lock_level = self.ui_lock_level - 1;
	end;
	
	-- script_error("unlock_ui() called, ui_lock_level is now " .. self.ui_lock_level .. ", should_unlock is " .. tostring(should_unlock));
	
	if not should_unlock then
		return;
	end;
	
	self.ui_locked = false;
	
	local cm = self.cm;
	
	local stamp = self:get_next_output_stamp();
	
	local out_str = "unlock_ui() called, output stamp is " .. tostring(stamp);
	
	out(out_str);
	out.ui();
	out.ui("****************");
	out.ui(out_str);
	out.inc_tab();
	
	---------------------------------------
	-- Unlock ui overrides
	---------------------------------------
	--[[
	for override_name, override in pairs(self.override_list) do
		override:unlock(false, true);
	end;
	]]
	
	self:override("end_turn"):unlock(false, true);
	self:override("giving_orders"):unlock(false, true);
	self:override("events_rollout"):unlock(false, true);
	
	out.dec_tab();
	out.ui("ending unlock_ui() output, stamp " .. tostring(stamp));
	out.ui("****************");
end;










----------------------------------------------------------------------------
--- @section Auto-Opening Event Panel
----------------------------------------------------------------------------


--- @function enable_event_panel_auto_open
--- @desc Enables or disables the event panel from auto-opening. Each call to disable the event panel auto-opening made with this function increases the lock level by one, and each call to enable it decreases the lock level by one. Auto-opening is only re-enabled when the lock level drops to zero. This allows multiple client scripts to suppress event panels at the same time, and only when all have relinquished their lock will event panels be allowed to auto-open again.
--- @p boolean should enable
function campaign_ui_manager:enable_event_panel_auto_open(value)
	if value then
		-- only unlock if the lock_level hits 0
		local should_unlock = false;
		
		if self.event_panel_auto_open_lock_level == 1 then
			should_unlock = true;
		end;
		
		if self.event_panel_auto_open_lock_level > 0 then
			self.event_panel_auto_open_lock_level = self.event_panel_auto_open_lock_level - 1;
		end;
		
		if not should_unlock then
			return;
		end;

		out(">> enable_event_panel_auto_open() allowing event panels");
	
		self.cm:override_ui("disable_event_panel_auto_open", false);
	else
		self.event_panel_auto_open_lock_level = self.event_panel_auto_open_lock_level + 1;
	
		if self.event_panel_auto_open_lock_level > 1 then
			return;
		end;
		
		out(">> enable_event_panel_auto_open() preventing event panels");
		
		self.cm:override_ui("disable_event_panel_auto_open", true);
	end;
end;











----------------------------------------------------------------------------
--- @section UI Overrides
----------------------------------------------------------------------------


--- @function set_should_save_override_state
--- @desc Sets the campaign ui manager to save and restore the state of all ui overrides when the game is saved and reloaded. By default the state of these is saved - use this function to disable this.
--- @p boolean should save
function campaign_ui_manager:set_should_save_override_state(value)
	if value == false then
		self.should_save_override_state = false;
	else
		self.should_save_override_state = true;
	end;
end;


--	set_all_overrides()
--	During campaign startup it's common to set the
--	state of ui overrides before the UI is created.
--	Attempting to manipulate UI objects at this time
--	would cause a crash, so if the UI is not ready
--	the ui overrides instead defer their manipulations 
--	until set_all_overrides() is called.
function campaign_ui_manager:set_all_overrides()
	local stamp = self:get_next_output_stamp();
	local out_str = "set_all_overrides() called, output stamp is " .. tostring(stamp);
	
	out(out_str);
	out.ui();
	out.ui("****************");
	out.ui(out_str);
	out.inc_tab();

	for override_name, override in pairs(self.override_list) do
		if override:get_allowed() then
			override:unlock(true, true);
		else
			override:lock(true);
		end;
	end;
	
	out.dec_tab();
	out.ui("ending set_all_overrides() output, stamp " .. tostring(stamp));
	out.ui("****************");
end;


--	save_override_state()
--	To be called on game save. Saves the state of
--	disallowed ui overrides into the savegame.
function campaign_ui_manager:save_override_state(context)	
	local save_str = "";
	
	if self.should_save_override_state then
		for override_name, override in pairs(self.override_list) do		
			if not override:get_allowed() then
				save_str = save_str .. override.name .. ";";
			end;
		end;
	end;
	
	self.cm:save_named_value("campaign_ui_manager_disallowed_overrides", save_str, context);
	self.cm:set_saved_value("cuim_should_save_override_state", self.should_save_override_state);
end;


--	load_override_state()
--	To be called on game load. Loads the state of
--	disallowed ui overrides from the samegame.
function campaign_ui_manager:load_override_state(context)
	-- read in a single string from the savegame (always do this, so that it's saved into the savegame)
	local load_str = self.cm:load_named_value("campaign_ui_manager_disallowed_overrides", "", context);

	local stamp = self:get_next_output_stamp();
	local out_str = "load_override_state() called, output stamp is " .. tostring(stamp);
	
	out.savegame(out_str);
	out.ui();
	out.ui("****************");
	out.ui(out_str);
	out.inc_tab("ui");

	self.should_save_override_state = self.cm:get_saved_value("cuim_should_save_override_state");
	
	-- load the overrides if we're set to do so
	if self.should_save_override_state then
		-- pattern match the string (%w+ matches alphanumeric strings of length greater than 0)
		-- and disallow any overrides found
		for override_name in string.gmatch(load_str, "[%w_]+") do 		
			self.override_list[override_name]:set_allowed(false);
		end;
	else
		out.ui("\tshould_save_override_state is false, not loading anything");
	end;
	
	out.dec_tab("ui");
	out.ui("ending load_override_state() output, stamp " .. tostring(stamp));
	out.ui("****************");
end;
















----------------------------------------------------------------------------
--- @section Whitelists
--- @desc The whitelist system allow scripts to prevent the player from selecting any settlements, characters or both. Individual settlements or characters can then be whitelisted so that only they may be selected.
----------------------------------------------------------------------------


--	Character Whitelist System
--	This system allows the scripter to designate a whitelist of
--	characters that can be selected (other characters that are clicked
--	on are immediately deselected before any visual update is given to
--	the player). By activating the system with no characters in the 
--	whitelist, the player won't be able to select any generals/agents etc.


--	Returns the index if a character exists in our whitelist, false
--	otherwise. Mainly for internal use.
function campaign_ui_manager:find_character_selection_whitelist(cqi)
	for i = 1, #self.character_selection_whitelist do
		if self.character_selection_whitelist[i] == cqi then
			return i;
		end;
	end;
	
	return false;
end;


--- @function enable_character_selection_whitelist
--- @desc Enables the character selection whitelist so that it starts being enforced. After this function is called the player will be unable to select any characters that have not been added to the whitelist until the character whitelist system is disabled with @campaign_ui_manager:disable_character_selection_whitelist.
function campaign_ui_manager:enable_character_selection_whitelist()
	
	self:disable_character_selection_whitelist(true);
	
	out("Enabling character selection whitelist");
	
	core:add_listener(
		"character_selected_whitelist",
		"CharacterSelected",
		true,
		function(context)
			if not self:find_character_selection_whitelist(context:character():cqi()) then
				CampaignUI.ClearSelection();
			end;
		end,
		true
	);
end;


--- @function disable_character_selection_whitelist
--- @desc Disables the character selection whitelist so that it is no longer enforced. Calling this does not clear characters from the whitelist - use @campaign_ui_manager:clear_character_selection_whitelist to do this.
function campaign_ui_manager:disable_character_selection_whitelist(no_output)
	if not no_output then
		out("Disabling character selection whitelist");
	end;

	core:remove_listener("character_selected_whitelist");
end;


--- @function add_character_selection_whitelist
--- @desc Adds a character to the character whitelist by cqi. The character whitelist system must be enabled with @campaign_ui_manager:enable_character_selection_whitelist for this to have an effect.
--- @p number character cqi
function campaign_ui_manager:add_character_selection_whitelist(cqi)
	if not is_number(cqi) then
		script_error("ERROR: add_character_selection_whitelist() called but supplied cqi [" .. tostring(cqi) .. "] is not a number");
		return false;
	end;

	if self:find_character_selection_whitelist(cqi) then
		return false;
	end;
		
	out("Adding character to selection whitelist :: cqi:" .. tostring(cqi));
	
	table.insert(self.character_selection_whitelist, cqi);
end;


--- @function remove_character_selection_whitelist
--- @desc Removes a character from the character whitelist by cqi.
--- @p number character cqi
function campaign_ui_manager:remove_character_selection_whitelist(cqi)
	local entry_to_remove = self:find_character_selection_whitelist(cqi);
	
	if not entry_to_remove then
		return;
	end;
	
	out("Removing character from selection whitelist :: cqi: " .. cqi);
	
	table.remove(self.character_selection_whitelist, entry_to_remove);
end;


--- @function clear_character_selection_whitelist
--- @desc Clears all characters from the character whitelist.
function campaign_ui_manager:clear_character_selection_whitelist()
	out("Clearing character selection whitelist");
	self.character_selection_whitelist = {};
end;


--- @function add_all_characters_for_faction_selection_whitelist
--- @desc Adds all characters from the specified faction to the character selection whitelist.
--- @p string faction name
function campaign_ui_manager:add_all_characters_for_faction_selection_whitelist(faction_name)
	if not is_string(faction_name) then
		script_error("ERROR: add_all_characters_for_faction_selection_whitelist() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	local faction = cm:get_faction(faction_name);
	
	if not is_faction(faction) then
		script_error("ERROR: add_all_characters_for_faction_selection_whitelist() called but couldn't find faction with name [" .. tostring(faction_name) .. "]");
		return false;
	end;
	
	local character_list = faction:character_list();
	
	out("add_all_characters_for_faction_selection_whitelist() called for faction " .. faction_name);
	out.inc_tab();	
	for i = 0, character_list:num_items() - 1 do
		self:add_character_selection_whitelist(character_list:item_at(i):cqi());
	end;
	out.dec_tab();
end;




--	Settlement Whitelist System
--	This system allows the scripter to designate a whitelist of
--	settlements that can be selected (other settlements that are clicked
--	on are immediately deselected before any visual update is given to
--	the player). By activating the system with no settlements in the 
--	whitelist, the player won't be able to select any settlements at all.


--- @function enable_settlement_selection_whitelist
--- @desc Enables the settlement selection whitelist so that it starts being enforced. After this function is called the player will be unable to select any settlements that have not been added to the whitelist until the settlement whitelist system is disabled with @campaign_ui_manager:disable_settlement_selection_whitelist.
function campaign_ui_manager:enable_settlement_selection_whitelist()
	self:disable_settlement_selection_whitelist(true);
	
	out("Enabling settlement selection whitelist");
	
	core:add_listener(
		"settlement_selected_whitelist",
		"SettlementSelected",
		true,
		function(context)		
			local settlement_selected = "settlement:" .. context:garrison_residence():region():name();
			
			-- if we find the selected settlement in our whitelist, return before we get the chance
			-- to clear the selection
			for i = 1, #self.settlement_selection_whitelist do
				if self.settlement_selection_whitelist[i] == settlement_selected then
					return;
				end;
			end;
			
			CampaignUI.ClearSelection();
		end,
		true
	);
end;


--- @function disable_settlement_selection_whitelist
--- @desc Diables the settlement selection whitelist so that it is no longer enforced. Calling this does not clear settlements from the whitelist - use @campaign_ui_manager:clear_settlement_selection_whitelist to do this.
function campaign_ui_manager:disable_settlement_selection_whitelist(no_output)
	if not no_output then
		out("Disabling settlement selection whitelist");
	end;

	core:remove_listener("settlement_selected_whitelist");
end;


--- @function add_settlement_selection_whitelist
--- @desc Adds the specified settlement to the settlement selection whitelist. The settlement name will be in the form <code>settlement:[region_name]</code>. The settlement whitelist system must be enabled with @campaign_ui_manager:enable_settlement_selection_whitelist for this to have an effect.
--- @p string settlement name
function campaign_ui_manager:add_settlement_selection_whitelist(settlement_name)
	if not is_string(settlement_name) then
		script_error("ERROR: add_settlement_selection_whitelist() called but supplied settlement [" .. tostring(settlement_name) .. "] is not a string");
		return false;
	end;
	
	-- check we don't already have it
	for i = 1, #self.settlement_selection_whitelist do
		if self.settlement_selection_whitelist[i] == settlement_name then
			return;
		end;
	end;
	
	out("Adding settlement to selection whitelist : " .. settlement_name);
	
	table.insert(self.settlement_selection_whitelist, settlement_name);
end;


--- @function remove_settlement_selection_whitelist
--- @desc Removes the specified settlement from the settlement selection whitelist. The settlement name will be in the form <code>settlement:[region_name]</code>.
--- @p string settlement name
function campaign_ui_manager:remove_settlement_selection_whitelist(settlement_name)
	if not is_string(settlement_name) then
		script_error("ERROR: remove_settlement_selection_whitelist() called but supplied settlement [" .. tostring(settlement_name) .. "] is not a string");
		return false;
	end;
	
	for i = 1, #self.settlement_selection_whitelist do
		if self.settlement_selection_whitelist[i] == settlement_name then
			out("Removing settlement selection whitelist :: " .. settlement_name);
			table.remove(self.settlement_selection_whitelist, i);
			return;
		end;
	end;
end;


--- @function clear_settlement_selection_whitelist
--- @desc Clears the settlement selection whitelist.
function campaign_ui_manager:clear_settlement_selection_whitelist()
	out("Clearing settlement selection whitelist");
	
	self.settlement_selection_whitelist = {};
end;


--- @function add_all_settlements_for_faction_selection_whitelist
--- @desc Adds all settlements belonging to the specified faction to the settlement whitelist.
--- @p string faction name
function campaign_ui_manager:add_all_settlements_for_faction_selection_whitelist(faction_name)
	if not is_string(faction_name) then
		script_error("ERROR: add_all_settlements_for_faction_selection_whitelist() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	local faction = cm:get_faction(faction_name);
	
	if not is_faction(faction) then
		script_error("ERROR: add_all_settlements_for_faction_selection_whitelist() called but couldn't find faction with name [" .. tostring(faction_name) .. "]");
		return false;
	end;
	
	local region_list = faction:region_list();
	
	out("add_all_settlements_for_faction_selection_whitelist() called for faction " .. faction_name);
	out.inc_tab();	
	for i = 0, region_list:num_items() - 1 do
		self:add_settlement_selection_whitelist(region_list:item_at(i):settlement():key());
	end;
	out.dec_tab();
end;














----------------------------------------------------------------------------
--- @section Pulse Strength Constants
--- @desc The campaign ui manager stores pulse strength constants, which are numbers which represent how intensely a ui component of a certain size should flash in certain situations. Smaller components (i.e. buttons) should flash more intensely than larger components (i.e. panels) to attract attention to themselves.
----------------------------------------------------------------------------


--- @function get_panel_pulse_strength
--- @desc Returns the panel pulse strength constant (currently 5).
--- @r number panel pulse strength constant
function campaign_ui_manager:get_panel_pulse_strength()
	return self.panel_pulse_strength;
end;


--- @function get_button_pulse_strength
--- @desc Returns the button pulse strength constant (currently 10).
--- @r number button pulse strength constant
function campaign_ui_manager:get_button_pulse_strength()
	return self.button_pulse_strength;
end;

















----------------------------------------------------------------------------
--- @section Settlement Highlighting
----------------------------------------------------------------------------


--- @function highlight_settlement
--- @desc Places a highlight effect at the position of the supplied settlement. An offset position may optionally be set - sometimes it's better not to highlight a settlement's central position if a character is stood there as it's unclear what's being highlighted.
--- @desc A marker type can be supplied - recognised marker types are currently <code>move_to</code>, <code>select</code>, <code>pointer</code>, <code>move_to_vfx</code>, <code>select_vfx</code> (default), <code>look_at_vfx</code>, <code>objective</code>. If one of these is specified then the marker is added with the underlying <code>add_marker</code> command provided by the game interface. If no marker type is specified then a vfx is added with the <code>add_vfx</code> command instead, of type <code>advice_settlement_marker</code>.
--- @desc Any highlight added with this function can be removed later with @campaign_ui_manager:unhighlight_settlement.
--- @p string settlement name, Full settlement name. This is generally "settlement:" concatenated with the region key.
--- @p [opt=nil] string marker type, Marker type.
--- @p [opt=0] number x offset, X offset.
--- @p [opt=0] number y offset, Y offset.
--- @p [opt=0] number height offset, Height offset.
function campaign_ui_manager:highlight_settlement(settlement_name, marker_type, x_offset, y_offset, z_offset)
	if not is_string(settlement_name) then
		script_error("ERROR: highlight_settlement() called but given settlement name [" .. tostring(settlement_name) .. "] is not a string");
		return false;
	end;
	
	if not is_nil(x_offset) and not is_number(x_offset) then
		script_error("ERROR: highlight_settlement() called but given x_offset [" .. tostring(x_offset) .. "] is not a number or nil");
		return false;
	end;
	
	if not is_nil(y_offset) and not is_number(y_offset) then
		script_error("ERROR: highlight_settlement() called but given y_offset [" .. tostring(y_offset) .. "] is not a number or nil");
		return false;
	end;
	
	if not is_nil(z_offset) and not is_number(z_offset) then
		script_error("ERROR: highlight_settlement() called but given z_offset [" .. tostring(z_offset) .. "] is not a number or nil");
		return false;
	end;
	
	z_offset = z_offset or 3;
	
	-- out("highlight_settlement() called, settlement_name: " .. tostring(settlement_name));

	local cm = self.cm;
	local settlement = cm:model():world():region_manager():settlement_by_key(settlement_name);
	
	if not is_settlement(settlement) then
		script_error("ERROR: highlight_settlement() called but given settlement [" .. settlement_name .. "] could not be found");
		return false;
	end;
	
	x_offset = x_offset or 0;
	y_offset = y_offset or 0;
	
	if marker_type then
		-- if this settlement is currently highlighted then abort
		if self.highlighted_settlements_markers[settlement_name] then
			return false;
		end;
		
		if not is_string(marker_type) then
			marker_type = "select_vfx";
		end;
		
		cm:add_marker(settlement_name .. "_marker", marker_type, settlement:display_position_x() + x_offset, settlement:display_position_y() + y_offset, z_offset);
		self.highlighted_settlements_markers[settlement_name] = true;
	else
		-- if this settlement is currently highlighted then abort
		if self.highlighted_settlements_vfx[settlement_name] then
			return false;
		end;
		
		cm:add_vfx(settlement_name .. "_marker", "advice_settlement_marker", settlement:display_position_x() + x_offset, settlement:display_position_y() + y_offset, z_offset);
		self.highlighted_settlements_vfx[settlement_name] = true;
	end;
	
	return true;
end;


--- @function unhighlight_settlement
--- @desc Removes a highlight effect at the position of the supplied settlement that was previously added with @campaign_ui_manager:highlight_settlement.
--- @p string settlement name, Full settlement name. This is generally "settlement:" concatenated with the region key.
--- @p [opt=false] boolean is marker, Is marker. If set to <code>true</code> this removes a marker at the settlement - set this if a marker type was specified to @campaign_ui_manager:highlight_settlement. If set to <code>false</code> then a vfx is removed - set this if no marker type was specified to @campaign_ui_manager:highlight_settlement.
function campaign_ui_manager:unhighlight_settlement(settlement_name, is_marker)
	if not is_string(settlement_name) then
		script_error("ERROR: unhighlight_settlement() called but given settlement name [" .. tostring(settlement_name) .. "] is not a string.");
		return false;
	end;
	
	if is_marker then
		-- unhighlight this settlement if it's currently highlighted
		if self.highlighted_settlements_markers[settlement_name] then
			self.cm:remove_marker(settlement_name .. "_marker");
			self.highlighted_settlements_markers[settlement_name] = false;
			return true;
		end;
	else
		-- unhighlight this settlement if it's currently highlighted
		if self.highlighted_settlements_vfx[settlement_name] then
			self.cm:remove_vfx(settlement_name .. "_marker");
			self.highlighted_settlements_vfx[settlement_name] = false;
			return true;
		end;
	end;
end;


--- @function highlight_all_settlements_for_faction
--- @desc A shorthand method for highlighting or unhighlighting all settlements belonging to a specified faction. This function uses @campaign_ui_manager:highlight_settlement and @campaign_ui_manager:unhighlight_settlement to perform the actual highlighting and unhighlighting.
--- @p string faction key, Faction key.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] string marker type, Marker type to be supplied to @campaign_ui_manager:highlight_settlement or @campaign_ui_manager:unhighlight_settlement - see the documentation for those functions for more information.
function campaign_ui_manager:highlight_all_settlements_for_faction(faction_name, value, marker_type)
	if not is_string(faction_name) then
		script_error("ERROR: highlight_all_settlements_for_faction() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return;
	end;

	local faction = cm:get_faction(faction_name);
	
	if not is_faction(faction) then
		script_error("ERROR: highlight_all_settlements_for_faction() called but couldn't find a faction called [" .. tostring(faction_name) .. "]");
		return;
	end;
	
	local region_list = faction:region_list();
	
	local process_func = false;
	
	if value then
		process_func = function(settlement_name) self:highlight_settlement(settlement_name, marker_type) end;
	else
		process_func = function(settlement_name) self:unhighlight_settlement(settlement_name, marker_type) end;
	end;
	
	for i = 0, region_list:num_items() - 1 do
		local curr_region = region_list:item_at(i);
		process_func(curr_region:settlement():key());
	end;
end;


--- @function highlight_all_settlements_near_camera
--- @desc A shorthand method for highlighting or unhighlighting all settlements currently near the position of the camera. An optional condition may be supplied to filter the settlements to highlight.
--- @desc Note that the highlighting won't update if the camera is moved.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p number radius, Radius in display units.
--- @p [opt=nil] function condition, Filter condition. If supplied, this should be a function which accepts a settlement object as a single argument and returns a boolean result. If the boolean result evaluates to <code>true</code> then the settlement is highlighted. The filter is only considered when highlighting - when unhighlighting, all settlements within the radius are unhighlighted regardless of any filter.
function campaign_ui_manager:highlight_all_settlements_near_camera(value, radius, condition)
	radius = radius or 30;

	if not is_number(radius) then
		script_error("highlight_all_settlements_near_camera() called but supplied radius [" .. tostring(radius) .. "] is not a number");
		return false;
	end;

	local cm = self.cm;
	
	if value then	
		local radius_squared = radius * radius;
		local cam_x, cam_y, cam_d, cam_b, cam_h = cm:get_camera_position();
		local region_list = cm:model():world():region_manager():region_list();
	
		for i = 0, region_list:num_items() - 1 do
			local curr_region = region_list:item_at(i);
			local curr_settlement = curr_region:settlement();
			
			if not is_function(condition) or condition(curr_settlement) then
				local distance_to_settlement_squared = distance_squared(curr_settlement:display_position_x(), curr_settlement:display_position_y(), cam_x, cam_y);
				
				if distance_to_settlement_squared < radius_squared then					
					-- only highlight if this settlement is visible to the local alliance
					local character = cm:get_garrison_commander_of_region(curr_region);
					
					if character and character:is_visible_to_faction(cm:get_local_faction_name(true)) then					
						local curr_settlement_name = curr_region:settlement():key();

						self:highlight_settlement(curr_settlement_name, false);
						table.insert(self.highlighted_settlements_near_camera, curr_settlement_name);
					end;
				end;
			end;
		end;
	else
		for i = 1, #self.highlighted_settlements_near_camera do
			self:unhighlight_settlement(self.highlighted_settlements_near_camera[i]);
		end;
		
		self.highlighted_settlements_near_camera = {};
	end;
end;


--- @function highlight_settlement_for_selection
--- @desc Highlights a settlement, and then calls a supplied callback when that character is selected. This function uses @campaign_ui_manager:highlight_settlement to perform the actual highlighting.
--- @p string settlement name, Full settlement name. This is generally "settlement:" concatenated with the region key.
--- @p string province name, Province name to which the settlement belongs.
--- @p function callback
--- @p [opt=0] number x offset, X offset.
--- @p [opt=0] number y offset, Y offset.
function campaign_ui_manager:highlight_settlement_for_selection(settlement_name, province_name, callback, x_offset, y_offset)
	if not is_string(settlement_name) then
		script_error("ERROR: highlight_settlement_for_selection() called but supplied settlement name [" .. tostring(settlement_name) .. "] is not a string");
		return false;
	end;
	
	if province_name and not is_string(province_name) then
		script_error("ERROR: highlight_settlement_for_selection() called but supplied province_name name [" .. tostring(province_name) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_function(callback) then
		script_error("ERROR: highlight_settlement_for_selection() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	self:highlight_settlement(settlement_name, true, x_offset, y_offset);
	
	core:add_listener(
		"highlight_settlement_for_selection:" .. settlement_name,
		"SettlementSelected",
		function(context)
			local selected_settlement = context:garrison_residence():settlement_interface():key();
			
			-- if the player selects a settlement in the same province that opens the same screen, so it counts as selecting the intended settlement
			if settlement_name == selected_settlement or (province_name and string.find(selected_settlement, province_name)) then
				return true;
			end;
			return false;
		end,
		function()
			self:unhighlight_settlement(settlement_name, true);
			callback();
		end,
		false
	);
end;


--- @function unhighlight_settlement_for_selection
--- @desc Unhighlights a settlement after it has been highlighted with @campaign_ui_manager:highlight_settlement_for_selection. Note that client scripts do not need to call this themselves to clean up after @campaign_ui_manager:highlight_settlement_for_selection has triggered - it is for cancelling a running selection listener.
--- @p character character object
function campaign_ui_manager:unhighlight_settlement_for_selection(settlement_name)
	if not is_string(settlement_name) then
		script_error("ERROR: highlight_settlement_for_selection() called but supplied settlement name [" .. tostring(settlement_name) .. "] is not a string");
		return false;
	end;
	
	self:unhighlight_settlement(settlement_name, true);
	
	core:remove_listener("highlight_settlement_for_selection:" .. settlement_name);
end;















----------------------------------------------------------------------------
--- @section Character Highlighting
----------------------------------------------------------------------------


--- @function highlight_character
--- @desc Places a highlight effect at the position of the supplied character. A marker type can be supplied - recognised marker types are currently <code>move_to</code>, <code>select</code>, <code>pointer</code>, <code>move_to_vfx</code>, <code>select_vfx</code> (default), <code>look_at_vfx</code>, <code>objective</code>. If one of these is specified then the marker is added with the underlying <code>add_marker</code> command provided by the game interface. If no marker type is specified then a vfx is added with the <code>add_vfx</code> command instead, of type <code>advice_settlement_marker</code>.
--- @desc Any highlight added with this function can be removed later with @campaign_ui_manager:unhighlight_character.
--- @p character character object
--- @p [opt=nil] string marker type
--- @p [opt=0] number height offset
--- @r boolean character was highlighted
function campaign_ui_manager:highlight_character(character_ref, marker_type, altitude)

	local character = false;

	if is_character(character_ref) then
		character = character_ref;
	elseif not is_string(character_ref) and not is_number(character_ref) then
		script_error("ERROR: highlight_character() called but supplied character reference [" .. tostring(character_ref) .. "] is not a character object or a string/number cqi");
		return false;
	else
		character = cm:get_character_by_cqi(character_ref)
		
		if not character then
			script_error("ERROR: highlight_character() called but no character with supplied cqi [" .. tostring(character_ref) .. "] could be found");
			return false;
		end;
	end;
	
	local marker_name = cm:char_lookup_str(character);
	
	altitude = altitude or 0;
	
	if marker_type then
		-- if this character is currently highlighted then abort
		if self.highlighted_characters_markers[marker_name] then
			return false;
		end;
		
		if not is_string(marker_type) then
			marker_type = "select_vfx";
		end;
		
		self.cm:add_marker(marker_name, marker_type, character:display_position_x(), character:display_position_y(), altitude);
		
		self.highlighted_characters_markers[marker_name] = true;
	else
		-- if this character is currently highlighted then abort
		if self.highlighted_characters_vfx[marker_name] then
			return false;
		end;
			
		self.cm:add_vfx(marker_name, "advice_character_marker", character:display_position_x(), character:display_position_y(), altitude);
				
		self.highlighted_characters_vfx[marker_name] = true;
	end;	
	
	return true;
end;


--- @function unhighlight_character
--- @desc Removes a highlight effect at the position of the supplied character that was previously added with @campaign_ui_manager:highlight_character.
--- @p character character object, Character object.
--- @p [opt=false] boolean is marker, Is marker. If set to <code>true</code> this removes a marker at the character - set this if a marker type was specified to @campaign_ui_manager:highlight_character. If set to <code>false</code> then a vfx is removed - set this if no marker type was specified to @campaign_ui_manager:highlight_character.
--- @r boolean character was unhighlighted
function campaign_ui_manager:unhighlight_character(character_ref, use_marker)
	local marker_name = cm:char_lookup_str(character_ref);

	if use_marker then
		if self.highlighted_characters_markers[marker_name] then
			self.cm:remove_marker(marker_name);
			self.highlighted_characters_markers[marker_name] = false;
			return true;
		end;
	else
		if self.highlighted_characters_vfx[marker_name] then
			self.cm:remove_vfx(marker_name);
			self.highlighted_characters_vfx[marker_name] = false;
			return true;
		end;
	end;
	
	return false;
end;


--- @function highlight_all_general_characters_for_faction
--- @desc A shorthand method for highlighting/unhighlight all armies for a faction.
--- @p string faction key
--- @p [opt=false] boolean should highlight
function campaign_ui_manager:highlight_all_general_characters_for_faction(faction_name, value)
	if not is_string(faction_name) then
		script_error("ERROR: highlight_all_general_characters_for_faction() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return;
	end;

	local faction = cm:get_faction(faction_name);
	
	if not is_faction(faction) then
		script_error("ERROR: highlight_all_general_characters_for_faction() called but couldn't find a faction called [" .. tostring(faction_name) .. "]");
		return;
	end;
		
	local military_force_list = faction:military_force_list();
	
	local process_func = false;
	
	if value then
		process_func = function(char) self:highlight_character(char) end;
	else
		process_func = function(char) self:unhighlight_character(char) end;
	end;
	
	for i = 0, military_force_list:num_items() - 1 do
		local military_force = military_force_list:item_at(i);
		
		if military_force:has_general() and not military_force:is_armed_citizenry() then
			process_func(military_force:general_character());
		end;
	end;
end;


--- @function highlight_all_characters_near_camera
--- @desc A shorthand method for highlighting or unhighlighting all characters currently near the position of the camera. An optional condition may be supplied to filter the characters to highlight.
--- @desc Note that the highlighting won't update if the camera is moved.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p number radius, Radius in display units.
--- @p [opt=nil] function condition, Filter condition. If supplied, this should be a function which accepts a character object as a single argument and returns a boolean result. If the boolean result evaluates to <code>true</code> then the character is highlighted. The filter is only considered when highlighting - when unhighlighting, all characters within the radius are unhighlighted regardless of any filter.
function campaign_ui_manager:highlight_all_characters_near_camera(value, radius, condition)
	local cm = self.cm;
	
	if value then
		local faction_list = cm:model():world():faction_list();
		local cam_x, cam_y, cam_d, cam_b, cam_h = cm:get_camera_position();
		local radius_squared = radius * radius;
		
		for i = 0, faction_list:num_items() - 1 do
			local char_list = faction_list:item_at(i):character_list();
			
			for j = 0, char_list:num_items() - 1 do
				local character = char_list:item_at(j);
				
				if distance_squared(character:display_position_x(), character:display_position_y(), math.max(0, cam_x), math.max(0, cam_y)) < radius_squared and character:is_visible_to_faction(cm:get_local_faction_name(true)) then
					if not is_function(condition) or condition(character) then
				
						table.insert(
							self.highlighted_characters_near_camera, 
							{
								["faction_name"] = character:faction():name(), 
								["cqi"] = character:cqi()
							}
						);
						self:highlight_character(character);
					end;
				end;
			end;
		end;
		
	else
		for i = 1, #self.highlighted_characters_near_camera do
			local current_record = self.highlighted_characters_near_camera[i];
			local character = cm:get_character_by_cqi(current_record.cqi);
			
			if character then
				self:unhighlight_character(character);
			end;
		end;
		self.highlighted_characters_near_camera = {};
	end;
end;


--- @function highlight_all_generals_near_camera
--- @desc A shorthand method for highlighting or unhighlighting all general/lord characters currently near the position of the camera. Uses @campaign_ui_manager:highlight_all_characters_near_camera.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p number radius, Radius in display units.
--- @p [opt=nil] function condition, Filter condition. If supplied, this should be a function which accepts a character object as a single argument and returns a boolean result. If the boolean result evaluates to <code>true</code> then the character is highlighted. The filter is only considered when highlighting - when unhighlighting, all characters within the radius are unhighlighted regardless of any filter.
function campaign_ui_manager:highlight_all_generals_near_camera(value, radius, condition)
	local my_condition = false;
	
	if not condition then
		my_condition = function(character) return cm:char_is_mobile_general_with_army(character) end;
	else
		my_condition = function(character) return cm:char_is_mobile_general_with_army(character) and condition(character) end;
	end;
	
	return self:highlight_all_characters_near_camera(value, radius, my_condition);
end;


--- @function highlight_all_heroes_near_camera
--- @desc A shorthand method for highlighting or unhighlighting all hero characters currently near the position of the camera. Uses @campaign_ui_manager:highlight_all_characters_near_camera.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p number radius, Radius in display units.
--- @p [opt=nil] function condition, Filter condition. If supplied, this should be a function which accepts a character object as a single argument and returns a boolean result. If the boolean result evaluates to <code>true</code> then the character is highlighted. The filter is only considered when highlighting - when unhighlighting, all characters within the radius are unhighlighted regardless of any filter.
function campaign_ui_manager:highlight_all_heroes_near_camera(value, radius, condition)
	local my_condition = false;
	
	if not condition then
		my_condition = function(character) return cm:char_is_agent(character) end;
	else
		my_condition = function(character) return cm:char_is_agent(character) and condition(character) end;
	end;
	
	return self:highlight_all_characters_near_camera(value, radius, my_condition);
end;


--- @function highlight_character_for_selection
--- @desc Highlights a character, and then calls a supplied callback when that character is selected. This function uses @campaign_ui_manager:highlight_character to perform the actual highlighting.
--- @p character character object
--- @p function callback
--- @p [opt=0] number height offset
function campaign_ui_manager:highlight_character_for_selection(character_ref, callback, altitude)

	local char_cqi = false;
	
	if is_string(character_ref) or is_number(character_ref) then
		char_cqi = character_ref;
	elseif is_character(character_ref) then
		char_cqi = character_ref:cqi();
	else
		script_error("ERROR: highlight_character_for_selection() called but supplied character reference [" .. tostring(character_ref) .. "] is not a character object, or a string or number cqi");
		return false;
	end;
	
	if not is_function(callback) then
		script_error("ERROR: highlight_character_for_selection() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	altitude = altitude or 0;
	
	if not is_number(altitude) then
		script_error("ERROR: highlight_character_for_selection() called but supplied altitude [" .. tostring(altitude) .. "] is not a number");
		return false;
	end;
			
	self:highlight_character(char_cqi, true, altitude);
	
	core:add_listener(
		"highlight_character_for_selection:" .. char_cqi,
		"CharacterSelected",
		function(context) return context:character():cqi() == char_cqi end,
		function()
			self:unhighlight_character(cm:get_character_by_cqi(char_cqi), true, altitude);
			callback();
		end,
		false
	);
end;


--- @function unhighlight_character_for_selection
--- @desc Unhighlights a character after it has been highlighted with @campaign_ui_manager:highlight_character_for_selection. Note that client scripts do not need to call this themselves to clean up after @campaign_ui_manager:highlight_character_for_selection has triggered - it is for cancelling a running selection listener.
--- @p character character object
function campaign_ui_manager:unhighlight_character_for_selection(character)
	if not is_character(character) then
		script_error("ERROR: unhighlight_character_for_selection() called but supplied character [" .. tostring(character) .. "] is not a character");
		return false;
	end;

	local char_cqi = character:cqi();
	
	self:unhighlight_character(character, true);
	
	core:remove_listener("highlight_character_for_selection:" .. char_cqi);
end;
















----------------------------------------------------------------------------
--- @section Tutorial-Specific UI Hiding
--- @desc The functions here are bespoke for tutorials and hide or show various bits of the UI.
----------------------------------------------------------------------------


--- @function display_first_turn_ui
--- @desc Hides or shows a large amount of the campaign UI.
--- @p boolean show ui
function campaign_ui_manager:display_first_turn_ui(value)	
	local cm = self.cm;
	local local_faction = cm:get_local_faction_name(true);
	
	self:override("events_panel"):set_allowed(value);
	self:override("events_rollout"):set_allowed(value);
	self:override("saving"):set_allowed(value);
	--self:override("missions"):set_allowed(value);
	--self:override("technology"):set_allowed(value);
	--self:override("rituals"):set_allowed(value);
	self:override("finance"):set_allowed(value);
	--self:override("diplomacy"):set_allowed(value);
	self:override("faction_button"):set_allowed(value);
	self:override("recruit_units"):set_allowed(value);
	self:override("cancel_recruitment"):set_allowed(value);
	self:override("dismantle_building"):set_allowed(value);
	self:override("repair_building"):set_allowed(value);
	self:override("cancel_construction"):set_allowed(value);
	self:override("building_upgrades"):set_allowed(value);
	self:override("non_city_building_upgrades"):set_allowed(value);
	self:override("enlist_agent"):set_allowed(value);
	self:override("raise_army"):set_allowed(value);
	self:override("recruit_mercenaries"):set_allowed(value);
	self:override("stances"):set_allowed(value);
	self:override("book_of_grudges"):set_allowed(value);
	--self:override("offices"):set_allowed(value);
	self:override("tax_exemption"):set_allowed(value);
	self:override("end_turn"):set_allowed(value);
	self:override("building_browser"):set_allowed(value);
	self:override("diplomacy_double_click"):set_allowed(value);
	self:override("tactical_map"):set_allowed(value);
	self:override("character_details"):set_allowed(value);
	self:override("disband_unit"):set_allowed(value);
	self:override("ping_clicks"):set_allowed(value);
	self:override("settlement_renaming"):set_allowed(value);
	self:override("autoresolve"):set_allowed(value);
	self:override("retreat"):set_allowed(value);
	self:override("advice_settings_button"):set_allowed(value);
	self:override("spell_browser"):set_allowed(value);
	self:override("camera_settings"):set_allowed(value);
	self:override("army_panel_help_button"):set_allowed(value);
	self:override("pre_battle_panel_help_button"):set_allowed(value);
	self:override("province_overview_panel_help_button"):set_allowed(value);
	self:override("intrigue_at_the_court"):set_allowed(value);
	self:override("slaves"):set_allowed(value);
	self:override("geomantic_web"):set_allowed(value);
	self:override("garrison_details"):set_allowed(value);
	self:override("end_turn_options"):set_allowed(value);
	self:override("skaven_corruption"):set_allowed(value);
	self:override("regiments_of_renown"):set_allowed(value);
	self:override("sword_of_khaine"):set_allowed(value);
	
	cm:enable_ui_hiding(value);
	
	local should_suppress = not value;
	
	-- ensure info panel is shown over the top of advice..
	local uic_info_panel_holder = find_uicomponent(core:get_ui_root(), "info_panel_holder");
	if uic_info_panel_holder then
		if value then
			uic_info_panel_holder:RemoveTopMost();
		else
			uic_info_panel_holder:RegisterTopMost();
		end;
	end;
	
	-- ..but prevent it from being pinned
	cm:override_ui("disable_info_panel_pinning", should_suppress);
	
	self:suppress_end_turn_warning("bankrupt", should_suppress);
	self:suppress_end_turn_warning("tech", should_suppress);
	self:suppress_end_turn_warning("edict", should_suppress);
	self:suppress_end_turn_warning("character", should_suppress);
	self:suppress_end_turn_warning("army_ap", should_suppress);
	self:suppress_end_turn_warning("office", should_suppress);
	self:suppress_end_turn_warning("siege", should_suppress);
	self:suppress_end_turn_warning("army_morale", should_suppress);
	
	cm:enable_all_diplomacy(value);
	
	self:display_faction_buttons(value);
	self:display_resources_bar(value);
	
	if value then
		-- unlocking
		play_component_animation("show", "resources_bar");
		play_component_animation("show", "bar_small_top");
		play_component_animation("show", "radar_things");
		
		self:disable_character_selection_whitelist();
		self:disable_settlement_selection_whitelist();
		
		cm:enable_movement_for_faction(local_faction);
	else
		-- locking		
		--play_component_animation("hide", "bar_small_top");
		--play_component_animation("hide", "radar_things");
		
		self:enable_character_selection_whitelist();
		self:enable_settlement_selection_whitelist();
		
		if cm:get_faction(local_faction) then
			cm:disable_movement_for_faction(local_faction);
		end;
	end;
end;


--- @function display_faction_buttons
--- @desc Hides or shows the faction buttons docker on the campaign UI, which is the panel on which the end-turn button is displayed.
--- @p boolean should show
function campaign_ui_manager:display_faction_buttons(value)
	if value == false then
		if self.faction_buttons_displayed then
			self.faction_buttons_displayed = false;
			play_component_animation("hide", "faction_buttons_docker");
		end;
	else
		if not self.faction_buttons_displayed then
			self.faction_buttons_displayed = true;
			play_component_animation("show", "faction_buttons_docker");
		end;
	end;
end;


--- @function display_resources_bar
--- @desc Hides or shows the resources bar at the top of the campaign UI.
--- @p boolean should show
function campaign_ui_manager:display_resources_bar(value)
	if value == false then
		if self.resources_bar_displayed then
			self.resources_bar_displayed = false;
			play_component_animation("hide", "resources_bar");
		end;
	else
		if not self.resources_button_displayed then
			self.resources_button_displayed = true;
			play_component_animation("show", "resources_bar");
		end;
	end;
end;











----------------------------------------------------------------------------
--- @section Unit Cards
----------------------------------------------------------------------------


--- @function num_queued_unit_cards_visible
--- @desc Returns the number of unit cards currently queued for recruitment on the army panel.
--- @r number queued unit cards
function campaign_ui_manager:num_queued_unit_cards_visible()
	local uic_units = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "units");
	
	local count = 0;
	
	if not uic_units then
		return 0;
	end;
	
	for i = 0, uic_units:ChildCount() - 1 do
		local uic_child = UIComponent(uic_units:Find(i));
		
		if string.sub(uic_child:Id(), 1, 14) == "QueuedLandUnit" then
			count = count + 1;
		end;
	end;
	
	return count;
end;













----------------------------------------------------------------------------
--- @section Interaction Monitor
--- @desc An interaction monitor sets up an event/condition listener. Should the event occur and the condition be satisfied then a supplied key is saved into the advice history. The presence of this key in the advice history can then be queried by external scripts with @campaign_ui_manager:get_interaction_monitor_state.
--- @desc This mechanism allows client scripts to set up listeners for the player ever performing an action (e.g. changing stance, recruiting a unit, declaring war etc). Other scripts can then query whether or not the player has performed one of these actions at any point.
----------------------------------------------------------------------------


--- @function add_interaction_monitor
--- @desc Sets up an interaction monitor. If the supplied key is not already present in the advice history then a listener is established for the supplied event and condition. Should the event be triggered and the condition met, then the key is set in the advice history.
--- @p string key, Interaction monitor key.
--- @p string event name, Event name to listen for.
--- @p [opt=true] function condition, Conditional test. This can either be a function that takes the event context as a single arguments and returns a boolean result, or just the value <code>true</code> to always match when the event is triggered (which is the default value).
function campaign_ui_manager:add_interaction_monitor(key, event_name, test)
	if not is_string(key) then
		script_error("ERROR: add_interaction_monitor() called but supplied key [" .. tostring(key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(event_name) then
		script_error("ERROR: add_interaction_monitor() called but supplied event name [" .. tostring(event_name) .. "] is not a string");
		return false;
	end;
	
	test = test or true;
	
	if not is_function(test) and test ~= true then
		script_error("ERROR: add_interaction_monitor() called but supplied callback [" .. tostring(test) .. "] is not a function, true or nil");
		return false;
	end;
	
	-- if we have already seen this interaction then don't bother starting the monitor
	if common.get_advice_history_string_seen(key) then
		return;
	end;
	
	core:add_listener(
		"interaction_monitor_" .. key,
		event_name,
		test,
		function() common.set_advice_history_string_seen(key) end,
		false
	);
end;


--- @function add_click_interaction_monitor
--- @desc Sets up an on-click interaction monitor. This sets up an interaction monitor with @campaign_ui_manager:add_interaction_monitor for the <code>ComponentLClickUp</code> event.
--- @p string key, Interaction monitor key.
--- @p [opt=true] function condition, Conditional test. This can either be a function that takes the event context as a single arguments and returns a boolean result, or just the value <code>true</code> to always match when the event is triggered (which is the default value).
function campaign_ui_manager:add_click_interaction_monitor(key, component_name)
	self:add_interaction_monitor(key, "ComponentLClickUp", function(context) return context.string == component_name end);
end;


--- @function add_campaign_panel_closed_interaction_monitor
--- @desc Sets up a panel-closing interaction monitor. This sets up an interaction monitor with @campaign_ui_manager:add_interaction_monitor for the <code>PanelClosedCampaign</code> event.
--- @p string key, Interaction monitor key.
--- @p [opt=true] function condition, Conditional test. This can either be a function that takes the event context as a single arguments and returns a boolean result, or just the value <code>true</code> to always match when the event is triggered (which is the default value).
function campaign_ui_manager:add_campaign_panel_closed_interaction_monitor(key, panel_name)
	self:add_interaction_monitor(key, "PanelClosedCampaign", function(context) return context.string == panel_name end);
end;


--- @function get_interaction_monitor_state
--- @desc Gets the state of a supplied interaction monitor. If the monitor has ever been triggered then <code>true</code> is returned, otherwise <code>false</code> is returned instead.
--- @p string key, Interaction monitor key.
--- @r boolean monitor ever triggered
function campaign_ui_manager:get_interaction_monitor_state(key)
	return common.get_advice_history_string_seen(key);
end;








----------------------------------------------------------------------------
--- @section Diplomacy Audio Locking
--- @desc Multiple independent client scripts wish to lock and unlock the diplomacy_audio override at the same time, so the campaign ui manager provides this specific interface for doing so. Each call to @campaign_ui_manager:lock_diplomacy_audio increases the lock level, whereas each call to @campaign_ui_manager:unlock_diplomacy_audio decreases it. The ui override itself only gets locked/unlocked when the lock level moves from 0 to 1 or 1 to 0.
----------------------------------------------------------------------------


--- @function lock_diplomacy_audio
--- @desc Increases the lock level on the <code>diplomacy_audio</code> ui override, locking it if the level is moving from 0 to 1.
function campaign_ui_manager:lock_diplomacy_audio()
	self.diplomacy_audio_lock_level = self.diplomacy_audio_lock_level + 1;
	
	if self.diplomacy_audio_lock_level == 1 then
		self:override("diplomacy_audio"):lock();
	end;
end;


--- @function unlock_diplomacy_audio
--- @desc Decreases the lock level on the <code>diplomacy_audio</code> ui override, unlocking it if the level is moving from 1 to 0.
function campaign_ui_manager:unlock_diplomacy_audio()
	self.diplomacy_audio_lock_level = self.diplomacy_audio_lock_level - 1;
	
	if self.diplomacy_audio_lock_level == 0 then
		self:override("diplomacy_audio"):unlock();
	end;
end;













----------------------------------------------------------------------------
--- @section Specific Component/Tooltip Pulse Highlighting
--- @desc The campaign ui manager provides a large number of functions, listed below, to pulse-highlight various specific sections of the campaign UI. Client scripts may call one or more of the functions listed below to highlight a section of the ui, then @campaign_ui_manager:unhighlight_all_for_tooltips to subsequently unhighlight any ui section currently highlighted by them. This is primarily for use with the tooltip/help system, which pulse-highlights sections of the UI when the cursor is placed over a relevant hyperlinked word in help system text.
--- @desc The <code>help_page_link_highlighting</code> ui override may be set to disable this system, although each highlighting function allows the action to be forced using a flag.
--- @desc Where sensible, each highlight function will call a different highlight function if its uicomponents are not visible. For example, a call to highlight the army panel will highlight armies instead if the army panel is not visible - hopefully communicating to the player that they can select an army to see the panel.
----------------------------------------------------------------------------


--- @function unhighlight_all_for_tooltips
--- @desc Unhighlights any component that's been highlighted by the tooltip system using one of the other functions in this section.
--- @p [opt=false] boolean force unhighlight, Force unhighlight, even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:unhighlight_all_for_tooltips(force_unhighlight)
	if not self.help_page_link_highlighting_permitted and not force_unhighlight then
		return;
	end;

	local unhighlight_action_list = self.unhighlight_action_list;
	
	for i = 1, #unhighlight_action_list do
		unhighlight_action_list[i]();
	end;
	
	self.unhighlight_action_list = {};
end;


--- @function pulse_and_unpulse_uicomponent
--- @desc Pulse a uicomponent, caching shader values at the same time. An entry to unhighlight the uicomponent and restore its shader values is automatically added to the unhighlight action list. This function can be used to set up a highlight on a uicomponent when the standard highlight/unhlight behaviour inadvertently clears active shaders on the uicomponent being highlighted. It is not generally necessary to call this function.
--- @p @uicomponent uicomponent
--- @p @number pulse strength
function campaign_ui_manager:pulse_and_unpulse_uicomponent(uic, pulse_strength)
	local a, b, c, d = uic:ShaderVarsGet();
	local shader = uic:ShaderTechniqueGet();

	pulse_uicomponent(uic, true, pulse_strength);

	table.insert(
		self.unhighlight_action_list,
		function()
			pulse_uicomponent(uic, false, pulse_strength);

			uic:ShaderTechniqueSet(shader);
			uic:ShaderVarsSet(a, b, c, d);
		end
	);
end;


--- @function highlight_advice_history_buttons
--- @desc Highlights the advice history buttons. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_advice_history_buttons(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_button_next = find_uicomponent(ui_root, "advice_interface", "button_next");
	pulse_strength = pulse_strength or self.button_pulse_strength;
	
	if uic_button_next and uic_button_next:Visible(true) and is_fully_onscreen(uic_button_next) then
		pulse_uicomponent(uic_button_next, value, pulse_strength);
		
		local uic_button_previous = find_uicomponent(ui_root, "advice_interface", "button_previous");
		
		if uic_button_previous and uic_button_previous:Visible(true) then
			pulse_uicomponent(uic_button_previous, value, pulse_strength);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_advice_history_buttons(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_advisor_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_advisor_button
--- @desc Highlights the advisor button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_advisor_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "menu_bar", "button_show_advice");
	
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
--- @desc Highlights the advisor. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_advisor(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_advice_interface = find_uicomponent(core:get_ui_root(), "advice_interface");
	
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


--- @function highlight_ancillaries
--- @desc Highlights the ancillaries on the character details panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_ancillaries(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_details_subpanel", "global_pool");
	
	if uic and uic:Visible(true) then
		local uic_header = find_uicomponent(uic, "general_ancillaries_button");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength or self.button_pulse_strength, true);
		end;

		local uic_list = find_uicomponent(uic, "global_ancillaries_listview");
		if uic_list then
			pulse_uicomponent(uic_list, value, pulse_strength or self.button_pulse_strength, true);
		end;

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_ancillaries(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_character_details_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_armies
--- @desc Highlights armies near the camera, optionally for a target faction. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] string faction key, Target faction key. Can be omitted to highlight armies for all factions.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_armies(value, target_faction, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	if value then
		if target_faction then
			self:highlight_all_generals_near_camera(true, 30, function(character) return character:faction():name() == target_faction end);
		else
			self:highlight_all_generals_near_camera(true, 30);
		end;
		table.insert(self.unhighlight_action_list, function() self:highlight_armies(false, pulse_strength, force_highlight) end);
	else
		self:highlight_all_generals_near_camera(false);
	end;
end;


--- @function highlight_armies_at_sea
--- @desc Highlights armies at sea near the camera, optionally for a target faction. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] string faction key, Target faction key. Can be omitted to highlight armies for all factions.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_armies_at_sea(value, target_faction, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	if value then
		if target_faction then
			self:highlight_all_generals_near_camera(true, 30, function(character) return character:is_at_sea() and character:faction():name() == target_faction end);
		else
			self:highlight_all_generals_near_camera(true, 30, function(character) return character:is_at_sea() end);
		end;
		table.insert(self.unhighlight_action_list, function() self:highlight_armies(false, pulse_strength, force_highlight) end);
	else
		self:highlight_all_generals_near_camera(false, pulse_strength, force_highlight);
	end;
end;


--- @function highlight_army_panel
--- @desc Highlights the army panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_army_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_panel = find_uicomponent(ui_root, "main_units_panel");
	
	if uic_panel and uic_panel:Visible(true) then
		-- if the building tab is visible and selected then highlight the army tab and exit
		local uic_tabgroup = find_uicomponent(uic_panel, "tabgroup");
		
		if uic_tabgroup then
			local uic_building_tab = find_uicomponent(uic_tabgroup, "tab_horde_buildings");
			if uic_building_tab and uic_building_tab:Visible(true) and uic_building_tab:CurrentState() == "selected" then
				local uic_army_tab = find_uicomponent(uic_tabgroup, "tab_army");
				if uic_army_tab then
					pulse_uicomponent(uic_army_tab, value, pulse_strength or self.button_pulse_strength);
					if value then
						table.insert(self.unhighlight_action_list, function() self:highlight_army_panel(false, pulse_strength, force_highlight) end);
					end;
					return true;
				end;			
			end;
		end;
	
		local panel_pulse_strength = pulse_strength or self.panel_pulse_strength;
	
		pulse_uicomponent(uic_panel, value, panel_pulse_strength);
		
		local uic_header = find_uicomponent(uic_panel, "button_focus");
		pulse_uicomponent(uic_header, value, panel_pulse_strength);
		
		local uic_cycle_left = find_uicomponent(uic_panel, "button_cycle_left");
		pulse_uicomponent(uic_cycle_left, value, panel_pulse_strength);
		
		local uic_cycle_right = find_uicomponent(uic_panel, "button_cycle_right");
		pulse_uicomponent(uic_cycle_right, value, panel_pulse_strength);
			
		if value then
			self:highlight_army_panel_unit_cards(value, pulse_strength, force_highlight, true);
			self:highlight_winds_of_magic(value, pulse_strength, force_highlight);
			table.insert(self.unhighlight_action_list, function() self:highlight_army_panel(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	else
		return self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_army_panel_unit_cards
--- @desc Highlights the unit cards on the army panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_army_panel_unit_cards(value, pulse_strength, force_highlight, do_not_highlight_upstream, highlight_unit_types, highlight_experience)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local cm = self.cm;
	local uic_parent = find_uicomponent(core:get_ui_root(), "main_units_panel", "units");
		
	if uic_parent and uic_parent:Visible(true) then
	
		for i = 0, uic_parent:ChildCount() - 1 do
			local uic_child = UIComponent(uic_parent:Find(i));
			
			-- highlight the type indicator if we're supposed to
			if highlight_unit_types then
				-- unit type
				local uic_type = find_uicomponent(uic_child, "unit_cat_frame");
				if uic_type then
					pulse_uicomponent(uic_type, value, pulse_strength or self.button_pulse_strength);
				end;
			elseif highlight_experience then
				-- experience
				local uic_experience = find_uicomponent(uic_child, "experience");
				if uic_experience then
					pulse_uicomponent(uic_experience, value, pulse_strength or self.button_pulse_strength);
				end;
			else
				-- whole card
				pulse_uicomponent(uic_child, value, pulse_strength or self.panel_pulse_strength, true);
			end;
		end;

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_army_panel_unit_cards(false, pulse_strength, force_highlight, do_not_highlight_upstream, highlight_unit_types, highlight_experience) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_army_panel(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_autoresolve_button
--- @desc Highlights the autoresolve button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_autoresolve_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_regular_deployment = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "regular_deployment");
			
	if uic_regular_deployment and uic_regular_deployment:Visible(true) then	
		local uic_standard_autoresolve = find_uicomponent(uic_regular_deployment, "button_set_attack", "button_autoresolve");
		if uic_standard_autoresolve and uic_standard_autoresolve:Visible(true) then
			pulse_uicomponent(uic_standard_autoresolve, value, pulse_strength or self.button_pulse_strength);
		else
			local uic_siege_autoresolve = find_uicomponent(uic_regular_deployment, "button_set_siege", "button_autoresolve");
			if uic_siege_autoresolve and uic_siege_autoresolve:Visible(true) then
				pulse_uicomponent(uic_siege_autoresolve, value, pulse_strength or self.button_pulse_strength);
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_autoresolve_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_balance_of_power_bar
--- @desc Highlights the balance of power bar. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_balance_of_power_bar(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "battle_deployment", "killometer");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or 8, true);
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_balance_of_power_bar(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_banners_and_marks
--- @desc Highlights banners and marks. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_banners_and_marks(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local component_highlighted = false;
	
	-- pre_battle_panel
	local uic_pre_battle_panel = find_uicomponent(ui_root, "popup_pre_battle");
	if uic_pre_battle_panel and uic_pre_battle_panel:Visible(true) then
		local uic_banners = find_uicomponent(uic_pre_battle_panel, "allies_combatants_panel", "army", "units_and_banners_parent", "ancillary_banners");
	
		if uic_banners then
			component_highlighted = true;
			pulse_uicomponent(uic_banners, value, pulse_strength or self.panel_pulse_strength, true);
			if value then
				self:highlight_pre_battle_panel_unit_cards(value, pulse_strength, force_highlight, false, false, false, true);
				table.insert(self.unhighlight_action_list, function() self:highlight_banners_and_marks(false, pulse_strength, force_highlight) end);
			end;
			return true;
		end;
	else
		-- post_battle_panel
		local uic_post_battle_panel = find_uicomponent(ui_root, "popup_battle_results");
		if uic_post_battle_panel and uic_post_battle_panel:Visible(true) then
			local uic_banners = find_uicomponent(uic_post_battle_panel, "allies_combatants_panel", "army", "units_and_banners_parent", "ancillary_banners");
		
			if uic_banners then
				component_highlighted = true;
				pulse_uicomponent(uic_banners, value, pulse_strength or self.panel_pulse_strength, true);
				if value then
					self:highlight_post_battle_panel_unit_cards(value, pulse_strength, force_highlight, false, false, true);
					table.insert(self.unhighlight_action_list, function() self:highlight_banners_and_marks(false, pulse_strength, force_highlight) end);
				end;
				return true;
			end;
		else
			-- character details pane
			self:highlight_global_item_pool(true);
			return true;
		end;
	end;

	return false;
end;


--- @function highlight_blessed_spawnings_button
--- @desc Highlights the blessed spawnings button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_blessed_spawnings_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if cm:get_faction(cm:get_local_faction_name(true)):culture() ~= "wh2_main_lzd_lizardmen" then
		return false;
	end;
	
	local ui_root = core:get_ui_root();
	
	local uic_renown_button = find_uicomponent(ui_root, "hud_campaign", "hud_center", "small_bar", "button_group_army", "button_renown");
	if uic_renown_button and uic_renown_button:Visible(true) then
		pulse_uicomponent(uic_renown_button, value, pulse_strength or self.button_pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_blessed_spawnings_button(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	else
		return self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_blood_kiss
--- @desc Highlights blood kiss indicator. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_blood_kiss(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	local faction = cm:get_faction(cm:get_local_faction_name(true)) 
	if faction and faction:culture() == "wh_main_vmp_vampire_counts" then
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_blood_kiss(false, pulse_strength, force_highlight) end);
		end;
		return highlight_visible_component(value, true, "hud_campaign", "resources_bar", "canopic_jars_holder");
	end
end;


--- @function highlight_bloodletting
--- @desc Highlights the bloodletting bar. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_bloodletting(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "CharacterInfoPopup", "winstreak_holder", "khorne_winstreak");

	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength, true);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_bloodletting(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_armies(value, pulse_strength, force_highlight);
	end;

	return false;
end;


--- @function highlight_bloodlines_button
--- @desc Highlights the bloodlines button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_bloodlines_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_bloodlines");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_bloodlines_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_bloodlines_panel
--- @desc Highlights the bloodlines panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_bloodlines_panel(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_panel = find_child_uicomponent(core:get_ui_root(), "bloodlines_panel");
			
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength);
		
		local uic_header = find_uicomponent(uic_panel, "header");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		local uic_rituals_list = find_uicomponent(uic_panel, "rituals_list");
		
		for i = 0, uic_rituals_list:ChildCount() - 1 do
			local uic_child = UIComponent(uic_rituals_list:Find(i));
			
			pulse_uicomponent(uic_child, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		local uic_frame = find_uicomponent(uic_panel, "panel_frame");
		if uic_frame then
			pulse_uicomponent(uic_frame, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		local uic_button = find_uicomponent(uic_panel, "button_ok");
		if uic_button then
			pulse_uicomponent(uic_button, value, pulse_strength or self.panel_pulse_strength);
		end;
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_bloodlines_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
		
	elseif not do_not_highlight_upstream then
		self:highlight_bloodlines_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_book_of_grudges_bar
--- @desc Highlights the book of grudges bar. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_book_of_grudges_bar(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "book_of_grudges", "grudge_bar");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or 8, true);
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_book_of_grudges_bar(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_books_of_nagash
--- @desc Highlights book of nagash. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_books_of_nagash(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_num_books = find_uicomponent(core:get_ui_root(), "resources_bar", "right_spacer_tomb_kings", "dy_num_books");
		
	if uic_num_books and uic_num_books:Visible(true) then
		pulse_uicomponent(uic_num_books, value, pulse_strength or self.button_pulse_strength, true);
		
		self:highlight_books_of_nagash_panel(value, pulse_strength, force_highlight, true);
		self:highlight_books_of_nagash_button(value, pulse_strength, force_highlight);
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_books_of_nagash(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_books_of_nagash_button
--- @desc Highlights the books of nagash button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_books_of_nagash_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_button = find_uicomponent(core:get_ui_root(), "resources_bar", "right_spacer_tomb_kings", "button_books_of_nagash");
		
	if uic_button and uic_button:Visible(true) then
		pulse_uicomponent(uic_button, value, pulse_strength or self.button_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_books_of_nagash_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_books_of_nagash_panel
--- @desc Highlights the books of nagash panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_books_of_nagash_panel(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_panel = find_child_uicomponent(core:get_ui_root(), "books_of_nagash");
			
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength);
		
		local uic_title = find_uicomponent(uic_panel, "panel_title");
		if uic_title then
			pulse_uicomponent(uic_title, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		local uic_watermark = find_uicomponent(uic_panel, "watermark");
		if uic_watermark then
			pulse_uicomponent(uic_watermark, value, pulse_strength or self.panel_pulse_strength);
			
			local uic_book_list = find_uicomponent(uic_watermark, "book_list");
			if uic_book_list then
				pulse_uicomponent(uic_book_list, value, pulse_strength or self.panel_pulse_strength, true);
			end;
		end;
		
		local uic_info = find_uicomponent(uic_panel, "info_panel");
		if uic_info then
			pulse_uicomponent(uic_info, value, pulse_strength or self.panel_pulse_strength);
			
			local uic_info_title = find_uicomponent(uic_info, "dy_title");
			if uic_info_title then
				pulse_uicomponent(uic_info_title, value, pulse_strength or self.panel_pulse_strength);
			end;
		end;
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_books_of_nagash(false, pulse_strength, force_highlight) end);
		end;
		return true;
		
	elseif not do_not_highlight_upstream then
		self:highlight_books_of_nagash_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_building_browser_button
--- @desc Highlights the building browser button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_building_browser_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local cm = self.cm;
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "button_building_browser");

	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_building_browser_button(false, pulse_strength, force_highlight) end);
		end;

		return true;
	else
		self:highlight_settlements(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
end;


--- @function highlight_building_browser
--- @desc Highlights the building browser. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_building_browser(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_browser = find_uicomponent(core:get_ui_root(), "building_browser");
	
	if uic_browser and uic_browser:Visible(true) then
		pulse_strength = pulse_strength or self.panel_pulse_strength;
	
		-- frame, back and button
		local uic_panel_frame = find_uicomponent(uic_browser, "panel_frame");
		if uic_panel_frame then
			pulse_uicomponent(uic_panel_frame, value, pulse_strength);
			
			local uic_back = find_uicomponent(uic_panel_frame, "panel_back");
			if uic_back then
				pulse_uicomponent(uic_back, value, pulse_strength);
			end;
			
			local uic_button = find_uicomponent(uic_panel_frame, "button_ok");
			if uic_button then
				pulse_uicomponent(uic_button, value, pulse_strength);
			end;
		end;
		
		-- header
		local uic_header = find_uicomponent(uic_browser, "header_frame");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength, true);
		end;
		
		-- treasury
		local uic_treasury = find_uicomponent(uic_browser, "dy_treasury");
		if uic_treasury then
			pulse_uicomponent(uic_treasury, value, pulse_strength, true);
		end;
		
		-- top-left info
		local uic_frame_tl = find_uicomponent(uic_browser, "frame_TL");
		if uic_frame_tl then
			pulse_uicomponent(uic_frame_tl, value, pulse_strength);
			
			-- corruption
			local uic_frame_corruption = find_uicomponent(uic_frame_tl, "frame_corruption");
			if uic_frame_corruption then
				pulse_uicomponent(uic_frame_corruption, value, pulse_strength);
				
				-- header
				local uic_corruption_header = find_uicomponent(uic_frame_corruption, "header_frame");
				if uic_corruption_header then
					pulse_uicomponent(uic_corruption_header, value, pulse_strength);
				end;
			end;
			
			-- growth
			local uic_frame_growth = find_uicomponent(uic_frame_tl, "frame_growth");
			if uic_frame_growth then
				pulse_uicomponent(uic_frame_growth, value, pulse_strength);
				
				-- header
				local uic_growth_header = find_uicomponent(uic_frame_corruption, "header_frame");
				if uic_growth_header then
					pulse_uicomponent(uic_growth_header, value, pulse_strength);
				end;
			end;
		end;
		
		-- top-right info
		local uic_frame_tr = find_uicomponent(uic_browser, "frame_TR");
		if uic_frame_tr then
			pulse_uicomponent(uic_frame_tr, value, pulse_strength);
			
			-- income
			local uic_frame_income = find_uicomponent(uic_frame_tr, "frame_PO_income");
			if uic_frame_income then
				pulse_uicomponent(uic_frame_income, value, pulse_strength);
				
				-- tax frame
				local uic_tax_frame = find_uicomponent(uic_frame_income, "tax_frame");
				if uic_tax_frame then
					pulse_uicomponent(uic_tax_frame, value, pulse_strength);
				end;
			end;
			
			-- effects
			local uic_effects = find_uicomponent(uic_frame_tr, "effects");
			if uic_effects then
				pulse_uicomponent(uic_effects, value, pulse_strength);
				
				-- header
				local uic_effects_header = find_uicomponent(uic_effects, "header_frame");
				if uic_effects_header then
					pulse_uicomponent(uic_effects_header, value, pulse_strength);
				end;
			end;
		end;
		
		-- settlement buttons		
		local uic_settlements = find_uicomponent(uic_browser, "main_settlement_panel");
		if uic_settlements then
			for i = 0, uic_settlements:ChildCount() - 1 do
				local uic_button = find_uicomponent(UIComponent(uic_settlements:Find(i)), "button_zoom");
				if uic_button then
					pulse_uicomponent(uic_button, value, pulse_strength);
				end;				
			end;
		end;
		
		if value then
			self:highlight_building_browser_buildings(value, pulse_strength, force_highlight, true);
			table.insert(self.unhighlight_action_list, function() self:highlight_building_browser(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_building_browser_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_building_browser_buildings
--- @desc Highlights building browser buildings. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_building_browser_buildings(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_browser = find_uicomponent(core:get_ui_root(), "building_browser", "building_superchains");
	
	if uic_browser and uic_browser:Visible(true) then
		pulse_uicomponent(uic_browser, value, pulse_strength or self.panel_pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_building_browser_buildings(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_building_browser_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_building_panel
--- @desc Highlights the building panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_building_panel(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_panel = find_uicomponent(ui_root, "settlement_panel");
	
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.button_pulse_strength);

		if value then
			self:highlight_horde_buildings(value,  pulse_strength, force_highlight, true);
			table.insert(self.unhighlight_action_list, function() self:highlight_building_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_building_panel_tab(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_building_panel_tab
--- @desc Highlights the building panel tab on the army panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_building_panel_tab(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_tab = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "tabgroup", "tab_horde_buildings");
	
	if uic_tab and uic_tab:Visible(true) then
		pulse_uicomponent(uic_tab, value, pulse_strength or self.button_pulse_strength);
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_building_panel_tab(false, pulse_strength, force_highlight) end);
		end;
	else
		self:highlight_armies(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_buildings
--- @desc Highlights buildings on the army panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean first settlement only, Only highlight buildings for the first settlement on the army panel.
--- @p [opt=false] boolean all but first settlement, Highlight buildings for all but the first settlement on the army panel.
function campaign_ui_manager:highlight_buildings(value, pulse_strength, force_highlight, first_settlement_only, all_but_first_settlement)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	if value then
		self:highlight_building_browser_buildings(value, pulse_strength, force_highlight, true);
		self:highlight_horde_buildings(value, pulse_strength, force_highlight, true);
	end;

	local ui_root = core:get_ui_root();
	local uic_panel = find_uicomponent(ui_root, "settlement_panel");
	
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.button_pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_buildings(false, pulse_strength, force_highlight, first_settlement_only) end);
		end;
		return true;
	else
		self:highlight_settlements(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_canopic_jars
--- @desc Highlights canopic jars. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_canopic_jars(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	local faction = cm:get_faction(cm:get_local_faction_name(true)) 
	if faction and faction:culture() == "wh2_dlc09_tmb_tomb_kings" then
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_canopic_jars(false, pulse_strength, force_highlight) end);
		end;
		return highlight_visible_component(value, true, "hud_campaign", "resources_bar", "canopic_jars_holder");
	end
end;


--- @function highlight_character_available_skill_points
--- @desc Highlights the available skill points indicator on the character details panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_character_available_skill_points(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "character_details_panel", "dy_pts");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength - 2);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_character_available_skill_points(false, pulse_strength, force_highlight, false) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_character_details_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_character_details
--- @desc Highlights the character details subpanel on the character details panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_character_details(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_character_details = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent");
	if uic_character_details and uic_character_details:Visible(true) then
		pulse_strength = pulse_strength or self.panel_pulse_strength;
		local tab_panels = find_uicomponent(uic_character_details, "tab_panels");
		-- name
		local uic_name = find_uicomponent(uic_character_details, "character_name");
		if uic_name then
			pulse_uicomponent(uic_name, value, pulse_strength, true);
		end;
		
		-- character details subpanel
		local uic_character_details = find_uicomponent(tab_panels, "character_details_subpanel");
		if uic_character_details then
			pulse_uicomponent(uic_character_details, value, pulse_strength, true);
		end;
		
		-- stats effects holder
		local uic_stats_effects_row = find_uicomponent(tab_panels, "row_header_stats");
		if uic_stats_effects_row then
			pulse_uicomponent(uic_stats_effects_row, value, pulse_strength, true);
		end;
		local uic_stats_effects_panel = find_uicomponent(tab_panels, "stats_panel");
		if uic_stats_effects_panel then
			pulse_uicomponent(uic_stats_effects_panel, value, pulse_strength, true);
		end;
		local uic_stats_effects_details = find_uicomponent(tab_panels, "row_details");
		if uic_stats_effects_details then
			pulse_uicomponent(uic_stats_effects_details, value, pulse_strength, true);
		end;
		local uic_stats_effects_holder = find_uicomponent(tab_panels, "details_traints_effects_holder");
		if uic_stats_effects_holder then
			pulse_uicomponent(uic_stats_effects_holder, value, pulse_strength, true);
		end;
		
		-- details tab button
		local uic_details_tab = find_uicomponent(uic_character_details, "Tab_Group", "details");
		if uic_details_tab then
			pulse_uicomponent(uic_details_tab, value, pulse_strength, true);
		end;
		
		if value then
			self:highlight_banners_and_marks(value, pulse_strength, force_highlight);
			table.insert(self.unhighlight_action_list, function() self:highlight_character_details(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_character_details_panel_details_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_character_details_button
--- @desc Highlights the character details button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_character_details_button(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local cm = self.cm;
	local uic = find_uicomponent(core:get_ui_root(), "primary_info_panel_holder", "button_general");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_character_details_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_character_details_panel
--- @desc Highlights the character details panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_character_details_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_panel = find_uicomponent(core:get_ui_root(), "character_details_panel");
	
	if uic_panel and uic_panel:Visible(true) then
	
		local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
		-- frame
		local uic_panel_frame = find_uicomponent(uic_panel, "panel_frame");
		if uic_panel_frame then
			pulse_uicomponent(uic_panel_frame, value, pulse_strength_to_use, true);
		end;
		
		-- title
		local uic_title = find_uicomponent(uic_panel, "character_name");
		if uic_title then
			pulse_uicomponent(uic_title, value, pulse_strength_to_use, true);
		end;
		
		-- ok button
		local uic_button = find_uicomponent(uic_panel, "button_ok");
		if uic_button then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use);
		end;
		
		-- bottom buttons
		local uic_bottom_buttons = find_uicomponent(uic_panel, "bottom_buttons");
		if uic_bottom_buttons then
			pulse_uicomponent(uic_bottom_buttons, value, pulse_strength_to_use, true);
		end;
		
		-- character stats
		local uic_char_stats = find_uicomponent(uic_panel, "stats_panel");
		if uic_char_stats then
			pulse_uicomponent(uic_char_stats, value, pulse_strength_to_use);
		
			-- header
			local uic_header = find_uicomponent(uic_char_stats, "stat_header");
			if uic_header then
				pulse_uicomponent(uic_header, value, pulse_strength_to_use, true);
			end;
			
			-- arrow
			local uic_arrow = find_uicomponent(uic_char_stats, "skill_arrow_stats");
			if uic_arrow then
				pulse_uicomponent(uic_arrow, value, pulse_strength_to_use);
			end;
		end;
		
		-- battle effects
		local uic_battle_effects = find_uicomponent(uic_panel, "battle_effects_window");
		if uic_battle_effects then
			pulse_uicomponent(uic_battle_effects, value, pulse_strength_to_use);
			
			-- header
			local uic_header = find_uicomponent(uic_battle_effects, "battle_header");
			if uic_header then
				pulse_uicomponent(uic_header, value, pulse_strength_to_use, true);
			end;
			
			-- arrow
			local uic_arrow = find_uicomponent(uic_battle_effects, "skill_arrow_battle");
			if uic_arrow then
				pulse_uicomponent(uic_arrow, value, pulse_strength_to_use);
			end;
		end;
		
		-- campaign effects
		local uic_campaign_effects = find_uicomponent(uic_panel, "campaign_effects_window");
		if uic_campaign_effects then
			pulse_uicomponent(uic_campaign_effects, value, pulse_strength_to_use);
			
			-- header
			local uic_header = find_uicomponent(uic_campaign_effects, "campaign_header");
			if uic_header then
				pulse_uicomponent(uic_header, value, pulse_strength_to_use, true);
			end;
			
			-- arrow
			local uic_arrow = find_uicomponent(uic_campaign_effects, "skill_arrow_campaign");
			if uic_arrow then
				pulse_uicomponent(uic_arrow, value, pulse_strength_to_use);
			end;
		end;
		
		-- character details
		local uic_character_details = find_uicomponent(uic_panel, "character_details_subpanel");
		if uic_character_details and uic_character_details:Visible(true) then
			-- info
			local uic_info = find_uicomponent(uic_character_details, "details");
			if uic_info then
				pulse_uicomponent(uic_info, value, pulse_strength_to_use);
				
				-- title
				local uic_title = find_uicomponent(uic_info, "parchment_divider_title");
				if uic_title then
					pulse_uicomponent(uic_title, value, pulse_strength_to_use, true);
				end;
			end;
			
			-- traits
			local uic_traits = find_uicomponent(uic_character_details, "traits_subpanel");
			if uic_traits then
				pulse_uicomponent(uic_traits, value, pulse_strength_to_use);
				
				-- title
				local uic_title = find_uicomponent(uic_traits, "parchment_divider_title");
				if uic_title then
					pulse_uicomponent(uic_title, value, pulse_strength_to_use, true);
				end;
			end;
			
			-- ancillaries
			local uic_ancillaries = find_uicomponent(uic_character_details, "ancillary_general");
			if uic_ancillaries then
				pulse_uicomponent(uic_ancillaries, value, pulse_strength_to_use, true);
			end;
			
			-- equipment
			local uic_equipment = find_uicomponent(uic_character_details, "ancillary_equipment");
			if uic_equipment then
				pulse_uicomponent(uic_equipment, value, pulse_strength_to_use, true);
			end;
		end;

		-- skills
		local uic_skills = find_uicomponent(uic_panel, "skills_subpanel");
		if uic_skills and uic_skills:Visible(true) then
			pulse_uicomponent(uic_skills, value, pulse_strength_to_use);
			
			-- reset button
			local uic_reset = find_uicomponent(uic_skills, "stats_reset_holder");
			if uic_reset then
				pulse_uicomponent(uic_reset, value, pulse_strength_to_use, true);
			end;
		end;
			
		if value then
			self:highlight_character_details_panel_rank_indicator(value, pulse_strength, force_highlight);
			self:highlight_character_available_skill_points(value, pulse_strength, force_highlight, true);
			self:highlight_character_details_panel_details_button(value, pulse_strength, force_highlight, true);
			self:highlight_character_details_panel_skills_button(value, pulse_strength, force_highlight, true);
			table.insert(self.unhighlight_action_list, function() self:highlight_character_details_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_character_details_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_character_details_panel_abilities
--- @desc Highlights the abilities details on the character details panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_character_details_panel_abilities(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "character_details_panel", "stats_effects_holder", "unit_information_listview");
	
	if uic and uic:Visible(true) then		
		-- highlight abilities header
		local uic_header = find_uicomponent(uic, "row_header_abilities");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength or self.button_pulse_strength - 2, true);
		end;
		
		-- highlight abilities list
		local uic_list = find_uicomponent(uic, "abilities_listview");
		if uic_list then
			pulse_uicomponent(uic_list, value, pulse_strength or self.button_pulse_strength - 2, true);
		end;

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_character_details_panel_abilities(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_character_details_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_character_details_panel_details_button
--- @desc Highlights the details tab button on the character details panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_character_details_panel_details_button(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "character_details_panel", "TabGroup", "details");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength - 2, true);
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_character_details_panel_details_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_character_details_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_character_details_panel_character_stats
--- @desc Highlights the character stats on the character details panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_character_details_panel_character_stats(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "character_details_panel", "stats_effects_holder");
	
	if uic and uic:Visible(true) then
		local uic_stats = find_uicomponent(uic, "row_header_stats");
		if uic_stats then
			pulse_uicomponent(uic_stats, value, pulse_strength or self.button_pulse_strength - 2, true);
		end;

		local uic_details = find_uicomponent(uic, "unit_information", "details");
		if uic_details then
			pulse_uicomponent(uic_details, value, pulse_strength or self.button_pulse_strength - 2, true);
		end;

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_character_details_panel_character_stats(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_character_details_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_character_details_panel_details_traits_and_effects
--- @desc Highlights the traits and effects for a character on the character details panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_character_details_panel_details_traits_and_effects(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "character_details_panel", "stats_effects_holder");
	
	if uic and uic:Visible(true) then
		local uic_header = find_uicomponent(uic, "row_details");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength or self.button_pulse_strength - 2, true);
		end;

		local uic_list = find_uicomponent(uic, "unit_information", "details_traints_effects_holder");
		if uic_list then
			pulse_uicomponent(uic_list, value, pulse_strength or self.button_pulse_strength - 2, true);
		end;

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_character_details_panel_details_traits_and_effects(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_character_details_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_character_details_panel_quests_button
--- @desc Highlights the quests tab button on the character details panel. Best practice is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_character_details_panel_quests_button(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "character_details_panel", "TabGroup", "quests");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength - 2);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_character_details_panel_quests_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_character_details_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_character_details_panel_rank_indicator
--- @desc Highlights the character rank indicator on the character details panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_character_details_panel_rank_indicator(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_rank = find_uicomponent(core:get_ui_root(), "character_details_panel", "rank", "frame");
	if uic_rank and uic_rank:Visible(true) then
		pulse_uicomponent(uic_rank, value, pulse_strength or self.button_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_character_details_panel_rank_indicator(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
end;


--- @function highlight_character_details_panel_skills_button
--- @desc Highlights the skills tab button on the character details panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_character_details_panel_skills_button(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "character_details_panel", "TabGroup", "skills");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength - 2);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_character_details_panel_skills_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_character_skills_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_character_info_panel
--- @desc Highlights the character info panel that appears when a character is selected. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_character_info_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local cm = self.cm;
	local uic_character_info_panel = find_uicomponent(core:get_ui_root(), "CharacterInfoPopup");
	
	if uic_character_info_panel and uic_character_info_panel:Visible(true) then
		local panel_pulse_strength = pulse_strength or self.panel_pulse_strength;
		
		pulse_uicomponent(find_uicomponent(uic_character_info_panel, "porthole_mask"), value, panel_pulse_strength);
		-- pulse_uicomponent(find_uicomponent(uic_character_info_panel, "rank"), value, panel_pulse_strength, true);
		pulse_uicomponent(find_uicomponent(uic_character_info_panel, "mount_icon"), value, panel_pulse_strength);
		--pulse_uicomponent(find_uicomponent(uic_character_info_panel, "effects_over"), value, panel_pulse_strength);
		
		-- highlight effects list
		local uic_effects = find_uicomponent(uic_character_info_panel, "effect_list");
		if uic_effects then
			pulse_uicomponent(uic_effects, value, panel_pulse_strength, true);
		end;
		
		-- highlight equipment list
		local uic_equipment_list = find_uicomponent(uic_character_info_panel, "equipment_list");
		if uic_equipment_list then
			pulse_uicomponent(uic_equipment_list, value, panel_pulse_strength, true);
		end;
		
		-- frame
		local uic_ap_frame = find_uicomponent(uic_character_info_panel, "ap_frame");
		if uic_ap_frame then
			pulse_uicomponent(uic_ap_frame, value, panel_pulse_strength);
		end;
		
		if value then
			self:highlight_character_details_button(value, pulse_strength, force_highlight, true);
			self:highlight_character_skills_button(value, pulse_strength, force_highlight, true);
			self:highlight_fightiness_bar(value, pulse_strength, force_highlight, true);
			self:highlight_stances(value, pulse_strength, force_highlight, true);
			self:highlight_movement_range(value, pulse_strength, force_highlight, true);
			table.insert(self.unhighlight_action_list, function() self:highlight_character_info_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_character_magic_items
--- @desc Highlights magic items on the character details panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_character_magic_items(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_equipment = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_details_subpanel", "ancillary_equipment");
	
	if uic_equipment and uic_equipment:Visible(true) then
		pulse_uicomponent(uic_equipment, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_character_magic_items(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_character_details_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_character_skills
--- @desc Highlights the character skills subpanel on the character details panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_character_skills(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_skills = find_uicomponent(ui_root, "character_details_panel", "skills_subpanel");
	local uic_skills_reset = find_uicomponent(ui_root, "character_details_panel", "skill_pts_holder");
	
	if uic_skills and uic_skills:Visible(true) then
		-- character details panel is open
		pulse_uicomponent(uic_skills, value, pulse_strength or self.panel_pulse_strength, true);
			
		-- reset button
		if uic_skills_reset then
			pulse_uicomponent(uic_skills_reset, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		if value then
			self:highlight_character_available_skill_points(value, pulse_strength, force_highlight, true);
			self:highlight_character_details_panel_rank_indicator(value, pulse_strength, force_highlight);
			table.insert(self.unhighlight_action_list, function() self:highlight_character_skills(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		if value then
			self:highlight_character_details_panel_rank_indicator(value, pulse_strength, force_highlight);
			self:highlight_character_available_skill_points(value, pulse_strength, force_highlight, true);
		end;
		self:highlight_character_details_panel_skills_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_character_skills_button
--- @desc Highlights the character skills button on the character details panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_character_skills_button(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "info_panel_holder", "primary_info_panel_holder", "CharacterInfoPopup", "skill_button");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_character_skills_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_character_traits
--- @desc Highlights the character traits on the character details panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_character_traits(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "character_details_panel", "stats_effects_holder");
	
	if uic and uic:Visible(true) then
		local uic_header = find_uicomponent(uic, "row_details");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength or self.button_pulse_strength, true);
		end;

		local uic_list = find_uicomponent(uic, "unit_information", "traits_subpanel");
		if uic_list then
			pulse_uicomponent(uic_list, value, pulse_strength or self.button_pulse_strength, true);
		end;

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_character_details_panel_details_traits_and_effects(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_character_details_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_chivalry
--- @desc Highlights the chivalry bar. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_chivalry(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_chivalry_bar = find_uicomponent(core:get_ui_root(), "chivalry_bar");
	
	if uic_chivalry_bar and uic_chivalry_bar:Visible(true) then
		-- player fill (positive)
		local uic_player_pos = find_uicomponent(uic_chivalry_bar, "positive_segment", "player");
		
		if uic_player_pos and uic_player_pos:Visible(true) then
			pulse_uicomponent(uic_player_pos, value, pulse_strength or self.button_pulse_strength);
		end;
		
		-- player fill (negative)
		local uic_player_neg = find_uicomponent(uic_chivalry_bar, "negative_segment", "player");
		
		if uic_player_neg and uic_player_neg:Visible(true) then
			pulse_uicomponent(uic_player_neg, value, pulse_strength or self.button_pulse_strength);
		end;
		
		-- bar background
		local uic_other = find_uicomponent(uic_chivalry_bar, "other");
		
		if uic_other and uic_other:Visible(true) then
			pulse_uicomponent(uic_other, value, pulse_strength or self.button_pulse_strength);
		end;
		
		-- bar frame
		local uic_frame = find_uicomponent(uic_chivalry_bar, "frame");
		
		if uic_frame and uic_frame:Visible(true) then
			pulse_uicomponent(uic_frame, value, pulse_strength or self.button_pulse_strength);
		end;
		
		-- number on frame
		local uic_current_frame = find_uicomponent(uic_chivalry_bar, "current_frame");
		
		if uic_current_frame and uic_current_frame:Visible(true) then
			pulse_uicomponent(uic_current_frame, value, pulse_strength or self.button_pulse_strength);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_chivalry(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	end;
	
	return false;
end;

--- @function highlight_electoral_machinations
--- @desc Highlights the Electoral Machinations. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_electoral_machinations(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "dlc25_electoral_machinations");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_electoral_machinations(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_electoral_machinations");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_electoral_machinations(false) end);
			end;
		end;
	end;
end;

--- @function highlight_commandments
--- @desc Highlights commandments. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_commandments(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local cm = self.cm;
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "BL_parent", "stack_incentives", "button_default", "frame");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.panel_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_commandments(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		return self:highlight_settlements(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_corruption
--- @desc Highlights corruption. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_corruption(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "frame_corruption");
	
	-- if uic and uic:Visible(true) and is_fully_onscreen(uic) then -->> is_fully_onscreen(uic) not working as expected
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_corruption(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_settlements(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_diplomacy_attitude_icons
--- @desc Highlights diplomacy attitude icons on the diplomacy screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_diplomacy_attitude_icons(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_list = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_panel", "sortable_list_factions", "list_clip", "list_box");
	
	if uic_list and uic_list:Visible(true) then
	
		for i = 0, uic_list:ChildCount() - 1 do
			local uic_row = UIComponent(uic_list:Find(i));
			local uic_attitude = find_uicomponent(uic_row, "attitude");
			
			if uic_attitude then
				pulse_uicomponent(uic_attitude, value, pulse_strength or self.button_pulse_strength);
			end;
		end;
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_diplomacy_attitude_icons(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_diplomacy_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_diplomacy_button
--- @desc Highlights the diplomacy button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_diplomacy_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "faction_buttons_docker", "button_diplomacy");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_diplomacy_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_diplomacy_centre_panel
--- @desc Highlights the centre panel on the diplomacy screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_diplomacy_centre_panel(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_screen = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown");
	
	if uic_screen and uic_screen:Visible(true) then
		-- see if faction_panel is visible
		local uic_faction_panel = find_uicomponent(uic_screen, "faction_panel");
		if uic_faction_panel and uic_faction_panel:Visible(true) then
			pulse_uicomponent(uic_faction_panel, value, pulse_strength or self.panel_pulse_strength, true);
		else
			-- otherwise, see if offers_panel is visible
			local uic_offers_panel = find_uicomponent(uic_screen, "offers_panel");
			if uic_offers_panel and uic_offers_panel:Visible(true) then
				pulse_uicomponent(uic_offers_panel, value, pulse_strength or self.panel_pulse_strength, true);
			else
				-- otherwise see if subpanel_group is visible
				local uic_subpanel_group = find_uicomponent(uic_screen, "offers_panel");
				if uic_subpanel_group and uic_subpanel_group:Visible(true) then
					pulse_uicomponent(uic_subpanel_group, value, pulse_strength or self.panel_pulse_strength, true);
				end;
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_diplomacy_centre_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_diplomacy_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_diplomacy_left_panel
--- @desc Highlights the left panel on the diplomacy screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_diplomacy_left_panel(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_left_panel = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_left_status_panel");
	if uic_left_panel and uic_left_panel:Visible(true) then
		pulse_uicomponent(uic_left_panel, value, pulse_strength or self.panel_pulse_strength);
		
		local uic_porthole = find_uicomponent(uic_left_panel, "porthole");
		if uic_porthole then
			pulse_uicomponent(uic_porthole, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_diplomacy_left_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_diplomacy_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_diplomacy_right_panel
--- @desc Highlights the right panel on the diplomacy screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_diplomacy_right_panel(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_left_panel = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_right_status_panel");
	if uic_left_panel and uic_left_panel:Visible(true) then
		pulse_uicomponent(uic_left_panel, value, pulse_strength or self.panel_pulse_strength);
		
		local uic_porthole = find_uicomponent(uic_left_panel, "porthole");
		if uic_porthole then
			pulse_uicomponent(uic_porthole, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_diplomacy_right_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_diplomacy_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_diplomacy_screen
--- @desc Highlights just the diplomacy screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_diplomacy_screen(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown");
	
	if uic and uic:Visible(true) then
		if value then
			self:highlight_diplomacy_centre_panel(value, pulse_strength, force_highlight, true);
			self:highlight_diplomacy_left_panel(value, pulse_strength, force_highlight, true);
			self:highlight_diplomacy_right_panel(value, pulse_strength, force_highlight, true);
			table.insert(self.unhighlight_action_list, function() self:highlight_diplomacy_screen(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_diplomacy_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_drill_of_hashut
--- @desc Highlights the Chaos Dwarfs Hell-forge. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_drill_of_hashut(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "chd_narrative_panel");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_drill_of_hashut(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "resources_bar_holder", "button_chd_narrative_panel");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_drill_of_hashut(false) end);
			end;
		end;
	end;
end;


--- @function highlight_drop_down_list_buttons
--- @desc Highlights the drop-down list buttons. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_drop_down_list_buttons(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	self:highlight_list_button_factions(value, pulse_strength, force_highlight);
	self:highlight_list_button_provinces(value, pulse_strength, force_highlight);
	self:highlight_list_button_forces(value, pulse_strength, force_highlight);
	self:highlight_list_button_events(value, pulse_strength, force_highlight);
	self:highlight_list_button_missions(value, pulse_strength, force_highlight);
end;


--- @function highlight_dynasties
--- @desc Highlights dynasties. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_dynasties(value, pulse_strength, force_highlight)
	return self:highlight_technologies(value, pulse_strength, force_highlight);
end;


--- @function highlight_dynasties_panel
--- @desc Highlights the dynasties panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_dynasties_panel(value, pulse_strength, force_highlight)
	return self:highlight_technology_panel(value, pulse_strength, force_highlight);
end;

--- @function highlight_colleges_of_magic
--- @desc Highlights the Colleges of Magic. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_colleges_of_magic(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "dlc25_college_of_magic");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_colleges_of_magic(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_college_of_magic");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_colleges_of_magic(false) end);
			end;
		end;
	end;
end;


--- @function highlight_end_turn_button
--- @desc Highlights the end-turn button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_end_turn_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_end_turn");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_end_turn_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_events_list
--- @desc Highlights the events drop-down list. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_events_list(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "radar_things", "dropdown_events", "panel");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.panel_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_events_list(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_list_button_events(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_factions_list
--- @desc Highlights the factions drop-down list. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_factions_list(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "radar_things", "dropdown_factions", "panel");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.panel_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_factions_list(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_list_button_factions(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_faction_summary_button
--- @desc Highlights the factions summary button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_faction_summary_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "bar_small_top", "button_factions");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_faction_summary_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_faction_summary_records_tab
--- @desc Highlights the records tab on the faction screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_faction_summary_records_tab(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_tab = find_uicomponent(ui_root, "clan", "main", "TabGroup", "Records");	

	if uic_tab and uic_tab:Visible(true) then
		pulse_uicomponent(uic_tab, value, pulse_strength or self.button_pulse_strength);
		
		-- event_feed
		local uic_event_feed = find_uicomponent(ui_root, "clan", "main", "tab_children_parent", "Records", "event_feed"); 
		if uic_event_feed and uic_event_feed:Visible(true) then
		
			pulse_strength = pulse_strength or self.panel_pulse_strength;

			-- filters
			local uic_filters_button = find_uicomponent(uic_event_feed, "filters_toggle");
			if uic_filters_button then
				pulse_uicomponent(uic_filters_button, value, pulse_strength);
				
				-- filters panel
				local uic_filters_panel = find_uicomponent(uic_filters_button, "filters");
				if uic_filters_panel and uic_filters_panel:Visible(true) then
					pulse_uicomponent(uic_filters_panel, value, pulse_strength);
					
					-- subpanel
					local uic_filters_subpanel = find_uicomponent(uic_filters_panel, "subpanel");
					if uic_filters_subpanel and uic_filters_subpanel:Visible(true) then
						pulse_uicomponent(uic_filters_subpanel, value, pulse_strength);
					end;
					
					-- subpanel header
					local uic_filters_subpanel_header = find_uicomponent(uic_filters_panel, "tx_header");
					if uic_filters_subpanel_header and uic_filters_subpanel_header:Visible(true) then
						-- root > clan > main > tab_children_parent > Records > event_feed > filters_toggle > filters > tx_header
						pulse_uicomponent(uic_filters_subpanel_header, value, pulse_strength);
					end;
					
					-- load filter
					local uic_load_filter = find_uicomponent(uic_filters_panel, "button_load_filter");
					if uic_load_filter then
						pulse_uicomponent(uic_load_filter, value, pulse_strength);
					end;
					
					-- save filter
					local uic_save_filter = find_uicomponent(uic_filters_panel, "button_save_filter");
					if uic_save_filter then
						pulse_uicomponent(uic_save_filter, value, pulse_strength);
					end;
				end;				
			end;
			
			-- feed
			local uic_feed = find_uicomponent(uic_event_feed, "feed");
			if uic_feed then
				pulse_uicomponent(uic_feed, value, pulse_strength);
				
				-- frame
				local uic_frame = find_uicomponent(uic_feed, "frame");
				if uic_frame then
					pulse_uicomponent(uic_frame, value, pulse_strength);
				end;
				
				-- header
				local uic_header = find_uicomponent(uic_feed, "tx_header");
				if uic_header then
					pulse_uicomponent(uic_header, value, pulse_strength);
				end;
			end;
			
			-- map controls
			local uic_controls = find_uicomponent(uic_event_feed, "map_controls");
			if uic_controls then
				pulse_uicomponent(uic_controls, value, pulse_strength, true);
			end;
			
			-- add filter button
			local uic_add_filter_button = find_uicomponent(uic_event_feed, "button_add_filter");
			if uic_add_filter_button then
				pulse_uicomponent(uic_add_filter_button, value, pulse_strength);
			end;
			
			-- view event button
			local uic_view_event_button = find_uicomponent(uic_event_feed, "button_open_message");
			if uic_view_event_button then
				pulse_uicomponent(uic_view_event_button, value, pulse_strength);
			end;
			
			-- clear context button
			local uic_clear_context_button = find_uicomponent(uic_event_feed, "button_clear_context");
			if uic_clear_context_button then
				pulse_uicomponent(uic_clear_context_button, value, pulse_strength);
			end;

			-- context subpanel
			local uic_context_subpanel = find_uicomponent(uic_event_feed, "context_subpanel");
			if uic_context_subpanel then
				pulse_uicomponent(uic_context_subpanel, value, pulse_strength);
				
				-- faction subpanel
				local uic_faction_subpanel = find_uicomponent(uic_context_subpanel, "faction_context_subpanel");
				if uic_faction_subpanel and uic_faction_subpanel:Visible(true) then
					pulse_uicomponent(uic_faction_subpanel, value, pulse_strength);
					
					local uic_header = find_uicomponent(uic_faction_subpanel, "header");
					if uic_header then
						pulse_uicomponent(uic_header, value, pulse_strength, true);
					end;
				end;
				
				-- character subpanel
				local uic_character_subpanel = find_uicomponent(uic_context_subpanel, "character_context_subpanel", "subpanel");
				if uic_character_subpanel and uic_character_subpanel:Visible(true) then
					pulse_uicomponent(uic_character_subpanel, value, pulse_strength);
					
					local uic_header = find_uicomponent(uic_character_subpanel, "header");
					if uic_header then
						pulse_uicomponent(uic_header, value, pulse_strength);
					end;
				end;
				
				-- force subpanel
				local uic_force_subpanel = find_uicomponent(uic_context_subpanel, "force_context_subpanel", "subpanel");
				if uic_force_subpanel and uic_force_subpanel:Visible(true) then
					pulse_uicomponent(uic_force_subpanel, value, pulse_strength);
					
					local uic_header = find_uicomponent(uic_force_subpanel, "header");
					if uic_header then
						pulse_uicomponent(uic_header, value, pulse_strength);
					end;
				end;
				
				-- province subpanel
				local uic_province_subpanel = find_uicomponent(uic_context_subpanel, "province_context_subpanel", "subpanel");
				if uic_province_subpanel and uic_province_subpanel:Visible(true) then
					pulse_uicomponent(uic_province_subpanel, value, pulse_strength);
					
					local uic_header = find_uicomponent(uic_province_subpanel, "header");
					if uic_header then
						pulse_uicomponent(uic_header, value, pulse_strength);
					end;
				end;
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_faction_summary_records_tab(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_faction_summary_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_faction_summary_screen
--- @desc Highlights the faction summary screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_faction_summary_screen(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local uic_screen = find_uicomponent(ui_root, "clan");
	
	if uic_screen and uic_screen:Visible(true) then
		
		-- frame
		local uic_frame = find_uicomponent(uic_screen, "panel_frame");
		if uic_frame then
			pulse_uicomponent(uic_frame, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		-- header
		local uic_header = find_uicomponent(uic_screen, "header_frame");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		if value then
			self:highlight_faction_summary_records_tab(value, pulse_strength, force_highlight, true);
			self:highlight_faction_summary_summary_tab(value, pulse_strength, force_highlight, true);
			self:highlight_faction_summary_statistics_tab(value, pulse_strength, force_highlight, true);
			table.insert(self.unhighlight_action_list, function() self:highlight_faction_summary_screen(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		return self:highlight_faction_summary_button(value, pulse_strength, force_highlight);
	end;
end;


--- @function highlight_faction_summary_summary_tab
--- @desc Highlights the summary tab on the faction screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_faction_summary_summary_tab(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_tab = find_uicomponent(ui_root, "clan", "main", "TabGroup", "Summary");	

	if uic_tab and uic_tab:Visible(true) then
		pulse_uicomponent(uic_tab, value, self.button_pulse_strength);
		
		pulse_strength = pulse_strength or self.panel_pulse_strength;
		
		-- left panel
		local uic_parchment_left = find_uicomponent(ui_root, "clan", "main", "tab_children_parent", "Summary", "parchment_L"); 
		if uic_parchment_left and uic_parchment_left:Visible(true) then
			pulse_uicomponent(uic_parchment_left, value, pulse_strength);
			
			-- details
			local uic_details = find_uicomponent(uic_parchment_left, "details");
			if uic_details then
				pulse_uicomponent(uic_details, value, pulse_strength);
			end;
			
			-- details header
			local uic_details_header = find_uicomponent(uic_details, "parchment_divider_title");
			if uic_details_header then
				pulse_uicomponent(uic_details_header, value, pulse_strength);
			end;
			
			-- effects
			local uic_effects = find_uicomponent(uic_parchment_left, "trait_panel");
			if uic_effects then
				pulse_uicomponent(uic_effects, value, pulse_strength);
			end;
			
			-- effects header
			local uic_effects_header = find_uicomponent(uic_effects, "parchment_divider_title");
			if uic_effects_header then
				pulse_uicomponent(uic_effects_header, value, pulse_strength);
			end;
		end;
		
		-- right panel
		local uic_parchment_right = find_uicomponent(ui_root, "clan", "main", "tab_children_parent", "Summary", "parchment_R"); 
		if uic_parchment_right and uic_parchment_right:Visible(true) then
			pulse_uicomponent(uic_parchment_right, value, pulse_strength);
			
			-- power
			local uic_power = find_uicomponent(uic_parchment_right, "imperium");
			if uic_power then
				pulse_uicomponent(uic_power, value, pulse_strength);
			end;
			
			-- details header
			local uic_power_header = find_uicomponent(uic_power, "parchment_divider_title");
			if uic_power_header then
				pulse_uicomponent(uic_power_header, value, pulse_strength);
			end;
			
			-- diplomacy
			local uic_diplomacy = find_uicomponent(uic_parchment_right, "diplomacy");
			if uic_diplomacy then
				pulse_uicomponent(uic_diplomacy, value, pulse_strength);
			end;
			
			-- diplomacy header
			local uic_diplomacy_header = find_uicomponent(uic_diplomacy, "parchment_divider_title");
			if uic_diplomacy_header then
				pulse_uicomponent(uic_diplomacy_header, value, pulse_strength);
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_faction_summary_summary_tab(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_faction_summary_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_faction_summary_statistics_tab
--- @desc Highlights the statistics tab on the faction screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_faction_summary_statistics_tab(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_tab = find_uicomponent(ui_root, "clan", "main", "TabGroup", "Stats");	

	if uic_tab and uic_tab:Visible(true) then
		pulse_uicomponent(uic_tab, value, pulse_strength or self.button_pulse_strength);
		
		local uic_stats = find_uicomponent(ui_root, "clan", "main", "tab_children_parent", "Stats", "stats_panel"); 
		if uic_stats and uic_stats:Visible(true) then
			pulse_uicomponent(uic_stats, value, pulse_strength or self.panel_pulse_strength);
			
			-- header
			local uic_header = find_uicomponent(uic_stats, "parchment_divider_title");
			if uic_header then
				pulse_uicomponent(uic_header, value, pulse_strength or self.panel_pulse_strength);
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_faction_summary_statistics_tab(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_faction_summary_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_fightiness_bar
--- @desc Highlights the fightiness bar. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_fightiness_bar(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local cm = self.cm;
	local uic_character_info_panel = find_uicomponent(core:get_ui_root(), "CharacterInfoPopup");
	
	if uic_character_info_panel and uic_character_info_panel:Visible(true) then
		pulse_strength = pulse_strength or self.panel_pulse_strength;
	
		pulse_uicomponent(find_uicomponent(uic_character_info_panel, "morale_container"), value, pulse_strength);
		pulse_uicomponent(find_uicomponent(uic_character_info_panel, "icon_waaargh"), value, pulse_strength);
		pulse_uicomponent(find_uicomponent(uic_character_info_panel, "frame"), value, pulse_strength);
		pulse_uicomponent(find_uicomponent(uic_character_info_panel, "icon_animosity"), value, pulse_strength);
		pulse_uicomponent(find_uicomponent(uic_character_info_panel, "threshold_lowest"), value, pulse_strength);
		pulse_uicomponent(find_uicomponent(uic_character_info_panel, "threshold_lower"), value, pulse_strength);
		pulse_uicomponent(find_uicomponent(uic_character_info_panel, "threshold_upper"), value, pulse_strength);
		pulse_uicomponent(find_uicomponent(uic_character_info_panel, "background_morale_bar"), value, pulse_strength);
		pulse_uicomponent(find_uicomponent(uic_character_info_panel, "foreground_morale_bar"), value, pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_fightiness_bar(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;

--- @function highlight_fleet_office_button
--- @desc Highlights the fleet office button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_fleet_office_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_offices");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_fleet_office_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;



--- @function highlight_fleet_office_panel
--- @desc Highlights the fleet office panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_fleet_office_panel(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_panel = find_child_uicomponent(core:get_ui_root(), "offices");
			
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength);
		
		local uic_header = find_uicomponent(uic_panel, "header_frame");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		local uic_header_panel = find_uicomponent(uic_panel, "panel_back");
		if uic_header_panel then
			pulse_uicomponent(uic_header_panel, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		local uic_portrait_list = find_uicomponent(uic_panel, "portrait_holder");
		
		for i = 0, uic_portrait_list:ChildCount() - 1 do
			local uic_child = UIComponent(uic_portrait_list:Find(i));
			
			pulse_uicomponent(uic_child, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		local uic_office_panel = find_uicomponent(uic_panel, "offices_panel");
		if uic_office_panel then
			pulse_uicomponent(uic_office_panel, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		local uic_lords_panel = find_uicomponent(uic_panel, "lords_panel");
		if uic_lords_panel then
			pulse_uicomponent(uic_lords_panel, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		local uic_offices_subtitle_panel = find_uicomponent(uic_panel, "offices_panel", "panel_subtitle");
		if uic_offices_subtitle_panel then
			pulse_uicomponent(uic_offices_subtitle_panel, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		local uic_lords_subtitle_panel = find_uicomponent(uic_panel, "lords_panel", "panel_subtitle");
		if uic_lords_subtitle_panel then
			pulse_uicomponent(uic_lords_subtitle_panel, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		local uic_button = find_uicomponent(uic_panel, "button_ok");
		if uic_button then
			pulse_uicomponent(uic_button, value, pulse_strength or self.panel_pulse_strength);
		end;
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_fleet_office_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
		
	elseif not do_not_highlight_upstream then
		self:highlight_fleet_office_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_food
--- @desc Highlights the food indicator on the top bar of the campaign interface. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_food(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_food(false, pulse_strength, force_highlight) end);
	end;
	return highlight_visible_component(value, true, "hud_campaign", "resources_bar", "dy_food");
end;


--- @function highlight_food_bar
--- @desc Highlights the food bar. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_food_bar(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_food = find_uicomponent(core:get_ui_root(), "skv_food_holder", "visibility_holder");
	
	if uic_food and uic_food:Visible(true) then
		-- food icon
		local uic_icon = find_uicomponent(uic_food, "icon");
		
		if uic_icon and uic_icon:Visible(true) then
			pulse_uicomponent(uic_icon, value, pulse_strength or self.button_pulse_strength);
		end;
		
		-- frame
		local uic_frame = find_uicomponent(uic_food, "frame");
		
		if uic_frame and uic_frame:Visible(true) then
			pulse_uicomponent(uic_frame, value, pulse_strength or self.button_pulse_strength);
		end;
		
		-- current holder
		local uic_current_holder = find_uicomponent(uic_frame, "skv_food_current", "current_holder");
		
		if uic_current_holder and uic_current_holder:Visible(true) then
			pulse_uicomponent(uic_current_holder, value, pulse_strength or self.button_pulse_strength);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_food_bar(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	end;
	
	return false;
end;


--- @function highlight_forces_list
--- @desc Highlights the forces drop-down list. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_forces_list(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "radar_things", "dropdown_units", "panel");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.panel_pulse_strength, true);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_forces_list(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_list_button_forces(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_forging_magic_items_button
--- @desc Highlights the forging magic items button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_forging_magic_items_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if cm:get_faction(cm:get_local_faction_name(true)):culture() ~= "wh_main_dwf_dwarfs" then
		return false;
	end;

	local uic_button = find_uicomponent(core:get_ui_root(), "faction_buttons_docker", "button_mortuary_cult");
		
	if uic_button and uic_button:Visible(true) then
		pulse_uicomponent(uic_button, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_forging_magic_items_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_forging_magic_items_panel
--- @desc Highlights the forging magic items panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_forging_magic_items_panel(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if cm:get_faction(cm:get_local_faction_name(true)):culture() ~= "wh_main_dwf_dwarfs" then
		return false;
	end;
	
	local uic_panel = find_child_uicomponent(core:get_ui_root(), "mortuary_cult");
		
	if uic_panel and uic_panel:Visible(true) then	
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength);
		
		local uic_title = find_uicomponent(uic_panel, "panel_title");
		if uic_title then
			pulse_uicomponent(uic_title, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		local uic_resources_list = find_uicomponent(uic_panel, "list_resources");
		if uic_resources_list then
			pulse_uicomponent(uic_resources_list, value, pulse_strength or self.panel_pulse_strength);
			--[[
			for i = 0, uic_resources_list:ChildCount() - 1 do
				local uic_resource = UIComponent(uic_resources_list:Find(i));				
				pulse_uicomponent(uic_resource, value, pulse_strength or self.panel_pulse_strength, false, uic_resource:CurrentState());
			end;
			]]		
		end;
		
		local uic_header_list = find_uicomponent(uic_panel, "header_list");
		if uic_header_list then
			pulse_uicomponent(uic_header_list, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		local uic_crafting_list = find_uicomponent(uic_panel, "listview", "list_box");
		if uic_crafting_list then
			pulse_uicomponent(uic_crafting_list, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_forging_magic_items_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		return self:highlight_forging_magic_items_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;

--- @function highlight_gardens_of_morr
--- @desc Highlights the Gardens of Morr. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_gardens_of_morr(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "dlc25_black_towers");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_gardens_of_morr(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_black_tower");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_gardens_of_morr(false) end);
			end;
		end;
	end;
end;


--- @function highlight_garrison_armies
--- @desc Highlights garrison army unit cards on the army panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_garrison_armies(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_button = find_uicomponent(ui_root, "hud_campaign", "hud_center", "button_group_settlement", "button_show_garrison");
		
	if uic_button and uic_button:Visible(true) and (uic_button:CurrentState() == "selected" or uic_button:CurrentState() == "selected_down") then
		pulse_strength = self.panel_pulse_strength or self.panel_pulse_strength;
		
		local uic_panel = find_uicomponent(ui_root, "settlement_panel", "main_settlement_panel");
		if uic_panel then
			for i = 0, uic_panel:ChildCount() - 1 do
				local uic_settlement = UIComponent(uic_panel:Find(i));
				
				local uic_land_units_frame = find_uicomponent(uic_settlement, "garrison_list", "land_units_frame");
				if uic_land_units_frame then
					for j = 0, uic_land_units_frame:ChildCount() - 1 do
						pulse_uicomponent(UIComponent(uic_land_units_frame:Find(j)), value, pulse_strength);
					end;
				end;
			end;		
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_garrison_armies(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_garrison_details_button(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_garrison_details_button
--- @desc Highlights the garrison details button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_garrison_details_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center", "button_group_settlement", "button_show_garrison");
		
	if uic and uic:Visible(true) and is_fully_onscreen(uic) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_garrison_details_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_settlements(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_geomantic_web_button
--- @desc Highlights the geomantic web button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_geomantic_web_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_geomantic_web");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_geomantic_web_button(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	end;
	
	return false;
end;


--- @function highlight_global_recruitment_pool
--- @desc Highlights the global recruitment pool on the recruitment panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_global_recruitment_pool(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_pool = find_uicomponent(core:get_ui_root(), "main_units_panel", "recruitment_options", "recruitment_listbox", "global");
	if not (uic_pool and uic_pool:Visible(true)) then
		-- see if the minimised pool is visible
		uic_pool = find_uicomponent(core:get_ui_root(), "main_units_panel", "recruitment_options", "recruitment_listbox", "global_min");
	end;
	
	if uic_pool and uic_pool:Visible(true) then
		pulse_uicomponent(uic_pool, value, pulse_strength or self.panel_pulse_strength);
		
		local uic_header = find_uicomponent(uic_pool, "tx_header");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		local uic_capacity = find_uicomponent(uic_pool, "capacity_listview");
		if uic_capacity then
			pulse_uicomponent(uic_capacity, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_global_recruitment_pool(false, pulse_strength, force_highlight) end);
		end;
		return true;	
	elseif not do_not_highlight_upstream then
		return self:highlight_recruitment_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_gods_bar
--- @desc Highlights the gods bar. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_gods_bar(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar", "norsca_gods_frame");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_gods_bar(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_growth
--- @desc Highlights the growth section of the province info panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_growth(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "frame_growth");
	
	-- if uic and uic:Visible(true) and is_fully_onscreen(uic) then -->> is_fully_onscreen(uic) not working as expected
	if uic and uic:Visible(true) then
		
		-- header
		local uic_header = find_uicomponent(uic, "header_frame");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength or self.panel_pulse_strength);
		end;

		-- row
		local uic_row = find_uicomponent(uic, "row_holder");
		if uic_row then
			pulse_uicomponent(uic_row, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_growth(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_settlements(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_grudges_bar
--- @desc Highlights the grudges bar. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_grudges_bar(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "resources_bar", "grudge_bar");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or 8, true);
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_grudges_bar(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_grudges_button
--- @desc Highlights the grudges button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_grudges_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_grudges");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_grudges_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_hellforge
--- @desc Highlights the Chaos Dwarfs Hell-forge. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_hellforge(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "hellforge_panel_main");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_hellforge(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_hellforge");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_hellforge(false) end);
			end;
		end;
	end;
end;


--- @function highlight_help_pages_button
--- @desc Highlights the help pages button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_help_pages_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "menu_bar", "buttongroup", "button_help_panel");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_help_pages_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
end;


--- @function highlight_heroes
--- @desc Highlights any visible heroes on the campaign map. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] string faction key, Target faction key. Can be omitted to highlight armies for all factions.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_heroes(value, target_faction, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	if value then
		if target_faction then
			self:highlight_all_heroes_near_camera(true, 30, function(character) return character:faction():name() == target_faction end);
		else
			self:highlight_all_heroes_near_camera(true, 30);
		end;
		table.insert(self.unhighlight_action_list, function() self:highlight_heroes(false, false, pulse_strength, force_highlight) end);
	else
		self:highlight_all_heroes_near_camera(false);
	end;
end;


--- @function highlight_hero_deployment_button
--- @desc Highlights the hero deployment button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_hero_deployment_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center", "small_bar", "button_deploy_agent");	

	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_hero_deployment_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_heroes(value, cm:get_local_faction_name(true), pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_hero_recruitment_panel
--- @desc Highlights the hero recruitment panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_hero_recruitment_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	-- query the state of the recruit hero button to determine if the panel is visible
	local uic_recruit_hero_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center", "button_group_settlement", "button_agents");
	local uic_recruit_hero_button_horde = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center", "button_group_army_settled", "button_agents");
	
	local button_selected_test = function(uic)
		return uic and (uic:CurrentState() == "selected" or uic:CurrentState() == "selected_down");
	end;
	
	if button_selected_test(uic_recruit_hero_button) or button_selected_test(uic_recruit_hero_button_horde) then
		-- background panel
		local uic_character_panel = find_uicomponent(core:get_ui_root(), "character_panel");

		pulse_strength = pulse_strength or self.panel_pulse_strength;
	
		if uic_character_panel then
			pulse_uicomponent(uic_character_panel, value, pulse_strength);
		end;
		
		-- title
		local uic_title = find_uicomponent(uic_character_panel, "title_plaque");
		if uic_title then
			pulse_uicomponent(uic_title, value, pulse_strength, true);
		end;
		
		-- subframe
		local uic_frame = find_uicomponent(uic_character_panel, "subframe");
		if uic_frame then
			pulse_uicomponent(uic_frame, value, pulse_strength);
		end;
		
		-- no candidates panel
		local uic_no_candidates_panel = find_uicomponent(uic_character_panel, "no_candidates_panel");
		if uic_no_candidates_panel then
			pulse_uicomponent(uic_no_candidates_panel, value, pulse_strength);
		end;
		
		-- province_cycle
		local uic_province_cycle = find_uicomponent(uic_character_panel, "province_cycle");
		if uic_province_cycle then
			pulse_uicomponent(uic_province_cycle, value, pulse_strength, true);
		end;
		
		-- recruit button
		local uic_recruit_button = find_uicomponent(uic_character_panel, "button_confirm");
		if uic_recruit_button then
			pulse_uicomponent(uic_recruit_button, value, pulse_strength);
		end;
		
		-- character list
		local uic_char_list = find_uicomponent(uic_character_panel, "general_selection_panel", "character_list");
		if uic_char_list then
			pulse_uicomponent(uic_char_list, value, pulse_strength, true);
		end;

		if value then
			self:highlight_hero_recruitment_panel_tab_buttons(value, pulse_strength, force_highlight);
			table.insert(self.unhighlight_action_list, function() self:highlight_hero_recruitment_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_recruit_hero_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_hero_recruitment_panel_tab_buttons
--- @desc Highlights the hero recruitment panel tab buttons. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_hero_recruitment_panel_tab_buttons(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "character_panel", "lords_and_agents_holder", "agent_parent", "list_box");	

	if uic and uic:Visible(true) then
		for i = 0, uic:ChildCount() - 1 do
			local uic_child = UIComponent(uic:Find(i));
			pulse_uicomponent(uic_child, value, pulse_strength or self.button_pulse_strength - 2, true);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_hero_recruitment_panel_tab_buttons(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_recruit_hero_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_horde_growth
--- @desc Highlights horde growth. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_horde_growth(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_panel = find_uicomponent(ui_root, "horde_growth");
	
	if uic_panel and uic_panel:Visible(true) then	
		pulse_strength = pulse_strength or self.panel_pulse_strength;
	
		pulse_uicomponent(uic_panel, value, pulse_strength);
		
		local uic_frame = find_uicomponent(uic_panel, "frame_growth");
		if uic_frame then
			pulse_uicomponent(uic_frame, value, pulse_strength);
		end;
		
		local uic_header = find_uicomponent(uic_panel, "header_frame");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_horde_growth(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
end;


--- @function highlight_horde_buildings
--- @desc Highlights horde buildings. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_horde_buildings(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_tab = find_uicomponent(ui_root, "units_panel", "main_units_panel", "tabgroup", "tab_horde_buildings");
	
	if uic_tab and uic_tab:Visible(true) and uic_tab:CurrentState() == "selected" then
		local uic_settlements = find_uicomponent(ui_root, "units_panel", "main_units_panel", "horde_building_frame", "horde_slot_list");
		
		pulse_uicomponent(uic_settlements, value, pulse_strength or self.button_pulse_strength, true);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_horde_buildings(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_building_panel_tab(value, pulse_strength, force_highlight);
	end;
end;


--- @function highlight_imperial_gunnery_school
--- @desc Highlights the Imperial Gunnery School. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_imperial_gunnery_school(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "dlc25_don_main");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_imperial_gunnery_school(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_districts_of_nuln");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_imperial_gunnery_school(false) end);
			end;
		end;
	end;
end;


--- @function highlight_infamy
--- @desc Highlights the infamy indicator. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_infamy(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_infamy(false, pulse_strength, force_highlight) end);
	end;
	return highlight_visible_component(value, true, "hud_campaign", "resources_bar", "infamy_holder");
end;


--- @function highlight_influence
--- @desc Highlights the influence indicator on the top bar of the campaign interface. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_influence(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_influence(false, pulse_strength, force_highlight) end);
	end;
	return highlight_visible_component(value, true, "hud_campaign", "resources_bar", "dy_intrigue");
end;


--- @function highlight_interventions
--- @desc Highlights the interventions button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_interventions(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "toggle_interrupt_button");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_interventions(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	end;
	
	return false;
end;


--- @function highlight_intrigue_at_the_court_button
--- @desc Highlights the intrigue at the court button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_intrigue_at_the_court_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_intrigue");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_intrigue_at_the_court_button(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	end;
	
	return false;
end;


--- @function highlight_intrigue_at_the_court_panel
--- @desc Highlights the intrigue at the court panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_intrigue_at_the_court_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "intrigue_panel");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_intrigue_at_the_court_panel(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	else
		self:highlight_intrigue_at_the_court_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_legendary_knight_button
--- @desc Highlights the Legendary Knight button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_legendary_knight_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_spawn_unique_agent");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_legendary_knight_button(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	end;
	
	return false;
end;


--- @function highlight_list_button_events
--- @desc Highlights the events list button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_list_button_events(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "bar_small_top", "tab_events");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_list_button_events(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_list_button_factions
--- @desc Highlights the factions list button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_list_button_factions(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "bar_small_top", "tab_factions");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_list_button_factions(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_list_button_forces
--- @desc Highlights the forces list button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_list_button_forces(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "bar_small_top", "tab_units");
			
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_list_button_forces(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_list_button_missions
--- @desc Highlights the missions list button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_list_button_missions(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "bar_small_top", "tab_missions");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_list_button_missions(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_list_button_provinces
--- @desc Highlights the provinces list button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_list_button_provinces(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "bar_small_top", "tab_regions");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_list_button_provinces(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_local_recruitment_pool
--- @desc Highlights the local recruitment pool on the recruitment panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_local_recruitment_pool(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_pool = find_uicomponent(core:get_ui_root(), "main_units_panel", "recruitment_options", "recruitment_listbox", "local1");
	
	if uic_pool and uic_pool:Visible(true) then
		pulse_uicomponent(uic_pool, value, pulse_strength or self.panel_pulse_strength);
		
		local uic_header = find_uicomponent(uic_pool, "tx_header");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		local uic_capacity = find_uicomponent(uic_pool, "capacity_listview");
		if uic_capacity then
			pulse_uicomponent(uic_capacity, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_local_recruitment_pool(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	elseif not do_not_highlight_upstream then
		return self:highlight_recruitment_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_lords
--- @desc Highlights lords on the pre-battle screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_lords(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	self:highlight_lords_pre_battle_screen(value, pulse_strength, force_highlight);
end;


--- @function highlight_lords_pre_battle_screen
--- @desc Highlights lords on the pre-battle screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean reinforcements only, Only highlights reinforcement lords.
function campaign_ui_manager:highlight_lords_pre_battle_screen(value, pulse_strength, force_highlight, reinforcements_only)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local start_index = 0;
	
	if reinforcements_only then
		start_index = 1;	-- start iterating at 1, which is the second army
	end;
	
	pulse_strength = pulse_strength or self.button_pulse_strength;

	local ui_root = core:get_ui_root();
	local uic_allied_army_list = find_uicomponent(ui_root, "popup_pre_battle", "allies_combatants_panel", "army", "army_list");
	
	if uic_allied_army_list and uic_allied_army_list:Visible(true) then
		for i = start_index, uic_allied_army_list:ChildCount() - 1 do			
			local uic_army = UIComponent(uic_allied_army_list:Find(i));
			
			local uic_button = find_uicomponent(uic_army, "button_select");
			if uic_button then
				pulse_uicomponent(uic_button, value, pulse_strength);
			end;
		end;
	end;
	
	local uic_enemy_army_list = find_uicomponent(ui_root, "popup_pre_battle", "enemy_combatants_panel", "army", "army_list");
	
	if uic_enemy_army_list and uic_enemy_army_list:Visible(true) then
		for i = start_index, uic_enemy_army_list:ChildCount() - 1 do
			local uic_army = UIComponent(uic_enemy_army_list:Find(i));
			
			local uic_button = find_uicomponent(uic_army, "button_select");
			if uic_button then
				pulse_uicomponent(uic_button, value, pulse_strength);
			end;
		end;
	end;
	
	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_lords_pre_battle_screen(false, pulse_strength, force_highlight, reinforcements_only) end);
	end;
end;



--- @function highlight_malakais_adventures
--- @desc Highlights the malakai's adventures. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_malakais_adventures(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "dlc25_malakai_oaths");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_malakais_adventures(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "resources_bar_holder", "resources_bar", "dwf_malakai_adventures", "button_diamond");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_malakais_adventures(false) end);
			end;
		end;
	end;
end;



--- @function highlight_military_convoys
--- @desc Highlights the Chaos Dwarfs Hell-forge. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_military_convoys(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "military_convoys");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_military_convoys(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_convoys");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_military_convoys(false) end);
			end;
		end;
	end;
end;


--- @function highlight_missions_list
--- @desc Highlights the missions list. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_missions_list(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic = find_uicomponent(ui_root, "objectives_screen", "tab_missions");
	
	if uic and uic:Visible(true) then
		-- Highlight mission tab
		pulse_uicomponent(uic, value, pulse_strength or self.panel_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_missions_list(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		-- Highlight objectives button
		local uic_objectives_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_missions");
		if uic_objectives_button and uic_objectives_button:Visible(true) then
			pulse_uicomponent(uic_objectives_button, value, pulse_strength or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_missions_list(false) end);
			end;
		end;
	end;
	
	return false;
end;


--- @function highlight_monstrous_arcanum_button
--- @desc Highlights the monstrous arcanum button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_monstrous_arcanum_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_monsters");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_monstrous_arcanum_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_mortuary_cult_button
--- @desc Highlights the mortuary cult button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_mortuary_cult_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if cm:get_faction(cm:get_local_faction_name(true)):culture() ~= "wh2_dlc09_tmb_tomb_kings" then
		return false;
	end;

	local uic_button = find_uicomponent(core:get_ui_root(), "faction_buttons_docker", "button_mortuary_cult");
		
	if uic_button and uic_button:Visible(true) then
		pulse_uicomponent(uic_button, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_mortuary_cult_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_mortuary_cult_panel
--- @desc Highlights the mortuary cult panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_mortuary_cult_panel(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if cm:get_faction(cm:get_local_faction_name(true)):culture() ~= "wh2_dlc09_tmb_tomb_kings" then
		return false;
	end;
	
	local uic_panel = find_child_uicomponent(core:get_ui_root(), "mortuary_cult");
		
	if uic_panel and uic_panel:Visible(true) then	
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength);
		
		local uic_title = find_uicomponent(uic_panel, "panel_title");
		if uic_title then
			pulse_uicomponent(uic_title, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		local uic_resources_list = find_uicomponent(uic_panel, "list_resources");
		if uic_resources_list then
			pulse_uicomponent(uic_resources_list, value, pulse_strength or self.panel_pulse_strength);
			--[[
			for i = 0, uic_resources_list:ChildCount() - 1 do
				local uic_resource = UIComponent(uic_resources_list:Find(i));				
				pulse_uicomponent(uic_resource, value, pulse_strength or self.panel_pulse_strength, false, uic_resource:CurrentState());
			end;
			]]		
		end;
		
		local uic_header_list = find_uicomponent(uic_panel, "header_list");
		if uic_header_list then
			pulse_uicomponent(uic_header_list, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		local uic_crafting_list = find_uicomponent(uic_panel, "listview", "list_box");
		if uic_crafting_list then
			pulse_uicomponent(uic_crafting_list, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_mortuary_cult_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		return self:highlight_mortuary_cult_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_movement_range
--- @desc Highlights the movement range indicator on the character info panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_movement_range(value, pulse_strength, force_highlight, do_not_highlight_armies)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_character_info_panel = find_uicomponent(core:get_ui_root(), "CharacterInfoPopup");
	
	if uic_character_info_panel and uic_character_info_panel:Visible(true) then
		local panel_pulse_strength = self.panel_pulse_strength;
		
		local uic_ap_bar = find_uicomponent(uic_character_info_panel, "ap_bar");
		if uic_ap_bar then
			pulse_uicomponent(uic_ap_bar, value, pulse_strength or self.panel_pulse_strength);
		end;
			
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_movement_range(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_armies then
		self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_oathgold
--- @desc Highlights oathgold indicator. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_oathgold(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	local faction = cm:get_faction(cm:get_local_faction_name(true)) 
	if faction and faction:culture() == "wh_main_dwf_dwarfs" then
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_oathgold(false, pulse_strength, force_highlight) end);
		end;
		return highlight_visible_component(value, true, "hud_campaign", "resources_bar", "canopic_jars_holder");
	end
end;


--- @function highlight_objectives_button
--- @desc Highlights the objectives button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_objectives_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_missions");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_objectives_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_objectives_panel
--- @desc Highlights the objectives panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_objectives_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_screen = find_uicomponent(core:get_ui_root(), "objectives_screen");
	
	if uic_screen and uic_screen:Visible(true) then
		local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
		pulse_uicomponent(uic_screen, value, pulse_strength_to_use);
		
		-- title
		local uic_title = find_uicomponent(uic_screen, "objectives_screen");
		if uic_title then
			pulse_uicomponent(uic_title, value, pulse_strength_to_use, true);
		end;
		
		-- parchment
		local uic_parchment = find_uicomponent(uic_screen, "objectives_screen");
		if uic_parchment then
			pulse_uicomponent(uic_parchment, value, pulse_strength_to_use);
		end;
		
		if value then
			self:highlight_objectives_panel_chapter_missions(value, pulse_strength, force_highlight);
			table.insert(self.unhighlight_action_list, function() self:highlight_objectives_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_objectives_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_objectives_panel_chapter_missions
--- @desc Highlights the chapter missions tab on the objectives panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_objectives_panel_chapter_missions(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local uic = find_uicomponent(ui_root, "objectives_screen", "tab_chapters");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_objectives_panel_chapter_missions(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_objectives_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_objectives_panel_victory_conditions
--- @desc Highlights the victory conditions tab on the objectives panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_objectives_panel_victory_conditions(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic = find_uicomponent(ui_root, "objectives_screen", "tab_victory_conditions");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_objectives_panel_victory_conditions(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_objectives_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_offices
--- @desc Highlights the offices panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_offices(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_screen = find_uicomponent(core:get_ui_root(), "offices");
	
	if uic_screen and uic_screen:Visible(true) then
		pulse_strength = pulse_strength or self.panel_pulse_strength - 2;
		
		-- offices panel
		local uic_offices_panel = find_uicomponent(uic_screen, "main", "offices_panel");
		if uic_offices_panel then
			pulse_uicomponent(uic_offices_panel, value, pulse_strength);
		end;
		
		-- offices header
		local uic_offices_header = find_uicomponent(uic_screen, "offices_panel", "title_holder");
		if uic_offices_header then			
			pulse_uicomponent(uic_offices_header, value, pulse_strength, true);
		end;
		
		-- backing
		local uic_panel_back = find_uicomponent(uic_screen, "panel_frame", "panel_back");
		if uic_panel_back then
			pulse_uicomponent(uic_panel_back, value, pulse_strength);
		end;
		
		-- lords section
		local uic_lords_panel = find_uicomponent(uic_screen, "lords_panel");
		if uic_lords_panel then			
			pulse_uicomponent(uic_lords_panel, value, pulse_strength);
		end;
		
		-- lords header
		local uic_lords_header = find_uicomponent(uic_screen, "lords_panel", "title_holder");
		if uic_lords_header then			
			pulse_uicomponent(uic_lords_header, value, pulse_strength, true);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_offices(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		return self:highlight_offices_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_offices_button
--- @desc Highlights the offices button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_offices_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_offices");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_offices_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_peasants
--- @desc Highlights peasants. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_peasants(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_peasants(false, pulse_strength, force_highlight) end);
	end;
	return highlight_visible_component(value, true, "hud_campaign", "resources_bar", "dy_peasants");
end;


--- @function highlight_per_turn_income
--- @desc Highlights the per-turn income indicator. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_per_turn_income(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_per_turn_income(false, pulse_strength, force_highlight) end);
	end;
	return highlight_visible_component(value, true, "hud_campaign", "resources_bar", "dy_income");
end;

--- @function highlight_pieces_of_eight_button
--- @desc Highlights the Pieces of Eight button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_pieces_of_eight_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_treasure_hunts");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_pieces_of_eight_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_pieces_of_eight_panel
--- @desc Highlights the pieces of eight panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_pieces_of_eight_panel(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_panel = find_child_uicomponent(core:get_ui_root(), "treasure_hunts");
	
	if uic_panel and uic_panel:Visible(true) then
		-- panel is visible
		
		local uic_button_pieces_of_eight = find_uicomponent(uic_panel, "pieces");
		
		if uic_button_pieces_of_eight and (uic_button_pieces_of_eight:CurrentState() == "selected"  or uic_button_pieces_of_eight:CurrentState() == "selected_down") then
			-- panel is visible and on the POE tab - highlight panel
			pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength);
		
			local uic_pieces_of_eight_objective = find_uicomponent(uic_panel, "pieces", "list_box", "objective");
			local uic_pieces_of_eight_zoom = find_uicomponent(uic_panel, "pieces", "list_box", "button_zoom");

			pulse_uicomponent(uic_pieces_of_eight_objective, value, pulse_strength or self.panel_pulse_strength, false);
			pulse_uicomponent(uic_pieces_of_eight_zoom, value, pulse_strength or self.panel_pulse_strength, false);
			
			local uic_pieces_of_eight_map_pieces = find_uicomponent(uic_panel, "pieces", "map", "wh2_dlc11_mission_piece_of_eight_1");
			for i = 1, 7 do
				uic_pieces_of_eight_map_pieces = find_uicomponent(uic_panel, "pieces", "map", "wh2_dlc11_mission_piece_of_eight_"..i);
				pulse_uicomponent(uic_pieces_of_eight_map_pieces, value, pulse_strength or self.panel_pulse_strength, false);
			end
		else
			-- panel is visible but not on the POE tab - highlight tab button
			pulse_uicomponent(uic_button_pieces_of_eight, value, pulse_strength or self.panel_pulse_strength, false);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_pieces_of_eight_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
		
	elseif not do_not_highlight_upstream then
		-- panel is not visible - highlight button
		self:highlight_pieces_of_eight_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_pirate_coves
--- @desc Highlights any visible port settlements with pirate coves. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] string faction key, Target faction key. Can be omitted to highlight armies for all factions.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_pirate_coves(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_panel = find_uicomponent(core:get_ui_root(), "settlement_panel");
	

	if uic_panel and uic_panel:Visible(true) then
		local uic_main_settlement_panel = find_uicomponent(uic_panel, "main_settlement_panel");
		
		for i = 0, uic_main_settlement_panel:ChildCount() - 1 do
			local uic_child = UIComponent(uic_main_settlement_panel:Find(i));
			local uic_pirate_cove = find_uicomponent(uic_child, "pirates_cove");

			
			if uic_pirate_cove and uic_pirate_cove:Visible(true) then
				pulse_uicomponent(uic_pirate_cove, value, pulse_strength or self.panel_pulse_strength, true);
		
				if value then
					table.insert(self.unhighlight_action_list, function() self:highlight_pirate_coves(false, pulse_strength, force_highlight) end);
				end;
				
			end
		end;
	else
		-- When we can detect pirate coves we need to add a check and then use this
		local regions = cm:model():world():region_manager():region_list();
	
		local highlight_action = false;
		if value then
			highlight_action = self.highlight_settlement;
		else
			highlight_action = self.unhighlight_settlement;
		end
		
		for j = 0, regions:num_items() - 1 do
			
			if regions:item_at(j):foreign_slot_manager_for_faction(cm:get_local_faction_name(true)):is_null_interface() == false then
				highlight_action(self, regions:item_at(j):settlement():key());
			end;
			
		end
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_pirate_coves(false, pulse_strength, force_highlight) end);
		end;
	end
end;




--- @function highlight_ports
--- @desc Highlights any visible port settlements. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] string faction key, Target faction key. Can be omitted to highlight ports for all factions.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_ports(value, target_faction, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	if value then
		if target_faction then
			self:highlight_all_settlements_near_camera(true, 30, function(settlement) return settlement:is_port() and settlement:faction():name() == target_faction end);
		else
			self:highlight_all_settlements_near_camera(true, 30, function(settlement) return settlement:is_port() end);
		end;
		table.insert(self.unhighlight_action_list, function() self:highlight_settlements(false, pulse_strength, force_highlight) end);
	else
		self:highlight_all_settlements_near_camera(false, pulse_strength, force_highlight);
	end;
end;


--- @function highlight_post_battle_options
--- @desc Highlights post battle option buttons. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_post_battle_options(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_panel = find_uicomponent(core:get_ui_root(), "popup_battle_results", "mid");
	
	pulse_strength = pulse_strength or self.button_pulse_strength;
	
	if uic_panel and uic_panel:Visible(true) then
		local uic_button_set_settlement_captured = find_uicomponent(uic_panel, "button_set_settlement_captured");
		if uic_button_set_settlement_captured then
			for i = 0, uic_button_set_settlement_captured:ChildCount() - 1 do
				local uic_child = UIComponent(uic_button_set_settlement_captured:Find(i));
				pulse_uicomponent(uic_child, value, pulse_strength, true);
			end;
		end;
			
		local uic_button_set_win = find_uicomponent(uic_panel, "button_set_win");
		if uic_button_set_win then
			for i = 0, uic_button_set_win:ChildCount() - 1 do
				local uic_child = UIComponent(uic_button_set_win:Find(i));
				pulse_uicomponent(uic_child, value, pulse_strength, true);
			end;
		end;
		
		local uic_button_dismiss = find_uicomponent(uic_panel, "battle_results", "button_dismiss_holder", "button_dismiss");
		if uic_button_dismiss then
			pulse_uicomponent(uic_button_dismiss, value, pulse_strength, true);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_post_battle_options(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	-- options on settlement captured panel
	local uic_settlement_captured_container = find_uicomponent(core:get_ui_root(), "settlement_captured", "button_parent");
	
	if uic_settlement_captured_container and uic_settlement_captured_container:Visible() then
		for i = 0, uic_settlement_captured_container:ChildCount() - 1 do
			local uic_button = find_uicomponent(UIComponent(uic_settlement_captured_container:Find(i)), "option_button");
			if uic_button then
				pulse_uicomponent(uic_button, value, pulse_strength, true);
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_post_battle_options(false, pulse_strength, force_highlight) end);
		end;
	end;
	
	return false;
end;


--- @function highlight_post_battle_options_for_click
--- @desc Highlights post battle option buttons for clicking. This function works differently to other functions in this section as it highlights the post-battle options with a square highlight indicating that they should be clicked on. It also waits until the post_battle_panel is in position before activating the highlight.
--- @desc Unlike other functions in this section this highlight should be disabled by calling this function again with <code>false</code> as a single argument.
--- @p [opt=false] boolean show highlight
function campaign_ui_manager:highlight_post_battle_options_for_click(value)	
	if value then
		
		-- check that the component is on-screen and not animating		
		local uic_panel = find_uicomponent(core:get_ui_root(), "popup_battle_results", "mid");
	
		if not uic_panel or (not (uic_panel:Visible() and is_fully_onscreen(uic_panel) and uic_panel:CurrentAnimationId() == "")) then
		
			-- component has not come to rest on-screen, defer this call
			self.cm:callback(function() self:highlight_post_battle_options_for_click(value) end, 0.2, "highlight_post_battle_options_for_click");
			return;
		end;
		
		-- try and highlight the settlement captured button set
		local uic_button_set_settlement_captured = find_uicomponent(uic_panel, "button_set_settlement_captured");
		if uic_button_set_settlement_captured and uic_button_set_settlement_captured:Visible(true) then
			highlight_all_visible_children(uic_button_set_settlement_captured, 5);
		end;
		
		-- try and highlight the field battle victory button set
		local uic_button_set_win = find_uicomponent(uic_panel, "button_set_win");
		if uic_button_set_win and uic_button_set_win:Visible(true) then
			highlight_all_visible_children(uic_button_set_win, 5);
		end;
		
		-- try and highlight the dismiss button
		local uic_button_dismiss = find_uicomponent(uic_panel, "battle_results", "button_dismiss_holder", "button_dismiss");
		if uic_button_dismiss and uic_button_dismiss:Visible(true) then
			highlight_all_visible_children(UIComponent(uic_button_dismiss:Parent()), 5);
		end;		
	else
		self.cm:remove_callback("highlight_post_battle_options_for_click");
		unhighlight_all_visible_children();
	end;
end;


--- @function highlight_post_battle_panel
--- @desc Highlights the post battle panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_post_battle_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	local uic_panel = find_uicomponent(ui_root, "popup_battle_results", "mid", "battle_results");
	
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength);
		
		-- title
		local uic_title = find_uicomponent(ui_root, "popup_battle_results", "mid", "battle_results", "title_plaque");
		if uic_title then
			pulse_uicomponent(uic_title, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_post_battle_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_post_battle_panel_unit_cards
--- @desc Highlights unit cards on the post battle panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean unit types only, Only highlights the unit type indicator on each card instead of the whole card.
--- @p [opt=false] boolean unit experience only, Only highlights the unit experience indicator on each card instead of the whole card.
--- @p [opt=false] boolean unit banners only, Only highlights unit banners on each card instead of the whole card.
function campaign_ui_manager:highlight_post_battle_panel_unit_cards(value, pulse_strength, force_highlight, highlight_unit_types, highlight_experience, highlight_banners)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	self:highlight_pre_battle_panel_unit_cards(value, pulse_strength, force_highlight, true, highlight_unit_types, highlight_experience, highlight_banners);
end;


--- @function highlight_pre_battle_options
--- @desc Highlights unit cards on the pre-battle panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_pre_battle_options(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local cm = self.cm;
	local uic_deployment = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "battle_deployment", "regular_deployment");
	
	if uic_deployment and uic_deployment:Visible(true) then
		pulse_strength = pulse_strength or self.button_pulse_strength;
	
		-- button_set_attack
		local uic_button_set_attack = find_uicomponent(uic_deployment, "button_set_attack");
		if uic_button_set_attack then
			for i = 0, uic_button_set_attack:ChildCount() - 1 do
				local uic_child = UIComponent(uic_button_set_attack:Find(i));
				pulse_uicomponent(uic_child, value, pulse_strength, true);
			end;
		end;
		
		-- button_set_siege
		local uic_button_set_siege = find_uicomponent(uic_deployment, "button_set_siege");
		if uic_button_set_siege then
			for i = 0, uic_button_set_siege:ChildCount() - 1 do
				local uic_child = UIComponent(uic_button_set_siege:Find(i));
				pulse_uicomponent(uic_child, value, pulse_strength, true);
			end;
		end;
		
		-- button_set_mp
		local uic_button_set_mp = find_uicomponent(uic_deployment, "button_set_mp");
		if uic_button_set_mp then
			for i = 0, uic_button_set_mp:ChildCount() - 1 do
				local uic_child = UIComponent(uic_button_set_mp:Find(i));
				pulse_uicomponent(uic_child, value, pulse_strength, true);
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_pre_battle_options(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	end;
	
	return false;
end;


--- @function highlight_pre_battle_panel
--- @desc Highlights the pre-battle panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_pre_battle_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	local uic_battle_deployment = find_uicomponent(ui_root, "popup_pre_battle", "mid", "battle_deployment");
	
	if uic_battle_deployment and uic_battle_deployment:Visible(true) then
		local uic_panel = find_uicomponent(uic_battle_deployment, "regular_deployment", "battle_information_panel");
		if uic_panel and uic_panel:Visible() then
			pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		local uic_list = find_uicomponent(uic_battle_deployment, "list");
		if uic_list and uic_list:Visible() then
			pulse_uicomponent(uic_list, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		local uic_header = find_uicomponent(uic_battle_deployment, "common_ui_parent");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		local uic_title = find_uicomponent(uic_battle_deployment, "regular_deployment", "common_ui_parent", "panel_title");
		if uic_title then
			pulse_uicomponent(uic_title, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		local uic_info_button = find_uicomponent(uic_battle_deployment, "regular_deployment", "battle_information_panel", "button_info");
		if uic_info_button and uic_info_button:Visible() then
			pulse_uicomponent(uic_info_button, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		if value then
			self:highlight_balance_of_power_bar(value, pulse_strength, force_highlight);
			self:highlight_winds_of_magic(value, pulse_strength, force_highlight);
			table.insert(self.unhighlight_action_list, function() self:highlight_pre_battle_panel(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	else
		self:highlight_siege_panel(value, pulse_strength, force_highlight);		
	end;
	
	return false;
end;


--- @function highlight_pre_battle_panel_unit_cards
--- @desc Highlights unit cards on the pre-battle panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean is post-battle panel, sets whether this is actually the post-battle panel we are highlighting (@campaign_ui_manager:highlight_post_battle_panel_unit_cards sets this flag).
--- @p [opt=false] boolean unit types only, Only highlights the unit type indicator on each card instead of the whole card.
--- @p [opt=false] boolean unit experience only, Only highlights the unit experience indicator on each card instead of the whole card.
--- @p [opt=false] boolean unit banners only, Only highlights unit banners on each card instead of the whole card.
function campaign_ui_manager:highlight_pre_battle_panel_unit_cards(value, pulse_strength, force_highlight, is_post_battle_panel, highlight_unit_types, highlight_experience, highlight_banner)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	local panel_name = "popup_pre_battle";
	
	if is_post_battle_panel then
		panel_name = "popup_battle_results";
	end;
	
	local uic_allied_unit_list = find_uicomponent(ui_root, panel_name, "allies_combatants_panel", "army", "units_and_banners_parent", "units_window");
	
	if uic_allied_unit_list and uic_allied_unit_list:Visible(true) then
		local button_pulse_strength = pulse_strength or self.button_pulse_strength;
		local panel_pulse_strength = pulse_strength or self.panel_pulse_strength;
	
		for i = 0, uic_allied_unit_list:ChildCount() - 1 do			
			local uic_card = UIComponent(uic_allied_unit_list:Find(i));
			
			-- highlight the type indicator if we're supposed to
			if highlight_unit_types then
				-- unit type
				local uic_type = find_uicomponent(uic_card, "unit_cat_frame");
				if uic_type then
					pulse_uicomponent(uic_type, value, button_pulse_strength);
				end;
			elseif highlight_experience then
				-- experience
				local uic_experience = find_uicomponent(uic_card, "experience");
				if uic_experience then
					pulse_uicomponent(uic_experience, value, button_pulse_strength);
				end;
			elseif highlight_banner then
				-- banner
				local uic_banner = find_uicomponent(uic_card, "ancillary_banner_item");
				if uic_banner then
					pulse_uicomponent(uic_banner, value, button_pulse_strength);
				end;
			else
				-- whole card
				pulse_uicomponent(uic_card, value, panel_pulse_strength);
			end;
		end;
	end;
	
	local uic_enemy_unit_list = find_uicomponent(ui_root, panel_name, "enemy_combatants_panel", "army", "units_and_banners_parent", "units_window");
	
	if uic_enemy_unit_list and uic_enemy_unit_list:Visible(true) then
		local button_pulse_strength = pulse_strength or self.button_pulse_strength;
		local panel_pulse_strength = pulse_strength or self.panel_pulse_strength;
	
		for i = 0, uic_enemy_unit_list:ChildCount() - 1 do			
			local uic_card = UIComponent(uic_enemy_unit_list:Find(i));
			
			-- highlight the type indicator if we're supposed to
			if highlight_unit_types then
				-- unit type
				local uic_type = find_uicomponent(uic_card, "unit_cat_frame");
				if uic_type then
					pulse_uicomponent(uic_type, value, button_pulse_strength);
				end;
			elseif highlight_experience then
				-- experience
				local uic_experience = find_uicomponent(uic_card, "experience");
				if uic_experience then
					pulse_uicomponent(uic_experience, value, button_pulse_strength);
				end;
			elseif highlight_banner then
				-- banner
				local uic_banner = find_uicomponent(uic_card, "ancillary_banner_item");
				if uic_banner then
					pulse_uicomponent(uic_banner, value, button_pulse_strength);
				end;
			else
				-- whole card
				pulse_uicomponent(uic_card, value, panel_pulse_strength);
			end;
		end;
	end;
	
	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_pre_battle_panel_unit_cards(false, pulse_strength, force_highlight, is_post_battle_panel, highlight_unit_types, highlight_experience, highlight_banner) end);
	end;
end;


--- @function highlight_province_info_panel
--- @desc Highlights the province info panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_province_info_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "panel");
	
	if uic and uic:Visible(true) then
		pulse_strength = pulse_strength or self.panel_pulse_strength;
		
		pulse_uicomponent(uic, value, pulse_strength);
		
		-- province effects body
		local uic_effects = find_uicomponent(uic, "effects");
		if uic_effects then
			pulse_uicomponent(uic_effects, value, pulse_strength);
		end;
		
		-- province effects header
		local uic_province_effects_header = find_uicomponent(uic, "effects", "header_frame");
		if uic_province_effects_header then
			pulse_uicomponent(uic_province_effects_header, value, pulse_strength);
		end;
		
		if value then
			self:highlight_growth(value, pulse_strength, force_highlight);
			self:highlight_tax(value, pulse_strength, force_highlight);
			self:highlight_public_order(value, pulse_strength, force_highlight);
			self:highlight_corruption(value, pulse_strength, force_highlight);
			
			table.insert(self.unhighlight_action_list, function() self:highlight_province_info_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_settlements(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_provinces_list
--- @desc Highlights the provinces drop-down list. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_provinces_list(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "radar_things", "dropdown_regions", "panel");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.panel_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_provinces_list(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_list_button_provinces(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_province_overview_panel
--- @desc Highlights the province overview panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_province_overview_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local cm = self.cm;
	local uic_panel = find_uicomponent(core:get_ui_root(), "settlement_panel");
	
	pulse_strength = pulse_strength or self.panel_pulse_strength;
	
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength);
		
		pulse_uicomponent(find_uicomponent(uic_panel, "header", "button_focus"), value, pulse_strength);
		pulse_uicomponent(find_uicomponent(uic_panel, "header", "button_cycle_left"), value, pulse_strength);
		pulse_uicomponent(find_uicomponent(uic_panel, "header", "button_cycle_right"), value, pulse_strength);

		if value then
			self:highlight_building_browser_button(value, pulse_strength, force_highlight);
			self:highlight_buildings(value, pulse_strength, force_highlight);
			table.insert(self.unhighlight_action_list, function() self:highlight_province_overview_panel(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	else	
		self:highlight_settlements(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_province_overview_panel_settlement_headers
--- @desc Highlights just the settlement headers on the province overview panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean first settlement only, Only highlight headers for the first settlement on the army panel.
--- @p [opt=false] boolean all but first settlement, Highlight headers for all but the first settlement on the army panel.
function campaign_ui_manager:highlight_province_overview_panel_settlement_headers(value, pulse_strength, force_highlight, first_settlement_only, all_but_first_settlement)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local cm = self.cm;
	local uic_settlement_list = find_uicomponent(core:get_ui_root(), "settlement_panel", "main_settlement_panel");
	
	if uic_settlement_list and uic_settlement_list:Visible(true) then	
		local loop_start = 0;
		local loop_end = uic_settlement_list:ChildCount() - 1;
		
		if first_settlement_only then
			loop_end = 0;
		end;
		
		if all_but_first_settlement then
			loop_start = 1;
		end;
		
		for i = loop_start, loop_end do
			local uic_settlement = UIComponent(uic_settlement_list:Find(i));
			
			local uic_zoom = find_uicomponent(uic_settlement, "button_zoom");
			
			if uic_zoom then
				pulse_uicomponent(uic_zoom, value, pulse_strength);
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_province_overview_panel_settlement_headers(false, pulse_strength, force_highlight, first_settlement_only, all_but_first_settlement) end);
		end;
		
		return true;
	end;
	
	return false;
end;


--- @function highlight_public_order
--- @desc Highlights public order on the province info panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_public_order(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "frame_public_order");
	
	-- if uic and uic:Visible(true) and is_fully_onscreen(uic) then -->> is_fully_onscreen(uic) not working as expected
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.panel_pulse_strength, true);
		
		-- header
		local uic_header = find_uicomponent(uic, "header_taxes");
		if not uic_header then
			-- slaves header instead
			uic_header = find_uicomponent(uic, "header_slaves");
		end;
		
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		if value then
			self:highlight_slaves_buttons(true, nil, force_highlight, true)
			table.insert(self.unhighlight_action_list, function() self:highlight_public_order(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_settlements(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_public_order_bar
--- @desc Highlights the public order bar on the province info panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_public_order_bar(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "frame_public_order", "control_frame");
	
	-- if uic and uic:Visible(true) and is_fully_onscreen(uic) then -->> is_fully_onscreen(uic) not working as expected
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_public_order_bar(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_settlements(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_public_order_icon
--- @desc Highlights the public order icon on the province info panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_public_order_icon(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "frame_public_order", "icon_public_order");
	
	-- if uic and uic:Visible(true) and is_fully_onscreen(uic) then -->> is_fully_onscreen(uic) not working as expected
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength, true);
				
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_public_order_icon(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_settlements(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_raise_dead_button
--- @desc Highlights the raise dead button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_raise_dead_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local cm = self.cm;
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "button_group_army", "button_mercenaries");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_raise_dead_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif cm:get_faction(cm:get_local_faction_name(true)):culture() == "wh_main_vmp_vampire_counts" then
		return self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_raise_dead_panel
--- @desc Highlights the raise dead panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_raise_dead_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local cm = self.cm;
	local uic_panel = find_uicomponent(core:get_ui_root(), "main_units_panel", "recruitment_options");
	
	if uic_panel and uic_panel:Visible(true) then
		-- if the dy_battle_sites component is not visible then this isn't the raise dead panel, so don't continue
		local uic_mercenary_display = find_uicomponent(uic_panel, "dy_battle_sites");
		if not uic_mercenary_display:Visible(true) then
			return self:highlight_raise_dead_button(value, pulse_strength, force_highlight);
		end;
		
		pulse_strength = pulse_strength or self.panel_pulse_strength;
		
		pulse_uicomponent(uic_mercenary_display, value, pulse_strength);		
		pulse_uicomponent(uic_panel, value, pulse_strength);
		
		-- frame
		local uic_frame = find_uicomponent(uic_panel, "mercenary_display", "frame");
		if uic_frame then
			pulse_uicomponent(uic_frame, value, pulse_strength);
		end;
		
		-- button
		local uic_button = find_uicomponent(uic_panel, "button_raise_dead");
		if uic_button then
			pulse_uicomponent(uic_button, value, pulse_strength);
		end;
		
		if value then
			self:highlight_raise_dead_panel_unit_cards(value, pulse_strength, force_highlight);
			table.insert(self.unhighlight_action_list, function() self:highlight_raise_dead_panel(false) end);
		end;
		return true;
	else
		return self:highlight_raise_dead_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_raise_dead_panel_unit_cards
--- @desc Highlights unit cards on the raise dead panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean unit types only, Only highlights the unit type indicator on each card instead of the whole card.
--- @p [opt=false] boolean unit experience only, Only highlights the unit experience indicator on each card instead of the whole card.
function campaign_ui_manager:highlight_raise_dead_panel_unit_cards(value, pulse_strength, force_highlight, highlight_unit_types, highlight_experience)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local cm = self.cm;
	local uic_raise_dead = find_uicomponent(core:get_ui_root(), "main_units_panel", "recruitment_options", "mercenary_display");
		
	if uic_raise_dead and uic_raise_dead:Visible(true) then	
		local uic_unit_list = find_uicomponent(uic_raise_dead, "listview", "list_clip", "list_box");
			
		if uic_unit_list then			
			for j = 0, uic_unit_list:ChildCount() - 1 do
				local uic_card = find_uicomponent(UIComponent(uic_unit_list:Find(j)), "unit_icon");
					
				-- highlight the type indicator if we're supposed to
				if highlight_unit_types then
					-- unit type
					local uic_type = find_uicomponent(uic_card, "unit_cat_frame");
					if uic_type then
						pulse_uicomponent(uic_type, value, pulse_strength or self.button_pulse_strength);
					end;
				elseif highlight_experience then
					-- experience
					local uic_experience = find_uicomponent(uic_child, "experience");
					if uic_experience then
						pulse_uicomponent(uic_experience, value, pulse_strength or self.button_pulse_strength);
					end;
				else
					-- whole card
					pulse_uicomponent(uic_card, value, pulse_strength or self.panel_pulse_strength);
				end;
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_raise_dead_panel_unit_cards(false, pulse_strength, force_highlight, highlight_unit_types, highlight_experience) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_raise_forces_button
--- @desc Highlights the raise forces button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_raise_forces_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center", "button_group_settlement", "button_create_army");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_raise_forces_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		-- hordes
		uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center", "button_group_army_settled", "button_create_army");
		
		if uic and uic:Visible(true) then
			pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_raise_forces_button(false, pulse_strength, force_highlight) end);
			end;
			return true;
		else
			local local_faction_key = cm:get_local_faction_name(true);
			if not cm:get_faction(local_faction_key):is_allowed_to_capture_territory() then
				self:highlight_building_panel_tab(value, pulse_strength, force_highlight, local_faction_key);
			else
				self:highlight_settlements(value, pulse_strength, force_highlight, local_faction_key);
			end;
		end;
	end;
	
	return false;
end;


--- @function highlight_raise_forces_panel
--- @desc Highlights the raise forces panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_raise_forces_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	-- query the state of the raise forces button to determine if the panel is visible
	local uic_raise_forces_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center", "button_group_settlement", "button_create_army");
	local uic_raise_forces_button_horde = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center", "button_group_army_settled", "button_create_army");
	
	local button_selected_test = function(uic)
		return uic and (uic:CurrentState() == "selected" or uic:CurrentState() == "selected_down");
	end;
	
	if button_selected_test(uic_raise_forces_button) or button_selected_test(uic_raise_forces_button_horde) then
		-- background panel
		local uic_character_panel = find_uicomponent(core:get_ui_root(), "character_panel");
		pulse_strength = pulse_strength or self.panel_pulse_strength;
	
		if uic_character_panel then
			pulse_uicomponent(uic_character_panel, value, pulse_strength);
		end;
		
		-- title
		local uic_title = find_uicomponent(uic_character_panel, "title_plaque");
		if uic_title then
			pulse_uicomponent(uic_title, value, pulse_strength, true);
		end;
		
		-- subframe
		local uic_frame = find_uicomponent(uic_character_panel, "subframe");
		if uic_frame then
			pulse_uicomponent(uic_frame, value, pulse_strength);
		end;
		
		-- no candidates panel
		local uic_no_candidates_panel = find_uicomponent(uic_character_panel, "no_candidates_panel");
		if uic_no_candidates_panel then
			pulse_uicomponent(uic_no_candidates_panel, value, pulse_strength);
		end;
		
		-- province_cycle
		local uic_province_cycle = find_uicomponent(uic_character_panel, "province_cycle");
		if uic_province_cycle then
			pulse_uicomponent(uic_province_cycle, value, pulse_strength, true);
		end;
		
		-- recruit button
		local uic_recruit_button = find_uicomponent(uic_character_panel, "button_raise");
		if uic_recruit_button then
			pulse_uicomponent(uic_recruit_button, value, pulse_strength);
		end;
		
		-- character list
		local uic_char_list = find_uicomponent(uic_character_panel, "general_selection_panel", "character_list");
		if uic_char_list then
			pulse_uicomponent(uic_char_list, value, pulse_strength, true);
		end;

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_raise_forces_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_raise_forces_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_recruit_black_ark_button
--- @desc Highlights the recruit black ark button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_recruit_black_ark_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center", "button_group_settlement", "button_sea_locked_general");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_recruit_black_ark_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif cm:get_faction(cm:get_local_faction_name(true)):culture() == "wh2_main_def_dark_elves" then
		return self:highlight_ports(value, cm:get_local_faction_name(true), pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_recruit_hero_button
--- @desc Highlights the recruit hero button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_recruit_hero_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center", "button_group_settlement", "button_agents");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_recruit_hero_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		-- horde
		uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center", "button_group_army_settled", "button_agents");
		if uic and uic:Visible(true) then
			pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_recruit_hero_button(false, pulse_strength, force_highlight) end);
			end;
			return true;
		else
			local local_faction_key = cm:get_local_faction_name(true);
			if not cm:get_faction(local_faction_key):is_allowed_to_capture_territory() then
				self:highlight_building_panel_tab(value, pulse_strength, force_highlight, local_faction_key);
			else
				self:highlight_settlements(value, pulse_strength, force_highlight, local_faction_key);
			end;
		end;
	end;
	
	return false;
end;


--- @function highlight_recruitment_button
--- @desc Highlights the recruitment button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_recruitment_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local cm = self.cm;
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center", "button_group_army", "button_recruitment");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_recruitment_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		return self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_recruitment_capacity
--- @desc Highlights the recruitment capacity indicators on the recruitment panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_recruitment_capacity(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local cm = self.cm;
	local uic_panel = find_uicomponent(core:get_ui_root(), "main_units_panel", "recruitment_options");
	
	if uic_panel and uic_panel:Visible(true) then		
		local uic_recruitment_lists = find_uicomponent(uic_panel, "recruitment_listbox");
		
		for i = 0, uic_recruitment_lists:ChildCount() - 1 do
			local uic_capacity = find_uicomponent(UIComponent(uic_recruitment_lists:Find(i)), "capacity_listview");
			
			if uic_capacity and uic_capacity:Visible(true) then
				pulse_uicomponent(uic_capacity, value, pulse_strength or self.panel_pulse_strength, true);
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_recruitment_capacity(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		return self:highlight_recruitment_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_recruitment_panel_unit_cards
--- @desc Highlights unit cards on the recruitment panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean unit types only, Only highlights the unit type indicator on each card instead of the whole card.
--- @p [opt=false] boolean unit experience only, Only highlights the unit experience indicator on each card instead of the whole card.
function campaign_ui_manager:highlight_recruitment_panel_unit_cards(value, pulse_strength, force_highlight, highlight_unit_types, highlight_experience)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local cm = self.cm;
	local uic_recruitment_lists = find_uicomponent(core:get_ui_root(), "main_units_panel", "recruitment_options", "recruitment_listbox");
		
	if uic_recruitment_lists and uic_recruitment_lists:Visible(true) then	
		for i = 0, uic_recruitment_lists:ChildCount() - 1 do
			local uic_recruitment_list = UIComponent(uic_recruitment_lists:Find(i));
			
			local uic_unit_list = find_uicomponent(uic_recruitment_list, "listview", "list_clip", "list_box");
			
			if uic_unit_list then			
				for j = 0, uic_unit_list:ChildCount() - 1 do
					local uic_card = find_uicomponent(UIComponent(uic_unit_list:Find(j)), "unit_icon");
					
					-- highlight the type indicator if we're supposed to
					if highlight_unit_types then
						-- unit type
						local uic_type = find_uicomponent(uic_card, "unit_cat_frame");
						if uic_type then
							pulse_uicomponent(uic_type, value, pulse_strength or self.button_pulse_strength);
						end;
					elseif highlight_experience then
						-- experience
						local uic_experience = find_uicomponent(uic_card, "experience");
						if uic_experience then
							pulse_uicomponent(uic_experience, value, pulse_strength or self.button_pulse_strength);
						end;
					else
						-- whole card
						pulse_uicomponent(uic_card, value, pulse_strength or self.panel_pulse_strength);
					end;
				end;
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_recruitment_panel_unit_cards(false, pulse_strength, force_highlight, highlight_unit_types, highlight_experience) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_regiments_of_renown_panel
--- @desc Highlights the regiments of renown panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_regiments_of_renown_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if cm:get_faction(cm:get_local_faction_name(true)):culture() == "wh2_main_lzd_lizardmen" then
		return false;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- if the regiments_of_renown button is not in a selected state then we are not on the regiments_of_renown panel
	local uic_renown_button = find_uicomponent(ui_root, "hud_campaign", "hud_center", "small_bar", "button_group_army", "button_renown");
	if uic_renown_button and not (uic_renown_button:CurrentState() == "selected" or uic_renown_button:CurrentState() == "selected_down") then
		return self:highlight_regiments_of_renown_button(value, pulse_strength, force_highlight);
	end;
	
	local uic_panel = find_uicomponent(core:get_ui_root(), "main_units_panel", "recruitment_options");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength);
		
		-- frame
		local uic_frame = find_uicomponent(uic_panel, "mercenary_display", "frame");
		if uic_frame then
			pulse_uicomponent(uic_frame, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		-- button
		local uic_button = find_uicomponent(uic_panel, "button_hire_renown");
		if uic_button then
			pulse_uicomponent(uic_button, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		if value then
			self:highlight_raise_dead_panel_unit_cards(value, pulse_strength, force_highlight);
			table.insert(self.unhighlight_action_list, function() self:highlight_regiments_of_renown_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		return self:highlight_regiments_of_renown_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_regiments_of_renown_button
--- @desc Highlights the regiments of renown button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_regiments_of_renown_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if cm:get_faction(cm:get_local_faction_name(true)):culture() == "wh2_main_lzd_lizardmen" then
		return false;
	end;
	
	local cm = self.cm;
	local ui_root = core:get_ui_root();
	
	local uic_renown_button = find_uicomponent(ui_root, "hud_campaign", "hud_center", "small_bar", "button_group_army", "button_renown");
	if uic_renown_button and uic_renown_button:Visible(true) then
		pulse_uicomponent(uic_renown_button, value, pulse_strength or self.button_pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_regiments_of_renown_button(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	else
		return self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_reinforcements
--- @desc Highlights reinforcements on the pre-battle screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_reinforcements(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	self:highlight_lords_pre_battle_screen(value, pulse_strength, force_highlight, true);
end;


--- @function highlight_rites_button
--- @desc Highlights the rites button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_rites_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_rituals");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_rites_button(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	end;
	
	return false;
end;


--- @function highlight_rites_panel
--- @desc Highlights the rites panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_rites_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "rituals_panel");
	
	if uic and uic:Visible(true) then
		local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
		
		-- panel frame
		local uic_frame = find_uicomponent(uic, "panel_frame");
		if uic_frame then
			pulse_uicomponent(uic_frame, value, pulse_strength_to_use);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_rites_panel(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	else
		self:highlight_rites_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_ritual_buttons
--- @desc Highlights ritual buttons. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_ritual_buttons(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ritual_bar = find_uicomponent(core:get_ui_root(), "vortex_ritual_bar");
	
	if ritual_bar and ritual_bar:Visible(true) then
		for i = 0, ritual_bar:ChildCount() - 1 do
			local ritual_bar_child = UIComponent(ritual_bar:Find(i));
			
			for j = 0, ritual_bar_child:ChildCount() - 1 do
				local ritual_button = find_uicomponent(ritual_bar_child, "ritual_rune");
				
				for k = 0, ritual_button:ChildCount() - 1 do
					pulse_uicomponent(UIComponent(ritual_button:Find(k)), value, pulse_strength or self.button_pulse_strength);
				end;
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_ritual_buttons(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	end;
	
	return false;
end;


--- @function highlight_ritual_rival_icons
--- @desc Highlights ritual rival icons. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_ritual_rival_icons(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ritual_holder = find_uicomponent(core:get_ui_root(), "vortex_ritual_holder", "bar_parent");
	
	if ritual_holder and ritual_holder:Visible(true) then
		for i = 0, ritual_holder:ChildCount() - 1 do
			pulse_uicomponent(find_uicomponent(UIComponent(ritual_holder:Find(i)), "icon"), value, pulse_strength or self.button_pulse_strength);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_ritual_rival_icons(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	end;
	
	return false;
end;


--- @function highlight_rituals_bar
--- @desc Highlights the rituals bar. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_rituals_bar(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ritual_holder = find_uicomponent(core:get_ui_root(), "vortex_ritual_holder", "bar_parent");
	
	if ritual_holder and ritual_holder:Visible(true) then
		pulse_uicomponent(ritual_holder, value, pulse_strength or self.button_pulse_strength);
		
		-- fill
		local uic_fill = find_uicomponent(ritual_holder, "vortex_ritual_bar", "bar_segment_template", "fill");
		
		if uic_fill and uic_fill:Visible(true) then
			pulse_uicomponent(uic_fill, value, pulse_strength or self.button_pulse_strength);
		end;		
		
		self:highlight_ritual_buttons(value, pulse_strength, force_highlight);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_rituals_bar(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	end;
	
	return false;
end;


--- @function highlight_seduce_units_button
--- @desc Highlights the Seduction button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_seduce_units_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();

	local uic_button = find_uicomponent(ui_root, "popup_pre_battle", "enemy_combatants_panel", "units_and_banners_parent", "slaanesh_promise_holder");
	if uic_button and uic_button:Visible(true) then
		pulse_uicomponent(uic_button, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_seduce_units_button(false) end);
		end;
	else
		self:highlight_armies(value, pulse_strength, force_highlight);
	end;
end;


--- @function highlight_seductive_influence
--- @desc Highlights the Seduction button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_seductive_influence(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();

	local uic = find_uicomponent(ui_root, "3d_ui_parent", "list_parent");
	if uic and uic:Visible(true) then
		local uic_header = find_uicomponent(uic, "status_docker", "status_bar", "seductive_influence_tracker");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength or self.button_pulse_strength, true);
		end;

		local uic_list = find_uicomponent(uic, "icon_holder", "seductive_influence_tracker");
		if uic_list then
			pulse_uicomponent(uic_list, value, pulse_strength or self.button_pulse_strength, true);
		end;

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_seductive_influence(false) end);
		end;
	end;
end;


--- @function highlight_settlements
--- @desc Highlights any visible settlements. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=nil] string faction key, Target faction key. Can be omitted to highlight settlements for all factions.
function campaign_ui_manager:highlight_settlements(value, pulse_strength, force_highlight, target_faction)
	
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if value then
		if target_faction then
			self:highlight_all_settlements_near_camera(true, 30, function(settlement) return settlement:faction():name() == target_faction end);
		else
			self:highlight_all_settlements_near_camera(true, 30);
		end;
		table.insert(self.unhighlight_action_list, function() self:highlight_settlements(false, pulse_strength, force_highlight) end);
	else
		self:highlight_all_settlements_near_camera(false);
	end;
end;

--- @function highlight_ship_building_button
--- @desc Highlights the shipbuilding tab on the army panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_ship_building_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_tab = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "tabgroup", "tab_horde_buildings");
	
	if uic_tab and uic_tab:Visible(true) then
		pulse_uicomponent(uic_tab, value, pulse_strength or self.button_pulse_strength);
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_ship_building_button(false, pulse_strength, force_highlight) end);
		end;
	else
		self:highlight_armies(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_ship_building_panel
--- @desc Highlights the shipbuilding panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_ship_building_panel(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_tab = find_uicomponent(ui_root, "units_panel", "main_units_panel", "tabgroup", "tab_horde_buildings");
	
	if uic_tab and uic_tab:Visible(true) and uic_tab:CurrentState() == "selected" then
	
		pulse_strength = pulse_strength or self.panel_pulse_strength;
	
		local uic_panel = find_uicomponent(ui_root, "units_panel", "main_units_panel");
		pulse_uicomponent(uic_panel, value, pulse_strength);
		
		-- frame
		local uic_frame = find_uicomponent(uic_panel, "frame");
		if uic_frame then
			pulse_uicomponent(uic_frame, value, pulse_strength);
		end;
		
		-- header
		local uic_header = find_uicomponent(uic_panel, "header");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength, true);
		end;
		
		-- building frame
		local uic_building_frame = find_uicomponent(uic_panel, "horde_building_frame");
		if uic_building_frame then
			
			-- background
			local uic_background = find_uicomponent(uic_building_frame, "panorama");
			if uic_background then
				pulse_uicomponent(uic_background, value, pulse_strength);
			end;
			
			-- growth
			local uic_growth = find_uicomponent(uic_building_frame, "pop_surplus");
			if uic_growth then
				pulse_uicomponent(uic_growth, value, pulse_strength, true);
			end;
			
			-- income
			local uic_income = find_uicomponent(uic_building_frame, "dy_income");
			if uic_income then
				pulse_uicomponent(uic_income, value, pulse_strength, true);
			end;
		end;

		if value then
			self:highlight_horde_buildings(value,  pulse_strength, force_highlight, true);
			table.insert(self.unhighlight_action_list, function() self:highlight_ship_building_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_ship_building_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;



--- @function highlight_siege_panel
--- @desc Highlights the siege panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_siege_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local uic_panel = find_uicomponent(ui_root, "popup_pre_battle", "battle_deployment", "regular_deployment", "siege_information_panel");
	
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength);
		
		-- title
		local uic_title = find_uicomponent(ui_root, "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "common_ui_parent", "panel_title");
		if uic_title then
			pulse_uicomponent(uic_title, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		if value then
			self:highlight_balance_of_power_bar(value, pulse_strength, force_highlight);
			self:highlight_siege_weapons(value, pulse_strength, force_highlight);
			table.insert(self.unhighlight_action_list, function() self:highlight_pre_battle_panel(false, pulse_strength, force_highlight) end);
		end;
		
		return true;		
	end;
	
	return false;
end;


--- @function highlight_siege_weapons
--- @desc Highlights siege weapons on the siege panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_siege_weapons(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local uic_panel = find_uicomponent(ui_root, "popup_pre_battle", "battle_deployment", "regular_deployment", "siege_information_panel", "attacker_recruitment_options");--, "equipment_frame", "construction_options");
	
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_siege_weapons(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	end;
	
	return false;
end;


--- @function highlight_slaves_button
--- @desc Highlights the slaves button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_slaves_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_slaves");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_slaves_button(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	end;
	
	return false;
end;


--- @function highlight_slaves_buttons
--- @desc Highlights the slaves buttons that appear on the province info panel when playing as Dark Elves. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_slaves_buttons(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "slaves_buttonset");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
	
		for i = 0, uic:ChildCount() - 1 do
			pulse_uicomponent(UIComponent(uic:Find(i)), value, pulse_strength or self.button_pulse_strength);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_slaves_buttons(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	elseif cm:get_faction(cm:get_local_faction_name(true)):culture() == "wh2_main_def_dark_elves" and not do_not_highlight_upstream then
		return self:highlight_settlements(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_spirit_of_grungni_button
--- @desc Highlights the spirit of grungni tab on the army panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_spirit_of_grungni_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_tab = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "tabgroup", "tab_horde_buildings");
	
	if uic_tab and uic_tab:Visible(true) then
		pulse_uicomponent(uic_tab, value, pulse_strength or self.button_pulse_strength);
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_spirit_of_grungni_button(false, pulse_strength, force_highlight) end);
		end;
	else
		self:highlight_armies(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_spirit_of_grungni_panel
--- @desc Highlights the spirit of grungni panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_spirit_of_grungni_panel(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_tab = find_uicomponent(ui_root, "units_panel", "main_units_panel", "tabgroup", "tab_horde_buildings");
	
	if uic_tab and uic_tab:Visible(true) and uic_tab:CurrentState() == "selected" then
	
		pulse_strength = pulse_strength or self.panel_pulse_strength;
	
		local uic_panel = find_uicomponent(ui_root, "units_panel", "main_units_panel");
		pulse_uicomponent(uic_panel, value, pulse_strength);
		
		-- frame
		local uic_frame = find_uicomponent(uic_panel, "frame");
		if uic_frame then
			pulse_uicomponent(uic_frame, value, pulse_strength);
		end;
		
		-- header
		local uic_header = find_uicomponent(uic_panel, "header");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength, true);
		end;
		
		-- building frame
		local uic_building_frame = find_uicomponent(uic_panel, "horde_building_frame");
		if uic_building_frame then
			
			-- background
			local uic_background = find_uicomponent(uic_building_frame, "panorama");
			if uic_background then
				pulse_uicomponent(uic_background, value, pulse_strength);
			end;
			
			-- growth
			local uic_growth = find_uicomponent(uic_building_frame, "pop_surplus");
			if uic_growth then
				pulse_uicomponent(uic_growth, value, pulse_strength, true);
			end;
			
			-- income
			local uic_income = find_uicomponent(uic_building_frame, "dy_income");
			if uic_income then
				pulse_uicomponent(uic_income, value, pulse_strength, true);
			end;
		end;

		if value then
			self:highlight_horde_buildings(value,  pulse_strength, force_highlight, true);
			table.insert(self.unhighlight_action_list, function() self:highlight_spirit_of_grungni_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_spirit_of_grungni_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;



--- @function highlight_stances
--- @desc Highlights the stances rollout. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_stances(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local cm = self.cm;
	local uic_character_info_panel = find_uicomponent(core:get_ui_root(), "CharacterInfoPopup");
	
	if uic_character_info_panel and uic_character_info_panel:Visible(true) then
		local button_stacks = {"land_stance_button_stack", "naval_stance_button_stack"};
		
		for i = 1, #button_stacks do
			local current_button_stack = button_stacks[i];
			
			local uic_button_stack = find_uicomponent(core:get_ui_root(), current_button_stack);
			if uic_button_stack then
				pulse_uicomponent(uic_button_stack, value, pulse_strength or self.button_pulse_strength, true);
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_stances(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;


--- @function highlight_strategic_map_layer_buttons
--- @desc Highlights the layer buttons on the strategic map. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_strategic_map_layer_buttons(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_toggles = find_uicomponent(core:get_ui_root(), "campaign_space_bar_options");	

	if uic_toggles and uic_toggles:Visible(true) then
		pulse_uicomponent(uic_toggles, value, pulse_strength or self.button_pulse_strength, true);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_strategic_map_layer_buttons(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_strat_map_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_strat_map_button
--- @desc Highlights the strategy map button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_strat_map_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "bar_small_top", "button_tactical_map");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_strat_map_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_tax
--- @desc Highlights the tax indicator on the province info panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_tax(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "frame_income");
	-- if uic and uic:Visible(true) and is_fully_onscreen(uic) then -->> is_fully_onscreen(uic) not working as expected
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.panel_pulse_strength, true);

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_tax(false, pulse_strength, force_highlight) end);
		end;
	else
		self:highlight_settlements(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;

--- @function highlight_tally_of_pestilence
--- @desc Highlights the Tally of Pestilence. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_tally_of_pestilence(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "dlc25_tally_of_pestilence");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_tally_of_pestilence(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_tally_of_pestilence");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_tally_of_pestilence(false) end);
			end;
		end;
	end;
end;
--- @function highlight_tamurkhans_chieftains
--- @desc Highlights the Tamurkhans's Chieftains. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_tamurkhans_chieftains(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "dlc25_tamurkhans_chieftains");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_tamurkhans_chieftains(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_tamurkhans_chiefs");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_tamurkhans_chieftains(false) end);
			end;
		end;
	end;
end;


--- @function highlight_technologies
--- @desc Highlights technologies. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_technologies(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_panel = find_uicomponent(core:get_ui_root(), "technology_panel");
	pulse_strength = pulse_strength or self.panel_pulse_strength;
	
	if uic_panel and uic_panel:Visible(true) then
		
		local uic_list = find_uicomponent(uic_panel, "list_clip", "list_box");
		if uic_list then			
			for i = 0, uic_list:ChildCount() - 1 do
				local uic_slot_parent = find_uicomponent(UIComponent(uic_list:Find(i)), "slot_parent");
				
				if uic_slot_parent then
					for j = 0, uic_slot_parent:ChildCount() - 1 do
						pulse_uicomponent(UIComponent(uic_slot_parent:Find(j)), value, pulse_strength);
					end;
				end;
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_technologies(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_technology_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_technology_button
--- @desc Highlights the technologies button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_technology_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_technology");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_technology_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_technology_panel
--- @desc Highlights the technologies panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_technology_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_panel = find_uicomponent(core:get_ui_root(), "technology_panel");
	
	if uic_panel and uic_panel:Visible(true) then
		local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
		-- panel back
		local uic_frame = find_uicomponent(uic_panel, "panel_back");
		if uic_frame then
			pulse_uicomponent(uic_frame, value, pulse_strength_to_use);
		end;
		
		-- parchment
		local uic_parchment = find_uicomponent(uic_panel, "parchment");
		if uic_parchment then
			pulse_uicomponent(uic_parchment, value, pulse_strength_to_use);
		end;
		
		-- header
		local uic_header = find_uicomponent(uic_panel, "header_frame");
		if uic_header then
			pulse_uicomponent(uic_header, value, pulse_strength_to_use, true);
		end;
		
		-- research rate
		local uic_research_rate = find_uicomponent(uic_panel, "label_research_rate");
		if uic_research_rate then
			pulse_uicomponent(uic_research_rate, value, pulse_strength_to_use, true);
		end;
		
		-- button
		local uic_button = find_uicomponent(uic_panel, "button_ok");
		if uic_button then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use);
		end;
		
		if value then
			self:highlight_technologies(value, pulse_strength, force_highlight, true);
			table.insert(self.unhighlight_action_list, function() self:highlight_technology_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_technology_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_tower_of_zharr
--- @desc Highlights the Chaos Dwarfs Hell-forge. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_tower_of_zharr(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "tower_of_zharr");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_tower_of_zharr(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_toz");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_tower_of_zharr(false) end);
			end;
		end;
	end;
end;


--- @function highlight_treasure_map_button
--- @desc Highlights the Treasure map button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_treasure_map_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_treasure_hunts");
		
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_treasure_map_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_treasure_map_panel
--- @desc Highlights the treasure maps panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_treasure_map_panel(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_panel = find_child_uicomponent(core:get_ui_root(), "treasure_hunts");
	
	if uic_panel and uic_panel:Visible(true) then
		-- panel is visible
		
		local uic_button_treasure_map = find_uicomponent(uic_panel, "hunts");
		
		if uic_button_treasure_map and (uic_button_treasure_map:CurrentState() == "selected"  or uic_button_treasure_map:CurrentState() == "selected_down") then
			-- panel is visible and on the treasure map tab - highlight panel
			pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength);
		
			local uic_treasure_maps_delete = find_uicomponent(uic_panel, "hunts", "button_delete");
			local uic_treasure_maps_zoom = find_uicomponent(uic_panel, "hunts", "button_zoom");

			pulse_uicomponent(uic_treasure_maps_delete, value, pulse_strength or self.panel_pulse_strength, false);
			pulse_uicomponent(uic_treasure_maps_zoom, value, pulse_strength or self.panel_pulse_strength, false);
			
			local uic_treasure_maps_button_list = find_uicomponent(uic_panel, "hunts", "hunts_list");
		
			for i = 0, uic_treasure_maps_button_list:ChildCount() - 1 do
				local uic_child = UIComponent(uic_treasure_maps_button_list:Find(i));
				
				pulse_uicomponent(uic_child, value, pulse_strength or self.panel_pulse_strength, true);
			end;
		else
			-- panel is visible but not on the treasure map tab - highlight tab button
			pulse_uicomponent(uic_button_treasure_map, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_treasure_map_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
		
	elseif not do_not_highlight_upstream then
		-- panel is not visible - highlight button
		self:highlight_treasure_map_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_treasury
--- @desc Highlights the treasury value. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_treasury(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_treasury(false, pulse_strength, force_highlight) end);
	end;
	return highlight_visible_component(value, true, "hud_campaign", "resources_bar", "dy_treasury");
end;


--- @function highlight_treasury_button
--- @desc Highlights the treasury button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_treasury_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "resources_bar", "button_finance");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_treasury_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_treasury_panel
--- @desc Highlights the treasury panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_treasury_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "finance_screen");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.panel_pulse_strength);
		
		local uic_title = find_uicomponent(uic, "panel_title");
		if uic_title then
			pulse_uicomponent(uic_title, value, pulse_strength or self.panel_pulse_strength);
		end;
		
		if value then
			self:highlight_treasury_panel_details_tab(value, pulse_strength, force_highlight, true);
			self:highlight_treasury_panel_summary_tab(value, pulse_strength, force_highlight, true);
			self:highlight_treasury_panel_trade_tab(value, pulse_strength, force_highlight, true);
			table.insert(self.unhighlight_action_list, function() self:highlight_treasury_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_treasury_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_treasury_panel_details_tab
--- @desc Highlights the details tab on the treasury panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_treasury_panel_details_tab(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "finance_screen");
	
	if uic and uic:Visible(true) then
		local uic_taxes = find_uicomponent(uic, "tab_summary");
		if uic_taxes then
			pulse_uicomponent(uic_taxes, value, pulse_strength or self.panel_pulse_strength);
		end;
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_treasury_panel_details_tab(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_treasury_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_treasury_panel_summary_tab
--- @desc Highlights the summary tab on the treasury panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_treasury_panel_summary_tab(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "finance_screen");
	
	if uic and uic:Visible(true) then
		local uic_trade = find_uicomponent(uic, "tab_taxes");
		if uic_trade then
			pulse_uicomponent(uic_trade, value, pulse_strength or self.panel_pulse_strength);
		end;
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_treasury_panel_summary_tab(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_treasury_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_treasury_panel_trade_tab
--- @desc Highlights the trade tab on the treasury panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_treasury_panel_trade_tab(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "finance_screen");
	
	if uic and uic:Visible(true) then
		local uic_trade = find_uicomponent(uic, "tab_trade");
		if uic_trade then
			pulse_uicomponent(uic_trade, value, pulse_strength or self.panel_pulse_strength);
		end;
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_treasury_panel_trade_tab(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		self:highlight_treasury_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_unit_cards
--- @desc Highlights unit cards across the campaign UI. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
--- @p [opt=false] boolean unit types only, Only highlights the unit type indicator on each card instead of the whole card.
--- @p [opt=false] boolean unit experience only, Only highlights the unit experience indicator on each card instead of the whole card.
function campaign_ui_manager:highlight_unit_cards(value, pulse_strength, force_highlight, highlight_type, highlight_experience)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	self:highlight_pre_battle_panel_unit_cards(value, pulse_strength, force_highlight, false, highlight_type, highlight_experience);
	self:highlight_post_battle_panel_unit_cards(value, pulse_strength, force_highlight, highlight_type, highlight_experience);
	self:highlight_army_panel_unit_cards(value, pulse_strength, force_highlight, false, highlight_type, highlight_experience);
	self:highlight_recruitment_panel_unit_cards(value, pulse_strength, force_highlight, highlight_type, highlight_experience);
	self:highlight_raise_dead_panel_unit_cards(value, pulse_strength, force_highlight, highlight_type, highlight_experience);
end;


--- @function highlight_unit_exchange_panel
--- @desc Highlights the unit exchange panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_unit_exchange_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic = find_uicomponent(core:get_ui_root(), "unit_exchange");
	
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.panel_pulse_strength, true);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_unit_exchange_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_unit_experience
--- @desc Highlights experience indicators on visible unit cards. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_unit_experience(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	self:highlight_unit_cards(value, pulse_strength, force_highlight, false, true);
end;


--- @function highlight_unit_information_panel
--- @desc Highlights the unit information panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_unit_information_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_panel = find_uicomponent(core:get_ui_root(), "unit_information_parent", "unit_information", "info_panel");
	
	if uic_panel and uic_panel:Visible(true) then
		pulse_strength = pulse_strength or self.panel_pulse_strength;
		pulse_uicomponent(uic_panel, value, pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_unit_information_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_unit_cards(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_unit_recruitment_panel
--- @desc Highlights the unit recruitment panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_unit_recruitment_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local cm = self.cm;
	local uic_panel = find_uicomponent(core:get_ui_root(), "main_units_panel", "recruitment_options");
	
	if uic_panel and uic_panel:Visible(true) then
		-- if the mercenary_display component is visible then this is the raise dead panel, so don't continue
		local uic_mercenary_display = find_uicomponent(uic_panel, "mercenary_display");
		if uic_mercenary_display:Visible(true) then
			return self:highlight_recruitment_button(value, pulse_strength, force_highlight);
		end;
		
		local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
		
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use);
		
		-- title
		local uic_title = find_uicomponent(uic_panel, "title_plaque");
		if uic_title then
			pulse_uicomponent(uic_title, value, pulse_strength_to_use);
		end;
		
		local uic_capacity = find_uicomponent(uic_panel, "capacity_listview");
		if uic_capacity then
			pulse_uicomponent(uic_capacity, value, pulse_strength_to_use);
		end;
		
		if value then
			self:highlight_local_recruitment_pool(value, pulse_strength, force_highlight, true);
			self:highlight_global_recruitment_pool(value, pulse_strength, force_highlight, true);
			self:highlight_recruitment_panel_unit_cards(value, pulse_strength, force_highlight);
			table.insert(self.unhighlight_action_list, function() self:highlight_unit_recruitment_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		return self:highlight_recruitment_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;


--- @function highlight_unit_types
--- @desc Highlights unit type indicators on visible unit cards. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_unit_types(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	self:highlight_unit_cards(value, pulse_strength, force_highlight, true);
end;


--- @function highlight_winds_of_magic
--- @desc Highlights the winds of magic indicators on the army panel and the pre-battle panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_winds_of_magic(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- army panel
	local uic_army_panel_wom = find_uicomponent(ui_root, "units_panel", "main_units_panel", "winds_of_magic");
	if uic_army_panel_wom and uic_army_panel_wom:Visible(true) then
		pulse_uicomponent(uic_army_panel_wom, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_winds_of_magic(false, pulse_strength, force_highlight) end);
		end;
	else
		-- pre_battle_panel
		local uic_pre_battle_panel_wom = find_uicomponent(ui_root, "popup_pre_battle", "allies_combatants_panel", "winds_of_magic");
		if uic_pre_battle_panel_wom and uic_pre_battle_panel_wom:Visible(true) then
			pulse_uicomponent(uic_pre_battle_panel_wom, value, pulse_strength or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_winds_of_magic(false) end);
			end;
		end;
	end;
end;


--- @function highlight_witchs_hut_button
--- @desc Highlights the witch's hut button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_witchs_hut_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_button = find_uicomponent(core:get_ui_root(), "faction_buttons_docker", "button_witches_hut");
	
	if uic_button and uic_button:Visible(true) then
		pulse_uicomponent(uic_button, value, pulse_strength or self.button_pulse_strength);
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_witchs_hut_button(false, pulse_strength, force_highlight) end);
		end;
		return true;
	end;
	
	return false;
end;


--- @function highlight_witchs_hut_panel
--- @desc Highlights the witch's hut panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
--- @p [opt=false] boolean dont highlight upstream, Suppress highlighting of any upstream components if this one is not currently visible.
function campaign_ui_manager:highlight_witchs_hut_panel(value, pulse_strength, force_highlight, do_not_highlight_upstream)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_incantations_list = find_uicomponent(core:get_ui_root(), "dlc24_witches_hut", "right_components_holder");
		
	if uic_incantations_list and uic_incantations_list:Visible(true) then	
		pulse_uicomponent(uic_incantations_list, value, pulse_strength or self.panel_pulse_strength);
		
		local uic_ingredients_list = find_uicomponent(core:get_ui_root(), "dlc24_witches_hut", "ingredients_list_holder");
		if uic_ingredients_list then
			pulse_uicomponent(uic_ingredients_list, value, pulse_strength or self.panel_pulse_strength, true);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_witchs_hut_panel(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif not do_not_highlight_upstream then
		return self:highlight_witchs_hut_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;



--- @function highlight_ataman_button
--- @desc Highlights the ataman button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_ataman_button(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_ataman_button(false, pulse_strength, force_highlight) end);
	end;
	return highlight_visible_component(value, true, "hud_campaign", "button_atamans")
end;



--- @function highlight_atamans
--- @desc Highlights the Atamans button and panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_atamans(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- ataman panel
	local uic_atamans_panel = find_uicomponent(ui_root, "kislev_atamans", "candidate_panel");
	if uic_atamans_panel and uic_atamans_panel:Visible(true) then
		pulse_uicomponent(uic_atamans_panel, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_atamans(false, pulse_strength, force_highlight) end);
		end;
	else
		-- ataman button
		local uic_ataman_button = find_uicomponent(ui_root, "faction_buttons_docker", "button_atamans");
		if uic_ataman_button and uic_ataman_button:Visible(true) then
			pulse_uicomponent(uic_ataman_button, value, pulse_strength or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_atamans(false) end);
			end;
		end;
	end;
end;



--- @function highlight_devotion
--- @desc Highlights the Devotion income. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_devotion(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_devotion(false, pulse_strength, force_highlight) end);
	end;
	return highlight_visible_component(value, true, "hud_campaign", "resources_bar", "devotion_parent");
end;



--- @function highlight_ice_court
--- @desc Highlights the Ice Court button and panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_ice_court(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- ice court button
	local uic_ice_court_button = find_uicomponent(ui_root, "faction_buttons_docker", "button_ice_court");
	if uic_ice_court_button and uic_ice_court_button:Visible(true) then
		pulse_uicomponent(uic_ice_court_button, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_ice_court(false) end);
		end;
	end;
end;



--- @function highlight_motherland
--- @desc Highlights the Ice Court button and panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_motherland(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- motherland panel
	local uic_motherland_panel = find_uicomponent(ui_root, "kislev_winter");
	if uic_motherland_panel and uic_motherland_panel:Visible(true) then
		pulse_uicomponent(uic_motherland_panel, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_motherland(false, pulse_strength, force_highlight) end);
		end;
	else
		-- motherland button
		local uic_motherland_button = find_uicomponent(ui_root, "hud_campaign", "resources_bar", "kislev_winter_holder", "frame");
		if uic_motherland_button and uic_motherland_button:Visible(true) then
			pulse_uicomponent(uic_motherland_button, value, pulse_strength or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_motherland(false) end);
			end;
		end;
	end;
end;



--- @function highlight_war_coordination
--- @desc Highlights the war co-ordination button and panel or diplomacy button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_war_coordination(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- war_coordination panel
	local uic_war_coordination_button = find_uicomponent(ui_root, "diplomacy_dropdown", "faction_panel_bottom", "button_war_coordination");
	if uic_war_coordination_button and uic_war_coordination_button:Visible(true) then
		-- war_coordination button
		pulse_uicomponent(uic_war_coordination_button, value, pulse_strength or self.panel_pulse_strength, true);
			
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_war_coordination(false) end);
		end;
	else
		-- war coordination button
		local uic_war_coordination_button = find_uicomponent(ui_root, "war_coordination_button_holder");
		if uic_war_coordination_button and uic_war_coordination_button:Visible(true) then
			-- war coordination button
			pulse_uicomponent(uic_war_coordination_button, value, pulse_strength or self.panel_pulse_strength, true);
				
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_war_coordination(false) end);
			end;
		end;
	end;
end;



--- @function highlight_war_coordination_ally_missions
--- @desc Highlights the war co-ordination_ally_missions tab. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_war_coordination_ally_missions(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- war_coordination_ally_missions tab
	local uic_war_coordination_ally_missions_tab = find_uicomponent(ui_root, "diplomacy_dropdown", "panel_war_coordination", "tab_missions");
	local uic_war_coordination_ally_missions_button = find_uicomponent(ui_root, "diplomacy_dropdown", "faction_panel_bottom", "button_war_coordination");
	if uic_war_coordination_ally_missions_tab and uic_war_coordination_ally_missions_tab:Visible(true) then
		pulse_uicomponent(uic_war_coordination_ally_missions_tab, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_war_coordination_ally_missions(false, pulse_strength, force_highlight) end);
		end;
	elseif uic_war_coordination_ally_missions_button and uic_war_coordination_ally_missions_button:Visible(true) then
		-- war_coordination button
		pulse_uicomponent(uic_war_coordination_ally_missions_button, value, pulse_strength or self.panel_pulse_strength, true);
			
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_war_coordination_ally_missions(false) end);
		end;
	else
		-- diplomacy button
		local uic_diplomacy_button = find_uicomponent(ui_root, "faction_buttons_docker", "button_diplomacy");
		if uic_diplomacy_button and uic_diplomacy_button:Visible(true) then
			-- diplomacy button
			pulse_uicomponent(uic_diplomacy_button, value, pulse_strength or self.panel_pulse_strength, true);
				
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_war_coordination_ally_missions(false) end);
			end;
		end;
	end;
end;



--- @function highlight_war_coordination_outpost
--- @desc Highlights the war co-ordination_outpost tab. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_war_coordination_outpost(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- war_coordination_outpost tab
	local uic_war_coordination_outpost_tab = find_uicomponent(ui_root, "diplomacy_dropdown", "panel_war_coordination", "tab_outpost");
	local uic_war_coordination_outpost_button = find_uicomponent(ui_root, "diplomacy_dropdown", "faction_panel_bottom", "button_war_coordination");
	if uic_war_coordination_outpost_tab and uic_war_coordination_outpost_tab:Visible(true) then
		pulse_uicomponent(uic_war_coordination_outpost_tab, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_war_coordination_outpost(false, pulse_strength, force_highlight) end);
		end;
	elseif uic_war_coordination_outpost_button and uic_war_coordination_outpost_button:Visible(true) then
		-- war_coordination button
		pulse_uicomponent(uic_war_coordination_outpost_button, value, pulse_strength or self.panel_pulse_strength, true);
			
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_war_coordination_outpost(false) end);
		end;
	else
		-- diplomacy button
		local uic_diplomacy_button = find_uicomponent(ui_root, "faction_buttons_docker", "button_diplomacy");
		if uic_diplomacy_button and uic_diplomacy_button:Visible(true) then
			-- diplomacy button
			pulse_uicomponent(uic_diplomacy_button, value, pulse_strength or self.panel_pulse_strength, true);
				
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_war_coordination_outpost(false) end);
			end;
		end;
	end;
end;



--- @function highlight_war_coordination_request_army
--- @desc Highlights the war co-ordination_outpost tab. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_war_coordination_request_army(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- war_coordination_outpost tab
	local uic_tab = find_uicomponent(ui_root, "diplomacy_dropdown", "panel_war_coordination", "tab_request_army");
	local uic_button = find_uicomponent(ui_root, "diplomacy_dropdown", "faction_panel_bottom", "button_war_coordination");
	if uic_tab and uic_tab:Visible(true) then
		pulse_uicomponent(uic_tab, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_war_coordination_request_army(false, pulse_strength, force_highlight) end);
		end;
	elseif uic_button and uic_button:Visible(true) then
		-- war_coordination button
		pulse_uicomponent(uic_button, value, pulse_strength or self.panel_pulse_strength, true);
			
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_war_coordination_request_army(false) end);
		end;
	else
		-- diplomacy button
		local uic_faction_buttons_docker_button = find_uicomponent(ui_root, "faction_buttons_docker", "button_diplomacy");
		if uic_faction_buttons_docker_button and uic_faction_buttons_docker_button:Visible(true) then
			-- diplomacy button
			pulse_uicomponent(uic_faction_buttons_docker_button, value, pulse_strength or self.panel_pulse_strength, true);
				
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_war_coordination_request_army(false) end);
			end;
		end;
	end;
end;



--- @function highlight_war_coordination_set_target
--- @desc Highlights the war co-ordination_outpost tab. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_war_coordination_set_target(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- war_coordination_set_target tab
	local uic_tab = find_uicomponent(ui_root, "diplomacy_dropdown", "panel_war_coordination", "tab_set_target");
	local uic_button = find_uicomponent(ui_root, "diplomacy_dropdown", "faction_panel_bottom", "button_war_coordination");
	if uic_tab and uic_tab:Visible(true) then
		pulse_uicomponent(uic_tab, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_war_coordination_set_target(false, pulse_strength, force_highlight) end);
		end;
	elseif uic_button and uic_button:Visible(true) then
		-- war_coordination button
		pulse_uicomponent(uic_button, value, pulse_strength or self.panel_pulse_strength, true);
			
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_war_coordination_set_target(false) end);
		end;
	else
		-- diplomacy button
		local uic_faction_buttons_docker_button = find_uicomponent(ui_root, "faction_buttons_docker", "button_diplomacy");
		if uic_faction_buttons_docker_button and uic_faction_buttons_docker_button:Visible(true) then
			-- diplomacy button
			pulse_uicomponent(uic_faction_buttons_docker_button, value, pulse_strength or self.panel_pulse_strength, true);
				
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_war_coordination_set_target(false) end);
			end;
		end;
	end;
end;



--- @function highlight_allied_recruitment
--- @desc Highlights the allied recruitment panel and button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_allied_recruitment(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_panel = find_uicomponent(ui_root, "main_units_panel");
	
	if uic_panel and uic_panel:Visible(true) then
		-- if the building tab is visible and selected then highlight the army tab and exit
		local uic_tabgroup = find_uicomponent(uic_panel, "tabgroup");
		
		if uic_tabgroup then
			local uic_building_tab = find_uicomponent(uic_tabgroup, "tab_horde_buildings");
			if uic_building_tab and uic_building_tab:Visible(true) and uic_building_tab:CurrentState() == "selected" then
				local uic_allied_recruitment_tab = find_uicomponent(ui_root, "hud_center_docker", "button_group_army", "button_allied_recruitment");
				if uic_allied_recruitment_tab then
					pulse_uicomponent(uic_allied_recruitment_tab, value, pulse_strength or self.button_pulse_strength);
					if value then
						table.insert(self.unhighlight_action_list, function() self:highlight_allied_recruitment(false, pulse_strength, force_highlight) end);
					end;
					return true;
				end;			
			end;
		end;
			
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_allied_recruitment(false, pulse_strength, force_highlight) end);
		end;
		
		return true;
	else
		return self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;



--- @function highlight_can_trade_icons
--- @desc Highlights diplomacy attitude icons on the diplomacy screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_can_trade_icons(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic_list = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_panel", "sortable_list_factions", "list_clip", "list_box");
	
	if uic_list and uic_list:Visible(true) then
	
		for i = 0, uic_list:ChildCount() - 1 do
			local uic_row = UIComponent(uic_list:Find(i));
			local uic_trade = find_uicomponent(uic_row, "pip_trade_land");
			
			if uic_trade then
				pulse_uicomponent(uic_trade, value, pulse_strength or self.button_pulse_strength);
			end;
		end;
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_can_trade_icons(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_diplomacy_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;



--- @function highlight_initiate_diplomacy
--- @desc Highlights region trading button on the diplomacy screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_initiate_diplomacy(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_button_initiate_diplomacy = find_uicomponent(ui_root, "diplomacy_dropdown", "faction_panel_bottom", "button_ok");
	
	if uic_button_initiate_diplomacy and uic_button_initiate_diplomacy:Visible(true) then
		pulse_uicomponent(uic_button_initiate_diplomacy, value, pulse_strength or self.button_pulse_strength);

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_initiate_diplomacy(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_diplomacy_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;



--- @function highlight_region_trading
--- @desc Highlights region trading button on the diplomacy screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_region_trading(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_screen = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown");
	local uic_button_region_trading = find_uicomponent(ui_root, "diplomacy_dropdown", "offers_panel", "diplomatic_option_trade_regions");
	
	if uic_button_region_trading and uic_button_region_trading:Visible(true) then
		pulse_uicomponent(uic_button_region_trading, value, pulse_strength or self.button_pulse_strength);

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_region_trading(false, pulse_strength, force_highlight) end);
		end;
	elseif uic_screen and uic_screen:Visible(true) then
		self:highlight_initiate_diplomacy(value, pulse_strength, force_highlight);
	else
		self:highlight_diplomacy_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;



--- @function highlight_confederation
--- @desc Highlights confederation button on the diplomacy screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_confederation(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_screen = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown");
	local uic_button = find_uicomponent(ui_root, "diplomacy_dropdown", "offers_panel", "diplomatic_option_confederation");
	
	if uic_button and uic_button:Visible(true) then
		pulse_uicomponent(uic_button, value, pulse_strength or self.button_pulse_strength);

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_confederation(false, pulse_strength, force_highlight) end);
		end;
	elseif uic_screen and uic_screen:Visible(true) then
		self:highlight_initiate_diplomacy(value, pulse_strength, force_highlight);
	else
		self:highlight_diplomacy_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;



--- @function highlight_non_aggression
--- @desc Highlights region non-aggression pact on the diplomacy screen. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_non_aggression(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local ui_root = core:get_ui_root();
	local uic_screen = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown");
	local uic_button_break = find_uicomponent(ui_root, "diplomacy_dropdown", "offers_panel", "diplomatic_option_break_nonaggression_pact");
	local uic_button = find_uicomponent(ui_root, "diplomacy_dropdown", "offers_panel", "diplomatic_option_nonaggression_pact");
	
	if uic_button_break and uic_button_break:Visible(true) then
		pulse_uicomponent(uic_button_break, value, pulse_strength or self.button_pulse_strength);

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_non_aggression(false, pulse_strength, force_highlight) end);
		end;
	elseif uic_button and uic_button:Visible(true) then
		pulse_uicomponent(uic_button, value, pulse_strength or self.button_pulse_strength);
	
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_non_aggression(false, pulse_strength, force_highlight) end);
		end;
	elseif uic_screen and uic_screen:Visible(true) then
		self:highlight_initiate_diplomacy(value, pulse_strength, force_highlight);
	else
		self:highlight_diplomacy_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;



--- @function highlight_global_item_pool
--- @desc Highlights the character details subpanel on the character details panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_global_item_pool(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local uic_character_details = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent");
	if uic_character_details and uic_character_details:Visible(true) then
		pulse_strength = pulse_strength or self.panel_pulse_strength;
		local tab_panels = find_uicomponent(uic_character_details, "tab_panels", "character_details_subpanel", "equipment_holder");
		
		-- Global item pool
		local uic_global_item_pool = find_uicomponent(tab_panels, "global_pool");
		if uic_global_item_pool then
			pulse_uicomponent(uic_global_item_pool, value, pulse_strength, true);
		end;
		
		if value then
			--self:highlight_banners_and_marks(value, pulse_strength, force_highlight);
			table.insert(self.unhighlight_action_list, function() self:highlight_global_item_pool(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		self:highlight_character_details_panel_details_button(value, pulse_strength, force_highlight);
	end;
	
	return false;
end;



--- @function highlight_cloak_of_skulls
--- @desc Highlights the Cloak of Skulls button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_cloak_of_skulls(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- cloak of skulls button
	local uic_panel = find_uicomponent(ui_root, "hud_campaign", "button_group_management", "button_cloak_of_skulls");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_cloak_of_skulls(false, pulse_strength, force_highlight) end);
		end;
	end;
end;



--- @function highlight_wrath_of_khorne
--- @desc Highlights the Wrath of Khorne button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_wrath_of_khorne(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- wrath of khorne button
	local uic_panel = find_uicomponent(ui_root, "hud_campaign", "button_group_management", "button_wrath_of_khorne");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_wrath_of_khorne(false, pulse_strength, force_highlight) end);
		end;
	end;
end;



--- @function highlight_skull_throne
--- @desc Highlights the Skull Throne button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_skull_throne(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- skull throne button
	local uic_panel = find_uicomponent(ui_root, "hud_campaign", "button_group_management", "button_skull_throne");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_skull_throne(false, pulse_strength, force_highlight) end);
		end;
	end;
end;



--- @function highlight_skulls_count
--- @desc Highlights the skulls counter. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_skulls_count(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_skulls_count(false, pulse_strength, force_highlight) end);
	end;
	return highlight_visible_component(value, true, "hud_campaign", "resources_bar_holder", "dy_khorne_skulls")
end;



--- @function highlight_devotees
--- @desc Highlights the devotees counter. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_devotees(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_devotees(false, pulse_strength, force_highlight) end);
	end;
	return highlight_visible_component(value, true, "hud_campaign", "resources_bar_holder", "dy_slaanesh_devotees")
end;



--- @function highlight_pleasurable_acts
--- @desc Highlights the pleasurable acts indicator on the province info panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_pleasurable_acts(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "frame_devotees");
	if uic and uic:Visible(true) then
		pulse_uicomponent(uic, value, pulse_strength or self.panel_pulse_strength, true);

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_pleasurable_acts(false, pulse_strength, force_highlight) end);
		end;
	else
		self:highlight_settlements(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;



--- @function highlight_summon_disciple_army
--- @desc Highlights the summon disciple army button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_summon_disciple_army(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local cm = self.cm;
	local uic_panel = find_uicomponent(core:get_ui_root(), "hud_center_docker", "button_subpanel_parent", "button_group_army", "button_summon_disciple_army");
	
	if uic_panel and uic_panel:Visible(true) then
		local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
		
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_summon_disciple_army(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		return self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;



--- @function highlight_proliferate_cults
--- @desc Highlights the Skull Throne button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_proliferate_cults(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();

	local uic_panel = find_uicomponent(ui_root, "hud_campaign", "resources_bar_holder", "slaanesh_cult_holder");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_proliferate_cults(false, pulse_strength, force_highlight) end);
		end;
	end;
end;



--- @function highlight_daemonic_glory_counters
--- @desc Highlights the glory counters counter. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_daemonic_glory_counters(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_daemonic_glory_counters(false, pulse_strength, force_highlight) end);
	end;
	return highlight_visible_component(value, true, "hud_campaign", "resources_bar_holder", "daemonic_glory_holder")
end;



--- @function highlight_daemonic_glory_panel
--- @desc Highlights the Daemonic Glory button and panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_daemonic_glory_panel(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- daemonic glory panel
	local uic_panel = find_uicomponent(ui_root, "daemonic_progression", "upgrades_list_view");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_daemonic_glory_panel(false, pulse_strength, force_highlight) end);
		end;
	else
		-- daemonic glory button
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_daemonic_progression");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_daemonic_glory_panel(false) end);
			end;
		end;
	end;
end;



--- @function highlight_daemonic_dedication
--- @desc Highlights the Daemonic Dedication button and panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_daemonic_dedication(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- daemonic dedication panel
	local uic_panel = find_uicomponent(ui_root, "daemonic_progression", "upgrades_list_view", "list_box");
	if uic_panel and uic_panel:Visible(true) then
		for i = 0, uic_panel:ChildCount() - 1 do
			local uic_row = UIComponent(uic_panel:Find(i));
			local uic_trade = find_uicomponent(uic_row, "divider_ascension");
			
			if uic_trade then
				pulse_uicomponent(uic_trade, value, pulse_strength or self.button_pulse_strength);
			end;
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_daemonic_dedication(false, pulse_strength, force_highlight) end);
		end;
	else
		-- daemonic dedication button
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_daemonic_progression");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_daemonic_dedication(false) end);
			end;
		end;
	end;
end;



--- @function highlight_cathay_compass
--- @desc Highlights the Cathay Compass button and panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_cathay_compass(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	local ui_root = core:get_ui_root();
	
	local uic_panel = find_uicomponent(ui_root, "cathay_compass");
	if uic_panel and uic_panel:Visible(true) then
		-- title
		local uic_title = find_uicomponent(uic_panel, "title");
		if uic_title then
			pulse_uicomponent(uic_title, value, pulse_strength_to_use, true);
		end;

		-- compass
		local uic_compass = find_uicomponent(uic_panel, "compass_parent");
		if uic_compass then
			pulse_uicomponent(uic_compass, value, pulse_strength_to_use, true);
		end;

		-- buttons
		local uic_buttons = find_uicomponent(uic_panel, "buttons_parent");
		if uic_buttons then
			pulse_uicomponent(uic_buttons, value, pulse_strength_to_use, true);
		end;

		-- panel
		local uic_panel_holder = find_uicomponent(uic_panel, "parent_list_holder");
		if uic_panel_holder then
			pulse_uicomponent(uic_panel_holder, value, pulse_strength_to_use, true);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_cathay_compass(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_compass");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_cathay_compass(false) end);
			end;
		end;
	end;
end;



--- @function highlight_ivory_road
--- @desc Highlights the Ivory Road button and panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_ivory_road(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "cathay_caravans", "caravans_panel");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_ivory_road(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_caravan");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_ivory_road(false) end);
			end;
		end;
	end;
end;



--- @function highlight_harmony
--- @desc Highlights the Harmony lotus. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_harmony(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();	
	local uic_panel = find_uicomponent(ui_root, "hud_campaign", "resources_bar_holder", "harmony");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_harmony(false, pulse_strength, force_highlight) end);
		end;
	end;
end;



--- @function highlight_great_bastion
--- @desc Highlights the Harmony lotus. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_great_bastion(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();	
	local uic_panel = find_uicomponent(ui_root, "hud_campaign", "resources_bar_holder", "cth_bastion_threat_holder");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_great_bastion(false, pulse_strength, force_highlight) end);
		end;
	end;
end;



--- @function highlight_kislev_supporters
--- @desc Highlights the Supporters Track. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_kislev_supporters(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "kislev_winter", "body", "devotion_holder");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_kislev_supporters(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		-- motherland button
		local uic_motherland_button = find_uicomponent(ui_root, "hud_campaign", "resources_bar", "kislev_winter_holder", "frame");
		if uic_motherland_button and uic_motherland_button:Visible(true) then
			pulse_uicomponent(uic_motherland_button, value, pulse_strength or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_motherland(false) end);
			end;
		end;
	end;
end;



--- @function highlight_plagues_of_nurgle
--- @desc Highlights the Plagues of Nurgle button and panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_plagues_of_nurgle(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	local ui_root = core:get_ui_root();
	
	local uic_panel = find_uicomponent(ui_root, "nurgle_plagues");
	if uic_panel and uic_panel:Visible(true) then
		local uic_title = find_uicomponent(uic_panel, "header_frame");
		if uic_title then
			pulse_uicomponent(uic_title, value, pulse_strength_to_use, true);
		end;

		local uic_left_section = find_uicomponent(uic_panel, "left_section");
		if uic_left_section then
			pulse_uicomponent(uic_left_section, value, pulse_strength_to_use);

			local uic_base_plague_holder = find_uicomponent(uic_left_section, "base_plague_holder");
			if uic_base_plague_holder then
				pulse_uicomponent(uic_base_plague_holder, value, pulse_strength_to_use, true);
			end;

			self:highlight_symptoms(value, pulse_strength_to_use, force_highlight);
			self:highlight_plague_recipes(value, pulse_strength_to_use, force_highlight);
		end;

		local uic_buttons = find_uicomponent(uic_panel, "right_section", "effects_holder");
		if uic_buttons then
			pulse_uicomponent(uic_buttons, value, pulse_strength_to_use, true);
		end;

		local uic_panel_holder = find_uicomponent(uic_panel, "middle_section");
		if uic_panel_holder then
			pulse_uicomponent(uic_panel_holder, value, pulse_strength_to_use, true);
		end;
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_plagues_of_nurgle(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_nurgle_plagues");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_plagues_of_nurgle(false) end);
			end;
		end;
	end;
end;



--- @function highlight_infections
--- @desc Highlights the infections counter. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_infections(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_infections(false, pulse_strength, force_highlight) end);
	end;

	local ui_root = core:get_ui_root();
	local uic_panel = find_uicomponent(ui_root, "nurgle_plagues");

	if uic_panel and uic_panel:Visible(true) then
		return highlight_visible_component(value, true, "nurgle_plagues", "infections_label");
	end;

	return highlight_visible_component(value, true, "hud_campaign", "resources_bar_holder", "dy_nurgle_infections");
end;



--- @function highlight_symptoms
--- @desc Highlights Nurgle symptoms. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_symptoms(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	local ui_root = core:get_ui_root();
	
	local uic_panel = find_uicomponent(ui_root, "nurgle_plagues");
	if uic_panel and uic_panel:Visible(true) then
		local uic_ingredients_holder = find_uicomponent(uic_panel, "left_section", "ingredients_holder");
		if uic_ingredients_holder then
			pulse_uicomponent(uic_ingredients_holder, value, pulse_strength_to_use);
			local uic_ingredients_header = find_uicomponent(uic_ingredients_holder, "ingredients_header");
			if uic_ingredients_header then
				pulse_uicomponent(uic_ingredients_header, value, pulse_strength_to_use, true);
			end;

			if value then
				for i, uic_child in uic_pairs(find_uicomponent(uic_ingredients_holder, "ingredient_list")) do
					self:pulse_and_unpulse_uicomponent(find_uicomponent(uic_child, "slot_item"), pulse_strength_to_use);
				end;
			end;
		end;

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_plague_recipes(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_nurgle_plagues");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_symptoms(false) end);
			end;
		end;
	end;
end;


--- @function highlight_plague_recipes
--- @desc Highlights Nurgle plague recipes. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_plague_recipes(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;

	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	local ui_root = core:get_ui_root();
	
	local uic_panel = find_uicomponent(ui_root, "nurgle_plagues");
	if uic_panel and uic_panel:Visible(true) then
		local uic_recipe_holder = find_uicomponent(uic_panel, "left_section", "recipes_holder");
		if uic_recipe_holder then
			pulse_uicomponent(uic_recipe_holder, value, pulse_strength_to_use);
			local uic_recipe_header = find_uicomponent(uic_recipe_holder, "recipe_header");
			if uic_recipe_header then
				pulse_uicomponent(uic_recipe_header, value, pulse_strength_to_use, true);
			end;

			if value then
				for i, uic_child in uic_pairs(find_uicomponent(uic_recipe_holder, "recipes_list")) do
					self:pulse_and_unpulse_uicomponent(uic_child, pulse_strength_to_use);
				end;
			end;
		end;

		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_plague_recipes(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_nurgle_plagues");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_plague_recipes(false) end);
			end;
		end;
	end;
end;



--- @function highlight_unholy_manifestations
--- @desc Highlights the Unholy Manifestations button and panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_unholy_manifestations(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "great_game_rituals", "rituals_panel");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_unholy_manifestations(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_great_game_rituals");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_unholy_manifestations(false) end);
			end;
		end;
	end;
end;



--- @function highlight_changing_of_the_ways
--- @desc Highlights the Changing of the Ways button and panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_changing_of_the_ways(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "tzeentch_changing_of_ways");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_changing_of_the_ways(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_changing_of_the_ways");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_changing_of_the_ways(false) end);
			end;
		end;
	end;
end;



--- @function highlight_grimoires
--- @desc Highlights the grimoires counter. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_grimoires(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_grimoires(false, pulse_strength, force_highlight) end);
	end;
	return highlight_visible_component(value, true, "hud_campaign", "resources_bar_holder", "dy_tzeentch_grimoires");
end;



--- @function highlight_winds_of_magic_manipulation
--- @desc Highlights the Winds of Magic Manipulation button and panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_winds_of_magic_manipulation(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	
	local uic_panel = find_uicomponent(ui_root, "tzeench_wom_manipulation");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_winds_of_magic_manipulation(false, pulse_strength_to_use, force_highlight) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_magic_manipulation");
		if uic_button and uic_button:Visible(true) then
			pulse_uicomponent(uic_button, value, pulse_strength_to_use or self.panel_pulse_strength, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_winds_of_magic_manipulation(false) end);
			end;
		end;
	end;
end;



--- @function highlight_offer_to_the_great_maw
--- @desc Highlights the offings to the great maw button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_offer_to_the_great_maw(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
	local cm = self.cm;
	local ui_root = core:get_ui_root();
	local uic_panel = find_uicomponent(ui_root, "hud_center_docker", "button_subpanel_parent", "button_group_army", "button_great_maw");
	local maw_panel = find_uicomponent(ui_root, "ogre_great_maw");

	if maw_panel and maw_panel:Visible(true) then
		pulse_uicomponent(maw_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_offer_to_the_great_maw(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif uic_panel and uic_panel:Visible(true) then		
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_offer_to_the_great_maw(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		return self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;



--- @function highlight_orge_camp
--- @desc Highlights the deploy ogre camp button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_orge_camp(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local cm = self.cm;
	local uic_panel = find_uicomponent(core:get_ui_root(), "hud_center_docker", "button_subpanel_parent", "button_group_army", "button_deploy_camp");
	
	if uic_panel and uic_panel:Visible(true) then
		local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
		
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_orge_camp(false, pulse_strength, force_highlight) end);
		end;
		return true;
	else
		return self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;



--- @function highlight_ogre_meat
--- @desc Highlights the grimoires counter. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_ogre_meat(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	if value then
		table.insert(self.unhighlight_action_list, function() self:highlight_ogre_meat(false, pulse_strength, force_highlight) end);
	end;
	return highlight_visible_component(value, true, "info_panel_holder", "info_panel_background", "character_info_parent", "icon_meat");
end;



--- @function highlight_ogre_contracts
--- @desc Highlights the Winds of Magic Manipulation button and panel. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number panel pulse strength override, Pulse Strength Override. Default is 5. Set a higher number for a more pronounced pulsing.
--- @p [opt=nil] number button pulse strength override, Pulse Strength Override. Default is 5. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_ogre_contracts(value, panel_pulse_strength, button_pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	local uic_panel = find_uicomponent(ui_root, "ogre_bounties");
	if uic_panel and uic_panel:Visible(true) then
		local pulse_strength_to_use = panel_pulse_strength or self.panel_pulse_strength;
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_ogre_contracts(false) end);
		end;
	else
		local uic_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", "button_ogre_bounties");
		if uic_button and uic_button:Visible(true) then
			local pulse_strength_to_use = button_pulse_strength or self.panel_pulse_strength;
			pulse_uicomponent(uic_button, value, pulse_strength_to_use, true);
			
			if value then
				table.insert(self.unhighlight_action_list, function() self:highlight_ogre_contracts(false) end);
			end;
		end;
	end;
end;



--- @function highlight_big_names
--- @desc Highlights the deploy ogre camp button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_big_names(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local cm = self.cm;
	local uic_panel = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "TabGroup", "big_names");
	local char_info_panel = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "info_button_list", "button_general");
	if uic_panel and uic_panel:Visible(true) then
		local pulse_strength_to_use = pulse_strength or self.panel_pulse_strength;
		
		pulse_uicomponent(uic_panel, value, pulse_strength_to_use);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_big_names(false, pulse_strength, force_highlight) end);
		end;
		return true;
	elseif char_info_panel and char_info_panel:Visible(true) then
		uim:highlight_character_details_button(true);
	else
		return self:highlight_armies(value, pulse_strength, force_highlight, cm:get_local_faction_name(true));
	end;
	
	return false;
end;



--- @function highlight_tyrants_demands
--- @desc Highlights the Tyrant's Demands button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_tyrants_demands(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- tyrant's demands button
	local uic_panel = find_uicomponent(ui_root, "hud_campaign", "button_group_management", "button_tyrants_demands");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_tyrants_demands(false, pulse_strength, force_highlight) end);
		end;
	end;
end;




--- @function highlight_mercenary_contracts
--- @desc Highlights the Mercenary Contracts button. Best practise is to use @campaign_ui_manager:unhighlight_all_for_tooltips to cancel the highlight later.
--- @p [opt=false] boolean show highlight, Show highlight.
--- @p [opt=nil] number pulse strength override, Pulse Strength Override. Default is 10 for smaller components such as buttons, and 5 for larger components such as panels. Set a higher number for a more pronounced pulsing.
--- @p [opt=false] boolean force highlight, Forces the highlight to show even if the <code>help_page_link_highlighting</code> ui override is set.
function campaign_ui_manager:highlight_mercenary_contracts(value, pulse_strength, force_highlight)
	if not self.help_page_link_highlighting_permitted and not force_highlight then
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	-- mercenary contracts demands button
	local uic_panel = find_uicomponent(ui_root, "hud_campaign", "button_group_management", "button_ogre_war_contracts");
	if uic_panel and uic_panel:Visible(true) then
		pulse_uicomponent(uic_panel, value, pulse_strength or self.panel_pulse_strength, true);
		
		if value then
			table.insert(self.unhighlight_action_list, function() self:highlight_mercenary_contracts(false, pulse_strength, force_highlight) end);
		end;
	end;
end;