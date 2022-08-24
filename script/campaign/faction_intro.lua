----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	FACTION_INTRO
--
---	@set_environment campaign
--- @data_interface faction_intro Faction Intro
--- @desc Provides the system used to define the cutscenes and start-of-game dressing that fires for a given faction, in a given campaign, and under other conditions.
--- @desc Faction Intro data is defined in the folder of each campaign, under a 'faction_intro' folder. Multiple faction intros can be defined, and will be merged together, allowing for mod compatibility.
--- @desc The Faction Intro system allows an inherited 'preset' system. For example, if lots of factions share the same intro cutscene, that cutscene could be defined as a preset, with each faction intro inheriting from that preset. If one of those factions also had different potential leaders, requiring different advisor voice lines or a different camera position for each one, then that can be defined with variant tables.
---
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------
--- @section How to Use
--- @desc To create your own set of faction-intro data for a given campaign, create a faction_intro folder under that campaign's script folder. e.g. <code>script/campaign/main_warhammer/faction_intro/</code>
--- @desc Scripts placed in this folder must define campaign-intro data, such as initial camera positions and cutscenes. These scripts can have any names, and multiple can be used. The Faction Intro system will load them all and merge them together.
--- @desc The scripts must take the following structure:
--- @new_example
--- @desc An example of a faction intro Lua file.
--- @example local data = {
--- @example 	-- Load order defines the order in which each of these tables is loaded, with later loads overwriting the elements of earlier ones.
--- @example 	-- If this isn't defined, a script will always load last.
--- @example 	-- If two scripts have an equal load-order, the order becomes alphabetical, based on script name.
--- @example 	load_order = 0,
--- @example 	-- A list of functions used to define how a faction's variant might be inferred. A typical example would be determining if we're playing as Karl Franz or Volkmar the Grimm.
--- @example 	variant_key_getters = {
--- @example 		-- ...
--- @example 	},
--- @example 	-- You can use presets to define bits of intro data which are used by lots of factions.
--- @example 	intro_presets = {
--- @example 		theatre_empire = {
--- @example 			cam_gameplay_start = {
--- @example 				x = 402,
--- @example 				y = 497,
--- @example 				d = 29,
--- @example 				b = 0,
--- @example 				h = 67,
--- @example 			}
--- @example 		},
--- @example 	},
--- @example }
--- @example 
--- @example -- This table provides the actual intro data for each faction.
--- @example -- Best practise is to define these after you've defined the initial data table, so that you can reference the contents of the data table (including presets)
--- @example data.faction_intros = {
--- @example 	-- The most simple way to define a faction intro, without using any fancy presets.
--- @example 	wh2_main_lzd_hexoatl = faction_intro_data:new{
--- @example 		cam_gameplay_start = {
--- @example 			x = 402,
--- @example 			y = 497,
--- @example 			d = 29,
--- @example 			b = 0,
--- @example 			h = 67,
--- @example 		},
--- @example 		advice_to_play = {
--- @example 			"war.camp.prelude.lzd.intro.005",
--- @example 			"war.camp.prelude.lzd.intro.006",
--- @example 			"war.camp.prelude.lzd.intro.007",
--- @example 			"war.camp.prelude.lzd.intro.008",
--- @example 		},
--- @example 	},
--- @example 	-- The Golden Order inherits the Empire Theatre preset's camera position, but defines its own advice lines.
--- @example 	wh2_dlc13_emp_golden_order = faction_intro_data:new{
--- @example 		preset = data.intro_presets.theatre_empire,
--- @example 		advice_to_play = {
--- @example 			"war.camp.prelude.emp.intro.005",
--- @example 			"war.camp.prelude.emp.intro.006",
--- @example 			"war.camp.prelude.emp.intro.007",
--- @example 			"war.camp.prelude.emp.intro.008",
--- @example 		},
--- @example 	},
--- @example 	wh_main_emp_empire = {
--- @example 		preset = data.intro_presets.theatre_empire,
--- @example 		-- You can also override data from the preset.
--- @example 		cam_gameplay_start = {
--- @example 			x = 352,
--- @example 			y = 486,
--- @example 			d = 17,
--- @example 			b = 0,
--- @example 			h = 14,
--- @example 		},
--- @example 		-- These are 'variants' for cases where a faction's intro data might differ in certain cases (if it has two possible leaders, for example).
--- @example 		-- The key provided by the 'variant_key_getters' list decides which of these is used.
--- @example 		wh_main_emp_karl_franz = faction_intro_data:new{
--- @example 			advice_to_play = {
--- @example 				"war.camp.prelude.emp.intro.001",
--- @example 				"war.camp.prelude.emp.intro.002",
--- @example 				"war.camp.prelude.emp.intro.003",
--- @example 				"war.camp.prelude.emp.intro.004",
--- @example 			},
--- @example 		},
--- @example 		wh_dlc04_emp_volkmar = faction_intro_data:new{
--- @example 			advice_to_play = {
--- @example 				"dlc04.camp.Volk.intro.001",
--- @example 				"dlc04.camp.Volk.intro.002",
--- @example 				"dlc04.camp.Volk.intro.003",
--- @example 				"dlc04.camp.Volk.intro.004",
--- @example 			},
--- @example 		},
--- @example 	},
--- @example 	
--- @example },
--- @example return data
----------------------------------------------------------------------------

