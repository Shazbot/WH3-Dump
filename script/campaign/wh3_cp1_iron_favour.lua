--The entire iron_favour mechanic applies only for Immortal Empire, the factions are not present in Realms of Chaos
iron_favour_culture_modifier_values = {
    low = 1.1,
	medium = 1.25,
    high = 1.4,
}

iron_favour = {
	bhashiva_faction = "wh3_cp1_cth_tiger_warriors",
	merc_feature_unlocked_key = "tiger_merc_unlocked",
	cai_bundle_key = "wh3_cp1_bundle_cai_bhashiva_income",
	should_show_ui_notification_for_hud_key = "zhaos_goals_should_show_ui_notification_for_hud",
	should_show_ui_notification_for_mission_prefix = "zhaos_goals_should_show_notification_for_category:",

	cultures = {
		cathay = "wh3_main_cth_cathay",
		rogue = "wh2_main_rogue",
	},

	resources = {
		iron_favour_faction = "wh3_cp1_cth_iron_favour",
		favour_army = "wh3_cp1_cth_iron_favour_enemy_armies",
		favour_settlement = "wh3_cp1_cth_iron_favour_enemy_settlements",
	},
	
	factors = {
		army_prefix = "wh3_cp1_cth_iron_favour_enemy_armies_",
		settlement_prefix = "wh3_cp1_cth_iron_favour_enemy_settlements_",

		goals_achieved = "goals_achieved",
		missions = "missions",
		shang_yang = "shang_yang",
		caravans = "caravan_escort",

		aversion = "aversion",
		key_settlements = "key_settlements",
		ivory_road = "ivory_road",
		zhaos_goals = "zhaos_goals",
		battles_against = "battles_against",
		battles_against_cathay = "battles_against_cathay",
		other = "other",
	},

	cathay_region_group = "wh3_cp1_ie_grand_cathay_key_settlements_homeland",
	ivory_road_region_group = "wh3_cp1_ie_grand_cathay_key_settlements_ivory_road",

	base_iron_favour_points = 30,
	mf_increment_iron_favour = 6,
	settlement_increment_iron_favour = 10,

	values = {
		starting_historical_favour = 100,
		starting_ivory_road_favour = 85,
		trespassing = 10,
		raiding = 25,
		war_declaration = 55,
		army_casualties_per_1000_cp_value = 2, 
	},

	cathay_regions = {}, --generated at new campaign from a region list in DaVE
	ivory_road_regions = {},
	
	starting_enemy_favour = {
		["wh3_dlc23_chd_chaos_dwarfs"] = 34,
		["wh3_main_ogr_ogre_kingdoms"] = 34,
		["wh3_main_tze_tzeentch"] = 48,
		["wh3_main_dae_daemons"] = 26,
		["wh3_main_kho_khorne"] = 26,
		["wh3_main_sla_slaanesh"] = 26,
		["wh3_main_nur_nurgle"] = 26,
		["wh_main_chs_chaos"] = 26,
		["wh_dlc08_nor_norsca"] = 20,
		["wh_main_grn_greenskins"] = 26,
		["wh2_main_skv_skaven"] = 34,
		["wh_dlc03_bst_beastmen"] = 26,
		["wh_main_vmp_vampire_counts"] = 26,
		["wh2_dlc11_cst_vampire_coast"] = 20,
		["wh2_main_def_dark_elves"] = 26,
	},

	enemy_factions_favour = { -- add factions outside of normal enemy cultures
		["wh3_main_cth_dissenter_lords_of_jinshen"] = 30,
		["wh3_main_cth_rebel_lords_of_nan_yang"] = 30,
	},

	enemy_cultures = {
		"wh3_main_dae_daemons",
		"wh3_main_kho_khorne",
		"wh3_main_sla_slaanesh",
		"wh3_main_tze_tzeentch",
		"wh3_main_nur_nurgle",
		"wh_main_chs_chaos",
		"wh3_dlc23_chd_chaos_dwarfs",
		"wh_dlc08_nor_norsca",
		"wh3_main_ogr_ogre_kingdoms",
		"wh_main_grn_greenskins",
		"wh2_main_skv_skaven",
		"wh_dlc03_bst_beastmen",
		"wh_main_vmp_vampire_counts",
		"wh2_dlc11_cst_vampire_coast",
		"wh2_main_def_dark_elves",	
	},

	iron_favour_culture_modifiers = {
		wh3_dlc23_chd_chaos_dwarfs = iron_favour_culture_modifier_values.high,
		wh3_main_ogr_ogre_kingdoms = iron_favour_culture_modifier_values.high,
		wh3_main_tze_tzeentch = iron_favour_culture_modifier_values.high,
		wh3_main_dae_daemons = iron_favour_culture_modifier_values.medium,
		wh3_main_kho_khorne =  iron_favour_culture_modifier_values.medium,
		wh3_main_sla_slaanesh = iron_favour_culture_modifier_values.medium,
		wh3_main_nur_nurgle = iron_favour_culture_modifier_values.medium,
		wh_main_chs_chaos = iron_favour_culture_modifier_values.medium,
		wh_dlc08_nor_norsca = iron_favour_culture_modifier_values.low,
		wh_main_grn_greenskins = iron_favour_culture_modifier_values.low,
		wh2_main_skv_skaven = iron_favour_culture_modifier_values.medium,
		wh_dlc03_bst_beastmen = iron_favour_culture_modifier_values.medium,
		wh3_main_cth_cathay = iron_favour_culture_modifier_values.low,
		wh_main_vmp_vampire_counts = iron_favour_culture_modifier_values.medium,
		wh2_dlc11_cst_vampire_coast = iron_favour_culture_modifier_values.low,
		wh2_main_def_dark_elves = iron_favour_culture_modifier_values.low,
	},

	iron_favour_settlement_decay = 2,
	turn_start_favour = 2,

	pending_battle = {
		attackers = {},
		defenders = {},
		region = {}
	},

	mission_event_category_key = "zhaos_will",
	base_mission_keys = {
		"wh3_cp1_camp_cth_enemies_of_cathay_1",
		"wh3_cp1_camp_cth_enemies_of_cathay_2",
		"wh3_cp1_camp_cth_enemies_of_cathay_3",
	},

	reward_structure = {
		basic_resources = {
			{
				type = "money",			
				weight = 40,
				minimal = 1000,
			},
			{
				type = "iron_favour",
				weight = 70,
				minimal = 50,
			},
			{
				type = "mixed",
				weight = 25,
			},
		},
		additional_rewards = {
			{
				type = "ancillary",
				weight = 40,
			},
			{
				type = "units",
				weight = 70,
			},
		},
		unit_rewards = {
			{
				units = {
					"wh3_main_cth_inf_jade_warriors_1",
					"wh3_main_cth_inf_jade_warrior_crossbowmen_1",
					"wh3_main_cth_inf_iron_hail_gunners_0",
				},
				weight = 60,
				double = 60 -- chance to get a second
			},
			{
				units = {
					"wh3_main_cth_inf_grenadiers",
					"wh3_dlc24_cth_inf_onyx_crowmen",
				},
				weight = 40,
				double = 60 -- chance to get a second
			},
			{
				units = {
					"wh3_main_cth_inf_dragon_guard_0",
					"wh3_main_cth_inf_dragon_guard_crossbowmen_0",
				},
				weight = 30,
				double = 40 -- chance to get a second
			},
			{
				units = {
					"wh3_dlc24_cth_mon_jade_lion",
					"wh3_dlc24_cth_mon_jet_lion",
				},
				weight = 30,
				double = 30 -- chance to get a second
			},
			{
				units = {
					"wh3_main_cth_art_fire_rain_rocket_battery_0",
					"wh3_main_cth_veh_war_compass_0",
					"wh3_dlc24_cth_veh_zhangu_war_drum",
				},
				weight = 25,
				double = 30 -- chance to get a second
			},
		},
	},
	
	mission_setup = {
		mission_issuer = "CLAN_ELDERS",
		min_army_size = 1,
		objectives = {
			{
				weight = 10,
				reward_rank = 0,
				iron_favour_add = 40,
				type = "win_fights_vs_culture",
				objective_scope = "culture",
				target = "armies",
				objectives = {
					[1] = { -- Timer objective
						objective_text = "cp1_timer_objective_text",
						objective_required_amount = 10,
						objective_save_key = "win_fights_vs_culture_save_2",
					},
					[2] = {
						objective_text = "mission_text_text_cp1_fight_against_culture_armies",
						objective_required_amount = 100,
						objective_save_key = "win_fights_vs_culture_save_1",
					},
				},
			},
			{
				weight = 10,
				reward_rank = 0,
				iron_favour_add = 40,
				type = "win_settlement_battles",
				objective_scope = "culture",
				target = "settlements",
				objectives = {
					[1] = {
						objective_text = "cp1_timer_objective_text",
						objective_required_amount = 10,
						objective_save_key = "settlements_save_2",
					},
					[2] = {
						objective_text = "cp1_fight_against_culture_settlements_",
						objective_required_amount = 100,
						objective_save_key = "settlements_save_1",
					},
				},
			},
			{
				weight = 20,
				reward_rank = 4,
				iron_favour_add = 60,
				type = "destroy_faction",
				objective_scope = "faction",
				objectives = {
					[1] = {
						objective_text = "cp1_timer_objective_text",
						objective_required_amount = 15,
						objective_save_key = "destroy_faction_save_2",
					}
				},
			},
			{
				weight = 50,
				reward_rank = 1,
				type = "kill_faction_leader",
				objective_scope = "single_entity",
				target = "armies",
				objectives = {
					[1] = {
						objective_text = "cp1_timer_objective_text",
						objective_required_amount = 8,
						objective_save_key = "kill_faction_leader_save_save_2",
					}
				},
			},
			{
				weight = 50,
				reward_rank = 1,
				type = "capture_settlement",
				objective_scope = "single_entity",
				target = "settlements",
				objectives = {
					[1] = {
						objective_text = "cp1_timer_objective_text",
						objective_required_amount = 15,
						objective_save_key = "capture_settlements_save_2",
					},
					[2] = {
						objective_text = "cp1_win_settlement_battles_vs_clt_",
						objective_required_amount = 3,
						objective_save_key = "capture_settlements_save_1",
					},
				},
			},
		}
	},

	used_region_targets = {},
	target_list = {},

	current_active_and_pending_mission_data = {
		--[[ this table structure is an example, mostly to illustrate what kind of info to expect for a mission
			["wh3_cp1_camp_cth_enemies_of_cathay"] = {
				objective_culture = "wh3_main_ogr_ogre_kingdoms",
				objective_faction = "wh3_main_ogr_blood_guzzlers",
				objective_scope = "culture",
				objective_subculture = "wh3_main_sc_ogr_ogre_kingdoms",
				objectives = {
					[1] = {
						objective_required_amount = "3",
						objective_save_key = "settlements_save_1",
						objective_text = "cp1_win_settlement_battles_vs_clt_",
					},
					[2] = {
						objective_required_amount = "15",
						objective_save_key = "settlements_save_2",
						objective_text = "cp1_timer_objective_text",
					},
				},
				reward = "faction_pooled_resource_transaction{resource wh3_cp1_cth_iron_favour;factor other;amount 100;context absolute;}",
				type = "win_settlement_battles",
				turns_until_reroll = 5,
			},
			["wh3_cp1_camp_cth_enemies_of_cathay_2"] = {},
			["wh3_cp1_camp_cth_enemies_of_cathay_3"] = {}, 
		]]
	},

	factions_to_exclude = {
		factions = {},
		cultures = {}
	},

	lost_settlements = {}, -- used to negate iron favour exploit with settlements

	mission_target_find_max_tries = 25,
	mission_payload_min_distance = 1250,
	mission_payload_max_distance = 5250,
	pending_missions_turns_duration_before_reroll = 5,
	turns_left_until_reroll_shared_state_key_prefix = "zhaos_goals_turns_left_until_reroll_",
	pending_mission_invalidated_shared_state_key_prefix = "zhaos_goals_pending_mission_invalidated_",
}

