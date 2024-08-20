

-------------------------------------------------------
-------------------------------------------------------
--	FACTION START SCRIPT
-------------------------------------------------------
-------------------------------------------------------

__faction_start_playing = false;	-- failsafe, there should be only one intro but we check this just in case

faction_start = {
	name = "",
	default_x = 0,
	default_y = 0,
	default_d = 0,
	default_b = 0,
	default_h = 0,
	intro_cutscene_callback = nil,
	new_sp_game_callback = nil,
	each_sp_game_callback = nil,
	new_mp_game_callback = nil,
	each_mp_game_callback = nil,
	force_intro_cutscene_playback = false,
	have_faded_to_black = false,
	delay_before_fade_to_picture = 0.5,
	fade_to_picture_duration = 1
};


function faction_start:new(name, x, y, d, b, h)
	-- type-check our parameters
	if not is_string(name) then
		script_error("ERROR: tried to create a faction_start but supplied name [" .. tostring(name) .."] is not a string");
		return false;
	end;
	
	local full_name = "Faction_Start_" .. name;
	
	local cm = get_cm();
	
	-- if we don't have camera co-ordinates then use the current camera
	if not x then
		x, y, d, b, h = cm:get_camera_position();
	end;
	
	if not is_number(x) then
		script_error(full_name .. " ERROR: tried to create a faction_start but supplied default x camera co-ordinate [" .. tostring(x) .."] is not a number");
		return false;
	end;

	if not is_number(y) then
		script_error(full_name .. " ERROR: tried to create a faction_start but supplied default y camera co-ordinate [" .. tostring(y) .."] is not a number");
		return false;
	end;
	
	if not is_number(d) then
		script_error(full_name .. " ERROR: tried to create a faction_start but supplied default camera distance [" .. tostring(d) .."] is not a number");
		return false;
	end;

	if not is_number(b) then
		script_error(full_name .. " ERROR: tried to create a faction_start but supplied default camera bearing [" .. tostring(b) .."] is not a number");
		return false;
	end;
	
	if not is_number(h) then
		script_error(full_name .. " ERROR: tried to create a faction_start but supplied default camera height [" .. tostring(h) .."] is not a number");
		return false;
	end;
		
	fs = {};
	
	setmetatable(fs, faction_start);
	self.__tostring = function() return TYPE_FACTION_START end;
	self.__index = self;
	
	fs.cm = cm;
	fs.name = full_name;
	
	-- if the x or y co-ordinates are 0 or less then we use the display position of the faction leader instead
	fs.default_x = x;
	fs.default_y = y;
	fs.default_d = d;
	fs.default_b = b;
	fs.default_h = h;
	
	return fs;
end;


