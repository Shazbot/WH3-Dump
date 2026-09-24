-- turns a horde faction must be dead for before it is allowed to re-emerge
turns_before_faction_may_reemerge_after_death = 9

-- turns before another (or the same) horde faction is allowed to re-emerge once one already has re-emerged
faction_reemerge_cooldown_turns = 15

-- percentage chance of a horde faction re-emerging if it is dead (meeting the above criteria)
chance_of_horde_reemerging = 5	-- Intentionally global, so that it can be set from the script console for debugging purposes.

-- The maximum and minimum radius away from our target (in hexes) we allow as a valid spawn region. 
local max_region_distance_from_target = 250
local min_region_distance_from_target = 8

-- Distance in hexes away from settlements we want hordes to re-emerge
local spawn_distance_from_settlement = 20

local subcultures_to_respawn = {
	wh_dlc03_sc_bst_beastmen = true,
	wh_main_sc_grn_savage_orcs = true,
	wh3_main_sc_kho_khorne = true,
	wh3_main_sc_nur_nurgle = true,
	wh3_main_sc_sla_slaanesh = true,
	wh3_main_sc_tze_tzeentch = true,
}

local factions_to_respawn = {
	wh2_dlc13_lzd_spirits_of_the_jungle = true,
	wh_dlc03_bst_beastmen_chaos = false,
	wh2_dlc13_bst_beastmen_invasion = false,
	wh2_dlc16_grn_savage_invasion = false,
	wh3_dlc29_khorne_vassal_owner = false,
	wh3_dlc29_nurgle_vassal_owner = false,
	wh3_dlc29_slaanesh_vassal_owner = false,
	wh3_dlc29_tzeentch_vassal_owner  = false,
	wh3_dlc25_kho_khorne_invasion  = false,
	wh3_dlc25_nur_nurgle_invasion  = false,
	wh3_dlc25_sla_slaanesh_invasion  = false,
	wh3_main_tze_tzeentch_invasion  = false,
	-- wh3_dlc24_tze_the_deceivers = true,	-- This is no longer needed, as we have the whole subculture respawning. We substitute it with a faction specific respawn data.
}

