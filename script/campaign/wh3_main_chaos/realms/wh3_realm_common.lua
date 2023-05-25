local realm_data = {
	["khorne"] = {
		["region"] = {
			"wh3_main_chaos_region_the_blood_gods_domain"
		},
		["spawn_positions"] = {
			{529, 673}, -- left-most position
			{535, 679},
			{542, 685},
			{552, 688},
			{576, 688},
			{586, 685},
			{593, 679},
			{599, 673}
		}
	},
	["nurgle"] = {
		["region"] = {
			"wh3_main_chaos_region_land_of_the_plaguelord"
		},
		["spawn_positions"] = {
			{622, 535},	-- south-easternmost position
			{561, 511},
			{516, 579},
			{502, 572},
			{578, 528},
			{605, 600},
			{621, 596},
			{606, 541}
		}
	},
	["tzeentch"] = {
		["region"] = {
			"wh3_main_chaos_region_realm_of_the_sorcerer_1",
			"wh3_main_chaos_region_realm_of_the_sorcerer_2",
			"wh3_main_chaos_region_realm_of_the_sorcerer_3",
			"wh3_main_chaos_region_realm_of_the_sorcerer_4",
			"wh3_main_chaos_region_realm_of_the_sorcerer_5",
			"wh3_main_chaos_region_realm_of_the_sorcerer_6",
			"wh3_main_chaos_region_realm_of_the_sorcerer_7"
		},
		["spawn_positions"] = {
			{451, 598}, -- position on right-most island
			{424, 634},
			{417, 606},
			{364, 654},
			{373, 636},
			{351, 690},
			{398, 687},
			{401, 664}
		}
	},
	["slaanesh"] = {
		["region"] = {
			"wh3_main_chaos_region_the_dark_princes_realm",
			"wh3_main_chaos_region_slaanesh_start_01",
			"wh3_main_chaos_region_slaanesh_start_02",
			"wh3_main_chaos_region_slaanesh_start_03",
			"wh3_main_chaos_region_slaanesh_start_04",
			"wh3_main_chaos_region_slaanesh_start_05",
			"wh3_main_chaos_region_slaanesh_start_06",
			"wh3_main_chaos_region_slaanesh_start_07",
			"wh3_main_chaos_region_slaanesh_start_08",
			"wh3_main_chaos_region_slaanesh_fifth",
			"wh3_main_chaos_region_slaanesh_first",
			"wh3_main_chaos_region_slaanesh_fourth",
			"wh3_main_chaos_region_slaanesh_second",
			"wh3_main_chaos_region_slaanesh_sixth",
			"wh3_main_chaos_region_slaanesh_third"
		},
		["spawn_positions"] = {
			{676, 651}, -- 10:30
			{719, 564},	
			{777, 688},
			{814, 662},
			{816, 601},
			{780, 570},
			{677, 596},
			{710, 685}
		}
	}
};

local forge_of_souls_dest_x = 553;
local forge_of_souls_dest_y = 623;

local realm_mapping = {
	["wh3_main_teleportation_node_template_kho"] = "khorne",
	["wh3_main_teleportation_node_template_nur"] = "nurgle",
	["wh3_main_teleportation_node_template_sla"] = "slaanesh",
	["wh3_main_teleportation_node_template_tze"] = "tzeentch"
};

-- the army strength required for the ai to win a realm once it reaches the survival battle destination. if they do not meet this value, the army is destroyed, to simulate losing the survival battle
local strength_required_for_ai_to_complete_realm = 2000000;

-- the number of turns the rifts should stay on the map when first appearing
rifts_duration = 15;

-- the number of turns the rifts cannot open after they close
local rifts_cooldown = 10;

-- the number of turns before chaos spawns out of a rift
local rifts_hero_spawn_time = 2;
local rifts_army_spawn_time = 5;

-- when closing a rift, this faction is fought
local rift_closure_force_data = {
	["wh3_main_teleportation_node_template_kho"] = {"wh3_main_kho_khorne_qb1", "rift_army_khorne"},
	["wh3_main_teleportation_node_template_nur"] = {"wh3_main_nur_nurgle_qb1", "rift_army_nurgle"},
	["wh3_main_teleportation_node_template_sla"] = {"wh3_main_sla_slaanesh_qb1", "rift_army_slaanesh"},
	["wh3_main_teleportation_node_template_tze"] = {"wh3_main_tze_tzeentch_qb1", "rift_army_tzeentch"}
};

