nagash_rors = {
	faction_key = "wh3_dlc29_nag_host_of_nagash",
	rituals = {
		["wh3_dlc29_nag_mortarchs_arkhan"] = "wh2_dlc09_tmb_followers_of_nagash",
		["wh3_dlc29_nag_mortarchs_mannfred"] = "wh_main_vmp_vampire_counts",
		["wh3_dlc29_nag_mortarchs_luthor"] = "wh2_dlc11_cst_vampire_coast"
	},
	agents = {
		["wh2_dlc09_tmb_arkhan"] = "wh2_dlc09_tmb_followers_of_nagash",
		["wh_main_vmp_mannfred_von_carstein"] = "wh_main_vmp_vampire_counts",
		["wh2_dlc11_cst_harkon"] = "wh2_dlc11_cst_vampire_coast"
	},
	unit_locks = {
		["wh2_dlc09_tmb_followers_of_nagash"] = {
			"wh2_dlc09_tmb_inf_skeleton_spearmen_ror",
			"wh2_dlc09_tmb_inf_skeleton_archers_ror",
			"wh2_dlc09_tmb_inf_tomb_guard_ror",
			"wh2_dlc09_tmb_mon_ushabti_ror",
			"wh3_dlc29_tmb_mon_ushabti_ror_sepulchrex",
			"wh2_dlc09_tmb_mon_sepulchral_stalkers_ror",
			"wh2_dlc09_tmb_mon_necrosphinx_ror",					
			"wh3_dlc29_tmb_mon_khemric_titan_ror"
		},
		["wh_main_vmp_vampire_counts"] = {
			"wh_dlc04_vmp_inf_tithe_0",
			"wh_dlc04_vmp_inf_konigstein_stalkers_0",
			"wh_dlc04_vmp_mon_direpack_0",
			"wh_dlc04_vmp_inf_feasters_in_the_dusk_0",
			"wh_dlc04_vmp_inf_sternsmen_0",
			"wh_dlc04_vmp_cav_vereks_reavers_0",
			"wh_dlc04_vmp_cav_chillgheists_0",
			"wh_dlc04_vmp_mon_devils_swartzhafen_0",
			"wh_dlc04_vmp_veh_claw_of_nagash_0"
		},
		["wh2_dlc11_cst_vampire_coast"] = {
			"wh2_dlc11_cst_inf_zombie_deckhands_mob_ror_0",
			"wh2_dlc11_cst_cav_deck_droppers_ror_0",
			"wh2_dlc11_cst_inf_zombie_gunnery_mob_ror_0",
			"wh2_dlc11_cst_inf_deck_gunners_ror_0",
			"wh2_dlc11_cst_mon_mournguls_ror_0",
			"wh2_dlc11_cst_inf_depth_guard_ror_0",
			"wh2_dlc11_cst_art_queen_bess",
			"wh2_dlc11_cst_mon_necrofex_colossus_ror_0",
			"wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_ror"
		}
	},
	tooltip_prefix = "wh3_dlc29_nagash_ror_lock_tooltip_"
}

function nagash_rors:nagash_rors_initialise()
	core:add_listener(
		"nag_rors_start",
		"WorldStartRound",
		function(context)
			return cm:turn_number() == 1
		end,
		function(context)
			for faction_key, unit_list in dpairs(self.unit_locks) do
				local faction = cm:get_faction(faction_key)

				if faction:is_human() == false and faction:was_confederated() == false then
					for _, unit in dpairs(unit_list) do
						cm:add_event_restricted_unit_record_for_faction(unit, self.faction_key, self.tooltip_prefix..faction_key)
					end
				end
			end	
		end,
		false
	)

	core:add_listener(
		"nag_rors_unlock",
		"RitualCompletedEvent",
		function(context)
			return self.rituals[context:ritual():ritual_key()]
		end,
		function(context)
			local unit_list = self.unit_locks[self.rituals[context:ritual():ritual_key()]]

			for _, unit in dpairs(unit_list) do
				cm:remove_event_restricted_unit_record_for_faction(unit, self.faction_key)
			end
		end,
		true
	)

	core:add_listener(
		"nag_rors_confederation",
		"FactionJoinsConfederation",
		true,
		function(context)
			-- When a faction joins a confederation, we check if any of the ror lock mortarchs have joined a human faction as part of that merge.
			-- If they have we just unlock their units as Nagash will no longer be able to confederate them.
			local faction = context:confederation()
			
			if faction:name() ~= self.faction_key and faction:is_human() == true then
				local character_list = faction:character_list()

				for i = 0, character_list:num_items() - 1 do
					local character = character_list:item_at(i)

					for subtype_key, faction_key in dpairs(self.agents) do
						if character:character_subtype_key() == subtype_key then
							local unit_list = self.unit_locks[faction_key]

							for _, unit in dpairs(unit_list) do
								cm:remove_event_restricted_unit_record_for_faction(unit, self.faction_key)
							end
						end
					end
				end
			end
		end,
		true
	)
end