
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	CAMPAIGN CUTSCENES
--
---	@set_environment campaign
--- @c campaign_cutscene Campaign Cutscenes
--- @desc The campaign cutscene library provides an interface for the relatively easy creation and setup of scripted cutscenes in campaign. A cutscene object is first declared with @campaign_cutscene:new, configured with the variety of configuration commands available, loaded with actions (things that happen within the cutscene) using repeated calls to @campaign_cutscene:action, and finally started with @campaign_cutscene:start to start the visual cutscene itself. Each campaign cutscene object represents an individual cutscene.
--- @desc See also the @"campaign_manager:Camera Movement" functions on the campaign manager, which allow the camera to be scrolled within a cutscene without having to manually set up a campaign cutscene object.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------



campaign_cutscene = {
	-- startup and internal params
	name = "",
	cumulative_time = 0,
	cutscene_length = nil,	-- If nil, the cutscene will not end without user input.
	relative_mode = false,	-- Whether or not actions added to this cutscene have their delay relative to the last action, or to the start of the cutscene.
	action_list = {},
	cutscene_has_end_action = false,	-- If true, this means the cutscene's end-time was set via action_end_cutscene.
	cinematic_triggers = {},
	is_running = false,
	wait_offset = 0,
	end_callback = nil,
	advisor_wait = false,
	intro_cutscene = false,

	-- skipping params
	is_skippable = true,
	is_skipped = false,
	skip_cam_x = false,
	skip_cam_y = false,
	skip_cam_d = false,
	skip_cam_b = false,
	skip_cam_h = false,
	skip_callback = nil,

	-- restore camera
	restore_cam_time = -1,
	restore_cam_x = false,
	restore_cam_y = false,
	restore_cam_d = false,
	restore_cam_b = false,
	restore_cam_h = false,
	restore_ui = true,
	restore_shroud = true,

	-- debug
	is_debug = false,

	-- music
	music_trigger_argument = nil,

	-- misc params
	dismiss_advice_on_end = true,
	disable_settlement_labels = true,
	neighbouring_regions_visible = false,
	use_cinematic_borders = true,
	do_not_skip_on_next_advice_dismissal = false,
	call_end_callback_when_skipped = true,
	disable_shroud = false,
	playing_cindy_camera = false,
	cindy_camera_specified = false,
	event_panels_enabled = true,
	enable_ui_hiding_on_release = true,
	should_send_recieve_metrics_data = false,
	fade_to_black_on_skip = true,
	fade_to_picture_after_skip_time = 1,
	fade_to_picture_after_skip_delay = 1,
	show_advisor_close_button_on_end = false,
};


set_class_custom_type(campaign_cutscene, TYPE_CAMPAIGN_CUTSCENE);
set_class_tostring(
	campaign_cutscene, 
	function(obj)
		return TYPE_CAMPAIGN_CUTSCENE .. "_" .. obj.name
	end
);





----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates a cutscene object. A cutscene must be given a unique string name, a length in seconds and optionally an end callback.
--- @p @string name, Unique name for the cutscene.
--- @p [opt=nil] @number duration, Cutscene duration in seconds. If nil or 0 is specified then the cutscene will be set to not end unless <code>action_end_cutscene</code> is used, and will only finish when skipped by the player or ended by an external process.
--- @p [opt=nil] function end callback, End callback.
--- @p [opt=nil] bool send_metrics_data, Send performance data to metrics.
--- @r campaign_cutscene cutscene object
function campaign_cutscene:new(name, length, end_callback, send_metrics_data)

	send_metrics_data = send_metrics_data or false;

	-- type-check our parameters
	if not is_string(name) then
		script_error("ERROR: tried to create a campaign_cutscene but supplied name [" .. tostring(name) .."] is not a string");
		return false;
	end;
	
	local full_name = "Campaign_Cutscene_" .. name;
	
	if length then
		if length == 0 then
			length = nil;
		elseif not is_number(length) or length < 0 then
			script_error(full_name .. " ERROR: tried to create a campaign_cutscene but supplied length [" .. tostring(length) .. "] is not a number, 0 or nil");
			return false;
		end;
	end;
	
	if not is_function(end_callback) and not is_nil(end_callback) then
		script_error(full_name .. " ERROR: tried to create a campaign_cutscene but supplied end callback [" .. tostring(end_callback) .. "] is not a function or nil");
		return false;
	end;
		
	cc = {};
	
	cc.name = full_name;

	set_object_class(cc, self);

	-- if a length has not been supplied then set this cutscene to only end when skipped
	cc.cutscene_length = length;

	cc.end_callback = end_callback;
	cc.should_send_recieve_metrics_data = send_metrics_data;
	
	cc.action_list = {};
	cc.cinematic_triggers = {};
	
	cm:register_cutscene(cc);
	
	return cc;
end;


--- @function new_from_cindyscene
--- @desc Creates a cutscene object that is bound to a cindyscene. When started, the scripted cutscene will automatically start the cindyscene, and will terminate when the cindyscene ends.
--- @p @string name, Unique name for the cutscene.
--- @p [opt=nil] @function end callback, End callback.
--- @p @string cindy scene, Cindy scene path.
--- @p [opt=0] @number blend in, Blend in time, in seconds.
--- @p [opt=10] @number blend out, Blend out time, in seconds.
--- @r campaign_cutscene cutscene object
function campaign_cutscene:new_from_cindyscene(name, end_callback, cindy_scene, blend_in_duration, blend_out_duration, send_metrics_data)

	if not is_string(cindy_scene) then
		script_error("ERROR: campaign_cutscene:new_from_cindyscene() called but supplied cindy scene path [" .. tostring(cindy_scene) .. "] is not a string");
		return false;
	end;

	local cc = campaign_cutscene:new(
		name,
		nil,
		end_callback,
		send_metrics_data
	);

	if not cc then
		return false;
	end;

	-- If we've loaded in minimalist dev mode or the cinematic editor is attached then cindy scenes will not work, so instead just end after a short period
	if CampaignUI.IsMinimalViewModeEnabled() or cm:is_replay() or cm:is_cinematic_editor_attached() then
		-- fade to black immediately
		cc:action(function() cm:fade_scene(0, 0) end, 0);

		cc:action(
			function()
				out(self.name .. " is skipping immediately because the campaign is running in minimal view, it's a replay, or the cinematic editor is attached");

				-- fade to picture
				cm:fade_scene(1, 0.5);

				cc:skip();
			end,
			1
		);
	else
		cc:action(function() cc:cindy_playback(cindy_scene, blend_in_duration, blend_out_duration) end, 0);

		cc:add_cinematic_trigger_listener(
			"end_cinematic",
			function()
				cc:finish();
			end
		);
	end;

	return cc;
