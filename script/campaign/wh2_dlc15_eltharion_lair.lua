local yvresse_faction_key = "wh2_main_hef_yvresse";
local lair_mistwalker_level = 15;
local lair_max_prisoners = 1;
local lair_autoresolve_capture_chance = 50;
local lair_base_escape_chance = 5;
local lair_escaping_prisoner = 0;
local lair_income_stolen = 0.05;
local lair_indoctrinated_characters = {};
local lair_execute_supply = 3;
local lair_indoctrinate_supply = 3;
local lair_max_yvresse_level = 2;
local lair_improved_interrogate = false;
local lair_interrogated_prisoner = 0;
local lair_interrogated_effect = "";
local lair_rituals_to_points = {
	["wh2_dlc15_athel_tamarha_influence_2"] = 5,
	["wh2_dlc15_athel_tamarha_influence_3"] = 5,
	["wh2_dlc15_athel_tamarha_interrogation_2"] = 5,
	["wh2_dlc15_athel_tamarha_interrogation_3"] = 5,
	["wh2_dlc15_athel_tamarha_melee_mistwalkers_2"] = 5,
	["wh2_dlc15_athel_tamarha_melee_mistwalkers_3"] = 5,
	["wh2_dlc15_athel_tamarha_mist_2"] = 5,
	["wh2_dlc15_athel_tamarha_mist_3"] = 5,
	["wh2_dlc15_athel_tamarha_mistwalkers_recruitment_2"] = 5,
	["wh2_dlc15_athel_tamarha_mistwalkers_recruitment_3"] = 5,
	["wh2_dlc15_athel_tamarha_mistwalkers_upgrades_2"] = 5,
	["wh2_dlc15_athel_tamarha_mistwalkers_upgrades_3"] = 5,
	["wh2_dlc15_athel_tamarha_ranged_mistwalkers_2"] = 5,
	["wh2_dlc15_athel_tamarha_ranged_mistwalkers_3"] = 5
};
local lair_culture_to_effects = {
	["wh_dlc03_bst_beastmen"] =			"wh2_dlc15_hef_eltharion_dungeon_reward_beastmen",
	["wh_main_brt_bretonnia"] =			"wh2_dlc15_hef_eltharion_dungeon_reward_bretonnia",
	["wh_main_chs_chaos"] =				"wh2_dlc15_hef_eltharion_dungeon_reward_chaos_warriors",
	["wh2_main_def_dark_elves"] =		"wh2_dlc15_hef_eltharion_dungeon_reward_dark_elves",
	["wh_main_dwf_dwarfs"] =			"wh2_dlc15_hef_eltharion_dungeon_reward_dwarfs",
	["wh_main_emp_empire"] =			"wh2_dlc15_hef_eltharion_dungeon_reward_empire",
	["wh3_main_ksl_kislev"] =			"wh2_dlc15_hef_eltharion_dungeon_reward_kislev",
	["wh3_main_cth_cathay"] =			"wh2_dlc15_hef_eltharion_dungeon_reward_cathay",
	["wh_main_grn_greenskins"] =		"wh2_dlc15_hef_eltharion_dungeon_reward_greenskins",
	["wh2_main_hef_high_elves"] =		"wh2_dlc15_hef_eltharion_dungeon_reward_high_elves",
	["wh2_main_lzd_lizardmen"] =		"wh2_dlc15_hef_eltharion_dungeon_reward_lizardmen",
	["wh_dlc08_nor_norsca"] =			"wh2_dlc15_hef_eltharion_dungeon_reward_norsca",
	["wh2_main_skv_skaven"] =			"wh2_dlc15_hef_eltharion_dungeon_reward_skaven",
	["wh2_dlc09_tmb_tomb_kings"] =		"wh2_dlc15_hef_eltharion_dungeon_reward_tomb_kings",
	["wh2_dlc11_cst_vampire_coast"] =	"wh2_dlc15_hef_eltharion_dungeon_reward_vampire_coast",
	["wh_main_vmp_vampire_counts"] =	"wh2_dlc15_hef_eltharion_dungeon_reward_vampire_counts",
	["wh_dlc05_wef_wood_elves"] =		"wh2_dlc15_hef_eltharion_dungeon_reward_wood_elves",
	["wh3_main_dae_daemons"] =			"wh2_dlc15_hef_eltharion_dungeon_reward_daemons",
	["wh3_main_kho_khorne"] =			"wh2_dlc15_hef_eltharion_dungeon_reward_daemons",
	["wh3_main_nur_nurgle"] =			"wh2_dlc15_hef_eltharion_dungeon_reward_daemons",
	["wh3_main_sla_slaanesh"] =			"wh2_dlc15_hef_eltharion_dungeon_reward_daemons",
	["wh3_main_tze_tzeentch"] =			"wh2_dlc15_hef_eltharion_dungeon_reward_daemons",
	["wh3_main_ogr_ogre_kingdoms"] =	"wh2_dlc15_hef_eltharion_dungeon_reward_ogre_kingdoms",
	["wh2_main_rogue"] =				"wh2_dlc15_hef_eltharion_dungeon_reward_rogue_armies"
};
local lair_action_effects = {
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_wood_elves",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_vampire_counts",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_vampire_coast",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_tomb_kings",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_skaven",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_rogue_army",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_norsca",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_lizardmen",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_high_elves",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_greenskins",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_empire",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_dwarfs",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_dark_elves",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_chaos_warriors", -- contains both warriors and champions
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_bretonnia",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_beastmen",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_cathay",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_daemons",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_kislev",
	"wh2_dlc15_hef_dungeon_mistwalker_upgrade_ogre_kingdoms"
};

