

-----------------------------------------------------------------------------------------------------------
-- MODULAR SCRIPTING FOR MODDERS
-----------------------------------------------------------------------------------------------------------
-- The following allows modders to load their own script files without editing any existing game scripts
-- This allows multiple scripted mods to work together without one preventing the execution of another
--
-- Issue: Two modders cannot use the same existing scripting file to execute their own scripts as one
-- version of the script would always overwrite the other preventing one mod from working
--
--
-- The following scripting loads all scripts within a "mod" folder of each campaign and then executes
-- a function of the same name as the file (if one such function is declared)
-- Onus is on the modder to ensure the function/file name is unique which is fine
--
-- Example: The file "data/script/campaign/wh2_main_great_vortex/mod/cool_mod.lua" would be loaded and
-- then any function by the name of "cool_mod" will be run if it exists (sort of like a constructor)
--
-- ~ Mitch 18/10/17
-----------------------------------------------------------------------------------------------------------


--- @set_environment battle
--- @set_environment campaign
--- @set_environment frontend


----------------------------------------------------------------------------
---	@section Mod Output
----------------------------------------------------------------------------


--- @function ModLog
--- @desc Writes output to the <code>lua_mod_log.txt</code> text file, and also to the game console.
--- @p @string output text
local logfile_made = false;
local logging_disabled = false;
local log_filename = "lua_mod_log.txt";

function ModLog(text)
	out(text);

	if not logging_disabled then
		if not logfile_made then
			logfile_made = true;
			local log_interface = io.open(log_filename, "w");
			if log_interface then
				log_interface:write(text.."\n");
				log_interface:flush();
				log_interface:close();
			else
				script_error("WARNING: ModLog() could not create/open " .. log_filename .. ", no mod log will be created");
				logging_disabled = true;
			end;
		else
			local log_interface = io.open(log_filename, "a");
			if log_interface then
				log_interface:write(text.."\n");
				log_interface:flush();
				log_interface:close();
			else
				script_error("WARNING: ModLog() could not open " .. log_filename .. ", no mod log will be created past this point");
				logging_disabled = true;
			end;
		end;
	end;
end;





-- load mods here
if core:is_campaign() then
	-- LOADING CAMPAIGN MODS

	-- load mods on NewSession
	core:add_listener(
		"new_session_mod_scripting_loader",
		"NewSession",
		true,
		function(context)

			local all_mods_loaded_successfully = core:load_mods(
				"/script/_lib/mod/",								-- general script library mods
				"/script/campaign/mod/",							-- root campaign folder
				"/script/campaign/" .. CampaignName .. "/mod/"		-- campaign-specific folder
			);

			core:trigger_event("ScriptEventAllModsLoaded", all_mods_loaded_successfully);
		end,
		true
	);

	-- execute mods on first tick
	cm:add_first_tick_callback(
		function(context)
			core:execute_mods(context);
		end
	);

elseif core:is_battle() then
	-- LOADING BATTLE MODS
	
	local all_mods_loaded_successfully = core:load_mods(
		"/script/_lib/mod/",				-- general script library mods
		"/script/battle/mod/"				-- root battle folder
	);

	core:trigger_event("ScriptEventAllModsLoaded", all_mods_loaded_successfully);

else
	-- LOADING FRONTEND MODS

	local all_mods_loaded_successfully = core:load_mods(
		"/script/_lib/mod/",				-- general script library mods
		"/script/frontend/mod/"				-- frontend-specific mods
	);

	core:trigger_event("ScriptEventAllModsLoaded", all_mods_loaded_successfully);
end;