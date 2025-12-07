
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	BATTLE CUTSCENES
--
--- @set_environment battle
--- @c cutscene Battle Cutscenes
--- @desc The battle cutscene library provides an interface for the relatively easy creation and setup of scripted cutscenes in battle. A cutscene object is first declared with @cutscene:new, configured with the variety of configuration commands available, loaded with actions (things that happen within the cutscene) using repeated calls to @cutscene:action, and finally started with @cutscene:start to start the visual cutscene itself. Each battle cutscene object represents an individual cutscene.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

cutscene = {
	-- startup and internal params
	my_subtitles = nil,
	cam = nil,
	name = "",
	players_army = nil,
	end_callback = nil,
	cutscene_length = nil,	-- If nil, the cutscene will not end without user input.
	action_list = nil,
	action_ptr = 1,
	cumulative_time = 0,
	relative_mode = false,
	is_running = false,
	start_time = 0,
	wait_offset = 0,
	advisor_wait = false,
	vo_wait = false,
	camera_wait = false,
	restore_cam_pos = nil,
	restore_cam_target = nil,
	is_skipped = false,
	esc_to_continue_prompt_active = false,
	
	-- skipping params
	skippable = true,
	skip_cam_pos = nil,
	skip_cam_target = nil,
	skip_callback = nil,
	
	-- is ambush
	is_ambush = false,
	teleport_on_ambush_cutscene_end = true,
	
	-- debug
	is_debug = false,
	hide_ui_in_debug = false,
	
	-- music
	music = nil,
	music_fade_in = nil,
	music_fade_out = nil,
	music_resume_auto_playback = true,
	
	-- misc params
	post_cutscene_fade_time = 0,
	post_cutscene_fade_time_delay = 0,
	battle_speed = 1,
	should_restore_battle_speed = true,
	restore_cam_time = -1,
	suppress_unit_vo = true,
	should_disable_unit_ids = true,
	stop_all_vo_on_start = false,
	close_advisor_on_start = true,
	close_advisor_on_end = true,
	wait_for_advisor_on_end = false,
	wait_for_vo_on_end = false,
	should_enable_ui_on_end = true,
	should_enable_cinematic_camera = true,
	debug_timestamps = false,
	should_release_players_army = true,
	show_cinematic_bars = true,
	call_end_callback_when_skipped = true,
	should_hide_ui = true,
	steal_input_focus = true,
	make_advisor_progress_button_visible_on_end = true,
	should_restore_ui_hiding_on_end = true,
	custom_cutscene_subtitles = {},
	cinematic_triggers = {},
	stop_cindy_scene_on_finish = false
}


set_class_custom_type(cutscene, TYPE_CUTSCENE_MANAGER);
set_class_tostring(
	cutscene,
	function(obj)
		return TYPE_CUTSCENE_MANAGER .. "_" .. obj.name;
	end
);