function add_eltharion_lair_listeners()
	out("#### Adding Eltharion Lair Listeners ####");
	
	core:add_listener(
		"lair_FactionTurnStart",
		"FactionBeginTurnPhaseNormal",
		function(context)
			local faction = context:faction();
			
			return faction:is_human() and faction:name() == yvresse_faction_key;
		end,
		function(context)
			local faction = context:faction();
			
			lair_UpdatePrisonAbility(faction);
			lair_UpdatePrisonerEffects(faction);
			
			-- update prisoner escapes
			local prisoners = cm:model():prison_system():get_faction_prisoners(faction);
			
			for i = 0, prisoners:num_items() - 1 do
				local prisoner = prisoners:item_at(i):character();
				
				if cm:random_number(100) <= lair_base_escape_chance then
					lair_escaping_prisoner = prisoner:command_queue_index();
					break;
				end
			end
			
			lair_CheckDeadPrisoners()
			
			for i = 1, #lair_indoctrinated_characters do
				local char_cqi = lair_indoctrinated_characters[i];
				local character = cm:get_character_by_cqi(char_cqi);
				
				if character and not character:is_null_interface() then
					local character_faction = character:faction();
					
					if not character_faction:is_null_interface() and not character_faction:is_dead() then
						-- steal treasury
						cm:treasury_mod(yvresse_faction_key, character_faction:treasury() * lair_income_stolen);
						
						lair_MakeCharacterVisible(character);
					end
				end
			end
			
			cm:callback(
				function()
					if faction:has_effect_bundle("wh2_dlc15_bundle_executed_prisoner_influence") then
						cm:remove_effect_bundle("wh2_dlc15_bundle_executed_prisoner_influence", yvresse_faction_key);
					end
					
					if faction:has_effect_bundle("wh2_dlc15_bundle_indoctrinated_prisoner_influence") then
						cm:remove_effect_bundle("wh2_dlc15_bundle_indoctrinated_prisoner_influence", yvresse_faction_key);
					end
				end,
				1
			);
		end,
		true
	);
	
	core:add_listener(
		"lair_CharacterRankUp",
		"CharacterRankUp",
		function(context)
			local character = context:character();
			local faction = character:faction();
			
			return faction:name() == yvresse_faction_key and faction:is_human() and not character:is_faction_leader() and not character:character_details():is_unique() and character:rank() >= lair_mistwalker_level;
		end,
		function(context)
			local character = context:character();
			local trait_level = character:trait_points("wh2_dlc15_trait_mistwalker_sentinel");
			trait_level = trait_level + character:trait_points("wh2_dlc15_trait_mistwalker_shadow");
			trait_level = trait_level + character:trait_points("wh2_dlc15_trait_mistwalker_watcher");
			
			if trait_level < 1 then
				cm:trigger_dilemma_with_targets(character:faction():command_queue_index(), "wh2_dlc15_hef_mistwalker_recruitment", 0, 0, character:command_queue_index(), 0, 0, 0);
			end
		end,
		true
	);
	
	core:add_listener(
		"lair_RitualCompletedEvent",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_category() == "ATHEL_TAMARHA_RITUAL" and context:succeeded();
		end,
		function(context)
			local ritual = context:ritual();
			local ritual_key = ritual:ritual_key();
			
			if ritual_key == "wh2_dlc15_athel_tamarha_mistwalkers_recruitment_2" then
				cm:remove_event_restricted_building_record_for_faction("wh2_dlc15_hef_field_hq_1", yvresse_faction_key);
				cm:remove_event_restricted_building_record_for_faction("wh2_dlc15_hef_field_hq_2", yvresse_faction_key);
				cm:remove_event_restricted_building_record_for_faction("wh2_dlc15_hef_field_hq_3", yvresse_faction_key);
			elseif ritual_key == "wh2_dlc15_athel_tamarha_prison_2" then
				lair_max_prisoners = lair_max_prisoners + 1;
			elseif ritual_key == "wh2_dlc15_athel_tamarha_interrogation_3" then
				lair_improved_interrogate = true;
			end
			
			local upgrade_value = lair_rituals_to_points[ritual_key];
			
			if upgrade_value then
				cm:faction_add_pooled_resource(yvresse_faction_key, "yvresse_defence", "wh2_dlc15_resource_factor_yvresse_defence_upgrade", upgrade_value);
			end
		end,
		true
	);
	
	core:add_listener(
		"lair_PrisonActionTakenEvent",
		"PrisonActionTakenEvent",
		true,
		function(context)
			local warden = context:faction();
			local warden_cqi = warden:command_queue_index();
			
			local prisoner = context:prisoner_family_member();
			local prisoner_cqi = 0;
			local faction_cqi = 0;
			local is_grom = false;
			
			if not prisoner:is_null_interface() then
				local character = prisoner:character();
				
				if not character:is_null_interface() then
					prisoner_cqi = character:command_queue_index();
					faction_cqi = character:faction():command_queue_index();
					is_grom = character:character_subtype("wh2_dlc15_grn_grom_the_paunch");
				end
			end
			
			local action = context:action_key();
			
			if action == "wh2_dlc15_prison_action_indoctrinate" then
				cm:faction_add_pooled_resource(yvresse_faction_key, "wardens_supply", "wh2_dlc15_resource_factor_wardens_supply_indoctrinated_prisoners", lair_indoctrinate_supply);
				cm:apply_effect_bundle("wh2_dlc15_bundle_indoctrinated_prisoner_influence", yvresse_faction_key, 0);
				cm:trigger_incident_with_targets(warden_cqi, "wh2_dlc15_incident_hef_prisoner_indoctrinated", 0, faction_cqi, prisoner_cqi, 0, 0, 0);
				cm:remove_effect_bundle("wh2_dlc15_hef_dungeon_indoctrinate", yvresse_faction_key);
				table.insert(lair_indoctrinated_characters, prisoner_cqi);
				
				if not prisoner:is_null_interface() then
					lair_MakeCharacterVisible(prisoner:character());
				end
				
				if prisoner_cqi == lair_interrogated_prisoner then
					lair_RemoveMistwalkerAbilities(warden);
					lair_interrogated_prisoner = 0;
				end
			elseif action == "wh2_dlc15_prison_action_execute" then
				cm:faction_add_pooled_resource(yvresse_faction_key, "wardens_supply", "wh2_dlc15_resource_factor_wardens_supply_executed_prisoners", lair_execute_supply);
				cm:apply_effect_bundle("wh2_dlc15_bundle_executed_prisoner_influence", yvresse_faction_key, 0);
				cm:trigger_incident_with_targets(warden_cqi, "wh2_dlc15_incident_hef_prisoner_executed", 0, faction_cqi, prisoner_cqi, 0, 0, 0);
				cm:remove_effect_bundle("wh2_dlc15_hef_dungeon_execute", yvresse_faction_key);
				
				cm:add_agent_experience(cm:char_lookup_str(warden:faction_leader()), 500);
				
				if prisoner_cqi == lair_interrogated_prisoner then
					lair_RemoveMistwalkerAbilities(warden);
					lair_interrogated_prisoner = 0;
				end
			elseif action:starts_with("wh2_dlc15_prison_action_interrogate") then
				local current_effect = lair_interrogated_effect;
				
				for i = 1, #lair_action_effects do
					if lair_action_effects[i] ~= current_effect and warden:has_effect_bundle(lair_action_effects[i]) then
						lair_interrogated_effect = lair_action_effects[i];
					end
				end
				
				lair_RemoveMistwalkerAbilities(warden, lair_interrogated_effect);
				lair_interrogated_prisoner = prisoner_cqi;
				
				if lair_improved_interrogate then
					local mf_list = warden:military_force_list();
					
					for i = 0, mf_list:num_items() - 1 do
						local current_mf = mf_list:item_at(i);
						
						if not current_mf:is_armed_citizenry() and current_mf:has_general() then
							cm:add_agent_experience(cm:char_lookup_str(current_mf:general_character()), 250);
						end
					end
				end
				
				if is_grom then
					cm:apply_effect_bundle("wh2_dlc15_hef_dungeon_mistwalker_upgrade_greenskins_grom", yvresse_faction_key, 0);
				end
			end
			
			lair_UpdatePrisonAbility(warden);
			lair_UpdatePrisonerEffects(warden);
		end,
		true
	);
	
	core:add_listener(
		"lair_BuildingCompleted",
		"BuildingCompleted",
		function(context)
			local building = context:building();
			
			return building:faction():name() == yvresse_faction_key and context:garrison_residence():region():name() == "wh3_main_combi_region_tor_yvresse" and building:chain() == "wh2_dlc15_special_settlement_tor_yvresse_eltharion";
		end,
		function(context)
			local building_level = context:building():building_level();
				
			if lair_max_yvresse_level == 4 and building_level == 5 then
				lair_max_yvresse_level = lair_max_yvresse_level + 1;
				cm:faction_add_pooled_resource(yvresse_faction_key, "yvresse_defence", "wh2_dlc15_resource_factor_yvresse_defence_settlement", 10);
			elseif lair_max_yvresse_level == 3 and building_level == 4 then
				lair_max_yvresse_level = lair_max_yvresse_level + 1;
				cm:faction_add_pooled_resource(yvresse_faction_key, "yvresse_defence", "wh2_dlc15_resource_factor_yvresse_defence_settlement", 10);
			elseif lair_max_yvresse_level == 2 and building_level == 3 then
				lair_max_yvresse_level = lair_max_yvresse_level + 1;
				cm:faction_add_pooled_resource(yvresse_faction_key, "yvresse_defence", "wh2_dlc15_resource_factor_yvresse_defence_settlement", 5);
			end
		end,
		true
	);
	
	core:add_listener(
		"lair_BattleCompleted",
		"BattleCompleted",
		function()
			return cm:get_faction(yvresse_faction_key):is_human();
		end,
		function()
			local pending_battle = cm:model():pending_battle();
			local warden = cm:get_faction(yvresse_faction_key);
			
			if pending_battle:is_auto_resolved() then
				local prison_system = cm:model():prison_system();
				local prisoners = prison_system:get_faction_prisoners(warden);
				
				if prisoners:num_items() < lair_max_prisoners then
					if cm:pending_battle_cache_faction_is_attacker(yvresse_faction_key) and pending_battle:has_been_fought() and not pending_battle:ended_with_withdraw() and cm:random_number(100) <= lair_autoresolve_capture_chance then
						for i = 1, cm:pending_battle_cache_num_defenders() do
							local defender_cqi = cm:pending_battle_cache_get_defender_fm_cqi(i);
							local enemy = cm:get_character_by_fm_cqi(defender_cqi);
							if enemy:is_null_interface() == false then
								local enemy_is_general = enemy:character_details():character_type("general")

								if enemy and not enemy:is_null_interface() and enemy_is_general then
									cm:faction_imprison_character(warden, enemy);
								end
							end
						end
					end
				end
			end
			
			-- checking to see if faction has been wiped out, resulting in lost prisoners 
			cm:callback(
				function()
					lair_CheckDeadPrisoners()
					lair_UpdatePrisonAbility(warden)
					lair_UpdatePrisonerEffects(warden)
				end,
				0.5
			)
		end,
		true
	);
	
	core:add_listener(
		"lair_GarrisonOccupiedEvent",
		"GarrisonOccupiedEvent",
		function(context)
			local faction = context:character():faction();
			
			return faction:is_human() and faction:name() == yvresse_faction_key;
		end,
		function()
			-- checking to see if faction has been wiped out, resulting in lost prisoners
			local warden = cm:get_faction(yvresse_faction_key);
			
			cm:callback(
				function()
					lair_CheckDeadPrisoners()
					lair_UpdatePrisonAbility(warden)
					lair_UpdatePrisonerEffects(warden)
				end,
				0.5
			)
		end,
		true
	)
	
	core:add_listener(
		"lair_ImprisonmentRejectionEvent",
		"ImprisonmentRejectionEvent",
		function(context)
			local warden = context:faction();
			
			return warden:is_human() and warden:name() == yvresse_faction_key;
		end,
		function(context)
			local rejection_reasons = context:rejection_reasons();
			
			if rejection_reasons:is_member_of_garrison() or rejection_reasons:is_from_rebel_faction() or rejection_reasons:is_from_companion_faction() then
				local prisoner = context:prisoner_family_member();
				
				if not prisoner:is_null_interface() then
					local character = prisoner:character();
					
					cm:trigger_incident_with_targets(context:faction():command_queue_index(), "wh2_dlc15_incident_hef_prisoner_failed_capture", 0, character:faction():command_queue_index(), character:command_queue_index(), 0, 0, 0);
				end
			end
		end,
		true
	)
	
	if cm:is_new_game() then
		local warden = cm:get_faction(yvresse_faction_key);
		lair_UpdatePrisonAbility(warden);
		cm:add_event_restricted_building_record_for_faction("wh2_dlc15_hef_field_hq_1", yvresse_faction_key, "eltharion_building_lock_hq");
		cm:add_event_restricted_building_record_for_faction("wh2_dlc15_hef_field_hq_2", yvresse_faction_key, "eltharion_building_lock_hq");
		cm:add_event_restricted_building_record_for_faction("wh2_dlc15_hef_field_hq_3", yvresse_faction_key, "eltharion_building_lock_hq");
		
		-- add pooled resource to account for fact you start with lvl 2 settlement
		cm:faction_add_pooled_resource(yvresse_faction_key, "yvresse_defence", "wh2_dlc15_resource_factor_yvresse_defence_settlement", 5);
		
		cm:callback(
			function()
				cm:perform_ritual(yvresse_faction_key, "", "wh2_dlc15_athel_tamarha_influence_1");
				cm:perform_ritual(yvresse_faction_key, "", "wh2_dlc15_athel_tamarha_interrogation_1");
				cm:perform_ritual(yvresse_faction_key, "", "wh2_dlc15_athel_tamarha_melee_mistwalkers_1");
				cm:perform_ritual(yvresse_faction_key, "", "wh2_dlc15_athel_tamarha_mist_1");
				cm:perform_ritual(yvresse_faction_key, "", "wh2_dlc15_athel_tamarha_mistwalkers_recruitment_1");
				cm:perform_ritual(yvresse_faction_key, "", "wh2_dlc15_athel_tamarha_mistwalkers_upgrades_1");
				cm:perform_ritual(yvresse_faction_key, "", "wh2_dlc15_athel_tamarha_prison_1");
				cm:perform_ritual(yvresse_faction_key, "", "wh2_dlc15_athel_tamarha_ranged_mistwalkers_1");
			end,
			1
		);
	end