function setup_realms()
	out.chaos("*********************************");
	
	if cm:is_new_game() then
		in_ursuns_roar_cutscene:start();
		
		if cm:is_multiplayer() then
			local human_factions = cm:get_human_factions();
			
			for i = 1, #human_factions do
				local current_faction_name = human_factions[i];
				
				core:add_listener(
					"intro_story_panel_listener",
					"ScriptEventShowIntroStoryPanel",
					function(context)
						return context:faction():name() == current_faction_name;
					end,
					function(context)
						show_intro_story_panel(current_faction_name);
					end,
					false
				);
			end;
		end;
	end;
	
	-- handle ai winning campaign
	cm:remove_hex_area_trigger("ai_final_battle_location");
	if not cm:get_saved_value("campaign_completed") then
		cm:add_hex_area_trigger("ai_final_battle_location", forge_of_souls_dest_x, forge_of_souls_dest_y, 3);
	end;
	
	update_shared_states();
	
	if not cm:is_multiplayer() then
		cm:complete_scripted_mission_objective(cm:get_local_faction_name(), "wh3_main_chaos_domination_victory", "domination", true);
	end;
	
	-- load any realm scripts if they are active
	if cm:get_saved_value("khorne_realm_active") then
		out.chaos("Initialising the Khorne realm...");
		setup_realm_khorne();
	end;
	
	if cm:get_saved_value("nurgle_realm_active") then
		out.chaos("Initialising the Nurgle realm...");
		setup_realm_nurgle();
	end;
	
	if cm:get_saved_value("slaanesh_realm_active") then
		out.chaos("Initialising the Slaanesh realm...");
		setup_realm_slaanesh();
	end;
	
	if cm:get_saved_value("tzeentch_realm_active") then
		out.chaos("Initialising the Tzeentch realm...");
		setup_realm_tzeentch();
	end;
	
	-- trigger ursuns roar event
	core:add_listener(
		"ursuns_roar",
		"WorldStartRound",
		function()
			return not are_any_rifts_open(true) and (cm:turn_number() == 30 or cm:get_saved_value("ursuns_roar_available"));
		end,
		function()
			cm:set_saved_value("ursuns_roar_available", true);
			
			local chance = cm:get_saved_value("chance_to_trigger_ursuns_roar") or 10;
			local roll = cm:random_number(100);
			
			out.chaos("Turn " .. cm:turn_number() .. " - Trying to trigger the Ursun's Roar event, rolled " .. roll .. " - if this is lower than " .. chance .. " then we'll proceed");
			
			if roll <= chance then
				trigger_ursuns_roar_event();
				cm:set_saved_value("chance_to_trigger_ursuns_roar", false);
			else
				cm:set_saved_value("chance_to_trigger_ursuns_roar", chance + 10);
			end;
		end,
		true
	);
	
	-- reset ursuns roar timer
	core:add_listener(
		"reset_ursuns_roar_timer",
		"ScriptEventUrsunsRoarCooldownExpires",
		function()
			return not cm:get_saved_value("rifts_permanent");
		end,
		function()
			cm:set_saved_value("ursuns_roar_available", true);
			
			local human_factions = cm:get_human_factions();
			
			for i = 1, #human_factions do
				show_story_panel(human_factions[i], "wh3_main_story_panel_ursuns_roar_imminent_" .. cm:random_number(4));
			end;
		end,
		true
	);
	
	-- spawn an army to fight when closing a rift
	core:add_listener(
		"army_closes_rift",
		"QueryTeleportationNetworkShouldHandoverCharacterNodeClosure",
		function(context)
			local closing_character = context:character_family_member();
			
			if not closing_character:is_null_interface() then
				local character = closing_character:character();
				
				if not character:is_null_interface() then
					if character:has_military_force() then
						return true;
					else
						-- hero closed the rift, trigger event to complete rift closure narrative mission
						core:trigger_event("ScriptEventRiftClosureBattleWon", character);
					end;
				end;
			end;
		end,
		function(context)
			context:flag_for_script_handover();
		end,
		true
	);
	
	core:add_listener(
		"army_closes_rift_battle",
		"TeleportationNetworkCharacterNodeClosureHandedOver",
		function(context)
			local closing_character = context:character_family_member();
			
			if not closing_character:is_null_interface() then
				local character = closing_character:character();
				
				return not character:is_null_interface() and character:has_military_force();
			end;
		end,
		function(context)
			local character = context:character_family_member():character();
			
			cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
			cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
			
			cm:set_saved_value("rift_closure_battle_active", {context:node_key(), context:template_key(), character:command_queue_index()});
			generate_rift_closure_battle_force(character, context:template_key());
			rift_closure_battle_cleanup();
		end,
		true
	);
	
	-- restore cleanup listener if saved on pre battle screen
	if cm:get_saved_value("rift_closure_battle_active") then
		rift_closure_battle_cleanup();
	end;
	
	-- set up realm when an army teleports into it
	core:add_listener(
		"army_enters_realm",
		"TeleportationNetworkMoveCompleted",
		function(context)
			return not context:character():character():is_null_interface() and context:success();
		end,
		function(context)
			local from_record = context:from_record();
			local from_template_key = from_record:template_key();
			local to_template_key = context:to_record():template_key();
			local character = context:character():character();
			local faction = character:faction();
			local is_human = faction:is_human();
			local faction_name = faction:name();
			
			if from_template_key:ends_with("_realm") then
				-- army has teleported from within a realm, teleport any unembedded heroes back to where they originally entered from
				teleport_characters_out_of_realm(faction, realm_mapping[from_template_key:gsub("_realm", "")]);
			else
				local x, y = from_record:position();
				cache_teleport_entry_point(character, x, y);
			end;
			
			-- army has entered realm
			if to_template_key:ends_with("_realm") then
				local realm = realm_mapping[to_template_key:gsub("_realm", "")];
				
				-- remove any khorne ancillaries
				for k, v in pairs(khorne_realm_encounters) do
					if faction:ancillary_exists(v[3]) then
						cm:force_remove_ancillary_from_faction(faction, v[3]);
						
						if is_human then
							cm:trigger_incident(faction_name, "wh3_main_incident_faction_loses_khorne_realm_weapon", true);
						end;
					end;
				end;
				
				-- if entering slaanesh, make sure they don't enter at the same spot as someone else
				if realm == "slaanesh" then
					local region_data = character:region_data();
					local character_in_area = false;
					local world = cm:model():world();
					local faction_list = world:faction_list();
					
					for i = 0, faction_list:num_items() - 1 do
						local current_faction = faction_list:item_at(i);
						
						if not current_faction:pooled_resource_manager():resource("wh3_main_realm_complete_khorne"):is_null_interface() and not region_data:characters_of_faction_in_region(current_faction):is_empty() then
							character_in_area = true;
							break;
						end;
					end;
					
					if character_in_area then
						local spawn_positions = realm_data["slaanesh"]["spawn_positions"];
						
						for i = 1, #spawn_positions do
							local character_in_current_area = false;
							local current_region_data = world:region_data_at_position(spawn_positions[i][1], spawn_positions[i][2]);
							
							for j = 0, faction_list:num_items() - 1 do
								local current_faction = faction_list:item_at(j);
								
								if not current_faction:pooled_resource_manager():resource("wh3_main_realm_complete_khorne"):is_null_interface() and not current_region_data:characters_of_faction_in_region(current_faction):is_empty() then
									character_in_current_area = true;
									break;
								end;
							end;
							
							if not character_in_current_area then
								cm:teleport_to(cm:char_lookup_str(character), spawn_positions[i][1], spawn_positions[i][2]);
								break;
							end;
						end;
					end;
				end;
				
				if is_human then
					sm:trigger_message(realm:gsub("^%l", string.upper) .. "RealmOpenedFactionSwitch", {faction_key = faction_name});
					
					-- completes "Open Realm" narrative mission, if active
					core:trigger_custom_event("ScriptEventPlayerOpensRealm", {realm = realm, faction = faction});
					
					cm:callback(function() open_and_initiate_realm(realm, faction) end, 0.5);
				else
					open_and_initiate_realm(realm, faction);
				end;
			-- army has traversed between rifts
			else
				if to_template_key:ends_with("forge_of_souls") then
					out.chaos("Forge of Souls entered by " .. faction_name);
					
					if is_human then
						-- reveal the shroud over all the realms
						toggle_realm_shroud(faction, true);
						cm:force_terrain_patch_visible("wh3_main_patch_area_forge_of_souls");
						cm:force_terrain_patch_visible("wh3_main_patch_area_khorne_realm");
						cm:force_terrain_patch_visible("wh3_main_patch_area_nurgle_realm");
						cm:force_terrain_patch_visible("wh3_main_patch_area_slaanesh_realm");
						cm:force_terrain_patch_visible("wh3_main_patch_area_tzeentch_realm");
					end;
					
					-- offer a dilemma to the player to jump into the forge to meet the AI immediately
					if not is_human and not cm:get_saved_value("intercept_forge_dilemma_active") then
						local human_factions = cm:get_human_factions();
						-- in multiplayer, only offer the dilemma to the host
						local first_human = cm:get_faction(human_factions[1]);
						local x, y = cm:find_valid_spawn_location_for_character_from_position(human_factions[1], forge_of_souls_dest_x, forge_of_souls_dest_y, true);
						
						if x > 0 and first_human:has_faction_leader() then
							local faction_leader = first_human:faction_leader();
							local has_garrison_residence = faction_leader:has_garrison_residence();
							
							if faction_leader:has_military_force() and (is_faction_in_realm(first_human) or (faction_leader:has_region() and not has_garrison_residence) or (has_garrison_residence and not faction_leader:garrison_residence():is_under_siege())) then
								local first_human_cqi = first_human:command_queue_index();
								
								cm:trigger_dilemma_with_targets(first_human_cqi, "wh3_main_dilemma_forge_of_souls_entered", faction:command_queue_index(), first_human_cqi, 0, faction_leader:military_force():command_queue_index(), 0, 0);
								cm:set_saved_value("intercept_forge_dilemma_active", true);
								
								core:add_listener(
									"intercept_forge_dilemma_choice",
									"DilemmaChoiceMadeEvent",
									function(context)
										return context:dilemma() == "wh3_main_dilemma_forge_of_souls_entered";
									end,
									function(context)
										cm:set_saved_value("intercept_forge_dilemma_active", false);
										
										if context:choice() == 0 then
											cm:teleport_to(cm:char_lookup_str(faction_leader), x, y);
											local camera_x, camera_y = cm:log_to_dis(x, y);
											cm:scroll_camera_from_current(true, 1, {camera_x, camera_y, 13, 0, 10});
										end;
									end,
									false
								);
							end;
						end;
					end;
				end;
				
				if is_human then
					cancel_active_survival_battle_mission(faction);
					
					-- cut camera to character that's come out of the rift
					if cm:get_local_faction_name(true) == faction_name then
						local cached_x, cached_y, cached_d, cached_b, cached_h = cm:get_camera_position();
						cm:scroll_camera_from_current(true, 1, {character:display_position_x(), character:display_position_y(), 13, cached_b, 10});
					end;
				end;
				
				cm:set_saved_value(faction_name .. "_is_in_realm", "");
				common.set_context_value(faction_name .. "_is_in_realm", "");
				
				update_shared_states();
			end;
			
			-- reset khorne realm points
			reset_khorne_realm_points(faction);
		end,
		true
	);
	
	-- if an ai faction is in the forge of souls region, move to the final position, the player will then lose the campaign
	core:add_listener(
		"ai_behaviour_in_forge",
		"FactionBeginTurnPhaseNormal",
		function(context)
			local faction = context:faction();
			
			return not faction:is_human() and is_faction_in_forge(faction) and not faction:pooled_resource_manager():resource("wh3_main_realm_complete_khorne"):is_null_interface();
		end,
		function(context)
			local faction = context:faction();
			local faction_name = faction:name();
			
			-- get the first army that's in the forge, just in case it's not the faction leader
			local character = false;
			local character_list = cm:get_region_data("wh3_main_chaos_region_the_forge_of_souls"):characters_of_faction_in_region(faction);
			
			for i = 0, character_list:num_items() - 1 do
				local current_character = character_list:item_at(i);
				
				if cm:char_is_general_with_army(current_character) then
					character = current_character;
					break;
				end;
			end;
			
			if character then
				if find_target_and_attack(character) then
					core:add_listener(
						"target_attacked_forge",
						"BattleCompleted",
						true,
						function()
							-- Delay this, otherwise move is discarded - don't pass in character reference as it might expire in the interval
							cm:callback(function() attempt_to_move_realm_character_to_desired_location(faction_name, nil, {x = forge_of_souls_dest_x, y = forge_of_souls_dest_y}) end, 0.2);
						end,
						false
					);
				else
					attempt_to_move_realm_character_to_desired_location(faction_name, character, {x = forge_of_souls_dest_x, y = forge_of_souls_dest_y});
				end;
			end;
		end,
		true
	);
	
	-- handle the scripted mission for defeating ai in forge
	core:add_listener(
		"ai_four_souls_mission_complete",
		"BattleCompleted",
		function()
			local pb = cm:model():pending_battle();
			return pb:region_data():key() == "wh3_main_chaos_region_the_forge_of_souls" and cm:pending_battle_cache_human_victory() and not pb:set_piece_battle_key():starts_with("wh3_main_survival_forge_of_souls_");
		end,
		function()
			local losing_faction = false;
			local human_factions = cm:get_human_factions();
			
			local function complete_ai_four_souls_mission(faction_name)
				for i = 1, #human_factions do
					cm:complete_scripted_mission_objective(human_factions[i], "wh3_main_ai_four_souls_forge_of_souls", "ai_four_souls_" .. faction_name, true);
				end;
				
				for realm, v in pairs(realm_data) do
					cm:faction_add_pooled_resource(faction_name, "wh3_main_realm_complete_" .. realm, "other", -1);
				end;
				
				cm:set_saved_value("faction_lost_at_forge_" .. faction_name, true);
			end;
			
			local function kill_characters_in_forge(faction_name)
				local faction = cm:get_faction(faction_name);
				local characters = cm:get_region_data("wh3_main_chaos_region_the_forge_of_souls"):characters_of_faction_in_region(faction);
				
				for i = 0, characters:num_items() - 1 do
					cm:kill_character(cm:char_lookup_str(characters:item_at(i)), true);
				end;
			end;
			
			if cm:pending_battle_cache_human_is_attacker() then
				for i = 1, cm:pending_battle_cache_num_defenders() do
					local current_defender = cm:pending_battle_cache_get_defender_faction_name(i);
					complete_ai_four_souls_mission(current_defender);
					
					kill_characters_in_forge(current_defender);
				end;
			elseif cm:pending_battle_cache_human_is_defender() then
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local current_attacker = cm:pending_battle_cache_get_attacker_faction_name(i);
					complete_ai_four_souls_mission(current_attacker);
					
					kill_characters_in_forge(current_attacker);
				end;
			end;
		end,
		true
	);
	
	--[[ show an event when the ai recovers from losing at the forge of souls
	core:add_listener(
		"ai_recovers_from_forge_of_souls",
		"CharacterRecruited",
		function(context)
			local character = context:character();
			local faction = character:faction();
			
			return cm:get_saved_value("faction_lost_at_forge_" .. faction:name()) and not faction:is_human() and character:is_faction_leader();
		end,
		function(context)
			local human_factions = cm:get_human_factions();
			
			for i = 1, #human_factions do
				cm:trigger_incident_with_targets(cm:get_faction(human_factions[i]):command_queue_index(), "wh3_main_incident_ai_recovers_from_forge_of_souls", context:character():faction():command_queue_index(), 0, 0, 0, 0, 0);
			end;
		end,
		true
	);]]
	
	-- cancel survival battle mission and reset ui if the player dies in a realm. if the faction leader is wounded, teleport the army out of the realm
	local function handle_character_dying_in_realm(character)
		local pb = cm:model():pending_battle();
		local faction = character:faction();
		local faction_name = faction:name();
		local realm = is_faction_in_realm(faction);
		local forge = is_faction_in_forge(faction);
		
		if (realm or forge) and not faction:pooled_resource_manager():resource("wh3_main_realm_complete_khorne"):is_null_interface() and faction:has_faction_leader() then
			local function teleport_out_of_realm_post_wound()
				if forge then
					teleport_characters_out_of_realm(faction, "forge_of_souls");
				else
					teleport_characters_out_of_realm(faction, realm);
				end;
				
				if faction:is_human() then
					-- don't cancel the survival battle mission if the player just won the survival battle
					if not pb:set_piece_battle_key():starts_with("wh3_main_survival_") or not cm:pending_battle_cache_human_victory() then
						cancel_active_survival_battle_mission(faction);
					end;
				else
					toggle_faction_leader_ai(faction, true);
				end;
				
				-- reset khorne realm points
				reset_khorne_realm_points(faction);
				
				cm:set_saved_value(faction_name .. "_is_in_realm", "");
				common.set_context_value(faction_name .. "_is_in_realm", "");
				
				update_shared_states();
			end;
			
			if pb:is_active() then
				core:add_listener(
					"return_army_from_realm",
					"BattleCompleted",
					true,
					function()
						teleport_out_of_realm_post_wound();
					end,
					false
				);
			else
				teleport_out_of_realm_post_wound();
			end;
		end;
	end;
	
	core:add_listener(
		"character_dies_in_realm",
		"CharacterDestroyed",
		function(context)
			local character = context:family_member():character();
			return not character:is_null_interface() and character:is_faction_leader();
		end,
		function(context)
			handle_character_dying_in_realm(context:family_member():character());
		end,
		true
	);
	
	core:add_listener(
		"character_wounded_in_realm",
		"CharacterConvalescedOrKilled",
		function(context)
			return context:character():is_faction_leader();
		end,
		function(context)
			handle_character_dying_in_realm(context:character());
		end,
		true
	);
	
	core:add_listener(
		"character_becomes_idle_in_realm",
		"FactionBecomesIdleHuman",
		true,
		function(context)
			local faction = context:faction();
			if faction:has_faction_leader() then
				handle_character_dying_in_realm(faction:faction_leader());
			end;
		end,
		true
	);
	
	-- it's possible for the primary faction to be confederated whilst they are in a realm/forge - in that case, teleport them out, as their faction leader will no longer be a faction leader. their progress will be taken over by the confederation's faction leader!
	core:add_listener(
		"character_is_confederated_in_realm",
		"FactionJoinsConfederation",
		true,
		function(context)
			local faction = context:confederation();
			local realm = is_faction_in_realm(faction);
			
			local function check_non_faction_leaders_in_realm(characters)
				for i = 0, characters:num_items() - 1 do
					local current_character = characters:item_at(i);
					
					-- check if they have a character that's leading an army and not a faction leader - this will be the former faction leader that's joined the confederation
					if current_character:has_military_force() and not current_character:is_faction_leader() then
						handle_character_dying_in_realm(current_character);
						break;
					end;
				end;
			end;
			
			if realm then
				for i = 1, #realm_data[realm]["region"] do
					check_non_faction_leaders_in_realm(cm:get_region_data(realm_data[realm]["region"][i]):characters_of_faction_in_region(faction));
				end;
			elseif is_faction_in_forge(faction) then
				check_non_faction_leaders_in_realm(cm:get_region_data("wh3_main_chaos_region_the_forge_of_souls"):characters_of_faction_in_region(faction));
			end;
		end,
		true
	);
	
	-- once the rifts are permanent (i.e. someone has completed all four realms), randomly respawn rifts each round (unless the campaign has been won)
	core:add_listener(
		"respawn_rifts",
		"WorldStartRound",
		function()
			return not cm:get_saved_value("campaign_completed") and cm:get_saved_value("rifts_permanent") and cm:random_number(5) == 1;
		end,
		function()
			out.chaos("Opening random rifts");
			
			for template, realm in pairs(realm_mapping) do
				open_random_nodes_with_bonus_value(template, 3);
			end;
		end,
		true
	);
	
	-- dev ui for completing a realm
	core:add_listener(
		"dev_ui_button_pressed_complete_realm",
		"ComponentLClickUp",
		function(context)
			return context.string:starts_with("dev_button_complete_realm_");
		end,
		function(context)
			local realm = context.string:gsub("dev_button_complete_realm_", "");
			CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(cm:get_local_faction_name(true)):command_queue_index(), "dev_button_realm_complete_pressed_" .. realm)
		end,
		true
	);
	
	core:add_listener(
		"dev_ui_button_pressed_complete_realm_result",
		"UITrigger",
		function(context)
			return context:trigger():starts_with("dev_button_realm_complete_pressed_");
		end,
		function(context)
			-- ensure the realms ui is visible
			cm:set_saved_value("tome_of_fates_story_panel_shown", true);
			common.set_context_value("tome_of_fates_story_panel_shown", 1);
			
			close_realm(cm:model():faction_for_command_queue_index(context:faction_cqi()):name(), context:trigger():gsub("dev_button_realm_complete_pressed_", ""));
		end,
		true
	);
	
	-- dev ui for opening rifts
	core:add_listener(
		"dev_ui_button_pressed_open_rifts",
		"ComponentLClickUp",
		function(context)
			return context.string == "dev_button_open_rifts";
		end,
		function()
			CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(cm:get_local_faction_name(true)):command_queue_index(), "dev_button_open_rifts_pressed")
		end,
		true
	);
	
	core:add_listener(
		"dev_ui_button_pressed_open_rifts_result",
		"UITrigger",
		function(context)
			return context:trigger() == "dev_button_open_rifts_pressed";
		end,
		function()
			if are_any_rifts_open() then
				close_realm(false, "khorne");
				close_realm(false, "nurgle");
				close_realm(false, "slaanesh");
				close_realm(false, "tzeentch");
			else
				trigger_ursuns_roar_event();
			end;
		end,
		true
	);
	
	-- dev ui for entering a realm immediately. not mp ready
	if not cm:is_multiplayer() then
		core:add_listener(
			"dev_ui_button_pressed_enter_realm",
			"ComponentLClickUp",
			function(context)
				return context.string:starts_with("dev_button_enter_realm_");
			end,
			function(context)
				local local_faction_name = cm:get_local_faction_name(true);
				local local_faction = cm:get_faction(local_faction_name);
				local realm = context.string:gsub("dev_button_enter_realm_", "");
				
				sm:trigger_message(realm:gsub("^%l", string.upper) .. "RealmOpenedFactionSwitch", {faction_key = local_faction_name});
				
				-- completes "Open Realm" narrative mission, if active
				core:trigger_custom_event("ScriptEventPlayerOpensRealm", {realm = realm, faction = local_faction});
				
				local character = local_faction:faction_leader();
				cache_teleport_entry_point(character, character:logical_position_x(), character:logical_position_y());
				
				local spawn_loc = realm_data[realm]["spawn_positions"][1];
				cm:teleport_to(cm:char_lookup_str(character), spawn_loc[1], spawn_loc[2]);
				
				cm:callback(function() open_and_initiate_realm(realm, local_faction) end, 0.5);
			end,
			true
		);
	end;
	
	-- pass the number of realms completed by the player when fighting a survival battle in order for the battle to show the correct loading screen
	core:add_listener(
		"player_initiates_survival_battle",
		"PendingBattle",
		function(context)
			return context:pending_battle():set_piece_battle_key():starts_with("wh3_main_survival_");
		end,
		function(context)
			local pb = context:pending_battle();
			local num_realms_completed = -1;
			
			if pb:has_attacker() then
				local attacker_faction = pb:attacker():faction();
				
				if attacker_faction:is_human() then
					num_realms_completed = get_num_realms_completed(attacker_faction);
				end;
			end;
			
			if num_realms_completed == -1 and pb:has_defender() then
				local defender_faction = pb:attacker():faction();
				
				if defender_faction:is_human() then
					num_realms_completed = get_num_realms_completed(defender_faction);
				end;
			end;
			
			core:svr_save_string("player_num_realms_completed", tostring(num_realms_completed));
		end,
		true
	);
	
	-- handle players winning a survival battle, or completing the campaign
	core:add_listener(
		"player_wins_survival_battle",
		"MissionSucceeded",
		function(context)
			local mission_key = context:mission():mission_record_key();
			return mission_key:starts_with("wh3_main_survival_");
		end,
		function(context)
			local mission_faction = context:faction();
			local faction_name = mission_faction:name();
			local local_faction = cm:get_local_faction_name(true);
			local team_mates = mission_faction:team_mates();
			local mission = context:mission():mission_record_key();
			
			if mission:find("forge_of_souls") then
				local win_movies = {
					["wh3_main_cth_the_northern_provinces"] =	{"warhammer3/cth/", "cth_win"},
					["wh3_main_cth_the_western_provinces"] =	{"warhammer3/cth/", "cth_win"},
					["wh3_main_dae_daemon_prince"] =			{"warhammer3/dae/", "dae_win"},
					["wh3_main_kho_exiles_of_khorne"] =			{"warhammer3/kho/", "kho_win_ska"},
					["wh3_main_ksl_the_great_orthodoxy"] =		{"warhammer3/ksl/", "ksl_win_kot"},
					["wh3_main_ksl_the_ice_court"] =			{"warhammer3/ksl/", "ksl_win_kat"},
					["wh3_main_ksl_ursun_revivalists"] = 		{"warhammer3/ksl/", "ksl_win_bor"},
					["wh3_main_nur_poxmakers_of_nurgle"] =		{"warhammer3/nur/", "nur_win_plg"},
					["wh3_main_ogr_disciples_of_the_maw"] =		{"warhammer3/ogr/", "ogr_win_skg"},
					["wh3_main_ogr_goldtooth"] = 				{"warhammer3/ogr/", "ogr_win_gre"},
					["wh3_main_sla_seducers_of_slaanesh"] =		{"warhammer3/sla/", "sla_win_nka"},
					["wh3_main_tze_oracles_of_tzeentch"] =		{"warhammer3/tze/", "tze_win_fat"}
				};
				
				cm:set_saved_value("campaign_completed", true);
				update_shared_states();
				
				cm:remove_hex_area_trigger("ai_final_battle_location");
				
				cm:teleportation_network_close_node("wh3_main_chaos_forge_of_souls");
				
				if cm:is_multiplayer() then
					if local_faction == faction_name then
						play_and_unlock_movie(win_movies[faction_name][1] .. win_movies[faction_name][2], win_movies[faction_name][2]);
					end;
					
					for i = 0, team_mates:num_items() - 1 do
						if local_faction == team_mates:item_at(i):name() then
							play_and_unlock_movie(win_movies[faction_name][1] .. win_movies[faction_name][2], win_movies[faction_name][2]);
						end;
					end;
				else
					play_and_unlock_movie(win_movies[faction_name][1] .. win_movies[faction_name][2], win_movies[faction_name][2]);
				end;
				
				local dilemma_key = "wh3_main_dilemma_chaos_campaign_victory";
				
				if mission_faction:culture() == "wh3_main_ksl_kislev" then
					dilemma_key = dilemma_key .. "_kislev";
				end;
				
				cm:trigger_dilemma(faction_name, dilemma_key);
				
				cm:disable_event_feed_events(true, "", "", "faction_campaign_victory_objective_complete");
				
				cm:add_turn_countdown_event(faction_name, 2, "ScriptEventShowEpilogueEvent_" .. faction_name, faction_name);
				
				core:add_listener(
					"continue_after_victory_dilemma",
					"DilemmaChoiceMadeEvent",
					function(context)
						return context:dilemma():starts_with("wh3_main_dilemma_chaos_campaign_victory");
					end,
					function(context)
						local faction = context:faction();
						local faction_name = faction:name();
						
						-- complete the realm objectives in case they were skipped for testing
						if cm:is_multiplayer() then
							local human_factions = cm:get_human_factions();
							
							for i = 1, #human_factions do
								local current_human_faction_name = human_factions[i];
								local current_human_faction = cm:get_faction(current_human_faction_name);
								
								if current_human_faction == faction or faction:is_team_mate(current_human_faction) then
									cm:complete_scripted_mission_objective(current_human_faction_name, "wh3_main_mp_victory", "realms_multiplayer", true);
									cm:complete_scripted_mission_objective(current_human_faction_name, "wh3_main_mp_victory", "forge_of_souls_battle", true);
								else
									cm:complete_scripted_mission_objective(current_human_faction_name, "wh3_main_mp_victory", "realms_multiplayer", false);
									cm:complete_scripted_mission_objective(current_human_faction_name, "wh3_main_mp_victory", "forge_of_souls_battle", false);
								end;
							end;
						else
							cm:complete_scripted_mission_objective(faction_name, "wh_main_long_victory", "realm_khorne", true);
							cm:complete_scripted_mission_objective(faction_name, "wh_main_long_victory", "realm_nurgle", true);
							cm:complete_scripted_mission_objective(faction_name, "wh_main_long_victory", "realm_slaanesh", true);
							cm:complete_scripted_mission_objective(faction_name, "wh_main_long_victory", "realm_tzeentch", true);
							cm:complete_scripted_mission_objective(faction_name, "wh_main_long_victory", "forge_of_souls_battle", true);
						end;
						
						cm:reset_forced_terrain_patch_visibility();
									
						local cached_x, cached_y, teleported_x, teleported_y = teleport_characters_out_of_realm(faction, "forge_of_souls");
						
						cm:trigger_dilemma(faction_name, "wh3_main_dilemma_chaos_campaign_belakor_decision");
						
						core:add_listener(
							"spawn_belakor",
							"DilemmaChoiceMadeEvent",
							function(context)
								return context:dilemma() == "wh3_main_dilemma_chaos_campaign_belakor_decision";
							end,
							function(context)
								if context:choice() == 1 then
									local x, y = -1, -1;
									
									if faction:has_home_region() then
										x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction_name, faction:home_region():name(), false, true, 4);
									end;
									
									if x == -1 then
										x, y = cm:find_valid_spawn_location_for_character_from_position(faction_name, teleported_x, teleported_y, true, 4);
									end;
									
									if x > 0 then
										cm:create_force_with_general(
											faction_name,
											"",
											cm:model():world():region_manager():region_list():item_at(0):name(),
											x,
											y,
											"general",
											"wh3_main_dae_belakor",
											"names_name_1088515835",
											"",
											"",
											"",
											false,
											function(cqi)
												local cam_x, cam_y = cm:log_to_dis(x, y);
												cm:set_camera_position(cam_x, cam_y, 13, 0, 10);
												
												local char_lookup_str = cm:char_lookup_str(cqi);
												local belakor = cm:get_character_by_cqi(cqi)
												cm:set_character_immortality(char_lookup_str, true);
												cm:add_agent_experience(char_lookup_str, 20, true);
												cm:force_add_ancillary(belakor, "wh3_main_anc_weapon_blade_of_shadow", true, true);
											end
										);
									end;
								else
									local cam_x, cam_y = cm:log_to_dis(teleported_x, teleported_y);
									cm:set_camera_position(cam_x, cam_y, 13, 0, 10);
								end;
							end,
							false
						);
						
						-- remove any other factions from the forge too
						local faction_list = cm:model():world():faction_list();
						local timer = 0;
						
						for i = 0, faction_list:num_items() - 1 do
							cm:callback(
								function()
									local current_faction = faction_list:item_at(i);
									
									if not current_faction:is_dead() and not current_faction:pooled_resource_manager():resource("wh3_main_realm_complete_khorne"):is_null_interface() and is_faction_in_forge(current_faction) then
										teleport_characters_out_of_realm(current_faction, "forge_of_souls");
										
										timer = timer + 0.2;
									end;
								end,
								timer
							);
						end;
						
						core:add_listener(
							"campaign_quit",
							"ComponentLClickUp",
							function(context)
								return context.string == "button_quit";
							end,
							function()
								core:svr_save_bool("sbool_frontend_play_credits_immediately", true);
							end,
							false
						);
					end,
					false
				);
			else
				local realm_completed = "khorne";
				
				if mission:find("nurgle") then
					realm_completed = "nurgle";
				elseif mission:find("slaanesh") then
					realm_completed = "slaanesh";
				elseif mission:find("tzeentch") then
					realm_completed = "tzeentch";
				end;
				
				core:trigger_custom_event("ScriptEventPlayerCompletesRealm", {realm = realm_completed, faction = mission_faction});
				
				local has_already_completed_realm = false;
				
				local realms_completed = get_num_realms_completed(mission_faction, true);
				
				if realms_completed[realm_completed] > 0 then
					has_already_completed_realm = true;
				end;
				
				close_realm(faction_name, realm_completed);
				
				if not cm:get_saved_value("campaign_completed") and not has_already_completed_realm then
					local num_realms_completed = get_num_realms_completed(mission_faction);
					
					local movie_str = "belakor_" .. num_realms_completed;
					local unlock_str = movie_str;
					
					if movie_str == "belakor_4" then
						local local_faction_culture = cm:get_faction(local_faction):culture();
						
						if local_faction_culture == "wh3_main_ogr_ogre_kingdoms" then
							movie_str = movie_str .. "_ogr";
						elseif local_faction_culture == "wh3_main_cth_cathay" or local_faction_culture == "wh3_main_ksl_kislev" then
							movie_str = movie_str .. "_alt";
						end;
					end;
					
					if cm:is_multiplayer() then
						if local_faction == faction_name then
							play_and_unlock_movie("warhammer3/" .. movie_str, unlock_str);
							
							if num_realms_completed == 4 then
								cm:complete_scripted_mission_objective(faction_name, "wh3_main_mp_victory", "realms_multiplayer", true);
							end;
						end;
						
						for i = 0, team_mates:num_items() - 1 do
							if local_faction == team_mates:item_at(i):name() then
								play_and_unlock_movie("warhammer3/" .. movie_str, unlock_str);
								
								if num_realms_completed == 4 then
									cm:complete_scripted_mission_objective(faction_name, "wh3_main_mp_victory", "realms_multiplayer", true);
								end;
							end;
						end;
					else
						play_and_unlock_movie("warhammer3/" .. movie_str, unlock_str);
						
						cm:complete_scripted_mission_objective(faction_name, "wh_main_long_victory", "realm_" .. realm_completed, true);
					end;
				end;
			end;
		end,
		true
	);
	
	-- reset any context values and ensure the forge of souls rift is open if necessary
	local world = cm:model():world();
	local faction_list = world:faction_list();
	local is_forge_rift_closed = world:teleportation_network_system():lookup_network("wh3_main_teleportation_network_chaos"):is_node_closed("wh3_main_chaos_forge_of_souls");
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		local current_faction_name = current_faction:name();
	
		if is_forge_rift_closed and get_num_realms_completed(current_faction) == 4 and not cm:get_saved_value("campaign_completed") then
			cm:teleportation_network_open_node("wh3_main_chaos_forge_of_souls", "wh3_main_teleportation_node_template_forge_of_souls");
		end;
		
		local value = cm:get_saved_value(current_faction_name .. "_is_in_realm");
		
		if value then
			common.set_context_value(current_faction_name .. "_is_in_realm", value);
		end;
		
		if cm:get_saved_value("slaanesh_realm_offer_taken_" .. current_faction_name) then
			common.set_context_value("slaanesh_realm_offer_taken_" .. current_faction_name, 1);
		end;
	end;
	
	local function update_rifts_duration_display()
		if cm:get_saved_value("rifts_permanent") then
			common.set_context_value("rifts_active_duration", "permanent");
		elseif not cm:get_saved_value("rifts_closed_early") then
			local turns_remaining, a, e, c = cm:report_turns_until_countdown_event(false, "ScriptEventRiftsExpire");
			common.set_context_value("rifts_active_duration", turns_remaining or 0);
		end;
	end;
	
	if are_any_rifts_open(true) then
		update_rifts_duration_display()
	end;
	
	-- update the rifts duration context value each round
	core:add_listener(
		"update_rifts_duration_display",
		"WorldStartRound",
		true,
		function()
			update_rifts_duration_display()
		end,
		true
	);
	
	-- close rifts when duration expires
	core:add_listener(
		"rift_duration_expires",
		"ScriptEventRiftsExpire",
		function()
			return not cm:get_saved_value("rifts_permanent");
		end,
		function()
			for template, realm in pairs(realm_mapping) do
				cm:teleportation_network_close_all_nodes("wh3_main_teleportation_network_chaos", template);
			end;
			
			-- kill all heroes that spawned from rifts
			local rift_factions = {
				"wh3_main_rogue_the_bloody_harvest",
				"wh3_main_rogue_the_putrid_swarm",
				"wh3_main_rogue_the_pleasure_tide",
				"wh3_main_rogue_the_fluxion_host",
				"wh3_main_rogue_shadow_legion"
			};
			
			for i = 1, #rift_factions do
				local character_list = cm:get_faction(rift_factions[i]):character_list();
				
				for j = 0, character_list:num_items() - 1 do
					local current_character = character_list:item_at(j);
					
					if cm:char_is_agent(current_character) then
						cm:kill_character(cm:char_lookup_str(current_character), true);
					end;
				end;
			end;
			
			local human_factions = cm:get_human_factions();
			
			for i = 1, #human_factions do
				cm:trigger_incident(human_factions[i], "wh3_main_incident_rifts_close", true);
			end;
			
			cm:add_round_turn_countdown_event(rifts_cooldown, "ScriptEventUrsunsRoarCooldownExpires");
		end,
		true
	);
	
	-- replenish teleport after leaving slaanesh realm
	core:add_listener(
		"replenish_teleport_token_slaanesh",
		"ScriptEventSlaaneshRealmCooldownExpires",
		true,
		function(context)
			local faction_name = context.string;
			
			cm:set_saved_value("slaanesh_realm_offer_taken_" .. faction_name, false);
			common.set_context_value("slaanesh_realm_offer_taken_" .. faction_name, 0);
			cm:faction_add_pooled_resource(faction_name, "wh3_main_enter_realm_cost", "other", 999);
		end,
		true
	);
	
	-- trigger epilogue event
	local human_factions = cm:get_human_factions();
	
	for i = 1, #human_factions do
		core:add_listener(
			"epilogue",
			"ScriptEventShowEpilogueEvent_" .. human_factions[i],
			true,
			function(context)
				local faction_name = context.string;
				
				cm:trigger_incident(faction_name, "wh3_main_incident_epilogue", true);
			end,
			false
		);
	end;
	
	-- show tome of fates story panel. this reveals the realm ui to the player
	local turn_number_to_trigger_tome_of_fates = 25;
	
	if cm:get_saved_value("tome_of_fates_story_panel_shown") then
		common.set_context_value("tome_of_fates_story_panel_shown", 1);
	else
		core:add_listener(
			"realm_of_chaos_story_panel_shown",
			"FactionTurnStart",
			function(context)
				return context:faction():is_human() and cm:model():turn_number() == turn_number_to_trigger_tome_of_fates;
			end,
			function(context)
				cm:set_saved_value("tome_of_fates_story_panel_shown", true);
				common.set_context_value("tome_of_fates_story_panel_shown", 1);
				
				show_story_panel(context:faction():name(), "wh3_main_story_panel_the_tome_of_fates");
			end,
			true
		);
	end;
	
	-- show realms story panel when player approaches rift
	core:add_listener(
		"realms_story_panel_shown",
		"TeleportationNetworkCharacterInteractionStarted",
		function(context)
			local faction = context:interacting_character():character():faction();
			return faction:is_human() and not cm:get_saved_value("realms_story_panel_shown_" .. faction:name());
		end,
		function(context)
			local faction_name = context:interacting_character():character():faction():name();
			cm:set_saved_value("realms_story_panel_shown_" .. faction_name, true);
			show_story_panel(faction_name, "wh3_main_story_panel_realms");
		end,
		true
	);
	
	-- show final battle failed story panel
	core:add_listener(
		"final_battle_failed",
		"BattleCompleted",
		function()
			local pb = cm:model():pending_battle();
			return pb:set_piece_battle_key():find("wh3_main_survival_forge_of_souls") and pb:has_been_fought() and not cm:pending_battle_cache_human_victory();
		end,
		function()
			show_story_panel(cm:pending_battle_cache_get_defender_faction_name(1), "wh3_main_story_panel_setback");
		end,
		true
	);
	
	-- show belakor ascending story panels
	if not cm:is_multiplayer() then
		core:add_listener(
			"belakor_ascends",
			"ScriptEventBelakorCountdown",
			function()
				return not cm:get_saved_value("campaign_completed");
			end,
			function(context)
				local separator_pos = string.find(context.string, ",");
				local faction_name = string.sub(context.string, 1, separator_pos - 1);
				local index = string.sub(context.string, separator_pos + 1);
				
				if index == "1" then
					show_story_panel(faction_name, "wh3_main_story_panel_ascension_coming");
				elseif index == "2" then
					show_story_panel(faction_name, "wh3_main_story_panel_ascension_close");
				elseif index == "3" then
					show_story_panel(faction_name, "wh3_main_story_panel_ascension_imminent");
				elseif index == "4" then
					cm:trigger_dilemma(faction_name, "wh3_main_story_panel_the_ascension");
					
					core:add_listener(
						"continue_after_defeat_dilemma",
						"DilemmaChoiceMadeEvent",
						function(context)
							return context:dilemma() == "wh3_main_story_panel_the_ascension";
						end,
						function(context)
							trigger_campaign_defeat(context:faction());
						end,
						true
					);
				end;
			end,
			true
		);
	end;
	
	-- play journey to forge movie when player approaches final battle
	if not cm:get_saved_value("journey_to_forge_movie_played") then
		core:add_listener(
			"journey_to_forge_movie",
			"PendingBattle",
			function(context)
				return context:pending_battle():set_piece_battle_key():starts_with("wh3_main_survival_forge_of_souls_");
			end,
			function(context)
				local pb = context:pending_battle();
				local local_faction = cm:get_local_faction_name(true);
				local movie_str = "warhammer3/journey_to_forge";
				local culture = false;
				
				if pb:has_attacker() and pb:attacker():faction():name() == local_faction then
					culture = pb:attacker():faction():culture();
				elseif pb:has_defender() and pb:defender():faction():name() == local_faction then
					culture = pb:defender():faction():culture();
				end;
				
				if culture then
					if culture == "wh3_main_cth_cathay" then
						movie_str = movie_str .. "_cth";
					elseif culture == "wh3_main_ksl_kislev" then
						movie_str = movie_str .. "_ksl";
					end;
					
					play_and_unlock_movie(movie_str, "journey_to_forge");
					cm:set_saved_value("journey_to_forge_movie_played", true);
				end;
			end,
			false
		);
	end;
	
	core:add_listener(
		"ai_enters_final_battle_location",
		"AreaEntered",
		function(context)
			local character = context:family_member():character();
			if not character:is_null_interface() then
				local faction = character:faction();
				return context:area_key() == "ai_final_battle_location" and not faction:is_human() and get_num_realms_completed(faction) == 4 and cm:char_is_general_with_army(character) and not cm:model():pending_battle():is_active();
			end;
		end,
		function(context)
			local character = context:family_member():character();
			if character:is_null_interface() then
				return;
			end;
			
			local faction = character:faction();
			local faction_name = faction:name();
			local human_factions = cm:get_human_factions();
			
			if can_ai_army_complete_final_battle(character:military_force()) then
				out.chaos(faction_name .. " has reached the forge of souls, the campaign is over");
				
				for i = 1, #human_factions do
					cm:trigger_dilemma(human_factions[i], "wh3_main_dilemma_chaos_campaign_defeat");
				end;
				
				core:add_listener(
					"continue_after_defeat_dilemma",
					"DilemmaChoiceMadeEvent",
					function(context)
						return context:dilemma() == "wh3_main_dilemma_chaos_campaign_defeat";
					end,
					function(context)
						trigger_campaign_defeat(context:faction());
					end,
					true
				);
				
				cm:set_saved_value("campaign_completed", true);
				update_shared_states();
				
				-- for autoruns, close the rift and remove all the armies
				cm:teleportation_network_close_node("wh3_main_chaos_forge_of_souls");
				
				cm:remove_hex_area_trigger("ai_final_battle_location");
				
				local faction_list = cm:model():world():faction_list();
				local timer = 0;
				
				for i = 0, faction_list:num_items() - 1 do
					cm:callback(
						function()
							local current_faction = faction_list:item_at(i);
							
							if not current_faction:is_dead() and not current_faction:pooled_resource_manager():resource("wh3_main_realm_complete_khorne"):is_null_interface() and is_faction_in_forge(current_faction) then
								teleport_characters_out_of_realm(current_faction, "forge_of_souls");
								
								timer = timer + 0.2;
							end;
						end,
						timer
					);
				end;
			else
				cm:set_saved_value("faction_lost_at_forge_" .. faction_name, true);
				
				for i = 1, #human_factions do
					cm:trigger_incident_with_targets(cm:get_faction(human_factions[i]):command_queue_index(), "wh3_main_incident_faction_loses_to_belakor", faction:command_queue_index(), 0, 0, 0, 0, 0);
				end;
			end;
		end,
		true
	);
	
	-- spawn chaos armies/heroes out of rifts
	local ram = random_army_manager;
	
	ram:new_force("rift_army_khorne");
	ram:new_force("rift_army_nurgle");
	ram:new_force("rift_army_slaanesh");
	ram:new_force("rift_army_tzeentch");
	
	ram:add_mandatory_unit("rift_army_khorne",		"wh3_main_kho_inf_bloodletters_0",		1);
	ram:add_unit("rift_army_khorne",				"wh3_main_kho_inf_bloodletters_0",		3);
	ram:add_unit("rift_army_khorne",				"wh3_main_kho_inf_chaos_warhounds_0",	1);
	ram:add_unit("rift_army_khorne",				"wh3_main_kho_inf_chaos_warriors_0",	1);
	
	ram:add_mandatory_unit("rift_army_nurgle",		"wh3_main_nur_inf_plaguebearers_0",		1);
	ram:add_unit("rift_army_nurgle",				"wh3_main_nur_inf_plaguebearers_0",		3);
	ram:add_unit("rift_army_nurgle",				"wh3_main_nur_inf_nurglings_0",			1);
	ram:add_unit("rift_army_nurgle",				"wh3_main_nur_mon_rot_flies_0",			1);
	
	ram:add_mandatory_unit("rift_army_slaanesh",	"wh3_main_sla_inf_daemonette_0",		1);
	ram:add_unit("rift_army_slaanesh",				"wh3_main_sla_inf_daemonette_0",		3);
	ram:add_unit("rift_army_slaanesh",				"wh3_main_sla_inf_marauders_0",			1);
	ram:add_unit("rift_army_slaanesh",				"wh3_main_sla_cav_hellstriders_0",		1);
	
	ram:add_mandatory_unit("rift_army_tzeentch",	"wh3_main_tze_inf_pink_horrors_0",		1);
	ram:add_unit("rift_army_tzeentch",				"wh3_main_tze_inf_pink_horrors_0",		3);
	ram:add_unit("rift_army_tzeentch",				"wh3_main_tze_inf_blue_horrors_0",		1);
	ram:add_unit("rift_army_tzeentch",				"wh3_main_tze_mon_screamers_0",			1);
	
	ram:combine_forces("rift_army_belakor", "rift_army_khorne", "rift_army_nurgle", "rift_army_slaanesh", "rift_army_tzeentch");
	
	ram:add_unit("rift_army_belakor",				"wh3_main_kho_mon_soul_grinder_0",		5);
	ram:add_unit("rift_army_belakor",				"wh3_main_nur_mon_soul_grinder_0",		5);
	ram:add_unit("rift_army_belakor",				"wh3_main_sla_mon_soul_grinder_0",		5);
	ram:add_unit("rift_army_belakor",				"wh3_main_tze_mon_soul_grinder_0",		5);
	
	core:add_listener(
		"spawn_chaos_out_of_rifts",
		"ScriptEventSpawnChaosFromRifts",
		function()
			return not cm:get_saved_value("campaign_completed");
		end,
		function(context)
			local world = cm:model():world();
			local open_nodes = world:teleportation_network_system():lookup_network("wh3_main_teleportation_network_chaos"):open_nodes();
			local anything_spawned = false;
			local faction_list = world:faction_list();
			
			local human_factions = cm:get_human_factions();
			local highest_realm_count = 0;
			
			-- if there are human players, track the player that is in the lead
			if #human_factions > 0 then
				for i = 1, #human_factions do
					local current_human_faction_realm_count = get_num_realms_completed(cm:get_faction(human_factions[i]));
					
					if current_human_faction_realm_count > highest_realm_count then
						highest_realm_count = current_human_faction_realm_count;
					end;
				end;
			-- otherwise we're in an autorun, so track the ai
			else
				for i = 0, faction_list:num_items() - 1 do
					local current_faction = faction_list:item_at(i);
					
					if not current_faction:pooled_resource_manager():resource("wh3_main_realm_complete_khorne"):is_null_interface() then
						local current_ai_faction_realm_count = get_num_realms_completed(current_faction);
						
						if current_ai_faction_realm_count > highest_realm_count then
							highest_realm_count = current_ai_faction_realm_count;
						end;
					end;
				end;
			end;
			
			-- don't spawn more than 20 heroes per faction
			local rift_hero_counts = {
				["wh3_main_rogue_the_bloody_harvest"] = 0,
				["wh3_main_rogue_the_putrid_swarm"] = 0,
				["wh3_main_rogue_the_pleasure_tide"] = 0,
				["wh3_main_rogue_the_fluxion_host"] = 0,
				["wh3_main_rogue_shadow_legion"] = 0
			};
			
			for faction, count in pairs(rift_hero_counts) do
				local character_list = cm:get_faction(faction):character_list();
				
				for i = 0, character_list:num_items() - 1 do
					if cm:char_is_agent(character_list:item_at(i)) then
						rift_hero_counts[faction] = rift_hero_counts[faction] + 1;
					end;
				end;
			end;
			
			-- spawn one character from a rift for every 5 provinces owned
			for i = 0, faction_list:num_items() - 1 do
				local current_faction = faction_list:item_at(i);
				
				if not current_faction:is_dead() and current_faction:has_home_region() then
					local number_of_rifts_to_spawn_from = math.ceil(current_faction:num_provinces() / 5);
					local number_of_characters_spawned = 0;
					
					for j = 0, open_nodes:num_items() - 1 do
						if number_of_characters_spawned >= number_of_rifts_to_spawn_from then
							break;
						else
							local current_node = open_nodes:item_at(j);
							local x, y = current_node:position();
							local god = realm_mapping[current_node:template_key()];
							local region_data = world:region_data_at_position(x, y);
							
							if not region_data:is_null_interface() then
								local region = region_data:region();
								
								if not region:is_null_interface() and not region:is_abandoned() and region:owning_faction() == current_faction and god then
									local size = 11;
									local rank = 3;
									local subtype = "wh3_main_kho_cultist";
									local type = "dignitary"
									local faction_key = "wh3_main_rogue_the_bloody_harvest";
									local units = "";
									
									if highest_realm_count == 1 then
										size = 13;
										rank = 5;
									elseif highest_realm_count == 2 then
										size = 15;
										rank = 15;
									elseif highest_realm_count == 3 then
										size = 17;
										rank = 25;
									elseif highest_realm_count == 4 then
										size = 19;
										rank = 35;
									end;
									
									if god == "khorne" then
										units = ram:generate_force("rift_army_khorne", size);
										type = "runesmith";
									elseif god == "nurgle" then
										subtype = "wh3_main_nur_cultist";
										faction_key = "wh3_main_rogue_the_putrid_swarm";
										units = ram:generate_force("rift_army_nurgle", size);
									elseif god == "slaanesh" then
										subtype = "wh3_main_sla_cultist";
										faction_key = "wh3_main_rogue_the_pleasure_tide";
										units = ram:generate_force("rift_army_slaanesh", size);
									elseif god == "tzeentch" then
										subtype = "wh3_main_tze_cultist";
										faction_key = "wh3_main_rogue_the_fluxion_host";
										units = ram:generate_force("rift_army_tzeentch", size);
									end;
									
									-- override the faction if the owner of the region that contains the rifts has 3 or more souls
									if highest_realm_count >= 3 then
										if not region:is_abandoned() and get_num_realms_completed(region:owning_faction()) >= 3 then
											faction_key = "wh3_main_rogue_shadow_legion"
											units = ram:generate_force("rift_army_belakor", size);
										end;
									end;
									
									local spawn_pos_x, spawn_pos_y = cm:find_valid_spawn_location_for_character_from_position(faction_key, x, y, true);
									
									if spawn_pos_x > 0 then
										if context.string == "heroes" then
											if rift_hero_counts[faction_key] < 20 then
												local agent = cm:create_agent(
													faction_key,
													type,
													subtype,
													spawn_pos_x,
													spawn_pos_y
												);

												local faction = cm:get_faction(faction_key);
														
												if not faction:has_effect_bundle("wh3_main_bundle_rift_factions") then
													cm:apply_effect_bundle("wh3_main_bundle_rift_factions", faction_key, 0);
												end;
												
												if agent then
													cm:apply_effect_bundle_to_character("wh3_main_bundle_rift_hero", agent, 0);
													cm:add_agent_experience(cm:char_lookup_str(agent), rank, true);
													
													rift_hero_counts[faction_key] = rift_hero_counts[faction_key] + 1;
													number_of_characters_spawned = number_of_characters_spawned + 1;
													anything_spawned = true;
												end
											end;
										else
											cm:create_force(
												faction_key,
												units,
												"wh3_main_chaos_region_kislev",
												spawn_pos_x,
												spawn_pos_y,
												false,
												function(cqi)
													cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0);
													cm:add_agent_experience(cm:char_lookup_str(cqi), rank, true);
													
													local faction = cm:get_faction(faction_key);
													
													if not faction:has_effect_bundle("wh3_main_bundle_rift_factions") then
														cm:apply_effect_bundle("wh3_main_bundle_rift_factions", faction_key, 0);
													end;
												end
											);
										end;
									end;
								end;
							end;
						end;
					end;
				end;
			end;
			
			-- spawn another wave of armies
			if anything_spawned then
				local countdown = rifts_army_spawn_time;
				
				if context.string == "heroes" then
					countdown = rifts_army_spawn_time - rifts_hero_spawn_time;
				end;
				
				cm:add_round_turn_countdown_event(countdown, "ScriptEventSpawnChaosFromRifts", "armies");
			end;
		end,
		true
	);
	
	-- add traits when a character spends a long time in the realms. remove them when a character is garrisoned with a bonus value active in the region
	core:add_listener(
		"add_traits_in_realms",
		"FactionTurnStart",
		function(context)
			local faction = context:faction();
			
			return faction:is_human() and not faction:pooled_resource_manager():resource("wh3_main_realm_complete_khorne"):is_null_interface() and faction:has_faction_leader();
		end,
		function(context)
			local faction = context:faction();
			local character = faction:faction_leader();
			
			local realm = is_faction_in_realm(faction);
			
			if realm then
				local trait_name = get_chaos_trait_name(realm, faction:culture());
				
				if trait_name then
					cm:force_add_trait(cm:char_lookup_str(character), trait_name, true, 1);
				end;
			elseif character:in_settlement() then
				local value = character:region():bonus_values():scripted_value("chaos_realm_trait_removal", "value");
				if value > 0 or character:region():is_province_capital() then
					for realm, v in pairs(realm_data) do
						if cm:random_number(100) <= value then
							remove_chaos_trait(character, realm, true);
						end;
					end;
				end;
			end;
		end,
		true
	);
