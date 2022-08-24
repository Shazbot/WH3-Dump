
system.ClearRequiredFiles();

require "script.all_scripted"

print("*************************************************************************************************************");
print("*************************************************************************************************************");

if __write_output_to_logfile then
	local file = io.open(__logfile_path, "a");
	if file then
		file:write("*************************************************************************************************************\n");
		file:write("*************************************************************************************************************\n");
	end;
end;

out("battle_scripted.lua loaded: a new battle is being initialised");
out("");


-- Sets the game mode for loading in the script libraries
__game_mode = __lib_type_battle;


--
-- Functions to add and clear battle event callbacks. These call functions upstream in all_scripted.lua
--

battle_user_defined_event_callbacks = {};

function add_battle_event_callback(event, callback, is_persistent)
	if is_persistent then
		-- add this event without a user-defined table i.e. it won't get removed by any clear_event_callbacks() calls
		add_event_callback(event, callback);
	else
		-- add this event, and add it to the battle user-defined table so that it'll be cleared by clear_battle_event_callbacks()
		add_event_callback(event, callback, battle_user_defined_event_callbacks);
	end;
end;


function clear_battle_event_callbacks()
	local count = clear_event_callbacks(battle_user_defined_event_callbacks);
	print("");
	if count == 1 then
		print("*** clear_battle_event_callbacks() called, 1 callback cleared ***");
	else
		print("*** clear_battle_event_callbacks() called, " .. count .. " callbacks cleared ***");
	end;
	print("");
	
	-- logfile output
	if __write_output_to_logfile then
		local file = io.open(__logfile_path, "a");
		if file then
			file:write("\n");
			if count == 1 then
				file:write("*** clear_battle_event_callbacks() called, 1 callback cleared ***\n");
			else
				file:write("*** clear_battle_event_callbacks() called, " .. count .. " callbacks cleared ***\n");
			end;
			file:close();
		end;
	end;
end;