function iron_favour:initialise()
	if cm:is_new_game() then
		self:setup()
	end
	self:favour_to_iron_favour()
	self:handle_scripted_mission_reissue()
	self:add_listeners()

	local world = cm:model():world()
	local cathay_region_list = world:lookup_regions_from_region_group(self.cathay_region_group)
	local ivory_road_region_list = world:lookup_regions_from_region_group(self.ivory_road_region_group)

	self.cathay_regions = unique_table:region_list_to_unique_table(cathay_region_list):to_table()
	self.ivory_road_regions = unique_table:region_list_to_unique_table(ivory_road_region_list):to_table()
end

function iron_favour:setup()
	out("#### Adding Starting favour ####")
	
	-- Grant starting iron_favour/favour on historical Cathay regions
	for i = 1, #self.cathay_regions do
		local region_key = self.cathay_regions[i]
		local region = cm:get_region(region_key)
		self:assign_favour(region, self.factors.settlement_prefix..self.factors.key_settlements, self.values.starting_historical_favour)
	end

	-- Grant starting iron_favour/favour on Ivory Road regions
	for i = 1, #self.ivory_road_regions do
		local region_key = self.ivory_road_regions[i]
		local region = cm:get_region(region_key)
		self:assign_favour(region, self.factors.settlement_prefix..self.factors.ivory_road, self.values.starting_ivory_road_favour)
	end

	-- assign starting favour to enemy cultures
	for culture_key, value in dpairs(self.starting_enemy_favour) do
		local faction_list = cm:get_factions_by_culture(culture_key)
		for i, faction in ipairs(faction_list) do
			local max = 4
			local min = -4
			local value_var = value + self:rand_between(min, max)

			self:assign_favour(faction, self.factors.aversion, value_var, nil, true)
		end
	end

	-- assign starting favour to enemy factions
	if self.enemy_factions_favour then
		for faction_key, value in dpairs(self.enemy_factions_favour) do
			local selected_faction = cm:get_faction(faction_key)
			
			local max = 4
			local min = -4
			local value_var = value + self:rand_between(min, max)

			self:assign_favour(selected_faction, self.factors.aversion, value_var, nil, true)
		end
	end

	local bhashiva_faction = cm:get_faction(self.bhashiva_faction)
	if bhashiva_faction and not bhashiva_faction:is_null_interface() and not bhashiva_faction:is_human() then
		cm:apply_effect_bundle(self.cai_bundle_key, self.bhashiva_faction, 0)
	end
end

function iron_favour:generate_mission(mission_key)
	local eligible_army = self:get_eligible_army()
	
	if not eligible_army then
		-- we don't have any valid armies, skipping generation this time.
		return
	end
	
	-- we use copy here to avoid modifying the config tables for the objectives
	local random_mission_data = table.copy(self:weighted_random(self.mission_setup.objectives))
	local maximum_distance = 1500
	
	self.target_list = {}

	for i, culture_key in ipairs(self.enemy_cultures) do
		local found_targets = self:get_num_of_generals_of_culture_in_range(self.bhashiva_faction, culture_key, maximum_distance)
		if found_targets == 0 then
			self:get_num_of_generals_of_culture_in_range(self.bhashiva_faction, culture_key, maximum_distance * 2)
		end
	end

	if table.is_empty(self.target_list) then
		-- no eligible target, returning
		return
	end

	local valid_target = nil
	local minVal = 9999999

	-- pick a random target that isn't already a target of one of the other missions we have issued
	local target_find_num_tries = 0
	while not valid_target and target_find_num_tries <= self.mission_target_find_max_tries do
		local target_index = cm:random_number(#self.target_list, 1)
		if target_index and self:is_target_valid(self.target_list[target_index].character, random_mission_data, mission_key) then
			valid_target = self.target_list[target_index].character
		end

		target_find_num_tries = target_find_num_tries + 1
	end

	if not valid_target then
		-- If the closest target is further away than the minVal, we can discard it, too far away.
		return
	end

	local valid_target_faction = valid_target:faction()
	local valid_target_culture = valid_target_faction:culture()
	local valid_target_subculture = valid_target_faction:subculture()

	local full_mission_key = mission_key .. "_" .. random_mission_data.type
	random_mission_data.objective_faction = valid_target_faction:name()
	random_mission_data.objective_culture = valid_target_culture
	random_mission_data.objective_subculture = valid_target_subculture
	random_mission_data.turns_until_reroll = self.pending_missions_turns_duration_before_reroll

	local mission_created = self:handle_scripted_mission_trigger(random_mission_data, full_mission_key, true)
	if not mission_created then
		return
	end

	self.current_active_and_pending_mission_data[full_mission_key] = random_mission_data
	random_mission_data = nil

	local bhashiva_faction = cm:get_faction(self.bhashiva_faction)
	cm:set_script_state(bhashiva_faction, self.should_show_ui_notification_for_hud_key, true)
	cm:set_script_state(bhashiva_faction, self.should_show_ui_notification_for_mission_prefix .. full_mission_key, true)
	cm:set_script_state(bhashiva_faction, self.turns_left_until_reroll_shared_state_key_prefix .. full_mission_key, self.pending_missions_turns_duration_before_reroll)
end

function iron_favour:weighted_random(data_structure)
    local total_weight = 0

    for _, selection in ipairs(data_structure) do
		local w = tonumber(selection.weight) or 0
		if w > 0 then
        	total_weight = total_weight + w
		end
    end

	if total_weight <= 0 then 
		return nil 
	end

    local roll = cm:random_number(total_weight)

    for _, selection in ipairs(data_structure) do
		local w = tonumber(selection.weight) or 0
		if w > 0 then
			if roll <= selection.weight then
				return selection
			end
			roll = roll - w
		end
    end

end

function iron_favour:get_num_of_generals_of_culture_in_range(faction_key, culture_key, closest_char_dist, character_filter)
	local faction = cm:get_faction(faction_key)
	local char_count = 0

	if not faction then
		script_error("ERROR: get_num_of_generals_of_culture_in_range() called but couldn't find faction with supplied key [" .. tostring(faction_key) .. "]")
		return char_count
	end
	
	if not is_string(culture_key) then
		script_error("ERROR: get_num_of_generals_of_culture_in_range() called but supplied subculture key [" .. tostring(culture_key) .. "] is not a string")
		return char_count
	end

	if self.factions_to_exclude.cultures[culture_key] or self.factions_to_exclude.factions[faction_key] then
		-- we've disabled this culture or faction as a valid target.
		return char_count
	end

	if character_filter and not validate.is_function(character_filter) then
		return char_count
	end
		
	local closest_char = false
	
	-- get a list of chars of the supplied culture
	local faction_list = faction:factions_met()
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i)
		local curr_faction_cqi = current_faction:command_queue_index()
		local is_allied_with = faction:allied_with(current_faction)
		
		if current_faction:culture() == culture_key and not is_allied_with then		
			local char_list = current_faction:character_list()
			
			for j = 0, char_list:num_items() - 1 do
				local current_char = char_list:item_at(j)

				if cm:char_is_general(current_char) and (not character_filter or character_filter(current_char)) then
					local closest_player_char, closest_player_char_dist = cm:get_closest_character_from_faction(
					faction,
					current_char:logical_position_x(),
					current_char:logical_position_y(),
					function(char)
						local character_subtype_key = char:character_subtype_key()
						return character_subtype_key ~= "wh3_cp1_cth_sawai_caravan" and character_subtype_key ~= "wh3_main_cth_lord_caravan_master"
					end)
					
					if closest_player_char_dist < closest_char_dist then
						closest_char = current_char
						if closest_char then
							local target = 
							{
								character = current_char,
								distance = closest_player_char_dist ^ 0.5,
							}
							table.insert(self.target_list, target)
							char_count = char_count + 1
						end
					end
				end
			end
		end
	end

	return char_count
