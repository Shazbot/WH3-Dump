


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	TUTORIAL HELPER SCRIPTS
--
---	@set_environment campaign
--- @c intro_campaign_scripts Tutorial Helper Scripts
--- @desc The objects described in this file can be used by campaign tutorial scripts to deliver certain discrete chunks of tutorial gameplay.
--- @end_class
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	INTRO CAMPAIGN CAMERA MARKER
--
---	@set_environment campaign
--- @c intro_campaign_camera_marker Intro Campaign Camera Marker
--- @page intro_campaign_scripts
--- @desc During campaign tutorial gameplay it is common to have scripted sections where the player has to inspect camera positions in order to progress. Camera markers are placed down in set positions, and when the player moves the camera close to them a cutscene plays which delivers narrative regarding the marker. The intention behind this is that the player learns about camera controls whilst narrative content is delivered to them.
--- @desc An <code>intro_campaign_camera_marker</code> represents an individual camera marker in a scripted section such as this. One or more markers are created and associated with a @intro_campaign_camera_positions_advice object in order to make such a sequence work.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


intro_campaign_camera_marker = {
	name = "",
	marker_x = 0,
	marker_y = 0,
	cutscene_duration = 0,
	cutscene_actions = {},
	wait_for_advisor_list = {},
	trigger_distance_squared = 25,
	is_completed = false,
	marker_is_visible = false,
	skip_x = -1,
	skip_y = -1,
	skip_d = -1,
	skip_b = -1,
	skip_h = -1
};

set_class_custom_type(intro_campaign_camera_marker, TYPE_INTRO_CAMPAIGN_CAMERA_MARKER);
set_class_tostring(
	intro_campaign_camera_marker, 
	function(obj)
		return TYPE_INTRO_CAMPAIGN_CAMERA_MARKER .. "_" .. obj.name
	end
);