----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates a cutscene object. A cutscene must be given a string name, an object granting control over the player's army (to allow it to be taken away during the cutscene), a length, and, optionally, a function to call when the cutscene finishes.
--- @p string name, Name for cutscene.
--- @p object unit controller, Either a unitcontroller with control over the player's army, or a @script_units collection containing all of the player's units.
--- @p [opt=nil] @number duration, Cutscene duration in milliseconds. If nil or 0 is specified then the cutscene will be set to not end, and will only finish when skipped by the player or ended by an external process
--- @p [opt=nil] function end callback, End callback. A callback is usually specified here, although not always.
--- @r cutscene cutscene object
function cutscene:new(name, players_army, cutscene_length, end_callback)
	if not is_string(name) then
		script_error("ERROR: Tried to create cutscene but given name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_unitcontroller(players_army) and not is_scriptunits(players_army) then
		script_error("ERROR: Tried to create cutscene " .. name .. " but the given player's unitcontroller [" .. tostring(players_army) .. "] is not a valid unitcontroller or scriptunits collection");
		return false;
	end;
	
	if cutscene_length == 0 then
		cutscene_length = nil;
	elseif cutscene_length and not (is_number(cutscene_length) and cutscene_length > 0) then
		script_error("ERROR: Tried to create cutscene " .. name .. " but given length [" .. tostring(cutscene_length) .. "] is not a positive number (or 0/nil)");
		return false;
	end;
	
	if not is_function(end_callback) and not is_nil(end_callback) then
		script_error("ERROR: Tried to create cutscene " .. name .. " but given callback [" .. tostring(end_callback) .. "] is not a function or nil");
		return false;
	end;
	
	local c = {};

	c.name = name;
	
	set_object_class(c, self);
	
	c.my_subtitles = bm:subtitles();
	c.my_subtitles:change_if_borders_drawn(false);
	c.cam = bm:camera();
	c.action_list = {};
	c.sounds = {};
	c.custom_cutscene_subtitles = {};
	c.cinematic_triggers = {};
	c.players_army = players_army;

	-- if a length has not been supplied then set this cutscene to only end when skipped
	c.cutscene_length = cutscene_length;

	c.end_callback = end_callback;
		
	bm:register_cutscene(c);
	
	return c;
end;


--- @function new_from_cindyscene
--- @desc Creates a cutscene object that is bound to a cindyscene. When started, the scripted cutscene will automatically start the cindyscene, and will terminate when the cindyscene ends.
--- @p @string name, Unique name for the cutscene.
--- @p object unit controller, Either a @battle_unitcontroller with control over the player's army, or a @script_units collection containing all of the player's units.
--- @p [opt=nil] @function end callback, End callback.
--- @p @string cindy scene, Cindy scene path.
--- @p [opt=0] @number blend in, Blend in time, in seconds.
--- @p [opt=10] @number blend out, Blend out time, in seconds.
--- @r cutscene cutscene object
function cutscene:new_from_cindyscene(name, players_army, end_callback, cindy_scene, blend_in_duration, blend_out_duration)

	if not is_string(cindy_scene) then
		script_error("ERROR: cutscene:new_from_cindyscene() called but supplied cindy scene path [" .. tostring(cindy_scene) .. "] is not a string");
		return false;
	end;

	local c = cutscene:new(
		name,
		players_army,
		nil,
		end_callback,
		send_metrics_data
	);

	if not c then
		return false;
	end;

	c:action(
		function() 
			bm:cindy_playback(cindy_scene, blend_in_duration, blend_out_duration) 
		end,
		0
	);

	c.stop_cindy_scene_on_finish = true;

	-- An unpleasant workaround for cutscenes not being able to distinguish between trigger events sent for different scenes. If two cindyscenes are played back to back and the first is skipped, the second receives the
	-- end_cinematic event as it starts to play and thinks that it's being ended immediately. The workaround is to only start the end cinematic trigger listener a short time into the cutscene.
	c:action(
		function()
			c:add_cinematic_trigger_listener(
				"end_cinematic",
				function()
					c:skip(false);
				end
			);
		end,
		500
	);

	return c;
end;










----------------------------------------------------------------------------
--- @section Debug
----------------------------------------------------------------------------


--- @function set_debug
--- @desc Sets the cutscene into debug mode for more output. Setting debug mode on a cutscene also allows the camera to be moved during cutscene playback, and keeps the UI visible.
--- @p [opt=true] boolean set debug, Set cutscene into debug mode.
--- @p [opt=false] boolean Hide UI in debug mode.
function cutscene:set_debug(is_debug, hide_ui_in_debug)
	if is_debug == nil then
		self.is_debug = true;
	else
		self.is_debug = is_debug;
	end;
	
	self.hide_ui_in_debug = hide_ui_in_debug;
end;


--- @function enable_debug_timestamps
--- @desc Instructs the cutscene to print a debug timestamp every model tick. This can be useful when trying to set up timings for cutscene events.
--- @p [opt=true] boolean enable timestamps
function cutscene:enable_debug_timestamps(value)
	if value == false then
		self.debug_timestamps = false;
	else
		self.debug_timestamps = true;		
	end;
end;








----------------------------------------------------------------------------
--- @section Cinematic Triggers
--- @desc A cindy scene can be configured to send events to script, for which listeners may be established that call script functions. The function @cutscene:add_cinematic_trigger_listener may be used to establish such a listener. This mechanism allows cinematic artists to more tightly control the timing of events in the cindy scene.
----------------------------------------------------------------------------


--- @function add_cinematic_trigger_listener
--- @desc Registers a new cinematic trigger listener. When the cindy scene triggers a script event with the supplied id in script, the supplied function is called.
--- @p @string id, Cinematic trigger id. This should match the an id of a cinematic event triggered from a cindy scene played during this cutscene.
--- @p function callback, Callback to call.
function cutscene:add_cinematic_trigger_listener(id, callback)
	if not is_string(id) then
		script_error(self.name .. " ERROR: add_cinematic_trigger_listener() called but supplied id " .. tostring(id) .. " is not a string");
		return false;
	end;
	
	if not is_function(callback) then
		script_error(self.name .. " ERROR: add_cinematic_trigger_listener() called but supplied callback " .. tostring(callback) .. " is not a function");
		return false;
	end;
	
	self.cinematic_triggers[id] = callback;
end;










----------------------------------------------------------------------------
--- @section Enqueuing Actions
--- @desc By adding actions to a cutscene it is instructed to perform operations at certain times after the cutscene is started. It is through cutscene actions that the narrative events in the cutscene are brought into being.
----------------------------------------------------------------------------


--- @function action
--- @desc Adds an action to the cutscene. Specify a function callback to be called, and a time after the start of the cutscene to call it in ms. If relative mode has been set with @cutscene:set_relative_mode then the specified time should instead be relative to the previously-enqueued action.
--- @p function action callback, Action callback.
--- @p number action time, Action time in ms. This can be 0, but cannot be greater than the length of the cutscene.
--- @p [opt=true] @boolean is terminator, If true, no actions will be called after this one.
function cutscene:action(new_callback, new_delay, new_is_terminator)
	if self.is_running then
		script_error(self.name .. " WARNING: trying to add an action to a running cutscene! You can't do this!");
		
		return false;
	end;

	if not is_function(new_callback) then
		script_error(self.name .. " ERROR: trying to add an action but supplied callback [" .. tostring(new_callback) .. "] is not a function");
		return false;
	end;

	if not is_number(new_delay) or new_delay < 0 then
		script_error(self.name .. " ERROR: trying to add an action but supplied delay [" .. tostring(new_delay) .. "] is not a positive number");
		return false;
	end;

	if self.cutscene_length ~= nil and new_delay > self.cutscene_length then
		script_error(self.name .. " WARNING: trying to add an action past the end of a cutscene! You can't do this!");
			return false;
	end;
	
	new_is_terminator = new_is_terminator or false;

	local global_start_time = nil;
	local insertion_index = nil;
	local action_list = self.action_list;
	
	if self.relative_mode then
		global_start_time = self.cumulative_time + new_delay;
		insertion_index = #action_list + 1;
	else
		global_start_time = new_delay;
		-- Actions will pretty much always want to be inserted at or near the end of the list, so search by iterating backwards.
		for i = #action_list, 1, -1 do
			if action_list[i].delay <= new_delay then
				insertion_index = i + 1;
				break;
			end;
		end;
		
		if insertion_index == nil then
			insertion_index = #action_list + 1;
		end;
	end;

	if global_start_time > self.cumulative_time then
		self.cumulative_time = global_start_time;
	end;

	table.insert(action_list, insertion_index, {callback = new_callback, delay = global_start_time, is_terminator = new_is_terminator});
	
	return false;
end;







----------------------------------------------------------------------------
--- @section Playing/Waiting for Sounds
----------------------------------------------------------------------------


--- @function play_sound
--- @desc Instructs the cutscene to play a sound. This sound is registered to the cutscene, so that it can query its status later and also stop it if the cutscene is skipped.
--- @p battle_sound_effect sound
function cutscene:play_sound(sound)
	if not is_battlesoundeffect(sound) then
		script_error(self.name .. " ERROR: play_sound() called but supplied object [" .. tostring(sound) .. "] is not a battle_sound_effect");
		return false;
	end;

	table.insert(self.sounds, sound);

	play_sound(bm:get_origin(), sound);
end;


--- @function play_vo
--- @desc Instructs the cutscene to play a sound at a specified @script_unit in 3D space. This sound is registered to the cutscene, so that it can query its status later and also stop it if the cutscene is skipped.
--- @p battle_sound_effect sound
--- @p script_unit target sunit
function cutscene:play_vo(sound, sunit)
	if not is_battlesoundeffect(sound) then
		script_error(self.name .. " ERROR: play_sound() called but supplied object [" .. tostring(sound) .. "] is not a battle_sound_effect");
		return false;
	end;

	table.insert(self.sounds, sound);

	sunit:play_vo(sound);
end;



--- @function wait_for_advisor
--- @desc Instructs a running cutscene to stall its progress until the advisor has finished speaking. This is designed to be called during a cutscene action to prevent one item of advice from colliding with another piece of advice, sound, or other event that it shouldn't overlap with. Since the length of an item of advice varies from language to language, it's sensible to insert wait_for_advisor calls into a cutscene script before starting subsequent advice.
function cutscene:wait_for_advisor()
	self.advisor_wait = true;
end;


--- @function wait_for_vo
--- @desc Instructs a running cutscene to stall its progress until any sounds started with @cutscene:play_sound or @cutscene:play_vo have finished. This is designed to be called during a cutscene action to prevent one sound from colliding with another sound or event that it shouldn't overlap with. Since the length of a localised sound varies from language to language, it's sensible to insert wait_for_vo calls into a cutscene script before starting subsequent sounds.
function cutscene:wait_for_vo()
	self.vo_wait = true;
end;









----------------------------------------------------------------------------
--- @section Querying
----------------------------------------------------------------------------


--- @function subtitles
--- @desc Returns a subtitles object stored internally by the cutscene.
--- @r subtitles
function cutscene:subtitles()
	return self.my_subtitles;
end;


--- @function camera
--- @desc Returns a camera object stored internally by the cutscene.
--- @r camera
function cutscene:camera()
	return self.cam;
end;


--- @function length
--- @desc Returns the cutscene length in ms
--- @r number length in ms
function cutscene:length()
	return self.cutscene_length;
end;


--- @function is_playing_sound
--- @desc Returns true if any of the sounds the cutscene has been told to play with @cutscene:play_sound or @cutscene:play_vo are still playing, false otherwise.
--- @r boolean is playing sound
function cutscene:is_playing_sound()
	for i = 1, #self.sounds do
		local curr_sound = self.sounds[i];
		
		if curr_sound:is_playing() then
			return true;
		end;
	end;
	
	return false;
end;


--- @function is_playing_camera
--- @desc Returns true if a scripted camera movement is currently happening, false otherwise.
--- @r boolean camera moving
function cutscene:is_playing_camera()
	return self.cam:is_playing();
end;


--- @function is_any_cutscene_running
--- @desc Returns true if this or any other scripted cutscene is currently running, false otherwise.
--- @r boolean any cutscene running
function cutscene:is_any_cutscene_running()
	return bm:is_any_cutscene_running();
end;


--- @function is_active
--- @desc Returns true if this cutscene is currently running, false otherwise.
--- @r boolean this cutscene running
function cutscene:is_active()
	return self.is_running and not self.is_skipped;
end;










----------------------------------------------------------------------------
--- @section Skipping Parameters
----------------------------------------------------------------------------


--- @function set_skippable
--- @desc Sets the cutscene to be skippable, and optionally also sets a function to be called when the player skips the cutscene.
--- @p boolean skippable,
--- @p [opt=nil] function skip callback
function cutscene:set_skippable(skippable, skip_callback)
	if self.is_running then
		script_error(self.name .. " ERROR: trying to set skippable status of a running cutscene!");
		
		return false;
	end;

	self.skippable = skippable;
	
	if is_function(skip_callback) then
		self.skip_callback = skip_callback;
	end;
end;


--- @function set_skip_camera
--- @desc Sets a position/target to immediately reposition the camera at if the cutscene is skipped. This supercedes any @"cutscene:Restore Camera" if set.
--- @p vector camera position
--- @p vector camera target
function cutscene:set_skip_camera(skip_cam_pos, skip_cam_target)
	if self.is_running then
		script_error(self.name .. " ERROR: trying to set skip cam on a running cutscene!");
		
		return false;
	end;

	if not is_vector(skip_cam_pos) then
		script_error(self.name .. " ERROR: tried to set skip cam but position given " .. tostring(skip_cam_pos) .. " is not a valid vector!");
		
		return false;
	end;
	
	if not is_vector(skip_cam_target) then
		script_error(self.name .. " ERROR: tried to set skip cam but target given " .. tostring(skip_cam_target) .. " is not a valid vector!");
		
		return false;
	end;
	
	self.skip_cam_pos = skip_cam_pos;
	self.skip_cam_target = skip_cam_target;
end;









----------------------------------------------------------------------------
--- @section Restore Camera
----------------------------------------------------------------------------


--- @function set_restore_cam
--- @desc Instructs the cutscene to restore the camera to either the position it occupied when the cutscene started, or a different position/target entirely. Note that if a skip camera/target has been set with @cutscene:set_skip_camera and the cutscene is skipped, those positions will supercede these.
--- @p number move time, Time over which to restore the camera in ms. Setting 0 would result in the camera cutting, setting 1000 would result in the camera panning over 1 second, and so on.
--- @p [opt=nil] vector override position, Override camera position. Supply a position here to set a specific restore camera position, or leave blank to use the position of the camera at the start of the cutscene.
--- @p [opt=nil] vector override target, Override camera target. Must be specified if a camera position is specified.
function cutscene:set_restore_cam(new_time, new_pos, new_targ)
	if not is_number(new_time) then
		script_error(self.name .. " ERROR: trying to set restore cam time but value given " .. tostring(new_time) .. " is not a number!");
		
		return false;
	end;
	
	self.restore_cam_time = new_time;
	
	if not new_pos then
		return;
	end;

	if not is_vector(new_pos) then
		script_error(self.name .. " ERROR: trying to set restore cam but position given [" .. tostring(new_pos) .. "] is not a vector!");
		
		return false;
	end;
	
	if not is_vector(new_targ) then
		script_error(self.name .. " ERROR: trying to set restore cam but target given [" .. tostring(new_targ) .. "] is not a vector!");
		
		return false;
	end;
	
	self.restore_cam_pos = new_pos;
	self.restore_cam_target = new_targ;
end;












----------------------------------------------------------------------------
--- @section Post Cutscene Fade Time
--- @desc The post-cutscene fade time instructs the cutscene to fade the camera from black to picture after it ends or is skipped. This is used to achieve a smooth transition back to picture if the cutscene faded to black as it ended.
----------------------------------------------------------------------------


--- @function set_post_cutscene_fade_time
--- @desc Sets a duration for the post-cutscene fade time, in seconds.
--- @desc If a negative fade time is specified, then the cutscene will fade to black when it ends/is skipped and will never fade back to picture. This is useful for outro cutscenes where no fade back to picture is desired. Battle scripts can later fade back to picture themselves if desired.
--- @p number duration, New post-cutscene fade-time. Note that unlike the majority of battle durations, camera durations (such as this) are specified in seconds.
--- @p [opt=0] number duration, New post-cutscene fade-time delay. If specified, this delays the fade-in effect. Unlike the first parameter it is set in ms.
function cutscene:set_post_cutscene_fade_time(fade_in_time, fade_in_time_delay)
	if not is_number(fade_in_time) then
		script_error(self.name .. " ERROR: set_post_cutscene_fade_time() called but fade in time " .. tostring(fade_in_time) .. " is not a number");
		return false;
	end;
	
	if fade_in_time_delay and (not is_number(fade_in_time_delay) or fade_in_time_delay < 0) then
		script_error(self.name .. " ERROR: set_post_cutscene_fade_time() but supplied fade-in delay time [" .. tostring(fade_in_time_delay) .. "] is not a positive number or nil");
		return false;
	end;
	
	self.post_cutscene_fade_time = fade_in_time;
	self.post_cutscene_fade_time_delay = fade_in_time_delay;
end;











----------------------------------------------------------------------------
--- @section Music
----------------------------------------------------------------------------


--- @function set_music
--- @desc Sets a music sound event to play during the cutscene.
--- @p string music event, Music event name.
--- @p number fade in, Fade in time in ms.
--- @p number fade out, Fade out time in ms.
function cutscene:set_music(music_event, fade_in, fade_out)
	if self.is_running then
		script_error(self.name .. " ERROR: trying to set music on a running cutscene");
		
		return false;
	end;
	
	if not is_string(music_event) then
		script_error(self.name .. " ERROR: trying to set music but supplied event argument " .. tostring(music_event) .. " is not a string");
		
		return false;
	end;
	
	if (not is_nil(fade_in)) and (not is_number(fade_in)) then
		script_error(self.name .. " ERROR: trying to set music but supplied fade_in argument " .. tostring(fade_in) .. " is not a number");
		
		return false;
	end;
	
	if (not is_nil(fade_out)) and (not is_number(fade_out)) then
		script_error(self.name .. " ERROR: trying to set music but supplied fade_out argument " .. tostring(fade_out) .. " is not a number");
		
		return false;
	end;

	self.music = music_event;
	self.music_fade_in = fade_in;
	self.music_fade_out = fade_out;
end;


--- @function set_music_resume_auto_playback
--- @desc Sets the sound system to return to automatically selecting music events after the cutscene ends. Only takes effect if a custom music track has been set with @cutscene:set_music.
--- @p boolean set auto playback
function cutscene:set_music_resume_auto_playback(new_value)
	if not is_boolean(new_value) then
		script_error(self.name .. " ERROR: set_music_resume_auto_playback() called with a non boolean parameter " .. tostring(new_value));
	
		return false;
	end;
	
	self.music_resume_auto_playback = new_value;
end;










----------------------------------------------------------------------------
--- @section Relative Mode
----------------------------------------------------------------------------


--- @function set_relative_mode
--- @desc Sets relative mode for enqueuing actions on the cutscene. With relative mode enabled, the time specified for each action is relative to the previously-added action, rather than absolute from the start of the cutscene. Relative mode is disabled by default.
--- @desc Relative mode must be set before any actions are enqueued with @cutscene:action.
function cutscene:set_relative_mode()
	if #self.action_list > 0 then
		script_error(self.name .. " ERROR: trying to set relative mode after already adding actions");

		return false;
	end;
	
	self.relative_mode = true;
end;










----------------------------------------------------------------------------
--- @section Ambush Mode
----------------------------------------------------------------------------


--- @function set_is_ambush
--- @desc Sets up the cutscene as an intro cutscene of an ambush battle. This must be set if the cutscene is being shown over an ambush scene.
--- @p [opt=true] boolean is ambush, Set to true to enable ambush behaviour.
--- @p [opt=false] boolean teleport units on end, Set to true to teleport the ambushed units to the end of their ambush path once the cutscene ends.
function cutscene:set_is_ambush(value, teleport_on_end)
	if value == false then
		bm:camera():allow_user_to_skip_ambush_intro(false);
		self.is_ambush = false;
	else
		bm:camera():allow_user_to_skip_ambush_intro(true);
		self.is_ambush = true;
	end;
	
	-- don't modify the value of teleport_on_ambush_cutscene_end if no value was passed in
	if teleport_on_end == false then
		self.teleport_on_ambush_cutscene_end = false;
	elseif teleport_on_end then
		self.teleport_on_ambush_cutscene_end = true;
	end;
	
	-- enqueue an action at the cutscene length, which sets the post-cutscene-fade-time to zero, so that when the cutscene ends "normally" the screen doesn't fade out and back in again
	self:action(function() self:set_post_cutscene_fade_time(0) end, self.cutscene_length);
end;












----------------------------------------------------------------------------
--- @section Miscellaneous Setup
----------------------------------------------------------------------------


--- @function set_battle_speed
--- @desc Sets the battle speed to use while the cutscene is running. By default this value is <code>1</code>, so the cutscene plays at normal battle speed.
--- @p @number battle speed
function cutscene:set_battle_speed(speed)
	if not is_number(speed) then
		script_error(self.name .. " ERROR: set_battle_speed() called but supplied speed [" .. tostring(speed) .. "] is not a number");
		return false
	end;

	self.battle_speed = speed;
end;


--- @function set_should_restore_battle_speed
--- @desc Sets whether the cutscene should restore battle speed to that set prior to the cutscene starting. By default this behaviour is enabled.
--- @p [opt=true] @boolean should restore
function cutscene:set_should_restore_battle_speed(value)
	if value == false then
		self.should_restore_battle_speed = false;
	else
		self.should_restore_battle_speed = true;
	end;
end;


--- @function set_should_disable_unit_ids
--- @desc Sets whether unit ID uicomponents should be disabled during the cutscene. By default they are disabled, but by supplying <code>false</code> as an argument this function can be used to make them display.
--- @p [opt=true] boolean disable unit ids
function cutscene:set_should_disable_unit_ids(value)
	if value == false then
		self.should_disable_unit_ids = false;
	else
		self.should_disable_unit_ids = true;
	end;
end;


--- @function suppress_unit_voices
--- @desc Sets whether to suppress unit voices during the cutscene duration. By default they are disabled - enabling them (by supplying <code>false</code> as an argument) will cause units to audibly respond to orders given during the cutscene.
--- @p [opt=true] boolean suppress voices
function cutscene:suppress_unit_voices(value)
	if self.is_running then
		script_error(self.name .. " ERROR: trying to suppress unit voices on a running cutscene");
		return false;
	end;
	
	if value then
		self.suppress_unit_vo = true;
	else
		self.suppress_unit_vo = false;
	end;
end;


--- @function stop_all_vo_on_start
--- @desc Sets whether to stop all playing voice-over when the cutscene starts. By default this is not done.
--- @p boolean stop playing voice-over on start
function cutscene:set_stop_all_vo_on_start(should_stop)
	if not is_boolean(should_stop) then
		script_error(self.name .. " ERROR: set_stop_all_vo_on_start() called but supplied should_stop [" .. tostring(should_stop) .. "] is not a boolean")
		return false
	end

	if self.is_running then
		script_error(self.name .. " ERROR: trying to configure the stopping of all voice-over on a running cutscene")
		return false
	end

	self.stop_all_vo_on_start = should_stop
end


--- @function set_should_enable_cinematic_camera
--- @desc Sets whether to enable the cinematic camera during the cutscene. By default it is enabled, but it can be disabled by supplying <code>false</code> as an argument to this function. The cinematic camera allows the camera to clip through terrain, so disable cinematic camera in circumstances where the path of the camera cannot be guaranteed (e.g. panning from a position relative to a unit to a fixed position, if there's a risk there'll be a hill in the way).
--- @p [opt=true] boolean enable cinematic camera
function cutscene:set_should_enable_cinematic_camera(value)
	if value == false then
		self.should_enable_cinematic_camera = false;
	else
		self.should_enable_cinematic_camera = true;
	end;
end;


--- @function set_wait_for_advisor_on_end
--- @desc Sets whether to wait for the advisor to finish before ending the cutscene. This is akin to calling @cutscene:wait_for_advisor at the end of the cutscene - the termination of the cutscene is delayed until the advisor has finished speaking. By default, cutscenes do not wait for the advisor to finish before ending.
--- @p [opt=true] boolean wait for advisor
function cutscene:set_wait_for_advisor_on_end(value)
	if value == false then
		self.wait_for_advisor_on_end = false;
	else
		self.wait_for_advisor_on_end = true;
	end;
end;


--- @function set_wait_for_vo_on_end
--- @desc Sets whether to wait for any sounds registered with @cutscene:play_sound or @cutscene:play_vo to finish before ending the cutscene. This is akin to calling @cutscene:wait_for_vo at the end of the cutscene - the termination of the cutscene is delayed until all registered sounds have finished playing. By default, cutscenes do not wait for registered sounds to finish before ending.
--- @p [opt=true] boolean wait for sounds
function cutscene:set_wait_for_vo_on_end(value)
	if value == false then
		self.wait_for_vo_on_end = false;
	else
		self.wait_for_vo_on_end = true;
	end;
end;


--- @function set_close_advisor_on_end
--- @desc Sets whether to close the advisor at the end of the cutscene. By default this behaviour is enabled (so the advisor closes), supply <code>false</code> as an argument to disable it.
--- @p [opt=true] boolean should close advisor
function cutscene:set_close_advisor_on_end(value)
	if value == false then
		self.close_advisor_on_end = false;
	else
		self.close_advisor_on_end = true;
	end;
end;


--- @function set_close_advisor_on_start
--- @desc Sets whether to close the advisor when the cutscene begins. By default this behaviour is enabled, supply <code>false</code> as an argument to disable it.
--- @p [opt=true] boolean should close advisor
function cutscene:set_close_advisor_on_start(value)
	if value == false then
		self.close_advisor_on_start = false;
	else
		self.close_advisor_on_start = true;
	end;
end;


--- @function enable_ui_on_end
--- @desc Sets whether the cutscene should re-enable the UI when it finishes. By default the cutscene re-enables the UI - supply <code>false</code> as an argument to prevent it from doing so. This can be useful for scripts which have turned off the UI and don't want cutscenes re-enabling it.
--- @p [opt=true] boolean should enable ui
function cutscene:enable_ui_on_end(value)
	if value == false then
		self.should_enable_ui_on_end = false;
	else
		self.should_enable_ui_on_end = true;
	end;
end;


--- @function set_end_callback
--- @desc Sets or changes the callback that is called when the cutscene is ended.
--- @p @function end callback
function cutscene:set_end_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: set_end_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	self.end_callback = callback;
end;


--- @function set_call_end_callback_when_skipped
--- @desc Sets whether the cutscene should call the end callback (supplied when the cutscene is created with @cutscene:new) when skipped. By default the cutscene does call this callback - supply <code>false</code> as an argument to prevent it from doing so.
--- @p [opt=true] boolean should call callback
function cutscene:set_call_end_callback_when_skipped(new_value)
	if new_value == false then
		self.call_end_callback_when_skipped = false;
	else
		self.call_end_callback_when_skipped = true;
	end;
end;


--- @function set_should_release_players_army
--- @desc Sets whether the cutscene should release script control of the player's army when finishing. By default the cutscene does release this control - supply <code>false</code> as an argument to prevent it from doing so. This is useful for scripts that may want to restrict the player's control of their army and don't want cutscenes un-restricting it.
--- @p [opt=true] boolean should call callback
function cutscene:set_should_release_players_army(new_value)
	if new_value == nil or new_value then
		self.should_release_players_army = true;
	else
		self.should_release_players_army = false;
	end;
end;


--- @function set_show_cinematic_bars
--- @desc Sets whether the cutscene should show cinematic bars while playing. By default the cutscene does show cinematic bars - supply <code>false</code> as an argument to prevent it from doing so.
--- @p [opt=true] boolean show bars
function cutscene:set_show_cinematic_bars(new_value)
	if new_value == nil or new_value then
		self.show_cinematic_bars = true;
	else
		self.show_cinematic_bars = false;
	end;
end;


--- @function set_should_hide_ui
--- @desc Sets whether the cutscene should show hide the UI while playing. By default the cutscene does hide the UI - supply <code>false</code> as an argument to prevent it from doing so.
--- @p [opt=true] boolean hide UI
function cutscene:set_should_hide_ui(new_value)
	if new_value == false then
		self.should_hide_ui = false;
	else
		self.should_hide_ui = true;
	end;
end;


--- @function set_should_restore_ui_hiding_on_end
--- @desc Sets whether cutscene should restore any pre-existing scripted ui hiding state when the cutscene ends. By default this state is restored - supply <code>false</code> as an argument to prevent it from doing so.
--- @p [opt=true] @boolean restore hiding
function cutscene:set_should_restore_ui_hiding_on_end(value)
	if value == false then
		self.should_restore_ui_hiding_on_end = false;
	else
		self.should_restore_ui_hiding_on_end = true;
	end;
end;


--- @function set_steal_input_focus
--- @desc Sets whether the cutscene should steal input focus while playing, preventing player input. By default the cutscene does steal input - supply <code>false</code> as an argument to prevent it from doing so.
--- @p [opt=true] boolean steal input
function cutscene:set_steal_input_focus(new_value)
	if new_value == false then
		self.steal_input_focus = false;
	else
		self.steal_input_focus = true;
	end;
end;
































----------------------------------------------------------------------------
--- @section Starting
----------------------------------------------------------------------------


--- @function start
--- @desc Starts the cutscene. After this point it cannot be configured further.
function cutscene:start()
	if self:is_any_cutscene_running() then
		script_error(self.name .. " ERROR: cannot start, another cutscene is running!");
		
		return false;
	end;

	if buim:is_esc_menu_open() then
		bm:out("Attempting to start cutscene " .. self.name .. " but the escape menu is open - waiting until it closes");
		core:add_listener(
			self.name .. "_wait_for_esc_menu",
			"ScriptEventPanelClosedBattle",
			function(context)
				return context.string == "esc_menu";
			end,
			function()
				self:start();
			end,
			false
		);
		return;
	end;
	
	self.start_time = bm:time_elapsed_ms();
	local effective_cutscene_length = self.cutscene_length or 0; -- Handle cases where cutscene_length is nil (signifying no-end cutscenes)
	
	bm:out("Starting cutscene " .. self.name);
	
	-- increase max camera height, disable shake and anchor
	self.cam:change_height_range(0, 100);
	self.cam:disable_shake();
	self.cam:disable_anchor_to_army();
	
	-- clear advisor
	if self.close_advisor_on_start then
		bm:stop_advisor_queue(true);
	end;

	-- stop any windowed movie players
	core:stop_all_windowed_movie_players();

	-- clear any on-screen help message + queue
	bm:hide_help_message(true);
	
	-- hide the advisor close button if not in benchmarking mode, and work out if we should restore it on end
	if bm:is_benchmarking_mode() then
		self.make_advisor_progress_button_visible_on_end = false;
	elseif not bm:is_multiplayer() then
		local uic_advisor_close_button = get_advisor_progress_button();
		if uic_advisor_close_button and not uic_advisor_close_button:Visible() then
			self.make_advisor_progress_button_visible_on_end = false;	 -- default value is true
		end;
		
		show_advisor_progress_button(false);
	end;
	-- prevent user input
	if self.steal_input_focus and not self.is_debug then
		bm:steal_input_focus(true, true);
	end;
	
	-- set camera mode to cinematic camera (or not)
	bm:enable_cinematic_camera(not not self.should_enable_cinematic_camera);
	
	-- set battle speed to normal
	bm:modify_battle_speed(self.battle_speed);	
	
	-- prevent battle time from elapsing
	bm:cache_conflict_time_update_overridden();
	bm:change_conflict_time_update_overridden(true);

	-- start cinematic triggers listeners
	self:start_cinematic_trigger_listeners(true);
	
	-- show or hide the ui depending on flag setup
	if self.is_debug then
		if self.hide_ui_in_debug then
			-- hide the ui
			bm:out("Hiding UI");
			bm:enable_cinematic_ui(true, true, false);
		else
			-- show the ui
			bm:out("Showing UI");
			bm:enable_cinematic_ui(false, true, false);
		end;
	elseif not self.should_hide_ui then
		-- don't do anything
	elseif self.show_cinematic_bars then
		-- hide the UI
		bm:enable_cinematic_ui(true, false, true);
	else
		-- hide the UI but with no cinematic bars
		bm:enable_cinematic_ui(true, false, false);
	end;
		
	-- subtitle alignment
	self.my_subtitles:set_alignment("bottom_centre");
	self.my_subtitles:begin("bottom_centre");

	-- sort out the music
	if self.music then
		
		-- music in
		if self.music_fade_in then
			bm:play_music_custom_fade(self.music, self.music_fade_in);
		else
			bm:play_music(self.music);
		end;
		
		-- music out
		if self.music_resume_auto_playback then
			if self.music_fade_out then
				self:action(function() bm:stop_music_custom_fade(false, self.music_fade_out) end, effective_cutscene_length - (self.music_fade_out * 1000));
			else
				self:action(function() bm:stop_music(false) end, effective_cutscene_length);
			end;
		end;		
	end;
	
	-- suppress general unit vo (responses etc) during cutscene
	if self.suppress_unit_vo then
		bm:suppress_unit_voices(true);
		bm:suppress_unit_musicians(true);
	end;

	if self.stop_all_vo_on_start then
		bm:stop_all_vo()
	end
	
	if self.should_disable_unit_ids then
		bm:enable_unit_ids(false);
	end;
	
	self.action_ptr = 1;
	
	-- a bit of hackery to force absolute timing when we queue up the end of the cutscene
	local temp_relative_mode = self.relative_mode;
	self.relative_mode = false;
	
	-- set up an end-listener if a length has been specified or if this is an ambush battle.
	if not (self.cutscene_length == nil or self.is_ambush) then
		if self.wait_for_vo_on_end then
			self:action(function() self:wait_for_vo() end, effective_cutscene_length);
		end;
		
		if self.wait_for_advisor_on_end then
			self:action(function() self:wait_for_advisor() end, effective_cutscene_length);
		end
		
		self:action(function() self:finish() end, effective_cutscene_length, true);
	end;
	
	self.relative_mode = temp_relative_mode;
	
	-- take control of the player's army to prevent the player from ordering it around during the cutscene
	-- (this call should work if its a unitcontroller *or* a scriptunits collection)
	self.players_army:take_control();
	
	-- set up restore camera if we need to
	if self.restore_cam_time >= 0 and not self.restore_cam_pos and not self.restore_cam_target then
		self.restore_cam_pos = self.cam:position();
		self.restore_cam_target = self.cam:target();
	end;
	
	-- if this cutscene is skippable then register the ESC key listener
	if self.skippable and not self.is_ambush and not bm:is_multiplayer() then
		bm:steal_escape_key_with_callback(self.name, function() self:skip() end);
	end;
	
	-- if this is an ambush cutscene, poll whether the ambush cutscene is running and skip when it's not
	if self.is_ambush then
		local cam = bm:camera();
		cam:allow_user_to_skip_ambush_intro(true);
		
		if self.teleport_on_ambush_cutscene_end then
			cam:teleport_defender_when_ambush_intro_skipped(true);
		end;
		
		-- poll whether the ambush controller is running
		local callback_name = self.name .. "_ambush_controller_poll";
		bm:repeat_callback(
			function() 
				if not cam:is_ambush_controller_executing() then
					bm:remove_process(callback_name);
					self:skip();
				end;
			end, 
			100, 
			callback_name
		);
	end;
	
	self.is_running = true;
	self.is_skipped = false;
	
	-- enable debug timestamps if necessary
	if self.debug_timestamps then
		self:output_debug_timestamp();
	end;

	-- send a script message/event that a cutscene is starting
	get_messager():trigger_message("cutscene_starting");
	core:trigger_event("ScriptEventBattleCutsceneStarting", self.name)
		
	-- start processing our actions
	self:process_next_action();
		
	return true;
end;


-- called internally when the cutscene starts to add cinematic trigger listeners that automatically respond to certain cinematic events and perform automatic actions like show advice and subtitles
function cutscene:start_cinematic_trigger_listeners(should_start)
	local listener_name = self.name .. "_cinematic_trigger_listeners";

	if should_start then
		core:add_listener(
			listener_name,
			"CinematicTrigger",
			true,
			function(context)
				local trigger_str = context.string;

				-- automatic behaviour
				if trigger_str == "_hide_subtitles" then
					bm:out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - hiding subtitles");
					bm:hide_subtitles();
				elseif trigger_str == "_dismiss_advice" then
					bm:out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - dismissing advice");
					bm:stop_advisor_queue(true);
				elseif trigger_str:starts_with("_advice_") then
					local advice_key = trigger_str:sub(9);					-- char 9 to the end, length of "_advice_" + 1
					bm:out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - triggering advice with key " .. tostring(advice_key));
					bm:stop_advisor_queue();
					bm:queue_advisor(advice_key);
				elseif trigger_str:starts_with("_subtitle_") then
					local subtitle_key = trigger_str:sub(11);				-- char 11 to the end, length of "_subtitle_" + 1
					bm:out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - triggering subtitle with key " .. tostring(subtitle_key));
					bm:show_subtitle(subtitle_key);
				elseif trigger_str:starts_with("_force_subtitle_") then
					local subtitle_key = trigger_str:sub(17);				-- char 17 to the end, length of "_force_subtitle_" + 1
					bm:out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - forcing subtitle with key " .. tostring(subtitle_key));
					bm:show_subtitle(subtitle_key, false, true);
				elseif trigger_str:starts_with("_vo_") then
					local sound_name = trigger_str:sub(5);					-- char 5 until the end, length of "_vo_" + 1
					bm:out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - playing sound at camera with event name " .. tostring(sound_name));
					self:play_sound(new_sfx(sound_name));
					
				-- custom trigger
				elseif self.cinematic_triggers[trigger_str] then					
					bm:out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - triggering callback");
					
					self.cinematic_triggers[trigger_str]();
				else
					bm:out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - no callback registered for this id");
				end;
			end,
			true
		);
	else
		core:remove_listener(listener_name);
	end;
end;


-- called internally to print debug timestamps each tick
function cutscene:output_debug_timestamp(count)
	if not self.is_running then
		return;
	end;

	count = count or 0;
	
	bm:out("\t\t" .. self.name .. " tick " .. count .. " [" .. count * 100 .. "ms after start]");
	
	bm:callback(function() self:output_debug_timestamp(count + 1) end, 100, self.name);
end;


-- called internally if we want the cutscene system to wait for a battle speech camera to finish playing.
function cutscene:wait_for_camera()
	self.camera_wait = true;
end;

-- perform the next action in the cutscene action list
function cutscene:process_next_action()
	if not self.is_running then
		script_error(self.name .. " WARNING:  tried to process an action while not active, the action didn't happen.");		
		return false;
	end;

	if self.action_ptr > #self.action_list then		
		return false;
	end;
	
	--action_time is the absolute time from the battle start that we reckon the next action should take place
	local action_time = self.start_time + self.action_list[self.action_ptr].delay + self.wait_offset;
	
	--if it's not time for the next action to be processed, then check again when it is
	local time_elapsed_ms = bm:time_elapsed_ms();
	if action_time > (time_elapsed_ms + bm:model_tick_time_ms()) then
		local next_time = self.action_list[self.action_ptr].delay + self.wait_offset - (time_elapsed_ms - self.start_time)
		bm:callback(function() self:process_next_action() end, next_time, self.name);
		
		return false;	
	end;
	
	--check if the advisor has finished (if we need to). If it's not finished, wait 500ms and try again
	if self.advisor_wait then
		if self:is_playing_sound() then
		-- if not bm:advice_finished() then
			self.wait_offset = self.wait_offset + 500;
			bm:callback(function() self:process_next_action() end, 500, self.name);
			
			return false;
		else
			self.advisor_wait = false;
		end;
	end;

	--check if subtitle vo has finished (if we need to). If it's not finished, wait 500ms and try again
	if self.vo_wait then
		if self:is_playing_sound() then
			self.wait_offset = self.wait_offset + 500;
			bm:callback(function() self:process_next_action() end, 500, self.name);
			
			return false;
		else
			self.vo_wait = false;
		end;
	end;
	
	if self.camera_wait then
		-- Code function.
		if self:is_playing_camera() then
			self.wait_offset = self.wait_offset + 500;
			bm:callback(function() self:process_next_action() end, 500, self.name);
			
			return false;
		else
			self.camera_wait = false;
		end;
	end;
	
	if self.is_debug then
		bm:out(self.name .. " : processing action " .. self.action_ptr);
	end;
		
	--call the current action in the queue, and then speculatively try the next in the queue (unless this is the last action)
	self.action_list[self.action_ptr].callback();
	
	if not self.action_list[self.action_ptr].is_terminator and not self.is_skipped then
		self.action_ptr = self.action_ptr + 1;
		self:process_next_action();
	end;
	
	return true;
end;










----------------------------------------------------------------------------
--- @section Subtitles
----------------------------------------------------------------------------


--- @function show_custom_cutscene_subtitle
--- @desc Streams a line of subtitles. Use this method of subtitle display within an @cutscene:action to animate the appearance of the supplied text over a supplied duration. Once a subtitle is shown with this function, it can later be hidden with @cutscene:hide_custom_cutscene_subtitles (which is also called automatically when this function is called, to hide any subtitles already visible).
--- @desc This functionality is provided by an extension to the @text_pointer system. As this behaviour is controlled by script, which only updates every 1/10th second, blocks of characters may appear at the same time instead of each character individually. This system should probably be moved into code at some point.
--- @p string subtitle key, Subtitle key, from the scripted_subtitles table.
--- @p string style, Text pointer style, from the valid entries in @text_pointer:set_style. "subtitle_with_frame" is in use by existing quest battles but more styles may be available.
--- @p number duration, Time the text takes to stream on-screen in ms.
--- @p [opt=false] boolean force, Force display of the subtitles. Setting this to true overrides the user's subtitle preference.
function cutscene:show_custom_cutscene_subtitle(key, style, duration, force_display)
	if not is_string(key) then
		script_error(self.name .. " ERROR: show_custom_cutscene_subtitle() called but supplied text key [" .. tostring(key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(style) then
		script_error(self.name .. " ERROR: show_custom_cutscene_subtitle() called but supplied style [" .. tostring(style) .. "] is not a string");
		return false;
	end;
	
	duration = duration or false;
	
	if duration and (not is_number(duration) or duration <= 0) then
		script_error(self.name .. " ERROR: show_custom_cutscene_subtitle() called but supplied duration [" .. tostring(duration) .. "] is not number > 0 or nil");
		return false;
	end;
	
	force_display = not not force_display;
	
	-- hide any previous subtitles
	self:hide_custom_cutscene_subtitles(true);

	-- construct the text pointer
	local tp = text_pointer:new("custom_cutscene_subtitle_" .. tostring(core:get_unique_counter()));
	tp:add_component_text("text", key);
	
	-- set the style
	tp:set_style(style);
	
	if duration then
		tp:set_stream_duration(duration);
	end;
	
	tp:show(force_display);
	
	table.insert(self.custom_cutscene_subtitles, tp);
end;


--- @function hide_custom_cutscene_subtitles
--- @desc Hides any visible custom cutscene subtitles. The hide effect will be animated, unless <code>true</code> is passed in as a single argument which hides the subtitles immediately.
--- @p [opt=false] boolean hide immediately
function cutscene:hide_custom_cutscene_subtitles(immediately)
	for i = 1, #self.custom_cutscene_subtitles do
		self.custom_cutscene_subtitles[i]:hide(immediately);
	end;
	
	self.custom_cutscene_subtitles = {};
end;


--- @function show_esc_prompt
--- @desc Shows or hides a "Press ESC to continue" subtitle prompt. It is intended that this should be called during an @cutscene:action.
--- @p [opt=true] @boolean should show
function cutscene:show_esc_prompt(value)
	if not self.is_running then
		return;
	end;
	
	if value == false then
		if self.esc_to_continue_prompt_active then
			self.esc_to_continue_prompt_active = false;
			bm:hide_subtitles();
		end;
	else
		if not self.esc_to_continue_prompt_active then
			self.esc_to_continue_prompt_active = true;
			bm:show_subtitle("esc_to_skip_cutscene", false, true);
		end;
	end;
end;











----------------------------------------------------------------------------
--- @section Skipping
----------------------------------------------------------------------------


--- @function skip
--- @desc Causes the cutscene to skip. This function is called internally when the ESC key is pressed, but it may also be called externally while the cutscene is running.
--- @p [opt=true] @boolean should stop sounds
function cutscene:skip(should_stop_sounds)
	if not self:is_active() then
		script_error(self.name .. " WARNING: skip() called when not running");
		
		return false;
	end;
	
	bm:remove_process(self.name);
	
	self.is_skipped = true;
	
	-- remove esc to continue prompt if active
	self:show_esc_prompt(false);
	
	-- stop any currently-playing sounds
	should_stop_sounds = (should_stop_sounds ~= false);
	if should_stop_sounds then
		for i = 1, #self.sounds do
			stop_sound(self.sounds[i]);
		end;
	end;
	
	-- unregister this function as an ESC key listener
	bm:release_escape_key_with_callback(self.name);

	-- stop any cinematic trigger listeners
	self:start_cinematic_trigger_listeners(false);
	
	-- hide any custom cutscene subtitles
	self:hide_custom_cutscene_subtitles(true);
	
	-- fade to black if there's a fade-in time
	if self.post_cutscene_fade_time ~= 0 then
		self.cam:fade(true, 0, true);
	end;
	
	-- after 0.2 seconds, skip the cutscene
	bm:callback(
		function()
			-- stop music
			if self.music then
				bm:stop_music(true);
			end;
			
			-- if we're set to never end, then we will always come through here so don't bother with output
			if self.length == nil then
				if self.is_ambush then
					bm:out("Ambush has completed, skipping cutscene " .. tostring(self.name));
				else
					bm:out("Skipping remainder of cutscene " .. tostring(self.name));
				end;
			end;
			
			if self.skip_callback then
				self.skip_callback();
			end;
	
			if self.skip_cam_pos and self.skip_cam_target then
				bm:camera():move_to(self.skip_cam_pos, self.skip_cam_target, 0, false, 0);
			else
				if self.restore_cam_time >= 0 and self.restore_cam_pos and self.restore_cam_target then	
				
					-- if we have faded to black, then instruct the next function to cut rather than pan
					local should_cut = false;
				
					if self.post_cutscene_fade_time ~= 0 then
						should_cut = true;
					end;					
				
					self:restore_camera_and_release(true, should_cut);
				
					return;
				end;
			end;
			
			self:release(true);
		end,
		200
	);
end;


-- called internally when the cutscene finishes without skipping
function cutscene:finish()
	-- unregister this function as an ESC key listener
	bm:release_escape_key_with_callback(self.name);

	-- stop any cinematic trigger listeners
	self:start_cinematic_trigger_listeners(false);
	
	-- remove esc to continue prompt if active
	self:show_esc_prompt(false);

	if self.restore_cam_time >= 0 and self.restore_cam_pos and self.restore_cam_target then		
		self:restore_camera_and_release();
		
		-- exit here so we don't call release twice
		return;
	end;
		
	self:release();
end;


-- called internally when the cutscene ends, either by skipping or ending naturally
function cutscene:restore_camera_and_release(was_skipped, should_cut)
	local restore_time = self.restore_cam_time;
	
	if should_cut then
		restore_time = 0;
	end;

	-- move camera to end position
	bm:camera():move_to(self.restore_cam_pos, self.restore_cam_target, restore_time, false, 0);
		
	-- call release when we're back
	if restore_time == 0 then
		self:release(was_skipped);
	else
		bm:callback(
			function() 
				self:release(was_skipped) 
			end, 
			restore_time * 1000,
			self.name
		);
	end;
end;


-- final finishing call made internally after the camera is released
function cutscene:release(was_skipped)
	if self.steal_input_focus and not self.is_debug then
		bm:steal_input_focus(false, true);
	end;

	-- end cindy scenes if we should
	if self.stop_cindy_scene_on_finish then
		bm:stop_cindy_playback();
	end;
	
	-- Set camera/ui back to default (make sure we haven't 
	-- launched straight into another cutscene first)
	bm:callback(
		function()				
			if not self:is_any_cutscene_running() then
				-- disable the cinematic ui (if it's enabled)
				if self.should_enable_ui_on_end and self.should_hide_ui and (not self.is_debug or self.hide_ui_in_debug) then
					bm:enable_cinematic_ui(false, true, false);
				end;

				if self.should_restore_ui_hiding_on_end then
					bm:restore_ui_hiding();
				end;
				
				local cam = self.cam;
			
				cam:enable_anchor_to_army();
				cam:change_height_range(-1, -1);
				cam:enable_shake();

				if self.should_enable_cinematic_camera then
					bm:enable_cinematic_camera(false);
				end;
				
				if self.should_restore_battle_speed then
					bm:restore_battle_speed();
				end;
				
				-- perform fade-in (if we have to)
				if self.post_cutscene_fade_time > 0 then
					-- if a value for post_cutscene_fade_time_delay is set then delay the fade in
					if self.post_cutscene_fade_time_delay > 0 then
						bm:callback(function() cam:fade(false, self.post_cutscene_fade_time) end, self.post_cutscene_fade_time_delay);
					else
						cam:fade(false, self.post_cutscene_fade_time);
					end;
				end;
			end;
		end, 
		100,
		"Cutscene_Camera_Anchor"
	);
	
	-- wait a while before unsuppressing unit voices (so they
	-- don't start gabbling immediately after cutscene ends)
	bm:callback(
		function()
			if not self:is_any_cutscene_running() and self.suppress_unit_vo then
				bm:suppress_unit_voices(false);
				bm:suppress_unit_musicians(false);
			end;
		end,
		2000,
		"Cutscene_Unsuppress_Unit_Voices"
	);
	
	-- re-enable unit ids if they were disabled
	if self.should_disable_unit_ids then
		bm:enable_unit_ids(true);
	end;
		
	-- restore battle time elapse setting
	bm:restore_conflict_time_update_overridden();
	
	bm:out("Ending cutscene " .. tostring(self.name));
	self.is_running = false;
	-- remove pending actions
	bm:remove_process(self.name);
	
	-- the cutscene may have been delayed due to waiting for stuff, if so inform the user
	if self.wait_offset > 0 then
		bm:out("Cutscene " .. self.name .. " was " .. self.wait_offset .. "ms longer than specified due to waiting for VO to complete.");
	end;
	
	-- release the player's army
	if self.should_release_players_army then
		self.players_army:release_control();
	end;
	
	-- hide the advisor close button if we should
	if not bm:is_benchmarking_mode() and not bm:is_multiplayer() then
		if not self.make_advisor_progress_button_visible_on_end or not bm:has_advice_played_this_battle() then
			show_advisor_progress_button(false);
		else
			show_advisor_progress_button(true);
		end;
	end;
	
	-- clear advisor and subtitles
	if self.close_advisor_on_end then
		bm:stop_advisor_queue(true);
	end;
	
	if self.my_subtitles then
		self.my_subtitles:clear();
	end;
	
	-- send a script message that a cutscene has finished (useful for generated battles)
	get_messager():trigger_message("cutscene_ended");
	core:trigger_event("ScriptEventBattleCutsceneEnded", self.name)
	
	-- end callback (must happen last!)
	if not self.is_skipped or self.call_end_callback_when_skipped then
		if is_function(self.end_callback) then
			self.end_callback(was_skipped);
		end;
	end;
end;












--
--	function to track the movement of a unit commander. returns a vector of a camera position from the unit commander.
--	parameters are the unit to track, its movement speed (look in battle_entities table), 
-- the horizontal tracking angle in degrees (zero being looking head on at the general), 
-- the vertical tracking angle in degrees (positive being above the unit, negative below), 
-- the camera distance to target (2D, height not considered),
--	the height of the unit above ground level to track (i.e. distance from commanders feet to head), 
-- and the time into the future to return the camera position.
--	predictive results assume that the unit is moving on a straight course on level ground
--

-- @function track_unit_commander
-- @desc Returns a vector position that is offset by supplied values from the predicted position of a unit's commander. Intended to be used during cutscene scripts to position the camera relative to a moving unit.
-- @p unit unit, Unit to track.
-- @p number movement speed, Movement speed of the unit. This can be looked up in the battle_entities table.
-- @p number horizontal angle, Horizontal tracking angle of the intended camera position in degrees. Zero would results in the camera looking head on at the general. 
-- @p number vertical angle, Vertical tracking angle of the intended camera position in degrees. A positive angle would position the camera above the general, a negative number below.
-- @p number distance, Camera distance to general, in m.
-- @p number general height, The height of the unit above ground level to track i.e. the distance from the commander's head to the ground.
-- @p number time, Time into the future to return the camera position in seconds.
-- @return vector position offset from predicted future position of unit.
function track_unit_commander(unit, movement_speed, tracking_angle_h, tracking_angle_v, tracking_distance, tracking_height, t)
	local angle_of_unit_movement = unit:bearing();
	-- local commander_position = unit:position_of_officer();
	local commander_position = unit:position();
	local commander_position_x = commander_position:get_x();
	local commander_position_y = commander_position:get_y();
	local commander_position_z = commander_position:get_z();

	local pos_x = commander_position_x + movement_speed * t * math.sin(d_to_r(angle_of_unit_movement)) + tracking_distance * math.sin(d_to_r(angle_of_unit_movement + tracking_angle_h));
	local pos_y = commander_position_y + tracking_height + tracking_distance * math.tan(d_to_r(tracking_angle_v));
	local pos_z = commander_position_z + movement_speed * t * math.cos(d_to_r(angle_of_unit_movement)) + tracking_distance * math.cos(d_to_r(angle_of_unit_movement + tracking_angle_h));
	
	return v(pos_x, pos_y, pos_z);
end;





--
--	function to predict the position of a units commander in the future. Assumes the unit is travelling in a straight line on level ground.
--	Takes the unit, its movement speed (from the battle_entities table, hopefully we will be able to look this up automatically in future), the
--	time offset in seconds, and a height by which to offset the returned position by in m (as the position of a unit is flat on the ground).
--	The final parameter allows the scripter to override the units bearing in degrees, as sometimes the game just doesn't report this usefully.
--	Returns a vector of the predicted commander position.
--

function predict_commander_position(unit, movement_speed, t, height_offset, bearing)
	local angle_of_unit_movement = 0;
	
	if is_number(bearing) then
		angle_of_unit_movement = bearing;
	else
		angle_of_unit_movement = d_to_r(unit:bearing());
	end;
	
	-- local commander_position = unit:position_of_officer();
	local commander_position = unit:position();
	local commander_position_x = commander_position:get_x();
	local commander_position_y = commander_position:get_y();
	local commander_position_z = commander_position:get_z();
	
	local ret_pos_x = commander_position_x + movement_speed * t * math.sin(angle_of_unit_movement);
	local ret_pos_y = commander_position_y + height_offset;
	local ret_pos_z = commander_position_z + movement_speed * t * math.cos(angle_of_unit_movement);
	
	return v(ret_pos_x, ret_pos_y, ret_pos_z);
end;



--
--	Gets a camera tracking offset from a position. Intended to be used in conjunction with predict_commander_position to be able to track a commander
--	marching into battle during a cutscene, but could be used with any position.
--	Takes a vector position, a horizontal tracking bearing (from north) in degrees, a vertical tracking bearing in degrees (positive being above the position, negative below),
--	and a 2D distance in m that the camera should be.
--	Returns a vector of the camera position.
--

function get_tracking_offset(pos, tracking_angle_h, tracking_angle_v, tracking_distance)
	local pos_x = pos:get_x();
	local pos_y = pos:get_y();
	local pos_z = pos:get_z();
	
	local ret_pos_x = pos_x + tracking_distance * math.sin(d_to_r(tracking_angle_h));
	local ret_pos_y = pos_y + tracking_distance * math.tan(d_to_r(tracking_angle_v));
	local ret_pos_z = pos_z + tracking_distance * math.cos(d_to_r(tracking_angle_h));
	
	return v(ret_pos_x, ret_pos_y, ret_pos_z);
end;







--
--	
--

function get_track_commander_positions(sunit, h_camera_bearing, v_camera_bearing, camera_distance, commander_height, unit_speed, tracking_time_offset, tracking_time, change_in_terrain_height)

	if not is_scriptunit(sunit) then
		script_error("get_track_commander_positions ERROR: supplied sunit [" .. tostring(sunit) .. "] is not a scriptunit");
		return false;
	end;
	
	if not is_number(h_camera_bearing) then
		script_error("get_track_commander_positions ERROR: supplied horizontal camera bearing [" .. tostring(h_camera_bearing) .. "] is not a number");
		return false;
	end;
	
	if not is_number(v_camera_bearing) then
		script_error("get_track_commander_positions ERROR: supplied vertical camera bearing [" .. tostring(v_camera_bearing) .. "] is not a number");
		return false;
	end;
	
	if not is_number(camera_distance) or camera_distance <= 0 then
		script_error("get_track_commander_positions ERROR: supplied camera distance [" .. tostring(camera_distance) .. "] is not a number greater than zero");
		return false;
	end;
	
	if not is_number(commander_height) or commander_height <= 0 then
		script_error("get_track_commander_positions ERROR: supplied commander height [" .. tostring(commander_height) .. "] is not a number greater than zero");
		return false;
	end;
	
	if not is_number(unit_speed) or unit_speed <= 0 then
		script_error("get_track_commander_positions ERROR: supplied unit speed [" .. tostring(unit_speed) .. "] is not a number greater than zero");
		return false;
	end;
	
	if not is_number(tracking_time_offset) or tracking_time_offset < 0 then
		script_error("get_track_commander_positions ERROR: supplied tracking time offset [" .. tostring(tracking_time_offset) .. "] is not a positive number");
		return false;
	end;
	
	if not is_number(tracking_time) or tracking_time <= 0 then
		script_error("get_track_commander_positions ERROR: supplied tracking time [" .. tostring(tracking_time) .. "] is not a positive number");
		return false;
	end;
	
	if not is_number(change_in_terrain_height) then
		script_error("get_track_commander_positions ERROR: supplied change in terrain height [" .. tostring(change_in_terrain_height) .. "] is not number");
		return false;
	end;
	
	-- compute current commander/camera positions and future commander/camera positions
	local current_commander_pos = predict_commander_position(sunit.unit, unit_speed, tracking_time_offset, commander_height, roman_bearing_override);
	local current_camera_pos = get_tracking_offset(current_commander_pos, sunit.unit:bearing() + h_camera_bearing, v_camera_bearing, camera_distance);
	
	local future_commander_pos = predict_commander_position(sunit.unit, unit_speed, tracking_time, commander_height, roman_bearing_override);
	local future_camera_pos = get_tracking_offset(future_commander_pos, sunit.unit:bearing() + h_camera_bearing, v_camera_bearing, camera_distance);
	
	-- compensate for terrain height change
	future_commander_pos = v_offset(future_commander_pos, 0, change_in_terrain_height, 0);
	future_camera_pos = v_offset(future_camera_pos, 0, change_in_terrain_height, 0);

	return current_camera_pos, current_commander_pos, future_camera_pos, future_commander_pos;
end;
