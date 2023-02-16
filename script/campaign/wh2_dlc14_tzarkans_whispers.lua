local tzarkans_whispers = {
	faction = "wh2_main_def_hag_graef",
	last_turn = 0,
	cooldown = 0
};
local tzarkan_mission_types = {
	{key = "DECLARE_WAR", weight = 1, cooldown = 0},
	{key = "RAZE_OR_SACK", weight = 1, cooldown = 0},
	{key = "KILL_X_ENTITIES", weight = 1, cooldown = 0}
};
local tzarkan_mission_rewards = {
	{
		key = "money",
		payload = "money %s",
		weight = 2,
		min_amount = 2000,
		max_amount = 15000,
		roundTo = 100
	},
	{
		key = "slaves",
		payload = "faction_pooled_resource_transaction{resource def_slaves;factor missions;amount %s;context absolute;}",
		weight = 2,
		min_amount = 500,
		max_amount = 2000,
		roundTo = 50
	},
	{
		key = "ancillary",
		payload = "add_ancillary_to_faction_pool{ancillary_key %s;}",
		weight = 5
	}
};
local tzarkan_mission_reward_ancillaries = {
	"wh2_dlc14_anc_follower_malus_arleth_vann",
	"wh2_dlc14_anc_follower_malus_balneth_bale",
	"wh2_dlc14_anc_follower_malus_bruglir",
	"wh2_dlc14_anc_follower_malus_edlire",
	"wh2_dlc14_anc_follower_malus_engvin",
	"wh2_dlc14_anc_follower_malus_hathan_gul",
	"wh2_dlc14_anc_follower_malus_hauclir",
	"wh2_dlc14_anc_follower_malus_isilvar",
	"wh2_dlc14_anc_follower_malus_lhunara",
	"wh2_dlc14_anc_follower_malus_lurhan",
	"wh2_dlc14_anc_follower_malus_nagaira",
	"wh2_dlc14_anc_follower_malus_silar",
	"wh2_dlc14_anc_follower_malus_urial",
	"wh2_dlc14_anc_follower_malus_yasmir",
	"wh2_dlc14_anc_talisman_malus_amulet_of_defiance",
	"wh2_dlc14_anc_talisman_malus_idol_of_darkness",
	"wh2_dlc14_anc_weapon_malus_blood_warpsword",
	"wh2_dlc14_anc_weapon_malus_dagger_of_souls",
	"wh2_dlc14_anc_weapon_malus_death_warpsword",
	"wh2_dlc14_anc_weapon_malus_slaugher_warpsword",
	"wh2_dlc14_anc_enchanted_item_malus_octagon_medallion",
	"wh2_dlc14_anc_enchanted_item_malus_warp_gem"
};
local tazrkan_mission_exclusions = {
	"wh2_main_def_naggarond"
};

-- The amount of missions that will attempt to be generated and on what turn
local tzarkan_generate_start_mission_count = 1;
local tzarkan_generate_start_mission_turn = 2;
-- Maximum number of turns until a mission is guaranteed to trigger
local tzarkan_max_turns_until_mission = 20;
-- Turns before another mission can be issued after one is triggered
local tzarkan_mission_cooldown_turns = 10;
-- The amount of Possession given for completing a mission
local tzarkan_possession_reward = 2;

---- DECLARE WAR MISSION
-- Hashness | Value is between 0-1 | 0 will generate easier missions and 1 will generate the harsher
local tazrkan_war_mission_harshness = 0.6;
-- Hashness Cutoffs | Values are between 0-1 | Modifier on the cutoff amount for harshness, 1.0 means all values are acceptable, 0.8 means only the bottom 80th percentile, etc.
local tazrkan_war_mission_harshness_cutoffs = {min = 0.1, max = 1.0};
-- Turn Timer | The turn timer on declare war missions
local tazrkan_war_mission_turn_limit = 10;
-- The harshness rating applied to declare war mission with a faction with these treaties/relations
-- Each line has mutually exclusive values, the relations values are only used if there is no diplomatic treaty
local tazrkan_war_mission_values = {
	base_value = 150,
	vassalized = 300, military_ally = 200, defensive_ally = 150, non_aggression_pact = 100,
	relations_300 = 150, relations_250 = 125, relations_200 = 100, relations_150 = 75, relations_100 = 50, relations_50 = 25,
	trade_partner = 100
};

