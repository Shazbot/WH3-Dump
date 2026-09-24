episode_vermintide = {
	episode_disabled = false,
	episode_name = "episode_skaven_vermintide",
	episode_set = "end_times",
	episode_active_shared_state = "episode_skaven_vermintide",
	episode_frontend_enabled_shared_state_key = "endgame_skaven_vermintide_enabled",
	episode_audio_stage_change_dynamic_dialogue_event = "campaign_vo_cs_end_times_structure_vermintide",
	post_episode_cooldown = 10,

	invasion_faction_key = "wh3_dlc29_vermintide_confederation_owner",
	invasion_culture_key = "wh2_main_skv_skaven",

	movie_path = "warhammer3/endtimes/dlc29_end_times_vermintide",
	movie_registry = "dlc29_end_times_vermintide",
	
	foreshadow_incident_key_1 = "wh3_dlc29_skaven_vermintide_episode_foreshadow_1",
	foreshadow_main_event_key = "skaven_vermintide_foreshadow_main_event",
	
	dilemma_join_invasion = "wh3_dlc29_episodes_skaven_vermintide_ally_dilemma",
	final_battle_mission_key = "wh3_dlc29_skaven_episodes_endgame_final_battle",
	victory_incident = "wh3_dlc29_skaven_vermintide_episode_victory",

	diplomacy_bundle = "wh3_dlc29_episodes_endgame_shield_of_civilization_skaven",
	devastated_region_bundle = "wh3_dlc29_episodes_skaven_devastated_region",
	devastated_province_bundle = "wh3_dlc29_episodes_skaven_devastated_province",
	faction_trait_effect_bundle = "wh3_dlc29_faction_trait_skaven_vermintide",

	-- areas that have devastated_region_bundle on them will be force devastated for as long as it is active
	forced_devastation_duration = 5,
	war_plans_ancillary = "wh3_dlc29_anc_enchanted_item_skaven_war_plans",
	war_plans_dilemma = "wh3_dlc29_skaven_vermintide_war_plans",
	war_plans_mission = "wh3_dlc29_skaven_vermintide_gain_war_plans",
	war_plans_progress_increase = 5,
	war_plans_drop_chance = 55,

	under_empire_slot_set = "wh2_dlc29_slot_set_underempire_endgame",
	under_empire_spread_per_turn_cap = 3, -- The max number of Under-Cities that can spread each turn
	under_empire_bad_things_per_turn_cap = 1, -- The max number of bad things we can spawn factionwide in Under-Cities each turn
	doomsphere_detonation_chance = 5,

	anti_vermintide_buildings = {
		"wh3_main_foreign_slot_endgame_1",
		"wh3_main_foreign_slot_endgame_2a",
		"wh3_main_foreign_slot_endgame_2b",
		"wh3_main_foreign_slot_endgame_2c"
	},

	invasion_region_to_force_count = 0.67, -- As the invasion spawns armies this value controls the max army count they're allowed based on their total region count
	invasion_per_turn_spawn_cap = 5, -- No more than this amount of armies can be spawned per turn from buildings
	invasion_region_count = 10, -- The ideal total number of regions around the world the invasion faction should get at the start of the invasion
	invasion_force_count_per_region = 5, -- The total number of forces the invasion will spawn at each of the key locations at the start
	skaven_legendary_lords = {
		["wh3_dlc29_skv_thanquol"] = {status = "unkown", forename = "1473216767", surname = "", army = "skaven_verminlord", spawn_region = "wh3_main_combi_region_skavenblight"},
		["wh2_dlc12_skv_ikit_claw"] = {status = "unkown", forename = "1400581194", surname = "1574593534", army = "skaven_arty", spawn_region = "wh3_main_combi_region_skavenblight"},
		["wh2_main_skv_queek_headtaker"] = {status = "unkown", forename = "2147359300", surname = "2147360908", army = "skaven_verminlord", spawn_region = "wh3_main_combi_region_karak_eight_peaks"},
		["wh2_dlc16_skv_throt_the_unclean"] = {status = "unkown", forename = "1120367167", surname = "2095615470", army = "skaven_pox", spawn_region = "wh3_main_combi_region_hell_pit"},
		["wh2_main_skv_lord_skrolk"] = {status = "unkown", forename = "2147359289", surname = "2147359296", army = "skaven_pox", spawn_region = "wh3_main_combi_region_hell_pit"},
		["wh2_dlc09_skv_tretch_craventail"] = {status = "unkown", forename = "421856293", surname = "1843290975", army = "skaven_monsters", spawn_region = "wh3_main_combi_region_crookback_mountain"},
		["wh2_dlc14_skv_deathmaster_snikch"] = {status = "unkown", forename = "840626619", surname = "560963109", army = "skaven_sneak", spawn_region = "wh3_main_combi_region_crookback_mountain"}
	},
	skaven_armies = {
		["skaven"] = {
			units = "wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide",
			valid_lords = {"wh2_main_skv_warlord"},
			bundle = "wh3_dlc29_episodes_skaven_invasion_force",
			weight = 15
		},
		["skaven_monsters"] = {
			units = "wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide",
			valid_lords = {"wh2_main_skv_grey_seer_ruin", "wh2_main_skv_grey_seer_ruin", "wh2_main_skv_grey_seer_ruin", "wh2_main_skv_grey_seer_ruin", "wh3_dlc29_skv_verminlord_warpseer"},
			bundle = "wh3_dlc29_episodes_skaven_invasion_force",
			weight = 1
		},
		["skaven_pox"] = {
			units = "wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide",
			valid_lords = {"wh2_main_skv_grey_seer_plague", "wh2_main_skv_grey_seer_plague", "wh2_main_skv_grey_seer_plague", "wh2_main_skv_grey_seer_plague", "wh3_dlc29_skv_verminlord_corruptor"},
			bundle = "wh3_dlc29_episodes_skaven_invasion_force",
			weight = 1
		},
		["skaven_sneak"] = {
			units = "wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide",
			valid_lords = {"wh2_dlc14_skv_master_assassin", "wh2_dlc14_skv_master_assassin", "wh2_dlc14_skv_master_assassin", "wh2_dlc14_skv_master_assassin", "wh3_dlc29_skv_verminlord_deceiver"},
			bundle = "wh3_dlc29_episodes_skaven_invasion_force",
			weight = 1
		},
		["skaven_arty"] = {
			units = "wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide",
			valid_lords = {"wh2_dlc12_skv_warlock_master", "wh2_dlc12_skv_warlock_master", "wh2_dlc12_skv_warlock_master", "wh2_dlc12_skv_warlock_master", "wh3_dlc29_skv_verminlord_warbringer"},
			bundle = "wh3_dlc29_episodes_skaven_invasion_force",
			weight = 1
		},
		["skaven_verminlord"] = {
			units = "wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide,wh3_dlc29_skv_inf_clanrats_vermintide",
			valid_lords = {"wh3_dlc29_skv_verminlord_corruptor", "wh3_dlc29_skv_verminlord_deceiver", "wh3_dlc29_skv_verminlord_warbringer", "wh3_dlc29_skv_verminlord_warpseer"},
			bundle = "wh3_dlc29_episodes_skaven_invasion_force",
			weight = 1
		}
	},

	prevent_occupation_options = {
		"1137",
		"1148",
		"361127595",
		"1161",
		"599999523"
	},

	skaven_spawn_points = {
		-- Bretonnia (Skavenblight)
		{
			primary = "wh3_main_combi_region_skavenblight",
			secondary = {"wh3_main_combi_region_massif_orcal", "wh3_main_combi_region_karak_izor", }
		},
		-- Norsca (Hell Pit)
		{
			primary = "wh3_main_combi_region_hell_pit",
			secondary = {"wh3_main_combi_region_doomkeep", "wh3_main_combi_region_the_forbidden_citadel"}
		},
		-- Northern Mountains (Crookback Mountain)
		{
			primary = "wh3_main_combi_region_crookback_mountain",
			secondary = {"wh3_main_combi_region_zharr_naggrund", "wh3_main_combi_region_khazid_irkulaz"}
		},
		-- Empire (Middenheim)
		{
			primary = "wh3_main_combi_region_middenheim",
			secondary = {"wh3_main_combi_region_altdorf", "wh3_main_combi_region_nuln"}
		},
		-- Badlands (Karak Eight-Peaks)
		{
			primary = "wh3_main_combi_region_karak_eight_peaks",
			secondary = {"wh3_main_combi_region_nagashizzar", "wh3_main_combi_region_karak_azgal"}
		},
		-- Ogre Mountains
		{
			primary = "wh3_main_combi_region_karak_vrag",
			secondary = {"wh3_main_combi_region_karak_azorn", "wh3_main_combi_region_flayed_rock"}
		},
		-- Naggarond
		{
			primary = "wh3_main_combi_region_rackdo_gorge",
			secondary = {"wh3_main_combi_region_tyrant_peak", "wh3_main_combi_region_clarak_spire"}
		},
		-- Lustria
		{
			primary = "wh3_main_combi_region_altar_of_the_horned_rat",
			secondary = {"wh3_main_combi_region_mine_of_the_bearded_skulls", "wh3_main_combi_region_hualotal"}
		},
		-- Southlands
		{
			primary = "wh3_main_combi_region_karak_zorn",
			secondary = {"wh3_main_combi_region_vulture_mountain", "wh3_main_combi_region_temple_avenue_of_gold", "wh3_main_combi_region_karag_orrud"}
		},
		-- Cathay
		{
			primary = "wh3_main_combi_region_shi_wu",
			secondary = {"wh3_main_combi_region_po_mei", "wh3_main_combi_region_hanyu_port"}
		}
	},

	underempire_thresholds = {
		{
			required_underempires = 0,
			battle_parameter = "the_vermintide_fb_underempire_threshold_01",
		},
		{
			required_underempires = 20,
			battle_parameter = "the_vermintide_fb_underempire_threshold_02",
		},
		{
			required_underempires = 30,
			battle_parameter = "the_vermintide_fb_underempire_threshold_03",
		},
		{
			required_underempires = 40,
			battle_parameter = "the_vermintide_fb_underempire_threshold_04",
		},
		{
			required_underempires = 51,
			battle_parameter = "the_vermintide_fb_underempire_threshold_05",
		},
	},

	dilemmas = {},
	factions_awaiting_dilemma = {},
	
	prerequisites = {
		min_turn = 80
	},
	persistent = {
		current_stage = 1,
		war_plan_progress = 0,
		doomspheres_detonated = 0,
		stages_persistent_data = {},
		invasion_spawned = false,
		dilemmas = {}
	}
}

