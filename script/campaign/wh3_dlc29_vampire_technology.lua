vampire_technology = {
	debug_output = false,
	locked_buildings = {
		{building = "wh_main_VAMPIRES_corpses_2", technology = "wh3_main_tech_vmp_necromancers_2", reason = "building_lock_vmp_necromancers_2"},
		{building = "wh_main_VAMPIRES_corpse_transport_1", technology = "wh3_main_tech_vmp_necromancers_3", reason = "building_lock_vmp_necromancers_3"},
		{building = "wh_main_VAMPIRES_shyish_capital_1", technology = "wh3_main_tech_vmp_necromancers_3", reason = "building_lock_vmp_necromancers_3"},
		{building = "wh_main_VAMPIRES_climate_1", technology = "wh3_main_tech_vmp_vampires_final_3", reason = "building_lock_vmp_climate"},
		{building = "wh_main_VAMPIRES_sylvanian_outpost_1", technology = "wh3_main_tech_vmp_vampires_final_4", reason = ""},
		{building = "wh3_dlc29_vmp_lair_secondary_followers_mount_1", technology = "wh3_main_tech_vmp_vampires_lair_5", reason = "building_lock_vmp_followers"},
		{building = "wh3_dlc29_vmp_lair_secondary_followers_necromancer_1", technology = "wh3_main_tech_vmp_vampires_lair_5", reason = "building_lock_vmp_followers"},
		{building = "wh3_dlc29_vmp_lair_secondary_followers_army_1", technology = "wh3_main_tech_vmp_vampires_lair_5", reason = "building_lock_vmp_followers"},
		{building = "wh3_dlc29_vmp_lair_secondary_items_ancillary_2", technology = "wh3_main_tech_vmp_vampires_lair_2", reason = "building_lock_vmp_items"},
		{building = "wh3_dlc29_vmp_lair_secondary_items_crypt_1", technology = "wh3_main_tech_vmp_vampires_lair_2", reason = "building_lock_vmp_items"},
		{building = "wh3_dlc29_vmp_lair_secondary_legacy_1", technology = "wh3_main_tech_vmp_vampires_lair_3", reason = "building_lock_vmp_legacy"},
		{building = "wh3_dlc29_vmp_lair_secondary_legacy_2", technology = "wh3_main_tech_vmp_vampires_lair_3", reason = "building_lock_vmp_legacy"},
		{building = "wh3_dlc29_vmp_lair_secondary_legacy_3", technology = "wh3_main_tech_vmp_vampires_lair_3", reason = "building_lock_vmp_legacy"},
		{building = "wh3_dlc29_vmp_lair_secondary_legacy_4", technology = "wh3_main_tech_vmp_vampires_lair_3", reason = "building_lock_vmp_legacy"},
		{building = "wh3_dlc29_vmp_lair_secondary_legacy_5", technology = "wh3_main_tech_vmp_vampires_lair_3", reason = "building_lock_vmp_legacy"},
		{building = "wh3_dlc29_vmp_lair_secondary_legacy_6", technology = "wh3_main_tech_vmp_vampires_lair_3", reason = "building_lock_vmp_legacy"}
	},
	locked_techs_vampires = {
		factions = {
			"wh2_dlc11_vmp_the_barrow_legion",
			"wh3_main_vmp_caravan_of_blue_roses"
		},
		techs = {
			{key = "wh3_main_tech_vmp_vampires_main_2", lairs = 1},
			{key = "wh3_main_tech_vmp_vampires_main_4", lairs = 2},
			{key = "wh3_main_tech_vmp_vampires_main_5", lairs = 3}
		}
	},
	locked_techs_necromancers = {
		factions = {
			"wh_main_vmp_vampire_counts",
			"wh_main_vmp_schwartzhafen",
			"wh3_dlc29_vmp_neferata"
		},
		techs = {
			{key = "wh3_main_tech_vmp_necromancers_1", corpses = 40000},
			{key = "wh3_main_tech_vmp_necromancers_2", corpses = 100000},
			{key = "wh3_main_tech_vmp_necromancers_3", corpses = 200000},
			{key = "wh3_main_tech_vmp_necromancers_4", corpses = 300000}
		}
	},
	faction_corpses_gained = {},
	locked_final_techs = {
		"wh3_main_tech_vmp_vampires_final_1",
		"wh3_main_tech_vmp_vampires_final_2",
		"wh3_main_tech_vmp_vampires_final_3",
		"wh3_main_tech_vmp_vampires_final_4",
		"wh3_main_tech_vmp_vampires_final_5"
	},
	unlock_final_techs = {
		"wh3_main_tech_vmp_vampires_unlock_1",
		"wh3_main_tech_vmp_vampires_unlock_2",
		"wh3_main_tech_vmp_vampires_unlock_3",
		"wh3_main_tech_vmp_vampires_unlock_4",
		"wh3_main_tech_vmp_vampires_unlock_5"
	},
	final_tech_unlock_count = {},
	faction_lairs_awakened = {},
	starting_vampire_techs = {
		{faction = "wh_main_vmp_vampire_counts", tech = "wh3_main_tech_vmp_vampires_main_1"},
		{faction = "wh_main_vmp_vampire_counts", tech = "wh3_main_tech_vmp_vampires_main_2"},
		{faction = "wh_main_vmp_schwartzhafen", tech = "wh3_main_tech_vmp_vampires_main_1"},
		{faction = "wh_main_vmp_schwartzhafen", tech = "wh3_main_tech_vmp_vampires_main_2"},
		{faction = "wh3_dlc29_vmp_neferata", tech = "wh3_main_tech_vmp_vampires_main_1"},
		{faction = "wh3_dlc29_vmp_neferata", tech = "wh3_main_tech_vmp_vampires_main_2"},
		{faction = "wh2_dlc11_vmp_the_barrow_legion", tech = "wh3_main_tech_vmp_vampires_main_1"},
		{faction = "wh3_main_vmp_caravan_of_blue_roses", tech = "wh3_main_tech_vmp_vampires_main_1"},
	},
	starting_necromancer_techs = {
		{faction = "wh2_dlc11_vmp_the_barrow_legion", tech = "wh3_main_tech_vmp_necromancers_0"},
		{faction = "wh2_dlc11_vmp_the_barrow_legion", tech = "wh3_main_tech_vmp_necromancers_1"},
		{faction = "wh3_main_vmp_caravan_of_blue_roses", tech = "wh3_main_tech_vmp_necromancers_0"},
		{faction = "wh3_main_vmp_caravan_of_blue_roses", tech = "wh3_main_tech_vmp_necromancers_1"},
		{faction = "wh_main_vmp_vampire_counts", tech = "wh3_main_tech_vmp_necromancers_0"},
		{faction = "wh_main_vmp_schwartzhafen", tech = "wh3_main_tech_vmp_necromancers_0"},
		{faction = "wh3_dlc29_vmp_neferata", tech = "wh3_main_tech_vmp_necromancers_0"}
	},
	unique_agents = {
		["wh3_main_tech_vmp_vampires_walach_harkon_1"] = {key = "wh3_dlc29_vmp_walach_harkon", items = {"wh3_dlc29_anc_enchanted_item_blood_dragon_standard", "wh3_dlc29_anc_weapon_crimson_blade"}},
		["wh3_main_tech_vmp_necromancers_dieter_helnisnicht_1"] = {key = "wh3_dlc29_vmp_dieter_helsnicht", items = {"wh3_dlc29_anc_arcane_item_staff_of_flaming_death"}},
		["wh3_dlc29_tech_nef_ulrika"] = {key = "wh3_dlc23_neu_ulrika", items = {"wh3_dlc23_anc_arcane_item_blood_shard", "wh3_dlc23_anc_weapon_item_silver_dagger", "wh3_dlc23_anc_follower_neu_gabriella"}}
	},
	discover_and_occupy_lairs = {
		["wh3_main_tech_vmp_vampires_lair_3"] = true,
		["wh3_main_tech_vmp_vampires_lair_5"] = true
	},
	nagash_mortarchs = {
		["wh3_dlc29_nag_mortarchs_dieter"] = "wh3_main_tech_vmp_necromancers_dieter_helnisnicht_1",
		["wh3_dlc29_nag_mortarchs_walach"] = "wh3_main_tech_vmp_vampires_walach_harkon_1"
	},
	ancillaries_from_techs = {
		{tech = "wh3_main_tech_vmp_vampires_final_2", ancillary = "wh_main_anc_follower_undead_possessed_mirror", count = 2},
		{tech = "wh3_main_tech_vmp_vampires_final_2", ancillary = "wh_main_anc_follower_undead_black_cat", count = 1},
		{tech = "wh3_main_tech_vmp_vampires_final_2", ancillary = "wh_main_anc_follower_undead_poltergeist", count = 1},
		{tech = "wh3_main_tech_vmp_vampires_final_2", ancillary = "wh_main_anc_follower_undead_carrion", count = 1},
		{tech = "wh3_main_tech_vmp_vampires_final_2", ancillary = "wh_main_anc_follower_undead_crone", count = 1},
		{tech = "wh3_main_tech_vmp_necromancers_misc_2", ancillary = "wh_main_anc_follower_undead_corpse_thief", count = 1},
		{tech = "wh3_main_tech_vmp_necromancers_misc_1", ancillary = "wh_main_anc_follower_undead_grave_digger", count = 1},
		{tech = "wh3_main_tech_vmp_necromancers_final_1", ancillary = "wh_main_anc_follower_undead_warlock", count = 1},
		{tech = "wh3_main_tech_vmp_necromancers_misc_3", ancillary = "wh_main_anc_follower_undead_treasurer", count = 1},
		{tech = "wh3_main_tech_vmp_necromancers_misc_8", ancillary = "wh_main_anc_follower_undead_flesh_golem", count = 1},
		{tech = "wh3_main_tech_vmp_vampires_main_2_a", ancillary = "wh_main_anc_follower_undead_dreg", count = 1},
		{tech = "wh3_main_tech_vmp_vampires_magic_1", ancillary = "wh_main_anc_follower_undead_manservant", count = 1},
		{tech = "wh3_main_tech_vmp_vampires_main_5_b", ancillary = "wh_main_anc_follower_undead_mortal_informer", count = 1},
		{tech = "wh3_main_tech_vmp_vampires_magic_2", ancillary = "wh_main_anc_follower_undead_spy", count = 1},
		{tech = "wh3_main_tech_vmp_vampires_lair_4", ancillary = "wh_main_anc_follower_undead_warp_stone_hunter", count = 1},
		{tech = "wh3_main_tech_vmp_necromancers_final_5", ancillary = "wh_main_anc_follower_undead_sailor", count = 1},
		{tech = "wh3_main_tech_vmp_necromancers_4", ancillary = "wh_main_anc_follower_undead_blood_mule", count = 1},
	},
	follower_rewards = {
		{tech = "wh3_main_tech_vmp_vampires_final_2", follower = "wh_main_anc_follower_undead_black_cat", weight = 2},
		{tech = "wh3_main_tech_vmp_vampires_final_2", follower = "wh_main_anc_follower_undead_crone", weight = 2},
		{tech = "wh3_main_tech_vmp_necromancers_misc_3", follower = "wh_main_anc_follower_undead_treasurer", weight = 2},
		{tech = "wh3_main_tech_vmp_necromancers_final_1", follower = "wh_main_anc_follower_undead_warlock", weight = 2},
		{tech = "wh3_main_tech_vmp_vampires_final_2", follower = "wh_main_anc_follower_undead_carrion", weight = 4},
		{tech = "wh3_main_tech_vmp_necromancers_misc_2", follower = "wh_main_anc_follower_undead_corpse_thief", weight = 4},
		{tech = "wh3_main_tech_vmp_necromancers_misc_1", follower = "wh_main_anc_follower_undead_grave_digger", weight = 4},
		{tech = "wh3_main_tech_vmp_vampires_main_5_b", follower = "wh_main_anc_follower_undead_mortal_informer", weight = 4},
		{tech = "wh3_main_tech_vmp_vampires_final_2", follower = "wh_main_anc_follower_undead_poltergeist", weight = 4},
		{tech = "wh3_main_tech_vmp_vampires_magic_2", follower = "wh_main_anc_follower_undead_spy", weight = 4},
		{tech = "wh3_main_tech_vmp_necromancers_misc_8", follower = "wh_main_anc_follower_undead_flesh_golem", weight = 4},
		{tech = "wh3_main_tech_vmp_vampires_lair_4", follower = "wh_main_anc_follower_undead_warp_stone_hunter", weight = 4},
		{tech = "wh3_main_tech_vmp_vampires_magic_1", follower = "wh_main_anc_follower_undead_manservant", weight = 6},
		{tech = "wh3_main_tech_vmp_vampires_main_2_a", follower = "wh_main_anc_follower_undead_dreg", weight = 6},
		{tech = "wh3_main_tech_vmp_necromancers_final_5", follower = "wh_main_anc_follower_undead_sailor", weight = 1},
		{tech = "wh3_main_tech_vmp_necromancers_4", follower = "wh_main_anc_follower_undead_blood_mule", weight = 2},
	},
	ghoul_king_unlocks = {
		["wh3_main_tech_vmp_necromancers_misc_6"] = true,
		["wh3_main_tech_vmp_necromancers_misc_11"] = true,
		["wh3_main_tech_vmp_vampires_main_4_b"] = true
	},
	feature_unlocks = {
		confederate_red_duke = "wh3_main_tech_vmp_vampires_red_duke_1",
		unlock_province_actions = "wh3_main_tech_vmp_vampires_final_1",
		unlock_rush_construction = "wh3_main_tech_vmp_vampires_final_5",
		corpses_on_lair_discovery = {tech_key = "wh3_main_tech_vmp_vampires_lair_2", bonus_value = "corpse_gained_from_lair_discovery"},
		corpses_on_war = {tech_key = "wh3_main_tech_vmp_necromancers_misc_11", bonus_value = "corpse_gained_from_war"},
		replenish_ap_ritual = "wh3_main_ritual_vmp_power_corruption"
	},
	free_bloodline_unlocks = {},
	any_human_vampires = false
};

