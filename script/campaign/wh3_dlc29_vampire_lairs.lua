vampire_lairs = {
	lair_faction = "wh3_main_vmp_vampire_lairs",
	lair_keys = {
		owned = "wh3_dlc29_slot_set_vampire_lair",
		complete = "wh3_dlc29_slot_set_vampire_lair_complete",
		complete_owned = "wh3_dlc29_slot_set_vampire_lair_complete_owned",
		foreign = "wh3_dlc29_slot_set_vampire_lair_foreign"
	},
	lairs_to_vampires = {
		{awakening_building = "wh3_dlc29_vmp_lair_primary_2_blood_dragon", vampire_subtype = "wh2_dlc11_vmp_bloodline_blood_dragon", completed_building = "wh3_dlc29_vmp_lair_complete_2_blood_dragon"},
		{awakening_building = "wh3_dlc29_vmp_lair_primary_2_lahmian", vampire_subtype = "wh2_dlc11_vmp_bloodline_lahmian", completed_building = "wh3_dlc29_vmp_lair_complete_2_lahmian"},
		{awakening_building = "wh3_dlc29_vmp_lair_primary_2_necrarch", vampire_subtype = "wh2_dlc11_vmp_bloodline_necrarch", completed_building = "wh3_dlc29_vmp_lair_complete_2_necrarch"},
		{awakening_building = "wh3_dlc29_vmp_lair_primary_2_strigoi", vampire_subtype = "wh2_dlc11_vmp_bloodline_strigoi", completed_building = "wh3_dlc29_vmp_lair_complete_2_strigoi"},
		{awakening_building = "wh3_dlc29_vmp_lair_primary_2_von_carstein", vampire_subtype = "wh2_dlc11_vmp_bloodline_von_carstein", completed_building = "wh3_dlc29_vmp_lair_complete_2_von_carstein"}
	},
	building_traits = {
		["wh3_dlc29_vmp_lair_secondary_legacy_1"] = {trait_key = "wh3_main_vmp_trait_legacy_lucky"},
		["wh3_dlc29_vmp_lair_secondary_legacy_2"] = {trait_key = "wh3_main_vmp_trait_legacy_undefeated"},
		["wh3_dlc29_vmp_lair_secondary_legacy_3"] = {trait_key = "wh3_main_vmp_trait_legacy_corrupted"},
		["wh3_dlc29_vmp_lair_secondary_legacy_4"] = {trait_key = "wh3_main_vmp_trait_legacy_silent"},
		["wh3_dlc29_vmp_lair_secondary_legacy_5"] = {trait_key = "wh3_main_vmp_trait_legacy_inflamed"},
		["wh3_dlc29_vmp_lair_secondary_legacy_6"] = {trait_key = "wh3_main_vmp_trait_legacy_command"},
		["wh3_dlc29_vmp_lair_secondary_power_1"] = {trait_key = "wh3_main_vmp_trait_power_stalker"},
		["wh3_dlc29_vmp_lair_secondary_power_2"] = {trait_key = "wh3_main_vmp_trait_power_death"},
		["wh3_dlc29_vmp_lair_secondary_power_3"] = {trait_key = "wh3_main_vmp_trait_power_fixation"},
		["wh3_dlc29_vmp_lair_secondary_power_4"] = {trait_key = "wh3_main_vmp_trait_power_magic"},
		["wh3_dlc29_vmp_lair_secondary_power_5"] = {trait_key = "wh3_main_vmp_trait_power_battle"},
		["wh3_dlc29_vmp_lair_secondary_power_6"] = {trait_key = "wh3_main_vmp_trait_power_health"}
	},
	building_skills = {
		["empty"] = {skill_key = ""}
	},
	building_ranks_and_xp = {
		["wh3_dlc29_vmp_lair_secondary_knowledge_rank_1"] = {rank = 10, xp = 0},
		["wh3_dlc29_vmp_lair_secondary_knowledge_rank_2"] = {rank = 20, xp = 0},
		["wh3_dlc29_vmp_lair_secondary_knowledge_rank_3"] = {rank = 30, xp = 0}
	},
	building_unit_xp = {
		["empty"] = {amount = 1}
	},
	building_items = {
		["wh3_dlc29_vmp_lair_secondary_followers_other_1"] = {items = {"wh3_main_anc_follower_vmp_necromancer_rare_1", "wh3_main_anc_follower_vmp_necromancer_rare_2", "wh3_main_anc_follower_vmp_necromancer_rare_3"}, is_follower = true, equip = true, amount = 1},
		["wh3_dlc29_vmp_lair_secondary_followers_other_2"] = {items = {"wh3_main_anc_follower_vmp_necromancer_legendary_1", "wh3_main_anc_follower_vmp_necromancer_legendary_2", "wh3_main_anc_follower_vmp_necromancer_legendary_3"}, is_follower = true, equip = true, amount = 1},
		["wh3_dlc29_vmp_lair_secondary_knowledge_other_1"] = {items = {"wh3_main_anc_enchanted_item_reset_innate_trait_vmp"}, is_follower = false, equip = false, amount = 3, hide_message = true}
	},
	building_random_items = { -- 5 max per building due to category limitations
		["wh3_dlc29_vmp_lair_secondary_items_ancillary_1"] = {
			{uniqueness = "uncommon", amount = 2}
		},
		["wh3_dlc29_vmp_lair_secondary_items_ancillary_2"] = {
			{uniqueness = "uncommon", amount = 2},
			{uniqueness = "rare", amount = 2}
		},
		["wh3_dlc29_vmp_lair_secondary_items_ancillary_3"] = {
			{uniqueness = "rare", amount = 4}
		}
	},
	building_agents = {
		["wh3_dlc29_vmp_lair_secondary_followers_necromancer_1"] = {agent_type_key = "wizard", agent_subtype_key = "wh_main_vmp_necromancer", rank = 10, trait_key = "wh2_main_trait_corrupted_vampire"},
		["wh3_dlc29_vmp_lair_secondary_followers_necromancer_2"] = {agent_type_key = "wizard", agent_subtype_key = "wh_main_vmp_necromancer", rank = 20, trait_key = "wh2_main_trait_corrupted_vampire"},
		["wh3_dlc29_vmp_lair_secondary_followers_necromancer_3"] = {agent_type_key = "wizard", agent_subtype_key = "wh_main_vmp_necromancer", rank = 30, trait_key = "wh2_main_trait_corrupted_vampire"}
	},
	building_resources = {
		["wh3_dlc29_vmp_lair_secondary_followers_corpses_1"] = {
			{location = "province", resource_key = "wh3_dlc29_vmp_corpses", factor_key = "vampire_lairs", amount = 3000}
		},
		["wh3_dlc29_vmp_lair_secondary_followers_corpses_2"] = {
			{location = "province", resource_key = "wh3_dlc29_vmp_corpses", factor_key = "vampire_lairs", amount = 4000},
			{location = "faction_leader", resource_key = "wh3_dlc29_vmp_corpses", factor_key = "vampire_lairs", amount = 2000}
		}
	},
	building_army = {
		["wh3_dlc29_vmp_lair_secondary_followers_army_1"] = {units = "wh_main_vmp_mon_crypt_horrors,wh_main_vmp_inf_grave_guard_0,wh_main_vmp_inf_grave_guard_0,wh_main_vmp_inf_grave_guard_0,wh_main_vmp_mon_fell_bats,wh_main_vmp_mon_fell_bats,wh_main_vmp_inf_zombie,wh_main_vmp_inf_zombie,wh_main_vmp_inf_zombie"}
	},
	building_discover_lair = {
		["wh3_dlc29_vmp_lair_secondary_items_crypt_2"] = {move_teleport = false},
		["wh3_dlc29_vmp_lair_secondary_items_crypt_3"] = {move_teleport = true}
	},
	building_keep_lair = {
		["wh3_dlc29_vmp_lair_secondary_items_crypt_1"] = true,
		["wh3_dlc29_vmp_lair_secondary_items_crypt_2"] = true,
		["wh3_dlc29_vmp_lair_secondary_items_crypt_3"] = true
	},
	building_mounts = {
		["wh3_dlc29_vmp_lair_secondary_followers_mount_1"] = true
	},
	subtype_to_mounts = {
		["wh2_dlc11_vmp_bloodline_blood_dragon"] = {
			{key = "wh2_dlc11_skill_vmp_bloodline_blood_dragon_unique_barded_nightmare", weight = 2, auto_rank = 8},
			{key = "wh2_dlc11_skill_vmp_bloodline_blood_dragon_unique_hellsteed", weight = 2, auto_rank = 10},
			{key = "wh2_dlc11_skill_vmp_bloodline_blood_dragon_unique_zombie_dragon", weight = 1, auto_rank = 18}
		},
		["wh2_dlc11_vmp_bloodline_lahmian"] = {
			{key = "wh2_dlc11_skill_vmp_bloodline_lahmian_unique_barded_nightmare", weight = 2, auto_rank = 8},
			{key = "wh2_dlc11_skill_vmp_bloodline_lahmian_unique_hellsteed", weight = 2, auto_rank = 10},
			{key = "wh2_dlc11_skill_vmp_bloodline_lahmian_unique_zombie_dragon", weight = 1, auto_rank = 18},
			{key = "wh3_dlc29_skill_vmp_lord_unique_lahmian_lord_coven_throne", weight = 1, auto_rank = 20}
		},
		["wh2_dlc11_vmp_bloodline_necrarch"] = {
			{key = "wh2_dlc11_skill_vmp_bloodline_necrarch_unique_barded_nightmare", weight = 2, auto_rank = 8},
			{key = "wh2_dlc11_skill_vmp_bloodline_necrarch_unique_hellsteed", weight = 2, auto_rank = 10},
			{key = "wh2_dlc11_skill_vmp_bloodline_necrarch_unique_zombie_dragon", weight = 1, auto_rank = 18}
		},
		["wh2_dlc11_vmp_bloodline_strigoi"] = {
			{key = "wh2_dlc11_skill_vmp_bloodline_strigoi_unique_terrorgheist", weight = 1, auto_rank = 20}
		},
		["wh2_dlc11_vmp_bloodline_von_carstein"] = {
			{key = "wh2_dlc11_skill_vmp_bloodline_von_carstein_unique_barded_nightmare", weight = 2, auto_rank = 8},
			{key = "wh2_dlc11_skill_vmp_bloodline_von_carstein_unique_hellsteed", weight = 2, auto_rank = 10},
			{key = "wh2_dlc11_skill_vmp_bloodline_von_carstein_unique_zombie_dragon", weight = 1, auto_rank = 18}
		}
	},
	lair_spawning_data = { -- This table holds all of the data relevant on new game for distributing Lairs across the world
		factions = {
			{
				key = "wh_main_vmp_vampire_counts", -- Mannfred
				first_lair = "wh3_main_combi_region_antoch",
				lair_pools = {
					{key = "close", distance = 35000, lair_count = 2}, -- Distance set at the value at which at least 50 regions are within range
					{key = "medium", distance = 240000, lair_count = 2}, -- Distance set at the value at which 50% of all regions are within range
					{key = "far", distance = 400000, lair_count = 3}, -- Distance set at the value at which 75% of all region are within range
					{key = "random", distance = 9999999, lair_count = 3}, -- All regions are valid at this distance
				}
			},
			{
				key = "wh2_dlc11_vmp_the_barrow_legion", -- Kemmler
				first_lair = "wh3_main_combi_region_castle_bastonne",
				lair_pools = {
					{key = "close", distance = 20000, lair_count = 2},
					{key = "medium", distance = 135000, lair_count = 2},
					{key = "far", distance = 290000, lair_count = 3},
					{key = "random", distance = 9999999, lair_count = 3}
				}
			},
			{
				key = "wh3_main_vmp_caravan_of_blue_roses", -- Ghorst
				first_lair = "wh3_main_combi_region_shattered_cove",
				lair_pools = {
					{key = "close", distance = 45000, lair_count = 2},
					{key = "medium", distance = 300000, lair_count = 2},
					{key = "far", distance = 700000, lair_count = 3},
					{key = "random", distance = 9999999, lair_count = 3}
				}
			},
			{
				key = "wh_main_vmp_schwartzhafen", -- Vlad/Isabella
				first_lair = "wh3_main_combi_region_castle_templehof",
				lair_pools = {
					{key = "close", distance = 20000, lair_count = 2},
					{key = "medium", distance = 140000, lair_count = 2},
					{key = "far", distance = 300000, lair_count = 3},
					{key = "random", distance = 9999999, lair_count = 3}
				}
			},
			{
				key = "wh3_dlc29_vmp_neferata", -- Neferata
				first_lair = "wh3_main_combi_region_desolation_of_drakenmoor",
				lair_pools = {
					{key = "close", distance = 25000, lair_count = 2},
					{key = "medium", distance = 160000, lair_count = 2},
					{key = "far", distance = 390000, lair_count = 3},
					{key = "random", distance = 9999999, lair_count = 3}
				}
			}
		},
		lair_overlap_decreases_count = false, -- If true then any Lair that overlaps into two or more factions pools will count for both factions, generally reducing overall Lair count
		allow_lairs_falling_to_next_pool = true, -- If true any pool that couldn't spawn its set Lair amount due to lack of valid regions will send those Lairs to the next best pool, this allows ensuring overall Lair amount stays intact even if locality will be off
		only_province_capitals = false, -- If true Lairs will only ever spawn in province capital regions
		disallow_adjacent_provinces = false, -- If true Lairs will never spawn in a province that has an adjacent province with a Lair
		ignore_ruins = false, -- If true Lairs will never spawn in razed regions
		ignore_provinces_and_regions = {
			["wh3_main_combi_province_eastern_colonies"] = "IGNORE",
			["wh3_main_combi_province_the_great_ocean"] = "IGNORE",
			["wh3_main_combi_province_yn_edri_eternos"] = "IGNORE",
			["wh3_main_combi_province_talsyn"] = "IGNORE",
			["wh3_main_combi_province_wydrioth"] = "IGNORE",
			["wh3_main_combi_province_torgovann"] = "IGNORE",
			["wh3_main_combi_province_argwylon"] = "IGNORE",
			["wh3_main_combi_region_mordheim"] = "IGNORE"
		}
	},
	setup_complete = false,
	keep_lair_after_awakening = false,
	lair_event_shown_this_turn = {},
	previous_lairs = {},
	pending_auto_mounts = {},
	verbose_logging = false
};