end

function iron_favour:get_eligible_army()
	local faction = cm:get_faction(self.bhashiva_faction)
	local armies = faction:military_force_list()
	local eligible_armies = {}

	for i=0, armies:num_items() - 1 do
		local curr_army = armies:item_at(i)
		if not curr_army:is_armed_citizenry() and curr_army:unit_list():num_items() >= self.mission_setup.min_army_size then
			table.insert(eligible_armies, curr_army)
		end
	end
	if not table.is_empty(eligible_armies) then
		return eligible_armies[cm:random_number(#eligible_armies, 1)]
	end

	return false
end

function iron_favour:handle_scripted_mission_trigger(mission_data, mission_key, should_trigger)
	local mission_created = false
	if mission_data.type == "win_fights_vs_culture" then
		mission_created = self:setup_win_battles_against_culture(mission_data, mission_key, should_trigger)
	elseif mission_data.type == "win_settlement_battles" then
		mission_created = self:setup_win_settlement_battles(mission_data, mission_key, should_trigger)
	elseif mission_data.type == "destroy_faction" then
		mission_created = self:setup_destroy_faction(mission_data, mission_key, should_trigger)
	elseif mission_data.type == "kill_faction_leader" then
		mission_created = self:setup_eliminate_faction_leader(mission_data, mission_key, should_trigger)
	elseif mission_data.type == "capture_settlement" then
		mission_created = self:setup_capture_settlement(mission_data, mission_key, should_trigger)
	end
	return mission_created
end

function iron_favour:handle_scripted_mission_reissue()
	for mission_key, mission_data in dpairs(self.current_active_and_pending_mission_data) do
		if not table.is_empty(mission_data) then
			self:handle_scripted_mission_trigger(mission_data, mission_key, false)
		end
	end
end

function iron_favour:setup_mission_payload(mm, mission_setup_data, distance, treasury, favour)
	local reward_rank = mission_setup_data.reward_rank or 0
	
	local function choose_main_rewards()
		local base_reward_structure = self.reward_structure.basic_resources
		local treasury_value = 0
		local favour_value = 0
		local bonus = (reward_rank * 0.25) + 1
		local turn_number = cm:turn_number()
	
		if treasury == true then
			treasury_value = math.max(math.round((math.sqrt(distance) * 16) / 4 + (bonus * turn_number)) * 10, base_reward_structure[1].minimal)
			if favour == true then
				treasury_value = math.round(treasury_value * 0.85)
			end
		end
	
		if favour == true then
			favour_value = math.max(math.round(((math.sqrt(distance) * 40) / 10) + (bonus * turn_number)), base_reward_structure[2].minimal)
			if treasury == true then
				favour_value = math.round(favour_value * 0.7)
			end
		end
		
		return treasury_value, favour_value
	end

	local function add_ancillary_to_rewards()
		local ancillary_key = nil

		ancillary_key = get_random_ancillary_key_for_faction(self.bhashiva_faction, nil)

		if ancillary_key then
			mm:add_payload("add_ancillary_to_faction_pool {ancillary_key " .. ancillary_key .. ";}")
		end
	end

	local function add_units_to_rewards(force_amount)
		local unit_selected, amount = nil, 1
		local unit_list = self.reward_structure.unit_rewards
		local unit_group = self:weighted_random(unit_list)
		
		if not force_amount then
			local double_amount = cm:random_number(100, 1)
		
			if double_amount <= unit_group.double then
				amount = 2
			end
		end

		unit_selected = cm:random_number(#unit_group.units, 1)

		mm:add_payload("add_mercenary_to_faction_pool{unit_key " .. unit_group.units[unit_selected] .. ";amount " .. amount .. ";}")
	end

	-- generate basic reward setup
	if treasury == true or favour == true then
		local treasury_value, favour_value = choose_main_rewards()

		if treasury_value ~= 0 then
			mm:add_payload(payload.money(treasury_value))
		end
	
		if favour_value ~= 0 then
			mm:add_payload(payload.iron_favour(favour_value))
		end
	end
		
	-- advanced rewards
	if reward_rank > 0 then
		local reward_types = self.reward_structure.additional_rewards
		local ancillary_drop = cm:random_number(100, 1) <= reward_types[1].weight
		local unit_drop = cm:random_number(100, 1) <= reward_types[2].weight
		local second_reward = cm:random_number(2 + reward_rank, 1) >= 3

		if unit_drop then
			add_units_to_rewards()

			if second_reward then
				local reward = self:weighted_random(reward_types)

				if reward.type == "units" then 
					add_units_to_rewards(true)
				elseif reward.type == "ancillary" then
					add_ancillary_to_rewards()
				end
			end
		elseif ancillary_drop then
			add_ancillary_to_rewards()

			if second_reward then
				add_units_to_rewards(true)
			end
		end
	end
end

function iron_favour:update_and_check_required_number_for_objective(objective_data, mission_manager, objective_key)
	local objective_count = cm:get_saved_value(objective_data.objective_save_key) or 0
	objective_count = objective_count + 1
	cm:set_saved_value(objective_data.objective_save_key, objective_count)
	self:updated_scripted_objective_count(mission_manager, objective_key, objective_data.objective_save_key, objective_data.objective_required_amount)
	if objective_count >= objective_data.objective_required_amount then
		return true
	end
	return false
end

function iron_favour:reset_objective_saved_data(objective_data, mission_manager, objective_key)
	if cm:get_saved_value(objective_data.objective_save_key) then
		cm:set_saved_value(objective_data.objective_save_key, 0)
		self:updated_scripted_objective_count(mission_manager, objective_key, objective_data.objective_save_key, objective_data.objective_required_amount)
	end
end

function iron_favour:updated_scripted_objective_count(mission_manager, objective_key, objective_save_key, required_amount)
	local objectives_count = cm:get_saved_value(objective_save_key) or 0
	mission_manager:update_scripted_objective_text(
		objective_key,
		objectives_count,
		required_amount,
		objective_key
	)
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------
-- MISSIONS SETUP
--------------------------------------------------------------------------
--------------------------------------------------------------------------

function iron_favour:setup_win_battles_against_culture(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.bhashiva_faction, mission_key)
	local timer_objective_key = "mission_text_text_" .. mission_setup_data.objectives[1].objective_text
	
	mm:set_mission_issuer(self.mission_setup.mission_issuer)
	mm:set_all_objectives_are_primary()
	
	local bhashiva_faction_key = self.bhashiva_faction
	mm:add_new_scripted_objective(
		timer_objective_key,
		"FactionTurnStart",
		function(context)
			local bhashiva_faction_interface = cm:get_faction(bhashiva_faction_key)
			if context:faction():name() == bhashiva_faction_key and cm:mission_is_active_for_faction(bhashiva_faction_interface, mission_key) then
				if self:update_and_check_required_number_for_objective(mission_setup_data.objectives[1], mm, timer_objective_key) then
					mm:force_scripted_objective_success(timer_objective_key)
					cm:set_active_mission_status_for_faction(bhashiva_faction_interface, mission_key, "SUCCEEDED")
					return true
				end
			end
			return false
		end,
		timer_objective_key
	)

	if should_trigger then
		-- we do this here so that when we re-trigger the mission with the same key our scripted objective timer will reset
		self:reset_objective_saved_data(mission_setup_data.objectives[1], mm, timer_objective_key)
	end

	mm:add_new_objective("SCRIPTED")

	mm:add_condition("script_key " .. mission_key)
	mm:add_condition("override_text " .. mission_setup_data.objectives[2].objective_text .. "_" .. mission_setup_data.objective_subculture)

	local distance = self.mission_payload_min_distance
	local faction_list = cm:get_factions_by_subculture(mission_setup_data.objective_subculture)

	if not is_empty_table(faction_list) then
		local faction_count = #faction_list
		local current_distance = math.floor(self.mission_payload_max_distance - 125 * faction_count)

		if current_distance > distance then
			distance = current_distance
		end
	end

	self:setup_mission_payload(mm, mission_setup_data, distance, false, false)

	mm:add_payload("text_display dummy_wh3_cp1_cth_iron_favour_armies")
	mm:set_is_pending_mission(true)
	mm:set_pending_mission_issuing_faction_name(self.bhashiva_faction)
	
	if should_trigger then mm:trigger() end
	
	self:updated_scripted_objective_count(mm, timer_objective_key, mission_setup_data.objectives[1].objective_save_key, mission_setup_data.objectives[1].objective_required_amount)

	return true
end

function iron_favour:setup_win_settlement_battles(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.bhashiva_faction, mission_key)
	local objective_key = "mission_text_text_" .. mission_setup_data.objectives[2].objective_text .. mission_setup_data.objective_culture
	local timer_objective_key = "mission_text_text_" .. mission_setup_data.objectives[1].objective_text
	
	mm:set_mission_issuer(self.mission_setup.mission_issuer)
	mm:set_all_objectives_are_primary()

	local bhashiva_faction_key = self.bhashiva_faction
	mm:add_new_scripted_objective(
		timer_objective_key,
		"FactionTurnStart",
		function(context)
			local bhashiva_faction_interface = cm:get_faction(bhashiva_faction_key)
			if context:faction():name() == bhashiva_faction_key and cm:mission_is_active_for_faction(bhashiva_faction_interface, mission_key) then
				if self:update_and_check_required_number_for_objective(mission_setup_data.objectives[1], mm, timer_objective_key) then
					cm:set_active_mission_status_for_faction(bhashiva_faction_interface, mission_key, "SUCCEEDED")
					return true
				end
			end
			return false
		end,
		timer_objective_key
	)

	mm:add_new_scripted_objective(
		objective_key,
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			local bhashiva_faction_interface = cm:get_faction(bhashiva_faction_key)
			if context:character():faction():name() == bhashiva_faction_key
				and	(context:previous_owner_culture() == mission_setup_data.objective_culture or context:garrison_residence():faction():culture() == mission_setup_data.objective_culture) 
				and not context:occupation_decision_type() == "occupation_decision_do_nothing" 
				and cm:mission_is_active_for_faction(bhashiva_faction_interface, mission_key)
			then
				if self:update_and_check_required_number_for_objective(mission_setup_data.objectives[2], mm, objective_key) then
					mm:force_scripted_objective_success(timer_objective_key)
					return true
				end
			end

			return false
		end,
		objective_key
	)

	if should_trigger then
		-- we do this here so that when we re-trigger the mission with the same key our scripted objective timer will reset
		self:reset_objective_saved_data(mission_setup_data.objectives[1], mm, timer_objective_key)
		self:reset_objective_saved_data(mission_setup_data.objectives[2], mm, objective_key)
	end

	local distance = self.mission_payload_min_distance
	local faction_list = cm:get_factions_by_subculture(mission_setup_data.objective_subculture)

	if not is_empty_table(faction_list) then
		local faction_count = #faction_list
		local mod_mult = math.floor(self.mission_payload_max_distance - 125 * faction_count)

		if mod_mult > distance then
			distance = mod_mult
		end
	end

	self:setup_mission_payload(mm, mission_setup_data, distance, false, false)

	mm:add_payload("text_display dummy_wh3_cp1_cth_iron_favour_settlements")
	mm:set_is_pending_mission(true)
	mm:set_pending_mission_issuing_faction_name(self.bhashiva_faction)
	
	if should_trigger then mm:trigger() end

	self:updated_scripted_objective_count(mm, objective_key, mission_setup_data.objectives[2].objective_save_key, mission_setup_data.objectives[2].objective_required_amount)
	self:updated_scripted_objective_count(mm, timer_objective_key, mission_setup_data.objectives[1].objective_save_key, mission_setup_data.objectives[1].objective_required_amount)

	return true
end

function iron_favour:setup_destroy_faction(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.bhashiva_faction, mission_key)
	
	mm:set_mission_issuer(self.mission_setup.mission_issuer)
	mm:set_all_objectives_are_primary()

	mm:add_new_objective("DESTROY_FACTION")
	mm:add_condition("faction " .. mission_setup_data.objective_faction)
	mm:add_condition("confederation_valid")

	local target_faction = cm:get_faction(mission_setup_data.objective_faction)
	local distance = self.mission_payload_min_distance

	if not target_faction:is_null_interface() then
		local home_region = target_faction:home_region()

		if not home_region:is_null_interface() then
			local target_x, target_y = cm:settlement_logical_pos(home_region:settlement():key())
			local own_force = cm:get_closest_military_force_from_faction(self.bhashiva_faction, target_x, target_y)

			if own_force and not own_force:general_character():is_null_interface() then
				local own_force_x = own_force:general_character():logical_position_x() or 0
				local own_force_y = own_force:general_character():logical_position_y() or 0
				local current_distance = distance_squared(target_x, target_y, own_force_x, own_force_y)

				if current_distance > distance then
					distance = current_distance
				end
			end
		end
	end

	local settlement_num = target_faction:num_regions() or 1

	distance = distance * (1 + settlement_num * 0.15)
	self:setup_mission_payload(mm, mission_setup_data, distance, true, false)

	mm:add_payload("text_display dummy_wh3_cp1_cth_iron_favour_all")
	mm:set_is_pending_mission(true)
	mm:set_pending_mission_issuing_faction_name(self.bhashiva_faction)
	
	if should_trigger then mm:trigger() end

	return true
end

function iron_favour:setup_eliminate_faction_leader(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.bhashiva_faction, mission_key)
	
	mm:set_mission_issuer(self.mission_setup.mission_issuer)
	mm:set_all_objectives_are_primary()

	local target_faction = cm:get_faction(mission_setup_data.objective_faction)

	local faction_leader_character = target_faction:faction_leader()
	if not faction_leader_character 
		or faction_leader_character:is_null_interface() 
		or faction_leader_character:is_alive() == false 
		or faction_leader_character:is_wounded() 
	then
		return false
	end
	local faction_leader_fm_cqi = faction_leader_character:family_member():command_queue_index()

	mm:add_new_objective("KILL_CHARACTER_BY_ANY_MEANS")
	mm:add_condition("family_member " .. faction_leader_fm_cqi)

	local target_x, target_y =  cm:char_logical_pos(faction_leader_character)
	local own_force = cm:get_closest_military_force_from_faction(self.bhashiva_faction, target_x, target_y)
	local distance = self.mission_payload_min_distance

	if own_force and not own_force:general_character():is_null_interface() then
		local own_force_x = own_force:general_character():logical_position_x() or 0
		local own_force_y = own_force:general_character():logical_position_y() or 0
		local current_distance = distance_squared(target_x, target_y, own_force_x, own_force_y)

		if current_distance > distance then
			distance = current_distance
		end
	end

	self:setup_mission_payload(mm, mission_setup_data, distance, false, true)

	mm:set_is_pending_mission(true)
	mm:set_pending_mission_issuing_faction_name(self.bhashiva_faction)
	
	if should_trigger then mm:trigger() end

	return true
end

function iron_favour:setup_capture_settlement(mission_setup_data, mission_key, should_trigger)
	local faction_key = self.bhashiva_faction
	local faction = cm:get_faction(faction_key)
	local mm = mission_manager:new(faction_key, mission_key)
	
	mm:set_mission_issuer(self.mission_setup.mission_issuer)
	mm:set_all_objectives_are_primary()

	local target_faction = cm:get_faction(mission_setup_data.objective_faction)
	local target_region_list = target_faction:region_list()
	local own_faction_region_list = faction:region_list()
	local mission_distance = 0
	local target_region = nil

	local objs_to_test_distance = faction:military_force_list()
	
	if faction:has_home_region() then
		objs_to_test_distance = own_faction_region_list
	end

	if objs_to_test_distance:is_empty() then
		return false
	end

	local closest_distance = 500000

	for j = 0, target_region_list:num_items() - 1 do
		local current_region = target_region_list:item_at(j)
		local current_region_key = current_region:name()
		local current_settlement = current_region:settlement()
		
		if not self.used_region_targets[target_faction:name() .. "_" .. current_region_key] then
			local settlement_x = current_settlement:logical_position_x()
			local settlement_y = current_settlement:logical_position_y()

			for _, obj in model_pairs(objs_to_test_distance) do
				local x = 0
				local y = 0

				if is_region(obj) then
					x = obj:settlement():logical_position_x()
					y = obj:settlement():logical_position_y()
				elseif obj:has_general() then
					local general = obj:general_character()
					x = general:logical_position_x()
					y = general:logical_position_y()
				end

				local distance = distance_squared(settlement_x, settlement_y, x, y)

				if distance < closest_distance then
					target_region = current_region
					closest_distance = distance
				end
			end
		end
	end

	if target_region ~= nil then
		-- Check if the region you are being assigned is the one you are sieging.
		local target_garrison_residence = target_region:garrison_residence()
		if target_garrison_residence:is_under_siege() then
			local sieging_character = target_garrison_residence:besieging_character()
			if not sieging_character:is_null_interface() and sieging_character:faction():name() == faction_key then
				return false
			end
		end

		local target_region_key = target_region:name()
		self.used_region_targets[target_faction:name() .. "_" .. target_region_key] = true
		
		mm:add_new_objective("CAPTURE_REGIONS")
		mm:add_condition("region " .. target_region_key)
		mission_setup_data.objective_region = target_region_key

		mission_distance = closest_distance
	else
		return false
	end

	self:setup_mission_payload(mm, mission_setup_data, mission_distance, true, true)

	mm:set_is_pending_mission(true)
	mm:set_pending_mission_issuing_faction_name(self.bhashiva_faction)
	
	if should_trigger then 
		mm:trigger()
	end

	return true
end

function iron_favour:add_listeners()
	core:add_listener(
		"IronFavourFeatureUnlocked", 
		"ScriptEventTigerMercenariesUnlocked", 
		function(context)
			return context:faction():is_human()
		end, 
		function(context)
			self:try_refill_missions(context:faction())
		end, 
		true
	)

	core:add_listener(
		"IronFavourFactionTurnStart", 
		"FactionTurnStart", 
		function(context)
			local faction = context:faction()
			return faction:name() == self.bhashiva_faction and faction:is_human() 
		end, 
		function(context)
			local faction_interface = context:faction()
			local unlocked = cm:model():shared_states_manager():get_state_as_bool_value(faction_interface, self.merc_feature_unlocked_key)
			if not unlocked then
				return
			end

			self:progress_turns_until_reroll_for_pending_missions(faction_interface)
			self:try_refill_missions(faction_interface)
		end, 
		true
	)

	core:add_listener(
		"IronFavourMissionSuccess", 
		"MissionSucceeded", 
		true, 
		function(context)
			local mission_key = context:mission():mission_record_key()
			local mission_data = self.current_active_and_pending_mission_data[mission_key]
			if context:faction():name() ~= self.bhashiva_faction or not mission_data then
				return
			end

			if table.is_empty(mission_data) then
				script_error("ERROR: IronFavourMissionSuccess triggered for mission with supplied key [" .. mission_key .. "] but this script has no data for such a mission")
				return
			end

			self:disable_favour_for_objective_targets(mission_data)
			self.current_active_and_pending_mission_data[mission_key] = {}

			local mission_manager = cm:get_mission_manager(self.bhashiva_faction, mission_key)
			if not mission_manager then
				return
			end
			cm:unregister_mission_manager(mission_manager)
		end, 
		true
	)

	core:add_listener(
		"IronFavourMissionAccepted", 
		"MissionIssued", 
		true, 
		function(context)
			local mission_key = context:mission():mission_record_key()
			local mission_data = self.current_active_and_pending_mission_data[mission_key]
			if context:faction():name() ~= self.bhashiva_faction or not mission_data or table.is_empty(mission_data) then
				return
			end
			
			if mission_data.objective_scope == "culture" then
				local faction_list = cm:get_factions_by_culture(mission_data.objective_culture)
				for i, faction in ipairs(faction_list) do
					local value = self.values.war_declaration
					if mission_data.iron_favour_add and mission_data.iron_favour_add ~= 0 then
						value = mission_data.iron_favour_add
					end
					self:assign_favour(faction, self.factors.zhaos_goals, value, mission_data.target)
				end
			elseif mission_data.objective_scope == "faction" then
				local objective_faction_interface = cm:get_faction(mission_data.objective_faction)
				if not objective_faction_interface or objective_faction_interface:is_null_interface() then
					script_error("ERROR: IronFavourMissionAccepted tried to assign favour to target faction with key [" .. mission_data.objective_faction .. "] but faction was not found")
					return
				end

				local value = self.values.war_declaration
				if mission_data.iron_favour_add and mission_data.iron_favour_add ~= 0 then
					value = mission_data.iron_favour_add
				end

				self:assign_favour(objective_faction_interface, self.factors.zhaos_goals, value, mission_data.target)
			elseif mission_data.objective_scope == "single_entity" then
				return
			end
		end, 
		true
	)

	core:add_listener(
		"IronFavourMissionCancelled", 
		"MissionCancelled", 
		true, 
		function(context)
			local mission_key = context:mission():mission_record_key()
			local mission_data = self.current_active_and_pending_mission_data[mission_key]
			if context:faction():name() ~= self.bhashiva_faction or not mission_data or table.is_empty(mission_data) then
				return
			end
			
			self:disable_favour_for_objective_targets(mission_data)
			self.current_active_and_pending_mission_data[mission_key] = {}

			local mission_manager = cm:get_mission_manager(self.bhashiva_faction, mission_key)
			if not mission_manager then
				return
			end
			cm:unregister_mission_manager(mission_manager)
		end, 
		true
	)

	-- panel is closed
	core:add_listener(
		"PanelClosedEventHandler",
		"PanelClosedCampaign",
		function(context)
			return context.string == "cp1_cth_shang_yang"
		end,
		function(context)
			-- Remove notification icon when going back from the panel
			local faction = cm:get_faction(self.bhashiva_faction)
			cm:set_script_state(faction, self.should_show_ui_notification_for_hud_key, false)

			for key, mission_data in dpairs(self.current_active_and_pending_mission_data) do
				if not table.is_empty(mission_data) then
					cm:set_script_state(faction, self.should_show_ui_notification_for_mission_prefix .. key, false)
				end
			end
		end, 
		true
	)

	core:add_listener(
		"IronFavourCharacterRecruited",
		"CharacterCreated",
		function(context)
			local culture = context:character():faction():culture()
			local faction = context:character():faction():name()

			return not is_nil(self.starting_enemy_favour[culture]) or
					not is_nil(self.enemy_factions_favour[faction])
		end,
		function(context)
			local character = context:character()
			if character:has_military_force() then
				local culture = character:faction():culture()
				local faction = character:faction():name()
				local starting_favour
				if self.starting_enemy_favour[culture] then
					starting_favour = self.starting_enemy_favour[culture]
				elseif self.enemy_factions_favour[faction] then
					starting_favour = self.enemy_factions_favour[faction]
				end
				self:assign_favour(character:military_force(), self.factors.army_prefix .. self.factors.aversion, starting_favour)
			end
		end,
		true
	)

	core:add_listener(
		"IronFavourMissionAlertSeenListener",
		"ContextTriggerEvent",
		true,
		function(context)
			if not context.string:starts_with("IronFavourMissionAlertSeen") then
				return
			end

			local params = context.string:split(":")
			local mission_key = params[2]
			if not table.is_empty(self.current_active_and_pending_mission_data[mission_key]) then
				local bhashiva_faction_interface = cm:get_faction(self.bhashiva_faction)
				cm:set_script_state(bhashiva_faction_interface, self.should_show_ui_notification_for_mission_prefix .. mission_key, false)
				-- if we've seen the alert for a specific mission we should have also seen the hud one
				cm:set_script_state(bhashiva_faction_interface, self.should_show_ui_notification_for_hud_key, false)
			end
		end,
		true
	)

	core:add_listener(
		"ZhaoGoalsRegionFactionChangeEvent",
		"RegionFactionChangeEvent",
		function(context)
			local previous_faction_key = context:previous_faction():name()
			local bhashiva_key = self.bhashiva_faction
			local bhashiva_faction = cm:get_faction(bhashiva_key)

			if previous_faction_key ~= bhashiva_key and bhashiva_faction and bhashiva_faction:is_human() then
				return true
			else
				return false
			end
		end,
		function(context)
			local previous_faction = context:previous_faction():name()
			local region = context:region():name()

			if self.used_region_targets[previous_faction .. "_" .. region] then
				self.used_region_targets[previous_faction .. "_" .. region] = nil
			end
		end,
		true
	)
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------
-- UTILITIES
--------------------------------------------------------------------------
--------------------------------------------------------------------------

function iron_favour:get_characters_in_faction_regions(faction_interface)
	local character_list = {}
	local region_list = faction_interface:region_list()

	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		local region_chars = region:characters_in_region()
		for j = 0, region_chars:num_items() - 1 do
			local char = region_chars:item_at(j)

			if char:has_military_force() and char:faction():name() ~= faction_interface:name() then
				table.insert(character_list, char)
			end
		end
	end
	
	return character_list
end

function iron_favour:assign_favour(target_interface, factor, value, target, use_mult)
	local process_favour_for_interface = function(target_interface, factor, mult)
		mult = mult or 1
		local updated_value = math.round(value * mult)
  		cm:entity_add_pooled_resource_transaction(target_interface, factor, updated_value)
	end
	
	local faction

	if target_interface:is_null_interface() then
		script_error("ERROR: assign_favour called with NULL target interface. This should not happen")
		return
	end

	if is_region(target_interface) then
		faction = target_interface:owning_faction()
	elseif is_militaryforce(target_interface) then
		faction = target_interface:faction()
	else
		faction = target_interface
	end
	
	local culture = faction:culture() -- don't add favour to Cathay culture
	if (culture == self.cultures.cathay and not self.enemy_factions_favour[faction:name()]) or culture == self.cultures.rogue or faction:is_rebel() then
		return
	end
	
	if not is_faction(target_interface) then
  		process_favour_for_interface(target_interface, factor)
	else
		faction = target_interface
		if target == "armies" or target == nil then
			local mf_list = faction:military_force_list()

			for i = 0, mf_list:num_items() - 1 do
				local force = mf_list:item_at(i)
				if force:is_armed_citizenry() == false and force:has_general() == true then --skip garrison armies
					process_favour_for_interface(force, self.factors.army_prefix..factor)
				end
			end
		end

		if target == "settlements" or target == nil then
			local region_list = faction:region_list()
			local culture_multiplier = self:culture_income_multiplier(faction:culture())

			for i = 0, region_list:num_items() - 1 do
				local settlement_level = region_list:item_at(i):settlement():primary_slot():building():building_level() or 1
				local settlement_mult = 1
				
				if use_mult then
					settlement_mult = settlement_mult + (culture_multiplier - 1) * settlement_level
				end

				process_favour_for_interface(region_list:item_at(i),self.factors.settlement_prefix..factor, settlement_mult)
			end
		end
	end
end

function iron_favour:disable_favour(faction) -- CURRENTLY UNUSED
	local faction_culture = faction:culture()
	local faction_name = faction:name()
	local disable_favour_for_interface = function(faction_cqi, target_interface, resource_key, value)
		if not self.starting_enemy_favour[faction_culture] then
			cm:entity_add_pooled_resource_transaction(target_interface, resource_key .. "_" .. self.factors.other, -value)
			cm:disable_distribution_to_entity(faction_cqi, resource_key, target_interface, true)
		elseif not self.enemy_factions_favour[faction_name] then
			cm:entity_add_pooled_resource_transaction(target_interface, resource_key .. "_" .. self.factors.other, -value)
			cm:disable_distribution_to_entity(faction_cqi, resource_key, target_interface, true)
		else
			cm:entity_add_pooled_resource_transaction(target_interface, resource_key .. "_" .. self.factors.zhaos_goals, -value)
		end
	end

	local faction_cqi = faction:command_queue_index()
	local mf_list = faction:military_force_list()
	local region_list = faction:region_list()

	for i = 0, mf_list:num_items() - 1 do
		local force = mf_list:item_at(i)
		if force:is_armed_citizenry() == false and force:has_general() == true then --skip garrison armies, they don't have the resource
			local iron_favour = force:pooled_resource_manager():resource(self.resources.favour_army)
			if not iron_favour:is_null_interface() then
				local value = iron_favour:value()
				disable_favour_for_interface(faction_cqi, force, self.resources.favour_army, value)
			end
		end
	end

	for i = 0, region_list:num_items() - 1 do
		local curr_region = region_list:item_at(i)
		local iron_favour = curr_region:pooled_resource_manager():resource(self.resources.favour_settlement)
		if not iron_favour:is_null_interface() then
			local value = iron_favour:value()
			disable_favour_for_interface(faction_cqi, curr_region, self.resources.favour_settlement, value)
		end
	end
end

function iron_favour:cache_pre_battle_data()
	local pb = cm:model():pending_battle()
	if not pb:is_null_interface() then
		local attacker = pb:attacker()
		local attacker_mf = attacker:military_force()
		local attacker_favour = attacker_mf:pooled_resource_manager():resource(self.resources.favour_army)
		local defender = pb:defender()
		local defender_faction = defender:faction()
		local defender_mf = defender:military_force()
		local defender_favour = defender_mf:pooled_resource_manager():resource(self.resources.favour_army)
		local secondary_attackers = pb:secondary_attackers()
		local secondary_defenders = pb:secondary_defenders()
		local siege = pb:siege_battle()
		local attacker_settlement_favour = nil
		local defender_settlement_favour = nil

		if attacker_mf:has_garrison_residence() then
			attacker_settlement_favour = attacker_mf:garrison_residence():region():pooled_resource_manager():resource(self.resources.favour_settlement)
		end

		if defender_mf:has_garrison_residence() then
			defender_settlement_favour = defender_mf:garrison_residence():region():pooled_resource_manager():resource(self.resources.favour_settlement)
		end

		-- reset the pending battle table
		self.pending_battle = {
			attackers = {},
			defenders = {},
			region = {}
		}
		
		-- Cache the CQI and favour values of all parties involved in the battle in-case they are killed later
		if not attacker_favour:is_null_interface() then
			table.insert(self.pending_battle.attackers, {mf_cqi = attacker_mf:command_queue_index(), favour = attacker_favour:value(), faction_key = attacker:faction():name()})
		elseif attacker_settlement_favour ~= nil then
			table.insert(self.pending_battle.attackers, {mf_cqi = attacker_mf:command_queue_index(), favour = 0, faction_key = attacker:faction():name()})
		end
		
		if not defender_favour:is_null_interface() then
			table.insert(self.pending_battle.defenders, {mf_cqi = defender_mf:command_queue_index(), favour = defender_favour:value(), faction_key = defender:faction():name()})
		elseif defender_settlement_favour ~= nil  then
			table.insert(self.pending_battle.defenders, {mf_cqi = defender_mf:command_queue_index(), favour = 0, faction_key = defender:faction():name()})
		end
		
		for i = 0, secondary_attackers:num_items() - 1 do
			local attacker = secondary_attackers:item_at(i)
			local attacker_mf = attacker:military_force()
			local attacker_favour = attacker_mf:pooled_resource_manager():resource(self.resources.favour_army)

			if not attacker_favour:is_null_interface() then
				table.insert(self.pending_battle.attackers, {mf_cqi = attacker_mf:command_queue_index(), favour = attacker_favour:value(), faction_key = attacker:faction():name()})
			elseif attacker_settlement_favour ~= nil then
				table.insert(self.pending_battle.attackers, {mf_cqi = attacker_mf:command_queue_index(), favour = 0, faction_key = attacker:faction():name()})
			end
		end
		
		for i = 0, secondary_defenders:num_items() - 1 do
			local defender = secondary_defenders:item_at(i)
			local defender_mf = defender:military_force()
			local defender_favour = defender_mf:pooled_resource_manager():resource(self.resources.favour_army)

			if not defender_favour:is_null_interface() then
				table.insert(self.pending_battle.defenders, {mf_cqi = defender_mf:command_queue_index(), favour = defender_favour:value(), faction_key = defender:faction():name()})
			elseif defender_settlement_favour ~= nil then
				table.insert(self.pending_battle.defenders, {mf_cqi = defender_mf:command_queue_index(), favour = 0, faction_key = defender:faction():name()})
			end
		end

		if siege and 
			(defender:faction():culture() ~= self.cultures.cathay or self.enemy_factions_favour[defender:faction():name()]) and 
			defender_mf:force_type():key() ~= "OGRE_CAMP" and 
			defender_faction:is_rebel() == false then
			local region = pb:region_data():region()
			local resource = region:pooled_resource_manager():resource(self.resources.favour_settlement)

			if not resource:is_null_interface() then
				self.pending_battle.region = {region_name = region:name(), favour = resource:value()}
			end
		end
	end
end

function iron_favour:cathay_attacker_or_defender(pending_battle)
	local cathay_attacker = false
	local cathay_defender = false
	local attacker = pending_battle:attacker()
	local defender = pending_battle:defender()
	local secondary_attackers = pending_battle:secondary_attackers()
	local secondary_defenders = pending_battle:secondary_defenders()

	if attacker:faction():culture() == self.cultures.cathay and not self.enemy_factions_favour[attacker:faction():name()] then
		cathay_attacker = true
	end

	if defender:faction():culture() == self.cultures.cathay and not self.enemy_factions_favour[defender:faction():name()] then
		cathay_defender = true
	end

	for i = 0, secondary_attackers:num_items() - 1 do
		local attacker = secondary_attackers:item_at(i)

		if attacker:faction():culture() == self.cultures.cathay and not self.enemy_factions_favour[attacker:faction():name()] then
			cathay_attacker = true
		end
	end

	for i = 0, secondary_defenders:num_items() - 1 do
		local defender = secondary_defenders:item_at(i)

		if defender:faction():culture() == self.cultures.cathay and not self.enemy_factions_favour[defender:faction():name()] then
			cathay_defender = true
		end
	end
	return cathay_attacker, cathay_defender
end

function iron_favour:can_use_iron_favour(faction_name)
	if (faction_name == self.bhashiva_faction) then
		return true
	else
		return false
	end
end

function iron_favour:favour_to_iron_favour()
	core:add_listener(
		"favourBattlePending",
        "PendingBattle",
        function(context)
			local cathay_attacker, cathay_defender = self:cathay_attacker_or_defender(context:pending_battle())
			return cathay_attacker or cathay_defender
        end,
        function(context)
			-- cache armies favour values before battles begin in-case they die during the battle.
			self:cache_pre_battle_data()
        end,
        true
	)

	core:add_listener(
		"SettlefavourToiron_favour",
		"BattleConflictFinished",
		function()
			local pb = cm:model():pending_battle()
			return pb:has_been_fought() and 
					(cm:pending_battle_cache_culture_is_defender(self.cultures.cathay) and pb:defender_won()) or 
					(cm:pending_battle_cache_culture_is_attacker(self.cultures.cathay) and pb:attacker_won())
		end,
		function()
			pb = cm:model():pending_battle()
			local cathay_winnners = {}
			local losers = {}
			local favour = 0

			if cm:pending_battle_cache_faction_is_defender(self.bhashiva_faction) and pb:defender_won() then
				for i = 1, cm:pending_battle_cache_num_defenders() do
					local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i)
					local faction = cm:get_faction(faction_name)

					if faction:culture() == self.cultures.cathay and not self.enemy_factions_favour[faction_name] and faction:can_be_human() then
						table.insert(cathay_winnners, {char_cqi = char_cqi, mf_cqi = mf_cqi, faction_name = faction_name})
					end

					losers = self.pending_battle.attackers
				end
			elseif cm:pending_battle_cache_faction_is_attacker(self.bhashiva_faction) and pb:attacker_won() then	
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i)
					local faction = cm:get_faction(faction_name)

					if faction:culture() == self.cultures.cathay and not self.enemy_factions_favour[faction_name] and faction:can_be_human() then
						table.insert(cathay_winnners, {char_cqi = char_cqi, mf_cqi = mf_cqi, faction_name = faction_name})
					end

					losers = self.pending_battle.defenders
				end
			end

			if #cathay_winnners > 0 then
				local enemy_favour_increased = {}
				for _, loser in ipairs(losers) do
					local mf = cm:get_military_force_by_cqi(loser.mf_cqi)
					local loser_faction = cm:get_faction(loser.faction_key)

					if is_faction(loser_faction) then
						if (loser_faction:num_regions() > 0 or loser_faction:military_force_list():num_items() > 0) and not enemy_favour_increased[loser.faction_key] then
							enemy_favour_increased[loser.faction_key] = true
							self:increase_favour_for_losing_faction(loser, losers)
						end
					end
					
					if mf and not mf:is_null_interface() and not mf:is_armed_citizenry() then
						local faction = mf:faction()

						if faction:is_rebel() == false then
							local resource = mf:pooled_resource_manager():resource(self.resources.favour_army)
							
							if resource:is_null_interface() == false then
								local value = resource:value() or loser.favour
								favour = favour + value
								self:assign_favour(mf, self.factors.army_prefix..self.factors.other, -value) --clear favour from losers
							end
						end
					else
						-- mf was wiped out or is an armed citizenry, just cache the pending battle saved favour
						favour = favour + loser.favour
					end
				end

				for _, winner in ipairs(cathay_winnners) do
					local value = favour
					local faction_name = winner.faction_name
					local cqi = winner.cqi
					local mf_cqi = winner.mf_cqi

					if self:can_use_iron_favour(faction_name) then
						cm:faction_add_post_battle_looted_resource(faction_name, self.resources.iron_favour_faction, self.factors.goals_achieved, "FACTION", value)
					end
				end
			end
		end,
		true
	)

	core:add_listener(
		"iron_favourCathayPreRegionFactionChangeEvent",
		"PreRegionFactionChangeEvent",
		function(context)
			local new_faction = context:new_faction()
			return new_faction:culture() == self.cultures.cathay and not self.enemy_factions_favour[new_faction:name()] and new_faction:can_be_human()
		end,
		function(context)
			local region = context:region()
			local iron_favour = region:pooled_resource_manager():resource(self.resources.favour_settlement)
			
			if not iron_favour:is_null_interface() then
				local value = iron_favour:value()
				if value > 0 then
					self:assign_favour(region, self.factors.settlement_prefix..self.factors.other, -value)
				end
				local faction_key = context:new_faction():name()
				if self:can_use_iron_favour(faction_key) then
					cm:faction_add_pooled_resource(faction_key, self.resources.iron_favour_faction, self.factors.goals_achieved, value)
				end
			end
		end,
		true
	)

	core:add_listener(
		"iron_favourCathaySettlementOccupiedNonCathay",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:previous_owner_culture() == self.cultures.cathay and not self.enemy_factions_favour[context:previous_owner()]
		end,		
		function(context)
			local faction_culture = context:character():faction():culture()
			local region_interface = context:garrison_residence():region()
			local region_key = region_interface:name()
			
			if region_interface:owning_faction():culture() ~= self.cultures.cathay or self.enemy_factions_favour[region_interface:owning_faction():name()] then
				local culture_multiplier = self:culture_income_multiplier(faction_culture)
				local iron_favour_points_to_add = self.base_iron_favour_points * culture_multiplier
				local factor = self.factors.settlement_prefix .. self.factors.battles_against_cathay
				
				if self.lost_settlements[region_key] then
					self.lost_settlements[region_key] = self.lost_settlements[region_key] + 1
				else
					self.lost_settlements[region_key] = 1
				end

				local times_lost = self.lost_settlements[region_key] or 1

				for i = 1, #self.cathay_regions do -- itterate key settlement favour
					if region_key == self.cathay_regions[i] then
						self:assign_favour(region_interface, self.factors.settlement_prefix..self.factors.key_settlements, self.values.starting_historical_favour / times_lost)
					end
				end

				self:assign_favour(region_interface, factor, math.floor(iron_favour_points_to_add / times_lost))
			end
		end,
		true
	)

	core:add_listener(
		"iron_favourCathayArmyLosses",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_culture_is_defender(self.cultures.cathay) or cm:pending_battle_cache_culture_is_attacker(self.cultures.cathay)
		end,
		function()
			local pb = cm:model():pending_battle()
			local is_attacker_culture_cathay = cm:pending_battle_cache_culture_is_attacker(self.cultures.cathay)
			local is_defender_culture_cathay = cm:pending_battle_cache_culture_is_defender(self.cultures.cathay)
			local enemy_faction_is_attacker, enemy_faction_is_defender = self:pending_battle_cache_is_enemy_faction_involved(self.enemy_factions_favour)

			if is_attacker_culture_cathay and (not is_defender_culture_cathay or enemy_faction_is_defender) and pb:defender_won() then
				self:assign_favour_to_winner(pb:defender_ending_cp_kill_score(), pb:defender())
			elseif is_defender_culture_cathay and (not is_attacker_culture_cathay or enemy_faction_is_attacker) and pb:attacker_won() then
				self:assign_favour_to_winner(pb:attacker_ending_cp_kill_score(), pb:attacker())
			end
		end,
		true
	)

	core:add_listener(
		"iron_favourFactionDeath",
		"FactionDeath",
		true,
		function(context)
			local dying_faction_interface = context:faction()
			if dying_faction_interface:is_human() or dying_faction_interface:is_idle_human() then
				return
			end

			local bhashiva_faction_interface = cm:get_faction(self.bhashiva_faction)
			for key, mission_data in dpairs(self.current_active_and_pending_mission_data) do
				if not table.is_empty(mission_data)
					and self:is_pending_mission_invalidated_by_faction_death(mission_data, dying_faction_interface)
					and cm:mission_is_active_for_faction(bhashiva_faction_interface, key) == false
				then
					self:invalidate_pending_mission(bhashiva_faction_interface, key)
				end
			end
		end,
		true
	)

	core:add_listener(
		"iron_favourCharacterConvalescedOrKilled",
		"CharacterConvalescedOrKilled",
		true,
		function(context)
			local dying_character_interface = context:character()
			if dying_character_interface:is_faction_leader() == false then
				return
			end

			local bhashiva_faction_interface = cm:get_faction(self.bhashiva_faction)
			for key, mission_data in dpairs(self.current_active_and_pending_mission_data) do
				if not table.is_empty(mission_data)
					and self:is_pending_mission_invalidated_by_character_death(mission_data, dying_character_interface)
					and cm:mission_is_active_for_faction(bhashiva_faction_interface, key) == false
				then
					self:invalidate_pending_mission(bhashiva_faction_interface, key)
				end
			end
		end,
		true
	)

	core:add_listener(
		"iron_favourRegionFactionChangeEvent",
		"RegionFactionChangeEvent",
		true,
		function(context)
			local region_interface = context:region()
			local region_owner_interface = region_interface:owning_faction()
			if not region_owner_interface or region_owner_interface:is_null_interface() or region_owner_interface:name() ~= self.bhashiva_faction then
				return
			end

			local bhashiva_faction_interface = cm:get_faction(self.bhashiva_faction)
			for key, mission_data in dpairs(self.current_active_and_pending_mission_data) do
				if not table.is_empty(mission_data)
					and self:is_pending_mission_invalidated_by_region_faction_change(mission_data, region_interface:name())
					and cm:mission_is_active_for_faction(bhashiva_faction_interface, key) == false
				then
					self:invalidate_pending_mission(bhashiva_faction_interface, key)
				end
			end
		end,
		true
	)
end

function iron_favour:increase_favour_for_losing_faction(faction_data, losers)
	local faction_si = cm:get_faction(faction_data.faction_key)
	local faction_culture = faction_si:culture()
	local culture_multiplier = self:culture_income_multiplier(faction_si:culture())
	local is_siege_battle = cm:model():pending_battle():siege_battle()
	local settlement_key 

	if is_siege_battle then
		settlement_key = cm:model():pending_battle():region_data():key()
	end

	if faction_si:num_regions() > 0 then
		local region_list = faction_si:region_list()
		for i = 0, region_list:num_items() - 1 do
			local region_si = region_list:item_at(i)
			local iron_favoure_resource = region_si:pooled_resource_manager():resource(self.resources.favour_settlement)
			if not iron_favoure_resource:is_null_interface() then
				local current_iron_favour = iron_favoure_resource:value()

				if current_iron_favour ~= 0 and region_si:name() ~= settlement_key then
					local value = ((current_iron_favour / 2) * (culture_multiplier - 1)) + self.settlement_increment_iron_favour
					self:assign_favour(region_si, self.resources.favour_settlement .. "_" .. self.factors.battles_against, value)
				end
			end
		end
	end

	if faction_si:military_force_list():num_items() > 0 then
		local military_force_list = faction_si:military_force_list()
		for i = 0, military_force_list:num_items() - 1 do
			local mf = military_force_list:item_at(i)
			local mf_cqi = mf:command_queue_index()
			local is_force_valid = not table.find(losers, function(loser) return mf_cqi == loser.mf_cqi end)

			if is_force_valid and mf:general_character():character_type_key() == "general" then
				local iron_favoure_resource = mf:pooled_resource_manager():resource(self.resources.favour_army)
				if not iron_favoure_resource:is_null_interface() then
					local current_iron_favour = iron_favoure_resource:value()
		
					if current_iron_favour ~= 0 then
						local value = ((current_iron_favour / 4) * (culture_multiplier - 1)) + self.mf_increment_iron_favour
						self:assign_favour(mf, self.resources.favour_army .. "_" .. self.factors.battles_against, value)
					end
				end
			end
		end
	end
end

function iron_favour:assign_favour_to_winner(winner_ending_cp_kill_score, winner_character)
	if winner_character == nil or winner_character:is_null_interface() then
		return
	end

	if not winner_character:has_military_force() then
		return
	end

	if winner_character:military_force():is_set_piece_battle_army() then 
		return
	end

	local losses = winner_ending_cp_kill_score / 2000
	local culture_modifier = self:culture_income_multiplier(winner_character:faction():culture())
	local favour = math.floor(losses * culture_modifier)
	local factor = self.factors.army_prefix .. self.factors.battles_against_cathay
	self:assign_favour(winner_character:military_force(), factor, favour)
end

function iron_favour:culture_income_multiplier(faction_culture)
    local culture_modifier = self.iron_favour_culture_modifiers[faction_culture]
    return culture_modifier or 1
end

function iron_favour:try_refill_missions(faction_interface)
	local current_active_or_pending_mission_keys = {}
	local active_missions = faction_interface:active_missions(self.mission_event_category_key, true)
	for _, active_mission in model_pairs(active_missions) do
		table.insert(current_active_or_pending_mission_keys, active_mission:mission_record_key())
	end

	local pending_missions = faction_interface:pending_missions(self.mission_event_category_key)
	for _, pending_mission in model_pairs(pending_missions) do
		table.insert(current_active_or_pending_mission_keys, pending_mission:mission_record_key())
	end

	-- generate missions for the ones we don't currently have as pending or active
	for i = 1, #self.base_mission_keys do
		local base_mission_key = self.base_mission_keys[i]
		local should_generate_mission = true
		for j = 1, #current_active_or_pending_mission_keys do
			local active_or_pending_mission_key = current_active_or_pending_mission_keys[j]
			if string.find(active_or_pending_mission_key, base_mission_key) then
				local mission_data = self.current_active_and_pending_mission_data[active_or_pending_mission_key]
				if mission_data and mission_data.invalidated then
					self:clear_pending_mission_data(faction_interface, active_or_pending_mission_key)
				else
					should_generate_mission = false
				end
				break
			end
		end

		if should_generate_mission then
			self:generate_mission(base_mission_key)
		end
	end
end

function iron_favour:disable_favour_for_objective_targets(mission_data)
	local iron_favour_remove = mission_data.iron_favour_add
	local mission_target = mission_data.target or nil
	
	if iron_favour_remove and iron_favour_remove > 0 then
		iron_favour_remove = iron_favour_remove * -1
		if mission_data.objective_scope == "faction" then
			local target_faction = cm:get_faction(mission_data.objective_faction)
			if target_faction then
				self:assign_favour(target_faction, self.factors.zhaos_goals, iron_favour_remove, mission_target)
			end
		elseif mission_data.objective_scope == "culture" then
			local faction_list = cm:get_factions_by_culture(mission_data.objective_culture)
			
			for i, faction in ipairs(faction_list) do
				self:assign_favour(faction, self.factors.zhaos_goals, iron_favour_remove, mission_target)
			end
		end
	end
end

function iron_favour:is_target_valid(target_character_interface, new_mission_data, new_mission_key)
	local target_faction_interface = target_character_interface:faction()
	local target_faction_key = target_faction_interface:name()
	local target_culture = target_faction_interface:culture()
	local target_subculture = target_faction_interface:subculture()

	-- check if we have picked a target that is the same as one of the other missions has
	for key, mission_data in dpairs(self.current_active_and_pending_mission_data) do
		if key ~= new_mission_key
			and not table.is_empty(mission_data)
			and mission_data.objective_scope == new_mission_data.objective_scope
			and mission_data.type == new_mission_data.type
		then
			if mission_data.objective_scope == "faction" and mission_data.objective_faction == target_faction_key then
				return false
			elseif mission_data.objective_scope == "culture" and mission_data.objective_culture == target_culture then
				return false
			elseif mission_data.objective_scope == "subculture" and mission_data.objective_subculture == target_subculture then
				return false
			elseif mission_data.objective_scope == "single_entity" and mission_data.objective_faction == target_faction_key then
				return false
			end
		end
	end

	return true
end

function iron_favour:progress_turns_until_reroll_for_pending_missions(bhashiva_faction_interface)
	for key, mission_data in dpairs(self.current_active_and_pending_mission_data) do
		if cm:mission_is_active_for_faction(bhashiva_faction_interface, key) == false and not table.is_empty(mission_data) then
			local new_turns_remaining = mission_data.turns_until_reroll - 1
			if new_turns_remaining > 0 then
				mission_data.turns_until_reroll = new_turns_remaining
				cm:set_script_state(bhashiva_faction_interface, self.turns_left_until_reroll_shared_state_key_prefix .. key, new_turns_remaining)
			else 
				self:clear_pending_mission_data(bhashiva_faction_interface, key)
			end
		end
	end
end

function iron_favour:invalidate_pending_mission(faction_interface, mission_key)
	self.current_active_and_pending_mission_data[mission_key].invalidated = true
	cm:set_script_state(faction_interface, self.pending_mission_invalidated_shared_state_key_prefix .. mission_key, true)
end

function iron_favour:clear_pending_mission_data(faction_interface, mission_key)
	if not faction_interface or faction_interface:is_null_interface() then
		script_error("ERROR: clear_pending_mission_data() called but supplied argument for faction_interface is invalid.");
		return false
	end

	if not is_string(mission_key) then
		script_error("ERROR: clear_pending_mission_data() called but supplied argument for mission key [" .. tostring(mission_key) .. "] is not a string.");
		return false
	end

	cm:discard_pending_mission(faction_interface, mission_key)
	if self.current_active_and_pending_mission_data[mission_key].invalidated then
		cm:remove_script_state(faction_interface, self.pending_mission_invalidated_shared_state_key_prefix .. mission_key)
	end
	self.current_active_and_pending_mission_data[mission_key] = {}
	cm:remove_script_state(faction_interface, self.turns_left_until_reroll_shared_state_key_prefix .. mission_key)
end

function iron_favour:are_all_factions_of_culture_dead(culture_key)
	if not is_string(culture_key) then
		script_error("ERROR: are_all_factions_of_culture_dead() called but supplied argument [" .. tostring(culture_key) .. "] is not a string.");
		return false
	end

	for i, faction in ipairs(cm:get_factions_by_culture(culture_key)) do
		if faction:is_dead() == false then
			return false
		end
	end

	return true
end

function iron_favour:is_pending_mission_invalidated_by_faction_death(mission_data, dying_faction_interface)
	local dying_faction_key = dying_faction_interface:name()
	if mission_data.objective_scope == "faction"
		and mission_data.type == "destroy_faction"
		and mission_data.objective_faction == dying_faction_key
	then
		-- the faction that was the target of this mission has already been destroyed by other means
		return true
	elseif mission_data.objective_scope == "single_entity"
		and mission_data.type == "kill_faction_leader"
		and mission_data.objective_faction == dying_faction_key
	then
		-- the faction whose leader we were supposed to kill has already been destroyed by other means
		return true
	elseif mission_data.objective_scope == "culture" 
		and (mission_data.type == "win_fights_vs_culture" 
			or mission_data.type == "win_settlement_battles")
		and mission_data.objective_culture == dying_faction_interface:culture()
		and self:are_all_factions_of_culture_dead(mission_data.objective_culture)
	then
		-- the culture we were supposed to fight has been wiped out by other means
		return true
	end

	return false
end

function iron_favour:is_pending_mission_invalidated_by_character_death(mission_data, dying_character_interface)
	local dying_character_faction = dying_character_interface:faction()
	if not dying_character_faction or dying_character_faction:is_null_interface() then
		script_error("ERROR: is_pending_mission_invalidated_by_character_death() called but supplied character with cqi [" .. tostring(dying_character_interface:command_queue_index()) .. "] has no faction")
	end

	if mission_data.objective_scope == "single_entity"
		and mission_data.type == "kill_faction_leader"
		and mission_data.objective_faction == dying_character_faction:name()
	then
		-- the faction whose leader we were supposed to kill has already been destroyed by other means
		return true
	end

	return false
end

function iron_favour:is_pending_mission_invalidated_by_region_faction_change(mission_data, region_key)
	if mission_data.objective_scope == "single_entity"
		and mission_data.type == "capture_settlement"
		and mission_data.objective_region == region_key
	then
		-- we already own the settlement the mission wanted us to occupy
		return true
	end

	return false
end

function iron_favour:rand_between(min, max) -- accepts negative values
	local min = min or 1
	local max = max or 1
	local random_base = cm:random_number(100, 1)
	local random_number = (random_base - 1) / (100 - 1) * (max - min) + min

	return math.round(random_number)
end

function iron_favour:pending_battle_cache_is_enemy_faction_involved(faction_list)
	local enemy_faction_is_attacker = false
	local enemy_faction_is_defender = false
	for faction, value in dpairs(faction_list) do
		if cm:pending_battle_cache_faction_is_attacker(faction) then
			enemy_faction_is_attacker = faction
		elseif cm:pending_battle_cache_faction_is_defender(faction) then
			enemy_faction_is_defender = faction
		end
	end

	return enemy_faction_is_attacker, enemy_faction_is_defender
end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("iron_favour.pending_battle", iron_favour.pending_battle, context)
		cm:save_named_value("iron_favour.current_active_and_pending_mission_data", iron_favour.current_active_and_pending_mission_data, context)
		cm:save_named_value("iron_favour.factions_to_exclude", iron_favour.factions_to_exclude, context)
		cm:save_named_value("iron_favour.lost_settlements", iron_favour.lost_settlements, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			iron_favour.pending_battle = cm:load_named_value("iron_favour.pending_battle", iron_favour.pending_battle, context)
			iron_favour.current_active_and_pending_mission_data = cm:load_named_value("iron_favour.current_active_and_pending_mission_data", iron_favour.current_active_and_pending_mission_data, context)
			iron_favour.factions_to_exclude = cm:load_named_value("iron_favour.factions_to_exclude", iron_favour.factions_to_exclude, context)
			iron_favour.lost_settlements = cm:load_named_value("iron_favour.lost_settlements", iron_favour.lost_settlements, context)
		end
	end
)