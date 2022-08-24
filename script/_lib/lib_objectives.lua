


----------------------------------------------------------------------------
--
--	OBJECTIVES MANAGER
--
--- @set_environment battle
--- @set_environment campaign
--- @c objectives_manager Objectives Manager
--- @desc Provides an interface for setting and managing the scripted objectives that appear in the scripted objectives panel, underneath the advisor in campaign and battle. With no advisor present, the scripted objectives panel appears in the top-left of the screen (it is displaced down the screen should the advisor appear). Scripted objectives are mainly used by tutorial scripts, but are also used in quest battles to deliver gameplay objectives.
--- @desc Once a scripted objective is set, with @objectives_manager:set_objective, it is down to the script to mark it as complete with @objectives_manager:complete_objective or failed with @objectives_manager:fail_objective, and to subsequently remove it from the scripted objectives panel with @objectives_manager:remove_objective.
--- @desc The objectives manager also provides an interface for setting up an objectives chain, which allows only one objective from the chain to be shown at a time. This is useful for tutorial scripts which are providing close instruction to the player, allowing them to set up a cooking-recipe series of mini-steps (e.g. "Select your army" / "Open the Recruitment panel" / "Recruit a Unit") which are chained together and can be advanced/rewound.
--- @desc Note that the @battle_manager and @campaign_manager both create an objectives manager, and provide passthrough interfaces for its most common functionality, so it should be rare for a battle or campaign script to need to get a handle to an objectives manager, or call functions on it directly.
----------------------------------------------------------------------------


objectives_manager = {
	uic_objectives = nil,
	objectives_list = {},
	objective_chain_active = "",
	previous_objective_chains = {},
	objective_chain_cached_objective = false,
	objective_chain_cached_objective_chain_name = false,
	objective_chain_cached_opt_a = false,
	objective_chain_cached_opt_b = false,
	is_debug = false,
	set_panel_top_centre_on_creation = false,
	set_panel_bottom_centre_on_creation = false
};


set_class_custom_type_and_tostring(objectives_manager, TYPE_OBJECTIVES_MANAGER);

local TOPIC_LEADER_HOLD_DURATION_FOR_OBJECTIVES = 2000;


----------------------------------------------------------------------------
---	@section Creation
----------------------------------------------------------------------------

__objectives_manager = nil;

--- @function new
--- @desc Creates an objective manager. It should never be necessary for client scripts to call this directly, for an objective manager is automatically set up whenever a @battle_manager or @campaign_manager is created.
function objectives_manager:new()
	if __objectives_manager then
		return __objectives_manager;
	end;

	local o = {};
	
	set_object_class(o, self);
	
	o.objectives_list = {};
	o.previous_objective_chains = {};
	
	__objectives_manager = o;

	return o;
end;


--- @end_class
--- @section Objectives Manager

--- @function get_objectives_manager
--- @desc Gets an objectives manager, or creates one if one doesn't already exist.
--- @r objectives_manager
function get_objectives_manager()
	return objectives_manager:new();
end;


--- @c objectives_manager Objectives Manager











----------------------------------------------------------------------------
---	@section Usage
----------------------------------------------------------------------------
--- @desc Once an <code>objectives_manager</code> object has been created with @objectives_manager:new, functions on it may be called in the form showed below.
--- @new_example Specification
--- @example <i>&lt;objectives_manager_object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example local om = objectives_manager:new()					-- set up automatically by campaign or battle managers
--- @example local uic_objectives = om:get_uicomponent()			-- calling a function on the object once created










--- @section Debug

--- @function set_debug
--- @desc Sets the objectives manager into debug mode for more verbose output
--- @p [opt=true] boolean debug mode
function objectives_manager:set_debug(value)
	if value == false then
		self.is_debug = false;
	else
		self.is_debug = true;
	end;
end;


----------------------------------------------------------------------------
--	output
----------------------------------------------------------------------------