end

-- this listener is established immediately as the ImprisonmentEvent is sent via code when the model is created
core:add_listener(
	"lair_ImprisonmentEvent",
	"ImprisonmentEvent",
	function(context)
		local warden = context:faction();
		
		return warden:is_human() and warden:name() == yvresse_faction_key;
	end,
	function(context)
		local warden = context:faction();
		local character = context:prisoner_family_member():character();
		
		lair_UpdatePrisonAbility(warden);
		lair_UpdatePrisonerEffects(warden);
		cm:trigger_incident_with_targets(warden:command_queue_index(), "wh2_dlc15_incident_hef_prisoner_captured", 0, character:faction():command_queue_index(), character:command_queue_index(), 0, 0, 0);
	end,
	true
)

function lair_CheckDeadPrisoners()
	local dead_prisoners = {};
	
	for i = 1, #lair_indoctrinated_characters do
		local character = cm:get_character_by_cqi(lair_indoctrinated_characters[i]);
		
		if not character or character:is_null_interface() or character:faction():is_null_interface() or character:faction():is_dead() then
			table.insert(dead_prisoners, i);
		end
	end
	
	for i = 1, #dead_prisoners do
		table.remove(lair_indoctrinated_characters, dead_prisoners[i]);
	end
end

function lair_UpdatePrisonAbility(faction)
	local prisoners = cm:model():prison_system():get_faction_prisoners(faction);
	
	if prisoners:num_items() < lair_max_prisoners then
		if not faction:has_effect_bundle("wh2_dlc15_bundle_wardens_cage") then
			cm:apply_effect_bundle("wh2_dlc15_bundle_wardens_cage", yvresse_faction_key, 0);
		end
	else
		cm:remove_effect_bundle("wh2_dlc15_bundle_wardens_cage", yvresse_faction_key);
	end
