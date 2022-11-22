local wulfhart_faction = "wh2_dlc13_emp_the_huntmarshals_expedition"

local buildings_to_lock = {"wh_main_emp_barracks_3", "wh_main_emp_stables_2", "wh_main_emp_stables_3", "wh_main_emp_forges_2", "wh_main_emp_forges_3"}

local buildings_to_unlock = {
	{},
	{"wh_main_emp_barracks_3", "wh_main_emp_stables_2"},
	{},
	{"wh_main_emp_stables_3", "wh_main_emp_forges_2"},
	{"wh_main_emp_forges_3"},
	{}
}

-- the timing of when imperial supply happens
local imperial_guard_meter = 90
local imperial_guard_max = 100
local imperial_guard_charge = {2, 3, 4, 6, 8, 1}

-- the strength level and corresponding incident to trigger when imperial supply happens
local imperial_guard_strength = 1
local imperial_guard_strength_dilemma = "wh2_dlc13_wulfhart_imperial_guards_st_"
local imperial_guard_extra_unit_incident = "wh2_dlc13_wulfhart_extra_reinforcement_"

local acclaim_resource_key = "emp_progress"
local acclaim_thresholds = {20, 40, 60, 80, 100}
local acclaim_merc_strength = {1, 2, 2, 3, 3}
local acclaim_enemy_strength = {"lizard_retaliate_low", "lizard_retaliate_low", "lizard_retaliate_mid", "lizard_retaliate_mid", "lizard_retaliate_hig"}
local acclaim_lock = false
local acclaim_resource_factors = {
	["increase"] =			{"settlements_captured",	3},
	["decrease"] =			{"lost_territory",			-2},
	["increase_ports"] =	{"ports_built_or_upgraded",	1},
	["increase_hunters"] =	{"hunters_unlocked",		4}
}

local hostility_resource_key = "emp_wanted"
local hostility_level_current = 0
local hostility_level_increased = 0
local hostility_level_resource_factors = {
	["increase_major"] =				{"settlements_captured",			7},
	["increase_minor"] =				{"raiding_sacking",					2},
	["decrease_major"] =				{"lords_lost",						-10},
	["decrease_minor"] =				{"inactivity",						-0.1},
	["increase_kill_army"] =			{"armies_attacked_and_defeated",	3},
	["increase_event"] =				{"events",							10},
	["reset"] =							{"hostility_level_reset",			-60}
}
local hostility_level_thresholds = {10, 20, 30, 40, 50, 60}
local hostility_level_scripted_army_size = {5, 5, 10, 14, 14, 18}

-- regions that can have armies spawn in them - they must NOT be owned by wulfhart's faction or his allies. 
-- will choose the region with the highest priority. If none are available, no army will spawn.
local hostility_level_scripted_army_spawn_loc = {
	["wh3_main_combi_region_tlaxtlan"]				= {coords = {181, 316}, priority = 9},
	["wh3_main_combi_region_hualotal"]				= {coords = {118, 305}, priority = 8},
	["wh3_main_combi_region_chaqua"]				= {coords ={164, 285}, priority = 7},
	["wh3_main_combi_region_the_high_sentinel"]		= {coords ={101, 406}, priority = 6},
	["wh3_main_combi_region_axlotl"]				= {coords ={210, 242}, priority = 5},
	["wh3_main_combi_region_pahuax"]				= {coords ={100, 419}, priority = 4},
	["wh3_main_combi_region_itza"]					= {coords ={171, 251}, priority = 3},
	["wh3_main_combi_region_xlanhuapec"]			= {coords ={232, 269}, priority = 2},
	["wh3_main_combi_region_hexoatl"]				= {coords ={ 79, 494}, priority = 1},
}

local hostility_level_decay_counter_default = 5
local hostility_level_decay_counter = hostility_level_decay_counter_default
local hostility_level_5_lock_counter_default = 5
local hostility_level_5_lock_counter = 0

local hostility_level_change_events = {
	["increase"] = {"wh2_dlc13_emp_wulfhart_wanted_level_0", "wh2_dlc13_emp_wulfhart_wanted_level_1", "wh2_dlc13_emp_wulfhart_wanted_level_2", "wh2_dlc13_emp_wulfhart_wanted_level_3", "wh2_dlc13_emp_wulfhart_wanted_level_4", "wh2_dlc13_emp_wulfhart_wanted_level_5"},
	["decrease"] = "wh2_dlc13_emp_wulfhart_wanted_level_decreased",
	["reset"] = "wh2_dlc13_emp_wulfhart_wanted_level_reset"
}

local hostility_level_enemy_buffs = {
	"wh2_dlc13_wanted_level_enemy_buff_1",
	"wh2_dlc13_wanted_level_enemy_buff_2",
	"wh2_dlc13_wanted_level_enemy_buff_3",
	"wh2_dlc13_wanted_level_enemy_buff_4",
	"wh2_dlc13_wanted_level_enemy_buff_5"
}

local hostility_level_scripted_army_faction = "wh2_dlc13_lzd_avengers"

local queued_hostility_level_army_spawn = {
	["counter"] = 2,
	["strength_level"] = "lizard_retaliate_low",
	["loc"] = {"wh3_main_combi_region_temple_of_kara", {128, 370}},
	["valid"] = false
}

local elector_count_counter_default = 9
local elector_count_index = {"averland", "reikland", "hochland", "middenland", "nordland", "ostermark", "ostland", "stirland", "talabecland", "wissenland"}