function vampire_lairs:initialise()
	out("Vampire Lairs: Initialise");
	self:add_listeners();
end

-- This need to exist in the root because it needs to happen earlier than the scripts full initialization
core:add_listener(
	"VampireLairSeenStartingRegions",
	"SettlementSeenEvent",
	function(context)
		return vampire_lairs.setup_complete == false and context:is_first_time() == true;
	end,
	function(context)
		if vampire_lairs.lair_spawning_data ~= nil then
			local region_key = context:settlement():region():name();
			vampire_lairs.lair_spawning_data.ignore_provinces_and_regions[region_key] = "VISIBLE_REGION";
		end
	end,
	true
);
core:add_listener(
	"VampireLairFirstTickAfterWorldCreated",
	"FirstTickAfterWorldCreated",
	true,
	function(context)
		if cm:is_new_game() == true then
			vampire_lairs:initital_lair_setup();
			vampire_lairs.setup_complete = true;
		end
		-- This table will never be needed again after this point and it contains a lot of data due to the new game Lair setup so we free it for the GC
		vampire_lairs.lair_spawning_data = nil;
	end,
	true
);

function vampire_lairs:initital_lair_setup()
	out("Vampire Lairs: Initial Lair Setup");
	-- Add the initial "hardcoded" Lair for each Legendary Lords start position
	for faction_index = 1, #self.lair_spawning_data.factions do
		if self.lair_spawning_data.factions[faction_index].first_lair ~= "" then
			local region = cm:get_region(self.lair_spawning_data.factions[faction_index].first_lair);
			local visible_to = cm:get_faction(self.lair_spawning_data.factions[faction_index].key);
			local foreign_slot_manager = self:create_lair(region);
			out("\tCreating STARTING Lair in region "..region:name().." for "..self.lair_spawning_data.factions[faction_index].key);
			self:reveal_lair(foreign_slot_manager, visible_to, false);
			-- Ignore this province for future spawning as it already has a Lair now
			local province_key = region:province_name();
			self.lair_spawning_data.ignore_provinces_and_regions[province_key] = "HAS_LAIR";
		end
	end
	-- Now do all other Lair distribution
	self:distribute_lairs();
end

