local PEASANTS_EFFECT_PREFIX = "wh_dlc07_bundle_peasant_penalty_"
local show_peasant_debug = false

PEASANTS_PER_REGION = 2
Bretonnia_Peasant_Units = {
	["wh_dlc07_brt_art_blessed_field_trebuchet_0"] = 1,
	["wh_dlc07_brt_inf_battle_pilgrims_0"] = 1,
	["wh_dlc07_brt_inf_foot_squires_0"] = 1,
	["wh_dlc07_brt_inf_grail_reliquae_0"] = 1,
	["wh_dlc07_brt_inf_men_at_arms_1"] = 1,
	["wh_dlc07_brt_inf_men_at_arms_2"] = 1,
	["wh_dlc07_brt_inf_spearmen_at_arms_1"] = 1,
	["wh_dlc07_brt_peasant_mob_0"] = 1,
	["wh_dlc07_brt_inf_peasant_bowmen_1"] = 1,
	["wh_dlc07_brt_inf_peasant_bowmen_2"] = 1,
	["wh_main_brt_art_field_trebuchet"] = 1,
	["wh_main_brt_cav_mounted_yeomen_0"] = 1,
	["wh_main_brt_cav_mounted_yeomen_1"] = 1,
	["wh_main_brt_inf_men_at_arms"] = 1,
	["wh_main_brt_inf_peasant_bowmen"] = 1,
	["wh_main_brt_inf_spearmen_at_arms"] = 1
}

function Add_Peasant_Economy_Listeners()
	out("#### Adding Peasant Economy Listeners ####")
	
	if not cm:are_any_factions_human(nil, "wh_main_brt_bretonnia") then
		return
	end
	
	core:add_listener(
		"BRT_Peasant_FactionTurnStart",
		"ScriptEventHumanFactionTurnStart",
		true,
		function(context) Calculate_Economy_Penalty(context:faction()) end,
		true
	)
	
	core:add_listener(
		"BRT_Peasant_UnitMergedAndDestroyed",
		"UnitMergedAndDestroyed",
		true,
		function(context)
			local faction = context:new_unit():faction()
			cm:callback(function() Calculate_Economy_Penalty(faction) end, 0.5)
		end,
		true
	)
	
	core:add_listener(
		"BRT_Peasant_UnitDisbanded",
		"UnitDisbanded",
		true,
		function(context)
			local faction = context:unit():faction()
			cm:callback(function() Calculate_Economy_Penalty(faction) end, 0.5)
		end,
		true
	)
	
	core:add_listener(
		"BRT_Peasant_FactionJoinsConfederation",
		"FactionJoinsConfederation",
		true,
		function(context) Calculate_Economy_Penalty(context:confederation()) end,
		true
	)
	
	core:add_listener(
		"BRT_Peasant_BattleCompleted",
		"BattleCompleted",
		true,
		function()
			for i = 1, cm:pending_battle_cache_num_attackers() do
				local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(i)
				local faction = cm:get_faction(attacker_name)
				if faction then
					Calculate_Economy_Penalty(faction)
				end
			end
			for i = 1, cm:pending_battle_cache_num_defenders() do
				local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(i)
				local faction = cm:get_faction(defender_name)
				if faction then
					Calculate_Economy_Penalty(faction)
				end
			end
		end,
		true
	)
	
	core:add_listener(
		"peasant_warning_event_cooldown_expired",
		"ScriptEventPeasantWarningEventCooldownExpired",
		true,
		function(context) cm:set_saved_value("peasant_warning_event_shown_" .. context.string, false) end,
		true
	)
	
	local human_factions = cm:get_human_factions()
	
	for i = 1, #human_factions do
		local current_human_faction = cm:get_faction(human_factions[i])
		
		if not current_human_faction:is_dead() then
			Calculate_Economy_Penalty(current_human_faction)
		end
	end
end

