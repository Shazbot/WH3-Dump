



-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	PRELUDE HELPER SCRIPTS
--	This file provides library support for the prelude first turns and early scripts
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

--
--	first-turn ui overrides
--

function set_first_turn_ui_allowed(value, local_faction)
	if core:is_tweaker_set("DISABLE_PRELUDE_CAMPAIGN_SCRIPTS") then
		out("Tweaker DISABLE_PRELUDE_CAMPAIGN_SCRIPTS is set so not setting first-turn ui state");
		return false;
	end;
	
	local cm = get_cm();
	local uim = cm:get_campaign_ui_manager();
	
	uim:override("saving"):set_allowed(value);
	uim:override("missions"):set_allowed(value);
	uim:override("technology"):set_allowed(value);
	uim:override("finance"):set_allowed(value);
	uim:override("diplomacy"):set_allowed(value);
	uim:override("faction_button"):set_allowed(value);
	uim:override("recruit_units"):set_allowed(value);
	uim:override("cancel_recruitment"):set_allowed(value);
	uim:override("dismantle_building"):set_allowed(value);
	uim:override("repair_building"):set_allowed(value);
	uim:override("cancel_construction"):set_allowed(value);
	uim:override("non_city_building_upgrades"):set_allowed(value);
	uim:override("enlist_agent"):set_allowed(value);
	uim:override("raise_army"):set_allowed(value);
	uim:override("recruit_mercenaries"):set_allowed(value);
	uim:override("stances"):set_allowed(value);
	uim:override("book_of_grudges"):set_allowed(value);
	uim:override("offices"):set_allowed(value);
	uim:override("tax_exemption"):set_allowed(value);
	uim:override("end_turn"):set_allowed(value);
	uim:override("building_browser"):set_allowed(value);
	uim:override("diplomacy_double_click"):set_allowed(value);
	uim:override("tactical_map"):set_allowed(value);
	uim:override("character_details"):set_allowed(value);
	uim:override("disband_unit"):set_allowed(value);
	uim:override("ping_clicks"):set_allowed(value);
	uim:override("settlement_renaming"):set_allowed(value);
	
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
	
	uim:suppress_end_turn_warning("bankrupt", should_suppress);
	uim:suppress_end_turn_warning("tech", should_suppress);
	uim:suppress_end_turn_warning("edict", should_suppress);
	uim:suppress_end_turn_warning("character", should_suppress);
	uim:suppress_end_turn_warning("army", should_suppress);
	uim:suppress_end_turn_warning("politics", should_suppress);
	uim:suppress_end_turn_warning("siege", should_suppress);
	uim:suppress_end_turn_warning("morale", should_suppress);
	
	cm:enable_all_diplomacy(value);
	
	if value then
		-- unlocking
		play_component_animation("show", "resources_bar");
		play_component_animation("show", "bar_small_top");
		play_component_animation("show", "radar_things");
		
		uim:disable_character_selection_whitelist();
		uim:disable_settlement_selection_whitelist();
		
		cm:enable_movement_for_faction(local_faction);
	else
		-- locking
		play_component_animation("hide", "faction_buttons_docker");
		
		play_component_animation("hide", "bar_small_top");
		play_component_animation("hide", "radar_things");
		
		uim:enable_character_selection_whitelist();
		uim:enable_settlement_selection_whitelist();
		
		if cm:get_faction(local_faction) then
			cm:disable_movement_for_faction(local_faction);
		end;
	end;
end;



--
--	camera tutorial
--

camera_tutorial = {
	cm = nil,
	end_callback = nil,
	positions = {},
	objective = "war.camp.prelude.ft_camera_tutorial.obj_001",
	infotext = {
		"war.camp.prelude.ft_camera_tutorial.info_004",
		"war.camp.prelude.ft_camera_tutorial.info_005",
		"war.camp.prelude.ft_camera_tutorial.info_006"
	},
	num_positions = 0,
	positions_visited = 0,
	bearing_threshold = 0.25
};


function camera_tutorial:new(end_callback, ...)

	local default_distance_threshold = 9;

	-- check our parameters
	if not is_function(end_callback) then
		script_error("ERROR: camera_tutorial:new() was called but supplied end callback [" .. tostring(end_callback) .. "] is not a function");
		return false;
	end;
	
	if arg.n == 0 then
		script_error("ERROR: camera_tutorial:new() was called but no lookat positions supplied");
		return false;
	end;
	
	for i = 1, arg.n do
		local lookat_position = arg[i];
	
		if not is_table(lookat_position) then
			script_error("ERROR: camera_tutorial:new() was called but supplied lookat position [" .. i .. "] is not a table");
			return false;
		end;
		
		if not is_string(lookat_position.advice) then
			script_error("ERROR: camera_tutorial:new() was called but advice key [" .. tostring(lookat_position.advice) .. "] supplied with lookat position [" .. i .. "] is not a string");
			return false;
		end;
		
		if not is_number(lookat_position.x) then
			script_error("ERROR: camera_tutorial:new() was called but x co-ordinate [" .. tostring(lookat_position.x) .. "] supplied with lookat position [" .. i .. "] is not a number");
			return false;
		end;
		
		if not is_number(lookat_position.y) then
			script_error("ERROR: camera_tutorial:new() was called but y co-ordinate [" .. tostring(lookat_position.y) .. "] supplied with lookat position [" .. i .. "] is not a number");
			return false;
		end;
		
		if not is_campaigncutscene(lookat_position.cutscene) then
			script_error("ERROR: camera_tutorial:new() was called but cutscene [" .. tostring(lookat_position.cutscene) .. "] supplied with lookat position [" .. i .. "] is not a campaign cutscene");
			return false;
		end;
		
		if lookat_position.cutscene:has_end_callback() then
			script_error("WARNING: camera_tutorial:new() was called but cutscene [" .. tostring(lookat_position.cutscene) .. "] supplied with lookat position [" .. i .. "] already has an end callback - this will be overwritten and not called");
			return false;
		end;
		
		if not is_number(lookat_position.threshold_modifier) then
			lookat_position.threshold_modifier = 0;
		end;
		
		lookat_position.threshold_squared = (default_distance_threshold + lookat_position.threshold_modifier) ^ 2;
	end;
	
	local cm = get_cm();
	local ct = {};
	
	setmetatable(ct, self);
	self.__index = self;
	
	ct.cm = cm;
	ct.end_callback = end_callback;
	ct.positions = arg;
	ct.num_positions = arg.n;
	
	return ct;
end;


function camera_tutorial:start()
	self:update();
end;


function camera_tutorial:update()
	-- update the state of the objective
	self:update_objective();
	
	if self.positions_visited >= self.num_positions then
		self:complete();
	else
		self:show_position_markers(true);
		self:camera_check();
	end;
	
end;


function camera_tutorial:update_objective()
	local cm = self.cm;
	local objective = self.objective;
	local positions_visited = self.positions_visited;
	local num_positions = self.num_positions;
	
	if positions_visited < num_positions then
		cm:set_objective(objective, positions_visited, num_positions);
	else
		cm:set_objective(objective, positions_visited, num_positions);
		cm:complete_objective(self.objective);
	end;
end;


--	check if the camera is currently near any of our lookat positions - if so, trigger the
--	associated cutscene, if not, check again in half a second
function camera_tutorial:camera_check()
	local cm = self.cm;
	local x, y, d, b, h = cm:get_camera_position();
			
	for i = 1, #self.positions do
		local current_position = self.positions[i];
				
		if not current_position.visited then
			local distance_to_position_squared = distance_squared(current_position.x, current_position.y, x, y);
		
			if distance_to_position_squared < current_position.threshold_squared then
				cm:remove_callback("camera_tutorial_check");
				current_position.visited = true;
				self:play_cutscene(current_position);
				return;	
			end;
		end;
	end;
	
	-- check again half a second from now
	cm:callback(function() self:camera_check() end, 2, "camera_tutorial_check");
end;


function camera_tutorial:play_cutscene(lookat_position)
	local cm = self.cm;
	local cutscene = lookat_position.cutscene;
	
	-- disable the position markers as we're going into a cutscene
	self:show_position_markers(false);
	
	-- set the cutscene to restore the camera position after playing
	cutscene:set_restore_camera(1.5);
	
	-- show settlement labels and don't close advice
	cutscene:set_disable_settlement_labels(false);
	cutscene:set_dismiss_advice_on_end(false);

	-- play the relevant advice during the cutscene
	cutscene:action(function() self:play_advice(lookat_position) end, 1);
	
	-- try and play advice after the cutscene ends (in case it was skipped) and update to check next advice
	cutscene:set_end_callback(
		function()
			self:play_advice(lookat_position, true);
			self.positions_visited = self.positions_visited + 1;
			self:update();
		end
	);
	
	cutscene:start();
end;


function camera_tutorial:play_advice(lookat_position, is_immediate)
	if not lookat_position.advice_played then
		lookat_position.advice_played = true;
		self.cm:show_advice(lookat_position.advice);
		self:show_next_infotext(is_immediate);
	end;
end;


function camera_tutorial:show_next_infotext(is_immediate)
	local cm = self.cm;
	local add_time = 1;
	
	if is_immediate then
		add_time = 0;
	end;
	
	local infotext = self.infotext;
	local positions_visited = self.positions_visited;

	if positions_visited == 0 then
		cm:add_infotext(add_time, infotext[1], infotext[2]);
	elseif positions_visited == 1 then
		cm:add_infotext(add_time, infotext[3]);
	end;
end;