end;











----------------------------------------------------------------------------
---	@section Usage
--- @desc Once a cutscene object has been created with @campaign_cutscene:new, functions on it may be called using the following form.
--- @new_example Specification
--- @example <i>&lt;cutscene_object&gt;</i>:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example local cutscene_intro = campaign_cutscene:new(
--- @example 	"intro",
--- @example 	48,
--- @example 	function() intro_cutscene_has_ended() end
--- @example )
--- @example cutscene_intro:set_debug(true)				-- calling a function on the object once created
----------------------------------------------------------------------------






----------------------------------------------------------------------------
--- @section Debug
----------------------------------------------------------------------------


--- @function set_debug
--- @desc Sets the cutscene into debug mode for more output.
--- @p [opt=true] boolean set debug
function campaign_cutscene:set_debug(is_debug)
	if is_debug == nil then
		self.is_debug = true;
	else
		self.is_debug = is_debug;
	end;
end;


--- @function set_debug_all
--- @desc Sets all campaign cutscenes into debug mode for more output.
--- @p [opt=true] boolean set debug
function campaign_cutscene:set_debug_all(is_debug)
	cm:set_campaign_cutscene_debug(is_debug);
end;










----------------------------------------------------------------------------
--- @section Configuration and Querying
----------------------------------------------------------------------------


--- @function set_skippable
--- @desc Sets whether the cutscene should be skippable or not, and also allows the optional specification of a callback to be called if the cutscene is skipped. Note that if a skip callback and end callback are both set, both will be called (in that order).
--- @p [opt=true] boolean set skippable
--- @p [opt=nil] function skip callback
function campaign_cutscene:set_skippable(skippable, callback)
	if skippable == false then
		self.is_skippable = false;
	else
		self.is_skippable = true;
	end;
	
	if is_function(callback) then
		self.skip_callback = callback;
	end;
end;


--- @function set_dismiss_advice_on_end
--- @desc Sets whether the dismiss the advisor at the end of the cutscene. By default the advisor is skipped - use this function to disable this behaviour.
--- @p [opt=true] boolean dismiss advice
function campaign_cutscene:set_dismiss_advice_on_end(value)
	if value == false then
		self.dismiss_advice_on_end = false;
	else
		self.dismiss_advice_on_end = true;
	end;
end;


--- @function set_use_cinematic_borders
--- @desc Sets the cutscene to show cinematic borders whilst playing, or not. Cutscenes by default will show cinematic borders - use this function to disable this behaviour.
--- @p [opt=true] boolean show borders
function campaign_cutscene:set_use_cinematic_borders(value)
	if value == false then
		self.use_cinematic_borders = false;
	else
		self.use_cinematic_borders = true;
	end;
end;


--- @function set_restore_ui
--- @desc Tells the cutscene whether to restore the ui when it ends, or not. Cutscenes by default will restore the ui - use this function to disable this behaviour. This is useful in highly specific circumstances.
--- @p [opt=true] boolean restore ui
function campaign_cutscene:set_restore_ui(value)
	if value == false then
		self.restore_ui = false;
	else
		self.restore_ui = true;
	end;
end;


--- @function set_disable_settlement_labels
--- @desc Tells the cutscene whether to show settlement labels while playing or not. Cutscenes by default will hide settlement labels - use this function to disable this behaviour.
--- @p [opt=true] boolean disable labels
function campaign_cutscene:set_disable_settlement_labels(value)
	if value == false then
		self.disable_settlement_labels = false;
	else
		self.disable_settlement_labels = true;
	end;
end;


--- @function set_neighbouring_regions_visible
--- @desc Tells the cutscene whether to make neighbouring regions visible or not. Cutscenes by default will not do this - use this function to enable this behaviour if required. The 'neighbouring' regions in this case are those regions adjacent to the regions currently unshrouded.
--- @desc Setting this property to true also enables the shroud.
--- @p [opt=true] boolean disable labels
function campaign_cutscene:set_neighbouring_regions_visible(value)
	if value == false then
		self.neighbouring_regions_visible = false;
	else
		self.neighbouring_regions_visible = true;
		self.disable_shroud = false;
	end;
end;


--- @function set_disable_shroud
--- @desc Tells the cutscene whether to show the shroud during playback, or not. By default the shroud is displayed - use this function to disable it if required.
--- @p [opt=true] boolean disable shroud
function campaign_cutscene:set_disable_shroud(value)
	if value == false then
		self.disable_shroud = false;
	else
		self.disable_shroud = true;
		self.neighbouring_regions_visible = false;
	end;
end;


--- @function set_restore_shroud
--- @desc Tells the cutscene whether to restore the shroud after completion to the state it was in before the cutscene started, or not. By default the shroud is restored - use this function to disable this behaviour if required.
--- @p [opt=true] boolean restore shroud
function campaign_cutscene:set_restore_shroud(value)
	if value == false then
		self.restore_shroud = false;
	else
		self.restore_shroud = true;
	end;
end;


--- @function set_show_advisor_close_button_on_end
--- @desc Tells the cutscene whether to show the advisor close button after the cutscene is finished or not. By default the close button is not shown - use this function to show the button at the end of the cutscene.
--- @p [opt=true] @boolean show advisor close button
function campaign_cutscene:set_show_advisor_close_button_on_end(value)
	if value == false then
		self.show_advisor_close_button_on_end = false;
	else
		self.show_advisor_close_button_on_end = true;
	end;
