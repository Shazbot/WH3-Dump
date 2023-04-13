local log_filename = "_LUA_BuildingLog"
local log_path = "\\The Creative Assembly\\Warhammer3\\logs\\campaign_ai"
local log_filetype = ".csv"
local log_data = {}

function building_logging()
	if core:is_tweaker_set("SCRIPTED_TWEAKER_50") then
		local session_id = cm:model():session_id()

		log_path = os.getenv("APPDATA")..log_path
		os.execute("mkdir \""..log_path.."\"")
		log_path = log_path .. "\\"..session_id..log_filename

		core:add_listener(
			"BuildingEndTurn",
			"WorldStartRound",
			true,
			function() 
				local turn = cm:turn_number()
				LogBuidling(turn)
			end,
			true
		)

		core:add_listener(
			"PrintBuildingLog",
			"WorldStartRound",
			true,
			function()
				PrintBuildingLog()
			end,
			true
		)
	end
end

function LogBuidling(turn)
	local provinces = cm:model():world():province_list()
	for i = 0, provinces:num_items() - 1 do
		local province = provinces:item_at(i)
		local regions = province:regions()
		for j = 0, regions:num_items() - 1 do
			local region = regions:item_at(j)
			local faction = region:owning_faction():name()
			slots = region:slot_list()
			for k = 0, slots:num_items() - 1 do
				local slot = slots:item_at(k)
				if slot:active() == true then
					local building = "Empty"
					if slot:has_building() == true then
						building = slot:building():name()
					end
					table.insert(log_data, turn..","..faction..","..province:key()..","..region:name()..","..building)
				end
			end
		end	
	end
end

function PrintBuildingLog()
	local log_interface = io.open(log_path..log_filetype, "a+")
	if log_interface then
		if cm:turn_number() == 1 then
			log_interface:write("Turn,Faction,Province,Region,Building\n")
		end
		for i = 1, #log_data do
			log_interface:write(log_data[i].."\n")
		end
		log_interface:flush()
		log_interface:close()
		log_data = {}
	end
end