function camera_tutorial:show_position_markers(should_show)
	local cm = self.cm;
	
	if should_show then
		-- show all markers for positions that have not been visited and are not already marked
		for i = 1, #self.positions do
			local current_position = self.positions[i];

			if not current_position.visited and not current_position.marker_visible then
				local marker_name = "marker_x:" .. current_position.x .. ",y:" .. current_position.y;
				current_position.marker_visible = true;
				cm:add_marker(marker_name, "pointer", current_position.x, current_position.y, 0);
			end;
		end;
	else
		-- remove all currently visible markers		
		for i = 1, #self.positions do
			local current_position = self.positions[i];

			if current_position.marker_visible then
				local marker_name = "marker_x:" .. tostring(current_position.x) .. ",y:" .. tostring(current_position.y);
				current_position.marker_visible = false;
				cm:remove_marker(marker_name);
			end;
		end;
	end;
end;


function camera_tutorial:complete()
	local cm = self.cm;
	cm:modify_advice(true, true);
	cm:progress_on_advice_dismissed(
		"camera_tutorial",
		function() 
			cm:remove_objective(self.objective);
			self.end_callback() 
		end, 
		1
	);
end;










--
--	movement tutorial
--


movement_tutorial = {
	cm = nil,
	end_callback = nil,
	faction_name = "",
	char_cqi = -1,
	x = -1,
	y = -1,
	start_advice = "",
	selection_objective = "",
	movement_objective = "",
	initial_infotext = {"war.camp.prelude.ft_movement_tutorial.info_001", "war.camp.prelude.ft_movement_tutorial.info_002", "war.camp.prelude.ft_movement_tutorial.info_003", "war.camp.prelude.ft_movement_tutorial.info_004"},
	movement_infotext = {"war.camp.prelude.ft_movement_tutorial.info_005"},
	movement_infotext_added = false,
	end_infotext = {},
	end_infotext_added = false,
	movement_marker_shown = false,
	initial_d = 15,
	initial_b = 0,
	initial_h = 12,
	initial_t = 5,
	listener_name = "movement_tutorial"
};