-- LAIR DISTRIBUTION
-- Every Vampire faction has a number of "pools" with a set max distance, every region will fall into one of these factions pools based on its distance to that factions capital
-- Each pool has a set amount of Lairs it will spawn amongst the regions that end up in its pool
-- This allows us to finely control the amount of Lairs at any given distance from any given Vampire factions
-- It's important we can set the distances per faction, as some factions have very different average distances to surrounding regions
function vampire_lairs:distribute_lairs()
	out("Vampire Lairs: Distributing Lairs");
	local vampire_factions = cm:get_factions_by_subculture("wh_main_sc_vmp_vampire_counts");

	for _, faction in ipairs(vampire_factions) do
		if faction:is_dead() == false and faction:can_be_human() == true then
			for faction_index = 1, #self.lair_spawning_data.factions do
				local faction_key = faction:name();

				if self.lair_spawning_data.factions[faction_index].key == faction_key then
					out("\tCreating Faction Pool: "..self.lair_spawning_data.factions[faction_index].key);
					for pool_index = 1, #self.lair_spawning_data.factions[faction_index].lair_pools do
						self.lair_spawning_data.factions[faction_index].lair_pools[pool_index].regions = {};
					end

					if faction:has_home_region() == false then
						-- If a faction in our list of factions doens't have a region something has gone horribly wrong or we have made drastic startpos changes and need to adjust this script
						script_error("Vampire Lairs: A faction in the scripts faction list no longer has a home region! This will require script changes");
					end
					
					-- Track their home position now for use later
					local home_region = faction:home_region();
					self.lair_spawning_data.factions[faction_index].position = {};
					self.lair_spawning_data.factions[faction_index].position.x = home_region:settlement():logical_position_x();
					self.lair_spawning_data.factions[faction_index].position.y = home_region:settlement():logical_position_y();

					-- We'll never want to spawn a Lair in the factions starting province, so add it to the ignore list
					local home_province = home_region:province_name();
					self.lair_spawning_data.ignore_provinces_and_regions[home_province] = "HOME_PROVINCE";
					out("\t\tIgnoring Home Province: "..home_province);
				end
			end
		end
	end

	local region_list = cm:model():world():region_manager():region_list();
	out("\tPooling Regions...");
	
	-- For every region we will go through all factions pools and assign them to the relevant pool based on the regions distance to the factions capital
	for region_index = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(region_index);

		if self:is_region_valid_lair_spawn(region) == true then
			local region_key = region:name();
			local settlement_x = region:settlement():logical_position_x();
			local settlement_y = region:settlement():logical_position_y();
			local weight = self:get_region_lair_weight(region);

			for faction_index = 1, #self.lair_spawning_data.factions do
				local distance_between_region_and_faction = self:calculate_distance(settlement_x, settlement_y, self.lair_spawning_data.factions[faction_index].position.x, self.lair_spawning_data.factions[faction_index].position.y);

				-- Based on this regions distance to the faction, put it in the correct pool. The distance values are incremental in this table and so we should use the first valid pool as it will be the closest
				for pool_index = 1, #self.lair_spawning_data.factions[faction_index].lair_pools do
					local max_distance_allowed_for_this_pool = self.lair_spawning_data.factions[faction_index].lair_pools[pool_index].distance;

					if distance_between_region_and_faction <= max_distance_allowed_for_this_pool then
						local valid_region = {};
						valid_region.region = region;
						valid_region.weight = weight;
						table.insert(self.lair_spawning_data.factions[faction_index].lair_pools[pool_index].regions, valid_region);
						break;
					end
				end
			end
		end
	end

	if self.verbose_logging == true then
		-- This is purely debug output, but useful for QA to see at a glance how the distribution setup is doing
		for faction_index = 1, #self.lair_spawning_data.factions do
			out("\tFaction Pools: "..self.lair_spawning_data.factions[faction_index].key);
			local total = 0;

			for pool_index = 1, #self.lair_spawning_data.factions[faction_index].lair_pools do
				local num_regions = #self.lair_spawning_data.factions[faction_index].lair_pools[pool_index].regions;
				out("\t\tPool: "..self.lair_spawning_data.factions[faction_index].lair_pools[pool_index].key.." - Valid Regions: "..num_regions);
				total = total + num_regions;
			end
			out("\t\tTotal in all pools: "..total);
		end
	end

	out("\tLair Spawning:");
	-- Every faction should now have all of their pools filled with all valid regions, so we can begin creating the Lairs
	for faction_index, faction in ipairs(self.lair_spawning_data.factions) do
		out("\t\tFaction: "..faction.key);

		-- Go through all pools for this faction, and create the amount of Lairs required per pool
		for pool_index, pool in ipairs(faction.lair_pools) do
			out("\t\t\tPool: "..pool.key);

			-- Make sure there are actually regions we can choose from in this pool, else something has gone very wrong!
			if #pool.regions == 0 then
				script_error("There were no available regions when spawning Lairs for the faction pool: "..faction.key.." ("..pool.key..") - Please contact Mitch");
				return false;
			end

			out("\t\t\tCleaning Lair Region list:");
			-- Do a cleanup of this factions pools regions incase we've already added a Lair to them as part of another factions pool, iterate backwards as we'll need to remove entries
			for region_index = #pool.regions, 1, -1 do
				-- The regions table is a tables of tables containing the region interface and its weight
				local region = pool.regions[region_index].region;
				local region_key = region:name();
				local region_province_key = region:province_name();

				-- If this region or its province has been newly ignored, remove it from the list of possible regions for this faction
				-- We only adjust the remaining lair amount if the region was ignored because it already has a Lair, because we will count this as having a nearby Lair already created for this faction
				local ignored_as_province = self.lair_spawning_data.ignore_provinces_and_regions[region_province_key];
				local ignored_as_region = self.lair_spawning_data.ignore_provinces_and_regions[region_key];

				if ignored_as_province ~= nil then
					table.remove(pool.regions, region_index);

					if self.lair_spawning_data.lair_overlap_decreases_count == true and ignored_as_province == "HAS_LAIR" then
						pool.lair_count = pool.lair_count - 1;
					end
				elseif ignored_as_region ~= nil then
					table.remove(pool.regions, region_index);

					if self.lair_spawning_data.lair_overlap_decreases_count == true and ignored_as_region == "HAS_LAIR" then
						pool.lair_count = pool.lair_count - 1;
					end
				end
			end

			-- Build a weighted list from the pools region list
			local possible_regions = weighted_list:new();

			for region_index = 1, #pool.regions do
				local region = pool.regions[region_index].region;
				local weight = pool.regions[region_index].weight;
				possible_regions:add_item(region, weight);
			end

			-- While there are still lairs left to give...
			while pool.lair_count > 0 do
				-- Do a weighted select of all possible regions and create the Lair there
				local selected_region, selected_index = possible_regions:weighted_select();
				self:create_lair(selected_region);

				-- We won't ever want multiple Lairs within the same province, so we track this regions province as one to ignore
				local province = selected_region:province();
				local province_key = province:key();
				self.lair_spawning_data.ignore_provinces_and_regions[province_key] = "HAS_LAIR";

				if self.lair_spawning_data.disallow_adjacent_provinces == true then
					local adjacent_provinces = province:adjacent_provinces();

					for province_index = 0, adjacent_provinces:num_items() - 1 do
						local adjacent_province_key = adjacent_provinces:item_at(province_index):key();
						
						if self.lair_spawning_data.ignore_provinces_and_regions[adjacent_province_key] == nil then
							self.lair_spawning_data.ignore_provinces_and_regions[adjacent_province_key] = "ADJACENT_LAIR";
						end
					end
				end

				-- Remove this as a possible region for this pool and reduce the Lairs left to give this faction
				possible_regions:remove_item(selected_index);
				pool.lair_count = pool.lair_count - 1;
				out("\t\t\tCreating Lair in Region: "..selected_region:name().." (Remaining: "..pool.lair_count..")");

				-- If we've ran out of valid regions in the weighted list yet there are still more Lairs left to spawn we can move them to the next available pool. Ideally this wouldn't happen with good data setup, but it is possible
				if #possible_regions.items == 0 and pool.lair_count > 0 then
					if self.verbose_logging == true then
						out("");
						out("\t\t\t\tWARNING: Ran out of potential regions to give all of a factions allocated amount of Lairs: "..faction.key.." ("..pool.key..")");
						out("\t\t\t\t\tRemaining Amount: "..pool.lair_count);
						out("");
					end

					if self.lair_spawning_data.allow_lairs_falling_to_next_pool == true then
						-- Move these Lairs to the next available pool, if there is one
						if pool_index < #faction.lair_pools then
							faction.lair_pools[pool_index + 1].lair_count = faction.lair_pools[pool_index + 1].lair_count + pool.lair_count;
						end
					end
					pool.lair_count = 0;
				end
			end
		end
	end
end

