





----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
-- TOPIC 
--
--- @set_environment battle
--- @set_environment campaign
--- @set_environment frontend
--- @c topic_leader Topic Leader
--- @desc A topic leader is a message panel that can be made to appear front/centre on-screen, and will then animate away towards a point on the screen. It's intended usage is to draw the player's attention towards an area of the screen, mainly during tutorial content.
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

topic_leader = {
	name = "topic_leader",										-- Unique name for this topic leader. Used for error output and to name the uicomponent created
	layout_name = "UI/Common UI/scripted_topic_leader.twui.xml",			-- UI layout path
	hold_duration = 2000,										-- duration in seconds for which the topic leader should remain on-screen before animating off
	uic_topic_leader = false,									-- a handle to the topic leader uicomponent
	is_showing = false,											-- internal flag for if the topic leader is currently showing
	is_shrinking = false,										-- internal flag for if the topic leader is currently in the process of shrinking off screen
	shrink_target_x = false,									-- on-screen target to which the uicomponent should shrink towards
	shrink_target_y = false,									-- on-screen target to which the uicomponent should shrink towards
	shrink_target_uic = false,									-- on-screen target to which the uicomponent should shrink towards
	shrink_animation_end_proportion = 0.2,						-- shrink animation end proportion size
	--[[
	content = {},												-- table of content data to add to the topic leader
	shrink_callbacks = {}										-- callbacks to call when the topic leader shrinks
	]]
};


set_class_custom_type(topic_leader, TYPE_TOPIC_LEADER);
set_class_tostring(
	topic_leader,
	function(obj)
		return TYPE_TOPIC_LEADER .. "_" .. obj.name
	end
);





