local vampire_coast_culture = "wh2_dlc11_cst_vampire_coast"
local harkon_faction = "wh2_dlc11_cst_vampire_coast"
local noctilus_faction = "wh2_dlc11_cst_noctilus"
-- turns until noctilus' next war declaration mission
local noctilus_war_counter = 5

local vampire_coast_dilemma_faction_data = {
	{
		faction = "wh2_dlc11_brt_bretonnia_dil",
		spawn = {x = 381, y = 676},
		unit_list = "wh_dlc07_brt_inf_foot_squires_0,wh_dlc07_brt_inf_foot_squires_0,wh_dlc07_brt_inf_foot_squires_0,wh_dlc07_brt_inf_men_at_arms_2,wh_dlc07_brt_inf_men_at_arms_2,wh_dlc07_brt_inf_peasant_bowmen_1,wh_dlc07_brt_inf_peasant_bowmen_1,wh_dlc07_brt_inf_peasant_bowmen_1,wh_main_brt_cav_grail_knights,wh_main_brt_cav_grail_knights,wh_main_brt_cav_grail_knights,wh_main_brt_cav_mounted_yeomen_1,wh_main_brt_cav_mounted_yeomen_1,wh_dlc07_brt_art_blessed_field_trebuchet_0",
		patrol = {{x = 457, y = 340}, {x = 381, y = 676}},
		agent_subtype = "wh_main_brt_lord",
		forename = "names_name_1237536125", --Fransiscus
		family_name = "names_name_2147345570", --Mercier
		inv_exp = 5
	},
	{
		faction = "wh2_dlc11_emp_empire_dil",
		spawn = {x = 109, y = 475},
		unit_list = "wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_halberdiers,wh_main_emp_inf_halberdiers,wh_main_emp_inf_halberdiers,wh_main_emp_inf_halberdiers,wh_main_emp_art_great_cannon,wh_main_emp_art_great_cannon,wh_main_emp_art_great_cannon,wh_main_emp_cav_reiksguard,wh_main_emp_cav_reiksguard,wh_main_emp_cav_reiksguard,wh_main_emp_inf_handgunners,wh_main_emp_inf_handgunners,wh_main_emp_inf_handgunners,wh_main_emp_inf_handgunners",
		patrol = {{x = 487, y = 388}, {x = 109, y = 475}},
		agent_subtype = "wh_main_emp_lord",
		fore_name = "names_name_2147355219", --Lennard
		family_name = "names_name_2147351126", --the Coin-Finger
		inv_exp = 7
	},
	{
		faction = "wh2_dlc11_def_dark_elves_dil",
		spawn = {x = 313, y = 521},
		unit_list = "wh2_main_def_inf_black_ark_corsairs_0,wh2_main_def_inf_black_ark_corsairs_0,wh2_main_def_inf_black_ark_corsairs_0,wh2_main_def_inf_black_ark_corsairs_0,wh2_main_def_inf_black_ark_corsairs_0,wh2_main_def_inf_black_ark_corsairs_1,wh2_main_def_inf_black_ark_corsairs_1,wh2_main_def_inf_black_ark_corsairs_1,wh2_main_def_inf_shades_0,wh2_main_def_inf_shades_0,wh2_main_def_inf_shades_0,wh2_dlc10_def_inf_sisters_of_slaughter,wh2_dlc10_def_inf_sisters_of_slaughter,wh2_dlc10_def_inf_sisters_of_slaughter,wh2_dlc10_def_mon_kharibdyss_0,wh2_dlc10_def_mon_kharibdyss_0,wh2_main_def_inf_harpies,wh2_main_def_inf_harpies,wh2_main_def_art_reaper_bolt_thrower",
		patrol = {{x = 243, y = 750}, {x = 313, y = 521}},
		agent_subtype = "wh2_main_def_dreadlord",
		fore_name = "names_name_1225535785", --Ramon
		family_name = "names_name_1231094167", --Dreadtongue
		inv_exp = 7
	},
	{
		faction = "wh2_dlc11_nor_norsca_dil",
		spawn = {x = 579, y = 768},
		unit_list = "wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_1,wh_main_nor_inf_chaos_marauders_1,wh_dlc08_nor_inf_marauder_hunters_1,wh_dlc08_nor_inf_marauder_hunters_1,wh_dlc08_nor_inf_marauder_champions_0,wh_dlc08_nor_inf_marauder_champions_1",
		patrol = {{x = 383, y = 868}, {x = 579, y = 768}},
		agent_subtype = "wh_main_nor_marauder_chieftain",
		fore_name = "names_name_1060172250", --Tarr
		family_name = "names_name_1414761431", --Bonespear
		inv_exp = 3
	}
}