----------------------------------------------------------------------------
--- @section Faction Intro Presets
--- @desc A preset is a template of faction intro data which other tables can inherit from. If all factions in a given culture need to use the same introductory cutscene, for example, it can be defined on a preset. Then each faction's <code>preset</code> entry can be set to the @string key of that preset.
--- @desc Presets are defiend in a faction intro data file and, as with the faction intro definitions themselves, can be re-defined or overriden in multiple files, allowing for mod compatibility.
----------------------------------------------------------------------------

----------------------------------------------------------------------------
--- @section Variants
--- @desc Variants allow a particular faction to have multiple possible introduction data sets.
--- @desc The trigger to use either one variant or another is user-defined: it might use the faction's starting-lord, as a way of handling cases where a faction can be lead by different leaders.
--- @desc Or it might play different voice lines and cutscenes based on the game's difficulty.
--- @desc Variant triggers must be defined using the <code>faction_intro.variant_key_getters</code> table.
--- @new_example Variant Key Getter Example
--- @desc In this example, we construct a variant key using the quantity of players in the game, which is used to adjust the advisor voicelines.
--- @example local data = {
--- @example 	-- Conditions by which a faction can provide a variant key are defined here. You may want to use the presence of a given effect bundle as a reason to have a particular intro to play, for example.
--- @example 	-- Criteria are executed in priority of first to last: if an earlier getter is satisfied and provides a non-nil variant key, then later getters will not be consulted.
--- @example 	variant_key_getters = {
--- @example 		function(faction_interface)
--- @example 			local variant_key = nil
--- @example 			local player_count = #cm:get_human_factions()
--- @example 			if player_count > 2 then
--- @example 				variant_key = "players_3_plus"
--- @example 			else
--- @example 				variant_key = "players_" .. player_count
--- @example 			end
--- @example 			
--- @example 			return variant_key
--- @example 		end
--- @example 	},
--- @example 	intro_data = {
--- @example 		main_warhammer = {
--- @example 			wh2_main_def_naggarond = {
--- @example 				cam_gameplay_start = {
--- @example 					x = 352,
--- @example 					y = 486,
--- @example 					d = 17,
--- @example 					b = 0,
--- @example 					h = 14,
--- @example 				},
--- @example 				players_1 = faction_intro_data:new{
--- @example 					advice_to_play = {
--- @example 						"war.camp.prelude.naggarond.singleplayer.001",
--- @example 						"war.camp.prelude.naggarond.singleplayer.002",
--- @example 					},
--- @example 				},
--- @example 				players_2 = faction_intro_data:new{
--- @example 					advice_to_play = {
--- @example 						"war.camp.prelude.naggarond.twoplayer.001",
--- @example 						"war.camp.prelude.naggarond.twoplayer.002",
--- @example 					},
--- @example 				},
--- @example 				players_3_plus = faction_intro_data:new{
--- @example 					advice_to_play = {
--- @example 						"war.camp.prelude.naggarond.multiplayer.001",
--- @example 						"war.camp.prelude.naggarond.multiplayer.002",
--- @example 					},
--- @example 				},
--- @example 			} 
--- @example 		}
--- @example 	}
--- @example }
--- @example return data
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