function movement_tutorial:new(faction_name, char_cqi, log_x, log_y, start_advice, selection_objective, movement_objective, end_advice, end_callback)
	
	if not is_string(faction_name) then
		script_error("ERROR: movement_tutorial:new() was called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	local faction = cm:get_faction(faction_name);
	
	if not is_faction(faction) then
		script_error("ERROR: movement_tutorial:new() was called but a faction matching the supplied name [" .. faction_name .. "] could not be found");
		return false;
	end;
	
	if not is_number(char_cqi) then
		script_error("ERROR: movement_tutorial:new() was called but supplied character cqi [" .. tostring(char_cqi) .. "] is not a number");
		return false;
	end;
	
	if not cm:get_character_by_cqi(char_cqi) then
		script_error("ERROR: movement_tutorial:new() was called but a character with supplied character cqi [" .. char_cqi .. "] could not be found");
		return false;
	end;
	
	if not is_number(log_x) or log_x <= 0 then
		script_error("ERROR: movement_tutorial:new() was called but supplied logical x co-ordinate [" .. tostring(log_x) .. "] is not a number > 0");
		return false;
	end;
	
	if not is_number(log_y) or log_y <= 0 then
		script_error("ERROR: movement_tutorial:new() was called but supplied logical y co-ordinate [" .. tostring(log_y) .. "] is not a number > 0");
		return false;
	end;
	
	if not is_string(start_advice) then
		script_error("ERROR: movement_tutorial:new() was called but supplied advice key [" .. tostring(start_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_string(selection_objective) then
		script_error("ERROR: movement_tutorial:new() was called but supplied selection objective [" .. tostring(selection_objective) .. "] is not a string");
		return false;
	end;
	
	if not is_string(movement_objective) then
		script_error("ERROR: movement_tutorial:new() was called but supplied movement objective [" .. tostring(movement_objective) .. "] is not a string");
		return false;
	end;
	
	if not is_string(end_advice) then
		script_error("ERROR: movement_tutorial:new() was called but supplied movement objective [" .. tostring(end_advice) .. "] is not a string");
		return false;
	end;

	if not is_function(end_callback) then
		script_error("ERROR: movement_tutorial:new() was called but supplied end callback [" .. tostring(end_callback) .. "] is not a function");
		return false;
	end;
	
	local cm = get_cm();
	local mt = {};
	
	setmetatable(mt, self);
	self.__index = self;
	
	mt.cm = cm;
	mt.faction_name = faction_name;
	mt.char_cqi = char_cqi;
	mt.logical_x = log_x;
	mt.logical_y = log_y;
	mt.display_x, mt.display_y = cm:log_to_dis(log_x, log_y);
	
	mt.start_advice = start_advice;
	mt.selection_objective = selection_objective;
	mt.movement_objective = movement_objective;
	mt.end_advice = end_advice;
	mt.end_callback = end_callback;
	
	return mt;
end;


function movement_tutorial:get_vip_char()
	return cm:get_character_by_cqi(self.char_cqi);
end;


function movement_tutorial:start()
	local cm = self.cm;
	local char = self:get_vip_char();
	
	-- work out a position halfway between the target character and the destination
	local char_x = char:display_position_x();
	local char_y = char:display_position_y();
	
	local targ_x = char_x - ((char_x - self.display_x) / 2);
	local targ_y = char_y - ((char_y - self.display_y) / 2);
	
	-- pan camera to calculated target
	cm:scroll_camera_with_cutscene(
		self.initial_t, 
		function() self:intro_pan_finished() end,
		{targ_x, targ_y, self.initial_d, self.initial_b, self.initial_h}
	);
	
	-- clear infotext
	cm:clear_infotext();
	
	cm:callback(
		function() 
			cm:show_advice(self.start_advice);
			
			-- build table of initial infotext and add a call to show the objective chain at the end
			local initial_infotext = self.initial_infotext;
			local infotext_to_add = {};
			
			for i = 1, #initial_infotext do
				infotext_to_add[i] = initial_infotext[i];
			end;
			
			table.insert(infotext_to_add, function() cm:activate_objective_chain(self.listener_name, self.selection_objective) end);
			
			cm:add_infotext(1, unpack(infotext_to_add));
		end, 
		1
	);
end;


function movement_tutorial:intro_pan_finished()
	local cm = self.cm;

	-- allow selection of the main army
	cm:get_campaign_ui_manager():add_character_selection_whitelist(self.char_cqi);
	
	local char = self:get_vip_char();
	local char_str = cm:char_lookup_str(char);
	local listener_name = self.listener_name;

	-- allow player to move army
	cm:enable_movement_for_character(char_str);
	
	-- detect when the player's army starts moving
	cm:add_circle_area_trigger(char:display_position_x(), char:display_position_y(), 2, listener_name, char_str, false, true, true);
	
	core:add_listener(
		listener_name .. "_area_exited",
		"AreaExited", 
		function(context) return context.string == listener_name end,
		function(context) 
			core:remove_listener(listener_name);
			self:army_is_moving();
		end, 
		false
	);
	
	self:highlight_character_for_selection();
end;


function movement_tutorial:highlight_character_for_selection()
	local cm = self.cm;
	local uim = cm:get_campaign_ui_manager();

	-- update objective
	cm:update_objective_chain(self.listener_name, self.selection_objective);
	
	-- highlight char for selection
	local char = self:get_vip_char();
	
	if uim:is_char_selected(char) then
		self:army_selected();
	else
		uim:highlight_character_for_selection(char, function() self:army_selected() end);
	end;
end;


function movement_tutorial:army_selected()
	local cm = self.cm;
	local listener_name = self.listener_name;
	
	-- objective
	cm:update_objective_chain(listener_name, self.movement_objective)
			
	-- find the character based on faction and cqi
	local char = self:get_vip_char();
	local char_str = cm:char_lookup_str(char);
	
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
	
	-- add infotext
	self:add_movement_infotext();
	
	-- show marker
	self:show_movement_marker(true);
end;


function movement_tutorial:show_movement_marker(value)
	local cm = self.cm;
	local listener_name = self.listener_name;
	
	if value then
		if not self.movement_marker_shown then
			-- show movement marker
			self.movement_marker_shown = true;
			cm:add_marker(listener_name, "tutorial_marker", self.display_x, self.display_y, 1);
		end;
	else
		if self.movement_marker_shown then
			-- hide movement marker
			self.movement_marker_shown = false;
			cm:remove_marker(listener_name);
		end;
	end;
end;


function movement_tutorial:add_movement_infotext()
	if not self.movement_infotext_added then
		self.movement_infotext_added = true;
		if #self.movement_infotext > 0 then
			self.cm:add_infotext(unpack(self.movement_infotext));
		end;
	end;
end;


function movement_tutorial:army_is_moving()
	local cm = self.cm;
	local char = self:get_vip_char();
	local uim = cm:get_campaign_ui_manager();
	
	-- unhighlight character for selection (in case player deselected immediately after moving)
	uim:unhighlight_character_for_selection(char)
	
	-- re-order the vip army to the target	
	cm:move_character(self.char_cqi, self.logical_x, self.logical_y, true, false, function() self:army_has_arrived(true) end, function() self:army_has_arrived(false) end)
	
	-- lock out ui so that the player cannot interfere
	cm:steal_user_input(true);
end;


function movement_tutorial:army_has_arrived(arrived_cleanly)
	local cm = self.cm;
	local listener_name = self.listener_name;

	if not arrived_cleanly then
		script_error("WARNING: army_has_arrived() called but the army did not arrive cleanly, investigate!");
	end;
	
	-- unlock ui
	cm:steal_user_input(false);
	
	-- remove marker
	self:show_movement_marker(false);
	cm:remove_area_trigger(listener_name);
	
	-- modify infotext
	cm:show_advice(self.end_advice, true, true);
	self:add_end_infotext();
	
	-- objective
	cm:complete_objective(self.movement_objective);
	
	cm:progress_on_advice_dismissed(
		"movement_tutorial",
		function()
			cm:end_objective_chain(listener_name);
			cm:callback(function() self.end_callback() end, 1);
		end
	);
end;


function movement_tutorial:add_end_infotext()
	if not self.end_infotext_added then
		self.end_infotext_added = true;
		if #self.end_infotext > 0 then
			self.cm:add_infotext(unpack(self.end_infotext));
		end;
	end;
end;













--
--	recruitment tutorial
--


recruitment_tutorial = {
	cm = nil,
	faction = "",
	char_cqi = -1,
	end_callback = nil,
	start_advice = "",
	end_advice = "",
	initial_infotext = {
		"war.camp.prelude.ft_recruitment_tutorial.info_001",
		"war.camp.prelude.ft_recruitment_tutorial.info_002"
	},
	recruitment_panel_infotext = {},
	recruitment_panel_infotext_added = false,
	unit_card_infotext = {
		"war.camp.prelude.ft_recruitment_tutorial.info_003",
		"war.camp.prelude.ft_recruitment_tutorial.info_004"
	},
	unit_card_infotext_added = false,
	unit_recruited_infotext = {},
	unit_recruited_infotext_added = false,
	selection_objective = "",
	panel_objective = "war.camp.prelude.ft_recruitment_tutorial.obj_002",
	recruitment_objective = "war.camp.prelude.ft_recruitment_tutorial.obj_003",
	listener_name = "recruitment_tutorial",
	num_recruited = 0,
	recruitment_limit = 0,
	unit_cards_highlighted = false
};


function recruitment_tutorial:new(faction_name, char_cqi, selection_objective, start_advice, recruitment_limit, end_advice, end_callback)
	if not is_string(faction_name) then
		script_error("ERROR: recruitment_tutorial:new() was called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	local faction = cm:get_faction(faction_name);
	
	if not is_faction(faction) then
		script_error("ERROR: recruitment_tutorial:new() was called but a faction matching the supplied name [" .. faction_name .. "] could not be found");
		return false;
	end;
	
	if not is_number(char_cqi) then
		script_error("ERROR: recruitment_tutorial:new() was called but supplied character cqi [" .. tostring(char_cqi) .. "] is not a number");
		return false;
	end;
	
	if not cm:get_character_by_cqi(char_cqi) then
		script_error("ERROR: recruitment_tutorial:new() was called but a character from faction [" .. faction_name .. "] with supplied character cqi [" .. char_cqi .. "] could not be found");
		return false;
	end;
	
	if not is_string(selection_objective) then
		script_error("ERROR: recruitment_tutorial:new() was called but supplied selection objective key [" .. tostring(selection_objective) .. "] is not a string");
		return false;
	end;
	
	if not is_string(start_advice) then
		script_error("ERROR: recruitment_tutorial:new() was called but supplied start advice key [" .. tostring(start_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_number(recruitment_limit) then
		script_error("ERROR: recruitment_tutorial:new() was called but supplied recruitment limit [" .. tostring(recruitment_limit) .. "] is not a number");
		return false;
	end;
	
	if not is_function(end_callback) then
		script_error("ERROR: recruitment_tutorial:new() was called but supplied end callback [" .. tostring(end_callback) .. "] is not a string");
		return false;
	end;
	
	if end_advice and not is_string(end_advice) then
		script_error("ERROR: recruitment_tutorial:new() was called but supplied end advice key [" .. tostring(end_advice) .. "] is not a string or nil");
		return false;
	end;
	
	
	local cm = get_cm();
	
	local rt = {};
	
	setmetatable(rt, self);
	self.__index = self;
	
	rt.cm = cm;
	rt.faction_name = faction_name;
	rt.char_cqi = char_cqi;
	rt.selection_objective = selection_objective;
	rt.start_advice = start_advice;
	rt.recruitment_limit = recruitment_limit;
	rt.end_callback = end_callback;
	rt.end_advice = end_advice;
	
	return rt;
end;



function recruitment_tutorial:start()
	local cm = self.cm;
	local uim = cm:get_campaign_ui_manager();
	
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
	
	cm:add_infotext(1, unpack(infotext_to_add));
	
	-- allow selection of the main army
	cm:get_campaign_ui_manager():add_character_selection_whitelist(self.char_cqi);
	
	-- if the player's army is not selected, highlight it
	local char = cm:get_character_by_cqi(self.char_cqi);
	
	if not uim:is_char_selected(char) then
		uim:highlight_character_for_selection(char, function() self:character_selected() end);
	else
		self:character_selected();
	end;
end;


function recruitment_tutorial:add_recruitment_panel_infotext()
	if self.recruitment_panel_infotext_added then
		return;
	end;
	
	self.recruitment_panel_infotext_added = true;

	self.cm:add_infotext(unpack(self.recruitment_panel_infotext));
end;


function recruitment_tutorial:character_selected()
	local cm = self.cm;
	local uim = cm:get_campaign_ui_manager();
	local listener_name = self.listener_name;

	local char = cm:get_character_by_cqi(self.char_cqi);
	
	cm:update_objective_chain(listener_name, self.panel_objective);
	
	self:add_recruitment_panel_infotext();
	
	-- add a listener for the character being deselected
	core:add_listener(
		listener_name,
		"CharacterDeselected", 
		true,
		function()
			core:remove_listener(listener_name);
			highlight_component(false, true, "button_group_army", "button_recruitment");
			cm:update_objective_chain(listener_name, self.selection_objective);
			local char = cm:get_character_by_cqi(self.char_cqi);
			uim:highlight_character_for_selection(char, function() self:character_selected() end);
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


function recruitment_tutorial:update_recruit_units_objective()
	cm:update_objective_chain(self.listener_name, self.recruitment_objective, self.num_recruited, self.recruitment_limit);
	
	if self.num_recruited == self.recruitment_limit then
		cm:complete_objective(self.recruitment_objective);
	end;
end;


function recruitment_tutorial:add_unit_card_infotext()
	if self.unit_card_infotext_added then
		return;
	end;
	
	self.unit_card_infotext_added = true;

	self.cm:add_infotext(unpack(self.unit_card_infotext));
end;


function recruitment_tutorial:player_opens_recruitment_panel()
	local cm = self.cm;
	local uim = cm:get_campaign_ui_manager();
	local listener_name = self.listener_name;
	
	self:update_recruit_units_objective();
	
	local char = cm:get_character_by_cqi(self.char_cqi);
	
	-- add unit card infotext (once)
	self:add_unit_card_infotext();
		
	-- add highlight for the unit card
	cm:callback(
		function()
			self:highlight_all_unit_cards(true);
		end, 
		0.2, 
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
			
			self:add_unit_recruited_infotext();
			
			if self.num_recruited >= self.recruitment_limit then
				core:remove_listener(listener_name);
				cm:remove_callback("unit_card_highlight");
				self:highlight_all_unit_cards(false);
				
				self:all_units_recruited();
			end;						
		end, 
		true
	);
	
	core:add_listener(
		listener_name,
		"ComponentLClickUp",
		function(context) return component_name_is_enqueued_unit(context.string) end,
		function()
			self.num_recruited = self.num_recruited - 1;
			self:update_recruit_units_objective();
		end,
		true
	);
	
	-- listen for player closing recruitment panel
	core:add_listener(
		listener_name,
		"PanelClosedCampaign", 
		function(context) return context.string == "recruitment" end,
		function()
			core:remove_listener(listener_name);
			cm:remove_callback("unit_card_highlight");
			self:highlight_all_unit_cards(false);
		
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
			core:remove_listener(listener_name);
			cm:remove_callback("unit_card_highlight");
			self:highlight_all_unit_cards(false);
			
			cm:update_objective_chain(listener_name, self.selection_objective);
			local char = cm:get_character_by_cqi(self.char_cqi);
			uim:highlight_character_for_selection(char, function() self:character_selected() end);
		end, 
		false
	);
end;


function recruitment_tutorial:highlight_all_unit_cards(value)
	local cm = self.cm;
	
	if value then
		if self.unit_cards_highlighted then
			return;
		end;
		
		self.unit_cards_highlighted = true;	
	
		local uic_recruitment_list = find_uicomponent(core:get_ui_root(), "main_units_panel", "recruitment_options", "recruitment_listbox", "local", "listview", "list_clip", "list_box");
		
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



-- move to libs somewhere
function component_name_is_enqueued_unit(name)
	return string.sub(name, 1, 14) == "QueuedLandUnit";
end;


function recruitment_tutorial:add_unit_recruited_infotext()
	if self.unit_recruited_infotext_added then
		return;
	end;
	
	self.unit_recruited_infotext_added = true;

	self.cm:add_infotext(unpack(self.unit_recruited_infotext));
end;



function recruitment_tutorial:all_units_recruited()
	local cm = self.cm;
	local uim = cm:get_campaign_ui_manager();
	local listener_name = self.listener_name;
	
	core:remove_listener(listener_name);
	
	-- complete objective
	-- cm:complete_objective(self.recruitment_objective);
	
	-- forbid unit recruitment
	uim:override("recruit_units"):set_allowed(false);
	uim:override("cancel_recruitment"):set_allowed(false);
	
	if self.end_advice then
		cm:callback(
			function()
				-- The recruits will begin their training immediately, Chieftain.
				cm:show_advice(self.end_advice, true, true);
				
				cm:progress_on_advice_dismissed(
					"recruitment_tutorial",
					function()
						cm:end_objective_chain(listener_name);
						cm:callback(function() self.end_callback() end, 1);
					end
				);
			end,
			0.5
		);
		
	else
		self.end_callback();
	end;
end;










--
--	province panel tutorial
--

province_panel_tutorial = {
	cm = nil,
	end_callback = nil,
	listener_name = "province_panel_tutorial",
	start_advice = "",
	initial_infotext = {
		"war.camp.prelude.ft_province_panel_tutorial.info_001",
		"war.camp.prelude.ft_province_panel_tutorial.info_002",
		"war.camp.prelude.ft_province_panel_tutorial.info_003"
	},
	completion_infotext = {
		"war.camp.prelude.ft_province_panel_tutorial.info_004"
	},
	objective = "",
	settlement_name = "",
	region_name = "",
	province_name = ""
};


function province_panel_tutorial:new(start_advice, objective, region_name, province_name, end_callback)
	if not is_string(start_advice) then
		script_error("ERROR: province_panel_tutorial:new() called but supplied startup advice key [" .. tostring(start_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_string(objective) then
		script_error("ERROR: province_panel_tutorial:new() called but supplied objective key [" .. tostring(objective) .. "] is not a string");
		return false;
	end;
	
	if not is_string(region_name) then
		script_error("ERROR: province_panel_tutorial:new() called but supplied region key [" .. tostring(region_name) .. "] is not a string");
		return false;
	end;
	
	local region = cm:get_region(region_name);
	
	if not region then
		script_error("ERROR: province_panel_tutorial:new() called but couldn't find region matching supplied key [" .. region_name .. "]");
		return false;
	end;
	
	if not is_string(province_name) then
		script_error("ERROR: province_panel_tutorial:new() called but supplied province key [" .. tostring(province_name) .. "] is not a string");
		return false;
	end;
	
	if not is_function(end_callback) then
		script_error("ERROR: province_panel_tutorial:new() called but supplied end callback [" .. tostring(end_callback) .. "] is not a function");
		return false;
	end;
	
	local cm = get_cm();
	local pp = {};
	
	setmetatable(pp, self);
	self.__index = self;
	
	pp.cm = cm;
	pp.start_advice = start_advice;
	pp.objective = objective;
	pp.region_name = region_name;
	pp.settlement_name = cm:get_region(region_name):settlement():key();
	pp.province_name = province_name;
	pp.end_callback = end_callback;
	
	return pp;
end;


function province_panel_tutorial:start()
	local cm = self.cm;
	local uim = cm:get_campaign_ui_manager();
	local settlement_name = self.settlement_name;
	
	-- clear selection
	CampaignUI.ClearSelection();
	
	-- allow selection of settlement
	uim:enable_settlement_selection_whitelist();
	uim:add_settlement_selection_whitelist(settlement_name);
	
	-- scroll camera
	local settlement = cm:get_region(self.region_name):settlement();
	local x, y, b, d, h = cm:get_camera_position();
	cm:scroll_camera_with_cutscene(4, nil, {settlement:display_position_x(), settlement:display_position_y(), b, d, h});
	
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
	
	table.insert(infotext_to_add, function() cm:activate_objective_chain(self.listener_name, self.objective) end);
	
	cm:add_infotext(1, unpack(infotext_to_add));
	
	if not uim:is_settlement_selected(settlement_name) then
		uim:highlight_settlement_for_selection(settlement_name, self.province_name, function() self:settlement_selected() end);
	else
		self:settlement_selected();
	end;
end;


function province_panel_tutorial:settlement_selected()
	local cm = self.cm;

	cm:complete_objective(self.objective);
	
	cm:add_infotext(unpack(self.completion_infotext));
	
	cm:modify_advice(true, true);
	
	cm:progress_on_advice_dismissed(
		"province_panel_tutorial",
		function()
			cm:end_objective_chain(self.listener_name);
			cm:callback(function() self.end_callback() end, 1);
		end
	);
end;







--
--	building construction tutorial
--

construction_tutorial = {
	cm = nil,
	listener_name = "construction_tutorial",
	start_advice = "",
	start_objective = "",
	initial_infotext = {
		"war.camp.prelude.ft_construction_tutorial.info_001",
		"war.camp.prelude.ft_construction_tutorial.info_002",
		"war.camp.prelude.ft_construction_tutorial.info_003"
	},
	province_panel_infotext = {
	},
	province_panel_infotext_shown = false,
	rollout_infotext = {
		"war.camp.prelude.ft_construction_tutorial.info_004"
	},
	rollout_infotext_shown = false,
	base_building_card = "",
	base_building_card_highlighted = false,
	upgrade_building_card = "",
	upgrade_building_card_highlighted = false,
	upgrade_objective = "",
	end_advice = "",
	end_callback = nil,
	settlement_name = "",
	province_name = ""
};


function construction_tutorial:new(region_name, province_name, start_advice, start_objective, base_building_card, upgrade_building_card, upgrade_objective, end_advice, end_callback)
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
	
	if not is_string(upgrade_building_card) then
		script_error("ERROR: construction_tutorial:new() was called but supplied upgrade building card [" .. tostring(upgrade_building_card) .. "] is not a string");
		return false;
	end;
	
	if not is_string(upgrade_objective) then
		script_error("ERROR: construction_tutorial:new() was called but supplied upgrade objective key [" .. tostring(upgrade_objective) .. "] is not a string");
		return false;
	end;
	
	if not is_string(end_advice) then
		script_error("ERROR: construction_tutorial:new() was called but supplied end advice key [" .. tostring(end_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_function(end_callback) then
		script_error("ERROR: construction_tutorial:new() was called but supplied end callback [" .. tostring(end_callback) .. "] is not a function");
		return false;
	end;
	
	local cm = get_cm();
	local ct = {};
	
	setmetatable(ct, self);
	self.__index = self;
	
	ct.cm = cm;
	ct.settlement_name = cm:get_region(region_name):settlement():key();
	ct.province_name = province_name;
	ct.start_advice = start_advice;
	ct.start_objective = start_objective;
	ct.base_building_card = base_building_card;
	ct.upgrade_building_card = upgrade_building_card;
	ct.upgrade_objective = upgrade_objective;
	ct.end_advice = end_advice;
	ct.end_callback = end_callback;
	
	return ct;
end;


function construction_tutorial:start()
	local cm = self.cm;
	local uim = cm:get_campaign_ui_manager();
	local settlement_name = self.settlement_name;

	-- allow building upgrades
	uim:override("non_city_building_upgrades"):set_allowed(true);
	
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
		uim:highlight_settlement_for_selection(settlement_name, self.province_name, function() self:settlement_selected() end);
	else
		self:settlement_selected();
	end;
end;



function construction_tutorial:add_province_panel_infotext()
	if self.province_panel_infotext_shown then
		return;
	end;
	
	self.province_panel_infotext_shown = true;
	
	cm:add_infotext(unpack(self.province_panel_infotext));
end;




function construction_tutorial:settlement_selected(do_not_update_objective)
	local cm = self.cm;
	local uim = cm:get_campaign_ui_manager();
	local listener_name = self.listener_name;
	
	-- add more infotext
	self:add_province_panel_infotext();
	
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
			uim:highlight_settlement_for_selection(self.settlement_name, self.province_name, function() self:settlement_selected() end);
		end,
		false
	);
	
	-- listen for the player mouse-overing the base building chain button
	core:add_listener(
		listener_name,
		"ComponentMouseOn",
		function(context) return context.string == self.base_building_card end,
		function()
			core:remove_listener(listener_name);
			self:highlight_base_building_card(false);
			self:building_chain_mouseovered();
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


function construction_tutorial:highlight_base_building_card(value)
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


function construction_tutorial:highlight_upgrade_building_card(value)
	if value then
		cm:callback(
			function()
				if not self.upgrade_building_card_highlighted then
					self.upgrade_building_card_highlighted = true;
					highlight_component(true, true, "construction_popup", self.upgrade_building_card);
				end;
			end, 
			0.3, 
			"ct_upgrade_card"
		);
	else
		cm:remove_callback("ct_upgrade_card");
		if self.upgrade_building_card_highlighted then
			highlight_component(false, true, "construction_popup", self.upgrade_building_card);
			self.upgrade_building_card_highlighted = false;
		end;
	end;
end;


function construction_tutorial:add_rollout_infotext()
	if self.rollout_infotext_shown then
		return;
	end;
	
	self.rollout_infotext_shown = true;
	
	cm:add_infotext(unpack(self.rollout_infotext));
end;



function construction_tutorial:building_chain_mouseovered()
	local cm = self.cm;
	local uim = cm:get_campaign_ui_manager();
	local listener_name = self.listener_name;
	
	--infotext
	self:add_rollout_infotext();

	-- highlight the upgrade
	self:highlight_upgrade_building_card(true);
	
	-- listen for mouseoff
	core:add_listener(
		listener_name,
		"ComponentMouseOn",
		function(context)
			return context.string ~= self.base_building_card and
				-- context.string ~= self.upgrade_building_card and
				context.string ~= "settlement_capital" and
				not uicomponent_descended_from(UIComponent(context.component), "construction_popup");
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



function construction_tutorial:player_completes_upgrade()
	local cm = self.cm;
	
	cm:complete_objective(self.upgrade_objective);
	
	cm:show_advice(self.end_advice, true, true);
	
	cm:progress_on_advice_dismissed(
		"construction_tutorial",
		function()
			cm:end_objective_chain(self.listener_name);
			
			cm:callback(function() self.end_callback() end, 1);
		end	
	);
end;




--
--	technology tutorial
--

technology_tutorial = {
	cm = nil,
	listener_name = "technology_tutorial",
	start_advice = "",
	infotext = {
		"war.camp.prelude.ft_technology_tutorial.info_001",
		"war.camp.prelude.ft_technology_tutorial.info_002",
		"war.camp.prelude.ft_technology_tutorial.info_003",
		"war.camp.prelude.ft_technology_tutorial.info_004"
	},
	tech_panel_objective = "war.camp.prelude.ft_technology_tutorial.obj_001",
	tech_objective = "war.camp.prelude.ft_technology_tutorial.obj_002",
	end_advice = "",
	end_callback = nil,
	player_is_currently_researching_technology = false,
	highlighted_technologies = {},
	desired_priority = 20,
	cached_advisor_priority = 100,
	cached_objectives_priority = 100
};


function technology_tutorial:new(start_advice, end_advice, end_callback)
	if not is_string(start_advice) then
		script_error("ERROR: technology_advice:new() called but supplied start advice [" .. tostring(start_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_string(end_advice) then
		script_error("ERROR: technology_advice:new() called but supplied end advice [" .. tostring(end_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_function(end_callback) then
		script_error("ERROR: technology_advice:new() called but supplied end callback [" .. tostring(end_callback) .. "] is not a callback");
		return false;
	end;
	
	local cm = get_cm();
	
	local tt = {};
	setmetatable(tt, self);
	self.__index = self;
	
	tt.cm = cm;
	tt.start_advice = start_advice;
	tt.end_advice = end_advice;
	tt.end_callback = end_callback;
	tt.highlighted_technologies = {};
	
	return tt;
end;


function technology_tutorial:start()
	local cm = self.cm;
	local uim = cm:get_campaign_ui_manager();
	
	-- allow tech
	uim:override("technology"):set_allowed(true);
	
	-- clear infotext
	cm:clear_infotext();

	-- advice
	cm:show_advice(self.start_advice);
	
	-- build table of initial infotext and add a call to show the objective chain at the end
	local infotext = self.infotext;
	local infotext_to_add = {};
	
	for i = 1, #infotext do
		infotext_to_add[i] = infotext[i];
	end;
	
	table.insert(infotext_to_add, function() cm:activate_objective_chain(self.listener_name, self.tech_panel_objective) end);
	
	cm:add_infotext(1, unpack(infotext_to_add));
	
	self:cache_and_set_advisor_priority();
	
	self:highlight_technology_button();
end;


function technology_tutorial:cache_and_set_advisor_priority()
	core:cache_and_set_advisor_priority(self.desired_priority);
end;


function technology_tutorial:restore_advisor_priority()
	core:restore_advisor_priority();
end;


function technology_tutorial:highlight_technology_button()
	local cm = self.cm;
	
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


function technology_tutorial:is_valid_technology_name(name)
	return string.find(name, "_tech_");
end;


function technology_tutorial:update_technology_state_and_highlight()

	local cm = self.cm;
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


function technology_tutorial:technology_panel_opened()
	local cm = self.cm;

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


function technology_tutorial:research_started()
	local cm = self.cm;
	local uim = cm:get_campaign_ui_manager();
	
	self:restore_advisor_priority();
	
	-- unhighlight close button
	highlight_component(false, false, "technology_panel", "button_ok");
	
	-- disallow tech
	uim:override("technology"):set_allowed(false);
	
	cm:complete_objective(self.tech_objective);
	
	cm:show_advice(self.end_advice, true, true);
	
	cm:progress_on_advice_dismissed(
		"technology_tutorial",
		function()
			cm:end_objective_chain(self.listener_name);
			cm:callback(function() self.end_callback() end, 1);
		end
	);	
end;











--
--	end turn tutorial
--


end_turn_tutorial = {
	cm = nil,
	end_callback = nil,
	start_advice = "",
	infotext = {
		"war.camp.prelude.ft_end_turn_tutorial.info_001",
		"war.camp.prelude.ft_end_turn_tutorial.info_002",
		"war.camp.prelude.ft_end_turn_tutorial.info_003"
	},
	objective = "war.camp.prelude.ft_end_turn_tutorial.001"
};



function end_turn_tutorial:new(start_advice, end_callback)
			
	if not is_string(start_advice) then
		script_error("ERROR: end_turn_tutorial:new() was called but supplied advice key [" .. tostring(start_advice) .. "] is not a string");
		return false;
	end;

	if not is_function(end_callback) then
		script_error("ERROR: end_turn_tutorial:new() was called but supplied end callback [" .. tostring(end_callback) .. "] is not a function");
		return false;
	end;
	
	local cm = get_cm();
	local et = {};
	
	setmetatable(et, self);
	self.__index = self;
	
	et.cm = cm;
	et.start_advice = start_advice;
	et.end_callback = end_callback;
	
	return et;
end;


function end_turn_tutorial:start()
	local cm = self.cm;
	
	-- clear infotext
	cm:clear_infotext();

	-- advice
	cm:show_advice(self.start_advice);
	
	-- add objective chain to infotext
	table.insert(self.infotext, function() cm:activate_objective_chain("end_turn_tutorial", self.objective) end);
	
	-- add infotext
	cm:add_infotext(1, unpack(self.infotext));

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




function end_turn_tutorial:turn_ended()
	local cm = self.cm;

	-- clean up objectives
	cm:end_objective_chain("end_turn_tutorial");
	
	-- remove UI highlight
	highlight_component(false, false, "button_end_turn");
	
	-- dismiss advice
	cm:dismiss_advice();
	
	-- prevent end turn button from highlighting if it has not already done so
	cm:remove_callback("end_turn_highlight");
	
	self.end_callback();
end;
















--
--	first attack enemy mission
--

first_attack_enemy_mission = {
	cm = nil,
	intervention = nil,
	mm = nil,
	start_advice = "",
	mission_key = "",
	player_faction = "",
	enemy_faction = "",
	enemy_mf_cqi = 0,
	player_starting_area = nil,
	end_callback = nil,
	play_advice = true,
	is_active = false,
	initial_camera_duration = 7
};


function first_attack_enemy_mission:new(start_advice, mission_key, player_faction, enemy_faction, enemy_mf_cqi, player_starting_area, end_callback)
	
	if not is_string(start_advice) then
		script_error("ERROR: first_attack_enemy_mission:new() called but supplied start advice [" .. tostring(start_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: first_attack_enemy_mission:new() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(player_faction) then
		script_error("ERROR: first_attack_enemy_mission:new() called but supplied player faction [" .. tostring(player_faction) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_faction(player_faction) then
		script_error("ERROR: first_attack_enemy_mission:new() called but no player faction with supplied key [" .. player_faction .. "] could be found");
		return false;
	end;
	
	if not is_string(enemy_faction) then
		script_error("ERROR: first_attack_enemy_mission:new() called but supplied enemy faction [" .. tostring(enemy_faction) .. "] is not a string");
		return false;
	end;
		
	if not cm:get_faction(enemy_faction) then
		script_error("ERROR: first_attack_enemy_mission:new() called but no enemy faction with supplied key [" .. enemy_faction .. "] could be found");
		return false;
	end;
	
	if not is_number(enemy_mf_cqi) and not is_string(enemy_mf_cqi) then
		script_error("ERROR: first_attack_enemy_mission:new() called but supplied enemy military force cqi [" .. tostring(enemy_mf_cqi) .. "] is not valid");
		return false;
	end;
	
	if not is_convexarea(player_starting_area) then
		script_error("ERROR: first_attack_enemy_mission:new() called but supplied starting area [" .. tostring(player_starting_area) .. "] is not a convex area");
		return false;
	end;
	
	if not is_function(end_callback) and not is_nil(end_callback) then
		script_error("ERROR: first_attack_enemy_mission:new() called but supplied end callback [" .. tostring(end_callback) .. "] is not a function or nil");
		return false;
	end;
		
	local cm = get_cm();
	
	local fm = {};	
	setmetatable(fm, self);
	self.__index = self;
	
	fm.cm = cm;
	fm.start_advice = start_advice;
	fm.mission_key = mission_key;
	fm.player_faction = player_faction;
	fm.enemy_faction = enemy_faction;
	fm.enemy_mf_cqi = enemy_mf_cqi;
	fm.player_starting_area = player_starting_area;
	fm.end_callback = end_callback;
	
	local intervention = intervention:new(
		"first_attack_enemy_mission", 												-- string name
		0, 																			-- cost
		function() fm:trigger() end,												-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
	);
	
	intervention:add_trigger_condition(
		"ScriptEventStartFirstAttackEnemyMission", 
		true
	);
		
	fm.intervention = intervention;
		
	-- if the mission is already active then set up an end turn listener for the enemy faction so that we can modify their behaviour
	local is_active = cm:get_saved_value("first_attack_enemy_mission_active");
	local is_completed = cm:get_saved_value("first_attack_enemy_mission_completed");
	
	fm.is_active = is_active;
	fm.is_completed = is_completed;
	
	if is_active and not is_completed then
		fm.is_active = true;
		
		fm:start_completion_listeners();
		
		if not cm:get_saved_value("first_attack_enemy_mission_scan_terminated") then
			fm:start_end_turn_listener();
		end;
	end;
	
	-- only start the intervention if we're not active or completed
	if not is_active and not is_completed then
		intervention:start();
	end;

	return fm;	
end;


function first_attack_enemy_mission:start(advice_already_played)
	local cm = self.cm;
	
	self.play_advice = not advice_already_played;
	
	core:trigger_event("ScriptEventStartFirstAttackEnemyMission");
end;


function first_attack_enemy_mission:trigger()
	out("first_attack_enemy_mission:trigger() called");
	
	if self.is_active or self.is_completed then
		script_error("WARNING: first_attack_enemy_mission:trigger() called but mission is already active or completed (active:" .. tostring(self.is_active) .. ", completed:" .. tostring(self.is_completed));
		self:intervention_complete();
		return false;
	end;
	
	-- if we don't have a valid character then abort
	if self.enemy_mf_cqi == -1 or not cm:model():has_military_force_command_queue_index(self.enemy_mf_cqi) then
		script_error("ERROR: first_attack_enemy_mission:trigger() called but no valid enemy army specified, skipping");
		self:intervention_complete();
		self:mission_completed();
		return;
	end;
	
	-- get the general character cqi of the military force
	local mf = cm:model():military_force_for_command_queue_index(self.enemy_mf_cqi);
	
	if not mf:has_general() then
		script_error("ERROR: first_attack_enemy_mission:trigger() called but specified enemy army has no general, skipping");
		self:intervention_complete();
		self:mission_completed();
		return;
	end;
	
	local enemy_char_cqi = mf:general_character():cqi();

	local cm = self.cm;
	
	self:start_completion_listeners();
	
	-- build the mission
	local mm = mission_manager:new(self.player_faction, self.mission_key);
	
	mm:add_new_objective("ENGAGE_FORCE");
	mm:add_condition("faction " .. self.enemy_faction);
	mm:add_condition("requires_victory");
	mm:add_condition("armies_only");
	mm:add_payload("money 1000");
	
	-- for Dwarfs, also add some Oathgold
	local faction = cm:get_faction(self.player_faction);
	if faction and faction:culture() == "wh_main_dwf_dwarfs" then
		mm:add_payload("faction_pooled_resource_transaction{resource dwf_oathgold;factor grudges;amount 15;context absolute;}"); -- Oathgold Reward
	elseif faction and faction:culture() == "wh_main_emp_empire" then
		mm:add_payload("faction_pooled_resource_transaction{resource emp_prestige;factor events;amount 300;context absolute;}"); -- Prestige Reward
	end;
	
	self.mm = mm;
	
	self.is_active = true;
	cm:set_saved_value("first_attack_enemy_mission_active", true);
	
	if self.play_advice then	
		cm:show_advice(self.start_advice, true);
		
		cm:scroll_camera_with_cutscene_to_character(
			self.initial_camera_duration, 
			function()
				cm:callback(
					function()
						self.mm:trigger();
						core:trigger_event("ScriptEventFirstAttackEnemyMissionIssued");
						
						if self.intervention:is_another_intervention_queued() then
							cm:progress_on_mission_accepted(function() self:intervention_complete() end, 1);
						else
							self:intervention_complete();
						end;
						
					end, 
					0.5
				);
			end, 
			enemy_char_cqi
		);
	else		
		cm:callback(
			function()
				cm:progress_on_mission_accepted(function() self:intervention_complete() end);			
				self.mm:trigger();
				core:trigger_event("ScriptEventFirstAttackEnemyMissionIssued");
			end, 
			1
		);
	end;
	
	-- show infotext if it's not been seen by the player before
	if not common.get_advice_history_string_seen("prelude_attacking_enemy_advice") then
		common.set_advice_history_string_seen("prelude_attacking_enemy_advice");
		
		cm:add_infotext(1, 
			"war.camp.advice.attacking_enemy.info_001",
			"war.camp.advice.attacking_enemy.info_002",
			"war.camp.advice.attacking_enemy.info_003"
		);
	end;
	
	self:start_end_turn_listener();
end;


function first_attack_enemy_mission:intervention_complete()
	self.intervention:complete();
end;


function first_attack_enemy_mission:start_end_turn_listener()
	core:add_listener(
		"first_attack_enemy_mission",
		"FactionBeginTurnPhaseNormal",
		function(context) return context.string == self.enemy_faction end,
		function()
			self:process_end_turn();
		end,
		true
	);
end;


function first_attack_enemy_mission:process_end_turn()
	local cm = self.cm;

	if cm:get_saved_value("first_attack_enemy_mission_scan_terminated") then
		return;
	end;
	
	local enemy_char = cm:get_character_by_mf_cqi(self.enemy_mf_cqi);
	
	-- stop if the enemy army has disappeared
	if not enemy_char or not enemy_char:has_military_force() then
		cm:enable_movement_for_faction(self.enemy_faction);
		cm:set_saved_value("first_attack_enemy_mission_scan_terminated", true);
		return;
	end;
	
	local pos_enemy_char_display = v_dis(enemy_char);
	
	-- go through each of the player's armies, if they have an army close enough to the enemy then compel it to attack,
	-- otherwise if they have an army outside of the starting zone then allow movement for the enemy.
	local faction = cm:get_faction(self.player_faction);
	
	if not faction then
		cm:enable_movement_for_faction(self.enemy_faction);
		cm:set_saved_value("first_attack_enemy_mission_scan_terminated", true);
		return;
	end;
	
	local military_force_list = faction:military_force_list();
	
	local closest_player_char = nil;
	local closest_player_distance = 90000000;
	
	local player_has_char_outside_starting_area = false;
	
	for i = 0, military_force_list:num_items() - 1 do
		local mf = military_force_list:item_at(i);
		
		if mf:has_general() and not mf:is_armed_citizenry() then
			local current_char = mf:general_character();
			local pos_current_char_display = v_dis(current_char);
			local current_distance = pos_current_char_display:distance(pos_enemy_char_display)
			
			if current_distance < closest_player_distance then
				closest_player_char = current_char;
				closest_player_distance = current_distance;
			end;
			
			-- check if this army is outside the designated starting area
			if not player_has_char_outside_starting_area and not self.player_starting_area:is_in_area(pos_current_char_display) then
				player_has_char_outside_starting_area = true;
			end
		end;
	end;
	
	-- stop if we couldn't find a player character
	if not closest_player_char then
		cm:enable_movement_for_faction(self.enemy_faction);
		cm:set_saved_value("first_attack_enemy_mission_scan_terminated", true);
		return;
	end;
	
	local enemy_char_str = cm:char_lookup_str(enemy_char);
	local player_char_str = cm:char_lookup_str(closest_player_char);

	-- if the closest character has a garrison residence then don't attack
	if closest_player_char:military_force():has_garrison_residence() then
	
		out("first_attack_enemy_mission:process_end_turn() found a player army but it's garrisoned");
		
		-- if it's past turn five just release
		if cm:model():turn_number() > 5 then
			out("\tstopping as it's past the maximum turn threshold");
			cm:enable_movement_for_faction(self.enemy_faction);
			cm:set_saved_value("first_attack_enemy_mission_scan_terminated", true);
			return;
		end
		
		cm:disable_movement_for_character(enemy_char_str);
		return;
	end;
	
	-- if the enemy army can reach the player's army then attack (if they're also within a threshold distance)
	if cm:character_can_reach_character(enemy_char, closest_player_char) then

		-- the enemy are more likely to attack as time goes by
		local distance_threshold = 8 + (cm:model():turn_number() - 1) * 2;
		
		out("first_attack_enemy_mission:process_end_turn() found a player army at a distance of " .. closest_player_distance .. " from the designated enemy army, threshold distance is " .. distance_threshold);
		
		if closest_player_distance < distance_threshold then
			out("\tattacking");
			cm:cai_disable_movement_for_character(enemy_char_str);
			cm:enable_movement_for_character(enemy_char_str);
			cm:replenish_action_points(enemy_char_str);
			cm:attack(enemy_char_str, player_char_str);
			return;
		end;
	end;
	
	-- if the player has a character outside of the starting area then release our enemy character
	if player_has_char_outside_starting_area then
		cm:enable_movement_for_character(enemy_char_str);
		cm:set_saved_value("first_attack_enemy_mission_scan_terminated", true);
		return;
	end;

	cm:disable_movement_for_character(enemy_char_str);
end;


function first_attack_enemy_mission:start_completion_listeners()
	local cm = self.cm;

	core:add_listener(
		"first_attack_enemy_mission",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == self.mission_key end,
		function() self:mission_completed() end,
		false
	);
	
	core:add_listener(
		"first_attack_enemy_mission",
		"MissionFailed",
		function(context) return context:mission():mission_record_key() == self.mission_key end,
		function() self:mission_completed() end,
		false
	);
	
	core:add_listener(
		"first_attack_enemy_mission",
		"MissionCancelled",
		function(context) return context:mission():mission_record_key() == self.mission_key end,
		function() self:mission_completed() end,
		false
	);
end;
	
	
function first_attack_enemy_mission:mission_completed()
	local cm = self.cm;
	
	core:remove_listener("first_attack_enemy_mission");
	cm:enable_movement_for_faction(self.enemy_faction);
	
	self.is_active = false;
	cm:set_saved_value("first_attack_enemy_mission_active", false);
	
	self.is_completed = true;
	cm:set_saved_value("first_attack_enemy_mission_completed", true);
		
	if is_function(self.end_callback) then
		self.end_callback();
	end;
end;









--
--	first capture settlement mission
--


first_capture_settlement_mission = {
	cm = nil,
	mm = nil,
	intervention = nil,
	start_advice = "",
	mission_key = "",
	region_key = "",
	pos_settlement_log = nil,
	player_faction = "",
	enemy_faction = "",
	player_starting_area = nil,
	end_callback = nil,
	is_active = false,
	is_completed = false
};


function first_capture_settlement_mission:new(start_advice, mission_key, region_key, player_faction, enemy_faction, player_starting_area, end_callback)
	
	if not is_string(start_advice) then
		script_error("ERROR: first_capture_settlement_mission:new() called but supplied start advice [" .. tostring(start_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: first_capture_settlement_mission:new() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(region_key) then
		script_error("ERROR: first_capture_settlement_mission:new() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_region(region_key) then
		script_error("ERROR: first_capture_settlement_mission:new() called but no region with supplied key [" .. region_key .. "] could be found");
		return false;
	end;
	
	if not is_string(player_faction) then
		script_error("ERROR: first_capture_settlement_mission:new() called but supplied player faction [" .. tostring(player_faction) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_faction(player_faction) then
		script_error("ERROR: first_capture_settlement_mission:new() called but no faction with supplied key [" .. player_faction .. "] could be found");
		return false;
	end;
	
	if not is_string(enemy_faction) then
		script_error("ERROR: first_capture_settlement_mission:new() called but supplied enemy faction [" .. tostring(enemy_faction) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_faction(enemy_faction) then
		script_error("ERROR: first_capture_settlement_mission:new() called but no faction with supplied key [" .. enemy_faction .. "] could be found");
		return false;
	end;
	
	if not is_convexarea(player_starting_area) then
		script_error("ERROR: first_capture_settlement_mission:new() called but supplied player convex area [" .. player_starting_area .. "] is not a convexarea");
		return false;
	end;
	
	if not is_function(end_callback) and not is_nil(end_callback) then
		script_error("ERROR: first_capture_settlement_mission:new() called but supplied end callback [" .. end_callback .. "] is not a function or nil");
		return false;
	end;
	
	local cm = get_cm();
	
	local fm = {};
	setmetatable(fm, self);
	self.__index = self;
	
	fm.cm = cm;
	
	fm.start_advice = start_advice;
	fm.mission_key = mission_key;
	fm.region_key = region_key;
	fm.player_faction = player_faction;
	fm.enemy_faction = enemy_faction;
	fm.player_starting_area = player_starting_area;
	fm.end_callback = end_callback;
	
	pos_settlement_log = v_log(cm:get_region(region_key):settlement());
	
	fm.pos_settlement_log = pos_settlement_log;
	
	local mm = mission_manager:new(player_faction, mission_key);
	
	mm:add_new_objective("CAPTURE_REGIONS");
	mm:add_condition("region " .. region_key);
	mm:add_payload("money 1000");
	
	-- Pooled resource payloads for the dwarfs and empire
	local faction = cm:get_faction(player_faction);
	if faction and faction:culture() == "wh_main_dwf_dwarfs" then
		mm:add_payload("faction_pooled_resource_transaction{resource dwf_oathgold;factor grudges;amount 15;context absolute;}"); -- Oathgold Reward
	elseif faction and faction:culture() == "wh_main_emp_empire" then
		mm:add_payload("faction_pooled_resource_transaction{resource emp_imperial_authority;factor missions;amount 1;context absolute;}"); -- Imperial Authority Reward
	end;
	
	fm.mm = mm;
	
	local intervention = intervention:new(
		"first_capture_settlement_mission", 										-- string name
		5, 																			-- cost
		function() fm:trigger() end,												-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
	);

	intervention:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart", 
		function() 
			if cm:turn_number() > 5 then
				return true;
			end;
			
			-- return true if any of the player's armies are outside the designated starting area
			--[[
			local faction = cm:get_faction(player_faction);
			local military_force_list = faction:military_force_list();
			
			for i = 0, military_force_list:num_items() - 1 do
				local mf = military_force_list:item_at(i);
				
				if mf:has_general() and not player_starting_area:is_in_area(v_dis(mf:general_character())) then
					out("first_capture_settlement_mission has found a general outside the starting area at log [" .. mf:general_character():logical_position_x() .. ", " .. mf:general_character():logical_position_y() .. "], display [" .. mf:general_character():display_position_x() .. ", " .. mf:general_character():display_position_y() .. "]");
					return true;
				end;
			end;
			return false;
			]]
		end
	);

	intervention:add_trigger_condition(
		"ScriptEventTriggerFirstCaptureSettlementMission",
		true
	);
	
	intervention:set_must_trigger(true);
	
	fm.intervention = intervention;
	
	-- if the mission is already active then start completion listeners
	local is_active = cm:get_saved_value("first_capture_settlement_mission_active");
	local is_completed = cm:get_saved_value("first_capture_settlement_mission_completed");
	
	fm.is_active = is_active;
	fm.is_completed = is_completed;
	
	if is_active and not is_completed then		
		fm:start_completion_listeners();
	end;
	
	-- only start the intervention if we're not active or completed
	if not is_active and not is_completed then
		intervention:start();
	end;
	
	return fm;
end;


function first_capture_settlement_mission:start()
	out("first_capture_settlement_mission:start() called");

	core:trigger_event("ScriptEventTriggerFirstCaptureSettlementMission");
end;


function first_capture_settlement_mission:trigger()

	out("first_capture_settlement_mission:trigger() called");

	if self.is_active or self.is_completed then
		out("mission is already active or completed (active:" .. tostring(self.is_active) .. ", completed:" .. tostring(self.is_completed) .. ")");
		self.intervention:complete();
		return false;
	end;

	local cm = self.cm;
		
	if not cm:is_region_owned_by_faction(self.region_key, self.enemy_faction) then
		out("\tNot triggering capture settlement mission as it's not held by the appointed enemy faction [" .. self.enemy_faction .. "]");
		self:mission_completed();
		self.intervention:complete();
		return;
	end;
	
	self.is_active = true;
	
	
	-- deliver mission
	local advice_level = common.get_advice_level();

	if advice_level == 2 then
		-- high advice
		self.intervention:scroll_camera_to_settlement_for_intervention(
			self.region_key, 
			self.start_advice, 
			nil, 
			self.mm
		);
	
	elseif advice_level == 1 then
		-- low advice
		self.intervention:play_advice_for_intervention(self.start_advice, nil, self.mm);
	
	else
		-- minimal advice
		cm:progress_on_mission_accepted(function() self.intervention:complete() end);			
		self.mm:trigger();
	end;
	
	self:start_completion_listeners();
	cm:set_saved_value("first_capture_settlement_mission_active", true);
end;


function first_capture_settlement_mission:start_completion_listeners()
	local cm = self.cm;

	core:add_listener(
		"first_capture_settlement_mission",
		"MissionSucceeded",
		function(context) return context:mission():mission_record_key() == self.mission_key end,
		function() self:mission_completed() end,
		false
	);
	
	core:add_listener(
		"first_capture_settlement_mission",
		"MissionFailed",
		function(context) return context:mission():mission_record_key() == self.mission_key end,
		function() self:mission_completed() end,
		false
	);
	
	core:add_listener(
		"first_capture_settlement_mission",
		"MissionCancelled",
		function(context) return context:mission():mission_record_key() == self.mission_key end,
		function() self:mission_completed() end,
		false
	);
end;


function first_capture_settlement_mission:mission_completed()
	local cm = self.cm;
	
	out("first_capture_settlement_mission:mission_completed() called");
	
	core:remove_listener("first_capture_settlement_mission");
		
	self.is_active = false;
	cm:set_saved_value("first_capture_settlement_mission_active", false);
	
	self.is_completed = true;
	cm:set_saved_value("first_capture_settlement_mission_completed", true);
		
	if is_function(self.end_callback) then
		self.end_callback();
	end;
end;









--
--	first quest battle mission
--


first_quest_battle_mission = {
	cm = nil,
	mm = nil,
	intervention = nil,
	start_advice = "",
	mission_key = "",
	player_faction = "",
	display_x = 0,
	display_y = 0,
	end_callback = nil,
	is_active = false,
	is_completed = false
};


function first_quest_battle_mission:new(start_advice, mission_key, player_faction, display_x, display_y, end_callback)
	
	if not is_string(start_advice) then
		script_error("ERROR: first_quest_battle_mission:new() called but supplied start advice [" .. tostring(start_advice) .. "] is not a string");
		return false;
	end;
	
	if not is_string(mission_key) then
		script_error("ERROR: first_quest_battle_mission:new() called but supplied mission key [" .. tostring(mission_key) .. "] is not a string");
		return false;
	end;
		
	if not is_string(player_faction) then
		script_error("ERROR: first_quest_battle_mission:new() called but supplied player faction [" .. tostring(player_faction) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_faction(player_faction) then
		script_error("ERROR: first_quest_battle_mission:new() called but no faction with supplied name [" .. player_faction .. "] could be found");
		return false;
	end;
	
	if not is_number(display_x) or display_x < 0 then
		script_error("ERROR: first_quest_battle_mission:new() called but supplied display x co-ordinate [" .. tostring(display_x) .. "] is not a positive number");
		return false;
	end;
	
	if not is_number(display_y) or display_y < 0 then
		script_error("ERROR: first_quest_battle_mission:new() called but supplied display y co-ordinate [" .. tostring(display_y) .. "] is not a positive number");
		return false;
	end;
	
	if not is_function(end_callback) and not is_nil(end_callback) then
		script_error("ERROR: first_quest_battle_mission:new() called but supplied end callback [" .. tostring(end_callback) .. "] is not a function or nil");
		return false;
	end;
	
	local cm = get_cm();
	
	local fm = {};
	setmetatable(fm, self);
	self.__index = self;
	
	fm.cm = cm;
	
	fm.start_advice = start_advice;
	fm.mission_key = mission_key;
	fm.player_faction = player_faction;
	fm.display_x = display_x;
	fm.display_y = display_y;
	
	local intervention = intervention:new(
		"first_quest_battle_mission", 												-- string name
		5, 																			-- cost
		function() fm:trigger() end,												-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
	);
	
	intervention:add_trigger_condition(
		"ScriptEventTriggerFirstQuestBattleMission",
		true
	);
	
	intervention:set_must_trigger(true);
	
	fm.intervention = intervention;
		
	-- if the mission is already active then start completion listeners
	local is_active = cm:get_saved_value("first_quest_battle_mission_active");
	local is_completed = cm:get_saved_value("first_quest_battle_mission_completed");
	
	fm.is_active = is_active;
	fm.is_completed = is_completed;
	
	if is_active and not is_completed then		
		fm:start_completion_listeners();
	end;
	
	-- only start the intervention if we're not active or completed
	if not is_active and not is_completed then
		intervention:start();
	end;
	
	return fm;
end;


function first_quest_battle_mission:start()
	core:trigger_event("ScriptEventTriggerFirstQuestBattleMission");
end;


function first_quest_battle_mission:trigger()

	if self.is_active or self.is_completed then
		script_error("WARNING: first_quest_battle_mission:trigger() called but mission is already active or completed (active:" .. tostring(self.is_active) .. ", completed:" .. tostring(self.is_completed));
		self.intervention:complete();
		return false;
	end;

	local cm = self.cm;
	
	self.is_active = true;

	-- build mission manager
	local mm = mission_manager:new(
		self.player_faction,														-- faction name
		self.mission_key,															-- mission key
		nil													 						-- success callback
	);

	mm:set_is_mission_in_db(true);
	
	self.mm = mm;
	
	local infotext = false;
	
	if not common.get_advice_history_string_seen("quest_battles") then
		common.set_advice_history_string_seen("quest_battles");
	end;
	
	cm:callback(
		function()
			cm:set_saved_value("first_quest_battle_mission_active", true);
			
			local advice_level = common.get_advice_level();
			
			if advice_level == 2 then
				-- high advice
				cm:scroll_camera_with_cutscene(
					3,
					function()
						cm:modify_advice(true);
						
						self:start_completion_listeners();
						
						mm:trigger();
					end,
					{self.display_x, self.display_y, 12.7, 0, 10}
				);
				
				cm:show_advice(self.start_advice);
			
				cm:progress_on_mission_accepted(function() self.intervention:complete() end, 1);
			
			elseif advice_level == 1 then
				-- low advice
				self.intervention:play_advice_for_intervention(self.start_advice, nil, mm);
			else
				-- minimal advice
				cm:progress_on_mission_accepted(function() self.intervention:complete() end);			
				mm:trigger();
			end;
		end,
		1
	);
end;








function first_quest_battle_mission:start_completion_listeners()
	local cm = self.cm;

	core:add_listener(
		"first_quest_battle_mission",
		"MissionSucceeded",
		function(context) return context:mission():mission_record_key() == self.mission_key end,
		function() self:mission_completed() end,
		false
	);
	
	core:add_listener(
		"first_quest_battle_mission",
		"MissionFailed",
		function(context) return context:mission():mission_record_key() == self.mission_key end,
		function() self:mission_completed() end,
		false
	);
	
	core:add_listener(
		"first_quest_battle_mission",
		"MissionCancelled",
		function(context) return context:mission():mission_record_key() == self.mission_key end,
		function() self:mission_completed() end,
		false
	);
end;


function first_quest_battle_mission:mission_completed()
	local cm = self.cm;
	
	core:remove_listener("first_quest_battle_mission");
		
	self.is_active = false;
	cm:set_saved_value("first_quest_battle_mission_active", false);
	
	self.is_completed = true;
	cm:set_saved_value("first_quest_battle_mission_completed", true);
		
	if is_function(self.end_callback) then
		self.end_callback();
	end;
end;





















--
--	public order modifier
--


function modify_public_order_if_unseen(region_str, public_order_modifier, advice_key, province_key, mission_key)
	local cm = get_cm();

	-- only do this if it's not been done before and the player is playing on hard difficulty or easier
	if not common.get_advice_history_string_seen("prelude_public_order_advice") and cm:model():difficulty_level() >= -1 then
		out("modify_public_order_if_unseen() is modifying public order of region " .. region_str .. " by " .. public_order_modifier);

		cm:set_public_order_of_province_for_region(region_str, public_order_modifier);
	end;
end;















-- legendary lord unlocking system
ll_unlock = {
	cm = false,
	faction = "",
	startpos_id = "",
	forename = "",
	event = "",
	condition = false
};

function ll_unlock:new(faction, startpos_id, forename, event, condition)
	if not is_string(faction) then
		script_error("ERROR: ll_unlock:new() called but supplied faction key [" .. tostring(faction) .."] is not a string");
		return false;
	end;
	
	if not is_string(startpos_id) then
		script_error("ERROR: ll_unlock:new() called but supplied startpos_id [" .. tostring(startpos_id) .."] is not a string");
		return false;
	end;
	
	if not is_string(forename) then
		script_error("ERROR: ll_unlock:new() called but supplied forename [" .. tostring(forename) .."] is not a string");
		return false;
	end;
	
	if not is_string(event) then
		script_error("ERROR: ll_unlock:new() called but supplied event [" .. tostring(event) .."] is not a string");
		return false;
	end;

	if not is_function(condition) and not (is_boolean(condition) and condition == true) then
		script_error("ERROR: ll_unlock:new() called but supplied condition [" .. tostring(condition) .. "] is not a function or true");
		return false;
	end;
	
	local cm = get_cm();
	
	local ll = {};
	setmetatable(ll, self);
	self.__index = self;
	
	ll.cm = cm;
	ll.faction = faction;
	ll.startpos_id = startpos_id;
	ll.forename = forename;
	ll.event = event;
	ll.condition = condition;
	
	return ll;
end;

-- start listening for the conditions, then unlock the legendary lord
function ll_unlock:start()
	local cm = self.cm;
	
	if cm:get_saved_value(self.startpos_id .. "_unlocked") then
		out.design("Legendary Lords -- Not starting listener for legendary lord with forename [" .. self.forename .. "] for faction [" .. self.faction .. "] as they have already been unlocked");
		return false;
	end;
	
	if cm:get_saved_value("starting_general_1") ~= self.forename and cm:get_saved_value("starting_general_2") ~= self.forename then
		out.design("Legendary Lords -- Starting listener for legendary lord with forename [" .. self.forename .. "] for faction [" .. self.faction .. "]");
		
		core:add_listener(
			self.startpos_id .. "_listener",
			self.event,
			self.condition,
			function()
				self:unlock();
			end,
			false
		);
	else
		out.design("Legendary Lords -- Not starting listener for legendary lord with forename [" .. self.forename .. "] for faction [" .. self.faction .. "] as the player started with them");
	end;
end;

-- Unlock the lord. This can be called to forcibly execute the lord unlock. An error is thrown if the lord is already present on the map.
function ll_unlock:unlock()
	if char_with_forename_has_no_military_force(self.forename) then
		out.design("Legendary Lords -- Conditions met for event [" .. self.event .. "], unlocking legendary lord with forename [" .. self.forename .. "] for faction [" .. self.faction .. "]");
		
		cm:unlock_starting_character_recruitment(self.startpos_id, self.faction);
		cm:set_saved_value(self.startpos_id .. "_unlocked", true);
		core:remove_listener(self.startpos_id .. "_listener");
	end;
end

-- save the chosen legendary lords so we don't unlock them again later
function store_starting_generals()
	local faction_list = cm:model():world():faction_list();
	local count = 1;
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		if current_faction:is_human() then
			local char_list = current_faction:character_list();
			
			for i = 0, char_list:num_items() - 1 do
				local current_char = char_list:item_at(i);
				
				-- special case: Beastmen and Lokhir have TWO starting armies so have to exclude the regular beastlord and black ark here
				if not (current_char:character_subtype("wh_dlc03_bst_beastlord") or current_char:character_subtype("wh2_main_def_black_ark")) and cm:char_is_general_with_army(current_char) then
					local forename = current_char:get_forename();
				
					out.design("Legendary Lords -- Saving value [" .. tostring(forename) .. "] to [starting_general_" .. count .. "]");
					
					cm:set_saved_value("starting_general_" .. count, forename);
					count = count + 1;
				end;
			end;
		end;
	end;
end;

-- when unlocking starting generals, as a fail safe, ensure that they do not have a military force (are present on the map) before trying to unlock them
-- otherwise catastrophic failures may occur.
function char_with_forename_has_no_military_force(forename)
	local faction_list = cm:model():world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		local char_list = current_faction:character_list();
		
		for i = 0, char_list:num_items() - 1 do
			local current_char = char_list:item_at(i);
			if current_char:get_forename() == forename and current_char:has_military_force() then
				script_error("Tried to unlock legendary lord with forename [" .. forename .. "], but that legendary lord already has a military force (i.e. is on the map) - how can this happen?");
				return false;
			end;
		end;
	end;
	
	return true;
end;






-- returns true if this faction has the ability to research any technologies
-- also returns a region at which they can research, if one can be found
-- WH1-specific
function faction_can_research_technologies(faction_key)
	local faction = cm:get_faction(faction_key);
	
	if not faction then
		script_error("ERROR: faction_can_research_technologies() called but couldn't find a faction with supplied name [" .. faction_key .. "]");
		return false;
	end;
	
	-- if the faction is horde then return true as all horde factions can research tech, but with no settlement specified
	if wh_faction_is_horde(faction) then
		return true, false;
	end;
	
	local greenskins_mapping = {};
	table.insert(greenskins_mapping, "wh_main_grn_workshop_1");
	table.insert(greenskins_mapping, "wh_main_grn_workshop_2");
	
	local empire_mapping = {};
	table.insert(empire_mapping, "wh_main_emp_barracks_2");
	table.insert(empire_mapping, "wh_main_emp_stables_2");
	table.insert(empire_mapping, "wh_main_emp_forges_2");
	table.insert(empire_mapping, "wh_main_emp_smiths_1");
	table.insert(empire_mapping, "wh_main_emp_port_2");
	table.insert(empire_mapping, "wh_main_emp_worship_2");
	table.insert(empire_mapping, "wh_main_emp_barracks_3");
	table.insert(empire_mapping, "wh_main_emp_stables_3");
	table.insert(empire_mapping, "wh_main_emp_forges_3");
	table.insert(empire_mapping, "wh_main_emp_smiths_2");
	
	local subculture_to_building_mapping = {
		["wh_main_sc_grn_greenskins"] = greenskins_mapping,
		["wh_main_sc_emp_empire"] = empire_mapping
	};
	
	local faction_subculture = faction:subculture();
	
	local faction_subculture_to_building_mapping = subculture_to_building_mapping[faction:subculture()];
	
	if faction_subculture_to_building_mapping then
		local region_list = faction:region_list();
		for i = 1, #faction_subculture_to_building_mapping do
			local current_building = faction_subculture_to_building_mapping[i];
			for j = 0, region_list:num_items() - 1 do
				local region = region_list:item_at(j);
				
				if region:building_exists(current_building) then
					return true, region:name();
				end;
			end;
		end;
		
		return false, false;
	end;
	
	-- faction was not in the subculture to building mapping so they have no building-based tech restriction, just need to work out if they have a home region
	if faction:has_home_region() then
		return true, faction:home_region():name();
	end;
	
	return true, false;
end;