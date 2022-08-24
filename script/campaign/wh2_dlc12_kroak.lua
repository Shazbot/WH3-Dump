kroak = {
	unlock_rank = 15,
	ai_unlock_turn = 30, -- If there are no player lizardmen, assign kroak to the strongest current lizard faction
	has_spawned = false,

	itza_faction_key = "wh2_main_lzd_itza",

	mission_factions = {
		"wh2_main_lzd_hexoatl",
		"wh2_main_lzd_last_defenders",
		"wh2_dlc12_lzd_cult_of_sotek",
		"wh2_main_lzd_tlaqua",
		"wh2_dlc13_lzd_spirits_of_the_jungle",
		"wh2_dlc17_lzd_oxyotl"
	},

	factions_on_mission = {},

	mission_keys = {
		["wh2_main_lzd_hexoatl"] = "wh3_main_ie_mazdamundi_lord_kroak",
		["wh2_main_lzd_last_defenders"] = "wh3_main_ie_kroqgar_lord_kroak",
		["wh2_dlc12_lzd_cult_of_sotek"] = "wh3_main_ie_tehenhauin_lord_kroak",
		["wh2_main_lzd_tlaqua"] = "wh3_main_ie_tiktaqto_lord_kroak",
		["wh2_dlc13_lzd_spirits_of_the_jungle"] = "wh3_main_ie_nakai_lord_kroak",
		["wh2_dlc17_lzd_oxyotl"] = "wh3_main_ie_qb_oxyotl_lord_kroak",
	}
}


function kroak:add_kroak_listeners()
	out("#### Add Kroak Listeners ####")

	local itza = cm:get_faction(self.itza_faction_key)
	local izta_human = false
	
	if itza then
		izta_human = itza:is_human()
	end

	if cm:is_new_game() and izta_human then
		self:spawn_kroak(self.itza_faction_key)
	elseif izta_human == false then
		for i = 1, #kroak.mission_factions do
			if cm:get_faction(kroak.mission_factions[i]):is_human() then
				-- there's at least 1 human lizard
				self:setup_mission_listeners()
				return
			end
		end

		self:assign_kroak_ai()
	end	
end


function kroak:setup_mission_listeners()
	if self.has_spawned == false then
		for i = 1, #self.mission_factions do
			if cm:get_faction(self.mission_factions[i]):is_human() then
				cm:add_faction_turn_start_listener_by_name(
					"KroakLaunchMission",
					self.mission_factions[i],
					function(context)
						if self.has_spawned == false then
							local faction = context:faction()
							local faction_name = faction:name()

							if self.factions_on_mission[faction_name] ~= true and faction:faction_leader():rank() >= self.unlock_rank then
								self.factions_on_mission[faction_name] = true
								cm:trigger_mission(faction_name, self.mission_keys[faction_name], true)
							end
						end
					end,
					true
				)
			end
		end
	
		core:add_listener(
			"KroakMissionSuccess",
			"MissionSucceeded",
			function(context)
				return context:mission():mission_record_key():find("lord_kroak")
			end,
			function(context)
				local faction_name = context:faction():name()
				self:spawn_kroak(faction_name)

				for k, v in pairs(self.mission_factions) do
					if v ~= faction_name and self.factions_on_mission[v] == true then
						cm:cancel_custom_mission(self.factions_on_mission[v], self.mission_keys[self.factions_on_mission[v]])
					end

					if self.factions_on_mission[v] then
						self.factions_on_mission[v] = false
					end
				end
			end,
			false
		)
	end
end


function kroak:assign_kroak_ai()
	core:add_listener(
		"KroakAISpawn",
		"WorldStartRound",
		function(context)
			return cm:turn_number() >= self.ai_unlock_turn
		end,
		function(context)
			if self.has_spawned == false then
				-- Give Kroak to the current strongest lizardmen faction so that he has the best chance of surviving for a while
				local world = cm:model():world()
				local strongest_lizard = {faction_key = self.itza_faction_key, rank = world:faction_strength_rank(cm:get_faction(self.itza_faction_key))}

				for _, lizard in pairs(self.mission_factions) do
					local faction  = cm:get_faction(lizard)
					local rank = world:faction_strength_rank(faction)

					if rank < strongest_lizard.rank then
						strongest_lizard = {faction_key = lizard, rank = rank}
					end
				end

				self:spawn_kroak(strongest_lizard.faction_key)
			end
		end,
		false
	)
end


function kroak:spawn_kroak(faction)
	if self.has_spawned == false then
		self.has_spawned = true

		core:add_listener(
			"GiveKroakAncillaries",
			"UniqueAgentSpawned",
			function(context)
				return context:unique_agent_details():character():get_surname() == "names_name_894850662";
			end,
			function(context)
				local agent = context:unique_agent_details():character()

				if agent:is_null_interface() == false and agent:character_subtype("wh2_dlc12_lzd_lord_kroak") then
					local cqi = agent:cqi()
					
					cm:replenish_action_points(cm:char_lookup_str(cqi))
					
					cm:callback(function()
						cm:force_add_ancillary(agent, "wh2_dlc12_anc_arcane_item_standard_of_the_sacred_serpent", false, true)
						cm:force_add_ancillary(agent, "wh2_dlc12_anc_armour_glyph_of_potec", false, true)
						cm:force_add_ancillary(agent, "wh2_dlc12_anc_enchanted_item_golden_death_mask", false, true)
						cm:force_add_ancillary(agent, "wh2_dlc12_anc_talisman_amulet_of_itza", false, true)
						cm:force_add_ancillary(agent, "wh2_dlc12_anc_weapon_ceremonial_mace_of_malachite", false, true)
						
						cm:callback(function()
							CampaignUI.ClearSelection()
						end, 0.5)
					end, 0.5)
				end
			end,
			false
		)

		cm:spawn_unique_agent(cm:get_faction(faction):command_queue_index(), "wh2_dlc12_lzd_lord_kroak", true)
	end
end 


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("kroak.factions_on_mission", kroak.factions_on_mission, context)
		cm:save_named_value("kroak.has_spawned", kroak.has_spawned, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			kroak.factions_on_mission = cm:load_named_value("kroak.factions_on_mission", kroak.factions_on_mission, context)
			kroak.has_spawned = cm:load_named_value("kroak.has_spawned", kroak.has_spawned, context)
		end
	end
)