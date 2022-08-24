

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	MOVIE OVERLAY PLAYER
--
--- @set_environment battle
--- @set_environment campaign
--- @set_environment frontend
--- @c movie_overlay Movie Overlays
--- @desc The movie overlay player provides an interface for scripts to play movies in a created uicomponent. The player functionality allows scripts to specify properties of the uicomponent player and the movie itself, allowing fine control over playback. Through this interface the script can control the size and position of the movie on-screen, how the movie fades in and out and what to do when the movie completes or is skipped, for example. The script may also set a mask image, which can be used to blend the edges of the movie to transparent during playback for a pleasing visual effect.
--- @desc A movie overlay player may be created with @movie_overlay:new, and then optionally configured with the function calls listed in this documentation. Once configured, movie playback may be started by calling @movie_overlay:start.
--- @desc The movie overlay interface provides some functions for configuring the player, however other configuration calls may be made to it beyond those listed here. If any call is made to the player which it doesn not recognise then those are passed through to the underlying player uicomponent. This means that any function call provided by the @uicomponent library may be made to a movie overlay object.
--- @desc The player uicomponent is created the first time a call is made which is to be passed through to it, or when @movie_overlay:start is called. If there is a delay between the creation/configuration of the player and the start of playback then be aware that the uicomponent will exist. It is set to be invisible and non-interactive so it should not affect the game.
--- @desc If a movie_overlay is not configured before playback is started then the default style is applied using @movie_overlay:set_style, setting the movie to be fullscreen.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

movie_overlay = {
	name = "",								-- unique name
	movie_path = "",						-- path to movie file from data/movies
	uic = false,							-- movie player uicomponent
	movie_track = -1,						-- the movie track in warscape this movie is/will be playing on. Currently 0-3 is supported but scripts should only use 2 or 3. force_movie_track can be used to set 0 or 1. Only one movie may play on a track at once.
	movie_track_forced = false,				-- specifies that the movie track has been forced with force_movie_track - the actual track number in this case will have been stored in movie_track
	is_started = false,						-- has this movie started playing
	is_finished = false,					-- has this movie finished playing
	set_uic_interactive = true,				-- sets whether the movie player should be interactive (blocking mouse clicks)
	show_animation = "show",				-- animation used to show the movie. Can be blank.
	show_animation_duration = false,		-- user-specified length of the show animation in ms
	hide_animation = "hide",				-- animation used to hide the movie when it finishes naturally. Can be blank.
	hide_animation_duration = false,		-- user-specified length of the hide animation in ms
	skip_animation = "",					-- animation used to hide the movie when it is skipped. Can be blank.
	skip_animation_duration = false,		-- user-specified length of the skip animation is ms
	--[[
	frame_callbacks = {},					-- set of callbacks to call on specified frames during movie playback
	timestamp_callbacks = {},				-- set of callbacks to call at specified times during movie playback. These are converted in to frame_callbacks when playback begins, as that mechanism is more reliable.
	]]
	hide_on_end = true,						-- sets whether the overlay should try and hide or destroy itself when it ends. Set this to false if something else will destroy the player.
	is_skippable = true,					-- sets whether the movie should be skippable with the ESC key.
	should_loop = false,					-- sets whether the movie should loop
	play_movie_audio = true,				-- sets whether the movie audio should be played
	freeze_game_rendering = true,			-- sets whether game rendering should freeze while the movie is playing. This does not stop the model from ticking.
	steal_user_input = false,				-- sets whether user input should be stolen by script while the movie is playing. This prevents user input, although ESC to skip still works.
	stop_game_audio = true,					-- sets whether game audio should stop while the movie is playing.
	resize_uicomponent_to_fit = false,		-- sets whether uicomponent should resize itself to match the movie dimensions.
	end_callback = false,					-- optional callback to call when the movie finishes playing. This includes when the movie is skipped.
	skip_callback = false,					-- optional callback to call when the movie is skipped.
	destroy_callback = false				-- optional callback to call when the movie player uicomponent is destroyed
}


set_class_custom_type(movie_overlay, TYPE_MOVIE_OVERLAY);
set_class_tostring(
	movie_overlay, 
	function(obj)
		return TYPE_MOVIE_OVERLAY .. "_" .. obj.name
	end
);






----------------------------------------------------------------------------
---	@section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns a new movie overlay player object. 
--- @p @string name, Unique name for this movie overlay object
--- @p @string movie path, Path to movie file, starting from the Movies folder in working data. The file extension should be omitted.
--- @r @movie_overlay movie overlay object
--- @new_example Play the Warhammer intro movie, filename data/Movies/startup_movie_03.ca_vp8
--- @example mo_wh_intro = movie_overlay:new("warhammer_intro", "startup_movie_03");	-- path starts from Movies
function movie_overlay:new(name, movie_path)
	if not is_string(name) then
		script_error("ERROR: movie_overlay:new() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if not is_string(movie_path) then
		script_error("ERROR: movie_overlay:new() called but supplied path [" .. tostring(movie_path) .. "] is not a string");
		return false;
	end;

	local mo = {};
	
	mo.name = name;

	set_object_class(mo, self);
	
	mo.movie_path = movie_path;

	mo.frame_callbacks = {};
	mo.timestamp_callbacks = {};
	
	return mo;
end;






----------------------------------------------------------------------------
---	@section Usage
--- @desc Once a handle to a movie_overlay object is obtained then functions may be called on it to query or modify its state in the following form.
--- @new_example Specification
--- @example <code>&lt;object_name&gt;:&lt;function_name&gt;(&lt;args&gt;)</code>
--- @new_example Creation and Usage
--- @example local mo_chaos_invasion = movie_overlay:new("warhammer_intro", "warhammer/chs_invasion");
--- @example mo_chaos_invasion:set_centre_mask_image();
--- @example mo_chaos_invasion:PropagatePriority(500);		-- function provided by uicomponent interface
----------------------------------------------------------------------------


-- allow movie_overlay to pass calls through to underlying uicomponent object. If a function is called on
-- the movie_overlay which hasn't been explicitly set up, this is passed through to the uicomponent. If the
-- uicomponent hasn't been created then it is created at this point.
set_class_metatable(
	movie_overlay,	
	{
		__index = function(mo, key)
			if not mo.uic then
				mo:create_uicomponent();
			end;
			local uic = mo.uic;
			return function(mo, ...)
				return uic[key](uic, ...)
			end;
		end
	}
);






-- Internal function to create the movie overlay uicomponent. This is called when start() is called, or
-- the first time any call is made to the movie_overlay which it doesn't recognise (and which is passed through to the uicomponent)
function movie_overlay:create_uicomponent()
	if self.uic then
		return;
	end;

	local uic = core:get_or_create_component("movie_overlay_" .. self.name, "UI/Common UI/movie_overlay.twui.xml");
	if not uic then
		script_error(self.name .. " ERROR: could not create movie player uicomponent, how can this be?");
		return false;
	end;

	uic:SetVisible(false);
	uic:SetInteractive(self.set_uic_interactive);

	self.uic = uic;
end;











----------------------------------------------------------------------------
---	@section Configuration
----------------------------------------------------------------------------


-- Special case function to set the movie player uicomponent to be interactive or not. We provide a function 
-- here so that uicomponent doesn't actually get made interactive at the point this is called (which could be 
-- some time before the movie starts playing). We cache this value and set the interactivity state when the
-- movie is started.
function movie_overlay:SetInteractive(value)
	self.set_uic_interactive = not not value;