function faction_start:register_intro_cutscene_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: register_intro_cutscene_callback() called but supplied object [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	-- black out camera at this time if this is a new singleplayer game
	if cm:is_new_game() and not cm:is_multiplayer() then
		cm:fade_scene(0, 0);
		self.have_faded_to_black = true;
	end;
	
	self.intro_cutscene_callback = callback;
end;


function faction_start:set_force_intro_cutscene_playback(value)
	self.force_intro_cutscene_playback = not not value;
end;


function faction_start:register_new_sp_game_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: register_new_sp_game_callback() called but supplied object [" .. tostring(callback) .. "] is not a function");
	end;
	
	self.new_sp_game_callback = callback;
end;


function faction_start:register_each_sp_game_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: register_each_sp_game_callback() called but supplied object [" .. tostring(callback) .. "] is not a function");
	end;
	
	self.each_sp_game_callback = callback;
end;


function faction_start:register_new_mp_game_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: register_new_mp_game_callback() called but supplied object [" .. tostring(callback) .. "] is not a function");
	end;
	
	self.new_mp_game_callback = callback;
end;


function faction_start:register_each_mp_game_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: register_each_mp_game_callback() called but supplied object [" .. tostring(callback) .. "] is not a function");
	end;
	
	self.each_mp_game_callback = callback;
end;


-- this faction_start is starting. There should only be one
function faction_start:start(should_show_cutscene, wait_for_loading_screen, suppress_cinematic_borders)
	-- we should wait for the loading screen by default
	if wait_for_loading_screen ~= false then
		wait_for_loading_screen = true;
	end;

	if wait_for_loading_screen then	
		-- show cinematic bars before the loading screen finishes if it's a new game, and certain other conditions are met
		if self.cm:is_new_game() and not self.cm:is_multiplayer() and not self:is_disable_prelude_scripts_tweaker_set() and self.intro_cutscene_callback and should_show_cutscene and not suppress_cinematic_borders then
			CampaignUI.ToggleCinematicBorders(true);
		end;
	
		-- wait for the LoadingScreenDismissed event
		core:progress_on_loading_screen_dismissed(function() self:process_start(should_show_cutscene) end);
	else
		self:process_start(should_show_cutscene);
	end;
end;


-- do the actual job of starting (called from function above)
function faction_start:process_start(should_show_cutscene)
	if __faction_start_playing then
		script_error(self.name .. " ERROR: Tried to start a faction_start but another faction_start " .. tostring(__faction_start_playing) .. " is already playing - there should be only one of these!");
		return false;
	end;
	
	local cm = self.cm;
	local is_multiplayer = cm:is_multiplayer();
	local is_new_game = cm:is_new_game();
	
	-- construct a console output
	local output_str = self.name .. " is starting";
	
	if is_new_game then
		output_str = output_str .. " a new";
	else
		output_str = output_str .. " an existing";
	end;
	
	if is_multiplayer then
		output_str = output_str .. " multiplayer game";
	else
		output_str = output_str .. " singleplayer game";
	end;
	
	out(output_str);
		
	-- if it's a new game, then call the appropriate new game callback
	if is_new_game then
		if is_multiplayer then
			-- this is a new multiplayer game. Call our new game function, if 
			-- we have one, then set the camera to the default position
			if is_function(self.new_mp_game_callback) then
				out("...calling new multiplayer game callback");
				out.inc_tab();
				self.new_mp_game_callback();
				out.dec_tab();
			else
				out("...not calling new multiplayer game callback as none exists");
			end;
		else
			-- this is a new singleplayer game
			
			-- call new game callback, if we have one
			if is_function(self.new_sp_game_callback) then
				out("...calling new singleplayer game callback");
				out.inc_tab();
				self.new_sp_game_callback();
				out.dec_tab();
			else
				out("...not calling new singleplayer game callback as none exists");
			end;
		end;
	end;
	
	-- the new game callback has now been called, if it existed.
	-- next, call the each game callback (if it exists)
	if is_multiplayer then
		if is_function(self.each_mp_game_callback) then
			out("...calling each multiplayer game callback");
			out.inc_tab();
			self.each_mp_game_callback();
			out.dec_tab();
		end;
	else
		if is_function(self.each_sp_game_callback) then
			out("...calling each singleplayer game callback");
			out.inc_tab();
			self.each_sp_game_callback();
			out.dec_tab();
		end;
	end;
	
	-- see if we want to force intro cutscene playback first of all, the cinematics guys want to do this sometimes
	if self:should_force_intro_cutscene_playback() then
		out(self.name .. " forcing playback of intro cutscene");
		out.inc_tab();
		self.intro_cutscene_callback();
		self:fade_camera_to_picture(self.delay_before_fade_to_picture);
		out.dec_tab();
		return;
	end;
	
	if is_new_game then
			
		-- (construct an output string first)
		local output_str = self.name .. " starting new game without cutscene";
		
		if self:is_disable_prelude_scripts_tweaker_set() then
			out(self.name .. " starting new game without cutscene as campaign scripts are disabled by tweaker DISABLE_PRELUDE_CAMPAIGN_SCRIPTS");
		elseif not self.intro_cutscene_callback then
			out(self.name .. " starting new game without cutscene as no intro cutscene callback has been set");
		elseif not should_show_cutscene then
			out(self.name .. " starting new game without cutscene as it's been suppressed with should_show_cutscene == false");
		elseif is_multiplayer then
			out(self.name .. " starting new game without cutscene as it's a multiplayer game");
		else
			-- this is a new game, we have a cutscene, we should show it and it's a sp campaign,
			-- so show the cutscene!
			out(self.name .. " calling intro cutscene callback");
			out.inc_tab();
			self.intro_cutscene_callback();
			self:fade_camera_to_picture(self.delay_before_fade_to_picture);
			out.dec_tab();
			return;
		end;
		
		self:set_camera_to_default();
	else
		out(self.name .. " continuing existing game");
	end;

	self:fade_camera_to_picture();
end;


function faction_start:fade_camera_to_picture(delay)
	if not self.have_faded_to_black then
		return;
	end;

	delay = delay or 0;
	self.have_faded_to_black = false;

	if delay == 0 then
		cm:fade_scene(1, self.fade_to_picture_duration);
		out(self.name .. " fading to picture over " .. self.fade_to_picture_duration .. "s");
	else
		cm:callback(
			function() 
				cm:fade_scene(1, self.fade_to_picture_duration);
				out(self.name .. " fading to picture over " .. self.fade_to_picture_duration .. "s after a " .. self.delay_before_fade_to_picture .. " delay");
			end, 
			self.delay_before_fade_to_picture, 
			"faction_start_fade_camera_to_picture"
		);
	end;
end;


function faction_start:is_disable_prelude_scripts_tweaker_set()
	return core:is_tweaker_set("DISABLE_PRELUDE_CAMPAIGN_SCRIPTS");
end;


function faction_start:should_force_intro_cutscene_playback()
	return self.force_intro_cutscene_playback and self.intro_cutscene_callback and not self:is_disable_prelude_scripts_tweaker_set();
end;


function faction_start:set_camera_to_default()
	out(self.name .. ": starting camera at default position [" .. self.default_x .. ", " .. self.default_y .. ", " .. self.default_d .. ", " .. self.default_b .. ", " .. self.default_h);
	
	self.cm:set_camera_position(self.default_x, self.default_y, self.default_d, self.default_b, self.default_h);
end;






