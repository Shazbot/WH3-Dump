local log_filename = "_LUA_WaaaghLog";
local log_path = "\\The Creative Assembly\\Warhammer3\\logs\\campaign_ai";
local log_filetype = ".csv";
local log_data = {};

function waaagh_logging()
	if core:is_tweaker_set("SCRIPTED_TWEAKER_18") then
		local session_id = cm:model():session_id();

		log_path = os.getenv("APPDATA")..log_path;
		os.execute("mkdir \""..log_path.."\"");
		log_path = log_path .. "\\"..session_id..log_filename;

		core:add_listener(
			"AIWaaaghStartedLogging",
			"AIWaaaghStarted",
			true,
			function(context)
				LogWaaagh(context);
			end,
			true
		);
		core:add_listener(
			"PrintWaaaghLog",
			"WorldStartRound",
			true,
			function()
				PrintWaaaghLog();
			end,
			true
		);
	end
end

function LogWaaagh(context)
	print("LogWaaagh -- ");
	local faction_key = context:faction_key();
	local target_key = context:target_key();
	local region_key = context:region_key();
	local turn_number = cm:turn_number();
	print("Faction: "..faction_key);
	print("Target: "..target_key);
	print("Region: "..region_key);
	print("Turn: "..turn_number);

	if log_data[faction_key] == nil then
		log_data[faction_key] = {};
	end

	if log_data[faction_key][target_key] == nil then
		log_data[faction_key][target_key] = {};
		log_data[faction_key][target_key].waaaghs = {};
	end

	local new_waaagh = {};
	new_waaagh.region_key = region_key;
	new_waaagh.turn_number = turn_number;

	table.insert(log_data[faction_key][target_key].waaaghs, new_waaagh);
end

function PrintWaaaghLog()
	print("PrintWaaaghLog");
	print(tostring(log_data));
	local log_interface = io.open(log_path..log_filetype, "w");

	if log_interface then
		local header = "FACTION,";
		header = header.."TARGET FACTION,";
		header = header.."TARGET REGION,";
		header = header.."TURN #,";
		log_interface:write(header.."\n");

		for faction_key, faction in pairs(log_data) do
			for target_key, target in pairs(faction) do
				for i = 1, #target.waaaghs do
					local output = faction_key..",";
					output = output..target_key..",";
					output = output..target.waaaghs[i].region_key..",";
					output = output..target.waaaghs[i].turn_number..",";
					print(tostring(output));
					log_interface:write(output.."\n");
				end
			end
		end
		log_interface:flush();
		log_interface:close();
	end
end