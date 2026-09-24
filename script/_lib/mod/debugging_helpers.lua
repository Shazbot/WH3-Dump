out("qa_console.lua loaded");

local get_n_spaces_string = function(n)
	local spaces = ""
	for _ = 1, n do
		spaces = spaces .. " "
	end

	return spaces
end

_debug = {
	whitespace_len_initial = 4,
	whitespace_len_additional = 4,

	print = function(object)
		out(_debug.to_str(object))
	end,

	-- spaces is optional. Dictates the whitespace before the content
	-- of a table or something else that will use whitespace
	to_str = function(object, spaces)
		spaces = (is_number(spaces) and spaces) or _debug.whitespace_len_initial

		local result_str
		if is_nil(object) then
			result_str = _debug.to_str_nil(object)
		elseif is_number(object) then
			result_str = _debug.to_str_number(object)
		elseif is_function(object) then
			result_str = _debug.to_str_function(object)
		elseif is_string(object) then
			result_str = _debug.to_str_string(object)
		elseif is_boolean(object) then
			result_str = _debug.to_str_boolean(object)
		elseif is_table(object) then
			result_str = _debug.to_str_table(spaces, object)
		else
			result_str = "Not implemented for this object yet: " .. tostring(object)
		end
		return result_str
	end,

	to_str_nil = tostring,

	to_str_number = tostring,

	to_str_function = tostring,

	to_str_string = function(object)
		return "\"" .. object .. "\""
	end,

	to_str_boolean = tostring,

	table_type = function(table)
		if not is_table(table) then
			return nil
		end

		if #table > 0 then
			return "indexed"
		end

		return "map"
	end,

	to_str_table = function(num_spaces, table)
		local result = ""
		local whitespace = get_n_spaces_string(math.max(0, num_spaces - _debug.whitespace_len_additional))

		result = result .. "\n" .. whitespace .. "{\n"

		local table_type = _debug.table_type(table)
		if table_type == "indexed" then
			result = result .. _debug.to_str_table_content_ipairs(num_spaces, table)
		elseif table_type == "map" then
			result = result .. _debug.to_str_table_content_pairs(num_spaces, table)
		else
			result = result .. whitespace .. "not a table?\n"
		end

		result = result .. whitespace .. "}"

		return result
	end,

	to_str_table_content_ipairs = function(num_spaces, table)
		return _debug.to_str_table_content(num_spaces, table, ipairs)
	end,

	to_str_table_content_pairs = function(num_spaces, table)
		return _debug.to_str_table_content(num_spaces, table, pairs)
	end,

	to_str_table_content = function(num_spaces, table, iterate_func)
		local result = ""
		local whitespace = get_n_spaces_string(num_spaces)

		for key, val in iterate_func(table) do
			result = result .. whitespace .. "[ " .. _debug.to_str(key) .. " ] = "
			result = result .. _debug.to_str(val, num_spaces + _debug.whitespace_len_additional) .. ",\n"
		end

		return result
	end,
}


local end_turn_file_name = nil
function province_buildings_round_summary_start()
	out("Starting province_buildings_round_summary dump...")
	core:add_listener(
		"provice_round_summary_listener",
		"RoundStart",
		function(context)
			return true
		end,
		function(context)
			local end_turn_file = nil
			if not end_turn_file_name then
				end_turn_file_name = "../working_data/script/end_turn_building_logs/end_turn_buildings_" .. os.date("%Y_%m_%d_%H_%M_%S") .. ".txt"
				end_turn_file = io.open(end_turn_file_name, "w")
				if not end_turn_file then
					out("Failed to open file " .. end_turn_file_name .. " . Stopping...")
					province_buildings_round_summary_stop()
					do return end
				end
				end_turn_file:write("Owning Faction key,Region key,Slot key,Slot Type,Building key,Turn\n")
			else
				end_turn_file = io.open(end_turn_file_name, "a")
				if not end_turn_file then
					out("Failed to open file " .. end_turn_file_name .. " . Stopping...")
					province_buildings_round_summary_stop()
					do return end
				end
			end

			log_provices_buildings(end_turn_file, context:model():world():province_manager():province_list())

			end_turn_file:write("\n")
			end_turn_file:close()
		end,
		true
	)
end

function log_provices_buildings(file, provinces)
	for i = 0, provinces:num_items() - 1 do
		local province = provinces:item_at(i)
		for j = 0, province:regions():num_items() - 1 do
			local region = province:regions():item_at(j)
			local slot_string = ""
			for m = 0, region:slot_list():num_items() - 1 do
				local slot = region:slot_list():item_at(m)
				if not slot:building():is_null_interface() then
					file:write(region:name() .. "," .. region:owning_faction():name() .. "," .. slot:name() .. "," .. slot:type() .. "," .. slot:building():name() .. "," .. cm:model():turn_number() .. "\n")
				end
			end
		end
	end
end

function province_buildings_round_summary_for_turn(turn_number)
	out("Starting province_buildings_round_summary_for_turn listener...")
	core:add_listener(
		"province_round_summary_for_turn_listener",
		"RoundStart",
		function(context)
			return true
		end,
		function(context)
			if cm:model():turn_number() == turn_number then
				local end_turn_file_name = "../working_data/script/end_turn_building_logs/end_turn_buildings_turn_".. turn_number .. "_" .. os.date("%Y_%m_%d_%H_%M_%S") .. ".txt"
				local end_turn_file = io.open(end_turn_file_name, "w")
				if not end_turn_file then
					out("Failed to open file " .. end_turn_file_name .. " . Stopping...")
					core:remove_listener("province_round_summary_for_turn_listener")
					do return end
				end
				end_turn_file:write("Owning Faction key,Region key,Slot key,Slot Type,Building key,Turn\n")
				log_provices_buildings(end_turn_file, context:model():world():province_manager():province_list())
				end_turn_file:close()
				core:remove_listener("province_round_summary_for_turn_listener")
			end
		end,
		true
	)
end

function province_buildings_round_summary_stop()
	out("Stopping province_buildings_round_summary dump...")
	core:remove_listener("provice_round_summary_listener")
	end_turn_file_name = nil
end

function get_camera_pos()
	local x,y,d,b,h = cm:get_camera_position()
	out(x)
	out(y)
	out(d)
	out(b)
	out(h)
end

function get_camera_pos_cindy()
	local posx, posy, posz, tarx, tary, tarz = cm:get_camera_position_cindy_format()
	out("POSITION")
	out(posx)
	out(posy)
	out(posz)

	out("TARGET")
	out(tarx)
	out(tary)
	out(tarz)
end
