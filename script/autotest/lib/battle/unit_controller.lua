local m_uc_script_control = {}

local function get_capture_point_index_by_script_id(cp_no)
	local matching_id

	Timers_Callbacks.battle_call(function()
		local cp_count = common.get_context_value("CcoBattleRoot", "", "VictoryCapturePointContextList(false).Size") - 1
		Utilities.print("cp count: "..tostring(cp_count))
		for i = 0, cp_count do
			-- find the index with the matching description we want
			local cp_script_id = common.get_context_value("CcoBattleRoot", "", "VictoryCapturePointContextList(false).At("..i..").ScriptId")
			local pos_test1,pos_test2,pos_test3,pos_test4 = common.get_context_value("CcoBattleRoot", "", "VictoryCapturePointContextList(false).At("..i..").Position")
			local vectorTest = battle_vector:new(pos_test1, pos_test2, pos_test3)
			Utilities.print("cp script_id: "..tostring(cp_script_id))
			if(string.find(cp_script_id, cp_no)) then
				matching_id = i
			end
		end
	end)

	return matching_id
end

local function get_player_alliance_index()
	local player_index
	Timers_Callbacks.battle_call(function()
		local alliance_list_size = common.get_context_value("CcoBattleRoot", "", "AllianceList.Size") - 1
		for i = 0, alliance_list_size do
			local is_player = common.get_context_value("CcoBattleRoot", "", "AllianceList.At("..i..").IsPlayersAlliance")
			if(is_player) then
				player_index = common.get_context_value("CcoBattleRoot", "", "AllianceList.At("..i..").Id")
			end
		end
	end)
	return player_index
end

function Lib.Battle.Unit_Controller.check_point_player_owned(cp_index)
	local player_index = tostring(get_player_alliance_index())
	local cp_held_by_player 

	Timers_Callbacks.battle_call(function()
		cp_held_by_player = common.get_context_value("CcoBattleRoot", "", "VictoryCapturePointContextList(false).At("..cp_index..").HoldingArmyContext.IsLocalPlayer")
	end)


	if(cp_held_by_player) then
		return true
	end

	return false
end

function Lib.Battle.Unit_Controller.release_script_unit_control()
	m_capture_pos = nil
	m_player_under_control = false

	for k, uc in pairs(m_uc_script_control) do
		uc:release_control()
	end
end

function Lib.Battle.Unit_Controller.get_valid_capture_point_by_pathfind()
	local s_unit
	Timers_Callbacks.battle_call(function()
			local player_army = bm:get_player_army()
			s_unit = script_unit:new_by_reference(player_army, 1)
	end)
	local result
	--get the list of victory points
	Timers_Callbacks.battle_call(function()
		local cp_count = common.get_context_value("CcoBattleRoot", "", "VictoryCapturePointContextList(false).Size") - 1
		for i = 0, cp_count do
			-- loop through all capture points and check if we can pathfind to them
			local pos_x,pos_y,pos_z,_ = common.get_context_value("CcoBattleRoot", "", "VictoryCapturePointContextList(false).At("..i..").Position")
			local capture_point_vector = battle_vector:new(pos_x, pos_y, pos_z)
			if(s_unit.unit:can_reach_position(capture_point_vector) and Lib.Battle.Unit_Controller.check_point_player_owned(i) == false) then
				result = i --this point can be reached and isnt owned by the player, so we want to target it
				break
			end
		end
	end)
	--return the id of the first valid capture point
	return result
end

local m_capture_pos
local m_current_target
local m_player_under_control = false
local function move_unit_controller_to_capture_point(uc, cp_index)
	callback(function()
		
		--get_valid_capture_point_by_pathfind(uc)
		Timers_Callbacks.battle_call(function()
			if(m_player_under_control == false) then
				table.insert(m_uc_script_control, uc)
				m_player_under_control = true
				uc:take_control()
			end

			if(cp_index ~= m_current_target)then 
				--if the target being passed in does not match the current target then we have a new target, change the capture pos
				m_capture_pos = nil
			end

			if(m_capture_pos == nil) then
				Utilities.print("Moving to point "..tostring(cp_index))
				m_current_target = cp_index
				local x_cp, y_cp, z_cp, w_cp = common.get_context_value("CcoBattleRoot", "", "VictoryCapturePointContextList(false).At("..cp_index..").FlagPosition")
				Timers_Callbacks.battle_call(function()
					m_capture_pos = battle_vector:new(x_cp, y_cp, z_cp)
				end)
			end

			uc:goto_location(m_capture_pos, true)
		end)
	end)
end

function Lib.Battle.Unit_Controller.capture_survival_point(cp_no)
	--get every unit in the players army and send them towards the capture point
	callback(function()
		Timers_Callbacks.battle_call(function()
			local player_army = bm:get_player_army()
			local unit_count = player_army:units():count()
			for i=1, unit_count do
				local unit = script_unit:new_by_reference(player_army, i)
				local unit_cont = unit.uc
				move_unit_controller_to_capture_point(unit_cont, cp_no)
			end
		end)
	end)
end