-- The weight of a region is its eventual likelihood to be selected as a Lair location compared to other regions
function vampire_lairs:get_region_lair_weight(region)
	local weight = 4;

	-- Ruined regions are much less likely to have Lairs
	if self.lair_spawning_data.ignore_ruins == false and region:is_abandoned() == true then
		weight = weight - 2;
	end

	-- Much more likely to get Lairs in province capitals
	if self.lair_spawning_data.only_province_capitals == false and region:is_province_capital() == true then
		weight = weight + 2;
	end
	return weight;
end

function vampire_lairs:calculate_distance(x1, y1, x2, y2)
	return (x2 - x1) ^ 2 + (y2 - y1) ^ 2;
end

function vampire_lairs:is_region_valid_lair_spawn(region)
	if self.lair_spawning_data.ignore_provinces_and_regions[region:name()] then
		return false; -- This region has been set as ignored
	end
	if self.lair_spawning_data.ignore_provinces_and_regions[region:province_name()] then
		return false; -- This regions province has been set as ignored
	end
	if self.lair_spawning_data.ignore_ruins == true and region:is_abandoned() == true then
		return false; -- The region is a ruin
	end
	if self.lair_spawning_data.only_province_capitals == true and region:is_province_capital() == false then
		return false; -- The region is not the province capital
	end
	return true;
end

function vampire_lairs:create_lair(region)
	if region and region:is_null_interface() == false then
		local lair_owner = cm:get_faction(self.lair_faction);
		local foreign_slot_manager = cm:add_foreign_slot_set_to_region_for_faction(lair_owner:command_queue_index(), region:cqi(), self.lair_keys.foreign);
		-- Keep track of where Lairs have been for other uses
		local region_key = region:name();
		self.previous_lairs[region_key] = true;
		return foreign_slot_manager;
	end
end

function vampire_lairs:reveal_lair(foreign_slot_manager, visible_to, trigger_event)
	if foreign_slot_manager:is_null_interface() == false then
		local region = foreign_slot_manager:region();
		local visible_to_faction_key = visible_to:name();
		out("Vampire Lairs: Revealing Lair in region "..region:name().." for "..visible_to_faction_key);
		out("\tTriggering Event - "..tostring(trigger_event));
		cm:foreign_slot_set_reveal_to_faction(visible_to, foreign_slot_manager);

		if trigger_event == true and self.lair_event_shown_this_turn[visible_to_faction_key] == nil then
			local incident_builder = cm:create_incident_builder("wh3_dlc29_vmp_incident_lair_found");
			incident_builder:add_target("default", region);

			local payload_builder = cm:create_payload();
			payload_builder:text_display("dummy_vampire_lair_discovered");
			incident_builder:set_payload(payload_builder);
			payload_builder:clear();
			cm:launch_custom_incident_from_builder(incident_builder, visible_to);

			self.lair_event_shown_this_turn[visible_to_faction_key] = true;
		end
	end
end

function vampire_lairs:discover_lair_chance(faction, settlement)
	-- This faction has discovered a new settlement, so we check if there is a Lair here that we need to reveal
	local region = settlement:region();
	local foreign_slot_manager = region:foreign_slot_manager_for_faction(self.lair_faction, self.lair_keys.foreign);

	if foreign_slot_manager:is_null_interface() == false then
		out(faction:name().." has seen settlement "..settlement:key().." for the first time");
		-- If the foreign slot manager for the Lair faction exists then there IS a Lair here and the player should discover it
		self:reveal_lair(foreign_slot_manager, faction, true);
		core:trigger_event("ScriptEventVampireLairDiscovered", faction, region);
	end
end

function vampire_lairs:discover_random_lair(discovering_faction, show_event)
	local lair_owner = cm:get_faction(self.lair_faction);
	local foreign_slot_managers = lair_owner:foreign_slot_managers();
	local possible_lairs = weighted_list:new();

	for i = 0, foreign_slot_managers:num_items() - 1 do
		local lair = foreign_slot_managers:item_at(i);

		if lair:has_been_discovered(discovering_faction:command_queue_index()) == false then
			possible_lairs:add_item(lair, 1);
		end
	end

	if #possible_lairs.items > 0 then
		local selected_lair, selected_index = possible_lairs:weighted_select();
		self:reveal_lair(selected_lair, discovering_faction, show_event);
		return selected_lair;
	end
	return nil;
end

function vampire_lairs:occupy_lair(foreign_slot_manager, new_owner)
	local region = foreign_slot_manager:region();
	local lair_owner = foreign_slot_manager:faction();
	-- Remove the old lair
	cm:remove_faction_foreign_slots_from_region(lair_owner:command_queue_index(), region:cqi(), self.lair_keys.foreign);
	-- Give new owner the full lair
	cm:add_foreign_slot_set_to_region_for_faction(new_owner:command_queue_index(), region:cqi(), self.lair_keys.owned);
	
	-- Give event to new owner
	local incident_builder = cm:create_incident_builder("wh3_dlc29_vmp_incident_lair_occupied");
	incident_builder:add_target("default", region);

	local payload_builder = cm:create_payload();
	payload_builder:text_display("dummy_vampire_lair_occupied");
	incident_builder:set_payload(payload_builder);
	payload_builder:clear();
	cm:launch_custom_incident_from_builder(incident_builder, new_owner);
end