function vampire_technology:initialise()
	self:add_listeners();

	if cm:is_new_game() == true then
		local vampire_factions = cm:get_factions_by_subculture("wh_main_sc_vmp_vampire_counts");

		for _, faction in ipairs(vampire_factions) do
			local faction_key = faction:name();
			-- Disable rush construction feature
			cm:apply_effect_bundle("wh3_main_bundle_vmp_disable_instant_construction", faction_key, 0);

			-- Lock all technology locked buildings
			for _, tech_lock in ipairs(self.locked_buildings) do
				cm:add_event_restricted_building_record_for_faction(tech_lock.building, faction_key, tech_lock.reason);
			end

			-- Lock the final Vampire techs
			for _, tech_to_lock in ipairs(self.locked_final_techs) do
				cm:lock_one_technology_node(faction_key, tech_to_lock);
			end

			-- Lock secret library
			cm:add_event_restricted_building_record_for_faction("wh3_main_special_vmp_hidden_library_1", faction_key, "");
			cm:add_event_restricted_building_record_for_faction("wh3_main_special_vmp_hidden_library_2", faction_key, "");
			
			if faction:is_human() == true then
				self.any_human_vampires = true;
			else
				cm:lock_one_technology_node(faction_key, "wh3_main_tech_vmp_vampires_walach_harkon_1");
				cm:lock_one_technology_node(faction_key, "wh3_main_tech_vmp_necromancers_dieter_helnisnicht_1");
				cm:lock_one_technology_node(faction_key, self.feature_unlocks.confederate_red_duke);

				if faction_key == "wh3_dlc29_vmp_neferata" then
					cm:lock_one_technology_node(faction_key, "wh3_dlc29_tech_nef_ulrika");
				end
			end
		end

		-- Lock initial Vampire techs
		for _, faction_key in ipairs(self.locked_techs_vampires.factions) do
			for _, tech_to_lock in ipairs(self.locked_techs_vampires.techs) do
				cm:lock_one_technology_node(faction_key, tech_to_lock.key);
				cm:update_technology_unlock_progress_values(faction_key, tech_to_lock.key, {0});
			end
		end

		-- Lock initial Necromancer techs
		for _, faction_key in ipairs(self.locked_techs_necromancers.factions) do
			local faction = cm:get_faction(faction_key);

			if faction then
				local total_corpses = self:get_total_corpses(faction);

				for _, tech_to_lock in ipairs(self.locked_techs_necromancers.techs) do
					if total_corpses >= tech_to_lock.corpses then
						script_error("Vampire Technology: Faction already meets technology Corpse requirement?!")
					end
					cm:lock_one_technology_node(faction_key, tech_to_lock.key);
					cm:update_technology_unlock_progress_values(faction_key, tech_to_lock.key, {tech_to_lock.corpses, total_corpses});
				end
			end
		end
		
		-- Give initial Vampire techs
		for _, starting_tech in ipairs(self.starting_vampire_techs) do
			cm:instantly_research_technology(starting_tech.faction, starting_tech.tech, false);
		end

		-- Give initial Necromancer techs
		for _, starting_tech in ipairs(self.starting_necromancer_techs) do
			cm:instantly_research_technology(starting_tech.faction, starting_tech.tech, false);
		end
	end
