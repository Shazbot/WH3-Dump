

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	NARRATIVE SYSTEM
--
--	PURPOSE
--	This file contains the narrative table, with definition of its utility functions that power the narrative
--	system.
--
--	LOADED
--	This file is loaded by wh3_narrative_loader.lua, which in turn should be loaded by the per-campaign narrative 
--	script file. It should get loaded on start of script.
--	
--	AUTHORS
--	SV
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- Common string to prepend shared narrative events.
shared_narrative_event_prepend_str = "wh3_main_camp_narrative";


--- @set_environment campaign

--- @data_interface narrative Narrative
--- @function_separator .
--- @desc The narrative table contains data and functions that help drive the narrative system.


--- @section At A Glance

--- @desc <ol><li>The narrative table is created when this file is loaded.</li>
--- @desc <li>Data setup callbacks are added to the narrative system as scripts are loaded using calls to @narrative:add_data_setup_callback.</li>
--- @desc <li>These data setup callbacks contain calls to functions that set up narrative override data, such as @narrative:add_playable_faction, @narrative:add_data_for_faction and @narrative:add_data_for_campaign.</li>
--- @desc <li>These data setup callbacks contain calls to functions that set up narrative override data, such as @narrative:add_playable_faction, @narrative:add_data_for_faction and @narrative:add_data_for_campaign.</li>
narrative = {};

narrative.faction_data = {};
narrative.campaign_data = {};

narrative.data_setup_callbacks = {};
narrative.loaders = {};
narrative.loaders_for_faction = {};
narrative.loaders_for_culture = {};
narrative.loaders_for_subculture = {};

--adding factions to this allows them to skip some narrative missions
narrative.exception_factions = {};






--- @section Data Setup Callbacks
--- @desc Data setup callbacks for the narrative system may be added with @narrative:add_data_setup_callback. Callbacks added with this function are not called until @narrative:start is called, which doesn't happen until the first tick. This structure allows narrative data to be added as scripts are loaded (potentially before the model is loaded) and only quer


--- @function add_data_setup_callback
--- @desc Adds a callback which sets up data for the narrative system. The callback can make calls to functions such as @narrative:add_playable_faction and @narrative:add_data_for_faction to set up narrative override data.
--- @desc Callbacks added here will be called when @narrative:start is called.
--- @p @function callback
function narrative.add_data_setup_callback(callback)
	if not validate.is_function(callback) then
		return false;
	end;

	table.insert(narrative.data_setup_callbacks, callback);
end;










--- @section Adding Data


--- @function add_playable_faction
--- @desc Adds a playable faction, by key, to the narrative data. Calls to this function should be made within setup functions that are passed to @narrative:add_data_setup_callback.
--- @desc Factions will need to be added to the narrative data with this function before any data can be added for them with @narrative:add_data_for_faction.
--- @p @string faction key
function narrative.add_playable_faction(faction_key)
	narrative.faction_data[faction_key] = {};
	out.narrative("Added faction " .. faction_key);
end;

--- @function add_exception_faction
--- @desc Adds a playable faction, by key, to the narrative exception faction list data. Calls to this function should be made within setup functions that are passed to @narrative:add_data_setup_callback.
--- @desc Factions will need to be added to the exception list to skip some elements of the narrative data.
--- @p @string faction key
function narrative.add_exception_faction(faction_key)
	narrative.exception_factions[faction_key] = {};
	out.narrative("Added exception faction " .. faction_key);
end;

--- @function add_data_for_faction
--- @desc Adds a data override for a faction within the narrative system. Factions must have been added with @narrative:add_playable_faction before data overrides can be added for them.
--- @desc If @narrative:get is later called and the faction and data keys supplied to it match a data override, then the data associated with that override is returned. This can be used to override data keys for specific factions.
--- @desc Calls to @narrative:get should be made within the narrative event declarations.
--- @p @string faction key
--- @p @string data key
--- @p value data
function narrative.add_data_for_faction(faction_key, data_key, data)

	if not validate.is_string(faction_key) then
		return false;
	end;

	if not validate.is_string(data_key) then
		return false;
	end;

	if not is_table(narrative.faction_data) then
		script_error("ERROR: add_data_for_faction() called but narrative faction data does not exist - ensure that create_base_faction_data() is called before trying to add any data");
		return false;
	end;

	if not narrative.faction_data[faction_key] then
		script_error("ERROR: narrative.add_data_for_faction() called but faction with key [" .. tostring(faction_key) .. "] has not been added to the narrative faction data. Either the key is wrong (check case/typos), or make sure that add_playable_faction() is called for this faction in narrative.create_base_faction_data()");
		return false;
	end;

	narrative.faction_data[faction_key][data_key] = data;