episode_vermintide.stages = 
{
	-- Foreshadow 1 - Skaven council of thirteen speech
	{
		stage_key = "episode_skaven_vermintide_stage_foreshadow_1",
		duration = 13,
		payloads =
		{
			{
				payload_type = "incident",
				incident_key = episode_vermintide.foreshadow_incident_key_1,
			}
		},
		audio_stage_type = episodes_manager.audio_stage_types.foreshadow,

		on_started = function(self)
			episode_vermintide:play_voiceline("Play_wh3_dlc29_endtimes_narrative_vermintide_skreech_007")
		end
	},
	-- Main Event - The Invasion begins!
	{
		stage_key = "episode_skaven_vermintide_stage_main",
		main_event = true,
		payloads = {},
		audio_stage_type = episodes_manager.audio_stage_types.main_event,

		on_started = function(self)
			-- Disable the entire event feed as we don't want any events while creating the invasion
			cm:disable_event_feed_events(true, "all")
		end,

		post_payload = function(self)
			local regions_to_raze = episode_vermintide:setup_skaven_invasion()
			cm:fade_scene(0, 3)

			cm:callback(function()
				episode_vermintide:raze_and_devastate_invasion_regions(regions_to_raze)
				episode_vermintide:play_endgame_movie()
				episode_vermintide:spawn_skaven_invasion()
				episode_vermintide:trigger_endgame_diplomacy()
				cm:fade_scene(1, 1)

				cm:callback(function()
					local local_faction_key = cm:get_local_faction_name(true)

					if episode_vermintide.factions_awaiting_dilemma[local_faction_key] == nil then
						-- If the local faction didn't just get given a dilemma we can show the UI right away, else we'll do it after the dilemma
						-- This is all MP safe as it is just UI stuff
						episode_vermintide:toggle_endgame_ui()
						episode_vermintide:play_voiceline("Play_wh3_dlc29_endtimes_narrative_vermintide_skreech_001")
					end

					-- Play some music!
                    cm:activate_music_trigger("Episode_Start", "wh2_main_sc_skv_skaven")

					-- Trigger all missions related to the endgame for all humans, excluding those waiting for the dilemma, as we need to know their choice before giving them missions
					local human_factions = cm:get_human_factions()

					for i = 1, #human_factions do
						if episode_vermintide.factions_awaiting_dilemma[human_factions[i]] == nil then
							episode_vermintide:trigger_endgame_missions(human_factions[i])
							episode_vermintide:unlock_vermintide_buildings(human_factions[i], true)
						end
					end
					cm:disable_event_feed_events(false, "all")
					episode_vermintide.persistent.invasion_spawned = true
				end, 1.2)
			end, 3.1)
		end,

		get_next_stage_index = function()
			-- If we don't specify a final battle then we should just skip straight to the ending
			if episode_vermintide.final_battle_mission_key == "" then
				return episodes_manager:get_episode_stage_index_by_name(episode_vermintide, "episode_skaven_vermintide_stage_final")
			end
			return episodes_manager:get_episode_stage_index_by_name(episode_vermintide, "episode_skaven_vermintide_stage_battle")
		end,
	},
	-- Archaon was defeated in a normal battle - We now trigger the final battle marker via a mission
	{
		stage_key = "episode_skaven_vermintide_stage_battle",
		payloads =
		{
			{
				payload_type = "mission",
				mission_key = episode_vermintide.final_battle_mission_key,
			}
		},
		audio_stage_type = episodes_manager.audio_stage_types.main_event_02,

		on_started = function(self)
			episode_vermintide:play_voiceline("Play_wh3_dlc29_endtimes_narrative_vermintide_narrator_006")
		end	
	},
	-- Episode Ending - Show the victory event, end the episode
	{
		stage_key = "episode_skaven_vermintide_stage_final",
		max_duration = 1,

		payloads =
		{
			-- Trigger win incident (all players get this, even if it was a Skaven player part of the invasion)
			{
				payload_type = "incident",
				incident_key = episode_vermintide.victory_incident,
			}
		},

		audio_stage_type = episodes_manager.audio_stage_types.ended,

		on_started = function(self)
			episode_vermintide:play_voiceline("Play_wh3_dlc29_endtimes_narrative_vermintide_narrator_008")

			-- Play some music!
            cm:activate_music_trigger("Episode_Finish", "wh2_main_sc_skv_skaven")

			-- Kill the invasion faction
			cm:kill_faction(episode_vermintide.invasion_faction_key)

			-- Hide the Endgame UI elements
			cm:set_script_state("current_episode_popup", "")
			local uic = core:get_or_create_component("foreshadow_popup", "UI/Campaign UI/dlc29_endgame_crisis_scenarios.twui.xml")
			uic:SetVisible(false)

			-- Remove all effect bundles related to the endgame
			local human_factions = cm:get_human_factions()

			for i = 1, #human_factions do
				local faction_key = human_factions[i]
				for _, dilemma in ipairs(episode_vermintide.dilemmas) do
					for _, effect in ipairs(dilemma.effects) do
						cm:remove_effect_bundle(effect, faction_key)
					end
				end

				-- Re-lock the endgame specific buildings
				episode_vermintide:unlock_vermintide_buildings(faction_key, false)
			end

			local all_factions = cm:get_faction_list()
			for i = 0, all_factions:num_items() - 1 do
				local faction = all_factions:item_at(i)
				if faction:is_dead() == false then
					local faction_key = faction:name()
					cm:remove_effect_bundle(episode_vermintide.diplomacy_bundle, faction_key)
				end
			end

			-- Also remove all region effect bundles
			local region_list = cm:model():world():region_manager():region_list()

			for _, region in model_pairs(region_list) do
				local region_key = region:name()
				cm:remove_effect_bundle_from_region(episode_vermintide.devastated_region_bundle, region_key)
			end

			-- Finally clear the persistent data as its no longer needed
			episode_vermintide.persistent.legendary_lords = {}
			episode_vermintide.persistent.dilemmas = {}
		end,

		get_next_stage_index = function()
			return -1 -- This ends the episode
		end
	},
}

episode_vermintide.setup_skaven_invasion = function(self)
	out.invasions("##### setup_skaven_invasion #####")
	local invasion_faction = cm:get_faction(episode_vermintide.invasion_faction_key)
	cm:awaken_faction_from_death(invasion_faction)
	cm:lock_starting_character_recruitment("1583741038", episode_vermintide.invasion_faction_key) -- Faction Leader
	out.invasions("\tawaken_faction_from_death")

	-- Kill all the Legendary Lords, we aren't going to want duplicates
	for lord_subtype, lord_details in dpairs(episode_vermintide.skaven_legendary_lords) do
		local family_member_cqi = episode_vermintide.persistent.legendary_lords[lord_subtype]

		if family_member_cqi then
			local family_member = cm:get_family_member_by_cqi(family_member_cqi)

			if family_member:is_null_interface() == false then
				local character_details = family_member:character_details()

				if character_details:faction():is_human() == false then
					local character_lookup = "family_member_cqi:"..family_member_cqi
					cm:set_character_immortality(character_lookup, false)
					cm:kill_character(character_lookup, true, true)
					out.invasions("\tkilling - "..lord_subtype)

					lord_details.status = "ready"
				else
					lord_details.status = "human"
				end
			end
		end
	end

	-- Next go through all Skaven factions, kill all their remaining lords/armies, raze all their regions and then confederate them (confederation is just so they are marked as confederated and thus cannot reappear)
	local faction_list = cm:get_factions_by_culture(episode_vermintide.invasion_culture_key)
	local stored_regions = {}

	-- if you postpone the cai analysis you MUST call resume_cai_analysis later!!
	cm:postpone_cai_analysis()
	for _, faction in ipairs(faction_list) do
		if faction:is_null_interface() == false and faction:is_human() == false and faction:is_quest_battle_faction() == false and faction:is_rebel() == false and faction:is_faction(invasion_faction) == false then
			if faction:is_dead() == true then
				cm:awaken_faction_from_death(faction)
			end
			local faction_key = faction:name()
			local character_list = faction:character_list()

			for char_index = character_list:num_items() - 1, 0, -1 do
				local character = character_list:item_at(char_index)
				local character_details = character:character_details()
				local character_subtype = character_details:character_subtype_key()
				local family_member_cqi = character_details:family_member():command_queue_index()
				local character_lookup = "family_member_cqi:"..family_member_cqi
				
				-- Kill everyone regardless of who they are
				cm:set_character_immortality(character_lookup, false)
				cm:kill_character(character_lookup, true, true)
			end

			local region_list = faction:region_list()

			for region_index = 0, region_list:num_items() - 1 do
				local region = region_list:item_at(region_index)
				table.insert(stored_regions, region:name())
			end
			cm:force_confederation(episode_vermintide.invasion_faction_key, faction_key)
		end
	end
	cm:resume_cai_analysis()
	return stored_regions