end

function vampire_technology:add_listeners()
	core:add_listener(
		"ScriptEventVampireLairAwakenedEvent",
		"ScriptEventVampireLairAwakened",
		true,
		function(context)
			local faction = context:faction();
			local faction_key = faction:name();

			for _, possible_faction_key in ipairs(self.locked_techs_vampires.factions) do
				if possible_faction_key == faction_key then
					self.faction_lairs_awakened[faction_key] = self.faction_lairs_awakened[faction_key] or 0;
					self.faction_lairs_awakened[faction_key] = self.faction_lairs_awakened[faction_key] + 1;

					for _, tech_to_unlock in ipairs(self.locked_techs_vampires.techs) do
						cm:update_technology_unlock_progress_values(faction_key, tech_to_unlock.key, {self.faction_lairs_awakened[faction_key]});

						if self.faction_lairs_awakened[faction_key] >= tech_to_unlock.lairs then
							cm:unlock_technology(faction_key, tech_to_unlock.key);
						end
					end
					break;
				end
			end
		end,
		true
	);
	core:add_listener(
		"ScriptEventVampireLairDiscoveredEvent",
		"ScriptEventVampireLairDiscovered",
		true,
		function(context)
			local faction = context:faction();
			local region = context:region();

			if faction:has_technology(self.feature_unlocks.corpses_on_lair_discovery.tech_key) == true then
				local province = region:province();
				local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, province);
				local corpse_resource = pooled_resource_manager:resource("wh3_dlc29_vmp_corpses");
				local amount = cm:get_factions_bonus_value(faction, self.feature_unlocks.corpses_on_lair_discovery.bonus_value) or 0;
				cm:pooled_resource_factor_transaction(corpse_resource, "vampire_lairs", amount);
			end
		end,
		true
	);
	core:add_listener(
		"ResearchCompletedVampires",
		"ResearchCompleted",
		function(context)
			return context:faction():subculture() == "wh_main_sc_vmp_vampire_counts";
		end,
		function(context)
			local faction = context:faction();
			local faction_key = faction:name();
			local tech_key = context:technology();

			-- Enable instant construction
			if tech_key == self.feature_unlocks.unlock_rush_construction then
				cm:remove_effect_bundle("wh3_main_bundle_vmp_disable_instant_construction", faction_key);
			end

			-- Unlock provincial actions
			if tech_key == self.feature_unlocks.unlock_province_actions then
				cm:unlock_ritual(faction, "wh3_main_ritual_vmp_power_defend");
				cm:unlock_ritual(faction, "wh3_main_ritual_vmp_power_corpses");
				cm:unlock_ritual(faction, "wh3_main_ritual_vmp_power_corruption");
			end

			-- Spawn Legendary hero
			if faction:is_human() == true or self.any_human_vampires == false then
				local unique_agent = self.unique_agents[tech_key];

				if unique_agent then
					self:spawn_unique_character(faction, unique_agent);

					-- Lock this tech for others
					local vampire_factions = cm:get_factions_by_subculture("wh_main_sc_vmp_vampire_counts");

					for _, vamp_faction in ipairs(vampire_factions) do
						local other_faction_key = vamp_faction:name();

						if other_faction_key ~= faction_key then
							out("\tLocking tech "..tech_key.." for "..other_faction_key);
							cm:lock_one_technology_node(other_faction_key, tech_key);
						end
					end

					-- If this was Ulrika we need to notify the legendary_characters script so it can deal with everything else
					if tech_key == "wh3_dlc29_tech_nef_ulrika" then
						character_unlocking:cancel_missions_for_other_players(faction_key, "ulrika", "ulrikaMissionSuccess");
					end
				end
			end

			-- Confederate Red Duke
			if faction:is_human() == true and tech_key == self.feature_unlocks.confederate_red_duke then
				self:confederate_red_duke(faction);

				-- Lock the confederation tech for everyone else
				local vampire_factions = cm:get_factions_by_subculture("wh_main_sc_vmp_vampire_counts");

				for _, other_faction in ipairs(vampire_factions) do
					local other_faction_key = other_faction:name();

					if other_faction_key ~= faction_key then
						out("\tLocking tech "..tech_key.." for "..other_faction_key);
						cm:lock_one_technology_node(other_faction_key, tech_key);
					end
				end
			end

			-- Check for buildings to unlock
			for _, tech_lock in ipairs(self.locked_buildings) do
				if tech_lock.technology == tech_key then
					cm:remove_event_restricted_building_record_for_faction(tech_lock.building, faction_key);
				end
			end

			-- Track the number of unlocks the faction has and unlock the final techs now one can be started
			if faction:is_human() == true then
				for _, unlock_tech in ipairs(self.unlock_final_techs) do
					if unlock_tech == tech_key then
						self.final_tech_unlock_count[faction_key] = self.final_tech_unlock_count[faction_key] or 0;
						self.final_tech_unlock_count[faction_key] = self.final_tech_unlock_count[faction_key] + 1;

						for _, tech_to_lock in ipairs(self.locked_final_techs) do
							cm:unlock_technology(faction_key, tech_to_lock);
						end
						
						-- This tech also gives free Bloodline unlock
						self.free_bloodline_unlocks[faction_key] = self.free_bloodline_unlocks[faction_key] or 0;
						self.free_bloodline_unlocks[faction_key] = self.free_bloodline_unlocks[faction_key] + 1;
						cm:apply_effect_bundle("wh3_main_bundle_vmp_free_bloodline", faction_key, 0);
						break;
					end
				end
			end

			-- Check if we should re-lock Vampire category final techs
			for _, tech_that_locks in ipairs(self.locked_final_techs) do
				if tech_key == tech_that_locks then
					-- This was a tech that locks other techs, so lock all un-researched techs of this type if they have run out of unlocks
					local relock = true;

					if self.final_tech_unlock_count[faction_key] and self.final_tech_unlock_count[faction_key] > 0 then
						self.final_tech_unlock_count[faction_key] = self.final_tech_unlock_count[faction_key] - 1;

						if self.final_tech_unlock_count[faction_key] > 0 then
							relock = false; -- Player still has unlocks, so no need to relock the techs
						end
					end

					if relock == true then
						for _, tech_to_lock in ipairs(self.locked_final_techs) do
							if faction:has_technology(tech_to_lock) == false then
								cm:lock_one_technology_node(faction_key, tech_to_lock);
							end
						end
					end
					break;
				end
			end

			-- Discover & Occupy Lairs
			if self.discover_and_occupy_lairs[tech_key] then
				local lair = vampire_lairs:discover_random_lair(faction, false);
				vampire_lairs:occupy_lair(lair, faction);
			end

			-- Free Ghoul King
			if self.ghoul_king_unlocks[tech_key] then
				local character_details = cm:spawn_character_to_pool(faction_key, "", "", "", "", 10, true, "general", "wh_dlc04_vmp_strigoi_ghoul_king", false, "", true);
				local background_skill = "wh_main_skill_innate_vmp_ghoul_whisperer";
				--background_skill = innate_trait_reset:get_new_background_skill("wh_dlc04_vmp_strigoi_ghoul_king", background_skill);
				out("GHOUL KING - "..background_skill)
				cm:character_details_pick_background_skill(character_details, background_skill, false);
				cm:character_details_add_skill_point(character_details, background_skill);
			end

			-- Techs that give ancillaries
			for _, possible_item in ipairs(self.ancillaries_from_techs) do
				if tech_key == possible_item.tech then
					for i = 1, possible_item.count do
						local suppress_event = i > 1;
						cm:add_ancillary_to_faction(faction, possible_item.ancillary, suppress_event);
					end
				end
			end
		end,
		true
	);
	core:add_listener(
		"FactionTurnEndCorpses",
		"FactionTurnEnd",
		true,
		function(context)
			local faction = context:faction();
			self:update_technology_locks(faction);
		end,
		true
	);
	core:add_listener(
		"RitualCompletedEventVampires",
		"RitualCompletedEvent",
		true,
		function(context)
			local ritual = context:ritual();
			local ritual_key = ritual:ritual_key();
			local ritual_category = ritual:ritual_category();
			local faction_key = context:performing_faction():name();

			if self.nagash_mortarchs[ritual_key] then
				local vampire_factions = cm:get_factions_by_subculture("wh_main_sc_vmp_vampire_counts");

				for _, vamp_faction in ipairs(vampire_factions) do
					local vamp_faction_key = vamp_faction:name();
					cm:lock_one_technology_node(vamp_faction_key, self.nagash_mortarchs[ritual_key]);
				end
			end

			if ritual_category == "BLOODLINE_RITUAL" then
				self.free_bloodline_unlocks[faction_key] = self.free_bloodline_unlocks[faction_key] or 1;
				self.free_bloodline_unlocks[faction_key] = self.free_bloodline_unlocks[faction_key] - 1;

				if self.free_bloodline_unlocks[faction_key] < 1 then
					cm:remove_effect_bundle("wh3_main_bundle_vmp_free_bloodline", faction_key);
				end
			end

			if ritual_key == self.feature_unlocks.replenish_ap_ritual then
				local region = context:ritual_target_region();
				local region_list = region:province():regions();

				for i = 0, region_list:num_items() - 1 do
					local region = region_list:item_at(i);
					local region_characters = region:characters_in_region();

					for j = 0, region_characters:num_items() - 1 do
						local character = region_characters:item_at(j);

						if character:has_military_force() == true and character:faction():name() == faction_key then
							cm:replenish_action_points(cm:char_lookup_str(character), 0.5);
						end
					end
				end
			end
		end,
		true
	);
	core:add_listener(
		"PooledResourceChangedCorpses",
		"PooledResourceChanged",
		function(context)
			return context:resource():key() == "wh3_dlc29_vmp_corpses" and context:factor():key() == "battles";
		end,
		function(context)
			local faction = context:faction();
			local faction_key = faction:name();
			local amount = context:amount();
			if self.debug_output then
				out("Corpses change for "..faction_key..", they gained "..amount);
			end
			self.faction_corpses_gained[faction_key] = self.faction_corpses_gained[faction_key] or 0;
			self.faction_corpses_gained[faction_key] = self.faction_corpses_gained[faction_key] + amount;
			self:update_technology_locks(faction);
		end,
		true
	);
	core:add_listener(
		"NegativeDiplomaticEventVmp",
		"NegativeDiplomaticEvent",
		function(context)
			return context:is_war() == true;
		end,
		function(context)
			local proposer = context:proposer();
			local recipient = context:recipient();

			if recipient:subculture() == "wh_main_sc_vmp_vampire_counts" and recipient:has_technology(self.feature_unlocks.corpses_on_war.tech_key) == true then
				-- Go through all proposers provinces and add Corpses
				local faction_provinces = proposer:provinces();

				for _, faction_province in model_pairs(faction_provinces) do
					local province = faction_province:province();
					local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(recipient, province);

					if pooled_resource_manager:is_null_interface() == false then
						local pooled_resource = pooled_resource_manager:resource("wh3_dlc29_vmp_corpses");

						if pooled_resource:is_null_interface() == false then
							local amount = cm:get_factions_bonus_value(recipient, self.feature_unlocks.corpses_on_war.bonus_value) or 0;
							cm:pooled_resource_factor_transaction(pooled_resource, "technology", amount);
						end
					end
				end
			end
		end,
		true
	);
	core:add_listener(
		"CharacterRankUpVmp",
		"CharacterRankUp",
		function(context)
			return context:character():has_ancillary("wh_main_anc_follower_undead_possessed_mirror");
		end,
		function(context)
			local character = context:character();
			local character_cqi = character:command_queue_index();

			if self.mirrors_awaiting_xp == nil then
				local found_another_mirror = false;
				self.mirrors_awaiting_xp = {};
				local faction = character:faction();
				local character_list = faction:character_list();
		
				for i = 0, character_list:num_items() - 1 do
					local other_character = character_list:item_at(i);
					local other_character_cqi = other_character:command_queue_index();
					
					if character_cqi ~= other_character_cqi then
						if other_character:has_ancillary("wh_main_anc_follower_undead_possessed_mirror") == true and other_character:has_region() then
							self.mirrors_awaiting_xp[other_character_cqi] = true;
							found_another_mirror = true;
						end
					end
				end

				if found_another_mirror == true then
					for char_cqi, _ in dpairs(self.mirrors_awaiting_xp) do
						cm:callback(
							function()
								cm:add_agent_experience(cm:char_lookup_str(char_cqi), 1, true);
							end,
							0.2
						);
					end
				else
					self.mirrors_awaiting_xp = nil;
				end
			else
				self.mirrors_awaiting_xp[character_cqi] = nil
				local number_still_waiting = 0

				for k, v in dpairs(self.mirrors_awaiting_xp) do
					number_still_waiting = number_still_waiting + 1
				end
				
				if number_still_waiting == 0 then
					self.mirrors_awaiting_xp = nil;
				end
			end			
		end,
		true
	);
	core:add_listener(
		"CharacterConvalescedOrKilledVmp",
		"CharacterConvalescedOrKilled",
		function(context)
			local character = context:character();
			return character:has_ancillary("wh_main_anc_follower_undead_possessed_mirror") or character:has_ancillary("wh_main_anc_follower_undead_black_cat");
		end,
		function(context)
			local character = context:character();
			local character_cqi = character:command_queue_index();
			local family_cqi = character:character_details():family_member():command_queue_index();

			if character:has_ancillary("wh_main_anc_follower_undead_black_cat") then
				cm:callback(
					function()
						local character_cqi = cm:get_character_by_fm_cqi(family_cqi):command_queue_index();
						cm:stop_character_convalescing(character_cqi);
					end,
					0.2
				);
				if self.mirrors_awaiting_death then
					self.mirrors_awaiting_death[character_cqi] = nil;
				end
				return false;
			end

			if self.mirrors_awaiting_death == nil then
				local found_another_mirror = false;
				self.mirrors_awaiting_death = {};
				local faction = character:faction();
				local character_list = faction:character_list();
		
				for i = 0, character_list:num_items() - 1 do
					local other_character = character_list:item_at(i);
					local other_character_cqi = other_character:command_queue_index();
					
					if character_cqi ~= other_character_cqi then
						if other_character:has_ancillary("wh_main_anc_follower_undead_possessed_mirror") == true and other_character:has_region() then
							self.mirrors_awaiting_death[other_character_cqi] = true;
							found_another_mirror = true;
						end
					end
				end

				if found_another_mirror == true then
					for char_cqi, _ in dpairs(self.mirrors_awaiting_death) do
						cm:callback(
							function()
								cm:kill_character(char_cqi, false);
							end,
							0.2
						);
					end
				else
					self.mirrors_awaiting_death = nil;
				end
			else
				if self.mirrors_awaiting_death then
					self.mirrors_awaiting_death[character_cqi] = nil;
				end
				local number_still_waiting = 0

				for k, v in dpairs(self.mirrors_awaiting_death) do
					number_still_waiting = number_still_waiting + 1
				end
				
				if number_still_waiting == 0 then
					self.mirrors_awaiting_death = nil;
				end
			end
		end,
		true
	);
	core:add_listener(
		"CharacterTurnStartVmpLibrary",
		"CharacterTurnStart",
		function(context)
			local character = context:character();
			if character:has_ancillary("wh_main_anc_follower_undead_librarian") == false then
				return false;
			end
			if character:has_region() == false or character:region():name() ~= "wh3_main_combi_region_mordheim" then
				return false;
			end
			if character:region():owning_faction():is_faction(character:faction()) == false then
				return false;
			end
			return true;
		end,
		function(context)
			local character = context:character();
			local faction =  character:faction();
			local faction_key = faction:name();
			cm:remove_event_restricted_building_record_for_faction("wh3_main_special_vmp_hidden_library_1", faction_key);
			cm:remove_event_restricted_building_record_for_faction("wh3_main_special_vmp_hidden_library_2", faction_key);
			cm:force_remove_ancillary(character, "wh_main_anc_follower_undead_librarian", false, true);
			cm:force_add_ancillary(character, "wh_main_anc_follower_undead_librarian_upgraded", true, true);
			cm:trigger_incident(faction_key, "wh3_main_incident_vmp_secret_library_1", true, true);
		end,
		true
	);
	core:add_listener(
		"CharacterTurnEndVmpLibrary",
		"CharacterTurnEnd",
		function(context)
			local character = context:character();
			return character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_1") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_2") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_3") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_4") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_5") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_6") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_7") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_8") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_9") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_10") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_11");
		end,
		function(context)
			local character = context:character();

			if character:has_region() == true then
				local region = character:region();
				cm:apply_effect_bundle_to_region("wh3_main_bundle_region_vampiric_climate", region:name(), 0);
				climate_change:add_climate_override(region, "vampire_corpses");
			end
		end,
		true
	);
	core:add_listener(
		"BuildingCompletedVmpLibrary",
		"BuildingCompleted",
		function(context)
			return context:building():name() == "wh3_main_special_vmp_hidden_library_2";
		end,
		function(context)
			local building = context:building();
			local slot = building:slot();
			local faction_key = building:faction():name();
			cm:add_event_restricted_building_record_for_faction("wh3_main_special_vmp_hidden_library_1", faction_key, "");
			cm:add_event_restricted_building_record_for_faction("wh3_main_special_vmp_hidden_library_2", faction_key, "");
			cm:trigger_incident(faction_key, "wh3_main_incident_vmp_secret_library_2", true, true);

			cm:callback(function()
				cm:instantly_dismantle_building_in_region(slot);
			end, 0.2);
		end,
		true
	);
	core:add_listener(
		"CharacterRankUpVmpLibrary",
		"CharacterRankUp", 
		function(context)
			if cm:model():random_percent(10) == false then
				return false;
			end
			local character = context:character();
			local faction = character:faction();
			return faction:ancillary_exists("wh3_main_anc_arcane_item_necromantic_tome") == false and
			faction:ancillary_exists("wh3_main_anc_arcane_item_grimoire_necronium_11") == false and
			(character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_1") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_2") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_3") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_4") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_5") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_6") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_7") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_8") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_9") or
			character:has_ancillary("wh3_main_anc_arcane_item_grimoire_necronium_10"));
		end,
		function(context)
			local character = context:character();
			local faction = character:faction();
			cm:add_ancillary_to_faction(faction, "wh3_main_anc_arcane_item_necromantic_tome", false);
			local character_list = faction:character_list();
		end,
		true
	);
	core:add_listener(
		"CharacterRankUpVmpFollower",
		"CharacterRankUp", 
		function(context)
			local character = context:character();
			return character:faction():subculture() == "wh_main_sc_vmp_vampire_counts";
		end,
		function(context)
			local character = context:character();
			self:vampire_follower_chance(character, false);
		end,
		true
	);
	core:add_listener(
		"CharacterCompletedBattleVmpFollower",
		"CharacterCompletedBattle", 
		function(context)
			local character = context:character();
			return character:won_battle() == true and character:faction():subculture() == "wh_main_sc_vmp_vampire_counts";
		end,
		function(context)
			local character = context:character();
			self:vampire_follower_chance(character, true);
		end,
		true
	);
	core:add_listener(
		"RegionFactionChangeEventVmpClimate",
		"RegionFactionChangeEvent",
		true,
		function(context)
			local region = context:region();

			if region:owning_faction():subculture() == "wh_main_sc_vmp_vampire_counts" and region:settlement():get_climate() == "climate_vampiric" then
				cm:apply_effect_bundle_to_region("wh3_main_bundle_region_vampiric_climate", region:name(), 0);
				climate_change:add_climate_override(region, "vampire_corpses");
			end
		end,
		true
	);
	core:add_listener(
		"UniqueAgentSpawnedNefUlrika",
		"UniqueAgentSpawned",
		function(context)
			return context:unique_agent_details():agent_subtype_key() == "wh3_dlc23_neu_ulrika" and context:unique_agent_details():faction():name() ~= "wh3_dlc29_vmp_neferata";
		end,
		function(context)
			cm:lock_one_technology_node("wh3_dlc29_vmp_neferata", "wh3_dlc29_tech_nef_ulrika");
		end,
		true
	);
