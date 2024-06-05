

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	CAMPAIGN_MANAGER
--
---	@set_environment campaign
--- @c campaign_manager Campaign Manager
--- @a cm
--- @index_pos 1
--- @desc The campaign manager is the main interface object in the campaign scripting environment. It wraps the primary @episodic_scripting game interface that the campaign model provides to script, as well as providing a myriad of features and quality-of-life improvements in its own right. Any calls made to the <code>campaign manager</code> that it doesn't provide itself are passed through to the @episodic_scripting interface. The is the intended route for calls to the @episodic_scripting interface to be made.
--- @desc Asides from the @episodic_scripting interface provided through the campaign manager, and the campaign manager interface itself (documented below), the main campaign interfaces provided by code are collectively called the @model_hierarchy. The model hierarchy interfaces allow scripts to query the state of the model at any time.
--- @desc A campaign manager object, called <code>cm</code> in script, is automatically created when the scripts load in campaign configuration.

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

local EVENT_ERROR_SAVEGAME_LOG_MAX_SIZE = 5;


function get_cm()
	if core:get_static_object("campaign_manager") then
		return core:get_static_object("campaign_manager");
	else
		script_error("get_cm() called but no campaign manager created as yet");
	end;
end;


-- Ideally we'd read this out of the database
local all_agent_types = {
	"champion",
	"dignitary",
	"engineer",
	"runesmith",
	"spy",
	"wizard"
};


local corruption_types = {
	"wh3_main_corruption_chaos",
	"wh3_main_corruption_khorne",
	"wh3_main_corruption_nurgle",
	"wh3_main_corruption_skaven",
	"wh3_main_corruption_slaanesh",
	"wh3_main_corruption_tzeentch",
	"wh3_main_corruption_vampiric"
};

-- Set for easy checking of the validity of a corruption type key.
local corruption_types_set = {};
for c = 1, #corruption_types do
	corruption_types_set[corruption_types[c]] = true;
end;


campaign_manager = {				-- default values should not be nil, otherwise they'll fail if looked up
	name = "",
	name_is_set = false,
	game_interface = false,
	cinematic_interface = false,
	tm = false,															-- timer manager
	factions = {},
	model_is_created = false,
	game_is_running = false,
	is_processing_ui_created_callbacks = false,
	is_processing_first_tick_callbacks = false,
	game_is_loaded = false,
	is_multiplayer_campaign = false,
	--[[
	ui_created_callbacks = {},
	ui_created_callbacks_mp_new = {},
	ui_created_callbacks_mp_each = {},
	ui_created_callbacks_sp_new = {},
	ui_created_callbacks_sp_each = {},
	pre_first_tick_callbacks = {},
	first_tick_callbacks = {},
	post_first_tick_callbacks = {},
	first_tick_callbacks_sp_new = {},
	first_tick_callbacks_sp_each = {},
	first_tick_callbacks_mp_new = {},
	first_tick_callbacks_mp_each = {},
	saving_game_callbacks = {},
	post_saving_game_callbacks = {},
	loading_game_callbacks = {},
	linear_sequence_configurations = {},
	mp_queries = {},
	saved_values = {},
	long_savegame_strings_map = {},
	long_savegame_strings_lookup = {},
	]]
	local_faction_name = "",
	human_factions = {},
	event_panel_auto_open_enabled = true,
	use_cinematic_borders_for_automated_cutscenes = true,
	ui_hiding_enabled = true,
	intro_cutscene_playing = false,
	cutscene_playing_allowed = true,

	-- cached local player culture and subculture keys
	local_faction_culture_key = "",
	local_faction_subculture_key = "",
	
	-- save counters
	save_counter = 0,	
	
	-- ui locking
	ui_locked_for_mission = false,
	
	-- advice
	pre_dismiss_advice_callbacks = {},
	PROGRESS_ON_ADVICE_FINISHED_REPOLL_TIME = 0.2,
	advice_enabled = true,
	modify_advice_str = "modify_advice",
	next_advice_location = false,
	advice_debug = false,
	
	-- campaign ui
	campaign_ui_manager = false,
	
	-- move_character data
	move_character_trigger_count = 0,
	move_character_active_list = {},
	
	-- objective and infotext managers
	objectives = false,
	infotext = false,
	
	-- help page manager
	hpm = false,
	
	-- mission managers
	mission_managers = {},
	mission_managers_indexed = {},
	
	-- turn countdown events
	turn_countdown_events = {},
	turn_countdown_round_start_listener_active = false,

	-- event error logs saved to savegame
	event_error_logs = {},

	-- pooled resource tracker
	pooled_resource_tracker = {},
	
	-- intervention manager
	intervention_manager = false,
	
	-- intervention max cost points per session constant
	campaign_intervention_max_cost_points_per_session = 100,
	
	-- turn number modifier
	turn_number_modifier = 0,
	
	-- records whether we're in a battle sequence
		-- if a player battle this will be between the PendingBattle event and the camera being returned to player control post-battle
		-- if not a player battle this will be between the PendingBattle event and the BattleCompleted event
	processing_battle = false,					-- saved into savegame
	
	-- diplomacy panel context listener
	diplomacy_panel_context_listener_started = false,
	
	-- faction region change monitor
	faction_region_change_list = {},
	
	-- event feed message suppression
	all_event_feed_messages_suppressed = false,
	
	-- pending battle cache
	pbc_attackers = {},
	pbc_defenders = {},
	pbc_attacker_value = 1,
	pbc_defender_value = 1,
	pbc_attacker_unit_count = 1,
	pbc_defender_unit_count = 1,
	
	-- cutscene list & debug mode
	cutscene_list = {},
	is_campaign_cutscene_debug = false,
	
	-- scripted subtitles
	subtitles_component_created = false,
	subtitles_visible = false,

	-- queue of characters that entered the recruitment pool during startup
	characters_entered_recruitment_pool_during_startup = nil,
	
	-- chapter mission list
	chapter_missions = {},
	
	-- settlement viewpoint bearing overrides
	settlement_viewpoint_bearings = {},
	
	-- cached camera records
	cached_camera_records = {},
	
	-- notify on character movement monitors
	notify_on_character_movement_active_monitors = {},

	-- UITrigger monitors
	progress_on_all_clients_ui_triggers = {},

	-- mp query unique counter
	mp_query_count = 0,

	-- agent types
	all_agent_types = all_agent_types,
	all_agent_types_lookup = table.indexed_to_lookup(all_agent_types),

	-- time of legends campaign key
	cached_tol_key = false
};


set_class_custom_type_and_tostring(campaign_manager, TYPE_CAMPAIGN_MANAGER);










----------------------------------------------------------------------------
--- @section Creation
--- @desc A campaign manager is automatically created when the script libraries are loaded - see the page on @campaign_script_structure - so there should be no need for client scripts to call @campaign_manager:new themselves. The campaign manager object created is called <code>cm</code>, which client scripts can make calls on.
----------------------------------------------------------------------------


--- @function new
--- @desc Creates and returns a campaign manager. If one has already been created it returns the existing campaign manager. Client scripts should not need to call this as it's already called, and a campaign manager set up, within the script libraries. However the script libraries cannot know the name of the campaign, so client scripts will need to set this using @campaign_manager:set_campaign_name.
--- @p [opt="<unnamed>"] string campaign name
--- @r campaign_manager campaign manager
function campaign_manager:new(name)

	-- see if a campaign manager has already been registered and return it if it has
	local cm = core:get_static_object("campaign_manager");
	if cm then
		return cm;
	end;
	
	-- set a temporary name for the campaign manager if one was not supplied
	local name_is_set = false;
	if name then
		name_is_set = true;
	else
		name = "<unnamed>";
	end;
	
	if not is_string(name) then
		script_error("ERROR: Attempted to create campaign manager but supplied name [" .. tostring(name) .. "] is not a string or nil");
		return false;
	end;
	
	-- set up campaign manager object
	local cm = {};

	-- self = campaign_manager
	set_object_class(cm, self);
	
	-- this will be overridden when the NewSession event is received
	setmetatable(
		campaign_manager,
		{
			__index = function(t, field)
				script_error("ERROR: an attempt was made to access function or value [" .. field .. "] on the campaign manager which it doesn't provide, and before the game interface has been created! The game interface is only created when the NewSession event is received. This needs fixing.");
				-- return a blank function
				return function()
				end;
			end
		}
	);
	
	cm.name = name;
	cm.name_is_set = name_is_set;
	cm.factions = {};
	cm.game_is_running = false;
	cm.ui_created_callbacks = {};
	cm.ui_created_callbacks_mp_new = {};
	cm.ui_created_callbacks_mp_each = {};
	cm.ui_created_callbacks_sp_new = {};
	cm.ui_created_callbacks_sp_each = {};
	cm.pre_first_tick_callbacks = {};
	cm.first_tick_callbacks = {};
	cm.post_first_tick_callbacks = {};
	cm.first_tick_callbacks_sp_new = {};
	cm.first_tick_callbacks_sp_each = {};
	cm.first_tick_callbacks_mp_new = {};
	cm.first_tick_callbacks_mp_each = {};
	cm.saving_game_callbacks = {};
	cm.post_saving_game_callbacks = {};
	cm.loading_game_callbacks = {};
	cm.human_factions = {};
	cm.pre_dismiss_advice_callbacks = {};
	cm.move_character_active_list = {};
	cm.mission_succeeded_callbacks = {};
	cm.saved_values = {};
	cm.long_savegame_strings_map = {};
	cm.long_savegame_strings_lookup = {};
	cm.mission_managers = {};
	cm.turn_countdown_events = {};
	cm.notify_on_character_movement_active_monitors = {};
	cm.linear_sequence_configurations = {};
	cm.mp_queries = {};
	cm.progress_on_all_clients_ui_triggers = {};
	cm.pooled_resource_tracker = {};
	cm.event_error_logs = {};
	cm.misc_logs = {};
	
	-- tooltip mouseover listeners
	cm.tooltip_mouseover_listeners = {};
	cm.active_tooltip_mouseover_listeners = {};
	
	-- faction region change monitor
	cm.faction_region_change_list = {};
	
	-- cutscene list
	cm.cutscene_list = {};
	
	-- key stealing
	cm.stolen_keys = {};
	
	-- starts infotext and objectives managers automatically
	cm.infotext = infotext_manager:new();
	cm.objectives = objectives_manager:new();
	-- cm.objectives:set_debug();
	cm.hpm = help_page_manager:new();
	
	-- stops infotext being added if advice is navigated	
	core:add_listener(
		"advice_navigation_listener",
		"ComponentLClickUp",
		function(context) return context.string == "button_previous" or context.string == "button_next" end,
		function(context) cm.infotext:cancel_add_infotext() end,
		true
	);

	core:add_listener(	"set_cutscene_playing_allowed",
						"SetCutscenePlayingAllowed",
						true,
						function(context)
							cm:set_cutscene_playing_allowed(context:cutscene_playing_allowed());
						end,
						true
					);
	
	-- start pending battle cache
	cm.pbc_attackers = {};
	cm.pbc_defenders = {};
	cm.pbc_attacker_value = 1;
	cm.pbc_defender_value = 1;
	cm:start_pending_battle_cache();
	
	-- list of chapter missions
	cm.chapter_missions = {};
	
	-- cached camera positions
	cm.cached_camera_records = {};
	
	-- overwrite out() with a custom output function for campaign
	getmetatable(out).__call = function(t, input) 		-- t is the 'this' object
		-- support for printing other types of objects
		if not is_string(input) then
			if is_number(input) or is_nil(input) or is_boolean(input) then
				input = tostring(input);
			elseif is_uicomponent(input) then
				out("%%%%% uicomponent (more output on ui tab):");
				out("%%%%% " .. uicomponent_to_str(input));
				output_uicomponent(input);
				return;
			else
				cm:output_campaign_obj(input);
				return;
			end;
		end;
		
		input = input or "";
		
		local timestamp = get_timestamp();
		local output_str = timestamp .. string.format("%" .. 11 - string.len(timestamp) .."s", " ");
		
		-- add in all required tab chars
		for i = 1, out.tab_levels["out"] do
			output_str = output_str .. "\t";
		end;

		output_str = output_str .. input;
		print(output_str);
		
		-- logfile output
		if __write_output_to_logfile then
			local file = io.open(__logfile_path, "a");
			if file then
				file:write("[out] " .. output_str .. "\n");
				file:close();
			end;
		end;
	end;
	
	-- output
	if name_is_set then
		out("Starting campaign manager for " .. name .. " campaign");
	else
		out("Starting campaign manager, name is not currently set");
	end;
	
	-- start listener for the NewSession event
	core:add_listener(
		"campaign_manager_new_session_listener",
		"NewSession",
		true,
		function(context)			
			-- set up proper link to game_interface object
			local game_interface = GAME(context);
			cm.game_interface = game_interface;
			cm.cinematic_interface = game_interface:cinematic();

			-- overwrite previous index entry
			set_object_class(self, game_interface);
		end,
		true
	);
	
	
	-- start listener for the WorldCreated event: when it's received, start campaign listeners that must start before the first tick
	core:add_listener(
		"campaign_manager_world_created_listener",
		"WorldCreated",
		true,
		function(context)

			cm.model_is_created = true;

			local model = cm:model();
			local is_multiplayer_campaign =	model:is_multiplayer();
			cm.is_multiplayer_campaign = is_multiplayer_campaign;

			-- create the timer manager at this point
			cm.tm = timer_manager:new_campaign(cm);
			core.tm = cm.tm;

			-- start listeners for tracking whether we're processing a battle.
			-- this has to be done now as some UI panels will open before the first tick
			cm:start_processing_battle_listeners(is_multiplayer_campaign);

			-- prevent UI input if this is a new singleplayer game, to prevent players from being able to skip any intro cutscene before it gets a chance to play
			if cm:is_new_game() and not is_multiplayer_campaign then
				cm:steal_user_input(true);
				
				-- if user input has been stolen then check whether any cutscenes have been registered on the first tick - if none have, then release user input (as no intro cutscene is loaded to do it for us)
				-- (this is a bit of a hack)
				cm:add_first_tick_callback_sp_new(
					function()
						if #self.cutscene_list == 0 then
							cm:steal_user_input(false);
						end
					end
				);
			end;

			self.cached_tol_key = model:shared_states_manager():get_state_as_string_value("tol_campaign");
		end,
		true
	);

	-- Create a link to the game interface object in the global registry. This is used by autotest scripts (which are also responsible for its deletion)
	core:add_ui_created_callback(
		function(context)
			_G.campaign_env = core:get_env();

			-- Call internal ui created callbacks
			cm:ui_created(context);
		end
	);
	
	-- start listener for the FirstTickAfterWorldCreated event: generally used
	-- by users to kick off startup scripts
	core:add_listener(
		"campaign_manager_first_tick_listener",
		"FirstTickAfterWorldCreated",
		true,
		function(context)
			cm:first_tick(context);
		end,
		true
	);

	-- Load the event error log and check it when the game is loaded
	cm:add_loading_game_callback(
		function() 
			local event_error_logs = cm.event_error_logs;
			if event_error_logs then
				if is_table(event_error_logs) then
					if #event_error_logs > EVENT_ERROR_SAVEGAME_LOG_MAX_SIZE then
						-- we are loading more errors than we can support, so rebuild the list at the smaller size
						local new_event_error_logs = {};

						for i = #event_error_logs + 1 - EVENT_ERROR_SAVEGAME_LOG_MAX_SIZE, #event_error_logs do
							table.insert(new_event_error_logs, event_error_logs[i]);
						end;

						event_error_logs = new_event_error_logs;
						cm:set_saved_value("event_error_logs", event_error_logs);
					end;
				else
					script_error("WARNING: loading game, but event_error_logs value in savegame is of type [" .. type(event_error_logs) .. "] which is not a table. Will set it to be a blank table. Value is: " .. tostring(event_error_logs));
					event_error_logs = {};
					cm:set_saved_value("event_error_logs", event_error_logs);
				end;
			else
				event_error_logs = {};
			end;
			cm:check_event_errors_on_startup();
		end
	);

	-- start listeners for the SavingGame and LoadingGame events
	core:add_listener(
		"campaign_manager_saving_game_listener",
		"SavingGame",
		true,
		function(context)
			cm:saving_game(context);
		end,
		true
	);
	
	core:add_listener(
		"campaign_manager_loading_game_listener",
		"LoadingGame",
		true,
		function(context)
			cm:loading_game(context);
		end,
		true
	);

	-- declare some lookup listeners
	core:declare_lookup_listener(
		"faction_turn_start_listeners_by_name",
		"FactionTurnStart",
		function(context)
			return context:faction():name();
		end
	);

	core:declare_lookup_listener(
		"faction_turn_start_listeners_by_culture",
		"FactionTurnStart",
		function(context)
			return context:faction():culture();
		end
	);

	core:declare_lookup_listener(
		"faction_turn_start_listeners_by_subculture",
		"FactionTurnStart",
		function(context)
			return context:faction():subculture();
		end
	);

	core:declare_lookup_listener(
		"pooled_resource_changed_listeners_by_faction_name",
		"PooledResourceChanged",
		function(context)
			return context:has_faction() and context:faction():name();
		end
	);

	core:declare_lookup_listener(
		"pooled_resource_regular_income_listeners_by_faction_name",
		"PooledResourceRegularIncome",
		function(context)
			return context:has_faction() and context:faction():name();
		end
	);

	core:add_listener(
		"dilemma_output",
		"DilemmaIssuedEvent",
		true,
		function(context)
			out(" *");
			out(" * DilemmaIssuedEvent received for faction " .. context:faction():name() .. ", key is " .. context:dilemma());
			out(" *");
		end,
		true
	);

	core:add_listener(
		"battle_being_fought",
		"BattleBeingFought",
		true,
		function(context)
			cm:set_saved_value("battle_being_fought", true);
		end,
		true
	);

	core:add_listener(
		"battle_being_fought",
		"BattleCompleted",
		true,
		function(context)
			cm:set_saved_value("battle_being_fought", false);
		end,
		true
	);

	-- start UITrigger monitor process
	cm:start_progress_on_all_clients_ui_triggered_monitor();

	cm:start_mp_query_listener();

	cm:start_new_character_entered_recruitment_pool_listener();

	-- register this object as a static object with the core (only one may exist at a time)
	core:add_static_object("campaign_manager", cm);
	
	return cm;
end;









----------------------------------------------------------------------------
--- @section Usage
--- @desc Once created, which happens automatically when the script libraries are loaded, functions on the campaign manager object may be called in the form showed below.
--- @new_example Specification
--- @example cm:<i>&lt;function_name&gt;</i>(<i>&lt;args&gt;</i>)
--- @new_example Creation and Usage
--- @example cm = campaign_manager:new()		-- object automatically set up by script libraries
--- @example 
--- @example -- within campaign script
--- @example cm:set_campaign_name("test_campaign")
----------------------------------------------------------------------------








----------------------------------------------------------------------------
--- @section Campaign Name
--- @desc Client scripts should set a name for the campaign using @campaign_manager:set_campaign_name before making other calls. This name is used for output and for loading campaign scripts.
----------------------------------------------------------------------------


--- @function set_campaign_name
--- @desc Sets the name of the campaign. This is used for some output, but is mostly used to determine the file path to the campaign script folder which is partially based on the campaign name. If the intention is to use @campaign_manager:require_path_to_campaign_folder or @campaign_manager:require_path_to_campaign_faction_folder to load in script files from a path based on the campaign name, then a name must be set first. The name may also be supplied to @campaign_manager:new when creating the campaign manager.
--- @p string campaign name
function campaign_manager:set_campaign_name(name)
	if not is_string(name) then
		script_error("ERROR: set_campaign_name() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	self.name = name;
	self.name_is_set = true;
	out("Campaign name has been set to " .. name);
end;


--- @function get_campaign_name
--- @desc Returns the name of the campaign.
--- @r string campaign name
function campaign_manager:get_campaign_name()
	return self.name;
end;









----------------------------------------------------------------------------
--- @section Loading Campaign Script Files
--- @desc One important role of the campaign manager is to assist in the loading of script files related to the campaign. By current convention, campaign scripts are laid out in the following structure:
--- @desc <table class="simple"><tr><td><code>script/campaign/</code></td><td>scripts related to all campaigns</td></tr><tr><td><code>script/campaign/%campaign_name%/</code></td><td>scripts related to the current campaign</td></tr><tr><td><code>script/campaign/%campaign_name%/factions/%faction_name%/</code></td><td>scripts related to a particular faction in the current campaign (when that faction is being played)</td></tr></table>
--- @desc The functions in this section allow the paths to these script files to be derived from the campaign/faction name, and for scripts to be loaded in. @campaign_manager:load_local_faction_script is the easiest method for loading in scripts related to the local faction. @campaign_manager:load_global_script is a more general-purpose function to load a script with access to the global environment.
----------------------------------------------------------------------------


--- @function get_campaign_folder
--- @desc Returns a static path to the campaign script folder (currently "data/script/campaign")
--- @r string campaign folder path
function campaign_manager:get_campaign_folder()
	return "data/script/campaign";
end;


--- @function require_path_to_campaign_folder
--- @desc Adds the current campaign's folder to the path, so that the lua files related to this campaign can be loaded with the <code>require</code> command. This function adds the root folder for this campaign based on the campaign name i.e. <code>script/campaign/%campaign_name%/</code>, and also the factions subfolder within this. A name for this campaign must have been set with @campaign_manager:new or @campaign_manager:set_campaign_name prior to calling this function.
function campaign_manager:require_path_to_campaign_folder()
	-- don't proceed if no campaign name has been set
	if not self.name_is_set then
		script_error("ERROR: require_path_to_campaign_folder() called but no campaign name set, call set_campaign_name() first");
		return false;
	end;

	package.path = package.path .. ";" .. self:get_campaign_folder() .. "/" .. self.name .. "/factions/?.lua"
	package.path = package.path .. ";" .. self:get_campaign_folder() .. "/" .. self.name .. "/?.lua"
end;


--- @function require_path_to_campaign_faction_folder
--- @desc Adds all player factions' script folder for the current campaign to the lua path (<code>script/campaign/%campaign_name%/factions/%player_faction_name%/</code>), so that scripts related to the faction can be loaded with the <code>require</code> command. Unlike @campaign_manager:require_path_to_campaign_folder this can only be called after the game state has been created. A name for this campaign must have been set with @campaign_manager:new or @campaign_manager:set_campaign_name prior to calling this function.
function campaign_manager:require_path_to_campaign_faction_folder()
	-- don't proceed if no campaign name has been set
	if not self.name_is_set then
		script_error("ERROR: require_path_to_campaign_folder() called but no campaign name set, call set_campaign_name() first");
		return false;
	end;
	
	if not self.game_is_running then
		script_error("ERROR: require_path_to_campaign_folder() called but game has not yet been created - call this later in the load sequence");
		return false;
	end;

	local human_faction_keys = self:get_human_factions();
	
	if #human_faction_keys == 0 then
		script_error("ERROR: require_path_to_campaign_faction_folder() called but no local factions could be found - has it been called too early during the load sequence, or during an autotest?");
		return false;
	end;
	
	for i = 1, #human_faction_keys do
		package.path = package.path .. ";" .. self:get_campaign_folder() .. "/" .. self.name .. "/factions/" .. human_faction_keys[i] .. "/?.lua"
	end;
end;


--- @function load_global_script
--- @desc This function attempts to load a lua script from all folders currently on the path, and, when loaded, sets the environment of the loaded file to match the global environment. This is used when loading scripts within a block (within if statement that is testing for the file's existence, for example) - loading the file with <code>require</code> would not give it access to the global environment.
--- @desc Call @campaign_manager:require_path_to_campaign_folder and/or @campaign_manager:require_path_to_campaign_faction_folder if required to include these folders on the path before loading files with this function, if required. Alternatively, use @campaign_manager:load_local_faction_script for a more automated method of loading local faction scripts.
--- @desc If the script file fails to load cleanly, a script error will be thrown.
--- @desc See also @core:load_global_script, which this function calls.
--- @p string script name
--- @p [opt=false] boolean single player only
--- @new_example Loading faction script
--- @desc This script snippet requires the path to the campaign faction folder, then loads the "faction_script_loader" script file, when the game is created.
--- @example cm:add_pre_first_tick_callback(
--- @example 	function()	
--- @example 		if cm:get_local_faction_name(true) then
--- @example 			cm:require_path_to_campaign_faction_folder();
--- @example 
--- @example 			if cm:load_global_script("faction_script_loader") then
--- @example 				out("Faction scripts loaded");
--- @example 			end;
--- @example 		end;
--- @example 	end
--- @example );
--- @result Faction scripts loaded 
function campaign_manager:load_global_script(scriptname, single_player_only)

	if not validate.is_string(scriptname) then
		return false;
	end;

	if single_player_only and self:is_multiplayer() then
		return false;
	end;

	return core:load_global_script(scriptname);
end;


--- @function load_local_faction_script
--- @desc Loads a script file in the factions subfolder that corresponds to the name of each player faction, with the supplied string appellation attached to the end of the script filename. This function is the preferred method for loading in local faction-specific script files. It calls @campaign_manager:require_path_to_campaign_faction_folder internally to set up the path, and uses @campaign_manager:load_global_script to perform the loading. It must not be called before the game is created.
--- @p string script name appellation
--- @r @boolean file loaded successfully
--- @new_example
--- @desc Assuming a faction named <code>fact_example</code> in a campaign named <code>main_test</code>, the following script would load in the script file <code>script/campaigns/main_test/factions/fact_example/fact_example_start.lua</code>.
--- @example cm:add_pre_first_tick_callback(
--- @example 	function()
--- @example 		cm:load_local_faction_script("_start");
--- @example 	end
--- @example );
function campaign_manager:load_local_faction_script(name_appellation, single_player_only)

	if name_appellation then
		if not is_string(name_appellation) then
			script_error("ERROR: load_local_faction_script() called but supplied name appellation [" .. tostring(name_appellation) .. "] is not a string");
			return false;
		end;
	else
		name_appellation = "";
	end;
	
	local human_faction_keys = self:get_human_factions();
	
	if #human_faction_keys == 0 then
		out("Not loading local faction scripts as no local factions could be determined");
		return false;
	end;
	
	for i = 1, #human_faction_keys do
		local script_name = human_faction_keys[i] .. name_appellation;

		if not vfs.exists("script/campaign/" .. self:get_campaign_name() .. "/factions/" .. human_faction_keys[i] .. "/" .. script_name .. ".lua") then
			script_error("ERROR: load_local_faction_script() couldn't find faction script called [" .. script_name .. "] for faction [" .. human_faction_keys[i] .. "]");
			return false;
		end;
	
		-- include path to scripts in script/campaigns/<campaign_name>/factions/<faction_name>/* associated with this campaign/faction
		self:require_path_to_campaign_faction_folder();	
		
		out("Loading faction script " .. script_name .. " for faction " .. human_faction_keys[i]);
		
		out.inc_tab();
		
		-- faction scripts loaded here - function will return true if the load succeeded
		if self:load_global_script(script_name, single_player_only) then
			out.dec_tab();
		else
			out.dec_tab();

			return false;
		end;
	end;
	
	out("Faction scripts loaded");
	return true;
end;


--- @function load_exported_files
--- @desc Loads all lua script files with filenames that contain the supplied string from the target directory. This is used to load in exported files e.g. export_ancillaries.lua, as the asset graph system may create additional files with an extension of this name for each DLC, where needed (e.g. export_ancillaries_dlcxx.lua). The target directory is "script" by default.
--- @p string filename, Filename subset of script file(s) to load.
--- @p [opt="script"] string path, Path of directory to load script files from, from working data. This should be supplied without leading or trailing "/" separators.
--- @new_example
--- @desc Assuming a faction named <code>fact_example</code> in a campaign named <code>main_test</code>, the following script would load in the script file <code>script/campaigns/main_test/factions/fact_example/fact_example_start.lua</code>.
--- @new_example
--- @desc Loads all script files from the "script" folder which contain "export_triggers" as a subset of their name.
--- @example cm:load_exported_files("export_triggers")
function campaign_manager:load_exported_files(filename, path_str)

	if not is_string(filename) then
		script_error("ERROR: load_exported_files() called but no string filename supplied");
		return false;
	end;
	
	if path_str and not is_string(path_str) then
		script_error("ERROR: load_exported_files() called but supplied path [" .. tostring(path_str) .. "] is not a string");
		return false;
	end;
	
	path_str = path_str or "script";
	package.path = package.path .. ";" .. path_str .. "/?.lua;";
	
	local all_files_str = self.game_interface:filesystem_lookup("/" .. path_str .. "/", filename .. "*.lua");
	
	if not is_string(all_files_str) or string.len(all_files_str) == 0 then
		script_error("WARNING: load_exported_files() couldn't find any files with supplied name " .. filename);
		return;
	end;
	
	local files_to_load = {};
	local pointer = 1;
	
	while true do
		local next_separator = string.find(all_files_str, ",", pointer);
		
		if not next_separator then
			-- this is the last entry
			table.insert(files_to_load, string.sub(all_files_str, pointer));
			break;
		end;
		
		table.insert(files_to_load, string.sub(all_files_str, pointer, next_separator - 1));
		
		pointer = next_separator + 1;
	end;
		
	-- strip the path off the start and the .lua off the end
	for i = 1, #files_to_load do
		local current_str = files_to_load[i];
			
		-- find the last '\' or '/' character
		local pointer = 1;
		while true do
			local next_separator = string.find(current_str, "\\", pointer) or string.find(current_str, "/", pointer);
			
			if next_separator then
				pointer = next_separator + 1;
			else
				-- this is the last separator
				if pointer > 1 then
					current_str = string.sub(current_str, pointer);
				end;
				break;
			end;
		end;
			
		-- remove the .lua suffix, if any
		local suffix = string.sub(current_str, string.len(current_str) - 3);
		
		if string.lower(suffix) == ".lua" then
			current_str = string.sub(current_str, 1, string.len(current_str) - 4);
		end;
		
		files_to_load[i] = current_str;
		
		out.inc_tab();
		self:load_global_script(current_str);
		out.dec_tab();
	end;	
end;









----------------------------------------------------------------------------
--- @section Loading Linear Sequence Campaign Files
--- @desc It's sometimes desirable to set up a linear sequence of campaign content that involves a series of different loading configurations. The most common example of this would be some introductory content for a campaign - for example a short campaign tutorial, followed by a scripted battle, followed by a wider campaign tutorial, followed by another scripted battle, followed by the open world campaign. The various campaign sections in such a setup will likely be housed in different files, and for this kind of gameplay sequence to work the loading scripts must be able to work out which files to load in each case, based on values saved into both the savegame and the scripted value registry. This quickly becomes an involved problem to solve as the system has to cope with being loaded into from a savegame, surviving a handler reset, loading into a specified state because of tweaker values (for debugging), as well as handling normal progression.
--- @desc The functions described in this section provide a simple interface to set up such linear sequences of campaign gameplay, where A leads to B leads to C and so on. There is no limit to the number of campaign segments that may be chained together using this system.
--- @desc Client scripts may establish one or more configurations by making calls to @campaign_manager:add_linear_sequence_configuration. When all configurations are established @campaign_manager:load_linear_sequence_configuration may be called, which picks a configuration and loads the local faction script file specified in that configuration. During the running of that script (or any scripted battle that subsequently loads), another configuration may be set up as the next configuration to load by setting the svr boolean of that second configuration to <code>true</code>. When the campaign script next loads (unless from the frontend or a savegame) it will pick the new configuration based on the value of the svr boolean.
--- @desc When adding a configuration a tweaker may be specified in the call to @campaign_manager:add_linear_sequence_configuration. By setting this same tweaker prior to the game starting the configuration loader can be forced to load that configuration.
----------------------------------------------------------------------------


--- @function add_linear_sequence_configuration
--- @desc Adds a linear sequence configuration. All added linear sequences will be queried when @campaign_manager:load_linear_sequence_configuration is called, with one being picked and loaded based on the game state.
--- @desc The name, svr boolean, and tweaker name (where set) of each configuration must be unique compared to other configurations.
--- @p @string name, Script name for this configuration. This must not contain spaces. The name of a saved value which gets saved with the campaign is derived from this name.
--- @p @string filename, Appellation of script file to be passed to @campaign_manager:load_local_faction_script (which performs the actual script loading) if this configuration is chosen by @campaign_manager:load_linear_sequence_configuration.
--- @p @string svr bool, Name of a scripted value registry boolean which, if set, causes this configuration to be loaded. When the transition from some other configuration to this configuration is desired, the game scripts should set this boolean value to <code>true</code> with @scriptedvalueregistry:SaveBool. The next time the campaign scripts load and @campaign_manager:load_linear_sequence_configuration, this configuration will be chosen. Once chosen in this manner, the svr boolean is set back to <code>false</code> again.
--- @p [opt=false] @boolean is default, Make this the default configuration if no other is chosen. Only one default configuration may be set.
--- @p [opt=false] @string tweaker, Name of tweaker value which, if set, forces this configuration to be chosen for loading. This is used for debugging scripts and forcing the game to start in a particular configuration.
function campaign_manager:add_linear_sequence_configuration(name, filename, svr_bool, is_default, tweaker)
	if not is_string(name) then
		script_error("ERROR: add_linear_sequence_configuration() called but supplied configuration name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if not is_string(filename) then
		script_error("ERROR: add_linear_sequence_configuration() called but supplied filename appelation [" .. tostring(filename) .. "] is not a string");
		return false;
	end;

	if not is_string(svr_bool) then
		script_error("ERROR: add_linear_sequence_configuration() called but supplied svr boolean name [" .. tostring(svr_bool) .. "] is not a string");
		return false;
	end;

	if tweaker and not is_string(tweaker) then
		script_error("ERROR: add_linear_sequence_configuration() called but supplied tweaker name [" .. tostring(tweaker) .. "] is not a string or nil");
		return false;
	end;

	-- check that the supplied values are unique where they should be
	for i = 1, #self.linear_sequence_configurations do
		local current_config = self.linear_sequence_configurations[i];

		if current_config.name == name then
			script_error("ERROR: add_linear_sequence_configuration() called but a configuration with supplied name [" .. name .. "] has already been added");
			return false;
		end;

		if current_config.svr_bool == svr_bool then
			script_error("ERROR: add_linear_sequence_configuration() called but a configuration with supplied svr boolean name [" .. svr_bool .. "] has already been added");
			return false;
		end;

		if tweaker and current_config.tweaker == tweaker then
			script_error("ERROR: add_linear_sequence_configuration() called but a configuration with supplied tweaker name [" .. tweaker .. "] has already been added");
			return false;
		end;

		if is_default and current_config.is_default then
			script_error("ERROR: add_linear_sequence_configuration() is attempting to set configuration with name [" .. name .. "] to be default but a configuration with name [" .. current_config.name .. "] is already set to be default");
			return false;
		end;
	end;

	-- assembly a configuration record and add it
	table.insert(
		self.linear_sequence_configurations,
		{
			name = name,
			filename = filename,
			svr_bool = svr_bool,
			is_default = not not is_default,
			tweaker = tweaker
		}
	);
end;


--- @function load_linear_sequence_configuration
--- @desc Picks a configuration previously added with @campaign_manager:add_linear_sequence_configuration and loads it, based on certain values:
--- @desc <ul><li>The function first looks at svr boolean values for each configuration. If one is set then that configuration is chosen, and the boolean is set back to false. These booleans should be individually set to <code>true</code> by client scripts when they wish to transition from loading scripts in one configuration to another.</li>
--- @desc <li>If no svr boolean is set and it's a new game, the function checks the value of the tweaker specified by each configuration. If any tweaker is set then that configuration is loaded.</li>
--- @desc <li>If no svr boolean is set and it's a not a new game, the function checks to see if a saved value exists corresponding to any configuration. If one is found then that configuration is loaded.</li>
--- @desc <li>If no configuration has been loaded so far then a registry value derived from the name of each configuration is checked, which would indicate that the handler has been forceably reset. If any configuration matches then that configuration is loaded.</li>
--- @desc <li>If still no configuration has been loaded then all configurations are checked to see if there's a default. If there is a default configuration then it is loaded.</li></ul>
function campaign_manager:load_linear_sequence_configuration()
	if self:is_multiplayer() then
		script_error("WARNING: load_linear_sequence_configuration() called in multiplayer mode - linear sequences are only valid in singleplayer mode");
		return;
	end;

	local linear_sequence_configurations = self.linear_sequence_configurations;
	local campaign_config_to_load = false;

	-- check svr booleans first
	-- these should be set when transitioning from one game config to another
	for i = 1, #linear_sequence_configurations do
		local current_config = linear_sequence_configurations[i];
		if current_config.svr_bool and core:svr_load_bool(current_config.svr_bool) then
			-- the svr boolean for this configuration is set to true - set it back to false and load with this config
			core:svr_save_bool(current_config.svr_bool, false);
			out("Will load scripts in " .. current_config.name .. " configuration as svr boolean " .. current_config.svr_bool .. " is set and it's a new game");
			campaign_config_to_load = current_config;
		end;
	end;
	
	-- if no svr values were set..
	if not campaign_config_to_load then
		if self:is_new_game() then
			-- this is a new game, check tweaker values
			if not campaign_config_to_load then
				for i = 1, #linear_sequence_configurations do
					if core:is_tweaker_set(linear_sequence_configurations[i].tweaker) then
						campaign_config_to_load = linear_sequence_configurations[i];
						out("load_linear_sequence_configuration() will load scripts in " .. campaign_config_to_load.name .. " configuration as tweaker " .. campaign_config_to_load.tweaker .. " is set and it's a new game");
						break;
					end;
				end;
			end;
		
		else
			-- this is a saved game, check campaign saved values
			for i = 1, #linear_sequence_configurations do
				if self:get_saved_value("bool_load_" .. linear_sequence_configurations[i].name) then
					campaign_config_to_load = linear_sequence_configurations[i];
					out("load_linear_sequence_configuration() will load scripts in " .. campaign_config_to_load.name .. " configuration as bool_load_" .. campaign_config_to_load.name .. " is set in savegame");
					break;
				end;
			end;
		end;
	end;
	
	-- check registry bool values last of all - these help scripts reload into the correct environment if a handler reset has been done
	if not campaign_config_to_load then
		for i = 1, #linear_sequence_configurations do
			if core:svr_load_registry_bool("rbool_load_" .. linear_sequence_configurations[i].name) then
				campaign_config_to_load = linear_sequence_configurations[i];
				out("load_linear_sequence_configuration() will load scripts in " .. campaign_config_to_load.name .. " configuration as rbool_load_" .. campaign_config_to_load.name .. " is set in registry");
				break;
			end;
		end;
	end;
	
	-- pick the default config if no other config loaded
	if not campaign_config_to_load then
		for i = 1, #linear_sequence_configurations do
			if linear_sequence_configurations[i].is_default then
				campaign_config_to_load = linear_sequence_configurations[i];
				out("load_linear_sequence_configuration() will load scripts in " .. campaign_config_to_load.name .. " configuration as it is the default and we're not being told to load anything else");
				break;
			end;
		end;
	end;
	
	if campaign_config_to_load then
		-- Set rbool and saved value of this config to true, and other configs to false.
		-- Registry booleans instruct the game to load back into this mode in the event of a handle reset.
		-- Saved booleans instruct the game to load back into this mode if it's saved and reloaded.
		core:svr_save_registry_bool("rbool_load_" .. campaign_config_to_load.name, true);
		self:set_saved_value("bool_load_" ..  campaign_config_to_load.name, true);

		for i = 1, #linear_sequence_configurations do
			if linear_sequence_configurations[i].name ~= campaign_config_to_load.name then
				core:svr_save_registry_bool("rbool_load_" .. campaign_config_to_load.name, false);
				self:set_saved_value("bool_load_" .. linear_sequence_configurations[i].name, false);
			end;
		end;
		
		-- load script
		self:load_local_faction_script(campaign_config_to_load.filename, true);						-- sp only
	else
		script_error("ERROR: load_linear_sequence_configuration() couldn't determine a campaign configuration in which to load");
	end;
end;











----------------------------------------------------------------------------
--- @section Loading Game
--- @desc Early in the campaign loading sequence the <code>LoadingGame</code> event is triggered by the game code, even when starting a new game. At this time, scripts are able to load script values saved into the savegame using @campaign_manager:load_named_value. These values can then be used by client scripts to set themselves into the correct state.
--- @desc Functions that perform the calls to @campaign_manager:load_named_value may be registered with @campaign_manager:add_loading_game_callback, so that they get called when the <code>LoadingGame</code> event is triggered.
--- @desc The counterpart function to @campaign_manager:load_named_value is @campaign_manager:save_named_value, which is used when the game saves to save values to the save file.
--- @desc See also @campaign_manager:set_saved_value and @campaign_manager:get_saved_value, which can be used at any time by client scripts to read and write values that will automatically saved and loaded to the save game.
--- @desc In the game loading sequence, the <code>LoadingGame</code> event is received before the game is created and the first tick.

--- @example cm:add_loading_game_callback(
--- @example	function(context)
--- @example		player_progression = cm:load_named_value("player_progression", 0, context);
--- @example 	end
--- @example )
----------------------------------------------------------------------------


function campaign_manager:get_saved_value_separator_str()
	return ":::";
end;


function campaign_manager:get_saved_value_terminator_str()
	return ";;;";
end;


-- Because of idiosyncracies in the behaviour of loadstring(), we swap out special characters like ", ', \\ and \n in strings within tables we want to save (this is done in table.tostring). This function restores the table after loading to its original state.
local function post_loadstring_table_fixup(t)
	for key, value in pairs(t) do
		local value_type = type(value);
		if value_type == "table" then
			post_loadstring_table_fixup(value);
		elseif value_type == "string" then
			t[key] = string_special_chars_post_load_fixup(t[key]);
		end;
	end;
end;


--- @function add_loading_game_callback
--- @desc Adds a callback to be called when the <code>LoadingGame</code> event is received from the game. This callback will be able to load information from the savegame with @campaign_manager:load_named_value. See also @campaign_manager:add_saving_game_callback and @campaign_manager:save_named_value to save the values that will be loaded here.
--- @desc Note that it is preferable for client scripts to use this function rather than listen for the <code>LoadingGame</code> event themselves as it preserves the ordering of certain setup procedures.
--- @p function callback, Callback to call. When calling this function the campaign manager passes it a single context argument, which can then be passed through in turn to @campaign_manager:load_named_value.
function campaign_manager:add_loading_game_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: add_loading_game_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	table.insert(self.loading_game_callbacks, callback);
end;
	

-- called internally when the LoadingGame event is received
function campaign_manager:loading_game(context)
	local counter = core:get_unique_counter();

	out("");
	out("********************************************************************************");
	out(self.name .. " event has occurred:: LoadingGame");
	out("\toutput is shown on the savegame console spool - unique counter for this output is [" .. counter .. "]");

	out.cache_tab("savegame");
	out.savegame("");
	out.savegame("********************************************************************************");
	out.savegame(self.name .. " event has occurred:: LoadingGame");
	out.inc_tab("savegame");
	out.savegame("unique counter for this output is [" .. counter .. "]");
	
	self.game_is_loaded = true;

	--
	--
	-- Load long savegame strings map first, and build a lookup table
	local long_savegame_strings_map = self:load_named_value("long_savegame_strings_map", {}, context);
	local long_savegame_strings_lookup = {};
	for i = 1, #long_savegame_strings_map do
		long_savegame_strings_lookup[long_savegame_strings_map[i].name] = true;
	end;

	self.long_savegame_strings_map = long_savegame_strings_map;
	self.long_savegame_strings_lookup = long_savegame_strings_lookup;
	--
	

	-- loading library values
	self.save_counter = self:load_named_value("__save_counter", 0, context);
	
	-- only perform these actions if this is not a new game
	if not self:is_new_game() then
		self.processing_battle = self:load_named_value("is_processing_battle", false, context);
		
		self:load_values_from_string(self:load_named_value("saved_values", "", context));
		
		-- set up the help page manager even if the tweaker disabling scripts is set
		self.hpm:load_history_from_string(self:load_named_value("help_page_history", "", context));		
		
		local mission_managers_save_table = self:load_named_value("mission_managers", {}, context);
		local intervention_manager_state_str = self:load_named_value("intervention_manager_state", "", context);
		
		self.pbc_attackers = self:load_named_value("pending_battle_cached_attackers", {}, context);
		self.pbc_defenders = self:load_named_value("pending_battle_cached_defenders", {}, context);
		-- Pending attackers and defenders used to be saved as a long string, with data separated by ',' and '$'.
		-- Now, it's saved as its native table form. But for older saves, still attempt to load from the string.
		if is_empty_table(self.pbc_attackers) or is_empty_table(self.pbc_defenders) then
			-- load pending battle cache strings and then build the tables from them
			local pending_battle_cached_attacker_str = self:load_named_value("pending_battle_cached_attacker_str", "", context);
			local pending_battle_cached_defender_str = self:load_named_value("pending_battle_cached_defender_str", "", context);
			
			if pending_battle_cached_attacker_str ~= "" then
				self.pbc_attackers = self:pending_battle_cache_table_from_string(pending_battle_cached_attacker_str);
			end;
			if pending_battle_cached_defender_str ~= "" then
				self.pbc_defenders = self:pending_battle_cache_table_from_string(pending_battle_cached_defender_str);
			end;
		end;
		
		self:turn_countdown_events_from_string(self:load_named_value("turn_countdown_events", "", context));
		self:faction_region_change_monitor_from_str(self:load_named_value("faction_region_change_monitor", "", context));
		
		self.pbc_attacker_value = self:load_named_value("pending_battle_cached_attacker_value", 0, context);
		self.pbc_defender_value = self:load_named_value("pending_battle_cached_defender_value", 0, context);
		self.pbc_attacker_unit_count = self:load_named_value("pbc_attacker_unit_count", 0, context);
		self.pbc_defender_unit_count = self:load_named_value("pbc_defender_unit_count", 0, context);

		self.pooled_resource_tracker = self:load_named_value("pooled_resource_tracker", {}, context);
		self:start_pooled_resource_trackers_on_load();

		self.event_error_logs = self:load_named_value("event_error_logs", {}, context);
		do
			-- Load any event_error_logs from where they used to live as a saved value, and insert them in the new event error logs table
			local event_error_logs = self.event_error_logs;
			local old_event_error_logs = self:get_saved_value("event_error_logs");
			if is_table(old_event_error_logs) then
				for i = 1, #old_event_error_logs do
					table.insert(event_error_logs, i, old_event_error_logs[i]);
				end;

				-- Clear old event error logs
				self:set_saved_value("event_error_logs", false);
			end;
		end;

		self.misc_logs = self:load_named_value("misc_logs", {}, context);

		self:add_post_first_tick_callback(
			function()
				self:setup_mission_managers_post_first_tick(mission_managers_save_table);
				self:get_intervention_manager():state_from_string(intervention_manager_state_str);
				self:start_turn_countdown_messages_from_savegame();
			end
		);
	end;
	
	-- invasion manager state
	load_invasion_manager(context);
	
	-- process loading game callbacks
	for i = 1, #self.loading_game_callbacks do
		self.loading_game_callbacks[i](context);
	end;
	
	out.dec_tab("savegame");
	out.savegame("********************************************************************************");
	out.savegame("");
	out.restore_tab("savegame");
	
	out("********************************************************************************");
	out("");
end;


--- @function load_named_value
--- @desc Loads a named value from the savegame. This may only be called as the game is being loaded, and must be passed the context object supplied by the <code>LoadingGame</code> event. Values are saved and loaded from the savegame with a string name, and the values themselves can be a boolean, a number, a string, or a table containing booleans, numbers or strings.
--- @p @string value name, Value name. This must be unique within the savegame, and should match the name the value was saved with, with @campaign_manager:save_named_value.
--- @p object default value, Default value, in case the value could not be loaded from the savegame. The default value supplied here is used to determine/must match the type of the value being loaded.
--- @p userdata context, Context object supplied by the <code>LoadingGame</code> event.
--- @p [opt=false] @boolean allow default value to be nil, If set to true, the default value can be nil.
function campaign_manager:load_named_value(name, default, context, allow_nil)
	allow_nil = allow_nil or false;

	if not is_string(name) then
		script_error("ERROR: load_named_value() called but supplied value name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if default == nil then
		if allow_nil then
			return nil;
		else
			script_error("ERROR: load_named_value() called but no default value supplied. Is the default value something that can be nil sometimes? If so, set 'allow_nil' to true when calling load_named_value()");
			return false;
		end;
	end;
	
	if not context then
		script_error("ERROR: load_named_value() called but no context supplied");
		return false;
	end;
	
	if type(default) == "table" then
		local table_save_state = self:load_named_string(name, "", context);
		
		-- check that we have a value to convert to a table
		if table_save_state then
			local table_func = loadstring(table_save_state);
			
			if is_function(table_func) then
				local retval = table_func();
				if is_table(retval) then
					post_loadstring_table_fixup(retval);
					out.savegame("Loading value " .. name .. " [" .. tostring(retval) .. "]");
					return retval;
				end;
			end;
		end;
		
		return default;
	elseif is_string(default) then
		return self:load_named_string(name, default, context);
	else
		local retval = self.game_interface:load_named_value(name, default, context);
		out.savegame("Loading value " .. name .. " [" .. tostring(retval) .. "]");
		return retval;
	end
end;


-- Load a string value from the savegame, potentially recombining it from multiple string values if a long string mapping exists
function campaign_manager:load_named_string(name, default, context)

	-- If we don't have any long string lookup for a variable with this name then just return it without any recombining
	if not self.long_savegame_strings_lookup[name] then
		return self.game_interface:load_named_value(name, default, context);
	end;

	-- Recombine this string from many in the savegame
	local str_table = {};

	local long_savegame_strings_map = self.long_savegame_strings_map;

	for i = 1, #long_savegame_strings_map do
		local current_map = long_savegame_strings_map[i];
		if current_map.name == name then
			local current_str = self.game_interface:load_named_value(current_map.long_str_name, "", context);
			table.insert(str_table, current_str);
		end;
	end;

	return table.concat(str_table);
end;


--- @function get_saved_value
--- @desc Retrieves a value saved using the saved value system. Values saved using @campaign_manager:set_saved_value are added to an internal register within the campaign manager, and are automatically saved and loaded with the game, so there is no need to register callbacks with @campaign_manager:add_loading_game_callback or @campaign_manager:add_saving_game_callback. Once saved with @campaign_manager:set_saved_value, values can be accessed with this function.
--- @desc Values are stored and accessed by a string name. Values can be booleans, numbers or strings.
--- @p string value name
--- @r object value
function campaign_manager:get_saved_value(name)
	return self.saved_values[name];
end;


--- @function get_cached_value
--- @desc Retrieves or generates a value saved using the saved value system. When called, the function looks up a value by supplied name using @campaign_manager:get_saved_value. If it exists it is returned, but if it doesn't exist a supplied function is called which generates the cached value. This value is saved with the supplied name, and also returned. A value is generated the first time this function is called, therefore, and is retrieved from the savegame on subsequent calls with the same arguments. If the supplied function doesn't return a value, a script error is triggered.
--- @p string value name
--- @p function generator callback
--- @r object value
function campaign_manager:get_cached_value(saved_value_name, generator_callback)
	if not is_string(saved_value_name) then
		script_error("ERROR: get_cached_value() called but supplied saved value name [" .. tostring(saved_value_name) .. "] is not a string");
		return false;
	end;
	
	if not is_function(generator_callback) then
		script_error("ERROR: get_cached_value() called but supplied generator callback [" .. tostring(generator_callback) .. "] is not a function");
		return false;
	end;
	
	local saved_value = self:get_saved_value(saved_value_name);

	if not is_nil(saved_value) then
		return saved_value;
	end;
	
	saved_value = generator_callback();
	
	if is_nil(saved_value) then
		script_error("ERROR: get_cached_value() generator callback did not return a valid value, returned value is [" .. tostring(saved_value) .. "]");
	else
		self:set_saved_value(saved_value_name, saved_value);
	end;
	
	return saved_value;
end;


-- called internally when the game loads, to load values saved with set_saved_value
function campaign_manager:load_values_from_string(str)
	if not is_string(str) then
		script_error("ERROR: load_values_from_string() called but supplied string [" .. tostring(str) .. "] is not a string");
		return false;
	end;

	local pointer = 1;

	-- Separator str ":::"
	-- Terminator str ";;;"
	local separator_str = self:get_saved_value_separator_str();
	local terminator_str = self:get_saved_value_terminator_str();
	local separator_str_len = string.len(separator_str);
	local terminator_str_len = string.len(terminator_str);

	-- First, see if there is a count at the start of the string. Older savegames won't have it. If it's there, it will be in the format
	-- <num>;;; and its presence will allow us to verify the number of saved values being loaded again.
	local saved_count;

	do
		local next_separator = string.find(str, separator_str, pointer);
		local next_terminator = string.find(str, terminator_str, pointer);
		if next_separator and next_terminator and next_separator > next_terminator then
			-- The first terminator str ";;;" is before the first separator ":::", which must mean that the count is present			
			local count_str = string.sub(str, pointer, next_terminator - 1);
			if count_str then
				local count_num = tonumber(count_str);
				if count_num then
					saved_count = count_num;
				end;
			end;

			-- position the pointer immediately after the first terminator
			pointer = next_terminator + terminator_str_len;
		end;
	end;
	
	local count = 0;
	while true do
		-- Format is:
		-- value_name:::value_type:::value_length:::value;;;
		local next_separator = string.find(str, separator_str, pointer);
		
		if not next_separator then
			break;
		end;

		-- Do an explicit test for a peculiar form of corruption that seems to be creeping in, where a number value followed by a terminator (e.g. 88;;;) is appearing in the middle of the saved string.
		-- This looks suspiciously like residual count validation values hanging around from previous savegames but I'm not sure how this can happen. Hopefully we can track it down.
		do
			local next_terminator = string.find(str, terminator_str, pointer);
			if next_terminator and next_terminator < next_separator then
				local corrupted_name = string.sub(str, pointer, next_separator - 1);

				-- Repair the pointer so that it jumps over the broken value
				pointer = next_terminator + terminator_str_len;
				
				-- string.sub(str, pointer, next_separator - 1)
				script_error("WARNING: Attempting to load saved values but the saved value string is corrupted. A new value is being read but the next terminator is before the next separator. The corrupted value name [" .. corrupted_name .. "] will be recovered to [" .. string.sub(str, pointer, next_separator - 1) .. "] so it should be safe to proceed");
			end;
		end;
		
		local value_name = string.sub(str, pointer, next_separator - 1);

		pointer = next_separator + separator_str_len;
		
 		next_separator = string.find(str, separator_str, pointer);
		
		if not next_separator then
			script_error("ERROR: load_values_from_string() called but supplied str is malformed: " .. str);
			return false;
		end;
		
		local value_type = string.sub(str, pointer, next_separator - 1);
		pointer = next_separator + separator_str_len;
		
		next_separator = string.find(str, separator_str, pointer);
		
		if not next_separator then
			script_error("ERROR: load_values_from_string() called but supplied str is malformed: " .. str);
			return false;
		end;
		
		local value_length = string.sub(str, pointer, next_separator - 1);
		local num_value_length = tonumber(value_length);
		
		if not num_value_length then
			script_error("ERROR: load_values_from_string() called, but retrieved value_length [" .. tostring(value_length) .. "] could not be converted to a number in string: " .. str);
			return false;
		end;
		
		pointer = next_separator + separator_str_len;
		
		local value = string.sub(str, pointer, pointer + num_value_length - 1);
		
		if value_type == "boolean" then
			if value == "true" then
				value = true;
			else
				value = false;
			end;
		elseif value_type == "number" then
			local value_number = tonumber(value);
			
			if not value_number then
				-- try replacing any "." characters with "," and vice versa
				local value_copy = string.gsub(value, "%.", ",");

				value_number = tonumber(value_copy);
				if not value_number then
					value_copy = string.gsub(value, ",", ".");
					value_number = tonumber(value_copy);
					if not value_number then
						script_error("ERROR: load_values_from_string() called, but couldn't convert loaded numeric value [" .. value .. "] to a number in string: " .. str);
						return false;
					end;
				end;
			end;
			value = value_number;

		elseif value_type == "table" then
			local table_func = loadstring(value);

			if is_function(table_func) then
				local t = table_func();
				if is_table(t) then
					post_loadstring_table_fixup(t);
					value = t;
				else
					script_error("ERROR: load_values_from_string() called, but loaded table value (reproduced after this script error) with name [" .. value_name .. "] could not be converted into a table - how can this be?");
				end;
			else
				script_error("ERROR: load_values_from_string() called, but loaded table value (reproduced after this script error) with name [" .. value_name .. "] could not be converted into a function by loadstring() - how can this be? table_func is " .. tostring(table_func));
			end;
		elseif value_type ~= "string" then
			script_error("ERROR: load_values_from_string() called, but couldn't recognise supplied value type [" .. tostring(value_type) .. "] in string: " .. str);
			return false;
		end;

		count = count + 1;
		self:set_saved_value(value_name, value);

		pointer = pointer + num_value_length + terminator_str_len;
	end;

	if saved_count and count ~= saved_count then
		script_error("ERROR: loading values from string but while [" .. saved_count .. "] values were supposed to have been saved, [" .. count .. "] were loaded. This is a serious error, please investigate immediately");
	end;
end;













-----------------------------------------------------------------------------
--- @section Saving Game
--- @desc These are the complementary functions to those in the @"campaign_manager:Loading Game" section. When the player saves the game, the <code>SavingGame</code> event is triggered by the game. At this time, variables may be saved to the savegame using @campaign_manager:save_named_value. Callbacks that make calls to this function may be registered with @campaign_manager:add_saving_game_callback, so that they get called at the correct time.
-----------------------------------------------------------------------------


--- @function add_saving_game_callback
--- @desc Registers a callback to be called when the game is being saved. The callback can then save individual values with @campaign_manager:save_named_value.
--- @p function callback, Callback to call. When calling this function the campaign manager passes it a single context argument, which can then be passed through in turn to @campaign_manager:save_named_value.
function campaign_manager:add_saving_game_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: add_saving_game_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	table.insert(self.saving_game_callbacks, callback);
end;


--- @function add_post_saving_game_callback
--- @desc Add a callback to be called after the game has been saved. These callbacks are called last in the saving sequence, and only the first time the game is saved after they have been added.
--- @p function callback, Callback to call. When calling this function the campaign manager passes it a single context argument.
function campaign_manager:add_post_saving_game_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: add_post_saving_game_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	table.insert(self.post_saving_game_callbacks, callback);
end;
	
	
-- called internally when the game saves
function campaign_manager:saving_game(context)
	local counter = core:get_unique_counter();

	self.long_savegame_strings_map = {};
	self.long_savegame_strings_lookup = {};

	out("");
	out("********************************************************************************");
	out(self.name .. " event has occurred:: SavingGame");
	out("\toutput is shown on the savegame console spool - unique counter for this output is [" .. counter .. "]");

	out.cache_tab("savegame");
	out.savegame("");
	out.savegame("********************************************************************************");
	out.savegame(self.name .. " event has occurred:: SavingGame");
	out.inc_tab("savegame");
	out.savegame("unique counter for this output is [" .. counter .. "]");
	
	-- increment the save_counter value
	self.save_counter = self.save_counter + 1;
	
	-- saving library values
	self:save_named_value("__save_counter", self.save_counter, context);
	self:save_named_value("saved_values", self:saved_values_to_string(), context);
	self:save_named_value("mission_managers", self:get_mission_managers_for_saving_game(), context);
	self:save_named_value("intervention_manager_state", self:get_intervention_manager():state_to_string(), context);
	self:save_named_value("turn_countdown_events", self:turn_countdown_events_to_string(), context);
	self:save_named_value("faction_region_change_monitor", self:faction_region_change_monitor_to_str(), context);
	self:save_named_value("help_page_history", self.hpm:help_page_history_to_string(), context);
	self:save_named_value("pooled_resource_tracker", self:process_table_save(self.pooled_resource_tracker), context);
	self:save_named_value("event_error_logs", self:process_table_save(self.event_error_logs), context);
	self:save_named_value("misc_logs", self:process_table_save(self.misc_logs), context);
	self:save_named_value("is_processing_battle", self.processing_battle, context);
	
	-- save the cached attacker and defender armies
	self:save_named_value("pending_battle_cached_attackers", self.pbc_attackers, context);
	self:save_named_value("pending_battle_cached_defenders", self.pbc_defenders, context);
	self:save_named_value("pending_battle_cached_attacker_value", self.pbc_attacker_value, context);
	self:save_named_value("pending_battle_cached_defender_value", self.pbc_defender_value, context);
	self:save_named_value("pbc_attacker_unit_count", self.pbc_attacker_unit_count, context);
	self:save_named_value("pbc_defender_unit_count", self.pbc_defender_unit_count, context);
	
	-- invasion manager state
	save_invasion_manager(context);
	
	-- process saving game callbacks
	for i = 1, #self.saving_game_callbacks do
		self.saving_game_callbacks[i](context);
	end;
	
	out.dec_tab("savegame");
	out.savegame("********************************************************************************");
	out.savegame("");
	out.restore_tab("savegame");

	out("********************************************************************************");
	out("");
	
	-- process post-saving game callbacks
	for i = 1, #self.post_saving_game_callbacks do
		self.post_saving_game_callbacks[i](context);
	end;
	
	-- make sure post-saving-game callbacks only happen once
	self.post_saving_game_callbacks = {};

	-- save the map of any long savegame strings last of all
	self:save_named_value("long_savegame_strings_map", self:process_table_save(self.long_savegame_strings_map), context);
end;


--- @function save_named_value
--- @desc Saves a named value from the savegame. This may only be called as the game is being saved, and must be passed the context object supplied by the <code>SavingGame</code> event. Values are saved (and loaded) from the savegame with a string name, and the values themselves can be a boolean, a number, a string, or a table containing booleans, numbers or strings.
--- @p @string value name, Value name. This must be unique within the savegame, and will be used by @campaign_manager:load_named_value later to load the value.
--- @p object value, Value to save.
--- @p userdata context, Context object supplied by the <code>SavingGame</code> event.
--- @p [opt=false] @boolean value can be nil, If set to true, the value can be nil.
function campaign_manager:save_named_value(name, value, context, allow_nil)
	allow_nil = allow_nil or false;

	if not is_string(name) then
		script_error("ERROR: save_named_value() called but supplied value name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if value == nil then
		if allow_nil then
			return;
		else
			script_error("ERROR: save_named_value() called but no value supplied. Is this a value that can sometimes be nil? If so, set 'allow_nil' to true when calling save_named_value()");
			return false;
		end;
	end;
	
	if not context then
		script_error("ERROR: save_named_value() called but no context supplied");
		return false;
	end;
	
	out.savegame("Saving value " .. name .. " [" .. tostring(value) .. "]");
	if type(value) == "table" then
		local table_save_state = self:process_table_save(value);
		self:process_string_save(name, table_save_state, context);
	elseif is_string(value) then
		self:process_string_save(name, value, context);
	else
		self.game_interface:save_named_value(name, value, context);
	end
end;


-- Called internally when a table needs to be saved.
-- Returns a string representation of a table.
function campaign_manager:process_table_save(tab)	
	-- The -1 flag disables any max-depth checking, a table with a cyclical reference will cause an infinite loop
	local str = "return " .. table.tostring(tab, true, -1);
	return str;
end;


local string_saving_char_limit = 65535;

function campaign_manager:process_string_save(name, str, context)
	-- We have a character limit of 65535 on our strings. If this string is shorter than this then just go ahead and save it.
	local str_len = str:len();
	if str_len <= string_saving_char_limit then
		return self.game_interface:save_named_value(name, str, context);
	end;

	-- The string we're trying to save is longer than the character limit, so break it up into multiple smaller chunks
	local long_savegame_strings_map = self.long_savegame_strings_map;
	
	local start_ptr = 1;	

	while true do
		local end_ptr = start_ptr + string_saving_char_limit - 1;
		local final_pass = false;

		if end_ptr > str_len then
			-- This is the final section of the input string
			end_ptr = str_len;
			final_pass = true;
		end;
		
		local current_substr = str:sub(start_ptr, end_ptr);

		local long_str_id = #long_savegame_strings_map + 1;
		local long_str_name = "long_string_" .. long_str_id;

		-- Save this chunk
		self.game_interface:save_named_value(long_str_name, current_substr, context);

		-- Add a record of this chunk mapped to the original string name, so that we can reconstitute it later 
		table.insert(
			long_savegame_strings_map, 
			{
				name = name,
				long_str_name = long_str_name
			}
		);
		
		if final_pass then
			break;
		end;

		start_ptr = end_ptr + 1;
	end;
end;


--- @function set_saved_value
--- @desc Sets a value to be saved using the saved value system. Values saved using this function are added to an internal register within the campaign manager, and are automatically saved and loaded with the game, so there is no need to register callbacks with @campaign_manager:add_loading_game_callback or @campaign_manager:add_saving_game_callback. Once saved with this function, the value can be accessed at any time with @campaign_manager:get_saved_value.
--- @desc Values are stored and accessed by a string name. Values can be of type @boolean, @number, @string or @table, where that table itself contains only booleans, numbers, string or other tables. Repeated calls to set_saved_value with the same name are legal, and will just overwrite the value of the value stored with the supplied name.
--- @p string value name, Value name.
--- @p object value, Value. Can be a boolean, number, string or table.
function campaign_manager:set_saved_value(name, value)
	if not is_string(name) then
		script_error("ERROR: set_saved_value() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if string.find(name, ":") then
		script_error("ERROR: set_saved_value() called but supplied name [" .. name .. "] contains a : character, this is illegal");
		return false;
	end;

	if is_table(value) then
		-- validate this value if it's a table (don't do this in the release game as it'll be slow)
		if core:is_debug_config() and not self:validate_saved_table_value(value) then
			local separator_str = self:get_saved_value_separator_str();
			script_error("ERROR: set_saved_value() called with key name [" .. name .. "] and table value [" .. tostring(value) .. "] but this table contains a string containing \"" .. separator_str .. "\" - this is invalid, not saving. Dumping table to console after this error message.");
			-- out(table.tostring(value));
			return false;
		end;
		
	elseif not (is_boolean(value) or is_number(value) or is_string(value)) then
		script_error("ERROR: set_saved_value() called but supplied value [" .. tostring(name) .. "] is not a boolean, number, string or a table");
		return false;
	end;
	
	self.saved_values[name] = value;
end;


-- validates a table for set_saved_value by making sure that it does not contain a string containing a colon
function campaign_manager:validate_saved_table_value(t)
	local separator_str = self:get_saved_value_separator_str();
	for key, value in pairs(t) do
		if is_string(value) and string.find(value, separator_str) then
			return false;
		elseif is_table(value) and not self:validate_saved_table_value(value) then
			return false;
		end;
	end;
	return true;
end;


-- internal function for creating string from all saved values when saving
function campaign_manager:saved_values_to_string()
	local str_table = {};
	local saved_values = self.saved_values;
	local insert = table.insert;

	local separator_str = self:get_saved_value_separator_str();
	local terminator_str = self:get_saved_value_terminator_str();

	local count = 0;
	
	for value_name, value in pairs(saved_values) do

		-- Search for separator string or terminator string in the value_name and attempt to recover if they are found there. 
		if string.find(value_name, separator_str) then
			local half_value_length = math.ceil(string.len(value_name));
			local new_value_name;

			local str_start, str_finish = string.find(value_name, separator_str);
			if str_start < half_value_length then
				new_value_name = string.sub(value_name, 1, str_start - 1);
			else
				new_value_name = string.sub(value_name, str_finish + 1);
			end;

			script_error("WARNING: saved_values_to_string() called but an attempt was made to save a value with name [" .. value_name .. "] that contains a separator string [" .. separator_str .. "]. This is illegal. Will attempt to recover to value name [" .. new_value_name .. "] but this is a serious error and should be reported.");
		end;

		if string.find(value_name, terminator_str) then
			local half_value_length = math.ceil(string.len(value_name));
			local new_value_name;

			local str_start, str_finish = string.find(value_name, terminator_str);
			if str_start < half_value_length then
				new_value_name = string.sub(value_name, 1, str_start - 1);
			else
				new_value_name = string.sub(value_name, str_finish + 1);
			end;
			
			script_error("WARNING: saved_values_to_string() called but an attempt was made to save a value with name [" .. value_name .. "] that contains a terminator string [" .. terminator_str .. "]. This is illegal. Will attempt to recover to value name [" .. new_value_name .. "] but this is a serious error and should be reported.");
		end;

		if is_table(value) then
			local str = self:process_table_save(value);

			insert(str_table, value_name);
			insert(str_table, separator_str);
			insert(str_table, "table");
			insert(str_table, separator_str);
			insert(str_table, string.len(str));
			insert(str_table, separator_str);
			insert(str_table, str);
			insert(str_table, terminator_str);
		else
			insert(str_table, value_name);
			insert(str_table, separator_str);
			insert(str_table, type(value));
			insert(str_table, separator_str);
			insert(str_table, string.len(tostring(value)));
			insert(str_table, separator_str);
			insert(str_table, tostring(value));
			insert(str_table, terminator_str);
		end;

		count = count + 1;
	end;

	-- insert the number of saved values so that we can verify this on load
	insert(str_table, 1, count .. terminator_str);

	return table.concat(str_table);
end;


--- @function save
--- @desc Instructs the campaign game to save at the next opportunity. An optional completion callback may be supplied.
--- @p [opt=nil] function callback, Completion callback. If supplied, this is called when the save procedure is completed.
--- @p [opt=false] boolean lock afterwards, Lock saving functionality after saving is completed.
function campaign_manager:save(callback, lock_afterwards)
	self:disable_saving_game(false);
	self:add_post_saving_game_callback(
		function()
			if lock_afterwards then
				self:disable_saving_game(true);
			end;
			if is_function(callback) then
				callback();
			end;
		end
	);
	self:autosave_at_next_opportunity();
end;










-- Event Error logging
-- This function is called from core if an event has been triggered in campaign and caused a script failure. The campaign manager maintains a log of these errors in the savegame.
function campaign_manager:log_event_error(event_name, error, traceback, establishing_callstack, is_event_condition)
	
	-- make a string of which faction(s) is/are currently processing their turn
	local faction_list_table = {};
	local turn_number;

	if self.model_is_created then
		turn_number = self:turn_number();

		local faction_list = cm:whose_turn_is_it();	
		for _, faction in model_pairs(faction_list) do
			table.insert(faction_list_table, faction:name());
		end;
	else
		turn_number = "<couldn't determine turn number>";
		table.insert(faction_list_table, "<error occurred during load before model created>");
	end;

	table.insert(
		self.event_error_logs, 
		{
			event_name = event_name,
			error = error,
			traceback = traceback,
			establishing_callstack = establishing_callstack,
			is_event_condition = is_event_condition,
			turn_number = turn_number,
			whose_turn_is_it = table.concat(faction_list_table, ", ")
		}
	);
	
	if #self.event_error_logs > EVENT_ERROR_SAVEGAME_LOG_MAX_SIZE then
		if not cm:get_saved_value("event_error_log_size_warning_issued") then
			script_error("WARNING: log_event_error() called but the size of the event error log has exceeded the max size [" .. EVENT_ERROR_SAVEGAME_LOG_MAX_SIZE .. "], some errors will be pruned - the script has failed a lot in this game, please investigate this");
			cm:set_saved_value("event_error_log_size_warning_issued", true);
		end;

		-- remove the oldest log entry
		table.remove(self.event_error_logs, 1);
	end;
end;


function campaign_manager:check_event_errors_on_startup()
	local num_errors = #self.event_error_logs;
	if num_errors > 0 then
		out("");
		out("");
		out("");
		out("******************************************************");
		out("check_event_errors_on_startup() is listing " .. num_errors .. " event error" .. (num_errors == 1 and "" or "s") .. ":");
		out("******************************************************");
		out("");

		for i = 1, num_errors do
			local current_entry = self.event_error_logs[i];
			out("ERROR " .. i .. " of " .. num_errors);
			out("");
			out("Event which provoked error: " .. current_entry.event_name);
			out("Turn number on which error occurred: " .. current_entry.turn_number);
			out("Whose turn it was when error occurred: " .. current_entry.whose_turn_is_it);
			out("Error message: " .. current_entry.error);
			out("Traceback of failed script:");
			out(current_entry.traceback);
			out("Callstack of script which set up the listener:");
			out(current_entry.establishing_callstack);
			if current_entry.is_event_condition then
				out("It was the listener's condition test that generated the error, not the callback that is called once the condition is passed");
			else
				out("The listener's callback generated the error, not the condition test");
			end;

			out("");
		end;

		out("******************************************************");
		out("");

		local error_message = "ERROR: check_event_errors_on_startup() has found script failure records in this savegame - the script has failed in the past, so scripted behaviour may be broken. The errors are printed above this message in the Lua console output.";
		if #self.event_error_logs == EVENT_ERROR_SAVEGAME_LOG_MAX_SIZE then
			error_message = error_message .. "\n*** NOTE: the max number of errors has been recorded, which implies that more errors have happened but they have been culled";
		end;

		script_error(error_message);
	end;
end;





----------------------------------------------------------------------------
--- @section UI Creation
--- @desc The UI is loaded after the game model during the game load sequence, and is the first point in the load sequence at which all script interfaces can be guaranteed to be present. Client scripts can register functions to be called when the UI is loaded with any of the functions listed below. They in turn make use of the equivalent functionality provided by the core object, documented here: @"core:UI Creation and Destruction".
--- @desc Please note that it's <code>strongly</code> preferred to start game scripts from the first tick, using the functions listed in the @"campaign_manager:First Tick" section below. The first tick is synchronised to model updates, where UI events such as <code>UICreated</code> are not, so scripts called from the latter may desync in multiplayer games. Be sure not to make calls to the model from within callbacks registered to UI events that could be called in multiplayer games.
----------------------------------------------------------------------------

local function call_each(callback_list, context)
	for i = 1, #callback_list do
		callback_list[i](context);
	end;
end;


--- @function add_ui_created_callback
--- @desc Registers a function to be called when the UI is created. Callbacks registered with this function will be called regardless of what mode the campaign is being loaded in.
--- @p @function callback
function campaign_manager:add_ui_created_callback(callback)
	if not validate.is_function(callback) then
		return false;
	end;

	if self.is_processing_ui_created_callbacks then
		script_error("WARNING: add_ui_created_callback() called from within a ui-created callback - this is illegal");
		return false;
	end;

	table.insert(self.ui_created_callbacks, callback);
end;


--- @function add_ui_created_callback_sp_new
--- @desc Registers a function to be called when the ui is created in a new singleplayer game.
--- @p @function callback
function campaign_manager:add_ui_created_callback_sp_new(callback)
	if not validate.is_function(callback) then
		return false;
	end;

	if self.is_processing_ui_created_callbacks then
		script_error("WARNING: add_ui_created_callback_sp_new() called from within a ui-created callback - this is illegal");
		return false;
	end;

	table.insert(self.ui_created_callbacks_sp_new, callback);
end;


--- @function add_ui_created_callback_sp_each
--- @desc Registers a function to be called when the ui is created in any singleplayer game.
--- @p @function callback
function campaign_manager:add_ui_created_callback_sp_each(callback)
	if not validate.is_function(callback) then
		return false;
	end;

	if self.is_processing_ui_created_callbacks then
		script_error("WARNING: add_ui_created_callback_sp_each() called from within a ui-created callback - this is illegal");
		return false;
	end;
	
	table.insert(self.ui_created_callbacks_sp_each, callback);
end;


--- @function add_ui_created_callback_mp_new
--- @desc Registers a function to be called when the ui is created in a new multiplayer game. Be sure not to make any calls to the model from within this callback.
--- @p @function callback
function campaign_manager:add_ui_created_callback_mp_new(callback)
	if not validate.is_function(callback) then
		return false;
	end;

	if self.is_processing_ui_created_callbacks then
		script_error("WARNING: add_ui_created_callback_mp_new() called from within a ui-created callback - this is illegal");
		return false;
	end;

	table.insert(self.ui_created_callbacks_mp_new, callback);
end;


--- @function add_ui_created_callback_mp_each
--- @desc Registers a function to be called when the ui is created in any multiplayer game. Be sure not to make any calls to the model from within this callback.
--- @p @function callback
function campaign_manager:add_ui_created_callback_mp_each(callback)
	if not validate.is_function(callback) then
		return false;
	end;

	if self.is_processing_ui_created_callbacks then
		script_error("WARNING: add_ui_created_callback_mp_each() called from within a ui-created callback - this is illegal");
		return false;
	end;
	
	table.insert(self.ui_created_callbacks_mp_each, callback);
end;


-- internal function, called when ui is created
function campaign_manager:ui_created(context)
	self.is_processing_ui_created_callbacks = true;

	call_each(self.ui_created_callbacks, context);

	if self:is_multiplayer() then
		if self:is_new_game() then
			call_each(self.ui_created_callbacks_mp_new, context);
		end;

		call_each(self.ui_created_callbacks_mp_each, context);
	else
		if self:is_new_game() then
			call_each(self.ui_created_callbacks_sp_new, context);
		end;

		call_each(self.ui_created_callbacks_sp_each);
	end;

	self.is_processing_ui_created_callbacks = false;
end;







----------------------------------------------------------------------------
--- @section First Tick
--- @desc The <code>FirstTickAfterWorldCreated</code> event is triggered by the game model when loading is complete and it starts to run time forward. At this point, the game can be considered "running". The campaign manager offers a suite of functions, listed in this section, which allow registration of callbacks to get called when the first tick occurs in a variety of situations e.g. new versus loaded campaign, singleplayer versus multiplayer etc.
--- @desc Callbacks registered with @campaign_manager:add_pre_first_tick_callback are called before any other first-tick callbacks. Next to be called are callbacks registered for a new game with @campaign_manager:add_first_tick_callback_new, @campaign_manager:add_first_tick_callback_sp_new or @campaign_manager:add_first_tick_callback_mp_new, which are called before each-game callbacks registered with @campaign_manager:add_first_tick_callback_sp_each or @campaign_manager:add_first_tick_callback_mp_each. Last to be called are global first-tick callbacks registered with @campaign_manager:add_first_tick_callback.
--- @desc Note that when the first tick occurs the loading screen is likely to still be on-screen, so it may be prudent to stall scripts that wish to display things on-screen with @core:progress_on_loading_screen_dismissed.
----------------------------------------------------------------------------


--- @function add_pre_first_tick_callback
--- @desc Registers a function to be called before any other first tick callbacks. Callbacks registered with this function will be called regardless of what mode the campaign is being loaded in.
--- @p @function callback
function campaign_manager:add_pre_first_tick_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: add_pre_first_tick_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	table.insert(self.pre_first_tick_callbacks, callback);
end;


--- @function add_first_tick_callback
--- @desc Registers a function to be called when the first tick occurs. Callbacks registered with this function will be called regardless of what mode the campaign is being loaded in.
--- @p @function callback
function campaign_manager:add_first_tick_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: add_first_tick_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	table.insert(self.first_tick_callbacks, callback);
end;


--- @function add_post_first_tick_callback
--- @desc Registers a function to be called when the first tick occurs, but after any other first tick callbacks. Callbacks registered with this function will be called regardless of what mode the campaign is being loaded in.
--- @p @function callback
function campaign_manager:add_post_first_tick_callback(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: add_post_first_tick_callback() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	table.insert(self.post_first_tick_callbacks, callback);
end;


--- @function add_first_tick_callback_sp_new
--- @desc Registers a function to be called when the first tick occurs in a new singleplayer game.
--- @p @function callback
function campaign_manager:add_first_tick_callback_sp_new(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: add_first_tick_callback_sp_new() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	table.insert(self.first_tick_callbacks_sp_new, callback);
end;


--- @function add_first_tick_callback_sp_each
--- @desc Registers a function to be called when the first tick occurs in a singleplayer game, whether new or loaded from a savegame.
--- @p @function callback
function campaign_manager:add_first_tick_callback_sp_each(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: add_first_tick_callback_sp_each() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	table.insert(self.first_tick_callbacks_sp_each, callback);
end;


--- @function add_first_tick_callback_mp_new
--- @desc Registers a function to be called when the first tick occurs in a new multiplayer game.
--- @p @function callback
function campaign_manager:add_first_tick_callback_mp_new(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: add_first_tick_callback_mp_new() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	table.insert(self.first_tick_callbacks_mp_new, callback);
end;


--- @function add_first_tick_callback_mp_each
--- @desc Registers a function to be called when the first tick occurs in a multiplayer game, whether new or loaded from a savegame.
--- @p @function callback
function campaign_manager:add_first_tick_callback_mp_each(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: add_first_tick_callback_mp_each() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	table.insert(self.first_tick_callbacks_mp_each, callback);
end;


--- @function add_first_tick_callback_new
--- @desc Registers a function to be called when the first tick occurs in a new game, whether singleplayer or multiplayer.
--- @p @function callback
function campaign_manager:add_first_tick_callback_new(callback)
	if not is_function(callback) then
		script_error(self.name .. " ERROR: add_first_tick_callback_new() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	table.insert(self.first_tick_callbacks_mp_new, callback);
	table.insert(self.first_tick_callbacks_sp_new, callback);
end;
	

-- called internally when first tick occurs
function campaign_manager:first_tick(context)
	out.cache_tab();
	out("");
	out("********************************************************************************");
	out(self.name .. " event has occurred:: FirstTickAfterWorldCreated");
	out.inc_tab();

	self.is_processing_first_tick_callbacks = true;
	
	-- store a link to the campaign manager on _G, as autotest scripts need it occasionally and they can't access it here
	_G.cm = self;
	
	local model = self.game_interface:model();
	
	local local_faction_name = false;
	local human_factions = {};

	-- build a list of human factions, and work out which faction is local
	do
		local faction_list = model:world():faction_list();
		local subcultures_present_on_first_turn = {}

		for i = 0, faction_list:num_items() - 1 do
			local faction = faction_list:item_at(i);
			local faction_name = faction:name();

			-- Storing initial subcultures on map.
			subcultures_present_on_first_turn[faction:subculture()] = true;

			if faction:is_human() then
				if model:faction_is_local(faction_name) then
					local_faction_name = faction_name;

					-- cached local player culture and subculture keys
					self.local_faction_culture_key = faction:culture();
					self.local_faction_subculture_key = faction:subculture();
				end;
				table.insert(human_factions, faction_name);

				-- create a ScriptEventHumanFactionTurnStart listener for this faction
				self:add_faction_turn_start_listener_by_name(
					"human_faction_turn_start",
					faction_name,
					function(context)
						out("");
						out("********************************************************************************");
						out("* Human faction " .. faction_name .. " is starting turn " .. model:turn_number());
						out("* triggering event ScriptEventHumanFactionTurnStart");
						out("********************************************************************************");
						out.inc_tab();
						core:trigger_event("ScriptEventHumanFactionTurnStart", context:faction());
						out.dec_tab();
					end,
					true
				);

				if self:is_new_game() then
					self:start_pooled_resource_tracker_for_faction(faction_name);
				end;
			end;
		end;

		-- Save subcultures that were present on turn one.
		self:set_saved_value("subcultures_present_on_first_turn", subcultures_present_on_first_turn)

		if not local_faction_name then
			if not common.is_autotest() then
				script_error("ERROR: campaign manager couldn't find a local faction - this should only happen in autoruns");
			else
				out("");
				out("***** No local faction found in this autotest *****");
				out("");
			end;
		end;
	end;
	
	self.local_faction_name = local_faction_name;
	self.human_factions = human_factions;
	self.game_is_running = true;
	
	-- start a listener for all faction turn starts so that client scripts can query whos turn it is
	-- also fire a custom event if it's the player's turn
	if local_faction_name then
		self:add_faction_turn_start_listener_by_name(
			"faction_currently_processing",
			local_faction_name,
			function(context)
				out("");
				out("********************************************************************************");
				out("* Local player faction " .. local_faction_name .. " is starting turn " .. model:turn_number());
				out("* triggering event ScriptEventPlayerFactionTurnStart");
				out("********************************************************************************");
				out.inc_tab();

				-- reset this flag here, as if there's a script failure it can get stuck
				self.processing_battle = false;
				
				core:trigger_event("ScriptEventPlayerFactionTurnStart", context:faction());
			end,
			true
		);

		-- start a listener for the local faction ending a turn which produces output and fires a custom scripted event
		core:add_listener(
			"faction_currently_processing",
			"FactionTurnEnd",
			function(context) return context:faction():name() == local_faction_name end,
			function(context)
				out.dec_tab();
				out("********************************************************************************");
				out("********************************************************************************");
				core:trigger_event("ScriptEventPlayerFactionTurnEnd", context:faction());
			end,
			true
		);
	end;	
	
	self.game_interface:suppress_all_event_feed_event_types(false);
	
	-- mainly for autotesting, but other scripts can listen for it too
	core:trigger_event("ScriptEventGlobalCampaignManagerCreated");

	core:trigger_event("ScriptEventFirstTickAfterWorldCreated");
	
	-- mark in the advice history that the player has started a campaign
	common.set_advice_history_string_seen("player_has_started_campaign");
	
	self:process_first_tick_callbacks(context);

	self.is_processing_first_tick_callbacks = false;
	
	out.dec_tab();
	out("********************************************************************************");
	out("");
	out.restore_tab();
end;


function campaign_manager:process_first_tick_callbacks(context)

	-- process pre first-tick callbacks
	call_each(self.pre_first_tick_callbacks, context);
	
	if self:is_multiplayer() then
		if self:is_new_game() then
			-- process new mp callbacks
			call_each(self.first_tick_callbacks_mp_new, context);
		end;
	
		-- process each mp callbacks
		call_each(self.first_tick_callbacks_mp_each, context);
	else
		if self:is_new_game() then
			-- process new sp callbacks
			call_each(self.first_tick_callbacks_sp_new, context);
		end;
	
		-- process each sp callbacks
		call_each(self.first_tick_callbacks_sp_each, context);
	end;
	
	-- process shared callbacks
	call_each(self.first_tick_callbacks, context);

	-- process post first-tick callbacks
	call_each(self.post_first_tick_callbacks, context);
end;









----------------------------------------------------------------------------
--- @section Faction Intro Cutscenes
----------------------------------------------------------------------------


-- internal function to play the intro cutscene
local function campaign_intro_cutscene_play(faction_key, cindy_scene_key_or_duration, cutscene_advice_keys, cam_gameplay_start, cutscene_config_callback, end_callback, hide_faction_leader_during_cutscene)
	if cm:get_local_faction_name(true) == faction_key then
		cm:fade_scene(1, 1);

		local cutscene_intro;

		local faction_leader_is_hidden = false;

		local cindy_scene_key = nil;
		local duration = nil;
		if is_string(cindy_scene_key_or_duration) then
			cindy_scene_key = cindy_scene_key_or_duration;
		elseif is_number(cindy_scene_key_or_duration) then
			duration = cindy_scene_key_or_duration;
		end;

		local function end_callback_wrapper()
			cm:progress_on_all_clients_ui_triggered(
				faction_key .. "_intro_finished",
				function()
					cm:modify_advice(true);

					if faction_leader_is_hidden then
						out("Intro Cutscene: unhiding faction leader's character model at end of cutscene");
						cm:toggle_character_hidden_from_view(cm:get_faction(faction_key):faction_leader(), false);
					end;

					end_callback();
				end
			);
		end;
		
		if cindy_scene_key then
			cutscene_intro = campaign_cutscene:new_from_cindyscene(
				faction_key .. "_intro",							-- string name for this cutscene
				end_callback_wrapper,													-- end callback
				cindy_scene_key,														-- path to cindyscene
				0,																		-- blend in time (s)
				1																		-- blend out time (s)
			);
		else
			cutscene_intro = campaign_cutscene:new(
				faction_key .. "_intro",							-- string name for this cutscene
				duration,																-- duration (s)
				end_callback_wrapper													-- end callback
			);

			cutscene_intro:action(
				function()
					cm:set_camera_position(cam_gameplay_start.x, cam_gameplay_start.y, cam_gameplay_start.d, cam_gameplay_start.b, cam_gameplay_start.h);
				end,
				0
			);
		end;

		if hide_faction_leader_during_cutscene then
			faction_leader_is_hidden = true;

			-- If hide_faction_leader_during_cutscene is a number > 0, then interpret it as a timestamp and add an action to the cutscene to unhide them at this time
			if is_number(hide_faction_leader_during_cutscene) and hide_faction_leader_during_cutscene > 0 then
				cutscene_intro:action(
					function()
						out("Intro Cutscene: unhiding faction leader's character model");
						cm:toggle_character_hidden_from_view(cm:get_faction(faction_key):faction_leader(), false);
						faction_leader_is_hidden = false;
					end,
					hide_faction_leader_during_cutscene
				);
			end;
		end;

		--cutscene_intro:set_debug();
		cutscene_intro:set_skippable(
			true,
			function() 
				cm:override_ui("disable_advice_audio", true);
				
				-- clear advice history, and then show all the advice for the intro cutscene
				common.clear_advice_session_history();
				if is_table(cutscene_advice_keys) then
					for i = 1, #cutscene_advice_keys do
						cm:show_advice(cutscene_advice_keys[i], true);
					end;
				end;
				
				cm:callback(function() cm:override_ui("disable_advice_audio", false) end, 0.5);
			end
		);

		cutscene_intro:set_skip_camera(cam_gameplay_start.x, cam_gameplay_start.y, cam_gameplay_start.d, cam_gameplay_start.b, cam_gameplay_start.h);
		cutscene_intro:set_disable_settlement_labels(false);
		cutscene_intro:set_dismiss_advice_on_end(false);
		cutscene_intro:set_disable_shroud(true);
		cutscene_intro:set_intro_cutscene(true);
		
		if is_function(cutscene_config_callback) then
			cutscene_config_callback(cutscene_intro);
		end;

		if cm:is_cutscene_playing_allowed() then
			cutscene_intro:start();
		end;
	else
		cm:progress_on_all_clients_ui_triggered(
			faction_key .. "_intro_finished",
			function()
				end_callback();
			end
		);
	end;
end;


local function attempt_campaign_intro_cutscene_play(faction_key, cindy_scene_key_or_duration, cutscene_advice_keys, cam_gameplay_start, cutscene_config_callback, end_callback_outer, hide_faction_leader_during_cutscene, pre_cindyscene_delay_callback, intro_fsm_skipped)

	if not pre_cindyscene_delay_callback then
		campaign_intro_cutscene_play(faction_key, cindy_scene_key_or_duration, cutscene_advice_keys, cam_gameplay_start, cutscene_config_callback, end_callback_outer, hide_faction_leader_during_cutscene);
		return;
	end;

	local function progress_callback()
		-- Wait for cutscene fade, otherwise the spacebar options will flash.
		cm:callback(function() cuim:override("campaign_spacebar_options"):unlock() end, 1)
		campaign_intro_cutscene_play(faction_key, cindy_scene_key_or_duration, cutscene_advice_keys, cam_gameplay_start, cutscene_config_callback, end_callback_outer, hide_faction_leader_during_cutscene);
	end;

	cuim:override("campaign_spacebar_options"):lock();
	CampaignUI.ToggleCinematicBorders(false);

	pre_cindyscene_delay_callback(progress_callback, intro_fsm_skipped);
end;


--- @function setup_campaign_intro_cutscene
--- @desc Sets up defines common behaviour for intro cutscenes that factions scripts can use invoke of defining their own behaviour manually. In singleplayer mode, an intro cutscene will be started when the loading screen is dismised that will play the supplied cindyscene. In multiplayer mode, the camera is positioned at the default camera position. In both cases the script event <code>ScriptEventIntroCutsceneFinished</code> event is triggered when the sequence completes.
--- @p @string faction key, The faction key that this cutscene is triggering for
--- @p @table default camera position, Default camera position. This should be a lua table containing <code>x</code>, <code>y</code>, <code>d</code>, <code>b</code> and <code>h</code> fields.
--- @p [opt=nil] @string cindy key or duration, @string key of the cindy scene to play, from table <code>campaign_cinematic_resources</code>, or (if you're building a new cutscene and editing it using <code>cutscene_config_callback</code>) the @number duration of that cutscene. If left as nil, then a placeholder non-cindy cutscene will be shown with a duration of 3 seconds.
--- @p [opt=nil] @table advice keys, Table of advice keys that may be played within the cutscene.
--- @p [opt=nil] @function end callback, End callback. If a function is supplied here, it will be called when the intro cutscene ends;
--- @p [opt=nil] @function cutscene configurator, Cutscene configurator callback. If a function is supplied here, it will be called after the intro cutscene is declared but before @campaign_cutscene:start is called, and will be passed the @campaign_cutscene as a single argument. The function can therefore make configuration calls to the cutscene before it starts. This is useful if nonstandard behaviour for the cutscene is desired.
--- @p [opt=nil] @string movie, Pre-cindyscene fullscreen movie to play, if one is desired. This should be a key from the <code>videos</code> table.
--- @p [opt=false] @number hide faction leader, Hide the faction leader's character model while the intro cutscene is playing. If the @boolean value <code>true</code> is supplied here, or <code>0</code>, the faction leader's model will be hiddent at the start of the cutscene and unhidden at the end. If a positive number is supplied they will be hidden at the start, and then unhidden that many seconds in to the cutscene (or when the cutscene is skipped, whichever comes first).
--- @p [opt=nil] @function pre-cindyscene callback, Pre-cindyscene progress-blocking callback. If supplied, this callback will be called prior to the cindyscene starting. When called, it will be supplied a progress function as a single argument. The cindyscene will not start until the progress function is called, allowing client scripts to determne when this should happen. The intended usage for this is to show an incident prior to the cindyscene launching, but this mechanism could be put to other uses.
--- @p [opt=false] @boolean is the intro exclusive to the Realm of Chaos victory conditions. If supplied as true, the intro will only play when the Realm of Chaos victory conditions are enabled (an option available in MPC).
function campaign_manager:setup_campaign_intro_cutscene(faction_key, cam_gameplay_start, cindy_scene_key_or_duration, cutscene_advice_keys, end_callback, cutscene_config_callback, pre_cutscene_fsm, hide_faction_leader_during_cutscene, pre_cindyscene_delay_callback, is_realm_of_chaos_exclusive)
	if not self:is_new_game() or (cm:model():campaign_type() == "MP_NORMAL_NO_ROC" and is_realm_of_chaos_exclusive) then
		return;
	end;
	
	if validate.is_table(cam_gameplay_start) then
		local cam_fields = {"x", "y", "d", "b", "h"};
		for i = 1, #cam_fields do
			if not cam_gameplay_start[cam_fields[i]] then
				script_error("ERROR: setup_campaign_intro_cutscene() called but supplied camera position table contains no [" .. cam_fields[i] .. "] element - the table should contain elements [" .. table.concat(cam_fields, ", ") .. "]");
				return false;
			end;
		end;
	else
		return false;
	end;
	
	-- The cindy scene/duration variable can be either a string or a number, depending on intended usage.
	-- Throw an error if it's neither, and if it's a string then retrieve the value for use later.
	local cindy_scene_key = nil;
	if cindy_scene_key_or_duration and not (is_string(cindy_scene_key_or_duration) or is_number) then
		script_error(string.format("ERROR: setup_campaign_intro_cutscene() called but supplued cindy scene path '%s' or duration is not a string or number. This parameter must be the string-key of the cindy scene, or the duration in seconds if you're creating a blank cutscene to be adjusted later.", tostring(cindy_scene_key_or_duration)));
		return false;
	elseif is_string(cindy_scene_key_or_duration) then
		cindy_scene_key = cindy_scene_key_or_duration;
	end

	if cutscene_advice_keys and not validate.is_table_of_strings_allow_empty(cutscene_advice_keys) then
		return false;
	end;

	if end_callback and not validate.is_function(end_callback) then
		return false;
	end;

	if cutscene_config_callback and not validate.is_function(cutscene_config_callback) then
		return false;
	end;

	if pre_cutscene_fsm and not validate.is_string(pre_cutscene_fsm) then
		return false;
	end;

	local function end_callback_outer()
		if end_callback then
			end_callback();
		end;
		core:trigger_event("ScriptEventIntroCutsceneFinished");
	end;

	-- Failsafe: position the camera over the local faction's main army
	do
		local faction = cm:get_faction(faction_key);
		if faction then
			local character = cm:get_highest_ranked_general_for_faction(faction);
			if character then
				local d = 14;
				cm:set_camera_position(character:display_position_x(), character:display_position_y(), d, 0, d * 1.25);
			end;
		end;
	end;

	-- At the start of a new game, wait for the loading screen and then play the intro cutscene
	self:start_intro_cutscene_on_loading_screen_dismissed(
		function() 
			-- If we have been given a fullscreen movie then play that first
			if pre_cutscene_fsm and not cm:is_benchmark_mode() then
				if cm:get_local_faction_name(true) == faction_key then
					cm:fade_scene(0, 0);

					local fsm_skipped = false;

					local mo = movie_overlay:new("intro_movie", pre_cutscene_fsm);

					mo:set_skip_callback(
						function() 
							fsm_skipped = true; 
						end
					);

					mo:set_end_callback(
						function()
							if hide_faction_leader_during_cutscene then
								cm:toggle_character_hidden_from_view(cm:get_faction(faction_key):faction_leader(), true);
							end;
							
							cm:progress_on_all_clients_ui_triggered(
								faction_key .. "_movie_finished",
								function()
									attempt_campaign_intro_cutscene_play(faction_key, cindy_scene_key_or_duration, cutscene_advice_keys, cam_gameplay_start, cutscene_config_callback, end_callback_outer, hide_faction_leader_during_cutscene, pre_cindyscene_delay_callback, fsm_skipped);
								end
							);
						end
					);

					mo:start();
				else
					cm:progress_on_all_clients_ui_triggered(
						faction_key .. "_movie_finished",
						function()
							attempt_campaign_intro_cutscene_play(faction_key, cindy_scene_key_or_duration, cutscene_advice_keys, cam_gameplay_start, cutscene_config_callback, end_callback_outer, hide_faction_leader_during_cutscene, pre_cindyscene_delay_callback, fsm_skipped);
						end
					);
				end;
			else
				-- Hide faction leader character here so that it gets hidden for benchmark + standard intro
				if hide_faction_leader_during_cutscene then
					cm:toggle_character_hidden_from_view(cm:get_faction(faction_key):faction_leader(), true);
				end;

				-- Play a benchmark if we're supposed to
				self:show_benchmark_if_required(
					function()
						-- We're not in a benchmark, proceed with the normal intro
						cm:progress_on_all_clients_ui_triggered(
							faction_key .. "_no_movie",
							function()
								attempt_campaign_intro_cutscene_play(faction_key, cindy_scene_key_or_duration, cutscene_advice_keys, cam_gameplay_start, cutscene_config_callback, end_callback_outer, hide_faction_leader_during_cutscene, pre_cindyscene_delay_callback, false);
							end
						);
					end,
					cindy_scene_key
				);
			end;
		end,
		faction_key
	);
end;







----------------------------------------------------------------------------
--- @section FactionTurnStart Lookup Listeners
--- @desc It's common for campaign scripts to want to execute some code when a faction starts its turn. Client scripts will typically use @core:add_listener to listen for the <code>FactionTurnStart</code> event and then query the event context to determine if it's the correct faction, usually by comparing the faction's name with a known string. This straightforward approach becomes more problematic as more listeners are added, and with a game full of content several dozen listeners can all be responding each time a faction starts its turn, all querying the faction name.
--- @desc To circumvent this problem, client scripts can instead register listeners with @campaign_manager:add_faction_turn_start_listener_by_name. The campaign manager stores these in a lookup table internally, which a lot more computationally efficient than having several dozen client scripts all query the faction name every time a faction starts a turn.
----------------------------------------------------------------------------


--- @function add_faction_turn_start_listener_by_name
--- @desc Adds a listener for the <code>FactionTurnStart</code> event which triggers if a faction with the supplied faction name starts a turn.
--- @p @string listener name, Name by which this listener can be later cancelled using @campaign_manager:remove_faction_turn_start_listener_by_name if necessary. It is valid to have multiple listeners with the same name.
--- @p @string faction name, Faction name to watch for, from the <code>factions</code> database table.
--- @p @function callback, Callback to call if a faction with the specified name starts a turn.
--- @p @boolean persistent, Is this a persistent listener. If this value is <code>false</code> the listener will stop the first time the callback is triggered. If <code>true</code>, the listener will continue until cancelled with @campaign_manager:remove_faction_turn_start_listener_by_name.
function campaign_manager:add_faction_turn_start_listener_by_name(listener_name, faction_name, callback, persistent)
	core:add_lookup_listener_callback("faction_turn_start_listeners_by_name", listener_name, faction_name, callback, persistent);
end;


--- @function remove_faction_turn_start_listener_by_name
--- @desc Removes a listener that was previously added with @campaign_manager:add_faction_turn_start_listener_by_name. Calling this won't affect other faction turn start listeners.
--- @p @string listener name
function campaign_manager:remove_faction_turn_start_listener_by_name(listener_name)
	core:remove_lookup_listener_callback("faction_turn_start_listeners_by_name", listener_name);
end;


--- @function add_faction_turn_start_listener_by_culture
--- @desc Adds a listener for the <code>FactionTurnStart</code> event which triggers if a faction with the supplied culture key starts a turn.
--- @p @string listener name, Name by which this listener can be later cancelled using @campaign_manager:remove_faction_turn_start_listener_by_culture if necessary. It is valid to have multiple listeners with the same name.
--- @p @string culture key, Culture key to watch for, from the <code>cultures</code> database table.
--- @p @function callback, Callback to call if a faction of the specified culture starts a turn.
--- @p @boolean persistent, Is this a persistent listener. If this value is <code>false</code> the listener will stop the first time the callback is triggered. If <code>true</code>, the listener will continue until cancelled with @campaign_manager:remove_faction_turn_start_listener_by_culture.
function campaign_manager:add_faction_turn_start_listener_by_culture(listener_name, culture_name, callback, persistent)
	core:add_lookup_listener_callback("faction_turn_start_listeners_by_culture", listener_name, culture_name, callback, persistent);
end;


--- @function remove_faction_turn_start_listener_by_culture
--- @desc Removes a listener that was previously added with @campaign_manager:add_faction_turn_start_listener_by_culture. Calling this won't affect other faction turn start listeners.
--- @p @string listener name
function campaign_manager:remove_faction_turn_start_listener_by_culture(listener_name)
	core:remove_lookup_listener_callback("faction_turn_start_listeners_by_culture", listener_name);
end;


--- @function add_faction_turn_start_listener_by_subculture
--- @desc Adds a listener for the <code>FactionTurnStart</code> event which triggers if a faction with the supplied subculture key starts a turn.
--- @p @string listener name, Name by which this listener can be later cancelled using @campaign_manager:remove_faction_turn_start_listener_by_subculture if necessary. It is valid to have multiple listeners with the same name.
--- @p @string subculture key, Subculture key to watch for, from the <code>subcultures</code> database table.
--- @p @function callback, Callback to call if a faction of the specified subculture starts a turn.
--- @p @boolean persistent, Is this a persistent listener. If this value is <code>false</code> the listener will stop the first time the callback is triggered. If <code>true</code>, the listener will continue until cancelled with @campaign_manager:remove_faction_turn_start_listener_by_culture.
function campaign_manager:add_faction_turn_start_listener_by_subculture(listener_name, subculture_name, callback, persistent)
	core:add_lookup_listener_callback("faction_turn_start_listeners_by_subculture", listener_name, subculture_name, callback, persistent);
end;


--- @function remove_faction_turn_start_listener_by_subculture
--- @desc Removes a listener that was previously added with @campaign_manager:add_faction_turn_start_listener_by_subculture. Calling this won't affect other faction turn start listeners.
--- @p @string listener name
function campaign_manager:remove_faction_turn_start_listener_by_subculture(listener_name)
	core:remove_lookup_listener_callback("faction_turn_start_listeners_by_subculture", listener_name);
end;










----------------------------------------------------------------------------
--- @section Post-Battle Listeners
--- @desc Because the game model can change dramatically after a battle - in particular regarding character instance stability - these functions provide safer listeners that work around this instability.
----------------------------------------------------------------------------


--- @function add_immortal_character_defeated_listener
--- @desc Add a callback that fires when an immortal character is defeated in battle, as well as conditions relating to the battle that can fire the callback.
--- @desc This is useful as there are some instabilities with waiting for, and responding to, the defeat of an immortal character with the typical 'BattleCompleted' event: an immortal character is liable to die and re-spawn with a new, irreconcilable character instance that may break your listeners.
--- @desc This function listens for the re-spawning of the temporarily dead immortal character, and performs your provided callback after the respawn.
--- @p @string listener name, The name given to the internal 'BattleCompleted' listener. Should be descriptive but needn't be unique.
--- @p @function battle condition, The condition a completed battle must meet to trigger this callback, or <code>true</code> to always pass.
--- @p @function callback, The callback that will be executed if an immortal character is defeated in a battle meeting the battle condition, immediately after the immortal character respawns. Must have two parameters, for the victorious and defeated generals' family member interfaces: the victorious character is always the winning side's main army.
--- @p [opt=false] @boolean fire if faction destroyed, If false, the callback will not fire if an immortal character has been defeated AND their faction has been destroyed.
--- @new_example
--- @desc In this example, when a Norscan army wins an attack, any defeated lords who were immortal get force-killed permanently.
--- @example cm:add_immortal_character_defeated_listener(
--- @example 	"NorscaLordDefeatedConfederateEvent",
--- @example 	function(context)
--- @example 		return cm:pending_battle_cache_subculture_is_attacker("wh_dlc08_sc_nor_norsca")
--- @example			and cm:pending_battle_cache_attacker_victory();
--- @example 	end,
--- @example 	function (victorious_fm, defeated_fm)
--- @example 		local defeated_character_cqi = defeated_fm:character():command_queue_index();
--- @example 		out("Immortal character was briefly killed post-battle but has respawned with a new character instance: "
--- @example			 .. defeated_fm:character_details():get_forename());
--- @example 		out("Killing them permanently.");
--- @example 		cm:set_character_immortality("character_cqi:" .. defeated_character_cqi, false);
--- @example 		cm:kill_character(defeated_character_cqi, false);
--- @example 	end
--- @example );
function campaign_manager:add_immortal_character_defeated_listener(listener_name, battle_condition, callback, fire_if_faction_destroyed)
	core:add_listener(
		listener_name,
		"BattleCompleted",
		battle_condition,
		function(context)
			local victorious_fm_cqi;
			
			if cm:pending_battle_cache_attacker_victory() then
				victorious_fm_cqi = cm:pending_battle_cache_get_attacker_fm_cqi(1);
			elseif cm:pending_battle_cache_defender_victory() then
				victorious_fm_cqi = cm:pending_battle_cache_get_defender_fm_cqi(1);
			elseif cm:model():pending_battle():has_been_fought() then
				script_error("ERROR: 'add_immortal_character_defeated_listener' attempted to get victorious family member cqi in most recent battle, but the battle was neither an attacker nor a defender victory. This is unhandled.");
				return;
			else
				-- This can happen if there's a retreat.
				return;
			end;

			-- We have to get the enemies using family members, instead of character interfaces.
			-- This is because a lot of the enemies may have just died and respawned, in which case their character CQIs will have changed.
			local enemies = cm:pending_battle_cache_get_enemy_fms_of_char_fm(cm:get_family_member_by_cqi(victorious_fm_cqi));
			local enemy_count = #enemies;
			
			if cm:model():pending_battle():night_battle() == true or cm:model():pending_battle():ambush_battle() == true then
				enemy_count = 1;
			end;

			for i = 1, enemy_count do
				local enemy_fm = enemies[i];

				if enemy_fm:character_details():is_immortal() then
					if enemy_fm:character():is_null_interface() then
						-- If the faction is dead (i.e. the leader was the last remnant of the faction, and has just been killed) then they're probably not
						-- about to respawn, so don't set up a listener.
						if not fire_if_faction_destroyed and enemy_fm:character_details():faction():is_dead() then
							return;
						end;

						-- No related character object exists, wait until it's created and then notify client scripts
						local enemy_fm_cqi = enemy_fm:command_queue_index();

						core:add_listener(
							"add_immortal_character_defeated_listener",
							"CharacterCreated",
							function(context)
								return context:character():family_member():command_queue_index() == enemy_fm_cqi;
							end,
							function(context)
								local enemy_fm = cm:get_family_member_by_cqi(enemy_fm_cqi);

								callback(cm:get_family_member_by_cqi(victorious_fm_cqi), enemy_fm);
							end,
							false
						);
					else
						-- A character object exists, notify client scripts immediately
						callback(cm:get_family_member_by_cqi(victorious_fm_cqi), enemy_fm);
					end;
				end;
			end;
		end,
		true
	);
end;











----------------------------------------------------------------------------
--- @section PooledResourceChanged Lookup Listener
--- @desc PooledResourceChanged events trigger very frequently, and scripts that wish to know about pooled resource changes usually only want to know about resource changes for a particular faction. As such, a lookup listener which monitors pooled resource changes by faction is provided here.
----------------------------------------------------------------------------


--- @function add_pooled_resource_changed_listener_by_faction
--- @desc Adds a listener for the <code>PooledResourceChanged</code> event which triggers if a faction with the supplied key experiences a change in a pooled resource value.
--- @p @string listener name, Name by which this listener can be later cancelled using @campaign_manager:remove_pooled_resource_changed_listener_by_faction if necessary. It is valid to have multiple listeners with the same name.
--- @p @string faction name, Faction name to watch for, from the <code>factions</code> database table.
--- @p @function callback, Callback to call if the specified faction experiences a pooled resource change.
--- @p @boolean persistent, Is this a persistent listener. If this value is <code>false</code> the listener will stop the first time the callback is triggered. If <code>true</code>, the listener will continue until cancelled with @campaign_manager:remove_pooled_resource_changed_listener_by_faction.
function campaign_manager:add_pooled_resource_changed_listener_by_faction(listener_name, faction_name, callback, persistent)
	core:add_lookup_listener_callback("pooled_resource_changed_listeners_by_faction_name", listener_name, faction_name, callback, persistent);
end;


--- @function remove_pooled_resource_changed_listener_by_faction
--- @desc Removes a listener that was previously added with @campaign_manager:add_pooled_resource_changed_listener_by_faction.
--- @p @string listener name
function campaign_manager:remove_pooled_resource_changed_listener_by_faction(listener_name)
	core:remove_lookup_listener_callback("pooled_resource_changed_listeners_by_faction_name", listener_name);
end;


--- @function add_pooled_resource_regular_income_listener_by_faction
--- @desc Adds a listener for the <code>PooledResourceRegularIncome</code> event which triggers if a faction with the supplied key receive a regular income.
--- @p @string listener name, Name by which this listener can be later cancelled using @campaign_manager:remove_pooled_resource_regular_income_listener_by_faction if necessary. It is valid to have multiple listeners with the same name.
--- @p @string faction name, Faction name to watch for, from the <code>factions</code> database table.
--- @p @function callback, Callback to call if the specified faction experiences a pooled resource change.
--- @p @boolean persistent, Is this a persistent listener. If this value is <code>false</code> the listener will stop the first time the callback is triggered. If <code>true</code>, the listener will continue until cancelled with @campaign_manager:remove_pooled_resource_regular_income_listener_by_faction.
function campaign_manager:add_pooled_resource_regular_income_listener_by_faction(listener_name, faction_name, callback, persistent)
	core:add_lookup_listener_callback("pooled_resource_regular_income_listeners_by_faction_name", listener_name, faction_name, callback, persistent);
end;


--- @function remove_pooled_resource_regular_income_listener_by_faction
--- @desc Removes a listener that was previously added with @campaign_manager:add_pooled_resource_regular_income_listener_by_faction.
--- @p @string listener name
function campaign_manager:remove_pooled_resource_regular_income_listener_by_faction(listener_name)
	core:remove_lookup_listener_callback("pooled_resource_regular_income_listeners_by_faction_name", listener_name);
end;


----------------------------------------------------------------------------
--- @section Faction Pooled Resource Tracking
--- @desc A pooled resource tracking monitor will attempt to track pooled resource changes for a specified faction and log the total amount of each pooled resource the faction has gained and spent/lost over time. Each pooled resource as a whole, and each factor of each pooled resource are logged. This allows client scripts to query the total amount of a particular pooled resource gained from or spent on a particular factor over the lifetime of the campaign (e.g. how much Meat has been earned from Ogre Camps, or how many Skulls have been sent to the Skull Throne).
--- @desc When a pooled resource change occurs for a tracked faction a <code>ScriptEventTrackedPooledResourceChanged</code> event or <code>ScriptEventTrackedPooledResourceRegularIncome</code> is triggered by the tracking monitor. Listening scripts can query the <code>context</code> object provided by this event for the following:
--- @desc <table class="simple"><tr><td><strong>Function Name</strong></td><td><strong>Description</strong></td></tr>
--- @desc <tr><td><code>faction</code></td><td>The faction for which pooled resource has changed</td></tr>
--- @desc <tr><td><code>has_faction</code></td><td>Does this pooled resource relate to a faction (this will always be true)</td></tr>
--- @desc <tr><td><code>resource</code></td><td>The pooled resource that's changed</td></tr>
--- @desc <tr><td><code>factor</code></td><td>The pooled resource factor of the change</td></tr>
--- @desc <tr><td><code>amount</code></td><td>The value of the change</td></tr>
--- @desc <tr><td><code>resource_gained</code></td><td>The total amount gained of the relevant pooled resource over the lifetime of the campaign</td></tr>
--- @desc <tr><td><code>resource_spent</code></td><td>The total amount spent of the relevant pooled resource over the lifetime of the campaign</td></tr>
--- @desc <tr><td><code>factor_gained</code></td><td>The total amount gained of the relevant pooled resource factor over the lifetime of the campaign</td></tr>
--- @desc <tr><td><code>factor_spent</code></td><td>The total amount spent of the relevant pooled resource factor over the lifetime of the campaign</td></tr></table>
--- @desc As well as listening for change events, client scripts can also directly tracked query pooled resource values by calling @campaign_manager:get_total_pooled_resource_changed_for_faction, @campaign_manager:get_total_pooled_resource_gained_for_faction and @campaign_manager:get_total_pooled_resource_spent_for_faction.
--- @desc The campaign manager currently start a pooled resource tracker for each human-controlled faction automatically.
----------------------------------------------------------------------------


--- @function start_pooled_resource_tracker_for_faction
--- @desc Starts a pooled resource tracking monitor for the supplied faction. 
--- @desc A pooled resource tracking monitor for a faction should only be started once per campaign. Once started, tracking monitors will save themselves in to the savegame and then automatically restart on load.
--- @p @string faction key, Key of the faction to track, from the <code>factions</code> database table.
function campaign_manager:start_pooled_resource_tracker_for_faction(faction_key, on_load)

	if not validate.is_string(faction_key) then
		return false;
	end;

	local pooled_resource_tracker = self.pooled_resource_tracker;
	local faction_record;

	if on_load then
		faction_record = pooled_resource_tracker[faction_key];
		if not faction_record then
			script_error("ERROR: start_pooled_resource_tracker_for_faction() called for faction [" .. faction_key .. "] on load of savegame but we have no record for this faction - how can this be?");
			return false;
		end;
	else
		if pooled_resource_tracker[faction_key] then
			-- we're already tracking resources for this faction
			return;
		end;

		faction_record = {};
		pooled_resource_tracker[faction_key] = faction_record;
	end;

	-- Start listener for this faction
	self:add_pooled_resource_changed_listener_by_faction(
		"pooled_resource_tracker_" .. faction_key,
		faction_key,
		function(context)
			local resource = context:resource();
			local resource_key = resource:key();
			local resource_value = resource:value();
			local factor = context:factor();
			local factor_key = factor:key();
			local amount = context:amount();

			-- If we have no pooled resource record then create one
			local resource_record = faction_record[resource_key];
			if not resource_record then
				resource_record = {};
				faction_record[resource_key] = resource_record;
			end;

			-- If we have no pooled resource factor record then create one
			local factor_record = resource_record[factor_key];
			if not factor_record then
				factor_record = {};
				resource_record[factor_key] = factor_record;
			end;

			if amount > 0 then
				local prev_resource_gained = resource_record.gained or 0;
				resource_record.gained = prev_resource_gained + amount;

				local prev_resource_factor_gained = factor_record.gained or 0;
				factor_record.gained = prev_resource_factor_gained + amount;
			else
				-- amount is negative, so spent value will be positive after subtractions below
				local prev_resource_spent = resource_record.spent or 0;
				resource_record.spent = prev_resource_spent - amount;

				local prev_resource_factor_spent = factor_record.spent or 0;
				factor_record.spent = prev_resource_factor_spent - amount;
			end;

			core:trigger_custom_event(
				"ScriptEventTrackedPooledResourceChanged", 
				{
					faction = context:faction(), 						-- faction
					has_faction = true, 								-- has faction
					resource = resource, 								-- pooled resource
					factor = factor, 									-- pooled resource factor
					amount = amount, 									-- amount changed by
					resource_gained = resource_record.gained or 0,		-- total amount of pooled resource gained to date
					resource_spent = resource_record.spent or 0,		-- total amount of pooled resource spent to date
					factor_gained = factor_record.gained or 0,			-- total amount of pooled resource factor gained to date
					factor_spent = factor_record.spent or 0				-- total amount of pooled resource factor spent to date
				}
			);
		end,
		true
	);

	self:add_pooled_resource_regular_income_listener_by_faction(
		"pooled_resource_regular_income_tracker_" .. faction_key,
		faction_key,
		function(context)
			local resource = context:resource();
			local resource_key = resource:key();
			local resource_value = resource:value();

			-- If we have no pooled resource record then create one
			local resource_record = faction_record[resource_key];
			if not resource_record then
				resource_record = {};
				faction_record[resource_key] = resource_record;
			end;

			core:trigger_custom_event(
				"ScriptEventTrackedPooledResourceRegularIncome",
				{
					faction = context:faction(), 						-- faction
					has_faction = true, 								-- has faction
					resource = resource, 								-- pooled resource
				}
			);
		end,
		true
	);
end;


-- start from load
function campaign_manager:start_pooled_resource_trackers_on_load()
	for faction_key in pairs(self.pooled_resource_tracker) do
		self:start_pooled_resource_tracker_for_faction(faction_key, true);
	end;
end;


--- @function are_pooled_resources_tracked_for_faction
--- @desc Returns whether a pooled resource tracker has been started for the specified faction.
--- @p @string faction key, Key of the faction to query, from the <code>factions</code> database table.
--- @return @boolean has tracker been started
function campaign_manager:are_pooled_resources_tracked_for_faction(faction_key)
	if not validate.is_string(faction_key) then
		return false;
	end;

	return not not self.pooled_resource_tracker[faction_key];
end;


--- @function get_total_pooled_resource_changed_for_faction
--- @desc Gets the total spent and gained of a pooled resource or pooled resource factor for a particular faction. A tracking monitor must be started for the specified faction before this function can be called.
--- @desc If a factor key is specified then the spent and gained values returned relate to the factor for the specified pooled resource. If no factor key is specified, then the total spent and gained for the pooled resource (for all factors) is returned.
--- @p @string faction key, Key of the faction to query, from the <code>factions</code> database table.
--- @p @string pooled resource key, Key of the pooled resource to query, from the <code>pooled_resources</code> database table.
--- @p [opt=nil] @string factor key, Key of the pooled resource factor to query, from the <code>pooled_resource_factors</code> database table.
--- @return @number spent
--- @return @number gained
function campaign_manager:get_total_pooled_resource_changed_for_faction(faction_key, pooled_resource_key, factor_key)
	if not validate.is_string(faction_key) then
		return false;
	end;

	local faction_record = self.pooled_resource_tracker[faction_key];

	if not faction_record then
		script_error("WARNING: get_total_pooled_resource_changed_for_faction() called for faction [" .. faction_key .. "] but we're not tracking this faction's pooled resource changes. Either check the faction key, or ensure that start_pooled_resource_tracker_for_faction() is called for this faction first");
		return 0, 0;
	end;

	if not validate.is_string(pooled_resource_key) then
		return false;
	end;

	local resource_record = faction_record[pooled_resource_key];
	if not resource_record then
		-- This might be a valid pooled resource key but it hasn't changed for this faction so we have no record of it
		return 0, 0;
	end;

	if factor_key then
		-- We're interested in the changes of a particular factor for the pooled resource
		if not validate.is_string(factor_key) then
			return false;
		end;

		local factor_record = resource_record[factor_key];
		if not factor_record then
			-- We have no record of this factor for this pooled resource, it might never have changed (or it might be invalid)
			return 0, 0;
		end;

		return factor_record.spent or 0, factor_record.gained or 0;
	else
		-- We're interested in the changes for the pooled resource (all factors)
		return resource_record.spent or 0, resource_record.gained or 0;
	end;
end;


--- @function get_total_pooled_resource_gained_for_faction
--- @desc Gets the total amount of a pooled resource or pooled resource factor gained by a particular faction. A tracking monitor must be started for the specified faction before this function can be called.
--- @desc If a factor key is specified then the gained value returned relates to the factor for the specified pooled resource. If no factor key is specified, then the total gained for the pooled resource (for all factors) is returned.
--- @p @string faction key, Key of the faction to query, from the <code>factions</code> database table.
--- @p @string pooled resource key, Key of the pooled resource to query, from the <code>pooled_resources</code> database table.
--- @p [opt=nil] @string factor key, Key of the pooled resource factor to query, from the <code>pooled_resource_factors</code> database table.
--- @return @number gained
function campaign_manager:get_total_pooled_resource_gained_for_faction(faction_key, pooled_resource_key, factor_key)
	local spent, gained = self:get_total_pooled_resource_changed_for_faction(faction_key, pooled_resource_key, factor_key);
	return gained;
end;


--- @function get_total_pooled_resource_spent_for_faction
--- @desc Gets the total amount of a pooled resource or pooled resource factor spent/lost by a particular faction. A tracking monitor must be started for the specified faction before this function can be called.
--- @desc If a factor key is specified then the spent value returned relates to the factor for the specified pooled resource. If no factor key is specified, then the total spent/lost for the pooled resource (for all factors) is returned.
--- @p @string faction key, Key of the faction to query, from the <code>factions</code> database table.
--- @p @string pooled resource key, Key of the pooled resource to query, from the <code>pooled_resources</code> database table.
--- @p [opt=nil] @string factor key, Key of the pooled resource factor to query, from the <code>pooled_resource_factors</code> database table.
--- @return @number spent
function campaign_manager:get_total_pooled_resource_spent_for_faction(faction_key, pooled_resource_key, factor_key)
	local spent, gained = self:get_total_pooled_resource_changed_for_faction(faction_key, pooled_resource_key, factor_key);
	return spent;
end;












----------------------------------------------------------------------------
--- @section Output
----------------------------------------------------------------------------


--- @function output_campaign_obj
--- @desc Prints information about certain campaign objects (characters, regions, factions or military force) to the debug console spool. Preferably don't call this - just call <code>out(object)</code> insead.
--- @p object campaign object
function campaign_manager:output_campaign_obj(input, verbosity)
	-- possible values of verbosity: 0 = full version, 1 = abridged, 2 = one line summary
	verbosity = verbosity or 0;
	
	if verbosity == 2 then
		out(self:campaign_obj_to_string(input));
		return;
	end;
		
	-- CHARACTER
	if is_character(input) then
		if verbosity == 0 then
			out("");
			out("CHARACTER:");
			out("==============================================================");
		end;
		out.inc_tab();
		out("cqi:\t\t\t" .. tostring(input:cqi()));
		out("faction:\t\t\t" .. input:faction():name());
		local forename = input:get_forename();
		out("forename:\t\t" .. forename .. (forename == "" and "" or "[" .. common.get_localised_string(forename) .. "]"));
		local surname = input:get_surname();
		out("surname:\t\t" .. surname .. (surname == "" and "" or "[" .. common.get_localised_string(surname) .. "]"));
		out("type:\t\t\t" .. input:character_type_key());
		out("subtype:\t\t\t" .. input:character_subtype_key());
		if input:has_region() then
			if verbosity == 0 then
				out("region:");
				out.inc_tab();
				self:output_campaign_obj(input:region(), 1);
				out.dec_tab();
			else
				out("region:\t" .. self:campaign_obj_to_string(input:region()));
			end;
		else
			out("region:\t<no region>");
		end;
		out("logical position:\t[" .. tostring(input:logical_position_x()) .. ", " .. tostring(input:logical_position_y()) .."]");
		out("display position:\t[" .. tostring(input:display_position_x()) .. ", " .. tostring(input:display_position_y()) .."]");
		
		if input:has_military_force() then
			if verbosity == 0 then
				out("military force:");
				out.inc_tab();
				self:output_campaign_obj(input:military_force(), 1);
				out.dec_tab();
			else
				out("military force:\t<commanding> " .. self:campaign_obj_to_string(input:military_force()));
			end;
		else
			out("military force:\t<not commanding>");
		end;
		
		out("has residence:\t" .. tostring(input:has_garrison_residence()));
		
		if not verbosity == 0 then
			out("is male:\t" .. tostring(input:is_male()));
			out("age:\t" .. tostring(input:age()));
			out("loyalty:\t" .. tostring(input:loyalty()));
			out("gravitas:\t" .. tostring(input:gravitas()));
			out("is embedded:\t" .. tostring(input:is_embedded_in_military_force()));
		end;
		
		out.dec_tab();
		
		if verbosity == 0 then
			out("==============================================================");
			out("");
		end;
	
	
	-- REGION
	elseif is_region(input) then	
		if verbosity == 0 then
			out("");
			out("REGION:");
			out("==============================================================");
		end;
		out.inc_tab();
		out("name:\t\t\t" .. input:name());
		
		
		if verbosity == 0 then
			out("owning faction:");
			out.inc_tab();
			self:output_campaign_obj(input:owning_faction(), 1);
			out.dec_tab();
		else
			out("owning faction:\t" .. self:campaign_obj_to_string(input:owning_faction()));
		end;
		
		if input:garrison_residence():has_army() then
			if verbosity == 0 then
				out("garrisoned army:");
				out.inc_tab();
				self:output_campaign_obj(input:garrison_residence():army(), 1);
				out.dec_tab();
			else
				out("garrisoned army: " .. self:campaign_obj_to_string(input:garrison_residence():army()));
			end;
		else
			out("garrisoned army:\t<no army>");
		end;
			
		if input:garrison_residence():has_navy() then
			if verbosity == 0 then
				out("garrisoned navy:");
				out.inc_tab();
				self:output_campaign_obj(input:garrison_residence():navy(), 1);
				out.dec_tab();
			else
				out("garrisoned navy: " .. self:campaign_obj_to_string(input:garrison_residence():navy()));
			end;
		else
			out("garrisoned navy:\t<no navy>");
		end;
		
		out("under siege:\t\t" .. tostring(input:garrison_residence():is_under_siege()));
		
		if verbosity == 0 then
			out("num buildings:\t" .. tostring(input:num_buildings()));
			out("public order:\t\t" .. tostring(input:public_order()));
			out("highest corruption:\t" .. tostring(self.get_highest_corruption_in_region(input)));
		end;
		
		out.dec_tab();
		
		if verbosity == 0 then
			out("==============================================================");
			out("");
		end;
	
	
	-- FACTION
	elseif is_faction(input) then
		if verbosity == 0 then
			out("");
			out("FACTION:");
			out("==============================================================");
		end;
		out.inc_tab();
		out("name:\t\t" .. input:name());
		out("human:\t" .. tostring(input:is_human()));
		out("regions:\t" .. tostring(input:region_list():num_items()));
		
		if verbosity == 0 then
			local region_list = input:region_list();
			out.inc_tab();
			for i = 0, region_list:num_items() - 1 do
				out(i .. ":\t" .. self:campaign_obj_to_string(region_list:item_at(i)));
			end;
			out.dec_tab();
		end;
		
		if input:has_faction_leader() then
			if verbosity == 0 then
				out("faction leader:");
				out.inc_tab();
				self:output_campaign_obj(input:faction_leader(), 1);
				out.dec_tab();
			else
				out("faction leader: " .. self:campaign_obj_to_string(input:faction_leader()));
			end;
		else
			out("faction leader:\t<none>");
		end;
		
		out("characters:\t" .. tostring(input:character_list():num_items()));
		
		if verbosity == 0 then
			local character_list = input:character_list();
			out.inc_tab();
			for i = 0, character_list:num_items() - 1 do
				out(i .. ":\t" .. self:campaign_obj_to_string(character_list:item_at(i)));
			end;
			out.dec_tab();
		end;

		out("mil forces:\t" .. tostring(input:military_force_list():num_items()));
		
		if verbosity == 0 then
			local military_force_list = input:military_force_list();
			out.inc_tab();
			for i = 0, military_force_list:num_items() - 1 do
				out(i .. ":\t" .. self:campaign_obj_to_string(military_force_list:item_at(i)));
			end;
			out.dec_tab();
		end;
		
		if verbosity == 0 then
			out("culture:\t" .. tostring(input:culture()));
			out("subculture:\t" .. tostring(input:subculture()));
			out("treasury:\t" .. tostring(input:treasury()));
			out("tax level:\t" .. tostring(input:tax_level()));
			out("losing money:\t" .. tostring(input:losing_money()));
			out("food short.:\t" .. tostring(input:has_food_shortage()));
			out("imperium:\t" .. tostring(input:imperium_level()));
		end;
		
		out.dec_tab();
		
		if verbosity == 0 then
			out("==============================================================");
			out("");
		end;
	
	
	-- MILITARY FORCE
	elseif is_militaryforce(input) then
		if verbosity == 0 then
			out("");
			out("MILITARY FORCE:");
			out("==============================================================");
		end;
		out.inc_tab();
		if input:has_general() then
			if verbosity == 0 then
				out("general:");
				out.inc_tab();
				self:output_campaign_obj(input:general_character(), 1);
				out.dec_tab();
			else
				out("general:\t" .. self:campaign_obj_to_string(input:general_character()));
			end;
		else
			out("general:\t<none>");
		end;
		
		out("is army:\t" .. tostring(input:is_army()));
		out("is navy:\t" .. tostring(input:is_navy()));
		out("faction:\t\t" .. self:campaign_obj_to_string(input:faction()));
		out("units:\t\t" .. tostring(input:unit_list():num_items()));
		
		if verbosity == 0 then
			local unit_list = input:unit_list();
			out.inc_tab();
			for i = 0, unit_list:num_items() - 1 do
				out(i .. ":\t" .. self:campaign_obj_to_string(unit_list:item_at(i)));
			end;
			out.dec_tab();
		end;
		
		out("characters:\t" .. tostring(input:character_list():num_items()));
		
		if verbosity == 0 then
			local char_list = input:character_list();
			out.inc_tab();
			for i = 1, char_list:num_items() - 1 do
				out(i .. ":\t" .. self:campaign_obj_to_string(char_list:item_at(i)));
			end;
			out.dec_tab();
		end;
		
		out("residence:\t" .. tostring(input:has_garrison_residence()));
		
		if verbosity == 0 then
			out("mercenaries:\t" .. tostring(input:contains_mercenaries()));
			out("upkeep:\t" .. tostring(input:upkeep()));
			out("is_armed_citizenry:\t" .. tostring(input:is_armed_citizenry()));
		end;
		
		out.dec_tab();
		
		if verbosity == 0 then
			out("==============================================================");
			out("");
		end;
	
	else
		script_error("WARNING: output_campaign_obj() did not recognise input " .. tostring(input));
	end;
end;


--- @function campaign_obj_to_string
--- @desc Returns a string summary description when passed certain campaign objects. Supported object types are character, region, faction, military force, and unit.
--- @p object campaign object
--- @r string summary of object
function campaign_manager:campaign_obj_to_string(input)
	if is_character(input) then
		return ("CHARACTER cqi[" .. tostring(input:cqi()) .. "], faction[" .. input:faction():name() .. "], forename[" .. common.get_localised_string(input:get_forename()) .. "], logical pos[" .. input:logical_position_x() .. ", " .. input:logical_position_y() .. "], type/subtype[" .. input:character_type_key() .. "|" .. input:character_subtype_key() .. "]");
	
	elseif is_region(input) then
		return ("REGION name[" .. input:name() .. "], owning faction[" .. input:owning_faction():name() .. "]");
		
	elseif is_faction(input) then
		return ("FACTION name[" .. input:name() .. "], num regions[" .. tostring(input:region_list():num_items()) .. "]");
	
	elseif is_militaryforce(input) then
		local gen_details = "" 
				
		if input:has_general() then
			local char = input:general_character();
			gen_details = "general cqi[" .. tostring(char:cqi()) .. "], logical pos [" .. char:logical_position_x() .. ", " .. char:logical_position_y() .. "]";
		else
			gen_details = "general: [none], logical pos[unknown]";
		end;
			
		return ("MILITARY_FORCE faction[" .. input:faction():name() .. "] units[" .. tostring(input:unit_list():num_items()) .. "], " .. gen_details .. "], upkeep[" .. tostring(input:upkeep()) .. "]");
	
	elseif is_unit(input) then
		return ("UNIT key[" .. input:unit_key() .. "], strength[" .. tostring(input:percentage_proportion_of_full_strength()) .. "]");
	
	else
		return "<campaign object [" .. tostring(input) .. "] not recognised>";
	end;
end;











----------------------------------------------------------------------------
--- @section Timer Callbacks
--- @desc Timer functionality - the ability for scripts to say that a function should be called after a certain interval (e.g. a second) - is provided by the @timer_manager object. The functions in this section provide a pass-through interface to the equivalent functions on the timer manager.
--- @desc During the end-turn sequence the update rate of the campaign model can accelerate wildly. This will cause a function registered to be called after five seconds to happen near-instantly during the end turn sequence, for example. To ameliorate this effect, the timer manager will automatically check the real world time once the interval has completed. If the real world time is less than would be expected then the callback is retried repeatedly until the real world interval has elapsed.
----------------------------------------------------------------------------


--- @function callback
--- @desc Calls the supplied function after the supplied interval in seconds using a timer synchronised to the campaign model. A string name for the callback may optionally be provided to allow the callback to be cancelled later.
--- @desc This function call is passed through to @timer_manager:callback - this @campaign_manager alias is provided purely for convenience.
--- @p @function callback to call, Callback to call.
--- @p @number interval, Interval in seconds after to which to call the callback.
--- @p [opt=nil] @string name, Callback name. If supplied, this callback can be cancelled at a later time (before it triggers) with @campaign_manager:remove_callback.
function campaign_manager:callback(callback, interval, name)
	self.tm:callback(callback, interval, name);
end;


--- @function repeat_callback
--- @desc Calls the supplied function repeatedly after the supplied period in seconds using a timer synchronised to the campaign model. A string name for the callback may optionally be provided to allow the callback to be cancelled. Cancelling the callback is the only method to stop a repeat callback, once started.
--- @desc This function call is passed through to @timer_manager:callback - this @campaign_manager alias is provided purely for convenience.
--- @p @function callback to call, Callback to call.
--- @p @number time, Time in seconds after to which to call the callback, repeatedly. The callback will be called each time this interval elapses.
--- @p [opt=nil] @string name, Callback name. If supplied, this callback can be cancelled at a later time with @campaign_manager:remove_callback.
function campaign_manager:repeat_callback(callback, interval, name)
	self.tm:repeat_callback(callback, interval, name);
end;


--- @function remove_callback
--- @desc Removes a callback previously added with @campaign_manager:callback or @campaign_manager:repeat_callback by name. All callbacks with a name matching that supplied will be cancelled and removed.
--- @desc This function call is passed through to @timer_manager:remove_callback - this @campaign_manager alias is provided purely for convenience.
--- @p @string name, Name of callback to remove.
function campaign_manager:remove_callback(name)
	self.tm:remove_callback(name);
end;


--- @function real_callback
--- @desc Adds a real callback to be called after the supplied interval has elapsed. Real timers are synchronised to UI updates, not to the game model - see @"timer_manager:Real Timers" for more information.
--- @desc This function call is passed through to @timer_manager:real_callback - this @campaign_manager alias is provided purely for convenience.
--- @p @function callback, Callback to call.
--- @p @number interval, Interval after which to call the callback. This should be in milliseconds, regardless of game mode.
--- @p [opt=nil] @string name, Callback name, by which it may be later removed with @campaign_manager:remove_real_callback. If omitted the callback may not be cancelled.
function campaign_manager:real_callback(callback, interval, name)
	self.tm:real_callback(callback, interval, name);
end;


--- @function repeat_real_callback
--- @desc Adds a repeating real callback to be called each time the supplied interval elapses. Real timers are synchronised to UI updates, not to the game model - see @"timer_manager:Real Timers" for more information.
--- @desc This function call is passed through to @timer_manager:repeat_real_callback - this @campaign_manager alias is provided purely for convenience.
--- @p @function callback, Callback to call.
--- @p @number interval, Repeating interval after which to call the callback. This should be in milliseconds, regardless of game mode.
--- @p [opt=nil] @string name, Callback name, by which it may be later removed with @campaign_manager:remove_real_callback. If omitted the repeating callback may not be cancelled.
function campaign_manager:repeat_real_callback(callback, interval, name)
	self.tm:repeat_real_callback(callback, interval, name);
end;


--- @function remove_real_callback
--- @desc Removes a real callback previously added with @campaign_manager:real_callback or @campaign_manager:repeat_real_callback by name. All callbacks with a name matching that supplied will be cancelled and removed.
--- @desc This function call is passed through to @timer_manager:remove_real_callback - this @campaign_manager alias is provided purely for convenience.
--- @p @string name, Name of callback to remove.
function campaign_manager:remove_real_callback(name)
	self.tm:remove_real_callback(name);
end;









----------------------------------------------------------------------------
--- @section Local Player Faction
--- @desc The functions in this section report information about the local player faction. Beware of using them in in multiplayer, for making changes to the model based on the identity of the local faction is likely to cause a desync because changes will happen on one machine and not the other. Each function listed here, if called in multiplayer, will throw a script error and fail, unless <code>true</code> is passed in as an argument to force the result. In doing so, the calling script acknowledges the risks described here.
--- @desc Each function here can only be called on or after the first model tick.
----------------------------------------------------------------------------


--- @function get_local_faction_name
--- @desc Returns the local player faction name.
--- @p [opt=false] boolean force result, Force the result to be returned instead of erroring in multiplayer.
--- @r string local faction name
function campaign_manager:get_local_faction_name(force)
	if not self.game_is_running then
		script_error(self.name .. " ERROR: get_local_faction_name() called before game has been created");
		return false;
	end;
	
	if self:is_multiplayer() and not force then
		script_error(self.name .. " ERROR: get_local_faction_name() called but this is a multiplayer game, reconsider or force this usage. Please bug this.");
		return false;
	end;
	
	return self.local_faction_name;
end;


--- @function has_local_faction
--- @desc Returns whether a local faction exists. This should only return <code>false</code> in an autotest without a local faction.
--- @return @boolean local faction exists
function campaign_manager:has_local_faction()
	return not not self.local_faction_name;
end;


--- @function get_local_faction
--- @desc Returns the local player faction object.
--- @p [opt=false] boolean force result, Force the result to be returned instead of erroring in multiplayer.
--- @r @faction faction
function campaign_manager:get_local_faction(force)
	if not self.game_is_running then
		script_error(self.name .. " ERROR: get_local_faction() called before game has been created");
		return false;
	end;
	
	if self:is_multiplayer() and not force then
		script_error(self.name .. " ERROR: get_local_faction() called but this is a multiplayer game, reconsider or force this usage. Please bug this.");
		return false;
	end;

	if not self.local_faction_name then
		script_error(self.name .. " WARNING: get_local_faction() called but no local faction has been set - this should only happen in autoruns. False will be returned");
		return false;
	end;
	
	return self:get_faction(self.local_faction_name);
end;


--- @function get_local_faction_culture
--- @desc Returns the cached culture key of the local human player. If no local faction has been set then a blank string is returned - this should only happen in autoruns.
--- @p [opt=false] boolean force result, Force the result to be returned instead of erroring in multiplayer.
--- @r @string local faction culture
function campaign_manager:get_local_faction_culture(force)
	if not self.game_is_running then
		script_error(self.name .. " ERROR: get_local_faction_culture() called before game has been created");
		return false;
	end;
	
	if self:is_multiplayer() and not force then
		script_error(self.name .. " ERROR: get_local_faction_culture() called but this is a multiplayer game, reconsider or force this usage. Please bug this.");
		return false;
	end;

	return self.local_faction_culture_key;
end;

--- @function get_local_faction_subculture
--- @desc Returns the cached subculture key of the local human player. If no local faction has been set then a blank string is returned - this should only happen in autoruns.
--- @p [opt=false] boolean force result, Force the result to be returned instead of erroring in multiplayer.
--- @r @string local faction subculture
function campaign_manager:get_local_faction_subculture(force)
	if not self.game_is_running then
		script_error(self.name .. " ERROR: get_local_faction_subculture() called before game has been created");
		return false;
	end;
	
	if self:is_multiplayer() and not force then
		script_error(self.name .. " ERROR: get_local_faction_subculture() called but this is a multiplayer game, reconsider or force this usage. Please bug this.");
		return false;
	end;

	return self.local_faction_subculture_key;
end;


--- @function is_local_players_turn
--- @desc Returns whether it's currently the local player's turn.
--- @p [opt=false] boolean force result, Force the result to be returned instead of erroring in multiplayer.
--- @r @boolean is local player's turn
function campaign_manager:is_local_players_turn(force)
	local local_faction_name = self:get_local_faction_name(force);				-- local_faction_name will be false in autorun
	if local_faction_name then
		return self:is_factions_turn_by_key(local_faction_name);
	end;
	return false;
end;









----------------------------------------------------------------------------
--- @section General Querying
----------------------------------------------------------------------------


--- @function is_faction_human
--- @desc Returns whether the specified faction is human.
--- @p @string faction key, Faction key, from the <code>factions</code> database table.
--- @r @table human factions
function campaign_manager:is_faction_human(faction_key)
	local faction = self:get_faction(faction_key, true);

	if faction then
		return faction:is_human();
	end;

	return false;	
end;


--- @function get_human_factions
--- @desc Returns a numerically-indexed table containing the string keys of all human player-controlled factions within the game. This includes idle human factions, which are factions that started as player-controlled but where the human player has dropped and not yet resumed.
--- @return @table human faction keys
function campaign_manager:get_human_factions()
	if not self.game_is_running then
		script_error(self.name .. " ERROR: get_human_factions() called before game has been created");
		return false;
	end;
	
	-- Return a copy so that our version cannot be modified by calling scripts
	return table.copy(self.human_factions);
end;


--- @function get_human_factions_of_culture
--- @desc Returns a numerically-indexed table containing the string keys of all human player-controlled factions in the game that match the provided culture, including idle human factions.
--- @p @string culture, Key of the culture of human players to get.
--- @return @table human factions matching specified culture.
function campaign_manager:get_human_factions_of_culture(culture)
	return self:get_human_factions_of_parameters(culture);
end;


--- @function get_human_factions_of_subculture
--- @desc Returns a numerically-indexed table containing the string keys of all human player-controlled factions in the game that match the provided subculture, including idle human factions.
--- @p @string subculture, Key of the subculture of human players to get.
--- @return @table human factions matching specified subculture.
function campaign_manager:get_human_factions_of_subculture(subculture)
	return self:get_human_factions_of_parameters(nil, subculture);
end;


-- Returns a numerically-indexed table containing the string keys of all human player-controlled factions in the game that match the provided parameters.
-- This includes idle human factions.
function campaign_manager:get_human_factions_of_parameters(culture, subculture)
	if culture ~= nil and not validate.is_string(culture) then
		return false;
	end;

	if subculture ~= nil and not validate.is_string(subculture) then
		return false;
	end;

	if culture ~= nil and subculture ~= nil then
		script_error(string.format("%s ERROR: get_human_factions_of_parameters() called with both culture '%s' and subculture '%s' specified. You must use one or the other.",
			self.name, culture, subculture));
	end;

	local human_faction_keys = self:get_human_factions();
	local filtered_faction_keys = {};
	for h = 1, #human_faction_keys do
		local human_faction = self:get_faction(human_faction_keys[h]);
		
		if culture ~= nil and human_faction:culture() == culture then
			table.insert(filtered_faction_keys, human_faction_keys[h]);
		elseif subculture ~= nil and human_faction:subculture() == subculture then
			table.insert(filtered_faction_keys, human_faction_keys[h]);
		end;
	end;

	return filtered_faction_keys;
end;


--- @function get_active_human_factions
--- @desc Returns a numerically-indexed table containing the string keys of all active human player-controlled factions in the game. This does not include idle human factions - see @campaign_manager:get_human_factions.
--- @return @table active human factions
function campaign_manager:get_active_human_factions()
	if not self.game_is_running then
		script_error(self.name .. " ERROR: get_active_human_factions() called before game has been created");
		return false;
	end;

	-- TODO: make this mechanism more efficient by having the campaign manager track player-controlled factions becoming active/idle
	local active_human_factions = {};

	local human_factions = self.human_factions;
	for i = 1, #human_factions do
		local faction = self:get_faction(human_factions[i]);
		if faction and not faction:is_idle_human() then
			table.insert(active_human_factions, human_factions[i]);
		end;
	end;

	return active_human_factions;
end;


--- @function get_factions_by_filter
--- @desc Returns an indexed table of @faction objects the pass the supplied filter condition function.
--- @p @function filter, Filter function. This should be a function that accepts a single @faction argument and returns a @boolean value. If the value equates to <code>true</code> then the faction is added to the table of factions to return.
--- @r @table factions that pass the filter
function campaign_manager:get_factions_by_filter(condition)
	if not validate.is_function(condition) then
		return false;
	end;

	local retval = {};

	local faction_list = self:model():world():faction_list();
	for _, faction in model_pairs(faction_list) do
		if condition(faction) then
			table.insert(retval, faction);
		end;
	end;

	return retval;
end;


--- @function get_factions_by_culture
--- @desc Returns an indexed table of @faction objects that belong to the supplied culture.
--- @p @string culture key, Culture key, from the <code>cultures</code> database table.
--- @r @table factions belonging to culture
function campaign_manager:get_factions_by_culture(culture_key)
	if not validate.is_string(culture_key) then
		return false;
	end;

	local function condition(faction)
		return faction:culture() == culture_key;
	end;

	return self:get_factions_by_filter(condition);
end;


--- @function get_factions_by_subculture
--- @desc Returns an indexed table of @faction objects that belong to the supplied subculture.
--- @p @string subculture key, Subulture key, from the <code>cultures_subcultures</code> database table.
--- @r @table factions belonging to subculture
function campaign_manager:get_factions_by_subculture(subculture_key)
	if not validate.is_string(subculture_key) then
		return false;
	end;

	local function condition(faction)
		return faction:subculture() == subculture_key;
	end;

	return self:get_factions_by_filter(condition);
end;


--- @function are_any_factions_human
--- @desc Returns true if any factions in the supplied list are human. If no list is provided, all factions in the game are checked.
--- @desc Culture and/or subculture keys may optionally be provided, in which case if any faction of that culture/subculture is human, <code>true</code> is returned.
--- @p [opt=nil] @table faction list, Numerically-indexed one-based table of @string faction keys or faction script objects.
--- @p [opt=nil] @string culture, The key of the culture we want to check.
--- @p [opt=nil] @string subculture, The key of the subculture we want to check.
--- @r @boolean Whether a human faction of the specified criteria and/or in the provided list was found.
function campaign_manager:are_any_factions_human(faction_list, culture, subculture)
	return self:are_any_factions_human_or_ai(faction_list, culture, subculture, true);
end;


--- @function are_any_factions_ai
--- @desc Returns true if any factions in the supplied list are ai. If no list is provided, all factions in the game are checked.
--- @desc Culture and/or subculture keys may optionally be provided, in which case if any faction of that culture/subculture is ao, <code>true</code> is returned.
--- @p [opt=nil] @table faction list, Numerically-indexed one-based table of @string faction keys or faction script objects.
--- @p [opt=nil] @string culture, The key of the culture we want to check.
--- @p [opt=nil] @string subculture, The key of the subculture we want to check.
--- @r @boolean Whether an ai faction of the specified criteria and/or in the provided list was found.
function campaign_manager:are_any_factions_ai(faction_list, culture, subculture)
	return self:are_any_factions_human_or_ai(faction_list, culture, subculture, false);
end;


--- @function are_all_factions_human
--- @desc Returns true if all factions in the supplied list are human. If no list is provided, all factions in the game are checked.
--- @desc Culture and/or subculture keys may optionally be provided, in which case if all factions of that culture/subculture are human, <code>true</code> is returned.
--- @p [opt=nil] @table faction list, Numerically-indexed one-based table of @string faction keys or faction script objects.
--- @p [opt=nil] @string culture, The key of the culture we want to check.
--- @p [opt=nil] @string subculture, The key of the subculture we want to check.
--- @r @boolean Whether all factions in the specified criteria are human.
function campaign_manager:are_all_factions_human(faction_list, culture, subculture)
	return not self:are_any_factions_human_or_ai(faction_list, culture, subculture, false);
end;


--- @function are_all_factions_ai
--- @desc Returns true if all factions in the supplied list are ai. If no list is provided, all factions in the game are checked.
--- @desc Culture and/or subculture keys may optionally be provided, in which case if all factions of that culture/subculture are ai, <code>true</code> is returned.
--- @p [opt=nil] @table faction list, Numerically-indexed one-based table of @string faction keys or faction script objects.
--- @p [opt=nil] @string culture, The key of the culture we want to check.
--- @p [opt=nil] @string subculture, The key of the subculture we want to check.
--- @r @boolean Whether all factions in the specified criteria are ai.
function campaign_manager:are_all_factions_ai(faction_list, culture, subculture)
	return not self:are_any_factions_human_or_ai(faction_list, culture, subculture, true);
end;


function campaign_manager:are_any_factions_human_or_ai(faction_list, culture, subculture, is_human)
	if faction_list ~= nil and not is_table(faction_list)  then
		script_error("ERROR: are_any_factions_human() called but supplied faction list [" .. tostring(faction_list) .. "] is not a table or nil (in which case all factions from the game model would be checked).");
		return false;
	end;

	if culture ~= nil and not is_string(culture)  then
		script_error("ERROR: are_any_factions_human() called but supplied culture [" .. tostring(culture) .. "] is not a string or nil.");
		return false;
	end;
	-- Convert empty string parameters to nil.
	if culture == "" then
		culture = nil;
	end;

	if subculture ~= nil and not is_string(subculture) then
		script_error("ERROR: are_any_factions_human() called but supplied subculture [" .. tostring(subculture) .. "] is not a string or nil.");
		return false;
	end;
	if subculture == "" then
		subculture = nil;
	end;

	if faction_list == nil then
		faction_list = cm:model():world():faction_list();

		-- It's important that we move elements out of the 'faction_list_interface' (zero-based and no indexer) and into a regular lua table.
		local one_based_list = {};
		for f = 0, faction_list:num_items() - 1 do
			table.insert(one_based_list, faction_list:item_at(f));
		end;
		faction_list = one_based_list;
	end;

	-- If a list of strings was provided, we need to turn them into faction interfaces.
	for f = 1, #faction_list do
		local current_faction_obj = faction_list[f];
		if is_string(current_faction_obj) then
			local faction = self:get_faction(current_faction_obj);
			
			if not faction then
				script_error("WARNING: are_any_factions_human_or_ai() called but item [" .. f .. "] in faction list is a string [" .. current_faction_obj .. "] but no faction with this key could be found");
				current_faction_obj = nil;
			else
				current_faction_obj = faction;
			end;
		end;

		-- A nil object indicates that an error was thrown when searching for a faction string, but we should keep iterating anyway.
		if current_faction_obj ~= nil and current_faction_obj:is_human() == is_human then
			local valid_faction = true;
			if culture ~= nil and current_faction_obj:culture() ~= culture then
				valid_faction = false;
			elseif  subculture ~= nil and current_faction_obj:subculture() ~= subculture then
				valid_faction = false;
			end;

			if valid_faction then
				return true;
			end;
		end;
	end;

	return false;
end;


--- @function whose_turn_is_it_single
--- @desc Returns faction object of the faction whose turn it is currently. This only works in singleplayer mode - in scripts that may be run in multiplayer mode call @campaign_manager:whose_turn_is_it, which returns a particular faction of the many currently taking their turn.
--- @r @faction faction
function campaign_manager:whose_turn_is_it_single()
	if self:is_multiplayer() then
		script_error("ERROR: whose_turn_is_it_single() called in multiplayer mode. This is not supported - call whose_turn_is_it() instead");
		return false;
	end;

	if self.model_is_created then
		return self:model():world():whose_turn_is_it():item_at(0);
	else
		script_error("ERROR: an attempt was made to call whose_turn_is_it_single() before the model was created - this call needs to happen later in the loading sequence");
		return false;
	end;
end;


--- @function whose_turn_is_it
--- @desc Returns a list of all factions whose turn it is currently. This can be used in singleplayer or multiplayer.
--- @r @faction_list faction list
function campaign_manager:whose_turn_is_it()
	if self.model_is_created then
		return self:model():world():whose_turn_is_it();
	else
		script_error("ERROR: an attempt was made to call whose_turn_is_it() before the model was created - this call needs to happen later in the loading sequence");
		return false;
	end;
end;


--- @function is_factions_turn_by_key
--- @desc Returns <code>true</code> if it's the supplied faction turn. The faction is specified by key.
--- @p @string faction key, Faction key, from the <code>factions</code> database table.
--- @r @boolean is faction's turn
function campaign_manager:is_factions_turn_by_key(faction_key)
	if not is_string(faction_key) then
		script_error("ERROR: is_factions_turn_by_key() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string");
		return false;
	end;
	
	return self:model():world():is_factions_turn_by_key(faction_key);
end;


--- @function is_human_factions_turn
--- @desc Returns whether it's currently the turn of any human-controlled faction.
--- @r @boolean is any human faction's turn
function campaign_manager:is_human_factions_turn()
	local faction_list = self:whose_turn_is_it();
	for _, faction in model_pairs(faction_list) do
		if faction:is_human() then
			return true;
		end;
	end;
	return false;
end;


--- @function is_multiplayer
--- @desc Returns true if the campaign is multiplayer.
--- @r boolean is multiplayer campaign
function campaign_manager:is_multiplayer()
	if not self.model_is_created then
		script_error(self.name .. " ERROR: is_multiplayer() called before the model has been created!");
		return false;
	end;
	
	return self.is_multiplayer_campaign;
end;


--- @function is_new_game
--- @desc Returns true if the campaign is new. A campaign is "new" if it has been saved only once before - this save occurs during startpos processing.
--- @desc Note that if the script fails during startpos processing, the counter will not have been saved and it's value will be 0 - in this case, the game may report that it's not new when it is. If you experience a campaign that behaves as if it's loading into a savegame when starting from fresh, it's probably because the script failed during startpos processing.
--- @r boolean is new game
function campaign_manager:is_new_game()
	if not self.game_is_loaded then
		-- If the model has been created but the game not loaded, that strongly suggests we are processing the startpos - return true
		if self.model_is_created then
			return true;
		end;

		script_error(self.name .. " WARNING: is_new_game() called before the game has loaded, this call should happen later in the loading process. Returning false.");
		return false;
	end;
	
	return (self.save_counter == 1);	-- save_counter is 0 before the startpos is reprocessed and saved, 1 after the startpos is reprocessed, > 1 after the player first saves
end;


--- @function is_game_running
--- @desc Returns whether or not the game is loaded and time is ticking.
--- @r boolean is game started
function campaign_manager:is_game_running()
	return self.game_is_running;
end;


--- @function is_first_tick
--- @desc Returns whether or not we're actively processing the first tick callbacks.
--- @r @boolean is first tick
function campaign_manager:is_first_tick()
	return self.is_processing_first_tick_callbacks;
end;


--- @function model
--- @desc Returns a handle to the game model at any time (after the game has been created). See the @model_hierarchy pages for more information about game model interfaces such as @model.
--- @r @model model
function campaign_manager:model()
	if self.model_is_created then
		return self.game_interface:model();
	else
		script_error("ERROR: an attempt was made to call model() before the model was created - this call needs to happen later in the loading sequence");
		return false;
	end;
end;


--- @function get_game_interface
--- @desc Returns a handle to the raw episodic scripting interface. Generally it's not necessary to call this function, as calls made on the campaign manager which the campaign manager doesn't itself provide are passed through to the episodic scripting interface, but a direct handle to the episodic scripting interface may be sought with this function if speed of repeated access.
--- @r @episodic_scripting game interface
function campaign_manager:get_game_interface()
	if not self.game_interface then
		script_error("ERROR: get_game_interface() called but game_interface object has not been created - call this later in the load sequence");
		return false;
	end;
	
	return self.game_interface;
end;


--- @function get_difficulty
--- @desc Returns the current combined campaign difficulty. This is returned as an integer value by default, or a string if a single <code>true</code> argument is passed in.
--- @desc <table class="simple"><tr><td><strong>string</strong></td><td><strong>number</strong></td></tr><tr><td>easy</td><td>1</td></tr><tr><td>normal</td><td>2</td></tr><tr><td>hard</td><td>3</td></tr><tr><td>very hard</td><td>4</td></tr><tr><td>legendary</td><td>5</td></tr></table>
--- @desc Note that the numbers returned above are different from those returned by the <code>combined_difficulty_level()</code> function on the campaign model.
--- @p [opt=false] boolean return as string
--- @r object difficulty integer or string
function campaign_manager:get_difficulty(return_as_string)
	local difficulty = self:model():combined_difficulty_level();
	
	if self:get_local_faction_name(true) then
		if difficulty == 0 then
			difficulty = 2;				-- normal
		elseif difficulty == -1 then
			difficulty = 3;				-- hard
		elseif difficulty == -2 then
			difficulty = 4;				-- very hard
		elseif difficulty == -3 then
			difficulty = 5;				-- legendary
		else
			difficulty = 1;				-- easy
		end;
	else
	-- autorun
		if difficulty == 0 then
			difficulty = 2;				-- normal
		elseif difficulty == 1 then
			difficulty = 3;				-- hard
		elseif difficulty == 2 then
			difficulty = 4;				-- very hard
		elseif difficulty == 3 then
			difficulty = 5;				-- legendary
		else
			difficulty = 1;				-- easy
		end;
	end;
	
	if return_as_string then
		local difficulty_string = "easy";
		
		if difficulty == 2 then
			difficulty_string = "normal";
		elseif difficulty == 3 then
			difficulty_string = "hard";
		elseif difficulty == 4 then
			difficulty_string = "very hard";
		elseif difficulty == 5 then
			difficulty_string = "legendary";
		end;
		
		return difficulty_string;
	end;
	
	return difficulty;
end;


--- @function is_processing_battle
--- @desc Returns true if a battle sequence is currently happening. Scripts can query whether a battle sequence is happening to know whether to proceed with gameplay events that should only happen outside of a battle. In particular, @campaign_manager:progress_on_battle_completed uses this mechanism to know when to trigger its callback.
--- @desc A battle sequence starts when the <code>PendingBattle</code> event is received, and ends when either the <code>BattleCompleted</code> event is received for battles not involving a human participant, or two seconds after the <code>BattleCompletedCameraMove</code> event is received if the battle did involve a human participant. It is safe to use in multiplayer, and also works for battles that aren't fought (withdrawal, maintain siege etc).
--- @r @boolean battle is happening
function campaign_manager:is_processing_battle()
	return self.processing_battle;
end;


--- @function is_pending_battle_active
--- @desc Returns whether a pending battle is active (i.e. we are immediately pre-battle or post-battle). If the pending battle is active the function will also return whether the battle has been fought (note however that on the first tick when returning from battle this will still be false).
--- @r @boolean is a pending battle active
--- @r @boolean active pending battle has been fought already
function campaign_manager:is_pending_battle_active()
	local pb = self:model():pending_battle();

	if pb:is_active() then
		return true, pb:has_been_fought();
	end;

	return false, false;
end;


--- @function turn_number
--- @desc Returns the turn number, including any modifier set with @campaign_manager:set_turn_number_modifier
--- @r number turn number
function campaign_manager:turn_number()
	return self.game_interface:model():turn_number() + self.turn_number_modifier;
end;


--- @function set_turn_number_modifier
--- @desc Sets a turn number modifier. This offsets the result returned by @campaign_manager:turn_number by the supplied modifier. This is useful for campaign setups which include optional additional turns (e.g. one or two turns at the start of a campaign to teach players how to play the game), but still wish to trigger events on certain absolute turns. For example, some script may wish to trigger an event on turn five of a standard campaign, but this would be turn six if a one-turn optional tutorial at the start of the campaign was played through - in this case a turn number modifier of 1 could be set if not playing through the tutorial.
--- @p number modifier
function campaign_manager:set_turn_number_modifier(modifier)
	if not is_number(modifier) or math.floor(modifier) ~= modifier then
		script_error("ERROR: set_turn_number_modifier() called but supplied modifier [" .. tostring(modifier) .. "] is not an integer");
		return false;
	end;
	
	self.turn_number_modifier = modifier;
end;


--- @function null_interface
--- @desc Returns a scripted-generated object that emulates a campaign null interface.
--- @r null_interface
function campaign_manager:null_interface()
	local null_interface = {};
	
	null_interface.is_null_interface = function() return true end;
	
	return null_interface;
end;


--- @function help_page_seen
--- @desc Returns whether the advice history indicates that a specific help page has been viewed by the player.
--- @p string help page name
--- @r boolean help page viewed 
function campaign_manager:help_page_seen(page_name)
	return common.get_advice_history_string_seen(page_name) or common.get_advice_history_string_seen("script_link_campaign_" .. page_name);
end;


--- @function tol_campaign_key
--- @desc Returns the Time of Legends campaign key. If the current campaign is not a Time of Legends campaign, then @nil is returned.
--- @r @string time of legends campaign key or @nil
function campaign_manager:tol_campaign_key()
	return self.cached_tol_key;
end;


--- @function is_subculture_in_campaign
--- @desc Returns whether the subculture is present in the campaign. By default, this will check the cached data of subcultures present on turn one of the campaign.
--- @p @string subculture key, Subculture key, from the <code>cultures_subcultures</code> database table.
--- @p [opt=false] @boolean factions present now, Set to <code>true</code> to actively check the factions on the map right now, instead of looking in the cached data. This check is more expensive.
--- @r boolean subculture is present
function campaign_manager:is_subculture_in_campaign(subculture, factions_present_now)

	if not is_string(subculture) then
		script_error("ERROR: building_exists_in_province() called but supplied subculture key [" .. tostring(subculture) .. "] is not a string");
		return false
	end;

	if factions_present_now and not is_boolean(factions_present_now) then
		script_error("ERROR: is_subculture_in_campaign() called but supplied faction present value [" .. tostring(factions_present_now) .. "] is not a boolean value");
		return false
	end;

	if factions_present_now then
		local faction_list = cm:model():world():faction_list()
		
		for i = 0, faction_list:num_items() - 1 do
			if faction_list:item_at(i):subculture() == subculture then
				return true
			end
		end
		
	else
		local subcultures_present_on_first_turn = cm:get_saved_value("subcultures_present_on_first_turn")
		
		if subcultures_present_on_first_turn[subculture] then
			return true
		end
	end

	return false
end;


-- internal function to notify the campaign manager that an intro cutscene is playing
function campaign_manager:notify_intro_cutscene_playing(is_playing)
	if is_playing then
		self.intro_cutscene_playing = true;
	else
		if self.intro_cutscene_playing then
			cm:set_saved_value("intro_cutscene_has_played", true);
		end;
		self.intro_cutscene_playing = false;
	end;
end;


--- @function is_intro_cutscene_playing
--- @desc Returns whether an intro cutscene is currently playing.
--- @return is intro cutscene playing
function campaign_manager:is_intro_cutscene_playing()
	return self.intro_cutscene_playing;
end;

--- @function set_cutscene_playing_allowed
--- @desc Sets a flag which will block the starting of cutscenes if they are not allowed.
function campaign_manager:set_cutscene_playing_allowed(allowed)
	self.cutscene_playing_allowed = allowed;
end;


--- @function is_cutscene_playing_allowed
--- @desc Returns whether we allow the starting of cutscenes.
--- @return is cutscene playing allowed
function campaign_manager:is_cutscene_playing_allowed()
	return self.cutscene_playing_allowed;
end;

--- @function has_intro_cutscene_played
--- @desc Returns whether an intro cutscene has been played this campaign playthrough at all.
--- @return has intro cutscene played
function campaign_manager:has_intro_cutscene_played()
	return not not self:get_saved_value("intro_cutscene_has_played");
end;







-----------------------------------------------------------------------------
--- @section DLC Ownership
-----------------------------------------------------------------------------


--- @function faction_has_dlc_or_is_ai
--- @desc Returns true if the provided faction key is a player and owns the specified DLC key
--- @p @string dlc key, The product key being checked, from the <code>ownership_products</code> table
--- @p @string faction key, The key of the faction being checked
--- @r @boolean <code>true</code> if the faction was player-controlled and owns the DLC, or if the faction was AI, otherwise <code>false</code>. 
function campaign_manager:faction_has_dlc_or_is_ai(dlc_key, faction_key)
	local faction = self:get_faction(faction_key)
	if not faction then return false end;
	
	if not faction:is_human() then
		return true;
	else
		return self:is_dlc_flag_enabled(dlc_key, faction_key)
	end;
end;


--- @function is_dlc_flag_enabled_by_anyone
--- @desc Returns true if any human players own the provided DLC key, or if we're in autotest.
--- @p @string dlc key, The product key being checked, from the <code>ownership_products</code> table
--- @r @boolean <code>true</code> if any players own the product key, or if we're in autotest, otherwise <code>false</code>.
function campaign_manager:is_dlc_flag_enabled_by_anyone(dlc_key)
	local player_faction_keys = self:get_human_factions();
	if #player_faction_keys == 0 then
		return true;
	end;

	for p = 1, #player_faction_keys do
		if self:is_dlc_flag_enabled(dlc_key, player_faction_keys[p]) then
			return true;
		end;
	end;
	return false;
end;


--- @function is_dlc_flag_enabled_by_everyone
--- @desc Returns true if all human players own the provided DLC key, or if we're in autotest.
--- @p @string dlc key, The product key being checked, from the <code>ownership_products</code> table
--- @r @boolean <code>true</code> if all players own the product key, or if we're in autotest, otherwise <code>false</code>.
function campaign_manager:is_dlc_flag_enabled_by_everyone(dlc_key)
	local player_faction_keys = self:get_human_factions();
	if #player_faction_keys == 0 then
		return true;
	end;

	for p = 1, #player_faction_keys do
		if not self:is_dlc_flag_enabled(dlc_key, player_faction_keys[p]) then
			return false;
		end;
	end;
	return true;
end;








-----------------------------------------------------------------------------
--- @section Co-ordinates
-----------------------------------------------------------------------------


--- @function log_to_dis
--- @desc Converts a set of logical co-ordinates into display co-ordinates.
--- @p number x, Logical x co-ordinate.
--- @p number y, Logical y co-ordinate.
--- @r number Display x co-ordinate.
--- @r number Display y co-ordinate.
function campaign_manager:log_to_dis(x, y)
	if not is_number(x) or x < 0 then
		script_error("ERROR: log_to_dis() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(y) or y < 0 then
		script_error("ERROR: log_to_dis() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a positive number");
		return;
	end;
	
	return self:model():display_position_for_logical_position(x, y);
end;


--- @function dis_to_log
--- @desc Converts a set of display co-ordinates into logical co-ordinates.
--- @p number x, Display x co-ordinate.
--- @p number y, Display y co-ordinate.
--- @r number Logical x co-ordinate.
--- @r number Logical x co-ordinate.
function campaign_manager:dis_to_log(x, y)
	if not is_number(x) or x < 0 then
		script_error("ERROR: dis_to_log() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(y) or y < 0 then
		script_error("ERROR: dis_to_log() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a positive number");
		return;
	end;
	
	return self:model():logical_position_for_display_position(x, y);
end;


--- @function distance_squared
--- @desc Returns the distance squared between two positions. The positions can be logical or display, as long as they are both in the same co-ordinate space. The squared distance is returned as it's faster to compare squared distances rather than taking the square-root.
--- @p number first x, x co-ordinate of the first position.
--- @p number first y, y co-ordinate of the first position.
--- @p number second x, x co-ordinate of the second position.
--- @p number second y, y co-ordinate of the second position.
--- @r number distance between positions squared.
function distance_squared(a_x, a_y, b_x, b_y)
	if not is_number(a_x) or a_x < 0 then
		script_error("ERROR: distance_squared() called but supplied a_x co-ordinate [" .. tostring(a_x) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(a_y) or a_y < 0 then
		script_error("ERROR: distance_squared() called but supplied a_y co-ordinate [" .. tostring(a_y) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(b_x) or b_x < 0 then
		script_error("ERROR: distance_squared() called but supplied b_x co-ordinate [" .. tostring(b_x) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(b_y) or b_y < 0 then
		script_error("ERROR: distance_squared() called but supplied b_y co-ordinate [" .. tostring(b_y) .. "] is not a positive number");
		return;
	end;
	
	return (b_x - a_x) ^ 2 + (b_y - a_y) ^ 2;
end;











-----------------------------------------------------------------------------
--- @section Bonus Values
-----------------------------------------------------------------------------


--- @function get_characters_bonus_value
--- @desc Returns the scripted bonus value a supplied character has of a supplied id.
--- @p character character interface
--- @p @string Scripted bonus value key, from the <code>scripted_bonus_value_ids</code> database table.
--- @r @number Bonus value amount.
function campaign_manager:get_characters_bonus_value(character, id)
	if not validate.is_character(character) then
		return false;
	end;
	
	if not validate.is_string(id) then
		return false;
	end;
	
	return character:bonus_values():scripted_value(id, "value");
end;

--- @function get_regions_bonus_value
--- @desc Returns the scripted bonus value a supplied region object has of a supplied id. It may also be supplied a region key in place of a region object.
--- @p object region interface or region key
--- @p @string Scripted bonus value key, from the <code>scripted_bonus_value_ids</code> database table.
--- @r @number Bonus value amount.
function campaign_manager:get_regions_bonus_value(region, id)
	if not is_string(region) and not is_region(region) then
		script_error("ERROR: get_regions_bonus_value() called, but supplied region [" .. tostring(region) .. "] is not a string or region object");
		return false;
	end;
	
	if not validate.is_string(id) then
		return false;
	end;
	
	if is_string(region) then
		region = cm:get_region(region);
		
		if not validate.is_region(region) then
			return false;
		end;
	end;
	
	return region:bonus_values():scripted_value(id, "value");
end;

--- @function get_provinces_bonus_value
--- @desc Returns the scripted bonus value a supplied faction province object has of a supplied id.
--- @p object faction province interface
--- @p @string Scripted bonus value key, from the <code>scripted_bonus_value_ids</code> database table.
--- @r @number Bonus value amount.
function campaign_manager:get_provinces_bonus_value(faction_province, id)
	if not validate.is_factionprovince(faction_province) then
		return false;
	end;
	
	if not validate.is_string(id) then
		return false;
	end;
	
	return faction_province:bonus_values():scripted_value(id, "value");
end;

--- @function get_factions_bonus_value
--- @desc Returns the scripted bonus value a supplied faction object has of a supplied id. It may also be supplied a faction key in place of a faction object.
--- @p object faction interface or faction key
--- @p @string Scripted bonus value key, from the <code>scripted_bonus_value_ids</code> database table.
--- @r @number Bonus value amount.
function campaign_manager:get_factions_bonus_value(faction, id)
	if not is_string(faction) and not is_faction(faction) then
		script_error("ERROR: get_factions_bonus_value() called, but supplied faction [" .. tostring(faction) .. "] is not a string or faction object");
		return false;
	end;
	
	if not validate.is_string(id) then
		return false;
	end;
	
	if is_string(faction) then
		faction = cm:get_faction(faction);
		
		if not validate.is_faction(faction) then
			return false;
		end;
	end;
	
	return faction:bonus_values():scripted_value(id, "value");
end;

--- @function get_forces_bonus_value
--- @desc Returns the scripted bonus value a supplied character has of a supplied id.
--- @p military_force military force interface
--- @p @string Scripted bonus value key, from the <code>scripted_bonus_value_ids</code> database table.
--- @r @number Bonus value amount.
function campaign_manager:get_forces_bonus_value(military_force, id)
	if not validate.is_militaryforce(military_force) then
		return false;
	end;
	
	if not validate.is_string(id) then
		return false;
	end;
	
	return military_force:bonus_values():scripted_value(id, "value");
end;










-----------------------------------------------------------------------------
--- @section Area Triggers
--- @desc The functions in this section allow areas to be drawn on the campaign map which, when entered and exited by a character, will fire events.
-----------------------------------------------------------------------------


--- @function add_hex_area_trigger
--- @desc Creates a hex based area trigger at a given set of logical co-ordinates with a supplied radius. Faction and subculture filtering is optional. The area will trigger "AreaEntered" and "AreaExited" events when a character enters and exits the trigger.
--- @p string id, The ID of the area trigger. Multiple area triggers with the same name will act as a single area trigger.
--- @p number x, Logical x co-ordinate.
--- @p number y, Logical y co-ordinate.
--- @p number radius, Radius of the area trigger (code supports a max of 20).
--- @p [opt=""] string faction key, Optional filter for faction (events will only trigger if the character belongs to this faction).
--- @p [opt=""] string subculture key, Optional filter for subculture (events will only trigger if the character belongs to this subculture).
function campaign_manager:add_hex_area_trigger(id, x, y, radius, faction_key, subculture_key)
	if not is_string(id) then
		script_error("ERROR: add_hex_area_trigger() called but supplied id [" .. tostring(id) .. "] is not a string");
		return;
	end;
	
	if not is_number(x) or x < 0 then
		script_error("ERROR: add_hex_area_trigger() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(y) or y < 0 then
		script_error("ERROR: add_hex_area_trigger() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(radius) then
		script_error("ERROR: add_hex_area_trigger() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a positive number");
		return;
	end;
	
	if radius < 1 or radius > 20 then
		script_error("ERROR: add_hex_area_trigger() called but supplied radius [" .. tostring(radius) .. "] is not a number between 1 and 20 - code only supports this size!");
		return;
	end;
	
	faction_key = faction_key or "";
	subculture_key = subculture_key or "";
	
	if not is_string(faction_key) then
		script_error("ERROR: add_hex_area_trigger() called but supplied faction_key [" .. tostring(faction_key) .. "] is not a string");
		return;
	end;
	
	if not is_string(subculture_key) then
		script_error("ERROR: add_hex_area_trigger() called but supplied subculture_key [" .. tostring(subculture_key) .. "] is not a string");
		return;
	end;
	
	self.game_interface:add_hex_area_trigger(id, x, y, radius, faction_key, subculture_key);
end;


--- @function remove_hex_area_trigger
--- @desc Removes a previously added hex based area trigger with the specified ID.
--- @p string id, The ID of the area trigger to remove.
function campaign_manager:remove_hex_area_trigger(id)
	if not is_string(id) then
		script_error("ERROR: remove_hex_area_trigger() called but supplied id [" .. tostring(id) .. "] is not a string");
		return;
	end;
	
	self.game_interface:remove_hex_area_trigger(id);
end;


--- @function add_interactable_campaign_marker
--- @desc Adds an interactable campaign marker (.bmd prefabs - as defined in the database) to the campaign map at a specified position. The marker comes with an attached hex area trigger. The area will trigger "AreaEntered" and "AreaExited" events when a character enters and exits the trigger.
--- @p string id, The ID of the interactable campaign marker. Multiple area triggers with the same name will act as a single area trigger.
--- @p string marker_info_key, The key of the marker to use as defined in the campaign_interactable_marker_infos table of the database.
--- @p number x, Logical x co-ordinate.
--- @p number y, Logical y co-ordinate.
--- @p number radius, Radius of the area trigger (code supports a max of 20).
--- @p [opt=""] string faction key, Optional filter for faction (events will only trigger if the character belongs to this faction).
--- @p [opt=""] string subculture key, Optional filter for subculture (events will only trigger if the character belongs to this subculture).
function campaign_manager:add_interactable_campaign_marker(id, marker_info_key, x, y, radius, faction_key, subculture_key)
	if not is_string(id) then
		script_error("ERROR: add_interactable_campaign_marker() called but supplied id [" .. tostring(id) .. "] is not a string");
		return;
	end;
	if not is_string(marker_info_key) then
		script_error("ERROR: add_interactable_campaign_marker() called but supplied marker_info_key [" .. tostring(marker_info_key) .. "] is not a string");
		return;
	end;
	
	if not is_number(x) or x < 0 then
		script_error("ERROR: add_interactable_campaign_marker() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(y) or y < 0 then
		script_error("ERROR: add_interactable_campaign_marker() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(radius) then
		script_error("ERROR: add_interactable_campaign_marker() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a positive number");
		return;
	end;
	
	if radius < 1 or radius > 20 then
		script_error("ERROR: add_interactable_campaign_marker() called but supplied radius [" .. tostring(radius) .. "] is not a number between 1 and 20 - code only supports this size!");
		return;
	end;
	
	faction_key = faction_key or "";
	subculture_key = subculture_key or "";
	
	if not is_string(faction_key) then
		script_error("ERROR: add_interactable_campaign_marker() called but supplied faction_key [" .. tostring(faction_key) .. "] is not a string");
		return;
	end;
	
	if not is_string(subculture_key) then
		script_error("ERROR: add_interactable_campaign_marker() called but supplied subculture_key [" .. tostring(subculture_key) .. "] is not a string");
		return;
	end;
	
	self.game_interface:add_interactable_campaign_marker(id, marker_info_key, x, y, radius, faction_key, subculture_key);
end;


--- @function remove_interactable_campaign_marker
--- @desc Removes a previously added interactable campaign marker with the specified ID.
--- @p string id, The ID of the interactable campaign marker to remove.
function campaign_manager:remove_interactable_campaign_marker(id)
	if not is_string(id) then
		script_error("ERROR: remove_interactable_campaign_marker() called but supplied id [" .. tostring(id) .. "] is not a string");
		return;
	end;
	
	self.game_interface:remove_interactable_campaign_marker(id);
end;








----------------------------------------------------------------------------
--- @section Building Queries & Modification
----------------------------------------------------------------------------


--- @function building_exists_in_province
--- @desc Returns whether the supplied building exists in the supplied province.
--- @p string building key
--- @p string province key
--- @r boolean building exist
function campaign_manager:building_exists_in_province(building_key, province_key)
	if not is_string(building_key) then
		script_error("ERROR: building_exists_in_province() called but supplied building key [" .. tostring(building_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(province_key) then
		script_error("ERROR: building_exists_in_province() called but supplied province key [" .. tostring(province_key) .. "] is not a string");
		return false;
	end;

	local region_list = self:model():world():region_manager():region_list();
	
	for i = 0, region_list:num_items() - 1 do
		local current_region = region_list:item_at(i);
		if current_region:province_name() == province_key and current_region:building_exists(building_key) then
			return true;
		end;
	end;
	
	return false;
end;


--- @function building_level_for_building
--- @desc Returns the building level for the supplied building key, as looked up from the <code>building_levels</code> database table (i.e. 0 is a "level one" building, 1 is a "level two" building and so on). If no building could be found then @nil is returned.
--- @p @string building key, Building key, from the <code>building_levels</code> database table.
--- @r @number building level, from the <code>building_levels</code> database table.
function campaign_manager:building_level_for_building(building_key)
	if not validate.is_string(building_key) then
		return false;
	end;

	local level = common.get_context_value("CcoBuildingLevelRecord", building_key, "Level()");
	if level then
		return level;
	end;
end;


--- @function building_chain_key_for_building
--- @desc Returns the building chain key for the supplied building key. If no building could be found then @nil is returned.
--- @p @string building key, Building key, from the <code>building_levels</code> database table.
--- @r @string building chain key, from the <code>building_chains</code> database table.
function campaign_manager:building_chain_key_for_building(building_key)
	if not validate.is_string(building_key) then
		return false;
	end;

	local chain_key = common.get_context_value("CcoBuildingLevelRecord", building_key, "BuildingChainRecordContext().Key()");
	if chain_key then
		return chain_key;
	end;
end;


--- @function building_superchain_key_for_building
--- @desc Returns the superchain key for the supplied building key. If no building could be found then @nil is returned.
--- @p @string building key, Building key, from the <code>building_levels</code> database table.
--- @r @string superchain key, from the <code>building_superchains</code> database table.
function campaign_manager:building_superchain_key_for_building(building_key)
	if not validate.is_string(building_key) then
		return false;
	end;

	return common.get_context_value("CcoBuildingLevelRecord", building_key, "BuildingChainRecordContext().BuildingSuperchainContext().Key()");
end;












----------------------------------------------------------------------------
--- @section Character Queries
----------------------------------------------------------------------------


local function get_closest_character_to_position_from_faction_impl(faction_specifier, x, y, is_display_coordinates, char_filter)
	local faction = cm:get_faction(faction_specifier);
	if not faction then
		script_error("ERROR: get_closest_character_to_position_from_faction() called but supplied faction [" .. tostring(faction_specifier) .. "] is not a valid faction, or a string name of a faction");
		return false;
	end;
	
	if not is_number(x) or x < 0 then
		script_error("ERROR: get_closest_character_to_position_from_faction() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a positive number");
		return false;
	end;
	
	if not is_number(y) or y < 0 then
		script_error("ERROR: get_closest_character_to_position_from_faction() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a positive number");
		return false;
	end;

	if is_display_coordinates then
		x, y = cm:dis_to_log(x, y);
	end;

	local char_list = faction:character_list();
	local closest_char;
	local closest_distance_squared = 9999999;
	
	for i = 0, char_list:num_items() - 1 do
		local current_char = char_list:item_at(i);

		if char_filter and char_filter(current_char) then
			local current_char_x, current_char_y = cm:char_logical_pos(current_char);
			local current_distance_squared = distance_squared(x, y, current_char_x, current_char_y);
			if current_distance_squared < closest_distance_squared then
				closest_char = current_char;
				closest_distance_squared = current_distance_squared;
			end;
		end;
	end;
	
	return closest_char, closest_distance_squared ^ 0.5;
end;


--- @function get_garrison_commander_of_region
--- @desc Returns the garrison commander character of the settlement in the supplied region. If no garrison commander can be found then @nil is returned.
--- @p region region object
--- @r character garrison commander
function campaign_manager:get_garrison_commander_of_region(region)
	if not is_region(region) then
		script_error("ERROR: get_garrison_commander_of_region() called but supplied object [" .. tostring(region) .. "] is not a valid region");
		return false;
	end
	
	if region:is_abandoned() then
		return;
	end;
	
	local faction = region:owning_faction();
	
	if not is_faction(faction) then
		return;
	end;
	
	local character_list = faction:character_list();
	
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i);
		
		if character:has_military_force() and character:military_force():is_armed_citizenry() and character:has_region() and character:region() == region then		
			return character;
		end;
	end;
end;


--- @function get_closest_character_to_position_from_faction
--- @desc Returns the character within the supplied faction that's closest to the supplied logical co-ordinates. If the is-display-coordinates flag is set then the supplied co-ordinates should be display co-ordinates instead.
--- @p object faction, Faction specifier. This can be a faction object or a string faction name.
--- @p @number x, Logical x co-ordinate, or Display x co-ordinate if the is-display-coordinates flag is set.
--- @p @number y, Logical y co-ordinate, or Display y co-ordinate if the is-display-coordinates flag is set.
--- @p [opt=false] @boolean general characters only, Restrict search results to generals.
--- @p [opt=false] @boolean include garrison commanders, Includes garrison commanders in the search results if set to <code>true</code>.
--- @p [opt=false] @boolean is display co-ordinates, Sets the function to use display co-ordinates instead of logical co-ordinates.
--- @p [opt=nil] @string visible to faction, Restricts search results to characters visible to the specified faction, by key from the <code>factions</code> database table.
--- @r character closest character
--- @r @number distance
function campaign_manager:get_closest_character_to_position_from_faction(faction_specifier, x, y, generals_only, consider_garrison_commanders, is_display_coordinates, visible_to_faction)
	generals_only = not not generals_only;
	consider_garrison_commanders = not not consider_garrison_commanders;
	
	if not generals_only then
		consider_garrison_commanders = true;
	end;

	if visible_to_faction and not validate.is_string(visible_to_faction) then
		return false;
	end;

	local function char_filter(char)
		-- if we aren't only looking for generals OR if we are and this is a general AND if we are considering garrison commanders OR if we aren't and it is a general proceed
		return not generals_only or (self:char_is_general(char) and char:has_military_force() and (consider_garrison_commanders or not char:military_force():is_armed_citizenry())) and (not visible_to_faction or char:is_visible_to_faction(visible_to_faction));
	end;

	return get_closest_character_to_position_from_faction_impl(faction_specifier, x, y, is_display_coordinates, char_filter)
end;


--- @function get_closest_character_from_filter_to_position_from_faction
--- @desc Returns the character within the supplied faction that's closest to the supplied logical co-ordinates. An optional filter function may be supplied which is called for each character in the faction - the function will be passed the character and should return <code>true</code> if the character is eligible to returned.
--- @desc If the is-display-coordinates flag is set then the supplied co-ordinates should be display co-ordinates instead.
--- @p object faction, Faction specifier. This can be a faction object or a string faction name.
--- @p @number x, Logical x co-ordinate, or Display x co-ordinate if the is-display-coordinates flag is set.
--- @p @number y, Logical y co-ordinate, or Display y co-ordinate if the is-display-coordinates flag is set.
--- @p [opt=nil] @function filter, Character filter callback. If supplied, this function will be called for each character in the faction and should return <code>true</code> if the character is to be considered in the results.
--- @p [opt=false] @boolean is display co-ordinates, Sets the function to use display co-ordinates instead of logical co-ordinates.
--- @r character closest character
--- @r @number distance
function campaign_manager:get_closest_character_from_filter_to_position_from_faction(faction_specifier, x, y, filter_callback, is_display_coordinates)
	if not filter_callback then
		function filter_callback(char)
			return true;
		end;
	end;

	return get_closest_character_to_position_from_faction_impl(faction_specifier, x, y, is_display_coordinates, filter_callback)
end;


--- @function get_closest_general_to_position_from_faction
--- @desc Returns the general within the supplied faction that's closest to the supplied co-ordinates. Logical co-ordinates should be supplied, unless the is-display-coordinates flag is set, in which case display co-ordinates should be provided.
--- @p object faction, Faction specifier. This can be a faction object or a string faction name.
--- @p @number x, x co-ordinate.
--- @p @number y, y co-ordinate.
--- @p [opt=false] @boolean include garrison commanders, Includes garrison commanders in the search results if set to <code>true</code>.
--- @p [opt=false] @boolean is display co-ordinates, Sets the function to use display co-ordinates instead of logical co-ordinates.
--- @p [opt=nil] @string visible to faction, Restricts search results to characters visible to the specified faction, by key from the <code>factions</code> database table.
--- @r character closest character
--- @r @number distance
function campaign_manager:get_closest_general_to_position_from_faction(faction, x, y, consider_garrison_commanders, is_display_coordinates, visible_to_faction)
	return self:get_closest_character_to_position_from_faction(faction, x, y, true, consider_garrison_commanders, is_display_coordinates, visible_to_faction);
end;


--- @function get_closest_character_to_camera_from_faction
--- @desc Returns the character within the supplied faction that's closest to the camera. This function is inherently unsafe to use in multiplayer mode - in this case, the position of the specified faction's faction leader character is used as the position to test from.
--- @p object faction, Faction specifier. This can be a faction object or a string faction name.
--- @p [opt=false] @boolean general characters only, Restrict search results to generals.
--- @p [opt=false] @boolean include garrison commanders, Includes garrison commanders in the search results if set to <code>true</code>.
--- @p [opt=nil] @string visible to faction, Restricts search results to characters visible to the specified faction, by key from the <code>factions</code> database table.
--- @r character closest character, or @nil if none found
--- @r @number distance, or @nil if none found
function campaign_manager:get_closest_character_to_camera_from_faction(faction_specifier, generals_only, consider_garrison_commanders, visible_to_faction)
	
	local faction = self:get_faction(faction_specifier);
	if not faction then
		script_error("ERROR: get_closest_character_to_camera_from_faction() called but supplied faction [" .. tostring(faction_specifier) .. "] is not a valid faction, or a string name of a faction");
		return false;
	end;

	local x, y;

	if self:is_multiplayer() then
		x, y = cm:char_display_pos(faction:faction_leader());
	else
		x, y = self:get_camera_position();
	end;

	return self:get_closest_character_to_position_from_faction(faction, x, y, generals_only, consider_garrison_commanders, true, visible_to_faction);
end;


--- @function get_closest_character_from_filter_to_camera_from_faction
--- @desc Returns the character within the supplied faction that's closest to the camera. An optional filter function may be supplied which is called for each character in the faction - the function will be passed the character and should return <code>true</code> if the character is eligible to returned.
--- @desc This function is inherently unsafe to use in multiplayer mode - in this case, the position of the specified faction's faction leader character is used as the position to test from.
--- @p object faction, Faction specifier. This can be a faction object or a string faction name.
--- @p [opt=nil] @function filter, Character filter callback. If supplied, this function will be called for each character in the faction and should return <code>true</code> if the character is to be considered in the results.
--- @r character closest character
--- @r @number distance
function campaign_manager:get_closest_character_from_filter_to_camera_from_faction(faction_specifier, filter_callback)
	local faction = self:get_faction(faction_specifier);
	if not faction then
		script_error("ERROR: get_closest_character_from_filter_to_camera_from_faction() called but supplied faction [" .. tostring(faction_specifier) .. "] is not a valid faction, or a string name of a faction");
		return false;
	end;

	local x, y;

	if self:is_multiplayer() then
		x, y = cm:char_display_pos(faction:faction_leader());
	else
		x, y = self:get_camera_position();
	end;
	
	
	if not filter_callback then
		function filter_callback(char)
			return true;
		end;
	end;

	return get_closest_character_to_position_from_faction_impl(faction_specifier, x, y, true, filter_callback)
end;


--- @function get_closest_hero_to_position_from_faction
--- @desc Returns the hero character from the specified faction that's closest to the specified position. If no hero character is found then @nil is returned. The position should be specified by logical co-ordinates unless the is-display-coordinates flag is set, in which case the position is specified by display co-ordinates.
--- @desc Optional list of character types and subtypes can be provided as tables of strings. If these lists are specified then a character's type/subtype must be present in the relevant list for it to be considered.
--- @p object faction, Faction specifier. This can be a faction object or a string faction name.
--- @p @number x, x co-ordinate.
--- @p @number y, y co-ordinate.
--- @p [opt=false] @boolean is display co-ordinates, Sets the function to use display co-ordinates instead of logical co-ordinates.
--- @p [opt=nil] @table character types, Table of @string hero types. If no table of character types is supplied then all hero types are eligible.
--- @p [opt=nil] @table character subtypes, Table of @string hero subtypes. If no table of subtypes is supplied then all subtypes are eligible.
--- @r character closest eligible hero, or @nil if none found
--- @r @number distance, or @nil if none found
function campaign_manager:get_closest_hero_to_position_from_faction(faction_specifier, x, y, is_display_coordinates, character_types, character_subtypes)

	character_types = character_types or self:get_all_agent_types();

	if character_types and not validate.is_table_of_strings(character_types) then
		return false;
	end;

	if character_subtypes and not validate.is_table_of_strings(character_subtypes) then
		return false;
	end;

	local function char_filter(char)
		if character_types then
			local char_type_found = false;
			local character_type = char:character_type_key();
			for i = 1, #character_types do
				if character_types[i] == character_type then
					char_type_found = true;
					break;
				end;
			end;

			if not char_type_found then
				return false;
			end;
		end;

		if character_subtypes then
			local char_subtype_found = false;
			local character_type = char:character_type_key();
			for i = 1, #character_types do
				if character_types[i] == character_type then
					char_subtype_found = true;
					break;
				end;
			end;

			if not char_subtype_found then
				return false;
			end;
		end;

		return true;
	end;

	return get_closest_character_to_position_from_faction_impl(faction_specifier, x, y, is_display_coordinates, char_filter)
end;


function campaign_manager:get_closest_hero_to_camera_from_faction(faction_specifier, character_types, character_subtypes)
	local x, y;

	if self:is_multiplayer() then
		local faction = cm:get_faction(faction_specifier);

		if not faction then
			script_error("ERROR: get_closest_hero_to_camera_from_faction() called but supplied faction [" .. tostring(faction_specifier) .. "] is not a valid faction, or a string name of a faction");
			return false;
		end;

		x, y = cm:char_display_pos(faction:faction_leader());
	else
		x, y = cm:get_camera_position();
	end;

	return self:get_closest_hero_to_position_from_faction(faction_specifier, x, y, true, character_types, character_subtypes);
end;


--- @function get_general_at_position_all_factions
--- @desc Returns the general character stood at the supplied position, regardless of faction. Garrison commanders are not returned.
--- @p number x, Logical x co-ordinate.
--- @p number y, Logical y co-ordinate.
--- @r character general character
function campaign_manager:get_general_at_position_all_factions(x, y)
	local faction_list = cm:model():world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i);
			
		local military_force_list = faction:military_force_list();
		
		for j = 0, military_force_list:num_items() - 1 do
			local mf = military_force_list:item_at(j);
			
			if mf:has_general() and not mf:is_armed_citizenry() then
				local character = mf:general_character();
				
				if character:logical_position_x() == x and character:logical_position_y() == y then
					return character;
				end;
			end;
		end;
	end;
	
	return false;
end;


--- @function get_character_by_cqi
--- @desc Returns a character by it's command queue index. If no character with the supplied cqi is found then <code>false</code> is returned.
--- @p number cqi
--- @r character character
function campaign_manager:get_character_by_cqi(cqi)
	if is_string(cqi) then
		cqi = tonumber(cqi);
	end;
	
	if not is_number(cqi) then
		script_error("get_character_by_cqi() called but supplied cqi [" .. tostring(cqi) .. "] is not a number or a string that converts to a number");
		return false;
	end;
	
	local model = self:model();
	if model:has_character_command_queue_index(cqi) then
		return model:character_for_command_queue_index(cqi);
	end;

	return false;
end;


--- @function get_family_member_by_cqi
--- @desc Returns a family member by it's command queue index. If no family member with the supplied cqi is found then <code>false</code> is returned.
--- @p number cqi
--- @r family_member family member
function campaign_manager:get_family_member_by_cqi(cqi)
	if is_string(cqi) then
		cqi = tonumber(cqi);
	end;
	
	if not is_number(cqi) then
		script_error("get_family_member_by_cqi() called but supplied cqi [" .. tostring(cqi) .. "] is not a number or a string that converts to a number");
		return false;
	end;
	
	local model = self:model();
	if model:has_family_member_command_queue_index(cqi) then
		return model:family_member_for_command_queue_index(cqi);
	end;

	return false;
end;


--- @function get_military_force_by_cqi
--- @desc Returns a military force by it's command queue index. If no military force with the supplied cqi is found then <code>false</code> is returned.
--- @p number cqi
--- @r military_force military force
function campaign_manager:get_military_force_by_cqi(cqi)
	if is_string(cqi) then
		cqi = tonumber(cqi);
	end;
	
	if not is_number(cqi) then
		script_error("get_military_force_by_cqi() called but supplied cqi [" .. tostring(cqi) .. "] is not a number or a string that converts to a number");
		return false;
	end;
	
	local model = self:model();
	if model:has_military_force_command_queue_index(cqi) then
		return model:military_force_for_command_queue_index(cqi);
	end;

	return false;
end;


--- @function get_character_by_mf_cqi
--- @desc Returns the commander of a military force by the military force's command queue index. If no military force with the supplied cqi is found or it has no commander then <code>false</code> is returned.
--- @p number military force cqi
--- @r character general character
function campaign_manager:get_character_by_mf_cqi(cqi)
	local mf = self:get_military_force_by_cqi(cqi);
	
	if mf and mf:has_general() then
		return mf:general_character();
	end;
	
	return false;
end;


--- @function get_character_by_fm_cqi
--- @desc Returns a character by family member command queue index. If no family member interface with the supplied cqi could be found then <code>false</code> is returned.
--- @p @number family member cqi
--- @r character character
function campaign_manager:get_character_by_fm_cqi(cqi)
	local family_member = self:model():family_member_for_command_queue_index(cqi);

	if not family_member:is_null_interface() then
		return family_member:character();
	end;
	
	return false;
end;


--- function char_name_to_string
--- @desc Returns the supplied character's full localised name as a string for output.
--- @p character character
--- @r @string character name
function campaign_manager:char_name_to_string(character)
	local forename = character:get_forename();
	local surname = character:get_surname();

	if not forename or forename == "" then
		forename = "<no forename>";
	else
		forename = common.get_localised_string(forename);
	end;

	if not surname or surname == "" then
		return forename;
	end;

	-- localised surnames can sometimes be blank, so only return the forename in this case
	local localised_surname = common.get_localised_string(surname);
	if not string.match(localised_surname, "[^%s]") then
		-- localised_surname didn't contain any non-space characters
		return forename;
	end;

	return forename .. " " .. localised_surname;
end;


--- @function char_display_pos
--- @desc Returns the x/y display position of the supplied character.
--- @p character character
--- @r number x display co-ordinate
--- @r number y display co-ordinate
function campaign_manager:char_display_pos(character)
	if not is_character(character) then
		script_error("ERROR: char_display_pos() called but supplied object [" .. tostring(character) .. "] is not a character");
		return 0, 0;
	end;
	
	return character:display_position_x(), character:display_position_y();
end;


--- @function char_logical_pos
--- @desc Returns the x/y logical position of the supplied character.
--- @p character character
--- @r number x logical co-ordinate
--- @r number y logical co-ordinate
function campaign_manager:char_logical_pos(character)
	if not is_character(character) then
		script_error("ERROR: char_logical_pos() called but supplied object [" .. tostring(character) .. "] is not a character");
		return 0, 0;
	end;

	return character:logical_position_x(), character:logical_position_y();
end;


--- @function character_is_army_commander
--- @desc Returns <code>true</code> if the character is a general at the head of a moveable army (not a garrison), <code>false</code> otherwise.
--- @p character character
--- @r boolean is army commander
function campaign_manager:character_is_army_commander(character)
	if not is_character(character) then
		script_error("ERROR: char_is_army_commander() called but supplied object [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	if not character:has_military_force() then
		return false;
	end;
	
	local military_force = character:military_force();
	
	return military_force:has_general() and military_force:general_character() == character and not military_force:is_armed_citizenry();
end;


--- @function char_lookup_str
--- @desc Various game interface functions lookup characters using a lookup string. This function converts a character into a lookup string that can be used by code functions to find that same character. It may also be supplied a character cqi in place of a character object.
--- @p object character or character cqi
--- @r string lookup string
function campaign_manager:char_lookup_str(obj)
	if is_number(obj) or is_string(obj) then
		return "character_cqi:" .. obj;
	elseif is_character(obj) then
		return "character_cqi:" .. obj:cqi();
	else
		script_error("ERROR: char_lookup_str() called but supplied object [" .. tostring(obj) .. "] not recognised");
	end;
end;


--- @function char_in_owned_region
--- @desc Returns <code>true</code> if the supplied character is in a region their faction controls, <code>false</code> otherwise.
--- @p character character
--- @r boolean stood in owned region
function campaign_manager:char_in_owned_region(character)
	if not is_character(character) then
		script_error("ERROR: char_in_owned_region() called but supplied object [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	return character:has_region() and (character:region():owning_faction() == character:faction());
end;


--- @function char_has_army
--- @desc Returns <code>true</code> if the supplied character has a land army military force, <code>false</code> otherwise.
--- @p character character
--- @r boolean has army
function campaign_manager:char_has_army(character)
	if not is_character(character) then
		script_error("ERROR: char_has_army() called but supplied object [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	return character:has_military_force() and character:military_force():is_army();
end;


--- @function char_has_navy
--- @desc Returns <code>true</code> if the supplied character has a navy military force, <code>false</code> otherwise.
--- @p character character
--- @r boolean has navy
function campaign_manager:char_has_navy(character)
	if not is_character(character) then
		script_error("ERROR: char_has_navy() called but supplied object [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	return character:has_military_force() and character:military_force():is_navy();
end;


--- @function char_is_agent
--- @desc Returns <code>true</code> if the supplied character is not a general, a colonel or a minister, <code>false</code> otherwise.
--- @p character character
--- @r boolean is agent
function campaign_manager:char_is_agent(character)
	if not is_character(character) then
		script_error("ERROR: char_is_agent() called but supplied object [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	return not (character:character_type("general") or character:character_type("colonel") or character:character_type("minister"));
end;


--- @function char_is_general
--- @desc Returns <code>true</code> if the supplied character is of type 'general', <code>false</code> otherwise.
--- @p character character
--- @r boolean is general
function campaign_manager:char_is_general(character)
	if not is_character(character) then
		script_error("ERROR: char_is_general() called but supplied object [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	return character:character_type("general");
end;


--- @function char_can_recruit_unit
--- @desc Returns <code>true</code> if the supplied character can recruit the supplied unit key, <code>false</code> otherwise.
--- @p character character
--- @p @string unit key
--- @r @boolean is general
function campaign_manager:char_can_recruit_unit(character, unit)
	if not validate.is_character(character) then
		return false;
	end;
	
	if not validate.is_string(unit) then
		return false;
	end;
	
	return character:has_military_force() and character:military_force():can_recruit_unit(unit);
end;


--- @function char_army_has_unit
--- @desc Returns <code>true</code> if the supplied character's army contains the supplied unit key (or table of unit keys), <code>false</code> otherwise.
--- @p character character
--- @p @string unit key or table of unit keys
--- @r @boolean contains unit
function campaign_manager:char_army_has_unit(character, unit)
	if not validate.is_character(character) then
		return false;
	end;
	
	if not validate.is_string_or_table_of_strings(unit) then
		return false;
	end;
	
	-- allow a table of units to be passed in as a parameter
	if type(unit) == "table" then
		if not character:has_military_force() and not character:is_embedded_in_military_force() then
			return false;
		end;
		
		for i = 1, #unit do
			if self:char_army_has_unit(character, unit[i]) then
				return true;
			end;
		end;
		return false;
	end;
	
	if character:has_military_force() then
		return character:military_force():unit_list():has_unit(unit);
	elseif character:is_embedded_in_military_force() then
		return character:embedded_in_military_force():unit_list():has_unit(unit);
	end;
end;


--- @function count_char_army_has_unit
--- @desc Returns the number of supplied unit keys (or table of unit keys) the character's army contains
--- @p character character
--- @p @string unit key or table of unit keys
--- @r @number number of units in army
function campaign_manager:count_char_army_has_unit(character, unit)
	if not validate.is_character(character) then
		return false;
	end;
	
	if not validate.is_string_or_table_of_strings(unit) then
		return false;
	end;
	
	local count = 0;
	local unit_list = false;
	
	if character:has_military_force() then
		unit_list = character:military_force():unit_list();
	elseif character:is_embedded_in_military_force() then
		unit_list = character:embedded_in_military_force():unit_list();
	end;
	
	if unit_list then
		for i = 0, unit_list:num_items() - 1 do
			if type(unit) == "table" then
				for j = 1, #unit do
					if unit_list:item_at(i):unit_key() == unit[j] then
						count = count + 1;
					end;
				end;
			elseif unit_list:item_at(i):unit_key() == unit then
				count = count + 1;
			end;
		end;
	end;
	
	return count;
end;


--- @function char_army_has_unit_category
--- @desc Returns <code>true</code> if the supplied character's army contains a unit with the supplied unit category (or table of unit categories), <code>false</code> otherwise.
--- @p character character
--- @p @string unit category key or table of unit category keys
--- @r @boolean contains unit with category
function campaign_manager:char_army_has_unit_category(character, unit_category)
	if not validate.is_character(character) then
		return false;
	end;
	
	if not validate.is_string_or_table_of_strings(unit_category) then
		return false;
	end;
	
	-- allow a table of unit categories to be passed in as a parameter
	if type(unit_category) == "table" then
		if not character:has_military_force() and not character:is_embedded_in_military_force() then
			return false;
		end;
		
		for i = 1, #unit_category do
			if self:char_army_has_unit_category(character, unit_category[i]) then
				return true;
			end;
		end;
		return false;
	end;
	
	local unit_list = false;
	
	if character:has_military_force() then
		unit_list = character:military_force():unit_list();
	elseif character:is_embedded_in_military_force() then
		return character:embedded_in_military_force():unit_list();
	end;
	
	if unit_list then
		for i = 0, unit_list:num_items() - 1 do
			if unit_list:item_at(i):unit_category() == unit_category then
				return true;
			end;
		end;
	end;
	
	return false;
end;


--- @function count_char_army_has_unit_category
--- @desc Returns the number of units with the supplied unit category (or table of unit categories) the character's army contains
--- @p character character
--- @p @string unit category key or table of unit category keys
--- @r @number number of units of category in army
function campaign_manager:count_char_army_has_unit_category(character, unit_category)
	if not validate.is_character(character) then
		return false;
	end;
	
	if not validate.is_string_or_table_of_strings(unit_category) then
		return false;
	end;
	
	local count = 0;
	local unit_list = false;
	
	if character:has_military_force() then
		unit_list = character:military_force():unit_list();
	elseif character:is_embedded_in_military_force() then
		unit_list = character:embedded_in_military_force():unit_list();
	end;
	
	if unit_list then
		for i = 0, unit_list:num_items() - 1 do
			if type(unit_category) == "table" then
				for j = 1, #unit_category do
					if unit_list:item_at(i):unit_category() == unit_category[j] then
						count = count + 1;
					end;
				end;
			elseif unit_list:item_at(i):unit_category() == unit_category then
				count = count + 1;
			end;
		end;
	end;
	
	return count;
end;


--- @function general_has_caster_embedded_in_army
--- @desc Returns <code>true</code> if the supplied character's army contains an embedded character that is a caster, <code>false</code> otherwise.
--- @p character character
--- @r @boolean contains caster
function campaign_manager:general_has_caster_embedded_in_army(character)
	if not validate.is_character(character) then
		return false;
	end;
	
	if character:has_military_force() then
		local character_list = character:military_force():character_list();
		
		for i = 0, character_list:num_items() - 1 do
			if character_list:item_at(i):is_caster() then
				return true;
			end;
		end;
	end;
	
	return false;
end;


--- @function character_won_battle_against_culture
--- @desc Returns <code>true</code> if the supplied character won their last battle against the key specified culture (or table of cultures), <code>false</code> otherwise.
--- @p character character
--- @p @string culture or table of cultures
--- @r @boolean character won against culture
function campaign_manager:character_won_battle_against_culture(character, culture)
	if not validate.is_character(character) then
		return false;
	end;
	
	if not validate.is_string_or_table_of_strings(culture) then
		return false;
	end;
	
	if character:won_battle() then
		local character_faction_name = character:faction():name();
		local target_faction_name = false;
		
		local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
		local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
		
		if defender_faction_name == character_faction_name then
			target_faction_name = attacker_faction_name;
		elseif attacker_faction_name == character_faction_name then
			target_faction_name = defender_faction_name;
		end;
		
		if target_faction_name and target_faction_name ~= "rebels" then
			local enemy_culture = cm:get_faction(target_faction_name):culture();
			
			-- allow a table of cultures to be passed in as a parameter
			if type(culture) == "table" then
				for i = 1, #culture do
					if enemy_culture == culture[i] then
						return true;
					end;
				end;
			else
				return enemy_culture == culture;
			end;
		end;
	end;
	
	return false;
end;


--- @function character_won_battle_against_unit
--- @desc Returns <code>true</code> if the supplied character won their last battle against an army containing the key specified unit key (or table of unit keys), <code>false</code> otherwise.
--- @p character character
--- @p @string unit key or table of unit keys
--- @r @boolean character won against unit key
function campaign_manager:character_won_battle_against_unit(character, unit)
	if not validate.is_character(character) then
		return false;
	end;
	
	if not validate.is_string_or_table_of_strings(unit) then
		return false;
	end;
	
	if type(unit) == "table" then
		for i = 1, #unit do
			if self:character_won_battle_against_unit(character, unit[i]) then
				return true;
			end;
		end;
		
		return false;
	end;

	if character:won_battle() then
		local character_faction_name = character:faction():name();
		
		local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
		local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
		
		if attacker_faction_name == character_faction_name then
			return cm:pending_battle_cache_unit_key_exists_in_defenders(unit);
		elseif defender_faction_name == character_faction_name then
			return cm:pending_battle_cache_unit_key_exists_in_attackers(unit);
		end;
	end;
	
	return false;
end;


--- @function character_reinforced_alongside_culture
--- @desc Returns <code>true</code> if the supplied character reinforced alongside the key specified culture in their last battle, <code>false</code> otherwise.
--- @p character character
--- @p @string culture
--- @r @boolean character reinforced alongside culture
function campaign_manager:character_reinforced_alongside_culture(character, culture)
	if not validate.is_character(character) then
		return false;
	end;
	
	if not validate.is_string(culture) then
		return false;
	end;
	
	if cm:char_is_general_with_army(character) then
		local character_is_attacker = false;
		local pb = cm:model():pending_battle();
		
		-- determine if the character is on the attacking side
		if pb:attacker() == character then
			character_is_attacker = true;
		else
			local secondary_attackers = pb:secondary_attackers();
			for i = 0, secondary_attackers:num_items() - 1 do
				if secondary_attackers:item_at(i) == character then
					character_is_attacker = true;
					break;
				end;
			end;
		end;
		
		local num_attackers = cm:pending_battle_cache_num_attackers();
		local num_defenders = cm:pending_battle_cache_num_defenders();
		
		if character_is_attacker then
			if num_attackers > 1 then
				for i = 1, num_attackers do
					local current_attacker_cqi, current_attacker_mf_cqi, current_attacker_faction_name = cm:pending_battle_cache_get_attacker(i);
					
					if character:cqi() ~= current_attacker_cqi then
						local current_attacker_faction = cm:get_faction(current_attacker_faction_name);
						
						if current_attacker_faction and current_attacker_faction:culture() == culture then
							-- found a reinforcing army that matches the supplied culture
							return true;
						end;
					end;
				end;
			end;
		elseif num_defenders > 1 then
			for i = 1, num_defenders do
				local current_defender_cqi, current_defender_mf_cqi, current_defender_faction_name = cm:pending_battle_cache_get_defender(i);
				
				if character:cqi() ~= current_defender_cqi then
					local current_defender_faction = cm:get_faction(current_defender_faction_name);
					
					if current_defender_faction and current_defender_faction:culture() == culture then
						-- found a reinforcing army that matches the supplied culture
						return true;
					end;
				end;
			end;
		end;
	end;
end;


--- @function char_is_victorious_general
--- @desc Returns <code>true</code> if the supplied character is a general that has been victorious (when?), <code>false</code> otherwise.
--- @p character character
--- @r boolean is victorious general
function campaign_manager:char_is_victorious_general(character)
	if not is_character(character) then
		script_error("ERROR: char_is_victorious_general() called but supplied object [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	return character:character_type("general") and character:won_battle();
end;


--- @function char_is_defeated_general
--- @desc Returns <code>true</code> if the supplied character is a general that has been defeated (when?), <code>false</code> otherwise.
--- @p character character
--- @r boolean is defeated general
function campaign_manager:char_is_defeated_general(character)
	if not is_character(character) then
		script_error("ERROR: char_is_defeated_general() called but supplied object [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	return character:character_type("general") and not character:won_battle();
end;


--- @function char_is_general_with_army
--- @desc Returns <code>true</code> if the supplied character is a general and has an army, <code>false</code> otherwise. This includes garrison commanders - to only return true if the army is mobile use @campaign_manager:char_is_mobile_general_with_army.
--- @p character character
--- @r boolean is general with army
function campaign_manager:char_is_general_with_army(character)
	if not is_character(character) then
		script_error("ERROR: char_is_general_with_army() called but supplied object [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	return self:char_is_general(character) and self:char_has_army(character);
end;


--- @function char_is_mobile_general_with_army
--- @desc Returns <code>true</code> if the supplied character is a general, has an army, and can move around the campaign map, <code>false</code> otherwise.
--- @p character character
--- @r boolean is general with army
function campaign_manager:char_is_mobile_general_with_army(character)
	if not is_character(character) then
		script_error("ERROR: char_is_mobile_general_with_army() called but supplied object [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	return self:char_is_general_with_army(character) and not character:military_force():is_armed_citizenry();
end;


--- @function char_is_garrison_commander
--- @desc Returns <code>true</code> if the supplied character is a general, has an army, and that army is armed citizenry (i.e. a garrison).
--- @p character character
--- @return boolean is general with army
function campaign_manager:char_is_garrison_commander(character)
	if not is_character(character) then
		script_error("ERROR: char_is_garrison_commander() called but supplied object [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	return self:char_has_army(character) and character:military_force():is_armed_citizenry();
end;


--- @function char_is_general_with_navy
--- @desc Returns <code>true</code> if the supplied character is a general with a military force that is a navy, <code>false</code> otherwise.
--- @p character character
--- @r boolean is general with navy
function campaign_manager:char_is_general_with_navy(character)
	if not is_character(character) then
		script_error("ERROR: char_is_general_with_navy() called but supplied object [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	return cm:char_is_general(character) and self:char_has_navy(character);
end;


--- @function char_is_general_with_embedded_agent
--- @desc Returns <code>true</code> if the supplied character is a general with a military force that contains at least one embedded agent, <code>false</code> otherwise.
--- @p character character
--- @r boolean is general with embedded agent
function campaign_manager:char_is_general_with_embedded_agent(character)
	if not is_character(character) then
		script_error("ERROR: char_is_general_with_embedded_agent() called but supplied object [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	if self:char_is_mobile_general_with_army(character) then
		local character_list = character:military_force():character_list();
		
		for i = 0, character_list:num_items() - 1 do
			if self:char_is_agent(character_list:item_at(i)) then
				return true;
			end;
		end;
	end;
	
	return false;
end;

--- @function char_is_in_region_list
--- @desc Returns <code>true</code> if the supplied character is currently in any region from a supplied list, <code>false</code> otherwise.
--- @p character character
--- @p table table of region keys
--- @r boolean is in region list
function campaign_manager:char_is_in_region_list(character, region_list)
	if not is_character(character) then
		script_error("ERROR: char_is_in_region_list() called but supplied object [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	if character:has_region() then
		return table.contains(region_list, character:region():name());
	end;
end;


--- @function get_all_agent_types
--- @desc Retuns a numerically-indexed table containing all agent types. Please copy this table instead of writing to it.
--- @r @table agent types
function campaign_manager:get_all_agent_types()
	return self.all_agent_types;
end;


--- @function get_all_agent_types_lookup
--- @desc Retuns a table containing all agent types as keys (the value of each record being <code>true</code>). Please copy this table instead of writing to it.
--- @r @table agent types
function campaign_manager:get_all_agent_types_lookup()
	return self.all_agent_types_lookup;
end;


--- @function get_closest_visible_character_of_culture
--- @desc Returns the closest character of the supplied culture to the supplied faction. The culture and faction are both specified by string key.
--- @desc Use this function sparingly, as it is quite expensive.
--- @p @string faction key, Faction key, from the <code>factions</code> database table.
--- @p @string subculture key, Culture key, from the <code>cultures</code> database table.
--- @p [opt=nil] @function filter, Filter function. If supplied, this filter function will be called for each potentially-eligible character, with the character being passed in as a single argument. The character will only be considered eligible if the filter function returns <code>true</code>.
--- @r character closest visible character
function campaign_manager:get_closest_visible_character_of_culture(faction_key, culture_key, character_filter)
	local faction = cm:get_faction(faction_key);
	
	if not faction then
		script_error("ERROR: get_closest_visible_character_of_culture() called but couldn't find faction with supplied key [" .. tostring(faction_key) .. "]");
		return false;
	end;
	
	if not is_string(culture_key) then
		script_error("ERROR: get_closest_visible_character_of_culture() called but supplied subculture key [" .. tostring(culture_key) .. "] is not a string");
		return false;
	end;

	if character_filter and not validate.is_function(character_filter) then
		return false;
	end;
		
	local closest_char = false;
	local closest_char_dist = 9999999;
	
	-- get a list of chars of the supplied culture
	local faction_list = faction:factions_met();
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		
		if current_faction:culture() == culture_key then		
			local char_list = current_faction:character_list();
			
			for j = 0, char_list:num_items() - 1 do
				local current_char = char_list:item_at(j);
				
				if current_char:is_visible_to_faction(faction_key) and (self:char_is_agent(current_char) or self:char_is_general(current_char)) and (not character_filter or character_filter(current_char)) then
					local closest_player_char, closest_player_char_dist = self:get_closest_character_from_faction(faction, current_char:logical_position_x(), current_char:logical_position_y());
					
					if closest_player_char_dist < closest_char_dist then
						closest_char_dist = closest_player_char_dist;
						closest_char = current_char;
					end;
				end;
			end;
		end;
	end;

	if not closest_char then
		return nil;
	end;
		
	return closest_char, closest_char_dist ^ 0.5;
end;


--- @function get_closest_visible_character_of_subculture
--- @desc Returns the closest character of the supplied subculture to the supplied faction. The subculture and faction are both specified by string key.
--- @desc Use this function sparingly, as it is quite expensive.
--- @p @string faction key, Faction key, from the <code>factions</code> database table.
--- @p @string subculture key, Subculture key, from the <code>cultures_subcultures</code> database table.
--- @p [opt=nil] @function filter, Filter function. If supplied, this filter function will be called for each potentially-eligible character, with the character being passed in as a single argument. The character will only be considered eligible if the filter function returns <code>true</code>.
--- @r character closest visible character
function campaign_manager:get_closest_visible_character_of_subculture(faction_key, subculture_key, character_filter)
	local faction = cm:get_faction(faction_key);
	
	if not faction then
		script_error("ERROR: get_closest_visible_character_of_subculture() called but couldn't find faction with supplied key [" .. tostring(faction_key) .. "]");
		return false;
	end;
	
	if not is_string(subculture_key) then
		script_error("ERROR: get_closest_visible_character_of_subculture() called but supplied subculture key [" .. tostring(subculture_key) .. "] is not a string");
		return false;
	end;

	if character_filter and not validate.is_function(character_filter) then
		return false;
	end;
		
	local closest_char = false;
	local closest_char_dist = 9999999;
	
	-- get a list of chars of the supplied culture
	local faction_list = faction:factions_met();
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		
		if current_faction:subculture() == subculture_key then		
			local char_list = current_faction:character_list();
			
			for j = 0, char_list:num_items() - 1 do
				local current_char = char_list:item_at(j);
				
				if current_char:is_visible_to_faction(faction_key) and (self:char_is_agent(current_char) or self:char_is_general(current_char)) and (not character_filter or character_filter(current_char)) then
					local closest_player_char, closest_player_char_dist = self:get_closest_character_from_faction(faction, current_char:logical_position_x(), current_char:logical_position_y());
					
					if closest_player_char_dist < closest_char_dist then
						closest_char_dist = closest_player_char_dist;
						closest_char = current_char;
					end;
				end;
			end;
		end;
	end;
	
	if not closest_char then
		return nil;
	end;
		
	return closest_char, closest_char_dist ^ 0.5;
end;


--- @function get_closest_character_from_faction
--- @desc Returns the closest character from the supplied faction to the supplied logical position. This includes characters such as politicians and garrison commanders that are not extant on the map.
--- @p faction faction, Faction script interface.
--- @p number x, Logical x position.
--- @p number y, Logical y position.
--- @r character closest character
--- @r @number closest character distance
function campaign_manager:get_closest_character_from_faction(faction, x, y)
	local closest_distance = false;
	local closest_character = false;
	
	local char_list = faction:character_list();
	
	for i = 0, char_list:num_items() - 1 do
		local current_char = char_list:item_at(i);
		
		local current_distance = distance_squared(x, y, current_char:logical_position_x(), current_char:logical_position_y());
		if closest_distance == false or current_distance < closest_distance then
			closest_distance = current_distance;
			closest_character = current_char;
		end;
	end;
	
	return closest_character, closest_distance;	
end;


--- @function character_can_reach_character
--- @desc Returns <code>true</code> if the supplied source character can reach the supplied target character this turn, <code>false</code> otherwise. The underlying test on the model interface returns false-positives if the source character has no action points - this wrapper function works around this problem by testing the source character's action points too.
--- @p character source character
--- @p character target character
--- @r boolean can reach
function campaign_manager:character_can_reach_character(source_char, target_char)
	if not is_character(source_char) then
		script_error("ERROR: character_can_reach_character() called but supplied source character [" .. tostring(source_char) .. "] is not a character");
		return false;
	end;
	
	if not is_character(target_char) then
		script_error("ERROR: character_can_reach_character() called but supplied target character [" .. tostring(target_char) .. "] is not a character");
		return false;
	end;
	
	return source_char:action_points_remaining_percent() > 0 and self:model():character_can_reach_character(source_char, target_char);
end;


--- @function character_can_reach_settlement
--- @desc Returns <code>true</code> if the supplied source character can reach the supplied target settlement this turn, <code>false</code> otherwise. The underlying test on the model interface returns false-positives if the source character has no action points - this wrapper function works around this problem by testing the source character's action points too.
--- @p character source character
--- @p settlement target settlement
--- @r boolean can reach
function campaign_manager:character_can_reach_settlement(source_char, target_settlement)
	if not is_character(source_char) then
		script_error("ERROR: character_can_reach_settlement() called but supplied source character [" .. tostring(source_char) .. "] is not a character");
		return false;
	end;
	
	if not is_settlement(target_settlement) then
		script_error("ERROR: character_can_reach_settlement() called but supplied target settlement [" .. tostring(target_settlement) .. "] is not a settlement");
		return false;
	end;
	
	return source_char:action_points_remaining_percent() > 0 and self:model():character_can_reach_settlement(source_char, target_settlement);
end;


--- @function general_with_forename_exists_in_faction_with_force
--- @desc Returns <code>true</code> if a general with a mobile military force exists in the supplied faction with the supplied forename. Faction and forename are specified by string key.
--- @p string faction key, Faction key.
--- @p string forename key, Forename key in the full localisation lookup format i.e. <code>[table]_[column]_[record_key]</code>.
--- @r boolean general exists
function campaign_manager:general_with_forename_exists_in_faction_with_force(faction_name, char_forename)
	local faction = cm:get_faction(faction_name);
	
	if not faction then
		return false;
	end;
	
	local char_list = faction:character_list();
	
	for i = 0, char_list:num_items() - 1 do
		local current_char = char_list:item_at(i);
		
		if current_char:get_forename() == char_forename and cm:char_is_general(current_char) and current_char:has_military_force() and not current_char:military_force():is_armed_citizenry() then
			return true;
		end;
	end;
	
	return false;
end;


--- @function get_highest_ranked_general_for_faction
--- @desc Returns the general character in the supplied faction of the highest rank. The faction may be supplied as a faction object or may be specified by key.
--- @p object faction, Faction, either by faction object or by string key.
--- @r character highest ranked character
function campaign_manager:get_highest_ranked_general_for_faction(faction)
	if is_string(faction) then
		faction = cm:get_faction(faction)
	end;
	
	if not is_faction(faction) then
		script_error("ERROR: get_highest_ranked_general_for_faction() called but supplied object [" .. tostring(faction) .. "] is not a faction");
		return false;
	end;
	
	local char_list = faction:character_list();
	
	local current_rank = 0;
	local chosen_char = nil;
	local char_x = 0;
	local char_y = 0;
	
	for i = 0, char_list:num_items() - 1 do
		local current_char = char_list:item_at(i);
		
		if self:char_is_general_with_army(current_char) then
			local rank = current_char:rank();
			
			if rank > current_rank then
				chosen_char = current_char;
				current_rank = rank;
			end;
		end;
	end;

	if chosen_char then
		return chosen_char;
	else
		return false;
	end;
end;


--- @function get_most_recently_created_character_of_type
--- @desc Returns the most recently-created character of a specified type and/or subtype for a given faction. This function makes the assumption that the character with the highest command-queue-index value is the most recently-created.
--- @p @string faction key, Faction specifier supply either a @string faction key, from the <code>factions</code> database table, or a faction script interface.
--- @p [opt=nil] @string type, Character type. If no type is specified then all character types match.
--- @p [opt=nil] @string subtype, Character subtype. If no subtype is specified then all character subtypes match.
function campaign_manager:get_most_recently_created_character_of_type(faction_specifier, character_type, character_subtype)

	local faction = self:get_faction(faction_specifier);

	if not validate.is_faction(faction) then
		return false;
	end;

	if character_type and not validate.is_string(character_type) then
		return false;
	end;

	if character_subtype and not validate.is_string(character_subtype) then
		return false;
	end;

	local character_list = faction:character_list();
	
	local newest_character;
	local newest_character_cqi = -1;

	for _, character in model_pairs(character_list) do
		if (not character_type or character:character_type(character_type)) and (not character_subtype or character:character_subtype(character_subtype)) and character:command_queue_index() > newest_character_cqi then
			newest_character = character;
			newest_character_cqi = character:command_queue_index();
		end;
	end;

	return newest_character;
end;









-----------------------------------------------------------------------------
--- @section Character Creation and Manipulation
-----------------------------------------------------------------------------


--- @function create_force
--- @desc Instantly spawn an army with a general on the campaign map. This function is a wrapper for the @episodic_scripting:create_force function provided by the episodic scripting interface, adding debug output and success callback functionality.
--- @p @string faction key, Faction key of the faction to which the force is to belong.
--- @p @string unit list, Comma-separated list of keys from the <code>land_units</code> table. The force will be created with these units.
--- @p @string region key, Region key of home region for this force.
--- @p @number x, x logical co-ordinate of force.
--- @p @number y, y logical co-ordinate of force.
--- @p @boolean exclude named characters, Don't spawn a named character at the head of this force.
--- @p [opt=nil] @function success callback, Callback to call once the force is created. The callback will be passed the created military force leader's cqi and the military force cqi.
--- @p [opt=false] @boolean command queue, Use command queue.
--- @example cm:create_force(
--- @example 	"wh_main_dwf_dwarfs",
--- @example 	"wh_main_dwf_inf_hammerers,wh_main_dwf_inf_longbeards_1,wh_main_dwf_inf_quarrellers_0,wh_main_dwf_inf_quarrellers_0",
--- @example 	"wh_main_the_silver_road_karaz_a_karak",
--- @example 	714,
--- @example 	353,
--- @example 	"scripted_force_1",
--- @example 	true,
--- @example 	function(cqi, force_cqi)
--- @example 		out("Force created with char cqi:" .. cqi .. " force cqi:" .. force_cqi);
--- @example 	end
--- @example );
function campaign_manager:create_force(faction_key, unit_list, region_key, x, y, exclude_named_characters, success_callback)
	if not is_string(faction_key) then
		script_error("ERROR: create_force() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string");
		return;
	end;
	
	if not is_string(unit_list) then
		script_error("ERROR: create_force() called but supplied unit list [" .. tostring(unit_list) .. "] is not a string");
		return;
	end;
	
	if unit_list == "" then
		script_error("ERROR: create_force() called but supplied unit list [" .. tostring(unit_list) .. "] is an empty string");
		return;
	end;
	
	if not is_string(region_key) then
		script_error("ERROR: create_force() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return;
	end;
	
	if not is_number(x) or x < 0 then
		script_error("ERROR: create_force() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(y) or y < 0 then
		script_error("ERROR: create_force() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a positive number");
		return;
	end;
	
	if not is_boolean(exclude_named_characters) then
		script_error("ERROR: create_force() called but supplied exclude named characters switch [" .. tostring(exclude_named_characters) .. "] is not a boolean value");	
		return;
	end;
	
	if not is_function(success_callback) and not is_nil(success_callback) then
		script_error("ERROR: create_force() called but supplied success callback [" .. tostring(success_callback) .. "] is not a function or nil");
		return;
	end;
	
	local region = cm:get_region(region_key);
	if not is_region(region) then
		script_error("ERROR: create_force() called but supplied region key [" .. tostring(region_key) .. "] is not a valid region");
	end;
	
	-- this is now generated internally, rather than being passed in from the calling function
	local id = tostring(core:get_unique_counter());
	
	local listener_name = "campaign_manager_create_force_" .. id;
	
	-- establish a listener for the force being created
	core:add_listener(
		listener_name,
		"ScriptedForceCreated",
		function(context)
			return context.string == id;
		end,
		function() self:force_created(id, listener_name, faction_key, x, y, success_callback) end,
		false
	);
	
	out("create_force() called:");
	out.inc_tab();
	
	out("faction_key: " .. faction_key);
	out("unit_list: " .. unit_list);
	out("region_key: " .. region_key);
	out("x: " .. tostring(x));
	out("y: " .. tostring(y));
	out("id: " .. id);
	out("exclude_named_characters: " .. tostring(exclude_named_characters));
	
	out.dec_tab();
	
	-- make the call to create the force
	self.game_interface:create_force(faction_key, unit_list, region_key, x, y, id, exclude_named_characters);
end;


--- @function create_force_with_full_diplomatic_discovery
--- @desc Instantly spawn an army with a general on the campaign map. This function is a wrapper for the @episodic_scripting:create_force_with_full_diplomatic_discovery function provided by the episodic scripting interface, adding debug output and success callback functionality.
--- @p @string faction key, Faction key of the faction to which the force is to belong.
--- @p @string unit list, Comma-separated list of keys from the <code>land_units</code> table. The force will be created with these units.
--- @p @string region key, Region key of home region for this force.
--- @p @number x, x logical co-ordinate of force.
--- @p @number y, y logical co-ordinate of force.
--- @p @boolean exclude named characters, Don't spawn a named character at the head of this force.
--- @p [opt=nil] @function success callback, Callback to call once the force is created. The callback will be passed the created military force leader's cqi as a single argument.
--- @p [opt=false] @boolean command queue, Use command queue.
--- @example cm:create_force_with_full_diplomatic_discovery(
--- @example 	"wh_main_dwf_dwarfs",
--- @example 	"wh_main_dwf_inf_hammerers,wh_main_dwf_inf_longbeards_1,wh_main_dwf_inf_quarrellers_0,wh_main_dwf_inf_quarrellers_0",
--- @example 	"wh_main_the_silver_road_karaz_a_karak",
--- @example 	714,
--- @example 	353,
--- @example 	"scripted_force_1",
--- @example 	true,
--- @example 	function(cqi)
--- @example 		out("Force created with char cqi: " .. cqi);
--- @example 	end
--- @example );
function campaign_manager:create_force_with_full_diplomatic_discovery(faction_key, unit_list, region_key, x, y, exclude_named_characters, success_callback)
	if not is_string(faction_key) then
		script_error("ERROR: create_force_with_full_diplomatic_discovery() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string");
		return;
	end;
	
	if not is_string(unit_list) then
		script_error("ERROR: create_force_with_full_diplomatic_discovery() called but supplied unit list [" .. tostring(unit_list) .. "] is not a string");
		return;
	end;
	
	if unit_list == "" then
		script_error("ERROR: create_force_with_full_diplomatic_discovery() called but supplied unit list [" .. tostring(unit_list) .. "] is an empty string");
		return;
	end;
	
	if not is_string(region_key) then
		script_error("ERROR: create_force_with_full_diplomatic_discovery() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return;
	end;
	
	if not is_number(x) or x < 0 then
		script_error("ERROR: create_force_with_full_diplomatic_discovery() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(y) or y < 0 then
		script_error("ERROR: create_force_with_full_diplomatic_discovery() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a positive number");
		return;
	end;
	
	if not is_boolean(exclude_named_characters) then
		script_error("ERROR: create_force_with_full_diplomatic_discovery() called but supplied exclude named characters switch [" .. tostring(exclude_named_characters) .. "] is not a boolean value");	
		return;
	end;
	
	if not is_function(success_callback) and not is_nil(success_callback) then
		script_error("ERROR: create_force_with_full_diplomatic_discovery() called but supplied success callback [" .. tostring(success_callback) .. "] is not a function or nil");
		return;
	end;
	
	local region = cm:get_region(region_key);
	if not is_region(region) then
		script_error("ERROR: create_force_with_full_diplomatic_discovery() called but supplied region key [" .. tostring(region_key) .. "] is not a valid region");
	end;
	
	-- this is now generated internally, rather than being passed in from the calling function
	local id = tostring(core:get_unique_counter());
	
	local listener_name = "campaign_manager_create_force_" .. id;
	
	-- establish a listener for the force being created
	core:add_listener(
		listener_name,
		"ScriptedForceCreated",
		function(context)
			return context.string == id;
		end,
		function() self:force_created(id, listener_name, faction_key, x, y, success_callback) end,
		false
	);
	
	out("create_force_with_full_diplomatic_discovery() called:");
	out.inc_tab();
	
	out("faction_key: " .. faction_key);
	out("unit_list: " .. unit_list);
	out("region_key: " .. region_key);
	out("x: " .. tostring(x));
	out("y: " .. tostring(y));
	out("id: " .. id);
	out("exclude_named_characters: " .. tostring(exclude_named_characters));
	
	out.dec_tab();
	
	-- make the call to create the force
	self.game_interface:create_force_with_full_diplomatic_discovery(faction_key, unit_list, region_key, x, y, id, exclude_named_characters);
end;


--- @function create_force_with_general
--- @desc Instantly spawns an army with a specific general on the campaign map. This function is a wrapper for the @episodic_scripting:create_force_with_general function provided by the underlying episodic scripting interface, adding debug output and success callback functionality.
--- @p string faction key, Faction key of the faction to which the force is to belong.
--- @p string unit list, Comma-separated list of keys from the <code>land_units</code> table. The force will be created with these units. This can be a blank string, or nil, if an empty force is desired.
--- @p string region key, Region key of home region for this force.
--- @p number x, x logical co-ordinate of force.
--- @p number y, y logical co-ordinate of force.
--- @p string agent type, Character type of character at the head of the army (should always be "general"?).
--- @p string agent subtype, Character subtype of character at the head of the army.
--- @p string forename, Localised string key of the created character's forename. This should be given in the localised text lookup format i.e. a key from the <code>names</code> table with "names_name_" prepended.
--- @p string clan name, Localised string key of the created character's clan name. This should be given in the localised text lookup format i.e. a key from the <code>names</code> table with "names_name_" prepended.
--- @p string family name, Localised string key of the created character's family name. This should be given in the localised text lookup format i.e. a key from the <code>names</code> table with "names_name_" prepended.
--- @p string other name, Localised string key of the created character's other name. This should be given in the localised text lookup format i.e. a key from the <code>names</code> table with "names_name_" prepended.
--- @p boolean make faction leader, Make the spawned character the faction leader.
--- @p [opt=nil] function success callback, Callback to call once the force is created. The callback will be passed the created military force leader's cqi as a single argument.
--- @p [opt=false] boolean force diplomatic discovery, forces the created faction to have diplomatic discovery - set to true if you expect the faction to automatically declare war on factions it meets once spawned.
--- @example cm:create_force_with_general(
--- @example 	"wh_main_dwf_dwarfs",
--- @example 	"wh_main_dwf_inf_hammerers,wh_main_dwf_inf_longbeards_1,wh_main_dwf_inf_quarrellers_0,wh_main_dwf_inf_quarrellers_0",
--- @example 	"wh_main_the_silver_road_karaz_a_karak",
--- @example 	714,
--- @example 	353,
--- @example 	"general",
--- @example 	"dwf_lord",
--- @example 	"names_name_2147344345",
--- @example 	"",
--- @example 	"names_name_2147345842",
--- @example 	"",
--- @example 	"scripted_force_1",
--- @example 	false,
--- @example 	function(cqi)
--- @example 		out("Force created with char cqi: " .. cqi);
--- @example 	end
--- @example );
function campaign_manager:create_force_with_general(faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, make_faction_leader, success_callback, force_diplomatic_discovery)
	if not is_string(faction_key) then
		script_error("ERROR: create_force_with_general() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string");
		return;
	end;

	if not unit_list then
		unit_list = "";
	elseif not is_string(unit_list) then
		script_error("ERROR: create_force_with_general() called but supplied unit list [" .. tostring(unit_list) .. "] is not a string");
		return;
	end;
		
	if not is_string(region_key) then
		script_error("ERROR: create_force_with_general() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return;
	end;
	
	if not is_number(x) or x < 0 then
		script_error("ERROR: create_force_with_general() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(y) or y < 0 then
		script_error("ERROR: create_force_with_general() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a positive number");
		return;
	end;
	
	if not is_string(agent_type) then
		script_error("ERROR: create_force_with_general() called but supplied agent_type [" .. tostring(agent_type) .. "] is not a string");
		return;
	end;
	
	if not is_string(agent_subtype) then
		script_error("ERROR: create_force_with_general() called but supplied agent_subtype [" .. tostring(agent_subtype) .. "] is not a string");
		return;
	end;
	
	if not is_string(forename) then
		script_error("ERROR: create_force_with_general() called but supplied forename [" .. tostring(forename) .. "] is not a string");
		return;
	end;
	
	if not is_string(clan_name) then
		script_error("ERROR: create_force_with_general() called but supplied clan_name [" .. tostring(clan_name) .. "] is not a string");
		return;
	end;
	
	if not is_string(family_name) then
		script_error("ERROR: create_force_with_general() called but supplied family_name [" .. tostring(family_name) .. "] is not a string");
		return;
	end;
	
	if not is_string(other_name) then
		script_error("ERROR: create_force_with_general() called but supplied other_name [" .. tostring(other_name) .. "] is not a string");
		return;
	end;
	
	if not is_boolean(make_faction_leader) then
		script_error("ERROR: create_force() called but supplied make faction leader switch [" .. tostring(make_faction_leader) .. "] is not a boolean value");
		return;
	end;
	
	if not is_function(success_callback) and not is_nil(success_callback) then
		script_error("ERROR: create_force_with_general() called but supplied success callback [" .. tostring(success_callback) .. "] is not a function or nil");
		return;
	end;
		
	local faction = cm:get_faction(faction_key);
	
	if not is_faction(faction) then
		script_error("ERROR: create_force_with_general() called but supplied faction [" .. tostring(faction_key) .. "] could not be found");
		return;
	end;
	
	local region = cm:get_region(region_key);
	if not is_region(region) then
		script_error("ERROR: create_force_with_general() called but supplied region key [" .. tostring(region_key) .. "] is not a valid region");
	end;
	
	force_diplomatic_discovery = not not force_diplomatic_discovery;
	
	-- this is now generated internally, rather than being passed in from the calling function
	local id = tostring(core:get_unique_counter());
	
	local listener_name = "campaign_manager_create_force_" .. id;
	local num_forces = faction:military_force_list():num_items();
	
	core:add_listener(
		listener_name,
		"ScriptedForceCreated",
		function(context) return context.string == id end,
		function() self:force_created(id, listener_name, faction_key, x, y, success_callback) end,
		false
	);
	
	out("create_force_with_general() called:");
	out.inc_tab();
	
	out("faction_key: " .. faction_key);
	out("unit_list: " .. unit_list);
	out("region_key: " .. region_key);
	out("x: " .. tostring(x));
	out("y: " .. tostring(y));
	out("agent_type: " .. agent_type);
	out("agent_subtype: " .. agent_subtype);
	out("forename: " .. forename);
	out("clan_name: " .. clan_name);
	out("family_name: " .. family_name);
	out("other_name: " .. other_name);
	out("id: " .. id);
	out("make_faction_leader: " .. tostring(make_faction_leader));
	out("force_diplomatic_discovery: " .. tostring(force_diplomatic_discovery));
	
	out.dec_tab();
	
	-- make the call to create the force
	self.game_interface:create_force_with_general(faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, force_diplomatic_discovery);
end;


--- @function create_force_with_existing_general
--- @desc Instantly spawn an army with a specific existing general on the campaign map. This function is a wrapper for the @episodic_scripting:create_force_with_existing_general function provided by the underlying episodic scripting interface, adding debug output and success callback functionality. The general character is specified by character string lookup.
--- @p string character lookup, Character lookup string for the general character.
--- @p string faction key, Faction key of the faction to which the force is to belong.
--- @p string unit list, Comma-separated list of keys from the <code>land_units</code> table. The force will be created with these units.
--- @p string region key, Region key of home region for this force.
--- @p number x, x logical co-ordinate of force.
--- @p number y, y logical co-ordinate of force.
--- @p [opt=nil] function success callback, Callback to call once the force is created. The callback will be passed the created military force leader's cqi as a single argument.
--- @example cm:create_force_with_existing_general(
--- @example 	cm:char_lookup_str(char_dwf_faction_leader),
--- @example 	"wh_main_dwf_dwarfs",
--- @example 	"wh_main_dwf_inf_hammerers,wh_main_dwf_inf_longbeards_1,wh_main_dwf_inf_quarrellers_0,wh_main_dwf_inf_quarrellers_0",
--- @example 	"wh_main_the_silver_road_karaz_a_karak",
--- @example 	714,
--- @example 	353,
--- @example 	function(cqi)
--- @example 		out("Force created with char cqi: " .. cqi);
--- @example 	end
--- @example );
function campaign_manager:create_force_with_existing_general(char_str, faction_key, unit_list, region_key, x, y, success_callback)
	if not is_string(char_str) then
		script_error("ERROR: create_force_with_existing_general() called but supplied character string [" .. tostring(char_str) .. "] is not a string");
		return;
	end;
	
	if not is_string(faction_key) then
		script_error("ERROR: create_force_with_existing_general() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string");
		return;
	end;
	
	if not is_string(unit_list) then
		script_error("ERROR: create_force_with_existing_general() called but supplied unit list [" .. tostring(unit_list) .. "] is not a string");
		return;
	end;
	
	if unit_list == "" then
		script_error("ERROR: create_force() called but supplied unit list [" .. tostring(unit_list) .. "] is an empty string");
		return;
	end;
	
	if not is_string(region_key) then
		script_error("ERROR: create_force_with_existing_general() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return;
	end;
	
	if not is_number(x) or x < 0 then
		script_error("ERROR: create_force_with_existing_general() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(y) or y < 0 then
		script_error("ERROR: create_force_with_existing_general() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a positive number");
		return;
	end;
	
	if not is_function(success_callback) and not is_nil(success_callback) then
		script_error("ERROR: create_force_with_existing_general() called but supplied success callback [" .. tostring(success_callback) .. "] is not a function or nil");
		return;
	end;
		
	local faction = cm:get_faction(faction_key);
	
	if not is_faction(faction) then
		script_error("ERROR: create_force_with_existing_general() called but supplied faction [" .. tostring(faction_key) .. "] could not be found");
		return;
	end;
	
	local region = cm:get_region(region_key);
	if not is_region(region) then
		script_error("ERROR: create_force_with_existing_general() called but supplied region key [" .. tostring(region_key) .. "] is not a valid region");
	end;
	
	-- this is now generated internally, rather than being passed in from the calling function
	local id = tostring(core:get_unique_counter());
	
	local listener_name = "campaign_manager_create_force_" .. id;
	local num_forces = faction:military_force_list():num_items();
	
	core:add_listener(
		listener_name,
		"ScriptedForceCreated",
		function(context) return context.string == id end,
		function() self:force_created(id, listener_name, faction_key, x, y, success_callback) end,
		false
	);
	
	out("create_force_with_existing_general() called:");
	out.inc_tab();
	
	out("char_str: " .. char_str);
	out("faction_key: " .. faction_key);
	out("unit_list: " .. unit_list);
	out("region_key: " .. region_key);
	out("x: " .. tostring(x));
	out("y: " .. tostring(y));
	out("id: " .. id);
	
	out.dec_tab();
	
	-- make the call to create the force
	self.game_interface:create_force_with_existing_general(char_str, faction_key, unit_list, region_key, x, y, id);
end;


-- called by create_force() commands above when a force has been created, either directly (if the force was not created via the command
-- queue) or via the ScriptedForceCreated event (if the force was created via the command queue). This attempts to find the newly-created 
-- character and returns its cqi to the calling code.
function campaign_manager:force_created(id, listener_name, faction_key, x, y, success_callback)
	if not is_function(success_callback) then
		return;
	end;
	
	-- find the cqi of the force just created
	local character_list = cm:get_faction(faction_key):character_list();
	for i = 0, character_list:num_items() - 1 do
		local char = character_list:item_at(i);
		if char:logical_position_x() == x and char:logical_position_y() == y then
			
			if char:has_military_force() and char:military_force():has_general() then
				-- we have found it, remove this listener, call the success callback with the character cqi as parameter and exit
				core:remove_listener(listener_name);
				local cqi = char:cqi();
				local force_cqi = char:military_force():command_queue_index();
				success_callback(cqi, force_cqi);
				return cqi, force_cqi;
			end;
		end;
	end;
	
	return false;
end;


--- @function create_agent
--- @desc Creates an agent of a specified type on the campaign map.This function is a wrapper for the @episodic_scripting:create_agent function provided by the underlying episodic scripting interface. This wrapper function adds validation.
--- @p string faction key, Faction key of the faction to which the agent is to belong.
--- @p string character type, Character type of the agent.
--- @p string character subtype, Character subtype of the agent.
--- @p number x, x logical co-ordinate of agent.
--- @p number y, y logical co-ordinate of agent.
--- @p [opt=false] boolean disable_auto_select, if set to true it will prevent the game automatically selecting the agent on creation.
--- @r @character interface Returns newly-created character if successful, false if not. 
--- @example cm:create_agent(
--- @example 	"wh_main_dwf_dwarfs",
--- @example 	"wh_main_the_silver_road_karaz_a_karak",
--- @example 	714,
--- @example 	353
--- @example );
function campaign_manager:create_agent(faction_key, agent_key, subtype_key, x, y, disable_auto_select)
	disable_auto_select = disable_auto_select or false
	if not is_string(faction_key) then
		script_error("ERROR: create_agent() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string");
		return;
	end;
	
	if not is_string(agent_key) then
		script_error("ERROR: create_agent() called but supplied agent key [" .. tostring(agent_key) .. "] is not a string");
		return;
	end;
	
	if not is_string(subtype_key) then
		script_error("ERROR: create_agent() called but supplied agent subtype key [" .. tostring(subtype_key) .. "] is not a string");
		return;
	end;
	
	if not is_number(x) or x < 0 then
		script_error("ERROR: create_agent() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(y) or y < 0 then
		script_error("ERROR: create_agent() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a positive number");
		return;
	end;

		
	local faction = cm:get_faction(faction_key);
	
	if not is_faction(faction) then
		script_error("ERROR: create_agent() called but supplied faction [" .. tostring(faction_key) .. "] could not be found");
		return;
	end;
	
	-- this is now generated internally, rather than being passed in from the calling function
	local id = tostring(core:get_unique_counter());

	out("create_agent() called:");
	out.inc_tab();
	
	out("faction_key: " .. faction_key);
	out("agent_key: " .. agent_key);
	out("subtype_key: " .. subtype_key);
	out("x: " .. tostring(x));
	out("y: " .. tostring(y));
	out("id: " .. id);
	
	out.dec_tab();

	if disable_auto_select then
		uim:override("selection_change"):lock()
	end
	
	-- make the call to create the agent
	local new_agent_interface = self.game_interface:create_agent(faction_key, agent_key, subtype_key, x, y, id);

	if disable_auto_select then
		uim:override("selection_change"):unlock()
	end

	if not new_agent_interface or new_agent_interface:is_null_interface() then
		script_error("ERROR: create_agent() called for agent subtype "..subtype_key.." at "..tostring(x)..", "..tostring(y).." but code was unable to spawn agent!");
		return false;
	end

	return new_agent_interface;
end;


--- @function kill_character
--- @desc Kills the specified character, with the ability to also destroy their whole force if they are commanding one. The character may be specified by a lookup string or by character cqi.
--- @p @string character lookup string, Character string of character to kill. This uses the standard character string lookup system. Alternatively, a @number may be supplied, which specifies a character cqi.
--- @p [opt=false] @boolean destroy force, Will also destroy the characters whole force if true.
function campaign_manager:kill_character(character_lookup_value, destroy_force)
	destroy_force = destroy_force or false;

	-- If the lookup value is a string pass it straight to code and exit
	if is_string(character_lookup_value) then
		self.game_interface:kill_character(character_lookup_value, destroy_force);
		return;
	end;

	if not is_number(character_lookup_value) then
		script_error("ERROR: kill_character() called but supplied character cqi [" .. tostring(character_lookup_value) .. "] is not a number or a string");
		return false;
	end;
	
	if self:model():has_character_command_queue_index(character_lookup_value) == true then
		local character_obj = self:model():character_for_command_queue_index(character_lookup_value);
		
		if character_obj:is_null_interface() == false then
			local lookup = "character_cqi:"..character_lookup_value;
			
			-- If this character has a force then they also currently have a unit so to kill the character AND the unit too we need to use a bespoke function
			if character_obj:has_military_force() == true then
				if destroy_force then
					out("* killing character with cqi [" .. character_lookup_value .. "], their unit, and their military force");
				else
					out("* killing character with cqi [" .. character_lookup_value .. "], their unit, but not their military force");
				end;
				self.game_interface:kill_character_and_commanded_unit(lookup, destroy_force);
			else
				out("* killing character with cqi [" .. character_lookup_value .. "] (this character has no military force)");
				self.game_interface:kill_character(lookup, destroy_force);
			end
			return true;
		end;
	else
		out("* kill_character() called for character with cqi [" .. character_lookup_value .. "] but no such character could be found, continuing");
	end
	return false;
end


--- @function add_building_to_force
--- @desc Adds one or more buildings to a horde army. The army is specified by the command queue index of the military force. A single building may be specified by a string key, or multiple buildings in a table.
--- @p number military force cqi, Command queue index of the military force to add the building(s) to.
--- @p object building(s), Building key or keys to add to the military force. This can be a single string or a numerically-indexed table.
function campaign_manager:add_building_to_force(cqi, building_level)
	if not is_number(cqi) then
		script_error("ERROR: add_building_to_force() called but supplied cqi [" .. tostring(cqi) .. "] is not a number");
		return false;
	end;
	
	if is_string(building_level) then
		out("add_building_to_force() called, adding building level [" .. building_level .. "] to military force cqi [" .. cqi .. "]");
		
		self.game_interface:add_building_to_force(cqi, building_level);
	elseif is_table(building_level) then
		out("add_building_to_force() called, adding buildings military force cqi [" .. cqi .. "]");
		
		for i = 1, #building_level do
			local current_building_level = building_level[i];
			
			if is_string(current_building_level) then
				out("\tAdding building level [" .. current_building_level .. "]");
				
				self.game_interface:add_building_to_force(cqi, current_building_level);
			else
				script_error("ERROR: add_building_to_force() called but supplied building_level table element [" .. tostring(current_building_level) .. "] is not a string");
				return false;
			end;
		end;
		
		out("add_building_to_force() finished adding buildings");
	else
		script_error("ERROR: add_building_to_force() called but supplied building_level [" .. tostring(building_level) .. "] is not a string or table");
		return false;
	end;
end;


--- @function reposition_starting_character_for_faction
--- @desc Repositions a specified character (the <i>target</i>) for a faction at start of a campaign, but only if another character (the <i>subject</i>) exists in that faction and is in command of an army. Like @campaign_manager:teleport_to which underpins this function it is for use at the start of a campaign in a game-created callback (see @campaign_manager:add_pre_first_tick_callback). It is intended for use in very specific circumstances.
--- @desc The characters involved are specified by forename key.
--- @p string faction key, Faction key of the subject and target characters.
--- @p string forename key, Forename key of the subject character from the names table using the full localisation format i.e. <code>names_name_[key]</code>.
--- @p string forename key, Forename key of the target character from the names table using the full localisation format i.e. <code>names_name_[key]</code>.
--- @p number x, x logical target co-ordinate.
--- @p number y, y logical target co-ordinate.
--- @r boolean Subject character exists.
--- @example cm:add_pre_first_tick_callback(
--- @example 	function()
--- @example 		cm:reposition_starting_character_for_faction(
--- @example 			"wh_dlc03_bst_beastmen", 
--- @example 			"names_name_2147357619", 
--- @example 			"names_name_2147357619", 
--- @example 			643, 
--- @example 			191
--- @example 		)
--- @example 	end
--- @example )
function campaign_manager:reposition_starting_character_for_faction(faction_name, subject_lord_forename, target_lord_forename, new_pos_x, new_pos_y)
	local faction = cm:get_faction(faction_name);
	
	if not faction then
		script_error("ERROR: reposition_starting_character_for_faction() called but couldn't find faction with supplied name [" .. tostring(faction_name) .. "]");
		return false;
	end;
	
	if not is_string(subject_lord_forename) then
		script_error("ERROR: reposition_starting_character_for_faction() called but supplied lord name [" .. tostring(subject_lord_forename) .. "] is not a string");
		return false;
	end;
	
	if not is_string(target_lord_forename) then
		script_error("ERROR: reposition_starting_character_for_faction() called but supplied lord name [" .. tostring(target_lord_forename) .. "] is not a string");
		return false;
	end;
	
	if not is_number(new_pos_x) or new_pos_x < 0 then
		script_error("ERROR: reposition_starting_character_for_faction() called but supplied x co-ordinate [" .. tostring(new_pos_x) .. "] is not a positive number");
		return false;
	end;
	
	if not is_number(new_pos_y) or new_pos_y < 0 then
		script_error("ERROR: reposition_starting_character_for_faction() called but supplied y co-ordinate [" .. tostring(new_pos_y) .. "] is not a positive number");
		return false;
	end;
	
	-- get character and see if it has an army
	local char_list = faction:character_list();
	
	for i = 0, char_list:num_items() - 1 do
		local current_subject_char = char_list:item_at(i);
		
		if current_subject_char:get_forename() == subject_lord_forename then
			if self:char_is_general_with_army(current_subject_char) then
				
				-- try and find the target char
				local target_char = false;
				if subject_lord_forename == target_lord_forename then
					target_char = current_subject_char;
				else
					-- the subject char and target char are different, go searching for the latter
					for j = 0, char_list:num_items() - 1 do
						local current_target_char = char_list:item_at(j);
						if current_target_char:get_forename() == target_lord_forename then
							target_char = current_target_char;
							break;
						end;
					end;
				end;
				
				if target_char then			
					out("Teleporting starting Lord with name " .. target_lord_forename .. " for faction " .. faction_name .. " to [" .. new_pos_x .. ", " .. new_pos_y .. "]");
					self:teleport_to(self:char_lookup_str(target_char), new_pos_x, new_pos_y);
				else
					script_error("WARNING: reposition_starting_character_for_faction() wanted to perform teleport but could find no character in faction " .. faction_name .. " with name " .. target_lord_forename);
				end;
			end;
			return true;
		end;
	end;
end;


--- @function spawn_army_starting_character_for_faction
--- @desc Spawns a specified force if a character (the <i>subject</i>) exists within a faction with an army. It is intended for use at the start of a campaign in a game-created callback (see @campaign_manager:add_pre_first_tick_callback), in very specific circumstances.
--- @p string faction key, Faction key of the subject character.
--- @p string forename key, Forename key of the subject character from the names table using the full localisation format i.e. <code>names_name_[key]</code>.
--- @p string faction key, Faction key of the force to create.
--- @p string units, list of units to create force with (see documentation for @campaign_manager:create_force for more information).
--- @p string region key, Home region key for the created force.
--- @p number x, x logical target co-ordinate.
--- @p number y, y logical target co-ordinate.
--- @p boolean make_immortal, Set to <code>true</code> to make the created character immortal.
--- @example cm:add_pre_first_tick_callback(
--- @example 	function()
--- @example 		cm:spawn_army_starting_character_for_faction(
--- @example 			"wh_dlc03_bst_beastmen",
--- @example 			"names_name_2147352487",
--- @example 			"wh_dlc03_bst_jagged_horn",
--- @example 			"wh_dlc03_bst_inf_ungor_herd_1,wh_dlc03_bst_inf_ungor_herd_1,wh_dlc03_bst_inf_ungor_raiders_0",
--- @example 			"wh_main_estalia_magritta",
--- @example 			643,
--- @example 			188,
--- @example 			true
--- @example 		)
--- @example 	end
--- @example )
function campaign_manager:spawn_army_starting_character_for_faction(source_faction_name, subject_lord_forename, army_faction_name, army_units, army_home_region, pos_x, pos_y, make_immortal)
	local source_faction = cm:get_faction(source_faction_name);
	local army_faction = cm:get_faction(army_faction_name);
	
	if not source_faction then
		script_error("ERROR: spawn_army_starting_character_for_faction() called but couldn't find source faction with supplied name [" .. tostring(source_faction_name) .. "]");
		return false;
	end;
	
	if not army_faction then
		script_error("ERROR: spawn_army_starting_character_for_faction() called but couldn't find faction with supplied name [" .. tostring(army_faction_name) .. "]");
		return false;
	end;
	
	if not is_string(subject_lord_forename) then
		script_error("ERROR: spawn_army_starting_character_for_faction() called but supplied lord name [" .. tostring(subject_lord_forename) .. "] is not a string");
		return false;
	end;
	
	if not is_string(army_units) then
		script_error("ERROR: spawn_army_starting_character_for_faction() called but supplied army units [" .. tostring(army_units) .. "] is not a string");
		return false;
	end;
	
	if not is_string(army_home_region) then
		script_error("ERROR: spawn_army_starting_character_for_faction() called but supplied army home region [" .. tostring(army_home_region) .. "] is not a string");
		return false;
	end;
	
	if not is_number(pos_x) or pos_x < 0 then
		script_error("ERROR: spawn_army_starting_character_for_faction() called but supplied x co-ordinate [" .. tostring(pos_x) .. "] is not a positive number");
		return false;
	end;
	
	if not is_number(pos_y) or pos_y < 0 then
		script_error("ERROR: spawn_army_starting_character_for_faction() called but supplied y co-ordinate [" .. tostring(pos_y) .. "] is not a positive number");
		return false;
	end;
	
	-- get character and see if it has an army
	local char_list = source_faction:character_list();
	
	for i = 0, char_list:num_items() - 1 do
		local current_subject_char = char_list:item_at(i);
		
		if current_subject_char:get_forename() == subject_lord_forename then
			if self:char_is_general_with_army(current_subject_char) then	
				out("Found character " .. subject_lord_forename .. " in faction " .. source_faction_name);
				
				self:create_force(
					army_faction_name,
					army_units,
					army_home_region,
					pos_x,
					pos_y,
					true,
					function(cqi)
						if make_immortal then
							local char_str = self:char_lookup_str(cqi);
							self:set_character_immortality(char_str, true);
						end;
					end
				);
			else
				return;	-- we found the general, but he does not command an army
			end;
			
			return;
		end;
	end;
end;



--- @function move_character
--- @desc Helper function to move a character.
--- @p number cqi, Command-queue-index of the character to move.
--- @p number x, x co-ordinate of the intended destination.
--- @p number y, y co-ordinate of the intended destination.
--- @p [opt=false] boolean should replenish, Automatically replenish the character's action points in script should they run out whilst moving. This ensures the character will reach their intended destination in one turn (unless they fail for another reason).
--- @p [opt=true] boolean allow post movement, Allow the army to move after the order is successfully completed. Setting this to <code>false</code> disables character movement with @campaign_manager:disable_movement_for_character should the character successfully reach their destination.
--- @p [opt=nil] function success callback, Callback to call if the character successfully reaches the intended destination this turn.
--- @p [opt=nil] function fail callback, Callback to call if the character fails to reach the intended destination this turn.
function campaign_manager:move_character(char_cqi, log_x, log_y, should_replenish, allow_movement_afterwards, success_callback, fail_callback)
	
	if not is_number(char_cqi) and not is_string(char_cqi) then
		script_error("move_character ERROR: cqi provided [" .. tostring(char_cqi) .. "] is not a number or string");
		return false;
	end;
		
	if not is_number(log_x) or log_x < 0 then
		script_error("move_character ERROR: supplied logical x co-ordinate [" .. tostring(log_x) .. "] is not a positive number");
		return false;
	end;
	
	if not is_number(log_y) or log_y < 0 then
		script_error("move_character ERROR: supplied logical y co-ordinate [" .. tostring(log_x) .. "] is not a positive number");
		return false;
	end;
	
	if not is_function(success_callback) and not is_nil(success_callback) then
		script_error("move_character ERROR: supplied success callback [" .. tostring(success_callback) .. "] is not a function or nil");
		return false;
	end;
	
	if not is_function(fail_callback) and not is_nil(fail_callback) then
		script_error("move_character ERROR: supplied failure callback [" .. tostring(fail_callback) .. "] is not a function or nil");
		return false;
	end;
	
	should_replenish = not not should_replenish;
	
	if allow_movement_afterwards ~= false then
		allow_movement_afterwards = true;
	end;
	
	out.inc_tab();
	
	local char_str = self:char_lookup_str(char_cqi);
	local trigger_name = "move_character_" .. char_str .. "_" .. tostring(self.move_character_trigger_count);
	self.move_character_trigger_count = self.move_character_trigger_count + 1;
	
	-- if should_replenish is set the establish a listener for the character running out of movement points
	--[[
	if should_replenish then
		self:replenish_action_points(char_str);
		
		-- listen for the army running out of movement points
		core:add_listener(
			trigger_name,
			"MovementPointsExhausted",
			-- function(context) return context:character():cqi() == char_cqi end,
			true,
			function()
				out("move_character() :: MovementPointsExhausted event has occurred, replenishing character action points and moving it to destination");
				self:replenish_action_points(char_str);
				self:move_to(char_str, log_x, log_y);
			end,
			true
		);
	end;
	]]
	
	out("move_character() moving character (" .. char_str .. ") to [" .. log_x .. ", " .. log_y .. "]");
	
	self:enable_movement_for_character(char_str);
	self:move_to(char_str, log_x, log_y);
	
	-- add this trigger to the active list, for if we wish to cancel it
	table.insert(self.move_character_active_list, trigger_name);
	
	-- set up this notification to catch the character halting without reaching the destination
	self:notify_on_character_movement(
		"move_character_" .. char_cqi,
		char_cqi,
		function()
			self:notify_on_character_halt(
				char_cqi, 
				function()
					core:remove_listener(trigger_name);
					self:move_character_halted(char_cqi, log_x, log_y, should_replenish, allow_movement_afterwards, success_callback, fail_callback);
				end
			);
		end
	);
	
	out.dec_tab();
end;


--	a character moved by move_character has finished moving for some reason
function campaign_manager:move_character_halted(char_cqi, log_x, log_y, should_replenish, allow_movement_afterwards, success_callback, fail_callback)
	
	self:stop_notify_on_character_halt(char_cqi);
	
	local character = self:get_character_by_cqi(char_cqi);
	
	if not character then
		script_error("ERROR: move_character_halted() called but couldn't find a character with cqi [" .. tostring(char_cqi) .."]");
		return false;
	end;
	
	-- if we're not within 3 hexes of our intended destination, then call the failure callback (unless we weren't supplied one, in which case just call the success callback)
	if distance_squared(log_x, log_y, character:logical_position_x(), character:logical_position_y()) > 9 then		
		if is_function(fail_callback) then
			fail_callback();
		elseif is_function(success_callback) then
			success_callback(false);
		end;
	else
		if is_function(success_callback) then
			success_callback(true);
		end;
	end;
end;


--	a character moved by move_character has arrived at its destination
function campaign_manager:move_character_arrived(char_cqi, log_x, log_y, should_replenish, allow_movement_afterwards, success_callback, fail_callback, trigger_name)
	
	self:stop_notify_on_character_halt(char_cqi);
	core:remove_listener(trigger_name);
	
	out.inc_tab();

	local char_str = self:char_lookup_str(char_cqi);
	
	core:remove_listener(trigger_name);
	
	-- remove this trigger from the active list
	for i = 1, #self.move_character_active_list do
		if self.move_character_active_list[i] == trigger_name then
			table.remove(self.move_character_active_list, i);
			break;
		end;
	end;
	
	out("Character (" .. char_str .. ") has arrived");
	
	if not allow_movement_afterwards then
		self:disable_movement_for_character(char_str);
	end;
	
	out.dec_tab();
	
	if is_function(success_callback) then
		success_callback();
	end;
end;


--- @function cancel_all_move_character
--- @desc Cancels any running monitors started by @campaign_manager:move_character. This won't actually stop any characters currently moving.
function campaign_manager:cancel_all_move_character()
	for i = 1, #self.move_character_active_list do
		core:remove_listener(self.move_character_active_list[i]);
	end;
	
	self.move_character_active_list = {};
end;


--- @function is_character_moving
--- @desc Calls one callback if a specified character is currently moving, and another if it's not. It does this by recording the character's position, waiting half a second and then comparing the current position with that just recorded.
--- @p number cqi, Command-queue-index of the subject character.
--- @p function moving callback, Function to call if the character is determined to be moving.
--- @p function not moving callback, Function to call if the character is determined to be stationary.
function campaign_manager:is_character_moving(char_cqi, is_moving_callback, is_not_moving_callback)
		
	if not is_number(char_cqi) then
		script_error("ERROR: is_character_moving() called but supplied cqi [" .. tostring(char_cqi) .. "] is not a number");
		return false;
	end;
	
	local cached_char = self:get_character_by_cqi(char_cqi);

	if not is_character(cached_char) then
		script_error("ERROR: is_character_moving() called but couldn't find char with cqi of [" .. char_cqi .. "]");
		return false;
	end;
	
	local cached_pos_x = cached_char:logical_position_x();
	local cached_pos_y = cached_char:logical_position_y();
	
	local callback_name = "is_character_moving_" .. self:char_lookup_str(char_cqi);
	
	self:callback(
		function()
			local current_char = self:get_character_by_cqi(char_cqi);
			
			if not is_character(current_char) then
				-- script_error("WARNING: is_character_moving_action() called but couldn't find char with cqi of [" .. char_cqi .. "] after movement - did it die?");
				return false;
			end;
			
			local current_pos_x = current_char:logical_position_x();
			local current_pos_y = current_char:logical_position_y();
			
			if cached_pos_x == current_pos_x and cached_pos_y == current_pos_y then
				-- character hasn't moved
				if is_function(is_not_moving_callback) then
					is_not_moving_callback();
				end;
			else
				-- character has moved
				if is_function(is_moving_callback) then
					is_moving_callback();
				end;
			end;
		end,
		0.5,
		callback_name
	);
end;


--- @function stop_is_character_moving
--- @desc Stops any running monitor started with @campaign_manager:is_character_moving, by character. Note that once the monitor completes (half a second after it was started) it will automatically shut itself down.
--- @p number cqi, Command-queue-index of the subject character.
function campaign_manager:stop_is_character_moving(char_cqi)
	local callback_name = "is_character_moving_" .. self:char_lookup_str(char_cqi);
	
	self:remove_callback(callback_name);
end;


--- @function notify_on_character_halt
--- @desc Calls the supplied callback as soon as a character is determined to be stationary. This uses @campaign_manager:is_character_moving to determine if the character moving so the callback will not be called the instant the character halts.
--- @p number cqi, Command-queue-index of the subject character.
--- @p function callback, Callback to call.
--- @p [opt=false] boolean must move first, If true, the character must be seen to be moving before this monitor will begin. In this case, it will only call the callback once the character has stopped again.
function campaign_manager:notify_on_character_halt(char_cqi, callback, must_move_first)
	if not is_function(callback) then
		script_error("ERROR: notify_on_character_halt() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	must_move_first = not not must_move_first;
	
	if must_move_first then
		-- character must be seen to have moved
		self:is_character_moving(
			char_cqi,
			function()
				-- character is now moving, notify when they stop
				self:is_character_moving(
					char_cqi, 
					function()
						self:notify_on_character_halt(char_cqi, callback, false);
					end,
					function()
						callback(char_cqi);
					end
				);
			end,
			function()
				self:notify_on_character_halt(char_cqi, callback, must_move_first);
			end
		);
	else
		-- can return immediately if the character's stationary
		self:is_character_moving(
			char_cqi, 
			function()
				self:notify_on_character_halt(char_cqi, callback);
			end,
			function()
				callback(char_cqi);
			end
		);
	end;
end;


--- @function stop_notify_on_character_halt
--- @desc Stops any monitor started by @campaign_manager:notify_on_character_halt, by character cqi.
--- @p number cqi, Command-queue-index of the subject character.
function campaign_manager:stop_notify_on_character_halt(char_cqi)
	self:stop_is_character_moving(char_cqi);
end;


--- @function notify_on_character_movement
--- @desc Calls the supplied callback as soon as a character is determined to be moving.
--- @p @string process name, name for this movement monitor, by which it can be cancelled later with @campaign_manager:stop_notify_on_character_movement. It is valid to have multiple notification processes with the same name.
--- @p number cqi, Command-queue-index of the subject character.
--- @p function callback, Callback to call.
function campaign_manager:notify_on_character_movement(process_name, char_cqi, callback)
	if not is_string(process_name) then
		script_error("ERROR: notify_on_character_movement() called but supplied process name [" .. tostring(process_name) .. "] is not a string");
		return false
	end;
		
	if not is_number(char_cqi) then
		script_error("ERROR: notify_on_character_movement() called but supplied character cqi [" .. tostring(char_cqi) .. "] is not a number");
		return false;
	end;
	
	local character = self:get_character_by_cqi(char_cqi);
	
	if not character then
		script_error("ERROR: notify_on_character_movement() called but no character with the supplied cqi [" .. tostring(char_cqi) .. "] could be found");
		return false;
	end;
	
	if not is_function(callback) then
		script_error("ERROR: notify_on_character_movement() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	-- create an entry in our active monitors list
	if not self.notify_on_character_movement_active_monitors[process_name] then
		self.notify_on_character_movement_active_monitors[process_name] = {};
	end;
	table.insert(self.notify_on_character_movement_active_monitors[process_name], char_cqi);
		
	local char_x = character:display_position_x();
	local char_y = character:display_position_y();

	local char_is_wounded_on_start = character:is_wounded();
	
	local monitor_name = "notify_on_character_movement_" .. process_name .. "_" .. tostring(char_cqi);
	
	-- poll the character's position and compare it with the cached value
	self:repeat_callback(
		function()
			local current_char = self:get_character_by_cqi(char_cqi);
			
			if current_char then

				local should_notify = false;

				if char_is_wounded_on_start then
					if not current_char:is_wounded() then
						-- Character was wounded but now is not
						should_notify = true;
					end;
				
				else
					if current_char:is_wounded() or (current_char:display_position_x() ~= char_x or current_char:display_position_y() ~= char_y) then
						-- Character was not wounded and now is, or they have moved
						should_notify = true;
					end;
				end;

				if should_notify then
					self:remove_callback(monitor_name);
					callback();
					return;
				end;
			else
				-- character was not found, so stop this process
				self:remove_callback(monitor_name);
			end;
		end,
		0.2,
		monitor_name
	);
end;


--- @function stop_notify_on_character_movement
--- @desc Stops any monitor started by @campaign_manager:notify_on_character_movement, by process name.
--- @p @string process name
function campaign_manager:stop_notify_on_character_movement(process_name)
	local process_table = self.notify_on_character_movement_active_monitors[process_name];

	if not is_table(process_table) or #process_table == 0 then
		return;
	end;
	
	for i = 1, #process_table do
		local monitor_name = "notify_on_character_movement_" .. process_name .. "_" .. tostring(process_table[i]);
		self:remove_callback(monitor_name);
	end;
	
	self.notify_on_character_movement_active_monitors[process_name] = {};
end;


--- @function attack
--- @desc Instruct a character at the head of a military force to attack another. This function is a wrapper for the @episodic_scripting:attack function on the underlying episodic scripting interface. The wrapper also enables movement for the character and prints debug output.
--- @p @string attacker, Attacker character string, uses standard character lookup string system.
--- @p @string defender, Defender character string, uses standard character lookup string system.
--- @p [opt=false] @boolean lay siege, Should the force lay siege.
--- @p [opt=true] @boolean ignore shroud restrictions, Should the attack command ignore shroud restrictions. If this is set to false, the attacker must be able to see the target for the attack to commence.
function campaign_manager:attack(attacker, defender, should_siege, ignore_shroud_restrictions)
	should_siege = not not should_siege;
	ignore_shroud_restrictions = not not ignore_shroud_restrictions;
	
	self:enable_movement_for_character(attacker);
	out("Sending [" .. tostring(attacker) .. "] to attack [" .. tostring(defender) .. "]");	
	self.game_interface:attack(attacker, defender, should_siege, ignore_shroud_restrictions);
end;


--- @function teleport_to
--- @desc Teleports a character to a logical position on the campaign map. This function is a wrapper for the @episodic_scripting:teleport_to function on the underlying episodic scripting interface. This wrapper adds debug output and argument validation.
--- @desc This function can also reposition the camera, so it's best used on game creation to move characters around at the start of the campaign, rather than on the first tick or later.
--- @p string character string, Character string of character to teleport. This uses the standard character string lookup system.
--- @p number x, Logical x co-ordinate to teleport to.
--- @p number y, Logical y co-ordinate to teleport to.
function campaign_manager:teleport_to(char_str, x, y)
	if not is_string(char_str) then
		script_error("ERROR: teleport_to() called but supplied character lookup [" .. tostring(char_str) .. "] is not a string");
		return false;
	end;
	
	if not is_number(x) or x <= 0 then
		script_error("ERROR: teleport_to() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a positive number");
		return false;
	end;
	
	if not is_number(y) or y <= 0 then
		script_error("ERROR: teleport_to() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a positive number");
		return false;
	end;
		
	out("Teleporting [" .. tostring(char_str) .. "] to [" .. x .. ", " .. y .. "]");	
	
	return self.game_interface:teleport_to(char_str, x, y);
end;


--- @function enable_movement_for_character
--- @desc Enables movement for the supplied character. Characters are specified by lookup string. This wraps the @episodic_scripting:enable_movement_for_character function on the underlying episodic scripting interface, but adds validation and output.
--- @p string char lookup string
function campaign_manager:enable_movement_for_character(char_str)
	if not is_string(char_str) then
		script_error("ERROR: enable_movement_for_character() called but supplied character string [" .. tostring(char_str) .. "] is not a string");
		return false;
	end;

	out("** enabling movement for character " .. char_str);
	
	self.game_interface:enable_movement_for_character(char_str);
end;


--- @function disable_movement_for_character
--- @desc Disables movement for the supplied character. Characters are specified by lookup string. This wraps the @episodic_scripting:disable_movement_for_character function on the underlying episodic scripting interface, but adds validation and output.
--- @p string char lookup string
function campaign_manager:disable_movement_for_character(char_str)
	if not is_string(char_str) then
		script_error("ERROR: disable_movement_for_character() called but supplied character string [" .. tostring(char_str) .. "] is not a string");
		return false;
	end;
	
	out("** disabling movement for character " .. char_str);
	
	self.game_interface:disable_movement_for_character(char_str);
end;


--- @function enable_movement_for_faction
--- @desc Enables movement for the supplied faction. This wraps the @episodic_scripting:enable_movement_for_faction function on the underlying episodic scripting interface, but adds validation and output.
--- @p string faction key
function campaign_manager:enable_movement_for_faction(faction_name)
	if not is_string(faction_name) then
		script_error("ERROR: enable_movement_for_faction() called but supplied faction string [" .. tostring(char_str) .. "] is not a string");
		return false;
	end;

	out("** enabling movement for faction " .. faction_name);
	
	self.game_interface:enable_movement_for_faction(faction_name);
end;


--- @function disable_movement_for_faction
--- @desc Disables movement for the supplied faction. This wraps the @episodic_scripting:disable_movement_for_faction function on the underlying episodic scripting interface, but adds validation and output.
--- @p string faction key
function campaign_manager:disable_movement_for_faction(faction_name)
	if not is_string(faction_name) then
		script_error("ERROR: disable_movement_for_faction() called but supplied faction string [" .. tostring(char_str) .. "] is not a string");
		return false;
	end;

	out("** disabling movement for faction " .. faction_name);
	
	self.game_interface:disable_movement_for_faction(faction_name);
end;


--- @function force_add_trait
--- @desc Forceably adds an trait to a character. This wraps the @episodic_scripting:force_add_trait function on the underlying episodic scripting interface, but adds validation and output. This output will be shown in the <code>Lua - Traits</code> debug console spool.
--- @p string character string, Character string of the target character, using the standard character string lookup system.
--- @p string trait key, Trait key to add.
--- @p [opt=false] boolean show message, Show message.
--- @p [opt=1] number points, Trait points to add. The underlying <code>force_add_trait</code> function is called for each point added.
function campaign_manager:force_add_trait(char_str, trait_str, show_msg, points)
	if not is_string(char_str) then
		script_error("ERROR: force_add_trait() called but supplied character string [" .. tostring(char_str) .. "] is not a string");
		return false;
	end;
	
	if not is_string(trait_str) then
		script_error("ERROR: force_add_trait() called but supplied trait string [" .. tostring(trait_str) .. "] is not a string");
		return false;
	end;
	
	show_msg = not not show_msg;
	points = points or 1;
	
	out.traits("* force_add_trait() is adding trait [" .. tostring(trait_str) .. "] to character [" .. tostring(char_str) .. "], showing message: " .. tostring(show_msg) .. ", points: " .. tostring(points));
	
	for i = 1, points do
		self.game_interface:force_add_trait(char_str, trait_str, show_msg);
	end
end;


--- @function add_skill
--- @desc Adds a skill to a character. This wraps the @episodic_scripting:add_skill function on the underlying episodic scripting interface, but adds validation and output. This output will be shown in the <code>Lua - Traits</code> debug console spool.
--- @p character character, Character script interface.
--- @p string skill key, Skill key to add.
--- @p bool ignore_requirements ignore requirements like the need to unlock other skills first.
--- @p bool ignore_skill_points ignore skill points, don't decrease the amount which means adding the skill even if the character doesn't have skill points.
function campaign_manager:add_skill(character, skill_str, ignore_requirements, ignore_skill_points)
		
	if not is_string(skill_str) then
		script_error("ERROR: add_skill() called but supplied skill string [" .. tostring(skill_str) .. "] is not a string");
		return false;
	end;
	
	local char_str = cm:char_lookup_str(character);

	out.traits("* add_skill() is adding skill [" .. tostring(skill_str) .. "] to character [" .. tostring(char_str) .. "]");
	self.game_interface:add_skill(character, skill_str,ignore_requirements, ignore_skill_points);
end;


--- @function add_agent_experience
--- @desc Forceably adds experience to a character. This wraps the @episodic_scripting:add_agent_experience function on the underlying episodic scripting interface, but adds validation and output.
--- @p string character string, Character string of the target character, using the standard character string lookup system.
--- @p number experience, Experience to add.
--- @p [opt=false] boolean by_level, If set to true, the level/rank can be supplied instead of an exact amount of experience which is looked up from a table in the campaign manager
function campaign_manager:add_agent_experience(char_str, exp_to_give, by_level)
	if by_level then
		exp_to_give = self.character_xp_per_level[math.min(exp_to_give, #self.character_xp_per_level)];
	end;
	
	out("add_agent_experience() called, char_str is " .. tostring(char_str) .. " and experience to give is " .. tostring(exp_to_give));
	return self.game_interface:add_agent_experience(char_str, exp_to_give);
end;


--- @function remove_all_units_from_general
--- @desc Removes all units from the military force the supplied general character commands.
--- @p character general character
--- @r number number of units removed
function campaign_manager:remove_all_units_from_general(character)
	
	if not is_character(character) then
		script_error("ERROR: remove_all_units_from_general() called but supplied character [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	if not character:has_military_force() then
		return 0;
	end;
	
	local count = 0;
	local char_str = self:char_lookup_str(character);
	
	local unit_list = character:military_force():unit_list();
	
	for i = 1, unit_list:num_items() - 1 do
		self:remove_unit_from_character(char_str, unit_list:item_at(i):unit_key());
		count = count + 1;
	end;
	
	return count;
end;


--- @function grant_units_to_character_by_position_from_faction
--- @desc Grants one or more units, specified by string key(s), to a military force by character lookup. The military force is specified by its faction key and logical co-ordinates.
--- @p @string faction key, Faction key.
--- @p @number x, Logical x co-ordinate.
--- @p @number y, Logical y co-ordinate.
--- @p ... units, Units to add, specified by one or more @string variables.
function campaign_manager:grant_units_to_character_by_position_from_faction(faction_key, log_x, log_y, ...)
	if not is_string(faction_key) then
		script_error("ERROR: grant_units_to_character_by_position_from_faction() but supplied faction key [" .. tostring(faction_key) .. "] is not a string")
		return false;
	end;
	
	local faction = cm:get_faction(faction_key);
	
	if not faction then
		script_error("ERROR: grant_units_to_character_by_position_from_faction() but no faction with supplied key [" .. faction_key .. "] could be found")
		return false;
	end;
	
	if not is_number(log_x) then
		script_error("ERROR: grant_units_to_character_by_position_from_faction() but supplied x co-ordinate [" .. tostring(x) .. "] is not a number")
		return false;
	end;
	
	if not is_number(log_y) then
		script_error("ERROR: grant_units_to_character_by_position_from_faction() but supplied y co-ordinate [" .. tostring(y) .. "] is not a number")
		return false;
	end;
	
	for i = 1, arg.n do
		if not is_string(arg[i]) then
			script_error("ERROR: grant_units_to_character_by_position_from_faction() but supplied unit key [" .. tostring(arg[i]) .. "] at vararg element [" .. i .. "] is not a string");
			return false;
		end;
	end;
	
	local character = cm:get_closest_general_to_position_from_faction(faction, log_x, log_y);
	
	if not character then
		script_error("ERROR: grant_units_to_character_by_position_from_faction() but no character at position [" .. log_x .. ", " .. log_y .. "] from faction with key [" .. faction_key .. "] could be found");
		return false;
	end;
	
	local character_str = cm:char_lookup_str(character);
	local output_str = "Adding units to character with cqi [" .. character:command_queue_index() .. "], position [" .. log_x .. ", " .. log_y .. "] from faction [" .. faction_key .. "] - units [";
	
	for i = 1, arg.n do
		cm:grant_unit_to_character(character_str, arg[i]);
		if i == arg.n then
			output_str = output_str .. arg[i] .. ",";
		else
			output_str = output_str .. arg[i] .. "]";
		end;
	end;
	
	out(output_str);
end;



-- The amount of xp required for a character to attain each level
-- Ensure this matches the character_experience_skill_tiers table
campaign_manager.character_xp_per_level = {
	0,
	1000,
	2200,
	3600,
	5200,
	7000,
	9000,
	11200,
	13600,
	16200,
	19000,
	21900,
	24900,
	28000,
	31200,
	34500,
	37900,
	41400,
	45000,
	48700,
	52450,
	56250,
	60100,
	64000,
	67950,
	71950,
	76000,
	80100,
	84250,
	88450,
	92675,
	96925,
	101200,
	105500,
	109825,
	114175,
	118550,
	122950,
	127375,
	131825,
	136300,
	140800,
	145325,
	149875,
	154450,
	159050,
	163675,
	168325,
	173000,
	177700
};









-----------------------------------------------------------------------------
--- @section New Character Entered Recruitment Pool Listener
--- @desc Game scripts can listen for a new character entering a recruitment pool using the <code>NewCharacterEnteredRecruitmentPool</code>. However, it is often useful for game scripts to know about characters entering a recruitment pool during campaign startup, which is before they are loaded.
--- @desc The campaign manager now establishes a listener for the <code>NewCharacterEnteredRecruitmentPool</code> event during startup. For any events of this type received during startup, the character details are cached. When the game starts ticking, the system then triggers a <code>ScriptEventNewCharacterEnteredRecruitmentPool</code> event, with the character details available using a <code>character_details</code> method provided by the context.
--- @desc If a <code>NewCharacterEnteredRecruitmentPool</code> event is received after startup, the campaign manager just retriggers a <code>ScriptEventNewCharacterEnteredRecruitmentPool</code> event with the same character details. The net result is that client game scripts can set up listeners for <code>ScriptEventNewCharacterEnteredRecruitmentPool</code> in place of <code>NewCharacterEnteredRecruitmentPool</code>, and get notifications for recruitment pool events that happened even before the client game scripts were loaded.
-----------------------------------------------------------------------------

function campaign_manager:start_new_character_entered_recruitment_pool_listener()

	core:add_listener(
		"new_character_entered_recruitment_pool_listener",
		"NewCharacterEnteredRecruitmentPool",
		true,
		function(context)
			if self.game_is_running then
				-- Game is ticking - just trigger ScriptEventNewCharacterEnteredRecruitmentPool with the same information the NewCharacterEnteredRecruitmentPool event contains
				core:trigger_custom_event("ScriptEventNewCharacterEnteredRecruitmentPool", {character_details = context:character_details()});
			else
				-- Game is not yet ticking ticking - make a record of this character for when it does
				if not self.characters_entered_recruitment_pool_during_startup then
					self.characters_entered_recruitment_pool_during_startup = {};

					-- Add a first-tick callback which trigger a ScriptEventNewCharacterEnteredRecruitmentPool for each instance in the startup queue
					self:add_first_tick_callback(
						function()
							
							for i = 1, #self.characters_entered_recruitment_pool_during_startup do
								local fm = cm:get_family_member_by_cqi(self.characters_entered_recruitment_pool_during_startup[i]);
								if fm then
									core:trigger_custom_event("ScriptEventNewCharacterEnteredRecruitmentPool", {character_details = fm:character_details()});
								end;
							end;
							self.characters_entered_recruitment_pool_during_startup = nil;
						end
					)
				end;

				table.insert(self.characters_entered_recruitment_pool_during_startup, context:character_details():family_member():command_queue_index());
			end;
		end,
		true
	);
end;












-----------------------------------------------------------------------------
--- @section Faction Queries & Modification
-----------------------------------------------------------------------------


--- @function get_faction
--- @desc Gets a faction object by its string key. If no faction with the supplied key could be found then <code>false</code> is returned.
--- @desc If a faction object is supplied then it is returned directly. This functionality is provided to allow other library functions to be flexible enough to accept a faction or faction key from client code, and use <code>get_faction</code> to convert that faction-or-faction-key into a faction object.
--- @p @string faction key, Faction key, from the <code>factions</code> database table. Alternatively a faction object may be supplied.
--- @p [opt=false] @boolean error if not found, Generate an error if the faction specifier was a @string but no faction with a corresponding key could be found.
--- @r @faction faction
function campaign_manager:get_faction(faction_specifier, error_if_not_found)

	-- If the supplied specifier is already a faction then just return it
	if is_faction(faction_specifier) then
		return faction_specifier;
	end;

	if not is_string(faction_specifier) then
		script_error("ERROR: get_faction() called but supplied faction name [" .. tostring(faction_specifier) .. "] is not a string");
		return false;
	end;

	local world = self:model():world();
	
	if world:faction_exists(faction_specifier) then
		return world:faction_by_key(faction_specifier);
	end;

	if error_if_not_found then
		script_error("ERROR: get_faction() called but no faction with supplied name [" .. tostring(faction_specifier) .. "] could be found");
	end;
	
	return false;
end;


--- @function faction_contains_building
--- @desc Returns <code>true</code> if territories controlled by the supplied faction contain the supplied building. This won't work for horde buildings.
--- @p @faction faction interface
--- @p @string building key
--- @r @faction contains building
function campaign_manager:faction_contains_building(faction, building_key)
	if not is_faction(faction) then
		script_error("ERROR: faction_contains_building() called but supplied faction [" .. tostring(faction) .. "] is not a faction object");
		return false;
	end;

	local region_list = faction:region_list();
	
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i);
		
		if region:building_exists(building_key) then
			return true;
		end;
	end;
	
	return false;
end;


--- @function num_characters_of_type_in_faction
--- @desc Returns the number of characters of the supplied type in the supplied faction.
--- @p @faction faction interface
--- @p @string character type
--- @r @number number of characters
function campaign_manager:num_characters_of_type_in_faction(faction, agent_type)
	if not is_faction(faction) then
		script_error("ERROR: num_characters_of_type_in_faction() called but supplied faction [" .. tostring(faction) .. "] is not a faction object");
		return false;
	end;
	
	local character_list = faction:character_list();
	
	if character_list:num_items() == 0 then
		return 0;
	end;
	
	local num_found = 0;
	for i = 0, character_list:num_items() - 1 do
		if character_list:item_at(i):character_type(agent_type) then
			num_found = num_found + 1;
		end;
	end;

	return num_found;
end;


--- @function kill_all_armies_for_faction
--- @desc Kills all armies in the supplied faction.
--- @p @faction faction interface
--- @r @number number of armies killed
function campaign_manager:kill_all_armies_for_faction(faction)
	if not is_faction(faction) then
		script_error("ERROR: kill_all_armies_for_faction() called but supplied faction [" .. tostring(faction) .. "] is not a faction object");
		return false;
	end;

	local military_force_list = faction:military_force_list();
	local count = 0;
	
	for i = 0, military_force_list:num_items() - 1 do
		local mf = military_force_list:item_at(i);
		
		if mf:has_general() then
			self:kill_character(mf:general_character():cqi(), true);
			count = count + 1;
		end;
	end;
	
	if count == 0 then
		return 0;
	elseif count == 1 then
		out("### kill_all_armies_for_faction() just killed 1 force for faction " .. faction:name() .. " ###");
	else
		out("### kill_all_armies_for_faction() just killed " .. tostring(count) .. " forces for faction " .. faction:name() .. " ###");
	end;
	return count;
end;


--- @function get_trespasser_list_for_faction
--- @desc Returns a table of cqis of characters that are both at war with the specified faction and also trespassing on its territory.
--- @p @faction faction interface
--- @r @table of character command queue indexes
function campaign_manager:get_trespasser_list_for_faction(faction)
	if not is_faction(faction) then
		script_error("ERROR: get_trespasser_list_for_faction() called but supplied object [" .. tostring(faction) .. "] is not a faction");
		return false;
	end;

	local retval = {};
	local faction_name = faction:name();
	
	-- go through all factions. If the current faction is at war with the specified faction, go through the
	-- current faction's military force leaders. If the character is in the subject faction's territory, note
	-- that character's cqi and faction in the table to return.
	local faction_list = faction:model():world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		
		if faction:at_war_with(current_faction) then
			local military_force_list = current_faction:military_force_list();

			for j = 0, military_force_list:num_items() - 1 do
				local military_force = military_force_list:item_at(j);
				
				if military_force:has_general() then
					local character = military_force:general_character();
					
					if character:has_region() and character:region():owning_faction():name() == faction_name then
						table.insert(retval, character:cqi());
					end;
				end;
			end;		
		end;
	end;

	return retval;
end;


--- @function number_of_units_in_faction
--- @desc Returns the number of units in all military forces in the supplied faction. The optional second parameter, if <code>true</code>, specifies that units in armed citizenry armies should not be considered in the calculation.
--- @p @faction faction interface
--- @p [opt=false] @boolean exclude armed citizenry
--- @r @number number of units
function campaign_manager:number_of_units_in_faction(faction, exclude_armed_citizenry)
	if not is_faction(faction) then
		script_error("ERROR: number_of_units_in_faction() called but supplied object [" .. tostring(faction) .. "] is not a faction");
		return false;
	end;
	
	local military_force_list = faction:military_force_list();
	local num_units = 0;
	
	for i = 0, military_force_list:num_items() - 1 do
		local mf = military_force_list:item_at(i);
		
		if not exclude_armed_citizenry or not mf:is_armed_citizenry() then
			num_units = num_units + mf:unit_list():num_items();
		end;
	end;
	
	return num_units;
end;


--- @function faction_has_full_military_force
--- @desc Returns <code>true</code> if the supplied faction has a military force with 20 units in it, or <code>false</code> otherwise. Armed citizenry/garrison armies are excluded from this check.
--- @p @faction faction interface
--- @r @boolean has full military force
function campaign_manager:faction_has_full_military_force(faction)
	if not is_faction(faction) then
		script_error("ERROR: faction_has_full_military_force() called but supplied object [" .. tostring(faction) .. "] is not a faction");
		return false;
	end;

	local military_force_list = faction:military_force_list();
	for i = 0, military_force_list:num_items() - 1 do
		if not military_force_list:item_at(i):is_armed_citizenry() and military_force_list:item_at(i):unit_list():num_items() >= 20 then
			return true;
		end;
	end;

	return false;
end;


--- @function faction_is_alive
--- @desc Returns true if the supplied faction has a home region or any military forces. Note that what constitutes as "alive" for a faction changes between different projects so use with care.
--- @p @faction faction interface
--- @r @boolean faction is alive
function campaign_manager:faction_is_alive(faction)
	if not is_faction(faction) then
		script_error("ERROR: faction_is_alive() called but supplied faction [" .. tostring(faction) .. "] is not a faction object");
		return false;
	end;

	return faction:has_home_region() or faction:military_force_list():num_items() > 0;
end;


--- @function faction_of_culture_is_alive
--- @desc Returns true if any faction with a culture corresponding to the supplied key is alive (uses @campaign_manager:faction_is_alive).
--- @p @string culture key
--- @r @boolean any faction is alive
function campaign_manager:faction_of_culture_is_alive(culture_key)
	if not is_string(culture_key) then
		script_error("ERROR: faction_of_culture_is_alive() called but supplied culture key [" .. tostring(culture_key) .. "] is not a string");
		return false;
	end;

	local faction_list = cm:model():world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i);
		
		if faction:culture() == culture_key then
			if self:faction_is_alive(faction) then
				return true;
			end;
		end;
	end;
	
	return false;
end;


--- @function faction_of_subculture_is_alive
--- @desc Returns true if any faction with a subculture corresponding to the supplied key is alive (uses @campaign_manager:faction_is_alive).
--- @p @string subculture key
--- @r @boolean any faction is alive
function campaign_manager:faction_of_subculture_is_alive(subculture_key)
	if not is_string(subculture_key) then
		script_error("ERROR: faction_of_subculture_is_alive() called but supplied subculture key [" .. tostring(subculture_key) .. "] is not a string");
		return false;
	end;

	local faction_list = cm:model():world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i);
		
		if faction:subculture() == subculture_key then
			if self:faction_is_alive(faction) then
				return true;
			end;
		end;
	end;
	
	return false;
end;


--- @function faction_has_armies_in_enemy_territory
--- @desc Returns <code>true</code> if the supplied faction has any armies in the territory of factions it's at war with, <code>false</code> otherwise.
--- @p @faction faction
--- @r @boolean has armies in enemy territory
function campaign_manager:faction_has_armies_in_enemy_territory(faction)
	if not is_faction(faction) then
		script_error("ERROR: faction_has_armies_in_enemy_territory() called but supplied faction [" .. tostring(faction) .. "] is not a faction object");
		return false;
	end;

	local mf_list = faction:military_force_list();
	
	for i = 0, mf_list:num_items() - 1 do
		local current_mf = mf_list:item_at(i);
		if current_mf:has_general() and not current_mf:is_armed_citizenry() then
			local character = current_mf:general_character();
			if character:has_region() then			
				local region = character:region();
				if not region:is_abandoned() then
					local owning_faction = region:owning_faction();
					if not owning_faction:is_null_interface() and owning_faction:at_war_with(faction) then
						return character;
					end;
				end;
			end;
		end;
	end;
	
	return false;
end;


--- @function faction_has_armies_in_region
--- @desc Returns <code>true</code> if the supplied faction has any armies in the supplied region, <code>false</code> otherwise.
--- @p @faction faction
--- @p @region region
--- @r @boolean armies in region
function campaign_manager:faction_has_armies_in_region(faction, region)
	local mf_list = faction:military_force_list();
	
	for i = 0, mf_list:num_items() - 1 do
		local current_mf = mf_list:item_at(i);
		if current_mf:has_general() and not current_mf:is_armed_citizenry() then
			local character = current_mf:general_character();
			if character:has_region() and character:region() == region then
				return character;
			end;
		end;
	end;
	
	return false;
end;


--- @function faction_has_nap_with_faction
--- @desc Returns <code>true</code> if the supplied faction has any armies in the supplied region, <code>false</code> otherwise.
--- @p @faction faction
--- @p @region region
--- @r @boolean armies in region
function campaign_manager:faction_has_nap_with_faction(faction_a, faction_b)
	if not is_faction(faction_a) then
		script_error("ERROR: faction_has_nap_with_faction() called but first supplied faction [" .. tostring(faction_a) .. "] is not a faction object");
		return false;
	end;
	
	if not is_faction(faction_b) then
		script_error("ERROR: faction_has_nap_with_faction() called but second supplied faction [" .. tostring(faction_b) .. "] is not a faction object");
		return false;
	end;

	local nap_list = faction_a:factions_non_aggression_pact_with();
	for i = 0, nap_list:num_items() - 1 do
		if nap_list:item_at(i) == faction_b then
			return true;
		end;
	end;
	return false;
end;


--- @function faction_has_trade_agreement_with_faction
--- @desc Returns <code>true</code> if the supplied faction has any armies in the supplied region, <code>false</code> otherwise.
--- @p @faction faction
--- @p @region region
--- @r @boolean armies in region
function campaign_manager:faction_has_trade_agreement_with_faction(faction_a, faction_b)
	if not is_faction(faction_a) then
		script_error("ERROR: faction_has_trade_agreement_with_faction() called but first supplied faction [" .. tostring(faction_a) .. "] is not a faction object");
		return false;
	end;
	
	if not is_faction(faction_b) then
		script_error("ERROR: faction_has_trade_agreement_with_faction() called but second supplied faction [" .. tostring(faction_b) .. "] is not a faction object");
		return false;
	end;

	local trade_list = faction_a:factions_trading_with();
	for i = 0, trade_list:num_items() - 1 do
		if trade_list:item_at(i) == faction_b then
			return true;
		end;
	end;
	return false;
end;


--- @function num_regions_controlled_in_province_by_faction
--- @desc Returns the number of regions controlled by a specified faction in a supplied province.
--- @p @province province, Province to query.
--- @p @faction faction, Faction to query.
--- @r @number number of controlled regions
--- @r @number total number of regions
function campaign_manager:num_regions_controlled_in_province_by_faction(province, faction)
	local count = 0;
	local region_list = province:regions();

	for i = 0, region_list:num_items() - 1 do
		if region_list:item_at(i):owning_faction() == faction then
			count = count + 1;
		end;
	end;

	return count, region_list:num_items();
end;


--- @function num_provinces_controlled_by_faction
--- @desc Returns the number of complete provinces controlled by the specified faction, as well as the number of provinces in which the faction owns territory and is only one settlement away from complete control.
--- @p @faction faction, Faction to query.
--- @r @number number of provinces controlled
--- @r @number number of provinces almost controlled (one settlement away from completion)
function campaign_manager:num_provinces_controlled_by_faction(faction)
	if not is_faction(faction) then
		script_error("ERROR: num_provinces_controlled_by_faction() called but supplied faction [" .. tostring(faction) .. "] is not a faction object");
		return false;
	end;

	local region_list = faction:region_list();
	local checked_provinces = {};
	local num_controlled_provinces = 0;
	local num_almost_controlled_provinces = 0;

	for i = 0, region_list:num_items() - 1 do
		local current_region = region_list:item_at(i);
		local current_region_province_name = current_region:province_name();

		-- check this province if it's not already been checked
		if not checked_provinces[current_region_province_name] then
			checked_provinces[current_region_province_name] = true;
			
			local num_regions_controlled_by_faction, num_regions_in_province = self:num_regions_controlled_in_province_by_faction(current_region:province(), faction);
			
			if num_regions_controlled_by_faction == num_regions_in_province then
				num_controlled_provinces = num_controlled_provinces + 1;
			elseif num_regions_controlled_by_faction + 1 == num_regions_in_province then
				num_almost_controlled_provinces = num_almost_controlled_provinces + 1;
			end;
		end;
	end;

	return num_controlled_provinces, num_almost_controlled_provinces;
end;


--- @function faction_contains_agents
--- @desc Returns <code>true</code> if the supplied faction has any agents in its character list, or <code>false</code> otherwise. The function may also be instructed to return a table of all agents in the faction, either by their character interfaces or their command-queue indexes.
--- @p @faction faction, Faction interface for the subject faction.
--- @p [opt=false] @boolean return list, Instructs the function to also return a @table of either their character interfaces or cqi's (which of these to use is set by the third parameter to this function).
--- @p [opt=false] @boolean return by cqi, Instructs the function to return a list of cqis instead of a list of character interfaces. If characters are stored by cqi their character interfaces may later be looked up using @campaign_manager:get_character_by_cqi. Character interfaces are volatile and may not be stored over time. This argument is not used if the second argument is not set to <code>true</code>.
--- @r @boolean faction has agents
--- @r @table list of agents, by either cqi or character interface, or @nil if the second argument is not set to <code>true</code>.
function campaign_manager:faction_contains_agents(faction, return_list, return_by_cqi)
	if not is_faction(faction) then
		script_error("ERROR: faction_has_agents() called but supplied faction [" .. tostring(faction) .. "] is not a faction object");
		return false;
	end;

	local agent_list = {};

	local char_list = faction:character_list();
	for i = 0, char_list:num_items() - 1 do
		local current_char = char_list:item_at(i);
		if self:char_is_agent(current_char) then
			if return_list then
				if return_by_cqi then
					table.insert(agent_list, current_char:command_queue_index());
				else
					table.insert(agent_list, current_char);
				end;
			else
				return true;
			end;
		end;
	end;

	if return_list then
		return #agent_list > 0, agent_list;
	end;

	return false;
end;


--- @function faction_contains_characters_of_type
--- @desc Returns <code>true</code> if the supplied faction has any agents of the supplied types or subtypes.
--- @p @faction faction, Interface for the subject faction.
function campaign_manager:faction_contains_characters_of_type(faction, character_types, character_subtypes)
	if not validate.is_faction(faction) then
		return false;
	end;

	if character_types then
		if not validate.is_table_of_strings(character_types) then
			return false;
		end;
	else
		character_types = self:get_all_agent_types();
	end;

	if character_subtypes and not validate.is_table_of_strings(character_types) then
		return false;
	end;

	local character_list = faction:character_list();
	for _, char in model_pairs(character_list) do
		if character_types then
			local char_type = char:character_type_key();
			for i = 1, #character_types do
				if character_types[i] == char_type then
					return true;
				end;
			end;
		end;

		if character_subtypes then
			local char_subtype = char:character_subtype_key();
			for i = 1, #character_subtypes do
				if character_subtypes[i] == char_subtype then
					return true;
				end;
			end;
		end;
	end;

	return false;
end;


--- @function can_recruit_agent
--- @desc Returns whether a specified faction can recruit agents, optionally of a type.
--- @p faction faction
--- @p @table types, Table of @string agent types, from the <code>agents</code> database table.
--- @r @boolean can recruit agent
function campaign_manager:can_recruit_agent(faction, agent_types)
	if not validate.is_faction(faction) then
		return false;
	end;

	if agent_types and not validate.is_table_of_strings(agent_types) then
		return false;
	end;

	agent_types = agent_types or self:get_all_agent_types();

	local region_list = faction:region_list();

	for _, region in model_pairs(region_list) do
		for i = 1, #agent_types do
			if region:can_recruit_agent_at_settlement(agent_types[i]) then
				return true;
			end;
		end;
	end;

	return false;
end;


--- @function faction_can_reach_faction
--- @desc Returns whether any army in a source faction can reach any settlement in a target faction this turn. An optional flag also includes whether the can-reach test should be performed against the target faction's roving armies.
--- @p faction source faction specifier, Source faction specifier - this can be a faction script interface object, or a @string faction key from the <code>factions</code> database table.
--- @p faction target faction specifier, Target faction specifier - this can be a faction script interface object, or a @string faction key from the <code>factions</code> database table.
--- @p [opt=false] @boolean include armies, Include the movable armies of the target faction in the can-reach test.
--- @r @boolean source can reach target
--- @r character character from source faction that can reach, or @nil if no character can reach
--- @r character character from target faction that can be reached, or @nil if no character can be reached
function campaign_manager:faction_can_reach_faction(source_faction_specifier, target_faction_specifier, include_armies)
	
	local source_faction = self:get_faction(source_faction_specifier, true);
	if not source_faction then
		return false;
	end;

	local target_faction = self:get_faction(target_faction_specifier, true);
	if not target_faction then
		return false;
	end;
	
	local source_mf_list = source_faction:military_force_list();
	local target_mf_list = target_faction:military_force_list();

	if source_mf_list:num_items() == 0 or target_mf_list:num_items() == 0 then
		return false;
	end;

	for _, source_mf in model_pairs(source_mf_list) do
		if not source_mf:is_armed_citizenry() and source_mf:has_general() then
			local source_char = source_mf:general_character();
			
			for _, target_mf in model_pairs(target_mf_list) do
				if target_mf:has_general() and (include_armies or target_mf:is_armed_citizenry()) then
					local target_char = target_mf:general_character();

					if self:character_can_reach_character(source_char, target_char) then
						return true, source_char, target_char;
					end;
				end;
			end;
		end;
	end;

	return false;
end;


--- @function get_highest_level_settlement_for_faction
--- @desc Returns the highest-level settlement for the specified faction. If the faction has no settlements then @nil is returned.
--- @p faction faction
--- @r settlement highest-level settlement
--- @r @number settlement level
function campaign_manager:get_highest_level_settlement_for_faction(faction)

	if not validate.is_faction(faction) then
		return false;
	end;

	local highest_level = 0;
	local highest_level_settlement;

	local region_list = faction:region_list();

	for i = 0, region_list:num_items() - 1 do
		local current_level = region_list:item_at(i):settlement():primary_slot():building():building_level();

		if current_level > highest_level then
			highest_level = current_level;
			highest_level_settlement = region_list:item_at(i):settlement();
		end;
	end;

	if highest_level > 0 then
		return highest_level_settlement, highest_level;
	end;
end;















-----------------------------------------------------------------------------
--- @section Foreign Slots
-----------------------------------------------------------------------------


--- @function get_closest_foreign_slot_manager_from_faction_to_faction
--- @desc Returns the closest foreign slot manager belonging to one faction, to the settlements from another faction. The two factions may be the same, in which case the closest foreign slot manager to the faction's own settlements is returned.
--- @p @faction owning faction, Owning faction specifier. This can be a @faction interface or a @string faction key from the <code>factions</code> database table.
--- @p @faction foreign faction, Foreign faction specifier. This can be a @faction object or a @string faction key from the <code>factions</code> database table.
--- @r @foreign_slot_manager foreign slot
function campaign_manager:get_closest_foreign_slot_manager_from_faction_to_faction(owning_faction_specifier, foreign_faction_specifier)
	local owning_faction = cm:get_faction(owning_faction_specifier, true);
	if not owning_faction then
		return false;
	end;

	local foreign_faction = cm:get_faction(foreign_faction_specifier, true);
	if not foreign_faction then
		return false;
	end;

	local fsm_list = owning_faction:foreign_slot_managers();

	local closest_fsm;
	local closest_fsm_distance = 999999;

	for i, fsm in model_pairs(fsm_list) do
		local fsm_settlement = fsm:region():settlement();
		local fsm_settlement_x = fsm_settlement:logical_position_x();
		local fsm_settlement_y = fsm_settlement:logical_position_y();

		local current_foreign_char, current_foreign_char_dist = cm:get_closest_general_to_position_from_faction(foreign_faction, fsm_settlement_x, fsm_settlement_y);

		if current_foreign_char_dist < closest_fsm_distance then
			closest_fsm = fsm;
			closest_fsm_distance = current_foreign_char_dist;
		end
	end;

	return closest_fsm;
end;


--- @function is_foreign_slot_manager_allied
--- @desc Returns whether the supplied foreign slot manager is allied to the settlement that it's a part of.
--- @p @foreign_slot_manager foreign slot manager
--- @r @boolean slot is allied
function campaign_manager:is_foreign_slot_manager_allied(fsm)
	if not validate.is_foreignslotmanager(fsm) then
		return false;
	end;

	local fsm_region = fsm:region();

	if fsm_region:is_abandoned() then
		return false;
	end;

	return fsm:faction():allied_with(fsm_region:owning_faction());
end;













-----------------------------------------------------------------------------
--- @section Garrison Residence Queries
-----------------------------------------------------------------------------


--- @function garrison_contains_building
--- @desc Returns <code>true</code> if the supplied garrison residence contains a building with the supplied key, <code>false</code> otherwise.
--- @p garrison_residence garrison residence
--- @p string building key
--- @r boolean garrison contains building
function campaign_manager:garrison_contains_building(garrison, building_key)
	if not is_garrisonresidence(garrison) then
		script_error("ERROR: garrison_contains_building() called but supplied garrison residence [" .. tostring(garrison) .. "] is not a garrison residence object");
		return false;
	end;
	
	if not is_string(building_key) then
		script_error("ERROR: garrison_contains_building() called but supplied building key [" .. tostring(building_key) .. "] is not a string");
		return false;
	end;

	for i = 0, garrison:region():slot_list():num_items() - 1 do
		local slot = garrison:region():slot_list():item_at(i);

		if slot:has_building() and slot:building():name() == building_key then
			return true;
		end;
	end;

	return false;
end;


--- @function garrison_contains_building_chain
--- @desc Returns <code>true</code> if the supplied garrison residence contains a building with the supplied chain key, <code>false</code> otherwise.
--- @p garrison_residence garrison residence
--- @p string building chain key
--- @r boolean garrison contains building
function campaign_manager:garrison_contains_building_chain(garrison, chain_key)
	if not is_garrisonresidence(garrison) then
		script_error("ERROR: garrison_contains_building_chain() called but supplied garrison residence [" .. tostring(garrison) .. "] is not a garrison residence object");
		return false;
	end;
	
	if not is_string(chain_key) then
		script_error("ERROR: garrison_contains_building_chain() called but supplied building chain key [" .. tostring(chain_key) .. "] is not a string");
		return false;
	end;

	for i = 0, garrison:region():slot_list():num_items() - 1 do
		local slot = garrison:region():slot_list():item_at(i);
	
		if slot:has_building() and slot:building():chain() == chain_key then
			return true;
		end;	
	end;
	
	return false;
end;


--- @function garrison_contains_building_superchain
--- @desc Returns <code>true</code> if the supplied garrison residence contains a building with the supplied superchain key, <code>false</code> otherwise.
--- @p garrison_residence garrison residence
--- @p string building superchain key
--- @r boolean garrison contains building
function campaign_manager:garrison_contains_building_superchain(garrison, superchain_key)
	if not is_garrisonresidence(garrison) then
		script_error("ERROR: garrison_contains_building_superchain() called but supplied garrison residence [" .. tostring(garrison) .. "] is not a garrison residence object");
		return false;
	end;
	
	if not is_string(superchain_key) then
		script_error("ERROR: garrison_contains_building_superchain() called but supplied building superchain key [" .. tostring(superchain_key) .. "] is not a string");
		return false;
	end;

	for i = 0, garrison:region():slot_list():num_items() - 1 do
		local slot = garrison:region():slot_list():item_at(i);
	
		if slot:has_building() and slot:building():superchain() == superchain_key then
			return true;
		end;	
	end;
	
	return false;
end;


--- @function get_armed_citizenry_from_garrison
--- @desc Returns the garrison army from a garrison residence. By default this returns the land army armed citizenry - an optional flag instructs the function to return the naval armed citizenry instead.
--- @p garrison_residence garrison residence, Garrison residence.
--- @p [opt=false] boolean get naval, Returns the naval armed citizenry army, if set to <code>true</code>.
--- @r boolean armed citizenry army
function campaign_manager:get_armed_citizenry_from_garrison(garrison, naval_force_only)
	if not is_garrisonresidence(garrison) then
		script_error("ERROR: get_armed_citizenry_from_garrison() called but supplied garrison residence [" .. tostring(garrison) .. "] is not a garrison residence object");
		return false;
	end;

	-- return land force or naval force, depending on what the value of this flag is
	naval_force_only = not not naval_force_only;
	
	local mf_list = garrison:faction():military_force_list();
	
	for i = 0, mf_list:num_items() - 1 do
		local current_mf = mf_list:item_at(i);
		
		if current_mf:is_armed_citizenry() and current_mf:garrison_residence() == garrison then
			if naval_force_only then
				if current_mf:is_navy() then
					return current_mf;
				end;
			else
				if current_mf:is_army() then
					return current_mf;
				end;
			end;
		end;
	end;
	
	return false;
end;












-----------------------------------------------------------------------------
--- @section Military Force Queries
-----------------------------------------------------------------------------


--- @function get_strongest_military_force_from_faction
--- @desc Returns the strongest military force from the specified faction. Nil is returned if the faction contains no military forces.
--- @p @string faction key, Faction key, from the <code>factions</code> table.
--- @p [opt=false] @boolean include garrisons, Include garrision armies.
--- @r military_force strongest military force
function campaign_manager:get_strongest_military_force_from_faction(faction_key, include_garrison_armies)
	if not is_string(faction_key) then
		script_error("ERROR: get_strongest_military_force_from_faction() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string");
		return false;
	end;

	local faction = self:get_faction(faction_key);

	if not faction then
		script_error("ERROR: get_strongest_military_force_from_faction() called but no faction with supplied key [" .. faction_key .. "] could be found");
		return false;
	end;

	local military_force_list = faction:military_force_list();
	local highest_strength = 0;
	local strongest_military_force;

	for i = 0, military_force_list:num_items() - 1 do
		local current_mf = military_force_list:item_at(i);

		if include_garrison_armies or not current_mf:is_armed_citizenry() then
			local current_mf_strength = current_mf:strength();
			if current_mf_strength > highest_strength then
				highest_strength = current_mf_strength;
				strongest_military_force = current_mf;
			end;
		end;
	end;

	return strongest_military_force;
end;


-- internal function, used by functions below
local function get_closest_military_force_from_faction(faction, x, y, include_garrison_armies)
	local military_force_list = faction:military_force_list();

	local closest_mf;
	local closest_distance_sq = 9999999;

	for i = 0, military_force_list:num_items() - 1 do
		local current_mf = military_force_list:item_at(i);

		if (include_garrison_armies or not current_mf:is_armed_citizenry()) and current_mf:has_general() then
			local current_char = current_mf:general_character();
			local current_distance_sq = distance_squared(current_char:logical_position_x(), current_char:logical_position_y(), x, y);
			if current_distance_sq < closest_distance_sq then
				closest_mf = current_mf;
				closest_distance_sq = current_distance_sq;
			end;
		end;
	end;

	return closest_mf, closest_distance_sq ^ 0.5;
end;


--- @function get_closest_military_force_from_faction
--- @desc Returns the closest military force from the specified faction to a specified logical position. Nil is returned if the faction contains no military forces.
--- @p @string faction key, Faction key, from the <code>factions</code> table.
--- @p @number x, Logical x co-ordinate.
--- @p @number y, Logical y co-ordinate.
--- @p [opt=false] @boolean include garrisons, Include garrison armies from the subject faction.
--- @r military_force closest military force
--- @r @number closest military force distance
function campaign_manager:get_closest_military_force_from_faction(faction_key, x, y, include_garrison_armies)
	if not is_string(faction_key) then
		script_error("ERROR: get_closest_military_force_from_faction() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string");
		return false;
	end;

	local faction = self:get_faction(faction_key);

	if not faction then
		script_error("ERROR: get_closest_military_force_from_faction() called but no faction with supplied key [" .. faction_key .. "] could be found");
		return false;
	end;

	if not is_number(x) or x < 0 then
		script_error("ERROR: get_closest_military_force_from_faction() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a positive number");
		return false;
	end;

	if not is_number(y) or y < 0 then
		script_error("ERROR: get_closest_military_force_from_faction() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a positive number");
		return false;
	end;

	return get_closest_military_force_from_faction(faction, x, y, include_garrison_armies);
end;


--- @function get_closest_military_force_from_faction_to_faction
--- @desc Returns the closest military force from the specified subject faction to a foreign faction. Nil is returned if either faction contains no military forces.
--- @p @string subject faction key, Subject faction key, from the <code>factions</code> table.
--- @p @string foreign faction key, Foreign faction key, from the <code>factions</code> table.
--- @p [opt=false] @boolean include garrisons, Include garrison armies from the subject faction.
--- @r military force closest military force
function campaign_manager:get_closest_military_force_from_faction_to_faction(subject_faction_key, foreign_faction_key, include_garrison_armies)

	if not is_string(subject_faction_key) then
		script_error("ERROR: get_closest_military_force_from_faction_to_faction() called but supplied subject faction key [" .. tostring(subject_faction_key) .. "] is not a string");
		return false;
	end;

	local subject_faction = self:get_faction(subject_faction_key);

	if not subject_faction then
		script_error("ERROR: get_closest_military_force_from_faction_to_faction() called but no faction with subject faction key [" .. subject_faction_key .. "] could be found");
		return false;
	end;

	if not is_string(foreign_faction_key) then
		script_error("ERROR: get_closest_military_force_from_faction_to_faction() called but supplied foreign faction key [" .. tostring(foreign_faction_key) .. "] is not a string");
		return false;
	end;

	local foreign_faction = self:get_faction(foreign_faction_key);

	if not foreign_faction then
		script_error("ERROR: get_closest_military_force_from_faction_to_faction() called but no faction with foreign faction key [" .. foreign_faction_key .. "] could be found");
		return false;
	end;

	-- get closest military force from subject faction for each of the foreign faction's military forces
	local foreign_mf_list = foreign_faction:military_force_list();
	
	local closest_subject_mf;
	local closest_subject_mf_dist = 9999999;

	for i = 0, foreign_mf_list:num_items() - 1 do
		local current_foreign_mf = foreign_mf_list:item_at(i);

		if current_foreign_mf:has_general() then
			local current_foreign_char = current_foreign_mf:general_character();
			local current_closest_subject_mf, current_closest_subject_mf_dist = get_closest_military_force_from_faction(subject_faction, current_foreign_char:logical_position_x(), current_foreign_char:logical_position_y(), include_garrison_armies);

			if current_closest_subject_mf_dist < closest_subject_mf_dist then
				closest_subject_mf = current_closest_subject_mf;
				closest_subject_mf_dist = current_closest_subject_mf_dist;
			end;
		end;
	end;

	return closest_subject_mf;
end;


--- @function military_force_average_strength
--- @desc Returns the average strength of all units in the military force. This is expressed as a percentage (0-100), so a returned value of 75 would indicate that the military force had lost 25% of its strength through casualties.
--- @p military_force military force
--- @r number average strength percentage
function campaign_manager:military_force_average_strength(military_force)
	if not is_militaryforce(military_force) then
		script_error("ERROR: military_force_average_strength() called but supplied military force [" .. tostring(military_force) .. "] is not a military force object");
		return false;
	end;

	local unit_list = military_force:unit_list();
	local num_units = unit_list:num_items();
	
	if num_units == 0 then
		return 0;
	end;
	
	local cumulative_health = 0;
	
	for i = 0, num_units - 1 do	
		cumulative_health = cumulative_health + unit_list:item_at(i):percentage_proportion_of_full_strength();
	end;
	
	return (cumulative_health / num_units);
end;


--- @function num_mobile_forces_in_force_list
--- @desc Returns the number of military forces that are not armed-citizenry in the supplied military force list. 
--- @p military_force_list military force list
--- @p [opt=nil] @table not_including_armies_of_type, Set of army-type keys that will not be counted by this function.
--- @r number number of mobile forces
function campaign_manager:num_mobile_forces_in_force_list(military_force_list, not_including_armies_of_type)
	if not is_militaryforcelist(military_force_list) then
		script_error("ERROR: num_mobile_forces_in_force_list() called but supplied military force list [" .. tostring(military_force_list) .. "] is not a military_force_list object");
		return false;
	end;

	return #campaign_manager:get_mobile_force_interface_list(military_force_list, not_including_armies_of_type);
end;




--- @function get_mobile_force_interface_list
--- @desc Returns a one-based list of military force interfaces in the provided list which are not armed-citizenry.
--- @p military_force_list, military force list
--- @p [opt=nil] @table not_including_armies_of_type, Set of army-type keys that will not be counted by this function.
--- @r @table One-based list of military force interfaces which are not armed-citizenry. Empty list is returned if none are found.
--- @new_example
--- @desc Getting the mobile forces within a military force list, excluding CARAVAN and OGRE_CAMP
--- @example cm:num_mobile_forces_in_force_list(military_force_list, {
--- @example     CARAVAN = true,
--- @example     OGRE_CAMP = true,
--- @example });
function campaign_manager:get_mobile_force_interface_list(military_force_list, not_including_armies_of_type)
	if not validate.is_militaryforcelist(military_force_list) then
		return;
	end;

	not_including_armies_of_type = not_including_armies_of_type or {}

	local discovered_force_interfaces = {};

	for i = 0, military_force_list:num_items() - 1 do
		local mf = military_force_list:item_at(i);
		local force_type = mf:force_type():key();
		if not mf:is_armed_citizenry() and (not_including_armies_of_type[force_type] == nil) then
			table.insert(discovered_force_interfaces, mf);
		end;
	end;

	return discovered_force_interfaces;
end;


--- @function proportion_of_unit_class_in_military_force
--- @desc Returns the unary proportion (0-1) of units in the supplied military force which are of the supplied unit class.
--- @p military_force military force
--- @p string unit class
--- @r proportion units of unit class
function campaign_manager:proportion_of_unit_class_in_military_force(military_force, unit_class)
	if not is_militaryforce(military_force) then
		script_error("ERROR: proportion_of_unit_class_in_military_force() called but supplied military force [" .. tostring(military_force) .. "] is not a military force object");
		return false;
	end;
	
	if not is_string(unit_class) then
		script_error("ERROR: proportion_of_unit_class_in_military_force() called but supplied unit class [" .. tostring(unit_class) .. "] is not a string");
		return false;
	end;

	local unit_list = military_force:unit_list();
	
	local num_items = unit_list:num_items();
	
	if num_items == 0 then
		return 0;
	end;
	
	local num_found = 0;
	for i = 0, num_items - 1 do
		if unit_list:item_at(i):unit_class() == unit_class then
			num_found = num_found + 1;
		end;
	end;
	
	return (num_found / num_items);
end;


--- @function military_force_contains_unit_type_from_list
--- @desc Returns <code>true</code> if the supplied military force contains any units of a type contained in the supplied unit type list, <code>false</code> otherwise.
--- @p military_force military force, Military force.
--- @p table unit type list, Unit type list. This must be supplied as a numerically indexed table of strings.
--- @r force contains unit from type list
function campaign_manager:military_force_contains_unit_type_from_list(military_force, unit_type_list)
	if not is_militaryforce(military_force) then
		script_error("ERROR: military_force_contains_unit_type_from_list() called but supplied military force [" .. tostring(military_force) .. "] is not a military force object");
		return false;
	end;
	
	if not is_table(unit_type_list) then
		script_error("ERROR: military_force_contains_unit_type_from_list() called but supplied  [" .. tostring(unit_type_list) .. "] is not a string");
		return false;
	end;

	for i = 0, military_force:unit_list():num_items() - 1 do
		local unit = military_force:unit_list():item_at(i);
		if table.contains(unit_type_list, unit:unit_key()) then
			return true;
		end;
	end;
	return false;
end;


--- @function military_force_contains_unit_class_from_list
--- @desc Returns <code>true</code> if the supplied military force contains any units of a class contained in the supplied unit class list, <code>false</code> otherwise.
--- @p military_force military force, Military force.
--- @p table unit class list, Unit class list. This must be supplied as a numerically indexed table of strings.
--- @r force contains unit from class list
function campaign_manager:military_force_contains_unit_class_from_list(military_force, unit_class_list)
	if not is_militaryforce(military_force) then
		script_error("ERROR: military_force_contains_unit_type_from_list() called but supplied military force [" .. tostring(military_force) .. "] is not a military force object");
		return false;
	end;
	
	if not is_table(unit_class_list) then
		script_error("ERROR: military_force_contains_unit_type_from_list() called but supplied  [" .. tostring(unit_class_list) .. "] is not a string");
		return false;
	end;
	
	for i = 0, military_force:unit_list():num_items() - 1 do
		if table.contains(unit_class_list, military_force:unit_list():item_at(i):unit_class()) then
			return true;
		end;
	end;
	return false;
end;


--- @function force_from_general_cqi
--- @desc Returns the force whose commanding general has the passed cqi. If no force is found then <code>false</code> is returned.
--- @p number general cqi
--- @r military force force
function campaign_manager:force_from_general_cqi(general_cqi)
	local general_obj = cm:model():character_for_command_queue_index(general_cqi);
	
	if general_obj:is_null_interface() == false then
		if general_obj:has_military_force() then
			return general_obj:military_force();
		end
	end
	return false;
end;


--- @function force_gold_value
--- @desc Returns the gold value of all of the units in the force.
--- @p @number or @military_force force cqi or force interface
--- @r number value
function campaign_manager:force_gold_value(force)
	if not is_militaryforce(force) then
		if is_number(force) then
			force = cm:model():military_force_for_command_queue_index(force);
		else
			script_error("ERROR: force_gold_value() called but supplied force value is [" .. tostring(force) .. "] is not a cqi number or military force interface.");
			return;
		end;
	end;

	local force_value = 0;
	
	if force:is_null_interface() == false then
		local unit_list = force:unit_list();
		
		for i = 0, unit_list:num_items() - 1 do
			local unit = unit_list:item_at(i);
			
			if unit:is_null_interface() == false then
				force_value = force_value + (math.max(0, unit:get_unit_custom_battle_cost()) * unit:percentage_proportion_of_full_strength() * 0.01);
			end
		end
	end
	return force_value;
end










-----------------------------------------------------------------------------
--- @section Region and Province Queries & Modification
-----------------------------------------------------------------------------


--- @function get_region
--- @desc Returns a region object with the supplied region name, or if a region interface was provided simply returns that. If no such region is found then <code>false</code> is returned.
--- @p string or @region region name or interface
--- @r region region
function campaign_manager:get_region(region_arg)
	if not is_string(region_arg) and is_region(region_arg) then
		script_error("ERROR: get_region() called but supplied region name [" .. tostring(region_arg) .. "] is not a string or region interface.");
		return false;
	end;
	
	if is_string(region_arg) then
		local region = self:model():world():region_manager():region_by_key(region_arg);
		if is_region(region) then
			return region;
		end;
	else
		return region_arg
	end;
	
	return false;
end;


--- @function get_region_data_at_position
--- @desc Returns the @region_data found at the provided x and y coordinates.
--- @p @number x
--- @p @number y
--- @r @region_data region data
function campaign_manager:get_region_data_at_position(x, y)
	local region_data = self:model():world():region_data_at_position(x, y);
	if region_data == nil or region_data:is_null_interface() then
		script_error(string.format(
			"ERROR: get_region_data_at_position() called but no region data was found from the provided position [%s, %s]",
			tostring(x),
			tostring(y)	
		));
		return false;
	end;
	return region_data;
end;


--- @function get_province_at_position
--- @desc Returns the @province ofthe region found at the provided x and y coordinates.
--- @p @number x
--- @p @number y
--- @r @province province
function campaign_manager:get_province_at_position(x, y)
	local region_data =  self:get_region_data_at_position(x, y);
	if region_data == nil or region_data:is_null_interface() or region_data:is_sea() then
		return false;
	end;
	local region = region_data:region();
	if region:is_null_interface() then
		return false;
	end;
	local province = region:province();
	if province == nil or province:is_null_interface() then
		return false;
	end;
	return province;
end;


--- @function get_region_data
--- @desc Returns a region data object with the supplied region name. If no such region data is found then <code>false</code> is returned.
--- @p string region data name
--- @r region_data region data
function campaign_manager:get_region_data(region_data_name)
	if not is_string(region_data_name) then
		script_error("ERROR: get_region_data() called but supplied region data name [" .. tostring(region_data_name) .. "] is not a string");
		return false;
	end;
	
	local region_data = self:model():world():region_data_for_key(region_data_name);
	
	if is_regiondata(region_data) then
		return region_data;
	end;
	
	return false;
end;


--- @function get_province
--- @desc Returns a province object with the supplied province name, or if a province interface is provided then simply returns that instead. If no such province is found then <code>false</code> is returned.
--- @p string or @province province name or interface
--- @r province province
function campaign_manager:get_province(province_arg)
	if not is_string(province_arg) and not is_province(province_arg) then
		script_error("ERROR: get_province() called but supplied province name [" .. tostring(province_arg) .. "] is not a string or province interface");
		return false;
	end;

	if is_string(province_arg) then
		local province = self:model():world():province_by_key(province_arg);
		if is_province(province) then
			return province;
		end;
	else
		return province_arg;
	end;
	
	return false;
end;


--- @function is_region_owned_by_faction
--- @desc Returns whether the region with the supplied key is owned by a faction with the supplied name.
--- @p @string region name, Region name, from the <code>campaign_map_regions</code> database table.
--- @p @string faction name, Faction name, from the <code>factions</code> database table.
--- @r @boolean region is owned by faction
function campaign_manager:is_region_owned_by_faction(region_name, faction_name)
	if not is_string(region_name) then
		script_error("ERROR: is_region_owned_by_faction() called but supplied region name [" .. tostring(region_name) .. "] is not a string");
		return false;
	end;
	
	if not is_string(faction_name) then
		script_error("ERROR: is_region_owned_by_faction() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;

	local region = self:get_region(region_name);
	
	if not is_region(region) then
		script_error("ERROR: is_region_owned_by_faction() called but couldn't find a region with supplied name [" .. tostring(region_name) .. "]");
		return false;
	end;
	
	return region:owning_faction():name() == faction_name;
end;


--- @function get_owner_of_province
--- @desc Returns the faction that has complete control of the supplied province. If no faction holds the entire province, then @nil is returned.
--- @p @province province
--- @r @faction province owner, or @nil if province is contested
function campaign_manager:get_owner_of_province(province)
	if not validate.is_province(province) then
		return false;
	end;

	local capital_region = province:capital_region();

	local controlling_faction;
	local regions = province:regions();

	for i, region in model_pairs(regions) do
		if region:is_abandoned() then
			return;
		end;

		if controlling_faction then
			if controlling_faction ~= region:owning_faction() then
				return;
			end;
		else
			controlling_faction = region:owning_faction();
		end;
	end;

	return controlling_faction;
end;


--- @function region_adjacent_to_faction
--- @desc Returns whether the supplied region object is adjacent to regions owned by the supplied faction. If the region is owned by the faction then <code>false</code> is returned.
--- @p region region
--- @p faction region
--- @r boolean region adjacent to faction
function campaign_manager:region_adjacent_to_faction(region, faction)
	if not validate.is_region(region) then
		return false;
	end;
	
	if not validate.is_faction(faction) then
		return false;
	end;

	if region:owning_faction() == faction then
		return false;
	end;

	local region_list = faction:region_list();

	for i, current_region in model_pairs(region_list) do
		for j, current_adjacent_region in model_pairs(current_region:adjacent_region_list()) do
			if current_adjacent_region == region then
				return true;
			end;
		end;
	end;
end;


--- @function region_has_chain_or_superchain
--- @desc Returns whether the supplied region contains the key specified building chain or superchain
--- @p @region region
--- @p @string building chain or building superchain key
--- @r boolean region has chain or superchain
function campaign_manager:region_has_chain_or_superchain(region, superchain)
	if not validate.is_region(region) then
		return false;
	end;
	
	if not validate.is_string(superchain) then
		return false;
	end;
	
	local slot_list = region:slot_list();
	
	for i = 0, slot_list:num_items() - 1 do
		current_slot = slot_list:item_at(i);
		if current_slot:has_building() and (current_slot:building():superchain() == superchain or current_slot:building():chain() == superchain) then
			return true;
		end;
	end;
	
	return false;
end;


--- @function instantly_upgrade_building_in_region
--- @desc Instantly upgrades the building in the supplied slot to the supplied building key.
--- @p @slot slot
--- @p @string target building key
function campaign_manager:instantly_upgrade_building_in_region(slot, target_building_key)
	if not is_string(target_building_key) then
		script_error("ERROR: instantly_upgrade_building_in_region() called but supplied target building key [" .. tostring(target_building_key) .. "] is not a string");
		return false;
	end;
	
	self.game_interface:region_slot_instantly_upgrade_building(slot, target_building_key);
end;


--- @function instantly_dismantle_building_in_region
--- @desc Instantly dismantles the building in the supplied slot number of the supplied region.
--- @p @slot slot
function campaign_manager:instantly_dismantle_building_in_region(slot)
	self.game_interface:region_slot_instantly_dismantle_building(slot);
end;


--- @function get_most_pious_region_for_faction_for_religion
--- @desc Returns the region held by a specified faction that has the highest proportion of a specified religion. The numeric religion proportion is also returned.
--- @p faction subject faction
--- @p string religion key
--- @r region most pious region
--- @r number religion proportion
function campaign_manager:get_most_pious_region_for_faction_for_religion(faction, religion_key)
	
	-- this function is temporarily deprecated until we have new WH3 religion methods
	script_error("get_most_pious_region_for_faction_for_religion() called but WH2 religion_proportion() calls are deprecated - replace with new WH3 calls when available");
	return faction:home_region(), "wh_main_religion_untainted";
	--[[
	local region_list = faction:region_list();
	
	local highest_religion_region = false;
	local highest_religion_amount = 0;
	
	for i = 0, region_list:num_items() - 1 do
		local current_region = region_list:item_at(i);
		local current_region_religion_amount = current_region:religion_proportion(religion_key);
		
		if current_region_religion_amount > highest_religion_amount then
			highest_religion_region = current_region;
			highest_religion_amount = current_region_religion_amount;
		end;
	end;

	return highest_religion_region, highest_religion_amount;
	]]
end;


--- @function create_storm_for_region
--- @desc Creates a storm of a given type in a given region. This calls the @episodic_scripting:create_storm_for_region function of the same name on the underlying episodic scripting interface, but adds validation and output.
--- @p string region key
--- @p number storm strength
--- @p number duration
--- @p string storm type
function campaign_manager:create_storm_for_region(region_key, strength, duration, storm_type)
	if not is_string(region_key) then
		script_error("ERROR: create_storm_for_region() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return false;
	end;
	
	if not is_number(strength) or strength < 1 then
		script_error("ERROR: create_storm_for_region() called but supplied strength value [" .. tostring(strength) .. "] is not a number greater than zero");
		return false;
	end;
	
	if not is_number(duration) or duration < 0 then
		script_error("ERROR: create_storm_for_region() called but supplied duration value [" .. tostring(duration) .. "] is not a positive number");
		return false;
	end;
	
	if not is_string(storm_type) then
		script_error("ERROR: create_storm_for_region() called but supplied storm_type string [" .. tostring(storm_type) .. "] is not a string");
		return false;
	end;
	
	out("* create_storm_for_region() called, creating storm type [" .. storm_type .. "] in region [" .. region_key .. "]");

	self.game_interface:create_storm_for_region(region_key, strength, duration, storm_type);
end;


--- @function get_province_capital_for_region
--- @desc Returns the region designated as the province capital, for the supplied region's province.
--- @p region region
--- @r region province capital region
function campaign_manager:get_province_capital_for_region(region)
	if region:is_province_capital() then
		return region;
	end;

	local region_list = region:province():regions();

	for i = 0, region_list:num_items() - 1 do
		if region_list:item_at(i):is_province_capital() then
			return region_list:item_at(i);
		end;
	end;
end;


--- @function get_closest_region_for_faction
--- @desc Returns the region controlled by the specified faction that is closest to a supplied set of logical co-ordinates. If no co-ordinates are supplied then the logical position of the camera is used.
--- @desc An optional condition function may be supplied which each region must pass in order to be considered eligible in the result. If supplied, this condition function will be called for each region and will be supplied that region object as a single argument. The function should return a value that evaluates to a boolean to determine the result of the condition test.
--- @desc If the specified faction controls no regions, or none pass the condition, then @nil will be returned.
--- @p faction faction, Faction object.
--- @p [opt=nil] @number x, Logical x co-ordinate.
--- @p [opt=nil] @number y, Logical y co-ordinate.
--- @p [opt=nil] @function condition, Conditional test.
--- @r region closest eligible region
function campaign_manager:get_closest_region_for_faction(faction, x, y, condition)
	if not validate.is_faction(faction) then
		return false;
	end;

	if x and not validate.is_positive_number(x) then
		return false;
	end;

	if y and not validate.is_positive_number(y) then
		return false;
	end;

	if condition and not validate.is_function(condition) then
		return false;
	end;

	if not x and not y then
		x, y = self:get_camera_position();
		x, y = self:dis_to_log(x, y);
	end;

	local region_list = faction:region_list();

	local closest_dist = 9999999;
	local closest_region;
	for i = 0, region_list:num_items() - 1 do
		local current_region = region_list:item_at(i);
		local current_settlement = current_region:settlement();
		local current_x = current_settlement:logical_position_x();
		local current_y = current_settlement:logical_position_y();

		local current_dist = distance_squared(x, y, current_x, current_y);
		if current_dist < closest_dist then
			if not condition or condition == true or condition(current_region) then
				closest_dist = current_dist;
				closest_region = current_region;
			end;
		end;
	end;

	return closest_region;
end;


--- @function get_regions_adjacent_to_faction
--- @desc Returns an indexed @table of all regions or region keys adjacent to those regions held by the supplied faction. The faction may be specified by @string faction key or as a @faction interface.
--- @desc If an optional condition function is supplied then it is called for each region with the region supplied as a single argument. In this case, the condition function must return true for the region to be included in the results.
--- @p faction faction specifier, Faction specifier - this can be a faction script interface object, or a @string faction key from the <code>factions</code> database table.
--- @p [opt=false] return regions as keys, Populate the returned table with region keys, rather than @region interfaces.
--- @r @table table of all adjacent regions
function campaign_manager:get_regions_adjacent_to_faction(faction_specifier, condition, return_regions_as_keys)
	local faction = cm:get_faction(faction_specifier, true);
	if not faction then
		return false;
	end;

	if condition and not validate.is_function(condition) then
		return false;
	end;

	local adjacent_region_table_indexed = {};
	local adjacent_region_table_lookup = {};

	local region_list = faction:region_list();

	for i, region in model_pairs(region_list) do
		local adjacent_region_list = region:adjacent_region_list();
		for j, adjacent_region in model_pairs(adjacent_region_list) do
			local adjacent_region_name = adjacent_region:name();

			if not adjacent_region_table_lookup[adjacent_region_name] then
				if not condition or condition(adjacent_region) then
					adjacent_region_table_lookup[adjacent_region_name] = adjacent_region;
					table.insert(adjacent_region_table_indexed, adjacent_region);
				end;
			end;
		end;
	end;

	-- adjacent_region_table_indexed will include the specified faction's regions as well, so rebuild the list without them
	local retval = {};
	for i = 1, #adjacent_region_table_indexed do
		local current_region = adjacent_region_table_indexed[i];
		if current_region:owning_faction() ~= faction then
			if return_regions_as_keys then
				table.insert(retval, current_region:name());
			else
				table.insert(retval, current_region);
			end;
		end;
	end;

	return retval;
end;



--- @function get_corruption_value_in_province
--- @desc Returns the value of the key specified corruption in the specified province object. It may also be supplied a province key in place of a province object.
--- @p object province or province key
--- @p string corruption pooled resource key
--- @r number corruption value
function campaign_manager:get_corruption_value_in_province(province, corruption_key)
	if not is_string(province) and not is_province(province) then
		script_error("ERROR: get_corruption_value_in_province() called, but supplied province [" .. tostring(province) .. "] is not a string or province object");
		return false;
	end;
	
	if not is_string(corruption_key) then
		script_error("ERROR: get_corruption_value_in_province() called, but supplied corruption key [" .. tostring(corruption_key) .. "] is not a string");
		return false;
	end;
	
	if is_string(province) then
		province = cm:get_region(province);
		
		if not is_region(province) then
			script_error("ERROR: get_corruption_value_in_province() called, but supplied province string [" .. tostring(province) .. "] is not a valid province");
			return false;
		end;
	end;
	
	local pooled_resource = province:pooled_resource_manager():resource(corruption_key);
	
	if pooled_resource:is_null_interface() then
		script_error("ERROR: get_corruption_value_in_province() called, but supplied province does not have pooled resource with key [" .. tostring(corruption_key) .. "]");
		return false;
	else
		return pooled_resource:value();
	end;
end;


--- @function get_corruption_value_in_region
--- @desc Returns the value of the key specified corruption in the specified region object. It may also be supplied a region key in place of a region object.
--- @p object region or region key
--- @p string corruption pooled resource key
--- @r number corruption value
function campaign_manager:get_corruption_value_in_region(region, corruption_key)
	if not is_string(region) and not is_region(region) then
		script_error("ERROR: get_corruption_value_in_region() called, but supplied region [" .. tostring(region) .. "] is not a string or region object");
		return false;
	end;
	
	if not is_string(corruption_key) then
		script_error("ERROR: get_corruption_value_in_region() called, but supplied corruption key [" .. tostring(corruption_key) .. "] is not a string");
		return false;
	end;
	
	if is_string(region) then
		region = cm:get_region(region);
		
		if not is_region(region) then
			script_error("ERROR: get_corruption_value_in_region() called, but supplied region string [" .. tostring(region) .. "] is not a valid region");
			return false;
		end;
	end;
	
	local pooled_resource = region:province():pooled_resource_manager():resource(corruption_key);
	
	if pooled_resource:is_null_interface() then
		script_error("ERROR: get_corruption_value_in_region() called, but supplied region does not have pooled resource with key [" .. tostring(corruption_key) .. "]");
		return false;
	else
		return pooled_resource:value();
	end;
end;


--- @function get_highest_corruption_in_region
--- @desc Returns the key and value of the highest value corruption in the specified region object. The region may be specified by string key or supplied as a region script interface object.
--- @desc A list of specific corruption types to consider can optionally be specified, otherwise all corruption types are considered. 
--- @desc <code>False</code> is returned if no corruption is present.
--- @p object region, Region script interface or @string region key.
--- @p [opt=DEFAULT_VALUE] @table corruption types to check, Should be numerically indexed list. If unspecified, will use the default table of all corruption types.
--- @r @string corruption pooled resource key
--- @r @string and @number The key of the highest corruption in the region, and the value of that corruption.
function campaign_manager:get_highest_corruption_in_region(region, corruption_types_to_check)	
	if not is_string(region) and not is_region(region) then
		script_error("ERROR: get_highest_corruption_in_region() called, but supplied region [" .. tostring(region) .. "] is not a string or region object");
		return false, false;
	end;
	
	if is_string(region) then
		region = cm:get_region(region);
		
		if not is_region(region) then
			script_error("ERROR: get_highest_corruption_in_region() called, but supplied region string [" .. tostring(region) .. "] is not a valid region");
			return false, false;
		end;
	end;

	if corruption_types_to_check == nil then
		corruption_types_to_check = corruption_types;
	elseif not validate.is_table(corruption_types_to_check) then
		return false, false;
	end;
	
	local prm = region:province():pooled_resource_manager();
	local current_highest_corruption_value = 0;
	local current_highest_corruption_key = false;
	
	for i = 1, #corruption_types_to_check do
		local current_corruption = prm:resource(corruption_types_to_check[i]);
		
		if current_corruption:is_null_interface() then
			script_error("ERROR: get_highest_corruption_in_region() called, but supplied region does not have corruption as a pooled resource");
			return false, false;
		else
			local current_corruption_value = current_corruption:value();
			
			if current_corruption_value > current_highest_corruption_value then
				current_highest_corruption_value = current_corruption_value;
				current_highest_corruption_key = corruption_types_to_check[i];
			end;
		end;
	end;
	
	return current_highest_corruption_key, current_highest_corruption_value
end;


--- @function get_total_corruption_value_in_region
--- @desc Returns the total value of all corruption types in the specified region object. It may also be supplied a region key in place of a region object.
--- @p object region or region key
--- @r number total corruption value
function campaign_manager:get_total_corruption_value_in_region(region)	
	if not is_string(region) and not is_region(region) then
		script_error("ERROR: get_total_corruption_value_in_region() called, but supplied region [" .. tostring(region) .. "] is not a string or region object");
		return false;
	end;
	
	if is_string(region) then
		region = cm:get_region(region);
		
		if not is_region(region) then
			script_error("ERROR: get_highest_corruption_in_region() called, but supplied region string [" .. tostring(region) .. "] is not a valid region");
			return false;
		end;
	end;
	
	local prm = region:province():pooled_resource_manager();
	local total_corruption_value = 0;
	
	for i = 1, #corruption_types do
		local current_corruption = prm:resource(corruption_types[i]);
		
		if current_corruption:is_null_interface() then
			script_error("ERROR: get_highest_corruption_in_region() called, but supplied region does not have corruption as a pooled resource");
			return false;
		else
			total_corruption_value = total_corruption_value + current_corruption:value();
		end;
	end;
	
	return total_corruption_value;
end;


-- Takes an argument that is either a region-key string or a region interface, and returns it as a region interface. Otherwise returns false.
function campaign_manager:handle_region_arg(region_arg)
	local region = nil;
	if not is_string(region_arg) and not is_region(region_arg) then
		script_error(string.format(
			"ERROR: %s() called, but supplied region [%s] is not a string or region object",
			tostring(debug.getinfo(2)), tostring(region_arg)
		));
		return false;
	end;
	
	if is_string(region_arg) then
		region = cm:get_region(region_arg);
		
		if not is_region(region) then
			script_error(string.format(
				"ERROR: %s() called, but supplied region string [%s] is not a valid region",
				tostring(debug.getinfo(2)), tostring(region_arg)
			));
			return false;
		end;
	else
		region = region_arg;
	end;
	return region;
end;


--- @function change_corruption_in_province_by
--- @desc Applies the specified value (may be positive or negative) to the @province's pooled resource manager. The corruption type must be an entry in the campaign manager corruption_types list. Non-corruption pooled resources are not accepted.
--- @p @province or @string province, The province interface or province key
--- @p @string or nil corruption_type, The key of the corruption pooled resource. If nil, will be interpreted as uncorrupted and all other corruptions will be reduced by the value (or increased, if the value is negative).
--- @p @number value, The positive or negative value to add to the regiuon's corruption
--- @p [opt=nil] @string factor, The factor to adjust the corruption with.
function campaign_manager:change_corruption_in_province_by(province, corruption_type, value, factor)
	province = self:get_province(province);

	if not province or province:is_null_interface() then
		script_error("ERROR: change_corruption_in_province_by() called but province [" .. tostring(province) .. "] could not be resolved to a province interface. Is this an incorrect key, or a non-land province?");
		return false;
	end;

	if corruption_type ~= nil and corruption_types_set[corruption_type] == nil then
		script_error("ERROR: change_corruption_in_province_by() called but string [" .. tostring(corruption_type) .. "] is not a valid corruption key as defined in the corruption_types list.");
		return false;
	end;

	local resources_to_transact = nil
	if corruption_type == nil then
		resources_to_transact = corruption_types;
		value = -value;
	else
		resources_to_transact = { corruption_type };
	end

	for r = 1, #resources_to_transact do
		local resource = province:pooled_resource_manager():resource(resources_to_transact[r]);
		if resource == nil or resource:is_null_interface() then
			script_error(string.format(
				"ERROR: change_corruption_in_province_by() called with corruption [%s] but corruption of type [%s] was not available in province [%s].",
				tostring(corruption_type), resources_to_transact[r], province:name()
			));
			return false;
		end;

		if factor == nil then
			self:pooled_resource_factor(resource, value);
		else
			self:pooled_resource_factor_transaction(resource, factor, value);
		end;
	end;
end;













-----------------------------------------------------------------------------
--- @section Settlement Queries
-----------------------------------------------------------------------------


--	returns display or logical position of a settlement - for internal use, call
--	settlement_display_pos() or settlement_logical_pos() externally
function campaign_manager:settlement_pos(settlement_name, display)
	if not is_string(settlement_name) then
		script_error("ERROR: settlement_pos() called but supplied name [" .. tostring(settlement_name) .. "] is not a string");
		return false;
	end;
	
	local settlement = self:model():world():region_manager():settlement_by_key(settlement_name);
	
	if not settlement then
		script_error("ERROR: settlement_pos() called but no settlement found with supplied name [" .. settlement_name .. "]");
		return false;
	end;
	
	if display then
		return settlement:display_position_x(), settlement:display_position_y();
	else
		return settlement:logical_position_x(), settlement:logical_position_y();
	end;
end;


--- @function settlement_display_pos
--- @desc Returns the display position of a supplied settlement by string name.
--- @p string settlement name
--- @r number x display position
--- @r number y display position
function campaign_manager:settlement_display_pos(settlement_name)
	return self:settlement_pos(settlement_name, true);
end;


--- @function settlement_logical_pos
--- @desc Returns the logical position of a supplied settlement by string name.
--- @p string settlement name
--- @r number x logical position
--- @r number y logical position
function campaign_manager:settlement_logical_pos(settlement_name)
	return self:settlement_pos(settlement_name, false);
end;


--- @function get_closest_settlement_from_faction_to_faction
--- @desc Returns the closest settlement from the specified subject faction to a foreign faction. The function returns the region of the closest settlement, although nil is returned if the source faction contains no settlements or the target faction no military forces.
--- @p object subject faction, Subject faction specifier. This can be a faction object or a string faction key from the <code>factions</code> database table.
--- @p object foreign faction, Foreign faction specifier. This can be a faction object or a string faction key from the <code>factions</code> database table.
--- @r region region containing closest settlement
function campaign_manager:get_closest_settlement_from_faction_to_faction(subject_faction_specifier, foreign_faction_specifier)

	local subject_faction = self:get_faction(subject_faction_specifier);
	if not subject_faction then
		script_error("ERROR: get_closest_settlement_from_faction_to_faction() called but supplied subject faction specifier [" .. tostring(subject_faction_specifier) .. "] is not a string or faction object, or no faction was found");
		return false;
	end;

	local foreign_faction = self:get_faction(foreign_faction_specifier);
	if not foreign_faction then
		script_error("ERROR: get_closest_settlement_from_faction_to_faction() called but supplied foreign faction specifier [" .. tostring(foreign_faction_specifier) .. "] is not a string or faction object, or no faction was found");
		return false;
	end;

	-- get closest military force from subject faction for each of the foreign faction's military forces
	local subject_region_list = subject_faction:region_list();
	local foreign_mf_list = foreign_faction:military_force_list();

	local closest_region;
	local closest_dist = 9999999;

	for i = 0, subject_region_list:num_items() - 1 do
		local current_region = subject_region_list:item_at(i);
		local current_settlement = current_region:settlement();

		for j = 0, foreign_mf_list:num_items() - 1 do
			local current_mf = foreign_mf_list:item_at(j);
			
			if current_mf:has_general() then
				local current_char = current_mf:general_character();
				local current_dist = distance_squared(current_char:logical_position_x(), current_char:logical_position_y(), current_settlement:logical_position_x(), current_settlement:logical_position_y());

				if current_dist < closest_dist then
					closest_dist = current_dist;
					closest_region = current_region;
				end;
			end;
		end;
	end;

	return closest_region;
end;


--- @function get_closest_settlement_from_table_to_faction
--- @desc Returns the closest settlement from the specified table of region keys to a foreign faction. The function returns the region of the closest settlement, although nil is returned if no closest region could be found.
--- @p @table region keys, Table of region keys, each a key from the <code>campaign_map_regions</code> database table.
--- @p object foreign faction, Foreign faction specifier. This can be a faction object or a string faction key from the <code>factions</code> database table.
--- @r region region containing closest settlement
--- @r @number distance of closest settlement, or @nil if none could be found
function campaign_manager:get_closest_settlement_from_table_to_faction(region_table, faction_specifier)

	if not validate.is_table_of_strings(region_table) then
		return false;
	end;

	local faction = self:get_faction(faction_specifier);
	if not faction then
		script_error("ERROR: get_closest_settlement_from_table_to_faction() called but supplied foreign faction specifier [" .. tostring(faction_specifier) .. "] is not a string or faction object, or no faction was found");
		return false;
	end;

	local closest_region = false;
	local closest_region_distance = 9999999;

	for i = 1, #region_table do
		local current_region = self:get_region(region_table[i]);

		if current_region then
			local current_settlement = current_region:settlement();

			local closest_region_from_faction, closest_region_from_faction_distance = self:get_closest_settlement_from_faction_to_position(faction, current_settlement:logical_position_x(), current_settlement:logical_position_y(), false);

			if closest_region_from_faction and closest_region_from_faction_distance < closest_region_distance then
				closest_region = current_region;
				closest_region_distance = closest_region_from_faction_distance;
			end;
		else
			script_error("WARNING: get_closest_settlement_from_table_to_faction() cannot find region with key [" .. region_table[i] .. "] in supplied table, index of value is [" .. i .. "]. Disregarding.");
		end;
	end;

	if closest_region then
		return closest_region, closest_region_distance;
	end;
end;


--- @function get_closest_settlement_from_faction_to_position
--- @desc Returns the closest settlement from the specified subject faction to a specified position. The function returns the region of the closest settlement, although nil is returned if the source faction contains no settlements.
--- @desc By default the supplied co-ordinates should specify a logical position to test against. If the use-display-coordinates flag is set, then the supplied co-ordinates should be a display position.
--- @p object subject faction, Subject faction specifier. This can be a faction object or a string faction key from the <code>factions</code> database table.
--- @p @number x, x co-ordinate. This should be a logical co-ordinate by default, or a display co-ordinate if the use-display-coordinates flag is set.
--- @p @number y, y co-ordinate. This should be a logical co-ordinate by default, or a display co-ordinate if the use-display-coordinates flag is set.
--- @p [opt=false] @boolean use display co-ordinates, Sets the function to accept display co-ordinates rather than logical co-ordinates.
--- @r region region containing closest settlement
--- @r @number distance, or @nil if no region is returned
function campaign_manager:get_closest_settlement_from_faction_to_position(subject_faction_specifier, x, y, use_display_coordinates)

	local subject_faction = self:get_faction(subject_faction_specifier);
	if not subject_faction then
		script_error("ERROR: get_closest_settlement_from_faction_to_position() called but supplied subject faction specifier [" .. tostring(subject_faction_specifier) .. "] is not a string or faction object");
		return false;
	end;

	if not validate.is_positive_number(x) or not validate.is_positive_number(y) then
		return false;
	end;

	if use_display_coordinates then
		x, y = self:dis_to_log(x, y);
	end;

	-- get closest military force from subject faction for each of the foreign faction's military forces
	local subject_region_list = subject_faction:region_list();

	local closest_region;
	local closest_dist = 9999999;

	for i = 0, subject_region_list:num_items() - 1 do
		local current_region = subject_region_list:item_at(i);
		local current_settlement = current_region:settlement();

		local current_dist = distance_squared(x, y, current_settlement:logical_position_x(), current_settlement:logical_position_y());

		if current_dist < closest_dist then
			closest_dist = current_dist;
			closest_region = current_region;
		end;
	end;

	if closest_region then
		return closest_region, closest_dist ^ 0.5;
	end;
end;


--- @function get_closest_settlement_from_faction_to_camera
--- @desc Returns the closest settlement from the specified subject faction to the camera. The function returns the region of the closest settlement, although nil is returned if the source faction contains no settlements.
--- @desc If this function is called in multiplayer mode the capital of the specified faction is returned, as testing the camera position in inherently unsafe in multiplayer.
--- @p object subject faction, Subject faction specifier. This can be a faction object or a string faction key from the <code>factions</code> database table.
--- @r region region containing closest settlement
function campaign_manager:get_closest_settlement_from_faction_to_camera(faction_specifier)

	if self:is_multiplayer() then
		local subject_faction = self:get_faction(faction_specifier);
		if not subject_faction then
			script_error("ERROR: get_closest_settlement_from_faction_to_camera() called but supplied subject faction specifier [" .. tostring(faction_specifier) .. "] is not a string or faction object");
			return false;
		end;

		if faction:has_home_region() then
			return faction:home_region();
		end;

		script_error("WARNING: get_closest_settlement_from_faction_to_camera() called in multiplayer mode, and the specified faction with key [" .. faction:name() .. "] has no home region - returning nil");
		return;
	end;
	
	local x, y = self:get_camera_position();

	return self:get_closest_settlement_from_faction_to_position(faction_specifier, x, y, true);
end;












-----------------------------------------------------------------------------
--- @section Pre and Post-Battle Events
--- @desc The campaign manager automatically monitors battles starting and finishing, and fires events at certain key times during a battle sequence that client scripts can listen for.
--- @desc The campaign manager fires the following pre-battle events <b>in singleplayer mode only</b>. The pending battle may be accessed on the context of each with <code>context:pending_battle()</code>:
--- @desc <table class="simple"><tr><td><strong>Event</strong></td><td><strong>Trigger Condition</strong></td></tr>
--- @desc <tr><td><code>ScriptEventPreBattlePanelOpened</code></td><td>The pre-battle panel has opened on the local machine.</td></tr>
--- @desc <tr><td><code>ScriptEventPreBattlePanelOpenedAmbushPlayerDefender</code></td><td>The pre-battle panel has opened on the local machine and the player is the defender in an ambush.</td></tr>
--- @desc <tr><td><code>ScriptEventPreBattlePanelOpenedAmbushPlayerAttacker</code></td><td>The pre-battle panel has opened on the local machine and the player is the attacker in an ambush.</td></tr>
--- @desc <tr><td><code>ScriptEventPreBattlePanelOpenedMinorSettlement</code></td><td>The pre-battle panel has opened on the local machine and the battle is at a minor settlement.</td></tr>
--- @desc <tr><td><code>ScriptEventPreBattlePanelOpenedProvinceCapital</code></td><td>The pre-battle panel has opened on the local machine and the battle is at a province capital.</td></tr>
--- @desc <tr><td><code>ScriptEventPreBattlePanelOpenedField</code></td><td>The pre-battle panel has opened on the local machine and the battle is a field battle.</td></tr>
--- @desc <tr><td><code>ScriptEventPlayerBattleStarted</code></td><td>Triggered when the local player initiates a battle from the pre-battle screen, either by clicking the attack or autoresolve button.</td></tr></table>
--- @desc  
--- @desc The campaign manager fires the following events post-battle events in singleplayer and multiplayer modes.
--- @desc <table class="simple"><tr><td><strong>Event</strong></td><td><strong>Trigger Condition</strong></td></tr>
--- @desc <tr><td><code>ScriptEventBattleSequenceCompleted</code></td><td>This event is triggered when any battle sequence is completed, whether a battle was fought or not.</td></tr>
--- @desc <tr><td><code>ScriptEventPlayerBattleSequenceCompleted</code></td><td>This event is triggered after a battle sequence involving a human player has been completed and the camera has returned to its normal completion, whether a battle was fought or not.</td></tr></table>
--- @desc  
--- @desc It also fires the following events post-battle in singleplayer and multiplayer modes, for battle victories/defeats involving a human player. If multiple human players are involved in a single battle, then an event is generated for each. The pending battle and the involved human faction can be accessed on the context of each with <code>context:pending_battle()</code> and <code>context:faction()</code> respectively:
--- @desc <table class="simple"><tr><td><strong>Event</strong></td><td><strong>Trigger Condition</strong></td></tr>
--- @desc <tr><td><code>ScriptEventHumanWinsBattle</code></td><td>A human player has won a battle.</td></tr>
--- @desc <tr><td><code>ScriptEventHumanWinsFieldBattle</code></td><td>A human player has won a field battle. A "field" battle is a non-settlement battle, although it would include a battle where a settlement defender sallied against the besieging player.</td></tr>
--- @desc <tr><td><code>ScriptEventHumanWinsSettlementDefenceBattle</code></td><td>A human player has won a settlement defence battle as the defender (including a battle where the player sallied).</td></tr>
--- @desc <tr><td><code>ScriptEventHumanWinsSettlementAttackBattle</code></td><td>A human player has won a settlement defence battle as the attacker. They should have captured the settlement if this event has been received.</td></tr>
--- @desc <tr><td><code>ScriptEventHumanLosesSettlementDefenceBattle</code></td><td>A human player has lost a settlement defence battle as the defender.</td></tr>
--- @desc <tr><td><code>ScriptEventHumanLosesSettlementAttackBattle</code></td><td>A human player has lost a settlement defence battle as the attacker.</td></tr>
--- @desc <tr><td><code>ScriptEventHumanLosesFieldBattle</code></td><td>A human player has lost a field (non-settlement) battle.</td></tr></table>
-----------------------------------------------------------------------------

function campaign_manager:start_processing_battle_listeners(is_multiplayer)

	--
	-- Singleplayer-only listeners
	-- Work towards removing these and replacing them with equivalents that work in multiplayer.
	if not is_multiplayer then

		-- Trigger ScriptEventPlayerBattleStarted in singleplayer mode if attack or autoresolve buttons are clicked
		core:add_listener(
			"processing_battle_listener",
			"ComponentLClickUp",
			function(context) return context.string == "button_attack" or context.string == "button_autoresolve" end,
			function()
				core:trigger_event("ScriptEventPlayerBattleStarted");
			end,
			true
		);

		-- Trigger pre-battle panel events in singleplayer
		core:add_listener(
			"processing_battle_listener",
			"PanelOpenedCampaign",
			function(context) return context.string == "popup_pre_battle" end,
			function(context)
				local pb = self:model():pending_battle();
				local battle_type = pb:battle_type();
				
				core:trigger_event("ScriptEventPreBattlePanelOpened", pb);
				
				-- check if this is an ambush
				out("popup_pre_battle panel has opened, battle type is " .. battle_type);
				
				if battle_type == "land_ambush" then
					local local_faction_name = self:get_local_faction_name(true);
					if local_faction_name then
						if self:pending_battle_cache_faction_is_defender(local_faction_name) then
							-- this is an ambush battle in which the player is the defender
							core:trigger_event("ScriptEventPreBattlePanelOpenedAmbushPlayerDefender", pb);
						else
							-- this is an ambush 
							core:trigger_event("ScriptEventPreBattlePanelOpenedAmbushPlayerAttacker", pb);
						end;
					end;
					
					return;
				end;
				
				-- if siege buttons are visible then this must be a siege battle
				local uic_button_set_siege = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "button_set_siege");
				
				if uic_button_set_siege and uic_button_set_siege:Visible() then
					-- this is a battle at a settlement, if the encircle button is visible then it's a minor settlement
					local uic_encircle_button = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "button_surround");
				
					if uic_encircle_button and uic_encircle_button:Visible() then
						-- this is a battle at a minor settlement
						core:trigger_event("ScriptEventPreBattlePanelOpenedMinorSettlement", pb);
					else
						-- this is a battle at a province capital
						core:trigger_event("ScriptEventPreBattlePanelOpenedProvinceCapital", pb);
					end;
				else
					-- this is a regular field battle
					core:trigger_event("ScriptEventPreBattlePanelOpenedField", pb);
				end;
			end,
			true
		);
	end;

	core:add_listener(
		"processing_battle_listener",
		"PendingBattle",
		true,
		function(context)
			local pb = context:pending_battle();
			local attacker = pb:attacker();
			local defender = pb:defender();
			out("");
			out("**** PendingBattle event received, starting battle sequence - attacking character is " ..
				(pb:has_attacker() and ("[" .. self:char_name_to_string(attacker) .. "] with cqi [" .. attacker:command_queue_index() .. "] of faction [" .. attacker:faction():name() .. "]") or "<no attacker?>") .. ", defending character is " ..
				(pb:has_defender() and ("[" .. self:char_name_to_string(defender) .. "] with cqi [" .. defender:command_queue_index() .. "] of faction [" .. defender:faction():name() .. "] at position [" .. defender:logical_position_x() .. ", " .. defender:logical_position_y() .. "]") or "<no defender?>") .. 
				(pb:has_contested_garrison() and (", the battle is being fought over a settlement [" .. pb:contested_garrison():settlement_interface():key() .. "] in region [" .. pb:contested_garrison():region():name() .. "]") or ""));

			if self.processing_battle then
				script_error("WARNING: PendingBattle event has been received but processing_battle flag is already true - how can this be?");
			end;

			self.processing_battle = true;
		end,
		true
	);

	local battle_completed_camera_move_event_received_for_current_battle = false;

	-- List of human factions. At the time this function is called it's too early to populate, so we do it when the first BattleCompleted event is received.
	local human_factions = false;

	-- Forward-declare these functions, just because they look nicer at the bottom
	local battle_sequence_completed = false;
	local trigger_events_for_player_involvement_in_battle = false;
	
	--
	-- BattleCompletedCameraMove listener
	-- This is received when the player is a participant in a battle and the camera has started to pull back up to gameplay altitude after
	-- the battle. It is received in multiplayer as well as singleplayer. When it's received, we set a flag which makes the battle sequence last
	-- a couple of seconds longer, allowing the camera movement to finish (otherwise we'd start getting missions and events popping off as the
	-- camera is underway)
	core:add_listener(
		"processing_battle_listener",
		"BattleCompletedCameraMove",
		true,
		function(context)
			battle_completed_camera_move_event_received_for_current_battle = true;
		end,
		true
	);


	--
	-- BattleCompleted listener
	-- This is received whenever any battle sequence finishes, whether the battle was fought or not (participants withdrew, maintain siege etc).
	-- If the BattleCompletedCameraMove event has already been received then a player is participating in the battle - in this case, if it's a
	-- player's turn, we wait for a couple of seconds for the camera to pull back up to gameplay altitude before sending notifications that the
	-- battle sequence is over.
	--
	-- If the battle has been fought, we also try and trigger events for any player involvement.
	core:add_listener(
		"processing_battle_listener",
		"BattleCompleted",
		true,
		function()
			if not self.processing_battle then
				script_error("WARNING: PendingBattle event has been received but processing_battle flag is false - how can we be completing a battle if one isn't happening?");
			end;

			local pb = self:model():pending_battle();
			local battle_fought = cm:model():pending_battle():has_been_fought();

			-- Output
			out("**** BattleCompleted event received, " ..
			(
				battle_fought and
				(
					pb:attacker_won() and "the attacker won" or 
					(
						pb:defender_won() and "the defender won" or 
						(
							pb:is_draw() and "the battle was drawn" or "could not determine result of battle"
						)
					)
				) or "the battle was not fought"
			));

			local is_human_factions_turn = self:is_human_factions_turn();

			--
			-- Complete the battle sequence (or wait two seconds to do it, if it's a player's turn)
			if battle_completed_camera_move_event_received_for_current_battle then
				battle_completed_camera_move_event_received_for_current_battle  = false;

				if is_human_factions_turn then
					-- The BattleCompletedCameraMove event has already been received and it's a player's turn, which means we're pulling back up to gameplay altitude. Wait a couple of seconds before completing.
					self:callback(
						function() 
							battle_sequence_completed(battle_fought, is_human_factions_turn);
						end, 
						2
					);
					out("\twaiting for the camera movement to complete before completing battle sequence");
				else
					battle_sequence_completed(battle_fought, is_human_factions_turn);
				end;
			else
				battle_sequence_completed(battle_fought, is_human_factions_turn);
			end;

			--
			-- If the battle has been fought then send custom events for each human faction
			if battle_fought then
				trigger_events_for_player_involvement_in_battle(pb)
			end;
		end,
		true
	);

	--
	-- local function to complete the battle sequence
	function battle_sequence_completed(battle_fought, is_human_factions_turn)
		self.processing_battle = false;

		if is_human_factions_turn then
			out("**** Battle sequence involving a player has fully completed, triggering ScriptEventPlayerBattleSequenceCompleted and ScriptEventBattleSequenceCompleted");
			core:trigger_custom_event("ScriptEventPlayerBattleSequenceCompleted", {battle_fought = battle_fought});
		else
			out("**** Battle sequence completed, triggering ScriptEventBattleSequenceCompleted.");
		end;
		out("");

		core:trigger_event("ScriptEventBattleSequenceCompleted");
	end;


	--
	-- local function to trigger events for player involvement in a battle that has been fought
	function trigger_events_for_player_involvement_in_battle(pb)
		local attacker_victory = self:pending_battle_cache_attacker_victory();
		local defender_victory = self:pending_battle_cache_defender_victory();

		local is_settlement_battle = pb:has_contested_garrison();
		local battle_type = pb:battle_type();

		-- Populate this local value the first time we get here
		if not human_factions then
			human_factions = self:get_human_factions();
		end;

		for i = 1, #human_factions do
			local human_faction_name = human_factions[i];
			if self:pending_battle_cache_faction_is_attacker(human_faction_name) then
				local human_faction = cm:get_faction(human_faction_name);
				if attacker_victory then
					-- Human is attacker and the attacker won the battle
					if is_settlement_battle then
						if battle_type == "settlement_sally" then
							-- the player has won a sally battle as the attacker - i.e. the player attacked out of the settlement
							out("**** Battle involving human faction [" .. human_faction_name .. "] has been fought - they won a sally battle as the attacker, triggering events ScriptEventHumanWinsSettlementDefenceBattle and ScriptEventHumanWinsBattle");
							core:trigger_event("ScriptEventHumanWinsSettlementDefenceBattle", pb, human_faction);
						else
							out("**** Battle involving human faction [" .. human_faction_name .. "] has been fought - they won a settlement battle as the attacker, triggering events ScriptEventHumanWinsSettlementAttackBattle and ScriptEventHumanWinsBattle");
							core:trigger_event("ScriptEventHumanWinsSettlementAttackBattle", pb, human_faction);
						end;
					else
						out("**** Battle involving human faction [" .. human_faction_name .. "] has been fought - they won a non-settlement battle as the attacker, triggering events ScriptEventHumanWinsFieldBattle and ScriptEventHumanWinsBattle");
						core:trigger_event("ScriptEventHumanWinsFieldBattle", pb, human_faction);
					end;
					core:trigger_event("ScriptEventHumanWinsBattle", pb, human_faction);
				else
					-- Human is attacker and the defender won the battle
					if is_settlement_battle then
						if battle_type == "settlement_sally" then
							-- the player has lost a sally battle as the attacker - i.e. the player attacked out of the settlement
							out("**** Battle involving human faction [" .. human_faction_name .. "] has been fought - they lost a sally battle as the attacker, triggering events ScriptEventHumanLosesSettlementDefenceBattle and ScriptEventHumanLosesBattle");
							core:trigger_event("ScriptEventHumanLosesSettlementDefenceBattle", pb, human_faction);
						else
							out("**** Battle involving human faction [" .. human_faction_name .. "] has been fought - they lost a settlement battle as the attacker, triggering events ScriptEventHumanLosesSettlementAttackBattle and ScriptEventHumanLosesBattle");
							core:trigger_event("ScriptEventHumanLosesSettlementAttackBattle", pb, human_faction);
						end;
					else
						out("**** Battle involving human faction [" .. human_faction_name .. "] has been fought - they lost a non-settlement battle as the attacker, triggering events ScriptEventHumanLosesFieldBattle and ScriptEventHumanLosesBattle");
						core:trigger_event("ScriptEventHumanLosesFieldBattle", pb, human_faction);
					end;
					core:trigger_event("ScriptEventHumanLosesBattle", pb, human_faction);
				end;

			elseif self:pending_battle_cache_faction_is_defender(human_faction_name) then
				local human_faction = cm:get_faction(human_faction_name);
				if attacker_victory then
					-- Human is defender and the attacker won the battle
					if is_settlement_battle then
						if battle_type == "settlement_sally" then
							-- the player has lost a sally battle as the defender - i.e. the player was sieging, and their opponent attacked out of the settlement
							out("**** Battle involving human faction [" .. human_faction_name .. "] has been fought - they lost a sally battle as the defender, triggering events ScriptEventHumanLosesFieldBattle and ScriptEventHumanLosesBattle");
							core:trigger_event("ScriptEventHumanLosesFieldBattle", pb, human_faction);
						else
							out("**** Battle involving human faction [" .. human_faction_name .. "] has been fought - they lost a settlement battle as the defender, triggering events ScriptEventHumanLosesSettlementDefenceBattle and ScriptEventHumanLosesBattle");
							core:trigger_event("ScriptEventHumanLosesSettlementDefenceBattle", pb, human_faction);
						end;
					else
						out("**** Battle involving human faction [" .. human_faction_name .. "] has been fought - they lost a non-settlement battle as the defender, triggering events ScriptEventHumanLosesFieldBattle and ScriptEventHumanLosesBattle");
						core:trigger_event("ScriptEventHumanLosesFieldBattle", pb, human_faction);
					end;
					core:trigger_event("ScriptEventHumanLosesBattle", pb, human_faction);
				else
					-- Human is defender and the defender won the battle
					if is_settlement_battle then
						if battle_type == "settlement_sally" then
							-- the player has won a sally battle as the defender - i.e. the player was sieging, and their opponent attacked out of the settlement but was defeated
							out("**** Battle involving human faction [" .. human_faction_name .. "] has been fought - they won a sally battle as the defender, triggering events ScriptEventHumanWinsSettlementAttackBattle and ScriptEventHumanWinsBattle");
							core:trigger_event("ScriptEventHumanWinsSettlementAttackBattle", pb, human_faction);
						else
							out("**** Battle involving human faction [" .. human_faction_name .. "] has been fought - they won a settlement battle as the defender, triggering events ScriptEventHumanWinsSettlementDefenceBattle and ScriptEventHumanWinsBattle");
							core:trigger_event("ScriptEventHumanWinsSettlementDefenceBattle", pb, human_faction);
						end;
					else
						out("**** Battle involving human faction [" .. human_faction_name .. "] has been fought - they won a non-settlement battle as the defender, triggering events ScriptEventHumanWinsFieldBattle and ScriptEventHumanWinsBattle");
						core:trigger_event("ScriptEventHumanWinsFieldBattle", pb, human_faction);
					end;
					core:trigger_event("ScriptEventHumanWinsBattle", pb, human_faction);
				end;
			end;
		end;
	end;
end;











-----------------------------------------------------------------------------
--- @section Pending Battle Cache
--- @desc Using the standard @model_hierarchy interfaces it can be difficult to get information about a battle after it has been fought. The only method provided by the @pending_battle interface to querying the forces that fought in a battle is through the @character interface (of the respective army commanders). If those commanders died in battle then these interfaces will no longer be available.
--- @desc The pending battle cache system stores information about a battle prior to it being fought, which can be queried after the battle. This allows the factions, characters, and military forces involved to be queried even if they died in the battle. The information will remain available for querying until the next battle occurs.
--- @desc The data in the cache may also be queried prior to battle. The script triggers a <code>ScriptEventPendingBattle</code> event after a <code>PendingBattle</code> event is received and the pending battle cache has been populated. Scripts that want to query the pending battle cache prior to battle can listen for this.
-----------------------------------------------------------------------------


-- called internally
function campaign_manager:start_pending_battle_cache()
	core:add_listener(
		"pending_battle_cache",
		"PendingBattle",
		true,
		function(context) self:cache_pending_battle() end,
		true
	);

	-- In multiplayer we rebuild the pending battle cache immediately prior to the battle being fought, as human players can decline to enter as reinforcements
	self:add_first_tick_callback(
		function()
			if self:is_multiplayer() then
				core:add_listener(
					"pending_battle_cache",
					"BattleBeingFought",
					true,
					function(context) self:cache_pending_battle() end,
					true
				);
			end;
		end
	);	
	
	-- Need to test for a pending battle on loading, as the above event "PendingBattle" isn't fired when loading into pre-battle screen. 
	-- If player has closed and opened game, svr values won't be saved.
	core:add_listener(
		"LoadingScreenDismissedTestForPendingBattle",
		"LoadingScreenDismissed",
		true,
		function() 
			local battle_active, battle_already_fought = self:is_pending_battle_active()

			if battle_active and not battle_already_fought then
				self:cache_pending_battle()
			end
		end,
		false
	)

	-- removed this, as removing the characters from the pending battle cache when they withdraw can cause issues, such
	-- as the progress_on_battle_completed listener never progressing
	--[[
	core:add_listener(
		"character_withdraw_cache",
		"CharacterWithdrewFromBattle",
		true,
		function(context) self:pending_battle_cache_remove_character(context) end,
		true
	);
	]]
end;


-- removes a character from the pending battle cache (no longer called any more)
function campaign_manager:pending_battle_cache_remove_character(context)
	local char = context:character();
	
	-- attempt to remove from attacker list
	for i = 1, #self.pbc_attackers do
		local current_cached_attacker = self.pbc_attackers[i];
		
		if current_cached_attacker.cqi == char:cqi() then
			table.remove(self.pbc_attackers, i);
			
			-- if we have no attackers left, then clear the defender list as well
			if #self.pbc_attackers == 0 then
				self.pbc_defenders = {};
			end;
			
			return;
		end;
	end;
	
	-- attempt to remove from defender list
	for i = 1, #self.pbc_defenders do
		local current_cached_defender = self.pbc_defenders[i];
		
		if current_cached_defender.cqi == char:cqi() then
			table.remove(self.pbc_defenders, i);
			
			-- if we have no defenders left, then clear the attacker list as well
			if #self.pbc_defenders == 0 then
				self.pbc_attackers = {};
			end;
			
			return;
		end;
	end;
end;


-- caches a pending battle character within a pending battle
function campaign_manager:cache_pending_battle_character(list, character)
	local record = {};
	
	record.cqi = character:cqi();
	record.fm_cqi = character:family_member():command_queue_index();
	record.faction_name = character:faction():name();
	record.units = {};
	record.embedded_character_subtypes = {};
	
	if character:has_military_force() then
		local mf = character:military_force();
		local unit_list = mf:unit_list();

		record.mf_cqi = mf:command_queue_index();
		
		for i = 0, unit_list:num_items() - 1 do
			local unit = unit_list:item_at(i);
			local unit_record = {};
			unit_record.unit_cqi = unit:command_queue_index();
			unit_record.unit_key = unit:unit_key();
			table.insert(record.units, unit_record);
		end;
		
		for _, embedded_character in model_pairs(mf:character_list()) do
			if record.cqi ~= embedded_character:command_queue_index() then
				table.insert(record.embedded_character_subtypes, embedded_character:character_subtype_key())
			end
		end
	else
		script_error("WARNING: cache_pending_battle_character() called but supplied character (cqi: [" .. character:cqi() .. "], faction name: [" .. character:faction():name() .. "]) has no military force, how can this be? Not going to add CQI.");
		return;
	end;

	table.insert(list, record);
end;


-- caches a pending battle
function campaign_manager:cache_pending_battle()
	local pb = self:model():pending_battle();

	local attackers = {};
	local defenders = {};
	local attacker_value = 0;
	local defender_value = 0;
	local attacker_units = 0;
	local defender_units = 0;
	
	-- cache attackers
	
	-- primary
	if pb:has_attacker() then
		self:cache_pending_battle_character(attackers, pb:attacker());
		attacker_value = attacker_value + self:force_gold_value(pb:attacker():military_force():command_queue_index());
		attacker_units = attacker_units + pb:attacker():military_force():unit_list():num_items();
	end;
	
	-- secondary
	local secondary_attacker_list = pb:secondary_attackers();
	for i = 0, secondary_attacker_list:num_items() - 1 do
		local attacker = secondary_attacker_list:item_at(i);
		self:cache_pending_battle_character(attackers, attacker);
		
		if pb:night_battle() == false then
			attacker_value = attacker_value + self:force_gold_value(attacker:military_force():command_queue_index());
			attacker_units = attacker_units + attacker:military_force():unit_list():num_items();
		end
	end;
	
	-- cache defenders
	
	-- defenders
	if pb:has_defender() then
		self:cache_pending_battle_character(defenders, pb:defender());
		defender_value = defender_value + self:force_gold_value(pb:defender():military_force():command_queue_index());
		defender_units = defender_units + pb:defender():military_force():unit_list():num_items();
	end;
	
	-- defenders
	local secondary_defenders_list = pb:secondary_defenders();
	for i = 0, secondary_defenders_list:num_items() - 1 do
		local defender = secondary_defenders_list:item_at(i);
		self:cache_pending_battle_character(defenders, secondary_defenders_list:item_at(i));
		
		if pb:night_battle() == false then
			defender_value = defender_value + self:force_gold_value(defender:military_force():command_queue_index());
			defender_units = defender_units + defender:military_force():unit_list():num_items();
		end
	end;
	
	if attacker_value < 1 then
		attacker_value = 1;
	end
	if defender_value < 1 then
		defender_value = 1;
	end
	
	self.pbc_attackers = attackers;
	self.pbc_defenders = defenders;
	self.pbc_attacker_value = attacker_value;
	self.pbc_defender_value = defender_value;
	self.pbc_attacker_unit_count = attacker_units;
	self.pbc_defender_unit_count = defender_units;
	
	self:set_pending_battle_svr_state(pb);
	
	if not self:is_multiplayer() and self:is_local_players_turn() then
		self:print_pending_battle_cache();
	end;
	
	core:trigger_event("ScriptEventPendingBattle", pb);
end;


-- output for pending battle cache system - can be used for debugging, and it happens automatically when a PendingBattle event occurs
function campaign_manager:print_pending_battle_cache()
	local attackers = self.pbc_attackers;
	local defenders = self.pbc_defenders;

	out("*****");
	out("printing pending battle cache");
	out("\tattackers:");
	for i = 1, #attackers do
		local current_record = attackers[i];
		out("\t\tvalue:" .. cm:pending_battle_cache_attacker_value());
		out(string.format(
			"\t\t%i faction: [%s], char_cqi: [%i], fm_cqi: [%i], mf_cqi: [%i]",
			i,
			current_record.faction_name,
			current_record.cqi,
			current_record.fm_cqi,
			current_record.mf_cqi
		));

		local units_output = "\t\t\t units: [";
		for j = 1, #current_record.units do
			local unit_record = current_record.units[j];
			
			units_output = units_output .. unit_record.unit_cqi .. "|" .. unit_record.unit_key;
			
			if j < #current_record.units then
				units_output = units_output .. ", "
			end;
		end;
		
		out(units_output .. "]");

		local embedded_characters_output = "\t\t\t embedded character subtypes: [";
		for j = 1, #current_record.embedded_character_subtypes do
			embedded_characters_output = embedded_characters_output .. current_record.embedded_character_subtypes[j];
			
			if j < #current_record.embedded_character_subtypes then
				embedded_characters_output = embedded_characters_output .. ", "
			end;
		end;
		
		out(embedded_characters_output .. "]");
	end;
	out("\tdefenders:");
	for i = 1, #defenders do
		local current_record = defenders[i];
		out("\t\tvalue:" .. cm:pending_battle_cache_defender_value());
		out(string.format(
			"\t\t%i faction: [%s], char_cqi: [%i], fm_cqi: [%i], mf_cqi: [%i]",
			i,
			current_record.faction_name,
			current_record.cqi,
			current_record.fm_cqi,
			current_record.mf_cqi
		));
		
		local units_output = "\t\t\t units: [";
		for j = 1, #current_record.units do
			local unit_record = current_record.units[j];
			
			units_output = units_output .. unit_record.unit_cqi .. "|" .. unit_record.unit_key;
			
			if j < #current_record.units then
				units_output = units_output .. ", "
			end;
		end;
		
		out(units_output .. "]");

		local embedded_characters_output = "\t\t\t embedded character subtypes: [";
		for j = 1, #current_record.embedded_character_subtypes do
			embedded_characters_output = embedded_characters_output .. current_record.embedded_character_subtypes[j];
			
			if j < #current_record.embedded_character_subtypes then
				embedded_characters_output = embedded_characters_output .. ", "
			end;
		end;
		
		out(embedded_characters_output .. "]");
	end;
	out("*****");
end;


-- Converts an old (from as early as WH3-launch) style army-cache string into a runtime army-cache table.
-- These strings take the format 'cqi,fm_cqi,mf_cqi,faction_name,unit1_cqi,unit1_key$unit2_cqi,unit2_key ... ;', with multiple armies being separated by semicolon.
-- It's undergone many changes but this was the format at the launch of WH3, so it's the only legacy format we need to support. In newer saves, these tables are serialised/deserialised directly using cm:save_named_value.
function campaign_manager:pending_battle_cache_table_from_string(str)
	local list = {};

	-- The old-style of serialised cached armies are in a format like:
	-- armyvariable,armyvariable,unitvariable,unitvariable$unitvariable,unitvariable;
	-- So we can split by the $ sign, use the first item as the army variables, and split further by commas.
	local army_substrings = string.split(str, ";");

	for a = 1, #army_substrings do
		-- construct the record we're about to read in
		local record = {};
		local successful_parse = true;

		-- The old-style of serialised cached armies are in a format like:
		-- armyvariable,armyvariable$unitvariable,unitvariable$unitvariable,unitvariable;
		-- So we can split by the $ sign, use the first item as the army variables, and split further by commas.
		local unit_segments = string.split(army_substrings[a], "$");
		local data_substrings = string.split(unit_segments[1], ",");
		table.remove(unit_segments, 1);

		-- The first unit definition is not preceeded by a $ sign so we have to retrieve it manually.
		-- Because WH3 launched with 4 properties in the battle cache, we can expect either 4 or 6 (where 6 is 4 + the 2 initial unit's properties) substrings in the first $ separation.
		-- Any other quantity is not parsible.
		if #data_substrings == 6 then
			table.insert(unit_segments, 1, data_substrings[5] .. "," .. data_substrings[6]);
			table.remove(data_substrings, 6);
			table.remove(data_substrings, 5);
		elseif #data_substrings ~= 4 then
			script_error(
				"ERROR: pending_battle_cache_table_from_string() Unexpected quantity of data substrings when loading cached army table from string.\n\t"
				.. army_substrings[a]
				.. "\nExpected four comman-separated values before the first dollar sign/semicolon, or 6 if the latter two are a unit's properties. Instead found " .. #data_substrings .. ". Cannot load this army into the battle cache."
			);
			successful_parse = false;
		end;

		record.cqi = tonumber(data_substrings[1]);
		record.fm_cqi = tonumber(data_substrings[2]);
		record.mf_cqi = tonumber(data_substrings[3]);
		record.faction_name = data_substrings[4];
		record.units = {};

		for u = 1, #unit_segments do
			local unit_substrings = string.split(unit_segments[u], ",");

			if #unit_substrings ~= 2 then
				script_error("ERROR: pending_battle_cache_table_from_string() Unexpected quantity of substrings in a saved-game unit string when loading a cached save-game army:\n\t"
				.. unit_segments[u]
				.. "\ncould be split into  " .. #unit_substrings .. " substrings using the '$' sign. Expected 2 substrings, signifying Unit Key and Unit CQI. Cannot load this unit into the battle cache.");
				successful_parse = false;
			else
				-- create a unit record for this unit
				local current_unit_record = {
					unit_cqi = tonumber(unit_substrings[1]),
					unit_key = unit_substrings[2]
				};
				table.insert(record.units, current_unit_record);
			end;
		end;

		if successful_parse then
			table.insert(list, record);
		end;
	end;
	
	return list;
end;


--- @function pending_battle_cache_num_attackers
--- @desc Returns the number of attacking armies in the cached pending battle.
--- @r @number number of attacking armies
function campaign_manager:pending_battle_cache_num_attackers()
	return #self.pbc_attackers;
end;


--- @function pending_battle_cache_get_attacker
--- @desc Returns records relating to a particular attacker in the cached pending battle. The attacker is specified by numerical index, with the first being accessible at record 1. This function returns the cqi of the commanding character, the cqi of the military force, and the faction name.
--- @desc To get records of the units related to an attacker, use @campaign_manager:pending_battle_cache_num_attacker_units and @campaign_manager:pending_battle_cache_get_attacker_unit.
--- @p @number index of attacker
--- @r @number character cqi
--- @r @number military force cqi
--- @r @string faction name
--- @new_example print attacker details
--- @example for i = 1, cm:pending_battle_cache_num_attackers() do
--- @example 	local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i);
--- @example 	out("Attacker " .. i .. " of faction " .. faction_name .. ":");
--- @example 	out("\tcharacter cqi: " .. char_cqi);
--- @example	out("\tmilitary force cqi: " .. mf_cqi);
--- @example end
function campaign_manager:pending_battle_cache_get_attacker(index)
	if not is_number(index) or index < 0 or index > #self.pbc_attackers then
		script_error("ERROR: pending_battle_cache_get_attacker() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;
	
	return self.pbc_attackers[index].cqi, self.pbc_attackers[index].mf_cqi, self.pbc_attackers[index].faction_name;
end;


--- @function pending_battle_cache_get_attacker_embedded_character_subtypes
--- @desc Returns the agent subtypes of all embedded characrers in a particular attacker's army in the cached pending battle. The attacker is specified by numerical index, with the first being accessible at record 1.
--- @p @number index of attacker
--- @r @table agent subtype keys
function campaign_manager:pending_battle_cache_get_attacker_embedded_character_subtypes(index)
	if not is_number(index) or index < 0 or index > #self.pbc_attackers then
		script_error("ERROR: pending_battle_cache_get_attacker_embedded_character_subtypes() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;
	
	return self.pbc_attackers[index].embedded_character_subtypes;
end;


--- @function pending_battle_cache_get_attacker_fm_cqi
--- @desc Returns the family member cqi of a particular attacker in the cached pending battle. The attacker is specified by numerical index, with the first being accessible at record 1.
--- @p @number index of attacker
--- @r @number family member cqi
function campaign_manager:pending_battle_cache_get_attacker_fm_cqi(index)
	if not is_number(index) or index < 0 or index > #self.pbc_attackers then
		script_error("ERROR: pending_battle_cache_get_attacker_fm_cqi() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;
	
	return self.pbc_attackers[index].fm_cqi;
end;


--- @function pending_battle_cache_get_attacker_units
--- @desc Returns just a table containing the unit keys of a particular attacker in the cached pending battle. The attacker is specified by numerical index, with the first being accessible at record 1.
--- @p @number index of attacker
--- @r @table unit keys
function campaign_manager:pending_battle_cache_get_attacker_units(index)
	if not is_number(index) or index < 0 or index > #self.pbc_attackers then
		script_error("ERROR: pending_battle_cache_get_attacker_units() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;
	
	return self.pbc_attackers[index].units;
end;


--- @function pending_battle_cache_get_attacker_faction_name
--- @desc Returns just the faction name of a particular attacker in the cached pending battle. The attacker is specified by numerical index, with the first being accessible at record 1.
--- @p @number index of attacker
--- @r @string faction name
function campaign_manager:pending_battle_cache_get_attacker_faction_name(index)
	if not is_number(index) or index < 0 or index > #self.pbc_attackers then
		script_error("ERROR: pending_battle_cache_get_attacker_faction_name() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;
	
	return self.pbc_attackers[index].faction_name;
end;


--- @function pending_battle_cache_get_attacker_subtype
--- @desc Returns just the subtype key of a particular attacker in the cached pending battle. The attacker is specified by numerical index, with the first being accessible at record 1.
--- @p @number index of attacker
--- @r @string subtype
function campaign_manager:pending_battle_cache_get_attacker_subtype(index)
	if not is_number(index) or index < 0 or index > #self.pbc_attackers then
		script_error("ERROR: pending_battle_cache_get_attacker_subtype() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;
	
	local family_member = cm:get_family_member_by_cqi(self.pbc_attackers[index].fm_cqi)
	local character_details = family_member:character_details();
	return character_details:character_subtype_key();
end;


--- @function pending_battle_cache_num_attacker_units
--- @desc Returns the number of units that a specified attacker in the cached pending battle took into battle, or will take into battle. The total number of units across all attacking armies is returned if no army index is specified.
--- @p [opt=nil] @number index of attacker
--- @r @number number of attacking units
function campaign_manager:pending_battle_cache_num_attacker_units(index)
	if index ~= nil and (index < 0 or index > #self.pbc_attackers) then
		script_error("ERROR: pending_battle_cache_num_attacker_units() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;

	if index == nil then
		return self.pbc_attacker_unit_count;
	else
		return #self.pbc_attackers[index].units;
	end;
end;


--- @function pending_battle_cache_num_attacker_embedded_characters
--- @desc Returns the number of embedded characters that a specified attacker in the cached pending battle took into battle, or will take into battle. The total number of embedded characters across all attacking armies is returned if no army index is specified.
--- @p [opt=nil] @number index of attacker
--- @r @number number of attacking embedded characters
function campaign_manager:pending_battle_cache_num_attacker_embedded_characters(index)
	if index ~= nil and (index < 0 or index > #self.pbc_attackers) then
		script_error("ERROR: pending_battle_cache_num_attacker_embedded_characters() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;

	if index == nil then
		local embedded_character_count = 0;
		
		for i = 1, self:pending_battle_cache_num_attackers() do
			embedded_character_count = embedded_character_count + #self:pending_battle_cache_get_attacker_embedded_character_subtypes(i);
		end;
		
		return embedded_character_count;
	else
		return #self:pending_battle_cache_get_attacker_embedded_character_subtypes(index);
	end;
end;


--- @function pending_battle_cache_get_attacker_unit
--- @desc Returns the cqi and unit key of a specified unit on the specified attacker in the pending battle cache, by index.
--- @p @number attacker index, Index of attacking character within the pending battle cache.
--- @p @number unit unit, Index of unit belonging to the attacking character.
--- @r @number cqi of unit
--- @r @string key of unit
function campaign_manager:pending_battle_cache_get_attacker_unit(index, unit_index)
	if not is_number(index) or index < 0 or index > #self.pbc_attackers then
		script_error("ERROR: pending_battle_cache_get_attacker_unit() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;

	local character_record = self.pbc_attackers[index];

	if not is_number(unit_index) or unit_index < 1 or unit_index > #character_record.units then
		script_error("ERROR: pending_battle_cache_get_attacker_unit() called but supplied unit index [" .. tostring(unit_index) .. "] is out of range");
		return false;
	end;

	local unit_record = character_record.units[unit_index];

	return unit_record.unit_cqi, unit_record.unit_key;
end;


--- @function pending_battle_cache_num_defenders
--- @desc Returns the number of defending armies in the cached pending battle.
--- @r @number number of defending armies
function campaign_manager:pending_battle_cache_num_defenders()
	return #self.pbc_defenders;
end;


--- @function pending_battle_cache_get_defender
--- @desc Returns records relating to a particular defender in the cached pending battle. The defender is specified by numerical index, with the first being accessible at record 1. This function returns the cqi of the commanding character, the cqi of the military force, and the faction name.
--- @p @number index of defender
--- @r @number character cqi
--- @r @number military force cqi
--- @r @string faction name
--- @new_example print defender details
--- @example for i = 1, cm:pending_battle_cache_num_defenders() do
--- @example 	local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i);
--- @example 	out("Defender " .. i .. " of faction " .. faction_name .. ":");
--- @example 	out("\tcharacter cqi: " .. char_cqi);
--- @example	out("\tmilitary force cqi: " .. mf_cqi);
--- @example end
function campaign_manager:pending_battle_cache_get_defender(index)
	if not is_number(index) or index < 0 or index > #self.pbc_defenders then
		script_error("ERROR: pending_battle_cache_get_defender() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;
	
	return self.pbc_defenders[index].cqi, self.pbc_defenders[index].mf_cqi, self.pbc_defenders[index].faction_name;
end;


--- @function pending_battle_cache_get_defender_embedded_character_subtypes
--- @desc Returns the agent subtypes of all embedded characrers in a particular defender's army in the cached pending battle. The defender is specified by numerical index, with the first being accessible at record 1.
--- @p @number index of defender
--- @r @table agent subtype keys
function campaign_manager:pending_battle_cache_get_defender_embedded_character_subtypes(index)
	if not is_number(index) or index < 0 or index > #self.pbc_defenders then
		script_error("ERROR: pending_battle_cache_get_defender_embedded_character_subtypes() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;
	
	return self.pbc_defenders[index].embedded_character_subtypes;
end;


--- @function pending_battle_cache_get_defender_fm_cqi
--- @desc Returns the family member cqi of a particular defender in the cached pending battle. The defender is specified by numerical index, with the first being accessible at record 1.
--- @p @number index of defender
--- @r @number family member cqi
function campaign_manager:pending_battle_cache_get_defender_fm_cqi(index)
	if not is_number(index) or index < 0 or index > #self.pbc_defenders then
		script_error("ERROR: pending_battle_cache_get_defender_fm_cqi() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;
	
	return self.pbc_defenders[index].fm_cqi;
end;


--- @function pending_battle_cache_get_defender_units
--- @desc Returns just a table containing the unit keys of a particular defender in the cached pending battle. The defender is specified by numerical index, with the first being accessible at record 1.
--- @p @number index of defender
--- @r @table unit keys
function campaign_manager:pending_battle_cache_get_defender_units(index)
	if not is_number(index) or index < 0 or index > #self.pbc_defenders then
		script_error("ERROR: pending_battle_cache_get_defender_units() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;
	
	return self.pbc_defenders[index].units;
end;


--- @function pending_battle_cache_get_defender_faction_name
--- @desc Returns just the faction name of a particular defender in the cached pending battle. The defender is specified by numerical index, with the first being accessible at record 1.
--- @p @number index of defender
--- @r @string faction name
function campaign_manager:pending_battle_cache_get_defender_faction_name(index)
	if not is_number(index) or index < 0 or index > #self.pbc_defenders then
		script_error("ERROR: pending_battle_cache_get_defender_faction_name() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;
	
	return self.pbc_defenders[index].faction_name;
end;


--- @function pending_battle_cache_get_defender_subtype
--- @desc Returns just the subtype key of a particular defender in the cached pending battle. The defender is specified by numerical index, with the first being accessible at record 1.
--- @p @number index of defender
--- @r @string subtype
function campaign_manager:pending_battle_cache_get_defender_subtype(index)
	if not is_number(index) or index < 0 or index > #self.pbc_defenders then
		script_error("ERROR: pending_battle_cache_get_defender_subtype() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;

	local family_member = cm:get_family_member_by_cqi(self.pbc_defenders[index].fm_cqi)
	local character_details = family_member:character_details();
	return character_details:character_subtype_key();
end;


--- @function pending_battle_cache_num_defender_units
--- @desc Returns the number of units that a specified defender in the cached pending battle took into battle, or will take into battle. The total number of units across all defending armies is returned if no army index is specified.
--- @p [opt=nil] @number index of defender
--- @r @number number of defending units
function campaign_manager:pending_battle_cache_num_defender_units(index)
	if index ~= nil and (index < 0 or index > #self.pbc_defenders) then
		script_error("ERROR: pending_battle_cache_num_defender_units() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;

	if index == nil then
		return self.pbc_defender_unit_count;
	else
		return #self.pbc_defenders[index].units;
	end;
end;


--- @function pending_battle_cache_num_defender_embedded_characters
--- @desc Returns the number of embedded characters that a specified defender in the cached pending battle took into battle, or will take into battle. The total number of embedded characters across all defending armies is returned if no army index is specified.
--- @p [opt=nil] @number index of defender
--- @r @number number of defending embedded characters
function campaign_manager:pending_battle_cache_num_defender_embedded_characters(index)
	if index ~= nil and (index < 0 or index > #self.pbc_defenders) then
		script_error("ERROR: pending_battle_cache_num_defender_embedded_characters() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;

	if index == nil then
		local embedded_character_count = 0;
		
		for i = 1, self:pending_battle_cache_num_defenders() do
			embedded_character_count = embedded_character_count + #self:pending_battle_cache_get_defender_embedded_character_subtypes(i);
		end;
		
		return embedded_character_count;
	else
		return #self:pending_battle_cache_get_defender_embedded_character_subtypes(index);
	end;
end;


--- @function pending_battle_cache_get_defender_unit
--- @desc Returns the cqi and unit key of a specified unit on the specified defender in the pending battle cache, by index.
--- @p @number defender index, Index of attacking character within the pending battle cache.
--- @p @number unit unit, Index of unit belonging to the attacking character.
--- @r @number cqi of unit
--- @r @string key of unit
function campaign_manager:pending_battle_cache_get_defender_unit(index, unit_index)
	if not is_number(index) or index < 0 or index > #self.pbc_defenders then
		script_error("ERROR: pending_battle_cache_get_defender_unit() called but supplied index [" .. tostring(index) .. "] is out of range");
		return false;
	end;

	local character_record = self.pbc_defenders[index];

	if not is_number(unit_index) or unit_index < 1 or unit_index > #character_record.units then
		script_error("ERROR: pending_battle_cache_get_defender_unit() called but supplied unit index [" .. tostring(unit_index) .. "] is out of range");
		return false;
	end;

	local unit_record = character_record.units[unit_index];

	return unit_record.unit_cqi, unit_record.unit_key;
end;


--- @function pending_battle_cache_faction_is_attacker
--- @desc Returns <code>true</code> if the faction was an attacker (primary or reinforcing) in the cached pending battle.
--- @p @string faction key
--- @r @boolean faction was attacker
function campaign_manager:pending_battle_cache_faction_is_attacker(faction_name)
	if not is_string(faction_name) then
		script_error("ERROR: pending_battle_cache_faction_is_attacker() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	for i = 1, self:pending_battle_cache_num_attackers() do
		local current_char_cqi, current_mf_cqi, current_faction_name = self:pending_battle_cache_get_attacker(i);
		
		if current_faction_name == faction_name then
			return true;
		end;
	end;
	
	return false;
end;


--- @function pending_battle_cache_faction_is_defender
--- @desc Returns <code>true</code> if the faction was a defender (primary or reinforcing) in the cached pending battle.
--- @p @string faction key
--- @r @boolean faction was defender
function campaign_manager:pending_battle_cache_faction_is_defender(faction_name)
	if not is_string(faction_name) then
		script_error("ERROR: pending_battle_cache_faction_is_defender() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;

	for i = 1, self:pending_battle_cache_num_defenders() do
		local current_char_cqi, current_mf_cqi, current_faction_name = self:pending_battle_cache_get_defender(i);
		
		if current_faction_name == faction_name then
			return true;
		end;
	end;
	
	return false;
end;


--- @function pending_battle_cache_faction_is_involved
--- @desc Returns <code>true</code> if the faction was involved in the cached pending battle as either attacker or defender.
--- @p @string faction key
--- @r @boolean faction was involved
function campaign_manager:pending_battle_cache_faction_is_involved(faction_name)
	return self:pending_battle_cache_faction_is_attacker(faction_name) or self:pending_battle_cache_faction_is_defender(faction_name);
end;


--- @function pending_battle_cache_faction_set_member_is_attacker
--- @desc Returns <code>true</code> if a faction that is part of the specified faction set was an attacker (primary or reinforcing) in the cached pending battle.
--- @p @string faction set key
--- @r @boolean faction was set member attacker
function campaign_manager:pending_battle_cache_faction_set_member_is_attacker(faction_set_name)
	if not is_string(faction_set_name) then
		script_error("ERROR: pending_battle_cache_faction_set_member_is_attacker() called but supplied faction set [" .. tostring(faction_set_name) .. "] is not a string");
		return false;
	end;
	
	for i = 1, self:pending_battle_cache_num_attackers() do
		local current_char_cqi, current_mf_cqi, current_faction_name = self:pending_battle_cache_get_attacker(i);
		
		local faction = cm:get_faction(current_faction_name)
		
		if faction and faction:is_contained_in_faction_set(faction_set_name) then
			return true;
		end;
	end;
	
	return false;
end;


--- @function pending_battle_cache_faction_set_member_is_defender
--- @desc Returns <code>true</code> if a faction that is part of the specified faction set was a defender (primary or reinforcing) in the cached pending battle.
--- @p @string faction set key
--- @r @boolean faction set member was defender
function campaign_manager:pending_battle_cache_faction_set_member_is_defender(faction_set_name)
	if not is_string(faction_set_name) then
		script_error("ERROR: pending_battle_cache_faction_set_member_is_defender() called but supplied faction set [" .. tostring(faction_set_name) .. "] is not a string");
		return false;
	end;

	for i = 1, self:pending_battle_cache_num_defenders() do
		local current_char_cqi, current_mf_cqi, current_faction_name = self:pending_battle_cache_get_defender(i);

		local faction = cm:get_faction(current_faction_name)
		
		if faction and faction:is_contained_in_faction_set(faction_set_name) then
			return true;
		end;
	end;
	
	return false;
end;

--- @function pending_battle_cache_faction_set_member_is_involved
--- @desc Returns <code>true</code> if a member of the specified faction set was involved in the cached pending battle as either attacker or defender.
--- @p @string faction set key
--- @r @boolean faction set member was involved
function campaign_manager:pending_battle_cache_faction_set_member_is_involved(faction_set_name)
	return self:pending_battle_cache_faction_set_member_is_attacker(faction_set_name) or self:pending_battle_cache_faction_set_member_is_defender(faction_set_name);
end;


--- @function pending_battle_cache_human_is_attacker
--- @desc Returns <code>true</code> if any of the attacking factions involved in the cached pending battle were human controlled (whether local or not).
--- @r @boolean human was attacking
function campaign_manager:pending_battle_cache_human_is_attacker()
	for i = 1, self:pending_battle_cache_num_attackers() do
		local current_char_cqi, current_mf_cqi, current_faction_name = self:pending_battle_cache_get_attacker(i);
		
		local faction = cm:get_faction(current_faction_name);
		
		if faction and faction:is_human() then
			return true;
		end;
	end;
	
	return false;
end;


--- @function pending_battle_cache_human_is_defender
--- @desc Returns <code>true</code> if any of the defending factions involved in the cached pending battle were human controlled (whether local or not).
--- @r @boolean human was defending
function campaign_manager:pending_battle_cache_human_is_defender()
	for i = 1, self:pending_battle_cache_num_defenders() do
		local current_char_cqi, current_mf_cqi, current_faction_name = self:pending_battle_cache_get_defender(i);
		
		local faction = cm:get_faction(current_faction_name);
		
		if faction and faction:is_human() then
			return true;
		end;
	end;
	
	return false;
end;


--- @function pending_battle_cache_human_is_involved
--- @desc Returns <code>true</code> if any of the factions involved in the cached pending battle on either side were human controlled (whether local or not).
--- @r @boolean human was involved
function campaign_manager:pending_battle_cache_human_is_involved()
	return self:pending_battle_cache_human_is_attacker() or self:pending_battle_cache_human_is_defender();
end;


--- @function pending_battle_cache_culture_is_attacker
--- @desc Returns <code>true</code> if any of the attacking factions in the cached pending battle are of the supplied culture.
--- @p @string culture key
--- @r @boolean any attacker was culture
function campaign_manager:pending_battle_cache_culture_is_attacker(culture_name)
	if not is_string(culture_name) then
		script_error("ERROR: pending_battle_cache_culture_is_attacker() called but supplied culture name [" .. tostring(culture_name) .. "] is not a string");
		return false;
	end;
	
	for i = 1, self:pending_battle_cache_num_attackers() do
		local current_char_cqi, current_mf_cqi, current_faction_name = self:pending_battle_cache_get_attacker(i);
		
		local faction = self:get_faction(current_faction_name);

		if faction and faction:culture() == culture_name then
			return true;
		end;
	end;
	
	return false;
end;


--- @function pending_battle_cache_culture_is_defender
--- @desc Returns <code>true</code> if any of the defending factions in the cached pending battle are of the supplied culture.
--- @p @string culture key
--- @r @boolean any defender was culture
function campaign_manager:pending_battle_cache_culture_is_defender(culture_name)
	if not is_string(culture_name) then
		script_error("ERROR: pending_battle_cache_culture_is_defender() called but supplied culture name [" .. tostring(culture_name) .. "] is not a string");
		return false;
	end;
	
	for i = 1, self:pending_battle_cache_num_defenders() do
		local current_char_cqi, current_mf_cqi, current_faction_name = self:pending_battle_cache_get_defender(i);
		
		local faction = self:get_faction(current_faction_name);

		if faction and faction:culture() == culture_name then
			return true;
		end;
	end;
	
	return false;
end;


--- @function pending_battle_cache_culture_is_involved
--- @desc Returns <code>true</code> if any of the factions involved in the cached pending battle on either side match the supplied culture.
--- @p @string culture key
--- @r @boolean culture was involved
function campaign_manager:pending_battle_cache_culture_is_involved(culture_name)
	return self:pending_battle_cache_culture_is_attacker(culture_name) or self:pending_battle_cache_culture_is_defender(culture_name);
end;


--- @function pending_battle_cache_human_culture_is_involved
--- @desc Returns <code>true</code> if any of the factions involved in the cached pending battle on either side were human controlled and belonging to the supplied culture (whether local or not).
--- @r @boolean human culture was involved
function campaign_manager:pending_battle_cache_human_culture_is_involved(culture_name)
	return (self:pending_battle_cache_human_is_attacker() and self:pending_battle_cache_culture_is_attacker(culture_name)) or (self:pending_battle_cache_human_is_defender() and self:pending_battle_cache_culture_is_defender(culture_name));
end;


--- @function pending_battle_cache_subculture_is_attacker
--- @desc Returns <code>true</code> if any of the attacking factions in the cached pending battle are of the supplied subculture.
--- @p @string subculture key
--- @r @boolean any attacker was subculture
function campaign_manager:pending_battle_cache_subculture_is_attacker(subculture_name)
	if not is_string(subculture_name) then
		script_error("ERROR: pending_battle_cache_subculture_is_attacker() called but supplied subculture name [" .. tostring(subculture_name) .. "] is not a string");
		return false;
	end;
	
	for i = 1, self:pending_battle_cache_num_attackers() do
		local current_char_cqi, current_mf_cqi, current_faction_name = self:pending_battle_cache_get_attacker(i);
		
		local faction = self:get_faction(current_faction_name);

		if faction and faction:subculture() == subculture_name then
			return true;
		end;
	end;
	
	return false;
end;


--- @function pending_battle_cache_subculture_is_defender
--- @desc Returns <code>true</code> if any of the defending factions in the cached pending battle are of the supplied subculture.
--- @p @string subculture key
--- @r @boolean any defender was subculture
function campaign_manager:pending_battle_cache_subculture_is_defender(subculture_name)
	if not is_string(subculture_name) then
		script_error("ERROR: pending_battle_cache_subculture_is_defender() called but supplied subculture name [" .. tostring(subculture_name) .. "] is not a string");
		return false;
	end;
	
	for i = 1, self:pending_battle_cache_num_defenders() do
		local current_char_cqi, current_mf_cqi, current_faction_name = self:pending_battle_cache_get_defender(i);
		
		local faction = self:get_faction(current_faction_name);

		if faction and faction:subculture() == subculture_name then
			return true;
		end;
	end;
	
	return false;
end;


--- @function pending_battle_cache_subculture_is_involved
--- @desc Returns <code>true</code> if any of the factions involved in the cached pending battle on either side match the supplied subculture.
--- @p @string subculture key
--- @r @boolean subculture was involved
function campaign_manager:pending_battle_cache_subculture_is_involved(subculture_name)
	return self:pending_battle_cache_subculture_is_attacker(subculture_name) or self:pending_battle_cache_subculture_is_defender(subculture_name);
end;


--- @function pending_battle_cache_char_is_involved
--- @desc Returns <code>true</code> if the supplied character fought in the cached pending battle.
--- @p object character, Character to query. May be supplied as a character object or as a cqi number.
--- @r @boolean character was involved
function campaign_manager:pending_battle_cache_char_is_involved(obj)
	return self:pending_battle_cache_char_is_attacker(obj) or self:pending_battle_cache_char_is_defender(obj);
end;


--- @function pending_battle_cache_char_is_attacker
--- @desc Returns <code>true</code> if the supplied character was an attacker in the cached pending battle.
--- @p object character, Character to query. May be supplied as a character object or as a cqi number.
--- @r @boolean character was attacker
function campaign_manager:pending_battle_cache_char_is_attacker(obj)
	return self:pending_battle_cache_character_is_involved_internal(obj, is_character, self.pending_battle_cache_get_attacker, true);
end;


--- @function pending_battle_cache_char_is_defender
--- @desc Returns <code>true</code> if the supplied character was a defender in the cached pending battle.
--- @p object character, Character to query. May be supplied as a character object or as a cqi number.
--- @r @boolean character was defender
function campaign_manager:pending_battle_cache_char_is_defender(obj)
	return self:pending_battle_cache_character_is_involved_internal(obj, is_character, self.pending_battle_cache_get_defender, false);
end;


--- @function pending_battle_cache_fm_is_involved
--- @desc Returns <code>true</code> if the supplied family member fought in the cached pending battle.
--- @p object family member, Character to query. May be supplied as a family member object or as a cqi number.
--- @r @boolean family member was involved
function campaign_manager:pending_battle_cache_fm_is_involved(obj)
	return self:pending_battle_cache_fm_is_attacker(obj) or self:pending_battle_cache_fm_is_defender(obj);
end;


--- @function pending_battle_cache_fm_is_attacker
--- @desc Returns <code>true</code> if the supplied family member was an attacker in the cached pending battle.
--- @p object family member, Character to query. May be supplied as a family member object or as a cqi number.
--- @r @boolean family member was attacker
function campaign_manager:pending_battle_cache_fm_is_attacker(obj)
	return self:pending_battle_cache_character_is_involved_internal(obj, is_familymember, self.pending_battle_cache_get_attacker_fm_cqi, true);
end;


--- @function pending_battle_cache_fm_is_defender
--- @desc Returns <code>true</code> if the supplied family member was a defender in the cached pending battle.
--- @p object family member, Character to query. May be supplied as a family member object or as a cqi number.
--- @r @boolean family member was defender
function campaign_manager:pending_battle_cache_fm_is_defender(obj)
	return self:pending_battle_cache_character_is_involved_internal(obj, is_familymember, self.pending_battle_cache_get_defender_fm_cqi, false);
end;


-- Internal function for other functions to check if a character/family member was involved in a cached pending battle.
-- Returns true if the supplied object satisfies the specified type validator, and if the participant getter finds this object in the attacker/defender list (determined by check_attackers_if_true).
-- Supplied object may be a family member interface/cqi or character interface/cqi. In either case, the appropriate type validator and participant getter function for either of these types must be specified.
function campaign_manager:pending_battle_cache_character_is_involved_internal(obj, type_validator, participant_getter, check_attackers)
	local character_cqi;

	if type_validator(obj) then
		character_cqi = obj:command_queue_index();
	else
		character_cqi = obj;
	end;

	if check_attackers then
		for i = 1, self:pending_battle_cache_num_attackers() do
			-- For 'get_attacker' type functions, the definition typically involves passing the campaign manager itself as a parameter (i.e. 'cm:get_attacker()').
			local current_cqi = participant_getter(self, i);
			
			if current_cqi == character_cqi then
				return true;
			end;
		end;
	else
		for i = 1, self:pending_battle_cache_num_defenders() do
			local current_cqi = participant_getter(self, i);
			
			if current_cqi == character_cqi then
				return true;
			end;
		end;
	end;

	return false;
end;


--- @function pending_battle_cache_mf_is_attacker
--- @desc Returns <code>true</code> if the supplied military force was an attacker in the cached pending battle.
--- @p @number cqi, Command-queue-index of the military force to query.
--- @r @boolean force was attacker
function campaign_manager:pending_battle_cache_mf_is_attacker(obj)
	local mf_cqi;
	
	if is_militaryforce(obj) then
		mf_cqi = obj:command_queue_index();
	else
		mf_cqi = obj;
	end;
	
	-- cast it to string
	mf_cqi = tostring(mf_cqi);
	
	for i = 1, self:pending_battle_cache_num_attackers() do
		local current_char_cqi, current_mf_cqi, current_faction_name = self:pending_battle_cache_get_attacker(i);
		
		if current_mf_cqi == mf_cqi then
			return true;
		end;
	end;
	
	return false;
end;


--- @function pending_battle_cache_mf_is_defender
--- @desc Returns <code>true</code> if the supplied military force was a defender in the cached pending battle.
--- @p @number cqi, Command-queue-index of the military force to query.
--- @r @boolean force was defender
function campaign_manager:pending_battle_cache_mf_is_defender(obj)
	local mf_cqi;
	
	if is_militaryforce(obj) then
		mf_cqi = obj:command_queue_index();
	else
		mf_cqi = obj;
	end;
	
	-- cast it to string
	mf_cqi = tostring(mf_cqi);
	
	for i = 1, self:pending_battle_cache_num_defenders() do
		local current_char_cqi, current_mf_cqi, current_faction_name = self:pending_battle_cache_get_defender(i);
		
		if current_mf_cqi == mf_cqi then
			return true;
		end;
	end;
	
	return false;
end;


--- @function pending_battle_cache_mf_is_involved
--- @desc Returns <code>true</code> if the supplied military force was an attacker or defender in the cached pending battle.
--- @p @number cqi, Command-queue-index of the military force to query.
--- @r @boolean force was involved
function campaign_manager:pending_battle_cache_mf_is_involved(obj)
	local mf_cqi;

	-- support passing in the actual character
	if is_militaryforce(obj) then
		mf_cqi = obj:cqi();
	else
		mf_cqi = obj;
	end;
	
	return self:pending_battle_cache_mf_is_attacker(mf_cqi) or self:pending_battle_cache_mf_is_defender(mf_cqi);
end;


--- @function pending_battle_cache_get_enemies_of_char
--- @desc Returns a numerically indexed table of character objects, each representing an enemy character of the supplied character in the cached pending battle. If the supplied character was not present in the pending battle then the returned table will be empty.
--- @p character character to query
--- @r @table table of enemy characters
function campaign_manager:pending_battle_cache_get_enemies_of_char(character)
	if not is_character(character) then
		script_error("ERROR: pending_battle_cache_get_enemies_of_character() called but supplied character [" .. tostring(character) .. "] is not a character");
		return false;
	end;
	
	local retval = {};

	if self:pending_battle_cache_char_is_attacker(character) then
		for i = 1, self:pending_battle_cache_num_defenders() do
			table.insert(retval, self:get_character_by_cqi(self:pending_battle_cache_get_defender(i)));
		end;
	elseif self:pending_battle_cache_char_is_defender(character) then
		for i = 1, self:pending_battle_cache_num_attackers() do
			table.insert(retval, self:get_character_by_cqi(self:pending_battle_cache_get_attacker(i)));
		end;
	end;
	
	return retval;
end;


--- @function pending_battle_cache_get_enemy_fms_of_char_fm
--- @desc Returns a numerically indexed table of family member objects, each representing an enemy character of the supplied family member in the cached pending battle. If the supplied family member was not present in the pending battle then the returned table will be empty.
--- @p family_member family member to query
--- @r @table table of enemy family members
function campaign_manager:pending_battle_cache_get_enemy_fms_of_char_fm(character_fm)
	if not is_familymember(character_fm) then
		script_error("ERROR: pending_battle_cache_get_enemy_fms_of_char() called but supplied character fm [" .. tostring(character_fm) .. "] is not a family member");
		return false;
	end;
	
	local retval = {};

	if self:pending_battle_cache_fm_is_attacker(character_fm) then
		for i = 1, self:pending_battle_cache_num_defenders() do
			table.insert(retval, self:get_family_member_by_cqi(self:pending_battle_cache_get_defender_fm_cqi(i)));
		end;
	elseif self:pending_battle_cache_fm_is_defender(character_fm) then
		for i = 1, self:pending_battle_cache_num_attackers() do
			table.insert(retval, self:get_family_member_by_cqi(self:pending_battle_cache_get_attacker_fm_cqi(i)));
		end;
	end;
	
	return retval;
end;


--- @function pending_battle_cache_is_quest_battle
--- @desc Returns <code>true</code> if any of the participating factions in the pending battle are quest battle factions, <code>false</code> otherwise.
--- @r boolean is quest battle
function campaign_manager:pending_battle_cache_is_quest_battle()
	for i = 1, self:pending_battle_cache_num_defenders() do
		local faction = self:get_faction(self:pending_battle_cache_get_defender_faction_name(i));
		
		if faction and faction:is_quest_battle_faction() then
			return true;
		end;
	end;
	
	for i = 1, self:pending_battle_cache_num_attackers() do
		local faction = self:get_faction(self:pending_battle_cache_get_attacker_faction_name(i));
		
		if faction and faction:is_quest_battle_faction() then
			return true;
		end;
	end;
end;


--- @function pending_battle_cache_attacker_victory
--- @desc Returns <code>true</code> if the pending battle has been won by the attacker, <code>false</code> otherwise.
--- @r boolean attacker has won
function campaign_manager:pending_battle_cache_attacker_victory()
	return self:model():pending_battle():attacker_won();
end;


--- @function pending_battle_cache_defender_victory
--- @desc Returns <code>true</code> if the pending battle has been won by the defender, <code>false</code> otherwise.
--- @r boolean defender has won
function campaign_manager:pending_battle_cache_defender_victory()
	return self:model():pending_battle():defender_won();
end;


--- @function pending_battle_cache_human_victory
--- @desc Returns <code>true</code> if the pending battle has been won by a human player, <code>false</code> otherwise.
--- @r @boolean human has won
function campaign_manager:pending_battle_cache_human_victory()
	return (self:pending_battle_cache_human_is_attacker() and self:pending_battle_cache_attacker_victory()) or (self:pending_battle_cache_human_is_defender() and self:pending_battle_cache_defender_victory());
end;


--- @function pending_battle_cache_faction_won_battle
--- @desc Returns <code>true</code> if the pending battle has been won by the specified faction key, <code>false</code> otherwise.
--- @p @string faction key
--- @r @boolean faction has won
function campaign_manager:pending_battle_cache_faction_won_battle(faction)
	return (self:pending_battle_cache_faction_is_attacker(faction) and self:pending_battle_cache_attacker_victory()) or (self:pending_battle_cache_faction_is_defender(faction) and self:pending_battle_cache_defender_victory());
end;


--- @function pending_battle_cache_faction_lost_battle
--- @desc Returns <code>true</code> if the pending battle has been lost by the specified faction key, <code>false</code> otherwise.
--- @p @string faction key
--- @r @boolean faction has lost
function campaign_manager:pending_battle_cache_faction_lost_battle(faction)
	return (self:pending_battle_cache_faction_is_attacker(faction) and not self:pending_battle_cache_attacker_victory()) or (self:pending_battle_cache_faction_is_defender(faction) and not self:pending_battle_cache_defender_victory());
end;


--- @function pending_battle_cache_faction_won_battle_against_culture
--- @desc Returns <code>true</code> if the pending battle has been won by the specified faction key against the specified culture, <code>false</code> otherwise. A table of culture keys may be supplied instead of a single culture key.
--- @p @string faction key
--- @p @string culture key
--- @r @boolean faction has won
function campaign_manager:pending_battle_cache_faction_won_battle_against_culture(faction, culture)
	if is_table(culture) then
		for i = 1, #culture do
			if self:pending_battle_cache_faction_won_battle_against_culture(faction, culture[i]) then
				return true;
			end;
		end;
		
		return false;
	else
		return (self:pending_battle_cache_faction_is_attacker(faction) and self:pending_battle_cache_attacker_victory() and self:pending_battle_cache_culture_is_defender(culture)) or (self:pending_battle_cache_faction_is_defender(faction) and self:pending_battle_cache_defender_victory() and self:pending_battle_cache_culture_is_attacker(culture));
	end;
end;


--- @function pending_battle_cache_faction_won_battle_against_unit
--- @desc Returns <code>true</code> if the pending battle has been won by the specified faction key against an army containing the key specified unit, <code>false</code> otherwise. A table of unit keys may be supplied instead of a single unit key.
--- @p @string faction key
--- @p @string unit key or table of unit keys
--- @r @boolean faction has won against unit key
function campaign_manager:pending_battle_cache_faction_won_battle_against_unit(faction, unit)
	if not validate.is_string(faction) then
		return false;
	end;
	
	if not validate.is_string_or_table_of_strings(unit) then
		return false;
	end;
	
	if type(unit) == "table" then
		for i = 1, #unit do
			if self:pending_battle_cache_faction_won_battle_against_unit(faction, unit[i]) then
				return true;
			end;
		end;
		
		return false;
	end;

	if self:pending_battle_cache_faction_won_battle(faction) then
		if self:pending_battle_cache_faction_is_attacker(faction) then
			return self:pending_battle_cache_unit_key_exists_in_defenders(unit);
		elseif self:pending_battle_cache_faction_is_defender(faction) then
			return self:pending_battle_cache_unit_key_exists_in_attackers(unit);
		end;
	end;
	
	return false;
end;


--- @function pending_battle_cache_attacker_value
--- @desc Returns the gold value of attacking forces in the cached pending battle.
--- @r number gold value of attacking forces
function campaign_manager:pending_battle_cache_attacker_value()
	if self.pbc_attacker_value < 1 then
		return 1;
	end
	return self.pbc_attacker_value;
end;


--- @function pending_battle_cache_defender_value
--- @desc Returns the gold value of defending forces in the cached pending battle.
--- @r number gold value of defending forces
function campaign_manager:pending_battle_cache_defender_value()
	if self.pbc_defender_value < 1 then
		return 1;
	end
	return self.pbc_defender_value;
end;


--- @function pending_battle_cache_unit_key_exists_in_attackers
--- @desc Returns <code>true</code> if the supplied unit key was involved in the cached pending battle as attacker.
--- @p string unit key
--- @r boolean unit was involved as attacker
function campaign_manager:pending_battle_cache_unit_key_exists_in_attackers(unit_key)
	if not is_string(unit_key) then
		script_error("ERROR: pending_battle_cache_unit_key_exists_in_attackers() called but supplied unit key [" .. tostring(unit_key) .. "] is not a string");
		return false;
	end;
	
	for i = 1, self:pending_battle_cache_num_attackers() do
		local units = self:pending_battle_cache_get_attacker_units(i);
		
		for j = 1, #units do
			if units[j].unit_key == unit_key then
				return true;
			end;
		end;
	end;
	
	return false;
end;


--- @function pending_battle_cache_unit_key_exists_in_defenders
--- @desc Returns <code>true</code> if the supplied unit key was involved in the cached pending battle as defender.
--- @p string unit key
--- @r boolean unit was involved as defender
function campaign_manager:pending_battle_cache_unit_key_exists_in_defenders(unit_key)
	if not is_string(unit_key) then
		script_error("ERROR: pending_battle_cache_unit_key_exists_in_defenders() called but supplied unit key [" .. tostring(unit_key) .. "] is not a string");
		return false;
	end;
	
	for i = 1, self:pending_battle_cache_num_defenders() do
		local units = self:pending_battle_cache_get_defender_units(i);
		
		for j = 1, #units do
			if units[j].unit_key == unit_key then
				return true;
			end;
		end;
	end;
	
	return false;
end;


--- @function pending_battle_cache_unit_key_exists
--- @desc Returns <code>true</code> if the unit was involved in the cached pending battle as attacker or defender.
--- @p string unit key
--- @r boolean unit was involved
function campaign_manager:pending_battle_cache_unit_key_exists(unit_key)
	if not is_string(unit_key) then
		script_error("ERROR: pending_battle_cache_unit_key_exists() called but supplied unit key [" .. tostring(unit_key) .. "] is not a string");
		return false;
	end;
	
	return self:pending_battle_cache_unit_key_exists_in_attackers(unit_key) or self:pending_battle_cache_unit_key_exists_in_defenders(unit_key);
end;








-----------------------------------------------------------------------------
--- @section Random Numbers
-----------------------------------------------------------------------------


--- @function random_number
--- @desc Assembles and returns a random integer between 1 and 100, or other supplied values. The result returned is inclusive of the supplied max/min. This is safe to use in multiplayer scripts.
--- @p [opt=100] integer max, Maximum value of returned random number.
--- @p [opt=1] integer min, Minimum value of returned random number.
--- @r number random number
function campaign_manager:random_number(max_num, min_num)
	if is_nil(max_num) then
		max_num = 100;
	end;
	
	if is_nil(min_num) then
		min_num = 1;
	end;
	
	if not is_number(max_num) or math.floor(max_num) < max_num then
		script_error("random_number ERROR: supplied max number [" .. tostring(max_num) .. "] is not a valid integer");
		return 0;
	end;
	
	if max_num == min_num then
		return max_num;
	end;
	
	if min_num == 1 and max_num < min_num then
		script_error("random_number ERROR: supplied max number [" .. tostring(max_num) .. "] can only be negative if a min number is also supplied");
		return 0;
	end;
	
	if not is_number(min_num) or min_num >= max_num or math.floor(min_num) < min_num then
		script_error("random_number ERROR: supplied min number [" .. tostring(min_num) .. "] is not an integer less than the max num [" .. tostring(max_num) .. "]");
		return 0;
	end;
	
	return self:model():random_int(min_num, max_num);
end;


--- @function random_sort
--- @desc Randomly sorts a numerically-indexed table. This is safe to use in multiplayer, but will destroy the supplied table. It is faster than @campaign_manager:random_sort_copy.
--- @desc Note that records in this table that are not arranged in an ascending numerical index will be lost.
--- @desc Note also that the supplied table is overwritten with the randomly-sorted table, which is also returned as a return value.
--- @p @table numerically-indexed table, Numerically-indexed table. This will be overwritten by the returned, randomly-sorted table.
--- @r @table randomly-sorted table
function campaign_manager:random_sort(t)
	if not is_table(t) then
		script_error("ERROR: random_sort() called but supplied object [" .. tostring(t) .. "] is not a table");
		return false;
	end;

	local new_t = {};
	local table_size = #t;
	local n = 0;
	
	for i = 1, table_size do
		
		-- pick an entry from t, add it to new_t, then remove it from t
		n = self:random_number(#t);
		
		table.insert(new_t, t[n]);
		table.remove(t, n);
	end;
	
	return new_t;
end;


--- @function random_sort_copy
--- @desc Randomly sorts a numerically-indexed table. This is safe to use in multiplayer, and will preserve the original table, but it is slower than @campaign_manager:random_sort as it copies the table first.
--- @desc Note that records in the source table that are not arranged in an ascending numerical index will not be copied (they will not be deleted, however).
--- @p @table numerically-indexed table, Numerically-indexed table.
--- @r @table randomly-sorted table
function campaign_manager:random_sort_copy(t)
	if not is_table(t) then
		script_error("ERROR: random_sort_copy() called but supplied object [" .. tostring(t) .. "] is not a table");
		return false;
	end;

	local table_size = #t;
	local new_t = {};

	-- copy this table
	for i = 1, table_size do
		new_t[i] = t[i];
	end;

	return self:random_sort(new_t);
end;


--- @function shuffle_table
--- @desc Randomly shuffles a table with an implementation of the Fisher-Yates shuffle.
--- @desc Note that, unlike the random_sort and random_sort_copy functions, this modifies the existing table and doesn't destroy the original or create a new table.
--- @p @table table
function campaign_manager:shuffle_table(tab)
	for i = #tab, 2, -1 do
		local j = self:random_number(i)
		tab[i], tab[j] = tab[j], tab[i];
	end;
end;













----------------------------------------------------------------------------
--- @section Campaign UI
----------------------------------------------------------------------------


--- @function is_cinematic_ui_enabled
--- @desc Returns whether the cinematic UI is currently enabled. The cinematic UI is enabled from script with @campaignui:ToggleCinematicBorders, and is commonly activated/deactivated by cutscenes.
--- @r @boolean is cinematic ui enabled
function campaign_manager:is_cinematic_ui_enabled()
	return common.get_context_value("CcoCampaignRoot", "", "IsCinematicModeEnabled()");
end;



--- @function get_campaign_ui_manager
--- @desc Gets a handle to the @campaign_ui_manager (or creates it).
--- @r campaign_ui_manager
function campaign_manager:get_campaign_ui_manager()
	if self.campaign_ui_manager then
		return self.campaign_ui_manager;
	end;
	return campaign_ui_manager:new();
end;


--- @function highlight_event_dismiss_button
--- @desc Activates or deactivates a highlight on the event panel dismiss button. This may not work in all circumstances.
--- @p [opt=true] boolean should highlight
function campaign_manager:highlight_event_dismiss_button(should_highlight)

	if should_highlight ~= false then
		should_highlight = true;
	end;
	
	local uic_button = find_uicomponent(core:get_ui_root(), "panel_manager", "events", "button_set", "accept_decline", "button_accept");
	local button_highlighted = false;
	
	-- if should_highlight is false, then both potential buttons get unhighlighted
	-- if it's true, then only the first that is found to be visible is highlighted
		
	if uic_button and (uic_button:Visible(true) or not should_highlight) then
		uic_button:Highlight(should_highlight, false, 0);
		button_highlighted = true;
	end;
	
	if button_highlighted and should_highlight then
		return;
	end;
	
	uic_button = find_uicomponent(core:get_ui_root(), "panel_manager", "events", "button_set", "accept_holder", "button_accept");
	
	if uic_button and (uic_button:Visible(true) or not should_highlight) then
		uic_button:Highlight(should_highlight, false, 0);
	end;
end;


--- @function quit
--- @desc Immediately exits to the frontend. Mainly used in benchmark scripts.
function campaign_manager:quit()
	out("campaign_manager:quit() called");
	
	self:dismiss_advice();

	self:callback(
		function()
			self:steal_user_input(true);
			core:get_ui_root():InterfaceFunction("QuitForScript");
		end,
		1
	);
end;


--- @function enable_ui_hiding
--- @desc Enables or disables the ability of the player to hide the UI.
--- @p [opt=true] boolean enable hiding
function campaign_manager:enable_ui_hiding(value)
	if value ~= false then
		value = true;
	end;

	self.ui_hiding_enabled = value;

	self.game_interface:disable_shortcut("root", "toggle_ui", not value);
	self.game_interface:disable_shortcut("root", "toggle_ui_with_borders", not value);
end;


--- @function is_ui_hiding_enabled
--- @desc Returns <code>false</code> if ui hiding has been disabled with @campaign_manager:enable_ui_hiding, <code>true</code> otherwise.
--- @r boolean is ui hiding enabled
function campaign_manager:is_ui_hiding_enabled()
	return self.ui_hiding_enabled;
end;


--- @function register_instant_movie
--- @desc Plays a fullscreen movie, by path from the <code>data/Movies</code> directory. This function wraps the underlying @episodic_scripting:register_instant_movie to play the movie and provide output.
--- @p @string movie path
--- @example -- play the movie file data/Movies/Warhammer/chs_rises
--- @example cm:register_instant_movie("Warhammer/chs_rises")
function campaign_manager:register_instant_movie(movie_path)
	out("* register_instant_movie() is playing movie " .. movie_path); 
	return self.game_interface:register_instant_movie(movie_path);
end;









-----------------------------------------------------------------------------
--- @section Camera Movement
--- @desc The functions in this section allow or automate camera scrolling to some degree. Where camera positions are supplied as arguments, these are given as a table of numbers. The numbers in a camera position table are given in the following order:
--- @desc <ol><li>x co-ordinate of camera target.</li>
--- @desc <li>y co-ordinate of camera target.</li>
--- @desc <li>horizontal distance from camera to target.</li>
--- @desc <li>bearing from camera to target, in radians.</li>
--- @desc <li>vertical distance from camera to target.</li></ol>
-----------------------------------------------------------------------------


-- called internally by various camera functions
function campaign_manager:check_valid_camera_waypoint(waypoint)
	if not is_table(waypoint) then
		script_error("ERROR: check_valid_camera_waypoint() called but supplied waypoint [" .. tostring(waypoint) .. "] is not a table");
		return false;
	end;
	
	for i = 1, 5 do
		if not is_number(waypoint[i]) then
			script_error("ERROR: check_valid_camera_waypoint() called but index [" .. i .. "] of supplied waypoint is not a number but is [" .. tostring(waypoint[i]) .. "]");
			return false;
		end;
	end;
	
	-- for waypoints that include a timestamp
	if #waypoint == 6 then
		if not is_number(waypoint[6]) then
			script_error("ERROR: check_valid_camera_waypoint() called but index [" .. 6 .. "] of supplied waypoint is not a number but is [" .. tostring(waypoint[6]) .. "]");
			return false;
		end;
	end;
	
	return true;
end;


-- returns true if the supplied positions are the same
function campaign_manager:scroll_camera_position_check(source, dest)
	return source[1] == dest[1] and source[2] == dest[2] and source[3] == dest[3] and source[4] == dest[4] and source[5] == dest[5];
end;


-- internal function to convert a camera position to a string
function campaign_manager:camera_position_to_string(x, y, d, b, h)
	if is_table(x) then
		y = x[2];
		d = x[3];
		b = x[4];
		h = x[5];
		x = x[1];
	end;
	
	return "[x: " .. tostring(x) .. ", y: " .. tostring(y) .. ", d: " .. tostring(d) .. ", b: " .. tostring(b) .. ", h: " .. tostring(h) .. "]";
end;


--- @function scroll_camera_with_direction
--- @desc Override function for scroll_camera_wiht_direction that provides output.
--- @p boolean correct endpoint, Correct endpoint. If true, the game will adjust the final position of the camera so that it's a valid camera position for the game. Set to true if control is being released back to the player after this camera movement finishes.
--- @p number time, Time in seconds over which to scroll.
--- @p ... positions, Two or more camera positions must be supplied. Each position should be a table with five number components, as described in the description of the @"campaign_manager:Camera Movement" section.
--- @new_example
--- @desc Pull the camera out from a close-up to a wider view.
--- @example cm:scroll_camera_with_direction(
--- @example 	true,
--- @example 	5,
--- @example 	{132.9, 504.8, 8, 0, 6},
--- @example 	{132.9, 504.8, 16, 0, 12}
--- @example )
function campaign_manager:scroll_camera_with_direction(correct_endpoint, t, ...)

	local x, y, d, b, h = self:get_camera_position();
	
	out("scroll_camera_with_direction() called, correct endpoint is " .. tostring(correct_endpoint) .. ", time is " .. tostring(t) .. "s, current camera position is " .. self:camera_position_to_string(x, y, d, b, h));
	
	out.inc_tab();
	for i = 1, arg.n do
		local current_pos = arg[i];
		out("position " .. i .. ": " .. self:camera_position_to_string(current_pos[1], current_pos[2], current_pos[3], current_pos[4], current_pos[5]));
	end;
	out.dec_tab();
	
	self.game_interface:scroll_camera_with_direction(correct_endpoint, t, unpack(arg));
end;


--- @function scroll_camera_from_current
--- @desc Scrolls the camera from the current camera position. This is the same as callling @campaign_manager:scroll_camera_with_direction with the current camera position as the first set of co-ordinates.
--- @p boolean correct endpoint, Correct endpoint. If true, the game will adjust the final position of the camera so that it's a valid camera position for the game. Set to true if control is being released back to the player after this camera movement finishes.
--- @p number time, Time in seconds over which to scroll.
--- @p ... positions, One or more camera positions must be supplied. Each position should be a table with five number components, as described in the description of the @"campaign_manager:Camera Movement" section.
--- @example cm:scroll_camera_from_current(
--- @example 	true,
--- @example 	5,
--- @example 	{251.3, 312.0, 12, 0, 8}
--- @example )
function campaign_manager:scroll_camera_from_current(correct_endpoint, t, ...)
	-- check our parameters
	if not is_number(t) or t <= 0 then
		script_error("ERROR: scroll_camera_from_current() called but supplied duration [" .. tostring(t) .. "] is not a number");
		return false;
	end;
	
	for i = 1, arg.n do
		if not self:check_valid_camera_waypoint(arg[i]) then
			-- error will be returned by the function above
			return false;
		end;
	end;
	
	-- insert the current camera position as the first position in the sequence
	local x, y, d, b, h = self:get_camera_position();
	
	table.insert(arg, 1, {x, y, d, b, h});
	
	-- output
	out("scroll_camera_from_current() called");
	out.inc_tab();	
	self:scroll_camera_with_direction(correct_endpoint, t, unpack(arg))
	out.dec_tab();
end;

--- @function scroll_camera_to_region
--- @desc Scrolls the camera from the current camera position. This hooks into scroll_camera_from_current, and respects the player's current height/rotation
--- @p string faction_key, which faction to pan the camera for. This is to make sure we're not panning the camera for all players in mp
--- @p string region_key, the region the camera should pan to. 
--- @p string time, Time in seconds over which to scroll.
--- @example cm:scroll_camera_to_region(
--- @example 	"wh_main_emp_empire",
--- @example 	"wh3_main_combi_region_altdorf",
--- @example 	5
--- @example )
function campaign_manager:scroll_camera_to_region(faction_key, region_key, time)
	if not is_string(faction_key) then
		script_error("ERROR: scroll_camera_to_region() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string");
		return false;
	end;

	if not is_string(region_key) then
		script_error("ERROR: scroll_camera_to_region() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return false;
	end;

	local region = cm:get_region(region_key);
	
	if not region then
		script_error("ERROR: scroll_camera_to_region() called but region with supplied key [" .. region_key .. "] could not be found");
		return false;
	end;
	
	if cm:get_local_faction_name() == faction_key then
		local display_x = region:settlement():display_position_x()
		local display_y = region:settlement():display_position_y()
		local cached_x, cached_y, cached_d, cached_b, cached_h = cm:get_camera_position()
		cm:scroll_camera_from_current(false, time, {display_x, display_y, cached_d, cached_b, cached_h})
	end
end


--- @function scroll_camera_with_cutscene
--- @desc Scrolls the camera from the current camera position in a cutscene. Cinematic borders will be shown (unless disabled with @campaign_manager:set_use_cinematic_borders_for_automated_cutscenes), the UI hidden, and interaction with the game disabled while the camera is scrolling. The player will be able to skip the cutscene with the ESC key, in which case the camera will jump to the end position.
--- @p number time, Time in seconds over which to scroll.
--- @p [opt=nil] function callback, Optional callback to call when the cutscene ends.
--- @p ... positions, One or more camera positions must be supplied. Each position should be a table with five number components, as described in the description of the @"campaign_manager:Camera Movement" section.
function campaign_manager:scroll_camera_with_cutscene(t, end_callback, ...)

	-- check our parameters
	if not is_number(t) or t <= 0 then
		script_error("ERROR: scroll_camera_with_cutscene() called but supplied duration [" .. tostring(t) .. "] is not a number");
		return false;
	end;
	
	if not is_function(end_callback) and not is_nil(end_callback) then
		script_error("ERROR: scroll_camera_with_cutscene() called but supplied end_callback [" .. tostring(end_callback) .. "] is not a function or nil");
		return false;
	end;
	
	for i = 1, arg.n do
		if not self:check_valid_camera_waypoint(arg[i]) then
			-- error will be returned by the function above
			return false;
		end;
	end;
	
	-- get the last position now before we start mucking around with the argument list
	local last_pos = arg[arg.n];
	
	-- insert the current camera position as the first position in the sequence
	local x, y, d, b, h = self:get_camera_position();
	
	table.insert(arg, 1, {x, y, d, b, h});
	
	self:cut_and_scroll_camera_with_cutscene(t, end_callback, unpack(arg));
end;


--- @function cut_and_scroll_camera_with_cutscene
--- @desc Scrolls the camera through the supplied list of camera points in a cutscene. Cinematic borders will be shown (unless disabled with @campaign_manager:set_use_cinematic_borders_for_automated_cutscenes), the UI hidden, and interaction with the game disabled while the camera is scrolling. The player will be able to skip the cutscene with the ESC key, in which case the camera will jump to the end position.
--- @p number time, Time in seconds over which to scroll.
--- @p [opt=nil] function callback, Optional callback to call when the cutscene ends.
--- @p ... positions. One or more camera positions must be supplied. Each position should be a table with five number components, as described in the description of the @"campaign_manager:Camera Movement" section.
function campaign_manager:cut_and_scroll_camera_with_cutscene(t, end_callback, ...)

	-- check our parameters
	if not is_number(t) or t <=0 then
		script_error("ERROR: cut_and_scroll_camera_with_cutscene() called but supplied duration [" .. tostring(t) .. "] is not a number");
		return false;
	end;
	
	if not is_function(end_callback) and not is_nil(end_callback) then
		script_error("ERROR: cut_and_scroll_camera_with_cutscene() called but supplied end_callback [" .. tostring(end_callback) .. "] is not a function or nil");
		return false;
	end;
	
	if arg.n < 2 then
		script_error("ERROR: cut_and_scroll_camera_with_cutscene() called but less than two camera positions given");
		return false;
	end;
	
	for i = 1, arg.n do
		if not self:check_valid_camera_waypoint(arg[i]) then
			-- error will be returned by the function above
			return false;
		end;
	end;
		
	-- make a cutscene, add the camera pan as the action and play it
	local cutscene = campaign_cutscene:new(
		"scroll_camera_with_cutscene", 
		t, 
		function() 
			out.dec_tab();
			if end_callback then
				end_callback();
			end;
		end
	);
	
	cutscene:set_skippable(true, arg[arg.n]);	-- set the last position in the supplied list to be the skip position
	cutscene:set_dismiss_advice_on_end(false);
	
	cutscene:set_use_cinematic_borders(self.use_cinematic_borders_for_automated_cutscenes);
	cutscene:set_disable_settlement_labels(false);
	
	local start_position = arg[1];
	
	cutscene:action(function() self:set_camera_position(unpack(start_position)) end, 0);
	cutscene:action(
		function()
			out.inc_tab();
			self:scroll_camera_with_direction(true, t, unpack(arg));
			out.dec_tab();
		end, 
		0
	);
	cutscene:start();
end;


--- @function scroll_camera_with_cutscene_to_settlement
--- @desc Scrolls the camera in a cutscene to the specified settlement in a cutscene. The settlement is specified by region key. Cinematic borders will be shown (unless disabled with @campaign_manager:set_use_cinematic_borders_for_automated_cutscenes), the UI hidden, and interaction with the game disabled while the camera is scrolling. The player will be able to skip the cutscene with the ESC key, in which case the camera will jump to the target.
--- @p number time, Time in seconds over which to scroll.
--- @p [opt=nil] function callback, Optional callback to call when the cutscene ends.
--- @p string region key, Key of region containing target settlement.
function campaign_manager:scroll_camera_with_cutscene_to_settlement(t, end_callback, region_key)
	if not is_string(region_key) then
		script_error("ERROR: scroll_camera_with_cutscene_to_settlement() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return false;
	end;

	local region = cm:get_region(region_key);
	
	if not region then
		script_error("ERROR: scroll_camera_with_cutscene_to_settlement() called but region with supplied key [" .. region_key .. "] could not be found");
		return false;
	end;
	
	local settlement = region:settlement();
	
	local targ_x = settlement:display_position_x();
	local targ_y = settlement:display_position_y();
	
	local x, y, d, b, h = self:get_camera_position();
	
	-- pan camera to calculated target
	self:scroll_camera_with_cutscene(
		t, 
		end_callback,
		{targ_x, targ_y, 7.6, b, 4.0}
	);
end;


--- @function scroll_camera_with_cutscene_to_character
--- @desc Scrolls the camera in a cutscene to the specified character in a cutscene. The character is specified by its command queue index (cqi). Cinematic borders will be shown (unless disabled with @campaign_manager:set_use_cinematic_borders_for_automated_cutscenes), the UI hidden, and interaction with the game disabled while the camera is scrolling. The player will be able to skip the cutscene with the ESC key, in which case the camera will jump to the target.
--- @p number time, Time in seconds over which to scroll.
--- @p [opt=nil] function callback, Optional callback to call when the cutscene ends.
--- @p number cqi, CQI of target character.
function campaign_manager:scroll_camera_with_cutscene_to_character(t, end_callback, char_cqi)
	if not is_number(char_cqi) then
		script_error("ERROR: scroll_camera_with_cutscene_to_character() called but supplied character cqi [" .. tostring(char_cqi) .. "] is not a number");
		return false;
	end;
		
	local character = self:get_character_by_cqi(char_cqi);
	
	if not character then
		script_error("ERROR: scroll_camera_with_cutscene_to_character() called but no character with cqi [" .. char_cqi .. "] could be found");
		return false;
	end;
	
	local targ_x = character:display_position_x();
	local targ_y = character:display_position_y();
	
	local x, y, d, b, h = self:get_camera_position();
	
	-- pan camera to calculated target
	self:scroll_camera_with_cutscene(
		t, 
		end_callback,
		{targ_x, targ_y, 7.6, b, 4.0}
	);
end;


--- @function set_use_cinematic_borders_for_automated_cutscenes
--- @desc Sets whether or not to show cinematic borders when scrolling the camera in an automated cutscene (for example with @campaign_manager:scroll_camera_with_cutscene). By default, cinematic borders are displayed.
--- @p [opt=true] boolean show borders
function campaign_manager:set_use_cinematic_borders_for_automated_cutscenes(value)
	if value == false then
		self.use_cinematic_borders_for_automated_cutscenes = false;
	else
		self.use_cinematic_borders_for_automated_cutscenes = true;
	end;
end;


-- use with care
function campaign_manager:scroll_camera_from_current_with_smoothing(correct_endpoint, ...)

	if not is_boolean(correct_endpoint) then
		script_error("ERROR: scroll_camera_from_current_with_smoothing() called but supplied correct_endpoint flag [" .. tostring(correct_endpoint) .. "] is not a boolean value");
		return false;
	end;

	if arg.n == 0 then
		script_error("ERROR: scroll_camera_from_current_with_smoothing() called but no waypoints supplied");
		return false;
	end;
	
	local max_time = 0;
	local camera_waypoints = {};				-- internal list of waypoints
	
	local processed_waypoints = {};				-- internal list of processed waypoints i.e. one per second
	
	-- insert current camera position at start
	local x, y, d, b, h = self:get_camera_position();
	table.insert(camera_waypoints, 1, {x, y, d, b, h, 0});
	table.insert(processed_waypoints, {x, y, d, b, h});
	
	-- check supplied waypoints are valid
	for i = 1, arg.n do
		local current_waypoint = arg[i];
	
		if not self:check_valid_camera_waypoint(current_waypoint) then
			-- error will be returned by the function above
			return false;
		end;
		
		local current_time = current_waypoint[6];
		
		if math.floor(current_time) < current_time then
			script_error("WARNING: scroll_camera_from_current_with_smoothing() called but supplied camera waypoint [" .. i .. "] has a specified time of [" .. tostring(current_time) .. "] - only integer values are supported, rounding it down");
			current_time = math.floor(current_time);
		end;
		
		out("attempting to insert waypoint with time " .. current_time);
		
		-- insert supplied waypoint into internal list
		local waypoint_inserted = false;
		for j = 1, #camera_waypoints do
			out("\tcomparing against pre-inserted waypoint with time " .. camera_waypoints[j][6]);
			if camera_waypoints[j][6] > current_time then
				out("\tinserting waypoint");
				waypoint_inserted = true;
				table.insert(camera_waypoints, j, {current_waypoint[1], current_waypoint[2], current_waypoint[3], current_waypoint[4], current_waypoint[5], current_time});
			end;
		end;
		
		if not waypoint_inserted then
			out("inserting waypoint at end");
			table.insert(camera_waypoints, {current_waypoint[1], current_waypoint[2], current_waypoint[3], current_waypoint[4], current_waypoint[5], current_time});
		end;
		
		if current_time > max_time then
			max_time = current_time;
		end;
	end;
	
	local current_camera_waypoint_pointer = 1;
		
	for i = 1, max_time do
		-- check we're not going to overrun the end of our camera_waypoints list
		if current_camera_waypoint_pointer >= #camera_waypoints then
			script_error("ERROR: scroll_camera_from_current_with_smoothing() is going to overrun the end of its camera_waypoints list, how can this be? current camera waypoint pointer is [" .. tostring(current_camera_waypoint_pointer) .. "], number of unprocessed waypoints is [" .. #camera_waypoints .. "], current time is [" .. tostring(i) .. "], and max time is [" .. tostring(max_time) .. "]");
			return false;
		end;
		
		local current_camera_waypoint = camera_waypoints[current_camera_waypoint_pointer];
		local next_camera_waypoint = camera_waypoints[current_camera_waypoint_pointer + 1];
		
		local current_camera_waypoint_time = current_camera_waypoint[6];
		local next_camera_waypoint_time = next_camera_waypoint[6];
		
		-- if we're reached the next waypoint, add it directly
		if i == next_camera_waypoint_time then
			table.insert(processed_waypoints, {next_camera_waypoint[1], next_camera_waypoint[2], next_camera_waypoint[3], next_camera_waypoint[4], next_camera_waypoint[5]});
			current_camera_waypoint_pointer = current_camera_waypoint_pointer + 1;
			
		else
			-- we're midway between two waypoints - calculate the position
			local waypoint_to_add = {};
			
			for j = 1, 5 do
				waypoint_to_add[j] = current_camera_waypoint[j] + ((next_camera_waypoint[j] - current_camera_waypoint[j]) * (i - current_camera_waypoint_time)) / (next_camera_waypoint_time - current_camera_waypoint_time)
			end;
			
			table.insert(processed_waypoints, waypoint_to_add);
		end;
	end;
	
	out("scroll_camera_from_current_with_smoothing() called");
	out.inc_tab();	
	self:scroll_camera_with_direction(correct_endpoint, max_time, unpack(processed_waypoints))
	out.dec_tab();
end;


--- @function position_camera_at_primary_military_force
--- @desc Immediately positions the camera at a position looking at the primary military force for the supplied faction. The faction is specified by key.
--- @p string faction key
function campaign_manager:position_camera_at_primary_military_force(faction_name)
	if not is_string(faction_name) then
		script_error("ERROR: position_camera_at_primary_military_force() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	local faction = cm:get_faction(faction_name);
	
	if not faction then
		script_error("ERROR: position_camera_at_primary_military_force() called but no faction with name [" .. faction_name .. "] could be found");
		return false;
	end;
	
	if not faction:has_faction_leader() then
		script_error("ERROR: position_camera_at_primary_military_force() called but no faction leader could be found for faction [" .. faction_name .. "]");
		return false;
	end;
	
	local faction_leader = faction:faction_leader();
	local x = nil;
	local y = nil;
	
	if faction_leader:has_military_force() then
		x = faction_leader:display_position_x();
		y = faction_leader:display_position_y();
	else
		local mf_list_item_0 = faction:military_force_list():item_at(0);
		
		if mf_list_item_0:has_general() then
			local general = mf_list_item_0:general_character();
			
			x = general:display_position_x();
			y = general:display_position_y();
		else
			script_error("ERROR: position_camera_at_primary_military_force() called but no military force for faction [" .. faction_name .. "] could be found on the map");
		end;
	end
	
	cm:set_camera_position(x, y, 7.6, 0.0, 4.0);
end;


--- @function cindy_playback
--- @desc Starts playback of a cindy scene. This is a wrapper for the @cinematics:cindy_playback function, adding debug output.
--- @p @string filepath, File path to cindy scene, from the working data folder.
--- @p [opt=nil] @number blend in duration, Time in seconds over which the camera will blend into the cindy scene when started.
--- @p [opt=nil] @number blend out duration, Time in seconds over which the camera will blend out of the cindy scene when it ends.
function campaign_manager:cindy_playback(filepath, blend_in_duration, blend_out_duration)
	
	if not is_string(filepath) then
		script_error("ERROR: cindy_playback() called but supplied file path [" .. tostring(filepath) .. "] is not a string");
		return false;
	end;

	if blend_in_duration and not is_number(blend_in_duration) then
		script_error("ERROR: cindy_playback() called but supplied blend in duration [" .. tostring(blend_in_duration) .. "] is not a number or nil");
		return false;
	end;

	if blend_out_duration and not is_number(blend_out_duration) then
		script_error("ERROR: cindy_playback() called but supplied blend out duration [" .. tostring(blend_out_duration) .. "] is not a number or nil");
		return false;
	end;

	if (blend_in_duration and not blend_out_duration) or (blend_out_duration and not blend_in_duration) then
		script_error("WARNING: cindy_playback() called with blend in duration [" .. tostring(blend_in_duration) .. "] and blend out duration [" .. tostring(blend_out_duration) .. "] specified - both need to be supplied for either to work");
		return false;
	end;

	-- Don't try and trigger the cindyscene in minimalist mode
	if CampaignUI.IsMinimalViewModeEnabled() then
		out("An attempt in script was made to start cinematic playback of file: " .. filepath .. " but the campaign is in minimalist mode, skipping");
		return;
	end;

	out("Starting cinematic playback of file: " .. filepath .. ".");
	self.cinematic_interface:cindy_playback(filepath, blend_in_duration, blend_out_duration);
end;


--- @function stop_cindy_playback
--- @desc Stops playback of any currently-playing cindy scene. This is a wrapper for the function of the same name on the <code>cinematic</code> interface, but adds debug output.
--- @p boolean clear animation scenes
function campaign_manager:stop_cindy_playback(clear_anim_scenes)
	out("Stopping cinematic playback");	
	self.cinematic_interface:stop_cindy_playback(clear_anim_scenes);
end;











-----------------------------------------------------------------------------
--- @section Camera Position Caching
--- @desc The functions in this section allow the current position of the camera to be cached, and then for a test to be performed later to determine if the camera has moved. This is useful for determining if the player has moved the camera, which would indicate whether it's appropriate or not to scroll the camera via script in certain circumstances.
-----------------------------------------------------------------------------


--- @function cache_camera_position
--- @desc Caches the current camera position, so that the camera position may be compared to it later to determine if it has moved. An optional name may be specified for this cache entry so that multiple cache entries may be created. If the camera position was previously cached with the supplied cache name then that cache will be overwritten.
--- @p [opt="default"] string cache name
function campaign_manager:cache_camera_position(cache_name)
	if cache_name then
		if not is_string(cache_name) then
			script_error("ERROR: cache_camera_position() called but supplied cache name [" .. tostring(cache_name) .. "] is not a string or nil");
			return false;
		end;
	else
		cache_name = "default";
	end;

	local cached_camera_record = {};
	cached_camera_record.x, cached_camera_record.y, cached_camera_record.d, cached_camera_record.b, cached_camera_record.h = self:get_camera_position();
	
	self.cached_camera_records[cache_name] = cached_camera_record;
end;


--- @function cached_camera_position_exists
--- @desc Returns whether a camera position is currently cached for the (optional) supplied cache name.
--- @p [opt="default"] string cache name
--- @r @boolean camera position is cached
function campaign_manager:cached_camera_position_exists(cache_name)
	if cache_name then
		if not is_string(cache_name) then
			script_error("ERROR: cached_camera_position_exists() called but supplied cache name [" .. tostring(cache_name) .. "] is not a string or nil");
			return false;
		end;
	else
		cache_name = "default";
	end;

	return not not self.cached_camera_records[cache_name];
end;


--- @function get_cached_camera_position
--- @desc Returns the camera position which was last cached with the optional cache name (the default cache name is <code>"default"</code>). If no camera cache has been set with the specified name then a script error is generated.
--- @p [opt="default"] string cache name
--- @r @number x
--- @r @number y
--- @r @number d
--- @r @number b
--- @r @number h
function campaign_manager:get_cached_camera_position(cache_name)
	if cache_name then
		if not is_string(cache_name) then
			script_error("ERROR: get_cached_camera_position() called but supplied cache name [" .. tostring(cache_name) .. "] is not a string or nil");
			return false;
		end;
	else
		cache_name = "default";
	end;
		
	local cached_camera_record = self.cached_camera_records[cache_name];
	
	if cached_camera_record then
		return cached_camera_record.x, cached_camera_record.y, cached_camera_record.d, cached_camera_record.b, cached_camera_record.h;
	end;
end;


--- @function camera_has_moved_from_cached
--- @desc Compares the current position of the camera to that last cached with the (optional) specified cache name, and returns <code>true</code> if any of the camera co-ordinates have changed by the (optional) supplied distance, or <code>false</code> otherwise. If no camera cache has been set with the specified name then a script error is generated.
--- @p [opt="default"] string cache name
function campaign_manager:camera_has_moved_from_cached(cache_name, distance)
	if cache_name then
		if not is_string(cache_name) then
			script_error("ERROR: camera_has_moved_from_cached() called but supplied cache name [" .. tostring(cache_name) .. "] is not a string or nil");
			return false;
		end;
	else
		cache_name = "default";
	end;
	
	if not distance then
		distance = 1;
	else
		if not is_number(distance) then
			script_error("ERROR: camera_has_moved_from_cached() called but supplied distance [" .. distance .. "] is not a positive number or nil");
			return false;
		end;
	end;
	
	local cached_camera_record = self.cached_camera_records[cache_name];
	
	if not cached_camera_record then
		script_error("ERROR: camera_has_moved_from_cached() called but no cache with supplied name [" .. cache_name .. "] is currently set");
		return false;
	end;
	
	local x, y, d, b, h = cm:get_camera_position();
	
	return math.abs(cached_camera_record.x - x) > 1 or 
		math.abs(cached_camera_record.y - y) > 1 or
		math.abs(cached_camera_record.d - d) > 1 or
		math.abs(cached_camera_record.b - b) > 1 or
		math.abs(cached_camera_record.h - h) > 1;
end;


--- @function delete_cached_camera_position
--- @desc Removes the cache for the supplied cache name. If no cache name is specified the default cache (cache name <code>"default"</code>) is deleted.
--- @p [opt="default"] string cache name
function campaign_manager:delete_cached_camera_position(cache_name)
	if cache_name then
		if not is_string(cache_name) then
			script_error("ERROR: reset_cached_camera_position() called but supplied cache name [" .. tostring(cache_name) .. "] is not a string or nil");
			return false;
		end;
	else
		cache_name = "default";
	end;
	
	self.cached_camera_records[cache_name] = nil;
end;











----------------------------------------------------------------------------
---	@section Cutscenes and Key Stealing
----------------------------------------------------------------------------


--- @function show_subtitle
--- @desc Shows subtitled text during a cutscene. The text is displayed until @campaign_manager:hide_subtitles is called.
--- @p string text key, Text key. By default, this is supplied as a record key from the <code>scripted_subtitles</code> table. Text from anywhere in the database may be shown, however, by supplying the full localisation key and <code>true</code> for the second argument.
--- @p [opt=false] boolean full text key supplied, Set to true if the fll localised text key was supplied for the first argument in the form [table]_[field]_[key].
--- @p [opt=false] boolean force diplay, Forces subtitle display. Setting this to <code>true</code> overrides the player's preferences on subtitle display.
function campaign_manager:show_subtitle(key, full_key_supplied, should_force)

	if not is_string(key) then
		script_error("ERROR: show_subtitle() called but supplied key [" .. tostring(key) .. "] is not a string");
		return false;
	end;
	
	-- only proceed if we're forcing the subtitle to play, or if the subtitle preferences setting is on
	if not should_force and not common.subtitles_enabled() then
		return;
	end;
	
	local full_key;
	
	if not full_key_supplied then
		full_key = "scripted_subtitles_localised_text_" .. key;
	else
		full_key = key;
	end;
	
	local localised_text = common.get_localised_string(full_key);
	
	if not is_string(localised_text) then
		script_error("ERROR: show_subtitle() called but could not find any localised text corresponding with supplied key [" .. tostring(key) .. "] in scripted_subtitles table");
		return false;
	end;

	local ui_root = core:get_ui_root();
	
	out("show_subtitle() called, supplied key is [" .. key .. "] and localised text is [" .. localised_text .. "]");

	-- create the subtitles component if it doesn't already exist
	if not self.subtitles_component_created then
		ui_root:CreateComponent("scripted_subtitles", "UI/Campaign UI/scripted_subtitles.twui.xml");
		self.subtitles_component_created = true;
	end;
	
	-- find the subtitles component
	local uic_subtitles = find_uicomponent(ui_root, "scripted_subtitles", "text_child");
	
	if not uic_subtitles then
		script_error("ERROR: show_subtitles() could not find the scripted_subtitles uicomponent");
		return false;
	end;
	
	-- set the text on it
	uic_subtitles:SetStateText(localised_text, full_key);
	
	-- make the subtitles component visible if it's not already
	if not self.subtitles_visible then
		uic_subtitles:SetVisible(true);
		uic_subtitles:RegisterTopMost();
		self.subtitles_visible = true;
	end;
	
	output_uicomponent(uic_subtitles);
end;


--- @function hide_subtitles
--- @desc Hides any subtitles currently displayed with @campaign_manager:show_subtitle.
function campaign_manager:hide_subtitles()
	if self.subtitles_visible then
		-- find the subtitles component
		local uic_subtitles = find_uicomponent(core:get_ui_root(), "scripted_subtitles", "text_child");
	
		uic_subtitles:RemoveTopMost();
		uic_subtitles:SetVisible(false);
		self.subtitles_visible = false;
	end;
end;


-- internal function for a campaign cutscene to register itself with the campaign manager
function campaign_manager:register_cutscene(cutscene)
	if not is_campaigncutscene(cutscene) then
		script_error("ERROR: register_cutscene() called but supplied object [" .. tostring(cutscene) .. "] is not a campaign cutscene");
		return false;
	end;
	
	table.insert(self.cutscene_list, cutscene);
end;


-- internal function that campaign cutscenes call to set global cutscene debug mode
function campaign_manager:set_campaign_cutscene_debug(value)
	if value == false then
		self.is_campaign_cutscene_debug = false;
	else
		self.is_campaign_cutscene_debug = true;
	end;
end;


-- internal function that campaign cutscenes call to query global cutscene debug mode
function campaign_manager:get_campaign_cutscene_debug()
	return self.is_campaign_cutscene_debug;
end;


--- @function is_any_cutscene_running
--- @desc Returns <code>true</code> if any @campaign_cutscene is running, <code>false</code> otherwise.
--- @r boolean is any cutscene running
function campaign_manager:is_any_cutscene_running()

	if #self.cutscene_list == 0 then
		return false;
	end;
	
	for i = 1, #self.cutscene_list do
		if self.cutscene_list[i]:is_active() then
			return true;
		end;
	end;
	
	return false;
end;


--- @function skip_all_campaign_cutscenes
--- @desc Skips any campaign cutscene currently running. 
function campaign_manager:skip_all_campaign_cutscenes()
	for i = 1, #self.cutscene_list do
		self.cutscene_list[i]:skip();
	end;
end;


--- @function steal_escape_key_on_event
--- @desc Steals or un-steals the escape key if the supplied script event is received, optionally with the specified condition. This function calls @episodic_scripting:steal_escape_key.
--- @p @boolean should steal, Should steal the escape key or not.
--- @p @string event, Event to listen for.
--- @p [opt=true] @function condition, Event condition that must return true for the key steal action to take place.
--- @p [opt=0] @number delay, Delay in seconds before key is stolen. Will sometimes need a slight delay after an event.
--- @p [opt="steal_escape_key_on_event"] string listener name, Optional name for the listener.

function campaign_manager:steal_escape_key_on_event(should_steal, event_name, condition, delay_before_steal, listener_name)
	if not validate.is_string(event_name) then
		return false;
	end;
	
	listener_name = listener_name or "steal_escape_key_on_event"
	condition = condition or true;
	delay_before_steal = delay_before_steal or 0

	core:add_listener(
		listener_name,
		event_name,
		condition,
		function()
			cm:callback(function() self:steal_escape_key(should_steal) end, delay_before_steal)
		end,
		false
	);
end;

--- @function steal_user_input_on_event
--- @desc Steals or un-steals user input if the supplied script event is received, optionally with the specified condition. This function calls @episodic_scripting:steal_user_input().
--- @p @boolean should steal, Should steal user input or not.
--- @p @string event, Event to listen for.
--- @p [opt=true] @function condition, Event condition that must return true for the user input action to take place.
--- @p [opt=0] @number delay, Delay in seconds before user input is stolen. Will sometimes need a slight delay after an event.
--- @p [opt="steal_user_input_on_event"] string listener name, Optional name for the listener.

function campaign_manager:steal_user_input_on_event(should_steal, event_name, condition, delay_before_steal, listener_name)
	if not validate.is_string(event_name) then
		return false;
	end;
	
	listener_name = listener_name or "steal_user_input_on_event"
	condition = condition or true;
	delay_before_steal = delay_before_steal or 0

	core:add_listener(
		listener_name,
		event_name,
		condition,
		function()
			cm:callback(function() cm:steal_user_input(should_steal) end, delay_before_steal)
		end,
		false
	);
end;


-- called by the code whenever a key is pressed when input has been stolen
-- input is stolen when steal_user_input() (all keys) or steal_escape_key() (just esc key) are called
function OnKeyPressed(key, is_key_up)
	if is_key_up == true then
		cm:on_key_press_up(key);
	end;
end;


--- @function on_key_press_up
--- @desc Called by the campaign model when a key stolen by steal_user_input or steal_escape_key is pressed. Client scripts should not call this!
--- @p string key pressed
function campaign_manager:on_key_press_up(key)	
	-- if anything has stolen this key, then execute the callback on the top of the relevant stack, then remove it
	local key_table = self.stolen_keys[key];
	if is_table(key_table) and #key_table > 0 then
		local entry = key_table[#key_table];
		local callback = entry.callback;
		if not entry.is_persistent then
			table.remove(key_table, #key_table);
		end;
		callback();
	end;
end;


--- @function print_key_steal_entries
--- @desc Debug output of all current stolen key records.
function campaign_manager:print_key_steal_entries()
	out.inc_tab();
	out("*****");
	out("printing key_steal_entries");
	for key, entries in pairs(self.stolen_keys) do
		out("\tkey " .. key);
		for i = 1, #entries do
			local entry = entries[i];
			out("\t\tentry " .. i .. " name is " .. entry.name .. ", callback is " .. tostring(entry.callback) .. ", persistent flag is " .. tostring(entry.is_persistent));
		end;
	end;
	out("*****");
	out.dec_tab();
end;


--- @function steal_key_with_callback
--- @desc Steal a key, and register a callback to be called when it's pressed. It will be un-stolen when this occurs. @episodic_scripting:steal_user_input will need to be called separately for this mechanism to work, unless it's the escape key that being stolen, where @episodic_scripting:steal_escape_key should be used instead. In this latter case @campaign_manager:steal_escape_key_with_callback can be used instead.
--- @p @string name, Unique name for this key-steal entry. This can be used later to release the key with @campaign_manager:release_key_with_callback.
--- @p @string key, Key name.
--- @p @function callback, Function to call when the key is pressed.
--- @p [opt=false] @boolean is persistent, Key should remain stolen after callback is first called.
function campaign_manager:steal_key_with_callback(name, key, callback, is_persistent)
	if not is_string(name) then
		script_error("ERROR: steal_key_with_callback() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if not is_string(key) then
		script_error("ERROR: steal_key_with_callback() called but supplied key [" .. tostring(key) .. "] is not a string");
		return false;
	end;
	
	-- create a table for this key if one doesn't already exist
	if not is_table(self.stolen_keys[key]) then
		self.stolen_keys[key] = {};
	end;

	local key_steal_entries_for_key = self.stolen_keys[key];
	
	-- don't proceed if a keysteal entry with this name already exists
	for i = 1, #key_steal_entries_for_key do
		if key_steal_entries_for_key[i].name == name then
			script_error("ERROR: steal_key_with_callback() called but a steal entry with supplied name [" .. name .. "] already exists for supplied key [" .. tostring(key) .. "]");
			return false;
		end;
	end;
	
	-- create a key steal entry
	local key_steal_entry = {
		["name"] = name,
		["callback"] = callback,
		["is_persistent"] = not not is_persistent
	};
	
	-- add this key steal entry at the end of the list
	table.insert(key_steal_entries_for_key, key_steal_entry);
	
	return true;
end;


--- @function release_key_with_callback
--- @desc Releases a key stolen with @campaign_manager:steal_key_with_callback, by unique name.
--- @p string name, Unique name for this key-steal entry.
--- @p string key, Key name.
function campaign_manager:release_key_with_callback(name, key)
	if not is_string(name) then
		script_error("ERROR: release_key_with_callback() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if not is_string(key) then
		script_error("ERROR: release_key_with_callback() called but supplied key [" .. tostring(key) .. "] is not a string");
		return false;
	end;
	
	local key_steal_entries_for_key = self.stolen_keys[key];
	
	if key_steal_entries_for_key then
		for i = 1, #key_steal_entries_for_key do
			if key_steal_entries_for_key[i].name == name then
				table.remove(key_steal_entries_for_key, i);
				break;
			end;
		end;
	end;
	
	return true;
end;


--- @function steal_escape_key_with_callback
--- @desc Steals the escape key and registers a function to call when it is pressed. Unlike @campaign_manager:steal_key_with_callback this automatically calls @episodic_scripting:steal_escape_key if the key is not already stolen.
--- @p @string name, Unique name for this key-steal entry.
--- @p @function callback, Function to call when the key is pressed.
--- @p [opt=false] @boolean is persistent, Key should remain stolen after callback is first called.
function campaign_manager:steal_escape_key_with_callback(name, callback, is_persistent)	
	-- attempt to steal the escape key if our attempt to register a callback succeeds
	if self:steal_key_with_callback(name, "ESCAPE", callback, is_persistent) then
		self:steal_escape_key(true);
	end;
end;


--- @function release_escape_key_with_callback
--- @desc Releases the escape key after it's been stolen with @campaign_manager:steal_escape_key_with_callback.
--- @p string name, Unique name for this key-steal entry.
function campaign_manager:release_escape_key_with_callback(name)
	-- attempt to release the escape key if our attempt to unregister a callback succeeds, and if the list of things now listening for the escape key is empty	
	if self:release_key_with_callback(name, "ESCAPE") then
		local esc_key_stealers = self.stolen_keys["ESCAPE"];
		if is_table(esc_key_stealers) and #esc_key_stealers == 0 then
			self:steal_escape_key(false);
		end;
	end;
end;


--- @function steal_escape_key_and_space_bar_with_callback
--- @desc Steals the escape key and spacebar and registers a function to call when they are pressed.
--- @p string name, Unique name for this key-steal entry.
--- @p function callback, Function to call when one of the keys are pressed.
--- @p [opt=false] @boolean is persistent, Keys should remain stolen after callback is first called.
function campaign_manager:steal_escape_key_and_space_bar_with_callback(name, callback, is_persistent)
	if self:steal_key_with_callback(name, "SPACE", callback, is_persistent) then
		self:steal_escape_key_with_callback(name, callback, is_persistent);
	end;
end;


--- @function release_escape_key_and_space_bar_with_callback
--- @desc Releases the escape key and spacebar after they've been stolen with @campaign_manager:steal_escape_key_and_space_bar_with_callback.
--- @p string name, Unique name for this key-steal entry
--- @p function callback, Function to call when one of the keys are pressed.
function campaign_manager:release_escape_key_and_space_bar_with_callback(name)
	if self:release_key_with_callback(name, "SPACE", callback) then
		self:release_escape_key_with_callback(name, callback);
	end;
end;











-----------------------------------------------------------------------------
--- @section Advice
-----------------------------------------------------------------------------


--- @function show_advice
--- @desc Displays some advice. The advice to display is specified by <code>advice_thread</code> key.
--- @p string advice key, Advice thread key.
--- @p [opt=false] @boolean show progress button, Show progress/close button on the advisor panel.
--- @p [opt=false] @boolean highlight progress button, Highlight the progress/close button on the advisor panel.
--- @p [opt=nil] @function callback, End callback to call once the advice VO has finished playing.
--- @p [opt=0] @number playtime, Minimum playtime for the advice VO in seconds. If this is longer than the length of the VO audio, the end callback is not called until after this duration has elapsed. If no end callback is set this has no effect. This is useful during development before recorded VO is ready for simulating the advice being played for a certain duration - with no audio, the advice would complete immediately, or not complete at all.
--- @p [opt=0] @number delay, Delay in seconds to wait after the advice has finished before calling the supplied end callback. If no end callback is supplied this has no effect.
function campaign_manager:show_advice(key, progress_button, highlight, callback, playtime, delay)
	if not self.advice_enabled then
		return;
	end;
	
	if not is_string(key) then
		script_error("ERROR: show_advice() called but supplied key [" .. tostring(key) .. "] is not a string");
		return false;
	end;

	if callback then
		if not is_function(callback) then
			script_error("ERROR: show_advice() called but supplied callback [" .. tostring(callback) .. "] is not a function or nil");
			return false;
		end;

		if playtime then
			if not (is_number(playtime) or playtime < 0) then
				script_error("ERROR: show_advice() called with a callback specified but supplied playtime [" .. tostring(playtime) .. "] is not a positive number or nil");
				return false;
			end;
		else
			playtime = 0;
		end;

		if delay then
			if (not is_number(delay) or delay < 0) then
				script_error("ERROR: show_advice() called with a callback specified but supplied delay [" .. tostring(delay) .. "] is not a positive number or nil");
				return false;
			end;
		else
			delay = 0;
		end;
	end;
	
	-- remove any pending progress_on_advice_finished processes
	self:cancel_progress_on_advice_finished("show_advice");
	self:remove_callback("show_advice_progress_on_advice_finished");

	-- remove any pending modify_advice process
	self:remove_callback(self.modify_advice_str);
	
	-- actually show the advice
	if self.next_advice_location then
		local x = self.next_advice_location.x;
		local y = self.next_advice_location.y;
		out("show_advice() called, key is " .. tostring(key) .. ", location is [" .. x .. ", " .. y .. "]");
		common.advance_scripted_advice_thread_located(key, 1, x, y);
		self.next_advice_location = nil;
	else
		out("show_advice() called, key is " .. tostring(key));
		common.advance_scripted_advice_thread(key, 1);
	end;

	get_infotext_manager():notify_of_advice(key);
	
	-- modify the state of the progress button to what has been specified
	self:modify_advice(progress_button, highlight);

	-- set up a progress_on_advice_finished callback if we should
	if callback then
		-- delay this by a second in case it returns back straight away
		self:callback(
			function() 
				if self.advice_debug then
					out("show_advice() for key [" .. key .. "] is starting progress_on_advice_finished() monitor as an on-finished callback was specified");
				end;
					
				self:progress_on_advice_finished("show_advice", callback, delay, playtime, true) 
			end, 
			1, 
			"show_advice_progress_on_advice_finished"
		);
	end;
end;


--- @function set_next_advice_location
--- @desc Sets an x/y display location for the next triggered advice. Once that advice has triggered this position will be cleared, meaning further advice will trigger without a location unless this function is called again.
--- @p @number x position, X display position.
--- @p @number y position, Y display position.
function campaign_manager:set_next_advice_location(x, y)
	if not is_number(x) or x <= 0 then
		script_error("ERROR: set_next_advice_location() called but supplied x position [" .. tostring(x) .. "] is not a positive number");
		return false;
	end;

	if not is_number(y) or y <= 0 then
		script_error("ERROR: set_next_advice_location() called but supplied y position [" .. tostring(y) .. "] is not a positive number");
		return false;
	end;

	self.next_advice_location = {x = x, y = y};
end;


--- @function set_advice_debug
--- @desc Enables or disables verbose debug output for the advice system. This can be useful as the advice system is difficult to debug using traditional means.
--- @p [opt=true] @boolean enable debug output
function campaign_manager:set_advice_debug(value)
	if value == false then
		self.advice_debug = false;
	else
		self.advice_debug = true;
	end;
end;


--- @function set_advice_enabled
--- @desc Enables or disables the advice system.
--- @p [opt=true] @boolean enable advice
function campaign_manager:set_advice_enabled(value)
	if value == false then
		--
		-- delaying this call as a workaround for a floating-point error that seems to occur when it's made in the same tick as the LoadingScreenDismissed event
		self:callback(function() self.game_interface:override_ui("disable_advisor_button", true) end, 0.2);
		-- self.game_interface:override_ui("disable_advisor_button", true);
		
		set_component_active(false, "menu_bar", "button_show_advice");
		self.advice_enabled = false;
	else
		self.game_interface:override_ui("disable_advisor_button", false);
		set_component_active(true, "menu_bar", "button_show_advice");
		self.advice_enabled = true;
	end;
end;


--- @function is_advice_enabled
--- @desc Returns <code>true</code> if the advice system is enabled, or <code>false</code> if it's been disabled with @campaign_manager:set_advice_enabled.
--- @r @boolean advice is enabled
function campaign_manager:is_advice_enabled()
	return self.advice_enabled;
end;


--- @function modify_advice
--- @desc Immediately enables or disables the close button that appears on the advisor panel, or causes it to be highlighted.
--- @p [opt=false] @boolean show progress button
--- @p [opt=false] @boolean highlight progress button
function campaign_manager:modify_advice(progress_button, highlight)
	-- if the component doesn't exist yet, wait a little bit as it's probably in the process of being created
	if not find_uicomponent(core:get_ui_root(), "advice_interface") then
		self:callback(function() self:modify_advice(progress_button, highlight) end, 0.2, self.modify_advice_str);
		return;
	end;

	self:remove_callback(self.modify_advice_str);

	if progress_button then
		show_advisor_progress_button();	
		
		core:remove_listener("dismiss_advice_listener");
		core:add_listener(
			"dismiss_advice_listener",
			"ComponentLClickUp", 
			function(context) return context.string == __advisor_progress_button_name end,
			function(context) self:dismiss_advice() end, 
			false
		);
	else
		show_advisor_progress_button(false);
	end;
	
	if highlight then
		highlight_advisor_progress_button(true);
	else
		highlight_advisor_progress_button(false);
	end;
end;


--- @function add_pre_dismiss_advice_callback
--- @desc Registers a callback to be called when/immediately before the advice gets dismissed.
--- @p @function callback
function campaign_manager:add_pre_dismiss_advice_callback(callback)
	if not is_function(callback) then
		script_error("ERROR: add_pre_dismiss_advice_callback() called but supplied callback [" .. tostring(callback) .."] is not a function");
		return false;
	end;
	
	table.insert(self.pre_dismiss_advice_callbacks, callback);
end;


--- @function dismiss_advice
--- @desc Dismisses the advice. Prior to performing the dismissal, this function calls any pre-dismiss callbacks registered with @campaign_manager:add_pre_dismiss_advice_callback. This function gets called internally when the player clicks the script-controlled advice progression button that appears on the advisor panel.
function campaign_manager:dismiss_advice()
	if not core:is_ui_created() then
		script_error("ERROR: dismiss_advice() called but ui not created");
		return false;
	end;
	
	-- call all pre_dismiss_advice_callbacks	
	for i = 1, #self.pre_dismiss_advice_callbacks do
		self.pre_dismiss_advice_callbacks[i]();
	end;
	
	self.pre_dismiss_advice_callbacks = {};
	
	-- perform the advice dismissal
	self.game_interface:dismiss_advice();
	self.infotext:clear_infotext();
	
	-- unhighlight advisor progress button	
	highlight_advisor_progress_button(false);
end;


--- @function progress_on_advice_dismissed
--- @desc Registers a function to be called when the advisor is dismissed. Only one such function can be registered at a time.
--- @p @string name, Process name, by which this progress listener may be later cancelled if necessary.
--- @p @function callback, Callback to call.
--- @p [opt=0] @number delay, Delay in seconds after the advisor is dismissed before calling the callback.
--- @p [opt=false] @boolean highlight on finish, Highlight on advice finish. If set to <code>true</code>, this also establishes a listener for the advice VO finishing. When it does finish, this function then highlights the advisor close button.
function campaign_manager:progress_on_advice_dismissed(name, callback, delay, highlight_on_finish)
	if not is_string(name) then
		script_error("ERROR: progress_on_advice_dismissed() called but supplied process name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_function(callback) then
		script_error("ERROR: progress_on_advice_dismissed() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	if not is_number(delay) or delay < 0 then
		delay = 0;
	end;

	local process_name = name .. "_advice_dismissed";
	
	-- a test to see if the advisor is visible on-screen at this moment
	local advisor_open_test = function()
		local uic_advisor = find_uicomponent(core:get_ui_root(), "advice_interface");
		return self.advice_enabled and uic_advisor and uic_advisor:Visible(true) and uic_advisor:CurrentAnimationId() == "";
	end;
	
	-- a function to set up listeners for the advisor closing
	local progress_func = function()
		local is_dismissed = false;
		local is_highlighted = false;
	
		core:add_listener(
			process_name,
			"AdviceDismissed",
			true,
			function()
				is_dismissed = true;
				
				if highlight_on_finish then
					self:cancel_progress_on_advice_finished(process_name);
				end;
			
				-- remove the highlight if it's applied
				if is_highlighted then
					self:modify_advice(true, false);
				end;
			
				if delay > 0 then
					self:callback(callback, delay);
				else
					callback();
				end;
			end,
			false
		);
		
		-- if the highlight_on_finish flag is set, we highlight the advisor close button when the 
		if highlight_on_finish then
			self:progress_on_advice_finished(
				process_name,
				function()
					if not is_dismissed then
						is_highlighted = true;
						self:modify_advice(true, true) 
					end;
				end
			);
		end;
	end;
	
	-- If the advisor open test passes then set up the progress listener, otherwise wait 0.5 seconds and try it again.
	-- If the advisor fails this test three times (i.e over the course of a second) then automatically progress
	if advisor_open_test() then
		progress_func();
	else
		self:callback(
			function()
				if advisor_open_test() then
					progress_func();
				else
					self:callback(
						function()
							if advisor_open_test() then
								progress_func();
							else
								if delay > 0 then
									self:callback(callback, delay, process_name);
								else
									callback();
								end;
							end;
						end,
						0.5,
						process_name
					);
				end;
			end,
			0.5,
			process_name
		);
	end;
end;


--- @function cancel_progress_on_advice_dismissed
--- @desc Cancels any running @campaign_manager:progress_on_advice_dismissed process.
--- @p @string name, Name of the progress on advice dismissed process to cancel.
function campaign_manager:cancel_progress_on_advice_dismissed(name)
	if not is_string(name) then
		script_error("ERROR: progress_on_advice_dismissed() called but supplied process name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	local process_name = name .. "_advice_dismissed";

	core:remove_listener(process_name);
	self:remove_callback(process_name);
	self:cancel_progress_on_advice_finished(process_name);
end;


--- @function progress_on_advice_finished
--- @desc Registers a function to be called when the advisor VO has finished playing and the <code>AdviceFinishedTrigger</code> event is sent from the game to script. If this event is not received after a duration (default 5 seconds) the function starts actively polling whether the advice audio is still playing, and calls the callback when it finds that it isn't.
--- @desc Only one process invoked by this function may be active at a time.
--- @p @string name, Name for this progress on advice finished process, by which it may be later cancelled if necessary.
--- @p @function callback, Callback to call.
--- @p [opt=0] @number delay, Delay in seconds after the advisor finishes to wait before calling the callback.
--- @p [opt=nil] @number playtime, Time in seconds to wait before actively polling whether the advice is still playing. The default value is 5 seconds unless overridden with this parameter. This is useful during development as if no audio has yet been recorded, or if no advice is playing for whatever reason, the function would otherwise continue to monitor until the next time advice is triggered, which is probably not desired.
--- @p [opt=false] @boolean use os clock, Use OS clock. Set this to true if the process is going to be running during the end-turn sequence, where the normal flow of model time completely breaks down.
function campaign_manager:progress_on_advice_finished(name, callback, delay, playtime, use_os_clock)
	if not is_string(name) then
		script_error("ERROR: progress_on_advice_finished() called but supplied process name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_function(callback) then
		script_error("ERROR: progress_on_advice_finished() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	if delay and not is_number(delay) then
		script_error("ERROR: progress_on_advice_finished() called but supplied delay [" .. tostring(delay) .. "] is not a number or nil");
		return false;
	end;

	if playtime and not is_number(playtime) then
		script_error("ERROR: progress_on_advice_finished() called but supplied playtime [" .. tostring(playtime) .. "] is not a number or nil");
		return false;
	end;

	local process_name = name .. "_advice_finished";
	
	local call_callback_with_delay = function()
		self:cancel_progress_on_advice_finished(process_name);
		
		-- do the given callback
		if is_number(delay) and delay > 0 then
			if use_os_clock then
				if self.advice_debug then
					out("progress_on_advice_finished() - advice audio has finished playing, calling callback after " .. tostring(delay) .. "s using os clock");
				end;
				self:callback(
					function() 
						callback() 
					end, 
					delay, 
					process_name
				);
			else
				if self.advice_debug then
					out("progress_on_advice_finished() - advice audio has finished playing, calling callback after " .. tostring(delay) .. "s");
				end;
				self:callback(
					function() 
						callback() 
					end, 
					delay, 
					process_name
				);
			end;
		else
			if self.advice_debug then
				out("progress_on_advice_finished() - advice audio has finished playing, calling callback without delay");
			end;
			callback();
		end;
	end;
	
	-- if advice is disabled then just finish
	if not self.advice_enabled then
		call_callback_with_delay();
		return;
	end;

	playtime = playtime or 5;
	
	if common.is_advice_audio_playing() then
		if self.advice_debug then
			out("progress_on_advice_finished() called - advice audio is playing, so establishing an AdviceFinishedTrigger event listener to listen for it finishing");
		end;

		-- advice is currently playing
		core:add_listener(
			process_name,
			"AdviceFinishedTrigger",
			true,
			function()
				call_callback_with_delay();
			end,
			false
		);
	else
		if self.advice_debug then
			out("progress_on_advice_finished() called - no advice audio is currently playing, so will begin to poll advice status after " .. playtime .. "s");
		end;
	end;	
	
	if use_os_clock then
		self:callback(
			function() 
				self:progress_on_advice_finished_poll(name, call_callback_with_delay, playtime, use_os_clock, 0) 
			end, 
			playtime, 
			process_name
		);
	else
		self:callback(
			function() 
				self:progress_on_advice_finished_poll(name, call_callback_with_delay, playtime, use_os_clock, 0) 
			end, 
			playtime, 
			process_name
		);
	end;
end;


-- used internally by progress_on_advice_finished
function campaign_manager:progress_on_advice_finished_poll(name, callback, playtime, use_os_clock, count)
	count = count or 0;
	
	if common.is_advice_audio_playing() then
		if self.advice_debug then
			out("progress_on_advice_finished() is polling advice - advice audio is currently playing");
		end;
	else

		self:cancel_progress_on_advice_finished(name);

		if self.advice_debug then
			out("progress_on_advice_finished() is progressing as no advice sound is playing after playtime of " .. playtime + (count * self.PROGRESS_ON_ADVICE_FINISHED_REPOLL_TIME) .. "s");
		end;
		
		-- do the given callback - this will be call_callback_with_delay that was set up in progress_on_advice_finished, so no need to wait
		callback();
		return;
	end;
	
	count = count + 1;
	
	-- sound is still playing, check again in a bit
	if use_os_clock then
		self:callback(
			function() 
				self:progress_on_advice_finished_poll(name, callback, playtime, use_os_clock, count) 
			end, 
			self.PROGRESS_ON_ADVICE_FINISHED_REPOLL_TIME,
			name .. "_advice_finished"
		);
	else
		self:callback(function() self:progress_on_advice_finished_poll(name, callback, playtime, use_os_clock, count) end, self.PROGRESS_ON_ADVICE_FINISHED_REPOLL_TIME, name .. "_advice_finished");
	end;
end;


--- @function cancel_progress_on_advice_finished
--- @desc Cancels any running @campaign_manager:progress_on_advice_finished process.
--- @p @string name, Name of the progress on advice finished process to cancel.
function campaign_manager:cancel_progress_on_advice_finished(name)
	if not is_string(name) then
		script_error("ERROR: cancel_progress_on_advice_finished() called but supplied process name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	local process_name = name .. "_advice_finished";

	core:remove_listener(process_name);
	self:remove_callback(process_name);
end;












-----------------------------------------------------------------------------
--- @section Progress on UI Event
-----------------------------------------------------------------------------


--- @function progress_on_panel_dismissed
--- @desc Calls a supplied callback when a panel with the supplied name is closed.
--- @p string unique name, Unique descriptive string name for this process. Multiple <code>progress_on_panel_dismissed</code> monitors may be active at any one time.
--- @p string panel name, Name of the panel.
--- @p function callback, Callback to call.
--- @p [opt=0] number callback delay, Time in seconds to wait after the panel dismissal before calling the supplied callback.
function campaign_manager:progress_on_panel_dismissed(name, panel_name, callback, delay)
	
	if not is_string(name) then
		script_error("ERROR: progress_on_panel_dismissed() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;
	
	if not is_string(panel_name) then
		script_error("ERROR: progress_on_panel_dismissed() called but supplied panel name [" .. tostring(panel_name) .. "] is not a string");
		return false;
	end;
	
	if not is_function(callback) then
		script_error("ERROR: progress_on_panel_dismissed() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;

	delay = delay or 0;
	
	if not is_number(delay) or delay < 0 then
		script_error("ERROR: progress_on_panel_dismissed() called but supplied delay [" .. tostring(delay) .. "] is not a positive number or nil");
		return false;
	end;
	
	local listener_name = name .. "_progress_on_panel_dismissed";
	
	if self:get_campaign_ui_manager():is_panel_open(panel_name) then
		core:add_listener(
			listener_name,
			"PanelClosedCampaign",
			function(context) return context.string == panel_name end,
			function()
				if delay == 0 then
					callback();
				else
					self:callback(callback, delay);
				end;
			end,
			false
		);
	else
		if delay == 0 then
			callback();
		else
			self:callback(callback, delay, listener_name);
		end;
	end;
end;


--- @function cancel_progress_on_panel_dismissed
--- @desc Cancels a monitor started with @campaign_manager:progress_on_panel_dismissed by name.
--- @p string unique name, Unique descriptive string name for this process.
function campaign_manager:cancel_progress_on_panel_dismissed(name)
	local listener_name = name .. "_progress_on_panel_dismissed";
	
	core:remove_listener(listener_name);
	self:remove_callback(listener_name);
end;


--- @function progress_on_events_dismissed
--- @desc Calls a supplied callback when all events panels are closed. Analagous to calling @campaign_manager:progress_on_panel_dismissed with the panel name "events".
--- @p string unique name, Unique descriptive string name for this process. Multiple <code>progress_on_panel_dismissed</code> monitors may be active at any one time.
--- @p function callback, Callback to call.
--- @p [opt=0] number callback delay, Time in seconds to wait after the panel dismissal before calling the supplied callback.
function campaign_manager:progress_on_events_dismissed(name, callback, delay)
	return self:progress_on_panel_dismissed(name, "events", callback, delay);
end;


--- @function cancel_progress_on_events_dismissed
--- @desc Cancels a monitor started with @campaign_manager:progress_on_events_dismissed (or @campaign_manager:progress_on_panel_dismissed) by name.
--- @p string unique name, Unique descriptive string name for this process.
function campaign_manager:cancel_progress_on_events_dismissed(name)
	return self:cancel_progress_on_panel_dismissed(name);
end;


--- @function progress_on_blocking_panel_dismissed
--- @desc Calls the supplied callback when all fullscreen campaign panels are dismissed. Only one such monitor may be active at once - starting a second will cancel the first.
--- @p function callback, Callback to call.
--- @p [opt=0] number callback delay, Time in seconds to wait after the panel dismissal before calling the supplied callback.
function campaign_manager:progress_on_blocking_panel_dismissed(callback, delay)
	delay = delay or 0;
	
	self:cancel_progress_on_blocking_panel_dismissed();
	
	local open_blocking_panel = self:get_campaign_ui_manager():get_open_blocking_or_event_panel();
		
	if open_blocking_panel then
		core:add_listener(
			"progress_on_blocking_panel_dismissed",
			"ScriptEventPanelClosedCampaign",
			function(context) 
				return context.string == open_blocking_panel 
			end,
			function() 
				self:progress_on_blocking_panel_dismissed(callback, delay) 
			end,
			false
		);
	else
		self:callback(callback, delay, "progress_on_blocking_panel_dismissed");
	end;
end;


--- @function cancel_progress_on_blocking_panel_dismissed
--- @desc Cancels any running monitor started with @campaign_manager:progress_on_blocking_panel_dismissed.
--- @p function callback, Callback to call.
--- @p [opt=0] number callback delay, Time in seconds to wait after the panel dismissal before calling the supplied callback.
function campaign_manager:cancel_progress_on_blocking_panel_dismissed()
	self:remove_callback("progress_on_blocking_panel_dismissed");
	core:remove_listener("progress_on_blocking_panel_dismissed");
end;


--- @function start_intro_cutscene_on_loading_screen_dismissed
--- @desc This function provides an easy one-shot method of starting an intro flyby cutscene from a loading screen with a fade effect. Call this function on the first tick (or before), and pass to it a function which starts an intro cutscene.
--- @p function callback, Callback to call.
--- @p string faction_key, which faction to start the intro cutscene for. This is to make sure we're not turning on cinematic borders for all players in mp
--- @p [opt=0] number fade in time, Time in seconds over which to fade in the camera from black.
function campaign_manager:start_intro_cutscene_on_loading_screen_dismissed(callback, faction_key, fade_in_duration)
	if not is_function(callback) then
		script_error("ERROR: start_intro_cutscene_on_loading_screen_dismissed() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	fade_in_duration = fade_in_duration or 1;
	
	if not is_number(fade_in_duration) or fade_in_duration < 0 then
		script_error("ERROR: start_intro_cutscene_on_loading_screen_dismissed() called but supplied fade in duration [" .. tostring(fade_in_duration) .. "] is not a positive number or nil");
		return false;
	end;
	
	if cm:get_local_faction_name(true) == faction_key then
		CampaignUI.ToggleCinematicBorders(true);
	end;
	
	self:fade_scene(0, 0);

	core:progress_on_loading_screen_dismissed(
		function()
			self:fade_scene(1, fade_in_duration);
			callback();
		end
	);
end;


-- progress on mission accepted
-- Old-style mission progression listener, with ui locking. Ideally use progress_on_events_dismissed instead.
function campaign_manager:progress_on_mission_accepted(callback, delay, should_lock)
	if not is_function(callback) then
		script_error("ERROR: progress_on_mission_accepted() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	local uim = self:get_campaign_ui_manager();
	
	should_lock = not not should_lock;	
	self.ui_locked_for_mission = should_lock;
	
	-- we should lock out elements of the ui so that the player is compelled to accept the mission
	if should_lock then
		uim:lock_ui();
	end;
	
	local callback_func = function()
		if should_lock then
			uim:unlock_ui();
		end;
		callback();
	end;

	core:add_listener(
		"progress_on_mission_accepted",
		"ScriptEventPanelClosedCampaign", 
		function(context) return context.string == "events" or context.string == "quest_details" end,
		function()
			core:remove_listener("progress_on_mission_accepted");
			
			self.ui_locked_for_mission = false;
			
			if is_number(delay) and delay > 0 then
				self:callback(callback_func, delay);
			else
				callback_func();
			end;
		end,
		false
	);
end;


function campaign_manager:cancel_progress_on_mission_accepted()
	if self.ui_locked_for_mission then
		self:get_campaign_ui_manager():unlock_ui();
	end;
	
	core:remove_listener("progress_on_mission_accepted");
end;


--- @function progress_on_battle_completed
--- @desc Calls the supplied callback when a battle sequence is fully completed. A battle sequence is completed once the pre or post-battle panel has been dismissed and any subsequent camera animations have finished. This mechanism should now work in multiplayer.
--- @p @string name, Unique name for this monitor. Multiple such monitors may be active at once.
--- @p @function callback, Callback to call.
--- @p [opt=0] @number delay, Delay in ms after the battle sequence is completed before calling the callback.
function campaign_manager:progress_on_battle_completed(name, callback, delay)
	delay = delay or 0;
	
	if not is_string(name) then
		script_error("ERROR: progress_on_battle_completed() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if not is_function(callback) then
		script_error("ERROR: progress_on_battle_completed() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	if self:is_processing_battle() then
		core:add_listener(
			"progress_on_battle_completed_" .. name,
			"ScriptEventPlayerBattleSequenceCompleted",
			true,
			function(context)
				self:callback(function() callback() end, delay, "progress_on_battle_completed_" .. name);
			end,
			false		
		);
	else
		if delay > 0 then
			self:callback(function() callback() end, delay, "progress_on_battle_completed_" .. name);
		else
			callback();
		end;			
	end;
end;


--- @function cancel_progress_on_battle_completed
--- @desc Cancels a running monitor started with @campaign_manager:progress_on_battle_completed by name.
--- @p string name, Name of monitor to cancel.
function campaign_manager:cancel_progress_on_battle_completed(name)
	if not is_string(name) then
		script_error("ERROR: cancel_progress_on_battle_completed() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	core:remove_listener("progress_on_battle_completed_" .. name);
	self:remove_callback("progress_on_battle_completed_" .. name);
end;


--- @function progress_on_camera_movement_finished
--- @desc Calls the supplied callback when the campaign camera is seen to have finished moving. The function has to poll the camera position repeatedly, so the supplied callback will not be called the moment the camera comes to rest due to the model tick resolution.
--- @desc Only one such monitor may be active at once.
--- @p function callback, Callback to call.
--- @p [opt=0] number delay, Delay in ms after the camera finishes moving before calling the callback.
function campaign_manager:progress_on_camera_movement_finished(callback, delay)
	delay = delay or 0;

	if not is_function(callback) then
		script_error("ERROR: progress_on_camera_movement_finished() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	out("progress_on_camera_movement_finished() called");
	
	local x, y, b, d, h = self:get_camera_position();
		
	self:repeat_callback(
		function()
			local new_x, new_y, new_b, new_d, new_h = self:get_camera_position();
			
			-- out("\tcurrent camera pos is [" .. new_x .. ", " .. new_y .. ", " .. new_b .. ", " .. new_d .. ", " .. new_h .. "], cached is [" .. x .. ", " .. y .. ", " .. b .. ", " .. d .. ", " .. h .."]");
			
			if math.abs(x - new_x) < 0.1 and
						math.abs(y - new_y) < 0.1 and
						math.abs(b - new_b) < 0.1 and
						math.abs(d - new_d) < 0.1 and
						math.abs(h - new_h) < 0.1  then
				
				-- camera pos matches, the camera movement is finished
				if delay then
					self:remove_callback("progress_on_camera_movement_finished");
					self:callback(function() callback() end, delay, "progress_on_camera_movement_finished");
				else
					self:remove_callback("progress_on_camera_movement_finished");
					callback();
				end;
			else
				-- camera pos doesn't match
				x = new_x;
				y = new_y;
				b = new_b;
				d = new_d;
				h = new_h;
			end
		end,
		0.2,
		"progress_on_camera_movement_finished"
	);
end;


--- @function cancel_progress_on_camera_movement_finished
--- @desc Cancels a running monitor started with @campaign_manager:progress_on_camera_movement_finished.
function campaign_manager:cancel_progress_on_camera_movement_finished()
	self:remove_callback("progress_on_camera_movement_finished");
end;


--- @function progress_on_post_battle_panel_visible
--- @desc Calls the supplied callback when the post-battle panel has finished animating on-screen. The function has to poll the panel state repeatedly, so the supplied callback will not be called the exact moment the panel comes to rest. Don't call this unless you know that the panel is about to animate on, otherwise it will be repeatedly polling in the background!
--- @desc Only one such monitor may be active at once.
--- @p function callback, Callback to call.
--- @p [opt=0] number delay, Delay in ms after the panel finishes moving before calling the callback.
function campaign_manager:progress_on_post_battle_panel_visible(callback, delay)

	local uic_panel = find_uicomponent(core:get_ui_root(), "popup_battle_results", "mid");

	if uic_panel and uic_panel:Visible(true) and is_fully_onscreen(uic_panel) and uic_panel:CurrentAnimationId() == "" then		
		
		if delay and is_number(delay) and delay > 0 then
			self:callback(callback, delay, "progress_on_post_battle_panel_visible");
		else
			callback();
		end;
	else
		self:callback(
			function()
				self:progress_on_post_battle_panel_visible(callback, delay)
			end,
			0.2, 
			"progress_on_post_battle_panel_visible"
		);
	end;
end;


--- @function cancel_progress_on_post_battle_panel_visible
--- @desc Cancels a running monitor started with @campaign_manager:progress_on_post_battle_panel_visible.
function campaign_manager:cancel_progress_on_post_battle_panel_visible()
	self:remove_callback("progress_on_post_battle_panel_visible");
end;














--- @section Progress on UI Trigger


-- Start the listening process associated with progress_on_all_clients_ui_triggered. We start this from script start so that each machine picks up UITrigger events even before progress_on_all_clients_ui_triggered() is called.
function campaign_manager:start_progress_on_all_clients_ui_triggered_monitor()

	local progress_on_all_clients_ui_triggers = self.progress_on_all_clients_ui_triggers;
	local prefix_str = "progress_on_all_clients_";
	local prefix_str_length = string.len(prefix_str);

	core:add_listener(
		"progress_on_all_clients_ui_trigger",
		"UITrigger",
		function(context)
			return string.find(context:trigger(), prefix_str);
		end,
		function(context)
			-- Clip the prefix from the start of the trigger name
			local trigger_name = string.sub(context:trigger(), prefix_str_length + 1);

			-- If we have no record of this trigger then create one - this will happen if the UITrigger on a remote machine happens before the listener is established on the local machine
			if not progress_on_all_clients_ui_triggers[trigger_name] then
				progress_on_all_clients_ui_triggers[trigger_name] = {};
			end;

			-- Lookup the faction that triggered the event
			local faction = cm:model():faction_for_command_queue_index(context:faction_cqi());
			if not faction:is_null_interface() then
				local faction_name = faction:name();

				local trigger_record = progress_on_all_clients_ui_triggers[trigger_name];

				if not trigger_record[faction_name] then
					-- Record this faction as having sent its event
					trigger_record[faction_name] = true;
				
					-- Increase the count
					local count = trigger_record.count or 0;
					count = count + 1;
					trigger_record.count = count;

					local active_human_factions = cm:get_active_human_factions();
										
					local total = #active_human_factions;
					if count >= total then
						-- Take a local copy of the callback, clear this UITrigger record, produce some output and call the callback
						local callback = trigger_record.callback;
						
						if not callback then
							script_error("ERROR: progress_on_all_clients_ui_triggered() has received ui trigger [" .. count .. "/" .. total .. "] for trigger [" .. trigger_name .. "] from faction [" .. faction_name .. "] but no progression callback is set up - how can this be? Expect a desync");
							return;
						end;

						self.progress_on_all_clients_ui_triggers[trigger_name] = nil;
						out("# progress_on_all_clients_ui_triggered() has received ui trigger [" .. count .. "/" .. total .. "] for trigger [" .. trigger_name .. "] from faction [" .. faction_name .. "], calling progression callback");
						callback();
					else
						out("# progress_on_all_clients_ui_triggered() has received ui trigger [" .. count .. "/" .. total .. "] for trigger [" .. trigger_name .. "] from faction [" .. faction_name .. "]");
					end;
				end;
			end;
		end,
		true
	);
end;


--- @function progress_on_all_clients_ui_triggered
--- @desc This function uses @campaignui:TriggerCampaignScriptEvent to trigger a UI event over the network which all clients receive. Once the event has been received from all clients then the progress callback is called. This can be used to progress the script in a synchronous manner in a multiplayer game only once an inherently-asynchronous event has been received. For example, a cutscene shown on multiple machines at once could be skipped on one machine and not another - progress_on_all_clients_ui_triggered can be used in this situation to only progress on all machines onces the cutscene has finished on all machines.
--- @desc The listening process associated with this function begins when the script is started, so it will pick up relevant events generated by <code>progress_on_all_clients_ui_triggered()</code> calls on remote machines even before <code>progress_on_all_clients_ui_triggered()</code> is called on this machine.
--- @p @string name, Name for this process by which it may optionally be cancelled.
--- @p @function callback, Progression callback.
--- @example -- play a cutscene in multiplayer and proceed when it's finished on all clients
--- @example 
--- @example local cutscene_name = "example_cutscene"
--- @example local c = campaign_cutscene:new_from_cindyscene(
--- @example 	cutscene_name,									-- name for cutscene
--- @example	"path/to/cindy_scene.CindySceneManager,			-- cindyscene
---	@example	function()										-- end callback
--- @example		cm:progress_on_ui_trigger(
--- @example			cutscene_name,
--- @example			function()
--- @example				out("Cutscene has finished on all clients, progressing...")
--- @example			end
--- @example		)
--- @example	end
--- @example )
function campaign_manager:progress_on_all_clients_ui_triggered(trigger_name, callback)

	if not validate.is_string(trigger_name) then
		return false;
	end;

	if not validate.is_function(callback) then
		return false;
	end;

	-- Immediately call the callback if this is a singleplayer game
	if not self:is_multiplayer() then
		callback();
		return;
	end;

	-- Get the local faction, grabbing the main parent faction if the local faction is auxiliary
	local local_faction = cm:get_local_faction(true);

	if not local_faction then
		script_error("WARNING: progress_on_all_clients_ui_triggered() called but no local faction found, is this an autorun? Immediately calling the callback");
		callback();
		return;
	end;

	-- Set up a record for this trigger name if one does not already exist
	if not self.progress_on_all_clients_ui_triggers[trigger_name] then
		self.progress_on_all_clients_ui_triggers[trigger_name] = {};
	end;

	-- Register a callback for this trigger name
	self.progress_on_all_clients_ui_triggers[trigger_name].callback = callback;

	local local_faction_cqi = local_faction:command_queue_index();

	out(""); 
	out("# progress_on_all_clients_ui_triggered() called with trigger name [" .. trigger_name .. "] on machine with local faction [" .. local_faction:name() .. "] (cqi: " .. local_faction_cqi .. ")");
	out("");

	-- Trigger a UITrigger event over the network, which the monitor in start_progress_on_all_clients_ui_triggered_monitor() will receive
	CampaignUI.TriggerCampaignScriptEvent(local_faction_cqi, "progress_on_all_clients_" .. trigger_name);
end;









-----------------------------------------------------------------------------
--- @section Multiplayer Queries
--- @desc The function @campaign_manager:progress_on_mp_query can be used to query information that is only available to the script on one machine, and have the result of that sent across the network to all machines.
-----------------------------------------------------------------------------


local valid_mp_query_cmds_indexed = {
	"all_advice_strings_seen",
	"any_advice_strings_seen",
}
local valid_mp_query_cmds_lookup = table.indexed_to_lookup(valid_mp_query_cmds_indexed);


function campaign_manager:start_mp_query_listener()

	core:add_listener(
		"mp_query_listener",
		"UITrigger",
		function(context)
			return string.sub(context:trigger(), 1, 4) == "mpq:";
		end,
		function(context)
			local query_str_with_result = context:trigger();

			local result_separator = string.find(query_str_with_result, "::");
			if not result_separator then
				script_error("WARNING: mp query event received but could not find result separator? Query string is " .. tostring(query_str_with_result));
				return false;
			end;

			local result = string.sub(query_str_with_result, result_separator + 2);
			local query_str = string.sub(query_str_with_result, 1, result_separator - 1);

			local callback = self.mp_queries[query_str];
			if not callback then
				script_error("WARNING: mp query event received but no record for it could be found. How can this be? Query string is " .. tostring(query_str_with_result));
				return false;
			end;

			self.mp_queries[query_str] = nil;

			if result == "true" then
				callback(true);
			elseif result == "false" then
				callback(false);
			else
				local result_as_number = tonumber(result);
				if result_as_number then
					callback(result_as_number);
				else
					callback(result);
				end;
			end;
		end,
		true
	)
end;


--- @function progress_on_mp_query
--- @desc Calls the supplied callback when the result of a multiplayer query is received from the network. Multiplayer queries allow the scripts on all machines in a multiplayer game to query information that normally on the script on one machine would have access to, such as advice history or the state of the UI.
--- @desc With each multiplayer query a faction key and some optional query data is specified. The query is run on the machine where the local player's faction matches the faction specified with the query. The results of the query are then broadcast with @campaignui:TriggerCampaignScriptEvent for all machines in the multiplayer game to receive.
--- @desc A number of multiplayer queries are supported:
--- @desc <table class="simple"><tr><th>Command</th><th>Description</th></tr>
--- @desc <table class="simple"><tr><td><code>all_advice_strings_seen</code></td><td>Returns true if all the specified advice strings have been seen on the machine where the local player's faction matches the faction specified with the query. The query data should be a table containing a list of advice strings. The result of the query will be a boolean value.</td></tr>
--- @desc <table class="simple"><tr><td><code>any_advice_strings_seen</code></td><td>Returns true if any of the specified advice strings have been seen on the machine where the local player's faction matches the faction specified with the query. The query data should be a table containing a list of advice strings. The result of the query will be a boolean value.</td></tr>
--- @desc <table class="simple"><tr><td><code>get_open_blocking_panel</code></td><td>Returns the result of calling @campaign_ui_manager:get_open_blocking_panel on the machine where the local player's faction matches the faction specified with the query. No query data is specified with this query. The result of the query will be a string panel name, or <code>false</code> if no panel is open.</td></tr></table>
--- @desc When the query is completed, the function will be called on all machines with the result of the query supplied as a single argument.
--- @p @string query command, Query command to run. See documentation above for a supported list of query commands.
--- @p @string faction key, Faction key, from the <code>factions</code> database table. The query is run on the machine where the local player's faction matches this key.
--- @p [opt=nil] @table query data, Data required to perform the query. This can be in different forms for different queries, but is often a @table.
--- @p @function callback, Callback that is called when the query is completed. The result of the query will be passed to the callback as a single argument.
function campaign_manager:progress_on_mp_query(query_cmd, faction_key, query_data, callback)

	if not validate.is_string(query_cmd) then
		return false;
	end;

	if not valid_mp_query_cmds_lookup[query_cmd] then
		script_error("ERROR: progress_on_mp_query() called but supplied query id [" .. tostring(query_cmd) .. "] is not recognised. Valid query ids are [" .. table.concat(valid_mp_query_cmds_indexed, ", ") .. "]");
		return false;
	end;

	if not validate.is_string(faction_key) then
		return false;
	end;

	local faction = self:get_faction(faction_key);
	if not faction then
		script_error("ERROR: progress_on_mp_query() called but no faction with supplied faction key [" .. faction_key .. "] could be found");
		return false;
	end;

	if not faction:is_human() then
		script_error("ERROR: progress_on_mp_query() called but faction with supplied faction key [" .. faction_key .. "] is not human-controlled");
		return false;
	end;

	local query_id = self.mp_query_count;
	self.mp_query_count = self.mp_query_count + 1;
	
	if query_cmd == "all_advice_strings_seen" then
		if query_data and not validate.is_table(query_data) then
			return false;
		end;

		local query_str = "mpq:" .. query_cmd .. ":" .. faction_key .. ":" .. query_id .. ":" .. table.concat(query_data, ",");
		self.mp_queries[query_str] = callback;

		if faction_key == cm:get_local_faction_name(true) then
			local result = true;
			for i = 1, #query_data do
				if not common.get_advice_history_string_seen(query_data[i]) then
					result = false;
					break;
				end;
			end;

			CampaignUI.TriggerCampaignScriptEvent(0, query_str .. "::" .. tostring(result));
		end;
	
	elseif query_cmd == "any_advice_strings_seen" then
		if query_data and not validate.is_table(query_data) then
			return false;
		end;

		local query_str = "mpq:" .. query_cmd .. ":" .. faction_key .. ":" .. query_id .. ":" .. table.concat(query_data, ",");
		self.mp_queries[query_str] = callback;

		if faction_key == cm:get_local_faction_name(true) then
			local result = false;
			for i = 1, #query_data do
				if common.get_advice_history_string_seen(query_data[i]) then
					result = true;
					break;
				end;
			end;

			CampaignUI.TriggerCampaignScriptEvent(0, query_str .. "::" .. tostring(result));
		end;

	elseif query_cmd == "get_open_blocking_panel" then
		local query_str = "mpq:" .. query_cmd .. ":" .. faction_key .. ":" .. query_id;
		self.mp_queries[query_str] = callback;

		if faction_key == cm:get_local_faction_name(true) then
			local result = cuim:get_open_blocking_panel();

			CampaignUI.TriggerCampaignScriptEvent(0, query_str .. "::" .. tostring(result));
		end;

	end;
end;











-----------------------------------------------------------------------------
--- @section Debug Drawing
-----------------------------------------------------------------------------


--- @function draw_text
--- @desc Draws debug text in the 3D space.
--- @p string text, Text to write.
--- @p number x, Display x co-ordinate.
--- @p number y, Display y co-ordinate.
--- @p number z, Display z co-ordinate (height).
--- @p number duration, Duration in seconds to display the text on screen for.
--- @p [opt=255] number r, Red value (0-255).
--- @p [opt=255] number g, Green value (0-255).
--- @p [opt=255] number b, Blue value (0-255).
--- @p [opt=255] number a, Alpha value (0-255).
function campaign_manager:draw_text(text, x_pos, y_pos, z_pos, duration, r, g, b, a)
	if not is_string(text) then
		script_error("ERROR: draw_text() called but supplied text [" .. tostring(text) .. "] is not a string");
		return;
	end;
	
	if not is_number(x_pos) or x_pos < 0 then
		script_error("ERROR: draw_text() called but supplied x co-ordinate [" .. tostring(x_pos) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(y_pos) or y_pos < 0 then
		script_error("ERROR: draw_text() called but supplied y co-ordinate [" .. tostring(y_pos) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(z_pos) or z_pos < 0 then
		script_error("ERROR: draw_text() called but supplied z co-ordinate [" .. tostring(z_pos) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(duration) or duration < 0 then
		script_error("ERROR: draw_text() called but supplied duration [" .. tostring(duration) .. "] is not a positive number");
		return;
	end;
	
	r = r or 255;
	g = g or 255;
	b = b or 255;
	a = a or 255;
	
	local debug_drawing = self:model():debug_drawing();
	
	if not debug_drawing:is_null_interface() then
		debug_drawing:set_begin(x_pos, z_pos, y_pos);
		debug_drawing:set_colour(r, g, b, a);
		debug_drawing:set_draw_duration(duration);
		debug_drawing:draw_text(text);
	end;
end;


--- @function draw_2d_text
--- @desc Draws debug text to the screen, in 2D.
--- @p string text, Text to write.
--- @p number x, x pixel position.
--- @p number y, y pixel position.
--- @p number duration, Duration in seconds to display the text on screen for.
--- @p [opt=255] number r, Red value (0-255).
--- @p [opt=255] number g, Green value (0-255).
--- @p [opt=255] number b, Blue value (0-255).
--- @p [opt=255] number a, Alpha value (0-255).
function campaign_manager:draw_2d_text(text, x_pos, y_pos, duration, r, g, b, a)
	if not is_string(text) then
		script_error("ERROR: draw_2d_text() called but supplied text [" .. tostring(text) .. "] is not a string");
		return;
	end;
	
	if not is_number(x_pos) or x_pos < 0 then
		script_error("ERROR: draw_2d_text() called but supplied x co-ordinate [" .. tostring(x_pos) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(y_pos) or y_pos < 0 then
		script_error("ERROR: draw_2d_text() called but supplied y co-ordinate [" .. tostring(y_pos) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(duration) or duration < 0 then
		script_error("ERROR: draw_2d_text() called but supplied duration [" .. tostring(duration) .. "] is not a positive number");
		return;
	end;
	
	r = r or 255;
	g = g or 255;
	b = b or 255;
	a = a or 255;
	
	local debug_drawing = self:model():debug_drawing();
	
	if not debug_drawing:is_null_interface() then
		debug_drawing:set_colour(r, g, b, a);
		debug_drawing:set_draw_duration(duration);
		debug_drawing:draw_text_screen_space(text, x_pos, y_pos);
	end;
end;


--- @function draw_line
--- @desc Draws a debug line in the 3D space.
--- @p number x_start_pos, Start point display x co-ordinate.
--- @p number y_start_pos, Start point display y co-ordinate.
--- @p number z_start_pos, Start point display z co-ordinate (height).
--- @p number x_end_pos, End point display x co-ordinate.
--- @p number y_end_pos, End point display y co-ordinate.
--- @p number z_end_pos, End point display z co-ordinate (height).
--- @p number duration, Duration in seconds to display the text on screen for.
--- @p [opt=255] number r, Red value (0-255).
--- @p [opt=255] number g, Green value (0-255).
--- @p [opt=255] number b, Blue value (0-255).
--- @p [opt=255] number a, Alpha value (0-255).
function campaign_manager:draw_line(x_start_pos, y_start_pos, z_start_pos, x_end_pos, y_end_pos, z_end_pos, duration, r, g, b, a)
	if not is_number(x_start_pos) or x_start_pos < 0 then
		script_error("ERROR: draw_line() called but supplied x co-ordinate [" .. tostring(x_start_pos) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(y_start_pos) or y_start_pos < 0 then
		script_error("ERROR: draw_line() called but supplied y co-ordinate [" .. tostring(y_start_pos) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(z_start_pos) or z_start_pos < 0 then
		script_error("ERROR: draw_line() called but supplied z co-ordinate [" .. tostring(z_start_pos) .. "] is not a positive number");
		return;
	end;
	if not is_number(x_end_pos) or x_end_pos < 0 then
		script_error("ERROR: draw_line() called but supplied x co-ordinate [" .. tostring(x_end_pos) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(y_end_pos) or y_end_pos < 0 then
		script_error("ERROR: draw_line() called but supplied y co-ordinate [" .. tostring(y_end_pos) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(z_end_pos) or z_end_pos < 0 then
		script_error("ERROR: draw_line() called but supplied z co-ordinate [" .. tostring(z_end_pos) .. "] is not a positive number");
		return;
	end;
	
	if not is_number(duration) or duration < 0 then
		script_error("ERROR: draw_line() called but supplied duration [" .. tostring(duration) .. "] is not a positive number");
		return;
	end;
	
	r = r or 255;
	g = g or 255;
	b = b or 255;
	a = a or 255;
	
	local debug_drawing = self:model():debug_drawing();
	
	if not debug_drawing:is_null_interface() then
		debug_drawing:set_begin(x_start_pos, z_start_pos, y_start_pos);
		debug_drawing:set_end(x_end_pos, z_end_pos, y_end_pos);
		debug_drawing:set_colour(r, g, b, a);
		debug_drawing:set_draw_duration(duration);
		debug_drawing:draw_line();
	end;
end;










-----------------------------------------------------------------------------
--- @section Restricting Units, Buildings, and Technologies
--- @desc The game allows the script to place or lift restrictions on factions recruiting certain units, constructing certain buildings and researching certain technologies. Note that lifting a restriction with one of the following commands does not grant the faction access to that unit/building/technology, as standard requirements will still apply (e.g. building requirements to recruit a unit).
-----------------------------------------------------------------------------


--- @function restrict_units_for_faction
--- @desc Applies a restriction to or removes a restriction from a faction recruiting one or more unit types.
--- @p string faction name, Faction name.
--- @p table unit list, Numerically-indexed table of string unit keys.
--- @p [opt=true] boolean should restrict, Set this to <code>true</code> to apply the restriction, <code>false</code> to remove it.
function campaign_manager:restrict_units_for_faction(faction_name, unit_list, value)
	if not is_string(faction_name) then
		script_error("ERROR: restrict_units_for_faction() called but supplied faction_name [" .. tostring(faction_name) .. "] is not a string");
		return;
	end;
	
	if not is_table(unit_list) then
		script_error("ERROR: restrict_units_for_faction() called but supplied unit_list [" .. tostring(unit_list) .. "] is not a table");
		return;
	end;
	
	local game_interface = self.game_interface;
	
	if value ~= false then
		value = true;
	end;
	
	if value then
		for i = 1, #unit_list do
			local current_rec = unit_list[i];
			game_interface:add_event_restricted_unit_record_for_faction(current_rec, faction_name);
		end;
		out("restricted " .. tostring(#unit_list) .. " unit records for faction " .. faction_name);
	else
		for i = 1, #unit_list do
			local current_rec = unit_list[i];
			game_interface:remove_event_restricted_unit_record_for_faction(current_rec, faction_name);
		end;
		out("unrestricted " .. tostring(#unit_list) .. " unit records for faction " .. faction_name);
	end;	
end;


--- @function restrict_buildings_for_faction
--- @desc Restricts or unrestricts a faction from constructing one or more building types. 
--- @p string faction name, Faction name.
--- @p table building list, Numerically-indexed table of string building keys.
--- @p [opt=true] boolean should restrict, Set this to <code>true</code> to apply the restriction, <code>false</code> to remove it.
function campaign_manager:restrict_buildings_for_faction(faction_name, building_list, value)
	if not is_string(faction_name) then
		script_error("ERROR: restrict_buildings_for_faction() called but supplied faction_name [" .. tostring(faction_name) .. "] is not a string");
		return;
	end;
	
	if not is_table(building_list) then
		script_error("ERROR: restrict_buildings_for_faction() called but supplied building_list [" .. tostring(building_list) .. "] is not a table");
		return;
	end;

	local game_interface = self.game_interface;
	
	if value ~= false then
		value = true;
	end;
	
	if value then
		for i = 1, #building_list do
			local current_rec = building_list[i];
		
			game_interface:add_event_restricted_building_record_for_faction(current_rec, faction_name);
		end;
		out("restricted " .. tostring(#building_list) .. " building records for faction " .. faction_name);
	else
		for i = 1, #building_list do
			local current_rec = building_list[i];
		
			game_interface:remove_event_restricted_building_record_for_faction(current_rec, faction_name);
		end;
		out("unrestricted " .. tostring(#building_list) .. " building records for faction " .. faction_name);
	end;
end;


--- @function restrict_technologies_for_faction
--- @desc Restricts or unrestricts a faction from researching one or more technologies. 
--- @p string faction name, Faction name.
--- @p table building list, Numerically-indexed table of string technology keys.
--- @p [opt=true] boolean should restrict, Set this to <code>true</code> to apply the restriction, <code>false</code> to remove it.
function campaign_manager:restrict_technologies_for_faction(faction_name, tech_list, value)
	if not is_string(faction_name) then
		script_error("ERROR: restrict_technologies_for_faction() called but supplied faction_name [" .. tostring(faction_name) .. "] is not a string");
		return;
	end;
	
	if not is_table(tech_list) then
		script_error("ERROR: restrict_technologies_for_faction() called but supplied tech_list [" .. tostring(tech_list) .. "] is not a table");
		return;
	end;
	
	local game_interface = self.game_interface;
	
	if value ~= false then
		value = true;
	end;
	
	if value then
		for i = 1, #tech_list do
			local current_rec = tech_list[i];
		
			game_interface:lock_technology(faction_name, current_rec);
		end;
		out("restricted " .. tostring(#tech_list) .. " tech records for faction " .. faction_name);
	else
		for i = 1, #tech_list do
			local current_rec = tech_list[i];
			
			game_interface:unlock_technology(faction_name, current_rec);
		end;
		out("unrestricted " .. tostring(#tech_list) .. " tech records for faction " .. faction_name);
	end;
end;











-----------------------------------------------------------------------------
--- @section Effect Bundles
--- @desc These this section contains functions that add and remove effect bundles from factions, military forces and regions. In each case they wrap a function of the same name on the underlying @episodic_scripting interface, providing input validation and debug output.
-----------------------------------------------------------------------------


--- @function apply_effect_bundle
--- @desc Applies an effect bundle to a faction for a number of turns (can be infinite).
--- @p string effect bundle key, Effect bundle key from the effect bundles table.
--- @p string faction key, Faction key of the faction to apply the effect to.
--- @p number turns, Number of turns to apply the effect bundle for. Supply 0 here to apply the effect bundle indefinitely (it can be removed later with @campaign_manager:remove_effect_bundle if required).
function campaign_manager:apply_effect_bundle(bundle_key, faction_name, turns)
	if not is_string(bundle_key) then
		script_error("ERROR: apply_effect_bundle() called but supplied bundle key [" .. tostring(bundle_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(faction_name) then
		script_error("ERROR: apply_effect_bundle() called but supplied faction key [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	if not is_number(turns) then
		script_error("ERROR: apply_effect_bundle() called but supplied turn count [" .. tostring(turns) .. "] is not a number");
		return false;
	end;
	
	-- Prevent underflow - We assume -1 being passed is intended to be infinite
	if turns < 0 then
		turns = 0;
	end
	
	out(" & Applying effect bundle [" .. bundle_key .. "] to faction [" .. faction_name .. "] for [" .. turns .. "] turns");
	
	return self.game_interface:apply_effect_bundle(bundle_key, faction_name, turns);
end;


--- @function remove_effect_bundle
--- @desc Removes an effect bundle from a faction.
--- @p string effect bundle key, Effect bundle key from the effect bundles table.
--- @p string faction key, Faction key of the faction to remove the effect from.
function campaign_manager:remove_effect_bundle(bundle_key, faction_name)
	if not is_string(bundle_key) then
		script_error("ERROR: remove_effect_bundle() called but supplied bundle key [" .. tostring(bundle_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(faction_name) then
		script_error("ERROR: remove_effect_bundle() called but supplied faction key [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	out(" & Removing effect bundle [" .. bundle_key .. "] from faction [" .. faction_name .. "]");
	
	return self.game_interface:remove_effect_bundle(bundle_key, faction_name);
end;


--- @function apply_effect_bundle_to_force
--- @desc Applies an effect bundle to a military force by cqi for a number of turns (can be infinite).
--- @p string effect bundle key, Effect bundle key from the effect bundles table.
--- @p string number cqi, Command queue index of the military force to apply the effect bundle to.
--- @p number turns, Number of turns to apply the effect bundle for. Supply 0 here to apply the effect bundle indefinitely (it can be removed later with @campaign_manager:remove_effect_bundle_from_force if required).
function campaign_manager:apply_effect_bundle_to_force(bundle_key, mf_cqi, turns)
	if not is_string(bundle_key) then
		script_error("ERROR: apply_effect_bundle_to_force() called but supplied bundle key [" .. tostring(bundle_key) .. "] is not a string");
		return false;
	end;
	
	if not is_number(mf_cqi) then
		script_error("ERROR: apply_effect_bundle_to_force() called but supplied mf cqi [" .. tostring(mf_cqi) .. "] is not a number");
		return false;
	end;
	
	if not is_number(turns) then
		script_error("ERROR: apply_effect_bundle_to_force() called but supplied turn count [" .. tostring(turns) .. "] is not a number");
		return false;
	end;
	
	-- Prevent underflow - We assume -1 being passed is intended to be infinite
	if turns < 0 then
		turns = 0;
	end
	
	out(" & Applying effect bundle [" .. bundle_key .. "] to military force with cqi [" .. mf_cqi .. "] for [" .. turns .. "] turns");
	
	return self.game_interface:apply_effect_bundle_to_force(bundle_key, mf_cqi, turns);
end;


--- @function remove_effect_bundle_from_force
--- @desc Removes an effect bundle from a military force by cqi.
--- @p string effect bundle key, Effect bundle key from the effect bundles table.
--- @p string number cqi, Command queue index of the military force to remove the effect from.
function campaign_manager:remove_effect_bundle_from_force(bundle_key, mf_cqi)
	if not is_string(bundle_key) then
		script_error("ERROR: remove_effect_bundle_from_force() called but supplied bundle key [" .. tostring(bundle_key) .. "] is not a string");
		return false;
	end;
	
	if not is_number(mf_cqi) then
		script_error("ERROR: remove_effect_bundle_from_force() called but supplied mf cqi [" .. tostring(mf_cqi) .. "] is not a number");
		return false;
	end;
	
	out(" & Removing effect bundle [" .. bundle_key .. "] from military force with cqi [" .. mf_cqi .. "]");
	
	return self.game_interface:remove_effect_bundle_from_force(bundle_key, mf_cqi);
end;


--- @function apply_effect_bundle_to_characters_force
--- @desc This function applies an effect bundle to a military force for a number of turns (can be infinite). It differs from @campaign_manager:apply_effect_bundle_to_force by referring to the force by its commanding character's cqi.
--- @p string effect bundle key, Effect bundle key from the effect bundles table.
--- @p string number cqi, Command queue index of the military force's commanding character to apply the effect bundle to.
--- @p number turns, Number of turns to apply the effect bundle for. Supply 0 here to apply the effect bundle indefinitely (it can be removed later with @campaign_manager:remove_effect_bundle_from_characters_force if required).
function campaign_manager:apply_effect_bundle_to_characters_force(bundle_key, char_cqi, turns)
	if not is_string(bundle_key) then
		script_error("ERROR: apply_effect_bundle_to_characters_force() called but supplied bundle key [" .. tostring(bundle_key) .. "] is not a string");
		return false;
	end;
	
	if not is_number(char_cqi) then
		script_error("ERROR: apply_effect_bundle_to_characters_force() called but supplied character cqi [" .. tostring(char_cqi) .. "] is not a number");
		return false;
	end;
	
	if not is_number(turns) then
		script_error("ERROR: apply_effect_bundle_to_characters_force() called but supplied turn count [" .. tostring(turns) .. "] is not a number");
		return false;
	end;
	
	-- Prevent underflow - We assume -1 being passed is intended to be infinite
	if turns < 0 then
		turns = 0;
	end
	
	out("& Applying effect bundle [" .. bundle_key .. "] to the force of character with cqi [" .. char_cqi .. "] for [" .. turns .. "] turns");
	
	return self.game_interface:apply_effect_bundle_to_characters_force(bundle_key, char_cqi, turns);
end;


--- @function remove_effect_bundle_from_characters_force
--- @desc Removes an effect bundle from a military force by its commanding character's cqi.
--- @p string effect bundle key, Effect bundle key from the effect bundles table.
--- @p string number cqi, Command queue index of the character commander of the military force to remove the effect from.
function campaign_manager:remove_effect_bundle_from_characters_force(bundle_key, char_cqi)
	if not is_string(bundle_key) then
		script_error("ERROR: remove_effect_bundle_from_characters_force() called but supplied bundle key [" .. tostring(bundle_key) .. "] is not a string");
		return false;
	end;
	
	if not is_number(char_cqi) then
		script_error("ERROR: remove_effect_bundle_from_characters_force() called but supplied character cqi [" .. tostring(char_cqi) .. "] is not a number");
		return false;
	end;
		
	out(" & Removing effect bundle [" .. bundle_key .. "] from the force of character with cqi [" .. char_cqi .. "]");
	
	return self.game_interface:remove_effect_bundle_from_characters_force(bundle_key, char_cqi);
end;


--- @function apply_effect_bundle_to_region
--- @desc Applies an effect bundle to a region for a number of turns (can be infinite).
--- @p string effect bundle key, Effect bundle key from the effect bundles table.
--- @p string region key, Key of the region to add the effect bundle to.
--- @p number turns, Number of turns to apply the effect bundle for. Supply 0 here to apply the effect bundle indefinitely (it can be removed later with @campaign_manager:remove_effect_bundle_from_region if required).
function campaign_manager:apply_effect_bundle_to_region(bundle_key, region_key, turns)
	if not is_string(bundle_key) then
		script_error("ERROR: apply_effect_bundle_to_region() called but supplied bundle key [" .. tostring(bundle_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(region_key) then
		script_error("ERROR: apply_effect_bundle_to_region() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return false;
	end;
	
	if not is_number(turns) then
		script_error("ERROR: apply_effect_bundle_to_region() called but supplied turn count [" .. tostring(turns) .. "] is not a number");
		return false;
	end;
	
	-- Prevent underflow - We assume -1 being passed is intended to be infinite
	if turns < 0 then
		turns = 0;
	end
	
	out(" & Applying effect bundle [" .. bundle_key .. "] to region with key [" .. region_key .. "] for [" .. turns .. "] turns");
	
	return self.game_interface:apply_effect_bundle_to_region(bundle_key, region_key, turns);
end;


--- @function remove_effect_bundle_from_region
--- @desc Removes an effect bundle from a region.
--- @p string effect bundle key, Effect bundle key from the effect bundles table.
--- @p string number cqi, Command queue index of the character commander of the military force to remove the effect from.
function campaign_manager:remove_effect_bundle_from_region(bundle_key, region_key)
	if not is_string(bundle_key) then
		script_error("ERROR: apply_effect_bundle_to_region() called but supplied bundle key [" .. tostring(bundle_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(region_key) then
		script_error("ERROR: apply_effect_bundle_to_region() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return false;
	end;
	
	out(" & Removing effect bundle [" .. bundle_key .. "] from region with key [" .. region_key .. "]");
	
	return self.game_interface:remove_effect_bundle_from_region(bundle_key, region_key);
end;









-----------------------------------------------------------------------------
--- @section Shroud Manipulation
-----------------------------------------------------------------------------


--- @function lift_all_shroud
--- @desc Lifts the shroud on all regions. This may be useful for cutscenes in general and benchmarks in-particular.
function campaign_manager:lift_all_shroud()
	local local_faction_name = self:get_local_faction_name();

	if local_faction_name then
		local region_list = self:model():world():region_manager():region_list();
		
		for i = 0, region_list:num_items() - 1 do
			local curr_region = region_list:item_at(i);	
			self.game_interface:make_region_visible_in_shroud(local_faction_name, curr_region:name());
		end;
	end;
end;










-----------------------------------------------------------------------------
--- @section Diplomacy
--- @desc The @campaign_manager:force_diplomacy function can be used to restrict or unrestrict diplomacy between factions. The following types of diplomacy are available to restrict - not all of them may be supported by each project:
-----------------------------------------------------------------------------


-- campaign diplomacy types
campaign_manager.diplomacy_types = {
	["trade agreement"] = 2^0,						--- @desc <ul><li>"trade agreement"</li>
	["hard military access"] = 2^1,					--- @desc <li>"hard military access"</li>
	["cancel hard military access"] = 2^2,			--- @desc <li>"cancel hard military access"</li>
	["military alliance"] = 2^3,					--- @desc <li>"military alliance"</li>
	["regions"] = 2^4,								--- @desc <li>"regions"</li>
	["technology"] = 2^5,							--- @desc <li>"technology"</li>
	["state gift"] = 2^6,							--- @desc <li>"state gift"</li>
	["payments"] = 2^7,								--- @desc <li>"payments"</li>
	["vassal"] = 2^8,								--- @desc <li>"vassal"</li>
	["peace"] = 2^9,								--- @desc <li>"peace"</li>
	["war"] = 2^10,									--- @desc <li>"war"</li>
	["join war"] = 2^11,							--- @desc <li>"join war"</li>
	["break trade"] = 2^12,							--- @desc <li>"break trade"</li>
	["break alliance"] = 2^13,						--- @desc <li>"break alliance"</li>
	["hostages"] = 2^14,							--- @desc <li>"hostages"</li>
	["non aggression pact"] = 2^15,					--- @desc <li>"non aggression pact"</li>
	["soft military access"] = 2^16,				--- @desc <li>"soft military access"</li>
	["cancel soft military access"] = 2^17,			--- @desc <li>"cancel soft military access"</li>
	["defensive alliance"] = 2^18,					--- @desc <li>"defensive alliance"</li>
	["client state"] = 2^19,						--- @desc <li>"client state"</li>
	["form confederation"] = 2^20,					--- @desc <li>"form confederation"</li>
	["break non aggression pact"] = 2^21,			--- @desc <li>"break non aggression pact"</li>
	["break soft military access"] = 2^22,			--- @desc <li>"break soft military access"</li>
	["break defensive alliance"] = 2^23,			--- @desc <li>"break defensive alliance"</li>
	["break vassal"] = 2^24,						--- @desc <li>"break vassal"</li>
	["break client state"] = 2^25,					--- @desc <li>"break client state"</li>
	["state gift unilateral"] = 2^26--[[,			--- @desc <li>"state gift unilateral"</li>
	["all"] = (2^27 - 1)							--- @desc <li>"all"</li></ul>
]]
};


--- @function force_diplomacy
--- @desc Restricts or unrestricts certain types of diplomacy between factions or groups of factions. Groups of factions may be specified with the strings <code>"all"</code>, <code>"faction:faction_key"</code>, <code>"subculture:subculture_key"</code> or <code>"culture:culture_key"</code>. A source and target faction/group of factions must be specified.
--- @desc Note that this wraps the function @episodic_scripting:force_diplomacy_new on the underlying episodic scripting interface.
--- @p string source, Source faction/factions identifier.
--- @p string target, Target faction/factions identifier.
--- @p string type, Type of diplomacy to restrict. See the documentation for the @campaign_manager:Diplomacy section for available diplomacy types.
--- @p boolean can offer, Can offer - set to <code>false</code> to prevent the source faction(s) from being able to offer this diplomacy type to the target faction(s).
--- @p boolean can accept, Can accept - set to <code>false</code> to prevent the target faction(s) from being able to accept this diplomacy type from the source faction(s).
--- @p [opt=false] both directions, Causes this function to apply the same restriction from target to source as from source to target.
--- @p [opt=false] do not enable payments, The AI code assumes that the "payments" diplomatic option is always available, and by default this function keeps payments available, even if told to restrict it. Set this flag to <code>true</code> to forceably restrict payments, but this may cause crashes.
function campaign_manager:force_diplomacy(source, target, diplomacy_types, offer, accept, add_both_directions, do_not_enable_payments)
	add_both_directions = not not add_both_directions;
	do_not_enable_payments = not not do_not_enable_payments;
	
	-- workaround - lua's default number type doesn't have the precision to support the bitmask required for "all"
	if diplomacy_types == "all" then
		out.design("force_diplomacy_new() called, source: " .. tostring(source) .. ", target: " .. tostring(target) .. ", diplomacy_types: " .. tostring(diplomacy_types) .. ", offer: " .. tostring(offer) .. ", accept: " .. tostring(accept) .. ", add both directions: " .. tostring(add_both_directions) .. ", do not enable payments: " .. tostring(do_not_enable_payments));
		for diplomacy_type, bitmask in pairs(campaign_manager.diplomacy_types) do
			self.game_interface:force_diplomacy_new(source, target, bitmask, offer, accept);
			if add_both_directions then
				self.game_interface:force_diplomacy_new(target, source, bitmask, offer, accept);
			end;
		end;
		return;
	end;
	
	local bitmask = self:generated_diplomacy_bitmask(diplomacy_types);
	
	out.design("force_diplomacy_new() called, source: " .. tostring(source) .. ", target: " .. tostring(target) .. ", diplomacy_types: " .. tostring(diplomacy_types) .. " (generating bitmask: " .. bitmask .. "), offer: " .. tostring(offer) .. ", accept: " .. tostring(accept) .. ", add both directions: " .. tostring(add_both_directions) .. ", do not enable payments: " .. tostring(do_not_enable_payments));

	self.game_interface:force_diplomacy_new(source, target, bitmask, offer, accept);
	
	if add_both_directions then
		self.game_interface:force_diplomacy_new(target, source, bitmask, offer, accept);
	end;
	
	-- the ai assumes that 'payments' will always be available, so if we are enabling a diplomatic relationship then always enable payments as well	
	if offer and not do_not_enable_payments then
		self.game_interface:force_diplomacy_new(source, target, self:generated_diplomacy_bitmask("payments"), true, false);
	end;
end;


function campaign_manager:generated_diplomacy_bitmask(str)
	if not is_string(str) then
		script_error("ERROR: generate_diplomacy_bitmask() called but supplied diplomacy string [" .. tostring(str) .. "] is not a string");
		return 0;
	end;
	
	if string.len(str) == 0 then
		return 0;
	end;
	
	-- specifically allow a token of "all"
	if str == "all" then
		return self.diplomacy_types["all"];
	end;
	
	local tokens = {};
	
	local pointer = 1;
	
	while true do
		local next_separator = string.find(str, ",", pointer);
		
		if not next_separator then
			-- this is the last token, so exit the loop after storing it
			table.insert(tokens, string.sub(str, pointer));
			break;
		end;
		
		table.insert(tokens, string.sub(str, pointer, next_separator - 1));
		
		pointer = next_separator + 1;
	end;
	
	local bitmask = 0;
	
	for i = 1, #tokens do
		local current_token = tokens[i];
		
		if current_token == "all" then
			-- combining "all" with other token types is not allowed
			script_error("WARNING: generate_diplomacy_bitmask() was given a string [" .. str .. "] containing token [" .. current_token .. "] with other tokens - this token can only be used on its own, ignoring");
		else		
			local current_token_value = self.diplomacy_types[current_token];		
			if not current_token_value then
				script_error("WARNING: generate_diplomacy_bitmask() was given a string [" .. str .. "] containing unrecognised token [" .. current_token .. "], ignoring");
			else
				bitmask = bitmask + current_token_value;
			end;
		end;
	end;
	
	return bitmask;
end;


--- @function enable_all_diplomacy
--- @desc Enables or disables all diplomatic options between all factions.
--- @p boolean enable diplomacy
function campaign_manager:enable_all_diplomacy(value)
	
	self:force_diplomacy("all", "all", "all", value, value);
	
	-- apply default diplomatic records afterwards if required
	if value then
		core:trigger_event("ScriptEventAllDiplomacyEnabled");
	end;
end;


--- @function force_declare_war
--- @desc Forces war between two factions. This wraps the @episodic_scripting:force_declare_war function of the same name on the underlying episodic scripting interface, but adds validation and output. This output will be shown in the <code>Lua - Design</code> console spool.
--- @p string faction key, Faction A key
--- @p string faction key, Faction B key
--- @p boolean invite faction a allies, Invite faction A's allies to the war
--- @p boolean invite faction b allies, Invite faction B's allies to the war
function campaign_manager:force_declare_war(faction_a_name, faction_b_name, invite_faction_a_allies, invite_faction_b_allies)
	if not is_string(faction_a_name) then
		script_error("ERROR: force_declare_war() called but supplied faction_a_name string [" .. tostring(faction_a_name) .. "] is not a string");
		return false;
	end;
	
	if not is_string(faction_b_name) then
		script_error("ERROR: force_declare_war() called but supplied faction_b_name string [" .. tostring(faction_b_name) .. "] is not a string");
		return false;
	end;
	
	if not is_boolean(invite_faction_a_allies) then
		script_error("ERROR: force_declare_war() called but supplied invite_faction_a_allies flag [" .. tostring(invite_faction_a_allies) .. "] is not a boolean value");
		return false;
	end;
	
	if not is_boolean(invite_faction_b_allies) then
		script_error("ERROR: force_declare_war() called but supplied invite_faction_b_allies flag [" .. tostring(invite_faction_b_allies) .. "] is not a boolean value");
		return false;
	end;
		
	local faction_a = cm:get_faction(faction_a_name);
	local faction_b = cm:get_faction(faction_b_name);
	
	if not faction_a then
		script_error("ERROR: force_declare_war() called but supplied faction_a_name string [" .. tostring(faction_a_name) .. "] could not be used to find a valid faction");
		return false;
	end;
	
	if not faction_b then
		script_error("ERROR: force_declare_war() called but supplied faction_b_name string [" .. tostring(faction_b_name) .. "] could not be used to find a valid faction");
		return false;
	end;
	
	out.design("* force_declare_war() called");
	out.design("\tforcing war between:");
	
	if faction_a:is_human() then
		out.design("\t\t[" .. tostring(faction_a_name) .. "] (human)");
	else
		out.design("\t\t[" .. tostring(faction_a_name) .. "] (ai)");
	end;
	
	if faction_b:is_human() then
		out.design("\t\t[" .. tostring(faction_b_name) .. "] (human)");
	else
		out.design("\t\t[" .. tostring(faction_b_name) .. "] (ai)");
	end;
	
	if invite_faction_a_allies then
		out.design("\tinviting [" .. tostring(faction_a_name) .. "] allies");
	end;
	
	if invite_faction_b_allies then
		out.design("\tinviting [" .. tostring(faction_b_name) .. "] allies");
	end;
	
	self.game_interface:force_declare_war(faction_a_name, faction_b_name, invite_faction_a_allies, invite_faction_b_allies);
end;



----------------------------------------------------------------------------
-- get diplomacy panel context
----------------------------------------------------------------------------

-- list of all diplomatic options, which the diplomacy panel displays
-- option is the name of the uicomponent
-- result is a string signifying its meaning to the interventions listening to it
-- priority is the priority of the meaning (so the context of a compound offer like an alliance with a payment is always of the more-significant component)
campaign_manager.diplomatic_options = {
	{["option"] = "diplomatic_option_trade_agreement", 				["result"] = "trade",						["priority"] = 2},
	{["option"] = "diplomatic_option_cancel_trade_agreement", 		["result"] = "noninteractive",				["priority"] = 1},
	{["option"] = "diplomatic_option_single_barter", 				["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_barter_agreement", 			["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_cancel_barter_agreement", 		["result"] = "noninteractive",				["priority"] = 1},
	{["option"] = "diplomatic_option_hard_access", 					["result"] = "noninteractive",				["priority"] = 1},
	{["option"] = "diplomatic_option_cancel_hard_access", 			["result"] = "noninteractive",				["priority"] = 1},
	{["option"] = "diplomatic_option_military_alliance", 			["result"] = "alliance",					["priority"] = 2},
	{["option"] = "diplomatic_option_cancel_military_alliance",		["result"] = "noninteractive",				["priority"] = 1},
	{["option"] = "diplomatic_option_trade_regions",				["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_trade_technology",				["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_state_gift",					["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_payment",						["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_vassal",						["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_cancel_vassal",				["result"] = "noninteractive",				["priority"] = 1},
	{["option"] = "diplomatic_option_peace",						["result"] = "interactive",					["priority"] = 1},
	{["option"] = "war_declared",									["result"] = "war",							["priority"] = 2},
	{["option"] = "diplomatic_option_join_war",						["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_break_trade_agreement",		["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_break_military_alliance",		["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_hostage",						["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_mariiage",						["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_nonaggression_pact",			["result"] = "nap",							["priority"] = 2},
	{["option"] = "diplomatic_option_cancel_nonaggression_pact",	["result"] = "noninteractive",				["priority"] = 1},
	{["option"] = "diplomatic_option_soft_access",					["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_cancel_soft_access",			["result"] = "noninteractive",				["priority"] = 1},	
	{["option"] = "diplomatic_option_defensive_alliance",			["result"] = "alliance",					["priority"] = 2},
	{["option"] = "diplomatic_option_cancel_defensive_alliance",	["result"] = "noninteractive",				["priority"] = 1},
	{["option"] = "diplomatic_option_client_state",					["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_cancel_client_state",			["result"] = "noninteractive",				["priority"] = 1},	
	{["option"] = "diplomatic_option_confederation",				["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_break_nonaggression_pact",		["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_break_soft_access",			["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_break_defensive_alliance",		["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_break_vassal",					["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_break_client_state",			["result"] = "interactive",					["priority"] = 1},
	{["option"] = "diplomatic_option_state_gift_unilateral",		["result"] = "interactive",					["priority"] = 1}
};



function campaign_manager:start_diplomacy_panel_context_listener()
	if self.diplomacy_panel_context_listener_started then
		return false;
	end;
	
	self.diplomacy_panel_context_listener_started = true;

	local poll_interval = 0.2;

	self:callback(function() self:poll_diplomacy_panel_context(1, poll_interval) end, poll_interval);
end;


function campaign_manager:poll_diplomacy_panel_context(count, poll_interval)
	local diplomacy_panel_context = self:get_diplomacy_panel_context(count, poll_interval);
	
	if diplomacy_panel_context then
		self.diplomacy_panel_context_listener_started = false;
		core:trigger_event("ScriptEventDiplomacyPanelContext", diplomacy_panel_context);
	else
		self:callback(function() self:poll_diplomacy_panel_context(count + 1, poll_interval) end, poll_interval);
	end;
end;


function campaign_manager:get_diplomacy_panel_context(count, poll_interval)

	-- failsafe, for in case we don't find anything
	if count >= 20 then
		script_error("WARNING: get_diplomacy_panel_context() couldn't find a diplomacy panel context despite looking " .. count .. " times over " .. count * poll_interval .. "s - this should be investigated")
		return "invalid";
	end;

	local uic_diplomacy = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown");
	
	local diplomatic_options = self.diplomatic_options;
	local result = false;
	local result_priority = 0;	
	
	-- If we couldn't find the panel or it doesn't seem to be open then return a state so that the polling completes.
	-- Not really sure how this happens but it does.
	if not uic_diplomacy or not self:get_campaign_ui_manager():is_panel_open("diplomacy_dropdown") then
		return "invalid";
	end;
	
	for i = 1, #diplomatic_options do
		local current_option = diplomatic_options[i].option;
		
		local uic_option = find_uicomponent(uic_diplomacy, current_option);
		
		if uic_option and uic_option:Visible() then
			if diplomatic_options[i].priority > result_priority then
				result_priority = diplomatic_options[i].priority;
				result = diplomatic_options[i].result;
				
				-- return immediately if the result is important enough
				if result_priority == 2 then
					break;
				end;
			end;
		end;
	end;
		
	return result;
end;


































-----------------------------------------------------------------------------
--- @section Objectives and Infotext
--- @desc Upon creation, the campaign manager automatically creates objectives manager and infotext manager objects which it stores internally. These functions provide a passthrough interface to the most commonly-used functions on these objects. See the documentation on the @objectives_manager and @infotext_manager pages for more details.
-----------------------------------------------------------------------------


--- @function set_objective
--- @desc Sets up a scripted objective for the player, which appears in the scripted objectives panel. This objective can then be updated, removed, or marked as completed or failed by the script at a later time.
--- @desc A key to the scripted_objectives table must be supplied with set_objective, and optionally one or two numeric parameters to show some running count related to the objective. To update these parameter values later, <code>set_objective</code> may be re-called with the same objective key and updated values.
--- @desc This function passes its arguments through @objectives_manager:set_objective on the objectives manager - see the documentation on that function for more information.
--- @p @string objective key, Objective key, from the scripted_objectives table.
--- @p [opt=nil] @number param a, First numeric objective parameter. If set, the objective will be presented to the player in the form [objective text]: [param a]. Useful for showing a running count of something related to the objective.
--- @p [opt=nil] @number param b, Second numeric objective parameter. A value for the first must be set if this is used. If set, the objective will be presented to the player in the form [objective text]: [param a] / [param b]. Useful for showing a running count of something related to the objective.
function campaign_manager:set_objective(...)
	return self.objectives:set_objective(...);
end;


--- @function set_objective_with_leader
--- @desc Sets up a scripted objective for the player which appears in the scripted objectives panel, with a @topic_leader. This objective can then be updated, removed, or marked as completed or failed by the script at a later time.
--- @desc A key to the scripted_objectives table must be supplied with set_objective, and optionally one or two numeric parameters to show some running count related to the objective. To update these parameter values later, <code>set_objective</code> may be re-called with the same objective key and updated values.
--- @desc This function passes its arguments through @objectives_manager:set_objective_with_leader on the objectives manager - see the documentation on that function for more information.
--- @p @string objective key, Objective key, from the scripted_objectives table.
--- @p [opt=nil] @number param a, First numeric objective parameter. If set, the objective will be presented to the player in the form [objective text]: [param a]. Useful for showing a running count of something related to the objective.
--- @p [opt=nil] @number param b, Second numeric objective parameter. A value for the first must be set if this is used. If set, the objective will be presented to the player in the form [objective text]: [param a] / [param b]. Useful for showing a running count of something related to the objective.
--- @p [opt=nil] @function callback, Optional callback to call when the objective is shown.
function campaign_manager:set_objective_with_leader(...)
	return self.objectives:set_objective_with_leader(...);
end;


--- @function complete_objective
--- @desc Marks a scripted objective as completed for the player to see. Note that it will remain on the scripted objectives panel until removed with @campaign_manager:remove_objective. This function passes its arguments through @objectives_manager:complete_objective on the objectives manager - see the documentation on that function for more information.
--- @desc Note also that is possible to mark an objective as complete before it has been registered with @campaign_manager:set_objective - in this case, it is marked as complete as soon as @campaign_manager:set_objective is called.
--- @p @string objective key, Objective key, from the scripted_objectives table.
function campaign_manager:complete_objective(...)
	return self.objectives:complete_objective(...);
end;


--- @function fail_objective
--- @desc Marks a scripted objective as failed for the player to see. Note that it will remain on the scripted objectives panel until removed with @campaign_manager:remove_objective. This function passes its arguments through @objectives_manager:fail_objective on the objectives manager - see the documentation on that function for more information.
--- @p @string objective key, Objective key, from the scripted_objectives table.
function campaign_manager:fail_objective(...)
	return self.objectives:fail_objective(...);
end;


--- @function remove_objective
--- @desc Removes a scripted objective from the scripted objectives panel. This function passes its arguments through @objectives_manager:remove_objective on the objectives manager - see the documentation on that function for more information.
--- @p @string objective key, Objective key, from the scripted_objectives table.
function campaign_manager:remove_objective(...)
	return self.objectives:remove_objective(...);
end;


--- @function activate_objective_chain
--- @desc Pass-through function for @objectives_manager:activate_objective_chain. Starts a new objective chain - see the documentation on the @objectives_manager page for more details.
--- @p string chain name, Objective chain name.
--- @p string objective key, Key of initial objective, from the scripted_objectives table.
--- @p [opt=nil] number number param a, First numeric parameter - see the documentation for @campaign_manager:set_objective for more details
--- @p [opt=nil] number number param b, Second numeric parameter - see the documentation for @campaign_manager:set_objective for more details
function campaign_manager:activate_objective_chain(...)
	return self.objectives:activate_objective_chain(...);
end;


--- @function activate_objective_chain_with_leader
--- @desc Starts a new objective chain, with a @topic_leader. This function passes its arguments through @objectives_manager:activate_objective_chain_with_leader on the objectives manager - see the documentation on that function for more information.
--- @p @string chain name, Objective chain name.
--- @p @string objective key, Key of initial objective, from the scripted_objectives table.
--- @p [opt=nil] @number number param a, First numeric parameter - see the documentation for @campaign_manager:set_objective for more details.
--- @p [opt=nil] @number number param b, Second numeric parameter - see the documentation for @campaign_manager:set_objective for more details.
function campaign_manager:activate_objective_chain_with_leader(...)
	return self.objectives:activate_objective_chain_with_leader(...);
end;


--- @function update_objective_chain
--- @desc Updates an existing objective chain. This function passes its arguments through @objectives_manager:update_objective_chain on the objectives manager - see the documentation on that function for more information.
--- @p @string chain name, Objective chain name.
--- @p @string objective key, Key of initial objective, from the scripted_objectives table.
--- @p [opt=nil] @number number param a, First numeric parameter - see the documentation for @battle_manager:set_objective for more details
--- @p [opt=nil] @number number param b, Second numeric parameter - see the documentation for @battle_manager:set_objective for more details
function campaign_manager:update_objective_chain(...)
	return self.objectives:update_objective_chain(...);
end;


--- @function end_objective_chain
--- @desc Ends an existing objective chain. This function passes its arguments through @objectives_manager:end_objective_chain on the objectives manager - see the documentation on that function for more information.
--- @p @string chain name, Objective chain name.
function campaign_manager:end_objective_chain(...)
	return self.objectives:end_objective_chain(...);
end;


--- @function reset_objective_chain
--- @desc Resets an objective chain so that it may be called again. This function passes its arguments through @objectives_manager:reset_objective_chain on the objectives manager - see the documentation on that function for more information.
--- @p @string chain name, Objective chain name.
function campaign_manager:reset_objective_chain(...)
	return self.objectives:reset_objective_chain(...);
end;


--- @function add_infotext
--- @desc Adds one or more lines of infotext to the infotext panel. This function passes through to @infotext_manager:add_infotext - see the documentation on the @infotext_manager page for more details.
--- @p object first param, Can be a string key from the advice_info_texts table, or a number specifying an initial delay in ms after the panel animates onscreen and the first infotext item is shown.
--- @p ... additional infotext strings, Additional infotext strings to be shown. <code>add_infotext</code> fades each of them on to the infotext panel in a visually-pleasing sequence.
function campaign_manager:add_infotext(...)
	return self.infotext:add_infotext(...);
end;


--- @function add_infotext_with_leader
--- @desc Adds one or more lines of infotext to the infotext panel, with a @topic_leader. This function passes through to @infotext_manager:add_infotext_with_leader - see the documentation on the @infotext_manager page for more details.
--- @p object first param, Can be a string key from the advice_info_texts table, or a number specifying an initial delay in ms after the panel animates onscreen and the first infotext item is shown.
--- @p ... additional infotext strings, Additional infotext strings to be shown. <code>add_infotext</code> fades each of them on to the infotext panel in a visually-pleasing sequence.
function campaign_manager:add_infotext_with_leader(...)
	return self.infotext:add_infotext_with_leader(...);
end;


--- @function add_infotext_simultaneously
--- @desc Adds one or more lines of infotext simultaneously to the infotext panel. This function passes through to @infotext_manager:add_infotext_simultaneously - see the documentation on the @infotext_manager page for more details.
--- @p object first param, Can be a string key from the advice_info_texts table, or a number specifying an initial delay in ms after the panel animates onscreen and the first infotext item is shown.
--- @p ... additional infotext strings, Additional infotext strings to be shown. <code>add_infotext_simultaneously</code> fades each of them on to the infotext panel in a visually-pleasing sequence.
function campaign_manager:add_infotext_simultaneously(...)
	return self.infotext:add_infotext_simultaneously(...);
end;


--- @function add_infotext_simultaneously_with_leader
--- @desc Adds one or more lines of infotext simultaneously to the infotext panel, with a @topic_leader. This function passes through to @infotext_manager:add_infotext_simultaneously_with_leader - see the documentation on the @infotext_manager page for more details.
--- @p object first param, Can be a string key from the advice_info_texts table, or a number specifying an initial delay in ms after the panel animates onscreen and the first infotext item is shown.
--- @p ... additional infotext strings, Additional infotext strings to be shown. <code>add_infotext_simultaneously</code> fades each of them on to the infotext panel in a visually-pleasing sequence.
function campaign_manager:add_infotext_simultaneously_with_leader(...)
	return self.infotext:add_infotext_simultaneously_with_leader(...);
end;


--- @function remove_infotext
--- @desc Pass-through function for @infotext_manager:remove_infotext. Removes a line of infotext from the infotext panel.
--- @p @string infotext key
function campaign_manager:remove_infotext(...)
	return self.infotext:remove_infotext(...);
end;


--- @function clear_infotext
--- @desc Pass-through function for @infotext_manager:clear_infotext. Clears the infotext panel.
function campaign_manager:clear_infotext(...)
	return self.infotext:clear_infotext(...);
end;











-----------------------------------------------------------------------------
--- @section Missions and Events
-----------------------------------------------------------------------------


--- @function trigger_custom_mission
--- @desc Triggers a specific custom mission from its database record key. This mission must be defined in the missions.txt file that accompanies each campaign. This function wraps the @episodic_scripting:trigger_custom_mission function on the game interface, adding debug output and event type whitelisting.
--- @p @string faction key, Faction key.
--- @p @string mission key, Mission key, from missions.txt file.
--- @p [opt=false] @boolean do not cancel, By default this function cancels this custom mission before issuing it, to avoid multiple copies of the mission existing at once. Supply <code>true</code> here to prevent this behaviour.
--- @p [opt=true] @boolean whitelist, Supply <code>false</code> here to not whitelist the mission event type, so that it does not display if event feed restrictions are in place (see @campaign_manager:suppress_all_event_feed_messages and @campaign_manager:whitelist_event_feed_event_type).
function campaign_manager:trigger_custom_mission(faction, mission, do_not_cancel, whitelist)
	if not is_string(faction) then
		script_error("ERROR: trigger_custom_mission() called but supplied faction name [" .. tostring(faction) .. "] is not a string");
		return false;
	end;

	if not do_not_cancel then
		self.game_interface:cancel_custom_mission(faction, mission);
	end;
	
	if whitelist ~= false then
		self:whitelist_event_feed_event_type("faction_event_mission_issuedevent_feed_target_mission_faction");
	end;
	
	out("++ triggering mission " .. tostring(mission) .. " for faction " .. tostring(faction));
	

	self.game_interface:trigger_custom_mission(faction, mission);
end;


--- @function trigger_custom_mission_from_string
--- @desc Triggers a custom mission from a string passed into the function. The mission string must be supplied in a custom format - see the missions.txt that commonly accompanies a campaign for examples. Alternatively, use a @mission_manager which is able to construct such strings internally.
--- @desc This wraps the @episodic_scripting:trigger_custom_mission_from_string function on the underlying episodic scripting interface, adding output and the optional whitelisting functionality.
--- @p @string faction key
--- @p @string mission, Mission definition string.
--- @p [opt=true] @boolean whitelist, Supply <code>false</code> here to not whitelist the mission event type, so that it does not display if event feed restrictions are in place (see @campaign_manager:suppress_all_event_feed_messages and @campaign_manager:whitelist_event_feed_event_type).
function campaign_manager:trigger_custom_mission_from_string(faction_name, mission_string, whitelist)
	out("++ triggering mission from string for faction " .. tostring(faction_name) .. " mission string is " .. tostring(mission_string));
	
	if whitelist ~= false then
		self:whitelist_event_feed_event_type("faction_event_mission_issuedevent_feed_target_mission_faction");
	end;
	
	self.game_interface:trigger_custom_mission_from_string(faction_name, mission_string);
end;


--- @function trigger_mission
--- @desc Instructs the campaign director to attempt to trigger a mission of a particular type, based on a mission record from the database. The mission will be triggered if its conditions, defined in the <code>cdir_events_mission_option_junctions</code>, pass successfully. The function returns whether the mission was successfully triggered or not. Note that if the command is sent via the command queue then <code>true</code> will always be returned, regardless of whether the mission successfully triggers.
--- @desc This function wraps the @episodic_scripting:trigger_mission function on the game interface, adding debug output and event type whitelisting.
--- @p @string faction key, Faction key.
--- @p @string mission key, Mission key, from the missions table.
--- @p [opt=false] @boolean fire immediately, Fire immediately - if this is set, then any turn delay for the mission set in the <code>cdir_event_mission_option_junctions</code> table will be disregarded.
--- @p [opt=true] @boolean whitelist, Supply <code>false</code> here to not whitelist the mission event type, so that it does not display if event feed restrictions are in place (see @campaign_manager:suppress_all_event_feed_messages and @campaign_manager:whitelist_event_feed_event_type).
--- @r @boolean mission triggered successfully
function campaign_manager:trigger_mission(faction_key, mission, fire_immediately, whitelist)
	if not is_string(faction_key) then
		script_error("ERROR: trigger_mission() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string");
		return;
	end;

	if whitelist == nil then
		whitelist = false
	end
	
	fire_immediately = not not fire_immediately;

	out("++ triggering mission from db " .. tostring(mission) .. " for faction " .. tostring(faction_key) .. ", fire_immediately: " .. tostring(fire_immediately));
	
	if whitelist ~= false then
		self:whitelist_event_feed_event_type("faction_event_mission_issuedevent_feed_target_mission_faction");
	end;
	
	return self.game_interface:trigger_mission(faction_key, mission, fire_immediately);
end;


--- @function trigger_dilemma
--- @desc Triggers dilemma with a specified key, based on a record from the database, preferentially wrapped in an intervention. The delivery of the dilemma will be wrapped in an intervention in singleplayer mode, whereas in multiplayer mode the dilemma is triggered directly. It is preferred to use this function to trigger a dilemma, unless the calling script is running from within an intervention in which case @campaign_manager:trigger_dilemma_raw should be used.
--- @p @string faction key, Faction key, from the <code>factions</code> table.
--- @p @string dilemma key, Dilemma key, from the <code>dilemmas</code> table.
--- @p [opt=nil] @function trigger callback, Callback to call when the intervention actually gets triggered.
--- @r @boolean Dilemma triggered successfully. <code>true</code> is always returned if an intervention is generated.
function campaign_manager:trigger_dilemma(faction_key, dilemma_key, on_trigger_callback)

	if not is_string(faction_key) then
		script_error("ERROR: trigger_dilemma() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string");
		return false;
	end;

	if not is_string(dilemma_key) then
		script_error("ERROR: trigger_dilemma() called but supplied dilemma key [" .. tostring(dilemma_key) .. "] is not a string");
		return false;
	end;

	if on_trigger_callback and not is_function(on_trigger_callback) then
		script_error("ERROR: trigger_dilemma() called but supplied trigger callback [" .. tostring(on_trigger_callback) .. "] is not a function");
		return false;
	end;

	-- trigger the dilemma immediately in mp
	if self:is_multiplayer() then
		local result = self:trigger_dilemma_raw(faction_key, dilemma_key, true, true);
		
		if result and on_trigger_callback then
			on_trigger_callback();
		end;
		
		return result;
	end;

	-- in singleplayer, wrap the delivery of the dilemma in an intervention
	self:trigger_transient_intervention(
		"dilemma_" .. faction_key .. "_" .. dilemma_key .. "_" .. core:get_unique_counter(),
		function(intervention)
			local process_name = "dilemma_" .. faction_key .. "_" .. dilemma_key .. "_listeners";

			-- start a one second countdown - if no dilemma has appeared in this time assume that something has gone wrong, error and abort
			self:callback(
				function()
					script_error("WARNING: trigger_dilemma() called but no dilemma was issued, is there a problem with the data? Faction key is [" .. faction_key .. "] and dilemma key is [" .. dilemma_key .. "]. Completing the associated intervention, but no dilemma was triggered.");
					core:remove_listener(process_name);
					intervention:complete();
					return;
				end,
				1,
				process_name
			);

			-- listen for the dilemma being issued
			core:add_listener(
				process_name,
				"DilemmaIssuedEvent",
				function(context) return context:dilemma() == dilemma_key end,
				function()
					cm:remove_callback(process_name);

					-- dilemma has been issued, complete intervention
					intervention:complete();
				end,
				false
			);

			-- call the on-trigger callback
			if on_trigger_callback then
				on_trigger_callback();
			end;

			-- trigger the actual dilemma
			self:trigger_dilemma_raw(faction_key, dilemma_key, true, true);
		end,
		true,
		function(intervention)
			-- Configuration
			-- This intervention will trigger regardless of advice level and whether advice is disabled
			intervention:set_allow_when_advice_disabled(true);
			intervention:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
		end
	);

	return true;
end;


--- @function trigger_dilemma_raw
--- @desc Compels the campaign director to trigger a dilemma of a particular type, based on a record from the database. This function is a raw wrapper for the @episodic_scripting:trigger_dilemma function on the game interface, adding debug output and event type whitelisting, but not featuring the intervention-wrapping behaviour of @campaign_manager:trigger_dilemma. Use this function if triggering the dilemma from within an intervention, but @campaign_manager:trigger_dilemma for all other instances.
--- @p @string faction key, Faction key, from the <code>factions</code> table.
--- @p @string dilemma key, Dilemma key, from the <code>dilemmas</code> table.
--- @p [opt=false] @boolean fire immediately, Fire immediately. If set, the dilemma will fire immediately, otherwise the dilemma will obey any wait period set in the <code>cdir_events_dilemma_options</code> table.
--- @p [opt=false] @boolean whitelist, Supply <code>true</code> here to also whitelist the dilemma event type, so that it displays even if event feed restrictions are in place (see @campaign_manager:suppress_all_event_feed_messages and @campaign_manager:whitelist_event_feed_event_type).
--- @r @boolean Dilemma triggered successfully.
function campaign_manager:trigger_dilemma_raw(faction_key, dilemma_key, fire_immediately, whitelist)

	if not is_string(faction_key) then
		script_error("ERROR: trigger_dilemma_raw() called but supplied faction key [" .. tostring(faction_key) .. "] is not a string");
		return false;
	end;

	if not is_string(dilemma_key) then
		script_error("ERROR: trigger_dilemma_raw() called but supplied dilemma key [" .. tostring(dilemma_key) .. "] is not a string");
		return false;
	end;

	fire_immediately = not not fire_immediately;

	out("++ triggering dilemma from db " .. tostring(dilemma_key) .. " for faction " .. tostring(faction_key) .. ", fire_immediately: " .. tostring(fire_immediately));
	
	if whitelist then
		self:whitelist_event_feed_event_type("faction_event_dilemmaevent_feed_target_dilemma_faction");
	end;
	
	return self.game_interface:trigger_dilemma(faction_key, dilemma_key, fire_immediately);
end;


--- @function trigger_dilemma_with_targets
--- @desc Triggers a dilemma with a specified key and one or more target game objects, preferentially wrapped in an intervention.
--- @desc If calling from within an intervention, <code>force_dilemma_immediately</code> can be specified as <code>true</code> to prevent a nested intervention call. If in multiplayer, the dilemma will never be wrapped in an intervention.
--- @desc The game object or objects to associate the dilemma with are specified by command-queue index. The dilemma will need to pass any conditions set up in the <code>cdir_events_dilemma_option_junctions</code> table in order to trigger.
--- @p @number faction cqi, Command-queue index of the faction to which the dilemma is issued. This must be supplied.
--- @p @string dilemma key, Dilemma key, from the <code>dilemmas</code> table.
--- @p [opt=0] @number target faction cqi, Command-queue index of a target faction.
--- @p [opt=0] @number secondary faction cqi, Command-queue index of a second target faction.
--- @p [opt=0] @number character cqi, Command-queue index of a target character.
--- @p [opt=0] @number military force cqi, Command-queue index of a target military force.
--- @p [opt=0] @number region cqi, Command-queue index of a target region.
--- @p [opt=0] @number settlement cqi, Command-queue index of a target settlement.
--- @p @function trigger callback, Callback to call when the intervention actually gets triggered.
--- @p [opt=false] @boolean trigger callback immediately, If true, will not wrap the dilemma in an intervention. If false, will only wrap the dilemma in an intervention if in singleplayer.
--- @r @boolean Dilemma triggered successfully. <code>true</code> is always returned if an intervention is generated.
function campaign_manager:trigger_dilemma_with_targets(faction_cqi, dilemma_key, target_faction_cqi, secondary_faction_cqi, character_cqi, mf_cqi, region_cqi, settlement_cqi, on_trigger_callback, force_dilemma_immediately)

	force_dilemma_immediately = force_dilemma_immediately or self:is_multiplayer()

	-- trigger the dilemma immediately in mp
	return self:trigger_dilemma_with_targets_internal(faction_cqi, dilemma_key, target_faction_cqi, secondary_faction_cqi, character_cqi, 0, mf_cqi, region_cqi, settlement_cqi, on_trigger_callback, force_dilemma_immediately)
end;


--- @function trigger_dilemma_with_targets_and_family_member
--- @desc Triggers a dilemma with a specified key and one or more target game objects, including a family member CQI instead of a character CQI (since this should remain constant between character deaths and revivals), preferentially wrapped in an intervention.
--- @desc If calling from within an intervention, <code>force_dilemma_immediately</code> can be specified as <code>true</code> to prevent a nested intervention call. If in multiplayer, the dilemma will never be wrapped in an intervention.
--- @desc The game object or objects to associate the dilemma with are specified by command-queue index. The dilemma will need to pass any conditions set up in the <code>cdir_events_dilemma_option_junctions</code> table in order to trigger.
--- @p @number faction cqi, Command-queue index of the faction to which the dilemma is issued. This must be supplied.
--- @p @string dilemma key, Dilemma key, from the <code>dilemmas</code> table.
--- @p [opt=0] @number target faction cqi, Command-queue index of a target faction.
--- @p [opt=0] @number secondary faction cqi, Command-queue index of a second target faction.
--- @p [opt=0] @number family member cqi, Command-queue index of a target character's family member interface.
--- @p [opt=0] @number military force cqi, Command-queue index of a target military force.
--- @p [opt=0] @number region cqi, Command-queue index of a target region.
--- @p [opt=0] @number settlement cqi, Command-queue index of a target settlement.
--- @p @function trigger callback, Callback to call when the intervention actually gets triggered.
--- @p [opt=false] @boolean trigger callback immediately, If true, will not wrap the dilemma in an intervention. If false, will only wrap the dilemma in an intervention if in singleplayer.
--- @r @boolean Dilemma triggered successfully. <code>true</code> is always returned if an intervention is generated.
function campaign_manager:trigger_dilemma_with_targets_and_family_member(faction_cqi, dilemma_key, target_faction_cqi, secondary_faction_cqi, family_member_cqi, mf_cqi, region_cqi, settlement_cqi, on_trigger_callback, force_dilemma_immediately)

	force_dilemma_immediately = force_dilemma_immediately or self:is_multiplayer()

	-- trigger the dilemma immediately in mp
	self:trigger_dilemma_with_targets_internal(faction_cqi, dilemma_key, target_faction_cqi, secondary_faction_cqi, 0, family_member_cqi, mf_cqi, region_cqi, settlement_cqi, on_trigger_callback, force_dilemma_immediately)
end;


-- The internal call for triggering a dilemma with targets. This will invoke an intervention to eventually trigger the dilemma if immediate is true.
-- This exists to handle the increasingly complicated pile of parameter targets that can be given to a dilemma: you can create more user-friendly
-- outward-facing functions complete with documentation to help avoid potential misuse of these parameters.
-- All target parameters are a CQI number of some sort, with the exception of the dilemma key itself (a string).
-- If 'immediate' is true, will not wrap the dilemma in an intervention. If false, will only wrap the dilemma in an intervention if in singleplayer.
-- Returns true if dilemma triggered successfully. True is always rturned if an intervention is generated.
function campaign_manager:trigger_dilemma_with_targets_internal(faction_cqi, dilemma_key, target_faction_cqi, secondary_faction_cqi, character_cqi, family_member_cqi, mf_cqi, region_cqi, settlement_cqi, on_trigger_callback, immediate)

	--other args are checked in triger_dilemma_with_targets_raw
	if on_trigger_callback and not is_function(on_trigger_callback) then
		script_error(string.format("ERROR: trigger_dilemma_with_targets_internal() [%s] called but supplied trigger callback [%s] is not a function", dilemma_key, tostring(on_trigger_callback)));
		return false;
	end;

	if immediate then
		local targets_valid, error_messages = self:trigger_dilemma_with_targets_raw(faction_cqi, dilemma_key, target_faction_cqi, secondary_faction_cqi, character_cqi, family_member_cqi, mf_cqi, region_cqi, settlement_cqi, true);

		if not targets_valid then
			if error_messages == "" then
				script_error(string.format("ERROR: 'trigger_dilemma_with_targets_internal() called with valid targets, but no dilemma was issued, does the dilemma exist? Dilemma key is [%s]", dilemma_key));
				return false;
			else
				script_error(string.format("ERROR: 'trigger_dilemma_with_targets_internal()' [%s] was not able to trigger dilemma from intervention. Targets were not valid:%s", dilemma_key, error_messages));
				return false;
			end
		else
			if on_trigger_callback then
				on_trigger_callback();
			end;
			return true;
		end
	else
		-- in singleplayer, wrap the delivery of the dilemma in an intervention
		self:trigger_transient_intervention(
			"dilemma_" .. faction_cqi .. "_" .. dilemma_key,
			function(intervention)
				local process_name = "dilemma_" .. faction_cqi .. "_" .. dilemma_key .. "_listeners";

				-- start a one second countdown - if no dilemma has appeared in this time assume that something has gone wrong, error and abort
				self:callback(
					function()
						script_error(
							string.format(
								"WARNING: trigger_dilemma_with_targets_internal() called but no dilemma was issued, is there a problem with the data? Faction cqi is [%s] and dilemma key is [%s]. Completing the associated intervention, but no dilemma was triggered.", 
								faction_cqi, 
								dilemma_key
							)
						);

						core:remove_listener(process_name);
						intervention:complete();
						return;
					end,
					1,
					process_name
				);

				-- listen for the dilemma being issued
				core:add_listener(
					process_name,
					"DilemmaIssuedEvent",
					function(context) return context:dilemma() == dilemma_key end,
					function()
						cm:remove_callback(process_name);

						-- dilemma has been issued, complete intervention
						intervention:complete();
					end,
					false
				);

				-- Attempt to trigger the actual dilemma
				local targets_valid, error_messages = self:trigger_dilemma_with_targets_raw(faction_cqi, dilemma_key, target_faction_cqi, secondary_faction_cqi, character_cqi, family_member_cqi, mf_cqi, region_cqi, settlement_cqi, true);

				if not targets_valid then
					if error_messages == "" then
						script_error(string.format("ERROR: 'trigger_dilemma_with_targets_internal() called with valid targets, but no dilemma was issued, does the dilemma exist? Dilemma key is [%s]", dilemma_key));
						return false;
					else
						script_error(string.format("ERROR: 'trigger_dilemma_with_targets_internal()' [%s] was not able to trigger dilemma from intervention. Targets were not valid:%s", dilemma_key, error_messages));
					end
				else
					-- call the on-trigger callback
					if on_trigger_callback then
						on_trigger_callback();
					end;
				end

				return
			end,
			true,
			function(intervention)
				-- This intervention will trigger regardless of advice level and whether advice is disabled
				intervention:set_allow_when_advice_disabled(true);
				intervention:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
			end
		);
		return true;
	end
end;


--- @function trigger_dilemma_with_targets_raw
--- @desc Directly triggers a dilemma with a specified key and one or more target game objects. This function is a raw wrapper for the @episodic_scripting:trigger_dilemma_with_targets function on the game interface, adding debug output and event type whitelisting, but not featuring the intervention-wrapping behaviour of <code>trigger_dilemma_with_targets_internal</code>.
--- @desc The game object or objects to associate the dilemma with are specified by command-queue index. The dilemma will need to pass any conditions set up in the <code>cdir_events_dilemma_option_junctions</code> table in order to trigger.
--- @desc Some parameters are mutually exclusive: for example, either character_cqi or family_member_cqi may be specified, but not both.
--- @p @number faction cqi, Command-queue index of the faction to which the dilemma is issued. This must be supplied.
--- @p @string dilemma key, Dilemma key, from the <code>dilemmas</code> table.
--- @p [opt=0] @number target faction cqi, Command-queue index of a target faction.
--- @p [opt=0] @number secondary faction cqi, Command-queue index of a second target faction.
--- @p [opt=0] @number character cqi, Command-queue index of a target character.
--- @p [opt=0] @number family member cqi, Command-queue index of a target settlement.
--- @p [opt=0] @number military force cqi, Command-queue index of a target military force.
--- @p [opt=0] @number region cqi, Command-queue index of a target region.
--- @p [opt=0] @number settlement cqi, Command-queue index of a target settlement.
--- @p @function trigger callback, Callback to call when the intervention actually gets triggered.
--- @p @boolean whitelist, Allows the dilemma to bypass event supression.
--- @r @boolean Dilemma triggered successfully
--- @r @string Any errors found with the dilemma's targets, if applicable. Otherwise an empty string.
function campaign_manager:trigger_dilemma_with_targets_raw(faction_cqi, dilemma_key, target_faction_cqi, secondary_faction_cqi, character_cqi, family_member_cqi, mf_cqi, region_cqi, settlement_cqi, whitelist)

	local error_messages = "";
	local faction;
	local target_faction = false;
	local secondary_faction = false;
	local character = false;
	local mf = false;

	if not is_number(faction_cqi) then
		error_messages = error_messages .. "\n\tSupplied faction cqi [" .. tostring(faction_cqi) .. "] is not a number";
	else
		faction = cm:model():faction_for_command_queue_index(faction_cqi);

		if faction:is_null_interface() then
			error_messages = error_messages .. "\n\tNo faction with supplied cqi [" .. faction_cqi .. "] could be found";
		end;
	end

	if not is_string(dilemma_key) then
		error_messages = error_messages .. "\n\tSupplied dilemma key [" .. tostring(dilemma_key) .. "] is not a string";
	end;

	if target_faction_cqi then
		if not is_number(target_faction_cqi) then
			error_messages = error_messages .. "\n\tSupplied target faction cqi [" .. tostring(target_faction_cqi) .. "] is not a number or nil";
		elseif target_faction_cqi ~= 0 then
			target_faction = cm:model():faction_for_command_queue_index(target_faction_cqi);

			if target_faction:is_null_interface() then
				error_messages = error_messages .. "\n\tNo target faction with supplied cqi [" .. target_faction_cqi .. "] could be found";
			end;
		end;
	else
		target_faction_cqi = 0;
	end;

	if secondary_faction_cqi then
		if not is_number(secondary_faction_cqi) then
			error_messages = error_messages .. "\n\tSupplied secondary faction cqi [" .. tostring(secondary_faction_cqi) .. "] is not a number or nil";
		elseif secondary_faction_cqi ~= 0 then
			secondary_faction = cm:model():faction_for_command_queue_index(secondary_faction_cqi);

			if secondary_faction:is_null_interface() then
				error_messages = error_messages .. "\n\tNo secondary faction with supplied cqi [" .. secondary_faction_cqi .. "] could be found";
			end;
		end;
	else
		secondary_faction_cqi = 0;
	end;

	if character_cqi then
		if not is_number(character_cqi) then
			error_messages = error_messages .. "\n\tSupplied character cqi [" .. tostring(character_cqi) .. "] is not a number or nil";
		elseif character_cqi ~= 0 then
			character = cm:get_character_by_cqi(character_cqi);

			if not character then
				error_messages = error_messages .. "\n\tNo character with supplied cqi [" .. character_cqi .. "] could be found";
			end;
		end;
	else
		character_cqi = 0;
	end;

	if family_member_cqi then
		if not is_number(family_member_cqi) then
			error_messages = error_messages .. "\n\tSupplied region cqi [" .. tostring(settlement_cqi) .. "] is not a number or nil";
		elseif family_member_cqi ~= 0 then
			if character_cqi ~= 0 then
				error_messages = error_messages .. 
					string.format(
						"\n\tBoth both character_cqi [%s] and family_member_cqi [%s] specified: the latter is used as a more stable standin for the former, as family_member CQIs do not change on character respawn. Use one or the other, but not both.",
						character_cqi,
						family_member_cqi
					);
			end

			local family_member = cm:get_family_member_by_cqi(family_member_cqi);
			if not family_member or family_member:is_null_interface() then
				error_messages = error_messages .. string.format("\n\tNo family member with supplied family_member cqi [" .. family_member_cqi .. "] could be found");
			else
				character = family_member:character();
				if not character or character:is_null_interface() then
					script_error("ERROR: trigger_dilemma_with_targets_raw(): Family member with cqi [" .. family_member_cqi .. "] found but character was nil or null_interface.");
				else
					character_cqi = character:command_queue_index();	-- By now, the dilemma is about to fire, so we can safely get the CQI without it changing in the meantime.
				end
			end
		end
	else
		family_member_cqi = 0;
	end;

	if mf_cqi then
		if not is_number(mf_cqi) then
			error_messages = error_messages .. "\n\tSupplied military force cqi [" .. tostring(mf_cqi) .. "] is not a number or nil";
		elseif mf_cqi ~= 0 then
			mf = cm:model():military_force_for_command_queue_index(mf_cqi);

			if mf:is_null_interface() then
				error_messages = error_messages .. "\n\tNo military force with supplied mf cqi [" .. mf_cqi .. "] could be found";
			end;
		end;
	else
		mf_cqi = 0;
	end;

	if region_cqi then
		if not is_number(region_cqi) then
			error_messages = error_messages .. "\n\tSupplied region cqi [" .. tostring(region_cqi) .. "] is not a number or nil";
		end;
	else
		region_cqi = 0;
	end;

	if settlement_cqi then
		if not is_number(settlement_cqi) then
			error_messages = error_messages .. "\n\tSupplied region cqi [" .. tostring(settlement_cqi) .. "] is not a number or nil";
		end;
	else
		settlement_cqi = 0;
	end;

	if error_messages ~= "" then
		return false, error_messages;
	end

	-- debug output
	out("++ triggering dilemma [" .. tostring(dilemma_key) .. "] with targets from db for faction with cqi [" .. tostring(faction_cqi) .. "] (key: " .. faction:name() .. "), whitelisting event type: " .. tostring(whitelist));
	if target_faction then
		out("\ttarget faction [" .. target_faction:name() .. "] with cqi [" .. target_faction_cqi .. "] specified");
	end;
	if secondary_faction then
		out("\tsecondary faction [" .. secondary_faction:name() .. "] with cqi [" .. secondary_faction_cqi .. "] specified");
	end;
	if character then
		out("\tcharacter with cqi [" .. character_cqi .. "] specified (faction [" .. character:faction():name() .. ", position [" .. character:logical_position_x() .. ", " .. character:logical_position_y() .. "])");
	end;
	if mf then
		out("\tmilitary force with cqi [" .. character_cqi .. "] specified (faction [" .. mf:general_character():faction():name() .. ", position [" .. mf:general_character():logical_position_x() .. ", " .. mf:general_character():logical_position_y() .. "])");
	end;
	if region_cqi ~= 0 then
		out("\tregion with cqi [" .. region_cqi .. "] specified");
	end;
	if settlement_cqi ~= 0 then
		out("\tsettlement with cqi [" .. settlement_cqi .. "] specified");
	end;

	if whitelist then
		self:whitelist_event_feed_event_type("faction_event_dilemmaevent_feed_target_dilemma_faction");
	end;
	
	return self.game_interface:trigger_dilemma_with_targets(faction_cqi, dilemma_key, target_faction_cqi, secondary_faction_cqi, character_cqi, mf_cqi, region_cqi, settlement_cqi), error_messages;
end;


--- @function trigger_incident
--- @desc Instructs the campaign director to attempt to trigger a specified incident, based on record from the database. The incident will be triggered if its conditions, defined in the <code>cdir_events_incident_option_junctions</code>, pass successfully. The function returns whether the incident was successfully triggered or not.
--- @desc This function wraps the @episodic_scripting:trigger_incident function on the game interface, adding debug output and event type whitelisting.
--- @p @string faction key, Faction key.
--- @p @string incident key, Incident key, from the incidents table.
--- @p [opt=false] @boolean fire immediately, Fire immediately - if this is set, then any turn delay for the incident set in the <code>cdir_event_incident_option_junctions</code> table will be disregarded.
--- @p [opt=false] @boolean whitelist, Supply <code>true</code> here to also whitelist the dilemma event type, so that it displays even if event feed restrictions are in place (see @campaign_manager:suppress_all_event_feed_messages and @campaign_manager:whitelist_event_feed_event_type).
--- @r @boolean incident was triggered
function campaign_manager:trigger_incident(faction, incident, fire_immediately, whitelist)
	fire_immediately = not not fire_immediately;

	out("++ triggering incident from db " .. tostring(incident) .. " for faction " .. tostring(faction) .. ", fire_immediately: " .. tostring(fire_immediately));
	
	if whitelist == true then
		self:whitelist_event_feed_event_type("faction_event_character_incidentevent_feed_target_incident_faction");
		self:whitelist_event_feed_event_type("faction_event_region_incidentevent_feed_target_incident_faction");
		self:whitelist_event_feed_event_type("faction_event_incidentevent_feed_target_incident_faction");
	end;
	
	return self.game_interface:trigger_incident(faction, incident, fire_immediately);
end;


-- get mission manager by mission key
-- for internal usage, hence not being documented
function campaign_manager:get_mission_manager(faction_key, mission_key)
	if self.mission_managers[faction_key] then
		return self.mission_managers[faction_key][mission_key];
	end;
end;


-- internal function that a mission manager calls to register itself
function campaign_manager:register_mission_manager(mission_manager)
	if not is_missionmanager(mission_manager) then
		script_error("ERROR: register_mission_manager() called but supplied mission manager [" .. tostring(mission_manager) .. "] is not a mission manager");
		return false;
	end;

	local faction_name = mission_manager.faction_name;
	local mission_key = mission_manager.mission_key;

	if self:get_mission_manager(faction_name, mission_key) then
		script_error("ERROR: register_mission_manager() called but supplied mission manager for faction [" .. faction_name .. "] with key [" .. mission_key .. "] is already registered");
		return false;
	end;

	local mission_managers = self.mission_managers;

	if not mission_managers[faction_name] then
		mission_managers[faction_name] = {};
	end;
	
	mission_managers[faction_name][mission_key] = mission_manager;
	
	-- We also store mission managers in a flat indexed list, which we use for savegame ordering
	table.insert(self.mission_managers_indexed, mission_manager);

	return true;
end;


--	handles the saving of mission managers to the savegame
function campaign_manager:get_mission_managers_for_saving_game()
	local mission_managers_save_table = {};
	local mission_managers_indexed = self.mission_managers_indexed;
	for i = 1, #mission_managers_indexed do
		local current_mm = mission_managers_indexed[i];
		table.insert(
			mission_managers_save_table,
			{
				faction_name = current_mm.faction_name,
				mission_key = current_mm.mission_key,
				started = current_mm.started,
				completed = current_mm.completed,
				persistent_values = current_mm.persistent_values
			}
		);
	end;

	return mission_managers_save_table;
end;


function campaign_manager:setup_mission_managers_post_first_tick(mission_managers_save_table)
	local mission_managers = self.mission_managers;
	for i = 1, #mission_managers_save_table do
		local current_record = mission_managers_save_table[i];

		local faction_name = current_record.faction_name;
		local mission_key = current_record.mission_key;
		local persistent_values = current_record.persistent_values;
		
		if mission_managers[faction_name] then
			local mm = mission_managers[faction_name][mission_key];
			if mm then
				for key, value in pairs(persistent_values) do
					mm:set_persistent_value(key, value);
				end;
				mm:trigger_from_savegame(current_record.started, current_record.completed);
			-- Throw a script error, unless the mission record indicates that the mission has been started and completed, in which case we assume it's safe to ignore
			elseif not (current_record.started and current_record.completed) then
				script_error("WARNING: attempting to set up mission manager on the first tick after loading the game but we couldn't find any declared mission managers for faction [" .. tostring(faction_name) .. "] with mission key ["  .. tostring(mission_key) .. "]. Mission managers should be declared during script startup. Will proceed, but this indicates some kind of script/savegame mismatch");
			end;
		else
			script_error("WARNING: attempting to set up mission manager on the first tick after loading the game but we couldn't find any declared mission managers for faction [" .. tostring(faction_name) .. "]. Mission managers should be declared during script startup. Will proceed, but this indicates some kind of script/savegame mismatch");
		end;
	end;
end;


--- @function suppress_all_event_feed_messages
--- @desc Suppresses or unsuppresses all event feed message from being displayed. With this suppression in place, event panels won't be shown on the UI at all but will be queued and then shown when the suppression is removed. The suppression must not be kept on during the end-turn sequence.
--- @desc When suppressing, we whitelist dilemmas as they lock the model, and also mission succeeded event types as the game tends to flow better this way.
--- @p [opt=true] boolean activate suppression
function campaign_manager:suppress_all_event_feed_messages(value)
	if value ~= false then
		value = true;
	end;

	if self.all_event_feed_messages_suppressed == value then
		return;
	end;
	
	self.all_event_feed_messages_suppressed = value;
		
	out(">> suppress_all_event_feed_messages(" .. tostring(value) .. ") called");
	
	CampaignUI.SuppressAllEventTypesInUI(value);
	
	-- if we are suppressing, then whitelist certain event types so that they still get through
	if value then
		-- whitelist dilemma messages in the UI, in case there's one already pending
		self:whitelist_event_feed_event_type("faction_event_dilemmaevent_feed_target_dilemma_faction");
		
		-- also whitelist mission succeeded events, the flow just works better if the player gets immediate feedback about these things
		self:whitelist_event_feed_event_type("faction_event_mission_successevent_feed_target_mission_faction");

		-- also whitelist basic faction incidents. this is because in WH3 these are used for story panels, which require interaction to close and can cause issues when suppressed.
		self:whitelist_event_feed_event_type("faction_event_incidentevent_feed_target_incident_faction");
	end;
end;


--- @function whitelist_event_feed_event_type
--- @desc While suppression has been activated with @campaign_manager:suppress_all_event_feed_messages an event type may be whitelisted and allowed to be shown with this function. This allows scripts to hold all event messages from being displayed except those of a certain type. This is useful for advice scripts which may want to talk about those messages, for example.
--- @desc If event feed suppression is not active then calling this function will have no effect.
--- @p string event type, Event type to whitelist. This is compound key from the <code>event_feed_targeted_events</code> table, which is the event field and the target field of a record from this table, concatenated together.
--- @new_example Whitelisting the "enemy general dies" event type
--- @example cm:whitelist_event_feed_event_type("character_dies_battleevent_feed_target_opponent")
function campaign_manager:whitelist_event_feed_event_type(event_type)
	out(">> whitelist_event_feed_event_type() called, event_type is " .. tostring(event_type));
	
	CampaignUI.WhiteListEventTypeInUI(event_type);
end;


--- @function disable_event_feed_events
--- @desc Disables event feed events by category, subcategory or individual event type. Unlike @campaign_manager:suppress_all_event_feed_messages the events this call blocks are discarded. Use this function to prevent certain events from appearing.
--- @desc The function wraps the @episodic_scripting:disable_event_feed_events function on the underlying episodic scripting interface.
--- @p boolean should disable, Should disable event type(s).
--- @p [opt=""] string event categories, Event categories to disable. Event categories are listed in the <code>event_feed_categories</code> database table. Additionally, supply "" or false/nil to not suppress by category in this function call. Supply "all" to disable all event types.
--- @p [opt=""] string event subcategories, Event subcategories to disable. Event subcategories are listed in the <code>event_feed_subcategories</code> database table. Supply "" or false/nil to not suppress by subcategory in this function call.
--- @p [opt=""] string event, Event to disable, from the <code>event_feed_events</code> database table. Supply "" or false/nil to not supress by events in this function call.
function campaign_manager:disable_event_feed_events(disable, categories, subcategories, events)
	categories = categories or "";
	subcategories = subcategories or "";
	events = events or "";
	--out("disable_event_feed_events() called: ["..tostring(disable).."], ["..categories.."], ["..subcategories.."], ["..events.."]");
	
	local all_categories = "wh_event_category_agent;wh_event_category_character;wh_event_category_conquest;wh_event_category_diplomacy;wh_event_category_faction;wh_event_category_military;wh_event_category_provinces;wh_event_category_traits_ancillaries;wh_event_category_world";
	
	if categories == "all" then
		self.game_interface:disable_event_feed_events(disable, all_categories, subcategories, events);
	else
		self.game_interface:disable_event_feed_events(disable, categories, subcategories, events);
	end
end


--- @function show_message_event
--- @desc Constructs and displays an event. This wraps the @episodic_scripting:show_message_event function of the same name on the underlying @episodic_scripting, although it provides input validation, output, whitelisting and a progression callback.
--- @p string faction key, Faction key to who the event is targeted.
--- @p string title loc key, Localisation key for the event title. This should be supplied in the full [table]_[field]_[key] localisation format, or can be a blank string.
--- @p string primary loc key, Localisation key for the primary detail of the event. This should be supplied in the full [table]_[field]_[key] localisation format, or can be a blank string.
--- @p string secondary loc key, Localisation key for the secondary detail of the event. This should be supplied in the full [table]_[field]_[key] localisation format, or can be a blank string.
--- @p boolean persistent, Sets this event to be persistent instead of transient.
--- @p number index, Index indicating the type of event.
--- @p [opt=false] function end callback, Specifies a callback to call when this event is dismissed. Note that if another event message shows first for some reason, this callback will be called early.
--- @p [opt=0] number callback delay, Delay in seconds before calling the end callback, if supplied.
--- @p [opt=false] boolean dont whitelist, By default this function will whitelist the scripted event message type with @campaign_manager:whitelist_event_feed_event_type. Set this flag to <code>true</code> to prevent this.
function campaign_manager:show_message_event(faction_key, title_loc_key, primary_detail_loc_key, secondary_detail_loc_key, is_persistent, index_num, end_callback, delay, suppress_whitelist)
	if not cm:get_faction(faction_key) then
		script_error("ERROR: show_message_event() called but no faction with supplied name [" .. tostring(faction_key) .. "] could be found");
		return false;
	end;
	
	if not is_string(title_loc_key) then
		script_error("ERROR: show_message_event() called but supplied title localisation key [" .. tostring(title_loc_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(primary_detail_loc_key) then
		script_error("ERROR: show_message_event() called but supplied primary detail localisation key [" .. tostring(primary_detail_loc_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(secondary_detail_loc_key) then
		script_error("ERROR: show_message_event() called but supplied secondary detail localisation key [" .. tostring(secondary_detail_loc_key) .. "] is not a string");
		return false;
	end;
	
	if not is_boolean(is_persistent) then
		script_error("ERROR: show_message_event() called but supplied is_persistent flag [" .. tostring(is_persistent) .. "] is not a boolean value");
		return false;
	end;
	
	if not is_number(index_num) then
		script_error("ERROR: show_message_event() called but supplied index number [" .. tostring(index_num) .. "] is not a number");
		return false;
	end;
	
	if end_callback and not is_function(end_callback) then
		script_error("ERROR: show_message_event() called but supplied end_callback [" .. tostring(end_callback) .. "] is not a function or nil");
		return false;
	end;
	
	if delay and not is_number(delay) then
		script_error("ERROR: show_message_event() called but supplied end_callback [" .. tostring(delay) .. "] is not a number or nil");
		return false;
	end;
	
	out("show_message_event() called, showing event for faction [" .. faction_key .. "] with title [" .. title_loc_key .. "], primary detail [" .. primary_detail_loc_key .. "] and secondary detail [" .. secondary_detail_loc_key .. "]");

	local is_multiplayer = self:is_multiplayer();
	
	if end_callback and not is_multiplayer then
		out("\tsetting up progress listener");
		local progress_name = "show_message_event_" .. title_loc_key;
	
		core:add_listener(
			progress_name,
			"PanelOpenedCampaign",
			function(context) return context.string == "events" end,
			function()
				self:progress_on_events_dismissed(
					progress_name,
					end_callback,
					delay
				);
			end,
			false
		);
	end;
	
	if not suppress_whitelist then
		if is_persistent then
			cm:whitelist_event_feed_event_type("scripted_persistent_eventevent_feed_target_faction");
		else
			cm:whitelist_event_feed_event_type("scripted_transient_eventevent_feed_target_faction");
		end;
	end;
	
	self.game_interface:show_message_event(faction_key, title_loc_key, primary_detail_loc_key, secondary_detail_loc_key, is_persistent, index_num);

	-- In multiplayer mode just call the end callback after the event is shown
	if end_callback and is_multiplayer then
		self:callback(
			function()
				end_callback();
			end,
			0.5
		);
	end;
end;


--- @function show_message_event_located
--- @desc Constructs and displays a located event. This wraps the @episodic_scripting:show_message_event_located function of the same name on the underlying episodic scripting interface, although it also provides input validation, output, whitelisting and a progression callback.
--- @p string faction key, Faction key to who the event is targeted.
--- @p string title loc key, Localisation key for the event title. This should be supplied in the full [table]_[field]_[key] localisation format, or can be a blank string.
--- @p string primary loc key, Localisation key for the primary detail of the event. This should be supplied in the full [table]_[field]_[key] localisation format, or can be a blank string.
--- @p string secondary loc key, Localisation key for the secondary detail of the event. This should be supplied in the full [table]_[field]_[key] localisation format, or can be a blank string.
--- @p number x, Logical x co-ordinate of event target.
--- @p number y, Logical y co-ordinate of event target.
--- @p boolean persistent, Sets this event to be persistent instead of transient.
--- @p number index, Index indicating the type of event.
--- @p [opt=false] function end callback, Specifies a callback to call when this event is dismissed. Note that if another event message shows first for some reason, this callback will be called early.
--- @p [opt=0] number callback delay, Delay in seconds before calling the end callback, if supplied.
function campaign_manager:show_message_event_located(faction_key, title_loc_key, primary_detail_loc_key, secondary_detail_loc_key, x, y, is_persistent, index_num, end_callback, delay)
	if not cm:get_faction(faction_key) then
		script_error("ERROR: show_message_event_located() called but no faction with supplied name [" .. tostring(faction_key) .. "] could be found");
		return false;
	end;
	
	if not is_string(title_loc_key) then
		script_error("ERROR: show_message_event_located() called but supplied title localisation key [" .. tostring(title_loc_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(primary_detail_loc_key) then
		script_error("ERROR: show_message_event_located() called but supplied primary detail localisation key [" .. tostring(primary_detail_loc_key) .. "] is not a string");
		return false;
	end;
	
	if not is_string(secondary_detail_loc_key) then
		script_error("ERROR: show_message_event_located() called but supplied secondary detail localisation key [" .. tostring(secondary_detail_loc_key) .. "] is not a string");
		return false;
	end;
	
	if not is_number(x) then
		script_error("ERROR: show_message_event_located() called but supplied x co-ordinate [" .. tostring(x) .. "] is not a number");
		return false;
	end;
	
	if not is_number(y) then
		script_error("ERROR: show_message_event_located() called but supplied y co-ordinate [" .. tostring(y) .. "] is not a number");
		return false;
	end;
	
	if not is_boolean(is_persistent) then
		script_error("ERROR: show_message_event_located() called but supplied is_persistent flag [" .. tostring(is_persistent) .. "] is not a boolean value");
		return false;
	end;
	
	if not is_number(index_num) then
		script_error("ERROR: show_message_event_located() called but supplied index_num [" .. tostring(index_num) .. "] is not a number");
		return false;
	end;
	
	if end_callback and not is_function(end_callback) then
		script_error("ERROR: show_message_event_located() called but supplied end_callback [" .. tostring(end_callback) .. "] is not a function or nil");
		return false;
	end;
	
	if delay and not is_number(delay) then
		script_error("ERROR: show_message_event_located() called but supplied end_callback [" .. tostring(delay) .. "] is not a number or nil");
		return false;
	end;
	
	out("show_message_event_located() called, showing event for faction [" .. faction_key .. "] with title [" .. title_loc_key .. "], primary detail [" .. primary_detail_loc_key .. "] and secondary detail [" .. secondary_detail_loc_key .. "] at co-ordinates [" .. x .. ", " .. y .. "]");
	
	if end_callback then
		local progress_name = "show_message_event_located_" .. title_loc_key;
	
		core:add_listener(
			progress_name,
			"PanelOpenedCampaign",
			function(context) return context.string == "events" end,
			function()
				self:progress_on_events_dismissed(
					progress_name,
					end_callback,
					delay
				);
			end,
			false
		);
	end;
	
	self.game_interface:show_message_event_located(faction_key, title_loc_key, primary_detail_loc_key, secondary_detail_loc_key, x, y, is_persistent, index_num);
end;












-----------------------------------------------------------------------------
--- @section Achievements
-----------------------------------------------------------------------------


--- @function award_achievement
--- @desc Awards an achievement by string key. This function calls the equivalent function on the episodic scripting interface, adding output and argument-checking.
--- @p @string achievement key, Achievement key, from the <code>achievements</code> database table.
function campaign_manager:award_achievement(key)
	if not validate.is_string(key) then
		return false;
	end;
	
	out.design("Awarding achievement [" .. key .. "]");
	self.game_interface:award_achievement(key);
end;








-----------------------------------------------------------------------------
--- @section Transient Interventions
--- @desc @intervention offer a script method for locking the campaign UI and progression until the sequence of scripted events has finished. The main intervention interface should primarily be used when creating interventions, but this section lists functions that can be used to quickly create transient throwaway interventions, whose state is not saved into the savegame. See @"intervention:Transient Interventions" for more information.
-----------------------------------------------------------------------------

--- @function trigger_transient_intervention
--- @desc Creates, starts, and immediately triggers a transient intervention with the supplied paramters. This should trigger immediately unless another intervention is running, in which case it should trigger afterwards.
--- @p @string name, Name for intervention. This should be unique amongst interventions.
--- @p @function callback, Trigger callback to call.
--- @p [opt=true] @boolean debug, Sets the intervention into debug mode, in which it will produce more output. Supply <code>false</code> to suppress this behaviour.
--- @p [opt=nil] @function configuration callback, If supplied, this function will be called with the created intervention supplied as a single argument before the intervention is started. This allows calling script to configure the intervention before being started.
--- @p [opt=0] @number intervention priority, Priority value of the intervention.
function campaign_manager:trigger_transient_intervention(name, callback, is_debug, config_callback, intervention_priority)
	if self:is_multiplayer() then
		script_error("ERROR: trigger_transient_intervention() called with intervention name [" .. tostring(name) .. "] in multiplayer mode - this is not supported. The intervention will not happen.");
		return false;
	end;
	
	if is_debug ~= false then
		is_debug = true;
	end;

	intervention_priority = intervention_priority or 0;

	-- ti = transient intervention
	local ti = intervention:new(
		name,
		intervention_priority,
		callback,
		is_debug,
		true
	);

	ti:set_must_trigger(true);
	ti:set_allow_when_advice_disabled(true);
	ti:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);

	if not ti then
		return false;
	end;

	ti:add_trigger_condition(
		"ScriptEventStartTransientIntervention",
		function(context)
			return context.string == name;
		end
	);

	if is_function(config_callback) then
		config_callback(ti);
	end;

	ti:start();

	core:trigger_event("ScriptEventStartTransientIntervention", name);
end;











-----------------------------------------------------------------------------
--- @section Turn Countdown Events/Messages
--- @desc The turn countdown event/message system allows client scripts to register a string script event or script message with the campaign manager. The campaign manager will then trigger the event or message at the start of turn for a given faction (or the start of a round if no faction was specified), a set number of turns later. This works even if the game is saved and reloaded. It is intended to be a secure mechanism for causing a scripted event/message to occur a number of turns in the future.
-----------------------------------------------------------------------------


--- @function add_turn_countdown_event
--- @desc Registers a turn countdown event. The supplied script event will be triggered after the specified number of turns has passed, when the <code>FactionTurnStart</code> event is received for the specified faction.
--- @p @string faction key, Key of the faction on whose turn start the event will be triggered.
--- @p @number turns, Number of turns from now to trigger the event.
--- @p @string event, Event to trigger. By convention, script event names begin with <code>"ScriptEvent"</code>
--- @p [opt=""] @string context string, Optional context string to trigger with the event.
function campaign_manager:add_turn_countdown_event(faction_name, turn_offset, event_name, context_str)
	if not is_string(faction_name) then
		script_error("ERROR: add_turn_countdown_event() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	-- if it's not the current faction's turn, then increase the turn_offset by 1, as when the faction starts their turn that will count
	if not self:is_factions_turn_by_key(faction_name) then
		turn_offset = turn_offset + 1;
	end;

	return self:add_absolute_turn_countdown_event(faction_name, turn_offset + self.game_interface:model():turn_number(), event_name, context_str);
end;


--- @function add_round_turn_countdown_event
--- @desc Registers a turn countdown event related to a round, rather than a faction. The supplied script event will be triggered after the specified number of turns has passed, when the <code>WorldStartRound</code> event is received.
--- @p @number turns, Number of turns from now to trigger the event.
--- @p @string event, Event to trigger. By convention, script event names begin with <code>"ScriptEvent"</code>
--- @p [opt=""] @string context string, Optional context string to trigger with the event.
function campaign_manager:add_round_turn_countdown_event(turn_offset, event_name, context_str)
	return self:add_absolute_turn_countdown_event(nil, turn_offset + self.game_interface:model():turn_number(), event_name, context_str);
end;


--- @function add_turn_countdown_event_on_event
--- @desc Registers a turn countdown event with @campaign_manager:add_turn_countdown_event when the supplied trigger event is received by script. Note that while the turn countdown event is saved into the savegame when triggered, the trigger event listener is not, so it will need to be re-established on script load.
--- @p [opt=nil] @string trigger event, Trigger event. When this event is received by script, the turn countdown event will be registered. If this is @nil or a blank string then the turn countdown event is registered immediately.
--- @p [opt=nil] @function condition, Condition that must be met when the trigger event is received, for the turn countdown event to be registered. If the value specified is <code>true</code> then no conditional check is performed and the turn countdown event will be registered as soon as the trigger event is received.
--- @p @string faction key, Key of the faction on whose turn start the event will be triggered.
--- @p @number turns, Number of turns from now to trigger the event.
--- @p @string event, Event to trigger. By convention, script event names begin with <code>"ScriptEvent"</code>
--- @p [opt=""] @string context string, Optional context string to trigger with the event.
function campaign_manager:add_turn_countdown_event_on_event(trigger_event, trigger_condition, faction_name, turn_offset, event_name, context_str)
	if is_string(trigger_event) and string.len(trigger_event) > 0 then
		-- a valid trigger event was supplied, so listen for it
		core:add_listener(
			"add_turn_countdown_event_on_event",
			trigger_event,
			trigger_condition,
			function() self:add_turn_countdown_event(faction_name, turn_offset, event_name, context_str) end,
			false
		);
	end;

	-- no valid trigger event was supplied, so just add the turn countdown event directly
	self:add_turn_countdown_event(faction_name, turn_offset, event_name, context_str);
end;


--- @function add_absolute_turn_countdown_event
--- @desc Registers a turn coutdown event to trigger on a specified absolute turn. The supplied script event will be triggered when the faction specified starts the supplied turn. If no faction is specified, the script event is triggered when the round starts for the supplied turn.
--- @p [opt=nil] @string faction key, Key of the faction on whose turn start the event will be triggered, from the <code>factions</code> database table. If no faction key is specified the event will be triggered when the round starts.
--- @p @number turns, Number of turns from now to trigger the event.
--- @p @string event, Event to trigger. By convention, script event names begin with <code>"ScriptEvent"</code>
--- @p [opt=""] @string context string, Optional context string to trigger with the event.
function campaign_manager:add_absolute_turn_countdown_event(faction_name, turn_to_trigger, event_name, context_str)
	if faction_name then
		if not is_string(faction_name) then
			script_error("ERROR: add_absolute_turn_countdown_event() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
			return false;
		end;
	end;
	
	if not is_number(turn_to_trigger) then
		script_error("ERROR: add_absolute_turn_countdown_event() called but supplied trigger turn [" .. tostring(turn_to_trigger) .. "] is not a number");
		return false;
	end;
	
	if not is_string(event_name) then
		script_error("ERROR: add_absolute_turn_countdown_event() called but supplied event name [" .. tostring(event_name) .. "] is not a string");
		return false;
	end;
	
	if not context_str then
		context_str = "";
	end;
	
	if not is_string(context_str) then
		script_error("ERROR: add_absolute_turn_countdown_event() called but supplied context string [" .. tostring(context_str) .. "] is not a string or nil");
		return false;
	end;

	local record = {};
	record.turn_to_trigger = turn_to_trigger;
	record.event_name = event_name;
	record.context_str = context_str;
	
	
	if faction_name and faction_name ~= "_" then
		-- if we have no sub-table for this faction then create it
		if not self.turn_countdown_events[faction_name] then
			self.turn_countdown_events[faction_name] = {};
		end;
		
		-- if we have no elements then start the listener
		if #self.turn_countdown_events[faction_name] == 0 then
			self:add_faction_turn_start_listener_by_name(
				"turn_start_countdown_event_" .. faction_name,
				faction_name,
				function(context)
					self:check_turn_countdown_events(context.string)
				end,
				true
			);
		end;
	else
		-- faction_name past this point is "_" and it will be treated separately
		faction_name = "_";

		-- if we have no sub-table for this faction then create it
		if not self.turn_countdown_events[faction_name] then
			self.turn_countdown_events[faction_name] = {};
		end;

		self:start_world_start_round_turn_countdown_listener();
	end;

	table.insert(self.turn_countdown_events[faction_name], record);
end;


-- Start the world start round listener in the turn countdown system, if it's not already started
function campaign_manager:start_world_start_round_turn_countdown_listener()
	if not self.turn_countdown_round_start_listener_active then
		self.turn_countdown_round_start_listener_active = true;

		core:add_listener(
			"turn_countdown_round_start_listener",
			"WorldStartRound",
			true,
			function()
				self:check_turn_countdown_events("_");
			end,
			true
		);
	end;
end;


-- Stop the world start round listener in the turn countdown system
function campaign_manager:stop_world_start_round_turn_countdown_listener()
	self.turn_countdown_round_start_listener_active = false;
	core:remove_listener("turn_countdown_round_start_listener");
end;




-- internal function to check turn countdown events this turn
function campaign_manager:check_turn_countdown_events(faction_name)
	local turn_countdown_events = self.turn_countdown_events[faction_name];

	if not is_table(turn_countdown_events) then
		script_error("WARNING: check_turn_countdown_events() called but could not find a table corresponding to given faction name [" .. faction_name .. "], how can this be?");
		return false;
	end;
	
	local turn_number = self.game_interface:model():turn_number();

	local events_to_trigger = {};

	for i = 1, #turn_countdown_events do
		local current_record = turn_countdown_events[i];
		
		if current_record.turn_to_trigger <= turn_number then
			table.insert(events_to_trigger, table.copy(current_record));
			current_record.remove = true;
		end;
	end;

	if #events_to_trigger > 0 then
		-- Rebuild our turn countdown events list
		local new_tce_list = {};
		for i = 1, #turn_countdown_events do
			if not turn_countdown_events[i].remove then
				table.insert(new_tce_list, turn_countdown_events[i]);
			end;
		end;

		self.turn_countdown_events[faction_name] = new_tce_list;

		-- Remove the faction turn start listener if we have nothing left to listen for
		if #new_tce_list == 0 then
			if faction_name == "_" then
				-- No faction is specified, so stop the WorldRoundStart listener
				self:stop_world_start_round_turn_countdown_listener();
			else
				self:remove_faction_turn_start_listener_by_name("turn_start_countdown_event_" .. faction_name);
			end;
		end;

		-- Trigger our events to trigger
		for i = 1, #events_to_trigger do
			local current_record = events_to_trigger[i];
			core:trigger_event(current_record.event_name, current_record.context_str);
		end;
	end;
end;


--- @function report_turns_until_countdown_event
--- @desc Reports the number of turns until the next turn countdown event matching the supplied criteria will trigger. 
--- @desc If a faction key is specified then turn countdown events related to that faction are considered, otherwise turn countdown events related to the start of round are considered.
--- @desc Any combination of script event name and context string must be supplied. Both may be specified, neither, or just one. If more than one matching turn countdown event is found then information about the next one to trigger will be returned. If no matching turn countdown event is found then @nil is returned.
--- @p [opt=nil] @string faction key, Faction key, from the <code>factions</code> database table. If no faction key is supplied then countdown events related to the start of round are considered.
--- @p [opt=nil] @string event name, Script event name to filter by.
--- @p [opt=nil] @string context string, Context string to filter by.
--- @r @number Number of turns until this turn countdown event is triggered
--- @r @number The absolute turn on which this turn countdown event is triggered
--- @r @string Script event that the turn countdown event will trigger
--- @r @string Context string that the turn countdown event will supply
function campaign_manager:report_turns_until_countdown_event(faction_name, event_name, context_str)
	if faction_name then
		if not is_string(faction_name) then
			script_error("ERROR: report_turns_until_countdown_event() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
			return false;
		end;
	else
		-- No faction name specified, consider the WorldStartRound turn countdown events
		faction_name = "_";
	end;

	local turn_countdown_events = self.turn_countdown_events[faction_name];

	if not turn_countdown_events or #turn_countdown_events == 0 then
		return;
	end;

	local eligible_records = {};

	for i = 1, #turn_countdown_events do
		if (not event_name or turn_countdown_events[i].event_name == event_name) and (not context_str or turn_countdown_events[i].context_str == context_str) then
			table.insert(eligible_records, turn_countdown_events[i]);
		end;
	end;

	if #eligible_records == 0 then
		return;
	end;

	table.sort(
		eligible_records, 
		function(first_record, second_record)
			return first_record.turn_to_trigger < second_record.turn_to_trigger;
		end
	);

	local record = eligible_records[1];

	-- return turns until trigger, absolute turn on which to trigger, event name and context str
	return record.turn_to_trigger - self.game_interface:model():turn_number(), record.turn_to_trigger, record.event_name, record.context_str;
end;


-- saving state of turn countdown events
function campaign_manager:turn_countdown_events_to_string()
	local state_str = "";
	
	out.savegame("turn_countdown_events_to_string() called");
	for faction_name, record_list in pairs(self.turn_countdown_events) do
		for i = 1, #record_list do
			local record = record_list[i];
	
			if faction_name == "_" then
				out.savegame("\tprocessing WorldStartRound records");
			else
				out.savegame("\tprocessing faction " .. faction_name);
			end;
			out.savegame("\t\trecord is " .. tostring(record));
			out.savegame("\t\trecord.turn_to_trigger is " .. tostring(record.turn_to_trigger));
			out.savegame("\t\trecord.event_name is " .. tostring(record.event_name));
			out.savegame("\t\trecord.context_str is " .. tostring(record.context_str));
		
			state_str = state_str .. faction_name .. "%" .. record.turn_to_trigger .. "%" .. record.event_name .. "%" .. record.context_str .. "%";
		end;
	end;
		
	return state_str;
end;


-- loading state of turn countdown events
function campaign_manager:turn_countdown_events_from_string(state_str)
	local pointer = 1;
	
	while true do
		local next_separator = string.find(state_str, "%", pointer);
		
		if not next_separator then
			break;
		end;
	
		local faction_name = string.sub(state_str, pointer, next_separator - 1);
		pointer = next_separator + 1;
		
		next_separator = string.find(state_str, "%", pointer);
		
		if not next_separator then
			script_error("ERROR: turn_countdowns_from_string() called but supplied string is malformed: " .. state_str);
			return false;
		end;
		
		local turn_to_trigger_str = string.sub(state_str, pointer, next_separator - 1);
		local turn_to_trigger = tonumber(turn_to_trigger_str);
		
		if not turn_to_trigger then
			script_error("ERROR: turn_countdowns_from_string() called but parsing failed, turns remaining number [" .. tostring(turn_to_trigger_str) .. "] couldn't be decyphered, string is " .. state_str);
			return false;
		end;
		
		pointer = next_separator + 1;
		
		next_separator = string.find(state_str, "%", pointer);
		
		if not next_separator then
			script_error("ERROR: turn_countdowns_from_string() called but supplied string is malformed: " .. state_str);
			return false;
		end;
		
		local event_name = string.sub(state_str, pointer, next_separator - 1);
		
		pointer = next_separator + 1;
		
		next_separator = string.find(state_str, "%", pointer);
		
		if not next_separator then
			script_error("ERROR: turn_countdowns_from_string() called but supplied string is malformed: " .. state_str);
			return false;
		end;
		
		local context_str = string.sub(state_str, pointer, next_separator - 1);
		
		pointer = next_separator + 1;
		
		self:add_absolute_turn_countdown_event(faction_name, turn_to_trigger, event_name, context_str);
	end;
end;


--- @function add_turn_countdown_message
--- @desc Registers a turn countdown script message. The supplied script message will be triggered after the specified number of turns has passed, when the <code>FactionTurnStart</code> event is received for the specified faction.
--- @desc See the @script_messager documentation for more information about script messages.
--- @p @string faction key, Key of the faction on whose turn start the event will be triggered, from the <code>factions</code> database table.
--- @p @number turns, Number of turns from now to trigger the event.
--- @p @string message, Message to trigger.
--- @p [opt=""] @string context string, Optional context string to trigger with the event.
--- @p [opt=false] @boolean is narrative message, Sets this message to be a narrative message. If this is set then the context string is actually a faction key, and will be exposed on the context supplied when the message is triggered in the way that the narrative system expects.
function campaign_manager:add_turn_countdown_message(faction_name, turn_offset, message, context_str, is_narrative_message)
	if not is_string(faction_name) then
		script_error("ERROR: add_turn_countdown_message() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	-- if it's not the current faction's turn, then increase the turn_offset by 1, as when the faction starts their turn that will count
	if not self:is_factions_turn_by_key(faction_name) then
		turn_offset = turn_offset + 1;
	end;

	return self:add_absolute_turn_countdown_message(faction_name, turn_offset + self.game_interface:model():turn_number(), message, context_str, is_narrative_message);
end;


--- @function add_absolute_turn_countdown_message
--- @desc Registers a turn coutdown message to trigger on a specified absolute turn. The supplied script message will be triggered when the faction specified starts the supplied turn.
--- @desc See the @script_messager documentation for more information about script messages.
--- @p @string faction key, Key of the faction on whose turn start the event will be triggered.
--- @p @number turns, Number of turns from now to trigger the event.
--- @p @string event, Event to trigger. By convention, script event names begin with <code>"ScriptEvent"</code>
--- @p [opt=""] @string context string, Optional context string to trigger with the event.
--- @p [opt=false] @boolean is narrative message, Sets this message to be a narrative message. If this is set then the context string is actually a faction key, and will be exposed on the context supplied when the message is triggered in the way that the narrative system expects.
function campaign_manager:add_absolute_turn_countdown_message(faction_name, turn_to_trigger, message, context_str, is_narrative_message)
	if not is_string(faction_name) then
		script_error("ERROR: add_absolute_turn_countdown_message() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	-- can only check that faction exists after the model is created
	if core:is_ui_created() then
		local faction = cm:get_faction(faction_name);
		
		if not faction then
			script_error("ERROR: add_absolute_turn_countdown_message() called but faction with supplied name [" .. faction_name .. "] could not be found");
			return false;
		end;
	end;
	
	if not is_number(turn_to_trigger) then
		script_error("ERROR: add_absolute_turn_countdown_message() called but supplied trigger turn [" .. tostring(turn_to_trigger) .. "] is not a number");
		return false;
	end;
	
	if not is_string(message) then
		script_error("ERROR: add_absolute_turn_countdown_message() called but supplied message [" .. tostring(message) .. "] is not a string");
		return false;
	end;
	
	if not context_str then
		context_str = "";
	end;
	
	if not is_string(context_str) then
		script_error("ERROR: add_absolute_turn_countdown_message() called but supplied context string [" .. tostring(context_str) .. "] is not a string or nil");
		return false;
	end;

	local record = {
		turn = turn_to_trigger,
		message = message,
		context_str = context_str,
		is_narr_msg = is_narrative_message
	};

	-- Read/create the turn countdown messages table of records
	local turn_countdown_messages = cm:get_saved_value("turn_countdown_messages") or {};

	-- if we have no sub-table for this faction then create it
	if not turn_countdown_messages[faction_name] then
		turn_countdown_messages[faction_name] = {};
	end;
	
	-- if we have no elements then start the listener
	if #turn_countdown_messages[faction_name] == 0 then
		self:add_faction_turn_start_listener_by_name(
			"turn_start_countdown_message_" .. faction_name,
			faction_name,
			function(context)
				self:check_turn_countdown_messages(context.string)
			end,
			true
		);
	end;
	
	table.insert(turn_countdown_messages[faction_name], record);

	-- Save this table back to the saved value system
	cm:set_saved_value("turn_countdown_messages", turn_countdown_messages);
end;


-- internal function to check turn countdown messages this turn
function campaign_manager:check_turn_countdown_messages(faction_name)
	local turn_countdown_messages = cm:get_saved_value("turn_countdown_messages");

	if not is_table(turn_countdown_messages) then
		script_error("WARNING: check_turn_countdown_messages() called but could not find any turn countdown messages in the saved value system, how can this be?");
		return false;
	end;

	local turn_countdown_messages_for_faction = turn_countdown_messages[faction_name];

	if not is_table(turn_countdown_messages_for_faction) then
		script_error("WARNING: check_turn_countdown_messages() called but could not find a table corresponding to given faction name [" .. faction_name .. "], how can this be?");
		return false;
	end;

	local turn_number = self.game_interface:model():turn_number();
	local messages_to_trigger = {};
		
	for i = 1, #turn_countdown_messages_for_faction do
		local current_record = turn_countdown_messages_for_faction[i];
		
		if current_record.turn <= turn_number then
			table.insert(messages_to_trigger, table.copy(current_record));
			current_record.remove = true;
		end;
	end;

	if #messages_to_trigger > 0 then
		-- Rebuild the turn_countdown_messages_for_faction table
		local new_tcm_list = {};

		for i = 1, #turn_countdown_messages_for_faction do
			if not turn_countdown_messages_for_faction[i].remove then
				table.insert(new_tcm_list, turn_countdown_messages_for_faction[i]);
			end;
		end;

		turn_countdown_messages[faction_name] = new_tcm_list;

		cm:set_saved_value("turn_countdown_messages", turn_countdown_messages);			-- probably not necessary

		-- Remove the faction turn start listener if we have nothing left to listen for
		if #new_tcm_list == 0 then
			core:remove_listener("turn_start_countdown_message_" .. faction_name);
		end;

		-- trigger each of our messages to trigger
		for i = 1, #messages_to_trigger do
			local current_record = messages_to_trigger[i];

			if current_record.is_narr_msg then
				out.narrative("");
				out.narrative("");
				out.narrative("Turn-countdown system is triggering message [" .. current_record.message .. "] for faction [" .. current_record.context_str .. "]");
				out.inc_tab("narrative");
				sm:trigger_message(current_record.message, {faction_key = current_record.context_str});
				out.dec_tab("narrative");
			else
				sm:trigger_message(current_record.message, {string = current_record.context_str});
			end;
		end;
	end;
end;


-- starting turn countdown message from savegame
function campaign_manager:start_turn_countdown_messages_from_savegame()
	local turn_countdown_messages = cm:get_saved_value("turn_countdown_messages");

	if not is_table(turn_countdown_messages) then
		return;
	end;

	for faction_name, turn_countdown_messages_for_faction in pairs(turn_countdown_messages) do
		if #turn_countdown_messages_for_faction > 0 then
			self:add_faction_turn_start_listener_by_name(
				"turn_start_countdown_message_" .. faction_name,
				faction_name,
				function(context)
					self:check_turn_countdown_messages(context.string);
				end,
				true
			);
		end;
	end;
end;







-----------------------------------------------------------------------------
--- @section Context Queries 
--- @desc Campaign wrappers for UI context queries, which can allow us to get access to information not otherwise available from script
-----------------------------------------------------------------------------

--- @function faction_has_campaign_feature
--- @desc Uses the context system to check if a faction has access to the specified campaign feature
--- @desc Valid feature keys can be found in the campaign_features database table
--- @p string faction key

function campaign_manager:faction_has_campaign_feature(faction_name, campaign_feature)

	if not is_string(faction_name) then
		script_error("ERROR: faction_has_campaign_feature() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;

	if not is_string(campaign_feature) then
		script_error("ERROR: faction_has_campaign_feature() called but supplied feature [" .. tostring(campaign_feature) .. "] is not a string");
		return false;
	end;
	
	if not cm:get_faction(faction_name) then 
		script_error("ERROR: faction_has_campaign_feature() called but supplied faction name [" .. tostring(faction_name) .. "] does not have a valid valid interface");
	end

	local faction_interface = cm:get_faction(faction_name);
	local cqi = faction_interface:command_queue_index();

	local has_feature = common.get_context_value("CcoCampaignFaction", cqi, "IsCampaignFeatureAvailable('"..campaign_feature.."')");

	return has_feature;

end;

--- @function faction_has_faction_feature
--- @desc Uses the context system to check if a faction has access to the specified faction feature 
--- @desc Valid feature keys can be found in the faction_features database table
--- @p string faction key
function campaign_manager:faction_has_faction_feature(faction_name, faction_feature)

	if not is_string(faction_name) then
		script_error("ERROR: faction_has_campaign_feature() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;

	if not is_string(faction_feature) then
		script_error("ERROR: faction_has_faction_feature() called but supplied feature [" .. tostring(faction_feature) .. "] is not a string");
		return false;
	end;

	if not cm:get_faction(faction_name) then 
		script_error("ERROR: faction_has_faction_feature() called but supplied faction name [" .. tostring(faction_name) .. "] does not have a valid valid interface");
	end
	
	local faction_interface = cm:get_faction(faction_name);
	local cqi = faction_interface:command_queue_index();

	local has_feature = common.get_context_value("CcoCampaignFaction", cqi, "IsFactionFeatureAvailable('"..faction_feature.."')");

	return has_feature;

end;



-----------------------------------------------------------------------------
--- @section Custom Battlefields
--- @desc These functions add, remove or clear custom battlefield records, which allow game scripts to override parts or all of the next battle to be fought. Custom battlefield records are saved in to the savegame, as the game code requires that records which modify the autoresolver result must remain active even after the campaign has loaded back in after battle. This can make managing the lifetime of custom battlefield records problematic.
--- @desc To assist with this management, the campaign manager will defer calls to @campaign_manager:add_custom_battlefield, @campaign_manager:remove_custom_battlefield and @campaign_manager:clear_custom_battlefields if a pending battle is active, and we are in the phase after the battle has been fought. It would not be valid to apply custom battle modifications at this time as they may tamper with the results of the battle just fought. Instead, they are deferred until that battle is completed, allowing the modifications to apply for subsequent battles.
-----------------------------------------------------------------------------


local function custom_battlefield_callback(callback)
	local pb_active, battle_fought = cm:is_pending_battle_active();

	if pb_active and (battle_fought or (cm:is_first_tick() and cm:get_saved_value("battle_being_fought"))) then
		-- We are in the post-battle phase of a battle being fought, so now is not the time to perform a custom battlefield action as the game might
		-- need the existing custom battlefield record setup still. We defer these calls until the BattleCompleted event is received.

		core:add_listener(
			"custom_battlefield_callback",
			"BattleCompleted",
			true,
			callback,
			false
		);
		return;
	end;

	-- If we are not in the post-battle sequence then proceed with calling the callback
	callback();
end;


--- @function add_custom_battlefield
--- @desc Adds a record which modifies or completely overrides a fought or autoresolved battle, if that battle happens within a certain supplied radius of a supplied campaign anchor position. Aspects of the battle may be specified, such as the loading screen and script to use, or the entire battle may be subsituted with an xml battle.
--- @desc If a pending battle sequence is already active, and the battle has been fought, then this call is deferred until after the battle is completed to avoid tampering with the running battle.
--- @p @string id, Id for this custom battle record. This may be used to later remove this override with @episodic_scripting:remove_custom_battlefield.
--- @p @number x, X logical co-ordinate of anchor position.
--- @p @number y, Y logical co-ordinate of anchor position.
--- @p @number radius, Radius around anchor position. If a battle is launched within this radius of the anchor position and it involves the local player, then the battle is modified/overridden.
--- @p @boolean dump campaign, If set to <code>true</code>, the battle makes no attempt to load back into this campaign after completion.
--- @p @string loading screen override, Key of a custom loading screen to use, from the <code>custom_loading_screens</code> table. A blank string may be supplied to not override the loading screen. This is ignored if the entire battle is overriden with a battle xml, as that may specify a loading screen override.
--- @p @string script override, Path to a script file to load with the battle, from the working data folder. A blank string may be supplied to not override the loading screen. This is ignored if the entire battle is overriden with a battle xml, as that may specify a script override.
--- @p @string whole battle override, Path to an battle xml file which overrides the whole battle.
--- @p @number human alliance, Sets the index of the human alliance, 0 or 1, if setting a battle xml to override the whole battle. If not setting a battle xml this number is ignored.
--- @p @boolean launch immediately, Launch the battle immediately without saving the campaign first.
--- @p @boolean is land battle, Sets whether the following battle is a land battle. This is only required if when launching the battle immediately.
--- @p @boolean force autoresolve result, If set to <code>true</code>, this forces the application of the autoresolver to the battle result after the battle, regardless of what happened in the battle itself. This is of most use for faking a battle result of an xml battle, which would otherwise return with no result.
function campaign_manager:add_custom_battlefield(...)
	custom_battlefield_callback(
		function()
			self.game_interface:add_custom_battlefield(unpack(arg));
		end
	);
end;


--- @function remove_custom_battlefield
--- @desc Removes a custom battle override previously set with @episodic_scripting:add_custom_battlefield.
--- @desc If a pending battle sequence is already active, and the battle has been fought, then this call is deferred until after the battle is completed to avoid tampering with the running battle.
--- @p @string id
function campaign_manager:remove_custom_battlefield(...)
	custom_battlefield_callback(
		function()
			self.game_interface:remove_custom_battlefield(unpack(arg));
		end
	);
end;


--- @function clear_custom_battlefields
--- @desc Removes all custom battle overrides previously set with @episodic_scripting:add_custom_battlefield.
--- @desc If a pending battle sequence is already active, and the battle has been fought, then this call is deferred until after the battle is completed to avoid tampering with the running battle.
function campaign_manager:clear_custom_battlefields(...)
	custom_battlefield_callback(
		function()
			self.game_interface:clear_custom_battlefields(unpack(arg));
		end
	);
end;

















-----------------------------------------------------------------------------
--	intervention manager
--	these functions are for intervention scripts and not for use by client scripts
-----------------------------------------------------------------------------

-- registering an intervention manager with the campaign manager
function campaign_manager:set_intervention_manager(im)
	self.intervention_manager = im;
end;

-- getting a registered intervention manager
function campaign_manager:get_intervention_manager()
	if self.intervention_manager then
		return self.intervention_manager;
	else
		return intervention_manager:new();
	end;
end;










-----------------------------------------------------------------------------
--	chapter mission registration
--	internal functions for chapter missions
-----------------------------------------------------------------------------

function campaign_manager:register_chapter_mission(ch)
	self.chapter_missions[ch.chapter_number] = ch;
end;


function campaign_manager:chapter_mission_exists_with_number(value)
	return not not self.chapter_missions[value];
end;














-----------------------------------------------------------------------------
--- @section Values Passed to Battle
--- @desc Prior to battle, the campaign manager saves certain data into the @"core:Scripted Value Registry" which can be accessed by battle scripts:
--- @desc <table class="simple"><tr><td><strong>Variable Name</strong></td><td><strong>Data Type</strong></td><td><strong>Description</strong></td></tr><tr><td><code>battle_type</code></td><td><code>string</code></td><td>The string battle type.</td></tr><tr><td><code>primary_attacker_faction_name</code></td><td><code>string</code></td><td>The faction key of the primary attacking army.</td></tr><tr><td><code>primary_attacker_subculture</code></td><td><code>string</code></td><td>The subculture key of the primary attacking army.</td></tr><tr><td><code>primary_defender_faction_name</code></td><td><code>string</code></td><td>The faction key of the primary defending army.</td></tr><tr><td><code>primary_defender_subculture</code></td><td><code>string</code></td><td>The subculture key of the primary defending army.</td></tr><tr><td><code>primary_attacker_is_player</code></td><td><code>boolean</code></td><td>Whether the local player is the primary attacker.</td></tr><tr><td><code>primary_defender_is_player</code></td><td><code>boolean</code></td><td>Whether the local player is the primary defender.</td></tr><tr><td><code>primary_attacker_is_female</code></td><td><code>boolean</code></td><td>Whether the primary attacker has a female lord.</td></tr><tr><td><code>primary_defender_is_female</code></td><td><code>boolean</code></td><td>Whether the primary defender has a female lord.</td></tr></table>
--- @desc These values can be accessed in battle scripts using @core:svr_load_string and @core:svr_load_bool.
-----------------------------------------------------------------------------


-- called by the pending battle cache system when the pending battle event occurs
function campaign_manager:set_pending_battle_svr_state(pb)
	
	local primary_attacker_faction_name = "";
	local primary_attacker_subculture = "";
	local primary_defender_faction_name = "";
	local primary_defender_subculture = "";
	local primary_attacker_is_female = false;
	local primary_defender_is_female = false;
	
	if pb:has_attacker() then
		primary_attacker_faction_name = pb:attacker():faction():name();
		primary_attacker_subculture = pb:attacker():faction():subculture();
		primary_attacker_is_female = pb:attacker():character_details():character_subtype_has_female_name();
	end;
	
	if pb:has_defender() then
		primary_defender_faction_name = pb:defender():faction():name();
		primary_defender_subculture = pb:defender():faction():subculture();
		primary_defender_is_female = pb:defender():character_details():character_subtype_has_female_name();
	end;
	
	core:svr_save_string("campaign_key_for_battle", self:get_campaign_name());
	core:svr_save_string("battle_type", pb:battle_type());
	core:svr_save_string("primary_attacker_faction_name", primary_attacker_faction_name);
	core:svr_save_string("primary_attacker_subculture", primary_attacker_subculture);
	core:svr_save_string("primary_defender_faction_name", primary_defender_faction_name);
	core:svr_save_string("primary_defender_subculture", primary_defender_subculture);
	core:svr_save_bool("primary_attacker_is_female", primary_attacker_is_female);
	core:svr_save_bool("primary_defender_is_female", primary_defender_is_female);
	
	-- only in sp
	if not self:is_multiplayer() then
		local local_faction_name = cm:get_local_faction_name();
		
		if primary_attacker_faction_name == local_faction_name then
			core:svr_save_bool("primary_attacker_is_player", true);
			core:svr_save_bool("primary_defender_is_player", false);
		elseif primary_defender_faction_name == local_faction_name then
			core:svr_save_bool("primary_attacker_is_player", false);
			core:svr_save_bool("primary_defender_is_player", true);
		else
			core:svr_save_bool("primary_attacker_is_player", false);
			core:svr_save_bool("primary_defender_is_player", false);
		end;
	end;
end;












-----------------------------------------------------------------------------
--- @section Region Change Monitor
--- @desc When started, a region change monitor stores a record of what regions a faction holds when their turn ends and compares it to the regions the same faction holds when their next turn starts. If the two don't match, then the faction has gained or lost a region and this system fires some custom script events accordingly to notify other script.
--- @desc If the monitored faction has lost a region, the event <code>ScriptEventFactionLostRegion</code> will be triggered at the start of that faction's turn, with the region lost attached to the context. Should the faction have gained a region during the end-turn sequence, the event <code>ScriptEventFactionGainedRegion</code> will be triggered, with the region gained attached to the context.
--- @desc Region change monitors are disabled by default, and have to be opted-into by client scripts with @campaign_manager:start_faction_region_change_monitor each time the scripts load.
-----------------------------------------------------------------------------


--- @function start_faction_region_change_monitor
--- @desc Starts a region change monitor for a faction.
--- @p string faction key
function campaign_manager:start_faction_region_change_monitor(faction_name)
	
	if not is_string(faction_name) then
		script_error("ERROR: start_faction_region_change_monitor() called but supplied name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	-- see if we already have listeners started for this faction (the data may be reinstated from the savegame)
	if not self.faction_region_change_list[faction_name] then
		self.faction_region_change_list[faction_name] = {};
	end;
	
	core:remove_listener("faction_region_change_monitor_" .. faction_name);
	
	self:add_faction_turn_start_listener_by_name(
		"faction_region_change_monitor_" .. faction_name,
		faction_name,
		function(context)
			self:faction_region_change_monitor_process_turn_start(context:faction())
		end,
		true
	);
	
	core:add_listener(
		"faction_region_change_monitor_" .. faction_name,
		"FactionTurnEnd",
		function(context) return context:faction():name() == faction_name end,
		function(context)
			self:faction_region_change_monitor_process_turn_end(context:faction())
		end,
		true
	);
	
	self:add_first_tick_callback(
		function() 
			self:faction_region_change_monitor_validate_on_load(faction_name);
		end
	);
end;


--- @function stop_faction_region_change_monitor
--- @desc Stops a running region change monitor for a faction.
--- @p string faction key
function campaign_manager:stop_faction_region_change_monitor(faction_name)
	if not is_string(faction_name) then
		script_error("ERROR: stop_faction_region_change_monitor() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	core:remove_listener("faction_region_change_monitor_" .. faction_name);
	self:remove_faction_turn_start_listener_by_name("faction_region_change_monitor_" .. faction_name);
	
	self.faction_region_change_list[faction_name] = nil;
end;


-- validates region change monitor saved data
function campaign_manager:faction_region_change_monitor_validate_on_load(faction_name)
	-- if it's currently this faction's turn then process the turn end - this means that the data will be current if loading from a savegame (or from a new game)
	if self:is_factions_turn_by_key(faction_name) then
		 self:faction_region_change_monitor_process_turn_end(cm:get_faction(faction_name));
	else
		-- validate that the cached region list contains valid data
		local cached_region_list = self.faction_region_change_list[faction_name];
		
		-- compare cached list to current list, to see if the subject faction has lost a region
		for i = 1, #cached_region_list do
			local current_cached_region = cached_region_list[i];
			
			if not cm:get_region(current_cached_region) then		
				script_error("WARNING: faction_region_change_monitor_validate_on_load() called but couldn't find region corresponding to key [" .. current_cached_region .. "] stored in cached region list - regenerating cached list");
				self:faction_region_change_monitor_process_turn_end(cm:get_faction(faction_name));
				return;
			end;
		end;
	end;
end;


-- called on turn end
function campaign_manager:faction_region_change_monitor_process_turn_end(faction)
	local faction_name = faction:name();
	local region_list = faction:region_list();
	
	-- rebuild the cached list of regions owned by this faction
	self.faction_region_change_list[faction_name] = {};

	for i = 0, region_list:num_items() - 1 do		
		table.insert(self.faction_region_change_list[faction_name], region_list:item_at(i):name());
	end;
end;


-- called on turn start
function campaign_manager:faction_region_change_monitor_process_turn_start(faction)
	local should_issue_grudge_messages = true;

	-- don't do anything on turn one or two
	if self:model():turn_number() <= 2 then
		should_issue_grudge_messages = false;
	end;

	local faction_name = faction:name();
	local region_list = faction:region_list();
		
	-- create a list of the regions the faction currently has
	local current_region_list = {};
	
	for i = 0, region_list:num_items(i) - 1 do
		table.insert(current_region_list, region_list:item_at(i):name());
	end;
	
	local cached_region_list = self.faction_region_change_list[faction_name];
	
	local regions_gained = {};
	local regions_lost = {};
	
	-- compare cached list to current list, to see if the subject faction has lost a region
	for i = 1, #cached_region_list do
		local current_cached_region = cached_region_list[i];
		local current_cached_region_found = false;
		
		if cm:get_region(current_cached_region) then		
			for j = 1, #current_region_list do
				if current_cached_region == current_region_list[j] then
					current_cached_region_found = true;
					break;
				end;
			end;
		
			if not current_cached_region_found then
				table.insert(regions_lost, current_cached_region);
			end;
		else
			script_error("WARNING: faction_region_change_monitor_process_turn_start() called but couldn't find region corresponding to key [" .. current_cached_region .. "] stored in cached region list - discarding cached list and using current");
			cached_region_list = current_region_list;
			regions_lost = {};
		end;
	end;
	
	-- compare current list to cached list, to see if the subject faction has gained a region
	for i = 1, #current_region_list do
		local current_region = current_region_list[i];
		local current_region_found = false;
		
		for j = 1, #cached_region_list do
			if current_region == cached_region_list[j] then
				current_region_found = true;
				break;
			end;
		end;
		
		if not current_region_found then
			table.insert(regions_gained, current_region);
		end;
	end;
	
	-- trigger script events for each region this faction has lost or gained
	if should_issue_grudge_messages then
		for i = 1, #regions_lost do
			core:trigger_event("ScriptEventFactionLostRegion", faction, cm:get_region(regions_lost[i]));
		end;
		
		for i = 1, #regions_gained do
			core:trigger_event("ScriptEventFactionGainedRegion", faction, cm:get_region(regions_gained[i]));
		end;
	end;
end;


-- saving game
function campaign_manager:faction_region_change_monitor_to_str()
	local savestr = "";
	
	for faction_name, region_table in pairs(self.faction_region_change_list) do
		savestr = savestr .. faction_name;
		
		for i = 1, #region_table do
			savestr = savestr .. "%" .. region_table[i];
		end;
		
		savestr = savestr .. ";";
	end;
	
	return savestr;
end;


-- loading game
function campaign_manager:faction_region_change_monitor_from_str(str)
	if str == "" then
		return;
	end;
	
	local pointer = 1;
	
	while true do
		local next_separator = string.find(str, ";", pointer);
		
		if not next_separator then	
			script_error("ERROR: faction_region_change_monitor_from_str() called but supplied string is malformed: " .. str);
			return false;
		end;
		
		local faction_str = string.sub(str, pointer, next_separator - 1);
		
		if string.len(faction_str) == 0 then
			script_error("ERROR: faction_region_change_monitor_from_str() called but supplied string contains a zero-length faction record: " .. str);
			return false;
		end;
		
		self:single_faction_region_change_monitor_from_str(faction_str);
		
		pointer = next_separator + 1;
		
		if pointer > string.len(str) then
			-- we have reached the end of the string
			return;
		end;
	end;
end;


function campaign_manager:single_faction_region_change_monitor_from_str(str)
	local pointer = 1;
	local next_separator = string.find(str, "%", pointer);
	
	if not next_separator then
		-- we have a faction with no regions, so just start the monitor
		self:start_faction_region_change_monitor(str);
		return;
	end;
	
	local faction_name = string.sub(str, pointer, next_separator - 1);
	
	-- create a record in the faction_region_change_list for this faction
	self.faction_region_change_list[faction_name] = {};
	
	local pointer = next_separator + 1;
	
	while true do
		next_separator = string.find(str, "%", pointer);
		
		if not next_separator then
			-- this is the last region in the string, so add it, start the monitor and then return
			table.insert(self.faction_region_change_list[faction_name], string.sub(str, pointer));
			self:start_faction_region_change_monitor(faction_name);
			return;
		end;
		
		table.insert(self.faction_region_change_list[faction_name], string.sub(str, pointer, next_separator - 1));
		
		pointer = next_separator + 1;
	end;
end;









-----------------------------------------------------------------------------
--- @section Miscellaneous Monitors
-----------------------------------------------------------------------------


--- @function find_lowest_public_order_region_on_turn_start
--- @desc Starts a monitor for a faction which, on turn start for that faction, triggers a event with the faction and the region they control with the lowest public order attached. This is useful for advice scripts that may wish to know where the biggest public order problems for a faction are. This function will need to be called by client scripts each time the script starts.
--- @desc The event triggered is <code>ScriptEventFactionTurnStartLowestPublicOrder</code>, and the faction and region may be returned by calling <code>faction()</code> and <code>region()</code> on the context object supplied with it.
--- @p string faction key
function campaign_manager:find_lowest_public_order_region_on_turn_start(faction_name)
	
	local faction = cm:get_faction(faction_name);
	
	if not faction then
		script_error("ERROR: find_lowest_public_order_region_on_turn_start() called but no faction with supplied name [" .. tostring(faction_name) .. "] could be found");
		return false;
	end;

	core:add_listener(
		"find_lowest_public_order_region_on_turn_start",
		"ScriptEventFactionTurnStart",
		function(context)
			return context:faction():name() == faction_name;
		end,
		function(context)
			local lowest_public_order = 200;
			local lowest_public_order_region = false;
			local faction = cm:get_faction(faction_name);
			local region_list = faction:region_list();
			
			-- find lowest public order
			for i = 0, region_list:num_items() - 1 do
				local current_region = region_list:item_at(i);
				local current_public_order = current_region:public_order();
				
				if current_public_order < lowest_public_order then
					lowest_public_order = current_public_order;
					lowest_public_order_region = current_region;
				end;
			end;
			
			if lowest_public_order_region then
				out("*** triggering ScriptEventFactionTurnStartLowestPublicOrder for " .. faction_name .. ", lowest_public_order_region is " .. lowest_public_order_region:name());
				core:trigger_event("ScriptEventFactionTurnStartLowestPublicOrder", faction, lowest_public_order_region);
			end;
		end,
		true	
	);
end;


--- @function generate_region_rebels_event_for_faction
--- @desc <code>RegionRebels</code> events are sent as a faction ends their turn but before the <code>FactionTurnEnd</code> event is received. If called, this function listens for <code>RegionRebels</code> events for the specified faction, then waits for the <code>FactionTurnEnd</code> event to be received and sends a separate event. This flow of events works better for advice scripts.
--- @desc The event triggered is <code>ScriptEventRegionRebels</code>, and the faction and region may be returned by calling <code>faction()</code> and <code>region()</code> on the context object supplied with it.
--- @p string faction key
function campaign_manager:generate_region_rebels_event_for_faction(faction_name)
	if not cm:get_faction(faction_name) then
		script_error("ERROR: generate_region_rebels_event_for_faction() called but couldn't find a faction with supplied name [" .. tostring(faction_name) .. "]");
		return false;
	end;
	
	core:add_listener(
		"region_rebels_event_for_faction",
		"RegionRebels",
		function(context) return context:region():owning_faction():name() == faction_name end,
		function(context)
		
			local region_name = context:region():name();
		
			-- a region has rebelled, listen for the FactionTurnEnd event and send the message then
			core:add_listener(
				"region_rebels_event_for_faction",
				"FactionTurnEnd",
				function(context) return context:faction():name() == faction_name end,
				function(context)
					core:trigger_event("ScriptEventRegionRebels", cm:get_faction(faction_name), cm:get_region(region_name));
				end,
				false
			);
		end,
		true
	)
end;


--- @function start_hero_action_listener
--- @desc This fuction starts a listener for hero actions committed against a specified faction and sends out further events based on the outcome of those actions. It is of most use for listening for hero actions committed against a player faction.
--- @desc This function called each time the script starts for the monitors to continue running. Once started, the function triggers the following events:
--- @desc <table class="simple"><tr><td><strong>Event Name</strong></td><td><strong>Context Functions</strong></td><td><strong>Description</strong></td></tr><tr><td><code>ScriptEventAgentActionSuccessAgainstCharacter</code></td><td><code>character</br>target_character</code></td><td>A foreign agent (<code>character</code>) committed a successful action against a character (<code>target_character</code>) of the subject faction.</td></tr><tr><td><code>ScriptEventAgentActionFailureAgainstCharacter</code></td><td><code>character</br>target_character</code></td><td>A foreign agent (<code>character</code>) failed when attempting an action against a character (<code>target_character</code>) of the subject faction.</td></tr><tr><td><code>ScriptEventAgentActionSuccessAgainstCharacter</code></td><td><code>character</br>garrison_residence</code></td><td>A foreign agent (<code>character</code>) committed a successful action against a garrison residence (<code>garrison_residence</code>) of the subject faction.</td></tr><tr><td><code>ScriptEventAgentActionFailureAgainstCharacter</code></td><td><code>character</br>garrison_residence</code></td><td>A foreign agent (<code>character</code>) failed when attempting an action against a garrison residence (<code>garrison_residence</code>) of the subject faction.</td></tr></table>
--- @p string faction key
function campaign_manager:start_hero_action_listener(faction_name)
	local faction = cm:get_faction(faction_name);
	
	if not faction then
		script_error("ERROR: start_hero_action_listener() called but couldn't find faction with specified name [" .. tostring(faction_name) .. "]");
		return false;
	end;

	local local_faction_name = self:get_local_faction_name();

	if local_faction_name then

		-- listen for hero actions committed against characters in specified faction
		core:add_listener(
			"character_character_target_action_" .. faction_name,
			"CharacterCharacterTargetAction",
			function(context)
				return context:target_character():faction():name() == local_faction_name and context:character():faction():name() ~= local_faction_name;
			end,
			function(context)
				if context:mission_result_critial_success() or context:mission_result_success() then
					core:trigger_event("ScriptEventAgentActionSuccessAgainstCharacter", context:character(), context:target_character());		-- first character is accessible at character() on context, second at target_character()
				else
					core:trigger_event("ScriptEventAgentActionFailureAgainstCharacter", context:character(), context:target_character());		-- first character is accessible at character() on context, second at target_character()
				end;
			end,
			true
		);
		
		-- listen for hero actions committed against characters in specified faction
		core:add_listener(
			"character_character_target_action_" .. faction_name,
			"CharacterGarrisonTargetAction",
			function(context)
				return context:garrison_residence():faction():name() == local_faction_name and context:character():faction():name() ~= local_faction_name;
			end,
			function(context)
				if context:mission_result_critial_success() or context:mission_result_success() then
					core:trigger_event("ScriptEventAgentActionSuccessAgainstGarrison", context:character(), context:garrison_residence());
				else
					core:trigger_event("ScriptEventAgentActionFailureAgainstGarrison", context:character(), context:garrison_residence());
				end;
			end,
			true
		);
	end;
end;











-----------------------------------------------------------------------------
--- @section Benchmark Scripts
-----------------------------------------------------------------------------


--- @function show_benchmark_if_required
--- @desc Shows a benchmark constructed from supplied parameters if benchmarking mode is active, otherwise calls a supplied callback which should continue the campaign as normal. The intention is for this to be called on or around the first tick, at a critical early point within the benchmark faction's script (each campaign benchmark being associated with a certain faction). If benchmark mode is currently set, this function plays the supplied cindy scene then quits the campaign. If benchmark mode is not set then the supplied callback is called - this should cause the campaign to continue as normal.
--- @desc An initial position for the camera prior to the cindy scene starting may be set with a set of five numerical arguments specifying camera co-ordinates. All five arguments must be supplied for the camera position to be used.
--- @desc A duration for the cindy scene may optionally be set. If a duration is not set then the 
--- @p function non-benchmark callback, Function to call if this campaign has not been loaded in benchmarking mode.
--- @p [opt=nil] @string cindy file, Cindy file to show for the benchmark.
--- @p [opt=nil] @number cam x, Start x position of camera.
--- @p [opt=nil] @number cam y, Start y position of camera.
--- @p [opt=nil] @number cam d, Start distance of camera.
--- @p [opt=nil] @number cam b, Start bearing of camera (in radians).
--- @p [opt=nil] @number cam h, Start height of camera.
--- @p [opt=nil] @number benchmark duration, Benchmark duration in seconds.
--- @example cm:add_first_tick_callback_sp_new(
--- @example 	function() 
--- @example 		cm:start_intro_cutscene_on_loading_screen_dismissed(
--- @example 			function()
--- @example 				-- Either show benchmark and exit, or continue with campaign load as normal
--- @example 				cm:show_benchmark_if_required(
--- @example 					function() cutscene_intro_play() end,
--- @example 					"script/benchmarks/scenes/campaign_benchmark.CindyScene",
--- @example 					348.7,
--- @example 					330.9,
--- @example 					10,
--- @example 					0,
--- @example 					10,
--- @example 					92.83
--- @example 				);
--- @example 			end
--- @example 		);
--- @example 	end
--- @example );
function campaign_manager:show_benchmark_if_required(non_benchmark_callback, cindy_str, start_x, start_y, start_d, start_b, start_h, duration)

	if not is_function(non_benchmark_callback) then
		script_error("ERROR: show_benchmark_if_required() called but supplied callback [" .. tostring(non_benchmark_callback) .. "] is not a function");
		return false;
	end;
	
	if cindy_str and (not is_string(cindy_str)) then
		script_error("ERROR: show_benchmark_if_required() called but supplied cindy path [" .. tostring(cindy_str) .. "] is not a string");
		return false;
	end;
		
	if start_x and (not is_number(start_x) or start_x <= 0) then
		script_error("ERROR: show_benchmark_if_required() called but supplied start x co-ordinate [" .. tostring(start_x) .. "] is not a number greater than zero");
		return false;
	end;
	
	if start_y and (not is_number(start_y) or start_y <= 0) then
		script_error("ERROR: show_benchmark_if_required() called but supplied start y co-ordinate [" .. tostring(start_y) .. "] is not a number greater than zero");
		return false;
	end;
	
	if start_d and (not is_number(start_d) or start_d <= 0) then
		script_error("ERROR: show_benchmark_if_required() called but supplied start d co-ordinate [" .. tostring(start_d) .. "] is not a number greater than zero");
		return false;
	end;
	
	if start_b and (not is_number(start_b)) then
		script_error("ERROR: show_benchmark_if_required() called but supplied start b co-ordinate [" .. tostring(start_b) .. "] is not a number");
		return false;
	end;
	
	if start_h and (not is_number(start_h) or start_h <= 0) then
		script_error("ERROR: show_benchmark_if_required() called but supplied start h co-ordinate [" .. tostring(start_h) .. "] is not a number greater than zero");
		return false;
	end;

	if duration and (not is_number(duration) or duration <= 0) then
		script_error("ERROR: show_benchmark_if_required() called but supplied duration [" .. tostring(duration) .. "] is not a number greater than zero or nil");
		return false;
	end;

	if not self:is_benchmark_mode() then
		-- don't do benchmark camera pan
		non_benchmark_callback();
		return;
	end;

	if CampaignUI.IsMinimalViewModeEnabled() then
		script_error("ERROR: An attempt is being made to run a benchmark but minimal view is enabled - this isn't supported. Your game is about to crash - disable minimal view and try again");
	end;

	-- set up an exit callback
	local function exit_benchmark()
		out("*** Benchmark script: exit_benchmark() called");
		local ui_root = core:get_ui_root();
		ui_root:UnLockPriority();
		ui_root:InterfaceFunction("QuitForScript");
	end;
	
	-- if a duration has been supplied then set up a callback over time
	if duration then
		self:callback(
			exit_benchmark,
			duration
		);
	end;
	
	out("*******************************************************************************");
	out("show_benchmark_if_required() is showing benchmark");
	if cindy_str then
		out("Showing cindy scene: " .. cindy_str .. (duration and (" with duration " .. tostring(duration)) or ""));
		-- listen for a cindyscene finishing in any case
		core:add_listener(
			"benchmark_cutscene_end",
			"CinematicTrigger",
			function(context)
				local str = context.string;
				out("");
				out("*** Benchmark script: CinematicTrigger [" .. str .. "] received");
				return str == "end_cinematic"
			end,
			exit_benchmark,
			false
		);
	else
		out("No cindy scene provided. Will not play cindy scene. Benchmark will end automatically in 30 seconds ...");
		self:callback(exit_benchmark, 30, "benchmark_without_cutscene_end");
	end
	out("*******************************************************************************");
	
	local ui_root = core:get_ui_root();
	
	if start_x and start_y and start_d and start_b and start_h then
		self:set_camera_position(start_x, start_y, start_d, start_b, start_h);
	end;

	core:progress_on_loading_screen_dismissed(
		function()
			self:show_shroud(false);
			CampaignUI.ToggleCinematicBorders(true);
			ui_root:LockPriority(50)
			self:override_ui("disable_settlement_labels", true);
			if cindy_str then
				self:cindy_playback(cindy_str, 0, 0);
			end;
		end
	);
end;








-----------------------------------------------------------------------------
--- @section Serialised Army State
--- @desc The functions in this section allow scripts to save or apply a serialised state from the @scriptedvalueregistry, across campaign and battle. This allows battle script to apply health values to units that were set in campaign, or vice-versa. This is chiefly useful for scripted battles that are launched from campaign but are logically actually nothing to do with that campaign, such as a tutorial battle xml loaded from a campaign as if it was a campaign-generated battle. Using this functionality the battle scripts would be able to spoof the approximate health of the army as if it were coming from campaign, and then pass it back to campaign on battle completion.
--- @desc Campaign scripts can use @campaign_manager:save_army_state_to_svr and @campaign_manager:load_army_state_from_svr to save and load army states, and in battle @script_units:save_state_to_svr and @script_units:load_state_from_svr can be used to do the same.
--- @desc Note that at present this only serialises the health state of units and not their experience, items carried etc.
-----------------------------------------------------------------------------


--- @function serialise_army_state
--- @desc Returns a @string which represents the serialised state of the military force specified by the supplied military force cqi. This does not embody the full model state of the units but only selected information. It is mainly intended for use by @campaign_manager:save_army_state_to_svr which will save the returned string into the @scriptedvalueregistry.
--- @p @number mf cqi
--- @r @string serialised state
function campaign_manager:serialise_army_state(mf_cqi)
	if not is_number(mf_cqi) then
		script_error("serialise_army_state() called but supplied military force cqi [" .. tostring(mf_cqi) .. "] is not a number");
		return false;
	end;

	if not cm:model():has_military_force_command_queue_index(mf_cqi) then
		script_error("serialise_army_state() called but no military force with supplied military force cqi [" .. tostring(mf_cqi) .. "] could be found");
		return false;
	end;

	local unit_list = cm:model():military_force_for_command_queue_index(mf_cqi):unit_list();

	local table_to_serialise = {};

	for i = 0, unit_list:num_items() - 1 do
		local current_unit = unit_list:item_at(i);
		table.insert(
			table_to_serialise,
			{
				type = current_unit:unit_key(),
				unary_hp = current_unit:percentage_proportion_of_full_strength() / 100
			}
		);
	end;

	return table.tostring(table_to_serialise, true);
end;


--- @function save_army_state_to_svr
--- @desc Saves a @string which represents the serialised state of the military force specified by the supplied military force cqi to the @scriptedvalueregistry. @campaign_manager:serialise_army_state is used to generate the state string, and @core:svr_save_string is used to save the string. This string can then be loaded by @script_units:load_state_from_svr, allowing scripted battles loaded from a campaign, but not logically related to that campaign (e.g. an xml battle) to spoof the starting state of a battle army to be approximately the same as it was in the campaign.
--- @p @number mf cqi
--- @p @string name, Name for this svr entry, to be passed to @core:svr_save_string.
function campaign_manager:save_army_state_to_svr(name, mf_cqi)
	if not is_string(name) then
		script_error(self.name .. " ERROR: save_army_state_to_svr() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	local table_str = "return " .. self:serialise_army_state(name, true);
	out("* save_army_state_to_svr() has serialised state of military force with cqi [" .. mf_cqi .. "] to string with name [" .. name .. "], string is " .. table_str);
	core:svr_save_string(name, table_str);
end;


--- @function load_army_state_from_svr
--- @desc Checks for a @scriptedvalueregistry string with the supplied name, and attempts to apply the health values it contains to the units in the military force specified by the supplied cqi. These svr strings would be set by either @campaign_manager:save_army_state_to_svr in campaign or @script_units:save_state_to_svr in battle.
--- @desc This is primarily intended to spoof casualties on a campaign army that is coming back from battle, but where the army in battle is not logically related to the army in campaign (such as when loading back from a scripted xml battle).
--- @desc The function returns whether the application was successful. A successful application is one that modifies all units in the military force (a "modification" from 100% health to 100% health would count), unless the <code>allow_partial</code> flag is set, in which case even a partial application would be considered successful. If the application is not successful then no changes are applied. Output is generated in all cases.
--- @p @string name, Name of string saved in the @scriptedvalueregistry.
--- @p @number mf cqi, CQI of military force to apply state to.
--- @p [opt=false] @boolean allow partial, Allow a partial application of the state string. If this is set to <code>true</code then the application will be successful even if not all units in the military force end up being touched.
--- @r @boolean state was applied successfully
function campaign_manager:load_army_state_from_svr(name, mf_cqi, allow_partial)
	if not is_string(name) then
		script_error(self.name .. " ERROR: load_army_state_from_svr() called but supplied name [" .. tostring(name) .. "] is not a string");
		return false;
	end;

	if not is_number(mf_cqi) then
		script_error(self.name .. " ERROR: load_army_state_from_svr() called but supplied military force cqi [" .. tostring(mf_cqi) .. "] is not a number");
		return false;
	end;

	if not self:model():has_military_force_command_queue_index(mf_cqi) then
		script_error("load_army_state_from_svr() called but no military force with supplied military force cqi [" .. tostring(mf_cqi) .. "] could be found");
		return false;
	end;

	local svr_str = core:svr_load_string(name);

	if not svr_str then
		bm:out(self.name .. ":load_army_state_from_svr() did not apply state with name [" .. name .. "] as no such scripted value registry string could be found");
		return false;
	end;

	local table_func = loadstring(svr_str);
	if not is_function(table_func) then
		bm:out(self.name .. ":load_army_state_from_svr() did not apply state with name [" .. name .. "] as the scripted value registry string [" .. svr_str .. "] could not be converted into a function");
		return false;
	end;

	local t = table_func();
	if not is_table(t) then
		bm:out(self.name .. ":load_army_state_from_svr() did not apply state with name [" .. name .. "] as the function generated by scripted value registry string [" .. svr_str .. "] did not return a table");
		return false;
	end;

	local unit_list = self:model():military_force_for_command_queue_index(mf_cqi):unit_list();
	local unit_list_shadow = {};			-- a table to sit alongside the userdata unit_list, on which we can store svr_new_hp values

	-- go through our derived table and set new hp values in our unit_list_shadow table, to be applied to the actual units later
	for i = 1, #t do
		local current_unit_record = t[i];
		if current_unit_record.type then
			for j = 0, unit_list:num_items() - 1 do
				local current_mf_unit_key = unit_list:item_at(j):unit_key();
				if (not unit_list_shadow[j] or not unit_list_shadow[j].svr_new_hp) and current_unit_record.type == current_mf_unit_key then
					unit_list_shadow[j] = {
						svr_new_hp = current_unit_record.unary_hp
					};
					break;
				end;
			end;
		end;
	end;

	-- check that all units in the script_units collection have been touched
	local untouched_units = {};
	for i = 0, unit_list:num_items() - 1 do
		if not unit_list_shadow[i] or not unit_list_shadow[i].svr_new_hp then
			local unit = unit_list:item_at(i);
			table.insert(
				untouched_units, 
				{
					index = i,
					cqi = unit:command_queue_index(),
					unit_key = unit:unit_key()
				}
			);
		end;
	end;

	-- if not all sunits are touched and the allow_partial flag is not set then clear up our flags and abort
	if not allow_partial and #untouched_units > 0 then
		out("load_army_state_from_svr() did not apply state with name [" .. name .. "] to military force with cqi [" .. mf_cqi .. "] as the following units in this force were not touched by the scripted value registry string [" .. svr_str .. "], and the allow_partial flag is not set");
		out("units that weren't touched:");
		for i = 1, #untouched_units do
			out("\tindex in army: " .. untouched_units[i].index .. ", cqi: " .. untouched_units[i].cqi .. ", unit key: " .. untouched_units[i].unit_key);
		end;
		return false;
	end;

	-- apply the changes
	for i = 0, unit_list:num_items() - 1 do
		if unit_list_shadow[i] and unit_list_shadow[i].svr_new_hp then
			self:set_unit_hp_to_unary_of_maximum(unit_list:item_at(i), unit_list_shadow[i].svr_new_hp);
		end;
	end;

	if #untouched_units == 0 then
		out("load_army_state_from_svr() applied state with name [" .. name .. "] to military force with cqi [" .. mf_cqi .. "], scripted value registry string was [" .. svr_str .. "]");
	else
		out(self.name .. ":load_army_state_from_svr() applied state with name [" .. name .. "] to military force with cqi [" .. mf_cqi .. "] despite the following units not being touched. Scripted value registry string was [" .. svr_str .. "]");
		out("units that weren't touched:");
		for i = 1, #untouched_units do
			out("\tindex in army: " .. untouched_units[i].index .. ", cqi: " .. untouched_units[i].cqi .. ", unit key: " .. untouched_units[i].unit_key);
		end;
	end;
	
	return true;
end;


function campaign_manager:break_if_in_debugger()
	CampaignUI.BreakIfInDebugger();
end;