--	prints output if the objectives manager is in debug mode
function objectives_manager:objective_out(str)
	if self.is_debug then
		out(str);
	end;
end;




----------------------------------------------------------------------------
--	Objectives Panel Creation
----------------------------------------------------------------------------

--	creates the objective panel ui component.  To be called only when needed - do not call on
--	campaign startup, as the advisor panel ui component needs to be created first. For internal use.
function objectives_manager:create_objectives_panel()
	if self.uic_objectives then
		return;
	end;

	-- not really what clears the docking point of the under advisor docker, but something is, so this resets it
	local uic_under_advisor_docker = find_uicomponent("under_advisor_docker");
	if uic_under_advisor_docker then
		uic_under_advisor_docker:SetDockingPoint(1);
	end;
	
	self.uic_objectives = find_uicomponent(core:get_ui_root(), "scripted_objectives_panel");

	if not self.uic_objectives then
		script_error("ERROR: create_objectives_panel() just failed to create the objectives panel - the uicomponent \"scripted_objectives_panel\" was not created. Scripted objectives will not work - please investigate. A list of all uicomponents will be dumped to the Lua - UI tab");
		print_all_uicomponent_children();
	end;
end;





----------------------------------------------------------------------------
--- @section UI Component
----------------------------------------------------------------------------


--- @function get_uicomponent
--- @desc Gets a uicomponent handle to the scripted objectives panel
--- @r uicomponent
function objectives_manager:get_uicomponent()
	self:create_objectives_panel();
	
	return self.uic_objectives;
end;





----------------------------------------------------------------------------
-- UI Component Manipulation
-- These functions can be used to show the scripted objectives panel in the top centre/bottom centre of the screen
----------------------------------------------------------------------------

function objectives_manager:undock_panel()
	self:create_objectives_panel();
	self.uic_objectives:SetDockingPoint(0, 0);
end;


function objectives_manager:move_panel(x, y)
	self:create_objectives_panel();
	self.uic_objectives:MoveTo(x, y);
end;


function objectives_manager:move_panel_top_centre()
	local screen_x, screen_y = core:get_screen_resolution();
	
	local uic_objectives = self.uic_objectives;
	
	if not uic_objectives then
		self.set_panel_top_centre_on_creation = true;
		return;
	end;
	
	local panel_x, panel_y = uic_objectives:Dimensions();
	
	self:undock_panel();
	
	local panel_pos_x = (screen_x - panel_x) / 2;
	local panel_pos_y = 20;	-- offset from top of screen
	
	self:objective_out("Moving objectives panel to [" .. panel_pos_x .. ", " .. panel_pos_y .. "], screen resolution is [" .. screen_x .. ", " .. screen_y .. "] and panel size is [" .. panel_x .. ", " .. panel_y .. "]");
	
	uic_objectives:MoveTo(panel_pos_x, panel_pos_y);
end;


function objectives_manager:move_panel_bottom_centre()
	local screen_x, screen_y = core:get_screen_resolution();
	
	local uic_objectives = self.uic_objectives;
	
	if not uic_objectives then
		self.set_panel_bottom_centre_on_creation = true;
		return;
	end;
	
	if __game_mode == __lib_type_battle then		
		local panel_x, panel_y = uic_objectives:Dimensions();
		
		self:undock_panel();
		
		local panel_pos_x = (screen_x - panel_x) / 2;
		local panel_pos_y = screen_y - 70;
		
		self:objective_out("Moving objectives panel to [" .. panel_pos_x .. ", " .. panel_pos_y .. "], screen resolution is [" .. screen_x .. ", " .. screen_y .. "] and panel size is [" .. panel_x .. ", " .. panel_y .. "]");
		
		uic_objectives:MoveTo(panel_pos_x, panel_pos_y);
		
		-- attach to battle_orders component
		--[[
		local uic_battle_orders = find_uicomponent(core:get_ui_root(), "battle_orders");
		
		if not uic_battle_orders then
			script_error("ERROR: move_panel_bottom_centre() could not find battle_orders uicomponent");
			return false;
		end;
		
		uic_battle_orders:Adopt(uic_objectives:Address());
		
		local battle_orders_width, battle_orders_height = uic_battle_orders:Dimensions();
		local objectives_width, objectives_height = uic_objectives:Dimensions();
		
		self.uic_objectives:SetDockingPoint((battle_orders_width - objectives_width) / 2, battle_orders_height + objectives_height + 20);
		
		-- self:objective_out("Docking objectives panel with battle_orders");	


		local show_obj_panel_func = function()
			local uic_obj = bm:ui_component("scripted_objectives_panel");
			if uic_obj then
				uic_obj:SetVisible(true);
				output_uicomponent(uic_obj);
			else
				script_error("Couldn't find scripted_objectives_panel panel");
			end;
		end;
		
		show_obj_panel_func();
		bm:repeat_callback(function() show_obj_panel_func() end, 1000);
		]]
	end;