local horde_respawn_data_for_subculture = {
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
	wh3_main_sc_kho_khorne = {
		is_region_owning_daemon = true,
		enabling_province_corruption_thresholds = {
			wh3_main_corruption_khorne = 75,
			wh3_main_corruption_chaos = 100,
		},
		army_manager_suffix = "_daemon",
		incident = "wh3_dlc29_incident_horde_reemerges_kho",
		exclude_player_cultures_from_incident = {},
		effect_bundle_while_regionless = "wh3_main_ie_scripted_endgame_force_immune_to_regionless_attrition",	-- An effect bundle that is applied to the faction until it captures a region to prevent it from taking regionless attrition.
		force_war_on_nearby_region_owner = {	-- If there is no such table, no war will be force declared.
			allow_selecting_region_owned_by_same_subculture = false,
			max_squared_distance = 250 * 250,
			region_score_squared_distance_multiplier = -0.01,	-- Closer regions are preferred.
			region_score_primary_building_level_multiplier = -10,	-- Weaker regions are preferred, so that the faction gets some foothold.
			region_score_province_corruption_multipliers = {
				wh3_main_corruption_khorne = 1.5,	-- Favourable corruption is preferred, so that the faction has a foothold in a region that already has favourable corruption.
				wh3_main_corruption_chaos = 1.0,	-- Favourable corruption is preferred, so that the faction has a foothold in a region that already has favourable corruption.
			},
		},
	},
	wh3_main_sc_nur_nurgle = {
		is_region_owning_daemon = true,
		enabling_province_corruption_thresholds = {
			wh3_main_corruption_nurgle = 75,
			wh3_main_corruption_chaos = 100,
		},
		army_manager_suffix = "_daemon",
		incident = "wh3_dlc29_incident_horde_reemerges_nur",
		exclude_player_cultures_from_incident = {},
		effect_bundle_while_regionless = "wh3_main_ie_scripted_endgame_force_immune_to_regionless_attrition",	-- An effect bundle that is applied to the faction until it captures a region to prevent it from taking regionless attrition.
		force_war_on_nearby_region_owner = {	-- If there is no such table, no war will be force declared.
			allow_selecting_region_owned_by_same_subculture = false,
			max_squared_distance = 250 * 250,
			region_score_squared_distance_multiplier = -0.01,	-- Closer regions are preferred.
			region_score_primary_building_level_multiplier = -10,	-- Weaker regions are preferred, so that the faction gets some foothold.
			region_score_province_corruption_multipliers = {
				wh3_main_corruption_nurgle = 1.5,	-- Favourable corruption is preferred, so that the faction has a foothold in a region that already has favourable corruption.
				wh3_main_corruption_chaos = 1.0,	-- Favourable corruption is preferred, so that the faction has a foothold in a region that already has favourable corruption.
			},
		},
	},
	wh3_main_sc_sla_slaanesh = {
		is_region_owning_daemon = true,
		enabling_province_corruption_thresholds = {
			wh3_main_corruption_slaanesh = 75,
			wh3_main_corruption_chaos = 100,
		},
		army_manager_suffix = "_daemon",
		incident = "wh3_dlc29_incident_horde_reemerges_sla",
		exclude_player_cultures_from_incident = {},
		effect_bundle_while_regionless = "wh3_main_ie_scripted_endgame_force_immune_to_regionless_attrition",	-- An effect bundle that is applied to the faction until it captures a region to prevent it from taking regionless attrition.
		force_war_on_nearby_region_owner = {	-- If there is no such table, no war will be force declared.
			allow_selecting_region_owned_by_same_subculture = false,
			max_squared_distance = 250 * 250,
			region_score_squared_distance_multiplier = -0.01,	-- Closer regions are preferred.
			region_score_primary_building_level_multiplier = -10,	-- Weaker regions are preferred, so that the faction gets some foothold.
			region_score_province_corruption_multipliers = {
				wh3_main_corruption_slaanesh = 1.5,	-- Favourable corruption is preferred, so that the faction has a foothold in a region that already has favourable corruption.
				wh3_main_corruption_chaos = 1.0,	-- Favourable corruption is preferred, so that the faction has a foothold in a region that already has favourable corruption.
			},
		},
	},
	wh3_main_sc_tze_tzeentch = {
		is_region_owning_daemon = true,
		enabling_province_corruption_thresholds = {
			wh3_main_corruption_tzeentch = 75,
			wh3_main_corruption_chaos = 100,
		},
		army_manager_suffix = "_daemon",
		incident = "wh3_dlc29_incident_horde_reemerges_tze",
		exclude_player_cultures_from_incident = {},
		effect_bundle_while_regionless = "wh3_main_ie_scripted_endgame_force_immune_to_regionless_attrition",	-- An effect bundle that is applied to the faction until it captures a region to prevent it from taking regionless attrition.
		force_war_on_nearby_region_owner = {	-- If there is no such table, no war will be force declared.
			allow_selecting_region_owned_by_same_subculture = false,
			max_squared_distance = 250 * 250,
			region_score_squared_distance_multiplier = -0.01,	-- Closer regions are preferred.
			region_score_primary_building_level_multiplier = -10,	-- Weaker regions are preferred, so that the faction gets some foothold.
			region_score_province_corruption_multipliers = {
				wh3_main_corruption_tzeentch = 1.5,	-- Favourable corruption is preferred, so that the faction has a foothold in a region that already has favourable corruption.
				wh3_main_corruption_chaos = 1.0,	-- Favourable corruption is preferred, so that the faction has a foothold in a region that already has favourable corruption.
			},
		},
	},
}