end

function lair_UpdatePrisonerEffects(faction)
	local effect_bundles = faction:effect_bundles();
	
	for i = 0, effect_bundles:num_items() - 1 do
		local effect_bundle = effect_bundles:item_at(i);
		local effect = effect_bundle:key();
		
		if effect:starts_with("wh2_dlc15_hef_eltharion_dungeon_reward") then
			cm:remove_effect_bundle(effect, yvresse_faction_key);
		end
	end
	
	local prison_system = cm:model():prison_system();
	local prisoners = prison_system:get_faction_prisoners(faction);
	local found_interrogated_cqi = false;
	
	for i = 0, prisoners:num_items() - 1 do
		local prisoner = prisoners:item_at(i):character();
		
		local effect = lair_culture_to_effects[prisoner:faction():culture()];
		
		if effect then
			cm:apply_effect_bundle(effect, yvresse_faction_key, 0);
		end
		
		if lair_interrogated_prisoner == prisoner:command_queue_index() then
			found_interrogated_cqi = true;
		end
	end
	
	if not found_interrogated_cqi then
		lair_RemoveMistwalkerAbilities(faction);
		lair_interrogated_prisoner = 0;
	end
end

function lair_RemoveMistwalkerAbilities(warden, exclude)
	exclude = exclude or "";
	for i = 1, #lair_action_effects do
		if lair_action_effects[i] ~= exclude and warden:has_effect_bundle(lair_action_effects[i]) then
			cm:remove_effect_bundle(lair_action_effects[i], yvresse_faction_key);
		end
	end