end;


function movie_overlay:SetVisible(value)
	-- disregard
end;


--- @function move_to
--- @desc Sets the position of the uicomponent by calling @uicomponent:MoveTo, setting the uicomponent to be unmoveable afterwards. The uicomponent is created at this point if it doesn't already exist.
--- @desc If a movie_overlay is not configured before playback is started then the default style is applied using @movie_overlay:set_style, setting the movie to be fullscreen.
--- @p @number x, X screen co-ordinate in pixels.
--- @p @number y, Y screen co-ordinate in pixels.
function movie_overlay:move_to(pos_x, pos_y)
	if not is_number(pos_x) or pos_x < 0 then
		script_error(self.name .. " ERROR: move_to() called but supplied x co-ordinate [" .. tostring(pos_x) .. "] is not a positive number");
		return false;
	end;

	if not is_number(pos_y) or pos_y < 0 then
		script_error(self.name .. " ERROR: move_to() called but supplied y co-ordinate [" .. tostring(pos_y) .. "] is not a positive number");
		return false;
	end;

	self:create_uicomponent();
	self.uic:SetMoveable(true);
	self.uic:MoveTo(pos_x, pos_y);
	self.uic:SetMoveable(false);
end;


--- @function resize
--- @desc Resizes the uicomponent, by calling @uicomponent:Resize. The uicomponent is created at this point if it doesn't already exist.
--- @desc If a movie_overlay is not configured before playback is started then the default style is applied using @movie_overlay:set_style, setting the movie to be fullscreen.
--- @p @number width, Width in pixels.
--- @p @number height, Height in pixels.
function movie_overlay:resize(width, height)
	if not is_number(width) or width < 1 then
		script_error(self.name .. " ERROR: resize() called but supplied width [" .. tostring(width) .. "] is not a number");
		return false;
	end;

	if not is_number(height) or height < 1 then
		script_error(self.name .. " ERROR: resize() called but supplied height [" .. tostring(height) .. "] is not a number");
		return false;
	end;

	self:create_uicomponent();
	local uic = self.uic;

	local uic_player = find_uicomponent(uic, "movie_overlay_player");
	uic:SetCanResizeHeight(true);
	uic:SetCanResizeWidth(true);
	uic:Resize(width, height);
	uic:SetCanResizeHeight(false);
	uic:SetCanResizeWidth(false);
end;


--- @function set_skippable
--- @desc Sets whether this movie should be skippable with the ESC key. Movies are skippable by default - use this function to disable this behaviour.
--- @p [opt=true] @boolean skippable
function movie_overlay:set_skippable(value)
	if value == false then
		self.is_skippable = false;
	else
		self.is_skippable = true;
	end;
end;


--- @function set_end_callback
--- @desc Sets a callback to be called when the movie ends or is skipped. If a hide animation is set, this callback gets called as the hide animation starts. To set a callback when the hide animation completes, use @movie_overlay:set_destroy_callback.
--- @p @function callback
function movie_overlay:set_end_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: set_end_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return;
	end;

	self.end_callback = callback;
end;


--- @function set_skip_callback
--- @desc Sets a callback to be called when the movie is skipped. If a hide animation is set, this callback gets called as the hide animation starts, before the end callback if one has been set with @movie_overlay:set_end_callback.
--- @p @function callback
function movie_overlay:set_skip_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: set_skip_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return;
	end;

	self.skip_callback = callback;
end;


--- @function set_destroy_callback
--- @desc Sets a callback to call when the player uicomponent is destroyed. This will only get called if this movie overlay player destroys itself, not if something else destroys it.
--- @p @function callback
function movie_overlay:set_destroy_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: set_destroy_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return;
	end;

	self.destroy_callback = callback;
end;


--- @function set_hide_on_end
--- @desc Sets whether the overlay should try and hide or destroy itself when it ends. Set this to <code>false</code> if some other process will destroy it.
--- @p @boolean destroy on end
function movie_overlay:set_hide_on_end(value)
	if value == false then
		self.hide_on_end = false;
	else
		self.hide_on_end = true;
	end;
end;


--- @function set_should_loop
--- @desc Sets the movie to loop. By default, the movie plays only once.
--- @p [opt=true] @boolean loop
function movie_overlay:set_should_loop(value)
	if value == false then
		self.should_loop = false;
	else
		self.should_loop = true;
	end;
end;


--- @function set_play_movie_audio
--- @desc Sets whether the movie audio should play or not. Movie audio plays by default - use this function to disable it.
--- @p [opt=true] @boolean play audio
function movie_overlay:set_play_movie_audio(value)
	if value == false then
		self.play_movie_audio = false;
	else
		self.play_movie_audio = true;
	end;
end;


--- @function set_freeze_game_rendering
--- @desc Sets whether the game should continue to render while the movie is being played. Game rendering stops during movie playback by default - use this function to enable it.
--- @p [opt=true] @boolean should freeze
function movie_overlay:set_freeze_game_rendering(value)
	if value == false then
		self.freeze_game_rendering = false;
	else
		self.freeze_game_rendering = true;
	end;
end;


--- @function set_steal_user_input
--- @desc Sets whether user input should be stolen by script while the movie is being played. The script establishes an ESC key listener to handle movie skipping if this is set.
--- @p [opt=true] @boolean should steal
function movie_overlay:set_steal_user_input(value)
	if value == false then
		self.steal_user_input = false;
	else
		self.steal_user_input = true;
	end;
end;


--- @function set_stop_game_audio
--- @desc Sets whether the game audio should stop playing while the movie is being played. By default game audio is stopped/disabled during movie playback - use this function to enable it.
--- @p [opt=true] @boolean stop audio
function movie_overlay:set_stop_game_audio(value)
	if value == false then
		self.stop_game_audio = false;
	else
		self.stop_game_audio = true;
	end;
end;