-- elector count details, name, affinity, and favor effect dummy
local elector_count_details = {
	["averland"] =		{0, "wh2_dlc13_wulfhart_favor_of_A_dummy"},
	["reikland"] =		{0, "wh2_dlc13_wulfhart_favor_of_B_dummy"},
	["hochland"] =		{0, "wh2_dlc13_wulfhart_favor_of_C_dummy"},
	["middenland"] =	{0, "wh2_dlc13_wulfhart_favor_of_D_dummy"},
	["nordland"] =		{0, "wh2_dlc13_wulfhart_favor_of_E_dummy"},
	["ostermark"] =		{0, "wh2_dlc13_wulfhart_favor_of_F_dummy"},
	["ostland"] =		{0, "wh2_dlc13_wulfhart_favor_of_G_dummy"},
	["stirland"] =		{0, "wh2_dlc13_wulfhart_favor_of_H_dummy"},
	["talabecland"] =	{0, "wh2_dlc13_wulfhart_favor_of_I_dummy"},
	["wissenland"] =	{0, "wh2_dlc13_wulfhart_favor_of_J_dummy"},
	["counter"] = elector_count_counter_default,
	["ongoing"] = false
}

local elector_count_weight_table = {1, 1, 1, 1, 1, 2, 2, 2}

local elector_count_dilemmas = {
	["averland"] = {
		"wh2_dlc13_wulfhart_dilemma_A_D_H",
		"wh2_dlc13_wulfhart_dilemma_A_E_I",
		"wh2_dlc13_wulfhart_dilemma_A_F_J",
		"wh2_dlc13_wulfhart_dilemma_A_G_H",
		"wh2_dlc13_wulfhart_dilemma_D_H_A",
		"wh2_dlc13_wulfhart_dilemma_E_J_A",
		"wh2_dlc13_wulfhart_dilemma_F_I_A",
		"wh2_dlc13_wulfhart_dilemma_G_H_A",
		"wh2_dlc13_wulfhart_dilemma_H_A_E",
		"wh2_dlc13_wulfhart_dilemma_I_A_D",
		"wh2_dlc13_wulfhart_dilemma_J_A_G"
	},
	["reikland"] = {
		"wh2_dlc13_wulfhart_dilemma_B_D_I",
		"wh2_dlc13_wulfhart_dilemma_B_E_J",
		"wh2_dlc13_wulfhart_dilemma_B_F_H",
		"wh2_dlc13_wulfhart_dilemma_B_G_I",
		"wh2_dlc13_wulfhart_dilemma_D_I_B",
		"wh2_dlc13_wulfhart_dilemma_E_H_B",
		"wh2_dlc13_wulfhart_dilemma_F_J_B",
		"wh2_dlc13_wulfhart_dilemma_G_I_B",
		"wh2_dlc13_wulfhart_dilemma_H_B_F",
		"wh2_dlc13_wulfhart_dilemma_I_B_E",
		"wh2_dlc13_wulfhart_dilemma_J_B_D"
	},
	["hochland"] = {
		"wh2_dlc13_wulfhart_dilemma_C_D_J",
		"wh2_dlc13_wulfhart_dilemma_C_E_H",
		"wh2_dlc13_wulfhart_dilemma_C_F_I",
		"wh2_dlc13_wulfhart_dilemma_C_G_J",
		"wh2_dlc13_wulfhart_dilemma_D_J_C",
		"wh2_dlc13_wulfhart_dilemma_E_I_C",
		"wh2_dlc13_wulfhart_dilemma_F_H_C",
		"wh2_dlc13_wulfhart_dilemma_G_J_C",
		"wh2_dlc13_wulfhart_dilemma_H_C_G",
		"wh2_dlc13_wulfhart_dilemma_I_C_F",
		"wh2_dlc13_wulfhart_dilemma_J_C_E"
	},
	["middenland"] = {
		"wh2_dlc13_wulfhart_dilemma_A_D_H",
		"wh2_dlc13_wulfhart_dilemma_B_D_I",
		"wh2_dlc13_wulfhart_dilemma_C_D_J",
		"wh2_dlc13_wulfhart_dilemma_D_H_A",
		"wh2_dlc13_wulfhart_dilemma_D_I_B",
		"wh2_dlc13_wulfhart_dilemma_D_J_C",
		"wh2_dlc13_wulfhart_dilemma_I_A_D",
		"wh2_dlc13_wulfhart_dilemma_J_B_D"
	},
	["nordland"] = {
		"wh2_dlc13_wulfhart_dilemma_A_E_I",
		"wh2_dlc13_wulfhart_dilemma_B_E_J",
		"wh2_dlc13_wulfhart_dilemma_C_E_H",
		"wh2_dlc13_wulfhart_dilemma_E_H_B",
		"wh2_dlc13_wulfhart_dilemma_E_I_C",
		"wh2_dlc13_wulfhart_dilemma_E_J_A",
		"wh2_dlc13_wulfhart_dilemma_H_A_E",
		"wh2_dlc13_wulfhart_dilemma_I_B_E",
		"wh2_dlc13_wulfhart_dilemma_J_C_E"
	},
	["ostermark"] = {
		"wh2_dlc13_wulfhart_dilemma_A_F_J",
		"wh2_dlc13_wulfhart_dilemma_B_F_H",
		"wh2_dlc13_wulfhart_dilemma_C_F_I",
		"wh2_dlc13_wulfhart_dilemma_F_H_C",
		"wh2_dlc13_wulfhart_dilemma_F_I_A",
		"wh2_dlc13_wulfhart_dilemma_F_J_B",
		"wh2_dlc13_wulfhart_dilemma_H_B_F",
		"wh2_dlc13_wulfhart_dilemma_I_C_F"
	},
	["ostland"] = {
		"wh2_dlc13_wulfhart_dilemma_A_G_H",
		"wh2_dlc13_wulfhart_dilemma_B_G_I",
		"wh2_dlc13_wulfhart_dilemma_C_G_J",
		"wh2_dlc13_wulfhart_dilemma_G_H_A",
		"wh2_dlc13_wulfhart_dilemma_G_I_B",
		"wh2_dlc13_wulfhart_dilemma_G_J_C",
		"wh2_dlc13_wulfhart_dilemma_H_C_G",
		"wh2_dlc13_wulfhart_dilemma_J_A_G"
	},
	["stirland"] = {
		"wh2_dlc13_wulfhart_dilemma_A_D_H",
		"wh2_dlc13_wulfhart_dilemma_A_G_H",
		"wh2_dlc13_wulfhart_dilemma_B_F_H",
		"wh2_dlc13_wulfhart_dilemma_C_E_H",
		"wh2_dlc13_wulfhart_dilemma_E_H_B",
		"wh2_dlc13_wulfhart_dilemma_F_H_C",
		"wh2_dlc13_wulfhart_dilemma_G_H_A",
		"wh2_dlc13_wulfhart_dilemma_H_A_E",
		"wh2_dlc13_wulfhart_dilemma_H_B_F",
		"wh2_dlc13_wulfhart_dilemma_H_C_G"
	},
	["talabecland"] = {
		"wh2_dlc13_wulfhart_dilemma_A_E_I",
		"wh2_dlc13_wulfhart_dilemma_B_D_I",
		"wh2_dlc13_wulfhart_dilemma_B_G_I",
		"wh2_dlc13_wulfhart_dilemma_C_F_I",
		"wh2_dlc13_wulfhart_dilemma_D_I_B",
		"wh2_dlc13_wulfhart_dilemma_E_I_C",
		"wh2_dlc13_wulfhart_dilemma_F_I_A",
		"wh2_dlc13_wulfhart_dilemma_G_I_B",
		"wh2_dlc13_wulfhart_dilemma_I_A_D",
		"wh2_dlc13_wulfhart_dilemma_I_B_E",
		"wh2_dlc13_wulfhart_dilemma_I_C_F"
	},
	["wissenland"] = {
		"wh2_dlc13_wulfhart_dilemma_A_F_J",
		"wh2_dlc13_wulfhart_dilemma_B_E_J",
		"wh2_dlc13_wulfhart_dilemma_C_D_J",
		"wh2_dlc13_wulfhart_dilemma_C_G_J",
		"wh2_dlc13_wulfhart_dilemma_D_J_C",
		"wh2_dlc13_wulfhart_dilemma_E_J_A",
		"wh2_dlc13_wulfhart_dilemma_F_J_B",
		"wh2_dlc13_wulfhart_dilemma_G_J_C",
		"wh2_dlc13_wulfhart_dilemma_J_A_G",
		"wh2_dlc13_wulfhart_dilemma_J_B_D",
		"wh2_dlc13_wulfhart_dilemma_J_C_E"
	}
}

