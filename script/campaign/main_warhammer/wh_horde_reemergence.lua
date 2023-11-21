-- turns a horde faction must be dead for before it is allowed to re-emerge
local turns_before_faction_may_reemerge_after_death = 9

-- turns before another (or the same) horde faction is allowed to re-emerge once one already has re-emerged
local faction_reemerge_cooldown_turns = 15

-- percentage chance of a horde faction re-emerging if it is dead (meeting the above criteria)
local chance_of_horde_reemerging = 5

-- The maximum radius away from our target (in hexes) we allow as a valid spawn region. 
local max_region_distance_from_target = 250

-- Distance in hexes away from settlements we want hordes to re-emerge
local spawn_distance_from_settlement = 20

local subcultures_to_respawn = {
	wh_dlc03_sc_bst_beastmen = true,
	wh_main_sc_grn_savage_orcs = true
}

local factions_to_respawn = {
	wh2_dlc13_lzd_spirits_of_the_jungle = true,
	wh_dlc03_bst_beastmen_chaos = false,
	wh2_dlc13_bst_beastmen_invasion = false,
	wh2_dlc16_grn_savage_invasion = false,
	wh3_dlc24_tze_the_deceivers = true
}

local horde_respawn_data = {
	wh_dlc03_sc_bst_beastmen = {
		incident = "wh3_main_incident_horde_reemerges_bst",
		building = "wh_dlc03_horde_beastmen_gors_1",
		exclude_player_cultures_from_incident = {
			wh_main_chs_chaos = true,
			wh_dlc03_bst_beastmen = true,
			wh_dlc08_nor_norsca = true,
			wh3_main_dae_daemons = true,
			wh3_main_kho_khorne = true,
			wh3_main_nur_nurgle = true,
			wh3_main_sla_slaanesh = true,
			wh3_main_tze_tzeentch = true
		}
	},
	wh_main_sc_grn_savage_orcs = {
		incident = "wh3_main_incident_horde_reemerges_grn",
		building = "wh_main_horde_savage_military_1",
		exclude_player_cultures_from_incident = {}
	},
	wh2_main_sc_lzd_lizardmen = {
		incident = "wh3_main_incident_horde_reemerges_lzd",
		building = "wh2_dlc13_horde_lizardmen_portal_quetzl_1",
		exclude_player_cultures_from_incident = {}
	},
	wh3_main_sc_tze_tzeentch = {
		incident = nil, --In the case of the changeling we don't want an incident when he comes back
		building = nil,
		exclude_player_cultures_from_incident = {}
	}
}

random_army_manager:new_force("wh_main_sc_grn_savage_orcs_horde")

random_army_manager:add_unit("wh_main_sc_grn_savage_orcs_horde", "wh_main_grn_inf_savage_orcs",					3)
random_army_manager:add_unit("wh_main_sc_grn_savage_orcs_horde", "wh_main_grn_inf_savage_orc_arrer_boyz",		3)
random_army_manager:add_unit("wh_main_sc_grn_savage_orcs_horde", "wh_main_grn_cav_savage_orc_boar_boyz",		2)
random_army_manager:add_unit("wh_main_sc_grn_savage_orcs_horde", "wh_main_grn_inf_savage_orc_big_uns",			1)
random_army_manager:add_unit("wh_main_sc_grn_savage_orcs_horde", "wh_main_grn_cav_savage_orc_boar_boy_big_uns",	1)

random_army_manager:new_force("wh_dlc03_sc_bst_beastmen_horde")

random_army_manager:add_unit("wh_dlc03_sc_bst_beastmen_horde", "wh_dlc03_bst_inf_ungor_spearmen_0",				3)
random_army_manager:add_unit("wh_dlc03_sc_bst_beastmen_horde", "wh_dlc03_bst_inf_ungor_raiders_0",				3)
random_army_manager:add_unit("wh_dlc03_sc_bst_beastmen_horde", "wh_dlc03_bst_inf_minotaurs_0",					2)
random_army_manager:add_unit("wh_dlc03_sc_bst_beastmen_horde", "wh_dlc03_bst_inf_chaos_warhounds_0",			1)
random_army_manager:add_unit("wh_dlc03_sc_bst_beastmen_horde", "wh_dlc03_bst_inf_cygor_0",						1)