--- @function set_resize_uicomponent_to_fit
--- @desc Sets whether the uicomponent should resize itself to match the dimensions of the movie. This behaviour is disabled by default - use this function to enable it.
--- @p [opt=true] @boolean should freeze
function movie_overlay:set_resize_uicomponent_to_fit(value)
	if value == false then
		self.resize_uicomponent_to_fit = false;
	else
		self.resize_uicomponent_to_fit = true;
	end;
end;


--- @function force_movie_track
--- @desc Forces the movie overlay to use a particular track. If this track is already occupied the previous video will be stopped. Supported track values are 0-3. If no movie track is forced, the system will pick track 2 or 3, depending on which is currently free.
--- @p @number movie track
function movie_overlay:force_movie_track(track)
	if not is_number(track) then
		script_error("ERROR: force_movie_track() called but supplied track [" .. tostring(track) .. "] is not a number");
		return false;
	end;

	if track < 0 or track > 3 then
		script_error("ERROR: force_movie_track() called but supplied track number [" .. track .. "] is not in the range 0 to 3");
		return false;
	end;

	self.movie_track_forced = true;
	self.movie_track = track;
end;






----------------------------------------------------------------------------
---	@section Frame Callbacks
--- @desc Callbacks can be registered to be called on certain frames or timestamps during the movie playback using the functions in this section. 
----------------------------------------------------------------------------


--- @function add_frame_callback
--- @desc Adds a callback to be called when the movie reaches a specified frame. The frame can be specified as a positive number or as a negative number, in which case that number of frames from the end of the movie is considered the trigger frame.
--- @p @function callback
--- @p @number frame number
function movie_overlay:add_frame_callback(callback, frame_num)
	if not validate.is_function(callback) or not validate.is_number(frame_num) then
		return false;
	end;

	local frame_callback_record = {
		callback = callback,
		frame_num = frame_num
	};

	table.insert(self.frame_callbacks, frame_callback_record);
end;


--- @function add_timestamp_callback
--- @desc Adds a callback to be called when the movie reaches a specified timestamp, in seconds. The time can be specified as a positive number or as a negative number, in which case the timestamp is counted backwards from the end of the movie.
--- @p @function callback
--- @p @number timestamp
function movie_overlay:add_timestamp_callback(callback, timestamp)
	if not validate.is_function(callback) or not validate.is_number(timestamp) then
		return false;
	end;

	local timestamp_callback_record = {
		callback = callback,
		timestamp = timestamp
	};

	table.insert(self.timestamp_callbacks, timestamp_callback_record);
end;






----------------------------------------------------------------------------
---	@section Animations
--- @desc The functions described in this section can be used to set custom show and hide animations for the player uicomponent. The animations should also be added to the movie overlay uicomponent in the UI editor.
----------------------------------------------------------------------------


--- @function set_show_animation
--- @desc Sets the uicomponent animation that should be triggered when the movie starts playing. By default an animation called "show" is triggered - use this function to set a different animation. A blank string may be supplied to play no animation as the movie starts.
--- @desc An optional animation duration in seconds may also be supplied. If set, this causes the player to set the frame time of the last frame of the animation to the supplied duration.
--- @p @string animation name
--- @p [opt=nil] @number duration override
function movie_overlay:set_show_animation(animation_name, duration)
	if not is_string(animation_name) then
		script_error(self.name .. " ERROR: set_show_animation() called but supplied animation name [" .. tostring(animation_name) .. "] is not a string");
		return false;
	end;

	if duration then
		if not is_number(duration) or duration < 0 then
			script_error(self.name .. " ERROR: set_show_animation() called but supplied animation duration [" .. tostring(duration) .. "] is not a positive number or nil");
			return false;
		end;
	end;

	self.show_animation = animation_name;
	if duration then
		self.show_animation_duration = duration * 1000;
	end;
end;


--- @function set_hide_animation
--- @desc Sets the uicomponent animation that should be triggered when the movie ends. This animation is played when the movie ends naturally, either because playback has finished or the specified movie duration has elapsed. It is also played if the movie is skipped and no skip animation has been set. By default this animation is called "hide" - use this function to set a different animation. A blank string may be supplied to play no animation.
--- @desc An optional animation duration in seconds may also be supplied. If set, this causes the player to set the frame time of the last frame of the animation to the supplied duration.
--- @desc Any new hide animation should also be set to destroy the overlay uicomponent on completion.
--- @p @string animation name
--- @p [opt=nil] @number duration override
function movie_overlay:set_hide_animation(animation_name, animation_duration)
	if not is_string(animation_name) then
		script_error(self.name .. " ERROR: set_hide_animation() called but supplied animation name [" .. tostring(animation_name) .. "] is not a string");
		return false;
	end;

	if animation_duration then
		if not is_number(animation_duration) or animation_duration < 0 then
			script_error(self.name .. " ERROR: set_hide_animation() called but supplied animation duration [" .. tostring(animation_duration) .. "] is not a positive number or nil");
			return false;
		end;
	end;

	self.hide_animation = animation_name;
	if duration then
		self.hide_animation_duration = animation_duration * 1000;
	end;
end;


--- @function set_skip_animation
--- @desc Sets the uicomponent that should be triggered when the movie is skipped. By default this animation is called "hide" - use this function to set a different animation. A blank string may be supplied to play no animation.
--- @desc An optional animation duration in seconds may also be supplied. If set, this causes the player to set the frame time of the last frame of the animation to the supplied duration.
--- @p @string animation name
--- @p [opt=nil] @number duration override
function movie_overlay:set_skip_animation(animation_name, duration)
	if not is_string(animation_name) then
		script_error(self.name .. " ERROR: set_skip_animation() called but supplied animation name [" .. tostring(animation_name) .. "] is not a string");
		return false;
	end;

	if duration then
		if not is_number(duration) or duration < 0 then
			script_error(self.name .. " ERROR: set_skip_animation() called but supplied animation duration [" .. tostring(duration) .. "] is not a positive number or nil");
			return false;
		end;
	end;

	self.skip_animation = animation_name;
	if duration then
		self.skip_animation_duration = duration * 1000;
	end;
end;







----------------------------------------------------------------------------
---	@section Mask Images
--- @desc The functions described in this section each set a mask image for the movie overlay. The transparency value of each pixel in this image is mapped onto the movie, allowing control over the opacity of each movie pixel during playback. This allows the edges of the movie to be blended to transparent, for example.
--- @desc Several pre-defined mask images have already been created, or another mask image may be specified. By default, a fully-opaque mask image is used so no blending/transparency is seen during playback.
----------------------------------------------------------------------------