function vampire_lairs:awaken_vampire(vampire_index, slot_manager)
	cm:disable_event_feed_events(true, "all");
	local faction = slot_manager:faction();
	local faction_key = faction:name();
	local region = slot_manager:region();
	local region_key = region:name();
	local slot_list = slot_manager:slots();
	local vampire_subtype = self.lairs_to_vampires[vampire_index].vampire_subtype;
	local should_keep_lair = false;
	out("AWAKENING VAMPIRE - "..vampire_subtype.." - "..faction_key.." - "..region_key);
	core:trigger_event("ScriptEventVampireLairAwakened", faction);

	-- Table to keep track of all extra building effects for the later event message
	local rewards_to_show = {
		["dummy_lair_building_army"] = false,
		["dummy_lair_building_discover_lair"] = false,
		["dummy_lair_building_traits"] = false,
		["dummy_lair_building_skills"] = false,
		["dummy_lair_building_mount"] = false,
		["dummy_lair_building_ranks"] = false,
		["dummy_lair_building_xp"] = false,
		["dummy_lair_building_unit_xp"] = false,
		["dummy_lair_building_followers"] = false,
		["dummy_lair_building_items"] = false,
		["dummy_lair_building_characters"] = false,
		["dummy_lair_building_resources_faction"] = false,
		["dummy_lair_building_resources_province"] = false,
		["dummy_lair_building_keep_lair"] = false
	};

	-- Find out before we do anything more whether we spawn the character into the pool or onto the map depending on secondary buildings
	local spawn_army_for_character = nil;
	local spawn_location_override = nil;

	for slot_index = 0, slot_list:num_items() - 1 do
		local building_slot = slot_list:item_at(slot_index);

		if building_slot:has_building() == true then
			local building_key = building_slot:building();
			
			-- We need to know if we spawn an army early as this change how we create the lord
			if self.building_army[building_key] then
				spawn_army_for_character = self.building_army[building_key].units;
				rewards_to_show["dummy_lair_building_army"] = true;
			end
			-- We need to discover Lairs early as other buildings may require their location later
			if self.building_discover_lair[building_key] then
				local lair = self:discover_random_lair(faction, true);

				if lair ~= nil then
					local lair_region = lair:region();
					cm:make_region_seen_in_shroud(faction_key, lair_region:name());

					if self.building_discover_lair[building_key].move_teleport == true then
						spawn_location_override = lair_region;
					end
				end
				rewards_to_show["dummy_lair_building_discover_lair"] = true;
			end
		end
	end

	-- Spawn the new lord either into an army or the pool
	local character_details = nil;
	local spawned_character = nil;
	local starting_rank = 0;
	local preselected_mount = ""

	-- If this string has any units in it, then we know we need to spawn an army, else put them in the pool
	if spawn_army_for_character then
		out("\tSpawning character into army")
		local spawn_distance = 0;
		if faction:command_queue_index() ~= region:owning_faction():command_queue_index() then
			spawn_distance = 5; -- If this isn't the characters factions settlement then spawn him further away to avoid the ZoC
		end

		local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, spawn_distance);
		spawned_character = cm:create_force_with_general(
			faction_key,
			spawn_army_for_character,
			region_key,
			pos_x,
			pos_y,
			"general",
			vampire_subtype,
			"","","","",
			false,
			function(cqi)
				cm:replenish_action_points(cm:char_lookup_str(cqi));
			end,
			false,
			true
		);
		character_details = spawned_character:character_details(); -- We want to use the character details interface even though we have the character, because new characters in the pool can only be modified through their details
	else
		out("\tSpawning character into pool")
		character_details = cm:spawn_character_to_pool(faction_key, "", "", "", "", 30, true, "general", vampire_subtype, true, "", true);
	end

	if character_details == nil or character_details:is_null_interface() == true then
		script_error("Vampire Lairs: Newly awakened Vampire doesn't have a valid character_details interface - Please contact Mitch")
	end

	-- Give them a background trait, as the spawning functions didn't
	local background_skill = innate_trait_reset:apply_new_background_skill(character_details);
	out("\tSelected background skill - "..background_skill);

	-- Give all rewards from secondary buildings
	for slot_index = 0, slot_list:num_items() - 1 do
		local building_slot = slot_list:item_at(slot_index);

		if building_slot:has_building() == true then
			local building_key = building_slot:building();
			
			if self.building_traits[building_key] then
				-- Give traits to the new character
				cm:force_add_trait_to_character_details(character_details, self.building_traits[building_key].trait_key);
				if spawned_character and self.building_traits[building_key].trait_key == "wh3_main_vmp_trait_power_stalker" and spawned_character:has_military_force() then
					local force = spawned_character:military_force()
					if force and not force:is_null_interface() then
						local cqi = force:command_queue_index()
						cm:military_force_add_temporary_stance(cqi, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_STALKING", 0)
					end
				end
				rewards_to_show["dummy_lair_building_traits"] = true;
			end
			if self.building_skills[building_key] then
				-- Unlock or lock specific skills of that character
				cm:character_details_add_skill_point(character_details, self.building_skills[building_key].skill_key);
				rewards_to_show["dummy_lair_building_skills"] = true;
			end
			if self.building_mounts[building_key] then
				local weighted_mounts = weighted_list:new();

				for _, mount in ipairs(self.subtype_to_mounts[vampire_subtype]) do
					weighted_mounts:add_item(mount.key, mount.weight);
				end
				
				preselected_mount = weighted_mounts:weighted_select();
				rewards_to_show["dummy_lair_building_mount"] = true;
			end
			if self.building_ranks_and_xp[building_key] then
				local building_rank_and_xp = self.building_ranks_and_xp[building_key]

				-- Rank up the character if rank is set up
				if building_rank_and_xp.rank > 0 then
					starting_rank = starting_rank + building_rank_and_xp.rank;
					rewards_to_show["dummy_lair_building_ranks"] = true;
				end

				-- Add XP to everyone if xp is set up
				if building_rank_and_xp.xp > 0 then
					local character_list = faction:character_list();

					for i = 0,  character_list:num_items() - 1 do
						local char = character_list:item_at(i);

						if char:family_member():command_queue_index() ~= character_details:family_member():command_queue_index() then
							local char_lookup_str = cm:char_lookup_str(char);
							cm:add_agent_experience(char_lookup_str, building_rank_and_xp.xp);
						end
					end
					rewards_to_show["dummy_lair_building_xp"] = true;
				end
			end
			if self.building_unit_xp[building_key] then
				local military_force_list = faction:military_force_list();

				for i = 0, military_force_list:num_items() - 1 do
					local force = military_force_list:item_at(i);
					local unit_list = force:unit_list();

					for j = 0, unit_list:num_items() - 1 do
						local unit = unit_list:item_at(j);	
						cm:add_experience_to_unit(unit, self.building_unit_xp[building_key].amount);
					end
				end
				rewards_to_show["dummy_lair_building_unit_xp"] = true;
			end
			if self.building_items[building_key] then
				if self.building_items[building_key].equip then
					-- Equip ancillaries to the character
					cm:shuffle_table(self.building_items[building_key].items);
					cm:character_details_add_ancillary(character_details, self.building_items[building_key].items[1]);

					if self.building_items[building_key].amount > 1 then
						for i = 2, self.building_items[building_key].amount do
							cm:add_ancillary_to_faction(faction, self.building_items[building_key].items[1], true);
						end
					end
				else
					for i = 1, self.building_items[building_key].amount do
						cm:add_ancillary_to_faction(faction, self.building_items[building_key].items[1], true);
					end
				end

				if not self.building_items[building_key].hide_message then
					if self.building_items[building_key].is_follower then
						rewards_to_show["dummy_lair_building_followers"] = true;
					else
						rewards_to_show["dummy_lair_building_items"] = true;
					end
				end
			end
			if self.building_random_items[building_key] then
				local categories = {"weapon", "armour", "enchanted_item", "talisman", "arcane_item"};
				cm:shuffle_table(categories);

				for _, item_set in ipairs(self.building_random_items[building_key]) do
					for i = 1, item_set.amount do
						local new_ancillary = get_random_ancillary_key_for_faction(faction_key, categories[1], item_set.uniqueness);
						cm:character_details_add_ancillary(character_details, new_ancillary);
						table.remove(categories, 1);
					end
				end
			end
			if self.building_agents[building_key] then
				-- Spawn an agent next to the settlement or at a newly discovered lair
				local spawn_region = region;

				if spawn_location_override then
					spawn_region = spawn_location_override;
				end

				local necro_x, necro_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, spawn_region:name(), false, true, 5);
				local agent = cm:spawn_agent_at_position(faction, necro_x, necro_y, self.building_agents[building_key].agent_type_key, self.building_agents[building_key].agent_subtype_key);
				rewards_to_show["dummy_lair_building_characters"] = true;

				if agent:is_null_interface() == false then
					local agent_lookup_str = cm:char_lookup_str(agent);
					cm:replenish_action_points(agent_lookup_str);

					if self.building_agents[building_key].trait_key and self.building_agents[building_key].trait_key ~= "" then
						cm:force_add_trait(agent_lookup_str, self.building_agents[building_key].trait_key, false, 1);
					end
					if self.building_agents[building_key].rank and self.building_agents[building_key].rank > 0 then
						cm:add_agent_experience(agent_lookup_str, self.building_agents[building_key].rank, true);
					end
				end
			end
			if self.building_resources[building_key] then
				for _, resource_table in ipairs(self.building_resources[building_key]) do
					-- Give pooled resources to the faction/province/leader
					if resource_table.location == "faction" then
						cm:faction_add_pooled_resource(faction_key, resource_table.resource_key, resource_table.factor_key, resource_table.amount);
						rewards_to_show["dummy_lair_building_resources_faction"] = true;
					elseif resource_table.location == "province" then
						local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, region:province());
						local corpse_resource = pooled_resource_manager:resource(resource_table.resource_key);
						cm:pooled_resource_factor_transaction(corpse_resource, resource_table.factor_key, resource_table.amount);
						rewards_to_show["dummy_lair_building_resources_province"] = true;
					elseif resource_table.location == "faction_leader" then
						if faction:has_faction_leader() == true then
							local province = nil;
							local faction_leader = faction:faction_leader();

							if faction_leader:is_null_interface() == false and faction_leader:has_region() == true and faction_leader:is_at_sea() == false then
								province = faction_leader:region_data():region():province();
							elseif faction:has_home_region() == true then
								province = faction:home_region():province();
							end

							if province ~= nil then
								local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, province);
								local corpse_resource = pooled_resource_manager:resource(resource_table.resource_key);
								cm:pooled_resource_factor_transaction(corpse_resource, resource_table.factor_key, resource_table.amount);
							end
						end
					end
				end
			end
			if self.building_keep_lair[building_key] then
				should_keep_lair = true;
				rewards_to_show["dummy_lair_building_keep_lair"] = true;
			end
		end
	end
	if faction:has_technology("wh3_main_tech_vmp_vampires_lair_4") == true then
		starting_rank = starting_rank + 3;
	end
	if faction:has_technology("wh3_main_tech_vmp_vampires_unlock_1") == true then
		starting_rank = starting_rank + 1;
	end
	if faction:has_technology("wh3_main_tech_vmp_vampires_unlock_2") == true then
		starting_rank = starting_rank + 1;
	end
	if faction:has_technology("wh3_main_tech_vmp_vampires_unlock_3") == true then
		starting_rank = starting_rank + 1;
	end
	if faction:has_technology("wh3_main_tech_vmp_vampires_unlock_4") == true then
		starting_rank = starting_rank + 1;
	end
	if faction:has_technology("wh3_main_tech_vmp_vampires_unlock_5") == true then
		starting_rank = starting_rank + 1;
	end
	
	if starting_rank > 0 then
		-- This only sets the rank and doesn't increase it, hence why we add the ranks up from all buildings and do it at the end
		cm:character_details_set_rank(character_details, starting_rank, false, true);
	end

	-- add mount here so we can check if our starting rank is above the needed for the mount
	-- if it is, then we don't need to add it now as it will be granted once the character is recruited
	-- granting it on character recruit is preferrable since adding the skill here means it'll be commited on character creation
	-- and it won't trigger an event feed event for the mount being gained
	local mounts = self.subtype_to_mounts[vampire_subtype];
	if preselected_mount ~= "" and mounts then
		for _, mount in ipairs(mounts) do
			if mount.key == preselected_mount and
				mount.auto_rank and 
				starting_rank < mount.auto_rank and 
				character_details:has_skill(mount.key) == false and 
				character_details:is_skill_awaiting_commit(mount.key) == false 
			then
				cm:character_details_add_skill_point(character_details, preselected_mount);
			end
		end
	end

	if spawn_army_for_character then
		-- Character already exists on the campaign map, so grant everything applicable. Automatic mounts given immediately and without spending skill points.
		local mounts = self.subtype_to_mounts[vampire_subtype];

		if spawned_character and spawned_character:is_null_interface() == false and mounts then
			for _, mount in ipairs(mounts) do
				if spawned_character:has_skill(mount.key) == false and 
					spawned_character:character_details():is_skill_awaiting_commit(mount.key) == false 
				then
					cm:add_skill(spawned_character, mount.key, true, true);
				end
			end
		end
	else
		local family_member_cqi = character_details:family_member():command_queue_index();
		self.pending_auto_mounts[family_member_cqi] = true;
	end

	-- Remove the players old lair
	cm:remove_faction_foreign_slots_from_region(faction:command_queue_index(), region:cqi(), self.lair_keys.owned);
	
	if should_keep_lair == true then
		-- Give the owner the completed version
		cm:add_foreign_slot_set_to_region_for_faction(faction:command_queue_index(), region:cqi(), self.lair_keys.complete_owned);
		local fsm = region:foreign_slot_manager_for_faction(faction_key, self.lair_keys.complete_owned);

		if fsm:is_null_interface() == false then
			local slots = fsm:slots();
			cm:foreign_slot_instantly_upgrade_building(slots:item_at(0), self.lairs_to_vampires[vampire_index].completed_building);
		end
	elseif self.keep_lair_after_awakening == true then
		-- Give the Lair faction the completed version
		local lair_owner = cm:get_faction(self.lair_faction);
		cm:add_foreign_slot_set_to_region_for_faction(lair_owner:command_queue_index(), region:cqi(), self.lair_keys.complete);
		-- Reveal the completed lair to the player, as they don't own it now
		local fsm = region:foreign_slot_manager_for_faction(self.lair_faction, self.lair_keys.complete);
		cm:foreign_slot_set_reveal_to_faction(faction, fsm);

		if fsm:is_null_interface() == false then
			local slots = fsm:slots();
			cm:foreign_slot_instantly_upgrade_building(slots:item_at(0), self.lairs_to_vampires[vampire_index].completed_building);
		end
	end

	cm:disable_event_feed_events(false, "all");

	local character_faction = character_details:faction()
	if not character_faction:is_human() then
		return
	end

	-- Show a dilemma event
	out("\tShowing dilemma event")
	local dilemma_builder = cm:create_dilemma_builder("wh3_dlc29_vmp_dilemma_lair_awakened");
	dilemma_builder:add_target("default", character_details:family_member());

	local payload_builder = self:create_event_payload(vampire_subtype, rewards_to_show);
	dilemma_builder:add_choice_payload("FIRST", payload_builder);
	payload_builder:clear();
	cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