end

episode_vermintide.raze_and_devastate_invasion_regions = function(self, regions_to_raze)
	for _, region_key in ipairs(regions_to_raze) do
		self:raze_and_devastate_invasion_region(region_key)
	end
end

episode_vermintide.raze_and_devastate_invasion_region = function(self, region_key)
	cm:set_region_abandoned(region_key)
	if self.devastated_region_bundle then
		cm:apply_effect_bundle_to_region(self.devastated_region_bundle, region_key, self.forced_devastation_duration)
	end
	self:update_province_devastation_for_region(region_key, true)
end

episode_vermintide.trigger_endgame_diplomacy = function(self)
	local invasion_faction = cm:get_faction(episode_vermintide.invasion_faction_key)
	local factions_met = invasion_faction:factions_met()

	local skaven_factions = {}
	local skaven_faction_list = cm:get_factions_by_culture(episode_vermintide.invasion_culture_key)

	local human_factions = cm:get_human_factions()
	local is_single_player = (#human_factions == 1)

	for _, faction in ipairs(skaven_faction_list) do
		skaven_factions[faction] = true
		if faction:is_human() == true then
			local other_faction_key = faction:name()
			if is_single_player then
				-- Human Skaven factions get asked to join or fight against the invasion here, subsequent diplomacy happens in the dilemma event
				cm:trigger_dilemma(other_faction_key, episode_vermintide.dilemma_join_invasion)
				episode_vermintide.factions_awaiting_dilemma[other_faction_key] = true
			else
				self:declare_war_on_faction_or_overlord(invasion_faction, faction)
			end
		end
	end

	for i = 0, factions_met:num_items() - 1 do
		local other_faction = factions_met:item_at(i)

		if not skaven_factions[other_faction] then -- We want to avoid doing anything with other Skaven factions
			self:declare_war_on_faction_or_overlord(invasion_faction, other_faction)
		end
	end
	
	-- No diplomacy with the endgame faction
	cm:force_diplomacy("all", "faction:"..episode_vermintide.invasion_faction_key, "all", false, false, true)
	cm:force_diplomacy("faction:"..episode_vermintide.invasion_faction_key, "all", "all", false, false, true)
end

-- checks if other_faction_obj is a vassal. if so - declaring_faction declares war on their overlord. 
-- otherwise declaring_factiondeclares war on other_faction_obj directly
episode_vermintide.declare_war_on_faction_or_overlord = function(self, declaring_faction, other_faction_obj, give_diplomatic_bundle--[[ = true --]])
	give_diplomatic_bundle = give_diplomatic_bundle or true
	local other_faction_key = other_faction_obj:name()
	local declaring_faction_key = declaring_faction:name()

	if other_faction_key == self.invasion_faction_key
		or other_faction_obj:is_ally_vassal_or_client_state_of(declaring_faction)
		or other_faction_obj:is_dead()
	then
		return
	end
	if give_diplomatic_bundle then
		-- all factions fighting against the invasion faction get a bundle so they support each other
		cm:apply_effect_bundle(self.diplomacy_bundle, other_faction_key, 0)
	end
	if other_faction_obj:at_war_with(declaring_faction) == false then
		-- If this faction is a vassal, declare war on their master to avoid issues
		if other_faction_obj:is_vassal() == true then
			local master_faction = other_faction_obj:master()
			if master_faction:at_war_with(declaring_faction) == false and master_faction:is_dead() == false then
				local master_faction_key = other_faction_obj:master():name()
				cm:force_declare_war(declaring_faction_key, master_faction_key, false, false)
				if give_diplomatic_bundle then
					-- we give the bundle to the master as well
					cm:apply_effect_bundle(self.diplomacy_bundle, master_faction_key, 0)
				end
			end
		else
			cm:force_declare_war(declaring_faction_key, other_faction_key, false, false)
		end
	end
end

episode_vermintide.on_episode_end = function(self)
	-- we clear the shared states from the episode
	cm:remove_script_state("skaven_world_owned")
	cm:remove_script_state("skaven_doomspheres_detonated")
	cm:remove_script_state("skaven_armies_owned")
	cm:remove_script_state("skaven_rat_count")
	cm:remove_script_state("skaven_war_plans")
end

-- TODO: Implement "get war plans" mission
episode_vermintide.trigger_endgame_missions = function(self, faction_key)
	out.invasions("\ttrigger_endgame_missions - "..faction_key)

	local mm = mission_manager:new(faction_key, episode_vermintide.war_plans_mission)
	mm:set_mission_issuer("CLAN_ELDERS")
	mm:add_new_objective("SCRIPTED")
	mm:add_condition("script_key skaven_war_plans_mission")
	mm:add_condition("override_text mission_text_text_wh3_dlc29_mission_skaven_vermintide_collect_war_plans")
	mm:add_payload("text_display dummy_skaven_vermintide_war_plans_reward")
	mm:trigger()
end

episode_vermintide.trigger_endgame_dilemma = function(self, dilemma_key)
	local invasion_faction = cm:get_faction(episode_vermintide.invasion_faction_key)
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		local faction_key = human_factions[i]
		local faction = cm:get_faction(faction_key)

		if faction:at_war_with(invasion_faction) == true and faction:has_home_region() == true then
			cm:trigger_dilemma(faction_key, dilemma_key)
		end
	end
end

episode_vermintide.spawn_skaven_invasion = function(self)
	out.invasions("##### spawn_skaven_invasion #####")
	local invasion_faction = cm:get_faction(episode_vermintide.invasion_faction_key)
	local invasion_spawn_regions = episode_vermintide:get_invasion_spawn_regions(episode_vermintide.invasion_region_count)
	local skavenblight_taken = false

	out.invasions("\tlegendary lords:")
	local lord_count = 1
	for lord_subtype, lord_details in dpairs(episode_vermintide.skaven_legendary_lords) do
		out.invasions("\t\t"..lord_count.."- "..lord_subtype.." ("..lord_details.status..")")
		lord_count = lord_count + 1

		if lord_details.forename ~= "" then
			lord_details.forename = "names_name_"..lord_details.forename
		end
		if lord_details.surname ~= "" then
			lord_details.surname = "names_name_"..lord_details.surname
		end
	end

	out.invasions("\tinvasion_spawn_regions:")
	-- Go through all of the regions, give them to the Skaven and spawn their starting armies
	for _, region in ipairs(invasion_spawn_regions) do
		local region_key = region:name()
		out.invasions("\t\t"..region_key)
		cm:transfer_region_to_faction(region_key, episode_vermintide.invasion_faction_key)
		episode_vermintide:reveal_region_to_humans(region_key)

		-- Upgrade the main settlement incase it is a ruin
		local primary_slot = region:settlement():primary_slot()
		cm:instantly_upgrade_building_in_region(primary_slot, "wh3_main_skv_endgame_settlement_1")
		-- Add one of the army spawning buildings
		local secondary_slot = region:slot_list():item_at(1)
		cm:instantly_upgrade_building_in_region(secondary_slot, "wh3_main_skv_endgame_army_spawn_1")
		
		-- Make sure Skavenblight becomes the capital if its given
		if region_key == "wh3_main_combi_region_skavenblight" then
			cm:change_home_region_of_faction(invasion_faction, region)
			cm:cai_disable_targeting_against_settlement("settlement:wh3_main_combi_region_skavenblight")
			skavenblight_taken = true
		end

		-- Spawn the Endgame Under-Empire in this region
		episode_vermintide:create_under_empire_in_region(region)
		episode_vermintide:increase_region_script_state(region)

		-- Corrupt the province
		cm:change_corruption_in_province_by(region:province_name(), "wh3_main_corruption_skaven", 100, "events")

		-- Spawn the legendary lords associated with this region and then generic armies
		local forces_spawned = 0
		
		for lord_subtype, lord_details in dpairs(episode_vermintide.skaven_legendary_lords) do
			if lord_details.status == "ready" and (lord_details.spawn_region and lord_details.spawn_region == region_key) then
				local spawn_distance = cm:random_number(5, 2)
				episode_vermintide:create_skaven_invasion_force(lord_subtype, region_key, spawn_distance)
				lord_details.status = "spawned"
				forces_spawned = forces_spawned + 1
			end
		end

		while forces_spawned < episode_vermintide.invasion_force_count_per_region do
			local spawn_distance = cm:random_number(10, 4)
			episode_vermintide:create_skaven_invasion_force(nil, region_key, spawn_distance)
			forces_spawned = forces_spawned + 1
		end
	end

	-- Go through all legendary lords and spawn any who didn't spawn at their associated location at Skavenblight
	for lord_subtype, lord_details in dpairs(episode_vermintide.skaven_legendary_lords) do
		if lord_details.status == "ready" then
			local spawn_distance = cm:random_number(12, 8)
			episode_vermintide:create_skaven_invasion_force(lord_subtype, "wh3_main_combi_region_skavenblight", spawn_distance)
			lord_details.status = "spawned"
		end
	end

	if skavenblight_taken == false then
		-- If Skavenblight wasn't given to the faction then corrupt it anyway and give it an undercity
		local region = cm:get_region("wh3_main_combi_region_skavenblight")
		episode_vermintide:create_under_empire_in_region(region)
		cm:change_corruption_in_province_by(region:province_name(), "wh3_main_corruption_skaven", 100, "events")
	end
	
	-- Apply the invasion factions effect bundle
	cm:apply_effect_bundle(episode_vermintide.faction_trait_effect_bundle, episode_vermintide.invasion_faction_key, 0)
	
	-- Limit the Endgames occupation options to just occupation
	for _, occupation_option in ipairs(episode_vermintide.prevent_occupation_options) do
		cm:add_event_restricted_occupation_option_record_for_faction(occupation_option, episode_vermintide.invasion_faction_key)
	end

	-- Finally update the UI tooltip
	episode_vermintide:update_endgame_tooltip()
end

episode_vermintide.create_skaven_invasion_force = function(self, lord_subtype_override, region_key, spawn_distance, prevent_corruption)
	out.invasions("\tcreate_legendary_invasion_force  -  "..region_key)
	local x_pos = -1
	local y_pos = -1
	prevent_corruption = prevent_corruption or false

	if spawn_distance then
		x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_settlement(episode_vermintide.invasion_faction_key, region_key, false, true, spawn_distance)
	else
		x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_settlement(episode_vermintide.invasion_faction_key, region_key, false, true)
	end
	if x_pos == -1 or y_pos == -1 then
		script_error("SKAVEN VERMINTIDE: Failed to generate new Lord's spawn position")
	end
	region_key = cm:get_region_data_at_position(x_pos, y_pos):key()
	
	local lord_subtype = ""
	local army_key = ""
	local unit_list = ""
	local force_bundle = ""
	local forename = ""
	local surname = ""
	local lord_xp = 30
	local unit_xp = 0

	if lord_subtype_override then
		lord_subtype = lord_subtype_override
		army_key = episode_vermintide.skaven_legendary_lords[lord_subtype].army
		unit_list = episode_vermintide.skaven_armies[army_key].units
		force_bundle = episode_vermintide.skaven_armies[army_key].bundle
		forename = episode_vermintide.skaven_legendary_lords[lord_subtype].forename
		surname = episode_vermintide.skaven_legendary_lords[lord_subtype].surname
		lord_xp = 50
		unit_xp = 3
	else
		local possible_armies = weighted_list:new()

		for army_key, army_details in dpairs(episode_vermintide.skaven_armies) do
			-- Only armies with weights can be randomly spawned
			if army_details.weight then
				possible_armies:add_item(army_key, army_details.weight)
			end
		end

		local selected_army, index = possible_armies:weighted_select()
		unit_list = episode_vermintide.skaven_armies[selected_army].units
		force_bundle = episode_vermintide.skaven_armies[selected_army].bundle
		
		-- Select a lord subtype
		cm:shuffle_table(episode_vermintide.skaven_armies[selected_army].valid_lords)
		lord_subtype = episode_vermintide.skaven_armies[selected_army].valid_lords[1]
	end

	local character cm:create_force_with_general(
		episode_vermintide.invasion_faction_key,
		unit_list,
		region_key,
		x_pos, y_pos,
		"general",
		lord_subtype,
		forename, "", surname, "",
		false,
		function(char_cqi, force_cqi)
			local character_lookup = "character_cqi:"..char_cqi
			cm:add_agent_experience(character_lookup, lord_xp, true)
			cm:apply_effect_bundle_to_force(force_bundle, force_cqi, 0)

			if unit_xp > 0 then
				cm:add_experience_to_units_commanded_by_character(character_lookup, unit_xp)
			end

			-- If this character has a subtype override then they are important and so we reveal them on turn 1 of the invasion
			if lord_subtype_override then
				episode_vermintide:reveal_character_to_humans(character_lookup, 1)
			end
		end
	)
	
	if prevent_corruption == false then
		-- Corrupt the region with Skaven corruption
		local region = cm:get_region(region_key)
		cm:change_corruption_in_province_by(region:province_name(), "wh3_main_corruption_skaven", 100, "events")
	end
	return character
end

episode_vermintide.create_random_invasion_force = function(self, region_key)
	local possible_armies = weighted_list:new()

	for army_key, army_details in dpairs(episode_vermintide.skaven_armies) do
		-- Only armies with weights can be randomly spawned
		if army_details.weight then
			possible_armies:add_item(army_key, army_details.weight)
		end
	end

	local selected_army, index = possible_armies:weighted_select()
	local unit_list = episode_vermintide.skaven_armies[selected_army].units
	local force_bundle = episode_vermintide.skaven_armies[selected_army].bundle
	local x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_settlement(episode_vermintide.invasion_faction_key, region_key, false, true)

	if x_pos == -1 or y_pos == -1 then
		return false
	end

	cm:create_force(
		episode_vermintide.invasion_faction_key,
		unit_list,
		region_key,
		x_pos, y_pos,
		false, -- False means allowing legendary lords to spawn, which we want as this will function as their respawn method
		function(char_cqi, force_cqi)
			cm:apply_effect_bundle_to_force(force_bundle, force_cqi, 0)
		end
	)
	return true
end

episode_vermintide.create_under_empire_in_region = function(self, region)
	local invasion_faction = cm:get_faction(episode_vermintide.invasion_faction_key)
	cm:add_foreign_slot_set_to_region_for_faction(invasion_faction:command_queue_index(), region:cqi(), episode_vermintide.under_empire_slot_set)
	out("CREATING UNDER-EMPIRE : "..region:name())

	local slot_manager = region:foreign_slot_manager_for_faction(episode_vermintide.invasion_faction_key)
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		local human_faction = cm:get_faction(human_factions[i])
		cm:foreign_slot_set_reveal_to_faction(human_faction, slot_manager);
	end
	return true
end

episode_vermintide.spread_under_empire_from_region = function(self, region)
	out("spread_under_empire_from_region")
	local adjacent_regions = region:adjacent_region_list()
	local settlement = region:settlement()
	local region_x = settlement:logical_position_x()
	local region_y = settlement:logical_position_y()

	local closest_player_capital = nil
	local closest_player_capital_x = -1
	local closest_player_capital_y = -1
	local closest_player_capital_distance = 999999999
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		local faction_key = human_factions[i]
		local faction = cm:get_faction(faction_key)

		if faction:has_home_region() == true then
			local home_region = faction:home_region()
			local home_settlement = home_region:settlement()
			local home_x = home_settlement:logical_position_x()
			local home_y = home_settlement:logical_position_y()
			local distance = distance_squared(home_x, home_y, region_x, region_y)

			if distance < closest_player_capital_distance then
				closest_player_capital = home_region
				closest_player_capital_x = home_x
				closest_player_capital_y = home_y
				closest_player_capital_distance = distance
			end
		end
	end

	if closest_player_capital then
		out("\tClosest Capital: "..closest_player_capital:name())
	else
		out("\tERROR : closest_player_capital is nil")
	end

	-- Calculate the reference direction from this region to the closest player capital
	-- We want to select the region that is the closest to being on that same direction
	-- This achieves the (rough) result of Under-Empires moving towards players
	local ref_x = closest_player_capital_x - region_x
	local ref_y = closest_player_capital_y - region_y
	local ref_len = math.sqrt(ref_x * ref_x + ref_y * ref_y)
	ref_x = ref_x / ref_len
	ref_y = ref_y / ref_len

	local best_region = nil
	local best_region_dot = nil
	local cs = false

	for _, adjacent_region in model_pairs(adjacent_regions) do
		if episode_vermintide:can_spread_under_empire_to_region(adjacent_region) == true then
			cs = true
			local adjacent_settlement = adjacent_region:settlement()
			local adjacent_x = adjacent_settlement:logical_position_x()
			local adjacent_y = adjacent_settlement:logical_position_y()

			-- Calculate the direction of this adjacent region, compare it against the reference direction and keep the best
			local dx = adjacent_x - region_x
			local dy = adjacent_y - region_y
			local len = math.sqrt(dx * dx + dy * dy)

			if len > 0 then
				dx = dx / len
				dy = dy / len
				local dot = ref_x * dx + ref_y * dy

				if best_region == nil or dot > best_region_dot then
					best_region = adjacent_region
					best_region_dot = dot
				end
			end
		end
	end
	out("\tcan_spread_under_empire_to_region : "..tostring(cs))

	if best_region then
		out("\tBest Region: "..best_region:name())
		return episode_vermintide:create_under_empire_in_region(best_region)
	else
		out("\tERROR : best_region is nil")
	end
	return false
end

episode_vermintide.can_spread_under_empire_to_region = function(self, region)
	if region:is_abandoned() == true then
		return false
	end

	local skv_fsm = region:foreign_slot_manager_for_faction(episode_vermintide.invasion_faction_key)
	if skv_fsm:is_null_interface() == false then
		return false
	end

	local prevent_region = cm:get_regions_bonus_value(region, "endgame_skaven_prevent_under_empire_region_only")

	if prevent_region > 0 then
		return false
	end

	local province_regions = region:province():regions()

	for _, prov_region in model_pairs(province_regions) do
		local prevent = cm:get_regions_bonus_value(prov_region, "endgame_skaven_prevent_under_empire")

		if prevent > 0 then
			return false
		end
	end
	return true
end

episode_vermintide.destroy_under_empire_in_province = function(self, province)
	local invasion_faction = cm:get_faction(episode_vermintide.invasion_faction_key)

	for _, region in model_pairs(province:regions()) do
		local skv_fsm = region:foreign_slot_manager_for_faction(episode_vermintide.invasion_faction_key)

		if skv_fsm:is_null_interface() == false then
			cm:remove_faction_foreign_slots_from_region(invasion_faction:command_queue_index(), region:cqi());
		end
	end
end

episode_vermintide.spawn_raid_army = function(self, region)
	local region_key = region:name()
	local character = episode_vermintide:create_skaven_invasion_force(nil, region_key, 1, true)

	if character then
		local char_lookup = cm:char_lookup_str(character)
		cm:replenish_action_points(char_lookup)
		cm:cai_disable_movement_for_character(char_lookup)
		cm:enable_movement_for_character(char_lookup)
		cm:attack_region(char_lookup, region_key, true)
	end
end

episode_vermintide.reveal_region_to_humans = function(self, region_key)
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		local faction_key = human_factions[i]
		cm:make_region_visible_in_shroud(faction_key, region_key)
	end
end

episode_vermintide.reveal_character_to_humans = function(self, character_lookup, duration)
	duration = duration or 1
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		local faction_key = human_factions[i]
		cm:make_character_seen_in_shroud(character_lookup, faction_key, duration)
	end
end

episode_vermintide.should_region_be_devastated = function(self, region_obj)
	local region_list = region_obj:regions_in_same_event_area()
	if (not region_list) or region_list:is_null_interface() then
		return false
	end

	local region_count = region_list:num_items()
	if region_count == 0 then
		-- this should never happen
		script_error("ERROR: region with zero regions in its event area! [" .. region_obj:name() .. "]!");
		return false
	end

	local razed_or_skaven_regions = 0
	for i = 0, region_count - 1 do
		local region = region_list:item_at(i)
		local has_devastation_bundle = region:has_effect_bundle(self.devastated_region_bundle)
		-- areas that were nuked are forced into devastation for a fixed period
		if has_devastation_bundle then
			return true
		end
		if region:is_abandoned() == true or region:owning_faction():name() == episode_vermintide.invasion_faction_key then
			razed_or_skaven_regions = razed_or_skaven_regions + 1
		end
	end
	
	-- During this endgame provinces with 50% or more of their regions razed or owned by the Endgame Skaven get devastated
	local razed_or_skaven_ratio = razed_or_skaven_regions / region_count
	if razed_or_skaven_ratio < 0.5 then
		return false
	end
	return true
end

episode_vermintide.update_province_devastation_for_region = function(self, region_key, force_devastation)
	local region_obj = cm:get_region(region_key)
	if is_region(region_obj) == false then
		return false
	end

	local is_devastated = devastation_manager:is_region_devastated(region_key)
	local should_be_devastated = force_devastation or self:should_region_be_devastated(region_obj)

	if should_be_devastated and is_devastated then
		-- region is already devastated
		return false
	end

	if should_be_devastated == false and is_devastated == false then
		-- no need to devastate it
		return false
	end

	if should_be_devastated then
		-- The region and all other regions in the same area should be devastated
		devastation_manager:devastate_region(
			region_key, 
			episode_vermintide.invasion_culture_key, 
			"vermintide_devastation",
			episode_vermintide.devastated_province_bundle -- this is the region bundle, I'm not sure why it's called province 
		)
	else
		devastation_manager:remove_devastation(region_key)
	end
end

episode_vermintide.get_invasion_spawn_regions = function(self, amount_required)
	local invasion_regions = {}

	for _, region_group in ipairs(episode_vermintide.skaven_spawn_points) do
		local primary_region = cm:get_region(region_group.primary)
		local primary_region_valid = episode_vermintide:is_region_valid_spawn(primary_region)

		if primary_region_valid == true then
			table.insert(invasion_regions, primary_region)
		elseif region_group.secondary and #region_group.secondary > 0 then
			for _, secondary_region_key in ipairs(region_group.secondary) do
				local secondary_region = cm:get_region(secondary_region_key)
				local secondary_region_valid = episode_vermintide:is_region_valid_spawn(secondary_region)

				if secondary_region_valid == true then
					table.insert(invasion_regions, secondary_region)
					break
				end
			end
		end

		if #invasion_regions >= amount_required then
			return invasion_regions
		end
	end

	-- Not enough of the pre-selected regions were valid, so we'll try to find others procedurally
	local number_required = amount_required - #invasion_regions
	local all_regions = cm:model():world():region_manager():region_list()
	local extra_regions = {}
	local desperation = 0

	while desperation < 3 do
		for i = 0, all_regions:num_items() -1 do
			local region = all_regions:item_at(i)
			local region_valid = episode_vermintide:is_region_valid_spawn(region)
			
			if region_valid == true then
				-- Secondary requirement - We want regions that are mountain climate
				if region:settlement():get_climate() == "climate_mountain" or desperation >= 1 then
					-- Primary requirement - We want regions that are province capitals (major settlements)
					if region:is_province_capital() == true or desperation >= 2 then
						table.insert(extra_regions, region)
					end
				end
			end
		end

		if #extra_regions < number_required then
			-- We still don't have enough, so we need to lower our standards and try again..
			desperation = desperation + 1
		else
			-- We've now found enough extra regions, shuffle the table and add the remaining required to the list
			cm:shuffle_table(extra_regions)

			for i = 1, number_required do
				local valid_region = extra_regions[i]
				table.insert(invasion_regions, valid_region)
			end
			break
		end
	end
	return invasion_regions
end

episode_vermintide.is_region_valid_spawn = function(self, region)
	if region == nil or region:is_null_interface() == true then
		return false
	end

	local faction = region:owning_faction()

	-- If the region is owned by a human then we won't allow the endgame to steal it, unless the associated player has enough regions
	-- Faction capitals will never be stolen however
	if faction:is_human() == true then
		-- Factions that own regions should inherently have a captial, but we check just to be sure
		if faction:has_home_region() == true then
			if region:cqi() == faction:home_region():cqi() then
				-- This is the factions capital, abort!
				return false
			end
		end
		
		if faction:region_list():num_items() <= 3 then
			-- If the player has 3 or less regions, we won't take the region
			return false
		end
	end
	return true
end

episode_vermintide.unlock_vermintide_buildings = function(self, faction_key, unlock)
	for _, building_key in ipairs(episode_vermintide.anti_vermintide_buildings) do
		if unlock == true then
			--cm:remove_event_restricted_building_record_for_faction(building_key, faction_key)
			cm:remove_event_restricted_building_record(building_key)
		else
			--cm:add_event_restricted_building_record_for_faction(building_key, faction_key, "")
			cm:add_event_restricted_building_record(building_key, "")
		end
	end
end

episode_vermintide.update_endgame_tooltip = function(self)
	local invasion_faction = cm:get_faction(episode_vermintide.invasion_faction_key)
	local region_list = cm:model():world():region_manager():region_list()
	
	local skaven_world_owned = (invasion_faction:region_list():num_items() / region_list:num_items()) * 100
	cm:set_script_state("skaven_world_owned", skaven_world_owned)

	local military_force_list = invasion_faction:military_force_list()
	local skaven_armies_owned = military_force_list:num_items()
	cm:set_script_state("skaven_armies_owned", skaven_armies_owned)

	local skaven_rat_count = 0

	for _, force in model_pairs(military_force_list) do
		if force:is_armed_citizenry() == false then
			local unit_list = force:unit_list()

			for _, unit in model_pairs(unit_list) do
				local num = 165 * (unit:percentage_proportion_of_full_strength() / 100)
				skaven_rat_count = skaven_rat_count + math.ceil(num)
			end
		end
	end

	local skaven_rat_count_formatted = tostring(skaven_rat_count)

	while true do
		skaven_rat_count_formatted, k = string.gsub(skaven_rat_count_formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k == 0) then
			break
		end
	end
	cm:set_script_state("skaven_rat_count", skaven_rat_count_formatted)
	cm:set_script_state("skaven_doomspheres_detonated", episode_vermintide.persistent.doomspheres_detonated or 0)
	cm:set_script_state("skaven_war_plans", episode_vermintide.persistent.war_plan_progress or 0)
end

episode_vermintide.toggle_endgame_ui = function(self)
	cm:set_script_state("current_episode_popup", episode_vermintide.foreshadow_main_event_key)
	common.call_context_command("ToggleHUDPanel('dlc29_endgame_crisis_scenarios')")
end

episode_vermintide.play_endgame_movie = function(self)
	core:svr_save_registry_bool(episode_vermintide.movie_registry, true)
	cm:register_instant_movie(episode_vermintide.movie_path)
end

episode_vermintide.play_voiceline = function(self, adivce_level)
	core:cache_and_set_advisor_priority(1500, true)
	cm:show_advice(adivce_level, true, false, nil, 0, 0)
end

episode_vermintide.is_main_invasion_active = function(self)
	local current_stage_index = episode_vermintide.persistent.current_stage_index
	local invasion_index = episodes_manager:get_episode_stage_index_by_name(episode_vermintide, "episode_skaven_vermintide_stage_main")
	local final_battle_index = episodes_manager:get_episode_stage_index_by_name(episode_vermintide, "episode_skaven_vermintide_stage_battle")
	return episode_vermintide.persistent.invasion_spawned and is_number(current_stage_index) and (current_stage_index == invasion_index or current_stage_index == final_battle_index)
end

episode_vermintide.is_available_this_game = function(self)
	-- First check the frontend setting to make sure it was enabled
	local episode_enabled = cm:model():shared_states_manager():get_state_as_bool_value(episode_vermintide.episode_frontend_enabled_shared_state_key)

	if not episode_enabled then
		episode_vermintide.episode_disabled = true
		return false
	end

	local invasion_faction = cm:get_faction(episode_vermintide.invasion_faction_key)
	if not is_faction(invasion_faction) then
		script_error("SKAVEN VERMINTIDE: Invasion faction was nil or null interface")
		return false
	end

	local human_factions = cm:get_human_factions()
	for i = 1, #human_factions do
		local human_faction = cm:get_faction(human_factions[i])

		if human_faction:culture() == episode_vermintide.invasion_culture_key then
			return false
		end
	end
	return true
end

episode_vermintide.can_start = function(self)
	return true
end

episode_vermintide.start_episode = function(self)
	episodes_manager:start_stage(self, 1)
	cm:set_script_state(episode_vermintide.episode_active_shared_state, true)
end

episode_vermintide.update_province = function(self, faction_province, allow_army_spawning)
	local army_spawned = false

	if allow_army_spawning == true then
		local army_spawn_chance = cm:get_provinces_bonus_value(faction_province, "endgame_skaven_army_spawn")

		if army_spawn_chance and cm:model():random_percent(army_spawn_chance) then
			local regions = faction_province:regions()
			local possible_regions = {}

			for region_index = 0, regions:num_items() - 1 do
				local region_key = regions:item_at(region_index):name()
				table.insert(possible_regions, region_key)
			end

			cm:shuffle_table(possible_regions)
			local selected_region = possible_regions[1]
			local success = episode_vermintide:create_random_invasion_force(selected_region)

			if success then
				army_spawned = true
			end
		end
	end
	return army_spawned
end

episode_vermintide.update_region = function(self, region, allow_under_empire_spread)
	local under_empire_spread = false

	if allow_under_empire_spread == true then
		-- Chance to spread the Under-Empire
		local spread_chance = cm:get_regions_bonus_value(region, "endgame_skaven_under_empire_expansion") or 5

		if spread_chance and cm:model():random_percent(spread_chance) then
			out("Attempting Under-Empire spread: "..region:name())
			local success = episode_vermintide:spread_under_empire_from_region(region)
			out("\tSuccess: "..tostring(success))

			if success == true then
				under_empire_spread = true
			end
		end
	end

	-- Chance to spawn the Under-Empire in this region, if it doesn't already exist
	-- This will count towards the per turn limit, but as its important and less intrusive than direct spread we'll always allow it
	local skv_fsm = region:foreign_slot_manager_for_faction(episode_vermintide.invasion_faction_key)

	if skv_fsm:is_null_interface() == true then
		local spread_chance = cm:get_regions_bonus_value(region, "endgame_skaven_under_empire_create")

		if spread_chance and cm:model():random_percent(spread_chance) then
			local success = episode_vermintide:create_under_empire_in_region(region)

			if success == true then
				under_empire_spread = true
			end
		end
	end
	return under_empire_spread
end

episode_vermintide.update_under_city = function(self, under_city, allow_bad_things)
	local bad_thing_created = false
	local was_nuked = false
	local region = under_city:region()
	local region_name = region:name()
	local region_owner = region:owning_faction():name()
	local spare_slot = under_city:slots():item_at(1)

	if region_owner ~= episode_vermintide.invasion_faction_key then
		episode_vermintide:increase_region_script_state(region)

		if spare_slot:has_building() == true and spare_slot:building() == "wh3_main_skv_endgame_under_empire_doomsphere_1" then
			if cm:model():random_percent(episode_vermintide.doomsphere_detonation_chance) then
				out("Detonated Doomsphere in "..region_name)
				episode_vermintide:raze_and_devastate_invasion_region(region_name)
				under_empire_detonate_nuke(region, false, true, 1, "", region_owner)
				episode_vermintide.persistent.doomspheres_detonated = episode_vermintide.persistent.doomspheres_detonated + 1
				cm:set_script_state("skaven_doomspheres_detonated", episode_vermintide.persistent.doomspheres_detonated)
				was_nuked = true
			end
		end
		if allow_bad_things == true and was_nuked == false then
			-- Chance to create a Doomsphere in the empty slot
			local doomsphere_chance = cm:get_regions_bonus_value(region, "endgame_skaven_doomsphere_chance")

			if doomsphere_chance and cm:model():random_percent(doomsphere_chance) then
				if spare_slot:has_building() == false then
					cm:foreign_slot_instantly_upgrade_building(spare_slot, "wh3_main_skv_endgame_under_empire_doomsphere_1")
					out("Built Doomsphere in "..region_name)
					bad_thing_created = true
				end
			end
		end
	end
	return bad_thing_created
end

episode_vermintide.increase_region_script_state = function(self, region)
	local bonus_value = cm:get_regions_bonus_value(region, "endgame_skaven_steal_income")
	if bonus_value == 0 then
		bonus_value = 1
	else
		-- If not 0 the bonus value will always be in increments of 5
		bonus_value = (bonus_value / 5) + 1
	end
	cm:set_script_state(region, "endgame_skv_steal", bonus_value)
end

episode_vermintide.set_final_battle_modifiers = function(self)
	local invasion_faction = cm:get_faction(episode_vermintide.invasion_faction_key)
	local current_underempires = invasion_faction:foreign_slot_managers():num_items()
	local active_treshhold_index = -1
	for index, underempire_threshold in ipairs(self.underempire_thresholds) do
		-- we are interested in the highest index that meets the requirements
		if underempire_threshold.required_underempires <= current_underempires then
			active_treshhold_index = index
		end
	end

	for index, underempire_threshold in ipairs(self.underempire_thresholds) do
		core:svr_save_bool(underempire_threshold.battle_parameter, index == active_treshhold_index)
	end
end

episode_vermintide.vermintide_turn_start = function(self)
	local faction = cm:get_faction(episode_vermintide.invasion_faction_key)
	local military_force_list = faction:military_force_list()
	local provinces = faction:provinces()
	local under_cities = faction:foreign_slot_managers()
	local province_list = {}
	local region_list = {}
	local under_city_list = {}
	local total_current_armies = 0
	local armies_spawned_this_turn = 0
	local under_cities_spread_this_turn = 0
	local bad_things_created_this_turn = 0

	for force_index = 0, military_force_list:num_items() - 1 do
		local military_force = military_force_list:item_at(force_index)
		
		if military_force:is_armed_citizenry() == false then
			total_current_armies = total_current_armies + 1
		end
	end

	for province_index = 0, provinces:num_items() - 1 do
		local province = provinces:item_at(province_index)
		local regions = province:regions()
		table.insert(province_list, province)

		for region_index = 0, regions:num_items() - 1 do
			local region = regions:item_at(region_index)
			table.insert(region_list, region)
		end
	end

	for i = 0, under_cities:num_items() - 1 do
		local under_city = under_cities:item_at(i)
		table.insert(under_city_list, under_city)
	end

	local total_allowed_armies = math.floor(#region_list * episode_vermintide.invasion_region_to_force_count)
	total_allowed_armies = math.max(total_allowed_armies, 3)

	-- We want to shuffle the tables as this gives even provinces/regions/foreign slots at the end of the lists a chance to do the chance based rolls
	cm:shuffle_table(province_list)
	cm:shuffle_table(region_list)
	cm:shuffle_table(under_city_list)

	for _, province in ipairs(province_list) do
		local allow_army_spawning = armies_spawned_this_turn < episode_vermintide.invasion_per_turn_spawn_cap and total_current_armies < total_allowed_armies
		local army_spawned = episode_vermintide:update_province(province, allow_army_spawning)

		if army_spawned == true then
			armies_spawned_this_turn = armies_spawned_this_turn + 1
			total_current_armies = total_current_armies + 1
		end
	end

	for _, region in ipairs(region_list) do
		local allow_under_empire_spread = under_cities_spread_this_turn < episode_vermintide.under_empire_spread_per_turn_cap
		local under_empire_spread = episode_vermintide:update_region(region, allow_under_empire_spread)

		if under_empire_spread == true then
			under_cities_spread_this_turn = under_cities_spread_this_turn + 1
		end
	end

	for _, under_city in ipairs(under_city_list) do
		local allow_bad_things = bad_things_created_this_turn < episode_vermintide.under_empire_bad_things_per_turn_cap
		local bad_thing_created = episode_vermintide:update_under_city(under_city, allow_bad_things)

		if bad_thing_created == true then
			bad_things_created_this_turn = bad_things_created_this_turn + 1
		end
	end
end
---------------
-- LISTENERS --
---------------

--skaven_vermintide_FactionTurnStart
core:add_listener(
	"skaven_vermintide_FactionTurnStart",
	"FactionTurnStart",
	function(context)
		return episode_vermintide:is_main_invasion_active()
	end,
	function(context)
		local faction = context:faction()
		local faction_key = faction:name()
		if faction_key == episode_vermintide.invasion_faction_key then
			episode_vermintide:vermintide_turn_start()
			return
		end

		local invasion_faction = cm:get_faction(episode_vermintide.invasion_faction_key)
		if faction:allied_with(invasion_faction)
			or faction:at_war_with(invasion_faction)
			or faction:is_rebel()
		then
			return
		end

		episode_vermintide:declare_war_on_faction_or_overlord(invasion_faction, faction)
		local allied_factions = invasion_faction:factions_allied_with()
		for _, allied_faction in model_pairs(allied_factions) do
			episode_vermintide:declare_war_on_faction_or_overlord(allied_faction, faction)
		end
	end,
	true
)

core:add_listener(
	"skaven_vermintide_FactionTurnStartOthers",
	"FactionTurnStart",
	function(context)
		return episode_vermintide:is_main_invasion_active() and context:faction():name() ~= episode_vermintide.invasion_faction_key
	end,
	function(context)
		local faction = context:faction()
		local region_list = faction:region_list()
		
		for region_index = 0, region_list:num_items() - 1 do
			local current_region = region_list:item_at(region_index)
			local region_key = current_region:name()
			local slots = current_region:slot_list()

			for _, slot in model_pairs(slots) do
				if slot:has_building() == true then
					local building_key = slot:building():name()

					if building_key == "wh3_main_foreign_slot_endgame_2a" then -- Explosives
						episode_vermintide:destroy_under_empire_in_province(current_region:province())
						cm:set_region_abandoned(region_key)
						cm:apply_effect_bundle_to_region("wh3_main_bundle_endgame_prevent_under_empire_razed", region_key, 20)
						break
					elseif building_key == "wh3_main_foreign_slot_endgame_2b" then -- Raid
						episode_vermintide:destroy_under_empire_in_province(current_region:province())
						cm:instantly_dismantle_building_in_region(slot)
						cm:apply_effect_bundle_to_region("wh3_main_bundle_endgame_prevent_under_empire_raid", region_key, 13)
						episode_vermintide:spawn_raid_army(current_region)
						break
					end
				end
			end
		end

		if faction:is_human() == true then
			-- Reveal all Vermintide Under-Cities
			local faction_key = faction:name()
			local invasion_faction = cm:get_faction(episode_vermintide.invasion_faction_key)
			local under_cities = invasion_faction:foreign_slot_managers();

			for under_city_index = 0, under_cities:num_items() - 1 do
				local under_city = under_cities:item_at(under_city_index);
				cm:foreign_slot_set_reveal_to_faction(faction_key, under_city)
			end
		end
	end,
	true
)

--skaven_vermintide_FactionTurnEnd
core:add_listener(
	"skaven_vermintide_FactionTurnEnd",
	"FactionTurnEnd",
	function(context)
		return context:faction():name() == episode_vermintide.invasion_faction_key
	end,
	function(context)
		local all_regions = cm:model():world():region_manager():region_list()
	
		for i = 0, all_regions:num_items() - 1 do
			local region = all_regions:item_at(i)
			local skv_fsm = region:foreign_slot_manager_for_faction(episode_vermintide.invasion_faction_key)

			if skv_fsm:is_null_interface() == true then
				cm:remove_script_state(region, "endgame_skv_steal")
			end
		end
		episode_vermintide:update_endgame_tooltip()
	end,
	true
)

--skaven_vermintide_BattleCompleted
core:add_listener(
	"skaven_vermintide_BattleCompleted",
	"BattleCompleted",
	function()
		local pb = cm:model():pending_battle()
		return episode_vermintide:is_main_invasion_active() and pb:has_been_fought() == true and pb:is_draw() == false
			and cm:pending_battle_cache_faction_is_involved(episode_vermintide.invasion_faction_key)
	end,
	function(context)
		episode_vermintide:update_endgame_tooltip()
		if cm:pending_battle_cache_human_is_involved() == false then
			return
		end 
		-- Immediatly roll the drop chance, so we can potentially save doing everything else
		if cm:model():random_percent(episode_vermintide.war_plans_drop_chance) == false then
			return false
		end

		if cm:pending_battle_cache_faction_is_attacker(episode_vermintide.invasion_faction_key) and cm:pending_battle_cache_attacker_victory() == false then
			for i = 1, cm:pending_battle_cache_num_defenders() do
				local defender_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(i)
				local faction = cm:get_faction(defender_faction_name)

				if faction:is_human() == true then
					cm:trigger_dilemma(defender_faction_name, episode_vermintide.war_plans_dilemma)
					if episode_vermintide.persistent.war_plan_progress == 0 then
						episode_vermintide:play_voiceline("Play_wh3_dlc29_endtimes_narrative_vermintide_skreech_002")
					end
					break
				end
			end
		elseif cm:pending_battle_cache_faction_is_defender(episode_vermintide.invasion_faction_key) and cm:pending_battle_cache_defender_victory() == false then
			for i = 1, cm:pending_battle_cache_num_attackers() do
				local attacker_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(i)
				local faction = cm:get_faction(attacker_faction_name)

				if faction:is_human() == true then
					cm:trigger_dilemma(attacker_faction_name, episode_vermintide.war_plans_dilemma)
					if episode_vermintide.persistent.war_plan_progress == 0 then
						episode_vermintide:play_voiceline("Play_wh3_dlc29_endtimes_narrative_vermintide_skreech_002")
					end
					break
				end
			end
		end
	end,
	true
)

--skaven_vermintide_DilemmaChoiceMadeEvent
core:add_listener(
	"skaven_vermintide_DilemmaChoiceMadeEvent",
	"DilemmaChoiceMadeEvent",
	function(context)
		return context:dilemma() == episode_vermintide.dilemma_join_invasion
	end,
	function(context)
		local faction = context:faction()
		local faction_key = faction:name()
		local choice = context:choice()
		
		if choice == 0 then
			-- Join the Invasion
			cm:force_alliance(faction_key, episode_vermintide.invasion_faction_key, true)

			-- Declare war on everyone you know
			-- at the start of other facton's next turn we will declare war on them as well
			local known_factions = faction:factions_met()

			-- if you postpone the cai analysis you MUST call resume_cai_analysis later!!
			cm:postpone_cai_analysis()
			for i = 0, known_factions:num_items() - 1 do
				local other_faction = known_factions:item_at(i)
				local other_faction_key = other_faction:name()
				if other_faction_key ~= faction_key and other_faction_key ~= episode_vermintide.invasion_faction_key then
					episode_vermintide:declare_war_on_faction_or_overlord(faction, other_faction)
				end
			end
			cm:resume_cai_analysis()

			-- No more diplomacy allowed
			cm:force_diplomacy("all", "faction:"..faction_key, "all", false, false, true)
			cm:force_diplomacy("faction:"..faction_key, "all", "all", false, false, true)
		else
			-- Fight against the Skaven
			local invasion_faction = cm:get_faction(episode_vermintide.invasion_faction_key)
			episode_vermintide:declare_war_on_faction_or_overlord(invasion_faction, faction)
			-- We can now issue relevant missions now we know they are enemies of the invasion
			episode_vermintide:trigger_endgame_missions(faction_key)
			episode_vermintide:unlock_vermintide_buildings(faction_key, true)
		end

		-- We didn't show this player the custom event earlier, so we do it now they've closed the dilemma
		local local_faction_key = cm:get_local_faction_name(true)
	
		if local_faction_key == faction_key then
			episode_vermintide:toggle_endgame_ui()
			episode_vermintide:play_voiceline("Play_wh3_dlc29_endtimes_narrative_vermintide_skreech_001")
		end
	end,
	true
)

--skaven_vermintide_DilemmaChoiceMadeEvent
core:add_listener(
	"skaven_vermintide_DilemmaChoiceMadeEvent",
	"DilemmaChoiceMadeEvent",
	function(context)
		return context:dilemma() == episode_vermintide.war_plans_dilemma
	end,
	function(context)
		if episode_vermintide.persistent.war_plan_progress == 0 then
			episode_vermintide:play_voiceline("Play_wh3_dlc29_endtimes_narrative_vermintide_narrator_004")
		end

		episode_vermintide.persistent.war_plan_progress = episode_vermintide.persistent.war_plan_progress + episode_vermintide.war_plans_progress_increase

		if episode_vermintide.persistent.war_plan_progress >= 100 then
			episode_vermintide.persistent.war_plan_progress = 100
			episodes_manager:advance_stage(episode_vermintide, episode_vermintide.persistent.current_stage_index)
		end
		cm:set_script_state("skaven_war_plans", episode_vermintide.persistent.war_plan_progress or 0)
	end,
	true
)

--skaven_vermintide_MissionSucceeded
core:add_listener(
	"skaven_vermintide_MissionSucceeded",
	"MissionSucceeded",
	function(context)
		-- Player has completed the final battle mission
		return episode_vermintide:is_main_invasion_active() and context:mission():mission_record_key() == episode_vermintide.final_battle_mission_key
	end,
	function(context)
		episodes_manager:advance_stage(episode_vermintide, episode_vermintide.persistent.current_stage_index)

		local faction_key = context:faction():name()
		local human_factions = cm:get_human_factions()

		-- Cancel the same mission that other players might have, its redundant now and episode progress is "shared" anyway
		for i = 1, #human_factions do
			if human_factions[i] ~= faction_key then
				cm:cancel_custom_mission(human_factions[i], episode_vermintide.final_battle_mission_key)
			end
		end
	end,
	true
)

--skaven_vermintide_RegionFactionChangeEvent
core:add_listener(
	"skaven_vermintide_RegionFactionChangeEvent",
	"RegionFactionChangeEvent",
	function(context)
		if episode_vermintide:is_main_invasion_active() == false then
			return false
		end

		return true
	end,
	function(context)
		local region_key = context:region():name()
		-- Check the province to see if the region should change its devastation status
		episode_vermintide:update_province_devastation_for_region(region_key, false)
	end,
	true
)

--skaven_vermintide_PendingBattle
core:add_listener(
	"skaven_vermintide_PendingBattle",
	"PendingBattle",
	function()
		local pb = cm:model():pending_battle();
		return pb:quest_mission_key() == episode_vermintide.final_battle_mission_key
	end,
	function()
		episode_vermintide:set_final_battle_modifiers()

		cm:callback(function()
			episode_chaos_invasion:play_voiceline("Play_wh3_dlc29_endtimes_narrative_vermintide_skreech_003")
		end, 0.5)
	end,
	true
)

cm:add_first_tick_callback(
	function()
		if not episode_vermintide:is_available_this_game() then
			return
		end
		episodes_manager:add_available_episode(episode_vermintide)

		episode_vermintide:generate_armies()

		if episode_vermintide.persistent.legendary_lords == nil then
			-- Track all Skaven Legendary Lords - We'll need their family cqi's later so we can kill them
			episode_vermintide.persistent.legendary_lords = {}
			local invasion_faction = cm:get_faction(episode_vermintide.invasion_faction_key)
			local faction_list = cm:get_factions_by_culture(episode_vermintide.invasion_culture_key)

			for _, faction in ipairs(faction_list) do
				if faction:is_null_interface() == false and faction:is_quest_battle_faction() == false and faction:is_rebel() == false and faction:is_faction(invasion_faction) == false then
					local faction_key = faction:name()
					local character_list = faction:character_list()

					for char_index = character_list:num_items() - 1, 0, -1 do
						local character = character_list:item_at(char_index)
						local character_details = character:character_details()
						local character_subtype = character_details:character_subtype_key()

						-- Check if this character is Legendary
						if episode_vermintide.skaven_legendary_lords[character_subtype] then
							local family_member_cqi = character_details:family_member():command_queue_index()
							episode_vermintide.persistent.legendary_lords[character_subtype] = family_member_cqi
						end
					end
				end
			end
		end
	end
)

episode_vermintide.generate_armies = function(self)
	local ram = random_army_manager
	ram:new_force("SV_skaven")
	ram:new_force("SV_skaven_monsters")
	ram:new_force("SV_skaven_pox")
	ram:new_force("SV_skaven_sneak")
	ram:new_force("SV_skaven_arty")
	ram:new_force("SV_skaven_verminlord")
	
	-- Standard Skaven
	ram:add_mandatory_unit("SV_skaven", "wh3_dlc29_skv_inf_clanrat_spearmen_vermintide", 4)
	ram:add_mandatory_unit("SV_skaven", "wh3_dlc29_skv_inf_clanrats_vermintide", 6)
	ram:add_mandatory_unit("SV_skaven", "wh3_dlc29_skv_inf_skavenslave_slingers_vermintide", 5)
	ram:add_mandatory_unit("SV_skaven", "wh3_dlc29_skv_inf_skavenslave_spearmen_vermintide", 2)
	ram:add_mandatory_unit("SV_skaven", "wh3_dlc29_skv_inf_skavenslaves_vermintide", 2)
	
	ram:add_mandatory_unit("SV_skaven_monsters", "wh3_dlc29_skv_inf_clanrats_vermintide", 6)
	ram:add_mandatory_unit("SV_skaven_monsters", "wh2_dlc16_skv_mon_wolf_rats_0", 6)
	ram:add_mandatory_unit("SV_skaven_monsters", "wh2_main_skv_mon_rat_ogres", 3)
	ram:add_mandatory_unit("SV_skaven_monsters", "wh2_dlc16_skv_mon_brood_horror_0", 2)
	ram:add_mandatory_unit("SV_skaven_monsters", "wh2_main_skv_mon_hell_pit_abomination", 2)

	ram:add_mandatory_unit("SV_skaven_pox", "wh2_main_skv_inf_plague_monks", 6)
	ram:add_mandatory_unit("SV_skaven_pox", "wh2_main_skv_inf_gutter_runner_slingers_1", 3)
	ram:add_mandatory_unit("SV_skaven_pox", "wh2_dlc14_skv_inf_poison_wind_mortar_0", 2)
	ram:add_mandatory_unit("SV_skaven_pox", "wh2_main_skv_inf_warpfire_thrower", 2)
	ram:add_mandatory_unit("SV_skaven_pox", "wh2_main_skv_inf_poison_wind_globadiers", 2)
	ram:add_mandatory_unit("SV_skaven_pox", "wh2_main_skv_inf_death_globe_bombardiers", 2)
	ram:add_mandatory_unit("SV_skaven_pox", "wh3_dlc29_skv_veh_cauldron_of_a_thousand_poxes", 2)

	ram:add_mandatory_unit("SV_skaven_sneak", "wh2_dlc14_skv_inf_eshin_triads_0", 6)
	ram:add_mandatory_unit("SV_skaven_sneak", "wh2_main_skv_inf_death_runners_0", 6)
	ram:add_mandatory_unit("SV_skaven_sneak", "wh2_main_skv_inf_gutter_runners_0", 6)
	ram:add_mandatory_unit("SV_skaven_sneak", "wh3_dlc26_ogr_inf_eshin_maneater_ror", 1)

	ram:add_mandatory_unit("SV_skaven_arty", "wh3_dlc29_skv_inf_clanrats_vermintide", 8)
	ram:add_mandatory_unit("SV_skaven_arty", "wh2_dlc12_skv_inf_ratling_gun_ror_tech_lab_0", 3)
	ram:add_mandatory_unit("SV_skaven_arty", "wh2_dlc12_skv_art_warplock_jezzails_ror_tech_lab_0", 3)
	ram:add_mandatory_unit("SV_skaven_arty", "wh2_main_skv_art_plagueclaw_catapult", 2)
	ram:add_mandatory_unit("SV_skaven_arty", "wh2_main_skv_art_warp_lightning_cannon", 2)
	ram:add_mandatory_unit("SV_skaven_arty", "wh3_dlc29_skv_art_warp_doom_magma_cannon", 1)

	ram:add_mandatory_unit("SV_skaven_verminlord", "wh2_main_skv_inf_stormvermin_0", 4)
	ram:add_mandatory_unit("SV_skaven_verminlord", "wh2_main_skv_inf_stormvermin_1", 4)
	ram:add_mandatory_unit("SV_skaven_verminlord", "wh2_dlc12_skv_inf_ratling_gun_0", 2)
	ram:add_mandatory_unit("SV_skaven_verminlord", "wh2_dlc12_skv_inf_warplock_jezzails_0", 2)
	ram:add_mandatory_unit("SV_skaven_verminlord", "wh3_dlc29_skv_mon_stormfiend_doomflayer_gauntlets", 1)
	ram:add_mandatory_unit("SV_skaven_verminlord", "wh3_dlc29_skv_mon_stormfiend_grinderfists", 1)
	ram:add_mandatory_unit("SV_skaven_verminlord", "wh3_dlc29_skv_mon_stormfiend_ratling_cannons", 1)
	ram:add_mandatory_unit("SV_skaven_verminlord", "wh3_dlc29_skv_mon_stormfiend_shock_gauntlets", 1)
	ram:add_mandatory_unit("SV_skaven_verminlord", "wh3_dlc29_skv_mon_stormfiend_warpfire_projectors", 1)
	ram:add_mandatory_unit("SV_skaven_verminlord", "wh3_dlc29_skv_mon_stormfiend_windlaunchers", 1)
	ram:add_mandatory_unit("SV_skaven_verminlord", "wh2_dlc12_skv_veh_doomwheel_ror_tech_lab_0", 2)
	ram:add_mandatory_unit("SV_skaven_verminlord", "wh2_main_skv_mon_hell_pit_abomination", 1)
	
	-- Create the force strings
	for army_key, army in dpairs(episode_vermintide.skaven_armies) do
		army.units = ram:generate_force("SV_"..army_key, 19, false)
	end
end