random_army_manager:new_force("wh2_main_sc_lzd_lizardmen_horde")

random_army_manager:add_unit("wh2_main_sc_lzd_lizardmen_horde", "wh2_main_lzd_inf_skink_cohort_1",				3)
random_army_manager:add_unit("wh2_main_sc_lzd_lizardmen_horde", "wh2_main_lzd_inf_saurus_warriors_0",			3)
random_army_manager:add_unit("wh2_main_sc_lzd_lizardmen_horde", "wh2_dlc13_lzd_mon_sacred_kroxigors_0",			2)
random_army_manager:add_unit("wh2_main_sc_lzd_lizardmen_horde", "wh2_main_lzd_cav_cold_ones_1",					1)
random_army_manager:add_unit("wh2_main_sc_lzd_lizardmen_horde", "wh2_main_lzd_mon_carnosaur_0",					1)

random_army_manager:new_force("wh3_main_sc_tze_tzeentch_horde")

random_army_manager:add_unit("wh3_main_sc_tze_tzeentch_horde", "wh3_main_tze_inf_blue_horrors_0",				3)
random_army_manager:add_unit("wh3_main_sc_tze_tzeentch_horde", "wh3_main_tze_inf_pink_horrors_0",				3)
random_army_manager:add_unit("wh3_main_sc_tze_tzeentch_horde", "wh3_main_tze_inf_forsaken_0",					2)
random_army_manager:add_unit("wh3_main_sc_tze_tzeentch_horde", "wh3_main_tze_mon_screamers_0",					1)
random_army_manager:add_unit("wh3_main_sc_tze_tzeentch_horde", "wh3_main_tze_cav_chaos_knights_0",				1)