--- @function set_mask_image
--- @desc Sets a path to a mask image for the movie overlay. This image should be in png format. The path is specified from the working data folder.
--- @desc Calling this function creates the movie player uicomponent if it has not already been created.
--- @p @string mask image path
function movie_overlay:set_mask_image(mask_image_path)
	if not is_string(mask_image_path) then
		script_error(self.name .. " ERROR: set_mask_image() called but supplied mask image path [" .. tostring(mask_image) .. "] is not a string");
		return false;
	end;

	self:create_uicomponent();

	local uic_video_mask = find_uicomponent(self.uic, "video_mask");
	if not uic_video_mask then
		script_error(self.name .. " ERROR: mask_image_path() called but video_mask uicomponent could not be found? How can this be?");
		return false;
	end;

	uic_video_mask:SetImagePath(mask_image_path);
end;


--- @function set_opaque_mask_image
--- @desc Sets a mask image of ui/skins/default/mask_movie_unmasked.png. This mask image is fully opaque.
function movie_overlay:set_opaque_mask_image()
	self:set_mask_image("ui/skins/default/mask_movie_unmasked.png");
end;


--- @function set_top_left_mask_image
--- @desc Sets a mask image of ui/skins/default/mask_movie_top_left.png. This mask image is intended to be used on movies shown in the top-left corner of the screen, blending to transparent to the bottom and right.
function movie_overlay:set_top_left_mask_image()
	self:set_mask_image("ui/skins/default/mask_movie_top_left.png");
end;


--- @function set_top_right_mask_image
--- @desc Sets a mask image of ui/skins/default/mask_movie_top_right.png. This mask image is intended to be used on movies shown in the top-right corner of the screen, blending to transparent to the bottom and left.
function movie_overlay:set_top_right_mask_image()
	self:set_mask_image("ui/skins/default/mask_movie_top_right.png");
end;


--- @function set_bottom_left_mask_image
--- @desc Sets a mask image of ui/skins/default/mask_movie_bottom_left.png. This mask image is intended to be used on movies shown in the bottom-left corner of the screen, blending to transparent to the top and right.
function movie_overlay:set_bottom_left_mask_image()
	self:set_mask_image("ui/skins/default/mask_movie_bottom_left.png");
end;


--- @function set_bottom_right_mask_image
--- @desc Sets a mask image of ui/skins/default/mask_movie_bottom_right.png. This mask image is intended to be used on movies shown in the bottom-right corner of the screen, blending to transparent to the top and left.
function movie_overlay:set_bottom_right_mask_image()
	self:set_mask_image("ui/skins/default/mask_movie_bottom_right.png");
end;


--- @function set_centre_mask_image
--- @desc Sets a mask image of ui/skins/default/mask_movie_centre.png. This mask image is intended to be used in a central position on the screen, blending to transparent along all four edges.
function movie_overlay:set_centre_mask_image()
	self:set_mask_image("ui/skins/default/mask_movie_bottom_right.png");
end;









----------------------------------------------------------------------------
---	@section Styles
--- @desc Movie overlay styles combine multiple settings into one function call. If it's desired to play multiple movies in the same manner it may be sensible to set up a style to avoid configuring each movie overlay object the same way.
----------------------------------------------------------------------------


--- @function set_style
--- @desc Sets a style. Currently recognised styles:<table class="simple"><tr><th>Style Name</th><th>Description</th></tr>
function movie_overlay:set_style(style)

	local styles = {
		--- @desc <tr><td><code>fullscreen</code></td><td>Sets the movie to be fullscreen and to block rendering update.</td></tr>
		fullscreen = function(mo)
			mo:set_opaque_mask_image();
			mo:set_freeze_game_rendering(true);
			mo:set_steal_user_input(true);
			mo:move_to(0, 0);
			local screen_x, screen_y = core:get_screen_resolution();	
			mo:resize(screen_x, screen_y);

			-- Hide help messages
			if core:is_battle() then
				bm:hide_help_message(true);
			end;
		end,
		--- @desc <tr><td><code>default</code></td><td>The default style sets the movie to be fullscreen.</td></tr>
		default = function(mo)
			mo:move_to(0, 0);
			local screen_x, screen_y = core:get_screen_resolution();	
			mo:resize(screen_x, screen_y);

			-- Hide help messages
			if core:is_battle() then
				bm:hide_help_message(true);
			end;
		end;
	}
	--- @desc </table>
	--- @p @string style name

	-- call the function associated with this style if it exists
	if styles[style] then
		styles[style](self);
	else
		script_error(self.name .. " ERROR: set_style() called but no style record could be found for supplied style [" .. tostring(style) .. "]");
	end;
end;







----------------------------------------------------------------------------
---	@section Starting and Stopping
----------------------------------------------------------------------------


-- function to trigger an animation on our uicomponent if not nil and not a blank string
function movie_overlay:trigger_animation_if_exists(animation_name, animation_duration_override, destroy_on_animation_completed)
	if not self.uic then
		script_error(self.name .. " ERROR: trigger_animation_if_exists() called but the uicomponent has not yet been created? How can this be?");
		return false;
	end;

	if animation_name and animation_name ~= "" then
		local uic = self.uic;

		if not uic:IsValid() then
			return false;
		end;

		if not uic:AnimationExists(animation_name) then
			script_error(self.name .. " ERROR: trigger_animation_if_exists() called but no animation with name [" .. animation_name .. "] could be found on uicomponent with path [" .. uicomponent_to_str(animation) .. "]");
			return false;
		end;

		if animation_duration_override then
			uic:SetAnimationFrameProperty(animation_name, uic:NumAnimationFrames(animation_name) - 1, "interpolation_time", animation_duration_override);
		end;
		
		local output_str = "* movie overlay " .. self.name .. " : triggering animation [" .. animation_name .. "] with a length of " .. uic:GetAnimationFrameProperty(animation_name, uic:NumAnimationFrames(animation_name) - 1, "interpolation_time") .. "s";
		
		if destroy_on_animation_completed then
			output_str = output_str .. " - destroying on end";
		end;

		out(output_str);

		uic:TriggerAnimation(animation_name);

		if destroy_on_animation_completed then
			local listener_name = self.name .. "_destroy_after_hide";

			local animation_test = function()
				if uic:CurrentAnimationId() ~= animation_name then
					self:destroy();
					return true;
				end;
			end;

			local tm = core:get_tm();

			tm:repeat_callback(
				function()
					if animation_test() then
						tm:remove_callback(listener_name);
					end;
				end,
				core:is_campaign() and 0.1 or 100,
				listener_name
			);
		end;

		return true;
	end;

	return false;
end;