---- RAZE OR SACK
-- Hashness | Value is between 0-1 | 0 will generate easier missions and 1 will generate the harsher
local tazrkan_raze_mission_harshness = 0.6;
-- Hashness Cutoffs | Values are between 0-1 | Modifier on the cutoff amount for harshness, 1.0 means all values are acceptable, 0.8 means only the bottom 80th percentile, etc.
local tazrkan_raze_mission_harshness_cutoffs = {min = 0.1, max = 1.0};
-- Minimum Targets | The minimum amount of targets that the mission will require
local tazrkan_raze_mission_min_targets = 1;
-- Maximum Targets | The maximum amount of targets that the mission will require
local tazrkan_raze_mission_max_targets = 2;
-- Max Distance | The maximum distance away a region can be to be selected as a potential target, if zero only bordering regions will be used
local tazrkan_raze_mission_max_distance = 25000;
-- Base Harshness | The base harshness value used for the reward calculation added for each region added to the mission
local tazrkan_raze_mission_base_reward_harshness = 0.15;
-- Extra Harshness | The amount of harshness for each region target added to the objective above one
local tazrkan_raze_mission_extra_reward_harshness = 0.15;
-- Turn Timer | The turn timer on the raze missions
local tazrkan_raze_mission_turn_limit = 15;
-- Turn Limit Per Region | The amount of extra turns added per number of regions in the mission
local tazrkan_raze_mission_turn_limit_per_region = 5;
-- The harshness rating applied to each region that is within the raze mission
local tazrkan_raze_mission_values = {
	base_value = 0,
	per_region_level = 10,
	province_capital = 50,
	already_at_war = -100
};

---- KILL X ENTITIES
-- Minimum Kills | The minimum amount of kills that the random number generator will generate for the kill missions
local tazrkan_kill_mission_min_kills = 2000;
-- Maximum Kills | The maximum amount of kills that the random number generator will generate for the kill missions
local tazrkan_kill_mission_max_kills = 6000;
-- Turn Modifier | This number will multiply the number of kills required based on the turn number | kills_required = (random_kill_number * (turn_number * turn_mod))
local tazrkan_kill_mission_turn_mod = 0.05;
-- The turn timer on the kill entities missions
local tazrkan_kill_mission_turn_limit = 20;
-- Round To | This is the number that the required amount of kills will be rounded up to
local tazrkan_kill_mission_round_to = 50;


function add_tzarkans_whispers_listeners()
	out("#### Adding Tz'arkans Whispers Listeners ####");
	core:add_listener(
		"tzarkan_FactionTurnStart",
		"FactionTurnStart",
		function(context)
			local faction = context:faction();
			return faction:is_human() == true and faction:name() == tzarkans_whispers.faction;
		end,
		function(context)
			tzarkan_attempt_trigger_mission(context:faction());
		end,
		true
	);

	local faction = cm:model():world():faction_by_key(tzarkans_whispers.faction);

	if faction:is_human() == true then
		tzarkan_update_ui();
	end
end

