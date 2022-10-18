---Scripted occupation options

scripted_occupation_options = {
	option_ids_to_option_sets = {
		["1067868589"] = "forced_confederate"
	},

	option_sets_callbacks = {
		forced_confederate = 
			function(context) 
				local subjugated_faction = context:garrison_residence():faction()
				local subjugated_faction_characters = subjugated_faction:character_list()
				local subjugating_faction_key = context:character():faction():name()
				for k, character in model_pairs(subjugated_faction_characters) do

					local character_details = character:character_details()
					local fm_cqi = character:family_member():command_queue_index()

					if fm_cqi and character_details and not (character:is_faction_leader() or character_details:is_unique()) then
						cm:suppress_immortality(fm_cqi, true)
					end

					cm:kill_character_and_commanded_unit("family_member_cqi:"..fm_cqi, true)
			
				end
				cm:force_confederation(subjugating_faction_key, context:previous_owner())
			end
	},

}

function scripted_occupation_options:initialise()
	core:add_listener(
			"scripted_occupation_options",
			"CharacterPerformsSettlementOccupationDecision",
			function(context)
				return self.option_ids_to_option_sets[context:occupation_decision()]
			end,
			function(context)
				local option_set = self.option_ids_to_option_sets[context:occupation_decision()]
				self.option_sets_callbacks[option_set](context)
			end,
			true
		)
end