end;

function remove_chaos_trait(character, realm, remove_single_level)
	local trait_name = get_chaos_trait_name(realm, character:faction():culture());
	
	if trait_name then
		local num_points = math.min(character:trait_points(trait_name), 9);
		
		cm:force_remove_trait(cm:char_lookup_str(character), trait_name);
		
		if remove_single_level and num_points / 3 > 1 and not trait_name:find("_daemons") then
			cm:force_add_trait(cm:char_lookup_str(character), trait_name, false, (math.floor(num_points / 3 - 1)) * 3);
		end;
	end;
end;
			
function get_chaos_trait_name(realm, culture)
	local trait = "wh3_main_trait_realm_" .. realm;
	
	if culture == "wh3_main_kho_khorne" then
		if realm == "khorne" then
			return false;
		end;
		
		trait = trait .. "_daemons";
	elseif culture == "wh3_main_nur_nurgle" then
		if realm == "nurgle" then
			return false;
		end;
		
		trait = trait .. "_daemons";
	elseif culture == "wh3_main_sla_slaanesh" then
		if realm == "slaanesh" then
			return false;
		end;
		
		trait = trait .. "_daemons";
	elseif culture == "wh3_main_tze_tzeentch" then
		if realm == "tzeentch" then
			return false;
		end;
		
		trait = trait .. "_daemons";
	elseif culture == "wh3_main_dae_daemons" then
		trait = trait .. "_daemons";
	end;
	
	return trait;