end

function lair_MakeCharacterVisible(character)
	if character:has_region() then
		cm:make_region_visible_in_shroud(yvresse_faction_key, character:region():name());
	else
		local faction = character:faction();
		
		if faction:has_home_region() then
			cm:make_region_visible_in_shroud(yvresse_faction_key, faction:home_region():name());
		end
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("lair_escaping_prisoner", lair_escaping_prisoner, context);
		cm:save_named_value("lair_indoctrinated_characters", lair_indoctrinated_characters, context);
		cm:save_named_value("lair_improved_interrogate", lair_improved_interrogate, context);
		cm:save_named_value("lair_max_yvresse_level", lair_max_yvresse_level, context);
		cm:save_named_value("lair_max_prisoners", lair_max_prisoners, context);
		cm:save_named_value("lair_interrogated_prisoner", lair_interrogated_prisoner, context);
		cm:save_named_value("lair_interrogated_effect", lair_interrogated_effect, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			lair_escaping_prisoner = cm:load_named_value("lair_escaping_prisoner", lair_escaping_prisoner, context);
			lair_indoctrinated_characters = cm:load_named_value("lair_indoctrinated_characters", lair_indoctrinated_characters, context);
			lair_improved_interrogate = cm:load_named_value("lair_improved_interrogate", lair_improved_interrogate, context);
			lair_max_yvresse_level = cm:load_named_value("lair_max_yvresse_level", lair_max_yvresse_level, context);
			lair_max_prisoners = cm:load_named_value("lair_max_prisoners", lair_max_prisoners, context);
			lair_interrogated_prisoner = cm:load_named_value("lair_interrogated_prisoner", lair_interrogated_prisoner, context);
			lair_interrogated_effect = cm:load_named_value("lair_interrogated_effect", lair_interrogated_effect, context);
		end
	end
);