end;


--- @function add_data_for_campaign
--- @desc Adds a data override for a particular data key to the narrative system. This override is for all playable factions in the campaign, rather than any specific faction.
--- @desc If @narrative:get is later called and the data key supplied to it matches the campaign data override, then the data associated with that override is returned by @narrative:get. Note that faction data overrides added with @narrative:add_data_for_faction are checked before campaign-wide overrides.
function narrative.add_data_for_campaign(data_key, data)

	if not validate.is_string(data_key) then
		return false;
	end;

	narrative.campaign_data[data_key] = data;
end;













--- @function add_loader
--- @desc Adds a narrative event loader callback. When the narrative system is started with @narrative:start, each loader function is called for each human-controlled faction in the campaign, with the faction key supplied to that function as a single argument. In a multiplayer game, each loader function will be called multiple times.
--- @p @function loader
function narrative.add_loader(callback)

	if not validate.is_function(callback) then
		return false;
	end;

	table.insert(narrative.loaders, callback);
end;


--- @function add_loader_for_faction
--- @desc Adds a narrative event loader callback for a specific faction. If the subject faction is controlled by a human when the narrative system is started with @narrative:start this loader function will be called with the faction key supplied as a single argument.
--- @p @string faction key
--- @p @function loader
function narrative.add_loader_for_faction(faction_key, callback)

	if not validate.is_string(faction_key) then
		return false;
	end;

	if not validate.is_function(callback) then
		return false;
	end;

	if not narrative.loaders_for_faction[faction_key] then
		narrative.loaders_for_faction[faction_key] = {};
	end;

	table.insert(narrative.loaders_for_faction[faction_key], callback);
end;


--- @function add_loader_for_culture
--- @desc Adds a narrative event loader callback for a specific culture. When the narrative system is started with @narrative:start, for each human-controlled faction that matches the supplied culture, this loader function will be called with the faction key supplied as a single argument.
--- @p @string culture key
--- @p @function loader
function narrative.add_loader_for_culture(culture_key, callback)

	if not validate.is_string(culture_key) then
		return false;
	end;

	if not validate.is_function(callback) then
		return false;
	end;

	if not narrative.loaders_for_culture[culture_key] then
		narrative.loaders_for_culture[culture_key] = {};
	end;

	table.insert(narrative.loaders_for_culture[culture_key], callback);
end;


--- @function add_loader_for_subculture
--- @desc Adds a narrative event loader callback for a specific subculture. When the narrative system is started with @narrative:start, for each human-controlled faction that matches the supplied subculture, this loader function will be called with the faction key supplied as a single argument.
--- @p @string subculture key
--- @p @function loader
function narrative.add_loader_for_subculture(subculture_key, callback)

	if not validate.is_string(subculture_key) then
		return false;
	end;

	if not validate.is_function(callback) then
		return false;
	end;

	if not narrative.loaders_for_subculture[subculture_key] then
		narrative.loaders_for_subculture[subculture_key] = {};
	end;

	table.insert(narrative.loaders_for_subculture[subculture_key], callback);
end;











--- @section Starting