local pirate_cove_created_bundle = "wh2_dlc11_bundle_pirate_cove_created"

local harkon_personality = {
	turns_until_swap = 5,
	current = "",
	new = "",
	restored = false,
	building_complete = false,
	quest_complete = false
}

function add_vampire_coast_listeners()
	out("#### Adding Vampire Coast Listeners ####")
	
	local harkon = cm:get_faction(harkon_faction)
	local harkon_faction_is_human = harkon:is_human()
	
	if cm:is_new_game() then
		harkon_personality.current = "mad"
		
		if not harkon_faction_is_human then
			harkon_personality.new = "restored"
			harkon_personality_trait_replace()
			harkon_personality.restored = true
		end
	end
	
	if harkon_faction_is_human then
		core:add_listener(
			"harkon_personality_swap",
			"FactionTurnStart",
			function(context)
				local faction = context:faction()
				
				return faction:name() == harkon_faction and faction:faction_leader():has_military_force() and not harkon_personality.restored
			end,
			function()
				harkon_personality.turns_until_swap = harkon_personality.turns_until_swap - 1
				
				if harkon_personality.turns_until_swap == 0 then
					harkon_personality.turns_until_swap = 5 + cm:random_number(5) -- next swap between 5 and 10 turns
					
					local new_personalities = {
						"coward",
						"mad",
						"prideful",
						"hateful"
					}
					
					-- remove the current personality and select a random new one
					for i = 1, #new_personalities do
						if new_personalities[i] == harkon_personality.current then
							table.remove(new_personalities, i)
							break
						end
					end
					
					harkon_personality.new = new_personalities[cm:random_number(#new_personalities)]
					
					harkon_personality_trait_replace()
				end
			end,
			true
		)
		
		local mm_fractured_mind = mission_manager:new(harkon_faction, "wh2_dlc11_harkon_factured_mind_mission")
		mm_fractured_mind:set_mission_issuer("CLAN_ELDERS")
		mm_fractured_mind:add_new_scripted_objective(
			"mission_text_text_wh2_dlc11_harkon_fractured_mind_quest",
			"ScriptEventHarkonRestored",
			true
		)
		mm_fractured_mind:add_payload("effect_bundle{bundle_key wh2_dlc11_harkon_mind_dummy_restored;turns 0;}")
		
		cm:add_faction_turn_start_listener_by_name(
			"harkon_mission_add",
			harkon_faction,
			function()
				if cm:turn_number() == 5 then
					mm_fractured_mind:trigger()
					cm:remove_faction_turn_start_listener_by_name("harkon_mission_add")
				end
			end,
			true
		)
		
		core:add_listener(
			"harkon_building_check",
			"BuildingCompleted",
			function(context)
				local faction = context:building():faction()
				return faction:name() == harkon_faction and context:building():name() == "wh2_dlc11_special_ancient_vault_2"
			end,
			function()
				harkon_personality.building_complete = true
				harkon_personality_restored()
			end,
			false
		)
		
		core:add_listener(
			"harkon_quest_check",
			"MissionSucceeded",
			function(context)
				return context:mission():mission_record_key() == "wh3_main_ie_qb_cst_harkon_quest_for_slann_gold"
			end,
			function()
				harkon_personality.quest_complete = true
				harkon_personality_restored()
			end,
			false
		)
	end
	
	local noctilus = cm:get_faction(noctilus_faction)
	
	if noctilus:is_human() then
		cm:add_faction_turn_start_listener_by_name(
			"noctilus_war_mission",
			noctilus_faction,
			function(context)
				noctilus_war_counter = noctilus_war_counter - 1
				
				if noctilus_war_counter <= 0 then
					local factions_list = context:faction():factions_met()
					local target_list = {}
					
					for i = 0, factions_list:num_items() - 1 do
						local target = factions_list:item_at(i)
						
						-- Exclude Noctilus' faction, factions Noctilus is already at war, Noctilus' allies and factions with no forces
						if target:name() ~= noctilus_faction and not target:at_war_with(noctilus) and not target:allied_with(noctilus) and not target:military_force_list():is_empty() then
							table.insert(target_list, target:name())
						end
					end
					
					if #target_list > 0 then
						local mission_payloads = {
							"wh2_dlc11_award_treasure_map",
							"wh2_dlc11_noctilus_war_armour_depth_guard",
							"wh2_dlc11_noctilus_war_leadership_infantry",
							"wh2_dlc11_noctilus_war_melee_attack_large",
							"wh2_dlc11_noctilus_war_melee_defence_zombies",
							"wh2_dlc11_noctilus_war_missile_damage_infantry",
							"wh2_dlc11_noctilus_war_physical_resist_zombies",
							"wh2_dlc11_noctilus_war_raiding",
							"wh2_dlc11_noctilus_war_replenishment",
							"wh2_dlc11_noctilus_war_sacking",
							"wh2_dlc11_noctilus_war_siege",
							"wh2_dlc11_noctilus_war_weapon_strength_depth_guard",
							"wh2_dlc11_noctilus_war_weapon_strength_large",
							"wh2_dlc11_noctilus_war_winds_of_magic"
						}
						
						local payload_effect = mission_payloads[cm:random_number(#mission_payloads)]
						
						local mm = mission_manager:new(noctilus_faction, "wh2_dlc11_noctilus_declare_war")
						mm:set_mission_issuer("CLAN_ELDERS")
						mm:add_new_objective("DECLARE_WAR")
						mm:add_condition("faction " .. target_list[cm:random_number(#target_list)])
						mm:set_turn_limit(10)
						mm:add_payload("money 1500")
						if payload_effect == "wh2_dlc11_award_treasure_map" then
							mm:add_payload("effect_bundle{bundle_key " .. payload_effect .. ";turns 0;}")
						else
							mm:add_payload("effect_bundle{bundle_key " .. payload_effect .. ";turns 10;}")
						end
						
						mm:trigger()
						
						noctilus_war_counter = 10 + cm:random_number(10)
					end
				end
			end,
			true
		)
	end
	
	if cm:are_any_factions_human(nil, vampire_coast_culture) then
		core:add_listener(
			"vampire_coast_dilemma_mission",
			"DilemmaChoiceMadeEvent",
			function(context)
				return context:dilemma() == "wh2_dlc11_cst_dilemma_ocean_of_opportunities"
			end,
			function(context)
				local choice = context:choice()
				local choice_index = choice + 1
				
				local faction = vampire_coast_dilemma_faction_data[choice_index].faction
				
				local mission_key = context:dilemma() .. "_" .. choice
				local players_faction = context:faction():name()
				
				if invasion_manager:get_invasion("dil_inv") then
					invasion_manager:kill_invasion_by_key("dil_inv")
				end
				
				local dil_inv = invasion_manager:new_invasion("dil_inv", faction, vampire_coast_dilemma_faction_data[choice_index].unit_list, vampire_coast_dilemma_faction_data[choice_index].spawn)
				dil_inv:set_target("PATROL", vampire_coast_dilemma_faction_data[choice_index].patrol)
				dil_inv:apply_effect("wh_main_reduced_movement_range_50", -1)
				dil_inv:create_general(false, vampire_coast_dilemma_faction_data[choice_index].agent_subtype, vampire_coast_dilemma_faction_data[choice_index].forename, "", vampire_coast_dilemma_faction_data[choice_index].family_name, "")
				dil_inv:add_unit_experience(vampire_coast_dilemma_faction_data[choice_index].inv_exp)
				dil_inv:start_invasion(
					function(self)
						cm:trigger_mission(players_faction, mission_key, true)
					end,
					false,
					false,
					false
				)
				
				cm:force_declare_war(players_faction, faction, false, false)													--force player to declare war on faction
				cm:force_diplomacy("all", "faction:" .. faction, "all", false, false, true) 									--set all factions to not do diplomacy with inv faction
				cm:force_diplomacy("faction:" .. faction, "all", "all", false, false, true) 									--set inv faction to not do diplomacy with all factions
			end,
			true
		)
		
		core:add_listener(
			"vampire_coast_dilemma_mission_over",
			"MissionSucceeded",
			function(context)
				return context:mission():mission_record_key():starts_with("wh2_dlc11_cst_dilemma_ocean_of_opportunities_")
			end,
			function(context)
				local mission_key = context:mission():mission_record_key()
				local faction_key = false
				
				if mission_key == "wh2_dlc11_cst_dilemma_ocean_of_opportunities_0" then
					faction_key = vampire_coast_dilemma_faction_data[1].faction
				elseif mission_key == "wh2_dlc11_cst_dilemma_ocean_of_opportunities_1" then
					faction_key = vampire_coast_dilemma_faction_data[2].faction
				elseif mission_key == "wh2_dlc11_cst_dilemma_ocean_of_opportunities_2" then
					faction_key = vampire_coast_dilemma_faction_data[3].faction
				else
					faction_key = vampire_coast_dilemma_faction_data[4].faction
				end
				
				cm:kill_all_armies_for_faction(cm:get_faction(faction_key))
			end,
			true
		)
		
		core:add_listener(
			"dilemma_end_point",
			"EndOfRound",
			true,
			function(context)
				for i = 1, #vampire_coast_dilemma_faction_data do
					local faction = cm:get_faction(vampire_coast_dilemma_faction_data[i].faction)
					
					if not faction:is_dead() then
						-- get the army (there is only 1 so it is always at position 0 in list)
						local general = faction:military_force_list():item_at(0):general_character()
						local army_position_x = general:logical_position_x()
						local army_position_y = general:logical_position_y()
						
						if distance_squared(army_position_x, army_position_y, vampire_coast_dilemma_faction_data[i].patrol[1].x, vampire_coast_dilemma_faction_data[i].patrol[1].y) <= 1 then
							cm:kill_all_armies_for_faction(faction)
						end
					end
				end
			end,
			true
		)
		
		-- clear action points and force-deselect when the search-for-treasure stance is adopted
		core:add_listener(
			"ForceAdoptsStance_Dig_For_Treasure",
			"ForceAdoptsStance",
			function(context)
				local faction = context:military_force():faction()
				return context:stance_adopted() == 11 and faction:culture() == "wh2_dlc11_cst_vampire_coast" and faction:is_human()
			end,
			function(context)
				local mf = context:military_force()
				
				cm:zero_action_points(cm:char_lookup_str(mf:general_character()))
				
				-- clear the selection if it's the local player that has changed stance
				if mf:faction():name() == cm:get_local_faction_name(true) then
					CampaignUI.ClearSelection()
				end
			end,
			true
		)
		
		-- if the player is a Vampire Coast faction, then hide the ap bar when the cursor is placed over the search-for-treasure stance button 
		-- to give the impression that it will remove AP (which the script above actually does)
		local lf = cm:get_local_faction_name(true)
		if lf and cm:get_faction(lf):culture() == "wh2_dlc11_cst_vampire_coast" then
			local player_has_mouse_cursor_on_treasure_hunting_stance_button = false
			
			local ap_component_names = {
				{
					name = "ap_bar",
					was_visible = false
				},
				{
					name = "ap_bar_cost",
					was_visible = false
				},
				{
					name = "ap_bar_insufficient",
					was_visible = false
				}
			}
			
			core:add_listener(
				"treasure_hunting_ap_zero_on_mouseover",
				"ComponentMouseOn",
				function(context)
					return not player_has_mouse_cursor_on_treasure_hunting_stance_button and context.string == "button_MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING"
				end,
				function(context)
					-- player has placed the mouse cursor over the Dig for Treasure stance
					local uic_ap_parent = find_uicomponent(core:get_ui_root(), "primary_info_panel_holder", "info_panel_background", "CharacterInfoPopup", "action_points_parent")
					
					if uic_ap_parent then
						player_has_mouse_cursor_on_treasure_hunting_stance_button = true
						
						for i = 1, #ap_component_names do
							local uic = find_uicomponent(uic_ap_parent, ap_component_names[i].name)
							
							if uic:Opacity() > 0 then
								uic:SetOpacity(0)
								ap_component_names[i].was_visible = true
							else
								ap_component_names[i].was_visible = false
							end
						end
						
						-- listen for the player moving the mouse cursor
						core:add_listener(
							"treasure_hunting_ap_zero_on_mouseover",
							"ComponentMouseOff",
							function(context)
								return context.string == "button_MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING"
							end,
							function(context)
								player_has_mouse_cursor_on_treasure_hunting_stance_button = false
								
								local uic_ap_parent = find_uicomponent(core:get_ui_root(), "primary_info_panel_holder", "info_panel_background", "CharacterInfoPopup", "action_points_parent")
								
								if uic_ap_parent then
									for i = 1, #ap_component_names do
										local uic = find_uicomponent(uic_ap_parent, ap_component_names[i].name)
										
										if ap_component_names[i].was_visible then
											uic:SetOpacity(255)
										end
									end
								end
							end,
							false
						)
					end
				end,
				true
			)
		end
		
		core:add_listener(
			"final_battle_army_abilities",
			"PendingBattle",
			function()
				return pending_battle_is_harkon_quest_battle()
			end,
			function()
				cm:apply_effect_bundle_to_force("wh2_dlc11_bundle_harkon_battle_army_abilities", cm:model():pending_battle():attacker():military_force():command_queue_index(), 0)
				cm:update_pending_battle()
			end,
			true
		)
		
		-- player completes the final battle
		core:add_listener(
			"final_battle_clean_up",
			"BattleCompleted",
			function()
				return pending_battle_is_harkon_quest_battle()
			end,
			function()
				local pb = cm:model():pending_battle()
				
				local attacker_mf = false
				
				if pb:has_attacker() then
					attacker_mf = pb:attacker():military_force()
				else
					local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(1)
					
					attacker_mf = cm:get_military_force_by_cqi(mf_cqi) 
				end
				
				if attacker_mf and attacker_mf:has_effect_bundle("wh2_dlc11_bundle_harkon_battle_army_abilities") then
					cm:remove_effect_bundle_from_force("wh2_dlc11_bundle_harkon_battle_army_abilities", attacker_mf:command_queue_index())
				end
			end,
			true
		)

		core:add_listener(
			"thelegendofdickhalfmast",
			"CharacterCreated",
			function(context)
				return context:has_respawned() == false;
			end,
			function(context)
				local character = context:character();

				if character:forename("names_name_169104324") and character:surname("names_name_1078739176") then
					cm:force_add_trait("character_cqi:"..character:cqi(), "wh2_dlc11_trait_legend", false, 1);
				end
			end,
			true
		)
	end
	
	core:add_listener(
		"vampire_coast_CharacterGarrisonTargetAction",
		"CharacterGarrisonTargetAction",
		function(context)
			return context:agent_action_key() == "wh2_dlc11_agent_action_dignitary_hinder_settlement_establish_pirate_cove" and (context:mission_result_critial_success() or context:mission_result_success())
		end,
		function(context)
			local faction = context:character():faction()
			local faction_name = faction:name()
			
			if faction:has_effect_bundle(pirate_cove_created_bundle) then
				cm:remove_effect_bundle(pirate_cove_created_bundle, faction_name)
			end
			
			cm:apply_effect_bundle(pirate_cove_created_bundle, faction_name, 15)
		end,
		true
	)
end

function pending_battle_is_harkon_quest_battle()
	return cm:model():pending_battle():set_piece_battle_key() == "wh2_dlc11_qb_cst_harkon"
end

function harkon_personality_trait_replace()
	local faction = cm:get_faction(harkon_faction)
	local faction_leader = faction:faction_leader()
	
	cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_traits", "")
	
	cm:force_remove_trait(cm:char_lookup_str(faction_leader), "wh2_dlc11_trait_harkon_personality_" .. harkon_personality.current)
	
	cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_traits", "") end, 0.2)
	
	if faction:is_human() then
		cm:trigger_incident_with_targets(faction:command_queue_index(), "wh2_dlc11_cst_harkon_mind_change_" .. harkon_personality.new, 0, 0, faction_leader:command_queue_index(), 0, 0, 0)
	end
	
	harkon_personality.current = harkon_personality.new
end

function harkon_personality_restored()
	if harkon_personality.building_complete and harkon_personality.quest_complete then
		harkon_personality.restored = true
		harkon_personality.new = "restored"
		harkon_personality_trait_replace()
		cm:complete_scripted_mission_objective(harkon_faction, "wh_main_short_victory", "restore_harkon_mind", true)
		core:trigger_event("ScriptEventHarkonRestored")
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("harkon_personality", harkon_personality, context)
		cm:save_named_value("noctilus_war_counter", noctilus_war_counter, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		harkon_personality = cm:load_named_value("harkon_personality", harkon_personality, context)
		noctilus_war_counter = cm:load_named_value("noctilus_war_counter", noctilus_war_counter, context)
	end
)