----------------------------------------------------------------------------
--- @section Faction Intro Cutscene Configurators
--- @desc If you want to define complicated custom routines for the intro cutscene, you can specify the <code>cutscene_configurator</code> on the faction intro.
--- @desc This is a function which takes a <code>cutscene</code> and makes adjustments to it before the cutscene is called.
--- @new_example Cutscene Configurator Example
--- @desc Creating a custom flyby routine for Hexoatl.
--- @example data.faction_intros = {
--- @example 	wh2_main_lzd_hexoatl = faction_intro_data:new{
--- @example 		cam_gameplay_start = {
--- @example 			x = 402,
--- @example 			y = 497,
--- @example 			d = 29,
--- @example 			b = 0,
--- @example 			h = 67,
--- @example 		},
--- @example 		cutscene_configurator = function(cutscene)
--- @example 			-- Start at location, fade in, zoom in, play advice line, and restore UI.
--- @example 			cutscene:set_relative_mode(true)
--- @example 			cutscene:action_fade_scene(0, 1, 2)
--- @example 			cutscene:action_override_ui_visibility(0, false, data.map_ui)
--- @example 			cutscene:action_set_camera_position(0, {11, 614, 20.705231, 0.0, 65.031822})
--- @example 			cutscene:action_scroll_camera_to_position(1, 8, true, {11, 614, 6.965149, 0.0, 8.008892})
--- @example 			cutscene:action_show_advice(6, "wh3_flyby_dummy_KF")
--- @example 			cutscene:action_override_ui_visibility(7, true, data.map_ui)
--- @example 			cutscene:action_end_cutscene(0)
--- @example 		end,
--- @example 	},
--- @example },
----------------------------------------------------------------------------

----------------------------------------------------------------------------
--- @section Faction Intro Cutscene Styles
--- @desc If lots of your cutscenes for each faction are basically the same, but with slight differences, you can create a <code>cutscene style</code>.
--- @desc A cutscene style is a function which returns a <code>cutscene configurator</code> (which itself returns a cutscene ...). It takes a 'self' parameter (self being the faction intro config table).
--- @desc For example, maybe we want to use the config's <code>cam_gameplay_start</code> variable as a waypoint for our camera in all of our cutscenes.
--- @new_example Cutscene Style Example
--- @desc Creating a zoom-in-and-speak cutscene style that uses positions and advice keys defined on the faction intro config.
--- @example data.cutscene_styles = {
--- @example 	zoom_in_and_speak = function(self)
--- @example 		local new_configurator = function(cutscene)
--- @example 			cutscene:set_relative_mode(true)
--- @example 			cutscene:action_fade_scene(0, 1, 2)
--- @example 			-- Use variables from the config table to inform our cutscene.
--- @example 			cutscene:action_set_camera_position(0, { self.cam_cutscene_start.x, self.cam_cutscene_start.y, self.cam_cutscene_start.d, self.cam_cutscene_start.b, self.cam_cutscene_start.h })
--- @example 			cutscene:action_scroll_camera_to_position(1, 8, true, { self.cam_gameplay_start.x, self.cam_gameplay_start.y, self.cam_gameplay_start.d, self.cam_gameplay_start.b, self.cam_gameplay_start.h })
--- @example 			cutscene:action_show_advice(6, self.advice_line)
--- @example 			cutscene:action_end_cutscene(0)
--- @example 		end
--- @example 
--- @example 		return new_configurator
--- @example 	end	
--- @example }
--- @example 
--- @example data.faction_intros = {
--- @example 	wh2_main_def_har_ganeth = faction_intro_data:new{
--- @example 		preset = data.intro_presets.standard,
--- @example 		cam_cutscene_start = {
--- @example 			x = 134,
--- @example 			y = 641,
--- @example 			d = 20.705231,
--- @example 			b = 0.0,
--- @example 			h = 65.031822,
--- @example 		},
--- @example 		cam_gameplay_start = {
--- @example 			x = 134, 
--- @example 			y = 641,
--- @example 			d = 6.965149,
--- @example 			b = 0,
--- @example 			h = 8.008892,
--- @example 		},
--- @example 		advice_line = "wh3_flyby_dummy_KF",
--- @example 		cutscene_style = data.cutscene_styles.zoom_in_and_speak
--- @example 	}
--- @example }
----------------------------------------------------------------------------


-- Class Definition. This class is mostly used to help us type-check the intro data.
faction_intro_data = {}
set_class_custom_type_and_tostring(faction_intro_data, TYPE_FACTION_INTRO_DATA)