function Calculate_Economy_Penalty(faction)
	if faction:culture() == "wh_main_brt_bretonnia" and faction:is_human() then
		output_P("---- Calculate_Economy_Penalty ----")
		local faction_name = faction:name()
		local peasant_count = 0
		local force_list = faction:military_force_list()
		local region_count = faction:region_list():num_items()
		
		for i = 0, force_list:num_items() - 1 do
			local force = force_list:item_at(i)
			
			-- Make sure this isn't a garrison!
			if not force:is_armed_citizenry() and force:has_general() then
				local unit_list = force:unit_list()
				
				for j = 0, unit_list:num_items() - 1 do
					local key = unit_list:item_at(j):unit_key()
					local val = Bretonnia_Peasant_Units[key] or 0
					
					output_P("\t" .. key .. " - " .. val)
					peasant_count = peasant_count + val
				end
			end
		end
		
		output_P("\tPeasants: " .. peasant_count)
		
		common.set_context_value("peasant_count_" .. faction_name, peasant_count)
		
		Remove_Economy_Penalty(faction)
		
		local peasants_per_region_fac = PEASANTS_PER_REGION + cm:get_factions_bonus_value(faction, "peasant_increase_per_region")
		local peasants_base_amount_fac = cm:get_factions_bonus_value(faction, "peasant_increase_base_amount")
		
		-- Make sure player has regions
		if region_count < 1 then
			peasants_base_amount_fac = 0
		end
		
		local free_peasants = (region_count * peasants_per_region_fac) + peasants_base_amount_fac
		free_peasants = math.max(1, free_peasants)
		output_P("Free Peasants: " .. free_peasants)
		
		common.set_context_value("peasant_cap_" .. faction_name, free_peasants)
		
		local peasant_percent = (peasant_count / free_peasants) * 100
		output_P("Peasant Percent: " .. peasant_percent .. "%")
		peasant_percent = math.round(peasant_percent)
		output_P("Peasant Percent Rounded: " .. peasant_percent .. "%")
		peasant_percent = math.min(peasant_percent, 200)
		output_P("Peasant Percent Clamped: " .. peasant_percent .. "%")
		
		if peasant_percent > 100 then
			peasant_percent = peasant_percent - 100
			output_P("Peasant Percent Final: " .. peasant_percent)
			cm:apply_effect_bundle(PEASANTS_EFFECT_PREFIX .. peasant_percent, faction_name, 0)
			
			if cm:get_saved_value("ScriptEventNegativePeasantEconomy") ~= true and faction:is_human() then
				core:trigger_event("ScriptEventNegativePeasantEconomy")
				cm:set_saved_value("ScriptEventNegativePeasantEconomy", true)
			end
			
			local peasants_ratio_positive = cm:get_saved_value("peasants_ratio_positive_" .. faction_name)
			
			if (peasants_ratio_positive or peasants_ratio_positive == nil) and not cm:get_saved_value("peasant_warning_event_shown_" .. faction_name) then
				cm:show_message_event(
					faction_name,
					"event_feed_strings_text_wh_dlc07_event_feed_string_scripted_event_peasant_negative_title",
					"event_feed_strings_text_wh_dlc07_event_feed_string_scripted_event_peasant_negative_primary_detail",
					"event_feed_strings_text_wh_dlc07_event_feed_string_scripted_event_peasant_negative_secondary_detail",
					true,
					703
				)
				
				cm:set_saved_value("peasant_warning_event_shown_" .. faction_name, true)
				
				cm:add_turn_countdown_event(faction_name, 25, "ScriptEventPeasantWarningEventCooldownExpired", faction_name)
			end
			
			cm:set_saved_value("peasants_ratio_positive_" .. faction_name, false)
		else
			output_P("Peasant Percent Final: 0")
			cm:apply_effect_bundle(PEASANTS_EFFECT_PREFIX .. "0", faction_name, 0)
			
			if cm:get_saved_value("ScriptEventNegativePeasantEconomy") == true and cm:get_saved_value("ScriptEventPositivePeasantEconomy") ~= true and faction:is_human() then
				core:trigger_event("ScriptEventPositivePeasantEconomy")
				cm:set_saved_value("ScriptEventPositivePeasantEconomy", true)
			end
			
			cm:set_saved_value("peasants_ratio_positive_" .. faction_name, true)
		end
	end
end

function Remove_Economy_Penalty(faction)
	output_P("---- Remove_Economy_Penalty ----")
	for i = 0, 100 do
		local bundle = PEASANTS_EFFECT_PREFIX .. i
		
		if faction:has_effect_bundle(bundle) then
			cm:remove_effect_bundle(bundle, faction:name())
		end
	end
end

function Is_Peasant_Unit(unit_key)
	local val = Bretonnia_Peasant_Units[unit_key] or 0
	
	return val > 0
end

function output_P(txt)
	if show_peasant_debug then
		out(txt)
	end
end