end;



function objectives_manager:update_position_on_first_use()
	if self.panel_position_updated_on_first_use then
		return false;
	end;

	self.panel_position_updated_on_first_use = true;
	
	if self.set_panel_top_centre_on_creation then
		self:move_panel_top_centre();
	elseif self.set_panel_bottom_centre_on_creation then
		self:move_panel_bottom_centre();
	end;
end;









----------------------------------------------------------------------------
-- Internal functions to perform objective actions with topic leaders
-- Used by set_objective_with_leader() and activate_objective_chain_with_leader(),
-- but more functions may be tied in to it in future
----------------------------------------------------------------------------


local function perform_objective_action_with_leader(om, topic_leader_name, topic_leader_title, objective_key, function_name, objective_action_callback, on_show_callback)
	local uic_objectives = om:get_uicomponent();

	if uic_objectives then
		local tl = topic_leader:new(
			topic_leader_name,
			topic_leader_title,
			"objective"
		);

		tl:add_content("scripted_objectives_localised_text_" .. objective_key);

		tl:set_hold_duration(TOPIC_LEADER_HOLD_DURATION_FOR_OBJECTIVES);

		tl:add_shrink_callback(
			function()
				local x, y;

				-- Try and find the uicomponent for the objective record
				local uic_objective_record = find_uicomponent(uic_objectives, objective_key);
				if uic_objective_record then
					x, y = uic_objective_record:Position();
				else
					x, y = uic_objectives:Position();
					y = y + uic_objectives:Height();
				end;

				tl:set_shrink_target(x + 15, y + 15);
				
			end
		);

		tl:start();

		core:get_tm():real_callback(
			function() 
				objective_action_callback();
				if on_show_callback then
					on_show_callback();
				end;
			end, 
			TOPIC_LEADER_HOLD_DURATION_FOR_OBJECTIVES - 500
		);
	else
		script_error("WARNING: " .. function_name .. "() called but uic_objectives could not be found? How can this be?");
		objective_action_callback();
	end;
end;


local function perform_new_objective_action_with_leader(om, function_name, objective_key, objective_action_callback, on_show_callback)
	return perform_objective_action_with_leader(om, "new_objective", "random_localisation_strings_string_wh3_prologue_new_objective", objective_key, function_name, objective_action_callback, on_show_callback);
end;






----------------------------------------------------------------------------
--- @section Objectives
----------------------------------------------------------------------------