----------------------------------------------------------------------------
--- @section Creation
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns a new topic leader object.
--- @p @string name, Names for this topic leader. The topic leader uicomponent will be named after this.
--- @p @string text key, Localisation key (or unlocalised text) to use for the first data entry in the topic leader. This should be supplied in the full [table]_[field]_[key] localisation format, or just as a plain unlocalised string if the fourth argument is set to <code>true</code>.
--- @p [opt=nil] @string text state, Component state for the first text entry on the topic leader. If @nil is supplied then the default state is used.
--- @p [opt=false] @boolean unlocalised, Use the @string supplied as the second argument to this function for display directly, instead of using it to look up a localised key. This can be useful for debugging, but shouldn't be used for released content.
--- @r @topic_leader
function topic_leader:new(name, text_key, text_state, unlocalised)

	if not is_string(name) then
		script_error("topic_leader ERROR: new() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if not is_string(text_key) then
		script_error(name .. " ERROR: new() called but supplied text key [" .. tostring(text_key) .. "] is not a string");
		return false;
	end;

	local tl = {};
	
	tl.name = "topic_leader_" .. name;
	
	set_object_class(tl, self);

	tl.content = {};
	tl.shrink_callbacks = {};

	tl:add_content(text_key, text_state, unlocalised);

	return tl;
end;








----------------------------------------------------------------------------
--- @section Usage
--- @desc Once created, functions on the topic leader be called in the form showed below.
--- @new_example Specification
--- @example &lt;topic_leader_object&gt;:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example local tl = topic_leader:new("new_objective", "random_localisation_strings_string_new_objective");
--- @example tl:set_shrink_target_uicomponent(get_objectives_manager():get_uicomponent(), 20, 20);
--- @example tl:set_hold_duration(2000);
--- @example tl:start();
----------------------------------------------------------------------------








----------------------------------------------------------------------------
--- @section Configuration
----------------------------------------------------------------------------


--- @function add_content
--- @desc Adds a new line of content to the topic leader.
--- @p @string text key, Localisation key (or unlocalised text) to display. This should be supplied in the full [table]_[field]_[key] localisation format, or just as a plain unlocalised string if the third argument is set to <code>true</code>.
--- @p [opt=nil] @string text state, Component state for the text entry. If @nil is supplied then the default state is used.
--- @p [opt=false] @boolean unlocalised, Use the @string supplied as the first argument to this function for display directly, instead of using it to look up a localised key. This can be useful for debugging, but shouldn't be used for released content.
function topic_leader:add_content(text_key, text_state, unlocalised)
	if not is_string(text_key) then
		script_error(self.name .. " ERROR: add_content() called but supplied text key [" .. tostring(text_key) .. "] is not a string");
		return false;
	end;

	if text_state and not is_string(text_state) then
		script_error(self.name .. " ERROR: add_content() called but supplied text state [" .. tostring(text_state) .. "] is not a string");
		return false;
	end;

	local content_record = {
		text_key = text_key,
		text_state = text_state,
		unlocalised = unlocalised
	};

	table.insert(self.content, content_record);
end;


--- @function set_text_state
--- @desc Sets the uicomponent state of the text uicomponent of the topic leader. Use this to customise how the text is displayed.
--- @p @string state
function topic_leader:set_text_state(state)
	if not is_string(state) then
		script_error(self.name .. " ERROR: set_text_state() called but supplied state [" .. tostring(state) .. "] is not a string");
		return false;
	end;

	self.text_state = state;
end;


--- @function set_hold_duration
--- @desc Sets the duration for which the leader uicomponent should hold in place before beginning to animate off-screen. This duration is set in milliseconds, in all game modes. The default value is 2000ms.
--- @p @number hold duration in ms
function topic_leader:set_hold_duration(duration)
	if not is_number(duration) or duration < 0 then
		script_error(self.name .. " ERROR: set_hold_duration() called but supplied duration [" .. tostring(duration) .. "] is not a positive number");
		return false;
	end;

	self.hold_duration = duration;
end;


--- @function set_shrink_target
--- @desc Sets a screen position to which the topic leader should shrink to when playing its shrink animation.
--- @p @number x, x co-ordinate in pixels.
--- @p @number y, y co-ordinate in pixels.
function topic_leader:set_shrink_target(x, y)
	if not is_number(x) then
		script_error(self.name .. " ERROR: set_shrink_target() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a number");
		return false;
	end;

	if not is_number(x) then
		script_error(self.name .. " ERROR: set_shrink_target() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a number");
		return false;
	end;

	self.shrink_target_x = x;
	self.shrink_target_y = y;
	self.shrink_target_uic = false;
end;


--- @function set_shrink_target_uicomponent
--- @desc Sets a uicomponent target to which the topic leader should shrink to when playing its shrink animation. This sets the topic leader to shrink to the top-left of the uicomponent, offset by the optionally-supplied offset co-ordinates. The position of the uicomponent is computed when @topic_leader:start is called.
--- @p @uicomponent uicomponent, UIComponent to which the topic leader should shrink towards when its shrink animation is played.
--- @p [opt=nil] @number x, x offset co-ordinate in pixels.
--- @p [opt=nil] @number y, y offset co-ordinate in pixels.
function topic_leader:set_shrink_target_uicomponent(uicomponent, x_offset, y_offset)
	if not is_uicomponent(uicomponent) then
		script_error(self.name .. " ERROR: set_shrink_target_uicomponent() called but supplied uicomponent [" .. tostring(uicomponent) .. "] is not a uicomponent");
		return false;
	end;

	if x_offset and not is_number(x_offset) then
		script_error(self.name .. " ERROR: set_shrink_target_uicomponent() called but supplied x offset co-ordinate [" .. tostring(x_offset) .. "] is not a number");
		return false;
	end;

	if y_offset and not is_number(y_offset) then
		script_error(self.name .. " ERROR: set_shrink_target_uicomponent() called but supplied y offset co-ordinate [" .. tostring(y_offset) .. "] is not a number");
		return false;
	end;

	self.shrink_target_x = x_offset or 0;
	self.shrink_target_y = y_offset or 0;

	self.shrink_target_uic = uicomponent;
end;


--- @function add_shrink_callback
--- @desc Adds a shrink callback for the topic leader. This function will be called @topic_leader:shrink is called, immediately prior to the topic leader beginning its shrink animation. This functionality may be used to set up the shrink target, amongst other things. Multiple shrink callbacks may be added to one topic leader.
--- @p @function callback
function topic_leader:add_shrink_callback(callback)
	if not validate.is_function(callback) then
		return false;
	end;

	table.insert(self.shrink_callbacks, callback);
end;








----------------------------------------------------------------------------
--- @section Animating
----------------------------------------------------------------------------


-- internal function to populate an individual content entry
function topic_leader:populate_content_entry(uic_entry, content_record)
	if content_record.text_state then 
		uic_entry:SetState(content_record.text_state);
	end;

	if content_record.unlocalised then
		uic_entry:SetStateText(content_record.text_key);
	else
		local localised_text = common.get_localised_string(content_record.text_key);
		if localised_text == "" then
			script_error(self.name .. " ERROR: populate_content_entry() called but could find no localised text corresponding to key [" .. content_record.text_key .. "]");
			return false;
		end;
		uic_entry:SetStateText(localised_text, content_record.text_key);
	end;
end;


--- @function start
--- @desc Creates the topic leader uicomponent and starts its animated sequence.
function topic_leader:start(error_if_already_exists)
	if self.is_showing then
		script_error(self.name .. " WARNING: start() called but topic leader is already showing");
		return false;
	end;

	-- create uicomponent, and get handles to relevant children
	local uic_topic_leader, was_created = core:get_or_create_component("topic_leader_" .. self.name, self.layout_name);
	if not uic_topic_leader then
		script_error(self.name .. " ERROR: start() called but no topic leader uicomponent created - how can this be?");
		return false;
	end;

	if not was_created then
		if error_if_already_exists then
			script_error(self.name .. " ERROR: start() called but uicomponent already exists and the start() function has been told to throw a script error in this case");
		end;
		return false;
	end;

	local uic_content = find_uicomponent(uic_topic_leader, "content");
	if not uic_content then
		script_error(self.name .. " ERROR: start() called but no content uicomponent created - how can this be?");
		return false;
	end;

	local uic_background = find_uicomponent(uic_topic_leader, "background");
	if not uic_background then
		script_error(self.name .. " ERROR: start() called but no background uicomponent created - how can this be?");
		return false;
	end;

	local uic_animation = find_uicomponent(uic_topic_leader, "animation");
	if not uic_animation then
		script_error(self.name .. " ERROR: start() called but no animation uicomponent created - how can this be?");
		return false;
	end;

	-- populate the contents of our uicomponent list based on the contents we've been loaded with
	local content = self.content;
	for i = 1, #content do
		local content_record = content[i];
		local uic_entry;

		if i == 1 then
			-- this is the first item of content to add - use the existing uicomponent in the list
			uic_entry = find_uicomponent(uic_content, "entry");
			self:populate_content_entry(uic_entry, content_record);
		else
			-- this is not the first item of content to add - clone the first and customise it
			uic_entry = UIComponent(find_uicomponent(uic_content, "entry"):CopyComponent("entry_" .. i));
			self:populate_content_entry(uic_entry, content_record);
		end;
	end;

	-- Resize the topic leader to its current bounds
	-- We always do this as it propagates the new size of the top-level uicomponent (which will have been
	-- resized by the text replacement) to the background and animation uicomponents
	do
		local tl_width, tl_height = uic_topic_leader:Bounds();
		uic_topic_leader:Resize(tl_width, tl_height);
		
		-- We also need to set the animation frame properties of the "show" animation of the background, as it performs a resize from-and-to static sizes. We need to set these sizes.
		uic_background:SetAnimationFrameProperty(
			"show", 					-- animation name
			0, 							-- frame number
			"scale", 					-- animation property
			50, 						-- x size
			tl_height					-- y size
		);

		uic_background:SetAnimationFrameProperty(
			"show", 					-- animation name
			1, 							-- frame number
			"scale", 					-- animation property
			tl_width,					-- x size
			tl_height					-- y size
		);
	end;

	-- begin animating the leader uicomponent
	uic_topic_leader:TriggerAnimation("show");

	self.uic_topic_leader = uic_topic_leader;

	self.is_showing = true;

	-- start a timer for the uicomponent animating away
	core:get_tm():real_callback(function() self:shrink() end, self.hold_duration, self.name);
end;


--- @function shrink
--- @desc Forces the topic leader to start playing its shrink animation. Once the topic leader is displayed the shrink animation will play automatically after the hold duration has elapsed, but this function can be called to force it to play early.
function topic_leader:shrink()

	if self.is_shrinking then
		return;
	end;

	-- find topic leader uicomponent
	local uic_topic_leader = find_uicomponent("topic_leader_" .. self.name);
	if not uic_topic_leader then
		script_error(self.name .. " ERROR: shrink() called but no topic leader uicomponent created - how can this be?");
		return false;
	end;

	self.is_shrinking = true;

	-- Call shrink callbacks, if we have any
	for i = 1, #self.shrink_callbacks do
		self.shrink_callbacks[i]();
	end;

	local shrink_anim_move_x, shrink_anim_move_y = 0;
	local shrink_animation_end_proportion = self.shrink_animation_end_proportion;

	local topic_leader_width, topic_leader_height = uic_topic_leader:Dimensions();

	if not self.shrink_target_uic and not self.shrink_target_x then
		-- no shrink anim targets are set - compute one based on the topic leader uic
				
		local topic_leader_x, topic_leader_y = uic_topic_leader:Position();

		shrink_anim_move_x = topic_leader_x + (topic_leader_width * 0.5) - (topic_leader_width * shrink_animation_end_proportion);
		shrink_anim_move_y = topic_leader_y + (topic_leader_height * 0.5) - (topic_leader_height * shrink_animation_end_proportion);
	
	else
		if self.shrink_target_uic then
			-- we have a uicomponent to animate towards
			shrink_anim_move_x, shrink_anim_move_y = self.shrink_target_uic:Position();

			if self.shrink_target_x then
				shrink_anim_move_x = shrink_anim_move_x + self.shrink_target_x;
			end;
			if self.shrink_target_y then
				shrink_anim_move_y = shrink_anim_move_y + self.shrink_target_y;
			end;
		else
			-- we have a position to animate towards
			shrink_anim_move_x = self.shrink_target_x;
			shrink_anim_move_y = self.shrink_target_y;
		end;
	end;

	local last_topic_leader_shrink_anim_frame =  uic_topic_leader:NumAnimationFrames("shrink") - 1;

	-- set the shrink animation initial and end size
	uic_topic_leader:SetAnimationFrameProperty("shrink", 0, "scale", topic_leader_width, topic_leader_height);
	uic_topic_leader:SetAnimationFrameProperty("shrink", last_topic_leader_shrink_anim_frame, "scale", topic_leader_width * shrink_animation_end_proportion, topic_leader_height * shrink_animation_end_proportion);

	local topic_leader_x, topic_leader_y = uic_topic_leader:Position();

	-- out(self.name .. " is shrinking, size [" .. topic_leader_width .. ", " .. topic_leader_height .. "], position [" .. topic_leader_x .. ", " .. topic_leader_y .. "], shrink anim move position [" .. shrink_anim_move_x .. ", " .. shrink_anim_move_y .. "]");

	-- set the shrink animation move-to target
	uic_topic_leader:SetAnimationFrameProperty("shrink", last_topic_leader_shrink_anim_frame, "position", shrink_anim_move_x, shrink_anim_move_y);
	
	-- set the font_scale proportion on the text shrink animation on each child of the content uicomponent, and start their animations off
	local uic_content = find_uicomponent(uic_topic_leader, "content");
	if uic_content then
		for i = 0, uic_content:ChildCount() - 1 do
			local uic_child = UIComponent(uic_content:Find(i));
			uic_child:SetAnimationFrameProperty("shrink", uic_child:NumAnimationFrames("shrink") - 1, "font_scale", shrink_animation_end_proportion);
			uic_child:TriggerAnimation("shrink");
		end;
	else
		script_error(self.name .. " ERROR: shrink() called but no text uicomponent created - how can this be?");
	end;
	
	uic_topic_leader:SetDockingPoint(0);

	uic_topic_leader:TriggerAnimation("shrink");

	core:add_listener(
		self.name .. "ComponentAnimationFinished",
		"ComponentAnimationFinished",
		function(context)
			return context.string == "shrink" and UIComponent(context.component) == uic_topic_leader;
		end,
		function(context)
			self.is_showing = false;
			self.is_shrinking = false;
		end,
		false
	);
end;

--- @function hide
--- @desc Immediately hides the topic leader, if it's showing, and destroys all running processes and listeners started by it.
function topic_leader:hide()

	if self.uic_topic_leader then
		self.uic_topic_leaderuicomponent:Destroy();
	end;

	self.is_showing = false;
	self.is_shrinking = false;

	core:remove_listener(self.name .. "ComponentAnimationFinished");

	core:get_tm():remove_callback(self.name);
end;