--- @function start
--- @desc Calls all setup and loader functions associated with the narrative system, setting up all data.
function narrative.start()

	-- SCRIPTED_TWEAKER_30 :: disable all narrative events and campaign advice triggers
	-- SCRIPTED_TWEAKER_31 :: disable narrative events
	if core:is_tweaker_set("SCRIPTED_TWEAKER_30") then
		script_error("INFO: not starting narrative events as SCRIPTED_TWEAKER_30 is set, disabling narrative events and campaign advice triggers");
		return;
	elseif core:is_tweaker_set("SCRIPTED_TWEAKER_31") then
		script_error("INFO: not starting narrative events as SCRIPTED_TWEAKER_31 is set, disabling narrative events");
		return;		
	end;

	if #narrative.data_setup_callbacks == 0 then
		script_error("WARNING: narrative.start() called but no narrative data callbacks have been added - nothing will be set up");
		return false;
	end;

	-- Copy the setup and loader tables to prevent any problems with callbacks adding more stuff while we're in the middle of our loops
	local setup_callbacks = table.copy(narrative.data_setup_callbacks);

	local separator = "***************************************************************************************************";

	out.narrative("");
	out.narrative(separator);
	out.narrative("narrative.start() creating faction and campaign data");
	out.inc_tab("narrative");

	-- Call all setup callbacks
	for i = 1, #setup_callbacks do
		setup_callbacks[i]();
	end;

	out.dec_tab("narrative");
	out.narrative("");
	out.narrative(separator);
	out.narrative("");
	out.narrative("");

	local loader_callbacks = table.copy(narrative.loaders);
	local human_factions = cm:get_human_factions();
	
	out.narrative(separator);
	out.narrative("narrative.start() is loading narrative events for human-controlled faction" .. (#human_factions == 1 and "" or "s") .. " [" .. table.concat(human_factions, ", ") .. "]");
	out.inc_tab("narrative");

	-- Call each non-faction-specific loader function for each human-controlled faction in the campaign, and call each culture/faction-specific loader if that faction is human-controlled
	for i = 1, #human_factions do
		local faction_key = human_factions[i];
		local faction = cm:get_faction(faction_key);

		if faction then
			local faction_data = narrative.faction_data[faction_key];

			if faction_data then
				-- Call general loaders
				for j = 1, #loader_callbacks do
					loader_callbacks[j](faction_key);
					out.narrative("");
				end;

				-- Call culture-specific loaders
				local culture_key = faction:culture();
				if narrative.loaders_for_culture[culture_key] then
					local loaders_for_culture = table.copy(narrative.loaders_for_culture[culture_key]);
					
					for j = 1, #loaders_for_culture do
						loaders_for_culture[j](faction_key);
						out.narrative("");
					end;
				end;

				-- Call subculture-specific loaders
				local subculture_key = faction:subculture();
				if narrative.loaders_for_subculture[subculture_key] then
					local loaders_for_subculture = table.copy(narrative.loaders_for_subculture[subculture_key]);
					
					for j = 1, #loaders_for_subculture do
						loaders_for_subculture[j](faction_key);
						out.narrative("");
					end;
				end;

				-- Call faction-specific loaders
				if narrative.loaders_for_faction[faction_key] then
					local loaders_for_faction = table.copy(narrative.loaders_for_faction[faction_key]);
					
					for j = 1, #loaders_for_faction do
						loaders_for_faction[j](faction_key);
						out.narrative("");
					end;
				end;
			else
				script_error("WARNING: narrative.start() could not find faction data in the narrative setup for faction [" .. faction_key .. "] - it needs adding. Not starting any narrative events for this faction.");
			end;
		end;
	end;

	out.dec_tab("narrative");
	out.narrative("");
	out.narrative(separator);
	out.narrative("");
end;










--- @section Data Retrieval


--- @function get
--- @desc Gets a data override for the specified faction key and data key, if one exists. Faction data registered with @narrative:add_data_for_faction will be checked first, then campaign data registered with @narrative:add_data_for_campaign.
--- @p @string faction key
--- @p @string data key
--- @r value data
function narrative.get(faction_key, data_key)
	return (narrative.faction_data[faction_key] and narrative.faction_data[faction_key][data_key]) or narrative.campaign_data[data_key];
end;










--- @section Output


--- @function output_chain_header
--- @desc Helper function which produces header output for a narrative chain when it's loaded.
--- @p @string chain name
--- @p @string faction key
function narrative.output_chain_header(narrative_chain_name, faction_key)
	out.narrative("");
	out.narrative("Starting " .. tostring(narrative_chain_name) .. " narrative chain for faction [" .. tostring(faction_key) .. "]");
	out.inc_tab("narrative");
end;


--- @function output_chain_footer
--- @desc Helper function which produces footer output for a narrative chain when it's loaded.
function narrative.output_chain_footer()
	out.dec_tab("narrative");
	out.narrative("");
end;


--- @function unimplemented_output
--- @desc Helper function which prints output about unimplemented narrative chains.
--- @p @string message
function narrative.unimplemented_output(msg)
	out.narrative("");
	out.narrative("*****************************************************");
	out.narrative("* Unimplemented narrative event(s): " .. msg);
	out.narrative("*****************************************************");
	out.narrative("");
end;


--- @function todo_output
--- @desc Helper function which prints output about narrative improvements to do.
--- @p @string message
function narrative.todo_output(msg)
	out.narrative("");
	out.narrative("\t*** TODO: " .. msg);
	out.narrative("");
end;
