fragments_of_sorcery =
{
	config =
	{
		target_faction_key = "wh3_main_tze_oracles_of_tzeentch",
		target_character_subtype_key = "wh3_main_tze_kairos",
		default_spell_type = "tzeentch",
		spell_sets =
		{
			{
				unlocked_at_rank = 1,
				initiative_set_key = "wh3_main_character_initiative_set_kairos_spells_common_1",
			},
			{
				unlocked_at_rank = 1,
				initiative_set_key = "wh3_main_character_initiative_set_kairos_spells_common_2",
			},
			{
				unlocked_at_rank = 5,
				initiative_set_key = "wh3_main_character_initiative_set_kairos_spells_uncommon_1",
			},
			{
				unlocked_at_rank = 10,
				initiative_set_key = "wh3_main_character_initiative_set_kairos_spells_uncommon_2",
			},
			{
				unlocked_at_rank = 15,
				initiative_set_key = "wh3_main_character_initiative_set_kairos_spells_rare_1",
			},
			{
				unlocked_at_rank = 20,
				initiative_set_key = "wh3_main_character_initiative_set_kairos_spells_rare_2",
			},
		},
	},
}

function fragments_of_sorcery:initialise()
	local faction = cm:get_faction(self.config.target_faction_key)
	if not faction or faction:is_null_interface() then
		return
	end

	if cm:is_new_game() then
		local character = faction:faction_leader()
		if not character or character:is_null_interface() then
			return
		end

		self:initialise_default_spells(character)
	end

	self:add_listeners()
end

function fragments_of_sorcery:add_listeners()
	core:add_listener(
		"FragmentsOfSorcery_FactionJoinsConfederation",
		"FactionJoinsConfederation",
		true,
		function(context)
			local characters = context:confederation():character_list()
			for i = 0, characters:num_items() - 1 do
				local character = characters:item_at(i)
				if character:character_subtype_key() == self.config.target_character_subtype_key then
					self:initialise_default_spells(character)
					break
				end
			end
		end,
		true
	)

	core:add_listener(
		"FragmentsOfSorcery_CharacterSkillPointAllocated",
		"CharacterSkillPointAllocated",
		true,
		function(context)
			local character = context:character()
			if character:character_subtype_key() == self.config.target_character_subtype_key then
				self:initialise_default_spells(character)
			end
		end,
		true
	)
end

function fragments_of_sorcery:initialise_default_spells(character)
	local character_details = character:character_details()
	local current_rank = character:rank()

	for _, spell_set in ipairs(self.config.spell_sets) do
		if spell_set.unlocked_at_rank == current_rank then
			local initiative_set = character_details:lookup_character_initiative_set_by_key(spell_set.initiative_set_key)
			-- activate default spell if there's no active spells in the spell-set
			if initiative_set and not initiative_set:is_null_interface() and initiative_set:active_initiatives():num_items() < 1 then
				for _, initiative in model_pairs(initiative_set:all_initiatives()) do
					local initiative_key = initiative:record_key()
					if string.find(initiative_key, self.config.default_spell_type) ~= nil
						and not initiative:is_active()
					then
						if initiative:is_script_locked() then
							cm:toggle_initiative_script_locked(initiative_set, initiative_key, false)
						end

						cm:toggle_initiative_active(initiative_set, initiative_key, true, 0)
						break
					end
				end
			end
		end
	end
end