function add_horde_reemergence_listeners()
	-- force horde factions to re-emerge via random incident
	core:add_listener(
		"horde_reemerge",
		"WorldStartRound",
		function()
			local allow_factions_to_reemerge = cm:get_saved_value("allow_factions_to_reemerge")
			return allow_factions_to_reemerge or allow_factions_to_reemerge == nil
		end,
		function()
			local factions_dead = {}
			local faction_list = cm:model():world():faction_list()
			
			for i = 0, faction_list:num_items() - 1 do
				local current_faction = faction_list:item_at(i)
				local current_faction_name = current_faction:name()
				
				if current_faction:is_dead() and not current_faction:was_confederated() and (factions_to_respawn[current_faction_name] or (subcultures_to_respawn[current_faction:subculture()] and factions_to_respawn[current_faction_name] ~= false)) and not current_faction:is_quest_battle_faction() then
					local turns_dead = cm:get_saved_value(current_faction_name .. "_dead")
					
					if turns_dead == nil or turns_dead == 0 then
						-- the faction has died for the first time
						cm:set_saved_value(current_faction_name .. "_dead", 1)
					elseif turns_dead > turns_before_faction_may_reemerge_after_death then
						-- the faction has been dead for the required number of turns, allow it to re-emerge
						table.insert(factions_dead, current_faction_name)
					else
						-- the faction has been dead, count the turn numbers
						cm:set_saved_value(current_faction_name .. "_dead", turns_dead + 1)
					end
				end
			end
			
			if #factions_dead > 0 and cm:random_number(100) <= chance_of_horde_reemerging then
				attempt_to_spawn_scripted_army(factions_dead[cm:random_number(#factions_dead)])
			end
		end,
		true
	)
	
	core:add_listener(
		"faction_reemerge_cooldown_expired",
		"ScriptEventFactionReemergeCooldownExpired",
		true,
		function()
			cm:set_saved_value("allow_factions_to_reemerge", true)
		end,
		true
	)
	
	core:add_listener(
		"force_faction_reemerge",
		"SpawnHorde",
		true,
		function(context)
			attempt_to_spawn_scripted_army(context.string)
		end,
		true
	)
end

function attempt_to_spawn_scripted_army(faction_name)
	local selected_faction = false
	
	local human_factions = cm:get_human_factions()
	
	if #human_factions > 0 then
		human_factions = cm:random_sort(human_factions)
		selected_faction = cm:get_faction(human_factions[1])
	else
		-- autorun - pick a random playable faction to target
		local playable_factions = {}
		local faction_list = cm:model():world():faction_list()
		
		for i = 0, faction_list:num_items() - 1 do
			local current_faction = faction_list:item_at(i)
			if not current_faction:is_dead() and current_faction:can_be_human() then
				table.insert(playable_factions, current_faction)
			end
		end
		
		selected_faction = playable_factions[cm:random_number(#playable_factions)]
	end
	
	-- get the highest ranked general's position
	local highest_ranked_general = cm:get_highest_ranked_general_for_faction(selected_faction)
	
	if not highest_ranked_general then
		return
	end
	
	-- get the closest settlement not owned by the player to the chosen general
	local closest_distance = 500000
	local target_region = false
	
	local region_list = cm:model():world():region_manager():region_list()
	
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		local settlement = region:settlement()
		
		if not region:is_abandoned() and region:owning_faction() ~= selected_faction then
			local current_distance = distance_squared(highest_ranked_general:logical_position_x(), highest_ranked_general:logical_position_y(), settlement:logical_position_x(), settlement:logical_position_y())
					
			if current_distance <= (max_region_distance_from_target * max_region_distance_from_target) and current_distance < closest_distance and current_distance > 50 then
				closest_distance = current_distance
				target_region = region:name()
			end
		end
	end
	
	if not target_region then
		out.design("Horde Reemergence: Attempting to spawn a new army for " .. faction_name .. ", but there are no valid spawn locations within range of the player's highest rank Lord")
		return
	end
	
	local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction_name, target_region, false, true, spawn_distance_from_settlement)
	
	if x < 1 then
		return
	end
	
	local faction = cm:get_faction(faction_name)
	local subculture = faction:subculture()
	
	local difficulty = cm:model():combined_difficulty_level()
	
	local army_size = 8				-- easy
	
	if difficulty == 0 then
		army_size = 10				-- normal
	elseif difficulty == -1 then
		army_size = 12				-- hard
	elseif difficulty == -2 then
		army_size = 14				-- very hard
	elseif difficulty == -3 then
		army_size = 16				-- legendary
	end
	
	cm:create_force(
		faction_name,
		random_army_manager:generate_force(subculture .. "_horde", army_size),
		target_region,
		x,
		y,
		false,
		function(cqi)
			local incident = horde_respawn_data[subculture].incident
			
			if incident then
				local human_factions = cm:get_human_factions()
				
				for i = 1, #human_factions do
					local current_faction = cm:get_faction(human_factions[i])
					local current_faction_culture = current_faction:culture()
					
					if not horde_respawn_data[subculture].exclude_player_cultures_from_incident[current_faction_culture] then
						cm:trigger_incident_with_targets(current_faction:command_queue_index(), incident, faction:command_queue_index(), 0, 0, 0, 0, 0)
					end
				end
			end
			
			-- add recruitment buildings to the spawned horde
			local building = horde_respawn_data[subculture].building
			
			if building then
				cm:add_building_to_force(cm:get_character_by_cqi(cqi):military_force():command_queue_index(), building)
			end
			
			cm:add_round_turn_countdown_event(faction_reemerge_cooldown_turns, "ScriptEventFactionReemergeCooldownExpired")
			
			cm:set_saved_value("allow_factions_to_reemerge", false)
			cm:set_saved_value(faction_name .. "_dead", 0)
		end
	)
end