end

function vampire_technology:spawn_unique_character(faction, unique_agent)
	core:add_listener(
		"VampireUniqueAgentSpawned",
		"UniqueAgentSpawned",
		function(context)
			return context:unique_agent_details():agent_subtype_key() == unique_agent.key;
		end,
		function(context)
			local agent = context:unique_agent_details():character();
			local char_lookup = cm:char_lookup_str(agent);

			cm:replenish_action_points(char_lookup);

			if agent:is_null_interface() == false then
				for i = 1, #unique_agent.items do
					cm:force_add_ancillary(agent, unique_agent.items[i], true, true);
				end
			end
		end,
		false
	);

	out("Spawning unique agent for "..faction:name().." : "..unique_agent.key);
	cm:spawn_unique_agent(faction:command_queue_index(), unique_agent.key, true);
end

function vampire_technology:vampire_follower_chance(character, was_battle)
	local faction = character:faction();
	local base_chance = 0;
	local chance = 0;
	local followers = weighted_list:new();

	if was_battle == true then
		base_chance = 2;
	end

	for _, possible_follower in ipairs(self.follower_rewards) do
		if faction:has_technology(possible_follower.tech) == true then
			local number_of_item_owned = faction:num_ancillaries_owned(possible_follower.follower);
			local number_of_item_equipped = number_of_item_equipped_in_faction(faction, possible_follower.follower);
			local number_of_item_unused = number_of_item_owned - number_of_item_equipped;

			if number_of_item_unused < 2 then
				local weight = possible_follower.weight or 1;
				followers:add_item(possible_follower.follower, weight);
				chance = chance + 1;
			end
		end
	end

	if chance > 0 and cm:model():random_percent(base_chance + chance) == true then
		local follower_key, index = followers:weighted_select();
		cm:force_add_ancillary(character, follower_key, false, false);
	end
