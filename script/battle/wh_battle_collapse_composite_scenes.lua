collapse_composite_scenes = {
	config = {
		start_phase = "Deployed",
		filter_keyword = "collapse",
		-- disabled for release
		camera_shake_enabled = false,
		interval = {
			near = {
				initial_delay = 10000,
				min_interval = 1000,
				max_interval = 5000
			},
			far = {
				initial_delay = 35000,
				min_interval = 5000,
				max_interval = 10000
			}
		},
		shake_keys = {
			"wh3_dlc29_collapse_1",
			"wh3_dlc29_collapse_2",
			"wh3_dlc29_collapse_3",
			"wh3_dlc29_collapse_4",
			"wh3_dlc29_collapse_5",
		} ,
		shake_amplitude_max_random_variability = 0.2,
		shake_sound_events = {
			start = "Bat_Env_Camera_Shake_Start",
			finish = "Bat_Env_Camera_Shake_End"
		},
		shake_duration = {
			wh3_dlc29_collapse_1 = 8000,
			wh3_dlc29_collapse_2 = 7500,
			wh3_dlc29_collapse_3 = 7500,
			wh3_dlc29_collapse_4 = 8000,
			wh3_dlc29_collapse_5 = 7500
		},
	},
	active_camera_shakes = 0,
}

bm:out("********************************************************************");
bm:out("*** loaded collapse composite scene script");
bm:out("********************************************************************");
bm:out("");

function collapse_composite_scenes:validate_config()
	local config = self.config

	if not is_string(config.start_phase) or not is_string(config.filter_keyword) then
		script_error("ERROR: collapse_composite_scenes:validate_config() failed as start_phase or filter_keyword is not a string")
		return false
	end

	if not is_boolean(config.camera_shake_enabled) then
		script_error("ERROR: collapse_composite_scenes:validate_config() failed as camera_shake_enabled is not a boolean")
		return false
	end

	if not is_table(config.interval) then
		script_error("ERROR: collapse_composite_scenes:validate_config() failed as interval is not a table")
		return false
	end

	local function validate_interval(interval_name, interval)
		if not is_table(interval) or not is_non_negative_number(interval.initial_delay) or not is_positive_number(interval.min_interval) or not is_positive_number(interval.max_interval) or interval.min_interval > interval.max_interval then
			script_error("ERROR: collapse_composite_scenes:validate_config() failed as interval [" .. tostring(interval_name) .. "] is invalid")
			return false
		end

		return true
	end

	if not validate_interval("near", config.interval.near) or not validate_interval("far", config.interval.far) then
		return false
	end

	if not is_table_of_strings(config.shake_keys) then
		script_error("ERROR: collapse_composite_scenes:validate_config() failed as shake_keys is not a non-empty table of strings")
		return false
	end

	if not is_table(config.shake_duration) then
		script_error("ERROR: collapse_composite_scenes:validate_config() failed as shake_duration is not a table")
		return false
	end

	for i = 1, #config.shake_keys do
		local shake_key = config.shake_keys[i]

		if not is_positive_number(config.shake_duration[shake_key]) then
			script_error("ERROR: collapse_composite_scenes:validate_config() failed as shake_duration for shake key [" .. shake_key .. "] is not a positive number")
			return false
		end
	end

	if not is_non_negative_number(config.shake_amplitude_max_random_variability) then
		script_error("ERROR: collapse_composite_scenes:validate_config() failed as shake_amplitude_max_random_variability is not a non-negative number")
		return false
	end

	if not is_table(config.shake_sound_events) or not is_string(config.shake_sound_events.start) or not is_string(config.shake_sound_events.finish) then
		script_error("ERROR: collapse_composite_scenes:validate_config() failed as shake_sound_events is invalid")
		return false
	end

	return true
end

if collapse_composite_scenes:validate_config() then
	bm:register_phase_change_callback(
		collapse_composite_scenes.config.start_phase,
		function() 
			collapse_composite_scenes:start_composite_scenes_delayed();
		end
	);
end