-- Class Constructor
function faction_intro_data:new(source_table)
	local new_data = source_table
	set_object_class(new_data, faction_intro_data)
	return new_data
end

faction_intro = {
	-- The directory from which campaign-specific intro data will be loaded, where %s is replaced with the campaign name.
	data_directory = "/script/campaign/%s/faction_intro/",
	intro_data = {},
}

--- @function perform_intro
--- @desc Perform the start-of-campaign dressing for the specified faction within the specified campaign, playing advisor lines, cutscenes, etc.
--- @desc All playable factions ought to have an intro definition table (even a blank one). If it's missing, an error will be thrown.
--- @p @string campaign_folder_name, The folder from which the campaign's faction intro data should be loaded. This needs to match the folder name from which the campaign's specific scripts are loaded.
--- @p @string faction_key, The faction for which we want to perform the intro, from the <code>factions</code> database table.
function faction_intro:perform_intro(campaign_folder_name, faction_key)
	local error_signature = string.format("campaign '%s'", campaign_folder_name)
	if faction_key then
		error_signature = error_signature .. string.format(", faction '%s'", faction_key)
	else
		script_error(string.format("ERROR: Cannot perform faction intro. Specified faction key has value '%s'. Please specify a valid faction key.", tostring(faction_key)))
	end

	self.intro_data = nil
	self.intro_data = self:load_data(campaign_folder_name)
	if self.intro_data == nil then
		script_error(string.format("ERROR: Couldn't run intro for %s. No intro data could be loaded from campaign folder '%s'. Is there data defiend under this directory?", error_signature, campaign_folder_name))
		return
	end

	local campaign_config = self.intro_data

	-- Attempt to find out if this faction has any variant keys it should be using given the current campaign setup.
	-- Since variant data is provided by the loaded campaign_config, this needs to be done after we get campaign_config.
	local faction_interface = cm:get_faction(faction_key)
	local variant_key = nil
	for _, variant_getter in ipairs(campaign_config.variant_key_getters) do
		variant_key = variant_getter(faction_interface)
		if variant_key ~= nil then
			break
		end
	end
	if variant_key then
		error_signature = error_signature .. string.format(", variant '%s'", variant_key)
	end

	intro_config = campaign_config.faction_intros[faction_key]
	if intro_config == nil then
		script_error(string.format("ERROR: Couldn't run intro for %s. Faction key did not have an entry under this campaign.", error_signature))
		return
	end

	if variant_key ~= nil then
		local faction_config = intro_config
		intro_config = intro_config[variant_key]
		if intro_config == nil then
			script_error(string.format("ERROR: Couldn't run intro for %s. Variant key did not have an entry under this faction and campaign.", error_signature))
			return
		end

		-- For cases where a faction has some intro data, while more specific data is defined in the variant table (e.g. for a specific leader of that faction)
		-- give all the faction config's properties to the variant config table. This is sort of like a slightly different type of inheritance to
		-- the one we're already providing with the 'preset' system.
		self:give_parent_properties_to_child_config(faction_config, intro_config)
	end

	if not is_factionintrodata(intro_config) then
		script_error(string.format("ERROR: Value found at faction intro specification: %s - was not an faction_intro_data table. Are you sure an faction_intro_data object has been created with these specifiers?", error_signature))
		return
	end

	-- It's possible and valid to have an intro config with both of these properties defined (in which case the style overrides the configurator), but only as a result of preset inheritance.
	-- So validate before inheritance that only one or the other has been defined on this faction intro table.
	if intro_config.cutscene_style ~= nil and intro_config.cutscene_configurator ~= nil then
		script_error(string.format("ERROR: The faction intro data for %s had both a cutscene configurator and a cutscene style defined. The style will override the configurator. Only one of these can be specified.", error_signature))
		return
	end

	if self:inherit_presets(intro_config) == false then
		script_error(string.format("ERROR: Couldn't run intro for %s. Failed to inherit presets when attempting to perform faction intro.", error_signature))
	end

	-- Ensure that intro_config's parameters are defaulted to the same default values expected by cm:setup_campaign_intro, unless they've been specified.
	intro_config.hide_faction_leader_during_cutscene = intro_config.hide_faction_leader_during_cutscene or false

	-- If there's a cutscene style, use that to essentially generate a cutscene configurator (which is itself used later to generate a cutscene), taking into account the config table's other data.
	-- This way, you can have your configurator refer to other data in your faction intro, such as the camera_gameplay_start.
	if intro_config.cutscene_style ~= nil then
		local configurator_from_style = intro_config:cutscene_style()
		if configurator_from_style == false then
			script_error(string.format("ERROR: Failed to use cutscene style for %s.", error_signature))
		elseif not is_function(configurator_from_style) then
			script_error(string.format("ERROR: Cutscene style for %s did not produce a cutscene configurator function. Cutscene styles are used to create a dynamic cutscene configurator, and must return that configurator as a function.", error_signature))
			return
		end

		intro_config.cutscene_configurator = configurator_from_style
	end

	-- Allow various parameters to be bundled into an end-of-cutscene callback, in addition to the 'end_callback' cutscene provided by the config (which fires after all the others).
	local composite_end_callback = function()
		intro_config.intro_missions = intro_config.intro_missions or {}
		for m = 1, #intro_config.intro_missions do
			intro_config.intro_missions[m]:start()
		end

		if intro_config.end_callback then
			intro_config.end_callback()
		end
		
		core:trigger_event("ScriptEventCampaignIntroComplete")
	end

	-- If no cindyscene is being provided, argue the duration as the cindyscene parameter instead.
	-- Note that duration may also have not been specified, if the cutscene is manually ended by an action.
	if intro_config.cindy_scene_key == nil then
		intro_config.cindy_scene_key = intro_config.cutscene_duration;
		intro_config.cutscene_duration = nil;
	elseif intro_config.cutscene_duration ~= nil then
		script_error(string.format("ERROR: You cannot specify both a duration (used for defining a brand new cutscene) and a cindy scene key (used for playing an existing one) in faction intro for %s.", error_signature));
	end
	
	cm:setup_campaign_intro_cutscene(intro_config.cam_gameplay_start,
		intro_config.cindy_scene_key,
		intro_config.advice_to_play,
		composite_end_callback,
		intro_config.cutscene_configurator,
		intro_config.fullscreen_movie,
		intro_config.hide_faction_leader_during_cutscene,
		intro_config.pre_cindyscene_delay_callback)
	
		-- Fire How They Play very early to ensure it appears before other missions and popups. It shouldn't actually be visible before the cutscene ends.
	if intro_config.how_they_play then
		out("SHOWING HOW THEY PLAY")
		show_how_to_play_event();
	end