end;

function setup_ursun_saved()

	-- trigger ursuns saved event
	core:add_listener(
		"ursun_saved",
		"WorldStartRound",
		function()
			return cm:turn_number() == 5 and not cm:get_saved_value("ursun_saved")
		end,
		function()
			cm:set_saved_value("ursun_saved", true)
			
			out.chaos("Turn " .. cm:turn_number() .. " - Trying to trigger the Ursun's Saved event");
			local human_factions = cm:get_human_factions();
			for i = 1, #human_factions do
				show_story_panel(human_factions[i], "wh3_dlc20_story_panel_ursun_saved");
			end;

		end,
		true
	);

end

function cache_teleport_entry_point(character, x, y)
	local faction_name = character:faction():name();
	
	-- army has teleported into a realm, cache their position
	local cached_teleport_entry_points = cm:get_saved_value("cached_teleport_entry_points") or {};
	
	-- remove faction from cache if it already exists
	for i = 1, #cached_teleport_entry_points do
		if cached_teleport_entry_points[i][1] == faction_name then
			table.remove(cached_teleport_entry_points, i);
			break;
		end;
	end;
	
	local mf = character:military_force();
	local unit_list = mf:unit_list();
	local units = {};
	
	-- skip the first unit, it's the general
	for i = 1, unit_list:num_items() - 1 do
		table.insert(units, unit_list:item_at(i):unit_key());
	end;
	
	table.insert(cached_teleport_entry_points, {faction_name, x, y, mf:command_queue_index(), units});
	cm:set_saved_value("cached_teleport_entry_points", cached_teleport_entry_points);
