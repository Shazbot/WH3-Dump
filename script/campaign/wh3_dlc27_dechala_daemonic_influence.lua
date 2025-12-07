dechala_daemonic_influence_config = {
	--dechala faction key
	faction_key = "wh3_dlc27_sla_the_tormentors";
	bundle_key = "wh3_dlc27_bundle_force_sla_daemonic_attraction", --all apply to the same bundle
	effect_turns_applied = 0, --infinite
	units_and_campaign_effects_lists = 
	{
		["wh3_dlc27_sla_inf_daemonette_1_dechala"] = "wh3_dlc27_force_initiative_dechala_daemonette_1_attraction",
		["wh3_dlc27_sla_veh_exalted_seeker_chariot_dechala"] = "wh3_dlc27_force_initiative_dechala_exalted_chariot_attraction",
		["wh3_dlc27_sla_mon_fiends_of_slaanesh_dechala"] = "wh3_dlc27_force_initiative_dechala_fiends_attraction",
		["wh3_dlc27_sla_inf_chaos_furies_dechala"] = "wh3_dlc27_force_initiative_dechala_furies_attraction",
		["wh3_dlc27_sla_cav_heartseekers_of_slaanesh_dechala"] = "wh3_dlc27_force_initiative_dechala_heartseekers_attraction",
		["wh3_dlc27_sla_mon_keeper_of_secrets_dechala"] = "wh3_dlc27_force_initiative_dechala_keeper_of_secrets_attraction",
		["wh3_dlc27_sla_cav_pleasureseekers_dechala"] = "wh3_dlc27_force_initiative_dechala_pleasureseekers_attraction",
	},
}

dechala_daemonic_influence = {}
dechala_daemonic_influence.config = dechala_daemonic_influence_config

local function add_custom_bundle_for_found_special_units_in_army(force, disbanded_unit_key)
	local bundle = cm:create_new_custom_effect_bundle(dechala_daemonic_influence.config.bundle_key)
	bundle:set_duration(dechala_daemonic_influence.config.effect_turns_applied)
	--disband unit event is triggered before the unit is removed from the army so we need to excluded it from the effects
	local found_disbanded_unit = false
	local unit_list = force:unit_list()

	for i = 0, unit_list:num_items() - 1 do
		local current_unit = unit_list:item_at(i)
		if found_disbanded_unit or current_unit:unit_key() ~= disbanded_unit_key then
			if dechala_daemonic_influence.config.units_and_campaign_effects_lists[current_unit:unit_key()] then
				local effects_list_to_apply = dechala_daemonic_influence.config.units_and_campaign_effects_lists[current_unit:unit_key()]
				local effects_to_apply = cm:get_effect_list_by_key (effects_list_to_apply)
				for j = 0, effects_to_apply:num_items() - 1 do
					local effect = effects_to_apply:item_at(j)
					bundle:add_effect(effect:key(), effect:scope(), effect:value())
				end
			end
		else
			found_disbanded_unit = true
		end
	end

	--if any effects end up in the bundle then add it (it will automatically remove any previous instances of itself)
	if bundle:effects():num_items() > 0 then
		cm:apply_custom_effect_bundle_to_force(bundle, force)
	else
		cm:remove_effect_bundle_from_force(dechala_daemonic_influence.config.bundle_key, force:command_queue_index())
	end
end


function dechala_daemonic_influence:initialize()

	out("#### Adding Dechala Daemonic Influence Listeners ####");
	local dechala_faction_interface = cm:get_faction(dechala_daemonic_influence.config.faction_key)

	if dechala_faction_interface then
		-- add listener for start of round incrementations
		core:add_listener(
			"DaemonicInfluenceAddedUnit",
			"UnitTrained",
			function(context)
				local faction = context:unit():faction()
				local unit_key = context:unit():unit_key()
				return dechala_daemonic_influence.config.units_and_campaign_effects_lists[unit_key]
						and faction
						and faction:name() == dechala_daemonic_influence.config.faction_key
			end,
			function(context)
				local force = context:unit():military_force()
				if force then
					add_custom_bundle_for_found_special_units_in_army(force, nil)
				end
			end,
			true
		)

		core:add_listener(
			"DaemonicInfluenceRemovedUnit",
			"UnitDisbanded",
			function(context)
				local faction = context:unit():faction()
				local unit_key = context:unit():unit_key()
				return dechala_daemonic_influence.config.units_and_campaign_effects_lists[unit_key]
						and faction
						and faction:name() == dechala_daemonic_influence.config.faction_key
			end,
			function(context)
				local force = context:unit():military_force()
				if force then
					add_custom_bundle_for_found_special_units_in_army(force, context:unit():unit_key())
				end
			end,
			true
		)
		
		core:add_listener(
			"DaemonicInfluenceArmyMergeCompleted",
			"CampaignArmiesMergeCompleted",
			true,
			function(context)
				local target_character = context:target_character()
				local has_compatible_target_force = target_character
														and target_character:faction()
														and target_character:faction():name() == dechala_daemonic_influence.config.faction_key
														and target_character:military_force()

				if has_compatible_target_force then
					local target_force = target_character:military_force()
					if target_force then
						add_custom_bundle_for_found_special_units_in_army(target_force, nil)
					end
				end

				local source_character = context:character()
				local has_compatible_source_force = source_character
														and source_character:faction()
														and source_character:faction():name() == dechala_daemonic_influence.config.faction_key
														and source_character:military_force()
				
				if has_compatible_source_force then
					local source_force = source_character:military_force()
					if source_force then
						add_custom_bundle_for_found_special_units_in_army(source_force, nil)
					end
				end
			end,
			true
		)
		
		core:add_listener(
			"DaemonicInfluenceUnitsDiedInBattle",
			"BattleCompleted",
			function()
				local pb = cm:model():pending_battle()
				return pb:has_been_fought() and cm:pending_battle_cache_faction_is_involved(dechala_daemonic_influence.config.faction_key)
			end,
			function()
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i)
					if dechala_daemonic_influence.config.faction_key == current_faction_name then
						local mf = cm:get_military_force_by_cqi(current_mf_cqi)
						if mf then
							add_custom_bundle_for_found_special_units_in_army(mf, nil)
						end
						return
					end
				end

				for i = 1, cm:pending_battle_cache_num_defenders() do
					local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i)
					if dechala_daemonic_influence.config.faction_key == current_faction_name then
						local mf = cm:get_military_force_by_cqi(current_mf_cqi)
						if mf then
							add_custom_bundle_for_found_special_units_in_army(mf, nil)
						end
						return
					end
				end
			end,
			true
		)
		--pass all the units and effect_lists to script/shared state
		for unit_key, effect_list_key in dpairs(dechala_daemonic_influence.config.units_and_campaign_effects_lists) do
			cm:set_script_state(dechala_faction_interface, "daemonic_influence_" .. unit_key, effect_list_key)
		end
	end
end