function tzarkan_attempt_trigger_mission(faction)
	out.design("tzarkan_attempt_trigger_mission()");
	local turn_number = cm:model():turn_number();
	
	if turn_number == tzarkan_generate_start_mission_turn then
		if tzarkan_generate_start_mission_count == -1 then
			out.design("\tTriggering Start Tzarkan Missions");
			local mission_generated_1 = tzarkan_generate_war_mission(faction);
			out.design("\t\tWar Mission Generated: "..tostring(mission_generated_1));
			
			local mission_generated_2 = tzarkan_generate_raze_mission(faction);
			out.design("\t\tRaze Mission Generated: "..tostring(mission_generated_2));
			
			local mission_generated_3 = tzarkan_generate_kill_mission(faction);
			out.design("\t\tKill Mission Generated: "..tostring(mission_generated_3));

			if mission_generated_1 == true or mission_generated_2 == true or mission_generated_3 == true then
				tzarkans_whispers.cooldown = tzarkan_mission_cooldown_turns;
				out.design("\tCooldown Initiated: "..tzarkan_mission_cooldown_turns.." turns");
			end
		elseif tzarkan_generate_start_mission_count > 0 then
			out.design("\tTriggering Start Tzarkan Missions");
			for i = 1, tzarkan_generate_start_mission_count do
				tzarkan_generate_mission(faction);
			end
		end
	elseif turn_number > tzarkan_generate_start_mission_turn then
		if tzarkans_whispers.cooldown < 1 then
			local chance_to_trigger = ((turn_number - tzarkans_whispers.last_turn) / tzarkan_max_turns_until_mission) * 100;
			out.design("\tChance: "..chance_to_trigger);

			if cm:model():random_percent(chance_to_trigger) then
				out.design("\tSuccess!");
				local mission_generated = tzarkan_generate_mission(faction);
				out.design("\tMission Generated: "..tostring(mission_generated));

				if mission_generated == true then
					tzarkans_whispers.cooldown = tzarkan_mission_cooldown_turns;
					out.design("\tCooldown Initiated: "..tzarkan_mission_cooldown_turns.." turns");
				end
			else
				out.design("\tFailed!");
			end
		else
			out.design("\tCooldown: "..tzarkans_whispers.cooldown);
			tzarkans_whispers.cooldown = tzarkans_whispers.cooldown - 1;
		end
	end
end

function tzarkan_generate_mission(faction)
	if faction == nil then
		faction = cm:get_faction(tzarkans_whispers.faction);
	end

	local mission_generated = false;
	local mission_types = weighted_list:new();
	local kill_mission_excluded = false;
	local mission = nil
	local index = nil

	for i = 1, #tzarkan_mission_types do
		if tzarkan_mission_types[i].cooldown > 0 then
			out.design("\t"..tzarkan_mission_types[i].key.." on cooldown ("..tzarkan_mission_types[i].cooldown..")");
			tzarkan_mission_types[i].cooldown = tzarkan_mission_types[i].cooldown - 1;

			if tzarkan_mission_types[i].key == "KILL_X_ENTITIES" then
				kill_mission_excluded = true;
			end
		else
			mission_types:add_item(tzarkan_mission_types[i].key, tzarkan_mission_types[i].weight);
		end
	end
	
	while mission_generated == false and #mission_types.items > 0 do
		mission, index = mission_types:weighted_select();

		if mission ~= nil then
			if mission == "DECLARE_WAR" then
				mission_generated = tzarkan_generate_war_mission(faction);
			elseif mission == "RAZE_OR_SACK" then
				mission_generated = tzarkan_generate_raze_mission(faction);
			elseif mission == "KILL_X_ENTITIES" then
				mission_generated = tzarkan_generate_kill_mission(faction);
			end
			mission_types:remove_item(index);
		end
	end

	-- Kill Mission should always be generatable unless it's on cooldown so use it as a backup
	if mission_generated == false and kill_mission_excluded == false and mission ~= "KILL_X_ENTITIES" then
		mission_generated = tzarkan_generate_kill_mission(faction);
	end
	if mission_generated == true then
		tzarkan_update_ui();
	end
	return mission_generated;
end