end;

function generate_rift_closure_battle_force(character, node_template)
	local mf = character:military_force();
	local faction = character:faction();
	local faction_name = faction:name();
	
	local rift_closure_battle_faction = rift_closure_force_data[node_template][1];
	local rift_closure_battle_units = random_army_manager:generate_force(rift_closure_force_data[node_template][2], 4 * math.min(cm:get_saved_value("ursuns_roar_count") or 1, 4));
	
	-- guard against invasion already existing
	invasion_manager:kill_invasion_by_key("rift_closure_battle_invasion");
	
	local invasion_1 = invasion_manager:new_invasion("rift_closure_battle_invasion", rift_closure_battle_faction, rift_closure_battle_units, {character:logical_position_x(), character:logical_position_y()});
	invasion_1:set_target("CHARACTER", character:command_queue_index(), faction_name);
	invasion_1:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
	invasion_1:start_invasion(
		function(self)
			core:add_listener(
				"rift_closure_battle_war_declared",
				"FactionLeaderDeclaresWar",
				function(context)
					return context:character():faction():name() == rift_closure_battle_faction;
				end,
				function()
					cm:set_force_has_retreated_this_turn(mf);
					cm:force_attack_of_opportunity(self:get_general():military_force():command_queue_index(), mf:command_queue_index(), false);
				end,
				false
			);
			
			cm:force_declare_war(rift_closure_battle_faction, faction_name, false, false);
		end,
		false,
		false,
		false
	);
	
	core:add_listener(
		"rift_closure_battle_end_of_round_cleanup",
		"EndOfRound", 
		true,
		function()
			kill_rift_closure_battle_invasion();
			cm:set_saved_value("rift_closure_battle_active", false);
		end,
		false
	);
end

function rift_closure_battle_cleanup()
	core:add_listener(
		"rift_closure_battle_cleanup",
		"BattleCompleted",
		function()
			return cm:get_saved_value("rift_closure_battle_active");
		end,
		function()
			local node_details = cm:get_saved_value("rift_closure_battle_active");
			
			-- close the rift if the battle was won
			if cm:pending_battle_cache_defender_victory() then
				cm:teleportation_network_close_node(node_details[1]);
				
				local char_cqi = node_details[3];
				local char = cm:get_character_by_cqi(char_cqi);
				if char then
					core:trigger_event("ScriptEventRiftClosureBattleWon", char);
				end;
			end;
			
			cm:set_saved_value("rift_closure_battle_active", false);
			
			kill_rift_closure_battle_invasion();
			
			cm:callback(
				function()
					cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
					cm:disable_event_feed_events(false, "wh_event_category_character", "", "");
				end,
				0.2
			);
		end,
		false
	);
end;

function kill_rift_closure_battle_invasion()
	cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
	cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
	
	invasion_manager:kill_invasion_by_key("rift_closure_battle_invasion");
	
	for k, v in pairs(rift_closure_force_data) do
		kill_faction(v[1]);
	end;
	
	cm:callback(
		function()
			cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
			cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
		end,
		0.2
	);
end;

function trigger_ursuns_roar_event()
	-- ensure the realms ui is visible, in case this was entered via dev ui
	cm:set_saved_value("tome_of_fates_story_panel_shown", true);
	common.set_context_value("tome_of_fates_story_panel_shown", 1);
	
	local human_factions = cm:get_human_factions();
	
	local ursuns_roar_count = cm:get_saved_value("ursuns_roar_count") or 0;
	ursuns_roar_count = ursuns_roar_count + 1;
	
	if ursuns_roar_count > 1 or cm:is_multiplayer() or #human_factions == 0 then
		for i = 1, #human_factions do
			show_story_panel(human_factions[i], "wh3_main_story_panel_ursuns_roar");
		end;
		
		open_all_nodes();

		core:trigger_event("ScriptEventUrsunsRoarTriggered");
	else
		core:trigger_custom_event("ScriptEventTriggerUrsunsRoarCutscene", {});
	end;
	
	open_realm_nodes();
	
	-- each time the ursun roar event happens, the starting corruption from rifts increases
	if ursuns_roar_count == 2 then
		cm:teleportation_network_set_effect_level_modifier("wh3_main_teleportation_network_chaos", 3);
	elseif ursuns_roar_count == 3 then
		cm:teleportation_network_set_effect_level_modifier("wh3_main_teleportation_network_chaos", 8);
	elseif ursuns_roar_count >= 4 then
		cm:teleportation_network_set_effect_level_modifier("wh3_main_teleportation_network_chaos", 13);
	end;
	
	cm:set_saved_value("ursuns_roar_count", ursuns_roar_count);
	cm:set_saved_value("ursuns_roar_available", false);
	
	cm:add_round_turn_countdown_event(rifts_hero_spawn_time, "ScriptEventSpawnChaosFromRifts", "heroes");
end;

function open_all_nodes()
	local nodes_opened = open_initial_nodes();
	
	-- open the remaining nodes. reduce the remaining nodes to open by the amount we just opened for playable factions
	for template, realm in pairs(realm_mapping) do
		open_random_nodes_with_bonus_value(template, math.round((64 - nodes_opened) / 4));
	end;
end;