--- @function set_objective
--- @desc Sets up a scripted objective for the player, which appears in the scripted objectives panel. This objective can then be updated, removed, or marked as completed or failed by the script at a later time.
--- @desc A key to the <code>scripted_objectives</code> table must be supplied with set_objective, and optionally one or two numeric parameters to show some running count related to the objective. To update these parameter values later, <code>set_objective</code> may be re-called with the same objective key and updated values.
--- @p @string objective key, Objective key, from the <code>scripted_objectives</code> table.
--- @p [opt=nil] @number param a, First numeric objective parameter. If set, the objective will be presented to the player in the form [objective text]: [param a]. Useful for showing a running count of something related to the objective.
--- @p [opt=nil] @number param b, Second numeric objective parameter. A value for the first must be set if this is used. If set, the objective will be presented to the player in the form [objective text]: [param a] / [param b]. Useful for showing a running count of something related to the objective.
function objectives_manager:set_objective(new_obj_name, obj_param_a, obj_param_b)
	if not is_string(new_obj_name) then
		script_error("ERROR: set_objective() called but supplied objective name [" .. tostring(new_obj_name) .. "] is not a string");
		return false;
	end;
	
	self:objective_out("[OBJECTIVES] set_objective() called, key is [" .. new_obj_name .. "], optional params are [" .. tostring(obj_param_a) .. ", " .. tostring(obj_param_b) .. "]");

	self:create_objectives_panel();
	
	if obj_param_b then
		self:objective_out("[OBJECTIVES] performing set_objective action, key is [" .. new_obj_name .. "], params are [" .. tostring(obj_param_a) .. ", " .. tostring(obj_param_b) .. "]");
		self.uic_objectives:InterfaceFunction("set_objective", new_obj_name, obj_param_a, obj_param_b);
	elseif obj_param_a then
		self:objective_out("[OBJECTIVES] performing set_objective action, key is [" .. new_obj_name .. "], param is [" .. tostring(obj_param_a) .. "]");
		self.uic_objectives:InterfaceFunction("set_objective", new_obj_name, obj_param_a);
	else
		self:objective_out("[OBJECTIVES] performing set_objective action, key is [" .. new_obj_name .. "]");
		self.uic_objectives:InterfaceFunction("set_objective", new_obj_name);
	end;
	
	-- if we have objective parameters then dont try and complete, but add this objective to the list if it's not already there
	if obj_param_a then
		for i = 1, #self.objectives_list do
			local current_obj = self.objectives_list[i];
			
			if current_obj.name == new_obj_name then
				return;
			end;
		end;
	else
		-- otherwise look for the objective in our list
		for i = 1, #self.objectives_list do
			local current_obj = self.objectives_list[i];
			
			if current_obj.name == new_obj_name then
				if current_obj.completed then
					self:objective_out("[OBJECTIVES] performing complete_objective action, key is [" .. new_obj_name .. "] - objective was already complete when it was set");
					self.uic_objectives:InterfaceFunction("complete_objective", new_obj_name);
				end;
				return;
			end;
		end;
	end;
	
	self:update_position_on_first_use();
	
	-- we didn't find the objective in our list, so add it
	local new_obj = {name = new_obj_name, completed = false};
	table.insert(self.objectives_list, new_obj);
end;


--- @function set_objective_with_leader
--- @desc Sets up a scripted objective for the player which appears in the scripted objectives panel, with a @topic_leader. This objective can then be updated, removed, or marked as completed or failed by the script at a later time.
--- @desc A key to the <code>scripted_objectives</code> table must be supplied with set_objective, and optionally one or two numeric parameters to show some running count related to the objective. To update these parameter values later, <code>set_objective</code> may be re-called with the same objective key and updated values.
--- @p @string objective key, Objective key, from the <code>scripted_objectives</code> table.
--- @p [opt=nil] @number param a, First numeric objective parameter. If set, the objective will be presented to the player in the form [objective text]: [param a]. Useful for showing a running count of something related to the objective.
--- @p [opt=nil] @number param b, Second numeric objective parameter. A value for the first must be set if this is used. If set, the objective will be presented to the player in the form [objective text]: [param a] / [param b]. Useful for showing a running count of something related to the objective.
--- @p [opt=nil] @function callback, Optional callback to call when the objective is shown.
function objectives_manager:set_objective_with_leader(new_obj_name, obj_param_a, obj_param_b, on_show_callback)
	if not validate.is_string(new_obj_name) then
		return false;
	end;

	if callback and not validate.is_function(callback) then
		return false;
	end;

	perform_new_objective_action_with_leader(
		self,
		"set_objective_with_leader",
		new_obj_name,
		function()
			self:set_objective(new_obj_name, obj_param_a, obj_param_b);
		end,
		on_show_callback
	);
