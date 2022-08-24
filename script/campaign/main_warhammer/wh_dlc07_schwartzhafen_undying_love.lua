vlad_isabella = {
	vlad_forename = "names_name_2147345130",
	faction_name = "wh_main_vmp_schwartzhafen",
	melissa_pos = {x = 715, y = 619},
	emmanuelle_pos = {x = 721, y = 619}
}


function vlad_isabella:spawn_hero()	
	local faction = cm:get_faction(self.faction_name)
	local leader = cm:get_closest_character_to_position_from_faction(faction, 626, 248, true)
	local character
	local char_lookup_str

	if(leader:get_forename() == self.vlad_forename) then
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

function vlad_isabella:initialize_vlad_isabella()	
	-- lock the conderation options for rival vampire counts
	if(cm:is_new_game()) then
		cm:force_diplomacy("faction:wh_main_vmp_rival_sylvanian_vamps", "faction:wh_main_vmp_vampire_counts", "form confederation", false, false, true);
		cm:force_diplomacy("faction:wh_main_vmp_rival_sylvanian_vamps", "faction:wh_main_vmp_schwartzhafen", "form confederation", false, false, true);

		vlad_isabella:spawn_hero()
	end
end;