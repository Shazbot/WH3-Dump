pre_battle_challenges = {
	defeated_target_bundle_key = "wh3_dlc27_pre_battle_challenges_defeated_target",
}

function pre_battle_challenges:initialise()
	core:add_listener(
		"pre_battle_challenges_defeated_target",
		"CharacterPreBattleChallenge",
		function(context)
			return context:is_successful()
		end,
		function(context)
			local target = context:target_character()
			local target_force = target:military_force()
			cm:apply_effect_bundle_to_force(pre_battle_challenges.defeated_target_bundle_key, target_force:command_queue_index(), 0)
		end,
		true
	)
end