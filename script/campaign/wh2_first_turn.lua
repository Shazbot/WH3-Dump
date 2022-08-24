-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	FIRST TURN SCRIPT LIBRARIES
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------





----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- select and attack advice
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

TYPE_INTRO_CAMPAIGN_SELECT_AND_ATTACK_ADVICE = "intro_campaign_select_and_attack_advice";

function is_introcampaignselectandattackadvice(obj)
	if tostring(obj) == TYPE_INTRO_CAMPAIGN_SELECT_AND_ATTACK_ADVICE then
		return true;
	end;
	
	return false;
end;

intro_campaign_select_and_attack_advice = {
	cm = false,
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
	setmetatable(sa, self);
	self.__index = self;
	self.__tostring = function() return TYPE_INTRO_CAMPAIGN_SELECT_AND_ATTACK_ADVICE end;
	
	sa.cm = get_cm();
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
	local cm = self.cm;
		
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
	local cm = self.cm;
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
	local cm = self.cm;
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
	local cm = self.cm;
	
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
	local cm = self.cm;
	
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
	
	local cm = self.cm;
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
	local cm = self.cm;
	
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

TYPE_INTRO_CAMPAIGN_SELECT_ADVICE = "intro_campaign_select_advice";

function is_introcampaignselectadvice(obj)
	if tostring(obj) == TYPE_INTRO_CAMPAIGN_SELECT_ADVICE then
		return true;
	end;
	
	return false;
end;


intro_campaign_select_advice = {
	cm = false,
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
	setmetatable(sa, self);
	self.__index = self;
	self.__tostring = function() return TYPE_INTRO_CAMPAIGN_SELECT_ADVICE end;
	
	sa.cm = get_cm();
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
	local cm = self.cm;
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
	local cm = self.cm;
	
	cm:complete_objective(self.objective_key);
	cm:callback(function() cm:end_objective_chain(self.listener_name) end, 2);
	
	self.completion_callback();
end;









----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- movement advice
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

TYPE_INTRO_CAMPAIGN_MOVEMENT_ADVICE = "intro_campaign_movement_advice";

function is_introcampaignmovementadvice(obj)
	if tostring(obj) == TYPE_INTRO_CAMPAIGN_MOVEMENT_ADVICE then
		return true;
	end;
	
	return false;
end;


intro_campaign_movement_advice = {
	cm = false,
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
	occupy = false,
	play_audio_with_subtitle = false,
	audio_file = "",
	has_advice_text = true,
	play_cutscene = false,
	cindy_file = "",
	cutscene_length = 0,
	unlock_camera = false
};


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
	
	local cm = get_cm();
	
	local ma = {};
	setmetatable(ma, self);
	self.__index = self;
	self.__tostring = function() return TYPE_INTRO_CAMPAIGN_MOVEMENT_ADVICE end;
	
	ma.cm = cm;
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


function intro_campaign_movement_advice:set_join_garrison_key(key)
	if not is_string(key) then
		script_error("ERROR: set_join_garrison_key() called but supplied key [" .. tostring(key) .. "] is not a string");
		return false;
	end;
	
	self.join_garrison_key = key;
end;

function intro_campaign_movement_advice:set_occupy(value)
	self.occupy = value;
end;

function intro_campaign_movement_advice:set_unlock_camera(value)
	self.unlock_camera = value;
end;

function intro_campaign_movement_advice:set_play_cutscene(value, file, length)
	self.play_cutscene = value;
	self.cindy_file = file;
	self.cutscene_length = length;
end;

function intro_campaign_movement_advice:set_has_advice_text(value)
	self.has_advice_text = value;
end;

function intro_campaign_movement_advice:set_play_audio_with_subtitle(value, audio_file)
	if not is_string(audio_file) then
		script_error("ERROR: set_play_audio_with_subtitle() called but supplied audio_file [" .. tostring(audio_file) .. "] is not a string");
		return false;
	end;
	
	self.play_audio_with_subtitle = value;
	self.audio_file = audio_file;
end

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
	local cm = self.cm;
	
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
	
	if self.camera_follow then
		-- pan camera to calculated target
			
		cm:scroll_camera_with_cutscene(
			self.initial_t, 
			function() self:intro_pan_finished() end,
			{targ_x, targ_y, self.initial_d, self.initial_b, self.initial_h}
		);
	else
		self:intro_pan_finished();
	end
	
	-- show advice and infotext
	cm:callback(
		function()
			if self.has_advice_text then
				cm:show_advice(self.advice_key);
			end
				
			-- build table of initial infotext and add a call to show the objective chain at the end
			local infotext_to_add = {};
			
			for i = 1, #self.infotext do
				infotext_to_add[i] = self.infotext[i];
			end;
			
			table.insert(infotext_to_add, function() cm:activate_objective_chain(self.listener_name, self.selection_objective_key) end);
			
			cm:add_infotext(self.infotext_delay, unpack(infotext_to_add));
		end, 
		1
	);
end;


function intro_campaign_movement_advice:intro_pan_finished()
	local cm = self.cm;

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
	local cm = self.cm;
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
	local cm = self.cm;
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
	local cm = self.cm;
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
	local cm = self.cm;
	local player_char = cm:get_character_by_cqi(self.player_cqi);
	local uim = cm:get_campaign_ui_manager();
	
	cm:dismiss_advice();
	
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
	elseif self.occupy then
		out("TIME TO COLONISE")
		
		-- listen for the character arriving
		core:add_listener(
			"intro_campaign_movement_advice_occupy",
			"CharacterPerformsSettlementOccupationDecision",
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
	
	-- go into cutscene mode and follow the player army
	if self.camera_follow then
		CampaignUI.ClearSelection();
		self:play_camera_follow(self.camera_follow_start_x, self.camera_follow_start_y, self.camera_follow_start_d, self.camera_follow_start_b, self.camera_follow_start_h, self.camera_follow_end_x, self.camera_follow_end_y, self.camera_follow_end_d, self.camera_follow_end_b, self.camera_follow_end_h);
	end
	
	
	if self.play_cutscene then
		local cutscene_intro = campaign_cutscene:new(
			"prologue_intro2",
			self.cutscene_length
			);
			
			-- cutscene_intro:set_debug();
			--cutscene_intro:set_skippable(true);
			--cutscene_intro:set_skip_camera(end_x, end_y, end_d, end_b, end_h);
			cutscene_intro:set_disable_settlement_labels(false);
			cutscene_intro:set_dismiss_advice_on_end(false);
			cutscene_intro:set_restore_shroud(false);
			--cutscene_intro:set_restore_ui(false);
			
			
			cutscene_intro:action(
				function()
					--cm:set_camera_position(266.031555, 52.097626, 9.999299, -0.112998, 7.550781);
					cutscene_intro:cindy_playback("script/campaign/wh3_test_empire_easy/factions/wh_main_emp_talabecland/scenes/scene_file_"..self.cindy_file..".CindyScene", true, true);
				end,
				0
			);
			
			cutscene_intro:action(
				function()

				end,
				1
			);
		
		cutscene_intro:start();
	end
	
	-- lock out ui so that the player cannot interfere
	if self.unlock_camera then
		cm:get_campaign_ui_manager():override("giving_orders"):lock();
	else
		cm:steal_user_input(true);
	end
end;


function intro_campaign_movement_advice:army_has_arrived(arrived_cleanly)
	local cm = self.cm;
	local listener_name = self.listener_name;

	if not arrived_cleanly then
		script_error("WARNING: army_has_arrived() called but the army did not arrive cleanly, investigate!");
	end;
	
	-- zero player army AP, so that it can't move again
	cm:zero_action_points(cm:char_lookup_str(self.player_cqi));
	
	-- unlock ui
	if self.unlock_camera then
		cm:get_campaign_ui_manager():override("giving_orders"):unlock();
	else
		cm:steal_user_input(false);
	end
	
	-- remove marker
	self:show_movement_marker(false);
	cm:remove_area_trigger(listener_name);
	
	-- objective
	cm:complete_objective(self.movement_objective_key);
	cm:callback(function() cm:end_objective_chain(listener_name) end, 2);
	
	if self.play_audio_with_subtitle then
		cm:callback(function() self.completion_callback() end, 11);
	elseif self.play_cutscene then
		cm:callback(function() self.completion_callback() end, 2);
	else
		self.completion_callback();
	end
end;


function intro_campaign_movement_advice:play_camera_follow(start_x, start_y, start_d, start_b, start_h, end_x, end_y, end_d, end_b, end_h)
	
	local cutscene_intro = campaign_cutscene:new(
		"campaign_intro",
		5
		
	);

	-- cutscene_intro:set_debug();
	cutscene_intro:set_disable_settlement_labels(false);
	cutscene_intro:set_dismiss_advice_on_end(false);
	
	cutscene_intro:action(
		function()
			cm:set_camera_position(start_x, start_y, start_d, start_b, start_h);
		end,
		0
	);
	
	cm:callback(
		function()
			if not self.play_audio_with_subtitle and self.has_advice_text then 
				-- The enemy close on our outpost in number, my Lord! We must look to our defence, and soon!
				-- cm:show_advice("wh3_intro_camp_100");
			end
		end,
		2
	);
	
	cutscene_intro:action(
		function()
			if self.play_audio_with_subtitle then
				cm:show_advice(self.audio_file, true)
				--local wh2_main_sfx_01 = new_sfx(self.audio_file);
				--cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);
			end
			cm:scroll_camera_from_current(true, 5, {end_x, end_y, end_d, end_b, end_h});
		end,
		0.5
	);
	
	cutscene_intro:action(
		function()
			if not self.play_audio_with_subtitle and self.has_advice_text then 
				-- This must be the place, my Lord. At long last, this must be the cauldron of which the legends speak!
				-- cm:show_advice("wh3_intro_camp_001");
			end
		end,
		1
	);
	cutscene_intro:start();

end





















----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- recruitment tutorial
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

TYPE_INTRO_CAMPAIGN_RECRUITMENT_ADVICE = "intro_campaign_recruitment_advice";

function is_introcampaignrecruitmentadvice(obj)
	if tostring(obj) == TYPE_INTRO_CAMPAIGN_RECRUITMENT_ADVICE then
		return true;
	end;
	
	return false;
end;


intro_campaign_recruitment_advice = {
	cm = nil,
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
	
	local cm = get_cm();

	local rt = {};
	
	setmetatable(rt, self);
	self.__index = self;
	self.__tostring = function() return TYPE_INTRO_CAMPAIGN_RECRUITMENT_ADVICE end;
	
	rt.cm = cm;
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
	local cm = self.cm;
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
	local cm = self.cm;
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
	local cm = self.cm;
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
	local cm = self.cm;

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
	local cm = self.cm;
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

TYPE_INTRO_CAMPAIGN_SELECT_SETTLEMENT_ADVICE = "intro_campaign_select_settlement_advice";

function is_introcampaignselectsettlementadvice(obj)
	if tostring(obj) == TYPE_INTRO_CAMPAIGN_SELECT_SETTLEMENT_ADVICE then
		return true;
	end;
	
	return false;
end;


intro_campaign_select_settlement_advice = {
	cm = nil,
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
	prevent_deselection_on_selection = true,
	play_cutscene = true,
	has_advice_text = true
};


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
	
	local cm = get_cm();

	local sa = {};
	
	setmetatable(sa, self);
	self.__index = self;
	self.__tostring = function() return TYPE_INTRO_CAMPAIGN_SELECT_SETTLEMENT_ADVICE end;
	
	sa.cm = cm;
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

function intro_campaign_select_settlement_advice:set_play_cutscene(value)
	self.play_cutscene = value;
end;

function intro_campaign_select_settlement_advice:set_has_advice_text(value)
	self.has_advice_text = value;
end;


function intro_campaign_select_settlement_advice:start()
	local cm = self.cm;
	local uim = cm:get_campaign_ui_manager();
	local settlement_name = self.settlement_name;
	
	-- clear selection
	CampaignUI.ClearSelection();
	
	-- allow selection of settlement
	uim:enable_settlement_selection_whitelist();
	uim:add_settlement_selection_whitelist(settlement_name);
	
	if self.play_cutscene then
		-- scroll camera
		local settlement = cm:get_region(self.region_name):settlement();
		local x, y = cm:get_camera_position();
		cm:scroll_camera_with_cutscene(4, nil, {settlement:display_position_x(), settlement:display_position_y(), self.zoom_to_d, self.zoom_to_b, self.zoom_to_h});
	end
	
	-- clear infotext
	cm:clear_infotext();
	
	if self.has_advice_text then
		-- advice	
		cm:show_advice(self.initial_advice);
	end
	
	-- build table of initial infotext and add a call to show the objective chain at the end
	local initial_infotext = self.initial_infotext;
	local infotext_to_add = {};
	
	for i = 1, #initial_infotext do
		infotext_to_add[i] = initial_infotext[i];
	end;
	
	table.insert(infotext_to_add, function() cm:activate_objective_chain(self.listener_name, self.selection_objective) end);
	
	cm:add_infotext(self.initial_infotext_delay, unpack(infotext_to_add));
	
	
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
	local cm = self.cm;
	
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

TYPE_INTRO_CAMPAIGN_PANEL_HIGHLIGHT_ADVICE = "intro_campaign_panel_highlight_advice";

function is_introcampaignpanelhighlightadvice(obj)
	if tostring(obj) == TYPE_INTRO_CAMPAIGN_PANEL_HIGHLIGHT_ADVICE then
		return true;
	end;
	
	return false;
end;


intro_campaign_panel_highlight_advice = {
	cm = nil,
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
	
	local cm = get_cm();
	local ui_root = core:get_ui_root();
	local uicomponents = {};
			
	local pa = {};
	
	setmetatable(pa, self);
	self.__index = self;
	self.__tostring = function() return TYPE_INTRO_CAMPAIGN_PANEL_HIGHLIGHT_ADVICE end;
	
	pa.cm = cm;
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
	local cm = self.cm;
		
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
	local cm = self.cm;
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
	local cm = self.cm;
	
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

TYPE_INTRO_CAMPAIGN_BUILDING_CONSTRUCTION_ADVICE = "intro_campaign_building_construction_advice";

function is_introcampaignbuildingconstructionadvice(obj)
	if tostring(obj) == TYPE_INTRO_CAMPAIGN_BUILDING_CONSTRUCTION_ADVICE then
		return true;
	end;
	
	return false;
end;


intro_campaign_building_construction_advice = {
	cm = nil,
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
	
	local cm = get_cm();
	local ba = {};
	
	setmetatable(ba, self);
	self.__index = self;
	self.__tostring = function() return TYPE_INTRO_CAMPAIGN_BUILDING_CONSTRUCTION_ADVICE end;
	
	ba.cm = cm;
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
	local cm = self.cm;
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
	local cm = self.cm;
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
			else
				self:building_chain_mouseovered();
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
	local cm = self.cm;
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
	
	-- listen for mouseoff		-- NOTE: This wont work anymore, should use ComponentMouseOff event instead and change condition. But not used Steve tells me so no way to test, so leaving as is but with comment to ensure no one copies functionality
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
	local cm = self.cm;
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
	local cm = self.cm;
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
	local cm = self.cm;
	
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

TYPE_INTRO_CAMPAIGN_TECHNOLOGY_ADVICE = "intro_campaign_technology_advice";

function is_introcampaigntechnologyadvice(obj)
	if tostring(obj) == TYPE_INTRO_CAMPAIGN_TECHNOLOGY_ADVICE then
		return true;
	end;
	
	return false;
end;


intro_campaign_technology_advice = {
	cm = nil,
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
	
	local cm = get_cm();
	
	local ta = {};
	setmetatable(ta, self);
	self.__index = self;
	self.__tostring = function() return TYPE_INTRO_CAMPAIGN_TECHNOLOGY_ADVICE end;
	
	ta.cm = cm;
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
	local cm = self.cm;
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


function intro_campaign_technology_advice:is_valid_technology_name(name)
	return string.match(name, "_tech_");
end;


function intro_campaign_technology_advice:update_technology_state_and_highlight()
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


function intro_campaign_technology_advice:technology_panel_opened()
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


function intro_campaign_technology_advice:research_started()
	local cm = self.cm;
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

TYPE_INTRO_CAMPAIGN_END_TURN_ADVICE = "intro_campaign_end_turn_advice";

function is_introcampaignendturnadvice(obj)
	if tostring(obj) == TYPE_INTRO_CAMPAIGN_END_TURN_ADVICE then
		return true;
	end;
	
	return false;
end;


intro_campaign_end_turn_advice = {
	cm = nil,
	initial_advice = "",
	initial_infotext = {},
	initial_infotext_delay = 1,
	end_turn_objective = "",
	completion_callback = nil,
	listener_name = "end_turn_advice",
	has_advice_text = true
};


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
	
	local cm = get_cm();
	local ea = {};
	
	setmetatable(ea, self);
	self.__index = self;
	self.__tostring = function() return TYPE_INTRO_CAMPAIGN_END_TURN_ADVICE end;
	
	ea.cm = cm;
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
	local cm = self.cm;
	
	-- clear infotext
	cm:clear_infotext();

	-- advice
	if self.has_advice_text then
		cm:show_advice(self.initial_advice);
	end
		
	-- build table of initial infotext and add a call to show the objective chain at the end
	local initial_infotext = self.initial_infotext;
	local infotext_to_add = {};
	
	for i = 1, #initial_infotext do
		infotext_to_add[i] = initial_infotext[i];
	end;
	
	table.insert(infotext_to_add, function() cm:activate_objective_chain(self.listener_name, self.end_turn_objective) end);
	
	cm:add_infotext(self.initial_infotext_delay, unpack(infotext_to_add));
	
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
	local cm = self.cm;

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















----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- finance highlight wrapper
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


function start_finances_first_turn_advice_wrapper(money_advice_key, money_infotext, end_callback)

	if not is_string(money_advice_key) then
		script_error("ERROR: start_finances_first_turn_advice_wrapper() called but supplied advice key [" .. tostring(money_advice_key) .. "] is not a string");
		return false;
	end;

	if money_infotext and not is_table(money_infotext) then
		script_error("ERROR: start_finances_first_turn_advice_wrapper() called but supplied infotext [" .. tostring(money_infotext) .. "] is not a table or nil");
		return false;
	end;
	
	if not is_function(end_callback) then
		script_error("ERROR: start_finances_first_turn_advice_wrapper() called but supplied end callback [" .. tostring(end_callback) .. "] is not a function");
		return false;
	end;
	
	local cm = get_cm();
	local uim = cm:get_campaign_ui_manager();
	
	-- clear selection
	CampaignUI.ClearSelection();
	
	-- show the resources bar
	uim:display_resources_bar(true);
		
	-- wait a little bit for the resources bar to animate on screen
	cm:callback(
		function()		
		
			-- get a handle to the resources bar
			local uic_resources_bar = find_uicomponent(core:get_ui_root(), "resources_bar");
			if not uic_resources_bar then
				script_error("ERROR: start_finances_first_turn_advice_wrapper() can't find uic_resources_bar, how can this be?");
				return;
			end;
			
			-- get a handle to the treasury
			local uic_treasury = find_uicomponent(uic_resources_bar, "dy_treasury");
			if not uic_treasury then
				script_error("ERROR: start_finances_first_turn_advice_wrapper() can't find uic_treasury, how can this be?");
				return;
			end;
			
			-- get a handle to the per-turn income
			local uic_income = find_uicomponent(uic_resources_bar, "dy_income");
			if not uic_income then
				script_error("ERROR: start_finances_first_turn_advice_wrapper() can't find uic_income, how can this be?");
				return;
			end;
		
			local treasury_size_x, treasury_size_y = uic_treasury:Dimensions();
			local treasury_pos_x, treasury_pos_y = uic_treasury:Position();
			
			local income_size_x, income_size_y = uic_income:Dimensions();
			local income_pos_x, income_pos_y = uic_income:Position();
			
			
			
			-- check/compensate for the positions being so close to the left of the screen that they collide with the advisor - use fallback positions in this case
			local treasury_final_x = treasury_pos_x + (treasury_size_x / 2);
			local treasury_final_y = treasury_pos_y + treasury_size_y;
			
			local income_final_x = income_pos_x + (income_size_x / 2);
			local income_final_y = income_pos_y + income_size_y;
			
			local treasury_pointer_length = 240;
			local income_pointer_length = 100;
			
			local income_label_offset = 120;
			
			local treasury_offset_x = 50;
			
			if treasury_final_x < 390 then
				treasury_final_x = 390;
				treasury_pointer_length = 340;
				income_pointer_length = 220;
				treasury_offset_x = 115;
				
				if income_final_x < 395 then
					income_final_x = 395;
					income_label_offset = 135;
				end;
			end;
			
			-- set up text pointers
			local tp_treasury = text_pointer:new("treasury", "top", treasury_pointer_length, treasury_final_x, treasury_final_y);
			tp_treasury:set_layout("text_pointer_title_and_text")
			tp_treasury:add_component_text("title", "ui_text_replacements_localised_text_wh2_intro_campaign_treasury_title");
			tp_treasury:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_treasury_description");
			tp_treasury:set_style("semitransparent");
			tp_treasury:set_label_offset(treasury_offset_x, 0);
			tp_treasury:set_panel_width(250);
			
			local tp_income = text_pointer:new("income", "top", income_pointer_length, income_final_x, income_final_y);
			tp_income:set_layout("text_pointer_title_and_text")
			tp_income:add_component_text("title", "ui_text_replacements_localised_text_wh2_intro_campaign_income_title");
			tp_income:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_income_description");
			tp_income:set_style("semitransparent");
			tp_income:set_label_offset(120, 0);
			tp_income:set_panel_width(300);
			
			-- set up panel highlight
			local pa = intro_campaign_panel_highlight_advice:new(
				money_advice_key,
				function()
					cm:remove_callback("start_finances_first_turn_advice_wrapper");
					
					tp_treasury:hide();
					tp_income:hide();
					
					end_callback();
				end,
				{"resources_bar"}
			);
			
			-- pa:set_show_advisor_dismiss_button(false);
			-- pa:set_allow_reselection_on_end(false);
			
			pa:add_infotext(unpack(money_infotext));
		
			pa:start();
	
			-- show text pointers
			cm:callback(
				function() 
					tp_treasury:show();
					tp_income:show();
				end, 
				1,
				"start_finances_first_turn_advice_wrapper"
			);
		end,	
		0.5
	);
end;







----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- province overview panel and province info panel highlight wrappers
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


function start_province_overview_panel_first_turn_advice_chain_wrapper(province_overview_panel_advice_key, foreign_settlements_advice_key, capital_city_advice_key, end_callback, foreign_settlement_is_ruin)

	if not is_string(province_overview_panel_advice_key) then
		script_error("ERROR: start_province_overview_panel_first_turn_advice_chain_wrapper() called but supplied advice key [" .. tostring(province_overview_panel_advice_key) .. "] is not a string");
		return false;
	end;
	
	if foreign_settlements_advice_key and not is_string(foreign_settlements_advice_key) then
		script_error("ERROR: start_province_overview_panel_first_turn_advice_chain_wrapper() called but supplied advice key [" .. tostring(foreign_settlements_advice_key) .. "] is not a string or nil");
		return false;
	end;
	
	if capital_city_advice_key and not is_string(capital_city_advice_key) then
		script_error("ERROR: start_province_overview_panel_first_turn_advice_chain_wrapper() called but supplied advice key [" .. tostring(capital_city_advice_key) .. "] is not a string or nil");
		return false;
	end;
	
	if not is_function(end_callback) then
		script_error("ERROR: start_province_overview_panel_first_turn_advice_chain_wrapper() called but supplied end callback [" .. tostring(end_callback) .. "] is not a function");
		return false;
	end;

	-- get a handle to the main settlement panel component
	local uic_main_settlement_panel = find_uicomponent(core:get_ui_root(), "settlement_panel", "main_settlement_panel");
	if not uic_main_settlement_panel then
		script_error("ERROR: start_province_overview_panel_first_turn_advice_chain_wrapper() can't find uic_main_settlement_panel, how can this be?");
		return;
	end;
	
	local uic_building = find_uicomponent(core:get_ui_root(), "settlement_panel", "main_settlement_panel", "capital", "building_slot_1");
	if not uic_building then
		script_error("ERROR: start_province_overview_panel_first_turn_advice_chain_wrapper() cannot find building icon, how can this be?");
		return false;
	end;
	
	local settlement_panel_size_x, settlement_panel_size_y = uic_main_settlement_panel:Dimensions();
	local settlement_panel_pos_x, settlement_panel_pos_y = uic_main_settlement_panel:Position();
	
	local building_size_x, building_size_y = uic_building:Dimensions();
	local building_pos_x, building_pos_y = uic_building:Position();
	
	-- set up text pointers
	local tp_province_overview_panel = text_pointer:new("province_overview_panel", "bottom", 130, settlement_panel_pos_x + settlement_panel_size_x * 0.15, settlement_panel_pos_y - 15);
	tp_province_overview_panel:set_layout("text_pointer_title_and_text")
	tp_province_overview_panel:add_component_text("title", "ui_text_replacements_localised_text_hp_campaign_title_province_overview_panel");
	tp_province_overview_panel:add_component_text("text", "ui_text_replacements_localised_text_hp_campaign_description_province_overview_panel");
	tp_province_overview_panel:set_style("semitransparent_highlight_dont_close");
	tp_province_overview_panel:set_panel_width(400);
	
	local tp_buildings = text_pointer:new("buildings", "right", 210, building_pos_x + (building_size_x / 2), building_pos_y + (building_size_y / 2));
	tp_buildings:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_province_overview_panel_buildings");
	tp_buildings:set_style("semitransparent_highlight_dont_close");
	tp_buildings:set_panel_width(300);
	tp_buildings:set_label_offset(0, -35);
	
	-- set up panel highlight
	local pa = intro_campaign_panel_highlight_advice:new(
		province_overview_panel_advice_key,
		nil,
		{"settlement_panel"}
	);
	
	pa:set_show_advisor_dismiss_button(false);
	pa:set_allow_reselection_on_end(false);
	pa:set_complete_on_advice_dismissed(false);
	
	pa:start();
	
	-- show first text pointer
	cm:callback(function() uim:highlight_province_overview_panel(true, 2, true) end, 0.5);
	cm:callback(function() tp_province_overview_panel:show() end, 1);
	
	-- set up text pointer progression
	tp_province_overview_panel:set_close_button_callback(
		function() 
			uim:unhighlight_all_for_tooltips(true);
			uim:highlight_buildings(true, nil, true, true);
			cm:callback(function() tp_buildings:show() end, 0.5);
		end
	);
	
	tp_buildings:set_close_button_callback(
		function()			
			uim:unhighlight_all_for_tooltips(true);
			
			cm:dismiss_advice();
			
			cm:callback(
				function()
					pa:complete();
					
					tp_buildings:hide();
					
					if foreign_settlements_advice_key then
						start_province_overview_panel_first_turn_foreign_settlements_wrappper(tp_province_overview_panel, uic_main_settlement_panel, foreign_settlements_advice_key, capital_city_advice_key, end_callback, foreign_settlement_is_ruin)
					else
						tp_province_overview_panel:hide();
						end_callback();
					end;
				end, 
				0.5
			); 
		end
	);
end;




function start_province_overview_panel_first_turn_foreign_settlements_wrappper(tp_province_overview_panel, uic_main_settlement_panel, foreign_settlements_advice_key, capital_city_advice_key, end_callback, foreign_settlement_is_ruin)

	-- insert a path to each of the non-capital settlement components into the paths table (each path is itself a table)
	local paths_to_non_capital_settlements = {};
	for i = 1, uic_main_settlement_panel:ChildCount() - 1 do
		local path_to_insert = {"settlement_panel", "main_settlement_panel", i}
		
		table.insert(paths_to_non_capital_settlements, path_to_insert);
	end;
	
	-- get a handle to the second settlement
	local uic_second_settlement_button = find_uicomponent(uic_main_settlement_panel, 1, "button_zoom");
	if not uic_second_settlement_button then
		script_error("ERROR: start_province_overview_panel_foreign_settlements_advice() cannot find second settlement button, how can this be?");
		return false;
	end;
	
	-- get a handle to the third settlement faction icon
	local uic_third_settlement_faction_icon = find_uicomponent(uic_main_settlement_panel, 2, "other_faction_overlay", "dy_flag");
	if not uic_third_settlement_faction_icon then
		script_error("ERROR: start_province_overview_panel_foreign_settlements_advice() cannot find third settlement flag, how can this be?");
		return false;
	end;
	
	local second_settlement_button_size_x, second_settlement_button_size_y = uic_second_settlement_button:Dimensions();
	local second_settlement_button_pos_x, second_settlement_button_pos_y = uic_second_settlement_button:Position();
	
	local third_settlement_button_size_x, third_settlement_button_size_y = uic_third_settlement_faction_icon:Dimensions();
	local third_settlement_button_pos_x, third_settlement_button_pos_y = uic_third_settlement_faction_icon:Position();
	
	-- set up text pointers
	local tp_other_settlements = text_pointer:new("other_settlements", "bottom", 120, second_settlement_button_pos_x + (second_settlement_button_size_x * 0.8), second_settlement_button_pos_y + (second_settlement_button_size_y / 2));
	tp_other_settlements:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_province_overview_panel_other_settlements");
	tp_other_settlements:set_style("semitransparent_highlight_dont_close");
	tp_other_settlements:set_panel_width(300);
	
	local tp_other_settlement_owners = text_pointer:new("other_settlement_owners", "left", 140, third_settlement_button_pos_x + 10 + (third_settlement_button_size_x / 2), third_settlement_button_pos_y + (third_settlement_button_size_y / 2));
	if foreign_settlement_is_ruin then
		tp_other_settlement_owners:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_province_overview_panel_other_settlement_owners_ruin");
	else
		tp_other_settlement_owners:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_province_overview_panel_other_settlement_owners");
	end;
	tp_other_settlement_owners:set_style("semitransparent_highlight_dont_close");
	tp_other_settlement_owners:set_panel_width(200);
	
	-- set up panel highlight
	local pa = intro_campaign_panel_highlight_advice:new(
		foreign_settlements_advice_key,
		nil,
		unpack(paths_to_non_capital_settlements)
	);
	
	pa:set_show_advisor_dismiss_button(false);
	pa:set_allow_reselection_on_end(false);
	pa:set_complete_on_advice_dismissed(false);
		
	pa:start();
	
	-- show first text pointer
	cm:callback(
		function() 
			tp_other_settlements:show();
			uim:highlight_buildings(true, nil, true, false, true);
			uim:highlight_province_overview_panel_settlement_headers(true, nil, true, false, true);
		end, 
		1
	);
	
	-- set up text pointer progression
	tp_other_settlements:set_close_button_callback(
		function()
			uim:unhighlight_all_for_tooltips(true);
			cm:callback(
				function()
					pulse_uicomponent(uic_third_settlement_faction_icon, true, uim:get_button_pulse_strength());
					
					tp_other_settlement_owners:show() 
				end, 
				0.5
			) 
		end
	);
	
	tp_other_settlement_owners:set_close_button_callback(
		function()
			pulse_uicomponent(uic_third_settlement_faction_icon, false, uim:get_button_pulse_strength());
			
			cm:dismiss_advice();
			
			cm:callback(
				function()
					pa:complete();
					
					tp_province_overview_panel:hide();
					tp_other_settlements:hide();
					tp_other_settlement_owners:hide();
					
					if capital_city_advice_key then
						start_province_overview_panel_first_turn_province_capital_wrappper(capital_city_advice_key, end_callback);
					else
						end_callback();
					end;
				end, 
				0.5
			); 
		end
	);
end;



function start_province_overview_panel_first_turn_province_capital_wrappper(capital_city_advice_key, end_callback)
	local uic_first_settlement_button = find_uicomponent(core:get_ui_root(), "settlement_panel", "main_settlement_panel", 0, "button_zoom");
	if not uic_first_settlement_button then
		script_error("ERROR: start_province_overview_panel_province_capital_advice() cannot find first settlement button, how can this be?");
		return false;
	end;
	
	local first_settlement_button_size_x, first_settlement_button_size_y = uic_first_settlement_button:Dimensions();
	local first_settlement_button_pos_x, first_settlement_button_pos_y = uic_first_settlement_button:Position();
	
	-- set up text pointers
	local tp_first_settlement = text_pointer:new("first_settlements", "bottom", 100, first_settlement_button_pos_x + (first_settlement_button_size_x * 3 / 4), first_settlement_button_pos_y + (first_settlement_button_size_y / 2));
	tp_first_settlement:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_province_overview_panel_province_capital");
	tp_first_settlement:set_panel_width(300);
	tp_first_settlement:set_style("semitransparent");
	
	local pa = intro_campaign_panel_highlight_advice:new(
		capital_city_advice_key,
		nil,
		{"settlement_panel", "main_settlement_panel", 0}
	);
	
	pa:set_show_advisor_dismiss_button(false);
	pa:set_allow_reselection_on_end(false);
	pa:set_complete_on_advice_dismissed(false);
	
	pa:set_post_advice_dismiss_time(1);
		
	cm:callback(function() pa:start() end, 1);
	
	cm:callback(
		function()
			uim:highlight_buildings(true, nil, true, true);
			uim:highlight_province_overview_panel_settlement_headers(true, nil, true, true, false);
			tp_first_settlement:show();
		end, 
		1.5
	);
	
	tp_first_settlement:set_close_button_callback(
		function() 
			cm:dismiss_advice();
			
			uim:unhighlight_all_for_tooltips(true);
			
			cm:callback(
				function()
					pa:complete();
					
					tp_first_settlement:hide();
					
					end_callback();
				end, 
				0.5
			); 
		end
	);
end;





function start_province_info_panel_first_turn_advice_wrapper(advice_key, end_callback, show_slaves_info)

	if not is_string(advice_key) then
		script_error("ERROR: start_province_info_panel_first_turn_advice_wrapper() called but supplied advice key [" .. tostring(advice_key) .. "] is not a string");
		return false;
	end;
	
	if not is_function(end_callback) then
		script_error("ERROR: start_province_info_panel_first_turn_advice_wrapper() called but supplied end callback [" .. tostring(end_callback) .. "] is not a function");
		return false;
	end;

	local uim = cm:get_campaign_ui_manager();
	
	-- set up text pointers
	
	-- get a handle to the province info panel component
	local uic_province_info_panel = find_uicomponent(core:get_ui_root(), "ProvinceInfoPopup");
	
	if not uic_province_info_panel then
		script_error("ERROR: start_province_info_panel_advice() can't find uic_province_info_panel, how can this be?");
		return;
	end;
	
	-- get a handle to the various components we need to point to
	local uic_growth_header = find_uicomponent(uic_province_info_panel, "frame_growth", "header_frame");
	if not uic_growth_header then
		script_error("ERROR: start_province_info_panel_advice() can't find uic_growth_header, how can this be?");
		return;
	end;
		
	local uic_wealth_holder = find_uicomponent(uic_province_info_panel, "wealth_holder");
	if not uic_wealth_holder then
		script_error("ERROR: start_province_info_panel_advice() can't find uic_wealth_holder, how can this be?");
		return;
	end;
	
	local uic_public_order_bar = find_uicomponent(uic_province_info_panel, "public_order_bar");
	if not uic_public_order_bar then
		script_error("ERROR: start_province_info_panel_advice() can't find uic_public_order_bar, how can this be?");
		return;
	end;
	
	local uic_corruption_header = find_uicomponent(uic_province_info_panel, "frame_corruption", "header_frame");
	if not uic_corruption_header then
		script_error("ERROR: start_province_info_panel_advice() can't find uic_corruption_header, how can this be?");
		return;
	end;
	
	local growth_header_size_x, growth_header_size_y = uic_growth_header:Dimensions();
	local growth_header_pos_x, growth_header_pos_y = uic_growth_header:Position();
	
	local wealth_holder_size_x, wealth_holder_size_y = uic_wealth_holder:Dimensions();
	local wealth_holder_pos_x, wealth_holder_pos_y = uic_wealth_holder:Position();
	
	local public_order_bar_size_x, public_order_bar_size_y = uic_public_order_bar:Dimensions();
	local public_order_bar_pos_x, public_order_bar_pos_y = uic_public_order_bar:Position();
	
	local corruption_header_size_x, corruption_header_size_y = uic_corruption_header:Dimensions();
	local corruption_header_pos_x, corruption_header_pos_y = uic_corruption_header:Position();
	
	-- set up text pointers
	local tp_province_info_panel = text_pointer:new("province_info_panel", "left", 250, growth_header_pos_x + growth_header_size_x + 20, growth_header_pos_y - 5);
	tp_province_info_panel:set_layout("text_pointer_title_and_text")
	tp_province_info_panel:add_component_text("title", "ui_text_replacements_localised_text_hp_campaign_title_province_info_panel");
	tp_province_info_panel:add_component_text("text", "ui_text_replacements_localised_text_hp_campaign_description_province_info_panel");
	tp_province_info_panel:set_style("semitransparent_highlight_dont_close");
	tp_province_info_panel:set_panel_width(500);
	tp_province_info_panel:set_label_offset(0, -45);

	local tp_growth = text_pointer:new("growth", "bottom", 80, growth_header_pos_x + (growth_header_size_x * 2 / 10), growth_header_pos_y + (growth_header_size_y / 2));
	tp_growth:add_component_text("text", "ui_text_replacements_localised_text_hp_campaign_description_growth");
	tp_growth:set_style("semitransparent_highlight_dont_close");
	tp_growth:set_panel_width(350);
	tp_growth:set_label_offset(120, 0);
	
	local tp_tax = text_pointer:new("tax", "left", 120, wealth_holder_pos_x + wealth_holder_size_x * 0.85, wealth_holder_pos_y + (wealth_holder_size_y / 2));
	
	if show_slaves_info then
		tp_tax:add_component_text("text", "ui_text_replacements_localised_text_hp_campaign_tax_and_slaves_def_first_turn");
		tp_tax:set_label_offset(0, -80);
	else
		tp_tax:add_component_text("text", "ui_text_replacements_localised_text_hp_campaign_description_tax");
		tp_tax:set_label_offset(0, -50);
	end;
	tp_tax:set_style("semitransparent_highlight_dont_close");
	tp_tax:set_panel_width(350);	
	
	local tp_public_order = text_pointer:new("public_order", "left", 500, public_order_bar_pos_x + public_order_bar_size_x, public_order_bar_pos_y + (public_order_bar_size_y / 2));
	tp_public_order:add_component_text("text", "ui_text_replacements_localised_text_hp_campaign_description_public_order");
	tp_public_order:set_style("semitransparent_highlight_dont_close");
	tp_public_order:set_panel_width(350);
	tp_public_order:set_label_offset(0, -55);
	
	local tp_corruption = text_pointer:new("corruption", "left", 180, corruption_header_pos_x + corruption_header_size_x + 20, corruption_header_pos_y + corruption_header_size_y + 20);
	tp_corruption:add_component_text("text", "ui_text_replacements_localised_text_hp_campaign_description_corruption");
	tp_corruption:set_style("semitransparent_highlight_dont_close");
	tp_corruption:set_panel_width(500);
	tp_corruption:set_label_offset(0, 35);
	
	-- set up panel highlight
	local pa = intro_campaign_panel_highlight_advice:new(
		advice_key,
		nil,
		{"hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "panel"}
	);
		
	pa:set_show_advisor_dismiss_button(false);
	pa:set_complete_on_advice_dismissed(false);
	
	-- start the panel highlight
	pa:start();
	
	-- show first text pointer
	cm:callback(
		function() 
			uim:highlight_province_info_panel(true, nil, true);
			tp_province_info_panel:show() 
		end, 
		1
	);
	
	-- set up text pointer progression
	tp_province_info_panel:set_close_button_callback(
		function() 
			uim:unhighlight_all_for_tooltips(true);
			cm:callback(
				function()
					uim:highlight_growth(true, nil, true);
					tp_growth:show() 
				end, 
				0.5
			) 
		end
	);
	
	tp_growth:set_close_button_callback(
		function()
			uim:unhighlight_all_for_tooltips(true);
			cm:callback(
				function()
					uim:highlight_tax(true, nil, true);
					tp_tax:show() 
				end, 
				0.5
			) 
		end
	);
	
	tp_tax:set_close_button_callback(
		function()
			cm:callback(
				function()
					tp_public_order:show() 
				end, 
				0.5
			); 
		end
	);
	
	tp_public_order:set_close_button_callback(
		function()
			uim:unhighlight_all_for_tooltips(true);
			cm:callback(
				function()
					uim:highlight_corruption(true, nil, true);
					tp_corruption:show() 
				end, 
				0.5
			); 
		end
	);
	
	tp_corruption:set_close_button_callback(
		function()
			uim:unhighlight_all_for_tooltips(true);
			
			cm:dismiss_advice();
			
			tp_province_info_panel:hide();
			tp_growth:hide();
			tp_tax:hide();
			tp_public_order:hide();
			tp_corruption:hide();
			
			cm:callback(
				function()
					pa:complete();
					
					end_callback();
				end, 
				0.5
			); 
		end
	);
end;








function show_balance_of_power_text_point_first_turn()
	
	-- get a handle to the bop bar
	local uic_bop = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "killometer");
	if not uic_bop then
		script_error("ERROR: show_balance_of_power_text_point_first_turn() can't find uic_bop, how can this be?");
		return;
	end;
	
	local bop_pos_x, bop_pos_y = uic_bop:Position();
	local bop_size_x, bop_size_y = uic_bop:Dimensions();
		
	local tp_bop = text_pointer:new("bop", "bottom", 100, bop_pos_x + bop_size_x / 2, bop_pos_y);
	tp_bop:add_component_text("text", "ui_text_replacements_localised_text_hp_campaign_point_3_pre_battle_panel");
	tp_bop:set_style("semitransparent");
	tp_bop:set_panel_width(350);
	
	tp_bop:show();
	
	-- listen for attack button being clicked and hide the text pointer
	core:add_listener(
		"show_balance_of_power_text_point_first_turn",
		"ComponentLClickUp",
		function(context) return context.string == "button_attack" end,
		function()
			core:remove_listener("show_balance_of_power_text_point_first_turn");
			tp_bop:hide()
		end,
		false
	);
	
	-- listen for ESC menu being opened and hide text pointer
	core:add_listener(
		"show_balance_of_power_text_point_first_turn",
		"ShortcutTriggered",
		function(context) return context.string == "escape_menu" end,
		function()
			core:remove_listener("show_balance_of_power_text_point_first_turn");
			tp_bop:hide()
		end,
		false
	);
end;


----------------------------------------------------------------------------------------------------
-- upgrading growth building
----------------------------------------------------------------------------------------------------
intro_campaign_select_settlement_for_upgrading_growth_building = {
	region_name = ""
};