function open_initial_nodes()
	-- ensure that a rift is open in each playable factions home province first
	local faction_list = cm:model():world():faction_list();
	-- get the valid templates for opening nodes with
	local templates = {};
	for k, v in pairs(realm_mapping) do
		table.insert(templates, k);
	end;
	
	local nodes_opened = 0;
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		
		if not current_faction:pooled_resource_manager():resource("wh3_main_realm_complete_khorne"):is_null_interface() then
			-- replenish realm entry tokens
			local faction_name = current_faction:name();
			cm:faction_add_pooled_resource(faction_name, "wh3_main_enter_realm_cost", "other", 999);
			
			cm:set_script_state(current_faction, "collected_soul_this_cycle", false);
			
			-- if this faction took a slaanesh offer in the previous phase, reset the ui
			if cm:get_saved_value("slaanesh_realm_offer_taken_" .. faction_name) then
				cm:set_saved_value("slaanesh_realm_offer_taken_" .. faction_name, false);
				common.set_context_value("slaanesh_realm_offer_taken_" .. faction_name, 0);
			end;
			
			if current_faction:has_home_region() then
				nodes_opened = nodes_opened + 1;
				
				local region = current_faction:home_region();
				
				if cm:get_provinces_bonus_value(region:faction_province(), "block_chaos_rifts") == 0 then
					cm:teleportation_network_open_node(region:province_name(), templates[cm:random_number(#templates)]);
				end;
			end;
		end;
	end;
	
	if cm:get_saved_value("rifts_permanent") then
		common.set_context_value("rifts_active_duration", "permanent");
	else
		cm:set_saved_value("rifts_closed_early", false);
		cm:add_round_turn_countdown_event(rifts_duration, "ScriptEventRiftsExpire");
		common.set_context_value("rifts_active_duration", rifts_duration);
	end;
	
	return nodes_opened;
end;

function open_realm_nodes()
	-- open rifts in the realms
	for i = 1, 8 do
		cm:teleportation_network_open_node("wh3_main_chaos_khorne_realm_" .. i, "wh3_main_teleportation_node_template_kho_realm");
		cm:teleportation_network_open_node("wh3_main_chaos_nurgle_realm_" .. i, "wh3_main_teleportation_node_template_nur_realm");
		cm:teleportation_network_open_node("wh3_main_chaos_slaanesh_realm_" .. i, "wh3_main_teleportation_node_template_sla_realm");
		cm:teleportation_network_open_node("wh3_main_chaos_tzeentch_realm_" .. i, "wh3_main_teleportation_node_template_tze_realm");
	end;
end;

function open_random_nodes_with_bonus_value(template, nodes_to_open)
	local world = cm:model():world();
	local closed_nodes = world:teleportation_network_system():lookup_network("wh3_main_teleportation_network_chaos"):closed_nodes();
	local available_nodes = {};
	
	-- get all the closed nodes and randomly sort them
	for i = 0, closed_nodes:num_items() - 1 do
		local current_closed_node = closed_nodes:item_at(i);
		
		if current_closed_node:template_key() == "" then
			local x, y = current_closed_node:position();
			table.insert(available_nodes, {current_closed_node:key(), x, y});
		end;
	end;
	
	available_nodes = cm:random_sort(available_nodes);
	
	for i = 1, nodes_to_open do
		if available_nodes[i] then
			local can_open_node = true;
			local region = world:region_data_at_position(available_nodes[i][2], available_nodes[i][3]):region();
			
			if not region:is_null_interface() then
				local faction_provinces = region:province():faction_provinces();
				
				for j = 0, faction_provinces:num_items() - 1 do
					if cm:get_provinces_bonus_value(faction_provinces:item_at(j), "block_chaos_rifts") ~= 0 then
						can_open_node = false;
						break;
					end;
				end;
				
				if can_open_node then
					cm:teleportation_network_open_node(available_nodes[i][1], template);
				end;
			end;
		end;
	end;
end;

in_ursuns_roar_cutscene = intervention:new(
	"ursuns_roar_cutscene",														-- string name
	0,																			-- cost
	function() ursuns_roar_cutscene() end,										-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_ursuns_roar_cutscene:add_trigger_condition(
	"ScriptEventTriggerUrsunsRoarCutscene",
	function() return true end
);

in_ursuns_roar_cutscene:set_reduce_pause_before_triggering(true);
in_ursuns_roar_cutscene:set_must_trigger(true, true);

function ursuns_roar_cutscene()
	local cached_x, cached_y, cached_d, cached_b, cached_h = cm:get_camera_position();
	local start_pos_x = false;
	local start_pos_y = false;
	local local_faction = cm:get_faction(cm:get_local_faction_name(true));
	
	if local_faction:has_home_region() then
		local settlement = local_faction:home_region():settlement();
		
		start_pos_x = settlement:display_position_x();
		start_pos_y = settlement:display_position_y();
	else
		local faction_leader = local_faction:faction_leader();
		
		start_pos_x = faction_leader:display_position_x();
		start_pos_y = faction_leader:display_position_y();
	end;
	
	local nodes_opened_in_cutscene = false;
	local story_panel_shown_in_cutscene = false;
	
	cm:fade_scene(0, 0.5);
	
	local cutscene = campaign_cutscene:new(
		"ursuns_roar",
		21,
		function()
			core:trigger_event("ScriptEventUrsunsRoarTriggered");
		end
	);
	
	cutscene:set_skippable(
		true,
		function()
			cm:fade_scene(1, 0.5);

			cm:modify_advice(true);
			
			cm:set_camera_position(start_pos_x, start_pos_y, 20, 0, 30);
			
			if not nodes_opened_in_cutscene then
				cm:show_advice("wh3_main_camp_rifts_01", true);
				cm:show_advice("wh3_main_camp_rifts_02", true);
				
				open_all_nodes();
			end;
			
			if not story_panel_shown_in_cutscene then
				local human_factions = cm:get_human_factions();
				
				for i = 1, #human_factions do
					show_story_panel(human_factions[i], "wh3_main_story_panel_ursuns_roar");
				end;
			end;
			
			in_ursuns_roar_cutscene:complete();
		end
	);
	
	cutscene:action(
		function()
			cm:set_camera_position(start_pos_x - 10, start_pos_y, 20, 0, 30);
		end,
		0.5
	);
	
	cutscene:action(
		function()
			cm:fade_scene(1, 0.5);
			common.trigger_soundevent("Campaign_Environment_Ursun_Roar");
		end,
		0.7
	);
	
	cutscene:action(
		function()
			cm:scroll_camera_from_current(false, 20, {start_pos_x + 10, start_pos_y, 20, 0, 30});
		end,
		1
	);
	
	cutscene:action(
		function()
			cm:show_advice("wh3_main_camp_rifts_01");
			
			local nodes_opened = open_initial_nodes();
			
			-- open the remaining nodes one by one. reduce the remaining nodes to open by the amount we just opened for playable factions
			for template, realm in pairs(realm_mapping) do
				for i = 1, math.round((64 - nodes_opened) / 4) do
					local timer = (i - 1) / 5;
					
					cm:callback(
						function()
							open_random_nodes_with_bonus_value(template, 1);
						end,
						timer
					);
				end;
			end;
			
			nodes_opened_in_cutscene = true;
		end,
		6
	);
	
	cutscene:action(
		function()
			cutscene:wait_for_advisor()
		end,
		7
	);
	
	cutscene:action(
		function()
			cm:show_advice("wh3_main_camp_rifts_02");
		end,
		8
	);
	
	cutscene:action(
		function()
			local human_factions = cm:get_human_factions();
			
			for i = 1, #human_factions do
				show_story_panel(human_factions[i], "wh3_main_story_panel_ursuns_roar");
			end;
			
			story_panel_shown_in_cutscene = true;

			cm:modify_advice(true);
			
			in_ursuns_roar_cutscene:complete();
		end,
		21
	);
	
	cm:callback(
		function()
			-- clear selection
			CampaignUI.ClearSelection();
			cutscene:start()
		end,
		0.2)
	;
end;

function open_and_initiate_realm(opened_realm, entering_faction)
	if opened_realm == "khorne" then
		setup_realm_khorne(entering_faction);
	elseif opened_realm == "nurgle" then
		setup_realm_nurgle(entering_faction);
	elseif opened_realm == "slaanesh" then
		setup_realm_slaanesh(entering_faction);
	elseif opened_realm == "tzeentch" then
		setup_realm_tzeentch(entering_faction);
	end;
	
	local faction_name = entering_faction:name();
	
	out.chaos(opened_realm .. " realm entered by " .. faction_name);
	
	common.set_context_value(faction_name .. "_is_in_realm", opened_realm);
	cm:set_saved_value(faction_name .. "_is_in_realm", opened_realm);
	
	if entering_faction:is_human() then
		-- cancel other survival battle missions in case player teleported between realms
		for template, realm in pairs(realm_mapping) do
			if opened_realm ~= realm then
				cancel_survival_battle_mission_for_realm(entering_faction, realm);
			end;
		end;
		
		toggle_realm_shroud(entering_faction, true, opened_realm);
	end;
	
	-- show faction enters realm event to local player for other factions
	local human_factions = cm:get_human_factions();
	
	for i = 1, #human_factions do
		if faction_name ~= human_factions[i] then
			cm:trigger_incident_with_targets(cm:get_faction(human_factions[i]):command_queue_index(), "wh3_main_incident_faction_enters_realm_" .. opened_realm, entering_faction:command_queue_index(), 0, 0, 0, 0, 0);
		end;
	end;
	
	update_shared_states();
end;

function show_story_panel(faction_key, id, show_for_team_mates)
	if core:is_tweaker_set("SCRIPTED_TWEAKER_33") then
		out.chaos("Attempting to show story panel [" .. id .. "] for [" .. faction_key .. "] but tweaker SCRIPTED_TWEAKER_33 is set, so story panels are disabled");
		return;
	end;
	
	out.chaos("Showing story panel [" .. id .. "] for [" .. faction_key .. "]");
	cm:trigger_incident(faction_key, id, true);
	
	if cm:is_multiplayer() and show_for_team_mates then
		local team_mates = cm:get_faction(faction_key):team_mates();
		
		for i = 0, team_mates:num_items() - 1 do
			show_story_panel(team_mates:item_at(i):name(), id);
		end;
	end;
end;


function show_intro_story_panel(faction_key, intro_story_panel_key)
	show_story_panel(faction_key, intro_story_panel_key);
end;

function show_intro_story_panel_with_progression_callback(faction_key, intro_story_panel_key, progression_callback, intro_fsm_skipped)
	cm:callback(
		function()
			show_intro_story_panel(faction_key, intro_story_panel_key);
			cm:set_music_paused(true); --pause the music system when the panel is opened--
			common.trigger_soundevent("music_c_intro_eventpanel_start"); --play the bespoke music--
		end,
		intro_fsm_skipped and 3 or 1
	);

	core:add_listener(
        "pre_cindyscene_delay_callback",
        "PanelClosedCampaign",
        true,
        function()
            cm:set_music_paused(false); --resume the music system when the panel is closed--
			common.trigger_soundevent("music_c_intro_eventpanel_stop");--stop the bespoke music--
            progression_callback()
        end,
        false
    );
end;




function setup_ai_behaviour(callback, realm)
	core:add_listener(
		"ai_behaviour_" .. realm,
		"FactionBeginTurnPhaseNormal",
		function(context)
			local faction = context:faction();
			if not faction:is_human() and not faction:is_rebel() and is_faction_in_realm(faction, realm) and not faction:pooled_resource_manager():resource("wh3_main_realm_complete_khorne"):is_null_interface() then
				out.chaos("=========== " .. faction:name() .. " turn (" .. realm .. ") ===========");
				
				toggle_faction_leader_ai(faction, false);
				
				return true;
			end;
		end,
		function(context)
			-- replenish some units that were lost to simulate recruitment
			local faction = context:faction();
			local faction_name = faction:name();
			local cached_units = false;
			
			local cached_teleport_entry_points = cm:get_saved_value("cached_teleport_entry_points") or {};
			
			for i = 1, #cached_teleport_entry_points do
				if cached_teleport_entry_points[i][1] == faction_name then
					cached_units = table.copy(cached_teleport_entry_points[i][5]);
					break;
				end;
			end;
			
			if cached_units then
				local unit_list = faction:faction_leader():military_force():unit_list();
				local temp_unit_list = {};
				
				-- build a new table so we can delete entries
				for i = 1, unit_list:num_items() - 1 do
					table.insert(temp_unit_list, unit_list:item_at(i):unit_key());
				end;
				
				-- compare the current unit list to the cached unit list and remove any that are in both lists. then we're left with any units that are missing - which can be added back
				for i = #cached_units, 1, -1 do
					for j = #temp_unit_list, 1, -1 do
						if cached_units[i] == temp_unit_list[j] then
							table.remove(cached_units, i);
							table.remove(temp_unit_list, j);
						end;
					end;
				end;
				
				-- only re-add up to 2 units per turn
				for i = 1, math.min(#cached_units, 2) do
					out.chaos("Recruiting unit: " .. cached_units[i]);
					cm:grant_unit_to_character(cm:char_lookup_str(faction:faction_leader()), cached_units[i]);
				end;
			end;
			
			callback(context);
		end,
		true
	);
end;

function find_target_and_attack(character, required_to_reach, required_closer_than_distance, force_attack_on_character_at_x, force_attack_on_character_at_y, closest_target_to_x, closest_target_to_y)
	local region_data = character:region_data();
	
	-- the character no longer has an army or isn't on the map, don't do anything
	if not character:has_military_force() or region_data:is_null_interface() then
		return false;
	end;
	
	local char_lookup_str = cm:char_lookup_str(character);
	
	-- make sure we're not in a stance we can't attack in
	cm:force_character_force_into_stance(char_lookup_str, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT");
	
	local region_key = region_data:key();
	local faction = character:faction();
	local faction_list = faction:factions_at_war_with();
	local realm = is_faction_in_realm(faction);
	local forge = is_faction_in_forge(faction);
	
	local x = 0;
	local y = 0;
	
	-- we want the closest target to the supplied position
	if closest_target_to_x then
		x = closest_target_to_x;
		y = closest_target_to_y;
	-- we want the closest target to the character
	else
		x = character:logical_position_x();
		y = character:logical_position_y();
	end;
	
	local military_force = character:military_force();
	local military_force_strength = military_force:strength();
	
	local target = nil;
	local lowest_strength = 99999999;
 	local closest_distance = 500000;
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		
		if is_faction_in_realm(current_faction) == realm or (forge and is_faction_in_forge(current_faction)) then
			local mf_list = current_faction:military_force_list();
			
			for j = 0, mf_list:num_items() - 1 do
				local current_military_force = mf_list:item_at(j);
				
				if current_military_force:has_general() then
					local current_general = current_military_force:general_character();
					local current_general_region_data = current_general:region_data();
					
					-- only use targets that are in the same region
					if not current_general_region_data:is_null_interface() and current_general_region_data:key() == region_key then
						local current_general_mf_strength = current_military_force:strength();
						local current_general_x = current_general:logical_position_x();
						local current_general_y = current_general:logical_position_y();
						local closer_than_distance = true;
						local can_reach = true;
						local current_general_distance = distance_squared(x, y, current_general_x, current_general_y);
						
						if required_closer_than_distance then
							closer_than_distance = current_general_distance < required_closer_than_distance;
						end;
						
						if required_to_reach then
							can_reach = cm:character_can_reach_character(character, current_general);
						end;
						
						-- only consider targets that can ever be reached
						if cm:model():character_can_ever_reach_character(character, current_general) then
							-- target is at the position we want to be, so ignore their strength
							if force_attack_on_character_at_x and current_general_x == force_attack_on_character_at_x and current_general_y == force_attack_on_character_at_y then
								lowest_strength = current_general_mf_strength;
								target = current_general;
							-- we want to attack the closest target to the supplied position as they're blocking it
							elseif closest_target_to_x then
								if current_general_distance < closest_distance then
									target = current_general;
									closest_distance = current_general_distance;
								end;
							-- target is weaker than our army, and weaker than the current target OR it's the same strength but closer
							elseif closer_than_distance and can_reach and military_force_strength >= current_general_mf_strength and current_general_mf_strength < lowest_strength or (current_general_mf_strength == lowest_strength and current_general_distance < closest_distance) then
								lowest_strength = current_general_mf_strength;
								target = current_general;
								closest_distance = current_general_distance;
							end;
						end;
					end;
				end;
			end;
		end;
	end;
	
	if target then
		local moved = false;
		
		if military_force:will_suffer_any_attrition() and not cm:character_can_reach_character(character, target) then
			-- we're taking attrition and can't reach the target in this turn, so switch to encamp and move towards the target
			local final_x, final_y = cm:find_valid_spawn_location_for_character_from_position(faction:name(), target:logical_position_x(), target:logical_position_y(), true);
			
			if cm:model():character_can_ever_reach_position(character, final_x, final_y) then
				out.chaos("Wanted to attack " .. common.get_localised_string(target:get_forename()) .. " of faction " .. target:faction():name() .. ", but taking attrition and can't reach them, so moving to: " .. final_x .. ", " .. final_y);
				
				local text_pos_x, text_pos_y = cm:log_to_dis(final_x, final_y);
				cm:draw_text("Moving...", text_pos_x, text_pos_y, 30, 4, 0, 255, 0);
				
				cm:force_character_force_into_stance(char_lookup_str, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP");
				cm:move_to_queued(char_lookup_str, final_x, final_y);
				
				moved = true;
			end;
		end;
		
		if not moved then
			out.chaos("Attacking " .. common.get_localised_string(target:get_forename()) .. " of faction " .. target:faction():name());
			
			cm:draw_text("Attacking...", target:display_position_x(), target:display_position_y(), 15, 4, 255, 0, 0);
			
			cm:attack_queued(char_lookup_str, cm:char_lookup_str(target:command_queue_index()));
		end;
		
		return true;
	end;
	
	out.chaos("\tCouldn't find a target");
end;

function attempt_to_move_realm_character_to_desired_location(faction_name, character, desired_position)
	-- Look up the character again if it wasn't supplied
	if not character then
		local faction = cm:get_faction(faction_name);
		
		if not faction then
			script_error("ERROR: attempt_to_move_realm_character_to_desired_location() could not find faction with supplied key [" .. faction_name .. "], how can this be?");
			return;
		end;
		
		if not faction:has_faction_leader() then
			return;
		end;
		
		character = faction:faction_leader();
	end;
	
	if desired_position.x then
		local final_x, final_y = cm:find_valid_spawn_location_for_character_from_position(faction_name, desired_position.x, desired_position.y, true);
		
		out.chaos("\tCalculating move destination: " .. desired_position.x .. ", " .. desired_position.y .. " -> " .. final_x .. ", " .. final_y);
		
		if final_x ~= -1 then
			out.chaos("Moving to: " .. final_x .. ", " .. final_y);
			
			local text_pos_x, text_pos_y = cm:log_to_dis(final_x, final_y);
			cm:draw_text("Moving...", text_pos_x, text_pos_y, 30, 4, 0, 255, 0);
			
			if cm:model():character_can_ever_reach_position(character, final_x, final_y) then
				local char_lookup_str = cm:char_lookup_str(character);
				
				-- ensure we start in default stance, to test attrition
				cm:force_character_force_into_stance(char_lookup_str, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT");
				
				if character:has_military_force() and character:military_force():will_suffer_any_attrition() then
					cm:force_character_force_into_stance(char_lookup_str, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP");
				elseif not character:can_reach_position_in_stance(final_x, final_y, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT") then
					cm:force_character_force_into_stance(char_lookup_str, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_MARCH");
				end;
				
				cm:move_to_queued(char_lookup_str, final_x, final_y);
			else
				out.chaos("\tDestination is blocked, attempting to attack the force closest to " .. final_x .. ", " .. final_y);
				if not find_target_and_attack(character, nil, nil, nil, nil, final_x, final_y) then
					return false;
				end;
			end;
		else
			script_error("Couldn't find position");
			out.chaos("\tCouldn't find position, attempting to attack a weaker force");
			if not find_target_and_attack(character) then
				return false;
			end;
		end;
	end;
	
	-- either we moved, or we attacked a weaker force blocking us
	return true;
end;

function can_ai_army_complete_final_battle(mf)
	if mf:strength() > strength_required_for_ai_to_complete_realm then
		return true;
	elseif mf:has_general() then
		local faction = mf:faction();
		
		toggle_faction_leader_ai(faction, true);
		
		cm:kill_character(cm:char_lookup_str(mf:general_character():command_queue_index()), true);
		
		return false;
	end;
end;

function toggle_faction_leader_ai(faction, enable)
	if faction:has_faction_leader() then
		local faction_leader = cm:char_lookup_str(faction:faction_leader():command_queue_index());
		
		if enable then
			cm:cai_enable_movement_for_character(faction_leader);
		elseif is_faction_in_realm(faction) then
			cm:cai_disable_movement_for_character(faction_leader);
		else
			script_error("Tried to disable movement for faction leader of " .. faction:name() .. ", but they are not in a realm - how did this happen?");
		end;
	end;
end;

function close_realm(faction_name, realm_to_close)
	if realm_to_close == "khorne" then
		close_khorne_realm();
	elseif realm_to_close == "nurgle" then
		close_nurgle_realm();
	elseif realm_to_close == "slaanesh" then
		close_slaanesh_realm();
	elseif realm_to_close == "tzeentch" then
		close_tzeentch_realm();
	end;
	
	local faction = false;
	local num_realms_completed = 0;
	local human_factions = cm:get_human_factions();
	local has_already_completed_realm = false;
	
	if faction_name then
		faction = cm:get_faction(faction_name);
		local realms_completed = get_num_realms_completed(faction, true);
		
		if realms_completed[realm_to_close] > 0 then
			has_already_completed_realm = true;
		end;
		
		out.chaos(faction_name .. " has completed the " .. realm_to_close .. " realm, closing");
		
		cm:faction_add_pooled_resource(faction_name, "wh3_main_realm_complete_" .. realm_to_close, "other", 1);
		
		if faction:has_faction_leader() then
			remove_chaos_trait(faction:faction_leader(), realm_to_close, false);
		end;
		
		-- don't allow this faction to enter a realm again until the next set of rifts open
		if not cm:get_saved_value("rifts_permanent") then
			cm:faction_add_pooled_resource(faction_name, "wh3_main_enter_realm_cost", "other", -faction:pooled_resource_manager():resource("wh3_main_enter_realm_cost"):value());
			
			cm:set_script_state(faction, "collected_soul_this_cycle", true);
		end;
		
		num_realms_completed = get_num_realms_completed(faction);
	end;
	
	-- return armies in the realm back to where they originally teleported from
	local world = cm:model():world();
	local faction_list = world:faction_list();
	local timer = 0;
	
	for i = 0, faction_list:num_items() - 1 do
		cm:callback(
			function()
				local current_faction = faction_list:item_at(i);
				
				if not current_faction:is_dead() and not current_faction:pooled_resource_manager():resource("wh3_main_realm_complete_khorne"):is_null_interface() and is_faction_in_realm(current_faction, realm_to_close) then
					-- found character in the realm, teleporting back
					local current_faction_name = current_faction:name();
					
					local cached_x, cached_y, teleported_x, teleported_y = teleport_characters_out_of_realm(current_faction, realm_to_close);
					
					-- close the rift if this faction was the faction that completed the realm
					if faction_name and faction_name == current_faction_name then
						-- find the rift by the coords we cached...
						local open_rifts = cm:model():world():teleportation_network_system():lookup_network("wh3_main_teleportation_network_chaos"):open_nodes();
						
						for k = 0, open_rifts:num_items() - 1 do
							local current_rift = open_rifts:item_at(k);
							local current_rift_pos_x, current_rift_pos_y = current_rift:position();
							
							if current_rift_pos_x == cached_x and current_rift_pos_y == cached_y then
								cm:teleportation_network_close_node(current_rift:record_key());
								break;
							end
						end;
					end;
					
					common.set_context_value(current_faction_name .. "_is_in_realm", "");
					cm:set_saved_value(current_faction_name .. "_is_in_realm", "");
					
					if current_faction:is_human() then
						-- show failure story panels for players who have lost the realm and who aren't teamed with the winner
						if faction_name ~= current_faction_name and faction and not faction:is_team_mate(current_faction) then
							if not cm:get_saved_value(current_faction_name .. "_lost_first_realm_attempt") and get_num_realms_completed(current_faction) == 0 then
								cm:set_saved_value(current_faction_name .. "_lost_first_realm_attempt", true);
								show_story_panel(current_faction_name, "wh3_main_story_panel_the_lost_soul");
							else
								show_story_panel(current_faction_name, "wh3_main_story_panel_failure");
							end;
						end;
						
						-- cut the camera to the faction leaders position
						if cm:get_local_faction_name(true) == current_faction_name then
							local cam_x, cam_y = cm:log_to_dis(teleported_x, teleported_y);
							
							if world:is_factions_turn_by_key(current_faction_name) then
								cm:set_camera_position(cam_x, cam_y, 13, 0, 10);
							else
								core:add_listener(
									"move_camera_to_teleported_character",
									"FactionTurnStart",
									function(context)
										return context:faction():name() == current_faction_name;
									end,
									function()
										cm:set_camera_position(cam_x, cam_y, 13, 0, 10);
									end,
									false
								);
							end;
						end;
					else
						toggle_faction_leader_ai(current_faction, true);
					end;
					
					timer = timer + 0.2;
				end;
			end,
			timer
		);
	end;
	
	if faction_name then
		if faction:is_human() and not cm:get_saved_value("campaign_completed") then
			if not has_already_completed_realm then
				if num_realms_completed == 1 then
					if cm:get_saved_value(faction_name .. "_lost_first_realm_attempt") then
						show_story_panel(faction_name, "wh3_main_story_panel_the_first_soul", true);
					else
						show_story_panel(faction_name, "wh3_main_story_panel_the_daemons_soul", true);
					end;
				elseif num_realms_completed == 2 then
					show_story_panel(faction_name, "wh3_main_story_panel_the_second_soul", true);
				elseif num_realms_completed == 3 then
					show_story_panel(faction_name, "wh3_main_story_panel_the_third_soul", true);
				elseif num_realms_completed == 4 then
					show_story_panel(faction_name, "wh3_main_story_panel_the_fourth_soul", true);
					
					-- trigger the final battle mission
					local battle_key = "wh3_main_survival_forge_of_souls_" .. faction:faction_leader():character_subtype_key();
					
					local mm = mission_manager:new(faction_name, battle_key);
					mm:add_new_objective("FIGHT_SET_PIECE_BATTLE");
					mm:add_condition("set_piece_battle " .. battle_key);
					mm:add_condition("override_text mission_text_text_wh3_win_forge_of_souls_battle");
					mm:set_turn_limit(40);
					mm:add_payload("text_display dummy_wh3_main_survival_forge_of_souls");
					
					-- trigger the final battle mission for their team mates in multiplayer
					if cm:is_multiplayer() then
						mm:trigger();
						
						local team_mates = faction:team_mates();
						
						for i = 0, team_mates:num_items() - 1 do
							local current_team_mate = team_mates:item_at(i);
							
							if current_team_mate:has_faction_leader() then
								battle_key = current_team_mate:faction_leader():character_subtype_key();
								
								local mm = mission_manager:new(current_team_mate:name(), battle_key);
								mm:add_new_objective("FIGHT_SET_PIECE_BATTLE");
								mm:add_condition("set_piece_battle " .. battle_key);
								mm:add_condition("override_text mission_text_text_wh3_win_forge_of_souls_battle");
								mm:add_payload("text_display dummy_wh3_main_survival_forge_of_souls");
								
								mm:trigger();
							end;
						end;
					else
						cm:trigger_transient_intervention(
							"forge_of_souls_final_battle", 
							function(inv)
								cm:callback(
									function()
										mm:trigger();
										inv:complete();
									end,
									0.5
								);
							end,
							true,
							function(inv)
								inv:set_must_trigger(true, true);
								inv:set_wait_for_fullscreen_panel_dismissed(false);
							end,
							0
						);
						
						-- add belakor countdown events
						cm:add_turn_countdown_event(faction_name, 10, "ScriptEventBelakorCountdown", faction_name .. ",1");
						cm:add_turn_countdown_event(faction_name, 20, "ScriptEventBelakorCountdown", faction_name .. ",2");
						cm:add_turn_countdown_event(faction_name, 30, "ScriptEventBelakorCountdown", faction_name .. ",3");
						cm:add_turn_countdown_event(faction_name, 40, "ScriptEventBelakorCountdown", faction_name .. ",4");
					end;
				end;
			end;
		else
			-- if ai has 4 souls, issue mission to player to defeat them
			if num_realms_completed == 4 and not cm:get_saved_value("campaign_completed") then
				for i = 1, #human_factions do
					local mm = mission_manager:new(human_factions[i], "wh3_main_ai_four_souls_forge_of_souls");
					mm:add_new_objective("SCRIPTED");
					mm:add_condition("script_key ai_four_souls_" .. faction_name);
					mm:add_condition("override_text mission_text_text_wh3_main_ai_four_souls_forge_of_souls");
					mm:add_payload("text_display dummy_wh3_main_ai_four_souls_forge_of_souls");
					mm:set_should_cancel_before_issuing(false);
					
					local function set_faction_for_mission(faction)
						cm:set_scripted_mission_entity_completion_states(
							"wh3_main_ai_four_souls_forge_of_souls",
							"ai_four_souls_" .. faction_name,
							{
								{faction, false},
							}
						);
					end;
					
					if cm:is_multiplayer() then
						mm:trigger();
						set_faction_for_mission(faction);
					else
						cm:trigger_transient_intervention(
							"ai_four_souls_" .. faction_name, 
							function(inv)
								cm:callback(
									function()
										mm:trigger();
										set_faction_for_mission(faction);
										inv:complete();
									end,
									0.5
								);
							end,
							true,
							function(inv)
								inv:set_must_trigger(true, true);
								inv:set_wait_for_fullscreen_panel_dismissed(false);
							end,
							0
						);
					end;
				end;
			end;
			
			if faction:has_faction_leader() then
				-- damage the ai's army to simulate survival battle casualties
				local faction_leader = faction:faction_leader();
				
				if faction_leader:has_military_force() then
					local faction_leader_units = faction_leader:military_force():unit_list();
					
					for i = 1, faction_leader_units:num_items() - 1 do
						local current_unit = faction_leader_units:item_at(i);
						
						local amount = math.max((current_unit:percentage_proportion_of_full_strength() / 100) - (cm:random_number(10, 3) / 10), 0);
						
						cm:set_unit_hp_to_unary_of_maximum(current_unit, amount);
					end;
				end;
			end;
		end;
	end;
	
	-- cancel the survival battle mission for human players
	for i = 1, #human_factions do
		cancel_survival_battle_mission_for_realm(cm:get_faction(human_factions[i]), realm_to_close);
	end;
	
	core:remove_listener("ai_behaviour_" .. realm_to_close);
	
	if num_realms_completed == 4 and not cm:get_saved_value("campaign_completed") then
		-- a human player has completed 4 realms, therefore watched ursun dying in belakor movie 4, never close the rifts from this point on
		if faction:is_human() then
			cm:set_saved_value("rifts_permanent", true);
			common.set_context_value("rifts_active_duration", "permanent");
			
			-- and reopen all nodes
			open_all_nodes();
			open_realm_nodes();
		end;
		
		-- if a faction that isn't the local player completes 4 realms, show the story panel for the local player
		for i = 1, #human_factions do
			if faction_name ~= human_factions[i] then
				show_story_panel(human_factions[i], "wh3_main_story_panel_another_play");
			end;
		end;
		
		-- open the forge of souls rift so final battle location is accessible for everyone
		cm:teleportation_network_open_node("wh3_main_chaos_forge_of_souls", "wh3_main_teleportation_node_template_forge_of_souls");
	else
		-- only close the rifts if no one has reached 4 souls
		for template, realm in pairs(realm_mapping) do
			if realm_to_close == realm then
				cm:teleportation_network_close_all_nodes("wh3_main_teleportation_network_chaos", template);
				cm:teleportation_network_close_all_nodes("wh3_main_teleportation_network_chaos", template .. "_realm");
			end;
		end;
		
		if not are_any_rifts_open() then
			cm:set_saved_value("rifts_closed_early", true);
			common.set_context_value("rifts_active_duration", 0);
		end;
	end;
	
	-- show faction claims soul to every human faction, if they weren't the one to claim it
	if faction_name then
		for i = 1, #human_factions do
			if faction_name ~= human_factions[i] then
				cm:trigger_incident_with_targets(cm:get_faction(human_factions[i]):command_queue_index(), "wh3_main_incident_faction_gains_soul_" .. realm_to_close, faction:command_queue_index(), 0, 0, 0, 0, 0);
			end;
		end;
	end;
	
	update_shared_states();
end;

function are_any_rifts_open(exclude_realm_rifts)
	local network = cm:model():world():teleportation_network_system():lookup_network("wh3_main_teleportation_network_chaos");
	
	if exclude_realm_rifts then
		for template, realm in pairs(realm_mapping) do
			if not network:open_nodes_of_template(template):is_empty() then
				return true;
			end;
		end;
		
		return false;
	else
		return not network:open_nodes():is_empty();
	end;
end;

function get_first_general_in_realm(faction, realm)
	for i = 1, #realm_data[realm]["region"] do
		local char_list = cm:get_region_data(realm_data[realm]["region"][i]):characters_of_faction_in_region(faction)
		for i = 0, char_list:num_items() - 1 do
			local current_char = char_list:item_at(i);
			if cm:char_is_general_with_army(current_char) then
				return current_char;
			end;
		end;
	end;
end;

function is_faction_in_realm(faction, realm)
	if realm then
		for i = 1, #realm_data[realm]["region"] do
			if not cm:get_region_data(realm_data[realm]["region"][i]):characters_of_faction_in_region(faction):is_empty() then
				return true;
			end;
		end;
	else
		for realm_name, v in pairs(realm_data) do
			if is_faction_in_realm(faction, realm_name) then
				return realm_name;
			end;
		end;
	end;
	
	return false;
end;

function is_faction_in_forge(faction)
	return not cm:get_region_data("wh3_main_chaos_region_the_forge_of_souls"):characters_of_faction_in_region(faction):is_empty();
end;

-- Returns the name of the realm that the region key belongs to, or false if it's not in a realm of Chaos
function region_in_chaos_realm(region_key)
	for current_realm_name, current_realm_data in pairs(realm_data) do
		local regions = current_realm_data.region;

		for i = 1, #regions do
			if regions[i] == region_key then
				return current_realm_name;
			end;
		end;
	end;

	return false;
end;

function deploy_creep_armies(creep_armies, patrol, aggro_radius, respawn_times, respawn_turns, kill_faction_before_spawning, set_retreated)
	-- sometimes the armies in the realms were still there, despite the realm being inactive - so kill any stragglers to be on the safe side
	if kill_faction_before_spawning then
		for i = 1, #creep_armies do
			kill_faction(creep_armies[i][5]);
		end;
	end;
	
	for i = 1, #creep_armies do
		local current_invasion = creep_armies[i];
		
		local invasion = invasion_manager:new_invasion(current_invasion[1], current_invasion[5], current_invasion[2], current_invasion[3]);
		
		if invasion then
			if is_table(patrol) then
				invasion:set_target("TZEENTCH_COORDS", patrol);
			elseif patrol then
				invasion:set_target("PATROL", current_invasion[4]);
			end;
			
			if aggro_radius then
				invasion:add_aggro_radius(aggro_radius);
			end;
			
			if respawn_times then
				invasion:add_respawn(true, respawn_times, respawn_turns);
			end;
			
			if current_invasion[6] then
				invasion:create_general(true, current_invasion[6][1], current_invasion[6][2], "", "", "")
			end;
			
			invasion:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
			
			invasion:start_invasion(
				function(self)
					local force = self:get_force();
					local faction = force:faction();
					
					if set_retreated then
						cm:set_force_has_retreated_this_turn(force);
					end;
					
					if not faction:has_effect_bundle("wh3_main_bundle_realm_factions") then
						cm:apply_effect_bundle("wh3_main_bundle_realm_factions", faction:name(), 0);
					end;
				end
			);
		end;
	end;
end;

function toggle_realm_shroud(faction, reveal, realm)
	if realm then
		for i = 1, #realm_data[realm]["region"] do
			if reveal then
				cm:grant_faction_additional_vision(faction, cm:get_region_data(realm_data[realm]["region"][i]));
			else
				cm:remove_faction_additional_vision(faction, cm:get_region_data(realm_data[realm]["region"][i]));
			end;
		end;
	else
		for realm, v in pairs(realm_data) do
			toggle_realm_shroud(faction, reveal, realm);
		end;
	end;
end;

-- <realm_name>_realm_cindyscene_played_<faction_key> savegame value is set by narrative system. If it hasn't been set then the
-- realm intro has not been shown, so we defer the triggering of the survival battle until after it's finished
function attempt_to_trigger_realm_final_battle_pre_cindyscene(faction_name, realm_to_trigger)
	if cm:get_saved_value(realm_to_trigger .. "_realm_cindyscene_played_" .. faction_name) then
		trigger_realm_final_battle(faction_name, realm_to_trigger);
	end;
end;

function trigger_realm_final_battle(faction_name, realm_to_trigger)
	local faction = cm:get_faction(faction_name);
	local num_realms_completed = get_num_realms_completed(faction);
	local subtype = faction:faction_leader():character_subtype_key();
	
	local battle_key = "wh3_main_survival_" .. realm_to_trigger .. "_" .. subtype;
	
	if num_realms_completed == 0 then
		battle_key = battle_key .. "_easy";
	elseif num_realms_completed > 2 then
		battle_key = battle_key .. "_hard";
	end;
	
	if cm:is_factions_turn_by_key(faction_name) and not cm:mission_is_active_for_faction(faction, battle_key) then
		local mm = mission_manager:new(faction_name, battle_key);
		mm:add_new_objective("FIGHT_SET_PIECE_BATTLE");
		mm:add_condition("set_piece_battle " .. battle_key);
		
		local realms_completed = get_num_realms_completed(faction, true);
		
		if realms_completed[realm_to_trigger] == 0 then
			mm:add_payload("text_display dummy_wh3_main_survival_" .. realm_to_trigger .. "_" .. math.min(num_realms_completed + 1, 4));
			mm:add_payload("effect_bundle{bundle_key wh3_main_bundle_daemon_prince_soul_" .. chaos_get_culture_prefix(faction:culture()) .. ";turns 10;}");
		else
			-- the player has already completed this realm, just give cash reward instead
			mm:add_payload("money 10000");
		end;
		
		if cm:is_multiplayer() then
			mm:trigger();
		else
			cm:trigger_transient_intervention(
				realm_to_trigger .. "_final_battle", 
				function(inv)
					cm:callback(
						function()
							mm:trigger();
							inv:complete();
						end,
						0.5
					);
				end,
				true,
				function(inv)
					inv:set_must_trigger(true, true);
					inv:set_wait_for_fullscreen_panel_dismissed(false);
				end,
				0
			);
		end;
	end;
end;

function cancel_active_survival_battle_mission(faction)
	local realm_name = cm:get_saved_value(faction:name() .. "_is_in_realm");
	
	if realm_name and realm_name ~= "" then
		cancel_survival_battle_mission_for_realm(faction, realm_name);
	end;
end;

function cancel_survival_battle_mission_for_realm(faction, realm_name)
	if faction:has_faction_leader() then
		local battle_key_to_cancel = "wh3_main_survival_" .. realm_name .. "_" .. faction:faction_leader():character_subtype_key();
		local faction_name = faction:name();
		
		cm:cancel_custom_mission(faction_name, battle_key_to_cancel);
		cm:cancel_custom_mission(faction_name, battle_key_to_cancel .. "_easy");
		cm:cancel_custom_mission(faction_name, battle_key_to_cancel .. "_hard");
		
		if realm_name == "khorne" then
			cm:cancel_custom_mission(faction_name, "wh3_main_khorne_realm_requirement");
		elseif realm_name == "nurgle" then
			cm:cancel_custom_mission(faction_name, "wh3_main_nurgle_realm_requirement");
		end;
	end;
end;

function update_shared_states()
	local model = cm:model();
	local ssm = model:shared_states_manager();
	
	local is_any_human_player_in_any_realm = false;
	local is_any_human_player_in_khorne_realm = false;
	local is_any_human_player_in_nurgle_realm = false;
	local is_any_human_player_in_slaanesh_realm = false;
	local is_any_human_player_in_tzeentch_realm = false;
	local campaign_game_won = cm:get_saved_value("campaign_completed") or false;
	local best_human_players_absolute_soul_count = ssm:get_state_as_float_value("best_human_players_absolute_soul_count") or 0;
	local number_of_ai_factions_in_khorne_realm = 0;
	local number_of_ai_factions_in_nurgle_realm = 0;
	local number_of_ai_factions_in_slaanesh_realm = 0;
	local number_of_ai_factions_in_tzeentch_realm = 0;
	
	local faction_list = model:world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		
		if not current_faction:pooled_resource_manager():resource("wh3_main_realm_complete_khorne"):is_null_interface() then
			local is_human = current_faction:is_human();
			
			if is_human then
				local current_factions_num_realms = get_num_realms_completed(current_faction);
				
				if current_factions_num_realms > best_human_players_absolute_soul_count then
					best_human_players_absolute_soul_count = current_factions_num_realms;
				end;
			else
				local current_faction_name = current_faction:name();
				local realms_completed = get_num_realms_completed(current_faction, true);
				local num_realms_completed = 0;
				local faction_has_any_allies_in_realm_khorne = false;
				local faction_has_any_allies_in_realm_nurgle = false;
				local faction_has_any_allies_in_realm_slaanesh = false;
				local faction_has_any_allies_in_realm_tzeentch = false;
				
				for realm, completed in pairs(realms_completed) do
					if completed == 1 then
						num_realms_completed = num_realms_completed + 1;
					end;
					
					--out.chaos("Setting script state [faction_completed_realm_" .. realm .. "] to " .. tostring(completed == 1) .. " for faction " .. current_faction_name);
					
					cm:set_script_state(current_faction, "faction_completed_realm_" .. realm, completed == 1);
				end;
				
				--[[out.chaos("Setting script state [faction_soul_count] to " .. num_realms_completed .. " for faction " .. current_faction_name);
				out.chaos("Setting script state [faction_relative_soul_count_to_best_human_player] to " .. best_human_players_absolute_soul_count - num_realms_completed .. " for faction " .. current_faction_name);]]
				
				cm:set_script_state(current_faction, "faction_soul_count", num_realms_completed);
				cm:set_script_state(current_faction, "faction_relative_soul_count_to_best_human_player", best_human_players_absolute_soul_count - num_realms_completed);
				
				for j = 0, faction_list:num_items() - 1 do
					local current_ally_to_check = faction_list:item_at(j);
					
					if current_faction:allied_with(current_ally_to_check) and not current_ally_to_check:pooled_resource_manager():resource("wh3_main_realm_complete_khorne"):is_null_interface() then
						local faction_in_realm = is_faction_in_realm(current_ally_to_check);
						
						if faction_in_realm == "khorne" then
							faction_has_any_allies_in_realm_khorne = true;
						elseif faction_in_realm == "nurgle" then
							faction_has_any_allies_in_realm_nurgle = true;
						elseif faction_in_realm == "slaanesh" then
							faction_has_any_allies_in_realm_slaanesh = true;
						elseif faction_in_realm == "tzeentch" then
							faction_has_any_allies_in_realm_tzeentch = true;
						end;
					end;
				end;
				
				--[[out.chaos("Setting script state [faction_has_any_allies_in_realm_khorne] to " .. tostring(faction_has_any_allies_in_realm_khorne) .. " for faction " .. current_faction_name);
				out.chaos("Setting script state [faction_has_any_allies_in_realm_nurgle] to " .. tostring(faction_has_any_allies_in_realm_nurgle) .. " for faction " .. current_faction_name);
				out.chaos("Setting script state [faction_has_any_allies_in_realm_slaanesh] to " .. tostring(faction_has_any_allies_in_realm_slaanesh) .. " for faction " .. current_faction_name);
				out.chaos("Setting script state [faction_has_any_allies_in_realm_tzeentch] to " .. tostring(faction_has_any_allies_in_realm_tzeentch) .. " for faction " .. current_faction_name);]]
				
				cm:set_script_state(current_faction, "faction_has_any_allies_in_realm_khorne", faction_has_any_allies_in_realm_khorne);
				cm:set_script_state(current_faction, "faction_has_any_allies_in_realm_nurgle", faction_has_any_allies_in_realm_nurgle);
				cm:set_script_state(current_faction, "faction_has_any_allies_in_realm_slaanesh", faction_has_any_allies_in_realm_slaanesh);
				cm:set_script_state(current_faction, "faction_has_any_allies_in_realm_tzeentch", faction_has_any_allies_in_realm_tzeentch);
			end;
			
			local faction_in_realm = is_faction_in_realm(current_faction);
			
			if faction_in_realm == "khorne" then
				if is_human then
					is_any_human_player_in_khorne_realm = true;
					is_any_human_player_in_any_realm = true;
				else
					number_of_ai_factions_in_khorne_realm = number_of_ai_factions_in_khorne_realm + 1;
				end;
			elseif faction_in_realm == "nurgle" then
				if is_human then
					is_any_human_player_in_nurgle_realm = true;
					is_any_human_player_in_any_realm = true;
				else
					number_of_ai_factions_in_nurgle_realm = number_of_ai_factions_in_nurgle_realm + 1;
				end;
			elseif faction_in_realm == "slaanesh" then
				if is_human then
					is_any_human_player_in_slaanesh_realm = true;
					is_any_human_player_in_any_realm = true;
				else
					number_of_ai_factions_in_slaanesh_realm = number_of_ai_factions_in_slaanesh_realm + 1;
				end;
			elseif faction_in_realm == "tzeentch" then
				if is_human then
					is_any_human_player_in_tzeentch_realm = true;
					is_any_human_player_in_any_realm = true;
				else
					number_of_ai_factions_in_tzeentch_realm = number_of_ai_factions_in_tzeentch_realm + 1;
				end;
			end;
		end;
	end;
	
	--[[out.chaos("Setting script state [is_any_human_player_in_any_realm] to " .. tostring(is_any_human_player_in_any_realm));
	out.chaos("Setting script state [is_any_human_player_in_khorne_realm] to " .. tostring(is_any_human_player_in_khorne_realm));
	out.chaos("Setting script state [is_any_human_player_in_nurgle_realm] to " .. tostring(is_any_human_player_in_nurgle_realm));
	out.chaos("Setting script state [is_any_human_player_in_slaanesh_realm] to " .. tostring(is_any_human_player_in_slaanesh_realm));
	out.chaos("Setting script state [is_any_human_player_in_tzeentch_realm] to " .. tostring(is_any_human_player_in_tzeentch_realm));
	out.chaos("Setting script state [best_human_players_absolute_soul_count] to " .. tostring(best_human_players_absolute_soul_count));
	out.chaos("Setting script state [number_of_ai_factions_in_khorne_realm] to " .. tostring(number_of_ai_factions_in_khorne_realm));
	out.chaos("Setting script state [number_of_ai_factions_in_nurgle_realm] to " .. tostring(number_of_ai_factions_in_nurgle_realm));
	out.chaos("Setting script state [number_of_ai_factions_in_slaanesh_realm] to " .. tostring(number_of_ai_factions_in_slaanesh_realm));
	out.chaos("Setting script state [number_of_ai_factions_in_tzeentch_realm] to " .. tostring(number_of_ai_factions_in_tzeentch_realm));
	out.chaos("Setting script state [campaign_game_won] to " .. tostring(campaign_game_won));]]
	
	cm:set_script_state("is_any_human_player_in_any_realm", is_any_human_player_in_any_realm);
	cm:set_script_state("is_any_human_player_in_khorne_realm", is_any_human_player_in_khorne_realm);
	cm:set_script_state("is_any_human_player_in_nurgle_realm", is_any_human_player_in_nurgle_realm);
	cm:set_script_state("is_any_human_player_in_slaanesh_realm", is_any_human_player_in_slaanesh_realm);
	cm:set_script_state("is_any_human_player_in_tzeentch_realm", is_any_human_player_in_tzeentch_realm);
	cm:set_script_state("best_human_players_absolute_soul_count", best_human_players_absolute_soul_count);
	cm:set_script_state("number_of_ai_factions_in_khorne_realm", number_of_ai_factions_in_khorne_realm);
	cm:set_script_state("number_of_ai_factions_in_nurgle_realm", number_of_ai_factions_in_nurgle_realm);
	cm:set_script_state("number_of_ai_factions_in_slaanesh_realm", number_of_ai_factions_in_slaanesh_realm);
	cm:set_script_state("number_of_ai_factions_in_tzeentch_realm", number_of_ai_factions_in_tzeentch_realm);
	cm:set_script_state("campaign_game_won", campaign_game_won);
end;


function get_num_realms_completed(faction, return_individual_realms)
	if faction then
		local faction_prm = faction:pooled_resource_manager();
		local khorne_resource = faction_prm:resource("wh3_main_realm_complete_khorne");
		
		if khorne_resource:is_null_interface() then
			return 0;
		elseif return_individual_realms then
			return {
				["khorne"] = khorne_resource:value(),
				["nurgle"] = faction_prm:resource("wh3_main_realm_complete_nurgle"):value(),
				["slaanesh"] = faction_prm:resource("wh3_main_realm_complete_slaanesh"):value(),
				["tzeentch"] = faction_prm:resource("wh3_main_realm_complete_tzeentch"):value()
			};
		else
			return khorne_resource:value() + faction_prm:resource("wh3_main_realm_complete_nurgle"):value() + faction_prm:resource("wh3_main_realm_complete_slaanesh"):value() + faction_prm:resource("wh3_main_realm_complete_tzeentch"):value();
		end;
	else
		return 0;
	end;
end;

function kill_realm_armies(army_data)
	cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed");
	
	for i = 1, #army_data do
		invasion_manager:kill_invasion_by_key(army_data[i][1]);
	end;
	
	-- ensure the faction is definitely killed off at this point
	for i = 1, #army_data do
		kill_faction(army_data[i][5]);
	end;
	
	cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed") end, 0.2);
end;

function teleport_characters_out_of_realm(faction, realm, zero_ap)
	-- return the army to the point they teleported from
	local cached_teleport_entry_points = cm:get_saved_value("cached_teleport_entry_points") or {};
	local faction_name = faction:name();
	local cached_x = 0;
	local cached_y = 0;
	local cached_mf_cqi = false;
	local x = 0;
	local y = 0;
	
	-- check each cached teleport entry point
	for i = 1, #cached_teleport_entry_points do
		if faction_name == cached_teleport_entry_points[i][1] then
			cached_x = cached_teleport_entry_points[i][2];
			cached_y = cached_teleport_entry_points[i][3];
			cached_mf_cqi = cached_teleport_entry_points[i][4];
			
			x, y = cm:find_valid_spawn_location_for_character_from_position(faction_name, cached_x, cached_y, true);
			break;
		end;
	end;
	
	-- ensure we're not teleporting them back into a realm
	if x > 0 then
		local region_data = cm:model():world():region_data_at_position(x, y);
		
		if not region_data:is_null_interface() then
			local key = region_data:key();
			
			for realm, v in pairs(realm_data) do
				for i = 1, #realm_data[realm]["region"] do
					if key == realm_data[realm]["region"][i] then
						x = 0;
						break;
					end;
				end;
			end;
			
			if key == "wh3_main_chaos_region_the_forge_of_souls" then
				x = 0;
			end;
		end;
	end;
	
	-- couldn't find a position to return them to (or entered via debug means)
	if x <= 0 then
		if faction:has_home_region() then
			-- can't return them to the original location, return them to their capital
			x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction_name, faction:home_region():name(), false, true, 4);
		else
			-- failsafe - dump them into the middle of the map!
			x, y = cm:find_valid_spawn_location_for_character_from_position(faction_name, 497, 186, true);
		end;
	end;
	
	local timer = 0;
	
	out.chaos("Returning characters of " .. faction_name .. " to " .. x .. " " .. y);
	
	local regions = {};
	
	if realm == "forge_of_souls" then
		regions = {"wh3_main_chaos_region_the_forge_of_souls"};
	else
		regions = realm_data[realm]["region"];
	end;
	
	for i = 1, #regions do
		local current_character_list = cm:get_region_data(regions[i]):characters_of_faction_in_region(faction);
		
		for j = 0, current_character_list:num_items() - 1 do
			local current_character_cqi = current_character_list:item_at(j):command_queue_index();
			
			local current_x = 0;
			local current_y = 0;
			
			cm:callback(
				function()
					current_x, current_y = cm:find_valid_spawn_location_for_character_from_position(faction_name, x, y, true);
					
					local current_character = cm:get_character_by_cqi(current_character_cqi);
					
					if current_character and not current_character:is_embedded_in_military_force() then
						if current_character:is_wounded() then
							local mf = cm:get_military_force_by_cqi(cached_mf_cqi);
							
							if mf then
								cm:teleport_military_force_to(mf, current_x, current_y);
							end;
						else
							local char_lookup_str = cm:char_lookup_str(current_character);
							cm:teleport_to(char_lookup_str, current_x, current_y);
							
							if zero_ap then
								cm:zero_action_points(char_lookup_str);
							end;
						end;
	
						out.chaos("\tReturned character " .. common.get_localised_string(current_character:get_forename()));
					end;
				end,
				timer
			);
			
			-- each teleport has to be delayed by a tick so the pathfinder can calculate a new position for the following character
			timer = timer + 0.2;
		end;
	end;
	
	if faction:is_human() then
		if realm == "forge_of_souls" then
			toggle_realm_shroud(faction, false);
		else
			toggle_realm_shroud(faction, false, realm);
		end;
	end;
	
	return cached_x, cached_y, x, y;
end;

function trigger_campaign_defeat(faction)
	local faction_name = faction:name();
	cm:complete_scripted_mission_objective(faction_name, "wh_main_long_victory", "realm_khorne", false);
	cm:complete_scripted_mission_objective(faction_name, "wh_main_long_victory", "realm_nurgle", false);
	cm:complete_scripted_mission_objective(faction_name, "wh_main_long_victory", "realm_slaanesh", false);
	cm:complete_scripted_mission_objective(faction_name, "wh_main_long_victory", "realm_tzeentch", false);
	cm:complete_scripted_mission_objective(faction_name, "wh_main_long_victory", "forge_of_souls_battle", false);
	cm:complete_scripted_mission_objective(faction_name, "wh3_main_chaos_domination_victory", "domination", false);
end;

function play_and_unlock_movie(movie_key, unlock_key)
	out.chaos("Playing movie: " .. movie_key);
	core:svr_save_registry_bool(unlock_key, true);
	cm:register_instant_movie(movie_key);
end;

function setup_creep_army_comp(creep_armies, ...)
	local army_index = math.min(cm:get_saved_value("ursuns_roar_count") or 1, 4);
	
	if arg.n > 1 then
		for i = 1, arg.n do
			local found_army_comps = arg[i][army_index];
			
			if creep_armies[i][2] == "" then
				local random_comp = cm:random_number(#found_army_comps);
				creep_armies[i][2] = table.concat(found_army_comps[random_comp], ",");
			end;
		end;
	else
		local found_army_comps = arg[1][army_index];
		
		for i = 1, #creep_armies do
			if creep_armies[i][2] == "" then
				local random_comp = cm:random_number(#found_army_comps);
				creep_armies[i][2] = table.concat(found_army_comps[random_comp], ",");
			end;
		end;
	end;
end;