local elector_count_incidents = {
	["averland"] =	 	{"wh2_dlc13_wulfhart_reward_A", "wh2_dlc13_wulfhart_reward_A_unit"},
	["reikland"] =	 	{"wh2_dlc13_wulfhart_reward_B", "wh2_dlc13_wulfhart_reward_B_unit"},
	["hochland"] =	 	{"wh2_dlc13_wulfhart_reward_C", "wh2_dlc13_wulfhart_reward_C_unit"},
	["middenland"] = 	{"wh2_dlc13_wulfhart_reward_D", "wh2_dlc13_wulfhart_reward_D_unit"},
	["nordland"] =	 	{"wh2_dlc13_wulfhart_reward_E", "wh2_dlc13_wulfhart_reward_E_unit"},
	["ostermark"] =	 	{"wh2_dlc13_wulfhart_reward_F", "wh2_dlc13_wulfhart_reward_F_unit"},
	["ostland"] =	 	{"wh2_dlc13_wulfhart_reward_G", "wh2_dlc13_wulfhart_reward_G_unit"},
	["stirland"] =	 	{"wh2_dlc13_wulfhart_reward_H", "wh2_dlc13_wulfhart_reward_H_unit"},
	["talabecland"] =	{"wh2_dlc13_wulfhart_reward_I", "wh2_dlc13_wulfhart_reward_I_unit"},
	["wissenland"] =	{"wh2_dlc13_wulfhart_reward_J", "wh2_dlc13_wulfhart_reward_J_unit"},
	["generic"] = {
		"wh2_dlc13_wulfhart_reward_1",
		"wh2_dlc13_wulfhart_reward_2",
		"wh2_dlc13_wulfhart_reward_3"
	},
	["affinity_threshold"] = 5
}

local elector_count_reward_queued = {
	["event"] = "",
	["counter"] = 0,
	["active"] = false
}

local supply_delay_counter = 0

