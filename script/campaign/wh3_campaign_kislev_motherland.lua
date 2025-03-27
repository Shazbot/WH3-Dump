local faction_key_orthodoxy = "wh3_main_ksl_the_great_orthodoxy";
local faction_key_ice_court = "wh3_main_ksl_the_ice_court";
local faction_key_boris = "wh3_main_ksl_ursun_revivalists";
local faction_key_ostankya = "wh3_dlc24_ksl_daughters_of_the_forest";
local kislev_subculture_key = "wh3_main_sc_ksl_kislev";
local kislev_support_battle_amount = 10;
local kislev_chaos_battle_amount = 10;
local kislev_support_warning_orthodoxy_key = "wh3_main_ksl_orthodoxy_warning";
local kislev_support_warning_ice_court_key = "wh3_main_ksl_ice_court_warning";
local kislev_support_neglect_orthodoxy_key = "wh3_main_ksl_orthodoxy_neglect";
local kislev_support_neglect_ice_court_key = "wh3_main_ksl_ice_court_neglect";
local kislev_neglect_time = 0;
local kislev_support_dilemma = "wh3_main_dilemma_kislev_support";
local kislev_support_dilemma_turn = 5;
local kislev_boon_incident = "wh3_main_incident_ksl_boon_cost";
local kislev_boon_incident_level = 20;
local kislev_boon_incident_effect = "wh3_main_ksl_boon_cost";
local kislev_devotion_amount_declare_war_on_kislev = -10;

