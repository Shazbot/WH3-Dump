local log_filename = "_LUA_SiegeLog"
local log_path = "\\The Creative Assembly\\Warhammer3\\logs\\campaign_ai"
local log_filetype = ".csv"
local log_data = {}

function siege_logging()
	if core:is_tweaker_set("SCRIPTED_TWEAKER_49") then
		local session_id = cm:model():session_id()

		log_path = os.getenv("APPDATA")..log_path
		os.execute("mkdir \""..log_path.."\"")
		log_path = log_path .. "\\"..session_id..log_filename

		core:add_listener(
			"SiegeLogEndTurnLog",
			"WorldStartRound",
			true,
			function() 
				EachTurnSiegeLog()
			end,
			true
		)

		core:add_listener(
			"SiegeLogOccupation",
			"CharacterPerformsSettlementOccupationDecision",
			true,
			function(context) 
				LogSiegeEndOnOccupy(context)
			end,
			true
		)

		core:add_listener(
			"SiegeLogPrint",
			"WorldStartRound",
			true,
			function()
				LogSiegePrintLog()
			end,
			true
		)
	end
end

function EachTurnSiegeLog()
	local provinces = cm:model():world():province_list()
	for i = 0, provinces:num_items() - 1 do
		local regions =  provinces:item_at(i):regions()
		for j = 0, regions:num_items() - 1 do
			local region = regions:item_at(j)
			local region_name = region:name()
			local garrison = region:garrison_residence()
			local under_siege = garrison:is_under_siege()
			local character = garrison:besieging_character()
			if under_siege and log_data[region_name] == nil then 
				log_data[region_name] = {}
				log_data[region_name].settlement = region:settlement():key()
				log_data[region_name].owning_faction = region:owning_faction():name()
				log_data[region_name].character = character:cqi()
				log_data[region_name].besieging_faction = character:faction():name()
				log_data[region_name].start_turn = cm:turn_number() - 1
				log_data[region_name].concluded = false
			elseif under_siege == false and log_data[region_name] ~= nil then
				if log_data[region_name].concluded == false then
					log_data[region_name].end_turn = cm:turn_number() - 1
					log_data[region_name].concluded = true
					log_data[region_name].outcome = "Lifted"
				end
			elseif under_siege and log_data[region_name] ~= nil then
				if log_data[region_name].character ~= character:cqi() or log_data[region_name].owning_faction ~= region:owning_faction():name() then
					--This is a fallback if a siege ends and a new one begins at the same region in the same turn. We just ignore the first one as I can't think of a neat way to handle this. 
					log_data[region_name].owning_faction = region:owning_faction():name()
					log_data[region_name].character = character:cqi()
					log_data[region_name].besieging_faction = character:faction():name()
					log_data[region_name].start_turn = cm:turn_number() - 1
					log_data[region_name].concluded = false
				end 
			end
		end	
	end
end

function LogSiegeEndOnOccupy(context)
	local garrison = context:garrison_residence()
	if garrison:is_settlement() == false then
		return
	end
	local settlement = garrison:settlement_interface()
	local region_name = settlement:region():name()
	if log_data[region_name] == nil then
		log_data[region_name] = {}
		log_data[region_name].settlement = settlement:key()
		log_data[region_name].owning_faction = context:previous_owner()
		log_data[region_name].besieging_faction = context:character():faction():name()
		log_data[region_name].start_turn = cm:turn_number()
	end
	log_data[region_name].concluded = true
	log_data[region_name].end_turn = cm:turn_number()
	log_data[region_name].outcome = context:settlement_option()
end

function LogSiegePrintLog()
	local log_interface = io.open(log_path..log_filetype, "a+")
	local turn = cm:turn_number() - 1
	if log_interface then
		if turn == 0 then
			log_interface:write("Turn,Settlement,Owning Faction,Besieging Faction,Length,Outcome\n")
		end
		for k, v in pairs(log_data) do
			if v.concluded == true then
				log_interface:write(turn..","..v.settlement..","..v.owning_faction..","..v.besieging_faction..","..v.end_turn-v.start_turn..","..v.outcome.."\n")
				log_data[k] = nil
			end
		end
		log_interface:flush()
		log_interface:close()
	end
end