function add_wulfhart_imperial_supply_listeners()
	update_acclaim_bar()
	setup_hostility_spawnable_army_compositions()
	
	update_hostility_ui_component()
	
	-- apply effect bundles to all opposing military forces when wulfhart fights a battle
	core:add_listener(
		"apply_wanted_level_enemy_buff_bundle",
		"PendingBattle",
		function()
			return cm:pending_battle_cache_faction_is_involved(wulfhart_faction) and cm:get_faction(wulfhart_faction):is_human() and not cm:model():pending_battle():has_been_fought() and hostility_level_enemy_buffs[hostility_level_current]
		end,
		function()
			if cm:pending_battle_cache_faction_is_attacker(wulfhart_faction) then
				for i = 1, cm:pending_battle_cache_num_defenders() do
					local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i)
					cm:apply_effect_bundle_to_force(hostility_level_enemy_buffs[hostility_level_current], current_mf_cqi, 0)
				end
			elseif cm:pending_battle_cache_faction_is_defender(wulfhart_faction) then
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i)
					cm:apply_effect_bundle_to_force(hostility_level_enemy_buffs[hostility_level_current], current_mf_cqi, 0)
				end
			end
			
			cm:update_pending_battle()
		end,
		true
	)
	
	-- remove effect bundles after the battle is completed
	core:add_listener(
		"remove_wanted_level_enemy_buff_bundle",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_faction_is_involved(wulfhart_faction) and cm:get_faction(wulfhart_faction):is_human() and hostility_level_enemy_buffs[hostility_level_current]
		end,
		function()
			local function remove_effect_bundle_from_mf(cqi)
				local mf = cm:get_military_force_by_cqi(cqi)
				
				if mf then
					for j = 1, #hostility_level_enemy_buffs do
						 if mf:has_effect_bundle(hostility_level_enemy_buffs[j]) then
							cm:remove_effect_bundle_from_force(hostility_level_enemy_buffs[j], cqi)
						end
					end
				end
			end
			
			if cm:pending_battle_cache_faction_is_attacker(wulfhart_faction) then
				for i = 1, cm:pending_battle_cache_num_defenders() do
					local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i)
					remove_effect_bundle_from_mf(current_mf_cqi)
				end
			elseif cm:pending_battle_cache_faction_is_defender(wulfhart_faction) then
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i)
					remove_effect_bundle_from_mf(current_mf_cqi)
				end
			end
		end,
		true
	)
	
	-- update the imperial supply charge at beginning of turn
	core:add_listener(
		"faction_turn_start_wulfhart_imperial_supply",
		"ScriptEventHumanFactionTurnStart",
		function(context)
			return context:faction():name() == wulfhart_faction
		end,
		function(context)
			-- checks if there's any delay on it
			local bv = cm:get_factions_bonus_value(context:faction(), "imperial_supplies_delay")
			
			if supply_delay_counter == 0 and bv > 0 then
				supply_delay_counter = bv
			end
			
			if supply_delay_counter > 0 then
				supply_delay_counter = supply_delay_counter - 1
			else
				imperial_guard_meter = imperial_guard_meter + imperial_guard_charge[hostility_level_current + 1]
				
				if imperial_guard_meter >= imperial_guard_max then
					trigger_imperial_reinforcements_event()
				end
			end
		end,
		true
	)
	
	-- show a bonus incident after the dilemma is selected
	core:add_listener(
		"dilemma_choice_made_distribute_imperial_supply",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma():starts_with("wh2_dlc13_wulfhart_")
		end,
		function(context)
			local faction = context:faction()
			local faction_name = context:faction():name()
			local dilemma = context:dilemma()
			
			if dilemma:starts_with(imperial_guard_strength_dilemma) and cm:get_factions_bonus_value(faction, "imperial_supply_extra") > 0 then
				cm:trigger_incident(faction_name, dilemma:gsub(imperial_guard_strength_dilemma, imperial_guard_extra_unit_incident), true)
				
				if faction:has_effect_bundle("wh2_dlc13_wulfhart_stronger_imperial_supply") then
					cm:remove_effect_bundle("wh2_dlc13_wulfhart_stronger_imperial_supply", faction_name)
				end
			end
			
			cm:callback(
				function()
					if faction:has_effect_bundle("wh2_dlc13_wulfhart_wanted_bar_increase") then
						update_hostility_bar("increase_event")
						cm:remove_effect_bundle("wh2_dlc13_wulfhart_wanted_bar_increase", faction_name)
					end
				end,
				0.5
			)
		end,
		true
	)
	
	core:add_listener(
		"adding_progress_for_hunter_unlock",
		"HunterUnlocked",
		true,
		function()
			update_acclaim_bar("increase_hunters")
		end,
		true
	)
	
	-- check all events tied to acclaim factors
	core:add_listener(
		"checking_progression_factor_1",
		"RegionFactionChangeEvent",
		true,
		function(context)
			local owning_faction = context:region():owning_faction()
			
			if not owning_faction:is_null_interface() and owning_faction:name() == wulfhart_faction and owning_faction:is_human() then
				update_acclaim_bar("increase")
			else
				local previous_faction = context:previous_faction()
				
				if not previous_faction:is_null_interface() and previous_faction:name() == wulfhart_faction and previous_faction:is_human() then
					update_acclaim_bar("decrease")
					core:trigger_event("ScriptEventMandateLostSettlement")
				end
			end
		end,
		true
	)
	
	core:add_listener(
		"checking_progression_factor_2",
		"BuildingCompleted",
		function(context)
			local building = context:building()
			local faction = building:faction()
			local building_name = building:name()
			
			return faction:is_human() and faction:name() == wulfhart_faction and (building_name == "wh_main_emp_port_1" or building_name == "wh_main_emp_port_2" or building_name == "wh_main_emp_port_3")
		end,
		function()
			update_acclaim_bar("increase_ports")
		end,
		true
	)
	
	core:add_listener(
		"wanted_bar_update_occupy",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			local faction = context:character():faction()
			return faction:is_human() and faction:name() == wulfhart_faction
		end,
		function(context)
			local occupation_decision = context:occupation_decision_type()
			
			if occupation_decision == "occupation_decision_loot" or occupation_decision == "occupation_decision_occupy" or occupation_decision == "occupation_decision_raze_without_occupy" then
				update_hostility_bar("increase_major")
			elseif occupation_decision == "occupation_decision_sack" then
				update_hostility_bar("increase_minor")
			end
		end,
		true
	)
	
	core:add_listener(
		"wanted_bar_update_post_battle",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_faction_is_involved(wulfhart_faction) and cm:get_faction(wulfhart_faction):is_human()
		end,
		function()
			local num_attackers_wounded = 0
			local num_defenders_wounded = 0
			
			local defender_is_scripted_army = false
			local defender_is_rebel = false
			
			for i = 1, cm:pending_battle_cache_num_defenders() do
				local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i)
				local character = cm:get_character_by_cqi(this_char_cqi)
				
				if not character or (not character:military_force():is_armed_citizenry() and character:is_wounded()) then
					num_defenders_wounded = num_defenders_wounded + 1
				end
				
				if current_faction_name == "rebels" then
					defender_is_rebel = true
				elseif current_faction_name == hostility_level_scripted_army_faction then
					defender_is_scripted_army = true
				end
			end
			
			if cm:pending_battle_cache_faction_is_attacker(wulfhart_faction) then
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i)
					local character = cm:get_character_by_cqi(this_char_cqi)
					
					if not character or (not character:military_force():is_armed_citizenry() and character:is_wounded()) then
						num_attackers_wounded = num_attackers_wounded + 1
					end
				end
				
				if cm:pending_battle_cache_attacker_victory() then
					if not defender_is_scripted_army and not defender_is_rebel then
						-- player won the battle against a regular army
						update_hostility_bar("increase_kill_army")
					end
				elseif num_attackers_wounded > 0 then
					-- player lost the battle and at least one character was wounded
					update_hostility_bar("decrease_major")
				end
			elseif cm:pending_battle_cache_faction_is_defender(wulfhart_faction) and cm:model():pending_battle():is_draw() and num_defenders_wounded > 0 then
				-- player drew a defensive battle and at least one character was wounded
				update_hostility_bar("decrease_major")
			end
		end,
		true
	)
	
	core:add_listener(
		"wanted_bar_update_turn_start",
		"ScriptEventHumanFactionTurnStart",
		function(context)
			return context:faction():name() == wulfhart_faction
		end,
		function(context)
			local faction = context:faction()
			local faction_name = faction:name()
			local mf_list = faction:military_force_list()
			
			for i = 0, mf_list:num_items() - 1 do
				if mf_list:item_at(i):active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" then
					update_hostility_bar("increase_minor")
				end
			end
			
			-- invasion army spawning
			if hostility_level_current == 5 and hostility_level_5_lock_counter > 0 then
				hostility_level_5_lock_counter = hostility_level_5_lock_counter - 1
				update_hostility_ui_component()
				
				if hostility_level_5_lock_counter == 0 then
					update_hostility_bar("reset")
				end
			elseif hostility_level_increased <= 0 and hostility_level_decay_counter > 0 then
				hostility_level_decay_counter = hostility_level_decay_counter - 1
				
				if hostility_level_decay_counter == 0 then
					update_hostility_bar("decrease_minor")
				end
			end
			
			hostility_level_increased = 0
			update_hostility_bar()
			update_acclaim_bar()
			update_queued_spawn()
			
			-- elector count dilemmas and counters
			if elector_count_details["counter"] > 0 then
				elector_count_details["counter"] = elector_count_details["counter"] - 1
			elseif elector_count_details["counter"] == 0 and not elector_count_details["ongoing"] then
				elector_count_details["counter"] = elector_count_counter_default
				cm:trigger_dilemma(faction_name, get_the_target_elector_count_event())
				elector_count_details["ongoing"] = true
			end
			
			if elector_count_details["ongoing"] then
				for i = 1, #elector_count_index do
					local current_elector_count = elector_count_index[i]
					
					if faction:has_effect_bundle(elector_count_details[current_elector_count][2]) then
						elector_count_details[current_elector_count][1] = elector_count_details[current_elector_count][1] + 1
						
						if elector_count_details[current_elector_count][1] == elector_count_incidents["affinity_threshold"] then
							reset_elector_count_reward(elector_count_incidents[current_elector_count][1])
						elseif elector_count_details[current_elector_count][1] > elector_count_incidents["affinity_threshold"] then
							reset_elector_count_reward(elector_count_incidents[current_elector_count][2])
						else
							reset_elector_count_reward(elector_count_incidents["generic"][cm:random_number(#elector_count_incidents["generic"])])
						end
						
						cm:remove_effect_bundle(elector_count_details[current_elector_count][2], faction_name)
						elector_count_details["ongoing"] = false
					end
				end
			end
			
			if elector_count_reward_queued["active"] then
				if elector_count_reward_queued["counter"] == 0 then
					cm:trigger_incident(faction_name, elector_count_reward_queued["event"], true)
					elector_count_reward_queued["active"] = false
				else
					elector_count_reward_queued["counter"] = elector_count_reward_queued["counter"] - 1
				end
			end
		end,
		true
	)
	
	core:add_listener(
		"wanted_bar_update_neutural",
		"FactionTurnEnd",
		function(context)
			local faction = context:faction()
			
			return faction:name() == wulfhart_faction and faction:is_human() and hostility_level_increased > 0
		end,
		function()
			hostility_level_decay_counter = hostility_level_decay_counter_default
		end,
		true
	)
end

function get_spawnable_region_not_owned_by_wulfhart()
	local current_top_region = false
	local current_choice_priority = 0

	for region_key, details in pairs(hostility_level_scripted_army_spawn_loc) do
		local region = cm:get_region(region_key)
		if region:is_abandoned() or not faction_is_wulfhart_or_ally(region:owning_faction()) then
			if details.priority > current_choice_priority then
				current_top_region = region_key
				current_choice_priority = details.priority
			end
		end
	end
	
	return current_top_region
end

function faction_is_wulfhart_or_ally(faction_interface)
	return faction_interface:name() == wulfhart_faction or faction_interface:allied_with(cm:get_faction(wulfhart_faction))
end


function setup_hostility_spawnable_army_compositions()
	-- low strength
	random_army_manager:new_force("lizard_retaliate_low")
	random_army_manager:add_mandatory_unit("lizard_retaliate_low", "wh2_main_lzd_inf_skink_cohort_0", 4)
	random_army_manager:add_mandatory_unit("lizard_retaliate_low", "wh2_main_lzd_inf_saurus_spearmen_0", 2)
	random_army_manager:add_unit("lizard_retaliate_low", "wh2_main_lzd_inf_skink_cohort_1", 1)
	random_army_manager:add_unit("lizard_retaliate_low", "wh2_dlc12_lzd_inf_skink_red_crested_0", 1)
	random_army_manager:add_unit("lizard_retaliate_low", "wh2_main_lzd_cav_terradon_riders_0", 1)
	
	-- mid strength
	random_army_manager:new_force("lizard_retaliate_mid")
	random_army_manager:add_mandatory_unit("lizard_retaliate_mid", "wh2_main_lzd_inf_saurus_spearmen_0", 3)
	random_army_manager:add_mandatory_unit("lizard_retaliate_mid", "wh2_main_lzd_inf_saurus_spearmen_1", 3)
	random_army_manager:add_mandatory_unit("lizard_retaliate_mid", "wh2_main_lzd_cav_cold_one_spearmen_1", 2)
	random_army_manager:add_mandatory_unit("lizard_retaliate_mid", "wh2_main_lzd_mon_kroxigors", 2)
	random_army_manager:add_mandatory_unit("lizard_retaliate_mid", "wh2_main_lzd_mon_carnosaur_0", 1)
	random_army_manager:add_unit("lizard_retaliate_mid", "wh2_main_lzd_inf_chameleon_skinks_0", 1)
	random_army_manager:add_unit("lizard_retaliate_mid", "wh2_main_lzd_cav_terradon_riders_1", 1)
	
	-- high strength
	random_army_manager:new_force("lizard_retaliate_hig")
	random_army_manager:add_mandatory_unit("lizard_retaliate_hig", "wh2_main_lzd_inf_temple_guards", 2)
	random_army_manager:add_mandatory_unit("lizard_retaliate_hig", "wh2_main_lzd_cav_horned_ones_0", 2)
	random_army_manager:add_mandatory_unit("lizard_retaliate_hig", "wh2_main_lzd_mon_kroxigors", 3)
	random_army_manager:add_mandatory_unit("lizard_retaliate_hig", "wh2_main_lzd_mon_carnosaur_0", 1)
	random_army_manager:add_mandatory_unit("lizard_retaliate_hig", "wh2_dlc12_lzd_mon_ancient_stegadon_1", 1)
	random_army_manager:add_mandatory_unit("lizard_retaliate_hig", "wh2_dlc13_lzd_mon_dread_saurian_0", 1)
	random_army_manager:add_unit("lizard_retaliate_hig", "wh2_main_lzd_inf_chameleon_skinks_0", 1)
	random_army_manager:add_unit("lizard_retaliate_hig", "wh2_dlc12_lzd_cav_ripperdactyl_riders_0", 1)
	random_army_manager:add_unit("lizard_retaliate_hig", "wh2_main_lzd_mon_bastiladon_0", 1)
end

function trigger_imperial_reinforcements_event()
	update_imperial_reinforcements_strength()
	
	if cm:get_faction(wulfhart_faction):is_human() then
		cm:trigger_dilemma(wulfhart_faction, imperial_guard_strength_dilemma .. imperial_guard_strength)
	end
	
	imperial_guard_meter = 0
end

-- edit the imperial supply strength, called when acclaim bar changes
function update_imperial_reinforcements_strength()
	local resource_value = cm:get_faction(wulfhart_faction):pooled_resource_manager():resource(acclaim_resource_key):value()
	
	for i = 1, #acclaim_thresholds do
		if resource_value < acclaim_thresholds[i] then
			imperial_guard_strength = acclaim_merc_strength[i]
			return
		elseif resource_value == 100 then
			imperial_guard_strength = acclaim_merc_strength[#acclaim_merc_strength]
			return
		end
	end
end

-- this will update the acclaim pooled resource based on player's occupation of lustria
function update_acclaim_bar(factor)
	local faction = cm:get_faction(wulfhart_faction)
	
	local previous_acclaim_value = faction:pooled_resource_manager():resource(acclaim_resource_key):value()
	
	if factor and acclaim_resource_factors[factor] and not acclaim_lock then
		cm:faction_add_pooled_resource(wulfhart_faction, acclaim_resource_key, acclaim_resource_factors[factor][1], acclaim_resource_factors[factor][2])
	end
	
	local current_acclaim_value = faction:pooled_resource_manager():resource(acclaim_resource_key):value()
	
	local function lock_wulfhart_buildings(index)
		for i = index, #buildings_to_lock do
			cm:add_event_restricted_building_record_for_faction(buildings_to_lock[i], wulfhart_faction, "wulfhart_building_lock")
		end
	end
	
	-- trigger an event reminding about progression reward
	for i = 1, #acclaim_thresholds do
		if previous_acclaim_value < acclaim_thresholds[i] and current_acclaim_value >= acclaim_thresholds[i] then
			cm:trigger_incident(wulfhart_faction, "wh2_dlc13_emp_wulfhart_progress_level_increase", true)
			
			for j = 1, #buildings_to_unlock[i + 1] do
				cm:remove_event_restricted_building_record_for_faction(buildings_to_unlock[i + 1][j], wulfhart_faction)
			end
			
			lock_wulfhart_buildings(i + 2)
		elseif previous_acclaim_value >= acclaim_thresholds[i] and current_acclaim_value < acclaim_thresholds[i] then
			lock_wulfhart_buildings(i + 1)
		elseif current_acclaim_value < acclaim_thresholds[1] then
			lock_wulfhart_buildings(1)
		end
	end
	
	update_imperial_reinforcements_strength()
	
	-- trigger endgame mechanics
	if faction:pooled_resource_manager():resource(acclaim_resource_key):value() >= acclaim_thresholds[#acclaim_thresholds] and not acclaim_lock then
		acclaim_lock = true
	end
end

function spawn_hostility_army(army_template, size, loc)
	if not loc then
		loc = hostility_level_scripted_army_spawn_loc[get_spawnable_region_not_owned_by_wulfhart()].coords
	end

	if not loc then
		return false
	end
	
	loc[1], loc[2] = cm:find_valid_spawn_location_for_character_from_position(hostility_level_scripted_army_faction, loc[1], loc[2], true, 3)
	
	local invasion_faction_has_armies = false
	
	for _, current_mf in model_pairs(cm:get_faction(hostility_level_scripted_army_faction):military_force_list()) do
		if not current_mf:is_armed_citizenry() then
			invasion_faction_has_armies = true
			break
		end
	end
	
	if not invasion_faction_has_armies then
		local scripted_army_wanted = invasion_manager:new_invasion("wanted_bar_army_" .. tostring(cm:model():turn_number()), hostility_level_scripted_army_faction, random_army_manager:generate_force(army_template, size), loc)
		scripted_army_wanted.target = wulfhart_faction
		scripted_army_wanted.human = false
		scripted_army_wanted:apply_effect("wh2_dlc13_elector_invasion_enemy", 0)
		scripted_army_wanted:start_invasion(
			function(self)
				local force_leader = self:get_general()
				
				if force_leader:has_region() then
					cm:make_region_visible_in_shroud(wulfhart_faction, force_leader:region():name())
				end
				
				cm:force_declare_war(hostility_level_scripted_army_faction, wulfhart_faction, false, false)
				
				cm:trigger_incident_with_targets(cm:get_faction(wulfhart_faction):command_queue_index(), "wh2_dlc13_incident_hostility_invasion", 0, 0, force_leader:command_queue_index(), 0, 0, 0)
			end,
			false,
			false,
			false
		)
	end
end

function update_hostility_bar(factor) 
	local hostility_level_previous = hostility_level_current
	
	if factor then
		if factor:starts_with("decrease") then
			core:trigger_event("ScriptEventHostilityDecreased")
		end
	
		if hostility_level_resource_factors[factor] then
			if hostility_level_resource_factors[factor][2] == 0 then
				local round = hostility_level_thresholds[hostility_level_current + 1] * hostility_level_resource_factors[factor][2]
				round = math.floor((math.floor(round * 2) + 1) / 2)
				cm:faction_add_pooled_resource(wulfhart_faction, hostility_resource_key, hostility_level_resource_factors[factor][1], round)
			else
				cm:faction_add_pooled_resource(wulfhart_faction, hostility_resource_key, hostility_level_resource_factors[factor][1], hostility_level_resource_factors[factor][2])
			end
			
			if hostility_level_resource_factors[factor][2] > 0 then
				hostility_level_increased = hostility_level_increased + hostility_level_resource_factors[factor][2]
			end
		end
	end
	
	-- define the hostility level based on the resource
	local hostility_value = cm:get_faction(wulfhart_faction):pooled_resource_manager():resource(hostility_resource_key):value()
	
	if hostility_value < hostility_level_thresholds[1] then
		hostility_level_current = 0
	elseif hostility_value < hostility_level_thresholds[2] then
		hostility_level_current = 1
	elseif hostility_value < hostility_level_thresholds[3] then
		hostility_level_current = 2
	elseif hostility_value < hostility_level_thresholds[4] then
		hostility_level_current = 3
	elseif hostility_value < hostility_level_thresholds[5] then
		hostility_level_current = 4
	else
		hostility_level_current = 5
	end
	
	-- spawn instant invasion army when hostility level increase
	if hostility_level_current > hostility_level_previous then
		cm:trigger_incident(wulfhart_faction, hostility_level_change_events["increase"][hostility_level_current + 1], true)
		
		if hostility_level_current == 5 then
			local location_key = get_spawnable_region_not_owned_by_wulfhart()

			if location_key then 
				local location_num = hostility_level_scripted_army_spawn_loc[location_key].coords
				queued_hostility_level_army_spawn["loc"][1] = location_key
				queued_hostility_level_army_spawn["loc"][2] = location_num
			
				local strength_level = false
				local resource_value = cm:get_faction(wulfhart_faction):pooled_resource_manager():resource(acclaim_resource_key):value()
				
				for i = 1, #acclaim_thresholds do
					if resource_value < acclaim_thresholds[i] then
						strength_level = acclaim_enemy_strength[i]
						break
					elseif resource_value == 100 then
						strength_level = acclaim_enemy_strength[#acclaim_enemy_strength]
						break
					end
				end
				
				queued_hostility_level_army_spawn["strength_level"] = strength_level
				
				queued_hostility_level_army_spawn["counter"] = 3
				queued_hostility_level_army_spawn["valid"] = true
				update_queued_spawn()

			end

			trigger_imperial_reinforcements_event()
			hostility_level_5_lock_counter = hostility_level_5_lock_counter_default
		end
	elseif hostility_level_current < hostility_level_previous then
		if hostility_level_current == 0 and hostility_level_previous == 5 then
			cm:trigger_incident(wulfhart_faction, hostility_level_change_events["reset"], true)
		else
			cm:trigger_incident(wulfhart_faction, hostility_level_change_events["decrease"], true)
		end
	end
	
	update_hostility_ui_component()
end

function update_queued_spawn()
	if queued_hostility_level_army_spawn["valid"] then
		queued_hostility_level_army_spawn["counter"] = queued_hostility_level_army_spawn["counter"] - 1
		
		if queued_hostility_level_army_spawn["counter"] == 0 then
			spawn_hostility_army(queued_hostility_level_army_spawn["strength_level"], hostility_level_scripted_army_size[hostility_level_current + 1], queued_hostility_level_army_spawn["loc"][2])
		elseif queued_hostility_level_army_spawn["counter"] > 0 then
			local loc = queued_hostility_level_army_spawn["loc"][2]
			
			cm:show_message_event_located(
				wulfhart_faction,
				"event_feed_strings_text_wh2_dlc13_event_feed_string_scripted_event_incoming_hostility_invasion_title",
				"regions_onscreen_" .. cm:model():world():region_data_at_position(loc[1], loc[2]):key(),
				"event_feed_strings_text_wh2_dlc13_event_feed_string_scripted_event_hostility_invasion_" .. queued_hostility_level_army_spawn["counter"] .. "_secondary_detail",
				loc[1],
				loc[2],
				false,
				1311
			)
		end
	end
end

function update_hostility_ui_component()
	if cm:get_local_faction_name(true) == wulfhart_faction then
		local compo = find_uicomponent(core:get_ui_root(), "hostility_number_holder")
		
		if hostility_level_5_lock_counter > 0 then
			compo:InterfaceFunction("SetCooldown", true)
			common.set_context_value("wanted_level_cooldown", hostility_level_5_lock_counter)
		else
			compo:InterfaceFunction("SetCooldown", false)
			common.set_context_value("wanted_level_turns", math.ceil((imperial_guard_max - imperial_guard_meter) / imperial_guard_charge[hostility_level_current + 1]) + supply_delay_counter)
		end
	end
end

-- pick a dilemma to trigger based on the rankings of each elector count
function get_the_target_elector_count_event()
	local elector_count_ranks = {
		{},
		{},
		{}
	}
	
	for i = 1, #elector_count_index do
		local current_elector_count = elector_count_index[i]
		local current_elector_count_affinity = elector_count_details[current_elector_count][1]
		
		if #elector_count_ranks[1] == 0 then
			table.insert(elector_count_ranks[1], current_elector_count)
		elseif current_elector_count_affinity > elector_count_details[elector_count_ranks[1][1]][1] then
			elector_count_ranks[3] = elector_count_ranks[2]
			elector_count_ranks[2] = elector_count_ranks[1]
			elector_count_ranks[1] = {}
			table.insert(elector_count_ranks[1], current_elector_count)
		elseif current_elector_count_affinity == elector_count_details[elector_count_ranks[1][1]][1] then
			table.insert(elector_count_ranks[1], current_elector_count)
			
		elseif #elector_count_ranks[2] == 0 then
			table.insert(elector_count_ranks[2], current_elector_count)
		elseif current_elector_count_affinity > elector_count_details[elector_count_ranks[2][1]][1] then
			elector_count_ranks[3] = elector_count_ranks[2]
			elector_count_ranks[2] = {}
			table.insert(elector_count_ranks[2], current_elector_count)
		elseif current_elector_count_affinity == elector_count_details[elector_count_ranks[2][1]][1] then
			table.insert(elector_count_ranks[2], current_elector_count)
			
		elseif #elector_count_ranks[3] == 0 then
			table.insert(elector_count_ranks[3], current_elector_count)
		elseif current_elector_count_affinity > elector_count_details[elector_count_ranks[3][1]][1] then
			elector_count_ranks[3] = {}
			table.insert(elector_count_ranks[3], current_elector_count)
		elseif current_elector_count_affinity == elector_count_details[elector_count_ranks[3][1]][1] then
			table.insert(elector_count_ranks[3], current_elector_count)
		end
	end
	
	local number_of_empty_ranks = #elector_count_ranks
	
	for i = 1, #elector_count_ranks do
		if #elector_count_ranks[#elector_count_ranks - i + 1] == 0 then
			number_of_empty_ranks = #elector_count_ranks - i
		end
	end
	
	local rank = elector_count_weight_table[math.min(cm:random_number(#elector_count_weight_table), number_of_empty_ranks)]
	local index = elector_count_ranks[rank][cm:random_number(#elector_count_ranks[rank])]
	return elector_count_dilemmas[index][cm:random_number(#elector_count_dilemmas[index])]
end

function reset_elector_count_reward(event)
	elector_count_reward_queued["event"] = event
	elector_count_reward_queued["counter"] = 4
	elector_count_reward_queued["active"] = true
end

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("imperial_guard_meter", imperial_guard_meter, context)
		cm:save_named_value("hostility_level_increased", hostility_level_increased, context)
		cm:save_named_value("hostility_level_current", hostility_level_current, context)
		cm:save_named_value("hostility_level_decay_counter", hostility_level_decay_counter, context)
		cm:save_named_value("elector_count_details", elector_count_details, context)
		cm:save_named_value("elector_count_reward_queued", elector_count_reward_queued, context)
		cm:save_named_value("acclaim_lock", acclaim_lock, context)
		cm:save_named_value("supply_delay_counter", supply_delay_counter, context)
		cm:save_named_value("queued_hostility_level_army_spawn", queued_hostility_level_army_spawn, context)
		cm:save_named_value("hostility_level_5_lock_counter", hostility_level_5_lock_counter, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			imperial_guard_meter = cm:load_named_value("imperial_guard_meter", imperial_guard_meter, context)
			hostility_level_increased = cm:load_named_value("hostility_level_increased", hostility_level_increased, context)
			hostility_level_current = cm:load_named_value("hostility_level_current", hostility_level_current, context)
			hostility_level_decay_counter = cm:load_named_value("hostility_level_decay_counter", hostility_level_decay_counter_default, context)
			elector_count_details = cm:load_named_value("elector_count_details", elector_count_details, context)
			elector_count_reward_queued = cm:load_named_value("elector_count_reward_queued", elector_count_reward_queued, context)
			acclaim_lock = cm:load_named_value("acclaim_lock", acclaim_lock, context)
			supply_delay_counter = cm:load_named_value("supply_delay_counter", supply_delay_counter, context)
			queued_hostility_level_army_spawn = cm:load_named_value("queued_hostility_level_army_spawn", queued_hostility_level_army_spawn, context)
			hostility_level_5_lock_counter = cm:load_named_value("hostility_level_5_lock_counter", hostility_level_5_lock_counter, context)
		end
	end
)