--- @function start
--- @desc Starts playback of the movie
function movie_overlay:start()
	if self.is_started then
		script_error(self.name .. " ERROR: start() called but this movie overlay has previously been started");
		return false;
	end;

	-- find a vacant movie track
	local movie_track = 0;
	
	if self.movie_track_forced then
		movie_track = self.movie_track;
	else
		-- try i == 3 and then i == 2, these tracks are supposed to be reserved for script
		for i = common.num_movies_that_can_play_in_parallel() - 1, common.num_movies_that_can_play_in_parallel() - 2, -1 do
			if not common.is_movie_playing_on_track(i) then
				movie_track = i;
				break;
			end;
		end;

		if not movie_track then
			script_error(self.name " ERROR: could not start movie playback as no vacant track could be found")
			return;
		end;

		self.movie_track = movie_track;
	end;


	-- if the uic player has not yet been created then create it with a default style
	if not self.uic then
		self:create_uicomponent();
		self:set_style("default");
	end;

	local uic_overlay = self.uic;
	local uic_player = find_uicomponent(uic_overlay, "movie_overlay_player");

	if not uic_player then
		script_error(self.name .. " ERROR: uic_player not found");

		out.ui("Listing all children of movie_overlay parent uic:");
		print_all_uicomponent_children(uic_overlay);
		return false;
	end;

	-- set the movie track to use
	uic_player:SetProperty("movie_index", movie_track);

	-- make the component visible
	uic_overlay:SetVisible(true);

	local x_pos, y_pos = uic_overlay:Position();
	local x_size, y_size = uic_overlay:Dimensions();

	out("* movie overlay " .. self.name .. " is playing movie with path [" .. self.movie_path .. "] on track [" .. movie_track .. "], overlay position [" .. x_pos .. ", " .. y_pos .. "], dimensions [" .. x_size .. ", " .. y_size .. "]");

	-- play the show animation if we have one
	if not self:trigger_animation_if_exists(self.show_animation, self.show_animation_duration) then
		out("\tnot playing a show animation");
	end;

	self.is_started = true;

	-- loop the movie if we should
	if self.should_loop then
		uic_player:SetProperty("loop", "1");
	end;

	if self.freeze_game_rendering then
		uic_player:SetProperty("block_freeze_views", 1);
	else
		uic_player:SetProperty("block_freeze_views", 0);
	end;

	if self.steal_user_input then
		if core:is_campaign() then
			cm:steal_user_input(true);
		end
	end;

	if self.play_movie_audio then
		uic_player:SetProperty("audio", 1);
	else
		uic_player:SetProperty("audio", 0);
	end;

	if self.stop_game_audio then
		uic_player:SetProperty("pause_game_audio", 1);
	else
		uic_player:SetProperty("pause_game_audio", 0);
	end;

	if self.resize_uicomponent_to_fit then
		uic_player:SetProperty("resize_to_fit", 1);
	else
		uic_player:SetProperty("resize_to_fit", 0);
	end;

	--  set the movie path
	uic_player:SetProperty("path", self.movie_path);

	-- start the movie playback
	uic_player:InterfaceFunction("PlayMovie");

	-- set up monitors for the movie ending / being skipped
	local tm = core:get_tm();

	-- Wait a short time for the movie to start playing, then establish a poll to check if it's still playing
	tm:real_callback(
		function()
			if self.is_skippable then
				-- The movie is skippable - steal the escape key and skip the movie if it is pressed
		
				if core:is_campaign() then
					cm:steal_escape_key_with_callback(
						"movie_overlay_skip_monitor_" .. self.name, 
						function()
							self:skip();
						end
					);
		
				elseif core:is_battle() then
					bm:steal_escape_key_with_callback(
						"movie_overlay_skip_monitor_" .. self.name, 
						function()
							self:skip();
						end
					);
				
				else
					script_error(self.name .. " WARNING: a skippable frontend movie has been created, this is currently unsupported")
				end;
			end;

			self:fixup_callbacks_after_playback_started();
			
			tm:repeat_real_callback(
				function()
					self:check_callbacks_during_playback();
					if not self:is_playing(uic_player) then
						self:finish("movie playback has finished");
					end;
				end,
				10,
				self.name .. "_movie_overlay_stop_monitor"
			);
		end,
		100
	);
end;


-- Check callbacks each frame
function movie_overlay:check_callbacks_during_playback()
	local callbacks_to_call = {};
	
	local frame_callbacks = self.frame_callbacks;
	if #frame_callbacks > 0 then
		local current_frame = common.get_movie_current_frame_num(self.movie_track);

		for i = 1, #frame_callbacks do
			if not frame_callbacks[i].is_called and frame_callbacks[i].frame_num <= current_frame then
				frame_callbacks[i].is_called = true;
				table.insert(callbacks_to_call, frame_callbacks[i].callback);
			end;
		end;
	end;

	for i = 1, #callbacks_to_call do
		callbacks_to_call[i](self);
	end;
end;


-- Called after movie playback started. First, go through all registered timestamp_callbacks and convert them to frame_callbacks which won't be thrown off by playback freezes/debugging. 
-- Then go through the frame_callbacks and set the proper frame for any that were declared with negative values (i.e. they are counting backwards from the end). We do this now because 
-- we can only determine the total number of frames/total movie duration once playback has started.
function movie_overlay:fixup_callbacks_after_playback_started()
	
	local num_movie_frames = common.get_movie_total_frames(self.movie_track);
	local movie_duration = common.get_movie_duration(self.movie_track);
	local fps = num_movie_frames / movie_duration;

	-- Convert all timestamp callbacks in to frame callbacks, as counting by frame is more reliable than by application time
	local timestamp_callbacks = self.timestamp_callbacks;
	for i = 1, #timestamp_callbacks do
		self:add_frame_callback(timestamp_callbacks[i].callback, timestamp_callbacks[i].timestamp * fps);
	end;

	-- For each frame callback below 0, set it counting back from the movie end
	local frame_callbacks = self.frame_callbacks;
	for i = 1, #frame_callbacks do
		if frame_callbacks[i].frame_num < 0 then
			frame_callbacks[i].frame_num = num_movie_frames - frame_callbacks[i].frame_num;
		end;
	end;
end;


-- internal function to clean up any listeners created by start()
function movie_overlay:cleanup_listeners()
	if core:is_campaign() then
		if self.steal_user_input then
			cm:steal_user_input(false);
		end;
		cm:release_escape_key_with_callback("movie_overlay_skip_monitor_" .. self.name);
	elseif core:is_battle() then
		bm:release_escape_key_with_callback("movie_overlay_skip_monitor_" .. self.name);
	end;
	core:get_tm():remove_real_callback(self.name .. "_movie_overlay_stop_monitor");
end;


-- internal function to stop the actual playback of the movie
function movie_overlay:stop()
	if not self.uic then
		script_error(self.name .. " ERROR: stop_movie() called but no overlay uicomponent created - how can this be?");
		return false;
	end;

	if self.uic:IsValid() then
		self.uic:InterfaceFunction("StopMovie");
	end;