end

function vampire_technology:update_technology_locks(faction)
	local faction_key = faction:name();
	
	for _, possible_faction_key in ipairs(self.locked_techs_necromancers.factions) do
		if possible_faction_key == faction_key then
			local total_corpses = self:get_total_corpses(faction);

			for _, tech_to_unlock in ipairs(self.locked_techs_necromancers.techs) do
				cm:update_technology_unlock_progress_values(faction_key, tech_to_unlock.key, {tech_to_unlock.corpses, total_corpses});
				
				if total_corpses >= tech_to_unlock.corpses then
					cm:unlock_technology(faction_key, tech_to_unlock.key);
				end
			end
			break;
		end
	end
end

function vampire_technology:confederate_red_duke(faction)
	local confederating_faction_key = faction:name();
	local red_duke = cm:model():world():faction_by_key("wh_main_vmp_mousillon");

	if red_duke:is_null_interface() == false and red_duke:was_confederated() == false then
		cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
		cm:perform_ritual(confederating_faction_key, "", "wh3_dlc29_vmp_ritual_confederate_lord_red_duke");
		cm:force_confederation("wh3_main_vmp_remnants", "wh_main_vmp_mousillon");
			
		cm:callback(function()
			cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
		end, 0.2);
	end
end

function vampire_technology:get_total_corpses(faction)
	local faction_key = faction:name();
	local total_corpses = self.faction_corpses_gained[faction_key] or 0;
	return total_corpses;
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("vampire_technology_any_human_vampires", vampire_technology.any_human_vampires, context);
		cm:save_named_value("vampire_technology_final_tech_unlock_count", vampire_technology.final_tech_unlock_count, context);
		cm:save_named_value("vampire_technology_faction_lairs_awakened", vampire_technology.faction_lairs_awakened, context);
		cm:save_named_value("vampire_technology_faction_corpses_gained", vampire_technology.faction_corpses_gained, context);
		cm:save_named_value("vampire_technology_free_bloodline_unlocks", vampire_technology.free_bloodline_unlocks, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			vampire_technology.any_human_vampires = cm:load_named_value("vampire_technology_any_human_vampires", vampire_technology.any_human_vampires, context);
			vampire_technology.final_tech_unlock_count = cm:load_named_value("vampire_technology_final_tech_unlock_count", vampire_technology.final_tech_unlock_count, context);
			vampire_technology.faction_lairs_awakened = cm:load_named_value("vampire_technology_faction_lairs_awakened", vampire_technology.faction_lairs_awakened, context);
			vampire_technology.faction_corpses_gained = cm:load_named_value("vampire_technology_faction_corpses_gained", vampire_technology.faction_corpses_gained, context);
			vampire_technology.free_bloodline_unlocks = cm:load_named_value("vampire_technology_free_bloodline_unlocks", vampire_technology.free_bloodline_unlocks, context);
		end
	end
);