function collapse_composite_scenes:schedule_scenes_chained(scenes, interval)
	local scheduled_scenes = {};

	local done = false;

	while not done do
		if #scenes == 0 then 
			done = true;
			break;
		end;
			
		local delay = math.random(interval.min_interval, interval.max_interval);
		local scene = table.remove(scenes, math.random(#scenes));
		local scheduled_scene = { scene = scene, delay = delay };
		table.insert(scheduled_scenes, scheduled_scene);
	end

	if #scheduled_scenes > 0 then
		bm:callback(function() self:play_scene_chained(scheduled_scenes, 1); end, interval.initial_delay);
	end
end

function collapse_composite_scenes:play_scene_chained(scheduled_scenes, index)
	local current = scheduled_scenes[index];

	local scene = current.scene;
	--out("played scene " .. scene:scene_name() .. " at (" .. scene:scene_centre():get_x() .. "," .. scene:scene_centre():get_y() .. "," .. scene:scene_centre():get_x() ..") with NEXT delay " .. current.delay .. "ms");

	scene:enable(true, false)
	scene:play_and_hold();

	if self.config.camera_shake_enabled then
		local shake_key = self.config.shake_keys[math.random(#self.config.shake_keys)];
		local scene_centre = scene:scene_centre();
		local amplitude = 1 + (((math.random() * 2) - 1) * self.config.shake_amplitude_max_random_variability);
		self:start_camera_shake_audio(shake_key)
		bm:camera():add_shake(shake_key, scene_centre, amplitude);
	end

	if index < #scheduled_scenes then
		--out(#scheduled_scenes - index .. " scenes remain")

		bm:callback(function() self:play_scene_chained(scheduled_scenes, index + 1); end, current.delay);
	end
end

function collapse_composite_scenes:start_camera_shake_audio(shake_key)
	if self.active_camera_shakes == 0 then
		play_sound_2D(new_sfx(self.config.shake_sound_events.start, false, false))
	end

	self.active_camera_shakes = self.active_camera_shakes + 1

	bm:callback(
		function()
			self.active_camera_shakes = math.max(self.active_camera_shakes - 1, 0)

			if self.active_camera_shakes == 0 then
				play_sound_2D(new_sfx(self.config.shake_sound_events.finish, false, false))
			end
		end,
		self.config.shake_duration[shake_key]
	)
end

function collapse_composite_scenes:start_composite_scenes_delayed()
	local far_scenes = bm:composite_scenes_system():far_terrain_composite_scenes();
	local scenes = bm:composite_scenes_system():terrain_composite_scenes();

	local near = {};
	local far = {};

	for i = 1, far_scenes:count() do
		local far_scene = far_scenes:item(i);

		local split_name = string.split(far_scene:scene_name(), "/");
		local last_name = split_name[#split_name];

		--out("FAR scene with full name: " .. far_scene:scene_name() .. " and last name: " .. last_name);

		if string.find(last_name, self.config.filter_keyword) ~= nil then
			table.insert(far, far_scene);

			--out("..registered!");
		end
	end

	for i = 1, scenes:count() do
		local scene = scenes:item(i);

		local split_name = string.split(scene:scene_name(), "/");
		local last_name = split_name[#split_name];

		--out("NEAR scene with full name: " .. scene:scene_name() .. " and last name: " .. last_name);

		if table.find(far, scene) == nil and string.find(last_name, self.config.filter_keyword) ~= nil then
			table.insert(near, scene);

			--out("..registered!");
		end
	end

	if self.config.camera_shake_enabled then
		local camera = bm:camera();
		camera:enable_shake();
	end

	self:schedule_scenes_chained(near, self.config.interval.near);
	self:schedule_scenes_chained(far, self.config.interval.far);
end



-- debug functions
function collapse_composite_scenes:restart_all_cs()
	local scenes = bm:composite_scenes_system():terrain_composite_scenes()
	for i = 1, scenes:count() do
		local scene = scenes:item(i)
		if scene then
			scene:play_and_hold()
			out("Restarting composite scene: " .. scene:scene_name())
		end
	end
end
function collapse_composite_scenes:start_all_cs(loop)
	local scenes = bm:composite_scenes_system():terrain_composite_scenes()
	for i = 1, scenes:count() do
		local scene = scenes:item(i)
		if scene then
			scene:enable(true, loop or false)
			scene:play_and_hold()
			out("Starting composite scene: " .. scene:scene_name())
		end
	end
end