end

function vampire_lairs:create_event_payload(bloodline, rewards_to_show)
	local payload_builder = cm:create_payload();
	payload_builder:text_display("dummy_lair_awakened_"..bloodline);

	if rewards_to_show["dummy_lair_building_army"] then
		payload_builder:text_display("dummy_lair_building_army");
	end
	if rewards_to_show["dummy_lair_building_discover_lair"] then
		payload_builder:text_display("dummy_lair_building_discover_lair");
	end
	if rewards_to_show["dummy_lair_building_traits"] then
		payload_builder:text_display("dummy_lair_building_traits");
	end
	if rewards_to_show["dummy_lair_building_skills"] then
		payload_builder:text_display("dummy_lair_building_skills");
	end
	if rewards_to_show["dummy_lair_building_mount"] then
		payload_builder:text_display("dummy_lair_building_mount");
	end
	if rewards_to_show["dummy_lair_building_ranks"] then
		payload_builder:text_display("dummy_lair_building_ranks");
	end
	if rewards_to_show["dummy_lair_building_xp"] then
		payload_builder:text_display("dummy_lair_building_xp");
	end
	if rewards_to_show["dummy_lair_building_unit_xp"] then
		payload_builder:text_display("dummy_lair_building_unit_xp");
	end
	if rewards_to_show["dummy_lair_building_followers"] then
		payload_builder:text_display("dummy_lair_building_followers");
	end
	if rewards_to_show["dummy_lair_building_items"] then
		payload_builder:text_display("dummy_lair_building_items");
	end
	if rewards_to_show["dummy_lair_building_characters"] then
		payload_builder:text_display("dummy_lair_building_characters");
	end
	if rewards_to_show["dummy_lair_building_resources_faction"] then
		payload_builder:text_display("dummy_lair_building_resources_faction");
	end
	if rewards_to_show["dummy_lair_building_resources_province"] then
		payload_builder:text_display("dummy_lair_building_resources_province");
	end
	if rewards_to_show["dummy_lair_building_keep_lair"] then
		payload_builder:text_display("dummy_lair_building_keep_lair");
	end
	return payload_builder;
end

function vampire_lairs:get_vampire_index_for_building(building_key)
	for i = 1, #self.lairs_to_vampires do
		if self.lairs_to_vampires[i].awakening_building == building_key then
			return i;
		end
	end
	return nil;
end

function vampire_lairs:try_awaken_vampire_in_region(vampire_index, faction_key, region_key)
	local faction = cm:get_faction(faction_key);
	local region = cm:get_region(region_key);

	if not faction or faction:is_null_interface() or not region or region:is_null_interface() then
		return;
	end

	local slot_manager = region:foreign_slot_manager_for_faction(faction_key, self.lair_keys.owned);
	if slot_manager:is_null_interface() then
		return;
	end

	local awakening_building = self.lairs_to_vampires[vampire_index].awakening_building;
	local slot_list = slot_manager:slots();

	for slot_index = 0, slot_list:num_items() - 1 do
		local building_slot = slot_list:item_at(slot_index);
		if building_slot:has_building() and building_slot:building() == awakening_building then
			self:awaken_vampire(vampire_index, slot_manager);
			return;
		end
	end
end