function setup_kislev_motherland()
	if cm:is_new_game() then
		-- Katarin Starting Support
		cm:faction_add_pooled_resource(faction_key_orthodoxy, "wh3_main_ksl_support_tracker_orthodoxy", "faction", 40);
		cm:faction_add_pooled_resource(faction_key_orthodoxy, "wh3_main_ksl_support_tracker_ice_court", "faction", 20);
		-- Kostaltyn Starting Support
		cm:faction_add_pooled_resource(faction_key_ice_court, "wh3_main_ksl_support_tracker_orthodoxy", "faction", 20);
		cm:faction_add_pooled_resource(faction_key_ice_court, "wh3_main_ksl_support_tracker_ice_court", "faction", 40);
		-- Boris Ursus Starting Support
		cm:faction_add_pooled_resource(faction_key_boris, "wh3_main_ksl_support_tracker_orthodoxy", "faction", 30);
		cm:faction_add_pooled_resource(faction_key_boris, "wh3_main_ksl_support_tracker_ice_court", "faction", 30);
		-- Mother Ostankya Starting Support
		cm:faction_add_pooled_resource(faction_key_ostankya, "wh3_main_ksl_support_tracker_orthodoxy", "faction", 30);
		cm:faction_add_pooled_resource(faction_key_ostankya, "wh3_main_ksl_support_tracker_ice_court", "faction", 30);
	end

	SetCourtDifferenceAllowedContext();

	core:add_listener(
		"kislev_support_resource",
		"PooledResourceChanged",
		function(context)
			if context:has_faction() == true and context:faction():is_null_interface() == false then
				local pr = context:resource();

				return context:faction():is_human() and (pr:key() == "wh3_main_ksl_support_tracker_orthodoxy" or pr:key() == "wh3_main_ksl_support_tracker_ice_court");
			end
			return false;
		end,
		function(context)
			calculate_kislev_support_state(context:faction());
		end,
		true
	);

	core:add_listener(
		"KislevBuildingCompleted",
		"BuildingCompleted",
		function(context)
			return context:building():name() == "wh3_main_special_ksl_kislev_1_4"
		end,
		function(context)
			calculate_kislev_support_state(context:building():faction());
			SetCourtDifferenceAllowedContext();
		end,
		true
	);
	
	core:add_listener(
		"KislevCharacterSkillPointAllocated",
		"CharacterSkillPointAllocated",
		function(context)
			return context:skill_point_spent_on() == "wh3_main_skill_ksl_kostaltyn_unique_06" or
			context:skill_point_spent_on() == "wh3_main_skill_ksl_kostaltyn_unique_orthodox_religion" or
			context:skill_point_spent_on() == "wh3_main_skill_ksl_katarin_unique_05";
		end,
		function(context)
			calculate_kislev_support_state(context:character():faction());
			SetCourtDifferenceAllowedContext();
		end,
		true
	);
	
	core:add_listener(
		"kislev_level_resource",
		"PooledResourceChanged",
		function(context)
			if context:has_faction() == true and context:faction():is_null_interface() == false and context:faction():has_effect_bundle(kislev_boon_incident_effect) == false then
				local pr = context:resource();

				return context:faction():is_human() and (pr:key() == "wh3_main_ksl_support_level_orthodoxy" or pr:key() == "wh3_main_ksl_support_level_ice_court");
			end
			return false;
		end,
		function(context)
			local faction = context:faction();
			local support_orthodoxy = faction:pooled_resource_manager():resource("wh3_main_ksl_support_level_orthodoxy"):value();
			local support_ice_court = faction:pooled_resource_manager():resource("wh3_main_ksl_support_level_ice_court"):value();

			if support_orthodoxy >= kislev_boon_incident_level or support_ice_court >= kislev_boon_incident_level then
				cm:trigger_incident(faction:name(), kislev_boon_incident, true, true);
			end
		end,
		true
	);

	core:add_listener(
		"AtamanCharacterTurnStart",
		"CharacterTurnStart",
		function(context)
			local character = context:character();
			return character:has_region() == true and character:is_wounded() == false and character:character_subtype("wh3_main_ksl_ataman");
		end,
		function(context)
			local character = context:character();
			local bonus_value = character:region():faction_province():bonus_values():scripted_value("ataman_trait_chance", "value");

			if bonus_value > 0 then
				if cm:model():random_percent(bonus_value) then
					cm:force_add_trait("character_cqi:"..character:cqi(), "wh3_main_trait_ataman_training", true, 1);
				end
			end
		end,
		true
	);

	core:add_listener(
		"kislev_support_battle",
		"BattleCompleted",
		function()
			return cm:model():pending_battle():has_been_fought();
		end,
		function()
			local attacker_won = cm:model():pending_battle():attacker_won();
			local faction_orthodoxy = cm:get_faction(faction_key_orthodoxy);
			local faction_ice_court = cm:get_faction(faction_key_ice_court);
			local chaos_attacker = false;
			local chaos_defender = false;
			local attacker_orthodoxy_enemy = false;
			local attacker_ice_court_enemy = false;
			local defender_orthodoxy_enemy = false;
			local defender_ice_court_enemy = false;
			
			for i = 1, cm:pending_battle_cache_num_attackers() do
				local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i);
				local attacker_faction = cm:get_faction(faction_name);
				
				if attacker_faction then
					if IsChaosCulture(attacker_faction) then
						chaos_attacker = true;
					end
					if attacker_faction:at_war_with(faction_orthodoxy) then
						attacker_orthodoxy_enemy = true;
					end
					if attacker_faction:at_war_with(faction_ice_court) then
						attacker_ice_court_enemy = true;
					end
				end
			end
			
			for i = 1, cm:pending_battle_cache_num_defenders() do
				local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i);
				local defender_faction = cm:get_faction(faction_name);
				
				if defender_faction then
					if IsChaosCulture(defender_faction) then
						chaos_defender = true;
					end
					if defender_faction:at_war_with(faction_orthodoxy) then
						defender_orthodoxy_enemy = true;
					end
					if defender_faction:at_war_with(faction_ice_court) then
						defender_ice_court_enemy = true;
					end
				end
			end

			for i = 1, cm:pending_battle_cache_num_attackers() do
				local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i);
				local attacker_faction = cm:get_faction(faction_name);
				
				if attacker_faction then
					local actual_amount = kislev_support_battle_amount;

					if attacker_faction:has_effect_bundle(kislev_boon_incident_effect) then
						actual_amount = actual_amount + 5;
					end

					if IsKislevButNotIceCourt(attacker_faction) then
						if defender_ice_court_enemy == true then
							if attacker_won == true then
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_ice_court", "battles_against_ice_court_enemies", actual_amount);
							else
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_ice_court", "battles_against_ice_court_enemies", actual_amount - 5);
							end
						end
					end
					
					if IsKislevButNotOrthodoxy(attacker_faction) then
						if defender_orthodoxy_enemy == true then
							if attacker_won == true then
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_orthodoxy", "battles_against_orthodoxy_enemies", actual_amount);
							else
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_orthodoxy", "battles_against_orthodoxy_enemies", actual_amount - 5);
							end
						end
					end

					if chaos_defender == true then
						if IsKislevButNotOrthodoxy(attacker_faction) then
							if attacker_won == true then
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_ice_court", "battles_against_chaos", kislev_chaos_battle_amount);
							else
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_ice_court", "battles_against_chaos", kislev_chaos_battle_amount - 5);
							end
						end
						if IsKislevButNotIceCourt(attacker_faction) then
							if attacker_won == true then
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_orthodoxy", "battles_against_chaos", kislev_chaos_battle_amount);
							else
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_orthodoxy", "battles_against_chaos", kislev_chaos_battle_amount - 5);
							end
						end
					end
				end
			end
			
			for i = 1, cm:pending_battle_cache_num_defenders() do
				local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i);
				local defender_faction = cm:get_faction(faction_name);
				
				if defender_faction then
					local actual_amount = kislev_support_battle_amount;

					if defender_faction:has_effect_bundle(kislev_boon_incident_effect) then
						actual_amount = actual_amount + 5;
					end

					if IsKislevButNotIceCourt(defender_faction) then
						if attacker_ice_court_enemy == true then
							if attacker_won == true then
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_ice_court", "battles_against_ice_court_enemies", actual_amount - 5);
							else
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_ice_court", "battles_against_ice_court_enemies", actual_amount);
							end
						end
					end
					
					if IsKislevButNotOrthodoxy(defender_faction) then
						if attacker_orthodoxy_enemy == true then
							if attacker_won == true then
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_orthodoxy", "battles_against_orthodoxy_enemies", actual_amount - 5);
							else
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_orthodoxy", "battles_against_orthodoxy_enemies", actual_amount);
							end
						end
					end

					if chaos_attacker == true then
						if IsKislevButNotOrthodoxy(defender_faction) then
							if attacker_won == true then
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_ice_court", "battles_against_chaos", kislev_chaos_battle_amount - 5);
							else
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_ice_court", "battles_against_chaos", kislev_chaos_battle_amount);
							end
						end
						if IsKislevButNotIceCourt(defender_faction) then
							if attacker_won == true then
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_orthodoxy", "battles_against_chaos", kislev_chaos_battle_amount - 5);
							else
								cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_support_tracker_orthodoxy", "battles_against_chaos", kislev_chaos_battle_amount);
							end
						end
					end
				end
			end
		end,
		true
	);

	core:add_listener(
		"kislev_start_support",
		"FactionTurnStart",
		function(context)
			return context:faction():subculture() == kislev_subculture_key;
		end,
		function(context)
			local faction = context:faction();

			if faction:is_human() == true then
				calculate_kislev_support_state(faction);

				if cm:turn_number() == kislev_support_dilemma_turn then
					cm:trigger_dilemma_raw(faction:name(), kislev_support_dilemma, true, true);
				end

				if faction:has_effect_bundle(kislev_support_neglect_ice_court_key) == true then
					kislev_neglect_time = kislev_neglect_time + 1;
					update_kislev_support_effect(faction, kislev_support_neglect_ice_court_key);
				elseif faction:has_effect_bundle(kislev_support_neglect_orthodoxy_key) == true then
					kislev_neglect_time = kislev_neglect_time + 1;
					update_kislev_support_effect(faction, kislev_support_neglect_orthodoxy_key);
				end
			end
		end,
		true
	);
	
	core:add_listener(
		"kislev_declares_war_on_kislev",
		"NegativeDiplomaticEvent",
		function(context)
			return context:proposer():is_human() and context:recipient():culture() == "wh3_main_ksl_kislev" and context:is_war();
		end,
		function(context)
			local faction = context:proposer();
			local faction_provinces_list = faction:provinces();

			for i = 0, faction_provinces_list:num_items() - 1 do
				local province = faction_provinces_list:item_at(i);
				local region_list = province:regions();
				
				for j = 0, region_list:num_items() - 1 do
					local current_region = region_list:item_at(j);

					if current_region:owning_faction() == faction then
						local public_order = current_region:public_order();
						local new_value = public_order + kislev_devotion_amount_declare_war_on_kislev;
						cm:set_public_order_of_province_for_region(current_region:name(), new_value);
						break;
					end
				end
			end
		end,
		true
	);

	core:add_listener(
		"kislev_zealous_conscription_initial_units",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == "wh3_main_ksl_support_orthodoxy_character_2_2";
		end,
		function(context)
			local faction = context:performing_faction()
			cm:add_unit_to_faction_mercenary_pool(faction, "wh3_dlc24_ksl_inf_kislevite_warriors", "wh3_main_ksl_zealous_conscription", 2, 0, 2, 0.2, "", "", "", true, "wh3_dlc24_ksl_inf_kislevite_warriors");
			cm:add_unit_to_faction_mercenary_pool(faction, "wh3_main_ksl_inf_kossars_1", "wh3_main_ksl_zealous_conscription", 2, 0, 2, 0.2, "", "", "", true, "wh3_main_ksl_inf_kossars_1");
			cm:add_unit_to_faction_mercenary_pool(faction, "wh3_main_ksl_inf_kossars_0", "wh3_main_ksl_zealous_conscription", 2, 0, 2, 0.2, "", "", "", true, "wh3_main_ksl_inf_kossars_0");
		end,
		true
	);

	core:add_listener(
		"CharacterFinishedMovingEventAtamanAP",
		"CharacterFinishedMovingEvent",
		function(context)
			local character = context:character();
			return character:has_region() == true and character:is_wounded() == false and character:character_subtype("wh3_main_ksl_ataman");
		end,
		function(context)
			-- We refresh Ataman AP because there shouldn't ever be a time they can't move/attack even though they do use AP
			local character = context:character();
			local character_cqi = character:command_queue_index();
			cm:replenish_action_points(cm:char_lookup_str(character_cqi));
		end,
		true
	);
