marks_of_cruelty_config = {
	faction_key = "wh3_dlc27_sla_the_tormentors",
	decadence_resource_key = "wh3_dlc27_sla_decadence",

	decadence_required_to_unlock_marks_of_cruelty = 200,

	unlock_shared_state = "marks_of_cruelty_unlocked",

	marks_of_vindictiveness_level_1_recipes = {
		"wh3_dlc27_recipe_mark_of_vindictiveness_pain",
		"wh3_dlc27_recipe_mark_of_vindictiveness_lash",
		"wh3_dlc27_recipe_mark_of_vindictiveness_indolence",
		"wh3_dlc27_recipe_mark_of_vindictiveness_despair",
		"wh3_dlc27_recipe_mark_of_vindictiveness_denial",
		"wh3_dlc27_recipe_mark_of_vindictiveness_ascendancy",
	},

	cai_config = {
		cai_marks_upgrade_cooldown = 5, 
		cai_num_provinces_to_unlock_marks = 1,
		cai_unlock_marks_turn = 20,
	},

	persistent = {
		cai_marks_upgrade_turn = 0, 
		cai_marks_to_upgrade = {},
		cai_has_unlocked_marks = false, 
	}
}

marks_of_cruelty = {}
marks_of_cruelty.config = marks_of_cruelty_config
marks_of_cruelty.unlocked_marks_of_cruelty = false

local function should_unlock_marks(context)
	return context:resource():key() == marks_of_cruelty.config.decadence_resource_key
		and context:faction():name() == marks_of_cruelty.config.faction_key
		and context:resource():value() >= marks_of_cruelty.config.decadence_required_to_unlock_marks_of_cruelty
end

local function unlock_marks(context)
	cm:set_script_state(context:faction(), marks_of_cruelty.config.unlock_shared_state, true)
	marks_of_cruelty.unlocked_marks_of_cruelty = true

	for _, recipe_key in ipairs(marks_of_cruelty.config.marks_of_vindictiveness_level_1_recipes) do
		cm:unlock_cooking_recipe(context:faction(), recipe_key)
	end
end

function marks_of_cruelty:initialise()
	local faction = cm:get_faction(marks_of_cruelty.config.faction_key)
	self.unlocked_marks_of_cruelty = cm:model():shared_states_manager():get_state_as_bool_value(faction, self.config.unlock_shared_state)

	if self.unlocked_marks_of_cruelty then
		return
	end

	core:add_listener(
		"DechalaMarksOfCruelty_PooledResourceChanged",
		"PooledResourceChanged",
		should_unlock_marks,
		function(context)
			unlock_marks(context)
			-- Remove the other (PooledResourceRegularIncome) listener, cause we won't need it.
			core:remove_listener("DechalaMarksOfCruelty_PooledResourceRegularIncome")
		end,
		false
	);

	core:add_listener(
		"DechalaMarksOfCruelty_PooledResourceRegularIncome",
		"PooledResourceRegularIncome",
		should_unlock_marks,
		function(context)
			unlock_marks(context)
			-- Remove the other (PooledResourceChanged) listener, cause we won't need it.
			core:remove_listener("DechalaMarksOfCruelty_PooledResourceChanged")
		end,
		false
	);

	core:add_listener(
		"DechalaMarksOfCruelty_CAICheckIfMarksUnlocked",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return faction and faction:name() == marks_of_cruelty.config.faction_key and faction:is_human() == false
		end,
		function(context)
			if context:faction():complete_provinces():num_items() >= marks_of_cruelty.config.cai_config.cai_num_provinces_to_unlock_marks or cm:turn_number() >= marks_of_cruelty.config.cai_config.cai_unlock_marks_turn then
				marks_of_cruelty.config.persistent.cai_has_unlocked_marks = true
				core:remove_listener("DechalaMarksOfCruelty_CAICheckIfMarksUnlocked")			
			end
		end,
		true
	);

	core:add_listener(
		"DechalaMarksOfCruelty_CAIUpgradeReceipe",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return faction and faction:name() == marks_of_cruelty.config.faction_key and faction:is_human() == false and marks_of_cruelty.config.persistent.cai_has_unlocked_marks == true
		end,
		function(context)
			-- If no marks left to upgrade, fill back the table
			if #marks_of_cruelty.config.persistent.cai_marks_to_upgrade <= 0 then
				marks_of_cruelty.config.persistent.cai_marks_to_upgrade = table.copy(marks_of_cruelty.config.marks_of_vindictiveness_level_1_recipes)	
			end
			
			if cm:turn_number() >= marks_of_cruelty.config.persistent.cai_marks_upgrade_turn then 
				marks_of_cruelty.config.persistent.cai_marks_upgrade_turn = cm:turn_number() + marks_of_cruelty.config.cai_config.cai_marks_upgrade_cooldown
				local rand = cm:random_number(#marks_of_cruelty.config.persistent.cai_marks_to_upgrade, 1)
				local receipe_key = marks_of_cruelty.config.persistent.cai_marks_to_upgrade[rand]
				cm:upgrade_cooking_recipe(context:faction(), receipe_key)
				table.remove(marks_of_cruelty.config.persistent.cai_marks_to_upgrade, rand)
			end		
		end,
		true
	);
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("dechala_cai_marks_of_cruelty", marks_of_cruelty.config.persistent, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			marks_of_cruelty.config.persistent = cm:load_named_value("dechala_cai_marks_of_cruelty", marks_of_cruelty.config.persistent, context)
		end
	end
)