function vampire_lairs:add_listeners()
	core:add_listener(
		"VampireLairNewLairChance",
		"SettlementSeenEvent",
		function(context)
			return self.setup_complete == true and context:is_first_time() == true and context:faction():culture() == "wh_main_vmp_vampire_counts";
		end,
		function(context)
			local faction = context:faction(); -- Discoverer
			local settlement = context:settlement();
			self:discover_lair_chance(faction, settlement);
		end,
		true
	);
	core:add_listener(
		"VampireLairOccupied",
		"RegionFactionChangeEvent",
		true,
		function(context)
			local region = context:region();
			local new_owner = region:owning_faction();

			if new_owner:culture() == "wh_main_vmp_vampire_counts" then
				local fsm = region:foreign_slot_manager_for_faction(self.lair_faction, self.lair_keys.foreign);

				if fsm:is_null_interface() == false then
					-- If the foreign slot manager for the Lair faction isn't null then there is a lair here and the new vampire occupier now fully owns it!
					self:occupy_lair(fsm, new_owner);
				end
			end
		end,
		true
	);
	core:add_listener(
		"VampireLairsInstantConstruction",
		"ForeignSlotBuildingConstructionIssued",
		function(context)
			return context:building():starts_with("wh3_dlc29_vmp_lair_")
				and context:slot_manager():slot_set_key() == self.lair_keys.owned;
		end,
		function(context)
			cm:foreign_slot_instantly_complete_construction(context:slot());
		end,
		true
	);
	core:add_listener(
		"VampireLairsInstantAwaken",
		"ForeignSlotBuildingCompleteEvent",
		function(context)
			return context:slot_manager():slot_set_key() == self.lair_keys.owned
				and self:get_vampire_index_for_building(context:building()) ~= nil;
		end,
		function(context)
			local vampire_index = self:get_vampire_index_for_building(context:building());
			local slot_manager = context:slot_manager();
			local faction_key = slot_manager:faction():name();
			local region_key = slot_manager:region():name();

			-- Destroying the foreign slot inside ForeignSlotBuildingCompleteEvent crashes; defer until this event has left the C++ stack
			cm:callback(function()
				self:try_awaken_vampire_in_region(vampire_index, faction_key, region_key);
			end, 0.1);
		end,
		true
	);
	core:add_listener(
		"VampireLairsFactionTurnStart",
		"FactionTurnStart",
		function(context)
			return context:faction():culture() == "wh_main_vmp_vampire_counts";
		end,
		function(context)
			local faction = context:faction();

			-- Reset the Lair discovered event
			self.lair_event_shown_this_turn[faction:name()] = nil;
		end,
		true
	);
	core:add_listener(
		"VampireLairsAutoMountsOnRecruitment",
		"CharacterRecruited",
		function(context)
			local character = context:character();
			local family_member_cqi = character:family_member():command_queue_index();

			return self.pending_auto_mounts[family_member_cqi] == true;
		end,
		function(context)
			local character = context:character();
			local character_details = character:character_details();
			local vampire_subtype = character:character_subtype_key();
			local mounts = self.subtype_to_mounts[vampire_subtype];

			if mounts then
				local rank = character:rank();

				for _, mount in ipairs(mounts) do
					if mount.auto_rank and 
						rank >= mount.auto_rank and 
						character_details:has_skill(mount.key) == false and 
						character_details:is_skill_awaiting_commit(mount.key) == false 
					then
						cm:add_skill(character, mount.key, true, true);
					end
				end
			end

			local family_member_cqi = character:family_member():command_queue_index();
			self.pending_auto_mounts[family_member_cqi] = nil;
		end,
		true
	);
	core:add_listener(
		"VampireLairsCharacterGarrisonTargetAction",
		"CharacterGarrisonTargetAction",
		function(context)
			local action_key = context:agent_action_key();
			return action_key:ends_with("_discover_lair") and (context:mission_result_critial_success() or context:mission_result_success());
		end,
		function(context)
			local region = context:garrison_residence():region();
			local faction = context:character():faction();
			local fsm = region:foreign_slot_manager_for_faction(self.lair_faction, self.lair_keys.foreign);

			if fsm:is_null_interface() == false then
				-- If the foreign slot manager for the Lair faction isn't null then there is a lair here and the new vampire occupier now fully owns it!
				self:occupy_lair(fsm, faction);
			end
		end,
		true
	);
	core:add_listener(
		"VampireLairsCharacterPerformsSettlementOccupationDecision",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:character():has_trait("wh3_main_vmp_trait_legacy_corrupted");
		end,
		function(context)
			local option = context:occupation_decision_type();

			if option:starts_with("occupation_decision_occupy") or option:starts_with("occupation_decision_colonise") or option:starts_with("occupation_decision_resettle") then
				local region = context:garrison_residence():region();
				cm:change_corruption_in_province_by(region:province_name(), "wh3_main_corruption_vampiric", 100, "characters");
				cm:apply_effect_bundle_to_region("wh3_main_bundle_region_vampiric_climate", region:name(), 0);
				vampire_corpses:update_region_climate(region);
			end
		end,
		true
	);
	core:add_listener(
		"VampireLairsCharacterCompletedBattle",
		"CharacterCompletedBattle",
		true,
		function (context)
			local character = context:character();
			
			if character:has_trait("wh3_main_vmp_trait_legacy_undefeated") == true then
				local family_member_cqi = character:family_member():command_queue_index();

				if character:won_battle() == true then
					cm:suppress_immortality(family_member_cqi, false);
				else
					cm:callback(function()
						cm:kill_character("family_member_cqi:"..family_member_cqi, true);
					end, 0.2);
				end
			end
		end,
		true
	);
	core:add_listener(
		"VampireLairsPendingBattle",
		"PendingBattle",
		true,
		function(context)
			function prep_for_battle(character)
				if character:has_trait("wh3_main_vmp_trait_legacy_undefeated") == true then
					local family_member_cqi = character:family_member():command_queue_index();
					cm:suppress_immortality(family_member_cqi, true);
				end
			end

			local attacker = context:pending_battle():attacker();
			prep_for_battle(attacker);

			local defender = context:pending_battle():defender();
			prep_for_battle(defender);

			local attacker_list = context:pending_battle():secondary_attackers();
			for i = 0, attacker_list:num_items() - 1 do
				local attacker = attacker_list:item_at(i);
				prep_for_battle(attacker);
			end

			local defender_list = context:pending_battle():secondary_defenders();
			for i = 0, defender_list:num_items() - 1 do
				local defender = defender_list:item_at(i);
				prep_for_battle(defender);
			end

			cm:update_pending_battle();
		end,
		true
	);
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("vampire_lairs_setup_complete", vampire_lairs.setup_complete, context);
		cm:save_named_value("vampire_lairs_previous_lairs", vampire_lairs.previous_lairs, context);
		cm:save_named_value("vampire_lairs_pending_auto_mounts", vampire_lairs.pending_auto_mounts, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			vampire_lairs.setup_complete = cm:load_named_value("vampire_lairs_setup_complete", vampire_lairs.setup_complete, context);
			vampire_lairs.previous_lairs = cm:load_named_value("vampire_lairs_previous_lairs", vampire_lairs.previous_lairs, context);
			vampire_lairs.pending_auto_mounts = cm:load_named_value("vampire_lairs_pending_auto_mounts", vampire_lairs.pending_auto_mounts, context);
		end
	end
);

