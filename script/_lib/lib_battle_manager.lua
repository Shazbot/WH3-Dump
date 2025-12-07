



----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	BATTLE MANAGER
--
--- @set_environment battle
--- @c battle_manager Battle Manager
--- @index_pos 1
--- @a bm
--- @desc The <code>battle_manager</code> is a central interface object through which much functionality is provided to battle scripts. A battle manager is automatically created when the script libraries are loaded in battle by calling @global:load_script_libraries. This battle manager object is called <code>bm</code>, and calls to @battle and battle manager functions may be made through it. 
--- @desc When created, the <code>battle_manager</code> script object internally creates a @battle code interface object automatically. Functions called on the battle manager that the battle manager does not itself provide are passed through to this @battle object. In this way, the battle_manager object automatically provides the full interface of a @battle object. The battle manager also provides numerous enhancements and extensions on top of the core @battle functionality - see the list of functions on this page.
--- @desc It is highly preferable for scripts to not create and use a @battle interface themselves, but instead to load the script libraries and work exclusively through the battle manager.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


battle_manager = {
	--[[
	watch_list = {},
	phase_change_callback_list = {},
	unit_selection_callback_list = {},
	command_handler_callback_list = {},
	input_handler_callback_list = {},
	esc_key_steal_list = {},
	advisor_list = {},
	cutscene_list = {},
	help_messages = {},
	composite_scene_groups = {},
	composite_scenes_currently_active = {},
	scriptunits = {},							-- collection of subtables containing script_units collections
	all_scriptunits = {},						-- flat list of all scriptunits, stored by unique_ui_id
	restore_ui_hiding_action_list = {},
	active_ui_overrides = {},
	active_survival_battle_waves = {},
	spawn_zone_list = {},
	value_to_campaign_map = {},
	fort_tower_buildings = {},
	fort_gate_buildings = {},
	fort_wall_buildings = {},
	victory_locations = {},						-- this is only create the first time get_victory_locations() is called
	]]
	battle = nil,
	tm = nil,
	battle_ui_manager = nil,
	campaign_key = "",
	should_close_queue_advice = false,			-- if true, advice will close when it's finished playing
	advice_is_playing = false,
	advisor_force_playing = false,
	advisor_stopping = false,
	advisor_last_action_was_stop = false,
	advice_has_played_this_battle = false,
	advice_dont_play = false,
	notify_of_next_advice = false,
	player_victory_callback = nil,
	player_defeat_callback = nil,
	current_phase = false,
	debug_angles = false,
	load_balancing = true,
	watch_timer_running = false,
	help_messages = {},
	help_messages_showing = false,
	advisor_reopen_wait = 500,
	objectives = false,
	infotext = false,
	hpm = false,
	battle_is_won = false,
	pos_origin = false,
	subtitles_visible = false,
	spell_browser_button_text = "",
	spell_browser_button_text_src = "",
	modify_advice_str = "modify_advice",
	PROGRESS_ON_ADVICE_FINISHED_REPOLL_TIME = 200,
	ui_hiding_enabled = true,
	input_focus_is_stolen = false,
	cached_conflict_time_update_overridden = false,
	current_conflict_time_update_overridden = false,
	survival_battle_wave_monitors_started = false,
	model_ticks_per_second = 5,							-- is recalculated in constructor
	
	-- camera movement tracker
	camera_tracker_active = false,
	camera_tracker_distance_travelled = 0,
	original_cached_camera_pos = false,
	last_cached_camera_pos = false,
	
	-- engagement monitor
	engagement_monitor_started = false,
	cached_distance_between_forces = 2000,
	cached_num_units_engaged = 0,
	cached_proportion_engaged = 0,
	cached_num_units_under_fire = 0,
	cached_proportion_under_fire = 0,
	main_player_army_altitude = 0,
	main_enemy_army_altitude = 0,
};


set_class_custom_type_and_tostring(battle_manager, TYPE_BATTLE_MANAGER);










----------------------------------------------------------------------------
--- @section Creation
--- @desc A battle manager object is automatically created when the script libraries are loaded in battle, so there should be no need for client scripts to call @battle_manager:new themselves. The battle manager object that is automatically created is called <code>bm</code>.
----------------------------------------------------------------------------

--- @function new
--- @desc Creates and returns a battle_manager object. Only one battle_manager object may be created in a session - attempting to create a second just returns the first.
--- @r @battle_manager battle manager
function battle_manager:new()
	if core:get_static_object("battle_manager") then
		return core:get_static_object("battle_manager");
	end;
	
	local b = empire_battle:new();
	
	local bm = {
		battle = b,
		watch_list = {},
		phase_change_callback_list = {},
		unit_selection_callback_list = {},
		command_handler_callback_list = {},
		input_handler_callback_list = {},
		esc_key_steal_list = {},
		advisor_list = {},
		cutscene_list = {},
		help_messages = {},
		composite_scene_groups = {},
		composite_scenes_currently_active = {},
		scriptunits = {},
		all_scriptunits = {},
		restore_ui_hiding_action_list = {},
		active_ui_overrides = {},
		active_survival_battle_waves = {},
		spawn_zone_list = {},
		value_to_campaign_map = {},
		fort_tower_buildings = {},
		fort_gate_buildings = {},
		fort_wall_buildings = {},
		victory_locations = {}
	};

	set_object_class(bm, self, b);
	
	-- overwrite out() with a custom output function for battle
	getmetatable(out).__call = function(t, input) 		-- t is the 'this' object
		local output_str = get_timestamp() .. "<" .. tostring(b:time_elapsed_ms()) .. "ms> ";
		
		-- add in all required tab chars
		for i = 1, out.tab_levels["out"] do
			output_str = output_str .. "\t";
		end;
		
		output_str = output_str .. input;
		
		print(output_str);
		
		-- logfile output
		if __write_output_to_logfile then
			local file = io.open(__logfile_path, "a");
			if file then
				file:write(output_str .. "\n");
				file:close();
			end;
		end;
	end;

	-- set up script failure warning context
	common.set_context_value("SCRIPT_FAILED_THIS_SESSION", 0)
	-- overwrite the script_error implemention of all_scripted so the context value is also set
	local old_script_error = script_error
	script_error = function(msg, stack_level_modifier, suppress_assert)
		common.set_context_value("SCRIPT_FAILED_THIS_SESSION", 1)
		old_script_error(msg, stack_level_modifier, suppress_assert)
	end
	
	core:add_static_object("battle_manager", bm);
	
	bm.tm = timer_manager:new_battle(b);
	core.tm = bm.tm;
	
	bm.pos_origin = v(0, 0);

	local file_path = string.gsub(get_full_file_path(5), "/", "\\");
	bm:out("battle_manager created, script path of battle script is " .. file_path);

	if bm:is_from_campaign() then
		local campaign_key = core:svr_load_string("campaign_key_for_battle");
		if is_string(campaign_key) then
			bm.campaign_key = campaign_key;
			bm:out("\tLoaded in from campaign " .. campaign_key);
		end;
	end;
	
	-- starts infotext and objectives managers automatically
	bm.infotext = infotext_manager:new();
	bm.objectives = objectives_manager:new();

	bm.uim = battle_ui_manager:new(bm);

	bm.model_ticks_per_second = 1000 / b:model_tick_time_ms();
	
	-- set the ui root on the core object
	local root_child_component_name = "hud_battle";
	local uic_root_child = UIComponent(b:ui_component(root_child_component_name));
	if uic_root_child then
		core:set_ui_root(UIComponent(uic_root_child:Parent()));
	else
		script_error("ERROR: couldn't find uicomponent with name " .. root_child_component_name .. " - the root uicomponent will not have been set!");
	end;

	-- builds an internal collection of all scriptunit/scriptunits for units in the battle
	bm:build_scriptunits();

	-- build cached lists of different types of buildings on the map
	local buildings = b:buildings();
	local fort_tower_buildings = bm.fort_tower_buildings;
	local fort_gate_buildings = bm.fort_gate_buildings;
	local fort_wall_buildings = bm.fort_wall_buildings;

	for i = 1, buildings:count() do
		local current_building = buildings:item(i);
		if current_building:is_fort_tower() then
			table.insert(fort_tower_buildings, current_building);
		end;
		
		if current_building:has_gate() then
			table.insert(fort_gate_buildings, current_building);
			table.insert(fort_wall_buildings, current_building);
		elseif current_building:is_fort_wall() then
			table.insert(fort_wall_buildings, current_building);
		end;
	end;

	-- start the phase change handler mechanism
	bm:register_battle_phase_handler("battle_manager_phase_change");

	-- help page manager
	bm.hpm = help_page_manager:new();
	
	--
	--	help pages
	--	hard-coded path to the battle help page
	--	(not ideal)
	--
	package.path = package.path .. ";" .. bm:get_battle_folder() .. "/?.lua";
	force_require("wh_battle_help_pages");
	setup_battle_help_pages(bm);
	
	-- create links to the battle and battlemanager objects in the global registry so that other environments (e.g. autotesting) can access them
	_G.battle_env = core:get_env();
		
	-- start any project-specific scripts
	if is_function(start_project_specific_scripts) then
		start_project_specific_scripts();
	end;
	
	return bm;
end;









----------------------------------------------------------------------------
--- @section Usage
--- @desc Once created (which happens automatically within the declaration of the script libraries), functions on the battle manager object may be called in the form showed below.
--- @new_example Specification
--- @example core:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example -- Object called bm is automatically set up by script libraries -
--- @example -- client scripts should not need to call this themselves.
--- @example bm = battle_manager:new()
--- @example bm:out("test")
--- @result Test
----------------------------------------------------------------------------









----------------------------------------------------------------------------
--- @section Console Output
----------------------------------------------------------------------------


--- @function out
--- @desc Prints a string to the console for debug purposes. The string is prepended with a timestamp.
--- @p string output
function battle_manager:out(str)
	out(str);
end;







----------------------------------------------------------------------------
--- @section Scriptunits
--- @desc The battle manager automatically constructs a @script_unit object for each unit in the battle, and a @script_units collection for each army. The @script_units collection objects can be accessed with the functions described below.
----------------------------------------------------------------------------


