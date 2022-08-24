local file_path = common.vfs_working_directory()
local script_file_path = string.sub(debug.getinfo(1).source, 1, string.len("/test.lua") * -1)
file_path = file_path..script_file_path

local function serialize_data(input, path)
	if	type(input) == "number" then
		path:write(input)
	elseif type(input) == "string" then
		path:write(string.format("%q", input))
	elseif type(input) == "boolean" then
		path:write(tostring(input))
	elseif type(input) == "table" then
		path:write("{\n")
        local count = 0
        for _ in pairs(input) do count = count + 1 end
        local final = 0
		for k,v in pairs(input) do
            final = final + 1
			path:write("  ", string.format("%q", k), ": ")
			serialize_data(v, path)
            if final == count then
                path:write("\n")
            else
                path:write(",\n")
            end
		end
		path:write("}\n")
	end
end

local function write_json_from_kvpair(key, value, path)
	if type(value) == "table" then
		local count = 0
		local final = 0
		path:write("  ", string.format("%q",key), ": [\n")
		for _ in pairs(value) do count = count + 1 end
		for _,entry in pairs(value) do
			final = final + 1
			path:write("    ", string.format("%q", entry))
			if final == count then
				path:write("\n")
				path:write("  ]")
			else
				path:write(",\n")
			end
		end
	elseif type(value) == "number" then
		path:write("  ", string.format("%q",key), ": ", value)
	elseif type(value) == "string" then
		path:write("  ", string.format("%q",key), ": ", string.format("%q", value))
	end
end

function Lib.Elastic.Misc.get_observer_path()
	return file_path..'python\\observer.py'
end

function Lib.Elastic.Misc.create_data_file(file_name)
	local elastic_appdata_path = os.getenv('APPDATA')..[[\CA_Autotest\WH3\elastic_data\]]
	local filehandle = io.open(elastic_appdata_path..file_name, 'w')
	serialize_data(g_quest_battle_elastic_table, filehandle)
	filehandle:close()
end

function Lib.Elastic.Misc.send_dlc_mask_data(dlc_mask_data_table)
	local elastic_appdata_path = os.getenv('APPDATA')..[[\CA_Autotest\WH3\elastic_data\]]
	local filehandle = io.open(elastic_appdata_path.."dlc_mask_data.json", 'w')
	filehandle:write("{\n")
	local count = 0
	local final = 0
	for _ in pairs(dlc_mask_data_table) do count = count + 1 end
	for k,v in pairs(dlc_mask_data_table) do
		final = final + 1
		write_json_from_kvpair(k, v, filehandle)
		if final == count then
			filehandle:write("\n")
		else
			filehandle:write(",\n")
		end
	end
	filehandle:write("}\n")
	filehandle:close()
end