end

-- Load the intro data from the given campaign folder
-- If multiple data tables are loaded, their results are merged together.
function faction_intro:load_data(campaign_folder_name)
	local directory = string.format(self.data_directory, campaign_folder_name)
	--local comma_separated_list = common.filesystem_lookup(directory, "*.lua")
	local file_names = core:get_scripts_in_directory(directory)

	if #file_names == 0 then
		out(string.format(
			"WARNING: faction_intro:load_data() called for campaign %s but no lua files were found at directory %s. No faction intro data will be loaded.",
			campaign_folder_name,
			directory
		))
	end

	local files = {}
	for f = 1, #file_names do
		local loaded_file = cm:load_global_script(file_names[f]) 
		if loaded_file == nil then
			script_error(string.format("ERROR: File '%s' under faction intro directory '%s' did not return a table. Files under this directory need to provide a table of faction intro data.",
				file_names[f], directory));
		else
			table.insert(files, loaded_file)
		end
	end

	return table.compile_tables(files)
end

-- If the specified child config has a preset, provide that child with the preset's values unless it defines its own.
function faction_intro:inherit_presets(child_config)
	presets = presets or {}

	if child_config.preset == nil then
		return
	end

	-- We don't want to make any actual adjustments to the configs themselves. So we copy them before going any further.
	parent_config = table.copy(child_config.preset)

	-- If the parent also has a parent, we'll inherit that grandparen's properties too. And so on.
	self:inherit_presets(parent_config)

	self:give_parent_properties_to_child_config(parent_config, child_config)
end

-- For any non-nil property in the parent that hasn't been overriden by the child, give the child the property of the parent.
-- i.e. if parent = { a = 1, b = 2, c = 3 } and child = { c = 4 } then child becomes { a = 1, b = 2, c = 4 }
function faction_intro:give_parent_properties_to_child_config(parent_config, child_config)
	for k, v in pairs(parent_config) do
		if child_config[k] == nil then
			child_config[k] = v
		end
	end
end