end;


--- @function complete_objective
--- @desc Marks a scripted objective as completed for the player to see. Note that it will remain on the scripted objectives panel until removed with @objectives_manager:remove_objective.
--- @desc Note also that is possible to mark an objective as complete before it has been registered with @objectives_manager:set_objective - in this case, it is marked as complete as soon as @objectives_manager:set_objective is called.
--- @p @string objective key, Objective key, from the scripted_objectives table.
function objectives_manager:complete_objective(obj_name)
	if not is_string(obj_name) then
		script_error("ERROR: complete_objective() called but supplied objective name [" .. tostring(obj_name) .. "] is not a string");
		return false;
	end;

	self:create_objectives_panel();
	
	self:objective_out("[OBJECTIVES] complete_objective() called, key is [" .. obj_name .. "]");

	for i = 1, #self.objectives_list do
		local current_obj = self.objectives_list[i];
		
		if current_obj.name == obj_name then
			self:objective_out("[OBJECTIVES] performing complete_objective action, key is [" .. obj_name .. "] - objective was already complete when it was set");
			self.uic_objectives:InterfaceFunction("complete_objective", obj_name);
			return;
		end;
	end;
	
	-- objective not found in our list, so add it
	self:objective_out("[OBJECTIVES] objective to complete [" .. obj_name .. "] was not found in the objectives list, so adding it for later");
	local new_obj = {name = obj_name, completed = true};
	table.insert(self.objectives_list, new_obj);
end;


--- @function fail_objective
--- @desc Marks a scripted objective as failed for the player to see. Note that it will remain on the scripted objectives panel until removed with @objectives_manager:remove_objective.
--- @p @string objective key, Objective key, from the scripted_objectives table.
function objectives_manager:fail_objective(obj_name)
	if not is_string(obj_name) then
		script_error("ERROR: fail_objective() called but supplied objective name [" .. tostring(obj_name) .. "] is not a string");
		return false;
	end;
	
	self:objective_out("[OBJECTIVES] fail_objective() called, key is [" .. obj_name .. "]");

	self:create_objectives_panel();

	self.uic_objectives:InterfaceFunction("fail_objective", obj_name);
end;


--- @function remove_objective
--- @desc Removes a scripted objective from the scripted objectives panel.
--- @p @string objective key, Objective key, from the scripted_objectives table.
function objectives_manager:remove_objective(obj_name)
	if not is_string(obj_name) then
		script_error("ERROR: remove_objective() called but supplied objective name [" .. tostring(obj_name) .. "] is not a string");
		return false;
	end;

	self:create_objectives_panel();
	
	self:objective_out("[OBJECTIVES] remove_objective() called, key is [" .. obj_name .. "]");
		
	-- remove from the objectives list, if it's there
	for i = 1, #self.objectives_list do
		local current_obj = self.objectives_list[i];
	
		if current_obj.name == obj_name then
			self:objective_out("[OBJECTIVES] performing remove_objective action, key is [" .. obj_name .. "]");
			self.uic_objectives:InterfaceFunction("remove_objective", obj_name);
			table.remove(self.objectives_list, i);
			return;
		end;
	end;
end;









----------------------------------------------------------------------------
--	Remove All Objectives
--	Removes all currently-active objectives. Allows specification of a
--	single exception, so that one objective stays active (this is used by
--	the objective chain system).
----------------------------------------------------------------------------