function tzarkan_faction_war_weight(tzarkan_faction, faction_key)
	local tzarkan_faction_key = tzarkan_faction:name();
	local faction_obj = cm:model():world():faction_by_key(faction_key);

	if faction_obj:is_null_interface() == true or faction_obj:is_dead() == true or faction_obj:at_war_with(tzarkan_faction) == true then
		return 0;
	end

	local factions_non_aggression_pact_with = unique_table:faction_list_to_unique_table(tzarkan_faction:factions_non_aggression_pact_with());
	local factions_trading_with = unique_table:faction_list_to_unique_table(tzarkan_faction:factions_trading_with());
	local weight = tazrkan_war_mission_values.base_value;

	-- Vassal
	if faction_obj:is_vassal_of(tzarkan_faction) == true then
		weight = weight + tazrkan_war_mission_values.vassalized;
	-- Military Ally
	elseif faction_obj:military_allies_with(tzarkan_faction) == true then
		weight = weight + tazrkan_war_mission_values.military_ally;
	-- Defensive Ally
	elseif faction_obj:defensive_allies_with(tzarkan_faction) == true then
		weight = weight + tazrkan_war_mission_values.defensive_ally;
	-- Non-Aggression Pact
	elseif factions_non_aggression_pact_with:contains(tzarkan_faction_key) then
		weight = weight + tazrkan_war_mission_values.non_aggression_pact;
	else
		-- Relations
		local relations = tzarkan_faction:diplomatic_attitude_towards(faction_key);

		if relations >= 300 then
			weight = weight + tazrkan_war_mission_values.relations_300;
		elseif relations >= 250 then
			weight = weight + tazrkan_war_mission_values.relations_250;
		elseif relations >= 200 then
			weight = weight + tazrkan_war_mission_values.relations_200;
		elseif relations >= 150 then
			weight = weight + tazrkan_war_mission_values.relations_150;
		elseif relations >= 100 then
			weight = weight + tazrkan_war_mission_values.relations_100;
		elseif relations >= 50 then
			weight = weight + tazrkan_war_mission_values.relations_50;
		end
	end

	-- Trading Partner
	if factions_trading_with:contains(tzarkan_faction_key) then
		weight = weight + tazrkan_war_mission_values.trade_partner;
	end
	return weight;
end

function tzarkan_generate_war_mission(tzarkan_faction)
	out.design("tzarkan_generate_war_missions()");
	local tzarkan_faction_key = tzarkan_faction:name();
	out.design("\tFaction: "..tzarkan_faction_key);
	local possible_factions = unique_table:new();
	local factions_met = unique_table:faction_list_to_unique_table(tzarkan_faction:factions_met());
	local factions_at_war_with = unique_table:faction_list_to_unique_table(tzarkan_faction:factions_at_war_with());

	-- Add all of the factions we currently know of
	possible_factions = possible_factions + factions_met;
	-- Remove all the factions we're already at war with
	possible_factions = possible_factions - factions_at_war_with;

	local possible_factions_table = possible_factions:to_table();
	local weighted_factions = weighted_list:new();
	
	local max_weight = tazrkan_war_mission_values.base_value + tazrkan_war_mission_values.vassalized + tazrkan_war_mission_values.trade_partner;
	local peak_weight = max_weight * tazrkan_war_mission_harshness;
	local min_cutoff = max_weight * tazrkan_war_mission_harshness_cutoffs.min;
	local max_cutoff = max_weight * tazrkan_war_mission_harshness_cutoffs.max;

	for i = 1, #possible_factions_table do
		local faction_key = possible_factions_table[i];
		local exclude = false;

		for j = 1, #tazrkan_mission_exclusions do
			if faction_key == tazrkan_mission_exclusions[j] then
				exclude = true;
				break;
			end
		end

		if exclude == false then
			local faction_obj = cm:model():world():faction_by_key(faction_key);
			local weight = tzarkan_faction_war_weight(tzarkan_faction, faction_key);
			
			if weight > 0 then
				local normalized_weight = math.normalize(weight, 0, max_weight);

				if weight > peak_weight then
					weight = peak_weight - (weight - peak_weight);
				end

				if weight >= min_cutoff and weight <= max_cutoff then
					local target_faction = {faction_key = faction_key, normalized_weight = normalized_weight};
					weighted_factions:add_item(target_faction, weight);
				end
			end
		end
	end

	if #weighted_factions.items > 0 then
		local selected_faction = weighted_factions:weighted_select();

		local mm = mission_manager:new(tzarkan_faction_key, "wh2_dlc14_tzarkan_declare_war");
		mm:set_mission_issuer("CLAN_ELDERS");
		mm:add_new_objective("DECLARE_WAR");
		mm:add_condition("faction "..selected_faction.faction_key);
		if tazrkan_war_mission_turn_limit > 0 then
			mm:set_turn_limit(tazrkan_war_mission_turn_limit);
		end
		mm:set_should_whitelist(false);

		local reward = tzarkan_generate_reward(selected_faction.normalized_weight);
		mm:add_payload(reward);
		mm:add_payload("faction_pooled_resource_transaction{resource def_malus_sanity;factor wh2_dlc14_resource_factor_sanity_tzarkans_whispers;amount "..tzarkan_possession_reward..";context absolute;}");
		mm:trigger();
		tzarkan_mission_types[1].cooldown = tazrkan_war_mission_turn_limit;
		return true;
	end
	return false;