end;


--- @function is_playing
--- @desc Returns whether this movie is currently playing.
function movie_overlay:is_playing(uic_player)
	return self.is_started and not self.is_finished and self.movie_track ~= -1 and common.is_movie_playing_on_track(self.movie_track) and uic_player and uic_player:IsValid() and uic_player:Visible(true);
end;


--- @function skip
--- @desc Causes this movie to skip during playback. This is mainly for internal use but can be called externally.
function movie_overlay:skip()
	-- do not proceed if we're not playing
	if self.is_finished or not self.is_started then
		return;
	end;

	self.is_finished = true;

	self:cleanup_listeners();

	self:stop();

	out("* movie overlay " .. self.name .. " : movie has been skipped");

	-- try to trigger one of the following animations in sequence: skip, hide, then destroy
	if not (self:trigger_animation_if_exists(self.skip_animation, self.skip_animation_duration, true) or self:trigger_animation_if_exists(self.hide_animation, self.hide_animation_duration, true)) then
		self:destroy();
	end;

	if self.skip_callback then
		self.skip_callback();
	end;

	if self.end_callback then
		self.end_callback();
	end;
end;


-- movie has finished naturally, either because it doesn't seem to be playing any more or the movie_length duration has elapsed
function movie_overlay:finish(reason)	
	-- do not proceed if we're not playing
	if self.is_finished or not self.is_started then
		return;
	end;

	reason = reason or "no reason specified";

	self.is_finished = true;

	self:cleanup_listeners();

	self:stop();

	out("* movie overlay " .. self.name .. " : movie has ended. Reason given: " .. reason);

	-- try to trigger one of the following animations in sequence: hide then destroy
	if self.hide_on_end then
		if not self:trigger_animation_if_exists(self.hide_animation, self.hide_animation_duration, true) then
			self:destroy();
		end;
	end;

	if self.end_callback then
		self.end_callback();
	end;
end;

-- internal function that destroys the overlay
function movie_overlay:destroy()
	out("* movie overlay " .. self.name .. " : destroying uicomponent");
	if self.uic then
		if self.uic:IsValid() then
			self.uic:Destroy();
		end;
		self.uic = nil;
		if self.destroy_callback then
			self.destroy_callback();
		end;
	end;
end;


--- @end_class



























----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	WINDOWED MOVIE PLAYER
--
--- @set_environment battle
--- @set_environment campaign
--- @set_environment frontend
--- @c windowed_movie_player Windowed Movie Player
--- @page movie_overlay
--- @desc The windowed movie player provides a shorthand interface for playing movies in a window, with a close button. It is of most use for playing movies underneath the advisor, for which the constructor @windowed_movie_player:new_from_advisor should be used. However, it may be used in other contexts, for which the more general purpose constructor @windowed_movie_player:new is used.
--- @desc The windowed movie player makes heavy use of the @movie_overlay system for movie playback.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