end

function calculate_kislev_support_state(faction)
	local level_orthodoxy = faction:pooled_resource_manager():resource("wh3_main_ksl_support_level_orthodoxy"):value();
	local level_ice_court = faction:pooled_resource_manager():resource("wh3_main_ksl_support_level_ice_court"):value();
	local level_orthodoxy_warning = cm:get_factions_bonus_value(faction, "allowed_orthodoxy_level_difference");
	local level_ice_court_warning = cm:get_factions_bonus_value(faction, "allowed_ice_court_level_difference");
	local level_orthodoxy_neglect = level_orthodoxy_warning + 1;
	local level_ice_court_neglect = level_ice_court_warning + 1;

	-- Check if Orthodoxy is favoured too much
	if (level_orthodoxy - level_ice_court) >= level_orthodoxy_neglect then
		set_kislev_support_effect(faction, kislev_support_neglect_ice_court_key);
	elseif (level_orthodoxy - level_ice_court) >= level_orthodoxy_warning then
		set_kislev_support_effect(faction, kislev_support_warning_ice_court_key);

	-- Check if Ice Court is favoured too much
	elseif (level_ice_court - level_orthodoxy) >= level_ice_court_neglect then
		set_kislev_support_effect(faction, kislev_support_neglect_orthodoxy_key);
	elseif (level_ice_court - level_orthodoxy) >= level_ice_court_warning then
		set_kislev_support_effect(faction, kislev_support_warning_orthodoxy_key);

	-- Else remove the effects
	else
		set_kislev_support_effect(faction, "remove");
	end