end;


--- @function set_intro_cutscene
--- @desc Tells the cutscene system that this cutscene is a faction intro cutscene. Intro cutscenes inform the campaign manager when they start and stop, and also trigger an additional <code>"ScriptEventCampaignIntroCutsceneCompleted"</code> event when the cutscene completes.
--- @p [opt=true] @boolean is intro cutscene
function campaign_cutscene:set_intro_cutscene(value)
	if value == false then
		self.intro_cutscene = false;
	else
		self.intro_cutscene = true;
	end;
end;


--- @function is_intro_cutscene
--- @desc Returns whether this cutscene has been set to be an intro cutscene.
--- @r @boolean is intro cutscene
function campaign_cutscene:is_intro_cutscene()
	return self.intro_cutscene;
end;


--- @function set_end_callback
--- @desc Sets the cutscene end callback. This replaces any end callback previously set (e.g. with @campaign_cutscene:new).
--- @p function end callback
function campaign_cutscene:set_end_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: set_end_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	self.end_callback = callback;
end;


--- @function prepend_end_cutscene
--- @desc Adds the specified callback to the start of the existing end-callback, without overwriting the existing end-callback's contents. If there is no end-callback yet, this cutscene's end-callback will simply be set to the one provided.
--- @p @function callback, callback to prepend to the existing end-callback
function campaign_cutscene:prepend_end_cutscene(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: prepend_end_cutscene() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	if self.end_callback then
		local existing_end_callback = self.end_callback;
		self.end_callback = function()
			callback();
			existing_end_callback();
		end;
	end;
end;


--- @function has_end_callback
--- @desc Returns <code>true</code> if the cutscene has an end callback specified, <code>false</code> otherwise.
--- @r boolean has end callback
function campaign_cutscene:has_end_callback()
	return not not self.end_callback;
end;


--- @function set_call_end_callback_when_skipped
--- @desc Sets whether the cutscene should call the end callback (supplied when the cutscene is created with @cutscene:new) when skipped. By default the cutscene does call this callback - supply <code>false</code> as an argument to prevent it from doing so.
--- @p [opt=true] boolean should call callback
function campaign_cutscene:set_call_end_callback_when_skipped(new_value)
	if new_value == false then
		self.call_end_callback_when_skipped = false;
	else
		self.call_end_callback_when_skipped = true;
	end;
end;


--- @function set_fade_on_skip
--- @desc Sets whether the cutscene should immediately fade to black, and then optionally fade back to picture (after an optional delay), or not. By default the cutscene system will fade to black immediately if the cutscene is skipped, then wait a second, then fade to picture after a second. Use this function to change this behaviour.
--- @p [opt=true] @boolean fade to black, Fade to black immediately on skip.
--- @p [opt=1] @number fade to picture time, Time in seconds over which the cutscene will fade back to picture. If a negative number is supplied, or no fade to black is set, then no fade to picture is performed.
--- @p [opt=1] @number fade to picture delay, Time in seconds after the cutscene is skipped between the fade to black and the subsequent fade back to picture.
function campaign_cutscene:set_fade_on_skip(should_fade_to_black, fade_to_picture_time, fade_to_picture_delay)
	if should_fade_to_black == false then
		self.fade_to_black_on_skip = false;
	else
		self.fade_to_black_on_skip = true;
	end;

	if fade_to_picture_time then
		if not validate.is_number(fade_to_picture_time) then
			return false;
		end;

		self.fade_to_picture_after_skip_time = fade_to_picture_time;
	end;

	if fade_to_picture_delay then
		if not validate.is_number(fade_to_picture_delay) then
			return false;
		end;

		self.fade_to_picture_after_skip_delay = fade_to_picture_delay;
	end;
end;


--- @function set_skip_camera
--- @desc Sets a position at which the game camera is repositioned to if the cutscene is skipped. The reposition happens behind a fade to black so the player does not see it.
--- @desc If no position is supplied, the cutscene system takes the current position of the game camera as the skip camera position.
--- @desc Note that this reposition will not happen if the cutscene is not skipped. 
--- @p [opt=nil] number x, x co-ordinate. If no co-ordinates are set here the function takes the camera position at the moment the function is called.
--- @p [opt=nil] number y, y co-ordinate.
--- @p [opt=nil] number d, d co-ordinate.
--- @p [opt=nil] number b, b co-ordinate.
--- @p [opt=nil] number h, h co-ordinate.
function campaign_cutscene:set_skip_camera(x, y, d, b, h)
	
	-- if we have been given no position then use current
	if not x then
		x, y, d, b, h = cm:get_camera_position();
	elseif is_table(x) then
		y = x[2];
		d = x[3];
		b = x[4];
		h = x[5];
		x = x[1];
	else
		if not is_number(x) then
			script_error(self.name .. " ERROR: set_skip_camera() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a number or nil");
			return false
		end;
		
		if not is_number(y) then
			script_error(self.name .. " ERROR: set_skip_camera() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a number");
			return false
		end;
		
		if not is_number(d) then
			script_error(self.name .. " ERROR: set_skip_camera() called but supplied distance [" .. tostring(d) .. "] is not a number");
			return false
		end;
		
		if not is_number(b) then
			script_error(self.name .. " ERROR: set_skip_camera() called but supplied x co-ordinate [" .. tostring(b) .. "] is not a number");
			return false
		end;
		
		if not is_number(h) then
			script_error(self.name .. " ERROR: set_skip_camera() called but supplied x co-ordinate [" .. tostring(h) .. "] is not a number");
			return false
		end;
	end;
	
	if self.is_debug or cm:get_campaign_cutscene_debug() then
		out(self.name .. " setting skip camera to " .. cm:camera_position_to_string(x, y, d, b, h));
	end;
	
	self.skip_cam_x = x;
	self.skip_cam_y = y;
	self.skip_cam_d = d;
	self.skip_cam_b = b;
	self.skip_cam_h = h;
end;


--- @function set_restore_camera
--- @desc Sets co-ordinates to which the game camera is restored when the cutscene ends. If a restore camera position is specified, the camera is scrolled to that position at the end of the cutscene over the supplied time in seconds. This is useful when it's desired to return the camera to the position it started the cutscene at when the cutscene finishes, or to a different position.
--- @desc If no co-ordinates are supplied, the cutscene system takes the current position of the game camera as the restore camera position.
--- @desc Note that if a skip camera position is set with @campaign_cutscene:set_skip_camera, and the cutscene is skipped, the camera will be skipped and not restored. If the cutscene is skipped, has no skip camera position but has a restore camera position set, the camera will be immediately repositioned at the restore camera position while the screen is faded to black.
--- @p number time, Time in seconds over which to scroll the camera.
--- @p [opt=nil] number x, x co-ordinate. If no co-ordinates are set here the function takes the camera position at the moment the function is called.
--- @p [opt=nil] number y, y co-ordinate.
--- @p [opt=nil] number d, d co-ordinate.
--- @p [opt=nil] number b, b co-ordinate.
--- @p [opt=nil] number h, h co-ordinate.
function campaign_cutscene:set_restore_camera(t, x, y, d, b, h)

	if not is_number(t) then
		script_error(self.name .. " ERROR: set_restore_camera() called but supplied time [" .. tostring(t) .. "] is not a number");
		return false;
	end;
	
	self.restore_cam_time = t;
	
	-- if we have been given no position then we will use the current position (later, when the cutscene is started)
	if not x then
		return;
	end;
	
	-- if we've been given a table then convert it
	if is_table(x) then
		y = x[2];
		d = x[3];
		b = x[4];
		h = x[5];
		x = x[1];
	end;
	
	if not is_number(x) then
		script_error(self.name .. " ERROR: set_restore_camera() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a number or nil");
		return false;
	end;
	
	if not is_number(y) then
		script_error(self.name .. " ERROR: set_restore_camera() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a number");
		return false;
	end;
	
	if not is_number(d) then
		script_error(self.name .. " ERROR: set_restore_camera() called but supplied distance [" .. tostring(d) .. "] is not a number");
		return false;
	end;
	
	if not is_number(b) then
		script_error(self.name .. " ERROR: set_restore_camera() called but supplied x co-ordinate [" .. tostring(b) .. "] is not a number");
		return false;
	end;
	
	if not is_number(h) then
		script_error(self.name .. " ERROR: set_restore_camera() called but supplied x co-ordinate [" .. tostring(h) .. "] is not a number");
		return false;
	end;
	
	if self.is_debug or cm:get_campaign_cutscene_debug() then
		out(self.name .. " setting restore camera to " .. cm:camera_position_to_string(x, y, d, b, h));
	end;
	
	self.restore_cam_x = x;
	self.restore_cam_y = y;
	self.restore_cam_d = d;
	self.restore_cam_b = b;
	self.restore_cam_h = h;
end;


--- @function is_active
--- @desc Returns <code>true</code> if the cutscene is currently running, <code>false</code> otherwise.
--- @r boolean is active
function campaign_cutscene:is_active()
	return self.is_running;
end;


--- @function steal_input_immediately
--- @desc Instructs the cutscene to steal input immediately, before @campaign_cutscene:start() is called. This is useful for campaign intro cutscenes as there's a short window of opportunity for the player to interact with the game as the loading screen is fading out, before the cutscene starts.
--- @desc Note that cutscenes don't steal input when debug mode is set with @campaign_cutscene:set_debug or @campaign_cutscene:set_debug_all, which affects this command too.
function campaign_cutscene:steal_input_immediately()
	if not (self.is_debug or cm:get_campaign_cutscene_debug()) then
		cm:steal_user_input(true);
	end;
end;


--- @function set_music_trigger_argument
--- @desc Sets the cutscene music trigger argument to be passed to the music system when the cutscene starts
--- @p string music_trigger_argument, A uniquely identifying name for the cutscene relevant to the music system
function campaign_cutscene:set_music_trigger_argument(music_trigger_argument)
	if self.is_running then
		script_error(self.name .. " ERROR: trying to set music on a running cutscene");
		
		return false;
	end;
	
	if not is_string(music_trigger_argument) then
		script_error(self.name .. " ERROR: trying to set music but supplied trigger argument " .. tostring(music_trigger_argument) .. " is not a string");
		
		return false;
	end;

	self.music_trigger_argument = music_trigger_argument;
end


--- @function set_relative_mode
--- @desc Sets relative mode for enqueuing actions on the cutscene. With relative mode enabled, the time specified for each action is relative to the previously-added action, rather than absolute from the start of the cutscene. Relative mode is disabled by default.
function campaign_cutscene:set_relative_mode(relative_mode)
	self.relative_mode = relative_mode;
end;










----------------------------------------------------------------------------
--- @section Cinematic Triggers
--- @desc A cindy scene can be configured to send events to script, for which listeners may be established that call script functions. The function @campaign_cutscene:add_cinematic_trigger_listener may be used to establish such a listener. This mechanism allows cinematic artists to more tightly control the timing of events in the cindy scene.
----------------------------------------------------------------------------


--- @function add_cinematic_trigger_listener
--- @desc Registers a new cinematic trigger listener. When the cindy scene triggers a script event with the supplied id in script, the supplied function is called.
--- @p @string id, Cinematic trigger id. This should match the an id of a cinematic event triggered from a cindy scene played during this cutscene.
--- @p function callback, Callback to call.
function campaign_cutscene:add_cinematic_trigger_listener(id, callback)
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
--- @section Subtitles
----------------------------------------------------------------------------


--- @function show_esc_prompt
--- @desc Shows or hides a "Press ESC to continue" subtitle prompt. It is intended that this should be called during an @campaign_cutscene:action.
--- @p [opt=true] @boolean should show
function campaign_cutscene:show_esc_prompt(value)
	if not self.is_running then
		return;
	end;
	
	if value == false then
		if self.esc_to_continue_prompt_active then
			self.esc_to_continue_prompt_active = false;
			cm:hide_subtitles();
		end;
	else
		if not self.esc_to_continue_prompt_active then
			self.esc_to_continue_prompt_active = true;
			cm:show_subtitle("esc_to_skip_cutscene", false, true);
		end;
	end;
end;











----------------------------------------------------------------------------
--- @section Enqueuing Actions
--- @desc Actions are the events that happen in a cutscene while the cutscene is running. Examples include camera movements and the playing of advice, subtitles, and potentially composite scenes. A cutscene must be loaded with actions before it is started.
----------------------------------------------------------------------------


--- @function action
--- @desc Registers a new action with the cutscene. The action is supplied a function callback, which is called at the appropriate time after the cutscene has been started (assuming the cutscene is not skipped beforehand).
--- @p function callback, Action callback to call.
--- @p number delay, Delay in seconds after the cutscene starts before calling this action callback (or after the preceeding action, if in relative mode).
function campaign_cutscene:action(new_callback, new_delay)
	-- type-check parameters
	if not validate.is_function(new_callback) then
		return false;
	end;

	if not validate.is_number(new_delay) then
		return false;
	end;

	-- debug output
	if self.is_debug or cm:get_campaign_cutscene_debug() then
		out(self.name .. " adding action " .. tostring(new_callback) .. " with delay " .. tostring(new_delay));
	end;

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

	table.insert(action_list, insertion_index, {callback = new_callback, delay = global_start_time});
	return true;
end;


--- @function action_set_camera_position
--- @desc Set the camera position. When using this, it's best to wait a fraction of a second before enacting other camera movements, as the action is not instant and can be overriden by other camera actions.
--- @p @number delay, The delay in seconds.
--- @p @table camera_coords, The coordinates to move the camera to. List of numbers as defined in @"campaign_manager:Camera Movement".
function campaign_cutscene:action_set_camera_position(delay, camera_coords)
	self:action(
		function()
			cm:set_camera_position(camera_coords[1], camera_coords[2], camera_coords[3], camera_coords[4], camera_coords[5]);
		end,
		delay
	);
end;


--- @function action_scroll_camera_to_position
--- @desc Scroll the camera from its current location to the specified location.
--- @p @number delay, The delay in seconds.
--- @p @number scroll duration, How long it takes, in seconds, for the camera to reach its new coordinate.
--- @p @boolean correct_endpoint, Correct endpoint. If true, the game will adjust the final position of the camera so that it's a valid camera position for the game. Set to true if control is being released back to the player after this camera movement finishes.
--- @p @table camera_coords, The coordinates to scroll the camera to. List of numbers as defined in @"campaign_manager:Camera Movement".
function campaign_cutscene:action_scroll_camera_to_position(delay, scroll_duration, correct_endpoint, camera_coords)
	self:action(
		function()
			cm:scroll_camera_from_current(correct_endpoint, scroll_duration, camera_coords);
		end,
		delay
	);
end;


--- @function action_show_advice
--- @desc Display some advice.
--- @p @number delay, The delay in seconds.
--- @p @string advice key, Advice thread key.
function campaign_cutscene:action_show_advice(delay, advice_key)
	self:action(
		function()
			cm:show_advice(advice_key);
		end,
		delay
	);
end;


--- @function action_override_ui_visibility
--- @desc Disable or enable the UI of the specified string keys, as defined in <code>campaign_ui_manager</code>.
--- @p @number delay, The delay in seconds.
--- @p ... ui overrides, A variable number of UI override arguments to enable or disable. UI overrides may be specified as multiple @string arguments or a single @table of strings.
function campaign_cutscene:action_override_ui_visibility(delay, enable, ...)
	local ui_flags;
	if #arg == 1 and is_table(arg[1]) then
		ui_flags = arg[1];
	else
		ui_flags = arg;
	end;

	self:action(
		function()
			for u = 1, #ui_flags do
				cm:get_campaign_ui_manager():override(ui_flags[u]):set_allowed(enable);
			end;
		end,
		delay
	);
end;


--- @function action_fade_scene
--- @desc Fades the scene to black or back to picture over a specified period.
--- @p @number delay, The delay in seconds.
--- @p @number brightness, Brightness, as a unary value. Supply a value of <code>0</code> to fade to black, supply a value of <code>1</code> to fade to picture, or supply a value in between to transition to a partially-faded picture.
--- @p @number duration, Duration of the fade effect in seconds.
function campaign_cutscene:action_fade_scene(delay, brightness, duration)
	self:action(
		function()
			cm:fade_scene(brightness, duration)
		end,
		delay
	);
end;


--- @function action_end_cutscene
--- @desc Sets a listener to end the cutscene at the specified delay. This will also update the cutscene's internal duration.
--- @p @number delay,The delay in seconds.
function campaign_cutscene:action_end_cutscene(delay)
	if self.cutscene_has_end_action then
		script_error(string.format(
			"ERROR: %s:action_end_cutscene() Cannot set an end-cutscene action as this cutscene has already had an end-action set (this happens automatically if a cutscene is defined with a length).",
			self.name, self.cutscene_length)
		);
		return;
	end;

	if not self.relative_mode and #self.action_list > 0 then
		local latest_delay = self.action_list[#self.action_list].delay
		if latest_delay > delay then
			script_error(string.format(
				"ERROR: %s:action_end_cutscene() Provided cutscene delay of %i seconds is earlier than the latest action's delay in this cutscene (%i) seconds. The end-action on a cutscene must come after all other actions.",
				self.name, delay, latest_delay
			));
			return;
		end;
	end;

	self:action(
		function()
			self:finish();
		end,
		delay
	);

	self.cutscene_length = self.cumulative_time;
	self.cutscene_has_end_action = true;
end;









----------------------------------------------------------------------------
--- @section Starting
----------------------------------------------------------------------------


--- @function start
--- @desc Starts the cutscene.
--- @r @boolean cutscene was started successfully
function campaign_cutscene:start()
	local uim = cm:get_campaign_ui_manager();
	
	if cm:is_any_cutscene_running() then
		script_error(self.name .. " ERROR: cannot start, another cutscene is running!");
		self:release();
		return false;
	end;
	
	-- prevent player input
	if not (self.is_debug or cm:get_campaign_cutscene_debug()) then
		cm:steal_user_input(true);
		
		if not cm:is_ui_hiding_enabled() then
			self.enable_ui_hiding_on_release = false;		-- ui hiding was disabled prior to the cutscene, so don't re-enable it
		end;
		
		cm:enable_ui_hiding(false);
	end;
	
	-- set up restore camera if we need to
	if self.restore_cam_time >= 0 and not self.restore_cam_x then
		self.restore_cam_x, self.restore_cam_y, self.restore_cam_d, self.restore_cam_b, self.restore_cam_h = cm:get_camera_position();
	end;
	
	-- turn off event panels
	self:enable_event_panels(false);

	-- if this is an intro cutscene then notify the campaign manager
	if self.intro_cutscene then
		cm:notify_intro_cutscene_playing(true);
	end;
	
	-- shroud
	if self.restore_shroud then
		cm:take_shroud_snapshot();
	end;
	
	if self.neighbouring_regions_visible then
		cm:make_neighbouring_regions_visible_in_shroud();
	end;
	
	if self.disable_shroud then
		cm:show_shroud(false);
	end;
	
	-- cinematic borders
	if self.use_cinematic_borders then
		CampaignUI.ToggleCinematicBorders(true);
	end;
	
	cm:override_ui("disable_advice_changes", true);	
	
	if self.disable_settlement_labels then
		cm:override_ui("disable_settlement_labels", true);
	else
		-- do this in case this cutscene is following another, and *that* cutscene had disabled settlement labels
		cm:override_ui("disable_settlement_labels", false);
	end;

	if self.should_send_recieve_metrics_data then
		-- start collection of performance metrics
		cm:trigger_performance_metrics_start();
	end;

	-- start listening for advice dismissed if necessary
	if self.is_skippable then
		core:add_listener(
			self.name .. "_advice_closed",
			"AdviceDismissed",
			true,
			function() self:advice_is_dismissed() end,
			false
		);
		
		cm:steal_escape_key_and_space_bar_with_callback(self.name, function() self:skip() end);
	end;

	-- establish a listener for cinematic triggers from cindy scenes
	self:start_cinematic_trigger_listeners(true);
	
	if self.cutscene_length ~= nil and not self.cutscene_has_end_action then
		if self.relative_mode then
			self:action_end_cutscene(0);
		else
			self:action_end_cutscene(self.cutscene_length);
		end;
	end;

	if self.music_trigger_argument then
		cm:activate_music_trigger("CutsceneStarted", self.music_trigger_argument);
	end;
	
	-- set internal is_running flag
	self.is_running = true;
	self.is_skipped = false;
	
	-- debug output
	if self.is_debug or cm:get_campaign_cutscene_debug() then
		out(self.name .. " is starting");
	end;
		
	-- start processing actions
	self:process_next_action(1);
	
	return true;
end;


function campaign_cutscene:start_cinematic_trigger_listeners(should_start)
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
					out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - hiding subtitles");
					cm:hide_subtitles();

				elseif trigger_str == "_dismiss_advice" then
					out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - dismissing advice");
					self:dismiss_advice();

				elseif trigger_str:starts_with("_advice_") then
					local advice_key = trigger_str:sub(9);					-- char 9 to the end, length of "_advice_" + 1
					out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - triggering advice with key " .. tostring(advice_key));
					cm:show_advice(advice_key);

				elseif trigger_str:starts_with("_subtitle_") then
					local subtitle_key = trigger_str:sub(11);				-- char 11 to the end, length of "_subtitle_" + 1
					out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - triggering subtitle with key " .. tostring(subtitle_key));
					cm:show_subtitle(subtitle_key);

				elseif trigger_str:starts_with("_force_subtitle_") then
					local subtitle_key = trigger_str:sub(17);				-- char 17 to the end, length of "_force_subtitle_" + 1
					out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - forcing subtitle with key " .. tostring(subtitle_key));
					cm:show_subtitle(subtitle_key, false, true);

				elseif trigger_str:starts_with("_force_subtitle_") then
					local subtitle_key = trigger_str:sub(17);				-- char 17 to the end, length of "_force_subtitle_" + 1
					out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - forcing subtitle with key " .. tostring(subtitle_key));
					cm:show_subtitle(subtitle_key, false, true);

				elseif trigger_str:starts_with("_fade_to_black_") then
					local duration_str = trigger_str:sub(16);				-- char 16 to the end, length of "_fade_to_black_" + 1
					local duration = tonumber(duration_str);
					if duration then
						out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - triggering fade to black over " .. duration .. "s");
						cm:fade_scene(0, duration);
					else
						script_error("WARNING: could not extract fade to black duration from trigger string " .. tostring(trigger_str) .. ", it should be in the format _fade_to_black_xx, where xx is a number specifying the fade duration");
					end;

				elseif trigger_str:starts_with("_fade_to_picture_") then
					local duration_str = trigger_str:sub(18);				-- char 18 to the end, length of "_fade_to_black_" + 1
					local duration = tonumber(duration_str);
					if duration then
						out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - triggering fade to picture over " .. duration .. "s");
						cm:fade_scene(1, duration);
					else
						script_error("WARNING: could not extract fade to picture duration from trigger string " .. tostring(trigger_str) .. ", it should be in the format _fade_to_picture_xx, where xx is a number specifying the fade duration");
					end;

				-- custom trigger
				elseif self.cinematic_triggers[trigger_str] then					
					out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - triggering callback");
					
					self.cinematic_triggers[trigger_str]();
				else
					out("* CinematicTrigger event received with id " .. tostring(trigger_str) .. " - no callback registered for this id");
				end;
			end,
			true
		);

	else
		core:remove_listener(listener_name);
	end;
end;


-- performs the next action
function campaign_cutscene:process_next_action(action_ptr)
	if not self.is_running then
		script_error(self.name .. " WARNING:  tried to process an action while not active, the action didn't happen.");		
		return false;
	end;
		
	if action_ptr > #self.action_list then		
		return false;
	end;
	
	-- see if we have to wait for advice to complete
	if self.advisor_wait then
		if common.is_advice_audio_playing() then
		
			-- Advice is playing and we have been instructed to wait for it to complete.
			-- Let's try again in a bit and see if the advice has finished
			cm:callback(function() self:process_next_action(action_ptr) end, 0.5, self.name);
			self.wait_offset = self.wait_offset + 0.5;
			return false;
		else
			-- advisor_wait is true but there is no advice playing, so we can set it to false again
			self.advisor_wait = false;
		end;	
	end;
	
	local next_action = self.action_list[action_ptr];
	local further_action = nil;
	
	if action_ptr < #self.action_list then
		further_action = self.action_list[action_ptr + 1];
	end;
	
	-- debug output
	if self.is_debug or cm:get_campaign_cutscene_debug() then
		out(self.name .. " : processing action " .. action_ptr .. " [" .. tostring(next_action.callback) .. "]");
	end;
	
	-- call the next_action callback
	next_action.callback();
	
	-- if the further_action (what we do after next_action) is due to happen at a later time
	-- as the next_action then queue that up, else run it now. If further_action doesn't exist
	-- then do nothing, we have got to the end of the cutscene
	if further_action and self.is_running then
		if further_action.delay > next_action.delay then
			cm:callback(function() self:process_next_action(action_ptr + 1) end, (further_action.delay - next_action.delay), self.name);
		else
			self:process_next_action(action_ptr + 1);
		end;
	end;
end;


-- internal function to enable or disable event panels
function campaign_cutscene:enable_event_panels(value)
	if self.event_panels_enabled == not value then
		cm:get_campaign_ui_manager():enable_event_panel_auto_open(value);
		self.event_panels_enabled = value;
	end;
end;








----------------------------------------------------------------------------
--- @section During Playback
----------------------------------------------------------------------------


--- @function wait_for_advisor
--- @desc This function, when called, causes the cutscene to repeatedly stall while the advisor is still speaking and only allow the cutscene to progress once the advisor has finished. If the cutscene contains multiple lines of advice that are played one after the other, this function can be used to ensure that each item of advice only triggers once the previous item has finished playing, so they don't speak over the top of each other. This is useful when laying out multiple items of advice in a cutscene where the length of advice items cannot be known in different languages - a localised version of an advice item in German, for example, might be many seconds longer than the equivalent in English.
--- @desc If a delay argument is passed in then the call to this function is enqueued as an @campaign_cutscene:action with that delay. Alternatively, it may be called with no delay within an action.
--- @p [opt=nil] number delay, Delay in seconds after the cutscene starts before invoking this function.
function campaign_cutscene:wait_for_advisor(delay)

	-- if this function is supplied with a delay, then enqueue it as an action
	if delay then
		if not is_number(delay) or delay < 0 then
			script_error(self.name .. " ERROR: wait_for_advisor() called but supplied delay [" .. tostring(delay) .. "] is not a positive number or nil");
			return false;
		end;
		
		self:action(
			function() 
				self:wait_for_advisor() 
			end,
			delay
		);
		return;
	end;
	
	self.advisor_wait = true;
end;


--- @function cindy_playback
--- @desc Immediately starts playback of a cindy scene. This is intended to be called within an @campaign_cutscene:action callback. If a cindy scene is started this way, the cutscene will automatically terminate it if the cutscene is skipped.
--- @p @string path, cindy xml path, from the data/ folder.
--- @p [opt=nil] @number blend in, Blend in duration in seconds.
--- @p [opt=nil] @number blend out, Blend out duration in seconds.
function campaign_cutscene:cindy_playback(file, blend_in_duration, blend_out_duration)
	self.playing_cindy_camera = true;
	self.cindy_camera_specified = true;
	
	-- If we're running in minimalist dev mode then cindy scenes will not be loaded, so instead just skip the cutscene
	if CampaignUI.IsMinimalViewModeEnabled() then
		self:skip();
	else
		cm:cindy_playback(file, blend_in_duration, blend_out_duration);
	end;
end;



--- @function dismiss_advice
--- @desc Issues a call to dismiss the advice without triggering the end of the cutscene. Normally a cutscene skips when advice is dismissed - use this function during an @campaign_cutscene:action to circumvent this behaviour.
function campaign_cutscene:dismiss_advice()
	self.do_not_skip_on_next_advice_dismissal = true;
	
	cm:dismiss_advice();
end;


-- called internally when the advisor is dismissed
function campaign_cutscene:advice_is_dismissed()
	if self.do_not_skip_on_next_advice_dismissal then
		self.do_not_skip_on_next_advice_dismissal = false;
		return;
	end;
	
	out(self.name .. ": advice has been dismissed");
	
	core:remove_listener(self.name .. "_advice_closed");
	self:skip(true);
end;










----------------------------------------------------------------------------
--- @section Skipping
----------------------------------------------------------------------------


--- @function skip
--- @desc This function is called internally when the cutscene has been skipped by the player. Additionally, it may be called by external scripts to force the running cutscene to skip.
function campaign_cutscene:skip(advice_being_dismissed)
	if not self.is_running then
		return false;
	end;
	
	out(self.name .. " has been skipped");
	
	-- kill any running process
	cm:remove_callback(self.name);
	
	-- remove listener for advice being dismissed before we manually dismiss it
	core:remove_listener(self.name .. "_advice_closed");

	-- remove esc to continue prompt if active
	self:show_esc_prompt(false);
	
	cm:stop_camera();

	-- stop any cinematic trigger listeners
	self:start_cinematic_trigger_listeners(false);
	
	if self.dismiss_advice_on_end and not advice_being_dismissed then
		cm:dismiss_advice();
	end;
	
	self.is_skipped = true;
	
	-- stop the cindy camera if one is playing
	if self.playing_cindy_camera then
		self.playing_cindy_camera = false;
		cm:stop_cindy_playback();
		
		if self.fade_to_black_on_skip then
			-- cut to black, then fade back in
			cm:fade_scene(0, 0);
			if self.fade_to_picture_after_skip_time >= 0 then
				cm:callback(
					function() 
						cm:fade_scene(1, self.fade_to_picture_after_skip_time)
					end, 
					self.fade_to_picture_after_skip_delay
				);
			end;
		end;
	end;
	
	if self.music_trigger_argument then
		cm:activate_music_trigger("CutsceneSkipped", self.music_trigger_argument);
	end;

	-- run the skip callback if we have one
	if is_function(self.skip_callback) then
		self.skip_callback();
	end;
	
	
	-- reposition camera if we have a skip camera (this is delayed in case the cindy scene is still running)
	if self.skip_cam_x then
		if self.cindy_camera_specified then
			cm:callback(function() cm:set_camera_position(self.skip_cam_x, self.skip_cam_y, self.skip_cam_d, self.skip_cam_b, self.skip_cam_h) end, 0.1);
		else
			cm:set_camera_position(self.skip_cam_x, self.skip_cam_y, self.skip_cam_d, self.skip_cam_b, self.skip_cam_h);
		end;
		
	elseif self.restore_cam_time >= 0 then
		self:restore_camera_and_release(true);
		return;
	end;
	
	self:release();
end


-- called when the campaign intro finishes without skipping
function campaign_cutscene:finish()
	if self.is_debug or cm:get_campaign_cutscene_debug() then
		out(self.name .. " is finishing");
	end;
	
	-- stop the cindy camera if one is playing
	if self.playing_cindy_camera then
		self.playing_cindy_camera = false;
		cm:stop_cindy_playback(false);
	end;

	-- stop any cinematic trigger listeners
	self:start_cinematic_trigger_listeners(false);

	-- remove esc to continue prompt if active
	self:show_esc_prompt(false);
	
	if self.restore_cam_time >= 0 then
		self:restore_camera_and_release(false);
	else
		self:release();
	end;
end


-- called when the cutscene ends (either by skipping or naturally finishing), this function decides whether to restore the camera and then releases the cutscene
function campaign_cutscene:restore_camera_and_release(should_cut)
	local restore_time = self.restore_cam_time;
	
	if should_cut then
		restore_time = 0;
	end;

	-- perform the camera movement
	if restore_time == 0 then
		cm:set_camera_position(self.restore_cam_x, self.restore_cam_y, self.restore_cam_d, self.restore_cam_b, self.restore_cam_h);
		self:release();
	else
		cm:scroll_camera_from_current(true, restore_time, {self.restore_cam_x, self.restore_cam_y, self.restore_cam_d, self.restore_cam_b, self.restore_cam_h});
		cm:callback(function() self:release() end, restore_time, self.name);
	end;
end;


-- cleans up the campaign_cutscene, called when it finishes for either reason
function campaign_cutscene:release()
	
	local uim = cm:get_campaign_ui_manager();
	
	--
	-- RE-ACTIVATE UI (wait a little and check if no other cutscene is running)
	--
	
	cm:callback(
		function()
			-- allow event panels to be shown again
			-- always do this at this time, even if another cutscene is running - the lock the second cutscene will have already placed
			-- on event panels auto-opening will prevent this call from actually enabling the functionality
			self:enable_event_panels(true);
		
			if not cm:is_any_cutscene_running() then	
				-- allow ui hiding if we should
				if self.enable_ui_hiding_on_release then
					cm:enable_ui_hiding(true);
				end;
			
				-- allow player input
				if not (self.is_debug or cm:get_campaign_cutscene_debug()) then
					cm:steal_user_input(false);
				end;

				-- cinematic borders
				if self.use_cinematic_borders and self.restore_ui then
					CampaignUI.ToggleCinematicBorders(false);
				end;
				
				cm:override_ui("disable_advice_changes", false);
				
				if self.disable_settlement_labels then
					cm:override_ui("disable_settlement_labels", false);
				end;
			end;
		end,
		0.1,
		self.name .. "_release"
	);
	
	-- Re-establish shroud
	if self.disable_shroud then
		cm:show_shroud(true);			-- this needs to be called as well as restore_shroud_from_snapshot()
	end;
	if self.restore_shroud then
		cm:restore_shroud_from_snapshot();
	end;
	
	-- re-establish shroud over terrain patches (e.g. realms of chaos)
	cm:reset_forced_terrain_patch_visibility();
	
	-- stop listening for advice being dismissed
	if self.is_skippable then
		core:remove_listener(self.name .. "_advice_closed");
		cm:release_escape_key_and_space_bar_with_callback(self.name);
	end;

	if self.show_advisor_close_button_on_end then
		cm:modify_advice(true);
	end;
	
	-- set internal is_running flag
	self.is_running = false;
	
	if self.wait_offset > 0 then
		out(self.name .. " was " .. self.wait_offset .. "s longer than specified due to waiting for advice to complete.");
	end;
	
	-- notify listeners that a cutscene has completed
	if self.intro_cutscene then
		cm:notify_intro_cutscene_playing(false);
		core:trigger_event("ScriptEventCampaignIntroCutsceneCompleted", self.name);
	end;

	core:trigger_event("ScriptEventCampaignCutsceneCompleted", self.name);

	if self.should_send_recieve_metrics_data then
		-- report collected performance metrics
		cm:trigger_performance_metrics_stop();
	end;

	-- end callback (must happen last!)
	if not self.is_skipped or self.call_end_callback_when_skipped then
		if is_function(self.end_callback) then
			self.end_callback();
		end;
	end;
end;