function objectives_manager:remove_all_objectives(exception)
	if exception then
		self:objective_out("[OBJECTIVES] remove_all_objectives() called with exception [" .. tostring(exception) .. "] specified");
	else
		self:objective_out("[OBJECTIVES] end_objective_chain() called, no exception specified");
	end;
	
	self:create_objectives_panel();

	local new_objectives_list = {};
	
	for i = 1, #self.objectives_list do
		local current_obj = self.objectives_list[i];
		local name = current_obj.name;
		
		if name ~= exception then
			self:objective_out("[OBJECTIVES] performing remove_objective action, key is [" .. name .. "]");
			self.uic_objectives:InterfaceFunction("remove_objective", name);
		else
			table.insert(new_objectives_list, current_obj);
		end;
	end;
	
	self.objectives_list = new_objectives_list;
end;











----------------------------------------------------------------------------
--- @section Objective Chains
--- @desc Objectives chains allow calling scripts to set up a sequence of objectives that are conceptually linked in such a manner that they are sequentially delivered to the player. This is useful for tutorial scripts which may wish to deliver close support to the player while they are performing a task for the first time e.g. "Open this panel" then "click on that button" then "select that option" and so on. Client scripts can update the status of an objective chain by name, and the objectives manager automatically removes or updates the onscreen objective.
--- @desc An objective chain may be started with @objectives_manager:activate_objective_chain, updated with @objectives_manager:update_objective_chain and finally terminated with @objectives_manager:end_objective_chain. Only one objective chain may be active at once, so terminate an existing chain before starting a new one.
----------------------------------------------------------------------------