end

function update_kislev_support_effect(faction, effect)
	local faction_key = faction:name();
	cm:remove_effect_bundle(effect, faction_key);
	apply_kislev_support_effect(faction, effect, kislev_neglect_time);
end

function set_kislev_support_effect(faction, effect)
	local faction_key = faction:name();

	if faction:has_effect_bundle(effect) == false and effect ~= "remove" then
		apply_kislev_support_effect(faction, effect, 0);
	end

	if effect ~= "wh3_main_ksl_orthodoxy_warning" and faction:has_effect_bundle("wh3_main_ksl_orthodoxy_warning") == true then
		cm:remove_effect_bundle("wh3_main_ksl_orthodoxy_warning", faction_key);
	end
	if effect ~= "wh3_main_ksl_orthodoxy_neglect" and faction:has_effect_bundle("wh3_main_ksl_orthodoxy_neglect") == true then
		cm:remove_effect_bundle("wh3_main_ksl_orthodoxy_neglect", faction_key);
	end
	if effect ~= "wh3_main_ksl_ice_court_warning" and faction:has_effect_bundle("wh3_main_ksl_ice_court_warning") == true then
		cm:remove_effect_bundle("wh3_main_ksl_ice_court_warning", faction_key);
	end
	if effect ~= "wh3_main_ksl_ice_court_neglect" and faction:has_effect_bundle("wh3_main_ksl_ice_court_neglect") == true then
		cm:remove_effect_bundle("wh3_main_ksl_ice_court_neglect", faction_key);
	end
	if effect == "remove" then
		kislev_neglect_time = 0;
	end