end

local function get_regions_within_distance_of_character(character, distance, not_razed, return_unique_list)
	-- These two functions no longer exist in wh3 has this was the only place it was used. Copying them here locally to make the script work but if they are needed in future we can look at making them baseline again
	local nearby_regions = unique_table:new();
	local regions = cm:model():world():region_manager():region_list();
	local char_x = character:logical_position_x();
	local char_y = character:logical_position_y();

	for i = 0, regions:num_items() - 1 do
		local region = regions:item_at(i);
		local settlement = region:settlement();
		local region_x = settlement:logical_position_x();
		local region_y = settlement:logical_position_y();
		local real_distance = distance_squared(char_x, char_y, region_x, region_y);

		if distance >= real_distance then
			if not_razed == false then
				nearby_regions:insert(region);
			elseif region:is_abandoned() == false then
				nearby_regions:insert(region);
			end
		end
	end
	if return_unique_list == true then
		return nearby_regions;
	end
	return nearby_regions:to_table();
end

local function get_border_regions_of_faction(faction, outside_border, return_unique_list)
	-- These two functions no longer exist in wh3 has this was the only place it was used. Copying them here locally to make the script work but if they are needed in future we can look at making them baseline again
	local border_regions = unique_table:new();
	local regions = faction:region_list();

	for i = 0, regions:num_items() - 1 do
		local region = regions:item_at(i);
		local adj_regions = region:adjacent_region_list();
		
		for j = 0, adj_regions:num_items() - 1 do
			local adj_region = adj_regions:item_at(j);
			local owner = adj_region:owning_faction();

			if owner:is_null_interface() == false and owner:is_faction(faction) == false then
				if outside_border == true then
					border_regions:insert(adj_region);
				elseif outside_border == false then
					border_regions:insert(adj_region);
					break;
				end
			end
		end
	end
	if return_unique_list == true then
		return border_regions;
	end
	return border_regions:to_table();
end

