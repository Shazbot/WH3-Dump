vlad_isabella = {
	vlad_subtype = "wh_dlc04_vmp_vlad_con_carstein",
	isabella_subtype = "wh_pro02_vmp_isabella_von_carstein",
	faction_name = "wh_main_vmp_schwartzhafen",
	melissa_pos = {x = 715, y = 619},
	emmanuelle_pos = {x = 721, y = 619},
	vlad_lord_skill = "wh3_main_skill_vmp_vlad_unique_become_lord",
	isabella_lord_skill = "wh3_main_skill_vmp_isabella_unique_become_lord"
}

function vlad_isabella:initialize_vlad_isabella()
	core:add_listener(
		"CharacterSkillPointAllocatedVladIsa",
		"CharacterSkillPointAllocated",
		true,
		function(context)
			if context:skill_point_spent_on() == self.vlad_lord_skill then
				local character = context:character()
				self:respawn_character_as_lord(character, self.vlad_subtype)
			elseif context:skill_point_spent_on() == self.isabella_lord_skill then
				local character = context:character()
				self:respawn_character_as_lord(character, self.isabella_subtype)
			end
		end,
		true
	);

	if cm:is_new_game() == false then
		return false
	end
	
	local faction = cm:get_faction(self.faction_name)
	local leader = cm:get_closest_character_to_position_from_faction(self.faction_name, 626, 248, true)
	local character
	local char_lookup_str

	if leader:character_subtype_key() == self.vlad_subtype then
		-- Spawn Isabella and Kill Melissa
		cm:spawn_unique_agent_at_character(faction:command_queue_index(), "wh_pro02_vmp_isabella_von_carstein_hero", leader:cqi(), true)
		character = cm:get_most_recently_created_character_of_type(self.faction_name, "runesmith", "wh_pro02_vmp_isabella_von_carstein_hero")
		char_lookup_str = cm:char_lookup_str(character)
		cm:force_add_ancillary(character, "wh_pro02_anc_enchanted_item_blood_chalice_of_bathori", true, true)

		local melissa = cm:get_closest_character_to_position_from_faction(self.faction_name, self.melissa_pos.x, self.melissa_pos.y)
		local melissa_cqi = melissa:cqi()
		cm:kill_character(melissa_cqi)
		
		cm:teleport_to(char_lookup_str, self.melissa_pos.x, self.melissa_pos.y)
	else
		-- Spawn Vlad and Kill Emmanuelle
		cm:spawn_unique_agent_at_character(faction:command_queue_index(), "wh_dlc04_vmp_vlad_von_carstein_hero", leader:cqi(), true)
		character = cm:get_most_recently_created_character_of_type(self.faction_name, "runesmith", "wh_dlc04_vmp_vlad_von_carstein_hero")
		char_lookup_str = cm:char_lookup_str(character)
		cm:force_add_ancillary(character, "wh_dlc04_anc_talisman_the_carstein_ring", true, true)
		cm:force_add_ancillary(character, "wh_dlc04_anc_weapon_blood_drinker", true, true)

		local emmanuelle = cm:get_closest_character_to_position_from_faction(self.faction_name, self.emmanuelle_pos.x, self.emmanuelle_pos.y)
		local emmanuelle_cqi = emmanuelle:cqi()
		cm:kill_character(emmanuelle_cqi)
		
		cm:teleport_to(char_lookup_str, self.emmanuelle_pos.x, self.emmanuelle_pos.y)
	end
	
	cm:replenish_action_points(char_lookup_str)
	cm:set_character_immortality(char_lookup_str, true)
	
	CampaignUI.ClearSelection()
end

function vlad_isabella:respawn_character_as_lord(character, new_subtype)

	local faction_key = character:faction():name()
	local faction_cqi = character:faction():command_queue_index() -- incident with target script doesn't take objects
	local character_details = character:character_details()
	local character_cqi = character:command_queue_index()
	local family_member_cqi = character:family_member():command_queue_index()
	local character_level = character:rank()
	local character_traits = character_details:all_traits()
	local forename = character:get_forename()
	local surname = character:get_surname()

	-- When part of Nagash's faction they need nagash name group ids
	if faction_key == "wh3_dlc29_nag_host_of_nagash" then 
		if new_subtype == self.isabella_subtype then
			forename = "names_name_148985317"
		elseif new_subtype == self.vlad_subtype then
			forename = "names_name_785000170"
		end
		surname = "names_name_619441628"
	end

	-- Trigger incident to explain how to recruit your new Lord
	cm:trigger_incident_with_targets(faction_cqi, "wh3_dlc29_vmp_hero_turns_to_lord", 0, 0, character_cqi, 0, 0, 0)

	-- Add the new Lord to the pool with the old name
	local new_lord = cm:spawn_character_to_pool(faction_key, forename, surname, "", "", 21, true, "general", new_subtype, true, "")

	-- Rank them up to their old rank
	cm:character_details_set_rank(new_lord, character_level, true)

	-- Add their old traits
	for i = 1, #character_traits do
		cm:force_add_trait_to_character_details(new_lord, character_traits[i])
	end

	-- Give them their old ancillaries
	cm:reassign_ancillaries_to_character_of_same_faction(character_details, new_lord)

	-- Kill the old agent, we're still inside a character event so we need a tick to happen
	cm:callback(function()
		cm:disable_event_feed_events(true, "all")
		cm:suppress_immortality(family_member_cqi, true)
		cm:kill_character_and_commanded_unit("family_member_cqi:"..family_member_cqi, false, true)
		cm:disable_event_feed_events(false, "all")
	
	end, 0.1);
end