----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns an <code>intro_campaign_camera_marker</code> object.
--- @p string name, Unique name camera marker.
--- @p number x, x co-ordinate of marker, using display co-ordinate system.
--- @p number y, y co-ordinate of marker, using display co-ordinate system.
--- @p number duration, duration of cutscene triggered by camera moving close to marker in seconds.
--- @p [opt=nil] number trigger distance, override for the distance at which the camera marker will trigger.
--- @r intro_campaign_camera_marker camera marker
function intro_campaign_camera_marker:new(name, marker_x, marker_y, cutscene_duration, distance_override)
	
	if not is_string(name) then
		script_error("ERROR: attempt was made to create a intro campaign cutscene marker but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_number(marker_x) or marker_x <= 0 then
		script_error("ERROR: attempt was made to create a intro campaign cutscene marker but supplied marker x co-ordinate [" .. tostring(marker_x) .. "] is not a number greater than 0");
		return false;
	end;
	
	if not is_number(marker_y) or marker_y <= 0 then
		script_error("ERROR: attempt was made to create a intro campaign cutscene marker but supplied marker y co-ordinate [" .. tostring(marker_y) .. "] is not a number greater than 0");
		return false;
	end;
	
	if not is_number(cutscene_duration) or marker_y <= 0 then
		script_error("ERROR: attempt was made to create a intro campaign cutscene marker but supplied cutscene duration [" .. tostring(cutscene_duration) .. "] is not a number greater than 0");
		return false;
	end;
	
	if not is_number(cutscene_duration) and not is_nil(distance_override) then
		script_error("ERROR: attempt was made to create a intro campaign cutscene marker but supplied distance override [" .. tostring(distance_override) .. "] is not a number or nil");
		return false;
	end;
	
	local cam_marker = {};
	
	cam_marker.name = name;

	set_object_class(cam_marker, self);
	
	cam_marker.full_name = "intro_campaign_camera_marker_" .. name;
	cam_marker.marker_x = marker_x;
	cam_marker.marker_y = marker_y;
	cam_marker.cutscene_duration = cutscene_duration;
	cam_marker.cutscene_actions = {};
	cam_marker.wait_for_advisor_list = {};
	
	if distance_override then
		cam_marker.trigger_distance_squared = distance_override * distance_override;
	end;
	
	return cam_marker;
end;



----------------------------------------------------------------------------
--- @section Usage
--- @desc Once an <code>intro_campaign_camera_marker</code> object has been created with @intro_campaign_camera_marker:new, functions on it may be called in the form showed below.
--- @new_example Specification
--- @example <i>&lt;object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example local cm_settlement = intro_campaign_camera_marker:new(
--- @example 	"settlement",
--- @example 	124.6,
--- @example 	74.1,
--- @example 	12.0
--- @example )
--- @example cm_settlement:wait_for_advisor(1)		-- calling a function on the object once created
----------------------------------------------------------------------------


----------------------------------------------------------------------------
--- @section methods
----------------------------------------------------------------------------


--- @function set_skip_camera
--- @desc Sets a skip camera position for the camera marker, so that if the related cutscene is skipped then the camera gets repositioned. See @campaign_cutscene:set_skip_camera for more information.
--- @p number x, skip camera x co-ordinate.
--- @p number y, skip camera x co-ordinate.
--- @p number d, skip camera d co-ordinate.
--- @p number b, skip camera b co-ordinate.
--- @p number h, skip camera h co-ordinate.
function intro_campaign_camera_marker:set_skip_camera(skip_x, skip_y, skip_d, skip_b, skip_h)
	if not is_number(skip_x) or skip_x <= 0 then
		script_error(self.full_name .. " ERROR: set_skip_camera() called but supplied x co-ordinate [" .. tostring(skip_x) .. "] is not a number > 0");
		return false;
	end;
	
	if not is_number(skip_y) or skip_y <= 0 then
		script_error(self.full_name .. " ERROR: set_skip_camera() called but supplied y co-ordinate [" .. tostring(skip_y) .. "] is not a number > 0");
		return false;
	end;
	
	if not is_number(skip_d) or skip_d <= 0 then
		script_error(self.full_name .. " ERROR: set_skip_camera() called but supplied d co-ordinate [" .. tostring(skip_d) .. "] is not a number > 0");
		return false;
	end;
	
	if not is_number(skip_b) then
		script_error(self.full_name .. " ERROR: set_skip_camera() called but supplied b co-ordinate [" .. tostring(skip_b) .. "] is not a number");
		return false;
	end;
	
	if not is_number(skip_h) or skip_h <= 0 then
		script_error(self.full_name .. " ERROR: set_skip_camera() called but supplied h co-ordinate [" .. tostring(skip_h) .. "] is not a number > 0");
		return false;
	end;
	
	self.skip_x = skip_x;
	self.skip_y = skip_y;
	self.skip_d = skip_d;
	self.skip_b = skip_b;
	self.skip_h = skip_h;
end;


--- @function action
--- @desc Adds a cutscene action related to this camera marker. After the camera marker is triggered the actions enqueued on the marker with this function are played as a @campaign_cutscene. See @campaign_cutscene:action for more information.
--- @p function callback, Callback to call.
--- @p number delay, Delay in seconds after the start of the cutscene at which to call this action.
function intro_campaign_camera_marker:action(callback, delay)
	if not is_function(callback) then
		script_error(self.full_name .. " ERROR: action() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	if not is_number(delay) or delay < 0 then
		script_error(self.full_name .. " ERROR: action() called but supplied delay [" .. tostring(delay) .. "] is not a positive number");
		return false;
	end;
	
	local new_action = {
		callback = callback,
		delay = delay
	};
	
	table.insert(self.cutscene_actions, new_action);
end;


--- @function wait_for_advisor
--- @desc Adds a @campaign_cutscene:wait_for_advisor to the camera marker. This causes @campaign_cutscene:wait_for_advisor to be called at the specified interval after the marker's cutscene begins playing.
--- @p number delay, Delay in seconds after the start of the cutscene at which to call @campaign_cutscene:wait_for_advisor.
function intro_campaign_camera_marker:wait_for_advisor(delay)
	if not is_number(delay) or delay < 0 then
		script_error(self.full_name .. " ERROR: wait_for_advisor() called but supplied delay [" .. tostring(delay) .. "] is not a positive number");
		return false;
	end;
	
	table.insert(self.wait_for_advisor_list, delay);
end;


















----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	INTRO CAMPAIGN CAMERA POSITIONS ADVICE
--
--- @c intro_campaign_camera_positions_advice Intro Campaign Camera Positions Advice
--- @page intro_campaign_scripts
--- @desc During campaign tutorial gameplay it is common to have scripted sections where the player has to inspect camera positions in order to progress. Camera markers are placed down in set positions, and when the player moves the camera close to them a cutscene plays which delivers narrative regarding the marker. The intention behind this is that the player learns about camera controls whilst narrative content is delivered to them.
--- @desc An <code>intro_campaign_camera_positions_advice</code> facilitates this behaviour. One or more @intro_campaign_camera_marker objects are created and associated with a <code>intro_campaign_camera_positions_advice</code> object in order to make such a sequence work.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


intro_campaign_camera_positions_advice = {
	objective_key = "",
	completion_callback = false,
	markers = {},
	should_skip = false,
	trigger_threshold = 3,
	markers_completed = 0,
	camera_infotext_displayed = false,
	help_panel_camera_info_callback = function() show_campaign_controls_cheat_sheet() end
};


set_class_custom_type_and_tostring(intro_campaign_camera_positions_advice, TYPE_INTRO_CAMPAIGN_CAMERA_POSITIONS_ADVICE);



----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns an <code>intro_campaign_camera_marker</code> object.
--- @p string objective key, Key for a record in the <code>scripted_objectives</code> table which is displayed as objective text. 
--- @p function completion callback, Callback to call when all markers have been viewed.
--- @p table markers, a table containing one or more @intro_campaign_camera_marker objects to be associated with this camera positions advice object.
--- @r intro_campaign_camera_positions_advice camera positions advice
function intro_campaign_camera_positions_advice:new(objective_key, completion_callback, markers)
	
	if not is_string(objective_key) then
		script_error("ERROR: attempt was made to create intro campaign camera positions advice, but supplied objective key [" .. tostring(objective_key) .. "] is not a string");
		return false;
	end;
	
	if not is_function(completion_callback) then
		script_error("ERROR: attempt was made to create intro campaign camera positions advice, but supplied completion callback [" .. tostring(objective_key) .. "] is not a string");
		return false;
	end;
	
	if not is_table(markers) then
		script_error("ERROR: attempt was made to create intro campaign camera positions advice, but supplied marker list [" .. tostring(markers) .. "] is not a table");
		return false;
	end;
	
	for i = 1, #markers do
		if not is_introcampaigncameramarker(markers[i]) then
			script_error("ERROR: attempt was made to create intro campaign camera positions advice, but marker [" .. i .. "] in supplied list is not an intro campaign camera marker but a [" .. tostring(markers[i]) .. "]");
			return false;
		end;
	end;
	
	local pa = {};

	set_object_class(pa, self);
	
	pa.objective_key = objective_key;
	pa.completion_callback = completion_callback;
	pa.markers = {};
	
	local added_marker_names = {};
	
	for i = 1, #markers do
		local current_marker = markers[i];
		
		-- ensure that there are no duplicate names as we add our markers
		if added_marker_names[current_marker.name] then
			script_error("ERROR: attempt was made to create intro campaign camera positions advice, but more than one marker was added with name [" .. current_marker.name .. "]");
			return false;
		end;
		
		added_marker_names[current_marker.name] = true;
		pa.markers[i] = markers[i];
	end;
		
	return pa;
end;


----------------------------------------------------------------------------
--- @section Usage
--- @desc Once an <code>intro_campaign_camera_positions_advice</code> object has been created with @intro_campaign_camera_positions_advice:new, functions on it may be called in the form showed below.
--- @new_example Specification
--- @example <i>&lt;object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example local ca = intro_campaign_camera_positions_advice:new(
--- @example 	-- Move the camera to see what lies ahead
--- @example 	"wh_intro_camp_camera_advice_001",
--- @example 	function() intro_campaign_camera_positions_advice_progress() end,
--- @example 	{camera_marker_player_capital, camera_marker_swamp, camera_marker_enemy_army}
--- @example )
--- @example ca:start(1)		-- calling a function on the object once created
----------------------------------------------------------------------------


----------------------------------------------------------------------------
--- @section Configuration
----------------------------------------------------------------------------


--- @function set_should_skip
--- @desc Sets whether the <code>intro_campaign_camera_positions_advice</code> should complete as soon as it is started. This can be useful to set during development to quickly progress through tutorial gameplay.
--- @p [opt=true] boolean should skip
function intro_campaign_camera_positions_advice:set_should_skip(value)
	if value == false then
		self.should_skip = false;
	else
		self.should_skip = true;
	end;
end;


----------------------------------------------------------------------------
--- @section Starting
----------------------------------------------------------------------------


--- @function start
--- @desc Starts the camera positions advice sequence. This object will have no visible effect until this is called. 
function intro_campaign_camera_positions_advice:start()

	if self.should_skip then
		out("camera positions advice :: skipping");
		cm:callback(function() self:complete() end, 1);
		return;
	end;
	
	-- show objective
	cm:callback(
		function()
			cm:activate_objective_chain("camera_advice", self.objective_key, 0, #self.markers);
			
			-- set the objectives panel to the top-middle of the screen
			-- get_objectives_manager():set_debug();
			-- get_objectives_manager():move_panel_top_centre();
			if self.help_panel_camera_info_callback then
				self.help_panel_camera_info_callback();
			end;
		end,
		5
	);	
	
	cm:callback(function() self:start_position_monitors() end, 3, "camera_positions_advice");
end;


-- start monitoring processes
function intro_campaign_camera_positions_advice:start_position_monitors()

	self:show_markers(true);
	
	self:camera_check();
end;


-- show or hide marker effects for camera positions not yet visited
function intro_campaign_camera_positions_advice:show_markers(should_show)

	local markers = self.markers;
	
	if should_show == false then
		for i = 1, #markers do
			local current_marker = markers[i];
			if current_marker.marker_is_visible then
			
				-- remove marker
				current_marker.marker_is_visible = false;
				cm:remove_marker(current_marker.name);
			end;
		end;
	else
		-- show all markers for positions that have not been visited and are not already marked
		for i = 1, #markers do
			local current_marker = markers[i];
			if not current_marker.is_completed then
				-- draw marker
				cm:add_marker(current_marker.name, "look_at_vfx", current_marker.marker_x, current_marker.marker_y, 0);
				current_marker.marker_is_visible = true;
			end;
		end;		
	end;
end;


-- check the distance of the camera to any markers not yet found
function intro_campaign_camera_positions_advice:camera_check()

	local x, y, d, b, h = cm:get_camera_position();
	
	-- we work out a virtual target for the camera, which is 1/4 the way between the camera target and the point on the terrain below the camera position
	local camera_distance_proportion = 0.25;
	
	local virtual_x = x - camera_distance_proportion * d * math.sin(b);
	local virtual_y = y - camera_distance_proportion * d * math.cos(b);
		
	for i = 1, #self.markers do
		local current_marker = self.markers[i];
		
		if not current_marker.is_completed then
			local distance_to_position_squared = distance_squared(current_marker.marker_x, current_marker.marker_y, virtual_x, virtual_y);
						
			-- check the position of the camera against both the virtual target and also the actual marker position
			if distance_to_position_squared < current_marker.trigger_distance_squared or distance_squared(current_marker.marker_x, current_marker.marker_y, x, y) < current_marker.trigger_distance_squared then
				cm:remove_callback("intro_campaign_camera_positions_advice");
				self:play_cutscene(current_marker);
				return;
			end;
		end;
	end;
	
	-- check again half a second from now
	cm:callback(function() self:camera_check() end, 0.5, "intro_campaign_camera_positions_advice");
end;


-- play a cutscene related to a marker
function intro_campaign_camera_positions_advice:play_cutscene(marker)
	
	self:show_markers(false);
	
	-- declare our cutscene
	local cutscene_marker = campaign_cutscene:new(
		marker.full_name,
		marker.cutscene_duration,
		function() self:marker_cutscene_ends(marker) end
	);
		
	--cutscene_marker:set_debug();
	cutscene_marker:set_skippable(true);
	cutscene_marker:set_skip_camera(marker.skip_x, marker.skip_y, marker.skip_d, marker.skip_b, marker.skip_h);
	cutscene_marker:set_disable_settlement_labels(false);
	cutscene_marker:set_dismiss_advice_on_end(false);
	
	-- pass through our list of actions
	local cutscene_actions = marker.cutscene_actions;
	for i = 1, #cutscene_actions do
		local current_action = cutscene_actions[i];
		cutscene_marker:action(current_action.callback, current_action.delay);
	end;
	
	-- also add any wait_for_advisors
	local wait_for_advisor_list = marker.wait_for_advisor_list;
	for i = 1, #wait_for_advisor_list do
		cutscene_marker:action(function() cutscene_marker:wait_for_advisor() end, wait_for_advisor_list[i]);
	end;
	
	cutscene_marker:start();
end;


-- a cutscene related to a marker has ended
function intro_campaign_camera_positions_advice:marker_cutscene_ends(marker)

	marker.is_completed = true;

	-- update internal counter
	self.markers_completed = self.markers_completed + 1;
	
	-- update objective counter on ui
	cm:update_objective_chain("camera_advice", self.objective_key, self.markers_completed, #self.markers);
		
	if self.markers_completed == #self.markers then
		self:complete();
	else
		self:start_position_monitors();
	end;
end;


-- a cutscene related to a marker has ended and all markers have been visited
function intro_campaign_camera_positions_advice:complete()

	cm:complete_objective(self.objective_key);
	cm:callback(function() cm:end_objective_chain("camera_advice") end, 2);

	-- call completion callback
	cm:callback(function() self:completion_callback() end, 1);
end;


----------------------------------------------------------------------------
--- @section Example
--- @desc The following script gives a simple example of the creation of multiple @intro_campaign_camera_marker objects, linked to a single @intro_campaign_camera_positions_advice object.

--- @example -- get a handle to the enemy settlement and its display position
--- @example local enemy_settlement = cm:get_region(cm:get_faction(ENEMY_FACTION_KEY):home_region():name()):settlement()
--- @example local enemy_settlement_x = enemy_settlement:display_position_x()
--- @example local enemy_settlement_y = enemy_settlement:display_position_y()
--- @example 
--- @example -- create enemy settlement marker
--- @example local marker_enemy_settlement = intro_campaign_camera_marker:new(
--- @example 	"enemy_settlement",
--- @example 	enemy_settlement_x,
--- @example 	enemy_settlement_y, 
--- @example 	12
--- @example )
--- @example 
--- @example -- add actions to enemy settlement marker cutscene
--- @example marker_enemy_settlement:action(
--- @example 	function()
--- @example 		cm:scroll_camera_from_current(false, 6, {enemy_settlement_x, enemy_settlement_y, 14.1, 0, 4.0}) end, 0)
--- @example 	end,
--- @example 	0
--- @example )
--- @example marker_enemy_settlement:action(function() cm:show_advice("intro_enemy_settlement_advice_01") end, 1)
--- @example marker_enemy_settlement:action(function() cm:scroll_camera_from_current(true, 5, {174.3, 51.4, 26.1, 0, 14.0}) end, 7)
--- @example 
--- @example -- get a handle to the player's army and its diplay position
--- @example local players_army = cm:get_character_by_cqi(PLAYER_ARMY_CQI)
--- @example local players_army_x = players_army:display_position_x()
--- @example local players_army_y = players_army:display_position_y()
--- @example 
--- @example -- create player army marker
--- @example local marker_player_army = intro_campaign_camera_marker:new(
--- @example 	"player_army",
--- @example 	players_army_x,
--- @example 	players_army_y, 
--- @example 	10
--- @example )
--- @example 
--- @example -- add actions to playe army marker cutscene
--- @example marker_player_army:action(
--- @example 	function()
--- @example 		cm:scroll_camera_from_current(false, 5, {players_army_x, players_army_y, 14.1, 0, 4.0})
--- @example 	end,
--- @example 	0
--- @example )
--- @example marker_player_army:action(function() cm:show_advice("intro_player_army_advice_01") end, 1)
--- @example marker_player_army:action(function() cm:scroll_camera_from_current(true, 4, {174.3, 51.4, 26.1, 0, 12.0}) end, 6)
--- @example 
--- @example -- create intro_campaign_camera_positions_advice object, associated with markers above
--- @example local ca = intro_campaign_camera_positions_advice:new(
--- @example 	"intro_camera_movement_objective",
--- @example 	function() progress_from_intro_campaign_camera_advice() end,
--- @example 	{marker_enemy_settlement, marker_player_army}				-- table containing all markers
--- @example )
--- @example 
--- @example -- start behaviour
--- @example ca:start()		

----------------------------------------------------------------------------











----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	INTRO CAMPAIGN SELECT AND ATTACK ADVICE
--
--- @c intro_campaign_select_and_attack_advice Intro Campaign Select And Attack Advice
--- @page intro_campaign_scripts
--- @desc During campaign tutorial gameplay it is common to have scripted sections where the player has to select an army and then attack a target in order to progress. An <code>intro_campaign_select_and_attack_advice</code> facilitates this behaviour - locking the UI, showing advice, compelling the player to move their army and controlling the movement of the army as this is done.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


intro_campaign_select_and_attack_advice = {
	player_cqi = -1,
	enemy_cqi = -1,
	initial_pan_duration = 3,
	initial_advice = "",
	initial_infotext_delay = 1,
	initial_infotext = {},
	cam_x = false,
	cam_y = false,
	cam_d = 14.8,
	cam_b = 0,
	cam_h = 12,
	initial_cam_d = 14.8,
	initial_cam_b = 0,
	initial_cam_h = 12,
	selection_objective = "",
	attack_advice = "",
	attack_advice_shown = false,
	attack_infotext_delay = 1,
	attack_infotext = {},
	enemy_marker_altitude = 2,
	player_marker_altitude = 2,
	help_panel_selection_info_callback = function() end,			-- TODO
	help_panel_attack_info_callback = function() end,				-- TODO
	attack_objective = "",
	completion_callback = false,
	listener_name = "select_and_attack_advice"
};


set_class_custom_type_and_tostring(intro_campaign_select_and_attack_advice, TYPE_INTRO_CAMPAIGN_SELECT_AND_ATTACK_ADVICE);


----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns an <code>intro_campaign_select_and_attack_advice</code> object.
--- @p number player cqi, Command queue index of the player's army that they have to attack with.
--- @p number enemy cqi, Command queue index of the target enemy army.
--- @p string initial advice, Initial advice key, from the <code>advice_threads</code> table. This is delivered when the objective is issued to the player, and should set up the task narratively.
--- @p string sleection objective, Initial selection objective key, from the <code>scripted_objectives</code> table. This is delivered when the objective is issued to the player, and should set up the task narratively.
--- @p table markers, a table containing one or more @intro_campaign_camera_marker objects to be associated with this camera positions advice object.
--- @r intro_campaign_camera_positions_advice camera positions advice
function intro_campaign_select_and_attack_advice:new(player_cqi, enemy_cqi, initial_advice, selection_objective, attack_advice, attack_objective, completion_callback)

	if not is_number(player_cqi) then
		script_error("ERROR: attempt made to create intro_campaign_select_and_attack_advice but supplied player cqi [" .. tostring(player_cqi) .. "] is not a number");
		return false;
	end;
	
	if not is_number(enemy_cqi) then
		script_error("ERROR: attempt made to create intro_campaign_select_and_attack_advice but supplied enemy cqi [" .. tostring(enemy_cqi) .. "] is not a number");
		return false;
	end;
	
	if not is_string(initial_advice) then
		script_error("ERROR: attempt made to create intro_campaign_select_and_attack_advice but supplied initial advice key [" .. tostring(initial_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_string(selection_objective) then
		script_error("ERROR: attempt made to create intro_campaign_select_and_attack_advice but supplied selection objective key [" .. tostring(selection_objective) .. "] is not a string");
		return false;
	end;
	
	if not is_string(attack_advice) then
		script_error("ERROR: attempt made to create intro_campaign_select_and_attack_advice but supplied attack advice key [" .. tostring(attack_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_string(attack_objective) then
		script_error("ERROR: attempt made to create intro_campaign_select_and_attack_advice but supplied attack objective key [" .. tostring(attack_objective) .. "] is not a string");
		return false;
	end;
	
	if not is_function(completion_callback) then
		script_error("ERROR: attempt made to create intro_campaign_select_and_attack_advice but supplied completion callback [" .. tostring(completion_callback) .. "] is not a function");
		return false;
	end;
	
	local sa = {};
	
	set_object_class(sa, self);
	
	sa.player_cqi = player_cqi;
	sa.enemy_cqi = enemy_cqi;
	sa.initial_advice = initial_advice;
	sa.selection_objective = selection_objective;
	sa.attack_advice = attack_advice;
	sa.attack_objective = attack_objective;
	sa.completion_callback = completion_callback;

	return sa;
end;


function intro_campaign_select_and_attack_advice:add_initial_infotext(delay, ...)
	if not is_number(delay) then
		script_error("ERROR: add_infotext() called, but supplied delay [" .. tostring(delay) .. "] is not a number");
		return false;
	end;
	
	for i = 1, arg.n do
		local current_infotext = arg[i];
		if not is_string(current_infotext) then
			script_error("ERROR: add_infotext() called but supplied item [" .. i .. "] is not a string, it is a [" .. tostring(current_infotext) .. "]");
			return false;
		else
			table.insert(self.initial_infotext, current_infotext);
		end;
	end;
	
	self.initial_infotext_delay = delay;
end;


function intro_campaign_select_and_attack_advice:add_attack_infotext(delay, ...)
	if not is_number(delay) then
		script_error("ERROR: add_infotext() called, but supplied delay [" .. tostring(delay) .. "] is not a number");
		return false;
	end;
	
	for i = 1, arg.n do
		local current_infotext = arg[i];
		if not is_string(current_infotext) then
			script_error("ERROR: add_infotext() called but supplied item [" .. i .. "] is not a string, it is a [" .. tostring(current_infotext) .. "]");
			return false;
		else
			table.insert(self.attack_infotext, current_infotext);
		end;
	end;
	
	self.attack_infotext_delay = delay;
end;


function intro_campaign_select_and_attack_advice:set_enemy_marker_altitude(value)
	if not is_number(value) or value < 0 then
		script_error("ERROR: set_enemy_marker_altitude() called but supplied altitude [" .. tostring(value) .. "] is not a positive number");
		return false;
	end;
	
	self.enemy_marker_altitude = value;
end;


function intro_campaign_select_and_attack_advice:set_player_marker_altitude(value)
	if not is_number(value) or value < 0 then
		script_error("ERROR: set_player_marker_altitude() called but supplied altitude [" .. tostring(value) .. "] is not a positive number");
		return false;
	end;
	
	self.player_marker_altitude = value;
end;


function intro_campaign_select_and_attack_advice:set_camera_position_override(x, y, d, b, h)
	if x then
		if not is_number(x) then
			script_error("ERROR: set_camera_position_override() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a number");
			return false;
		end;
		
		self.cam_x = x;
	end;
	
	if y then
		if not is_number(y) then
			script_error("ERROR: set_camera_position_override() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a number");
			return false;
		end;
		
		self.cam_y = y;
	end;
	
	if d then
		if not is_number(d) then
			script_error("ERROR: set_camera_position_override() called but supplied d co-ordinate [" .. tostring(d) .. "] is not a number");
			return false;
		end;
		
		self.cam_d = d;
	end;
	
	if b then
		if not is_number(b) then
			script_error("ERROR: set_camera_position_override() called but supplied b co-ordinate [" .. tostring(b) .. "] is not a number");
			return false;
		end;
		
		self.cam_b = b;
	end;
	
	if h then
		if not is_number(h) then
			script_error("ERROR: set_camera_position_override() called but supplied h co-ordinate [" .. tostring(h) .. "] is not a number");
			return false;
		end;
		
		self.cam_h = h;
	end;
end;


function intro_campaign_select_and_attack_advice:start()

	-- move the camera to the player army, unless an override position is set
	local x, y = false;
	
	if self.cam_x and self.cam_y then
		x = self.cam_x;
		y = self.cam_y;
	else
		local char_player = cm:get_character_by_cqi(self.player_cqi);
		if not char_player then
			script_error("ERROR: intro_campaign_select_and_attack_advice could not find a player character with cqi [" .. self.player_cqi .. "]");
			return false;
		end;
		
		x = char_player:display_position_x();
		y = char_player:display_position_y();
	end
		
	-- pan camera to calculated target
	cm:scroll_camera_with_cutscene(
		self.initial_pan_duration, 
		function() self:intro_pan_finished() end,
		{x, y, self.cam_d, self.cam_b, self.cam_h}
	);
	
	-- clear infotext
	cm:clear_infotext();
	
	cm:callback(
		function() 
			cm:show_advice(self.initial_advice);
			
			local activate_objective_func = function()
				cm:activate_objective_chain(self.listener_name, self.selection_objective)
			end;
			
			local initial_infotext = self.initial_infotext;
			
			if #initial_infotext == 0 then
				activate_objective_func();
			else
				table.insert(initial_infotext, function() activate_objective_func() end);
				cm:add_infotext(1, unpack(initial_infotext));
			end;		
		end, 
		1
	);
end;


function intro_campaign_select_and_attack_advice:intro_pan_finished()

	local player_char = cm:get_character_by_cqi(self.player_cqi);
	local player_char_str = cm:char_lookup_str(player_char);
	local listener_name = self.listener_name;
	
	-- allow selection of the player's army
	cm:get_campaign_ui_manager():add_character_selection_whitelist(self.player_cqi);
	
	-- allow player to move army
	cm:enable_movement_for_character(player_char_str);
	
	-- detect when the player's army starts moving
	cm:notify_on_character_movement(
		"intro_campaign_select_and_attack_advice",
		self.player_cqi,
		function()
			self:army_is_moving();
		end
	);	
	
	self:highlight_character_for_selection();
end;


function intro_campaign_select_and_attack_advice:highlight_character_for_selection()

	local uim = cm:get_campaign_ui_manager();
	local player_char = cm:get_character_by_cqi(self.player_cqi);

	-- update objective
	cm:update_objective_chain(self.listener_name, self.selection_objective);
	
	if uim:is_char_selected(player_char) then
		self:army_selected();
	else
		uim:highlight_character_for_selection(player_char, function() self:army_selected() end, self.player_marker_altitude);
	end;
end;


function intro_campaign_select_and_attack_advice:army_selected()

	local listener_name = self.listener_name;

	-- objective
	cm:update_objective_chain(listener_name, self.attack_objective);
	
	local player_char = cm:get_character_by_cqi(self.player_cqi);
	local player_char_str = cm:char_lookup_str(player_char);
	
	-- listen for character being deselected
	core:add_listener(
		listener_name,
		"CharacterDeselected",
		true,
		function()
			core:remove_listener(listener_name);
			self:show_attack_marker(false);
			self:highlight_character_for_selection();
		end,
		false
	);
	
	-- also listen for settlement selected - this means the character has been deselected
	core:add_listener(
		listener_name,
		"SettlementSelected",
		true,
		function()
			core:remove_listener(listener_name);
			self:show_attack_marker(false);
			self:highlight_character_for_selection();
		end,
		false
	);
		
	-- show advice and infotext
	self:show_attacking_advice();
	
	-- show marker	
	self:show_attack_marker(true);
end;


function intro_campaign_select_and_attack_advice:show_attack_marker(value)
	local uim = self.cm:get_campaign_ui_manager();
	local enemy_char = cm:get_character_by_cqi(self.enemy_cqi);
	
	if value == false then
		uim:unhighlight_character(enemy_char, true);
	else
		uim:highlight_character(enemy_char, "move_to_vfx", self.enemy_marker_altitude);
	end;	
end;


function intro_campaign_select_and_attack_advice:show_attacking_advice()
	
	if not self.attack_advice_shown then
		cm:show_advice(self.attack_advice);
		
		self.attack_advice_shown = true;

		cm:clear_infotext();
			
		if #self.attack_infotext > 0 then
			cm:add_infotext(self.attack_infotext_delay, unpack(self.attack_infotext));
		end;
	end;
end;


function intro_campaign_select_and_attack_advice:army_is_moving()
	
	local player_char = cm:get_character_by_cqi(self.player_cqi);
	local player_char_str = cm:char_lookup_str(player_char);
	local enemy_char_str = cm:char_lookup_str(self.enemy_cqi);
	local uim = cm:get_campaign_ui_manager();
	local listener_name = self.listener_name;
	
	core:remove_listener(listener_name);
	
	-- unhighlight character for selection (in case player deselected immediately after moving)
	uim:unhighlight_character_for_selection(player_char);
	
	-- re-order the player's army to attack the target
	cm:attack(player_char_str, enemy_char_str);
		
	-- lock out ui so that the player cannot interfere
	cm:steal_user_input(true);
	
	-- listen for the attack being initiated
	core:add_listener(
		listener_name,
		"ScriptEventPreBattlePanelOpened",
		true,
		function()
			self:attack_initiated();
		end,
		false
	);
end;


function intro_campaign_select_and_attack_advice:attack_initiated()
	
	-- remove target marker
	self:show_attack_marker(false);
	
	local listener_name = self.listener_name;
	
	core:remove_listener(listener_name .. "_area_exited");
	core:remove_listener(listener_name);
	
	cm:complete_objective(self.attack_objective);
	cm:callback(function() cm:end_objective_chain(self.listener_name) end, 2);

	self.completion_callback();
end;













----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- select advice
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


intro_campaign_select_advice = {
	player_cqi = -1,
	advice_key = "",
	infotext = {},
	infotext_delay = 1,
	selection_delay = 0,
	allow_selection_with_objective = false,
	selection_objective = "",
	completion_callback = false,
	listener_name = "select_advice",
	highlight_altitude = 2
};


set_class_custom_type_and_tostring(intro_campaign_select_advice, TYPE_INTRO_CAMPAIGN_SELECT_ADVICE);




function intro_campaign_select_advice:new(player_cqi, advice_key, objective_key, completion_callback)
	
	if not is_number(player_cqi) then
		script_error("ERROR: attempt made to create intro_campaign_select_advice but supplied player cqi [" .. tostring(player_cqi) .. "] is not a number");
		return false;
	end;
	
	if not is_string(advice_key) then
		script_error("ERROR: attempt made to create intro_campaign_select_advice but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(objective_key) then
		script_error("ERROR: attempt made to create intro_campaign_select_advice but supplied objective key [" .. tostring(objective_key) .. "] is not a string");
		return false;
	end;
	
	if not is_function(completion_callback) then
		script_error("ERROR: attempt made to create intro_campaign_select_advice but supplied completion callback [" .. tostring(completion_callback) .. "] is not a function");
		return false;
	end;
	
	local sa = {};

	set_object_class(sa, self);
	
	sa.player_cqi = player_cqi;
	sa.advice_key = advice_key;
	sa.objective_key = objective_key;
	sa.completion_callback = completion_callback;
	sa.infotext = {};

	return sa;
end;


function intro_campaign_select_advice:add_infotext(delay, ...)
	if not is_number(delay) then
		script_error("ERROR: add_infotext() called, but supplied delay [" .. tostring(delay) .. "] is not a number");
		return false;
	end;
	
	for i = 1, arg.n do
		local current_infotext = arg[i];
		if not is_string(current_infotext) then
			script_error("ERROR: add_infotext() called but supplied item [" .. i .. "] is not a string, it is a [" .. tostring(current_infotext) .. "]");
			return false;
		else
			table.insert(self.infotext, current_infotext);
		end;
	end;
	
	self.infotext_delay = delay;
end;


function intro_campaign_select_advice:set_highlight_altitude(value)
	if not is_number(value) or value < 0 then
		script_error("ERROR: set_highlight_altitude() called but supplied altitude [" .. tostring(value) .. "] is not a positive number");
		return false;
	end;
	
	self.highlight_altitude = value;
end;


function intro_campaign_select_advice:set_selection_delay(value)
	if not is_number(value) or value < 0 then
		script_error("ERROR: set_selection_delay() called but supplied value [" .. tostring(value) .. "] is not a positive number");
		return false;
	end;
	
	self.selection_delay = value;
end;


function intro_campaign_select_advice:set_allow_selection_with_objective(value)
	if value == false then
		self.allow_selection_with_objective = false;
	else
		self.allow_selection_with_objective = true;
	end;
end;


function intro_campaign_select_advice:start()

	local uim = cm:get_campaign_ui_manager();
	
	local char_player = cm:get_character_by_cqi(self.player_cqi);
	if not char_player then
		script_error("ERROR: intro_campaign_select_and_attack_advice could not find a player character with cqi [" .. self.player_cqi .. "]");
		return false;
	end;
	
	-- clear infotext
	cm:clear_infotext();
	
	-- show advice
	cm:show_advice(self.advice_key);
	
	
	-- set up a function which allows/listens for char selection
	local function allow_selection()
		-- allow selection of the player's army
		uim:add_character_selection_whitelist(self.player_cqi);
		
		-- progress on selection	
		local player_char = cm:get_character_by_cqi(self.player_cqi);
		
		if uim:is_char_selected(player_char) then
			self:army_selected();
		else
			uim:highlight_character_for_selection(player_char, function() self:army_selected() end, self.highlight_altitude);
		end;
	end;
	
	-- show infotext and objective
	local function activate_objective()
		cm:activate_objective_chain(self.listener_name, self.objective_key);
		
		if self.allow_selection_with_objective then
			allow_selection();
		end;
	end;
	
	if #self.infotext == 0 then
		activate_objective();
	else
		table.insert(self.infotext, function() activate_objective() end);
		cm:add_infotext(1, unpack(self.infotext));
	end;
	
	if not self.allow_selection_with_objective then
		if self.selection_delay == 0 then
			allow_selection();
		else
			cm:callback(function() allow_selection() end, self.selection_delay);
		end;
	end;
end;


function intro_campaign_select_advice:army_selected()
	
	cm:complete_objective(self.objective_key);
	cm:callback(function() cm:end_objective_chain(self.listener_name) end, 2);
	
	self.completion_callback();
end;














----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- movement advice
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


intro_campaign_movement_advice = {
	player_cqi = -1,
	advice_key = "",
	infotext = {},
	infotext_delay = 1,
	infotext_displayed = false,
	selection_objective_key = "",
	movement_objective_key = "",
	log_x = 0,
	log_y = 0,
	join_garrison_key = false,
	display_x = 0,
	display_y = 0,
	movement_marker_shown = false,
	completion_callback = false,
	initial_x = false,
	initial_y = false,
	initial_d = 10,
	initial_b = 0,
	initial_h = 8,
	initial_t = 2,
	listener_name = "movement_advice",
	highlight_altitude = 2,
	camera_follow = false,
	camera_follow_start_x = 0,
	camera_follow_start_y = 0,
	camera_follow_start_d = 0,
	camera_follow_start_b = 0,
	camera_follow_start_h = 0,
	camera_follow_end_x = 0,
	camera_follow_end_y = 0,
	camera_follow_end_d = 0,
	camera_follow_end_b = 0,
	camera_follow_end_h = 0,
	has_advice_text = false
};


set_class_custom_type_and_tostring(intro_campaign_movement_advice, TYPE_INTRO_CAMPAIGN_MOVEMENT_ADVICE);




function intro_campaign_movement_advice:new(player_cqi, advice_key, selection_objective_key, movement_objective_key, log_x, log_y, completion_callback)
	if not is_number(player_cqi) then
		script_error("ERROR: attempt made to create intro_campaign_movement_advice but supplied player cqi [" .. tostring(player_cqi) .. "] is not a number");
		return false;
	end;
	
	if not is_string(advice_key) then
		script_error("ERROR: attempt made to create intro_campaign_movement_advice but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(selection_objective_key) then
		script_error("ERROR: attempt made to create intro_campaign_movement_advice but supplied selection objective key [" .. tostring(selection_objective_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(movement_objective_key) then
		script_error("ERROR: attempt made to create intro_campaign_movement_advice but supplied movement objective key [" .. tostring(movement_objective_key) .. "] is not a string");
		return false;
	end;
	
	if not is_number(log_x) or log_x <= 0 then
		script_error("ERROR: attempt made to create intro_campaign_movement_advice but supplied log x co-ordinate [" .. tostring(log_x) .. "] is not a number > 0");
		return false;
	end;
	
	if not is_number(log_y) or log_y <= 0 then
		script_error("ERROR: attempt made to create intro_campaign_movement_advice but supplied log y co-ordinate [" .. tostring(log_y) .. "] is not a number > 0");
		return false;
	end;
	
	if not is_function(completion_callback) then
		script_error("ERROR: attempt made to create intro_campaign_movement_advice but supplied completion callback [" .. tostring(completion_callback) .. "] is not a function");
		return false;
	end;
	
	local ma = {};
	
	set_object_class(ma, self);
	
	ma.player_cqi = player_cqi;
	ma.advice_key = advice_key;
	ma.selection_objective_key = selection_objective_key;
	ma.movement_objective_key = movement_objective_key;
	ma.log_x = log_x;
	ma.log_y = log_y;
	ma.display_x, ma.display_y = cm:log_to_dis(log_x, log_y);
	ma.completion_callback = completion_callback;
	ma.infotext = {};

	return ma;

end;


function intro_campaign_movement_advice:add_infotext(delay, ...)
	if not is_number(delay) then
		script_error("ERROR: add_infotext() called, but supplied delay [" .. tostring(delay) .. "] is not a number");
		return false;
	end;
	
	for i = 1, arg.n do
		local current_infotext = arg[i];
		if not is_string(current_infotext) then
			script_error("ERROR: add_infotext() called but supplied item [" .. i .. "] is not a string, it is a [" .. tostring(current_infotext) .. "]");
			return false;
		else
			table.insert(self.infotext, current_infotext);
		end;
	end;
	
	self.infotext_delay = delay;
end;


function intro_campaign_movement_advice:set_highlight_altitude(value)
	if not is_number(value) or value < 0 then
		script_error("ERROR: set_highlight_altitude() called but supplied altitude [" .. tostring(value) .. "] is not a positive number");
		return false;
	end;
	
	self.highlight_altitude = value;
end;

function intro_campaign_movement_advice:set_has_advice_text(value)
	self.has_advice_text = value;
end;




function intro_campaign_movement_advice:set_join_garrison_key(key)
	if not is_string(key) then
		script_error("ERROR: set_join_garrison_key() called but supplied key [" .. tostring(key) .. "] is not a string");
		return false;
	end;
	
	self.join_garrison_key = key;
end;


function intro_campaign_movement_advice:set_camera_position_override(x, y, d, b, h)
	if x then
		if not is_number(x) then
			script_error("ERROR: set_camera_position_override() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a number");
			return false;
		end;
		
		self.initial_x = x;
	end;
	
	if y then
		if not is_number(y) then
			script_error("ERROR: set_camera_position_override() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a number");
			return false;
		end;
		
		self.initial_y = y;
	end;
	
	if d then
		if not is_number(d) then
			script_error("ERROR: set_camera_position_override() called but supplied d co-ordinate [" .. tostring(d) .. "] is not a number");
			return false;
		end;
		
		self.initial_d = d;
	end;
	
	if b then
		if not is_number(b) then
			script_error("ERROR: set_camera_position_override() called but supplied b co-ordinate [" .. tostring(b) .. "] is not a number");
			return false;
		end;
		
		self.initial_b = b;
	end;
	
	if h then
		if not is_number(h) then
			script_error("ERROR: set_camera_position_override() called but supplied h co-ordinate [" .. tostring(h) .. "] is not a number");
			return false;
		end;
		
		self.initial_h = h;
	end;
end;


function intro_campaign_movement_advice:set_camera_follow(value, camera_follow_start_x, camera_follow_start_y, camera_follow_start_d, camera_follow_start_b, camera_follow_start_h, camera_follow_end_x, camera_follow_end_y, camera_follow_end_d, camera_follow_end_b, camera_follow_end_h)
	self.camera_follow = value;
	self.camera_follow_start_x = camera_follow_start_x;
	self.camera_follow_start_y = camera_follow_start_y;
	self.camera_follow_start_d = camera_follow_start_d;
	self.camera_follow_start_b = camera_follow_start_b;
	self.camera_follow_start_h = camera_follow_start_h;
	self.camera_follow_end_x = camera_follow_end_x;
	self.camera_follow_end_y = camera_follow_end_y;
	self.camera_follow_end_d = camera_follow_end_d;
	self.camera_follow_end_b = camera_follow_end_b;
	self.camera_follow_end_h = camera_follow_end_h;
end;



function intro_campaign_movement_advice:start()

	local player_char = cm:get_character_by_cqi(self.player_cqi);
	
	if not player_char then
		script_error("ERROR: intro_campaign_movement_advice cannot find character with supplied cqi [" .. tostring(self.player_cqi) .. "]");
		return false;
	end;
	
	-- work out a position halfway between the target character and the destination
	local player_char_x = player_char:display_position_x();
	local player_char_y = player_char:display_position_y();
	
	local targ_x = self.initial_x or (player_char_x - ((player_char_x - self.display_x) / 2));
	local targ_y = self.initial_y or (player_char_y - ((player_char_y - self.display_y) / 2));
	
	-- pan camera to calculated target
	cm:scroll_camera_with_cutscene(
		self.initial_t, 
		function() self:intro_pan_finished() end,
		{targ_x, targ_y, self.initial_d, self.initial_b, self.initial_h}
	);
	
	-- show advice and infotext
	cm:callback(
		function() 
			if self.has_advice_text then
				cm:show_advice(self.advice_key);
				
				-- build table of initial infotext and add a call to show the objective chain at the end
				local infotext_to_add = {};
				
				for i = 1, #self.infotext do
					infotext_to_add[i] = self.infotext[i];
				end;
				
				table.insert(infotext_to_add, function() cm:activate_objective_chain(self.listener_name, self.selection_objective_key) end);
				
				cm:add_infotext(self.infotext_delay, unpack(infotext_to_add));
			end
		end, 
		1
	);
end;


function intro_campaign_movement_advice:intro_pan_finished()

	-- allow selection of the main army
	cm:get_campaign_ui_manager():add_character_selection_whitelist(self.player_cqi);
	
	-- ensure that the player is allowed to give orders
	cm:get_campaign_ui_manager():override("giving_orders"):unlock();
	
	local player_char = cm:get_character_by_cqi(self.player_cqi);
	local player_char_str = cm:char_lookup_str(player_char);
	local listener_name = self.listener_name;

	-- allow player to move army
	cm:enable_movement_for_character(player_char_str);
	
	-- detect when the player's army starts moving
	cm:add_circle_area_trigger(player_char:display_position_x(), player_char:display_position_y(), 0, listener_name, player_char_str, false, true, true);
	
	core:add_listener(
		listener_name .. "_area_exited",
		"AreaExited", 
		function(context) return context:area_key() == listener_name end,
		function(context) 
			core:remove_listener(listener_name);
			self:army_is_moving();
		end, 
		false
	);
	
	self:highlight_character_for_selection();
end;


function intro_campaign_movement_advice:highlight_character_for_selection()
	local uim = cm:get_campaign_ui_manager();

	-- update objective
	cm:update_objective_chain(self.listener_name, self.selection_objective_key);
	
	-- highlight char for selection
	local player_char = cm:get_character_by_cqi(self.player_cqi);
	
	if uim:is_char_selected(player_char) then
		self:army_selected();
	else
		uim:highlight_character_for_selection(player_char, function() self:army_selected() end, self.highlight_altitude);
	end;
end;


function intro_campaign_movement_advice:army_selected()
	local listener_name = self.listener_name;
	
	-- objective
	cm:update_objective_chain(listener_name, self.movement_objective_key);
	
	local player_char = cm:get_character_by_cqi(self.player_cqi);
	local player_char_str = cm:char_lookup_str(player_char);
	
	-- listen for character being deselected
	core:add_listener(
		listener_name,
		"CharacterDeselected",
		true,
		function()		
			core:remove_listener(listener_name);
			self:show_movement_marker(false);
			self:highlight_character_for_selection();
		end,
		false
	);
		
	-- show marker
	self:show_movement_marker(true);
end;


function intro_campaign_movement_advice:show_movement_marker(value)
	local listener_name = self.listener_name;
	
	if value then
		if not self.movement_marker_shown then
			-- show movement marker
			self.movement_marker_shown = true;
			cm:add_marker(listener_name, "move_to_vfx", self.display_x, self.display_y, 1);
		end;
	else
		if self.movement_marker_shown then
			-- hide movement marker
			self.movement_marker_shown = false;
			cm:remove_marker(listener_name);
		end;
	end;
end;


function intro_campaign_movement_advice:army_is_moving()
	local player_char = cm:get_character_by_cqi(self.player_cqi);
	local uim = cm:get_campaign_ui_manager();
	
	-- unhighlight character for selection (in case player deselected immediately after moving)
	uim:unhighlight_character_for_selection(player_char)
	
	-- re-order the vip army to the target
	if self.join_garrison_key then
		-- a join garrison key is set, send the character to join the garrison rather than move to the position
		cm:join_garrison(cm:char_lookup_str(self.player_cqi), self.join_garrison_key);
		
		-- listen for the character arriving
		core:add_listener(
			"intro_campaign_movement_advice",
			"CharacterEntersGarrison",
			function(context)
				return context:character():cqi() == self.player_cqi;
			end,
			function()
				self:army_has_arrived(true);
			end,
			false
		);
	else
		cm:move_character(self.player_cqi, self.log_x, self.log_y, false, false, function() self:army_has_arrived(true) end, function() self:army_has_arrived(false) end)
	end;
	
	
	--[[ add cutscene
	local cutscene_intro = campaign_cutscene:new(
		"campaign_intro",
		14
		
	);
	out("Trying to move camera")
	
	-- cutscene_intro:set_debug();
	cutscene_intro:set_disable_settlement_labels(false);
	cutscene_intro:set_dismiss_advice_on_end(false);
	
	cutscene_intro:action(
		function()
			cm:set_camera_position(114.991905, 19.600224, 10.343493, 0.0, 4.0);
		end,
		0
	);
	
	cm:callback(
		function()
			-- The enemy close on our outpost in number, my Lord! We must look to our defence, and soon!
			cm:show_advice("wh3_intro_camp_100");
		end,
		2
	);
	
	cutscene_intro:action(
		function()
			cm:scroll_camera_from_current(true, 14, {114.384613, 27.830257, 11.340765, 0.0, 4.0});
		end,
		0.5
	);
	
	cutscene_intro:action(
		function()
			-- This must be the place, my Lord. At long last, this must be the cauldron of which the legends speak!
			cm:show_advice("wh3_intro_camp_001");		
		end,
		1
	);
	
	cutscene_intro:start();]]
	
	-- lock out ui so that the player cannot interfere
	cm:steal_user_input(true);
end;


function intro_campaign_movement_advice:army_has_arrived(arrived_cleanly)

	local listener_name = self.listener_name;

	if not arrived_cleanly then
		script_error("WARNING: army_has_arrived() called but the army did not arrive cleanly, investigate!");
	end;
	
	-- zero player army AP, so that it can't move again
	cm:zero_action_points(cm:char_lookup_str(self.player_cqi));
	
	-- unlock ui
	cm:steal_user_input(false);
	
	-- remove marker
	self:show_movement_marker(false);
	cm:remove_area_trigger(listener_name);
	
	-- objective
	cm:complete_objective(self.movement_objective_key);
	cm:callback(function() cm:end_objective_chain(listener_name) end, 2);
	
	self.completion_callback();
end;



























----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- recruitment tutorial
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


intro_campaign_recruitment_advice = {
	char_cqi = -1,
	completion_callback = nil,
	start_advice = "",
	end_advice = "",
	initial_infotext = {},
	initial_infotext_delay = 1,
	selection_objective = "",
	panel_objective = "",
	recruitment_objective = "",
	listener_name = "recruitment_tutorial",
	num_recruited = 0,
	recruitment_limit = 0,
	unit_cards_highlighted = false,
	highlight_altitude = 2,
	-- character selected callbacks
	first_time_character_selected_callback = false,
	first_time_character_selected_callback_delay = 0,
	character_selected_first_time = false,
	each_time_character_selected_callback = false,
	each_time_character_selected_callback_delay = 0,
	-- recruitment panel opened callbacks
	first_time_open_recruitment_panel_callback = false,
	first_time_open_recruitment_panel_callback_delay = 0,
	recruitment_panel_opened_first_time = false,
	each_time_open_recruitment_panel_callback = false,
	each_time_open_recruitment_panel_callback_delay = 0,
	-- recruitment panel closed callbacks
	first_time_close_recruitment_panel_callback = false,
	first_time_close_recruitment_panel_callback_delay = 0,
	recruitment_panel_closed_first_time = false,
	each_time_close_recruitment_panel_callback = false,
	each_time_close_recruitment_panel_callback_delay = 0,	
	-- unit recruited callbacks
	first_time_unit_recruited_callback = false,
	first_time_unit_recruited_callback_delay = 0,
	first_time_unit_recruited_callback_called = false,
	each_time_unit_recruited_callback = false,
	each_time_unit_recruited_callback_delay = 0,
	-- all units recruited callback
	all_units_recruited_callback = false
};


set_class_custom_type_and_tostring(intro_campaign_recruitment_advice, TYPE_INTRO_CAMPAIGN_RECRUITMENT_ADVICE);


function intro_campaign_recruitment_advice:new(player_cqi, start_advice, selection_objective, panel_objective, recruitment_objective, recruitment_limit, end_advice, completion_callback)
		
	if not is_number(player_cqi) then
		script_error("ERROR: intro_campaign_recruitment_advice:new() was called but supplied character cqi [" .. tostring(player_cqi) .. "] is not a number");
		return false;
	end;
	
	if not cm:get_character_by_cqi(player_cqi) then
		script_error("ERROR: intro_campaign_recruitment_advice:new() was called but a character from faction [" .. faction_name .. "] with supplied character cqi [" .. char_cqi .. "] could not be found");
		return false;
	end;
	
	if not is_string(start_advice) then
		script_error("ERROR: intro_campaign_recruitment_advice:new() was called but supplied start advice key [" .. tostring(start_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_string(selection_objective) then
		script_error("ERROR: intro_campaign_recruitment_advice:new() was called but supplied selection objective key [" .. tostring(selection_objective) .. "] is not a string");
		return false;
	end;
	
	if not is_string(panel_objective) then
		script_error("ERROR: intro_campaign_recruitment_advice:new() was called but supplied panel objective key [" .. tostring(panel_objective) .. "] is not a string");
		return false;
	end;
	
	if not is_string(recruitment_objective) then
		script_error("ERROR: intro_campaign_recruitment_advice:new() was called but supplied recruitment objective key [" .. tostring(recruitment_objective) .. "] is not a string");
		return false;
	end;
	
	if not is_number(recruitment_limit) then
		script_error("ERROR: intro_campaign_recruitment_advice:new() was called but supplied recruitment limit [" .. tostring(recruitment_limit) .. "] is not a number");
		return false;
	end;
		
	if not is_string(end_advice) then
		script_error("ERROR: intro_campaign_recruitment_advice:new() was called but supplied end advice key [" .. tostring(end_advice) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_function(completion_callback) then
		script_error("ERROR: intro_campaign_recruitment_advice:new() was called but supplied completion callback [" .. tostring(completion_callback) .. "] is not a string");
		return false;
	end;

	local rt = {};
	
	set_object_class(rt, self);
	
	rt.player_cqi = player_cqi;
	rt.start_advice = start_advice;
	rt.selection_objective = selection_objective;
	rt.panel_objective = panel_objective;
	rt.recruitment_objective = recruitment_objective;
	rt.recruitment_limit = recruitment_limit;
	rt.end_advice = end_advice;
	rt.completion_callback = completion_callback;
	
	rt.initial_infotext = {};
	
	return rt;
end;


function intro_campaign_recruitment_advice:add_initial_infotext(delay, ...)
	if not is_number(delay) then
		script_error("ERROR: add_initial_infotext() called, but supplied delay [" .. tostring(delay) .. "] is not a number");
		return false;
	end;
	
	for i = 1, arg.n do
		local current_infotext = arg[i];
		if not is_string(current_infotext) then
			script_error("ERROR: add_initial_infotext() called but supplied item [" .. i .. "] is not a string, it is a [" .. tostring(current_infotext) .. "]");
			return false;
		else
			table.insert(self.initial_infotext, current_infotext);
		end;
	end;
	
	self.initial_infotext_delay = delay;
end;


function intro_campaign_recruitment_advice:set_highlight_altitude(value)
	if not is_number(value) or value < 0 then
		script_error("ERROR: set_highlight_altitude() called but supplied altitude [" .. tostring(value) .. "] is not a positive number");
		return false;
	end;
	
	self.highlight_altitude = value;
end;


function intro_campaign_recruitment_advice:set_first_time_open_recruitment_panel_callback(callback, delay)
	if not is_function(callback) then
		script_error("ERROR: set_first_time_open_recruitment_panel_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
		
	if delay then 
		if not is_number(delay) or delay < 0 then
			script_error("ERROR: set_first_time_open_recruitment_panel_callback() called but supplied callback delay [" .. tostring(delay) .. "] is not a positive number or nil");
			return false;
		end;
		
		self.first_time_open_recruitment_panel_callback_delay = delay;
	end;
	
	self.first_time_open_recruitment_panel_callback = callback;
end;


function intro_campaign_recruitment_advice:set_each_time_open_recruitment_panel_callback(callback, delay)
	if not is_function(callback) then
		script_error("ERROR: set_each_time_open_recruitment_panel_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
		
	if delay then 
		if not is_number(delay) or delay < 0 then
			script_error("ERROR: set_each_time_open_recruitment_panel_callback() called but supplied callback delay [" .. tostring(delay) .. "] is not a positive number or nil");
			return false;
		end;
		
		self.each_time_open_recruitment_panel_callback_delay = delay;
	end;
	
	self.each_time_open_recruitment_panel_callback = callback;
end;


function intro_campaign_recruitment_advice:set_first_time_close_recruitment_panel_callback(callback, delay)
	if not is_function(callback) then
		script_error("ERROR: set_first_time_close_recruitment_panel_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
		
	if delay then 
		if not is_number(delay) or delay < 0 then
			script_error("ERROR: set_first_time_close_recruitment_panel_callback() called but supplied callback delay [" .. tostring(delay) .. "] is not a positive number or nil");
			return false;
		end;
		
		self.first_time_close_recruitment_panel_callback_delay = delay;
	end;
	
	self.first_time_close_recruitment_panel_callback = callback;
end;


function intro_campaign_recruitment_advice:set_each_time_close_recruitment_panel_callback(callback, delay)
	if not is_function(callback) then
		script_error("ERROR: set_each_time_close_recruitment_panel_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
		
	if delay then 
		if not is_number(delay) or delay < 0 then
			script_error("ERROR: set_each_time_close_recruitment_panel_callback() called but supplied callback delay [" .. tostring(delay) .. "] is not a positive number or nil");
			return false;
		end;
		
		self.each_time_close_recruitment_panel_callback_delay = delay;
	end;
	
	self.each_time_close_recruitment_panel_callback = callback;
end;


function intro_campaign_recruitment_advice:set_first_time_unit_recruited_callback(callback, delay)
	if not is_function(callback) then
		script_error("ERROR: set_first_time_unit_recruited_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	if delay then
		if not is_number(delay) or delay < 0 then
			script_error("ERROR: set_first_time_unit_recruited_callback() called but supplied callback delay [" .. tostring(delay) .. "] is not a positive number or nil");
			return false;
		end;
		
		self.first_time_unit_recruited_callback_delay = delay;
	end;
	
	self.first_time_unit_recruited_callback = callback;
end;


function intro_campaign_recruitment_advice:set_each_time_unit_recruited_callback(callback, delay)
	if not is_function(callback) then
		script_error("ERROR: set_each_time_unit_recruited_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	if delay then
		if not is_number(delay) or delay < 0 then
			script_error("ERROR: set_each_time_unit_recruited_callback() called but supplied callback delay [" .. tostring(delay) .. "] is not a positive number or nil");
			return false;
		end;
		
		self.each_time_unit_recruited_callback_delay = delay;
	end;
	
	self.each_time_unit_recruited_callback = callback;
end;


function intro_campaign_recruitment_advice:set_all_units_recruited_callback(callback)
	if not is_function(callback) then
		script_error("ERROR: set_all_units_recruited_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	self.all_units_recruited_callback = callback;
end;










function intro_campaign_recruitment_advice:start()

	local uim = cm:get_campaign_ui_manager();
	
	-- allow selection change
	uim:override("selection_change"):set_allowed(true);
	
	-- clear selection
	CampaignUI.ClearSelection();
		
	-- permit unit recruitment
	uim:override("recruit_units"):set_allowed(true);
	uim:override("cancel_recruitment"):set_allowed(true);
	
	-- clear infotext
	cm:clear_infotext();
	
	-- advice
	cm:show_advice(self.start_advice, true);
	
	-- build table of initial infotext and add a call to show the objective chain at the end
	local initial_infotext = self.initial_infotext;
	local infotext_to_add = {};
	
	for i = 1, #initial_infotext do
		infotext_to_add[i] = initial_infotext[i];
	end;
	
	table.insert(infotext_to_add, function() cm:activate_objective_chain(self.listener_name, self.selection_objective) end);
	
	cm:add_infotext(self.initial_infotext_delay, unpack(infotext_to_add));
	
	-- allow selection of the main army
	cm:get_campaign_ui_manager():add_character_selection_whitelist(self.player_cqi);
	
	-- if the player's army is not selected, highlight it
	local player_char = cm:get_character_by_cqi(self.player_cqi);
	
	if not uim:is_char_selected(player_char) then
		uim:highlight_character_for_selection(player_char, function() self:character_selected() end, self.highlight_altitude);
	else
		self:character_selected();
	end;
end;


function intro_campaign_recruitment_advice:character_selected()

	local uim = cm:get_campaign_ui_manager();
	local listener_name = self.listener_name;
	
	cm:update_objective_chain(listener_name, self.panel_objective);
		
	-- call first time character selected callback if we should
	if self.first_time_character_selected_callback and not self.character_selected_first_time then
		cm:callback(
			function()
				self.first_time_character_selected_callback();
			end,
			self.first_time_character_selected_callback_delay
		);
	end;
	
	self.character_selected_first_time = true;
	
	-- call each time open recruitment panel callback if we should
	if self.each_time_character_selected_callback then
		cm:callback(
			function()
				self.each_time_character_selected_callback();
			end,
			self.each_time_character_selected_callback_delay
		);
	end;
	
	-- add a listener for the character being deselected
	core:add_listener(
		listener_name,
		"CharacterDeselected", 
		true,
		function()
			core:remove_listener(listener_name);
			highlight_component(false, true, "button_group_army", "button_recruitment");
			cm:update_objective_chain(listener_name, self.selection_objective);
			uim:highlight_character_for_selection(cm:get_character_by_cqi(self.player_cqi), function() self:character_selected() end, self.highlight_altitude);
		end, 
		false
	);
	
	core:add_listener(
		listener_name,
		"PanelOpenedCampaign", 
		function(context) return context.string == "units_recruitment" end,
		function(context) 
			core:remove_listener(listener_name);
			highlight_component(false, true, "button_group_army", "button_recruitment");
			self:player_opens_recruitment_panel();
		end, 
		false
	);
	
	highlight_component(true, true, "button_group_army", "button_recruitment");
end;


function intro_campaign_recruitment_advice:update_recruit_units_objective()
	cm:update_objective_chain(self.listener_name, self.recruitment_objective, self.num_recruited, self.recruitment_limit);
	
	if self.num_recruited == self.recruitment_limit then
		cm:complete_objective(self.recruitment_objective);
	end;
end;


function intro_campaign_recruitment_advice:player_opens_recruitment_panel()

	local uim = cm:get_campaign_ui_manager();
	local listener_name = self.listener_name;
	
	cm:remove_callback("close_recruitment_panel_callback");
	
	self:update_recruit_units_objective();
	
	local player_char = cm:get_character_by_cqi(self.player_cqi);	
	
	-- call first time open recruitment panel callback if we should
	if self.first_time_open_recruitment_panel_callback and not self.recruitment_panel_opened_first_time then
		cm:callback(
			function()
				self.first_time_open_recruitment_panel_callback();
			end,
			self.first_time_open_recruitment_panel_callback_delay,
			"open_recruitment_panel_callback"
		);
	end;
	
	self.recruitment_panel_opened_first_time = true;
	
	-- call each time open recruitment panel callback if we should
	if self.each_time_open_recruitment_panel_callback then
		cm:callback(
			function()
				self.each_time_open_recruitment_panel_callback();
			end,
			self.each_time_open_recruitment_panel_callback_delay,
			"open_recruitment_panel_callback"
		);
	end;
	
	-- add highlight for the unit card
	cm:callback(
		function()
			self:highlight_all_unit_cards(true);
		end, 
		0.4, 
		"unit_card_highlight"
	);
	
	-- listen for the player recruiting a unit
	core:add_listener(
		listener_name,
		"RecruitmentItemIssuedByPlayer", 
		true,
		function(context)
			self.num_recruited = self.num_recruited + 1;
			
			self:update_recruit_units_objective();
			
			-- call first time unit recruited callback if we should
			if self.first_time_unit_recruited_callback and not self.first_time_unit_recruited_callback_called then
				cm:callback(
					function()
						self.first_time_unit_recruited_callback_called = true;
						self.first_time_unit_recruited_callback();
					end,
					self.first_time_unit_recruited_callback_delay,
					"unit_recruited_callback"
				);
			end;
			
			-- call each time unit recruited callback if we have one
			if self.each_time_unit_recruited_callback then
				cm:callback(
					function()
						self.each_time_unit_recruited_callback();
					end,
					self.each_time_unit_recruited_callback_delay,
					"unit_recruited_callback"
				);
			end;
			
			if self.num_recruited >= self.recruitment_limit then
				core:remove_listener(listener_name);
				cm:remove_callback("unit_card_highlight");
				self:highlight_all_unit_cards(false);
				
				self:all_units_recruited();
			end;						
		end, 
		true
	);
	
	-- listen for player cancelling enqueued unit
	core:add_listener(
		listener_name,
		"ComponentLClickUp",
		function(context) return self:component_name_is_enqueued_unit(context.string) end,
		function()
			cm:remove_callback("unit_recruited_callback");
			self.num_recruited = self.num_recruited - 1;
			self:update_recruit_units_objective();
		end,
		true
	);
	
	-- cleanup callback to call if the player closes recruitment panel/deselects character
	local rewind_callback = function()
		core:remove_listener(listener_name);
		cm:remove_callback("unit_card_highlight");
		cm:remove_callback("open_recruitment_panel_callback");
		self:highlight_all_unit_cards(false);
		
		-- call first time close recruitment panel callback if we should
		if self.first_time_close_recruitment_panel_callback and not self.recruitment_panel_closed_first_time then
			cm:callback(
				function()
					self.first_time_close_recruitment_panel_callback();
				end,
				self.first_time_close_recruitment_panel_callback_delay,
				"close_recruitment_panel_callback"
			);
		end;
		
		self.recruitment_panel_closed_first_time = true;
		
		-- call each time close recruitment panel callback if we should
		if self.each_time_close_recruitment_panel_callback then
			cm:callback(
				function()
					self.each_time_close_recruitment_panel_callback();
				end,
				self.each_time_close_recruitment_panel_callback_delay,
				"close_recruitment_panel_callback"
			);
		end;
	end;
	
	
	-- listen for player closing recruitment panel
	core:add_listener(
		listener_name,
		"PanelClosedCampaign", 
		function(context) 
			return context.string == "units_recruitment" 
		end,
		function()
			rewind_callback();
			self:character_selected();
		end,
		false
	);
	
	-- listen for player deselecting character
	core:add_listener(
		listener_name,
		"CharacterDeselected", 
		true,
		function()
			rewind_callback();
			uim:highlight_character_for_selection(
				self.player_cqi, 
				function() 
					cm:remove_callback("close_recruitment_panel_callback");
					self:character_selected();
				end, 
				self.highlight_altitude
			);
		end, 
		false
	);
end;


function intro_campaign_recruitment_advice:component_name_is_enqueued_unit(name)
	return string.sub(name, 1, 14) == "QueuedLandUnit";
end;


function intro_campaign_recruitment_advice:highlight_all_unit_cards(value)

	if value then
		if self.unit_cards_highlighted then
			return;
		end;
		
		self.unit_cards_highlighted = true;	
	
		local uic_recruitment_list = find_uicomponent(core:get_ui_root(), "main_units_panel", "recruitment_options", "recruitment_listbox", "local1", "listview", "list_clip", "list_box");
		
		if not uic_recruitment_list then
			script_error("ERROR: highlight_all_unit_cards() could not find uic_recruitment_list, how can this be?");
			return false;
		end;
		
		highlight_all_visible_children(uic_recruitment_list, 5);
	else
		if not self.unit_cards_highlighted then
			return;
		end;
		
		self.unit_cards_highlighted = false;
		
		unhighlight_all_visible_children();
	end;
end;


function intro_campaign_recruitment_advice:all_units_recruited()

	local uim = cm:get_campaign_ui_manager();
	
	core:remove_listener(self.listener_name);
	
	-- complete objective
	-- cm:complete_objective(self.recruitment_objective);
	
	-- call the all-units-recruited callback if we should
	if self.all_units_recruited_callback then
		self.all_units_recruited_callback()
	end;
	
	-- forbid unit recruitment
	uim:override("recruit_units"):set_allowed(false);
	uim:override("cancel_recruitment"):set_allowed(false);
	
	cm:callback(
		function()
			cm:show_advice(self.end_advice, true);
			
			cm:progress_on_advice_dismissed(
				"intro_campaign_recruitment_advice",
				function()
					cm:end_objective_chain(self.listener_name);
					cm:callback(function() self.completion_callback() end, 1);
				end,
				0,
				true
			);
		end,
		0.5
	);
end;










----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- select settlement
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


intro_campaign_select_settlement_advice = {
	region_name = "",
	initial_advice = "",
	initial_infotext = {},
	initial_infotext_delay = 1,
	selection_objective = "",
	completion_callback = nil,
	listener_name = "select_settlement_advice",
	highlight_altitude = 2,
	zoom_to_d = 10,
	zoom_to_b = 0,
	zoom_to_h = 8,
	prevent_deselection_on_selection = true
};


set_class_custom_type_and_tostring(intro_campaign_select_settlement_advice, TYPE_INTRO_CAMPAIGN_SELECT_SETTLEMENT_ADVICE);


function intro_campaign_select_settlement_advice:new(region_name, province_name, initial_advice, selection_objective, completion_callback)
	if not is_string(region_name) then
		script_error("ERROR: intro_campaign_select_settlement_advice:new() was called but supplied region name [" .. tostring(region_name) .. "] is not a string");
		return false;
	end;
		
	if not cm:get_region(region_name) then
		script_error("ERROR: intro_campaign_select_settlement_advice:new() was called but could not find a region with supplied key [" .. tostring(region_name) .. "]");
		return false;
	end;
	
	if not is_string(province_name) then
		script_error("ERROR: intro_campaign_select_settlement_advice:new() was called but supplied province name [" .. tostring(province_name) .. "] is not a string");
		return false;
	end;
	
	if not is_string(initial_advice) then
		script_error("ERROR: intro_campaign_select_settlement_advice:new() was called but supplied initial advice key [" .. tostring(initial_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_string(selection_objective) then
		script_error("ERROR: intro_campaign_select_settlement_advice:new() was called but supplied selection objective key [" .. tostring(selection_objective) .. "] is not a string");
		return false;
	end;
		
	if not is_function(completion_callback) then
		script_error("ERROR: intro_campaign_select_settlement_advice:new() was called but supplied completion callback [" .. tostring(completion_callback) .. "] is not a function");
		return false;
	end;

	local sa = {};

	set_object_class(sa, self);
	
	sa.region_name = region_name;
	sa.province_name = province_name;
	sa.settlement_name = cm:get_region(region_name):settlement():key();
	sa.initial_advice = initial_advice;
	sa.selection_objective = selection_objective;
	sa.initial_infotext = {};
	sa.completion_callback = completion_callback;
	
	return sa;
end;


function intro_campaign_select_settlement_advice:add_initial_infotext(delay, ...)
	if not is_number(delay) then
		script_error("ERROR: add_initial_infotext() called, but supplied delay [" .. tostring(delay) .. "] is not a number");
		return false;
	end;
	
	for i = 1, arg.n do
		local current_infotext = arg[i];
		if not is_string(current_infotext) then
			script_error("ERROR: add_initial_infotext() called but supplied item [" .. i .. "] is not a string, it is a [" .. tostring(current_infotext) .. "]");
			return false;
		else
			table.insert(self.initial_infotext, current_infotext);
		end;
	end;
	
	self.initial_infotext_delay = delay;
end;


function intro_campaign_select_settlement_advice:set_highlight_altitude(value)
	if not is_number(value) or value < 0 then
		script_error("ERROR: set_highlight_altitude() called but supplied altitude [" .. tostring(value) .. "] is not a positive number");
		return false;
	end;
	
	self.highlight_altitude = value;
end;


function intro_campaign_select_settlement_advice:start()
	local uim = cm:get_campaign_ui_manager();
	local settlement_name = self.settlement_name;
	
	-- clear selection
	CampaignUI.ClearSelection();
	
	-- allow selection of settlement
	uim:enable_settlement_selection_whitelist();
	uim:add_settlement_selection_whitelist(settlement_name);
	
	-- scroll camera
	local settlement = cm:get_region(self.region_name):settlement();
	local x, y = cm:get_camera_position();
	cm:scroll_camera_with_cutscene(4, nil, {settlement:display_position_x(), settlement:display_position_y(), self.zoom_to_d, self.zoom_to_b, self.zoom_to_h});
	
	-- clear infotext
	cm:clear_infotext();
	
	-- advice	
	cm:show_advice(self.initial_advice);
	
	-- build table of initial infotext and add a call to show the objective chain at the end
	local initial_infotext = self.initial_infotext;
	local infotext_to_add = {};
	
	for i = 1, #initial_infotext do
		infotext_to_add[i] = initial_infotext[i];
	end;
	
	table.insert(infotext_to_add, function() cm:activate_objective_chain(self.listener_name, self.selection_objective) end);
	
	cm:add_infotext(self.initial_infotext_delay, unpack(infotext_to_add));
	
	if not uim:is_settlement_selected(settlement_name) then
		uim:highlight_settlement_for_selection(
			settlement_name, 
			-- self.province_name, 
			nil,
			function()
				-- immediately prevent deselection
				if self.prevent_deselection_on_selection then
					uim:override("selection_change"):lock();
				end;
				
				cm:callback(function() self:settlement_selected() end, 1)
			end,
			0, 
			0, 
			self.highlight_altitude
		);
	else
		self:settlement_selected();
	end;
end;


function intro_campaign_select_settlement_advice:settlement_selected()
	
	-- complete objective
	cm:complete_objective(self.selection_objective);
	cm:callback(function() cm:end_objective_chain(self.listener_name) end, 2);
	
	-- allow deselection once again
	if not self.prevent_deselection_on_selection then
		cm:get_campaign_ui_manager():override("selection_change"):unlock();
	end;

	self.completion_callback() 
end;






















----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- panel highlight
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


intro_campaign_panel_highlight_advice = {
	initial_advice = "",
	initial_infotext = {},
	initial_infotext_delay = 1,
	completion_callback = nil,
	paths_to_uicomponents = {},
	highlight_text = false,
	highlight_padding = 25,
	allow_reselection_on_end = true,
	post_advice_dismiss_time = 0,
	show_advisor_dismiss_button = true,
	complete_on_advice_dismissed = true
};


set_class_custom_type_and_tostring(intro_campaign_panel_highlight_advice, TYPE_INTRO_CAMPAIGN_PANEL_HIGHLIGHT_ADVICE);



function intro_campaign_panel_highlight_advice:new(initial_advice, completion_callback, ...)
	if not is_string(initial_advice) then
		script_error("ERROR: intro_campaign_panel_highlight_advice:new() was called but supplied initial advice key [" .. tostring(initial_advice) .. "] is not a string");
		return false;
	end;
	
	if completion_callback and not is_function(completion_callback) then
		script_error("ERROR: intro_campaign_panel_highlight_advice:new() was called but supplied completion callback [" .. tostring(completion_callback) .. "] is not a function or nil");
		return false;
	end;
	
	if arg.n == 0 then
		script_error("ERROR: intro_campaign_panel_highlight_advice:new() was called but no uicomponents to highlight have been supplied");
		return false;
	end;
	
	local ui_root = core:get_ui_root();
	local uicomponents = {};
			
	local pa = {};
	
	set_object_class(pa, self);
	
	pa.initial_advice = initial_advice;	
	pa.paths_to_uicomponents = arg;
		
	pa.completion_callback = completion_callback;
	pa.initial_infotext = {};
	
	return pa;
end;


function intro_campaign_panel_highlight_advice:set_highlight_text(key)
	if not is_string(key) then
		script_error("ERROR: set_highlight_text() called but supplied key [" .. tostring(key) .. "] is not a string");
		return false;
	end;
	
	self.highlight_text = key;
end;


function intro_campaign_panel_highlight_advice:set_highlight_padding(value)
	if not is_number(value) then
		script_error("ERROR: set_highlight_padding() called but supplied value [" .. tostring(value) .. "] is not a number");
		return false;
	end;
	
	self.highlight_padding = value;
end;


function intro_campaign_panel_highlight_advice:set_post_advice_dismiss_time(value)
	if not is_number(value) or value < 0 then
		script_error("ERROR: set_post_advice_dismiss_time() called but supplied interval [" .. tostring(value) .. "] is not a positive number");
		return false;
	end;
	
	self.post_advice_dismiss_time = value;
end;


function intro_campaign_panel_highlight_advice:set_allow_reselection_on_end(value)
	if value == false then
		self.allow_reselection_on_end = false;
	else
		self.allow_reselection_on_end = true;
	end;
end;


function intro_campaign_panel_highlight_advice:set_complete_on_advice_dismissed(value)
	if value == false then
		self.complete_on_advice_dismissed = false;
	else
		self.complete_on_advice_dismissed = true;
	end;
end;


function intro_campaign_panel_highlight_advice:set_show_advisor_dismiss_button(value)
	if value == false then
		self.show_advisor_dismiss_button = false;
	else
		self.show_advisor_dismiss_button = true;
	end;
end;


function intro_campaign_panel_highlight_advice:add_infotext(delay, ...)
	if not is_number(delay) then
		script_error("ERROR: add_infotext() called, but supplied delay [" .. tostring(delay) .. "] is not a number");
		return false;
	end;
	
	for i = 1, arg.n do
		local current_infotext = arg[i];
		if not is_string(current_infotext) then
			script_error("ERROR: add_infotext() called but supplied item [" .. i .. "] is not a string, it is a [" .. tostring(current_infotext) .. "]");
			return false;
		else
			table.insert(self.initial_infotext, current_infotext);
		end;
	end;
	
	self.initial_infotext_delay = delay;
end;


function intro_campaign_panel_highlight_advice:start()
		
	-- set advisor priority so it appears above the highlight (and topmost)
	core:cache_and_set_advisor_priority(1500, true);
	
	-- activate the highlight
	self:activate_highlight();
	
	-- prevent the player from deselecting
	cm:get_campaign_ui_manager():override("selection_change"):lock();
	
	-- advice / infotext
	cm:show_advice(self.initial_advice, self.show_advisor_dismiss_button);
	
	if #self.initial_infotext > 0 then
		cm:add_infotext(self.initial_infotext_delay, unpack(self.initial_infotext));
	end;
	
	cm:progress_on_advice_dismissed("intro_campaign_panel_highlight_advice", function() self:advice_dismissed() end, 0, self.show_advisor_dismiss_button);
end;


function intro_campaign_panel_highlight_advice:activate_highlight()
	local ui_root = core:get_ui_root();
	
	local uicomponents = {};
	
	-- build/validate a list of uicomponents from the paths given
	for i = 1, #self.paths_to_uicomponents do		
		local path_to_component = self.paths_to_uicomponents[i];
		
		if not is_table(path_to_component) then
			script_error("ERROR: intro_campaign_panel_highlight_advice:activate_highlight() called but supplied path argument [" .. i .. "] is not a table, but [".. tostring(path_to_component) .. "] instead");
			return false;
		end;
		
		local uic = find_uicomponent_from_table(ui_root, path_to_component);
		
		if not uic then		
			local err_str = "";
			
			for j = 1, #path_to_component do
				if j == 1 then
					err_str = path_to_component[j];
				else
					err_str = err_str .. " > " .. path_to_component[j];
				end;
			end;
		
			script_error("ERROR: intro_campaign_panel_highlight_advice:activate_highlight() couldn't find supplied component [" .. i .. "] with path " .. err_str);
			return false;
		end;
		
		table.insert(uicomponents, uic);
	end;

	core:show_fullscreen_highlight_around_components(self.highlight_padding, self.highlight_text, false, unpack(uicomponents))
end;


function intro_campaign_panel_highlight_advice:advice_dismissed()
	if self.complete_on_advice_dismissed then
		self:complete();
	end;
end;


function intro_campaign_panel_highlight_advice:complete()
	
	-- reset advisor priority so it appears above the highlight
	core:restore_advisor_priority();
	
	-- deactivate panel highlight
	core:hide_fullscreen_highlight();
	
	-- allow the player to change selection
	if self.allow_reselection_on_end then
		cm:get_campaign_ui_manager():override("selection_change"):unlock();
	end;
	
	cm:callback(
		function() 
			if self.completion_callback then
				self.completion_callback();
			end;
		end,
		self.post_advice_dismiss_time
	);
end;
















----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- building constuction
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


intro_campaign_building_construction_advice = {
	listener_name = "construction_tutorial",
	settlement_name = "",
	province_name = "",
	start_advice = "",
	start_objective = "",
	initial_infotext = {},
	initial_infotext_delay = 1,
	settlement_selected_advice = false,
	settlement_selected_infotext = {},
	settlement_selected_advice_shown = false,
	settlement_selected_callback = false,
	settlement_selected_callback_call_one_time_only = false,
	settlement_selected_callback_called = false,
	building_chain_mouseovered_callback = false,
	building_chain_mouseovered_callback_call_one_time_only = false,
	rollout_infotext = {},
	rollout_infotext_shown = false,
	completion_infotext = {},
	base_building_card = "",
	base_building_card_highlighted = false,
	chain_building_card = false,
	chain_building_card_highlighted = false,
	upgrade_building_card = false,
	upgrade_building_card_highlighted = false,
	upgrade_objective = "",
	end_advice = false,
	completion_callback = nil,
	highlight_altitude = 0,
	allow_non_city_building_upgrades = false
};


set_class_custom_type_and_tostring(intro_campaign_building_construction_advice, TYPE_INTRO_CAMPAIGN_BUILDING_CONSTRUCTION_ADVICE);


function intro_campaign_building_construction_advice:new(region_name, province_name, start_advice, start_objective, base_building_card, chain_building_card, upgrade_building_card, upgrade_objective, end_advice, completion_callback)

	if not is_string(region_name) then
		script_error("ERROR: construction_tutorial:new() was called but supplied settlement [" .. tostring(region_name) .. "] is not a string");
		return false;
	end;
	
	local region = cm:get_region(region_name);
	
	if not region then
		script_error("ERROR: construction_tutorial:new() was called but couldn't find region with supplied name [" .. region_name .. "]");
		return false;
	end;
	
	if not is_string(province_name) then
		script_error("ERROR: construction_tutorial:new() was called but supplied province [" .. tostring(province_name) .. "] is not a string");
		return false;
	end;
	
	if not is_string(start_advice) then
		script_error("ERROR: construction_tutorial:new() was called but supplied start advice key [" .. tostring(start_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_string(start_objective) then
		script_error("ERROR: construction_tutorial:new() was called but supplied start objective key [" .. tostring(start_objective) .. "] is not a string");
		return false;
	end;
	
	if not is_string(base_building_card) then
		script_error("ERROR: construction_tutorial:new() was called but supplied base building card [" .. tostring(base_building_card) .. "] is not a string");
		return false;
	end;
	
	if chain_building_card and not is_string(chain_building_card) then
		script_error("ERROR: construction_tutorial:new() was called but supplied chain building card [" .. tostring(chain_building_card) .. "] is not a string or nil");
		return false;
	end;
	
	if upgrade_building_card and not is_string(upgrade_building_card) then
		script_error("ERROR: construction_tutorial:new() was called but supplied upgrade building card [" .. tostring(upgrade_building_card) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_string(upgrade_objective) then
		script_error("ERROR: construction_tutorial:new() was called but supplied upgrade objective key [" .. tostring(upgrade_objective) .. "] is not a string");
		return false;
	end;
	
	if end_advice and not is_string(end_advice) then
		script_error("ERROR: construction_tutorial:new() was called but supplied end advice key [" .. tostring(end_advice) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_function(completion_callback) then
		script_error("ERROR: construction_tutorial:new() was called but supplied completion callback [" .. tostring(completion_callback) .. "] is not a function");
		return false;
	end;

	local ba = {};

	set_object_class(ba, self);
	
	ba.settlement_name = cm:get_region(region_name):settlement():key();
	ba.province_name = province_name;
	ba.start_advice = start_advice;
	ba.start_objective = start_objective;
	ba.base_building_card = base_building_card;
	ba.chain_building_card = chain_building_card;
	ba.upgrade_building_card = upgrade_building_card;
	ba.upgrade_objective = upgrade_objective;
	ba.end_advice = end_advice;
	ba.completion_callback = completion_callback;
	
	ba.initial_infotext = {};
	ba.settlement_selected_infotext = {};
	ba.rollout_infotext = {};
	ba.completion_infotext = {};
	
	return ba;

end;


function intro_campaign_building_construction_advice:add_initial_infotext(delay, ...)
	if not is_number(delay) then
		script_error("ERROR: add_initial_infotext() called, but supplied delay [" .. tostring(delay) .. "] is not a number");
		return false;
	end;
	
	for i = 1, arg.n do
		local current_infotext = arg[i];
		if not is_string(current_infotext) then
			script_error("ERROR: add_initial_infotext() called but supplied item [" .. i .. "] is not a string, it is a [" .. tostring(current_infotext) .. "]");
			return false;
		else
			table.insert(self.initial_infotext, current_infotext);
		end;
	end;
	
	self.initial_infotext_delay = delay;
end;


function intro_campaign_building_construction_advice:add_settlement_selected_advice(advice_key)	
	if not is_string(advice_key) then
		script_error("ERROR: add_settlement_selected_advice() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	self.settlement_selected_advice = advice_key;
end;


function intro_campaign_building_construction_advice:add_settlement_selected_callback(callback, one_time_only)
	if not is_function(callback) then
		script_error("ERROR: add_settlement_selected_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	one_time_only = not not one_time_only;
	
	self.settlement_selected_callback = callback;
	self.settlement_selected_callback_call_one_time_only = one_time_only;
end;


function intro_campaign_building_construction_advice:add_building_chain_mouseovered_callback(callback, one_time_only)
	if not is_function(callback) then
		script_error("ERROR: add_building_chain_mouseovered_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	one_time_only = not not one_time_only;
	
	self.building_chain_mouseovered_callback = callback;
	self.building_chain_mouseovered_callback_call_one_time_only = one_time_only;
end;


function intro_campaign_building_construction_advice:add_settlement_selected_infotext(...)	
	for i = 1, arg.n do
		local current_infotext = arg[i];
		if not is_string(current_infotext) then
			script_error("ERROR: add_settlement_selected_infotext() called but supplied item [" .. i .. "] is not a string, it is a [" .. tostring(current_infotext) .. "]");
			return false;
		else
			table.insert(self.settlement_selected_infotext, current_infotext);
		end;
	end;
end;


function intro_campaign_building_construction_advice:add_rollout_infotext(...)	
	for i = 1, arg.n do
		local current_infotext = arg[i];
		if not is_string(current_infotext) then
			script_error("ERROR: add_rollout_infotext() called but supplied item [" .. i .. "] is not a string, it is a [" .. tostring(current_infotext) .. "]");
			return false;
		else
			table.insert(self.rollout_infotext, current_infotext);
		end;
	end;
end;


function intro_campaign_building_construction_advice:add_completion_infotext(delay, ...)
	if not is_number(delay) then
		script_error("ERROR: add_completion_infotext() called, but supplied delay [" .. tostring(delay) .. "] is not a number");
		return false;
	end;

	for i = 1, arg.n do
		local current_infotext = arg[i];
		if not is_string(current_infotext) then
			script_error("ERROR: add_completion_infotext() called but supplied item [" .. i .. "] is not a string, it is a [" .. tostring(current_infotext) .. "]");
			return false;
		else
			table.insert(self.completion_infotext, current_infotext);
		end;
	end;
	
	self.completion_infotext_delay = delay;
end;


function intro_campaign_building_construction_advice:set_highlight_altitude(value)
	if not is_number(value) or value < 0 then
		script_error("ERROR: set_highlight_altitude() called but supplied altitude [" .. tostring(value) .. "] is not a positive number");
		return false;
	end;
	
	self.highlight_altitude = value;
end;


function intro_campaign_building_construction_advice:set_allow_non_city_building_upgrades(value)
	if value == false then
		self.allow_non_city_building_upgrades = false;
	else
		self.allow_non_city_building_upgrades = true;
	end;
end;


function intro_campaign_building_construction_advice:start()
	local uim = cm:get_campaign_ui_manager();
	local settlement_name = self.settlement_name;
	
	-- clear selection
	CampaignUI.ClearSelection();

	-- allow building upgrades (non-city building upgrades are still restricted)
	uim:override("building_upgrades"):set_allowed(true);
	
	if self.allow_non_city_building_upgrades then
		uim:override("non_city_building_upgrades"):set_allowed(true);
	end;
	
	-- allow selection of settlement
	uim:enable_settlement_selection_whitelist();
	uim:add_settlement_selection_whitelist(settlement_name);
	
	-- clear infotext
	cm:clear_infotext();
	
	-- advice
	cm:show_advice(self.start_advice);
	
	-- build table of initial infotext and add a call to show the objective chain at the end
	local initial_infotext = self.initial_infotext;
	local infotext_to_add = {};
	
	for i = 1, #initial_infotext do
		infotext_to_add[i] = initial_infotext[i];
	end;
	
	table.insert(infotext_to_add, function() cm:activate_objective_chain(self.listener_name, self.start_objective) end);
	
	cm:add_infotext(1, unpack(infotext_to_add));
	
	if not uim:is_settlement_selected(settlement_name) then
		uim:highlight_settlement_for_selection(settlement_name, self.province_name, function() self:settlement_selected() end, 0, 0, self.highlight_altitude);
	else
		self:settlement_selected();
	end;
end;


function intro_campaign_building_construction_advice:show_settlement_selected_advice_and_infotext()
	if self.settlement_selected_advice_shown then
		return;
	end;
	
	self.settlement_selected_advice_shown = true;
	
	if self.settlement_selected_advice then
		cm:show_advice(self.settlement_selected_advice);
	end;
	
	if #self.settlement_selected_infotext > 0 then
		cm:add_infotext(unpack(self.settlement_selected_infotext));
	end;
end;


function intro_campaign_building_construction_advice:settlement_selected(do_not_update_objective)
	local uim = cm:get_campaign_ui_manager();
	local listener_name = self.listener_name;
	
	-- add more infotext
	self:show_settlement_selected_advice_and_infotext();
	
	-- call settlement selected callback if we have one
	if self.settlement_selected_callback and (not self.settlement_selected_callback_call_one_time_only or not self.settlement_selected_callback_called) then
		self.settlement_selected_callback_called = true;
		self.settlement_selected_callback();
	end;
	
	-- objective
	if not do_not_update_objective then
		cm:update_objective_chain(listener_name, self.upgrade_objective);
	end;
	
	-- highlight building chain
	self:highlight_base_building_card(true);
	
	-- listen for player deselecting settlement
	core:add_listener(
		listener_name,
		"SettlementDeselected",
		true,
		function()
			core:remove_listener(listener_name);
			self:highlight_base_building_card(false);
			cm:update_objective_chain(listener_name, self.start_objective);
			uim:highlight_settlement_for_selection(self.settlement_name, self.province_name, function() self:settlement_selected() end, 0, 0, self.highlight_altitude);
		end,
		false
	);
	
	-- listen for the player mouse-overing the base building chain button
	core:add_listener(
		listener_name,
		"ComponentMouseOn",
		function(context) return uicomponent_descended_from(UIComponent(context.component), self.base_building_card) end,
		function()
			core:remove_listener(listener_name);
			self:highlight_base_building_card(false);
			if self.chain_building_card then
				self:building_chain_with_chain_cards_mouseovered();
				out("BUILDING WITH CHAIN LEVEL")
			else
				self:building_chain_mouseovered();
				out("BUILDING WITHOUT CHAIN LEVEL")
			end
		end,
		false	
	);
	
	-- listen for the player performing the upgrade, as it's (probably) possible for the
	-- player to get here as they could be mousovering the building icon when dismissing the advisor,
	-- thus would never hit the ComponentMouseOn event above as it's already happened
	core:add_listener(
		listener_name,
		"BuildingConstructionIssuedByPlayer",
		true,
		function()
			core:remove_listener(listener_name);
			self:highlight_upgrade_building_card(false);
			self:player_completes_upgrade();
		end,
		false
	);
end;


function intro_campaign_building_construction_advice:highlight_base_building_card(value)
	if value then
		cm:callback(
			function()
				if not self.base_building_card_highlighted then
					self.base_building_card_highlighted = true;
					highlight_component(true, true, "settlement_panel", self.base_building_card);
				end;
			end, 
			0.5, 
			"ct_base_card"
		);
	else
		cm:remove_callback("ct_base_card");
		if self.base_building_card_highlighted then
			highlight_component(false, true, "settlement_panel", self.base_building_card);
			self.base_building_card_highlighted = false;
		end;
	end;
end;

function intro_campaign_building_construction_advice:highlight_chain_building_card(value)
	if value then
		cm:callback(
			function()
				if not self.chain_building_card_highlighted then
					self.chain_building_card_highlighted = true;
					highlight_component(true, true, "construction_popup", self.chain_building_card);
				end;
			end, 
			0.5, 
			"ct_chain_card"
		);
	else
		cm:remove_callback("ct_chain_card");
		if self.chain_building_card_highlighted then
			highlight_component(false, true, "construction_popup", self.chain_building_card);
			self.chain_building_card_highlighted = false;
		end;
	end;
end;


function intro_campaign_building_construction_advice:highlight_upgrade_building_card(value)
	if value then
		cm:callback(
			function()
				if not self.upgrade_building_card_highlighted then
					self.upgrade_building_card_highlighted = true;
					
					-- only actually perform the highlight if we have a card to highlight
					if self.upgrade_building_card then
						if self.chain_building_card then
							highlight_component(true, true, "second_construction_popup", self.upgrade_building_card);
						else
							highlight_component(true, true, "construction_popup", self.upgrade_building_card);
						end
					end;
				end;
			end, 
			0.3, 
			"ct_upgrade_card"
		);
	else
		cm:remove_callback("ct_upgrade_card");
		if self.upgrade_building_card_highlighted then
			self.upgrade_building_card_highlighted = false;
			
			-- only actually perform the unhighlighting if we have a card to unhighlight
			if self.upgrade_building_card then
				if self.chain_building_card then
					highlight_component(false, true, "second_construction_popup", self.upgrade_building_card);
				else
					highlight_component(false, true, "construction_popup", self.upgrade_building_card);
				end
			end;
		end;
	end;
end;



function intro_campaign_building_construction_advice:show_rollout_infotext()
	if self.rollout_infotext_shown then
		return;
	end;
	
	self.rollout_infotext_shown = true;
	
	if #self.rollout_infotext > 0 then
		cm:add_infotext(unpack(self.rollout_infotext));
	end;
end;


function intro_campaign_building_construction_advice:building_chain_with_chain_cards_mouseovered()
	local uim = cm:get_campaign_ui_manager();
	local listener_name = self.listener_name;
	
	self:highlight_chain_building_card(true);
	
	-- listen for the player mouse-overing the chain building button
	core:add_listener(
		listener_name,
		"ComponentMouseOn",
		function(context) return uicomponent_descended_from(UIComponent(context.component), self.chain_building_card) end,
		function()
			core:remove_listener(listener_name);
			self:highlight_chain_building_card(false);
			self:building_chain_card_mouseovered();
		end,
		false	
	);
	
	-- listen for mouseoff -- NOTE: This wont work anymore, should use ComponentMouseOff event instead and change condition. But not used Steve tells me so no way to test, so leaving as is but with comment to ensure no one copies functionality
	core:add_listener(
		listener_name,
		"ComponentMouseOn",
		function(context)
			local retval = context.string ~= self.base_building_card and
				context.string ~= "settlement_capital" and
				not uicomponent_descended_from(UIComponent(context.component), "construction_popup") and 
				not uicomponent_descended_from(UIComponent(context.component), "second_construction_popup");
			if retval then
				out("player has moused off the building chain, uicomponent is " .. uicomponent_to_str(UIComponent(context.component)));
			end;
			return retval;
		end,
		function()
			self:highlight_chain_building_card(false);
			core:remove_listener(listener_name);
			self:settlement_selected(true);
		end,
		false	
	);
end

function intro_campaign_building_construction_advice:building_chain_card_mouseovered()
	local uim = cm:get_campaign_ui_manager();
	local listener_name = self.listener_name;
	
	self:highlight_upgrade_building_card(true);
	
	-- listen for mouseoff	-- NOTE: This wont work anymore, should use ComponentMouseOff event instead and change condition. But not used Steve tells me so no way to test, so leaving as is but with comment to ensure no one copies functionality
	core:add_listener(
		listener_name,
		"ComponentMouseOn",
		function(context)
			local retval = context.string ~= self.chain_building_card and
				context.string ~= "settlement_capital" and
				not uicomponent_descended_from(UIComponent(context.component), "construction_popup") and 
				not uicomponent_descended_from(UIComponent(context.component), "second_construction_popup");
			if retval then
				out("player has moused off the building chain, uicomponent is " .. uicomponent_to_str(UIComponent(context.component)));
			end;
			return retval;
		end,
		function()
			self:highlight_upgrade_building_card(false);
			core:remove_listener(listener_name);
			self:settlement_selected(true);
		end,
		false	
	);
	
	-- listen for player clicking upgrade button
	core:add_listener(
		listener_name,
		"BuildingConstructionIssuedByPlayer",
		true,
		function()
			self:highlight_upgrade_building_card(false);
			core:remove_listener(listener_name);
			self:player_completes_upgrade();
		end,
		false
	);
end


function intro_campaign_building_construction_advice:building_chain_mouseovered()
	local uim = cm:get_campaign_ui_manager();
	local listener_name = self.listener_name;
	
	--infotext
	self:show_rollout_infotext();

	-- highlight the upgrade
	self:highlight_upgrade_building_card(true);
	
	-- call building-chain-mouseovered callback if we have one
	if self.building_chain_mouseovered_callback and (not self.building_chain_mouseovered_callback_call_one_time_only or not self.building_chain_mouseovered_callback_called) then
		self.building_chain_mouseovered_callback_called = true;
		self.building_chain_mouseovered_callback();
	end;
	
	-- listen for mouseoff	-- NOTE: This wont work anymore, should use ComponentMouseOff event instead and change condition. But not used Steve tells me so no way to test, so leaving as is but with comment to ensure no one copies functionality
	core:add_listener(
		listener_name,
		"ComponentMouseOn",
		function(context)
			local retval = context.string ~= self.base_building_card and
				context.string ~= "settlement_capital" and
				not uicomponent_descended_from(UIComponent(context.component), "construction_popup") and 
				not uicomponent_descended_from(UIComponent(context.component), "second_construction_popup");
			if retval then
				out("player has moused off the building chain, uicomponent is " .. uicomponent_to_str(UIComponent(context.component)));
			end;
			return retval;
		end,
		function()
			self:highlight_upgrade_building_card(false);
			core:remove_listener(listener_name);
			self:settlement_selected(true);
		end,
		false	
	);
	
	-- listen for the player deselecting the settlement 
	-- (unsure if this actually possible at this stage)
	core:add_listener(
		listener_name,
		"SettlementDeselected",
		true,
		function()
			self:highlight_upgrade_building_card(false);
			core:remove_listener(listener_name);
			cm:update_objective_chain(listener_name, self.start_objective);
			uim:highlight_settlement_for_selection(self.settlement_name, self.province_name, function() self:settlement_selected() end);
		end,
		false	
	);
	
	-- listen for player clicking upgrade button
	core:add_listener(
		listener_name,
		"BuildingConstructionIssuedByPlayer",
		true,
		function()
			self:highlight_upgrade_building_card(false);
			core:remove_listener(listener_name);
			self:player_completes_upgrade();
		end,
		false
	);
end;


function intro_campaign_building_construction_advice:player_completes_upgrade()
	
	cm:complete_objective(self.upgrade_objective);
	cm:callback(function() cm:end_objective_chain(self.listener_name) end, 2);
	
	-- if we don't have any end advice then proceed immediately
	if not self.end_advice then
		self.completion_callback();
		return;
	end;
	
	cm:show_advice(self.end_advice, true, true);
	
	if #self.completion_infotext > 0 then
		cm:add_infotext(self.completion_infotext_delay, unpack(self.completion_infotext));
	end;
	
	cm:progress_on_advice_dismissed(
		"intro_campaign_building_construction_advice",
		function()
			self.completion_callback();
		end,
		1,
		true
	);
end;
















----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- technologies
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


intro_campaign_technology_advice = {
	listener_name = "technology_advice",
	initial_advice = "",
	initial_infotext = {},
	initial_infotext_delay = 1,
	tech_panel_objective = "",
	tech_objective = "",
	completion_advice = "",
	completion_infotext = {},
	completion_infotext_delay = 1,	
	completion_callback = nil,
	player_is_currently_researching_technology = false,
	highlighted_technologies = {},
	desired_priority = 20,
	cached_advisor_priority = 100,
	cached_objectives_priority = 100
};


set_class_custom_type_and_tostring(intro_campaign_technology_advice, TYPE_INTRO_CAMPAIGN_TECHNOLOGY_ADVICE);


function intro_campaign_technology_advice:new(start_advice, tech_panel_objective, tech_objective, completion_advice, completion_callback)
	if not is_string(start_advice) then
		script_error("ERROR: intro_campaign_technology_advice:new() called but supplied start advice key [" .. tostring(start_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_string(tech_panel_objective) then
		script_error("ERROR: intro_campaign_technology_advice:new() called but supplied technology panel objective [" .. tostring(tech_panel_objective) .. "] is not a string");
		return false;
	end;
	
	if not is_string(tech_objective) then
		script_error("ERROR: intro_campaign_technology_advice:new() called but supplied technology objective [" .. tostring(tech_objective) .. "] is not a string");
		return false;
	end;
	
	if not is_string(completion_advice) then
		script_error("ERROR: intro_campaign_technology_advice:new() called but supplied completion advice [" .. tostring(completion_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_function(completion_callback) then
		script_error("ERROR: intro_campaign_technology_advice:new() called but supplied completion callback [" .. tostring(completion_callback) .. "] is not a callback");
		return false;
	end;
	
	local ta = {};

	set_object_class(ta, self);

	ta.start_advice = start_advice;
	ta.tech_panel_objective = tech_panel_objective;
	ta.tech_objective = tech_objective;
	ta.completion_advice = completion_advice;
	ta.completion_callback = completion_callback;
	ta.highlighted_technologies = {};
	ta.initial_infotext = {};
	ta.completion_infotext = {};
	
	return ta;
end;


function intro_campaign_technology_advice:add_initial_infotext(delay, ...)
	if not is_number(delay) then
		script_error("ERROR: add_initial_infotext() called, but supplied delay [" .. tostring(delay) .. "] is not a number");
		return false;
	end;
	
	for i = 1, arg.n do
		local current_infotext = arg[i];
		if not is_string(current_infotext) then
			script_error("ERROR: add_initial_infotext() called but supplied item [" .. i .. "] is not a string, it is a [" .. tostring(current_infotext) .. "]");
			return false;
		else
			table.insert(self.initial_infotext, current_infotext);
		end;
	end;
	
	self.initial_infotext_delay = delay;
end;


function intro_campaign_technology_advice:add_completion_infotext(delay, ...)
	if not is_number(delay) then
		script_error("ERROR: add_completion_infotext() called, but supplied delay [" .. tostring(delay) .. "] is not a number");
		return false;
	end;
	
	for i = 1, arg.n do
		local current_infotext = arg[i];
		if not is_string(current_infotext) then
			script_error("ERROR: add_completion_infotext() called but supplied item [" .. i .. "] is not a string, it is a [" .. tostring(current_infotext) .. "]");
			return false;
		else
			table.insert(self.completion_infotext, current_infotext);
		end;
	end;
	
	self.completion_infotext_delay = delay;
end;


function intro_campaign_technology_advice:start()
	local uim = cm:get_campaign_ui_manager();
	
	-- allow tech
	uim:override("technology"):set_allowed(true);
	
	-- clear infotext
	cm:clear_infotext();

	-- advice
	cm:show_advice(self.start_advice);
	
	-- build table of initial infotext and add a call to show the objective chain at the end
	local initial_infotext = self.initial_infotext;
	local infotext_to_add = {};
	
	for i = 1, #initial_infotext do
		infotext_to_add[i] = initial_infotext[i];
	end;
	
	table.insert(infotext_to_add, function() cm:activate_objective_chain(self.listener_name, self.tech_panel_objective) end);
	
	cm:add_infotext(self.initial_infotext_delay, unpack(infotext_to_add));
	
	self:cache_and_set_advisor_priority();
	
	self:highlight_technology_button();
end;


function intro_campaign_technology_advice:cache_and_set_advisor_priority()
	core:cache_and_set_advisor_priority(self.desired_priority);
end;


function intro_campaign_technology_advice:restore_advisor_priority()
	core:restore_advisor_priority();
end;


function intro_campaign_technology_advice:highlight_technology_button()
	
	highlight_component(true, false, "faction_buttons_docker", "button_technology");
	
	core:add_listener(
		self.listener_name,
		"PanelOpenedCampaign",
		function(context) return context.string == "technology_panel" end,
		function()
			highlight_component(false, false, "faction_buttons_docker", "button_technology");
			self:technology_panel_opened() 
		end,
		false	
	);
end;


function intro_campaign_technology_advice:is_valid_technology_name(name)
	return string.sub(name, "_tech_");
end;


function intro_campaign_technology_advice:update_technology_state_and_highlight()
	local all_technologies = {};
	local available_technologies = {};
	
	-- default value, will be set to true further down this function if appropriate
	self.player_is_currently_researching_technology = false;
	
	local uic_tech_panel_list_box = find_uicomponent(core:get_ui_root(), "technology_panel", "listview", "list_clip", "list_box");
	
	if not uic_tech_panel_list_box then
		script_error("ERROR: update_technology_state_and_highlight() called but uic_tech_panel_list_box could not be found");
		self.player_is_currently_researching_technology = true;
		return;
	end;
	
	for i = 0, uic_tech_panel_list_box:ChildCount() - 1 do
		local uic_tree = UIComponent(uic_tech_panel_list_box:Find(i));
		local uic_slot_parent = find_uicomponent(uic_tree, "tree_parent", "slot_parent");
		
		if not uic_slot_parent then
			script_error("ERROR: update_technology_state_and_highlight() called but uic_slot_parent could not be found");
			self.player_is_currently_researching_technology = true;
			return;
		end;
		
		for j = 0, uic_slot_parent:ChildCount() - 1 do
			local uic_tech = UIComponent(uic_slot_parent:Find(j));
			
			all_technologies[uic_tech] = true;
			
			local tech_state = uic_tech:CurrentState();
			
			if tech_state == "researching" then
				self.player_is_currently_researching_technology = true;
			elseif tech_state == "available" or tech_state == "hover" then
				available_technologies[uic_tech] = true;			
			end;
		end;
	end;

	local highlighted_technologies = self.highlighted_technologies;
	
	if self.player_is_currently_researching_technology then
		-- unhighlight all highlighted technologies if the player is researching
		for technology_uic, value in pairs(highlighted_technologies) do
			if value then
				technology_uic:Highlight(false, true, 0);
				highlighted_technologies[technology_uic] = false;
			end;
		end;		
	else
		-- unhighlight any currently-highlighted technologies that shouldn't be highlighted
		for technology_uic, value in pairs(highlighted_technologies) do
			if value and not available_technologies[technology_uic] then
				technology_uic:Highlight(false, true, 0);
				highlighted_technologies[technology_uic] = false;
			end;
		end;
		
		-- highlight any currently-available technologies that aren't already highlighted	
		for technology_uic, value in pairs(available_technologies) do
			if not highlighted_technologies[technology_uic] then
				technology_uic:Highlight(true, true, 0);
				highlighted_technologies[technology_uic] = true;
			end;
		end;
	end;
end;


function intro_campaign_technology_advice:technology_panel_opened()

	cm:update_objective_chain(self.listener_name, self.tech_objective);
	
	-- update to highlight available technologies
	self:update_technology_state_and_highlight();
	
	-- player clicks on a technology, update whether they are currently researching or not
	core:add_listener(
		self.listener_name,
		"ComponentLClickUp",
		function(context) return self:is_valid_technology_name(context.string) end,
		function()
			-- wait a little bit for the panel state to update
			cm:callback(
				function()
					self:update_technology_state_and_highlight();
			
					-- highlight close button if we are researching a technology
					highlight_component(self.player_is_currently_researching_technology, false, "technology_panel", "button_ok");
				end,
				0.2
			);
		end,
		true
	);
	
	core:add_listener(
		self.listener_name,
		"PanelClosedCampaign",
		function(context) return context.string == "technology_panel" end,
		function()
			-- if player is currently researching then we're done, otherwise tell player to re-open panel
			core:remove_listener(self.listener_name);
			if self.player_is_currently_researching_technology then
				self:research_started();
			else
				cm:update_objective_chain(self.listener_name, self.tech_panel_objective);
				self:highlight_technology_button();
			end;
		end,
		false
	);
end;


function intro_campaign_technology_advice:research_started()
	local uim = cm:get_campaign_ui_manager();
	
	self:restore_advisor_priority();
	
	-- unhighlight close button
	highlight_component(false, false, "technology_panel", "button_ok");
	
	-- disallow tech
	uim:override("technology"):set_allowed(false)
	
	-- objective
	cm:complete_objective(self.tech_objective);
	cm:callback(function() cm:end_objective_chain(self.listener_name) end, 2);
	
	-- completion advice
	cm:show_advice(self.completion_advice, true);
	
	if #self.completion_infotext > 0 then
		cm:add_infotext(self.completion_infotext_delay, unpack(self.completion_infotext));
	end;
	
	cm:progress_on_advice_dismissed(
		"intro_campaign_technology_advice",
		function()
		cm:callback(function() self.completion_callback() end, 1, true);
		end,
		1,
		true
	);	
end;
























----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- ending turn
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


intro_campaign_end_turn_advice = {
	initial_advice = "",
	initial_infotext = {},
	initial_infotext_delay = 1,
	end_turn_objective = "",
	completion_callback = nil,
	listener_name = "end_turn_advice",
	has_advice_text = true
};


set_class_custom_type_and_tostring(intro_campaign_end_turn_advice, TYPE_INTRO_CAMPAIGN_END_TURN_ADVICE);


function intro_campaign_end_turn_advice:new(initial_advice, end_turn_objective, completion_callback)
	if not is_string(initial_advice) then
		script_error("ERROR: intro_campaign_end_turn_advice:new() was called but supplied advice key [" .. tostring(initial_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_string(end_turn_objective) then
		script_error("ERROR: intro_campaign_end_turn_advice:new() was called but supplied objective key [" .. tostring(end_turn_objective) .. "] is not a string");
		return false;
	end;

	if not is_function(completion_callback) then
		script_error("ERROR: intro_campaign_end_turn_advice:new() was called but supplied completion callback [" .. tostring(completion_callback) .. "] is not a function");
		return false;
	end;

	local ea = {};
	
	set_object_class(ea, self);
	
	ea.initial_advice = initial_advice;
	ea.end_turn_objective = end_turn_objective;
	ea.completion_callback = completion_callback;
	ea.initial_infotext = {};
	
	return ea;
end;

function intro_campaign_end_turn_advice:set_has_advice_text(value)
	self.has_advice_text = value;
end;


function intro_campaign_end_turn_advice:add_infotext(delay, ...)
	if not is_number(delay) then
		script_error("ERROR: add_infotext() called, but supplied delay [" .. tostring(delay) .. "] is not a number");
		return false;
	end;
	
	for i = 1, arg.n do
		local current_infotext = arg[i];
		if not is_string(current_infotext) then
			script_error("ERROR: add_infotext() called but supplied item [" .. i .. "] is not a string, it is a [" .. tostring(current_infotext) .. "]");
			return false;
		else
			table.insert(self.initial_infotext, current_infotext);
		end;
	end;
	
	self.initial_infotext_delay = delay;
end;


function intro_campaign_end_turn_advice:start()
	
	-- clear infotext
	cm:clear_infotext();

	-- advice
	if self.has_advice_text then
		cm:show_advice(self.initial_advice);
		
		-- build table of initial infotext and add a call to show the objective chain at the end
		local initial_infotext = self.initial_infotext;
		local infotext_to_add = {};
		
		for i = 1, #initial_infotext do
			infotext_to_add[i] = initial_infotext[i];
		end;
		
		table.insert(infotext_to_add, function() cm:activate_objective_chain(self.listener_name, self.end_turn_objective) end);
		
		cm:add_infotext(self.initial_infotext_delay, unpack(infotext_to_add));
	end
	
	-- allow the player to end turn
	self.cm:get_campaign_ui_manager():override("end_turn"):set_allowed(true);
	
	-- highlight end turn button
	cm:callback(function() highlight_component(true, false, "button_end_turn") end, 1, "end_turn_highlight");
			
	-- player ends turn
	core:add_listener(
		"player_ends_turn",
		"FactionTurnEnd",
		true,
		function(context) self:turn_ended() end,
		false
	);
end;


function intro_campaign_end_turn_advice:turn_ended()

	-- clean up objectives
	cm:end_objective_chain(self.listener_name);
	
	-- remove UI highlight
	highlight_component(false, false, "button_end_turn");
	
	-- dismiss advice
	cm:dismiss_advice();
	
	-- prevent end turn button from highlighting if it has not already done so
	cm:remove_callback("end_turn_highlight");
	
	self.completion_callback();
end;