--- @function activate_objective_chain
--- @desc Starts a new objective chain. Each objective chain must be given a unique string name, by which the objectives chain is later updated or ended.
--- @p string chain name, Name for the objective chain. Must not be shared with other objective chain names.
--- @p string objective key, Objective key, from the scripted_objectives table.
--- @p [opt=nil] number number param a, First numeric objective parameter. See documentation for @objectives_manager:set_objective.
--- @p [opt=nil] number number param b, Second numeric objective parameter. See documentation for @objectives_manager:set_objective.
function objectives_manager:activate_objective_chain(name, objective, opt_a, opt_b)
	if not is_string(name) then
		script_error("ERROR: activate_objective_chain() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_string(objective) then
		script_error("ERROR: activate_objective_chain() called but supplied objective [" .. tostring(objective) .. "] is not a string");
		return false;
	end;

	-- if this objective chain is in the previous objective chain list then don't start it, as it's already finished
	if self.previous_objective_chains[name] then
		self:objective_out("[OBJECTIVE CHAIN] activate_objective_chain() called with name [" .. name .. "] and objective [" .. objective .. "] but it's already been completed, discarding");
		return;
	end;
	
	self:objective_out("[OBJECTIVE CHAIN] activate_objective_chain() called with name [" .. name .. "] and objective [" .. objective .. "], setting it to be the active chain and updating");
	
	self.objective_chain_active = name;
	self:update_objective_chain(name, objective, opt_a, opt_b);
end;


--- @function activate_objective_chain_with_leader
--- @desc Starts a new objective chain, with a topic leader. Each objective chain must be given a unique string name, by which the objectives chain is later updated or ended.
--- @p string chain name, Name for the objective chain. Must not be shared with other objective chain names.
--- @p string objective key, Objective key, from the scripted_objectives table.
--- @p [opt=nil] number number param a, First numeric objective parameter. See documentation for @objectives_manager:set_objective.
--- @p [opt=nil] number number param b, Second numeric objective parameter. See documentation for @objectives_manager:set_objective.
--- @p [opt=nil] @function on-show callback, Optional callback to call when the objective is shown.
function objectives_manager:activate_objective_chain_with_leader(name, objective, opt_a, opt_b, on_show_callback)
	if not validate.is_string(name) or not validate.is_string(objective) then
		return false;
	end;

	perform_new_objective_action_with_leader(
		self, 
		"activate_objective_chain_with_leader",
		objective,
		function()
			self:activate_objective_chain(name, objective, opt_a, opt_b);
		end,
		on_show_callback
	);
end;


--- @function update_objective_chain
--- @desc Updates an objective chain, either with new parameters for the existing objective or a new objective (in which case the existing objective will be removed).
--- @p string chain name, Name for the objective chain.
--- @p string objective key, Objective key, from the scripted_objectives table.
--- @p [opt=nil] number number param a, First numeric objective parameter. See documentation for @objectives_manager:set_objective.
--- @p [opt=nil] number number param b, Second numeric objective parameter. See documentation for @objectives_manager:set_objective.
function objectives_manager:update_objective_chain(name, objective, opt_a, opt_b)
	if not is_string(name) then
		script_error("ERROR: update_objective_chain() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_string(objective) then
		script_error("ERROR: update_objective_chain() called but supplied objective [" .. tostring(objective) .. "] is not a string");
		return false;
	end;
	
	-- if this objective chain is not active stash the given objective chain for later
	if self.objective_chain_active ~= name then
		self:objective_out("[OBJECTIVE CHAIN] update_objective_chain() called with name [" .. name .. "] and objective [" .. objective .. "] but this is not the active chain, caching it instead");
		
		self.objective_chain_cached_objective = objective;
		self.objective_chain_cached_objective_chain_name = name;
		self.objective_chain_cached_opt_a = opt_a;
		self.objective_chain_cached_opt_b = opt_b;
		return;
	end;
		
	-- if we have a current objective, use that instead of the one supplied
	if self.objective_chain_cached_objective and self.objective_chain_cached_objective_chain_name == name then
		self:objective_out("[OBJECTIVE CHAIN] update_objective_chain() called with name [" .. name .. "] and objective [" .. objective .. "] but there is a cached objective [" .. self.objective_chain_cached_objective .. "], using that instead");
		objective = self.objective_chain_cached_objective;
		opt_a = self.objective_chain_cached_opt_a;
		opt_b = self.objective_chain_cached_opt_b;
	else
		self:objective_out("[OBJECTIVE CHAIN] update_objective_chain() called with name [" .. name .. "] and objective [" .. objective .. "]");
	end;
	
	self:remove_all_objectives(objective);		-- remove all objectives bar the current objectives
	
	self:set_objective(objective, opt_a, opt_b);
	
	self.objective_chain_cached_objective = false;
	self.objective_chain_cached_objective_chain_name = false;
	self.objective_chain_cached_opt_a = false;
	self.objective_chain_cached_opt_b = false;
end;


--- @function end_objective_chain
--- @desc Ends an objective chain. 
--- @p string chain name, Name for the objective chain.
--- @p string objective key, Objective key, from the scripted_objectives table.
--- @p [opt=nil] number number param a, First numeric objective parameter. See documentation for @objectives_manager:set_objective.
--- @p [opt=nil] number number param b, Second numeric objective parameter. See documentation for @objectives_manager:set_objective.
function objectives_manager:end_objective_chain(name)
	if not is_string(name) then
		script_error("ERROR: end_objective_chain() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	-- only proceed if the supplied objective chain is active
	if self.objective_chain_active == name then
		self:objective_out("[OBJECTIVE CHAIN] end_objective_chain() called with name [" .. name .. "]");
		self:remove_all_objectives();
		self.objective_chain_active = "";
	else
		self:objective_out("[OBJECTIVE CHAIN] end_objective_chain() called with name [" .. name .. "] - this objective chain is not active - marking it as previous so that it cannot start without being reset");
	end;
	
	self.previous_objective_chains[name] = true;
end;


--- @function reset_objective_chain
--- @desc Removes this objective chain from the previous objective chains list, which allows it to be triggered again.
--- @p string chain name
function objectives_manager:reset_objective_chain(name)
	if not is_string(name) then
		script_error("ERROR: reset_objective_chain() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	-- remove this objective chain from the previous objective list
	self.previous_objective_chains[name] = nil;
end;










