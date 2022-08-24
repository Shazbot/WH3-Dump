

---- Contains various listeners to force-update Dark Authority

dark_authority = {}

dark_authority.valid_cultures = {
	wh_main_chs_chaos = true
}

dark_authority.agent_action_strings = {
	assist_army = true
}


function dark_authority:initialise()
	core:add_listener(
		"dark_authority_character_recruited",
		"CharacterRecruited",
		function(context)
			local character = context:character()
			return self:character_faction_uses_authority(character) and character:has_military_force()
		end,
		function(context)
			self:update_authority(context:character())
		end,
		true
	)

	core:add_listener(
		"dark_authority_character_performs_agent_action",
		"CharacterCharacterTargetAction",
		function(context)
			return self:character_faction_uses_authority(context:character()) and self.agent_action_strings[context:ability()]
		end,
		function(context)
			self:update_authority(context:character())
		end,
		true
	)

	core:add_listener(
		"dark_authority_character_dies",
		"CharacterConvalescedOrKilled",
		function(context)
			local character = context:character()
			return self:character_faction_uses_authority(character) and self:character_is_general_or_embedded(character)
		end,
		function(context)
			self:update_authority(context:character())
		end,
		true
	)

	core:add_listener(
		"dark_authority_character_applies_skill",
		"CharacterSkillPointAllocated",
		function(context)
			local character = context:character()
			return self:character_faction_uses_authority(character) and self:character_is_general_or_embedded(character)
		end,
		function(context)
			self:update_authority(context:character())
		end,
		true
	)

end


function dark_authority:character_is_general_or_embedded(character_interface)
	return character_interface:has_military_force() or character_interface:is_embedded_in_military_force()
end


function dark_authority:update_authority(character_interface)
	local force_interface
	if character_interface:has_military_force() then
		force_interface = character_interface:military_force()
	elseif character_interface:is_embedded_in_military_force() then
		force_interface = character_interface:embedded_in_military_force()
	else
		script_error("ERROR: dark authority: calling a dark authority update on a character that is neither embedded nor a general. Nothing will happen")
		return
	end
	local resource_manager = force_interface:pooled_resource_manager()
	cm:apply_regular_reset_income(resource_manager)
end

function dark_authority:character_faction_uses_authority(character_interface)
	local character_faction_culture = character_interface:faction():culture()
	return self.valid_cultures[character_faction_culture]
end
