glottkin_blessings_of_nurgle_config = {
	faction_key = "wh3_dlc29_chs_host_of_the_triplets",
	progression_pooled_resource_key = "wh3_dlc29_glott_souls",
	progression_ancillary_reward_key = "wh3_dlc29_chs_anc_armour_armour_of_rot_eternal",
	blessings_of_nurgle_unlocked_key = "glottkin_blessings_of_nurgle_unlocked",
	blessings_of_nurgle_unlocked_turn = 3,
	progression_ancillary_unlocked_progression = 4 -- 5th section of the progress bar
}

glottkin_blessings_of_nurgle = {}
glottkin_blessings_of_nurgle.config = glottkin_blessings_of_nurgle_config
glottkin_blessings_of_nurgle.dynamic_data = {}

function glottkin_blessings_of_nurgle:initialise()
	local faction = cm:get_faction(self.config.faction_key)
	local is_unlocked = cm:model():turn_number() >= self.config.blessings_of_nurgle_unlocked_turn
	cm:set_script_state(faction, self.config.blessings_of_nurgle_unlocked_key, is_unlocked)

	if not is_unlocked then
		self:add_unlock_listeners()
	end

	self:add_progression_rewards_listeners()
end

--------------------------------------------------------------
---------------------------- LISTENERS -----------------------
--------------------------------------------------------------

function glottkin_blessings_of_nurgle:add_unlock_listeners()
	core:add_listener(
		"glottkin_blessings_of_nurgle_turn_start",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return faction:name() == self.config.faction_key and
				faction:model():turn_number() == self.config.blessings_of_nurgle_unlocked_turn
		end,
		function(context)
			cm:set_script_state(context:faction(), self.config.blessings_of_nurgle_unlocked_key, true)
		end,
		false
	)
end

function glottkin_blessings_of_nurgle:add_progression_rewards_listeners()
	core:add_listener(
		"glottkin_blessings_of_nurgle_pooled_res_effect_changed",
		"PooledResourceEffectChangedEvent",
		function(context)
			local resource = context:resource()
			local new_effect_split = string.split(context:new_effect(), "_")
			return resource:key() == glottkin_blessings_of_nurgle_config.progression_pooled_resource_key and tonumber(new_effect_split[#new_effect_split]) >= glottkin_blessings_of_nurgle_config.progression_ancillary_unlocked_progression
		end,
		function(context)
			local faction = cm:get_faction(glottkin_blessings_of_nurgle_config.faction_key)
			cm:add_ancillary_to_faction(faction, glottkin_blessings_of_nurgle_config.progression_ancillary_reward_key, false)
		end,
		false
	)
end

--------------------------------------------------------------
---------------------------- UTIL ----------------------------
--------------------------------------------------------------

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

-- cm:add_saving_game_callback(
-- 	function(context)
-- 		cm:save_named_value("BlessingsOfNurgleDynamicData", glottkin_blessings_of_nurgle.dynamic_data, context)
-- 	end
-- )
-- cm:add_loading_game_callback(
-- 	function(context)
-- 		if cm:is_new_game() == false then
-- 			glottkin_blessings_of_nurgle.dynamic_data = cm:load_named_value("BlessingsOfNurgleDynamicData", glottkin_blessings_of_nurgle.dynamic_data, context)
-- 		end
-- 	end
-- )