windowed_movie_player = {
	name = "",											-- unique name
	movie_path = "",									-- path of movie to play
	uic_parent = false,									-- parent uicomponent to attach to (root will be used if not set)
	movie_aspect_ratio = 1,								-- aspect ratio of the movie to be played - width / height
	width = false,										-- width override of the player panel in pixels (otherwise the width of the panel in the layout is used)
	docking_point = false,								-- docking point to use for panel
	show_animation = false,								-- animation to play on the panel when it is showed
	hide_animation_slides_off_screen_left = false,		-- special switch to modify the keyframe position of the hide animation by the panel's width, so that it moves fully offscreen. This should be set if the panel is docked under the advisor.
	hide_animation = "hide",							-- animation to play on the panel when it is hiding
	close_callback = false,								-- callback to call if the close button is clicked (or ESC is pressed and we're listening for it)
	show_close_button = true,							-- should we show the close button
	panel_hidden_callback = false,						-- callback to call when the panel is fully hidden (just prior to destruction)
	should_steal_esc_key_focus = true,					-- sets whether the player should steal esc key focus
	escape_key_focus_stolen = false,					-- is the player currently stealing the esc key focus
	delay_before_movie_start = 1,						-- sets a delay in s before starting the actual movie playback
	mo = false,											-- movie overlay object - not set until show() is called
	uic_panel = false,									-- player panel uic - not set until show() is called
	is_showing = false									-- records whether the movie player is currently showing
}


set_class_custom_type(windowed_movie_player, TYPE_WINDOWED_MOVIE_PLAYER);
set_class_tostring(
	windowed_movie_player, 
	function(obj)
		return TYPE_WINDOWED_MOVIE_PLAYER .. "_" .. obj.name
	end
);








----------------------------------------------------------------------------
---	@section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns a new windowed movie player object. If creating a windowed movie player docked underneath the advisor, the constructor @windowed_movie_player:new_from_advisor should be used instead.
--- @p @string name, Unique name for this windowed movie object
--- @p @string movie path, Path to movie file, starting from the Movies folder in working data. The file extension should be omitted.
--- @p @number aspect ratio, Movie aspect ratio. This should be the width divided by the height.
--- @p [opt=ui_root] @uicomponent ui_root, Parent uicomponent, to which the windowed movie player should be attached.
--- @r @windowed_movie_player windowed movie player object
function windowed_movie_player:new(name, movie_path, movie_aspect_ratio, uic_parent)

	-- TODO: check that this name is unique
	if not is_string(name) then
		script_error("ERROR: windowed_movie_player:new() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if not is_string(movie_path) then
		script_error("ERROR: windowed_movie_player:new() called but supplied movie path [" .. tostring(movie_path) .. "] is not a string");
		return false;
	end;

	if not is_number(movie_aspect_ratio) then
		script_error("ERROR: windowed_movie_player:new() called but supplied aspect ratio [" .. tostring(movie_aspect_ratio) .. "] is not a number");
		return false;
	end;

	if uic_parent and not is_uicomponent(uic_parent) then
		script_error("ERROR: windowed_movie_player:new() called but supplied parent uicomponent [" .. tostring(uic_parent) .. "] is not a uicomponent or nil");
	end;

	local wmp = {};

	wmp.name = "windowed_movie_player_" .. name;
	
	set_object_class(wmp, self);

	wmp.movie_path = movie_path;
	wmp.movie_aspect_ratio = movie_aspect_ratio;

	-- default parent is the advisor movie docker
	uic_parent = uic_parent or core:get_ui_root();
	 
	wmp.uic_parent = uic_parent;

	return wmp;
end;


--- @function new_from_advisor
--- @desc Creates and returns a new windowed movie player object, set up to play underneath the advisor. This sets the <code>advisor_movie_docker</code> uicomponent to be the panel parent, and also calls @windowed_movie_player:set_hide_animation_slides_off_screen_left to set custom hide animation behaviour that is appropriate for this display mode.
--- @p @string name, Unique name for this windowed movie object.
--- @p @string movie path, Path to movie file, starting from the Movies folder in working data. The file extension should be omitted.
--- @p @number aspect ratio, Movie aspect ratio. This should be the width divided by the height.
--- @r @windowed_movie_player windowed movie player object
function windowed_movie_player:new_from_advisor(name, movie_path, movie_aspect_ratio)
	local uic_advisor_movie_docker = find_uicomponent(core:get_ui_root(), "advisor_movie_docker");
	if not uic_advisor_movie_docker then
		script_error(name .. " ERROR: new_from_advisor() called but couldn't find advisor_movie_docker uicomponent");
		return false;
	end;

	local wmp = windowed_movie_player:new(name, movie_path, movie_aspect_ratio, uic_advisor_movie_docker);
	if not wmp then
		return false;
	end;
	wmp:set_hide_animation_slides_off_screen_left(true);
	return wmp;
end;


--- @function new_centred
--- @desc Creates and returns a new windowed movie player object, set up to play in the centre of the screen.
--- @p @string name, Unique name for this windowed movie object.
--- @p @string movie path, Path to movie file, starting from the Movies folder in working data. The file extension should be omitted.
--- @p @number aspect ratio, Movie aspect ratio. This should be the width divided by the height.
--- @r @windowed_movie_player windowed movie player object
function windowed_movie_player:new_centred(name, movie_path, movie_aspect_ratio)
	local wmp = windowed_movie_player:new(name, movie_path, movie_aspect_ratio, uic_advisor_movie_docker);
	if not wmp then
		return false;
	end;
	wmp:set_docking_point(5);
	return wmp;
end;









----------------------------------------------------------------------------
---	@section Usage
--- @desc Once a handle to a windowed_movie_player object is obtained then functions may be called on it to query or modify its state in the following form.
--- @new_example Specification
--- @example <code>&lt;object_name&gt;:&lt;function_name&gt;(&lt;args&gt;)</code>
--- @new_example Creation and Usage
--- @example local wmp_drag_and_select = windowed_movie_player:new_from_advisor("wmp_test", "wh3_drag_and_select", 16/9);
--- @example wmp_drag_and_select:set_should_steal_esc_key_focus(true)
--- @example wmp_drag_and_select:start()
----------------------------------------------------------------------------







----------------------------------------------------------------------------
---	@section Configuration
----------------------------------------------------------------------------


--- @function set_width
--- @desc Sets the intended panel width. By default, the panel will use the panel width set in the ui layout. The height will also be scaled, based on the aspect ratio supplied to @windowed_movie_player:new.
--- @p @number panel width in pixels
function windowed_movie_player:set_width(width)
	if not is_number(width) or width <= 0 then
		script_error(self.name .. " ERROR: set_width() called but supplied width [" .. tostring(width) .. "] is not a number");
		return false;
	end;

	if self.is_showing then
		script_error(self.name .. " ERROR: set_width() called but panel is already showing");
		return false;
	end;

	self.width = width;
end;


--- @function set_docking_point
--- @desc Sets the panel docking point, which determines how the panel is docked to its parent uicomponent. Docking points are specified as integer values - a list is available in the @uicomponent:Docking section of this documentation.
--- @p @number docking point
function windowed_movie_player:set_docking_point(docking_point)
	if not validate.is_number(docking_point) then
		return false;
	end;

	self.docking_point = docking_point;
end;


--- @function set_show_animation
--- @desc Sets an animation to play on the panel when it is showed. By default no animation is triggered. The animation must be present on the panel uicomponent.
--- @p @string animation name
function windowed_movie_player:set_show_animation(show_animation)
	if not is_string(show_animation) then
		script_error(self.name .. " ERROR: set_show_animation() called but supplied animation name [" .. tostring(show_animation) .. "] is not a string");
		return false;
	end;

	if self.is_showing then
		script_error(self.name .. " ERROR: set_show_animation() called but panel is already showing");
		return false;
	end;
	
	self.show_animation = show_animation;
end;


--- @function set_hide_animation
--- @desc Sets an animation to play on the panel when it is hidden. By default, an animation called "hide" is triggered. The animation must be present on the panel uicomponent.
--- @p @string animation name
function windowed_movie_player:set_hide_animation(hide_animation)
	if not is_string(hide_animation) then
		script_error(self.name .. " ERROR: set_hide_animation() called but supplied animation name [" .. tostring(hide_animation) .. "] is not a string");
		return false;
	end;
	
	self.hide_animation = hide_animation;
end;


--- @function set_hide_animation_slides_off_screen_left
--- @desc Sets a special flag which adjusts the horizontal movement of the hide animation to match the panel width, so the animation moves the panel fully off-screen regardless of width.
--- @p @boolean hide animation slides left
function windowed_movie_player:set_hide_animation_slides_off_screen_left(value)
	if value == false then
		self.hide_animation_slides_off_screen_left = false;
	else
		self.hide_animation_slides_off_screen_left = true;
	end;
end;


--- @function set_close_callback
--- @desc Sets a callback to call if this windowed movie player is closed. The callback is triggered at the point of closure, when the panel has yet to animate off-screen.
--- @p @function callback
function windowed_movie_player:set_close_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: set_close_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	self.close_callback = callback;
end;


--- @function set_show_close_button
--- @desc Sets whether the close button is shown on the windowed movie player. By default the close button is displayed, use this function to not show it if needs be.
--- @p [opt=true] @boolean show close button
function windowed_movie_player:set_show_close_button(show_close_button)
	if show_close_button == false then
		self.show_close_button = false;
	else
		self.show_close_button = true;
	end;
end;


--- @function set_panel_hidden_callback
--- @desc Sets a callback to call when the windowed movie player is fully hidden after being closed. The supplied callback is triggered immediately prior to the panel being destroyed.
--- @p @function callback
function windowed_movie_player:set_panel_hidden_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: set_panel_hidden_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	self.panel_hidden_callback = callback;
end;


--- @function set_should_steal_esc_key_focus
--- @desc Sets whether the panel should steal escape key focus and therefore close itself when the ESC key is pressed. By default the panel does respond to ESC key presses, use this function to disable this behaviour.
--- @p @boolean steal esc key focus
function windowed_movie_player:set_should_steal_esc_key_focus(value)
	if self.is_showing then
		script_error(self.name .. " ERROR: set_should_steal_esc_key_focus() called but panel is already showing");
		return false;
	end;

	if value == false then
		self.should_steal_esc_key_focus = false;
	else
		self.should_steal_esc_key_focus = true;
	end;
end;






----------------------------------------------------------------------------
---	@section Showing and Hiding
----------------------------------------------------------------------------


--- @function show
--- @desc Creates and shows the panel and starts movie playback.
function windowed_movie_player:show()
	if self.is_showing then
		script_error(self.name .. " ERROR: show() called but this windowed movie player is already showing");
		return false;
	end;

	-- create the scripted movie panel
	local uic_scripted_movie_panel = core:get_or_create_component("scripted_movie_panel", "UI/Common UI/scripted_movie_panel.twui.xml");
	if not uic_scripted_movie_panel then
		script_error(self.name .. " ERROR: show() called but uic_scripted_movie_panel not created");
		return false;
	end;

	-- set docking point if we have been supplied one
	if self.docking_point then
		uic_scripted_movie_panel:SetDockingPoint(self.docking_point);
	end;

	-- have the supplied parent adopt the scripted movie panel
	self.uic_parent:Adopt(uic_scripted_movie_panel:Address());

	-- find the scripted movie panel player uicomponent within the scripted movie panel
	local uic_scripted_movie_panel_player = find_uicomponent(uic_scripted_movie_panel, "scripted_movie_panel_player");
	if not uic_scripted_movie_panel_player then
		script_error(self.name .. " ERROR: show() called but uic_scripted_movie_panel_player not found");
		return false;
	end;

	-- the movie player sits within the movie panel with a border around it. Work out how big that border is and use that figure to inform how we should size our elements
	local movie_border_size_twice = (uic_scripted_movie_panel:Width() - uic_scripted_movie_panel_player:Width());

	-- work out a screen size for our movie, based on the existing width of the scripted movie panel player and the aspect ratio
	local movie_panel_width = self.width or uic_scripted_movie_panel_player:Width();
	local movie_panel_height = movie_panel_width / self.movie_aspect_ratio;
	
	-- work out a size for the player that sits within the window, which takes into account the border size
	local movie_panel_player_width = movie_panel_width - movie_border_size_twice;
	local movie_panel_player_height = movie_panel_height - movie_border_size_twice;

	-- trigger a show animation for the panel if we have one
	if self.show_animation then
		uic_scripted_movie_panel:TriggerAnimation(self.show_animation);
	end;

	-- Resize panel and player to desired sizes
	uic_scripted_movie_panel:Resize(movie_panel_width, movie_panel_height);
	uic_scripted_movie_panel_player:Resize(movie_panel_player_width, movie_panel_player_height);

	-- special switch, which if set modifies the hide animation position so that it carries the panel fully offscreen
	if self.hide_animation_slides_off_screen_left then
		uic_scripted_movie_panel:SetAnimationFrameProperty(self.hide_animation, 0, "position", -20 - movie_panel_player_width);
	end;

	-- create a movie overlay, configure and resize it, and have the scripted movie panel player adopt it
	local mo = movie_overlay:new("movie_overlay_" .. self.name, self.movie_path);
	mo:set_skippable(false);
	mo:set_should_loop(true);
	mo:set_freeze_game_rendering(false);
	mo:set_hide_on_end(false);
	mo:set_show_animation("show", 0.5);
	mo:set_stop_game_audio(false);

	mo:resize(movie_panel_player_width, movie_panel_player_height);
	uic_scripted_movie_panel_player:Adopt(mo.uic:Address());

	mo.uic:SetDockingPoint(1);

	-- store handles to the panel uic and the movie overlay object
	self.uic_panel = uic_scripted_movie_panel;
	self.mo = mo;

	self.is_showing = true;

	core:register_windowed_movie_player(self);

	-- Hide the close button if we should
	if not self.show_close_button then
		local uic_close_button = find_uicomponent(uic_scripted_movie_panel, "button_scripted_movie_panel_close");
		if not uic_close_button then
			script_error(self.name .. " ERROR: show() called but uic_close_button was not found");
			return false;
		end;
		uic_close_button:SetVisible(false);
	else
		-- listen for the close button being clicked
		core:add_listener(
			self.name,
			"ComponentLClickUp",
			function(context) return context.string == "button_scripted_movie_panel_close" and UIComponent(UIComponent(context.component):Parent()) == uic_scripted_movie_panel end,
			function() self:hide() end,
			false
		);
	
		-- also steal the escape key and listen for that keypress if we should
		if self.should_steal_esc_key_focus then
			self.escape_key_focus_stolen = true;
			if core:is_battle() then
				bm:steal_escape_key_with_callback(self.name, function() self:hide() end);
			else
				cm:steal_escape_key_with_callback(self.name, function() self:hide() end);
			end;
		end;
	end;

	-- start the movie playback after a short grace period
	core:get_tm():callback(
		function()
			mo:start() 
		end, 
		core:is_campaign() and self.delay_before_movie_start or self.delay_before_movie_start * 1000, 
		self.name
	);
end;


--- @function hide
--- @desc Hides and then destroys the windowed movie player if it is showing, playing an animation to do so if one has been set. This is called internally if the close button is clicked, or if the ESC key is pressed when stolen.
function windowed_movie_player:hide()
	if not self.is_showing then
		return false;
	end;

	self.is_showing = false;

	core:unregister_windowed_movie_player(self);

	local uic_scripted_movie_panel = self.uic_panel;

	-- cancel listeners
	core:remove_listener(self.name);
	core:get_tm():remove_callback(self.name);

	-- release esc key if we stole it
	if self.escape_key_focus_stolen then
		self.escape_key_focus_stolen = false;
		if core:is_battle() then
			bm:release_escape_key_with_callback(self.name, close_panel);
		else
			cm:release_escape_key_with_callback(self.name, close_panel);
		end;
	end;

	-- call callback if we have one
	if self.close_callback then
		self.close_callback();
	end;

	-- if we don't have a hide animation then destroy the panel immediately
	if not self.hide_animation then
		uic_scripted_movie_panel:SetVisible(false);
		uic_scripted_movie_panel:Destroy();
		self.mo = nil;
		return;
	end;

	-- set the panel to report all script events (like ComponentAnimationFinished)
	uic_scripted_movie_panel:AddScriptEventReporter()

	-- wait for the hide animation to complete and then destroy the panel
	local uic_scripted_movie_panel_address = uic_scripted_movie_panel:Address();
	core:add_listener(
		self.name,
		"ComponentAnimationFinished",
		function(context)
			return context.component == uic_scripted_movie_panel_address;
		end,
		function(context)
			-- call callback if we have one
			if self.panel_hidden_callback then
				self.panel_hidden_callback();
			end;

			uic_scripted_movie_panel:Destroy();
			self.mo = nil;
		end,
		false
	);

	-- trigger the hide animation
	uic_scripted_movie_panel:TriggerAnimation(self.hide_animation);
end;