--[[
	LOGGED DISTANCE VALUES - USED FOR BALANCING

	Maximum theoretical distance possible on the campaign map: 3,014,500
	Maximum distance between a Vampire and their furthest away region: 1,264,276
	Longest Average: 416,656 - wh3_main_vmp_caravan_of_blue_roses
	Longest Median: 314,785 - wh3_main_vmp_caravan_of_blue_roses
	Shortest Average: 193,835 - wh_main_vmp_schwartzhafen
	Shortest Median: 137,461 - wh2_dlc11_vmp_the_barrow_legion
	Average of Averages: 262,814
	Average of Medians: 201,605

	Faction - wh_main_vmp_vampire_counts
		Average Distance: <265,080
		Median Distance: <244,205
		Distance: <2,500  |  Total: 0 (0.0%)  |  Exclusive: 0 (0.0%)
		Distance: <5,000  |  Total: 2 (0.4%)  |  Exclusive: 2 (0.4%)
		Distance: <10,000  |  Total: 10 (1.8%)  |  Exclusive: 8 (1.5%)
		Distance: <20,000  |  Total: 30 (5.5%)  |  Exclusive: 20 (3.6%)
		Distance: <30,000  |  Total: 44 (8.0%)  |  Exclusive: 14 (2.6%)
		Distance: <40,000  |  Total: 58 (10.6%)  |  Exclusive: 14 (2.6%)
		Distance: <50,000  |  Total: 68 (12.4%)  |  Exclusive: 10 (1.8%)
		Distance: <75,000  |  Total: 96 (17.5%)  |  Exclusive: 28 (5.1%)
		Distance: <100,000  |  Total: 120 (21.9%)  |  Exclusive: 24 (4.4%)
		Distance: <150,000  |  Total: 172 (31.3%)  |  Exclusive: 52 (9.5%)
		Distance: <200,000  |  Total: 224 (40.8%)  |  Exclusive: 52 (9.5%)
		Median: <244,205  |  Total: 274 (49.9%)  |  Exclusive: 50 (9.1%)
		Average: <265,080  |  Total: 294 (53.6%)  |  Exclusive: 20 (3.6%)
		Distance: <300,000  |  Total: 332 (60.5%)  |  Exclusive: 38 (6.9%)
		Distance: <400,000  |  Total: 411 (74.9%)  |  Exclusive: 79 (14.4%)
		Distance: <500,000  |  Total: 484 (88.2%)  |  Exclusive: 73 (13.3%)
		Distance: <750,000  |  Total: 548 (99.8%)  |  Exclusive: 64 (11.7%)
		Distance: <1,000,000  |  Total: 549 (100.0%)  |  Exclusive: 1 (0.2%)
		Distance: <1,500,000  |  Total: 549 (100.0%)  |  Exclusive: 0 (0.0%)
		Distance: <2,000,000  |  Total: 549 (100.0%)  |  Exclusive: 0 (0.0%)

	Faction - wh2_dlc11_vmp_the_barrow_legion
		Average Distance: <196,953
		Median Distance: <137,461
		Distance: <2,500  |  Total: 9 (1.6%)  |  Exclusive: 9 (1.6%)
		Distance: <5,000  |  Total: 16 (2.9%)  |  Exclusive: 7 (1.3%)
		Distance: <10,000  |  Total: 30 (5.5%)  |  Exclusive: 14 (2.6%)
		Distance: <20,000  |  Total: 50 (9.1%)  |  Exclusive: 20 (3.6%)
		Distance: <30,000  |  Total: 74 (13.5%)  |  Exclusive: 24 (4.4%)
		Distance: <40,000  |  Total: 96 (17.5%)  |  Exclusive: 22 (4.0%)
		Distance: <50,000  |  Total: 117 (21.3%)  |  Exclusive: 21 (3.8%)
		Distance: <75,000  |  Total: 165 (30.1%)  |  Exclusive: 48 (8.7%)
		Distance: <100,000  |  Total: 212 (38.6%)  |  Exclusive: 47 (8.6%)
		Median: <137,461  |  Total: 274 (49.9%)  |  Exclusive: 62 (11.3%)
		Distance: <150,000  |  Total: 295 (53.7%)  |  Exclusive: 21 (3.8%)
		Average: <196,953  |  Total: 355 (64.7%)  |  Exclusive: 60 (10.9%)
		Distance: <200,000  |  Total: 360 (65.6%)  |  Exclusive: 5 (0.9%)
		Distance: <300,000  |  Total: 433 (78.9%)  |  Exclusive: 73 (13.3%)
		Distance: <400,000  |  Total: 479 (87.2%)  |  Exclusive: 46 (8.4%)
		Distance: <500,000  |  Total: 495 (90.2%)  |  Exclusive: 16 (2.9%)
		Distance: <750,000  |  Total: 537 (97.8%)  |  Exclusive: 42 (7.7%)
		Distance: <1,000,000  |  Total: 549 (100.0%)  |  Exclusive: 12 (2.2%)
		Distance: <1,500,000  |  Total: 549 (100.0%)  |  Exclusive: 0 (0.0%)
		Distance: <2,000,000  |  Total: 549 (100.0%)  |  Exclusive: 0 (0.0%)

	Faction - wh3_main_vmp_caravan_of_blue_roses
		Average Distance: <416,656
		Median Distance: <314,785
		Distance: <2,500  |  Total: 2 (0.4%)  |  Exclusive: 2 (0.4%)
		Distance: <5,000  |  Total: 5 (0.9%)  |  Exclusive: 3 (0.5%)
		Distance: <10,000  |  Total: 14 (2.6%)  |  Exclusive: 9 (1.6%)
		Distance: <20,000  |  Total: 23 (4.2%)  |  Exclusive: 9 (1.6%)
		Distance: <30,000  |  Total: 30 (5.5%)  |  Exclusive: 7 (1.3%)
		Distance: <40,000  |  Total: 41 (7.5%)  |  Exclusive: 11 (2.0%)
		Distance: <50,000  |  Total: 56 (10.2%)  |  Exclusive: 15 (2.7%)
		Distance: <75,000  |  Total: 81 (14.8%)  |  Exclusive: 25 (4.6%)
		Distance: <100,000  |  Total: 115 (20.9%)  |  Exclusive: 34 (6.2%)
		Distance: <150,000  |  Total: 160 (29.1%)  |  Exclusive: 45 (8.2%)
		Distance: <200,000  |  Total: 195 (35.5%)  |  Exclusive: 35 (6.4%)
		Distance: <300,000  |  Total: 265 (48.3%)  |  Exclusive: 70 (12.8%)
		Median: <314,785  |  Total: 274 (49.9%)  |  Exclusive: 9 (1.6%)
		Distance: <400,000  |  Total: 332 (60.5%)  |  Exclusive: 58 (10.6%)
		Average: <416,656  |  Total: 337 (61.4%)  |  Exclusive: 5 (0.9%)
		Distance: <500,000  |  Total: 364 (66.3%)  |  Exclusive: 27 (4.9%)
		Distance: <750,000  |  Total: 429 (78.1%)  |  Exclusive: 65 (11.8%)
		Distance: <1,000,000  |  Total: 507 (92.3%)  |  Exclusive: 78 (14.2%)
		Distance: <1,500,000  |  Total: 549 (100.0%)  |  Exclusive: 42 (7.7%)
		Distance: <2,000,000  |  Total: 549 (100.0%)  |  Exclusive: 0 (0.0%)

	Faction - wh_main_vmp_schwartzhafen
		Average Distance: <193,835
		Median Distance: <140,884
		Distance: <2,500  |  Total: 6 (1.1%)  |  Exclusive: 6 (1.1%)
		Distance: <5,000  |  Total: 15 (2.7%)  |  Exclusive: 9 (1.6%)
		Distance: <10,000  |  Total: 30 (5.5%)  |  Exclusive: 15 (2.7%)
		Distance: <20,000  |  Total: 54 (9.8%)  |  Exclusive: 24 (4.4%)
		Distance: <30,000  |  Total: 76 (13.8%)  |  Exclusive: 22 (4.0%)
		Distance: <40,000  |  Total: 103 (18.8%)  |  Exclusive: 27 (4.9%)
		Distance: <50,000  |  Total: 127 (23.1%)  |  Exclusive: 24 (4.4%)
		Distance: <75,000  |  Total: 181 (33.0%)  |  Exclusive: 54 (9.8%)
		Distance: <100,000  |  Total: 222 (40.4%)  |  Exclusive: 41 (7.5%)
		Median: <140,884  |  Total: 274 (49.9%)  |  Exclusive: 52 (9.5%)
		Distance: <150,000  |  Total: 284 (51.7%)  |  Exclusive: 10 (1.8%)
		Average: <193,835  |  Total: 318 (57.9%)  |  Exclusive: 34 (6.2%)
		Distance: <200,000  |  Total: 323 (58.8%)  |  Exclusive: 5 (0.9%)
		Distance: <300,000  |  Total: 397 (72.3%)  |  Exclusive: 74 (13.5%)
		Distance: <400,000  |  Total: 464 (84.5%)  |  Exclusive: 67 (12.2%)
		Distance: <500,000  |  Total: 528 (96.2%)  |  Exclusive: 64 (11.7%)
		Distance: <750,000  |  Total: 549 (100.0%)  |  Exclusive: 21 (3.8%)
		Distance: <1,000,000  |  Total: 549 (100.0%)  |  Exclusive: 0 (0.0%)
		Distance: <1,500,000  |  Total: 549 (100.0%)  |  Exclusive: 0 (0.0%)
		Distance: <2,000,000  |  Total: 549 (100.0%)  |  Exclusive: 0 (0.0%)

	Faction - wh3_dlc29_vmp_neferata
		Average Distance: <241,545
		Median Distance: <170,690
		Distance: <2,500  |  Total: 4 (0.7%)  |  Exclusive: 4 (0.7%)
		Distance: <5,000  |  Total: 8 (1.5%)  |  Exclusive: 4 (0.7%)
		Distance: <10,000  |  Total: 16 (2.9%)  |  Exclusive: 8 (1.5%)
		Distance: <20,000  |  Total: 39 (7.1%)  |  Exclusive: 23 (4.2%)
		Distance: <30,000  |  Total: 59 (10.7%)  |  Exclusive: 20 (3.6%)
		Distance: <40,000  |  Total: 82 (14.9%)  |  Exclusive: 23 (4.2%)
		Distance: <50,000  |  Total: 104 (18.9%)  |  Exclusive: 22 (4.0%)
		Distance: <75,000  |  Total: 153 (27.9%)  |  Exclusive: 49 (8.9%)
		Distance: <100,000  |  Total: 191 (34.8%)  |  Exclusive: 38 (6.9%)
		Distance: <150,000  |  Total: 258 (47.0%)  |  Exclusive: 67 (12.2%)
		Median: <170,690  |  Total: 274 (49.9%)  |  Exclusive: 16 (2.9%)
		Distance: <200,000  |  Total: 299 (54.5%)  |  Exclusive: 25 (4.6%)
		Average: <241,545  |  Total: 333 (60.7%)  |  Exclusive: 34 (6.2%)
		Distance: <300,000  |  Total: 366 (66.7%)  |  Exclusive: 33 (6.0%)
		Distance: <400,000  |  Total: 420 (76.5%)  |  Exclusive: 54 (9.8%)
		Distance: <500,000  |  Total: 456 (83.1%)  |  Exclusive: 36 (6.6%)
		Distance: <750,000  |  Total: 546 (99.5%)  |  Exclusive: 90 (16.4%)
		Distance: <1,000,000  |  Total: 549 (100.0%)  |  Exclusive: 3 (0.5%)
		Distance: <1,500,000  |  Total: 549 (100.0%)  |  Exclusive: 0 (0.0%)
		Distance: <2,000,000  |  Total: 549 (100.0%)  |  Exclusive: 0 (0.0%)
]]--