local horde_respawn_data_for_faction = {
	wh3_dlc24_tze_the_deceivers = {
		is_region_owning_daemon = false, --This is an horde daemon faction.
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

random_army_manager:new_force("wh3_main_sc_kho_khorne_daemon")

random_army_manager:add_unit("wh3_main_sc_kho_khorne_daemon", "wh3_main_kho_inf_bloodletters_0",				3)
random_army_manager:add_unit("wh3_main_sc_kho_khorne_daemon", "wh3_main_kho_inf_bloodletters_1",				3)
random_army_manager:add_unit("wh3_main_sc_kho_khorne_daemon", "wh3_main_kho_inf_flesh_hounds_of_khorne_0",		2)
random_army_manager:add_unit("wh3_main_sc_kho_khorne_daemon", "wh3_main_kho_veh_blood_shrine_0",				1)
random_army_manager:add_unit("wh3_main_sc_kho_khorne_daemon", "wh3_main_kho_mon_bloodthirster_0",				1)

random_army_manager:new_force("wh3_main_sc_nur_nurgle_daemon")

random_army_manager:add_unit("wh3_main_sc_nur_nurgle_daemon", "wh3_main_nur_inf_nurglings_0",					3)
random_army_manager:add_unit("wh3_main_sc_nur_nurgle_daemon", "wh3_main_nur_inf_plaguebearers_1",				3)
random_army_manager:add_unit("wh3_main_sc_nur_nurgle_daemon", "wh3_main_nur_mon_plague_toads_0",				2)
random_army_manager:add_unit("wh3_main_sc_nur_nurgle_daemon", "wh3_main_nur_mon_rot_flies_0",					1)
random_army_manager:add_unit("wh3_main_sc_nur_nurgle_daemon", "wh3_main_nur_mon_great_unclean_one_0",			1)

random_army_manager:new_force("wh3_main_sc_sla_slaanesh_daemon")

random_army_manager:add_unit("wh3_main_sc_sla_slaanesh_daemon", "wh3_main_sla_inf_daemonette_0",				3)
random_army_manager:add_unit("wh3_main_sc_sla_slaanesh_daemon", "wh3_main_sla_inf_daemonette_1",				3)
random_army_manager:add_unit("wh3_main_sc_sla_slaanesh_daemon", "wh3_main_sla_mon_fiends_of_slaanesh_0",					2)
random_army_manager:add_unit("wh3_main_sc_sla_slaanesh_daemon", "wh3_main_sla_cav_seekers_of_slaanesh_0",					1)
random_army_manager:add_unit("wh3_main_sc_sla_slaanesh_daemon", "wh3_main_sla_mon_keeper_of_secrets_0",			1)

random_army_manager:new_force("wh3_main_sc_tze_tzeentch_daemon")

random_army_manager:add_unit("wh3_main_sc_tze_tzeentch_daemon", "wh3_main_tze_inf_blue_horrors_0",				3)
random_army_manager:add_unit("wh3_main_sc_tze_tzeentch_daemon", "wh3_main_tze_inf_pink_horrors_1",				3)
random_army_manager:add_unit("wh3_main_sc_tze_tzeentch_daemon", "wh3_main_tze_mon_flamers_0",					2)
random_army_manager:add_unit("wh3_main_sc_tze_tzeentch_daemon", "wh3_main_tze_mon_screamers_0",					1)
random_army_manager:add_unit("wh3_main_sc_tze_tzeentch_daemon", "wh3_main_tze_mon_lord_of_change_0",			1)

reemergence_persistent = {}
-- Here we store the effect bundles applied to regionless region owning daemon forces that have been spawned, so that we can remove them upon their faction capturing a region.
reemergence_persistent.regionless_region_owning_daemon_forces_effect_bundles = {}

function add_horde_reemergence_listeners()
	-- special case - if Middenland(Boris Todbringer) is human explicitly disallow Khazrak from reemerging
	if cm:get_faction(fervour.middenland_faction):is_human() then
		factions_to_respawn["wh_dlc03_bst_beastmen"] = false
	end
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
			local faction_list = cm:get_faction_list()
			
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
				attempt_to_spawn_scripted_army(factions_dead)
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
		"faction_reemerge_regionless_region_owning_daemon_faction_captured_region",
		"RegionFactionChangeEvent",
		true,
		function(context)
			local new_owner = context:region():owning_faction()
			local new_owner_key = new_owner:name()
			if reemergence_persistent.regionless_region_owning_daemon_forces_effect_bundles[new_owner_key] then
				local bundle_data = reemergence_persistent.regionless_region_owning_daemon_forces_effect_bundles[new_owner_key]
				local force = cm:get_military_force_by_cqi(bundle_data.force_cqi)
				if force then
					cm:remove_effect_bundle_from_force(bundle_data.effect_bundle, bundle_data.force_cqi)
				end
				reemergence_persistent.regionless_region_owning_daemon_forces_effect_bundles[new_owner_key] = nil
			end
		end,
		true
	)
end

function get_reemergence_respawn_data(faction_name, faction_subculture)
	if horde_respawn_data_for_faction[faction_name] then
		return horde_respawn_data_for_faction[faction_name]
	elseif horde_respawn_data_for_subculture[faction_subculture] then
		return horde_respawn_data_for_subculture[faction_subculture]
	end
	
	return false
end

function attempt_to_spawn_scripted_army(factions_dead)
	local provinces_with_enabling_corruption_thresholds = {}
	while not is_empty_table(factions_dead) do
		local index = cm:random_number(#factions_dead)
		local faction_name = factions_dead[index]
		if attempt_to_spawn_scripted_army_for_faction(faction_name, provinces_with_enabling_corruption_thresholds) then
			return
		end

		table.remove(factions_dead, index)
	end
end

function attempt_to_spawn_scripted_army_for_faction(faction_name, provinces_with_enabling_corruption_thresholds)
	if not cm:is_multiplayer() and faction_name == "wh_dlc03_bst_beastmen" then
		local human_factions = cm:get_human_factions()
		if #human_factions > 0 and human_factions[1] == "wh_main_emp_middenland" then
			return false
		end
	end

	local faction = cm:get_faction(faction_name)
	local subculture = faction:subculture()
	local respawn_data = get_reemergence_respawn_data(faction_name, subculture)
	if not respawn_data then
		script_error("Horde Reemergence: Attempting to spawn a new army for " .. faction_name .. ", but no respawn data was found for this faction or its subculture")
		return false
	end

	if respawn_data.is_region_owning_daemon then
		-- Lazily evaluate the provinces_with_enabling_corruption_thresholds cache per culture.
		if not is_table(provinces_with_enabling_corruption_thresholds[subculture]) then
			provinces_with_enabling_corruption_thresholds[subculture] = fill_reemergence_provinces_with_enabling_corruption_thresholds(respawn_data.enabling_province_corruption_thresholds)
		end
		return attempt_to_spawn_scripted_army_for_region_owning_daemon_faction(faction, faction_name, subculture, respawn_data, provinces_with_enabling_corruption_thresholds[subculture])
	else
		return attempt_to_spawn_scripted_army_for_horde_faction(faction, faction_name, subculture, respawn_data)
	end
end

function fill_reemergence_provinces_with_enabling_corruption_thresholds(enabling_province_corruption_thresholds)
	local result = {}
	local province_list = cm:model():world():province_list()
	for _, province in model_pairs(province_list) do
		for corruption_key, corruption_threshold in dpairs(enabling_province_corruption_thresholds) do
			if cm:get_corruption_value_in_province(province, corruption_key) >= corruption_threshold then
				table.insert(result, province)
				break
			end
		end
	end
	return result
end

function attempt_to_spawn_scripted_army_for_region_owning_daemon_faction(faction, faction_name, subculture, respawn_data, subculture_provinces_with_enabling_corruption_thresholds)
	if is_empty_table(subculture_provinces_with_enabling_corruption_thresholds) then
		return false
	end

	local target_province = subculture_provinces_with_enabling_corruption_thresholds[cm:random_number(#subculture_provinces_with_enabling_corruption_thresholds)]
	local target_region = target_province:capital_region()

	return attempt_to_spawn_scripted_army_in_region(faction, faction_name, subculture, target_region:name(), respawn_data)
end

function attempt_to_spawn_scripted_army_for_horde_faction(faction, faction_name, subculture, respawn_data)
	local selected_faction = false
	
	local human_factions = cm:get_human_factions()
	
	if #human_factions > 0 then
		human_factions = cm:random_sort(human_factions)
		selected_faction = cm:get_faction(human_factions[1])
	else
		-- autorun - pick a random playable faction to target
		local playable_factions = {}
		local faction_list = cm:get_faction_list()
		
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
		return false
	end
	
	-- get the closest settlement not owned by the player to the chosen general
	local closest_squared_distance = 500000
	local target_region = false
	
	local region_list = cm:model():world():region_manager():region_list()
	
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		local settlement = region:settlement()
		
		if not region:is_abandoned() and region:owning_faction() ~= selected_faction then
			local current_squared_distance = distance_squared(highest_ranked_general:logical_position_x(), highest_ranked_general:logical_position_y(), settlement:logical_position_x(), settlement:logical_position_y())
					
			if current_squared_distance <= (max_region_distance_from_target * max_region_distance_from_target)
				and current_squared_distance < closest_squared_distance
				and current_squared_distance >= (min_region_distance_from_target * min_region_distance_from_target)
			then
				closest_squared_distance = current_squared_distance
				target_region = region:name()
			end
		end
	end
	
	if not target_region then
		out.design("Horde Reemergence: Attempting to spawn a new army for " .. faction_name .. ", but there are no valid spawn locations within range of the player's highest rank Lord")
		return false
	end

	return attempt_to_spawn_scripted_army_in_region(faction, faction_name, subculture, target_region, respawn_data)
end

function attempt_to_spawn_scripted_army_in_region(faction, faction_name, subculture, target_region, respawn_data)
	
	local x, y = cm:find_valid_spawn_location_for_character_from_settlement(
		faction_name, 
		target_region, 
		false, 
		true, 
		spawn_distance_from_settlement
	)
	
	if x < 1 then
		return false
	end
	
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

	local army_manager_suffix = respawn_data.army_manager_suffix or "_horde"
	cm:create_force(
		faction_name,
		random_army_manager:generate_force(subculture .. army_manager_suffix, army_size),
		target_region,
		x,
		y,
		false,
		function(cqi)
			local incident = respawn_data.incident
			
			if incident then
				local human_factions = cm:get_human_factions()
				
				for i = 1, #human_factions do
					local current_faction = cm:get_faction(human_factions[i])
					local current_faction_culture = current_faction:culture()
					
					if not respawn_data.exclude_player_cultures_from_incident[current_faction_culture] then
						cm:trigger_incident_with_targets(
							current_faction:command_queue_index(), 
							incident, 
							faction:command_queue_index(), 
							0, 
							0, 
							0, 
							0, 
							0
						)
					end
				end
			end
			
			-- add recruitment buildings to the spawned horde
			local building = respawn_data.building			
			if building then
				cm:add_building_to_force(cm:get_character_by_cqi(cqi):military_force():command_queue_index(), building)
			end

			if respawn_data.is_region_owning_daemon and respawn_data.effect_bundle_while_regionless then
				local general = cm:get_character_by_cqi(cqi)
				local military_force_cqi = general:military_force():command_queue_index()
				cm:apply_effect_bundle_to_force(respawn_data.effect_bundle_while_regionless, military_force_cqi, 0)
				local bundle_data = { force_cqi = military_force_cqi, effect_bundle = respawn_data.effect_bundle_while_regionless }
				reemergence_persistent.regionless_region_owning_daemon_forces_effect_bundles[faction_name] = bundle_data
			end

			if respawn_data.force_war_on_nearby_region_owner then
				local war_target = reemergence_declare_war_on_nearby_region_owner(faction, subculture, respawn_data.force_war_on_nearby_region_owner, cqi)
				if war_target and not war_target:is_rebel() and not faction:at_war_with(war_target) then
					cm:force_declare_war(faction_name, war_target:name(), true, true)
				end
			end
			
			cm:add_round_turn_countdown_event(faction_reemerge_cooldown_turns, "ScriptEventFactionReemergeCooldownExpired")
			
			cm:set_saved_value("allow_factions_to_reemerge", false)
			cm:set_saved_value(faction_name .. "_dead", 0)
		end
	)

	return true
end

function reemergence_declare_war_on_nearby_region_owner(faction, subculture, war_target_data, cqi)
	local general = cm:get_character_by_cqi(cqi)
	local force_position_x, force_position_y = general:logical_position_x(), general:logical_position_y()
	local region_list = cm:model():world():region_manager():region_list()
	local best_score = -999999
	local best_region_owner = false

	for i = 0, region_list:num_items() - 1 do
		local current_region = region_list:item_at(i)
		local current_region_owner = current_region:owning_faction()
		if war_target_data.allow_selecting_region_owned_by_same_subculture or current_region_owner:subculture() ~= subculture then
			local settlement = current_region:settlement()
			local current_distance_squared = distance_squared(force_position_x, force_position_y, settlement:logical_position_x(), settlement:logical_position_y())
			if current_distance_squared <= (war_target_data.max_squared_distance or 250 * 250) then
				local score = 0
				local primary_slot_building = settlement:primary_slot():building()
				primary_slot_building = primary_slot_building:is_null_interface() and 0 or primary_slot_building:building_level()
				score = score + (primary_slot_building * (war_target_data.region_score_primary_building_level_multiplier or -10))
				score = score + (current_distance_squared * (war_target_data.region_score_squared_distance_multiplier or -0.01))
				for corruption_key, corruption_multiplier in pairs(war_target_data.region_score_province_corruption_multipliers or {}) do
					score = score + (cm:get_corruption_value_in_province(current_region:province(), corruption_key) * corruption_multiplier)
				end

				if score > best_score then
					best_score = score
					best_region_owner = current_region_owner
				end
			end
		end
	end

	return best_region_owner
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("reemergence_persistent", reemergence_persistent, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		reemergence_persistent = cm:load_named_value("reemergence_persistent", reemergence_persistent, context)
	end
)