--- @function get_scriptunits_for_army
--- @desc Gets an automatically-generated @script_units collection object containing a @script_unit for every unit in the specified army. If no scriptunits collection can be found for the supplied alliance/army/optional reinforcement index then <code>false</code> is returned.
--- @p @number alliance id, Alliance id. Alliances are specified by 1-based index, currently either <code>1</code> or <code>2</code>.
--- @p @number army id, Army id, specified by 1-based index, so a value of <code>1<code> corresponds to the first army in the specified alliance.
--- @p [opt=false] @number reinforcement units id, Specifies a reinforcing units to return the scriptunits for. If this argument is omitted, the scriptunits collection corresponding to the main (non-reinforcing) army is returned. Otherwise, the scriptunits collection corresponding to the specified reinforcing units is returned. If no reinforcing army could be found then a script error is thrown.
--- @r @script_units scriptunits collection, or <code>false</code> if no alliance/army found.
function battle_manager:get_scriptunits_for_army(alliance_id, army_id, reinforcement_units_index)
	if not is_number(alliance_id) or alliance_id < 1 then
		script_error("ERROR: get_scriptunits_for_army() called but supplied alliance index [" .. tostring(alliance_id) .. "] is not a positive number");
		return false;
	end;

	if not is_number(army_id) or army_id < 1 then
		script_error("ERROR: get_scriptunits_for_army() called but supplied army index [" .. tostring(army_id) .. "] is not a positive number");
		return false;
	end;

	if reinforcement_units_index and (not is_number(reinforcement_units_index) or reinforcement_units_index < 1) then
		script_error("ERROR: get_scriptunits_for_army() called but supplied reinforcement unit index [" .. tostring(reinforcement_units_index) .. "] is not a positive number or nil");
		return false;
	end;

	local scriptunits = self.scriptunits;

	if not is_table(scriptunits) or #scriptunits == 0 then
		script_error("ERROR: get_scriptunits_for_army() called but the internal scriptunits collections have not been built. How can this be?");
		return false;
	end;

	if alliance_id > #scriptunits then
		script_error("ERROR: get_scriptunits_for_army() called but supplied alliance index [" .. alliance_id .. "] is greater than the number of cached alliances [" .. #scriptunits .. "]");
		return false;
	end;

	if not is_table(scriptunits[alliance_id]) or #scriptunits[alliance_id] == 0 then
		script_error("ERROR: get_scriptunits_for_army() called but no scriptunits could be found for the supplied alliance id [" .. alliance_id .. "]. How can this be?");
		return false;
	end;

	if army_id > #scriptunits[alliance_id] then
		script_error("ERROR: get_scriptunits_for_army() called but supplied army index [" .. army .. "] is greater than the number of cached armies [" .. #scriptunits[alliance_id] .. "] in alliance [" .. alliance_id .. "]");
		return false;
	end;

	if reinforcement_units_index then
		if reinforcement_units_index > scriptunits[alliance_id][army_id].num_reinforcement_armies then
			script_error("ERROR: get_scriptunits_for_army() called but supplied reinforcement units index [" .. reinforcement_units_index .. "] is greater than the number of cached reinforcement armies [" .. scriptunits[alliance_id][army_id].num_reinforcement_armies .. "] for alliance [" .. alliance_id .. "], army [" .. army_id .. "]");
			return false;
		end;
		return scriptunits[alliance_id][army_id]["r_" .. reinforcement_units_index];
	end;
	
	return scriptunits[alliance_id][army_id]["main"];
end;


--- @function num_alliances
--- @desc Returns the number of alliances in the battle. Currently there should always be two alliances.
--- @r @number alliances
function battle_manager:num_alliances()
	return #self.scriptunits;
end;


--- @function num_armies_in_alliance
--- @desc Returns the number of armies in the specified alliance. The alliance is specified by index, which should currently either be <code>1</code> or <code>2</code>.
--- @p @number alliance id
--- @r @number army
function battle_manager:num_armies_in_alliance(alliance_id)
	if not is_number(alliance_id) or alliance_id < 1 then
		script_error("ERROR: num_armies_in_alliance() called but supplied alliance index [" .. tostring(alliance_id) .. "] is not a positive number");
		return false;
	end;

	if not is_table(self.scriptunits[alliance_id]) then
		script_error("ERROR: num_armies_in_alliance() called but no alliance with supplied index [" .. tostring(alliance_id) .. "] could be found");
		return false;
	end;

	return #self.scriptunits[alliance_id];
end;


--- @function num_reinforcing_armies_for_army_in_alliance
--- @desc Returns the number of reinforcing armies for an army in the specified alliance and army. The alliance and army are specified by index (indexes are always 1-based).
--- @p @number alliance id
--- @p @number army id
--- @r @number num reinforcing armies
function battle_manager:num_reinforcing_armies_for_army_in_alliance(alliance_id, army_id)
	if not is_number(alliance_id) or alliance_id < 1 then
		script_error("ERROR: num_reinforcing_armies_for_army_in_alliance() called but supplied alliance index [" .. tostring(alliance_id) .. "] is not a positive number");
		return false;
	end;

	if not is_table(self.scriptunits[alliance_id]) then
		script_error("ERROR: num_reinforcing_armies_for_army_in_alliance() called but no alliance with supplied index [" .. tostring(alliance_id) .. "] could be found");
		return false;
	end;

	if not is_number(army_id) or army_id < 1 then
		script_error("ERROR: num_reinforcing_armies_for_army_in_alliance() called but supplied army index [" .. tostring(army_id) .. "] is not a positive number");
		return false;
	end;

	if not is_table(self.scriptunits[alliance_id][army_id]) then
		script_error("ERROR: num_reinforcing_armies_for_army_in_alliance() called but no army with alliance index [" .. tostring(alliance_id) .. "] and army index [" .. tostring(army_id) .. "] could be found");
		return false;
	end;

	return self.scriptunits[alliance_id][army_id].num_reinforcement_armies;
end;


--- @function get_scriptunits_for_local_players_army
--- @desc Returns the automatically-generated @script_units collection object, containing a @script_unit for every unit, corresponding to the local player's army.
--- @r @script_units scriptunits collection
function battle_manager:get_scriptunits_for_local_players_army()
	return self:get_scriptunits_for_army(self.battle:local_alliance(), self.battle:local_army());
end;


--- @function get_scriptunits_for_main_enemy_army_to_local_player
--- @desc Returns the automatically-generated @script_units collection object, containing a @script_unit for every unit, for the local player's primary enemy army.
--- @r @script_units scriptunits collection
function battle_manager:get_scriptunits_for_main_enemy_army_to_local_player()
	return self:get_scriptunits_for_army(self:get_non_player_alliance_num(), 1);
end;


--- @function get_scriptunits_for_main_attacker
--- @desc Returns the automatically-generated @script_units collection object, containing a @script_unit for every unit, for the primary attacking army.
--- @r @script_units scriptunits collection
function battle_manager:get_scriptunits_for_main_attacker()
	return self:get_scriptunits_for_army(self:get_attacking_alliance_num(), 1);
end;



--- @function get_scriptunits_for_main_defender
--- @desc Returns the automatically-generated @script_units collection object, containing a @script_unit for every unit, for the primary defending army.
--- @r @script_units scriptunits collection
function battle_manager:get_scriptunits_for_main_defender()
	return self:get_scriptunits_for_army(self:get_defending_alliance_num(), 1);
end;


-- internal function which takes an army and an optional reinforcement units index (which, if supplied, specifies which reinforcing units to target) and returns a table of constructed scriptunit objects
function battle_manager:get_scriptunits_from_units(army, reinforcement_units_index)
	if not is_army(army) then
		script_error("ERROR: get_scriptunits_from_army() called but supplied army [" .. tostring(army) .. "] is not a valid army object");
		return false;
	end;

	if reinforcement_units_index and (not is_number(reinforcement_units_index) or reinforcement_units_index < 1) then
		script_error("ERROR: get_scriptunits_from_army() called but supplied reinforcement units index [" .. tostring(reinforcement_units_index) .. "] is not a positive number or nil");
		return false;
	end;

	local units = false;

	if reinforcement_units_index then
		if reinforcement_units_index > army:num_reinforcement_units() then
			script_error("ERROR: get_scriptunits_from_army() called but supplied reinforcement units index [" .. reinforcement_units_index .. "] is greater than the number of reinforcing unit collections present [" .. army:num_reinforcement_units() .. "]");
			return false;
		end;
		
		units = army:get_reinforcement_units(reinforcement_units_index);
	else
		units = army:units();
	end;

	local retval = {};
	for i = 1, units:count() do
		table.insert(retval, script_unit:new(units:item(i)));
	end;
	return retval;
end;


--- @function get_scriptunit_for_unit
--- @desc Returns a previously-created @script_unit for the supplied @battle_unit. If no matching @script_unit can be found then @nil is returned.
--- @p @battle_unit unit
--- @r @script_unit sunit
function battle_manager:get_scriptunit_for_unit(unit)
	if not is_unit(unit) then
		script_error("ERROR: get_scriptunit_for_unit() called but supplied object [" .. tostring(unit) .. "] is not a valid unit");
		return false;
	end;

	return self.all_scriptunits[unit:unique_ui_id()];
end;


-- internal function to register a scriptunit - this should only be called by the scriptunit constructor
function battle_manager:register_scriptunit_for_unit(unit, scriptunit)
	self.all_scriptunits[unit:unique_ui_id()] = scriptunit;
end;


-- internal function to build a dataset containing a scriptunit for each unit on the battlefield, called on construction
function battle_manager:build_scriptunits()
	if #self.scriptunits > 0 then
		script_error("ERROR: battle_manager:build_scriptunits() called but the scriptunits collections for this battle have already been built. This function should only be called once.");
		return false;
	end;

	local num_scriptunits = 0;
	local scriptunits = {};

	local alliances = self.battle:alliances();
				
	for i = 1, alliances:count() do
		local armies = alliances:item(i):armies();
		
		scriptunits[i] = {};

		for j = 1, armies:count() do
			local current_army = armies:item(j);
			
			scriptunits[i][j] = {};

			-- build a scriptunits collection object from a table of scriptunit objects (returned by get_scriptunits_from_units) for the main units collection in the army
			local sunits = script_units:new(
				"generated_" .. i .. "_" .. j .. "_main", 
				unpack(self:get_scriptunits_from_units(current_army))
			);
			num_scriptunits = num_scriptunits + sunits:count();
			scriptunits[i][j]["main"] = sunits;

			-- do the same, but for each reinforcing army (if any)
			for k = 1, current_army:num_reinforcement_units() do
				local sunits_r = script_units:new(
					"generated_" .. i .. "_" .. j .. "_r" .. k, 
					unpack(self:get_scriptunits_from_units(current_army, k))
				);
				num_scriptunits = num_scriptunits + sunits_r:count();
				scriptunits[i][j]["r_" .. k] = sunits_r;
			end;
			
			-- also record the number of reinforcement armies
			scriptunits[i][j]["num_reinforcement_armies"] = current_army:num_reinforcement_units();
		end;	
	end;

	-- print report to console
	out("battle_manager: constructed " .. num_scriptunits .. " script_unit objects");
	for i = 1, #scriptunits do
		for j = 1, #scriptunits[i] do
			out("alliance " .. i .. " army " .. j .. ":");
			local current_sunits = scriptunits[i][j]["main"];
			out("\t" .. current_sunits.name .. " created with " .. current_sunits:count() .. " units");
			
			for k = 1, scriptunits[i][j]["num_reinforcement_armies"] do
				local current_sunits_r = scriptunits[i][j]["r_" .. k];
				out("\t" .. current_sunits_r.name .. " created with " .. current_sunits_r:count() .. " units");
			end;
		end;
	end;

	self.scriptunits = scriptunits;
end;







----------------------------------------------------------------------------
--- @section Miscellaneous Querying
----------------------------------------------------------------------------


--- @function get_battle_ui_manager
--- @desc Retrieves a handle to a @battle_ui_manager object from the battle manager. One is created if it hasn't been created before.
--- @r @battle_ui_manager battle ui manager
function battle_manager:get_battle_ui_manager()
	if not self.battle_ui_manager then
		-- this will create a self.battle_ui_manager record
		return battle_ui_manager:new();
	end;
	
	return self.battle_ui_manager;
end;


--- @function get_battle_folder
--- @desc Returns the path to the battle script folder.
--- @r @string path
function battle_manager:get_battle_folder()
	return "data/script/battle";
end;


--- @function get_origin
--- @desc Returns a vector position at the world origin.
--- @r @battle_vector origin
function battle_manager:get_origin()
	return self.pos_origin;
end;


--- @function ui_component
--- @desc A wrapper for ui_component. Searches the UI heirarchy and returns a uicomponent object with the supplied name. This overrides the base ui_component function provided by the underlying <code>battle</code> object, which returns a component object (which must be converted to be a UIComponent before use).
--- @r @uicomponent ui component, or false if not found
function battle_manager:ui_component(component_name)
	if not is_string(component_name) then
		script_error("ERROR: ui_component() called but supplied component name [" .. tostring(component_name) .. "] is not a string");
		return false;
	end;
	
	if component_name == "" then
		script_error("ERROR: ui_component() called but supplied component name is empty");
		return false;
	end;
	
	local retval = self.battle:ui_component(component_name);
	
	if is_component(retval) then
		return UIComponent(retval);
	elseif not retval then
		return false;
	else
		script_error("ERROR: ui_component() called to search for a component called [" .. component_name .. "] and is prepared to return an object [" .. tostring(retval) .. "] of type [" .. type(retval) .. "] but this is not a component, something bad has happened!");
	end;
	
	return false;
end;


--- @function get_campaign_key
--- @desc Returns the key of the campaign this battle was launched from. If this battle was not launched from a campaign then a blank string is returned.
--- @r @string campaign key
function battle_manager:get_campaign_key()
	return self.campaign_key;
end;


function battle_manager:register_cutscene(cutscene)
	if not is_cutscene(cutscene) then
		script_error("ERROR: register_cutscene() called but supplied object [" .. tostring(cutscene) .. "] is not a cutscene");
		return false;
	end;
	
	table.insert(self.cutscene_list, cutscene);
end;


--- @function is_any_cutscene_running
--- @desc Returns true if any cutscene object is currently showing a cutscene.
--- @r @boolean is cutscene running
function battle_manager:is_any_cutscene_running()
	if #self.cutscene_list == 0 then
		return false;
	end;
	
	for i = 1, #self.cutscene_list do
		if self.cutscene_list[i]:is_active() then
			return true;
		end;
	end;
	
	return false;
end;


--- @function is_any_unit_selected
--- @desc Returns whether any unit cards are selected.
--- @r @boolean any unit selected
function battle_manager:is_any_unit_selected()
	local uic_unit_card_parent = find_uicomponent(core:get_ui_root(), "battle_orders_pane", "card_panel_docker", "cards_panel", "review_DY")
	
	if not uic_unit_card_parent then
		script_error("ERROR: is_any_unit_selected() called but couldn't find unit card parent ui component");
		return false;
	end;
	
	for i = 0, uic_unit_card_parent:ChildCount() - 1 do
		local uic_child = UIComponent(uic_unit_card_parent:Find(i));
		
		if uic_child:CallbackId() == "UnitCard" then
			local state = uic_child:CurrentState();
			
			if uic_child:Visible() then
				if string.sub(state, 1, 8) == "selected" then
					return true;
				end;
			end;
		end;
	end;
	
	return false;
end;


--- @function num_units_selected
--- @desc Returns the number of unit cards that are selected.
--- @r @number number of units selected
function battle_manager:num_units_selected()
	local uic_unit_card_parent = find_uicomponent(core:get_ui_root(), "battle_orders_pane", "card_panel_docker", "cards_panel", "review_DY")
	
	if not uic_unit_card_parent then
		script_error("ERROR: is_any_unit_selected() called but couldn't find unit card parent ui component");
		return false;
	end;

	local count = 0;
	
	for i = 0, uic_unit_card_parent:ChildCount() - 1 do
		local uic_child = UIComponent(uic_unit_card_parent:Find(i));
		
		if uic_child:CallbackId() == "UnitCard" then
			local state = uic_child:CurrentState();
			
			if uic_child:Visible() then
				if string.sub(state, 1, 8) == "selected" then
					count = count + 1;
				end;
			end;
		end;
	end;
	
	return count;
end;


--- @function are_all_units_selected
--- @desc Returns whether all unit cards are selected.
--- @r @boolean all units selected
function battle_manager:are_all_units_selected()
	local uic_unit_card_parent = find_uicomponent(core:get_ui_root(), "battle_orders_pane", "card_panel_docker", "cards_panel", "review_DY")
	
	if not uic_unit_card_parent then
		script_error("ERROR: is_any_unit_selected() called but couldn't find unit card parent ui component");
		return false;
	end;
	
	for i = 0, uic_unit_card_parent:ChildCount() - 1 do
		local uic_child = UIComponent(uic_unit_card_parent:Find(i));
		local state = uic_child:CurrentState();
		
		if uic_child:Visible() then
			if string.sub(state, 1, 8) ~= "selected" then
				return false;
			end;
		end;
	end;
	
	return true;
end;


--- @function get_player_alliance_num
--- @desc Returns the alliance number of the player's alliance.
--- @r @number alliance number
function battle_manager:get_player_alliance_num()
	return self:local_alliance();
end;


--- @function get_non_player_alliance_num
--- @desc Returns the alliance number of the non-player alliance.
--- @r @number alliance number
function battle_manager:get_non_player_alliance_num()
	if self:local_alliance() == 1 then
		return 2;
	else
		return 1;
	end;
end;


--- @function get_player_alliance
--- @desc Returns the local player's alliance object.
--- @r @battle_alliance player alliance
function battle_manager:get_player_alliance()
	return self:alliances():item(self:get_player_alliance_num());
end;


--- @function get_non_player_alliance
--- @desc Returns the alliance object of the local player's enemy.
--- @r @battle_alliance enemy alliance
function battle_manager:get_non_player_alliance()
	return self:alliances():item(self:get_non_player_alliance_num());
end;


--- @function player_is_attacker
--- @desc Returns true if the local player is the attacker in the battle.
--- @r @boolean player is attacker
function battle_manager:player_is_attacker()
	return self:get_player_alliance():is_attacker();
end;


--- @function get_player_army
--- @desc Returns the local player's army object.
--- @r @battle_army player's army
function battle_manager:get_player_army()
	return self:get_player_alliance():armies():item(1);
end;


--- @function get_first_non_player_army
--- @desc Returns the first army of the enemy alliance to the local player.
--- @r @battle_army enemy army
function battle_manager:get_first_non_player_army()
	return self:get_non_player_alliance():armies():item(1);
end;


--- @function get_attacking_alliance_num
--- @desc Returns the alliance number of the attacking alliance in the battle.
--- @r @number attacking alliance num
function battle_manager:get_attacking_alliance_num()
	local alliances = self.battle:alliances();
	for i = 1, alliances:count() do
		if alliances:item(i):is_attacker() then
			return i;
		end;
	end;

	script_error("ERROR: get_attacking_alliance_num() could find no attacking alliance");
	return false;
end;


--- @function get_defending_alliance_num
--- @desc Returns the alliance number of the defending alliance in the battle.
--- @r @number defending alliance num
function battle_manager:get_defending_alliance_num()
	local alliances = self.battle:alliances();
	for i = 1, alliances:count() do
		if not alliances:item(i):is_attacker() then
			return i;
		end;
	end;

	script_error("ERROR: get_defending_alliance_num() could find no defending alliance");
	return false;
end;


--- @function get_attacking_alliance
--- @desc Returns the attacking alliance object.
--- @r @battle_alliance attacking alliance
function battle_manager:get_attacking_alliance()
	local alliances = self.battle:alliances();
	for i = 1, alliances:count() do
		if alliances:item(i):is_attacker() then
			return alliances:item(i);
		end;
	end;

	script_error("ERROR: get_attacking_alliance() could find no attacking alliance");
	return false;
end;


--- @function get_defending_alliance
--- @desc Returns the defending alliance object.
--- @r @battle_alliance defending alliance
function battle_manager:get_defending_alliance()
	local alliances = self.battle:alliances();
	for i = 1, alliances:count() do
		if not alliances:item(i):is_attacker() then
			return alliances:item(i);
		end;
	end;

	script_error("ERROR: get_defending_alliance() could find no defending alliance");
	return false;
end;


--- @function assault_equipment_exists
--- @desc Returns <code>true</code> if any assault equipment with the optional supplied key exists on the battlefield. If no key is supplied then the function returns true if any assault equipment exists.
--- @p [opt=nil] @string key, Assault equipment key, from the <code>battlefield_siege_vehicles</code> table. If no key is supplied then the function returns <code>true</code> if any assault equipment is present.
--- @r @boolean equipment exists
function battle_manager:assault_equipment_exists(key)
	local assault_equipment = self.battle:assault_equipment();

	if not key then
		return assault_equipment:vehicle_count() > 0;
	end;

	if not is_string(key) then
		script_error("ERROR: assault_equipment_exists() called but supplied key [" .. tostring(key) .. "] is not a string or nil");
		return false;
	end;

	for i = 1, assault_equipment:vehicle_count() do
		if assault_equipment:vehicle_item(i):vehicle_key() == key then
			return true;
		end;
	end;

	return false;
end;


--- @function get_closest_vehicle
--- @desc Returns the closest siege vehicle to the supplied position. If no assault equipment is present on the map then @nil is returned.
--- @p @battle_vector position
--- @r @battle_vehicle closest vehicle
function battle_manager:get_closest_vehicle(pos)
	if not is_vector(pos) then
		script_error("ERROR: get_closest_vehicle() called but supplied position [" .. tostring(pos) .. "] is not a vector");
		return false;
	end;

	local closest_vehicle = nil;
	local closest_distance = 5000;

	local assault_equipment = bm:assault_equipment();
	for i = 1, assault_equipment:vehicle_count() do
		local current_vehicle = assault_equipment:vehicle_item(i);
		local current_distance = current_vehicle:position():distance(pos);

		if current_distance < closest_distance then
			closest_vehicle = current_vehicle;
			closest_distance = current_distance;
		end;
	end;

	return closest_vehicle;
end;


--- @function get_closest_capture_location
--- @desc Returns the closest capture location to the supplied position. If no capture location is present on the map then @nil is returned.
--- @p @battle_vector position
--- @r @battle_capture_location closest capture location
function battle_manager:get_closest_capture_location(pos)
	if not validate.is_vector(pos) then
		return false;
	end;

	local closest_cl = nil;
	local closest_distance = 5000;

	local clm = bm:capture_location_manager();
	for i = 1, clm:count() do
		local current_cl = clm:item(i);
		local current_distance = current_cl:position():distance(pos);

		if current_distance < closest_distance then
			closest_cl = current_cl;
			closest_distance = current_distance;
		end;
	end;

	return closest_cl;
end;


--- @function get_general
--- @desc Returns the first commanding @battle_unit found in the supplied units collection. Supported collection types are @battle_units, @battle_army and @script_units. If no commanding unit is found then <code>false</code> is returned.
--- @p collection unit collection, Unit collection object.
--- @r @battle_unit commanding unit
function battle_manager:get_general(object)

	if is_units(object) then
		for i = 1, object:count() do
			if object:item(i):is_commanding_unit() then
				return object:item(i);
			end;
		end;
		return false;

	elseif is_army(object) then
		return self:get_general(object:units());

	elseif is_scriptunits(object) then
		for i = 1, object:count() do
			if object:item(i).unit:is_commanding_unit() then
				return object:item(i).unit;
			end;
		end;
		return false;
	end;
end;


--- @function player_army_is_subculture
--- @desc Returns whether the local player army is of the supplied subculture.
--- @p @string subculture key
--- @r @boolean subculture matches
function battle_manager:player_army_is_subculture(subculture_key)
	return self:get_player_army():subculture_key() == subculture_key;
end;


--- @function player_army_is_faction
--- @desc Returns whether the local player army is of the supplied faction.
--- @p @string faction key
--- @r @boolean faction key matches
function battle_manager:player_army_is_faction(faction_key)
	return self:get_player_army():faction_key() == faction_key;
end;













----------------------------------------------------------------------------
--- @section Scripted Tours
----------------------------------------------------------------------------


--- @function load_scripted_tours
--- @desc Loads all scripted tour scripts. Calling this allows battle scripted tours to work.
function battle_manager:load_scripted_tours()
	package.path = package.path .. ";data/script/battle/scripted_tours/?.lua";
	require("battle_tours");
end;











----------------------------------------------------------------------------
--- @section Random Numbers
----------------------------------------------------------------------------


--- @function random_number
--- @desc Returns a random number. If no min or max bounding values are supplied then the value returned is a float between 0 and 1. If a single integer number argument is supplied, then the value returned is an integer value from 1 to the max value. If two integer min/max arguments are supplied then the value returned is an integer value between the first and the second.
--- @p [opt=nil] @number first number, First number argument - this is the maximum value for the returned random integer if no second argument is supplied, or the mininum value if a second argument is provided.
--- @p [opt=nil] @number max number, Maximum value for the returned random integer.
--- @r @number random number
function battle_manager:random_number(param_a, param_b)

	if param_a then
		if not validate.is_integer(param_a) then
			return false;
		end;
	else
		-- No values supplied, just return what the underlying battle:random_number() returns
		return self.battle:random_number();
	end;

	local min, max;

	if param_b then
		if not validate.is_integer(param_b) then
			return false;
		end;

		min = param_a;
		max = param_b;
	else
		min = 1;
		max = param_a;
	end;

	if max == min then
		return min;
	end;

	if max < min then
		if param_b then
			script_error("ERROR: random_number() called but supplied max value [" .. param_b .. "] is less than supplied min value [" .. param_a .. "] - swap the arguments");
		else
			script_error("ERROR: random_number() called but supplied max value [" .. param_a .. "] is less than one - to get a random number less than one, please supply a min and a max value");
		end;
		return false;
	end;

	return math.floor(self.battle:random_number() * (1 + max - min)) + min;
end;


--- @function random_sort
--- @desc Randomly sorts a numerically-indexed table. This is safe to use in multiplayer, but will destroy the supplied table. It is faster than @battle_manager:random_sort_copy.
--- @desc Note that records in this table that are not arranged in an ascending numerical index will be lost.
--- @desc Note also that the supplied table is overwritten with the randomly-sorted table, which is also returned as a return value.
--- @p @table numerically-indexed table, Numerically-indexed table. This will be overwritten by the returned, randomly-sorted table.
--- @r @table randomly-sorted table
function battle_manager:random_sort(t)
	if not is_table(t) then
		script_error("ERROR: random_sort() called but supplied object [" .. tostring(t) .. "] is not a table");
		return false;
	end;

	local new_t = {};
	local table_size = #t;
	local n = 0;

	for i = 1, table_size do
		
		-- pick an entry from t, add it to new_t, then remove it from t
		n = self:random_number(#t);
		
		table.insert(new_t, t[n]);
		table.remove(t, n);
	end;

	return new_t;
end;


--- @function random_sort_copy
--- @desc Randomly sorts a numerically-indexed table. This is safe to use in multiplayer, and will preserve the original table, but it is marginally slower than @battle_manager:random_sort.
--- @desc Note that records in the source table that are not arranged in an ascending numerical index will not be copied (they will not be deleted, however).
--- @p @table numerically-indexed table, Numerically-indexed table.
--- @r @table randomly-sorted table
function battle_manager:random_sort_copy(t)
	if not is_table(t) then
		script_error("ERROR: random_sort_copy() called but supplied object [" .. tostring(t) .. "] is not a table");
		return false;
	end;

	local table_size = #t;
	local new_t = {};

	-- copy this table
	for i = 1, table_size do
		new_t[i] = t[i];
	end;

	return self:random_sort(new_t);
end;





















----------------------------------------------------------------------------
--- @section Battle Startup and Phases
--- @desc As a battle loads and progresses it passes through phases, such as "Deployment", "Deployed" (main battle phase), "VictoryCountdown" and "Complete". The script gets notified as phase changes occur
----------------------------------------------------------------------------


--- @function setup_battle
--- @desc Packaged function to set up a scripted battle on startup, and register a function to be called when the deployment phase ends (i.e. when battle starts). <code>setup_battle</code> will suppress a variety of unit sounds and steal input focus until the combat phase begins.
--- @p function deployment end callback
function battle_manager:setup_battle(new_deployment_end_callback)
	
	self.battle:suspend_contextual_advice(true);
	self.battle:suppress_unit_voices(true);
	self.battle:suppress_unit_musicians(true);
	self.battle:steal_input_focus();
	
	self:register_phase_change_callback(
		"Deployed", 
		function() 
			self:end_deployment();
			new_deployment_end_callback();
		end
	);
	
	self:register_phase_change_callback("VictoryCountdown", function() self.battle_is_won = true end);
	
	self:register_phase_change_callback("Complete", function() self:suspend_contextual_advice(false) end);
end;


function battle_manager:end_deployment()
	self.battle:release_input_focus();
	self.battle:suppress_unit_voices(false);
	self.battle:suppress_unit_musicians(false);
end;


--- @function register_phase_change_callback
--- @desc Registers a function to be called when a specified phase change occurs. Phase change notifications are sent to the script by the game when the battle changes phases, from 'Deployment' to 'Deployed' and on to 'VictoryCountdown' and 'Complete'. The battle manager writes debug output whenever a phase change occurs, regardless of whether any callback has been registered for it.
--- @desc This wraps the underlying functionality provided by @battle:register_battle_phase_handler. See that function's documentation for a list of phase change events that may be listened for.
--- @p string phase name
--- @p function callback
function battle_manager:register_phase_change_callback(phase_name, callback)
	if not is_string(phase_name) then
		script_error("ERROR: battle_manager:register_phase_change_callback() called but specified phase name [" .. tostring(phase_name) .. "] is not a string");
		return false;
	end;

	if not is_function(callback) then
		script_error("ERROR: battle_manager:register_phase_change_callback() callback but specified callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	local new_phase_change_callback = {
		phase_name = phase_name,
		callback = callback
	};
	
	table.insert(self.phase_change_callback_list, new_phase_change_callback);
end;


--- @function get_current_phase_name
--- @desc Returns the name of the current battle phase.
--- @r @string phase name
function battle_manager:get_current_phase_name()
	return self.current_phase or "";
end;


--- @function is_deployment_phase
--- @desc Returns whether the battle is currently in deployment phase.
--- @r @boolean is deployment phase
function battle_manager:is_deployment_phase()
	return self.current_phase == "Deployment";
end;


--- @function is_conflict_phase
--- @desc Returns whether the battle is currently in the conflict phase.
--- @r @boolean is conflict phase
function battle_manager:is_conflict_phase()
	return self.current_phase == "Deployed";
end;


--- @function is_victory_countdown_phase
--- @desc Returns whether the battle is currently in the victory countdown phase.
--- @r @boolean is victory countdown phase
function battle_manager:is_victory_countdown_phase()
	return self.current_phase == "VictoryCountdown";
end;


-- internal phase change listener function
function battle_manager_phase_change(phase)
	local phase_name = phase:get_name();
	bm:out("\tBattle is now entering phase: " .. phase_name);
	bm.current_phase = phase_name;

	for i = 1, #bm.phase_change_callback_list do	
		if string.lower(bm.phase_change_callback_list[i].phase_name) == string.lower(phase_name) then
			bm.phase_change_callback_list[i].callback();
		end;
	end;

	core:trigger_event("ScriptEventBattlePhaseChanged", phase_name);
end;









----------------------------------------------------------------------------
--- @section Unit Selection Callbacks
----------------------------------------------------------------------------

--- @function register_unit_selection_callback
--- @desc Registers a function to be called when a specified unit is selected by the player.
--- @p unit subject unit
--- @p function callback
function battle_manager:register_unit_selection_callback(unit, callback)
	if not is_unit(unit) then
		script_error("ERROR: battle_manager:register_unit_selection_callback() called but supplied unit " .. tostring(unit) .. " is not a unit");
		return false;
	end;

	if not is_function(callback) then
		script_error("ERROR: battle_manager:register_unit_selection_callback() called but supplied callback " .. tostring(callback) .. " is not a function");
		return false;
	end;
	
	local unit_selection_callback = {
		unit = unit,
		callback = callback
	};
	
	if #self.unit_selection_callback_list == 0 then
		self:register_unit_selection_handler("battle_manager_unit_selection_handler");
	end;
	
	table.insert(self.unit_selection_callback_list, unit_selection_callback);
end;


--- @function unregister_unit_selection_callback
--- @desc Unregisters a function registered with @battle_manager:register_unit_selection_callback.
--- @p unit subject unit
function battle_manager:unregister_unit_selection_callback(unit)
	for i = 1, #self.unit_selection_callback_list do
		if self.unit_selection_callback_list[i].unit == unit then
			table.remove(self.unit_selection_callback_list, i);
			
			if #self.unit_selection_callback_list == 0 then
				self:unregister_unit_selection_handler();
			end;
			return;
		end;
	end;
end;


function battle_manager_unit_selection_handler(unit, selected)	
	for i = 1, #bm.unit_selection_callback_list do
		local current_unit_selection_callback_entry = bm.unit_selection_callback_list[i];
	
		if current_unit_selection_callback_entry and current_unit_selection_callback_entry.unit == unit then
			current_unit_selection_callback_entry.callback(unit, selected);
		end;
	end;
end;










----------------------------------------------------------------------------
--- @section Command Handler Callbacks
----------------------------------------------------------------------------

--- @function register_command_handler_callback
--- @desc Registers a function to be called when a command event is issued by the game. The function will be called with the command handler context supplied as a single argument, which can be queried for further information depending upon the command.
--- @desc This wraps the underlying functionality provided by @battle:register_command_handler. See the documentation of that function for more information about what command events can be listened for, and what contextual information those events provide.
--- @p string command, Command name to listen for.
--- @p function callback, Callback to call when the command is triggered by the game.
--- @p [opt=nil] string callback name, Optional name by which this callback handler can be removed.
function battle_manager:register_command_handler_callback(command_name, callback, callback_name)
	if not is_string(command_name) then
		script_error("ERROR: battle_manager:register_command_handler_callback() called but supplied command name " .. tostring(command_name) .. " is not a string");
		return false;
	end;

	if not is_function(callback) then
		script_error("ERROR: battle_manager:register_command_handler_callback() called but supplied callback " .. tostring(callback) .. " is not a function");
		return false;
	end;
	
	if callback_name and not is_string(callback_name) then
		script_error("ERROR: battle_manager:register_command_handler_callback() called but supplied callback_name " .. tostring(callback_name) .. " is not a string");
		return false;
	end;
	
	-- work out whether to register the command handler
	if not self:are_any_command_handlers_registered() then
		self:register_command_handler("battle_manager_command_handler");
	end;
	
	-- add a table for this command if one does not already exist
	if not self.command_handler_callback_list[command_name] then
		self.command_handler_callback_list[command_name] = {};
	end;
	
	-- build a callback record
	local callback_record = {
		callback = callback,
		callback_name = callback_name
	};
	
	-- add the callback record to the relevant command table
	table.insert(self.command_handler_callback_list[command_name], callback_record);
end;


-- internal function
function battle_manager:are_any_command_handlers_registered()
	for command_name, handler_callbacks in pairs(self.command_handler_callback_list) do
		if #handler_callbacks > 0 then
			return true;
		end;
	end;
	return false;
end;


--- @function unregister_command_handler_callback
--- @desc Unregisters a callback function registered with @battle_manager:register_command_handler_callback. The callback function is specified by the command name and callback name specified when setting the callback up.
--- @p string command name
--- @p string callback name
function battle_manager:unregister_command_handler_callback(command_name, callback_name)
	if not is_string(command_name) then
		script_error("ERROR: battle_manager:unregister_command_handler_callback() called but supplied command name " .. tostring(command_name) .. " is not a string");
		return false;
	end;
	
	if not is_string(callback_name) then
		script_error("ERROR: battle_manager:unregister_command_handler_callback() called but supplied callback name " .. tostring(callback_name) .. " is not a string");
		return false;
	end;

	local command_table = self.command_handler_callback_list[command_name];
	
	if command_table then
		for i = #command_table, 1, -1 do
			if command_table[i].callback_name == callback_name then
				table.remove(command_table, i);
			end;
		end;
	end;
	
	-- unregister the command handler if we aren't using it any more
	if not self:are_any_command_handlers_registered() then
		self:unregister_command_handler();
	end;
end;


function battle_manager_command_handler(command_context)
	local command_records = bm.command_handler_callback_list[command_context:get_name()];
	
	if not command_records then
		return;
	end;
	
	-- push the commands into another table so the commands can't alter the table as we're walking over it
	local commands_to_call = {};
	for i = 1, #command_records do
		table.insert(commands_to_call, command_records[i].callback);
	end;
	
	for i = 1, #commands_to_call do
		commands_to_call[i](command_context);
	end;
end;










----------------------------------------------------------------------------
--- @section Input Handler Callbacks
----------------------------------------------------------------------------

--- @function register_input_handler_callback
--- @desc Registers a function to be called when an input event is issued by the game. This wraps the underlying functionality provided by @battle:register_input_handler. See the documentation of that function for more information about what input events can be listened for.
--- @p string input, Input name to listen for.
--- @p function callback, Callback to call when the input is triggered by the game.
--- @p [opt=nil] string callback name, Optional name by which this input handler can be removed.
function battle_manager:register_input_handler_callback(input_name, callback, callback_name)
	if not is_string(input_name) then
		script_error("ERROR: battle_manager:register_input_handler_callback() called but supplied input name " .. tostring(input_name) .. " is not a string");
		return false;
	end;

	if not is_function(callback) then
		script_error("ERROR: battle_manager:register_input_handler_callback() called but supplied callback " .. tostring(callback) .. " is not a function");
		return false;
	end;
	
	if callback_name and not is_string(callback_name) then
		script_error("ERROR: battle_manager:register_input_handler_callback() called but supplied callback_name " .. tostring(callback_name) .. " is not a string");
		return false;
	end;
	
	-- work out whether to register the input handler
	if not self:are_any_input_handlers_registered() then
		self:register_input_handler("battle_manager_input_handler");
	end;
	
	-- add a table for this input if one does not already exist
	if not self.input_handler_callback_list[input_name] then
		self.input_handler_callback_list[input_name] = {};
	end;
	
	-- build a callback record
	local callback_record = {
		callback = callback,
		callback_name = callback_name
	};
	
	-- add the callback record to the relevant input table
	table.insert(self.input_handler_callback_list[input_name], callback_record);
end;


-- internal function
function battle_manager:are_any_input_handlers_registered()
	for input_name, handler_callbacks in pairs(self.input_handler_callback_list) do
		if #handler_callbacks > 0 then
			return true;
		end;
	end;
	return false;
end;


--- @function unregister_input_handler_callback
--- @desc Unregisters a callback function registered with @battle_manager:register_input_handler_callback. The callback function is specified by the input name and callback name specified when setting the callback up.
--- @p string command name
--- @p string callback name
function battle_manager:unregister_input_handler_callback(input_name, callback_name)
	if not is_string(input_name) then
		script_error("ERROR: battle_manager:unregister_input_handler_callback() called but supplied input name " .. tostring(input_name) .. " is not a string");
		return false;
	end;
	
	if not is_string(callback_name) then
		script_error("ERROR: battle_manager:unregister_input_handler_callback() called but supplied callback name " .. tostring(callback_name) .. " is not a string");
		return false;
	end;

	local input_table = self.input_handler_callback_list[input_name];
	
	if input_table then
		for i = #input_table, 1, -1 do
			if input_table[i].callback_name == callback_name then
				table.remove(input_table, i);
			end;
		end;
	end;
	
	-- unregister the input handler if we aren't using it any more
	if not self:are_any_input_handlers_registered() then
		self:unregister_input_handler();
	end;
end;


function battle_manager_input_handler(input_name)
	local input_records = bm.input_handler_callback_list[input_name];
	
	if not input_records then
		return;
	end;
	
	-- push the inputs into another table so the commands can't alter the table as we're walking over it
	local commands_to_call = {};
	for i = 1, #input_records do
		table.insert(commands_to_call, input_records[i].callback);
	end;
	
	for i = 1, #commands_to_call do
		commands_to_call[i]();
	end;
end;











----------------------------------------------------------------------------
--- @section ESC Key Callback Queue
----------------------------------------------------------------------------

--- @function steal_escape_key_with_callback
--- @desc Steals the escape key if it wasn't stolen before, and registers a callback to be called if the player presses it. The callback entry must be registered with a unique string name, by which it may be cancelled later if desired.
--- @desc Multiple escape key callbacks may be registered at one time, although only the most recently-registered callback is notified when the ESC key is pressed. Once an ESC key callback is called it is removed from the list, and the next ESC key press causes the next most recent callback to be notified, and so-on.
--- @p @string callback name
--- @p @function callback
--- @p [opt=false] @boolean is persistent, Key should remain stolen after callback is first called.
function battle_manager:steal_escape_key_with_callback(name, callback, is_persistent)
	if not is_string(name) then
		script_error("ERROR: steal_escape_key_with_callback() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_function(callback) then
		script_error("ERROR: steal_escape_key_with_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	local esc_key_steal_list = self.esc_key_steal_list;
	
	-- don't proceed if a keysteal entry with this name currently exists in the list
	for i = 1, #esc_key_steal_list do
		if esc_key_steal_list[i].name == name then
			script_error("ERROR: steal_escape_key_with_callback() called but another process has already stolen the esc key with name [" .. name .. "]");
			return false;
		end;
	end;
	
	-- create a key steal entry
	local key_steal_entry = {
		["name"] = name,
		["callback"] = callback,
		["is_persistent"] = not not is_persistent
	};
	
	-- add this key steal entry at the end of the list
	table.insert(esc_key_steal_list, key_steal_entry);
	
	-- steal the esc key if it wasn't previously
	if #esc_key_steal_list == 1 then
		self:steal_escape_key();
	end;
	
	return true;
end;


--- @function release_escape_key_with_callback
--- @desc Cancels an escape key callback registered with @battle_manager:steal_escape_key_with_callback by name.
--- @p string callback name to cancel
function battle_manager:release_escape_key_with_callback(name)
	if not is_string(name) then
		script_error("ERROR: release_escape_key_with_callback() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	local esc_key_steal_list = self.esc_key_steal_list;
	
	for i = 1, #esc_key_steal_list do
		if esc_key_steal_list[i].name == name then
			table.remove(esc_key_steal_list, i);
			break;
		end;
	end;
	
	-- release the esc key if the list is now empty
	if #esc_key_steal_list == 0 then
		self:release_escape_key();
	end;
end;


function battle_manager:escape_key_pressed()
	local esc_key_steal_list = self.esc_key_steal_list;

	if #esc_key_steal_list == 0 then
		return;
	end;

	local record = esc_key_steal_list[#esc_key_steal_list];
	
	-- cache callback to call
	local callback = record.callback;
	
	-- remove callback entry from list if we should
	if not record.is_persistent then
		table.remove(esc_key_steal_list);
		
		-- if list is now empty, release the escape key
		if #esc_key_steal_list == 0 then
			self:release_escape_key();
		end;
	end;
	
	-- call the callback
	callback();
end;


function Esc_Key_Pressed()
	bm:escape_key_pressed();
end;






----------------------------------------------------------------------------
--- @section Victory Callbacks
----------------------------------------------------------------------------

--- @function setup_victory_callback
--- @desc Establishes a function to be called when the battle enters VictoryCountdown phase i.e. someone has won. This function also sets the duration of the victory countdown to infinite, meaning the battle will never end until @battle_manager:end_battle is called. This allows calling scripts to do things like set up an outro cutscene or play some advice that wouldn't fit into the standard victory countdown duration (10 seconds).
--- @p function callback to call
function battle_manager:setup_victory_callback(callback)
	self:register_victory_countdown_callback(callback);
	self:change_victory_countdown_limit(-1);
end;


function battle_manager:register_victory_countdown_callback(callback)
	self:register_phase_change_callback("VictoryCountdown", callback);
end;


--- @function end_battle
--- @desc Causes a battle to immediately end when it enters the VictoryCountdown phase, or to immediately end if it is already in that phase. This function is most commonly used to end a battle that has entered the VictoryCountdown phase after @battle_manager:setup_victory_callback has been called.
function battle_manager:end_battle()
	self:change_victory_countdown_limit(0);

	-- we also now have to call quit_battle() on the player's army to force the battle to end
	if self:get_current_phase_name() == "VictoryCountdown" then
		self:get_player_army():quit_battle();
	else
		self:register_phase_change_callback(
			"VictoryCountdown",
			function()
				self:get_player_army():quit_battle();
			end
		);
	end;
end;


--- @function restart_battle
--- @desc Immediately restarts the current battle.
function battle_manager:restart_battle()
	common.call_context_command("CcoBattleRoot", "", "RestartBattle");
end;


--- @function register_results_callbacks
--- @desc Old-style battle-ending handlers. These can still be used but won't get called until the battle results screen is shown. Registers player victory and player defeat callbacks to be called at the end of the battle.
--- @p function player victory callback
--- @p function player defeat callback
function battle_manager:register_results_callbacks(player_victory_callback, player_defeat_callback)
	self.player_victory_callback = player_victory_callback;
	self.player_defeat_callback = player_defeat_callback;
	
	self:register_command_handler_callback(
		"Battle Results",
		function(command_context)
			self:process_results(command_context)
		end,
		"battle_manager_battle_results"
	);
end;


function Battle_Manager_Battle_Results(event)
	if event:get_name() == "Battle Results" then
		bm:process_results(event:get_bool1());
	end;
end;


function battle_manager:process_results(result)
	if result then
		self:out("The Player has won the battle!");
		if self.player_victory_callback then
			self.player_victory_callback();
		else
			script_error("No victory callback was present? If you're not seeing outro advice and you expected to then something broke.");
		end;
	else
		self:out("The Player has lost the battle!");
		if self.player_defeat_callback then
			self.player_defeat_callback();
		else
			script_error("No defeat callback was present? If you're not seeing outro advice and you expected to then something broke.");
		end;
	end;
end;







----------------------------------------------------------------------------
--- @section Time Manipulation
----------------------------------------------------------------------------

--- @function slow_game_over_time
--- @desc Changes game speed from one value to another over a total time (note that this will be elongated by the slowing action) over a given number of steps. Note that the script engine only updates once every 1/10th of a second so specifying steps of less than this will have weird results. Speeds are specified as multiples of normal game speed, so a value of 2 would be twice normal speed, 0.5 would be half, and so on.
--- @p number start game speed
--- @p number target game speed
--- @p number duration in ms
--- @p number steps
function battle_manager:slow_game_over_time(start_game_speed, target_game_speed, total_time, steps)

	if not is_number(start_game_speed) then
		script_error("ERROR: slow_game_over_time() called but supplied start game speed [" .. tostring(start_game_speed) .. "] is not a number");
		return false;
	end;
	
	if not is_number(target_game_speed) then
		script_error("ERROR: slow_game_over_time() called but supplied target game speed [" .. tostring(target_game_speed) .. "] is not a number");
		return false;
	end;
	
	if not is_number(total_time) or total_time <= 0 then
		script_error("ERROR: slow_game_over_time() called but supplied time [" .. tostring(total_time) .. "] is not a number > 0");
		return false;
	end;
	
	if not is_number(steps) or steps <= 0 then
		script_error("ERROR: slow_game_over_time() called but supplied steps [" .. tostring(steps) .. "] is not a number > 0");
		return false;
	end;
	
	local speed_interval = (target_game_speed - start_game_speed) / steps;

	for i = 1, steps do
		self:callback(
			function()
				local new_speed = math.floor((start_game_speed + speed_interval * i) * 10 + 0.5) / 10;		-- precise to only one decimal place
				self:out("::: slow_game_over_time() changing battle speed to " .. new_speed);
				self:modify_battle_speed(new_speed, true);
			end, 
			(total_time / steps) * i,
			"battle_manager_slow_game_over_time"
		);
	end;
end;


--- @function stop_slow_game_over_time
--- @desc Cancels any running processes started by @battle_manager:slow_game_over_time.
function battle_manager:stop_slow_game_over_time()
	self:remove_process("battle_manager_slow_game_over_time");
end;


--- @function pause
--- @desc Pauses the battle.
function battle_manager:pause()
	self.battle:modify_battle_speed(0);
end;


--- @function modify_battle_speed
--- @desc Wrapper for the @battle:modify_battle_speed function, that prints output and notifies other systems that the model tick speed has changed.
--- @p @number speed, New battle speed, as a unary proportion of normal speed. Supply a value of 1 to set the battle speed to normal, 0.5 for half speed, 0 for pause etc.
--- @p [opt=false] @boolean silent, Silent flag - do not print output.
function battle_manager:modify_battle_speed(speed, silent)
	if not silent then
		self:out("::: changing battle speed to " .. speed);
	end;
	
	self.battle:modify_battle_speed(speed);
end;











-----------------------------------------------------------------------------
-- Achievements :: needs filling in for each game :<
-----------------------------------------------------------------------------


function battle_manager:unlock_achievement(key)
	if not is_string(key) then
		script_error("ERROR: unlock_achievement() called but achievement given [" .. tostring(key) .. "] is not a string");	
		return false;
	end;
	
	if key == "WH3_ACHIEVEMENT_PROLOGUE_COMPLETE" then
		self:out("\tUNLOCKING ACHIEVEMENT :: WH3_ACHIEVEMENT_PROLOGUE_COMPLETE :: The End of the Beginning :: Complete the Prologue."); 
		return self.battle:unlock_achievement("WH3_ACHIEVEMENT_PROLOGUE_COMPLETE");
	else
		script_error("unlock_achievement() called but supplied key is not a recognised achievement!");
	end
end;









----------------------------------------------------------------------------
--- @section Timer Callbacks
--- @desc Timer functionality - the ability for scripts to say that a function should be called after a certain interval (e.g. a second) - is provided by the @timer_manager object. The functions in this section provide a pass-through interface to the equivalent functions on the timer manager.
--- @desc Battle model time is measured in milliseconds throughout.
----------------------------------------------------------------------------


--- @function callback
--- @desc Calls the supplied function after the supplied interval in seconds using a timer synchronised to the battle model. A string name for the callback may optionally be provided to allow the callback to be cancelled later.
--- @desc This function call is passed through to @timer_manager:callback - this @battle_manager alias is provided purely for convenience.
--- @p function callback to call, Callback to call.
--- @p number interval, Interval in milliseconds after to which to call the callback.
--- @p [opt=nil] string name, Callback name. If supplied, this callback can be cancelled at a later time (before it triggers) with @battle_manager:remove_process or @battle_manager:remove_callback.
function battle_manager:callback(callback, interval, name)
	return self.tm:callback(callback, interval, name);
end;


--- @function repeat_callback
--- @desc Calls the supplied function repeatedly after the supplied period in seconds using a timer synchronised to the battle model. A string name for the callback may optionally be provided to allow the callback to be cancelled. Cancelling the callback is the only method to stop a repeat callback, once started.
--- @desc This function call is passed through to @timer_manager:callback - this @battle_manager alias is provided purely for convenience.
--- @p @function callback to call, Callback to call.
--- @p @number time, Time in milliseconds after to which to call the callback, repeatedly. The callback will be called each time this interval elapses.
--- @p [opt=nil] @string name, Callback name. If supplied, this callback can be cancelled at a later time with @battle_manager:remove_callback.
function battle_manager:repeat_callback(callback, interval, name)
	return self.tm:repeat_callback(callback, interval, name);
end;


--- @function remove_callback
--- @desc Removes a callback previously added with @battle_manager:callback or @battle_manager:repeat_callback by name. All callbacks with a name matching that supplied will be cancelled and removed.
--- @desc This function call is passed through to @timer_manager:remove_callback - this @battle_manager alias is provided purely for convenience. See also @battle_manager:remove_process, which also removes any watches with the specified name.
--- @p @string name, Name of callback to remove.
function battle_manager:remove_callback(name)
	self.tm:remove_callback(name);
end;


--- @function real_callback
--- @desc Adds a real callback to be called after the supplied interval has elapsed. Real timers are synchronised to UI updates, not to the game model - see @"timer_manager:Real Timers" for more information.
--- @desc This function call is passed through to @timer_manager:real_callback - this @battle_manager alias is provided purely for convenience.
--- @p @function callback, Callback to call.
--- @p @number interval, Interval after which to call the callback, in milliseconds.
--- @p [opt=nil] @string name, Callback name, by which it may be later removed with @battle_manager:remove_real_callback. If omitted the callback may not be cancelled.
function battle_manager:real_callback(callback, interval, name)
	self.tm:real_callback(callback, interval, name);
end;


--- @function repeat_real_callback
--- @desc Adds a repeating real callback to be called each time the supplied interval elapses. Real timers are synchronised to UI updates, not to the game model - see @"timer_manager:Real Timers" for more information.
--- @desc This function call is passed through to @timer_manager:repeat_real_callback - this @battle_manager alias is provided purely for convenience.
--- @p @function callback, Callback to call.
--- @p @number interval, Repeating interval after which to call the callback, in milliseconds.
--- @p [opt=nil] @string name, Callback name, by which it may be later removed with @battle_manager:remove_real_callback. If omitted the repeating callback may not be cancelled.
function battle_manager:repeat_real_callback(callback, interval, name)
	self.tm:repeat_real_callback(callback, interval, name);
end;


--- @function remove_real_callback
--- @desc Removes a real callback previously added with @battle_manager:real_callback or @battle_manager:repeat_real_callback by name. All callbacks with a name matching that supplied will be cancelled and removed.
--- @desc This function call is passed through to @timer_manager:remove_real_callback - this @battle_manager alias is provided purely for convenience.
--- @p @string name, Name of callback to remove.
function battle_manager:remove_real_callback(name)
	self.tm:remove_real_callback(name);
end;













-----------------------------------------------------------------------------
--- @section Watches
--- @desc A watch is a process that continually polls a supplied condition. When it is true, the watch process waits for a supplied period, and then calls a supplied target function. Watches provide battle scripts with a fire-and-forget method of polling the state of the battle, and of being notified when that state changes in some crucial way.
-----------------------------------------------------------------------------

--- @function watch
--- @desc Establishes a new watch. A supplied condition function is repeated tested and, when it returns true, a supplied target function is called. A wait period between the condition being met and the target being called must also be specified. A name for the watch may optionally be specified to allow other scripts to cancel it.
--- @desc The condition must be a function that returns a value - when that value is true (or evaluates to true) then the watch condition is met. The watch then waits the supplied time offset, which is specified in ms as the second parameter, before calling the callback supplied in the third parameter.
--- @p function condition
--- @p function condition, Condition. Must be a function that returns a value. When the returned value is true, or evaluates to true, then the watch condition is met.
--- @p number wait time, Time in ms that the watch waits once the condition is met before triggering the target callback
--- @p function target callback, Target callback
--- @p [opt=nil] string watch name, Name for this watch process. Giving a watch a name allows it to be stopped/cancelled with @battle_manager:remove_process.
function battle_manager:watch(new_condition, new_time_offset, new_callback, new_entryname)
	if not is_function(new_condition) then
		script_error("ERROR: battle_manager:watch() called but supplied condition " .. tostring(new_condition) .. " is not a function!");
		
		return false;
	end;
	
	if not is_number(new_time_offset) or new_time_offset < 0 then
		script_error("ERROR: battle_manager:watch() called but supplied time offset " .. tostring(new_time_offset) .. " is not a positive number!");
		
		return false;
	end;
	
	if not is_function(new_callback) then
		script_error("ERROR: battle_manager:watch() called but supplied callback " .. tostring(new_callback) .. " is not a function!");
		
		return false;
	end;
	
	local new_entryname = new_entryname or "";
	
	local new_watch_entry = {
		condition = new_condition, 
		time_offset = new_time_offset, 
		callback = new_callback, 
		entryname = new_entryname, 
		last_check = 0
	};
		
	table.insert(self.watch_list, new_watch_entry);
	
	if #self.watch_list == 1 then
		self:register_repeating_timer("battle_manager_tick_watch_counter", 2000);
		self.watch_timer_running = true;
	end;
end;


function battle_manager_tick_watch_counter()
	bm:tick_watch_counter();
end;


function battle_manager:tick_watch_counter()
	if #self.watch_list == 0 then
		return false;
	end;
	
	if not self.load_balancing then
		-- old non-load-balancing script

		local i = 1;
		local j = #self.watch_list;
		local result = false;
		local should_rescan = false;
		
		while i <= j do
			-- process the next watch entry, get back the result and whether it was processed immediately
			result, should_rescan = self:check_watch_entry(i);

			if should_rescan then
				self:tick_watch_counter(); -- rescan the whole list
				
				return false;
			elseif result then
				j = j - 1;
			else
				i = i + 1;
			end;			
		end;
	else
		-- load-balancing script
		
		-- stop the regular watch timer if it's running
		if self.watch_timer_running then
			self.watch_timer_running = false;
			self:unregister_timer("battle_manager_tick_watch_counter");
		end;
		
		-- work out how many watch entries to scan this tick
		local watch_entries_per_tick = math.ceil(#self.watch_list / self.model_ticks_per_second);
				
		local next_watch = false;
		
		for i = 1, watch_entries_per_tick do
			-- find watch entry with lowest last_check value
			next_watch = self:get_next_watch_entry();
			
			if next_watch then
				-- check it
				local result, need_to_rescan = self:check_watch_entry(next_watch);				
				
				if need_to_rescan then
					self:tick_watch_counter(); -- rescan the whole list
				
					return false;
				end;
			end;			
		end;
		
		self:callback(function() self:tick_watch_counter() end, 100, "tick_watch_counter");
	end;
	
end;

-- go through all the watches and return the one that happened the longest time ago
function battle_manager:get_next_watch_entry()
	if #self.watch_list == 0 then
		return false;
	end;

	local lowest_check = self:time_elapsed_ms() + 100;
	local next_watch = 0;
	local next_watch_last_check = 0;
	
	for i = 1, #self.watch_list do
		next_watch_last_check = self.watch_list[i].last_check;
	
		if next_watch_last_check < lowest_check then
			next_watch = i;
			lowest_check = next_watch_last_check;
		end;
	end;
	
	return next_watch;
end;


-- check the result of a particular watch, takes an entry number in the 
-- battle manager watch list as parameter
function battle_manager:check_watch_entry(entry_number)
	local w = self.watch_list[entry_number];

	w.last_check = self:time_elapsed_ms();
			
	-- determine the result of the condition
	local result = w.condition();
		
	-- if the callback happened immediately then we need to rescan the 
	-- whole list as it could have been mangled by whatever the callback did
	local need_to_rescan = false;
	
	-- if it succeeded then we need to call the callback, either now or in the future
	-- (depending on the offset) and also remove the current watch from the watch list
	if result then
		if w.time_offset == 0 then
			local callback = w.callback;
			table.remove(self.watch_list, entry_number);
			
			-- REMOVE
			-- out.design("\tgoing to call callback");
			
			callback();
			
			-- REMOVE
			-- out.design("\tcallback call completed");
			need_to_rescan = true;
		else
			self:callback(w.callback, w.time_offset, w.entryname);
			table.remove(self.watch_list, entry_number);
		end;
	end;
	
	return result, need_to_rescan;
end;


--- @function remove_process
--- @desc Stops and removes any watch OR callback with the supplied name. Returns true if any were found, false otherwise.
--- @p string name
--- @r boolean any removed
function battle_manager:remove_process(key)
	-- make sure it does both
	local retval = self:remove_process_from_watch_list(key);
	
	return self.tm:remove_callback(key) or retval;
end;


--- @function remove_process_from_watch_list
--- @desc Stops and removes any watch with the supplied name. Returns true if any were found, false otherwise. Best practice is to use remove_process instead of this.
--- @p string name
--- @r boolean any removed
function battle_manager:remove_process_from_watch_list(key)
	if #self.watch_list == 0 then
		return false;
	end;
	
	local i = 1;
	local j = #self.watch_list;
	local have_removed_entry = false;
	
	-- walk through the watch list looking for watches with the given key
	while i <= j do
		if self.watch_list[i].entryname == key then
			table.remove(self.watch_list, i);
			have_removed_entry = true;
			j = j - 1;
		else
			i = i + 1;
		end;
	end;
	
	return have_removed_entry;
end;


--- @function print_watch_list
--- @desc Debug command to dump the watch list to the console output spool.
function battle_manager:print_watch_list()
	if #self.watch_list == 0 then
		self:out("Watch list is empty");
		return;
	end;
	
	self:out("Watch list now looks like:");
	for i = 1, #self.watch_list do
		self:out(i .. ":  " .. tostring(self.watch_list[i].entryname));
	end;
end;


--- @function clear_watches_and_callbacks
--- @desc Cancels all running watches and callbacks. It's highly recommend to not call this except for debug purposes (and rarely, even then).
function battle_manager:clear_watches_and_callbacks()
	self.tm:clear_callback_list();
	
	self.watch_list = {};
	
	-- stop the regular watch timer if it's running (load-balanced watch timer is already cancelled by blanking the callback list)
	if self.watch_timer_running then
		self.watch_timer_running = false;
		self:unregister_timer("battle_manager_tick_watch_counter");
	end;
end;


--- @function set_load_balancing
--- @desc By default the watch system performs load balancing, where it tries to stagger its running watches so they don't all process on the same tick. If this is causes problems for any reason it can be disabled with <code>set_load_balancing</code>. Supply a boolean parameter to enable or disable load balancing.
--- @p boolean enable load balancing
function battle_manager:set_load_balancing(value)
	if not is_boolean(value) then 
		value = true;
	end;

	self.load_balancing = value;
end;








-----------------------------------------------------------------------------
--- @section Advisor Queue
--- @desc The advisor queueing functionality allows the calling script to queue advisor messages so they don't clumsily collide with each other during playback.
-----------------------------------------------------------------------------


--- @function queue_advisor
--- @desc Enqueues a line of advice for delivery to the player. If there is no other advice playing, or nothing is blocking the advisor system, then the advice gets delivered immediately. Otherwise, the supplied advice will be queued and shown at an appropriate time.
--- @desc The function must be supplied an advice key from the advice_levels/advice_threads tables as its first parameter, unless the advisor entry is set to be debug (see below).
--- @p string advice key, Advice key from the advice_levels/advice_threads table.
--- @p_long_desc If the advice entry is set to be debug (see third parameter) the text supplied here will instead be shown directly in the advisor window (debug only)
--- @p [opt=0] number forced duration, Forced duration in ms. This is a period that this advice must play for before another item of advice is allowed to start. By default, items of advice will only remain queued while the active advice is actually audibly playing, but by setting a duration the active advice can be held on-screen for longer than the length of its associated soundfile (unless it is closed by the player). This is useful during development to hold advice on-screen when no soundfile yet exists, and also for tutorial scripts which often wish to ensure that an item of advice is shown on-screen for a certain duration.
--- @p [opt=false] boolean debug, Sets whether the advice line is debug. If set to true, the text supplied as the first parameter is displayed in the advisor window as-is, without using it as a lookup key in the advice_levels table.
--- @p [opt=nil] function start callback, Start callback. If a function is supplied here it is called when the advice is actually played.
--- @p [opt=0] number start callback wait, Start callback wait period in ms. If a duration is specified it causes a delay between the advice being played and the start callback being called.
--- @p [opt=nil] playback condition, Playback condition. If specified, it compels the advisor system to check this condition immediately before playing the advisor entry to decide whether to actually proceed. This must be supplied as a function block that returns a result. If this result evaluates to true, the advice is played.
function battle_manager:queue_advisor(new_advisor_string, new_duration, new_is_debug, new_callback, new_callback_offset, new_advice_offset, new_condition)
	if self.advice_dont_play then
		return;
	end;
	
	if not is_string(new_advisor_string) then
		script_error("ERROR :: queue_advisor called with non-string parameter (" .. tostring(new_advisor_string) .. "), cannot queue this!");
		return false;
	end;
	
	-- if the advisor system was manually stopped in the last 500ms (usually this same tick), wait for a little bit to allow the system to clear
	if self.advisor_stopping then
		self:callback(function() self:queue_advisor(new_advisor_string, new_duration, new_is_debug, new_callback) end, self.advisor_reopen_wait, "battle_manager_advisor_stopping");
		return false;
	end
	
	if not is_number(new_duration) then
		new_duration = 0;
	end;
	
	if not is_function(new_callback) then
		new_callback = nil;
	end;
	
	if not is_number(new_callback_offset) then
		new_callback_offset = 0;
	elseif new_callback_offset < 0 then
		script_error("WARNING: battle_manager:queue_advisor called but a negative callback offset [" .. tostring(new_callback_offset) .. "] was specified, setting to 0");
		new_callback_offset = 0;
	end;
	
	if not is_number(new_advice_offset) then
		new_advice_offset = 0;
	elseif new_advice_offset < 0 then
		script_error("WARNING: battle_manager:queue_advisor called but a negative callback offset [" .. tostring(new_advice_offset) .. "] was specified, setting to 0");
		new_advice_offset = 0;
	end;
	
	local new_is_debug = new_is_debug or false;

	local advisor_entry = {
		advisor_string = new_advisor_string, 
		duration = new_duration, 
		is_debug = new_is_debug,
		callback = new_callback,
		callback_offset = new_callback_offset,
		advice_offset = new_advice_offset,
		condition = new_condition
	};

	table.insert(self.advisor_list, advisor_entry);

	if not self.advice_is_playing then
		self:play_next_advice();
	end;
end;


-- plays the next queued advice
function battle_manager:play_next_advice()

	if self.advice_dont_play then
		return;
	end;

	-- the game reckons it's still playing some advice, so try again later
	-- if the last advisor action was to stop advice, then don't bother with this as the next advisor should just override it
	if not self.advisor_last_action_was_stop and not self:advice_finished() then	
		self:remove_process("battle_manager_advisor_queue");
		self:callback(function() self:watch_advice_queue() end, 500, "battle_manager_advisor_queue");
		
		return false;
	end;
	
	self.advisor_last_action_was_stop = false;
	
	-- if we have no more advice to play, stop
	if #self.advisor_list == 0 then
		if self.should_close_queue_advice then
			self:close_advisor();
		end;
		
		self.advice_is_playing = false;
		
		return false;
	end;
		
	local current_advice = self.advisor_list[1];
	
	if is_function(current_advice.condition) then
		if not current_advice.condition() then
			self:out("Tried to play advice [" .. current_advice.advisor_string .. "] but condition failed, skipping");
			table.remove(self.advisor_list, 1);
			self:play_next_advice();
			return;
		end;		
	end;
	
	self.advice_is_playing = true;
	self.advice_has_played_this_battle = true;
	
	local advice_offset = current_advice.advice_offset;
	
	-- play first bit of advice in the list
	if current_advice.is_debug then
		if advice_offset > 0 then
			self:callback(function() common.advice(current_advice.advisor_string) end, advice_offset);
		else
			common.advice(current_advice.advisor_string);
		end;		
	else	
		if advice_offset > 0 then
			self:callback(
				function() 
					common.advance_scripted_advice_thread(current_advice.advisor_string, 1);
					get_infotext_manager():notify_of_advice(current_advice.advisor_string);
				end, 
				advice_offset, 
				"battle_manager_pending_advice"
			);
		else
			common.advance_scripted_advice_thread(current_advice.advisor_string, 1);
			get_infotext_manager():notify_of_advice(current_advice.advisor_string);
		end;
	end;
	
	self:remove_process("battle_manager_advisor_queue");
	
	-- prevent the advisor from closing or progressing until after the allotted duration is over
	-- note that if the player closes the advisor dialog this isn't picked up on 
	if current_advice.duration > 0 then
		self.advisor_force_playing = true;		
		self:callback(function() self.advisor_force_playing = false end, current_advice.duration, "battle_manager_advisor_queue");
	end;
	
	-- call callback if there is one
	if is_function(current_advice.callback) then
		if current_advice.callback_offset == 0 then
			current_advice.callback();
		else
			-- offset the call by the supplied offset if there is one
			self:callback(function() current_advice.callback() end, current_advice.callback_offset, "battle_manager_advisor_queue");
		end;
	end;
	
	-- remove first element in the table now that it's being played
	table.remove(self.advisor_list, 1);
	
	self:callback(function() self:watch_advice_queue() end, 500, "battle_manager_advisor_queue");
end;


function battle_manager:watch_advice_queue()
	-- if the current bit of advice has finished playing then wait a bit and try to play the next, else re-check in 500ms
	if self:advice_finished() then
		self:callback(function() self:play_next_advice() end, 2000, "battle_manager_advisor_queue");
	else
		self:callback(function() self:watch_advice_queue() end, 500, "battle_manager_advisor_queue");
	end;
end;


--- @function stop_advisor_queue
--- @desc Cancels any running advice, and clears any subsequent advice that may be queued.
--- @p [opt=false] boolean close advisor, Closes the advisor if it's open
--- @p [opt=false] boolean force immediate stop, Forces immediate stop. By default the stopping action takes a short amount of time - the game seems happier with this. If set to true, this flag bypasses this behaviour. User beware.
function battle_manager:stop_advisor_queue(should_close, force_immediate_stop)
	if should_close then
		self:close_advisor();
	end;
	self:remove_process("battle_manager_advisor_queue");
	self.advisor_list = {};
	self.advice_is_playing = false;
	self.advisor_force_playing = false;
	self.advisor_last_action_was_stop = true;
	
	-- take a note that the advisor is stopping, and delay and queueing for a bit if so - the game doesn't
	-- seem to like stopping and then immediately re-queueing
	-- The force_immediate_stop flag bypasses this, which can be useful when time is being manipulated. Buyer beware in this case etc.
	
	if not force_immediate_stop then
		self.advisor_stopping = true;
		self:callback(function() self.advisor_stopping = false end, self.advisor_reopen_wait, "battle_manager_stop_advisor_queue");
	end;
end;


--- @function advice_cease
--- @desc Stops the advisor queue and prevents any more advice from being queued. The advice system will only subsequently restart if @battle_manager:advice_resume is called.
function battle_manager:advice_cease()
	self:out("Ceasing all advice");
	self:stop_advisor_queue(true);
	self.advice_dont_play = true;
end;


--- @function advice_resume
--- @desc Allows advice to resume after @battle_manager:advice_cease has been called.
function battle_manager:advice_resume()
	self.advice_dont_play = false;
end;


--- @function stop_advice_on_battle_end
--- @desc Establishes a listener which stops the advice system as soon as the battle results panel appears.
function battle_manager:stop_advice_on_battle_end()
	core:add_listener(
		"bm_stop_advice_on_battle_end",
		"PanelOpenedBattle",
		function(context) return context.string == "in_battle_results_popup" end,
		function() self:advice_cease() end,
		false
	);
end;


function battle_manager:advice_finished()
	if self.battle:advice_finished() and not self.advisor_force_playing then
		return true;
	end;
	
	return false;
end;


--- @function set_close_queue_advice
--- @desc Sets whether the advisor system should close the advisor panel once an item of advice has finished playing. By default this is set to false, so use this function to turn this behaviour on.
--- @p [opt=true] boolean value
function battle_manager:set_close_queue_advice(value)
	if value == false then
		self.should_close_queue_advice = false;
	else
		self.should_close_queue_advice = true;
	end;
end;


--- @function has_advice_played_this_battle
--- @desc Returns true if any advice has played in this battle session
--- @r boolean advice has played
function battle_manager:has_advice_played_this_battle()
	return self.advice_has_played_this_battle;
end;


--- @function modify_advice
--- @desc Modifies the advisor panel to show the progress/close button in the bottom right, and also to highlight this button with an animated ring around it. This setting will persist across subsequent items of advice in a battle session until modified again.
--- @p [opt=false] boolean show button, Show progress/close button.
--- @p [opt=false] boolean show highlight, Show highlight on close button.
function battle_manager:modify_advice(progress_button, highlight)
	-- if the component doesn't exist yet, wait a little bit as it's probably in the process of being created
	if not find_uicomponent(core:get_ui_root(), "advice_interface") then
		self:callback(function() self:modify_advice(progress_button, highlight) end, 200, self.modify_advice_str);
		return;
	end;

	self:remove_process(self.modify_advice_str);

	if progress_button then
		show_advisor_progress_button();
		
		local dismiss_advice_str = "dismiss_advice_str";
		
		core:remove_listener(dismiss_advice_str);
		
		core:add_listener(
			dismiss_advice_str,
			"ComponentLClickUp", 
			function(context) return context.string == __advisor_progress_button_name end,
			function(context) self:close_advisor() end, 
			false
		);
	else
		show_advisor_progress_button(false);
	end;
	
	if highlight then
		highlight_advisor_progress_button(true);
	else
		highlight_advisor_progress_button(false);
	end;
end;













-----------------------------------------------------------------------------
--- @section Progress on Advice Actions
-----------------------------------------------------------------------------


--- @function progress_on_advice_dismissed
--- @desc Calls a supplied callback when the advisor panel is closed for any reason.
--- @p @string name, Process name, by which this progress listener may be later cancelled if necessary.
--- @p @function callback to call, Callback to call.
--- @p [opt=0] @number delay, Delay in ms after the adisor closes before calling the callback.
--- @p [opt=false] @boolean highlight on finish, Highlight the advisor close button upon finishing the currently-playing advice. This is useful for script that knows the advisor is playing, wants to highlight the close button when it finishes and be notified of when the player closes the advisor in any case.
function battle_manager:progress_on_advice_dismissed(name, callback, delay, highlight_on_finish)
	if not is_string(name) then
		script_error("ERROR: progress_on_advice_dismissed() called but supplied process name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_function(callback) then
		script_error("ERROR: progress_on_advice_dismissed() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	if not is_number(delay) or delay < 0 then
		delay = 0;
	end;
	
	-- a test to see if the advisor is visible on-screen at this moment
	local advisor_open_test = function()
		local uic_advisor = find_uicomponent(core:get_ui_root(), "advice_interface");
		return uic_advisor and uic_advisor:Visible(true) and uic_advisor:CurrentAnimationId() == "";
	end;
	
	-- a function to set up listeners for the advisor closing
	local progress_func = function()
		local is_dismissed = false;
		local is_highlighted = false;
	
		core:add_listener(
			name,
			"AdviceDismissed",
			true,
			function()			
				is_dismissed = true;
				
				if highlight_on_finish then
					self:cancel_progress_on_advice_finished(name .. "_advice_finished");
				end;
			
				-- remove the highlight if it's applied
				if is_highlighted then
					self:modify_advice(true, false);
				end;
			
				if delay > 0 then
					self:callback(callback, delay);
				else
					callback();
				end;
			end,
			false
		);
		
		-- if the highlight_on_finish flag is set, we highlight the advisor close button when the advice audio finishes
		if highlight_on_finish then
			local highlight_dismiss_button_func = function()
				self:remove_process(name .. "_immediate_highlight");
			
				if not is_dismissed then
					is_highlighted = true;
					self:modify_advice(true, true);
				end;
			end;
			
			-- highlight dismiss button if advice is finished
			self:progress_on_advice_finished(name .. "_advice_finished", highlight_dismiss_button_func);
			
			-- listen for a message to say that we should immediately highlight (usually sent if cutscene has been skipped)
			core:add_listener(
				name .. "_immediate_highlight",
				"ScriptEventProgressOnAdviceDismissedImmediateHighlight",
				true,
				highlight_dismiss_button_func,
				false
			);
		end;
	end;
	
	-- If the advisor open test passes then we set up the progress listener, otherwise wait 0.5 seconds and try it again.
	-- If the advisor fails this test three times (i.e over the course of a second) then automatically progress
	if advisor_open_test() then
		progress_func();
	else
		self:callback(
			function()
				if advisor_open_test() then
					progress_func();
				else
					self:callback(
						function()
							if advisor_open_test() then
								progress_func();
							else
								if delay > 0 then
									self:callback(callback, delay, name);
								else
									callback();
								end;
							end;
						end,
						500,
						name
					);
				end;
			end,
			500,
			name
		);
	end;
end;


--- @function cancel_progress_on_advice_dismissed
--- @desc Cancels a running @battle_manager:progress_on_advice_dismissed process.
--- @p @string name, Process name, by which this progress listener was started.
function battle_manager:cancel_progress_on_advice_dismissed(name)
	if not is_string(name) then
		script_error("ERROR: cancel_progress_on_advice_dismissed() called but supplied process name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	core:remove_listener(name);
	self:remove_process(name);
	self:remove_process(name .. "_immediate_highlight");
	self:cancel_progress_on_advice_finished(name .. "_advice_finished");
end;


--- @function progress_on_advice_dismissed_immediate_highlight
--- @desc Causes a @battle_manager:progress_on_advice_dismissed process that is listening for the advice to finish so that it can highlight the close button (i.e. the third parameter was set to true) to cancel this listener.
function battle_manager:progress_on_advice_dismissed_immediate_highlight()
	core:trigger_event("ScriptEventProgressOnAdviceDismissedImmediateHighlight");
end;


--- @function progress_on_advice_finished
--- @desc Calls a supplied callback when the advisor has stopped playing an audible sound.
--- @p @string name, Name for this progress on advice finished process, by which it may be later cancelled if necessary.
--- @p @function callback to call, Callback to call.
--- @p [opt=0] @number delay, Delay in ms after the adisor stops before calling the callback.
--- @p [opt=5000] @number playtime, Playing time for the advice item. This sets a time after which @battle_manager:progress_on_advice_finished will begin to actively poll whether the advice is still playing, as well as listening for the finish event. This is useful as it ensure this function works even during development when the advisor sound files have not yet been recorded.
function battle_manager:progress_on_advice_finished(name, callback, delay, playtime)
	if not is_string(name) then
		script_error("ERROR: progress_on_advice_finished() called but supplied process name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if not is_function(callback) then
		script_error("ERROR: progress_on_advice_finished() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	local callback_function = function()
		self:cancel_progress_on_advice_finished(name);
		
		-- do the given callback
		if is_number(delay) and delay > 0 then
			self:callback(function() callback() end, delay, name);
		else
			callback();
		end;
	end;
	
	if common.is_advice_audio_playing() then
		-- advice is currently playing
		core:add_listener(
			name,
			"AdviceFinishedTrigger",
			true,
			function()
				callback_function();
			end,
			false
		);
	end;
	
	playtime = playtime or 5000;
	
	-- for if sound is disabled
	self:callback(function() self:progress_on_advice_finished_poll(name, callback, delay, playtime, 0) end, playtime, name);
end;


function battle_manager:progress_on_advice_finished_poll(name, callback, delay, playtime, count)
	count = count or 0;
	
	if not common.is_advice_audio_playing() then
		self:cancel_progress_on_advice_finished(name);
		
		self:out("progress_on_advice_finished is progressing as no advice sound is playing after playtime of " .. playtime + (count * self.PROGRESS_ON_ADVICE_FINISHED_REPOLL_TIME) .. "ms");
		
		-- do the given callback
		if is_number(delay) then
			self:callback(function() callback() end, delay, name);
		else
			callback();
		end;
		return;
	end;
	
	count = count + 1;
	
	-- sound is still playing, check again in a bit
	self:callback(function() self:progress_on_advice_finished_poll(name, callback, delay, playtime, count) end, self.PROGRESS_ON_ADVICE_FINISHED_REPOLL_TIME, name);
end;


--- @function cancel_progress_on_advice_finished
--- @desc Cancels a running @battle_manager:progress_on_advice_finished process.
--- @p @string name, Name of the progress on advice finished process to cancel.
function battle_manager:cancel_progress_on_advice_finished(name)
	if not is_string(name) then
		script_error("ERROR: cancel_progress_on_advice_finished() called but supplied process name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	core:remove_listener(name);
	self:remove_process(name);
end;


--- @function progress_on_sound_effect_finished
--- @desc Calls a supplied function when a supplied sound effect has finished playing. A post-completion delay and a minimum play time - useful during development when sound effects (particularly voiceover) may not yet have been recorded - may also be supplied.
--- @p @string name, Name for this progress-on-sound-effect-finished process. The process may be cancelled by the name supplied here by calling @battle_manager:cancel_progress_on_sound_effect_finished before the callback is called.
--- @p @battle_sound_effect sound effect, Sound effect to monitor.
--- @p @function callback, Callback to call.
--- @p [opt=0] @number post-finish delay, Delay in ms to wait after the sound effect has finished before calling the callback.
--- @p [opt=0] @number minimum playtime, Minimum playtime for the sound effect, in ms. If a positive number is supplied here, the process will not begin to monitor until after that period has elapsed.
function battle_manager:progress_on_sound_effect_finished(name, sound, callback, post_finish_delay, min_play_time)
	if not validate.is_string(name) or not validate.is_battlesoundeffect(sound) or not validate.is_function(callback) then
		return false;
	end;

	if post_finish_delay then
		if not validate.is_non_negative_number(post_finish_delay) then
			return false;
		end;
	else
		post_finish_delay = 0;
	end;

	if min_play_time then
		if not validate.is_non_negative_number(min_play_time) then
			return false;
		end;
	else
		min_play_time = 0;
	end;

	local process_name = "progress_on_sound_effect_finished_" .. name;

	self:callback(
		function()
			self:repeat_callback(
				function()
					if not sound:is_playing() then
						self:remove_process(process_name);
						self:callback(
							callback,
							post_finish_delay,
							process_name
						);
					end;
				end,
				100,
				process_name
			);
		end,
		min_play_time,
		process_name
	);
end;


--- @function cancel_progress_on_sound_effect_finished
--- @desc Cancels a process started by @battle_manager:progress_on_sound_effect_finished with the supplied name.
--- @p @string name
function battle_manager:cancel_progress_on_sound_effect_finished(name)
	self:remove_process("progress_on_sound_effect_finished_" .. name);
end;











----------------------------------------------------------------------------
--- @section Objectives
--- @desc Upon creation, the battle manager automatically creates an objectives manager object which it stores internally. Most of these functions provide a passthrough interface to the most commonly-used functions on the objectives manager. See the documentation on the @objectives_manager page for more details.
--- @desc Note that @battle_manager:set_locatable_objective is native to the battle manager and is not related to the objectives manager.
----------------------------------------------------------------------------


--- @function set_objective
--- @desc Sets up a scripted objective for the player, which appears in the scripted objectives panel. This objective can then be updated, removed, or marked as completed or failed by the script at a later time.
--- @desc A key to the scripted_objectives table must be supplied with set_objective, and optionally one or two numeric parameters to show some running count related to the objective. To update these parameter values later, <code>set_objective</code> may be re-called with the same objective key and updated values.
--- @desc This function passes its arguments through @objectives_manager:set_objective on the objectives manager - see the documentation on that function for more information.
--- @p @string objective key, Objective key, from the scripted_objectives table.
--- @p [opt=nil] @number param a, First numeric objective parameter. If set, the objective will be presented to the player in the form [objective text]: [param a]. Useful for showing a running count of something related to the objective.
--- @p [opt=nil] @number param b, Second numeric objective parameter. A value for the first must be set if this is used. If set, the objective will be presented to the player in the form [objective text]: [param a] / [param b]. Useful for showing a running count of something related to the objective.
function battle_manager:set_objective(...)
	return self.objectives:set_objective(...);
end;


--- @function set_objective_with_leader
--- @desc Sets up a scripted objective for the player which appears in the scripted objectives panel, with a @topic_leader. This objective can then be updated, removed, or marked as completed or failed by the script at a later time.
--- @desc A key to the scripted_objectives table must be supplied with set_objective, and optionally one or two numeric parameters to show some running count related to the objective. To update these parameter values later, <code>set_objective</code> may be re-called with the same objective key and updated values.
--- @desc This function passes its arguments through @objectives_manager:set_objective_with_leader on the objectives manager - see the documentation on that function for more information.
--- @p @string objective key, Objective key, from the scripted_objectives table.
--- @p [opt=nil] @number param a, First numeric objective parameter. If set, the objective will be presented to the player in the form [objective text]: [param a]. Useful for showing a running count of something related to the objective.
--- @p [opt=nil] @number param b, Second numeric objective parameter. A value for the first must be set if this is used. If set, the objective will be presented to the player in the form [objective text]: [param a] / [param b]. Useful for showing a running count of something related to the objective.
--- @p [opt=nil] @function callback, Optional callback to call when the objective is shown.
function battle_manager:set_objective_with_leader(...)
	return self.objectives:set_objective_with_leader(...);
end;


--- @function complete_objective
--- @desc Marks a scripted objective as completed for the player to see. Note that it will remain on the scripted objectives panel until removed with @battle_manager:remove_objective. This function passes its arguments through @objectives_manager:complete_objective on the objectives manager - see the documentation on that function for more information.
--- @desc Note also that is possible to mark an objective as complete before it has been registered with @battle_manager:set_objective - in this case, it is marked as complete as soon as @battle_manager:set_objective is called.
--- @p @string objective key, Objective key, from the scripted_objectives table.
function battle_manager:complete_objective(...)
	return self.objectives:complete_objective(...);
end;


--- @function fail_objective
--- @desc Marks a scripted objective as failed for the player to see. Note that it will remain on the scripted objectives panel until removed with @battle_manager:remove_objective. This function passes its arguments through @objectives_manager:fail_objective on the objectives manager - see the documentation on that function for more information.
--- @p @string objective key, Objective key, from the scripted_objectives table.
function battle_manager:fail_objective(...)
	return self.objectives:fail_objective(...);
end;


--- @function remove_objective
--- @desc Removes a scripted objective from the scripted objectives panel. This function passes its arguments through @objectives_manager:remove_objective on the objectives manager - see the documentation on that function for more information.
--- @p @string objective key, Objective key, from the scripted_objectives table.
function battle_manager:remove_objective(...)
	return self.objectives:remove_objective(...);
end;


--- @function activate_objective_chain
--- @desc Starts a new objective chain. This function passes its arguments through @objectives_manager:activate_objective_chain on the objectives manager - see the documentation on that function for more information.
--- @p @string chain name, Objective chain name.
--- @p @string objective key, Key of initial objective, from the scripted_objectives table.
--- @p [opt=nil] @number number param a, First numeric parameter - see the documentation for @battle_manager:set_objective for more details.
--- @p [opt=nil] @number number param b, Second numeric parameter - see the documentation for @battle_manager:set_objective for more details.
function battle_manager:activate_objective_chain(...)
	return self.objectives:activate_objective_chain(...);
end;


--- @function activate_objective_chain_with_leader
--- @desc Starts a new objective chain, with a @topic_leader. This function passes its arguments through @objectives_manager:activate_objective_chain_with_leader on the objectives manager - see the documentation on that function for more information.
--- @p @string chain name, Objective chain name.
--- @p @string objective key, Key of initial objective, from the scripted_objectives table.
--- @p [opt=nil] @number number param a, First numeric parameter - see the documentation for @battle_manager:set_objective for more details.
--- @p [opt=nil] @number number param b, Second numeric parameter - see the documentation for @battle_manager:set_objective for more details.
function battle_manager:activate_objective_chain_with_leader(...)
	return self.objectives:activate_objective_chain_with_leader(...);
end;


--- @function update_objective_chain
--- @desc Updates an existing objective chain. This function passes its arguments through @objectives_manager:update_objective_chain on the objectives manager - see the documentation on that function for more information.
--- @p @string chain name, Objective chain name.
--- @p @string objective key, Key of initial objective, from the scripted_objectives table.
--- @p [opt=nil] @number number param a, First numeric parameter - see the documentation for @battle_manager:set_objective for more details
--- @p [opt=nil] @number number param b, Second numeric parameter - see the documentation for @battle_manager:set_objective for more details
function battle_manager:update_objective_chain(...)
	return self.objectives:update_objective_chain(...);
end;


--- @function end_objective_chain
--- @desc Ends an existing objective chain. This function passes its arguments through @objectives_manager:end_objective_chain on the objectives manager - see the documentation on that function for more information.
--- @p @string chain name, Objective chain name.
function battle_manager:end_objective_chain(...)
	return self.objectives:end_objective_chain(...);
end;


--- @function reset_objective_chain
--- @desc Resets an objective chain so that it may be called again. This function passes its arguments through @objectives_manager:reset_objective_chain on the objectives manager - see the documentation on that function for more information.
--- @p @string chain name, Objective chain name.
function battle_manager:reset_objective_chain(...)
	return self.objectives:reset_objective_chain(...);
end;


function battle_manager:set_locatable_objective_action(obj_key, cam_pos_generator, duration)
	-- find and show the zoom button
	local uic_panel = self.objectives:get_uicomponent();
	if not uic_panel then
		script_error("ERROR: set_locatable_objective() called but couldn't find uic_panel");
		return false;
	end;

	local uic_button_zoom = find_uicomponent(uic_panel, obj_key, "button_zoom");
	if not uic_button_zoom then
		script_error("ERROR: set_locatable_objective() called but couldn't find uic_button_zoom");
		return false;
	end;

	uic_button_zoom:SetVisible(true);

	core:add_listener(
		obj_key,
		"ComponentLClickUp",
		function(context)
			return UIComponent(context.component) == uic_button_zoom;
		end,
		function()
			local cam_pos, cam_targ = cam_pos_generator();

			if not is_vector(cam_pos) or not is_vector(cam_targ) then
				script_error("WARNING: set_locatable_objective_action() for objective " .. tostring(obj_key) .. " called the camera generator function but it did not return two valid vectors - the camera will not move");
				return false;
			end;

			self:out("* set_locatable_objective() is scrolling the camera to pos: " .. v_to_s(cam_pos) .. ", targ: " .. v_to_s(cam_targ) .. " over duration " .. duration .. " seconds as zoom button has been clicked");
			self.battle:camera():move_to(cam_pos, cam_targ, duration, false, 0, false);
			bm:enable_camera_movement(false);

			core:get_tm():real_callback(
				function()
					bm:enable_camera_movement(true);
				end,
				duration * 1000
			);
		end,
		true
	);
end;


--- @function set_locatable_objective
--- @desc Sets up a locatable objective in battle. This will appear in the scripted objectives list alongside a zoom-to button which, when clicked, will zoom the camera to a location on the battlefield. The key of the objective text, as well as the camera position/target and zoom duration must all be supplied.
--- @p @string objective key, Objective key, from the scripted_objectives table.
--- @p @battle_vector camera position, Final camera position.
--- @p @battle_vector camera target, Final camera target.
--- @p @number zoom duration, Duration of camera movement in seconds.
--- @p [opt=false] @boolean show topic leader, Shows a @topic_leader before displaying the objective.
function battle_manager:set_locatable_objective(obj_key, cam_pos, cam_targ, duration, show_topic_leader)
	if not is_string(obj_key) then
		script_error("ERROR: set_locatable_objective() called but supplied objective key [" .. tostring(obj_key) .. "] is not a string");
		return false;
	end;
	
	if not is_vector(cam_pos) then
		script_error("ERROR: set_locatable_objective() called but supplied camera position [" .. tostring(cam_pos) .. "] is not a vector");
		return false;
	end;
	
	if not is_vector(cam_targ) then
		script_error("ERROR: set_locatable_objective() called but supplied camera position [" .. tostring(cam_targ) .. "] is not a vector");
		return false;
	end;
	
	if not is_number(duration) or duration <= 0 then
		script_error("ERROR: set_locatable_objective() called but supplied zoom duration [" .. tostring(duration) .. "] is not a number > 0");
		return false;
	end;
	
	-- show objective
	if show_topic_leader then
		self.objectives:set_objective_with_leader(
			obj_key,
			nil,
			nil,
			function()
				self:set_locatable_objective_action(
					obj_key,
					function()
						return cam_pos, cam_targ;
					end, 
					duration
				);
			end
		);
	else
		self.objectives:set_objective(obj_key);
		self:set_locatable_objective_action(
			obj_key,
			function()
				return cam_pos, cam_targ;
			end, 
			duration
		);
	end;
end;


--- @function set_locatable_objective_callback
--- @desc Sets up a locatable objective in battle. This will appear in the scripted objectives list alongside a zoom-to button which, when clicked, will zoom the camera to a location on the battlefield. Whereas @battle_manager:set_locatable_objective requires static camera position/targets to be supplied, this function takes a function argument which, when called, should return a @battle_vector camera position and a @battle_vector camera target. This allows the camera position to be generated at runtime, to follow a unit for example.
--- @p @string objective key, Objective key, from the scripted_objectives table.
--- @p @function camera position generator, Camera position generator function. When called, this should return two @battle_vector values that specify the camera position and target to move to.
--- @p @number zoom duration, Duration of camera movement in seconds.
--- @p [opt=false] @boolean show topic leader, Shows a @topic_leader before displaying the objective.
function battle_manager:set_locatable_objective_callback(obj_key, cam_pos_generator, duration, show_topic_leader)
	if not is_string(obj_key) then
		script_error("ERROR: set_locatable_objective_callback() called but supplied objective key [" .. tostring(obj_key) .. "] is not a string");
		return false;
	end;
	
	if not is_function(cam_pos_generator) then
		script_error("ERROR: set_locatable_objective_callback() called but supplied camera position generator callback [" .. tostring(cam_pos_generator) .. "] is not a function");
		return false;
	end;
	
	if not is_number(duration) or duration <= 0 then
		script_error("ERROR: set_locatable_objective_callback() called but supplied zoom duration [" .. tostring(duration) .. "] is not a number > 0");
		return false;
	end;
	
	-- show objective
	if show_topic_leader then
		self.objectives:set_objective_with_leader(
			obj_key,
			nil,
			nil,
			function()
				self:set_locatable_objective_action(obj_key, cam_pos_generator, duration);
			end
		);
	else
		self.objectives:set_objective(obj_key);
		self:set_locatable_objective_action(obj_key, cam_pos_generator, duration);
	end;
end;







----------------------------------------------------------------------------
--- @section Infotext
--- @desc These functions provide a passthrough interface to the most commonly-used functions on the infotext manager, which the battle manager creates automatically.
----------------------------------------------------------------------------


--- @function add_infotext
--- @desc Adds one or more lines of infotext to the infotext panel. This function passes through to @infotext_manager:add_infotext - see the documentation on the @infotext_manager page for more details.
--- @p object first param, Can be a string key from the advice_info_texts table, or a number specifying an initial delay in ms after the panel animates onscreen and the first infotext item is shown.
--- @p ... additional infotext strings, Additional infotext strings to be shown. <code>add_infotext</code> fades each of them on to the infotext panel in a visually-pleasing sequence.
function battle_manager:add_infotext(...)
	return self.infotext:add_infotext(...);
end;


--- @function add_infotext_with_leader
--- @desc Adds one or more lines of infotext to the infotext panel, with a @topic_leader. This function passes through to @infotext_manager:add_infotext_with_leader - see the documentation on the @infotext_manager page for more details.
--- @p object first param, Can be a string key from the advice_info_texts table, or a number specifying an initial delay in ms after the panel animates onscreen and the first infotext item is shown.
--- @p ... additional infotext strings, Additional infotext strings to be shown. <code>add_infotext</code> fades each of them on to the infotext panel in a visually-pleasing sequence.
function battle_manager:add_infotext_with_leader(...)
	return self.infotext:add_infotext_with_leader(...);
end;


--- @function add_infotext_simultaneously
--- @desc Adds one or more lines of infotext simultaneously to the infotext panel. This function passes through to @infotext_manager:add_infotext_simultaneously - see the documentation on the @infotext_manager page for more details.
--- @p object first param, Can be a string key from the advice_info_texts table, or a number specifying an initial delay in ms after the panel animates onscreen and the first infotext item is shown.
--- @p ... additional infotext strings, Additional infotext strings to be shown. <code>add_infotext_simultaneously</code> fades each of them on to the infotext panel in a visually-pleasing sequence.
function battle_manager:add_infotext_simultaneously(...)
	return self.infotext:add_infotext_simultaneously(...);
end;


--- @function add_infotext_simultaneously_with_leader
--- @desc Adds one or more lines of infotext simultaneously to the infotext panel, with a @topic_leader. This function passes through to @infotext_manager:add_infotext_simultaneously_with_leader - see the documentation on the @infotext_manager page for more details.
--- @p object first param, Can be a string key from the advice_info_texts table, or a number specifying an initial delay in ms after the panel animates onscreen and the first infotext item is shown.
--- @p ... additional infotext strings, Additional infotext strings to be shown. <code>add_infotext_simultaneously</code> fades each of them on to the infotext panel in a visually-pleasing sequence.
function battle_manager:add_infotext_simultaneously_with_leader(...)
	return self.infotext:add_infotext_simultaneously_with_leader(...);
end;


--- @function remove_infotext
--- @desc Pass-through function for @infotext_manager:remove_infotext. Removes a line of infotext from the infotext panel.
--- @p string infotext key
function battle_manager:remove_infotext(...)
	return self.infotext:remove_infotext(...);
end;


--- @function clear_infotext
--- @desc Pass-through function for @infotext_manager:clear_infotext. Clears the infotext panel.
function battle_manager:clear_infotext(...)
	return self.infotext:clear_infotext(...);
end;


--- @function hide_infotext
--- @desc Pass-through function for @infotext_manager:hide_infotext. Hides and clears the infotext panel with an animation.
function battle_manager:hide_infotext(...)
	return self.infotext:hide_infotext(...);
end;


--- @function attach_to_advisor
--- @desc Pass-through function for @infotext_manager:attach_to_advisor. This attaches or detaches the infotext panel from the advisor. By default they are attached, but by detaching them infotext may be triggered independently of advice.
--- @p [opt=true] @boolean should attach
function battle_manager:attach_to_advisor(...)
	return self.infotext:attach_to_advisor(...);
end;





-----------------------------------------------------------------------------
--- @section Subtitles
-----------------------------------------------------------------------------

--- @function show_subtitle
--- @desc Shows a cutscene subtitle on-screen.
--- @p string subtitle key
--- @p [opt=false] boolean full key supplied, Full localised key supplied. If false, or if no value supplied, the script assumes that the key is from the scripted_subtitles table and pads the supplied key out accordingly.
--- @p_long_desc If the key has been supplied in the full localisation format (i.e. <code>[table]_[field_of_text]_[key_from_table]</code>), set this to true.
--- @p [opt=false] boolean force subtitle on, Forces the subtitle to display, overriding the user's preferences.
function battle_manager:show_subtitle(key, full_key_supplied, should_force)
	
	if not is_string(key) then
		script_error("ERROR: show_subtitle() called but supplied key [" .. tostring(key) .. "] is not a string");
		return false;
	end;

	-- only proceed if we're forcing the subtitle to play, or if the subtitle preferences setting is on
	if not should_force and not common.subtitles_enabled() then
		self:out("show_subtitle() called with supplied key is [" .. key .. "] but subtitles are disabled");
		return;
	end;

	local full_key = key;
	
	if not full_key_supplied then
		full_key = "scripted_subtitles_localised_text_" .. key;
	end;

	local localised_text = common.get_localised_string(full_key);
	
	if not is_string(localised_text) then
		script_error("ERROR: show_subtitle() called but could not find any localised text corresponding with supplied key [" .. tostring(key) .. "] in scripted_subtitles table");
		return false;
	end;

	self:out("show_subtitle() called, supplied key is [" .. full_key .. "] and localised text is [" .. localised_text .. "]");
	
	local ui_root = core:get_ui_root();

	-- create the subtitles component if it doesn't already exist
	if not self.subtitles_component_created then
		ui_root:CreateComponent("scripted_subtitles", "UI/Common UI/scripted_subtitles.twui.xml");
		self.subtitles_component_created = true;
	end;
	
	-- find the subtitles component
	local uic_subtitles = find_uicomponent(ui_root, "scripted_subtitles", "text_child");
	
	if not uic_subtitles then
		script_error("ERROR: show_subtitles() could not find the scripted_subtitles uicomponent");
		return false;
	end;
	
	-- set the text on it
	uic_subtitles:SetStateText(localised_text, full_key);
	
	-- make the subtitles component visible if it's not already
	if not self.subtitles_visible then
		uic_subtitles:SetVisible(true);
		uic_subtitles:RegisterTopMost();
		self.subtitles_visible = true;
	end;
end;


--- @function hide_subtitles
--- @desc Hides any currently-shown subtitle.
function battle_manager:hide_subtitles()

	self:out("hide_subtitles() called");

	if self.subtitles_visible then
		-- find the subtitles component
		local uic_subtitles = find_uicomponent(core:get_ui_root(), "scripted_subtitles", "text_child");
	
		uic_subtitles:RemoveTopMost();
		uic_subtitles:SetVisible(false);
		self.subtitles_visible = false;
	end;
end;










-----------------------------------------------------------------------------
--- @section Help Message Queue
--- @desc Help messages are used primarily in quest battles. They are text messages faded onto the HUD above the army panel, that persist for a time and then fade off. The battle manager queues them so they don't overwrite one another.
-----------------------------------------------------------------------------


--- @function queue_help_message
--- @desc Enqueues a help message for showing on-screen.
--- @p string key, Help message key, from the scripted_objectives table.
--- @p [opt=5000] number duration, Duration that the message will persist on-screen for in ms. If this is specified then a fade time must also be set.
--- @p [opt=2000] number fade time, Time that the message will take to fade on/fade off in ms. If this is specified then a duration must also be set.
--- @p [opt=false] boolean high priority, Set this to true to set this message to high priority. High priority messages are bumped to the top of the queue.
--- @p [opt=false] boolean play after battle victory, By default, help messages won't play after the battle has been won. Set this to true to allow this message to play after this point.
--- @p [opt=nil] function callback, Callback to call when the message actually starts to show on-screen.
function battle_manager:queue_help_message(key, duration, fade_time, high_priority, play_after_battle_victory, callback)

	if not is_string(key) then
		script_error("ERROR: queue_help_message() called but supplied message key [" .. tostring(key) .. "] is not a string");
		return false;
	end;
	
	if duration then
		if not is_number(duration) or duration <= 0 then
			script_error("ERROR: queue_help_message() called but supplied duration [" .. tostring(duration) .. "] is not a number greater than zero");
			return false;
		end;
	else
		duration = 5000;
	end;
	
	if fade_time then
		if not is_number(fade_time) or fade_time <= 0 then
			script_error("ERROR: queue_help_message() called but supplied fade time [" .. tostring(fade_time) .. "] is not a number greater than zero");
			return false;
		end;
	else
		fade_time = 2000;
	end;
	
	if duration and not fade_time then
		script_error("WARNING: queue_help_message() called and duration has been specified but no fade time was also supplied - both must be supplied, or neither. Discarding them.");
		return false;
	end;

	-- if the battle is won then don't bother showing any more messages (unless we are told to)
	if self.battle_is_won and not play_after_battle_victory then
		return;
	end;
	
	local help_message_record = {};
	help_message_record.key = key;
	help_message_record.duration = duration;
	help_message_record.fade_time = fade_time;
	help_message_record.high_priority = high_priority;
	help_message_record.play_after_battle_victory = play_after_battle_victory;
	help_message_record.callback = callback;
	
	if high_priority then
		table.insert(self.help_messages, 1, help_message_record);
	else
		table.insert(self.help_messages, help_message_record);
	end;
	
	-- if no help messages are playing then try and play one
	if not self.help_messages_showing then
		self:show_next_help_message();
	end;
end;


function battle_manager:show_next_help_message()
	
	local help_messages = self.help_messages;

	-- if we have no more help messages then exit
	if #help_messages == 0 then
		self.help_messages_showing = false;
		return;
	end;
	
	-- get the first help message
	local help_message_record = help_messages[1];
	
	-- if the battle is won then don't bother showing any more messages (unless we are told to)
	if self.battle_is_won and not help_message_record.play_after_battle_victory then
		self.help_messages_showing = false;
		return;
	end;
	
	-- remove the message from our table
	table.remove(help_messages, 1);
	
	-- show the message
	bm:show_objective(help_message_record.key, help_message_record.duration, help_message_record.fade_time);
	self.help_messages_showing = true;
	
	-- find the message panel and reposition it so that it appears above the army panel (its default position is to work with the black cinematic borders)	
	local uic_help_panel = find_uicomponent(core:get_ui_root(), "objective_panel");
	
	if not uic_help_panel then
		script_error("ERROR: show_help_msg() couldn't find objective_panel");
		return false;
	end;
	
	local screen_x, screen_y = core:get_screen_resolution();
	local component_x, component_y = uic_help_panel:Position();

	if uic_help_panel:DockingPoint() == 0 then
		uic_help_panel:MoveTo(component_x, screen_y - 410);
	end;
	
	-- if we have a callback, call it
	if help_message_record.callback then
		help_message_record.callback();
	end;
	
	-- we calculate the time at which this message will have expired based on the game running time, as the message runs by this rather than model time
	local help_message_expiry_time = os.clock() + (help_message_record.duration + help_message_record.fade_time * 2) / 1000;
	
	-- watch the time and show the next help message when this one has expired
	bm:watch(
		function() return os.clock() >= help_message_expiry_time end,
		0,
		function()
			self:show_next_help_message();
		end,
		"battle_manager_help_message_queue"
	);
end;


--- @function hide_help_message
--- @desc Hides any help message currently being shown. The help message queue may optionally also be cleared.
--- @p [opt=false] @boolean clear help message queue
function battle_manager:hide_help_message(clear_queue)
	local uic_help_message = find_uicomponent(core:get_ui_root(), "objective_panel");
	if uic_help_message then
		uic_help_message:Destroy();
		bm:remove_process("battle_manager_help_message_queue");
		
		if clear_queue then
			self.help_messages = {};
		else
			self:show_next_help_message();
		end;
	end;
end;









-----------------------------------------------------------------------------
--- @section Showing/Hiding UI
--- @desc Functions in this section may be used to show/hide elements on the battle ui. In some cases, the hidden elements will be restored if the cinematic ui is disabled/re-enabled, such as going into and then coming out of a cutscene. To circumvent this problem @cutscene objects will call @battle_manager:restore_ui_hiding to re-establish all hiding behaviour that would otherwise be reset, unless told not to with @cutscene:set_should_restore_ui_hiding_on_end.
-----------------------------------------------------------------------------


--- @function is_cinematic_ui_enabled
--- @desc Returns whether the cinematic UI is currently enabled. The cinematic UI is enabled from script with @battle:enable_cinematic_ui, and is commonly activated/deactivated by cutscenes.
--- @r @boolean is cinematic ui enabled
function battle_manager:is_cinematic_ui_enabled()
	return common.get_context_value("CcoBattleRoot", "", "IsCinematicModeEnabled()");
end;


--- @function clear_selection
--- @desc Deselects any currently-selected units.
function battle_manager:clear_selection()
	common.call_context_command("CcoBattleRoot", "", "SelectionContext.DeselectAll()");
end;


--- @function restore_ui_hiding
--- @desc Restores certain ui hiding behaviours established by calls to ui-hiding functions in this section, where those ui-hiding behaviours would be reset by disabling/re-enabling the cinematic ui. This is called by @cutscene objects.
function battle_manager:restore_ui_hiding()
	out("restoring ui hiding:");
	out.inc_tab();
	for key, action in pairs(self.restore_ui_hiding_action_list) do
		if action then
			action();
		end;
	end;
	out.dec_tab();
	out("end of ui hiding restoration");
end;


--- @function steal_input_focus
--- @desc Steals or releases all input from the UI, disabling or re-enabing user input in the game. This calls/overrides the @battle functions @battle:steal_input_focus and @battle:release_input_focus. The state set with this function will be re-established when @battle_manager:restore_ui_hiding is called.
--- @p @boolean steal focus, Steal focus. Set to <code>false</code> to release focus.
--- @p @boolean dont restore, Don't add this action to the list of actions to restore if @battle_manager:restore_ui_hiding is called.
function battle_manager:steal_input_focus(value, suppress_restore)
	if value == false then
		if suppress_restore then
			out("@steal_input_focus() is releasing input focus (not adding to restore list)");
		else
			out("@steal_input_focus() is releasing input focus");
			self.restore_ui_hiding_action_list["steal_input_focus"] = nil;
		end;
		self.input_focus_is_stolen = false;
		self.battle:release_input_focus();
	else
		if suppress_restore then
			out("@steal_input_focus() is stealing input focus (not adding to restore list)");
		else
			out("@steal_input_focus() is stealing input focus");
			self.restore_ui_hiding_action_list["steal_input_focus"] = function()
				self:steal_input_focus(value);
			end;
		end;
		self.input_focus_is_stolen = true;
		self.battle:steal_input_focus();
	end;
end;


--- @function is_input_focus_stolen
--- @desc Returns whether input focus has currently been stolen by @battle_manager:steal_input_focus.
--- @r @boolean input focus is stolen
function battle_manager:is_input_focus_stolen()
	return self.input_focus_is_stolen;
end;


--- @function enable_ui_hiding
--- @desc Enables/disables UI hiding. With UI hiding disabled the player will not be able to hide the UI by pressing K or alt-K. This function does not prevent the script from being able to hide or show the UI.
--- @desc Any state set by a call to this function is restored if @battle_manager:restore_ui_hiding is called.
--- @p [opt=true] @boolean should enable
function battle_manager:enable_ui_hiding(value)
	if value ~= false then
		out("@enable_ui_hiding() is preventing ui hiding");
		value = true;
		self.restore_ui_hiding_action_list["enable_ui_hiding"] = false;
	else
		out("@enable_ui_hiding() is allowing ui hiding");
		self.restore_ui_hiding_action_list["enable_ui_hiding"] = function()
			self:enable_ui_hiding(value);
		end;
	end;

	self.ui_hiding_enabled = value;

	self.battle:disable_shortcut("toggle_ui", not value);
	self.battle:disable_shortcut("toggle_ui_with_borders", not value);
end;


--- @function enable_paused_panel
--- @desc Disables or re-enables the display of the paused panel. With the paused panel disabled the game may still be paused, but the panel will not show.
--- @p [opt=true] @boolean should enable
function battle_manager:enable_paused_panel(value)
	local uic_pause_panel = find_uicomponent(core:get_ui_root(), "paused_panel");

	if not uic_pause_panel then
		script_error("WARNING: enable_paused_panel() called but pause panel could not be found - how can this be?");
		return false;
	end;

	if value == false then
		uic_pause_panel:SetState("hidden");
	else
		uic_pause_panel:SetState("visible");
	end;
end;


--- @function is_ui_hiding_enabled
--- @desc Returns false if UI hiding has been disabled with @battle_manager:enable_ui_hiding, otherwise true.
--- @r @boolean is ui hiding enabled.
function battle_manager:is_ui_hiding_enabled()
	return self.ui_hiding_enabled;
end;


--- @function show_start_battle_button
--- @desc Shows/hides the start battle button. Any state set by a call to this function is restored if @battle_manager:restore_ui_hiding is called.
--- @p [opt=true] @boolean should show, Should show.
--- @p [opt=false] @boolean is multiplayer, Set this to true if this is a multiplayer battle.
function battle_manager:show_start_battle_button(value, is_multiplayer)
	if value ~= false then
		out("@show_start_battle_button() is showing start battle button");
		value = true;
	else
		out("@show_start_battle_button() is hiding start battle button");
	end;

	if bm:get_battle_ui_manager():is_panel_open("esc_menu") then
		-- Remove listener so only one can be active.
		core:remove_listener("PanelClosedBattleShowStartBattle")

		core:add_listener(
			"PanelClosedBattleShowStartBattle",
			"PanelClosedBattle",
			function(context) return context.string == "esc_menu" end,
			function()
				bm:callback(function() bm:show_start_battle_button(value, is_multiplayer) end, 100)
			end,
			false
		)
	else
		local uic_finish_deployment = bm:ui_component("finish_deployment");
		
		if uic_finish_deployment then
			uic_finish_deployment:SetVisible(value);
			
			if is_multiplayer then
				local uic_mp = find_uicomponent(uic_finish_deployment, "deployment_end_mp");
				if uic_mp then
					uic_mp:SetVisible(value);
				end;
			else
				local uic_sp = find_uicomponent(uic_finish_deployment, "deployment_end_sp");
				if uic_sp then
					uic_sp:SetVisible(value);
				end;
			end;
		end;
	end

	if value then
		self.restore_ui_hiding_action_list["show_start_battle_button"] = nil;
	else
		self.restore_ui_hiding_action_list["show_start_battle_button"] = function()
			self:show_start_battle_button(value, is_multiplayer);
		end;
	end;
end;


--- @function show_ui
--- @desc Shows/hides the army panel, winds of magic panel, portrait panel, top bar, radar frame and army abilities from script.
--- @p [opt=true] @boolean should show
function battle_manager:show_ui(value)

	if value == nil then
		value = true;
	else
		value = not not value;
	end;

	self:show_army_panel(value);
	self:show_winds_of_magic_panel(value);
	self:show_portrait_panel(value);
	self:show_top_bar(value);
	self:show_radar_frame(value);
	self:show_army_abilities(value);
end;


--- @function show_army_panel
--- @desc Shows/hides the army panel.
--- @p [opt=true] @boolean should show, Should show.
--- @p [opt=false] @boolean immediate, Hide immediately. If the first parameter is false and this is true, the panel will not animate offscreen but will instead immediately disappear.
function battle_manager:show_army_panel(value, immediate)
	local uic = bm:ui_component("battle_orders");
	
	if not uic then
		script_error("ERROR: show_army_panel() called but could not find uicomponent");
		return false;
	end;
	
	if value == false then
		if immediate then
			uic:SetVisible(false);
		end;

		if self.active_ui_overrides["army_panel"] then
			out("@show_army_panel() was instructed to hide army panel but it's already hidden");
		else
			out("@show_army_panel() is hiding army panel");
			self.active_ui_overrides["army_panel"] = true;
			uic:TriggerAnimation("tut_hide");
		end;
	else
		uic:SetVisible(true);
		if self.active_ui_overrides["army_panel"] then
			out("@show_army_panel() is showing army panel");
			self.active_ui_overrides["army_panel"] = false;
			uic:TriggerAnimation("tut_show");
		else
			out("@show_army_panel() was instructed to show army panel but it's not hidden");
		end;
	end;
end;


--- @function show_winds_of_magic_panel
--- @desc Shows/hides the winds of magic panel.
--- @p [opt=true] @boolean should show, Should show.
--- @p [opt=false] @boolean immediate, Hide immediately. If the first parameter is false and this is true, the panel will not animate offscreen but will instead immediately disappear.
function battle_manager:show_winds_of_magic_panel(value, immediate)
	local uic = bm:ui_component("winds_of_magic");
	
	if not uic then
		script_error("ERROR: show_winds_of_magic_panel() called but could not find uicomponent");
		return false;
	end;
	
	if value == false then
		if self.active_ui_overrides["winds_of_magic_panel"] then
			out("@show_winds_of_magic_panel() was instructed to hide winds of magic panel but it's already hidden");
		else
			self.active_ui_overrides["winds_of_magic_panel"] = true;
			if immediate then
				out("@show_winds_of_magic_panel() is hiding winds of magic panel immediately");
				uic:SetVisible(false);
			else
				out("@show_winds_of_magic_panel() is hiding winds of magic panel");
			end;
			uic:TriggerAnimation("tut_hide");
		end;
	else
		if self.active_ui_overrides["winds_of_magic_panel"] then
			out("@show_winds_of_magic_panel() is showing winds of magic panel");
			self.active_ui_overrides["winds_of_magic_panel"] = false;
			uic:SetVisible(true);
			uic:TriggerAnimation("tut_show");
		else
			out("@show_winds_of_magic_panel() was instructed to show winds of magic panel but it's not hidden");
		end;
	end;
end;


--- @function show_portrait_panel
--- @desc Shows/hides the unit portrait panel.
--- @p [opt=true] @boolean should show, Should show.
--- @p [opt=false] @boolean immediate, Hide immediately. If the first parameter is false and this is true, the panel will not animate offscreen but will instead immediately disappear.
function battle_manager:show_portrait_panel(value, immediate)
	local uic = find_uicomponent(core:get_ui_root(), "hud_battle", "porthole_parent");
	
	if not uic then
		script_error("ERROR: show_portrait_panel() called but could not find uicomponent");
		return false;
	end;
	
	if value == false then
		if self.active_ui_overrides["portrait_panel"] then
			out("@show_portrait_panel() was instructed to hide portrait panel but it's already hidden");
		else
			self.active_ui_overrides["portrait_panel"] = true;
			if immediate then
				out("@show_portrait_panel() is hiding portrait panel immediately");
				uic:SetVisible(false);
			else
				out("@show_portrait_panel() is hiding portrait panel");
			end;
			uic:TriggerAnimation("tut_hide");
		end;
	else
		if self.active_ui_overrides["portrait_panel"] then
			out("@show_portrait_panel() is showing portrait panel");
			self.active_ui_overrides["portrait_panel"] = false;
			uic:SetVisible(true);
			uic:TriggerAnimation("tut_show");
		else
			out("@show_portrait_panel() was instructed to show portrait panel but it's not hidden");
		end;
	end;
end;


--- @function show_top_bar
--- @desc Shows/hides the top bar on the battle interface.
--- @p [opt=true] @boolean should show, Should show.
--- @p [opt=false] @boolean immediate, Hide immediately. If the first parameter is false and this is true, the panel will not animate offscreen but will instead immediately disappear.
function battle_manager:show_top_bar(value, immediate)
	local uic = bm:ui_component("BOP_frame");
	
	if not uic then
		script_error("ERROR: show_top_bar() called but could not find uicomponent");
		return false;
	end;
	
	if value == false then
		if self.active_ui_overrides["top_bar"] then
			out("@show_top_bar() was instructed to hide top bar but it's already hidden");
		else
			self.active_ui_overrides["top_bar"] = true;
			if immediate then
				out("@show_top_bar() is hiding top bar immediately");
				uic:SetVisible(false);
			else
				out("@show_top_bar() is hiding top bar");
			end;
			uic:TriggerAnimation("tut_hide");
		end;
	else
		if self.active_ui_overrides["top_bar"] then
			out("@show_top_bar() is showing top bar");
			self.active_ui_overrides["top_bar"] = false;
			uic:SetVisible(true);
			uic:TriggerAnimation("tut_show");
		else
			out("@show_top_bar() was instructed to show top bar but it's not hidden");
		end;
	end;
end;


--- @function show_radar_frame
--- @desc Shows/hides the radar.
--- @p [opt=true] @boolean should show, Should show.
--- @p [opt=false] @boolean immediate, Hide immediately. If the first parameter is false and this is true, the panel will not animate offscreen but will instead immediately disappear.
function battle_manager:show_radar_frame(value, immediate)
	local uic = bm:ui_component("radar_holder");

	if not uic then
		script_error("ERROR: show_radar_frame() called but could not find uicomponent");
		return false;
	end;
	
	if value == false then
		if self.active_ui_overrides["radar_frame"] then
			out("@show_radar_frame() was instructed to hide radar frame but it's already hidden");
		else
			self.active_ui_overrides["radar_frame"] = true;
			if immediate then
				out("@show_radar_frame() is hiding radar frame immediately");
				uic:SetVisible(false);
			else
				out("@show_radar_frame() is hiding radar frame");
			end;
			uic:TriggerAnimation("tut_hide");
		end;
	else
		if self.active_ui_overrides["radar_frame"] then
			out("@show_radar_frame() is showing radar frame");
			self.active_ui_overrides["radar_frame"] = false;
			uic:SetVisible(true);
			uic:TriggerAnimation("tut_show");
		else
			out("@show_radar_frame() was instructed to show radar frame but it's not hidden");
		end;
	end;
end;


--- @function show_army_abilities
--- @desc Shows/hides any army abilities on the right-side of the screen.
--- @p [opt=true] @boolean should show, Should show.
--- @p [opt=false] @boolean immediate, Hide immediately. If the first parameter is false and this is true, the panel will not animate offscreen but will instead immediately disappear.
function battle_manager:show_army_abilities(value, immediate)
	local uic = bm:ui_component("army_ability_parent");

	if not uic then
		script_error("ERROR: show_army_abilities() called but could not find uicomponent");
		return false;
	end;
	
	if value == false then
		if self.active_ui_overrides["army_abilities"] then
			out("@show_army_abilities() was instructed to hide army abilities but they're already hidden");
		else
			self.active_ui_overrides["army_abilities"] = true;
			if immediate then
				out("@show_army_abilities() is hiding army abilities immediately");
				uic:SetVisible(false);
			else
				out("@show_army_abilities() is hiding army abilities");
			end;
			uic:TriggerAnimation("tut_hide");
		end;
	else
		if self.active_ui_overrides["army_abilities"] then
			out("@show_army_abilities() is showing army abilities");
			self.active_ui_overrides["army_abilities"] = false;
			uic:SetVisible(true);
			uic:TriggerAnimation("tut_show");
		else
			out("@show_army_abilities() was instructed to show army abilities but it's not hidden");
		end;
	end;		
end;


--- @function show_spell_browser_button
--- @desc Shows/hides the spell browser.
--- @p [opt=true] @boolean should show, Should show.
-- This is just used for the prologue, so I haven't hooked it up to show_ui().
function battle_manager:show_spell_browser_button(value)
	local uic = bm:ui_component("button_spell_browser");
	
	if not uic then
		script_error("ERROR: show_spell_browser_button called but could not find uicomponent");
		return false;
	end;
	
	if value == false then
		if self.active_ui_overrides["button_spell_browser"] then
			out("@show_spell_browser_button() was instructed to hide spell browser but it's already hidden");
		else
			self.active_ui_overrides["button_spell_browser"] = true;
			uic:SetVisible(false);
		end;
	else
		if self.active_ui_overrides["button_spell_browser"] then
			out("@show_spell_browser_button() is showing spell browser");
			self.active_ui_overrides["button_spell_browser"] = false;
			uic:SetVisible(true);
		else
			out("@show_spell_browser_button() was instructed to show spell browser but it's not hidden");
		end;
	end;
end;

--- @function show_ui_options_panel
--- @desc Shows/hides the ui options rollout panel.
--- @p [opt=true] @boolean should show
function battle_manager:show_ui_options_panel(value)
	local uic_spacebar_options = bm:ui_component("spacebar_options");
	
	if not uic_spacebar_options then
		script_error("ERROR: show_ui_options_panel() called but could not find uicomponent uic_spacebar_options");
		return false;
	end;
	
	local uic_panel = UIComponent(uic_spacebar_options:Find(0));
	
	if not uic_panel then
		script_error("ERROR: show_ui_options_panel() called but could not find uicomponent uic_spacebar_options");
		return false;
	end;
	
	if value == false then
		out("@show_ui_options_panel() is hiding ui options panel");
		uic_panel:SetVisible(false);
	else
		out("@show_ui_options_panel() is showing ui options panel");
		uic_panel:SetVisible(true);
	end;
end;


--- @function enable_spell_browser_button
--- @desc Enables/disables the spell browser button on the battle interface. A disabled button will still be visible, but greyed-out.
--- @p [opt=true] @boolean should enable
function battle_manager:enable_spell_browser_button(value)
	local uic_spell_browser_button = bm:ui_component("button_spell_browser");
	
	if not uic_spell_browser_button then
		script_error("ERROR: enable_spell_browser_button() called but could not find uicomponent uic_button_spell_browser");
		return false;
	end;
	
	if value == false then
		out("@enable_spell_browser_button() is disabling spell browser button");
		uic_spell_browser_button:SetState("inactive");
		self.spell_browser_button_text, self.spell_browser_button_text_src = uic_spell_browser_button:GetTooltipText();
		uic_spell_browser_button:SetTooltipText("", true);
	else
		out("@enable_spell_browser_button() is enabling spell browser button");
		uic_spell_browser_button:SetState("active");
		
		if self.spell_browser_button_text and self.spell_browser_button_text_src then
			uic_spell_browser_button:SetTooltipText(self.spell_browser_button_text, self.spell_browser_button_text_src, true);
		end;
	end;
end;


--- @function enable_camera_movement
--- @desc Allows script to prevents player movement of the camera without stealing input - other game interactions are still permitted. Supply false as an argument to disable camera movement.
--- @p [opt=true] @boolean enable movement
function battle_manager:enable_camera_movement(value)
	out("@enable_camera_movement() is " .. (value and "en" or "dis") .. "abling camera functions");
	self:camera():enable_functionality("CAMERA_ALL_FUNCTIONS", not not value, true);
end;


--- @function disable_orders
--- @desc Disables or enables the giving of any orders at all. This function wraps the @battle:disable_orders function of the same name on the @battle interface, adding console output.
--- @p [opt=true] @boolean disable
function battle_manager:disable_orders(value)
	if value == false then
		out("@disable_orders() is enabling orders in battle");
		self.battle:disable_orders(false);
	else
		out("@disable_orders() is disabling orders in battle");
		self.battle:disable_orders(true);
	end;
end;


--- @function disable_pausing
--- @desc Disables or enables pausing.
--- @p [opt=true] @boolean disable
function battle_manager:disable_pausing(value)
	if value == false then
		out("@disable_pausing() is enabling pausing in battle");
		self.battle:disable_shortcut("toggle_pause", false);
	else
		out("@disable_pausing() is disabling pausing in battle");
		self.battle:disable_shortcut("toggle_pause", true);
	end;
end;


--- @function disable_time_speed_controls
--- @desc Disables or enables the time speed controls.
--- @p [opt=true] @boolean disable
function battle_manager:disable_time_speed_controls(value)
	if value == false then
		common.call_context_command("CcoBattleRoot", "", "TimeControlContext.SetCanChangeTime(true)");
	else
		common.call_context_command("CcoBattleRoot", "", "TimeControlContext.SetCanChangeTime(false)");
	end;
end;


--- @function disable_tactical_map
--- @desc Disables or enables the tactical map.
--- @p [opt=true] @boolean disable
function battle_manager:disable_tactical_map(value)
	if value == false then
		out("@disable_tactical_map() is enabling the tactical map");
		self.battle:disable_shortcut("show_tactical_map", false);
		common.set_context_value("disable_battle_tactical_map_button", 0);
	else
		out("@disable_tactical_map() is disabling the tactical map");
		self.battle:disable_shortcut("show_tactical_map", true);
		common.set_context_value("disable_battle_tactical_map_button", 1);
	end;
end;


--- @function disable_help_page_button
--- @desc Disables or enables the help page button.
--- @p [opt=true] @boolean disable
function battle_manager:disable_help_page_button(value)
	if value == false then
		out("@disable_help_page_button() is enabling the help page button");
		common.set_context_value("disable_help_page_button", 0);
	else
		out("@disable_tactical_map() is disabling the help page button");
		common.set_context_value("disable_help_page_button", 1);
	end;
end;


--- @function disable_cycle_battle_speed
--- @desc Disables or enables the battle speed cycling keyboard shortcuts.
--- @p [opt=true] @boolean disable
function battle_manager:disable_cycle_battle_speed(value)
	if value == false then
		out("@disable_cycle_battle_speed() is enabling battle speed cycling keyboard shortcuts");
		self.battle:disable_shortcut("cycle_battle_speed", false);
	else
		out("@disable_cycle_battle_speed() is disabling battle speed cycling keyboard shortcuts");
		self.battle:disable_shortcut("cycle_battle_speed", true);
	end;
end;


--- @function disable_unit_camera
--- @desc Disables or enables the unit camera.
--- @p [opt=true] @boolean disable
function battle_manager:disable_unit_camera(value)
	if value == false then
		out("@disable_unit_camera() is enabling the unit camera");
		self.battle:disable_shortcut("context_camera", false);
	else
		out("@disable_unit_camera() is disabling the unit camera");
		self.battle:disable_shortcut("context_camera", true);
	end;
end;


--- @function disable_unit_details_panel
--- @desc Prevents the unit details panel from being displayed, or allows it to be displayed again after it was previously prevented.
--- @p [opt=true] @boolean disable
function battle_manager:disable_unit_details_panel(value)
	local uic_unit_details_button = find_uicomponent(core:get_ui_root(), "hud_battle", "porthole_parent", "button_toggle_infopanel");
	if not uic_unit_details_button then
		script_error("ERROR: disable_unit_details_panel() called but uic_unit_details_button could not be found");
		return false;
	end;

	if value == false then
		out("@disable_unit_details_panel() is allowing the unit details panel to be toggled");
		uic_unit_details_button:SetVisible(true);
		self.battle:disable_shortcut("visibility_toggle_porthole", false);
	else
		out("@disable_unit_details_panel() is disabling the unit details panel");
		if string.find(uic_unit_details_button:CurrentState(), "selected") then
			uic_unit_details_button:SimulateLClick();
		end;

		uic_unit_details_button:SetVisible(false);
		self.battle:disable_shortcut("visibility_toggle_porthole", true);
	end;
end;









-----------------------------------------------------------------------------
--- @section Showing/Hiding Units for Multiplayer Cutscenes
-----------------------------------------------------------------------------


local function show_sunits_for_mp_cutscenes(sunits, should_show)
	if should_show then
		for i = 1, sunits:count() do
			local current_sunit = sunits:item(i);
			
			if current_sunit.restore_script_control_when_showing_for_mp_cutscenes then
				current_sunit.restore_script_control_when_showing_for_mp_cutscenes = nil;
				current_sunit:set_enabled(true);
			end;

			if current_sunit.restore_script_control_when_showing_for_mp_cutscenes then
				current_sunit.restore_script_control_when_showing_for_mp_cutscenes = nil;
				current_sunit:take_control();
			else
				current_sunit:release_control();
			end;
		end;
	else
		for i = 1, sunits:count() do
			local current_sunit = sunits:item(i);

			if current_sunit.unit:is_script_controlled() then
				current_sunit.restore_script_control_when_showing_for_mp_cutscenes = true;
			end;

			if has_deployed(current_sunit) then
				current_sunit.restore_script_control_when_showing_for_mp_cutscenes = true;
				current_sunit:set_enabled(false);
			end;
		end;
	end;
end;



--- @function show_player_alliance_units_for_mp_cutscenes
--- @desc Shows or hides all units in the player's alliance. This is primarily intended for multiplayer cutscenes but could be used for other purposes.
--- @p @boolean show
function battle_manager:show_player_alliance_units_for_mp_cutscenes(should_show)
	for i = 1, self:num_alliances() do
		if i == self:get_player_alliance_num() then
			for j = 1, bm:num_armies_in_alliance(i) do
				show_sunits_for_mp_cutscenes(bm:get_scriptunits_for_army(i, j), should_show);
				for k = 1, bm:num_reinforcing_armies_for_army_in_alliance(i, j) do
					show_sunits_for_mp_cutscenes(bm:get_scriptunits_for_army(i, j, k), should_show);
				end;
			end;
		end;
	end;
end;



--- @function show_player_army_units_for_mp_cutscenes
--- @desc Shows or hides all units in the player's army. This is primarily intended for multiplayer cutscenes but could be used for other purposes.
--- @p @boolean show
function battle_manager:show_player_army_units_for_mp_cutscenes(should_show)
	show_sunits_for_mp_cutscenes(bm:get_scriptunits_for_local_players_army(), true);

	local local_player_alliance = self:local_alliance()
	local local_player_army = self:local_army()
	for k = 1, bm:num_reinforcing_armies_for_army_in_alliance(local_player_alliance, local_player_army) do
		show_sunits_for_mp_cutscenes(bm:get_scriptunits_for_army(local_player_alliance, local_player_army, k), true);
	end;
end;





-----------------------------------------------------------------------------
--- @section Building Lists
-----------------------------------------------------------------------------


--- @function get_fort_tower_buildings
--- @desc Returns a table containing a @battle_building object for each fort tower building on the map. The table will not be copied, so modifying the returned table will also modify the battle manager's internal version.
--- @r @table fort tower buildings
function battle_manager:get_fort_tower_buildings()
	return self.fort_tower_buildings;
end;



--- @function get_fort_gate_buildings
--- @desc Returns a table containing a @battle_building object for each fort gate building on the map. The table will not be copied, so modifying the returned table will also modify the battle manager's internal version.
--- @r @table fort gate buildings
function battle_manager:get_fort_gate_buildings()
	return self.fort_gate_buildings;
end;


--- @function get_fort_wall_buildings
--- @desc Returns a table containing a @battle_building object for each fort wall building on the map. The table will not be copied, so modifying the returned table will also modify the battle manager's internal version.
--- @r @table fort wall buildings
function battle_manager:get_fort_wall_buildings()
	return self.fort_wall_buildings;
end;


local function print_building_list(bm, list, list_name)
	if #list == 0 then
		bm:out("Printing " .. list_name .. " buildings: <no buildings>");	
		return;
	end;

	bm:out("Printing " .. list_name .. " buildings:");
	for i = 1, #list do
		local current_building = list[i];
		bm:out("\t" .. i .. "\tname: " .. current_building:name() .. ", category: " .. current_building:category() .. ", health: " .. current_building:health() .. ", position: " .. v_to_s(current_building:central_position()));
	end;
end;


--- @function print_fort_tower_buildings
--- @desc Prints a debug list of all fort tower buildings on the map.
function battle_manager:print_fort_tower_buildings()
	print_building_list(bm, self.fort_tower_buildings, "fort tower");
end;


--- @function print_fort_gate_buildings
--- @desc Prints a debug list of all fort gate buildings on the map.
function battle_manager:print_fort_gate_buildings()
	print_building_list(bm, self.fort_gate_buildings, "fort gate");
end;


--- @function print_fort_wall_buildings
--- @desc Prints a debug list of all fort wall buildings on the map.
function battle_manager:print_fort_wall_buildings()
	print_building_list(bm, self.fort_wall_buildings, "fort wall");
end;










-----------------------------------------------------------------------------
--- @section Conflict Time Update
--- @desc The functions in this section relate to conflict time updating, which is the battle timer that ticks down to the end of the battle. Certain client scripts such as cutscenes may want to enable/disable/cache/restore conflict time settings.
-----------------------------------------------------------------------------

--- @function change_conflict_time_update_overridden
--- @desc Enables or disables the countdown of the conflict timer. This function wraps the underlying @battle interface function @battle:change_conflict_time_update_overridden. Call with an argument of <code>true</code> to disable the countdown of the conflict timer, or <code>false</code> to enable it again. With conflict time update overridden, time can pass but the victory timer will not count down.
--- @p @boolean disable update
function battle_manager:change_conflict_time_update_overridden(disable)
	self.current_conflict_time_update_overridden = disable;
	self.battle:change_conflict_time_update_overridden(disable);
end;


--- @function cache_conflict_time_update_overridden
--- @desc Caches whether conflict time is currently overridden. The cached value can be later restored with @battle_manager:restore_conflict_time_update_overridden.
function battle_manager:cache_conflict_time_update_overridden()
	self.cached_conflict_time_update_overridden = self.current_conflict_time_update_overridden;
end;


--- @function restore_conflict_time_update_overridden
--- @desc Restores any conflict override setting previously cached with @battle_manager:cache_conflict_time_update_overridden.
function battle_manager:restore_conflict_time_update_overridden()
	self.current_conflict_time_update_overridden = self.cached_conflict_time_update_overridden;
	self.battle:change_conflict_time_update_overridden(self.current_conflict_time_update_overridden);
end;








-----------------------------------------------------------------------------
--- @section Camera
-----------------------------------------------------------------------------


--- @function cache_camera
--- @desc Caches the current position/target of the camera for later retrieval.
function battle_manager:cache_camera()
	local cam = self:camera();
	self.cached_camera_pos = cam:position();
	self.cached_camera_targ = cam:target();
end;


--- @function get_cached_camera_pos
--- @desc Gets the cached position of the camera. This must be called after the position has been cached with @battle_manager:cache_camera (else it will return false).
function battle_manager:get_cached_camera_pos()
	return self.cached_camera_pos;
end;


--- @function get_cached_camera_targ
--- @desc Gets the cached target of the camera. This must be called after the position has been cached with @battle_manager:cache_camera (else it will return false).
function battle_manager:get_cached_camera_targ()
	return self.cached_camera_targ;
end;


--- @function scroll_camera_with_cutscene
--- @desc Automatically creates and starts a @cutscene in which the camera is moved to the supplied co-ordinates.
--- @p @battle_vector position, Camera position.
--- @p @battle_vector target, Camera target.
--- @p @number duration, Duration of camera movement in seconds.
--- @p [opt=nil] @function end callback, Function to call when cutscene ends (either naturally or by being skipped).
--- @p [opt=0] @number fov, Field of view at target position in degrees. Supply <code>0</code> or @nil to use the game default.
--- @p [opt=true] @boolean skippable, Sets whether cutscene is skippable or not.
--- @p [opt=nil] @function skip callback, Function to call when cutscene is skipped.
function battle_manager:scroll_camera_with_cutscene(position, target, duration, end_callback, fov, is_skippable, skip_callback)
	if not is_vector(position) then
		script_error("ERROR: scroll_camera_with_cutscene() called but supplied camera position [" .. tostring(position) .. "] is not a battle vector");
		return false;
	end;

	if not is_vector(target) then
		script_error("ERROR: scroll_camera_with_cutscene() called but supplied camera target [" .. tostring(target) .. "] is not a battle vector");
		return false;
	end;

	if not is_number(duration) or duration <= 0 then
		script_error("ERROR: scroll_camera_with_cutscene() called but supplied duration [" .. tostring(duration) .. "] is not a positive number");
		return false;
	end;

	if end_callback and not is_function(end_callback) then
		script_error("ERROR: scroll_camera_with_cutscene() called but supplied end callback [" .. tostring(end_callback) .. "] is not a function or nil");
		return false;
	end;

	if not fov then
		fov = 0;
	elseif not is_number(fov) or fov <= 0 then
		script_error("ERROR: scroll_camera_with_cutscene() called but supplied field of view [" .. tostring(fov) .. "] is not a positive number or nil");
		return false;
	end;

	if is_skippable == nil then
		is_skippable = true;
	elseif not is_boolean(is_skippable) then
		script_error("ERROR: scroll_camera_with_cutscene() called but supplied is skippable flag [" .. tostring(is_skippable) .. "] is not a boolean or nil");
		return false;
	end;

	if skip_callback and not is_function(skip_callback) then
		script_error("ERROR: scroll_camera_with_cutscene() called but supplied skip callback [" .. tostring(skip_callback) .. "] is not a function or nil");
		return false;
	end;

	-- create, build and start cutscene object
	local c = cutscene:new(
		"scroll_camera_with_cutscene_" .. core:get_unique_counter(),
		self:get_scriptunits_for_local_players_army(),
		duration * 1000,
		end_callback
	);
	c:set_close_advisor_on_start(false);
	c:set_close_advisor_on_end(false);
	c:set_show_cinematic_bars(false);
	c:set_skippable(is_skippable, skip_callback);
	c:action(function() self:camera():move_to(position, target, duration, false, fov) end, 0)
	c:start();
end;









-----------------------------------------------------------------------------
--- @section Camera Movement Tracker
--- @desc The camera movement tracker is used by some tutorial scripts to track how the player is moving the camera.
-----------------------------------------------------------------------------


--- @function start_camera_movement_tracker
--- @desc Starts the camera movement tracker. Only tutorial scripts which need to query camera tracker information need to do this.
function battle_manager:start_camera_movement_tracker()
	self.camera_tracker_active = true;
	self.original_cached_camera_pos = self:camera():position();
	self.last_cached_camera_pos = self.original_cached_camera_pos;
	self.camera_tracker_distance_travelled = 0;

	self:repeat_callback(function() self:update_camera_movement_tracker() end, 200, "battle_manager_camera_movement_tracker");
end;


--- @function stop_camera_movement_tracker
--- @desc Stops the camera movement tracker.
function battle_manager:stop_camera_movement_tracker()
	self.camera_tracker_active = false;
	self.original_cached_camera_pos = false;
	self.last_cached_camera_pos = false;
	self:remove_process("battle_manager_camera_movement_tracker");
end;


function battle_manager:update_camera_movement_tracker()
	local cam = self:camera();
	local cam_position = cam:position();
	
	self.camera_tracker_distance_travelled = self.camera_tracker_distance_travelled + cam_position:distance_xz(self.last_cached_camera_pos);
	
	self.last_cached_camera_pos = cam_position;
end;


--- @function get_camera_altitude_change
--- @desc Gets the difference in camera altitude between now and when the tracker was started. The returned value is absolute (always positive).
--- @r number difference in m
function battle_manager:get_camera_altitude_change()
	if not is_vector(self.original_cached_camera_pos) then
		script_error("ERROR: get_camera_altitude_change() called but no camera position cached - call start_camera_movement_tracker() first");
		return 0;
	end;
	
	local cam = self:camera();
	
	return math.abs(cam:position():get_y() - self.original_cached_camera_pos:get_y());
end;


--- @function get_camera_distance_travelled
--- @desc Gets the total distance the camera has travelled between now and when the tracker was started. This distance is not exact, but gives the calling script an indication of how much the player is moving the camera.
--- @r number distance in m
function battle_manager:get_camera_distance_travelled()
	return self.camera_tracker_distance_travelled;
end;












-----------------------------------------------------------------------------
-- add/remove ping icon overrides
-----------------------------------------------------------------------------


function battle_manager:add_ping_icon(pos_x, pos_y, pos_z, ping_type, is_waypoint, rotation)
	self:out("* adding ping icon at [" .. tostring(pos_x) .. ", " .. tostring(pos_y) .. ", " .. tostring(pos_z) .. "], type [" .. tostring(ping_type) .. "], is_waypoint [" .. tostring(is_waypoint) .. "], rotation [" .. tostring(rotation) .. "]");
	return self.battle:add_ping_icon(pos_x, pos_y, pos_z, ping_type, is_waypoint, rotation);
end;


function battle_manager:remove_ping_icon(pos_x, pos_y, pos_z)
	self:out("* removing ping icon at [" .. tostring(pos_x) .. ", " .. tostring(pos_y) .. ", " .. tostring(pos_z) .. "]");
	return self.battle:remove_ping_icon(pos_x, pos_y, pos_z);
end;















-----------------------------------------------------------------------------
--- @section Engagement Monitor
--- @desc The Engagement monitor is a set of processes that continually query the battle state and either store information for other scripts to look up or trigger events for other scripts to listen to. The engagement monitor doesn't start automatically, but must be started by scripts that need the processing and information that it requires, mostly advice/tutorial scripts.
--- @desc The Engagement monitor tracks the following information:
--- @desc <ul><li>the distance between the two alliances on the battlefield, which other scripts can query instead of continually working it out themselves which is potentially expensive.</li>
--- @desc <li>the number/proportion of the player's alliance that is engaged in melee/under fire.</li>
--- @desc <li>the average altitude of both the player and enemy alliance.</li></ul>
--- @desc The Engagement monitor also triggers the following events:
--- @desc <ul><li><code>ScriptEventBattleArmiesEngaging</code>, when the two sides close to within 100m or once more than 40% of the player's army is under fire.</li>
--- @desc <li><code>ScriptEventPlayerGeneralWounded</code>, if the player's general is wounded (they must be invincible).</li>
--- @desc <li><code>ScriptEventPlayerGeneralDies</code>, if the player's general dies (not invincible).</li>
--- @desc <li><code>ScriptEventEnemyGeneralWounded</code>, if the enemy general is wounded (they must be invincible).</li>
--- @desc <li><code>ScriptEventEnemyGeneralDies</code>, if the enemy general dies (not invincible).</li>
--- @desc <li><code>ScriptEventPlayerGeneralRouts</code>, if the player's general routs.</li>
--- @desc <li><code>ScriptEventEnemyGeneralRouts</code>, if the enemy general routs.</li>
--- @desc <li><code>ScriptEventPlayerUnitRouts</code>, if one of the player's units routs.</li>
--- @desc <li><code>ScriptEventPlayerUnitRallies</code>, if one of the player's units rallies.</li>
--- @desc <li><code>ScriptEventEnemyUnitRouts</code>, if one of the enemy units routs.</li></ul>
-----------------------------------------------------------------------------

--- @function start_engagement_monitor
--- @desc Starts the engagement monitor. This must be called before the "Deployed" phase change occurs (i.e. before the end of deployment).
function battle_manager:start_engagement_monitor()
	if self.engagement_monitor_started then
		script_error("WARNING: start_engagement_monitor() called engagement monitor is already started, disregarding");
		return false;
	end;
	
	self.engagement_monitor_started = true;
	
	-- start live condition listeners when the battle proper starts
	bm:register_phase_change_callback("Deployed", function() self:engagement_monitor_battle_starts() end);
end;


function battle_manager:engagement_monitor_battle_starts()

	local player_alliance = self:get_player_alliance();
	local enemy_alliance = self:get_non_player_alliance();
	
	local num_units_player_alliance = num_units_in_collection(player_alliance);
	local num_units_enemy_alliance = num_units_in_collection(enemy_alliance);
	
	local main_player_army = self:get_player_army();
	local main_enemy_army = self:get_first_non_player_army();
	
	local player_units_routing = {};

	-- poll the distance between the two forces and cache the result so other scripts can look it up (intended for advice)
	self.cached_distance_between_forces = distance_between_forces(player_alliance, enemy_alliance, standing_only);
	self:repeat_callback(
		function()
			self.cached_distance_between_forces = distance_between_forces(player_alliance, enemy_alliance, standing_only);
		end,
		1100,
		"battle_manager_engagement_monitor"
	);
	
	-- divide-by-zero check
	if num_units_player_alliance == 0 then
		script_error("ERROR: engagement_monitor_battle_starts() called but the number of units in the player's alliance seems to be zero, how can this be?");
		return false;
	end;
	
	-- poll the number of units engaged between the two forces and cache the result so other scripts can look it up (intended for advice)
	local cache_num_units_engaged = function()
		self.cached_num_units_engaged = num_units_engaged(player_alliance);
		self.cached_proportion_engaged = self.cached_num_units_engaged / num_units_player_alliance;
		self.cached_num_units_under_fire = num_units_under_fire(player_alliance);
		self.cached_proportion_under_fire = self.cached_num_units_under_fire / num_units_player_alliance;
	end;
	
	cache_num_units_engaged();
	
	self:repeat_callback(
		function()
			cache_num_units_engaged();
		end,
		1000,
		"battle_manager_engagement_monitor"
	);
	
	
	--
	-- watch for the two sides engaging
	--
	self:watch(
		function()
			local distance_between_forces = self:get_distance_between_forces();
			local proportion_under_fire = self:get_proportion_under_fire();
			
			return self:get_distance_between_forces() < 100 or self:get_proportion_under_fire() > 0.4
		end,
		0,
		function()
			self:out("ScriptEventBattleArmiesEngaging event triggered, distance between forces is " .. tostring(self:get_distance_between_forces()) .. " and proportion under fire is " .. tostring(self:get_proportion_under_fire()));
			core:trigger_event("ScriptEventBattleArmiesEngaging");
		end,
		"engagement_monitor_two_sides_engaging_watch"
	);
	
	
	--
	-- work out the altitude of the main player and main enemy army
	--
	
	self.main_player_army_altitude = get_average_altitude(main_player_army);
	self.main_enemy_army_altitude = get_average_altitude(main_enemy_army);
	self:repeat_callback(
		function()
			self.main_player_army_altitude = get_average_altitude(main_player_army);
			self.main_enemy_army_altitude = get_average_altitude(main_enemy_army);
		end,
		4900,
		"battle_manager_altitude_monitor"
	);
	
	
	--
	-- watch for the main player and enemy generals dying and trigger events
	--
	
	-- player
	self:watch(
		function()
			return not main_player_army:is_commander_alive();
		end,
		0,
		function()
			if main_player_army:is_commander_invincible() then
				core:trigger_event("ScriptEventPlayerGeneralWounded");
			else
				core:trigger_event("ScriptEventPlayerGeneralDies");
			end;
		end,
		"engagement_monitor_player_commander_alive_watch"
	);
	
	-- enemy
	self:watch(
		function()
			return not main_enemy_army:is_commander_alive();
		end,
		0,
		function()
			if main_enemy_army:is_commander_invincible() then
				core:trigger_event("ScriptEventEnemyGeneralWounded");
			else
				core:trigger_event("ScriptEventEnemyGeneralDies");
			end;
		end,
		"engagement_monitor_enemy_commander_alive_watch"
	);

	
	--
	-- listen for units and commanders routing
	--
	
	-- listener for player commmander routing
	core:add_listener(
		"player_commander_routs_watch",
		"BattleCommandingUnitRouts",
		true,
		function()
			self:callback(
				function()
					local player_units = main_player_army:units();
					
					for i = 1, player_units:count() do
						local current_unit = player_units:item(i);
						
						if current_unit:is_commanding_unit() then
							if current_unit:is_routing() or current_unit:is_shattered() then
								core:remove_listener("player_commander_routs_watch");
								self:out("<<< triggering event ScriptEventPlayerGeneralRouts >>>");
								core:trigger_event("ScriptEventPlayerGeneralRouts");
								return true;
							else
								return false;
							end;
						end;
					end;
					return false;
				end,
				500,
				"player_commander_routs_watch"
			);
		end,
		true
	);
	
	-- listener for enemy commmander routing
	core:add_listener(
		"enemy_commander_routs_watch",
		"BattleCommandingUnitRouts",
		true,
		function()
			self:callback(
				function()
					local enemy_units = main_enemy_army:units();
					
					for i = 1, enemy_units:count() do
						local current_unit = enemy_units:item(i);
						
						if current_unit:is_commanding_unit() then
							if current_unit:is_routing() or current_unit:is_shattered() then
								core:remove_listener("enemy_commander_routs_watch");
								self:out("<<< triggering event ScriptEventMainEnemyGeneralRouts >>>");
								core:trigger_event("ScriptEventMainEnemyGeneralRouts");
								return true;
							else
								return false;
							end;
						end;
					end;
					return false;
				end,
				500,
				"enemy_commander_routs_watch"
			);
		end,
		true
	);
	
	
	-- listener for player units routing
	core:add_listener(
		"player_unit_routs_watch",
		"BattleUnitRouts",
		true,
		function()
			self:callback(
				function()
					local player_units = main_player_army:units();
					
					for i = 1, player_units:count() do
						local current_unit = player_units:item(i);
						
						if not current_unit:is_commanding_unit() then
							if current_unit:is_routing() or current_unit:is_shattered() then
								
								-- trigger an event message if we haven't seen this unit routing before
								if not player_units_routing[current_unit] then
									player_units_routing[current_unit] = true;
									self:out("<<< triggering event ScriptEventPlayerUnitRouts >>>");
									core:trigger_event("ScriptEventPlayerUnitRouts");
								end;
							end;
						end;
					end
				end,
				500,
				"engagement_monitor_unit_routs"
			);
		end,
		true
	);
	
	
	-- check for routing player units rallying
	self:repeat_callback(
		function()
			for unit in pairs(player_units_routing) do
				if is_unit(unit) and not unit:is_routing() and not unit:is_shattered() then
					player_units_routing[unit] = nil;
					self:out("<<< triggering event ScriptEventPlayerUnitRallies >>>");
					core:trigger_event("ScriptEventPlayerUnitRallies");
				end;
			end;
		end,
		1000,
		"engagement_monitor_rallying_check"
	);
	
	
	-- listener for first enemy unit routing
	core:add_listener(
		"enemy_unit_routs_watch",
		"BattleUnitRouts",
		true,
		function()
			self:callback(
				function()				
					local enemy_armies = enemy_alliance:armies();
					
					for i = 1, enemy_armies:count() do
						local enemy_units = enemy_armies:item(i):units();
					
						for j = 1, enemy_units:count() do
							local current_unit = enemy_units:item(j);
							
							if not current_unit:is_commanding_unit() then
								if current_unit:is_routing() or current_unit:is_shattered() then
									self:out("<<< triggering event ScriptEventEnemyUnitRouts >>>");
									core:trigger_event("ScriptEventEnemyUnitRouts");
									core:remove_listener("enemy_unit_routs_watch");
									return true;
								end;
							end;
						end;
					end;
				end,
				500,
				"engagement_monitor_first_enemy_unit_routs"
			);
		end,
		true
	);
end;


--- @function get_distance_between_forces
--- @desc Returns the cached distance between the two alliances. @battle_manager:start_engagement_monitor must have been called before the battle started for this to work.
--- @r number distance
function battle_manager:get_distance_between_forces()
	if not self.engagement_monitor_started then
		script_error("ERROR: get_distance_between_forces() called but engagement monitor has not been started");
		return false;
	end;
	return self.cached_distance_between_forces;
end;


--- @function get_num_units_engaged
--- @desc Returns the number of units in the player's alliance engaged in melee. @battle_manager:start_engagement_monitor must have been called before the battle started for this to work.
--- @r number engaged
function battle_manager:get_num_units_engaged()
	if not self.engagement_monitor_started then
		script_error("ERROR: get_num_units_engaged() called but engagement monitor has not been started");
		return false;
	end;
	return self.cached_num_units_engaged;
end;


--- @function get_proportion_engaged
--- @desc Returns the proportion of units in the player's alliance engaged in melee. This proportion will be a unary value (0 - 1). @battle_manager:start_engagement_monitor must have been called before the battle started for this to work.
--- @r number proportion engaged
function battle_manager:get_proportion_engaged()
	if not self.engagement_monitor_started then
		script_error("ERROR: get_proportion_engaged() called but engagement monitor has not been started");
		return false;
	end;
	return self.cached_proportion_engaged;
end;


--- @function get_num_units_under_fire
--- @desc Returns the number of units in the player's alliance under missile fire. @battle_manager:start_engagement_monitor must have been called before the battle started for this to work.
--- @r number under fire
function battle_manager:get_num_units_under_fire()
	if not self.engagement_monitor_started then
		script_error("ERROR: get_num_units_under_fire() called but engagement monitor has not been started");
		return false;
	end;
	return self.cached_num_units_under_fire;
end;


--- @function get_proportion_under_fire
--- @desc Returns the proportion of units in the player's alliance engaged in melee. This proportion will be a unary value (0 - 1). @battle_manager:start_engagement_monitor must have been called before the battle started for this to work.
--- @r number proportion engaged
function battle_manager:get_proportion_under_fire()
	if not self.engagement_monitor_started then
		script_error("ERROR: get_proportion_under_fire() called but engagement monitor has not been started");
		return false;
	end;
	return self.cached_proportion_under_fire;
end;


--- @function get_player_army_altitude
--- @desc Returns the average altitude of the player's army in m.
--- @r number average altitude
function battle_manager:get_player_army_altitude()
	if not self.engagement_monitor_started then
		script_error("ERROR: get_player_army_altitude() called but engagement monitor has not been started");
		return false;
	end;
	return self.main_player_army_altitude;
end;


--- @function get_enemy_army_altitude
--- @desc Returns the average altitude of the enemy army in m.
--- @r number average altitude
function battle_manager:get_enemy_army_altitude()
	if not self.engagement_monitor_started then
		script_error("ERROR: get_enemy_army_altitude() called but engagement monitor has not been started");
		return false;
	end;
	return self.main_enemy_army_altitude;
end;


--- @function stop_engagement_monitor
--- @desc Stops the engagement monitor.
function battle_manager:stop_engagement_monitor()
	self.engagement_monitor_started = false;
	self:remove_process("battle_manager_engagement_monitor");
end;










-----------------------------------------------------------------------------
--- @section Composite Scenes
-----------------------------------------------------------------------------

--- @function start_terrain_composite_scene
--- @desc Starts a composite scene with the supplied key. If an optional group name is set then this composite scene will not play if another from the same group is active, but will instead be enqueued. When a composite scene in a group stops and a second in the same group is enqueued, then that second scene will begin to play automatically.
--- @p string key, Composite scene key.
--- @p [opt=false] string group name, Composite group name.
--- @p [opt=false] number delay, Delay in milliseconds to wait before starting if this composite scene becomes enqueued behind another (allowing a minimum time separation between composite scenes of the same group to be specified). This has no effect if no group name is specified.
function battle_manager:start_terrain_composite_scene(composite_scene_key, composite_scene_group_name, delay_if_enqueued)
	
	if not is_string(composite_scene_key) then
		script_error("ERROR: start_terrain_composite_scene() called but supplied composite scene key [" .. tostring(composite_scene_key) .. "] is not a string");
		return false;
	end;
	
	-- don't try and start this composite scene if it's already active
	if self.composite_scenes_currently_active[composite_scene_key] then
		script_error("ERROR: start_terrain_composite_scene() called but supplied composite scene with key [" .. tostring(composite_scene_key) .. "] is already active");
		return false;
	end;
	
	-- if no group is specified then just start this composite scene
	if not composite_scene_group_name then
		self:start_terrain_composite_scene_action(composite_scene_key);
		return;
	end;
	
	if not is_string(composite_scene_group_name) then
		script_error("ERROR: start_terrain_composite_scene() called but supplied composite scene group name [" .. tostring(composite_scene_group_name) .. "] is not a string");
		return false;
	end;
	
	if delay_if_enqueued and (not is_number(delay_if_enqueued) or delay_if_enqueued < 0) then
		script_error("ERROR: start_terrain_composite_scene() called but supplied composite scene group delay [" .. tostring(delay_if_enqueued) .. "] is not a positive number or nil");
		return false;
	end;
	
	if not self.composite_scene_groups[composite_scene_group_name] then
		-- no group with this name has yet been specified - in this case create a record for it
		self.composite_scene_groups[composite_scene_group_name] = {};
	end;
	
	if #self.composite_scene_groups[composite_scene_group_name] == 0 then
		-- there are no composite scenes belonging to this group currently playing, so go ahead and play this one
		self:start_terrain_composite_scene_action(composite_scene_key, composite_scene_group_name, false);
	end;
	
	-- add an entry for this composite scene to the group list
	local composite_scene_group_entry = {};
	composite_scene_group_entry.composite_scene_key = composite_scene_key;
	composite_scene_group_entry.composite_scene_group_name = composite_scene_group_name;
	composite_scene_group_entry.delay_if_enqueued = delay_if_enqueued;
	
	table.insert(self.composite_scene_groups[composite_scene_group_name], composite_scene_group_entry);
end;


-- actually start a composite scene
function battle_manager:start_terrain_composite_scene_action(composite_scene_key, composite_scene_group_name, is_enqueued)
	
	if composite_scene_group_name then
		if is_enqueued then
			self:out("@ starting previously-queued composite scene with key " .. composite_scene_key .. " from group " .. composite_scene_group_name .. " @");
		else
			self:out("@ starting composite scene with key " .. composite_scene_key .. " from group " .. composite_scene_group_name .. " @");
		end;
	else
		self:out("@ starting composite scene with key " .. composite_scene_key .. " @");
	end;
	
	self.composite_scenes_currently_active[composite_scene_key] = true;
	self.battle:start_terrain_composite_scene(composite_scene_key);
end;



--- @function stop_terrain_composite_scene
--- @desc Stops a composite scene with the supplied key. If this composite scene was specified as belonging to a group when it was started, and other composite scenes in that group are enquened, then the next one will begin to play automatically (after an optional delay).
--- @p string key, Composite scene key.
function battle_manager:stop_terrain_composite_scene(composite_scene_key)
	
	if not is_string(composite_scene_key) then
		script_error("ERROR: stop_terrain_composite_scene() called but supplied composite scene key [" .. tostring(composite_scene_key) .. "] is not a string");
		return false;
	end;
	
	-- don't try and stop this composite scene if it's not active
	if not self.composite_scenes_currently_active[composite_scene_key] then
		script_error("ERROR: stop_terrain_composite_scene() called but supplied composite scene with key [" .. tostring(composite_scene_key) .. "] is not active");
		return false;
	end;
	
	-- stop the scene
	self.battle:stop_terrain_composite_scene(composite_scene_key);
	self.composite_scenes_currently_active[composite_scene_key] = false;
	
	-- go through our groups to see if this scene was added to a group anywhere
	for composite_scene_group_name, composite_scene_group_list in pairs(self.composite_scene_groups) do
		for i = 1, #composite_scene_group_list do		
			if composite_scene_group_list[i].composite_scene_key == composite_scene_key then
				
				-- we've found this scene in a group table - remove it, then play any scene queued up behind it
				table.remove(composite_scene_group_list, i);
				
				if #composite_scene_group_list > 0 then
					local next_composite_scene_group_entry = composite_scene_group_list[1];
					
					if next_composite_scene_group_entry.delay_if_enqueued then 
						-- a scene is queued up but we have to wait before triggering it
						self:callback(
							function()
								self:start_terrain_composite_scene_action(
									next_composite_scene_group_entry.composite_scene_key, 
									next_composite_scene_group_entry.composite_scene_group_name, 
									true
								);
							end,
							next_composite_scene_group_entry.delay_if_enqueued
						)
					else
						-- a scene is queued up and we don't have to wait, so trigger it
						self:start_terrain_composite_scene_action(
							next_composite_scene_group_entry.composite_scene_key, 
							next_composite_scene_group_entry.composite_scene_group_name, 
							true
						);
					end;
				end;
				
				return;
			end;
		end;
	end;
end;










-----------------------------------------------------------------------------
--- @section Survival Battle Waves
-----------------------------------------------------------------------------

--- @function add_survival_battle_wave
--- @desc Adds a script units collection to a survival battle wave by index number. A new survival battle wave process is created if one does not already exist for the supplied number.
--- @desc When a new survival battle wave is created, the battle manager starts a process which automatically monitors the health of all units in that wave, updating the UI accordingly. The state of the wave is set to <code>"incoming"</code> to start with, to <code>"in_progress"</code> when the units in the wave first enter combat, and then to <code>"defeated"</code> when those units are routed or killed. The progress value of the wave is also continually updated.
--- @p @number index, Survival battle wave index. This should be an ascending integer for each new wave e.g. wave 1, wave 2 etc.
--- @p @script_units script units, Script units collection containing sunits to add to the wave.
--- @p [opt=false] @boolean is final wave, Is this the final wave.
function battle_manager:add_survival_battle_wave(index, sunits, is_final_wave)
	if not is_number(index) or index < 0 then
		script_error("ERROR: add_survival_battle_wave() called but supplied index value [" .. tostring(index) .. "] is not a number");
		return false;
	end;

	if not is_scriptunits(sunits) then
		script_error("ERROR: add_survival_battle_wave() called but supplied scriptunits [" .. tostring(sunits) .. "] is not a valid scriptunits collection");
		return false;
	end;

	is_final_wave = not not is_final_wave;

	local active_survival_battle_waves = self.active_survival_battle_waves;
	local wave_record = false;

	for i = 1, #active_survival_battle_waves do
		if active_survival_battle_waves[i].index == index then
			wave_record = active_survival_battle_waves[i];
			break;
		end;
	end;

	local should_notify_wave_state_changed = true;
	local new_state = "incoming";

	if wave_record then
		-- add the supplied scriptunits to those already present in the wave
		wave_record.sunits:add_sunits(unpack(sunits:get_sunit_table()));
		
		-- if this wave was previously marked as defeated then we now mark it as incoming (should this ever happen?), otherwise we will use the existing wave state (incoming or in-progress)
		if wave_record.state == "defeated" then
			wave_record.state = new_state;
		else
			should_notify_wave_state_changed = false;		-- don't do an update if the state hasn't changed
			new_state = wave_record.state;
		end;
		self:notify_wave_units_changed(index, unpack(wave_record.sunits:get_unit_table()));
	else
		-- create a new wave		
		local starting_hitpoints = sunits:unary_hitpoints(true);
		local new_wave_record = {
			index = index,
			sunits = sunits:duplicate("survival_battle_wave_" .. index),
			state = new_state,
			is_final_wave = is_final_wave,
			last_hp = starting_hitpoints
		};

		table.insert(self.active_survival_battle_waves, new_wave_record);

		if not self.survival_battle_wave_monitors_started then
			self.survival_battle_wave_monitors_started = true;
			self:repeat_callback(
				function()
					self:update_survival_battle_waves();
				end,
				500
			);
		end;
		self:notify_wave_units_changed(index, unpack(new_wave_record.sunits:get_unit_table()));
		self:notify_wave_progress_changed(index, starting_hitpoints);
	end;

	if should_notify_wave_state_changed then
		self:notify_wave_state_changed(index, new_state, is_final_wave);
	end;
end;


-- internal function to update survival battle waves - this is polled
function battle_manager:update_survival_battle_waves()
	for i = 1, #self.active_survival_battle_waves do
		local current_wave_record = self.active_survival_battle_waves[i];
		local current_index = current_wave_record.index;
		local current_sunits = current_wave_record.sunits;

		-- update progress
		local current_hp = current_sunits:unary_hitpoints(true);
		if current_hp ~= current_wave_record.last_hp then
			current_wave_record.last_hp = current_hp;
			self:notify_wave_progress_changed(current_index, current_hp);
		end;

		-- query for state change
		if current_wave_record.state == "incoming" then
			if current_sunits:is_under_attack() then
				local new_state = "in_progress";
				self:notify_wave_state_changed(current_index, new_state, current_wave_record.is_final_wave);
				current_wave_record.state = new_state;
				core:trigger_custom_event("ScriptEventSurvivalBattleWaveInProgress", {index = current_index, is_final_wave = current_wave_record.is_final_wave})
			end;

		elseif current_wave_record.state == "in_progress" then
			if current_sunits:are_all_routing_or_dead() then
				local new_state = "defeated";
				self:notify_wave_state_changed(current_index, new_state, current_wave_record.is_final_wave);
				current_wave_record.state = new_state;
				core:trigger_custom_event("ScriptEventSurvivalBattleWaveDefeated", {index = current_index, is_final_wave = current_wave_record.is_final_wave})
			end;
		end;
	end;
end;










-----------------------------------------------------------------------------
--- @section Spawn Zone Collections
-----------------------------------------------------------------------------


function battle_manager:construct_spawn_zone_list()
	if self.spawn_zone_list_constructed then
		return;
	end;

	self.spawn_zone_list_constructed = true;
	
	local spawn_zone_list = {};

	local reinforcements = bm:reinforcements();
	for i = 1, reinforcements:spawn_zone_count() do
		local current_spawn_zone = reinforcements:spawn_zone(i);
		if current_spawn_zone:has_reinforcement_line() then
			table.insert(
				spawn_zone_list,
				{
					spawn_zone = current_spawn_zone,
					count = 0
				}
			);
		end;
	end;

	bm:out("");
	bm:out("construct_spawn_zone_list() has found the following spawn zones on the map associated with named reinforcement lines:");
	
	for i = 1, #spawn_zone_list do
		local spawn_zone = spawn_zone_list[i].spawn_zone;
		bm:out("\t[" .. i .. "] reinforcement line script id [" .. spawn_zone:reinforcement_line():script_id() .. "] at position " .. v_to_s(spawn_zone:position()));
	end;
	
	bm:out("");

	self.spawn_zone_list = spawn_zone_list;
end;


--- @function get_spawn_zone_collection_by_name
--- @desc Returns a table containing all spawn zones on the battlefield where the script id of the contained reinforcement line partially match any of the supplied names. The script_id of each spawn zone/reinforcement line pair is checked - should it contain any of the supplied @string arguments then that spawn zone is added to the collection to be returned. Partial matches are possible, so a spawn zone with a reinforcement line called something like <code>sz_section_3_rear</code> will match against the argument <code>section_3</code>.
--- @desc The returned spawn zone collection is a table containing subtables, each of which contains a spawn zone and a count of how many time that spawn zone has had a reinforcement army assigned to it by script. The spawn zone collection can be passed to @battle_manager:get_random_spawn_zone_from_collection to get a semi-random spawn zone from the collection.
--- @p vararg names, Spawn zone names to match, each of which should be a @string.
--- @r @table spawn zone collection
function battle_manager:get_spawn_zone_collection_by_name(...)

	-- check args are all strings
	for i = 1, arg.n do
		if not is_string(arg[i]) then
			script_error("ERROR: get_spawn_zone_collection_by_name() called but name [" .. i .. "] in supplied list (value: " .. tostring(arg[i]) .. ") is not a string");
			return false;
		end;
	end;

	-- build the internal spawn zone list (if it's not already built)
	self:construct_spawn_zone_list();

	local collection = {};

	local spawn_zone_list = self.spawn_zone_list;

	for i = 1, #spawn_zone_list do
		local current_spawn_zone_script_id = spawn_zone_list[i].spawn_zone:reinforcement_line():script_id();
		
		for j = 1, arg.n do
			if string.find(current_spawn_zone_script_id, arg[j]) then
				table.insert(collection, spawn_zone_list[i]);
				break;
			end;
		end;
	end;

	return collection;
end;


--- @function get_random_spawn_zone_from_collection
--- @desc Returns a random spawn zone from the supplied spawn zone collection, preferentially choosing a spawn zone that hasn't been used as much as the others.
--- @p @table collection
--- @r @battle_spawn_zone spawn zone
function battle_manager:get_random_spawn_zone_from_collection(collection)

	if not is_table(collection) then
		script_error("ERROR: get_random_spawn_zone_from_collection() called but supplied collection [" .. tostring(collection) .. "] is not a table");
		return false;
	end;

	if #collection == 0 then
		script_error("ERROR: get_random_spawn_zone_from_collection() called but supplied collection [" .. tostring(collection) .. "] is empty");
		return false;
	end

	-- Work out what the greatest number of times any spawn zone from the collection has been used
	local highest_count = 0;
	for i = 1, #collection do
		local current_count = collection[i].count;

		if not is_number(current_count) then
			script_error("ERROR: get_random_spawn_zone_from_collection() called but element [" .. i .. "] in supplied collection [" .. tostring(collection) .. "] has no score registered - collection is not valid");
			return false;
		end;

		if current_count > highest_count then
			highest_count = current_count;
		end;
	end;

	local collection_points_tally = {};
	local total_points = 0;

	for i = 1, #collection do
		-- Make an entry in the points tally table for each entry in the collection, with the points inversely proportional to the 
		-- number of times that spawn zone has been used (numbers will go negative, math.abs will each number positive again)
		collection_points_tally[i] = math.abs(collection[i].count - highest_count) + 1;
		total_points = total_points + collection_points_tally[i];
	end;

	-- Get a random number between 1 and the total number of points
	local random_count = bm:random_number(total_points);

	-- Walk through the points tally table 'spending' points until there are none left, then choose what spawn zone we've landed on
	for i = 1, #collection_points_tally do
		random_count = random_count - collection_points_tally[i];
		if random_count < 1 then
			collection[i].count = collection[i].count + 1;			
			return collection[i].spawn_zone;
		end;
	end;

	-- should never get here
	return collection[1].spawn_zone;
end;


--- @function assign_army_to_spawn_zone_from_collection
--- @desc Assigns a supplied @battle_army to a spawn zone from a collection. The spawn zone will be selected by @battle_manager:get_random_spawn_zone_from_collection.
--- @p @battle_army army, Army to assign.
--- @p @table collection, Spawn zone collection.
--- @p [opt=nil] @string name, Optional army name for output. If supplied, some output is generated featuring this name should the assignment be successful.
function battle_manager:assign_army_to_spawn_zone_from_collection(army, collection, output_name)
	if not is_army(army) then
		script_error("ERROR: assign_army_to_spawn_zone_from_collection() called but supplied army [" .. tostring(army) .. "] is not a valid army object");
		return false;
	end;

	if not is_table(collection) then
		script_error("ERROR: assign_army_to_spawn_zone_from_collection() called but supplied spawn zone collection [" .. tostring(collection) .. "] is not a table");
		return false;
	end;

	local spawn_zone = self:get_random_spawn_zone_from_collection(collection);

	if not spawn_zone then
		script_error("ERROR: assign_army_to_spawn_zone_from_collection() failed to get a random spawn zone from the supplied collection [" .. tostring(collection) .. "]");
		return false;
	end;

	local ra = bm:reinforcements():reinforcement_army_for_army(army);
	if ra then
		ra:assign_spawn_zone(spawn_zone);
		if not is_string(output_name) then
			output_name = "<no name>";
		end;
		self:out("Assigned army with name [" .. output_name .. "] to spawn zone with script id [" .. spawn_zone:reinforcement_line():script_id() .. "] which is at position " .. v_to_s(spawn_zone:position()));
	else
		script_error("WARNING: assign_army_to_spawn_zone_from_collection() called but could not find a reinforcement army for supplied army [" .. tostring(army) .. "] - spawn zone will not be assigned");	
	end;
end;











----------------------------------------------------------------------------
--- @section Capture Locations
----------------------------------------------------------------------------


--- @function print_capture_locations
--- @desc Generates debugging output that lists all capture locations on the battlefield.
function battle_manager:print_capture_locations()
	bm:out("");
	
	local capture_location_manager = bm:capture_location_manager();
	local capture_location_count = capture_location_manager:count();

	if capture_location_count == 0 then
		bm:out(" * A request was made to list all capture locations but there are none on the battlefield");
		bm:out("");
		return 
	end;

	bm:out("Listing " .. capture_location_count .. " capture location" .. (capture_location_count == 1 and "" or "s"));

	for i = 1, capture_location_count do
		local cl = capture_location_manager:item(i);
		bm:out("\tCapture Location " .. i .. ": unique id [" .. cl:unique_id() .. "], script id [" .. cl:script_id() .. "], type [" .. cl:type() .."], position " .. v_to_s(cl:position()) .. (cl:contributes_to_victory() and ". This location contributes to battle victory" or "."));
	end;

	bm:out("");
end;


--- @function get_victory_locations
--- @desc Gets a table containing a @battle_capture_location for each capture location that contributes to battle victory. The table is cached internally the first time this function is called.
--- @r @table victory locations
function battle_manager:get_victory_locations()
	if self.victory_locations then
		return self.victory_locations;
	end;

	local victory_locations = {};
	local capture_location_manager = self:capture_location_manager();
	for i = 1, capture_location_manager:count() do
		local cl = capture_location_manager:item(i);
		if cl:contributes_to_victory() then
			table.insert(victory_locations, cl);
		end;
	end;
	self.victory_locations = victory_locations;
	return victory_locations;
end;










-----------------------------------------------------------------------------
--- @section Toggle Slots
-----------------------------------------------------------------------------


--- @function print_toggle_slots
--- @desc Prints a list of all toggle slots on the battle map to the console.
function battle_manager:print_toggle_slots()
	local toggle_system = self.battle:toggle_system();

	self:out("Listing toggle slots:");

	for i = 1, toggle_system:toggle_slot_count() do
		local current_toggle_slot = toggle_system:toggle_slot(i);

		self:out("toggle slot [" .. i .. "] with uuid [" .. current_toggle_slot:unique_ui_id() .. "] and script id [" .. current_toggle_slot:script_id() .. "] is of type [" .. current_toggle_slot:slot_type() .. "]");

		if current_toggle_slot:is_held_by_alliance() then
			self:out("\tis held by alliance " .. tostring(current_toggle_slot:holding_alliance()));
		end;

		if current_toggle_slot:has_map_barrier() then
			local current_map_barrier = current_toggle_slot:map_barrier();
			self:out("\thas map barrier at position [" .. v_to_s(current_map_barrier:position()) .. "] that's " .. (current_map_barrier:enabled() and "enabled" or "disabled"));
		end;
	end;

	self:out("");
end;


--- @function get_toggle_slot_by_script_id
--- @desc Returns the first toggle slot found with the supplied script id. If no matching toggle slot is found then <code>nil</code> is returned.
--- @p @string script id
--- @r @battle_toggle_slot toggle slot
function battle_manager:get_toggle_slot_by_script_id(script_id)
	if not is_string(script_id) then
		script_error("ERROR: get_toggle_slot_by_script_id() called but supplied script id [" .. tostring(script_id) .. "] is not a string");
		return false;
	end;

	local toggle_system = self.battle:toggle_system();

	for i = 1, toggle_system:toggle_slot_count() do
		if toggle_system:toggle_slot(i):script_id() == script_id then
			return toggle_system:toggle_slot(i);
		end;
	end;
end;












-----------------------------------------------------------------------------
--- @section Campaign Value Remapping
--- @desc This subsystem allows values to be remapped for a particular campaign. This can be useful to specify a replacement set of advice keys for a particular campaign, for example, but could be used for other sets of data.
--- @desc Values are remapped initially by calling @battle_manager:remap_value_for_campaign, and then subsequently accessed with @battle_manager:get_value_for_campaign.
--- @new_example Remapping advice keys for a prologue campaign
--- @example bm:remap_value_for_campaign("wh3_main_prologue", "deployment_advice_1", "prologue_advice_01")
--- @example bm:remap_value_for_campaign("wh3_main_prologue", "deployment_advice_3", "prologue_advice_12")
--- @example bm:remap_value_for_campaign("wh3_main_prologue", "deployment_advice_5", "prologue_advice_26")
--- @example 
--- @example -- later
--- @example local advice_to_use_1 = bm:get_value_for_campaign("wh3_main_prologue", "deployment_advice_1")	-- maps to prologue_advice_01
--- @example local advice_to_use_2 = bm:get_value_for_campaign("wh3_main_prologue", "deployment_advice_2")	-- maps to deployment_advice_2 as no remap set
--- @example local advice_to_use_3 = bm:get_value_for_campaign("wh3_main_prologue", "deployment_advice_3")	-- maps to prologue_advice_12
---
-----------------------------------------------------------------------------


--- @function remap_value_for_campaign
--- @desc Stores a mapping for the specified campaign, that the supplied value should remap to the supplied replacement value. This can be subsequently looked up with @battle_manager:get_value_for_campaign.
--- @p @string campaign key, Campaign key.
--- @p value value, Value to remap. This can be any value other than @nil or <code>false</code>.
--- @p [opt=nil] value replacement value, Replacement value. This can be any value.
--- @p [opt=false] @boolean allow overwriting, Allow a previously-mapped value to be overwritten.
function battle_manager:remap_value_for_campaign(campaign_key, value, replacement_value, allow_overwriting)
	if not validate.is_string(campaign_key) then
		return false;
	end;

	if not value then
		script_error("ERROR: remap_value_for_campaign() called but supplied value [" .. tostring(value) .. "] is not valid");
		return false;
	end;

	local value_to_campaign_map = self.value_to_campaign_map;

	if not value_to_campaign_map[campaign_key] then
		value_to_campaign_map[campaign_key] = {};
	end;

	if not allow_overwriting and value_to_campaign_map[campaign_key][value] then
		script_error("WARNING: remap_value_for_campaign() called but supplied value [" .. tostring(value) .. "] is already mapped for campaign key [" .. campaign_key .. "] and the allow_overwriting flag is not set - its current replacement value of [" .. tostring(replacement_value) .. "] will not be overwritten");
		return false;
	end;

	value_to_campaign_map[campaign_key][value] = replacement_value;
end;


--- @function get_value_for_campaign
--- @desc Retrieves a value remapping for the specified campaign. If the value has been remapped for the particular campaign then the replacement value is returned. If the value has not been remapped then the value itself is returned, un-remapped, or @nil is returned if the return-unmapped-value parameter is set to <code>false</code>.
--- @p @string campaign key, Campaign key.
--- @p value value, value to remap. This can be any value other than @nil or <code>false</code>.
--- @p [opt=true] @boolean return unmapped value, Sets whether the function call should return the value as it was supplied if it was not remapped or not. If this is set to <code>false</code> and the value has not been remapped, then @nil is returned.
--- @r value remapped value
function battle_manager:get_value_for_campaign(campaign_key, value, return_unmapped_value)
	if not validate.is_string(campaign_key) then
		return false;
	end;

	if not value then
		script_error("ERROR: get_value_for_campaign() called but supplied value [" .. tostring(value) .. "] is not valid");
		return false;
	end;

	local value_to_campaign_map = self.value_to_campaign_map;

	if value_to_campaign_map[campaign_key] and value_to_campaign_map[campaign_key][value] then
		return value_to_campaign_map[campaign_key][value];
	end;

	if return_unmapped_value ~= false then
		return value;
	end;
end;


--- @function get_value_for_current_campaign
--- @desc Retrieves a value remapping for the current campaign. If the value has been remapped for this campaign then the replacement value is returned. If the value has not been remapped then the value itself is returned, un-remapped, or @nil is returned if the return-unmapped-value parameter is set to <code>false</code>.
--- @p value value, value to remap. This can be any value other than @nil or <code>false</code>.
--- @p [opt=true] @boolean return unmapped value, Sets whether the function call should return the value as it was supplied if it was not remapped or not. If this is set to <code>false</code> and the value has not been remapped, then @nil is returned.
--- @r value remapped value
function battle_manager:get_value_for_current_campaign(value, return_unmapped_value)
	return self:get_value_for_campaign(self:get_campaign_key(), value, return_unmapped_value)
end;