bon_effects = {
	volkmar_faction_key = "wh3_main_emp_cult_of_sigmar",
	book_effect_bundles = {
		[3] = {
			"wh2_dlc09_books_of_nagash_reward_3",
			"wh3_main_books_of_nagash_mannfred_studied_reward_3",
			"wh3_main_books_of_nagash_mannfred_reward_3",
			"wh3_dlc29_books_of_nagash_nagash_reward_3"
		}
	},
	sandstorm_duration = 5,
	volkmar_book_resource_key = "wh3_main_emp_volkmar_books_destroyed",
}


function bon_effects:add_listeners()
	core:add_listener(
		"garrison_occupied_event_tmb_create_storm_for_region",
		"GarrisonOccupiedEvent",
		true,
		function(context)			
			self:trigger_book_3_effects(context)
		end,
		true
	)

	core:add_listener(
		"character_sacked_settlement_tmb_create_storm_for_region",
		"CharacterSackedSettlement",
		true,
		function(context)
			self:trigger_book_3_effects(context)
		end,
		true
	)

	core:add_listener(
		"VolkmarBooksOfNagashZeal",
		"ScriptEventBookOfNagashUpdated",
		true,
		function(context)
			local faction_interface = context:faction()
			if faction_interface:name() ~= bon_effects.volkmar_faction_key then
				return
			end

			local new_book_count = context.number
			local resource = faction_interface:pooled_resource_manager():resource(bon_effects.volkmar_book_resource_key)
			local current_book_count = resource:value()
			local book_amount_delta = new_book_count - current_book_count
			if book_amount_delta == 0 then
				return
			end
			
			cm:faction_add_pooled_resource(bon_effects.volkmar_faction_key, bon_effects.volkmar_book_resource_key, "wh3_main_emp_volkmar_books_destroyed", book_amount_delta)
		end,
		true
	)
end


function bon_effects:trigger_book_3_effects(context)
	local faction = context:character():faction()
	local character = context:character()
	local mf = character:military_force()

	if nagash_book_participant_factions[faction:name()] or nagash_book_participant_cultures[faction:culture()] then
		for _, effect_bundle in dpairs(bon_effects.book_effect_bundles[3]) do
			if (mf:has_effect_bundle(effect_bundle)) then
				local region_key = character:region():name()

				cm:create_storm_for_region(region_key, 1, self.sandstorm_duration, "land_storm")

				return true
			end
		end
	end
end