end

function apply_kislev_support_effect(faction, effect, level)
	if effect == kislev_support_warning_orthodoxy_key then
		cm:apply_effect_bundle(kislev_support_warning_orthodoxy_key, faction:name(), 0);
	elseif effect == kislev_support_warning_ice_court_key then
		cm:apply_effect_bundle(kislev_support_warning_ice_court_key, faction:name(), 0);
	else
		local support_effect = cm:create_new_custom_effect_bundle(effect);

		if effect == kislev_support_neglect_ice_court_key then
			support_effect:add_effect("wh3_main_diplomatic_relations_ice_court", "faction_to_faction_own_unseen", -10 - level);
			support_effect:add_effect("wh3_main_effect_ice_court_training_cost_mod", "faction_to_faction_own_unseen", 50 + (level * 2));
		elseif effect == kislev_support_neglect_orthodoxy_key then
			support_effect:add_effect("wh3_main_diplomatic_relations_orthodoxy", "faction_to_faction_own_unseen", -10 - level);
			support_effect:add_effect("wh_main_effect_building_construction_cost_mod_infrastructure", "faction_to_region_own", 15 + (level / 2));
		end
		
		support_effect:add_effect("wh3_main_effect_public_order_supporters", "faction_to_province_own", -2 - (level * 0.33));
		support_effect:add_effect("wh_main_effect_force_stat_leadership", "faction_to_force_own", -3 - (level * 0.33));
		support_effect:add_effect("wh_main_effect_technology_research_points", "faction_to_faction_own_unseen", -10 - (level / 2));

		support_effect:set_duration(0);
		cm:apply_custom_effect_bundle_to_faction(support_effect, faction);
	end
end

function SetCourtDifferenceAllowedContext()
	local local_player = cm:get_faction(cm:get_local_faction_name(true));
	local level_orthodoxy_warning = cm:get_factions_bonus_value(local_player, "allowed_orthodoxy_level_difference");
	local level_ice_court_warning = cm:get_factions_bonus_value(local_player, "allowed_ice_court_level_difference");
	common.set_context_value("level_orthodoxy_warning", level_orthodoxy_warning - 1);
	common.set_context_value("level_ice_court_warning", level_ice_court_warning - 1);
end

function IsKislevButNotOrthodoxy(faction)
	if faction:name() == faction_key_orthodoxy then
		return false;
	end
	if faction:subculture() ~= kislev_subculture_key then
		return false;
	end
	return true;
end

function IsKislevButNotIceCourt(faction)
	if faction:name() == faction_key_ice_court then
		return false;
	end
	if faction:subculture() ~= kislev_subculture_key then
		return false;
	end
	return true;
end
function IsChaosCulture(faction)
	local clt = faction:culture();

	if clt == "wh_main_chs_chaos" or
	clt == "wh_dlc08_nor_norsca" or
	clt == "wh_dlc03_bst_beastmen" or
	clt == "wh3_main_dae_daemons" or
	clt == "wh3_main_nur_nurgle" or
	clt == "wh3_main_sla_slaanesh" or
	clt == "wh3_main_tze_tzeentch" or
	clt == "wh3_main_kho_khorne" or
	clt == "wh3_dlc23_chd_chaos_dwarfs" then
		return true;
	end
	return false;
end