function tzarkan_generate_raze_mission(tzarkan_faction)
	out.design("tzarkan_generate_raze_mission()");
	local tzarkan_faction_key = tzarkan_faction:name();
	out.design("\tFaction: "..tzarkan_faction_key);
	local faction_leader = tzarkan_faction:faction_leader();

	local target_regions = {};
	local region_list = {};
	local num_targets = cm:random_number(tazrkan_raze_mission_max_targets, tazrkan_raze_mission_min_targets);

	if tazrkan_raze_mission_max_distance > 0 then
		region_list = get_regions_within_distance_of_character(faction_leader, tazrkan_raze_mission_max_distance, true, false);
	else
		region_list = get_border_regions_of_faction(tzarkan_faction, true, false);
	end

	local weighted_regions = weighted_list:new();

	local max_weight = tazrkan_war_mission_values.base_value + tazrkan_war_mission_values.vassalized + tazrkan_war_mission_values.trade_partner;
	max_weight = max_weight + tazrkan_raze_mission_values.base_value + (5 * tazrkan_raze_mission_values.per_region_level) + tazrkan_raze_mission_values.province_capital;
	local peak_weight = max_weight * tazrkan_raze_mission_harshness;
	local min_cutoff = max_weight * tazrkan_raze_mission_harshness_cutoffs.min;
	local max_cutoff = max_weight * tazrkan_raze_mission_harshness_cutoffs.max;

	for i = 1, #region_list do
		local region = region_list[i];
		local region_key = region:name();
		local region_level = region:settlement():primary_slot():building():building_level();
		local region_owner = region:owning_faction();
		local region_owner_key = region_owner:name();
		local skip_faction = false;

		for j = 1, #tazrkan_mission_exclusions do
			if region_owner_key == tazrkan_mission_exclusions[j] or region_owner_key == tzarkan_faction_key then
				skip_faction = true;
				break;
			end
		end

		if skip_faction == false then
			local weight = tazrkan_raze_mission_values.base_value + (region_level * tazrkan_raze_mission_values.per_region_level);

			if region:is_province_capital() == true then
				weight = weight + tazrkan_raze_mission_values.province_capital;
			end

			local war_harshness = tzarkan_faction_war_weight(tzarkan_faction, region_owner_key);
			weight = weight + war_harshness;

			if region_owner:at_war_with(tzarkan_faction) == true then
				weight = weight + tazrkan_raze_mission_values.already_at_war;
			end

			if weight > 0 then
				if weight > peak_weight then
					weight = peak_weight - (weight - peak_weight);
				end

				if weight >= min_cutoff and weight <= max_cutoff then
					local normalized_weight = math.normalize(weight, 0, max_weight) + tazrkan_raze_mission_base_reward_harshness;
					local weighted_region = {key = region_key, weight = normalized_weight};
					weighted_regions:add_item(weighted_region, weight);
				end
			end
		end
	end

	if #weighted_regions.items > 0 then
		local total_normalized_weight = 0;

		for i = 1, num_targets do
			local target, index = weighted_regions:weighted_select();
			weighted_regions:remove_item(index);
			table.insert(target_regions, target.key);
			total_normalized_weight = total_normalized_weight + target.weight;

			if #weighted_regions.items == 0 then
				break;
			end
		end
		
		if #target_regions > 0 then
			local mm = mission_manager:new(tzarkan_faction_key, "wh2_dlc14_tzarkan_raze_or_sack");
			mm:set_mission_issuer("CLAN_ELDERS");
			mm:add_new_objective("RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING");

			for i = 1, #target_regions do
				mm:add_condition("region "..target_regions[i]);
			end
			mm:add_condition("total "..#target_regions);
			local turn_limit = 0;

			if tazrkan_raze_mission_turn_limit > 0 then
				turn_limit = tazrkan_raze_mission_turn_limit + (#target_regions * tazrkan_raze_mission_turn_limit_per_region);
				mm:set_turn_limit(turn_limit);
			end
			mm:set_should_whitelist(false);
			
			total_normalized_weight = total_normalized_weight + ((#target_regions - 1) * tazrkan_raze_mission_extra_reward_harshness);
			local reward = tzarkan_generate_reward(total_normalized_weight);
			mm:add_payload(reward);
			mm:add_payload("faction_pooled_resource_transaction{resource def_malus_sanity;factor wh2_dlc14_resource_factor_sanity_tzarkans_whispers;amount "..tzarkan_possession_reward..";context absolute;}");
			mm:trigger();
			tzarkan_mission_types[2].cooldown = turn_limit;
			return true;
		end
	end
	return false;
end

function tzarkan_generate_kill_mission(tzarkan_faction)
	out.design("tzarkan_generate_kill_mission()");
	local tzarkan_faction_key = tzarkan_faction:name();
	out.design("\tFaction: "..tzarkan_faction_key);

	local mm = mission_manager:new(tzarkan_faction_key, "wh2_dlc14_tzarkan_kill_entities");
	mm:set_mission_issuer("CLAN_ELDERS");
	mm:add_new_objective("KILL_X_ENTITIES");

	local kill_count = cm:random_number(tazrkan_kill_mission_max_kills, tazrkan_kill_mission_min_kills);
	local normalized_kills = math.normalize(kill_count, tazrkan_kill_mission_min_kills, tazrkan_kill_mission_max_kills);
	local turn_number = cm:model():turn_number();
	kill_count = kill_count * ((turn_number * tazrkan_kill_mission_turn_mod) + 1);
	kill_count = math.ceilTo(kill_count, tazrkan_kill_mission_round_to);

	mm:add_condition("total "..kill_count);

	if tazrkan_kill_mission_turn_limit > 0 then
		mm:set_turn_limit(tazrkan_kill_mission_turn_limit);
	end
	mm:set_should_whitelist(false);
	
	local reward = tzarkan_generate_reward(normalized_kills);
	mm:add_payload(reward);
	mm:add_payload("faction_pooled_resource_transaction{resource def_malus_sanity;factor wh2_dlc14_resource_factor_sanity_tzarkans_whispers;amount "..tzarkan_possession_reward..";context absolute;}");
	mm:trigger();
	tzarkan_mission_types[3].cooldown = tazrkan_kill_mission_turn_limit;
	return true;
end

function tzarkan_generate_reward(harshness)
	local weighted_rewards = weighted_list:new();

	for i = 1, #tzarkan_mission_rewards do
		if tzarkan_mission_rewards[i].key == "ancillary" then
			if #tzarkan_mission_reward_ancillaries > 0 then
				weighted_rewards:add_item(tzarkan_mission_rewards[i], tzarkan_mission_rewards[i].weight);
			end
		else
			weighted_rewards:add_item(tzarkan_mission_rewards[i], tzarkan_mission_rewards[i].weight);
		end
	end

	local reward = weighted_rewards:weighted_select();
	local payload = "";

	if reward.key == "ancillary" then
		local rand_anc = cm:random_number(#tzarkan_mission_reward_ancillaries);
		local anc_key = tzarkan_mission_reward_ancillaries[rand_anc];
		payload = string.format(reward.payload, anc_key);
		table.remove(tzarkan_mission_reward_ancillaries, rand_anc);
	else
		local amount = reward.min_amount + ((reward.max_amount - reward.min_amount) * harshness);
		payload = string.format(reward.payload, tostring(math.ceilTo(amount, reward.roundTo)));
	end
	return payload;
end

function tzarkan_update_ui()
	local ui_root = core:get_ui_root();
	local mission_ui = find_uicomponent(ui_root, "tzarkans_whispers");
	
	if mission_ui then
		mission_ui:InterfaceFunction("SetMissions", "wh2_dlc14_tzarkan_declare_war", "wh2_dlc14_tzarkan_kill_entities", "wh2_dlc14_tzarkan_raze_or_sack");
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("tzarkans_whispers", tzarkans_whispers, context);
		cm:save_named_value("tzarkan_mission_types", tzarkan_mission_types, context);
		cm:save_named_value("tzarkan_mission_reward_ancillaries", tzarkan_mission_reward_ancillaries, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			tzarkans_whispers = cm:load_named_value("tzarkans_whispers", tzarkans_whispers, context);
			tzarkan_mission_types = cm:load_named_value("tzarkan_mission_types", tzarkan_mission_types, context);
			tzarkan_mission_reward_ancillaries = cm:load_named_value("tzarkan_mission_reward_ancillaries", tzarkan_mission_reward_ancillaries, context);
		end
	end
);