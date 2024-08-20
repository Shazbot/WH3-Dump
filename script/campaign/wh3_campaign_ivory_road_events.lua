caravans.event_tables["wh3_main_cth_cathay"] = {
	["banditExtort"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local bandit_threat = world_conditions["bandit_threat"];
			local probability = math.floor(bandit_threat/10) +3;
			
			local event_region = world_conditions["event_region"];
			local enemy_faction = event_region:owning_faction();
			
			local enemy_faction_name = enemy_faction:name();
			if enemy_faction_name == "rebels" then
				enemy_faction_name = "wh3_main_ogr_ogre_kingdoms_qb1";
			end
			
			local eventname = "banditExtort".."?"
				..event_region:name().."*"
				..enemy_faction_name.."*"
				..tostring(bandit_threat).."*";
			
			local caravan_faction = world_conditions["faction"];
			if enemy_faction:name() == caravan_faction:name() then
				probability = 0;
			end;
			
			return {probability,eventname}
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
		
			out.design("banditExtort action called")
			local dilemmas = {"wh3_main_dilemma_cth_caravan_battle_1A", "wh3_main_dilemma_cth_caravan_battle_1B"}
			local dilemma_name = dilemmas[cm:random_number(#dilemmas)]
			
			--Decode the string into arguments-- read_out_event_params explains encoding
			local decoded_args = caravans:read_out_event_params(event_conditions,3);
			
			local is_ambush = false;
			local target_faction = decoded_args[2];
			local enemy_faction;
			local target_region = decoded_args[1];
			
			local bandit_threat = tonumber(decoded_args[3]);
		
			local attacking_force = caravans:generate_attackers(bandit_threat, "");

			local cargo_reduction = -200;

			-- reduce the amount of cargo reduction based on any bonus values the character has
			local character = caravan_handle:caravan_master():character();
			if not character:is_null_interface() then
				local bv_reduction = cm:get_characters_bonus_value(character, "caravan_lower_toll");

				if bv_reduction < 0 then
					cargo_reduction = cargo_reduction + cargo_reduction * (bv_reduction / 100);
				end;
			end;
			
			--Handles the custom options for the dilemmas, such as battles (only?)
			local enemy_cqi = caravans:attach_battle_to_dilemma(
				dilemma_name,
				caravan_handle,
				{attacking_force, 0},
				is_ambush,
				enemy_faction,
				target_region,
				{
					function()
						cm:set_caravan_cargo(caravan_handle, caravan_handle:cargo() + cargo_reduction)
					end,
					1
				}
			);
			
			local target_faction_object = cm:get_faction(target_faction);
			
			--Trigger dilemma to be handled by above function
			local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			payload_builder:text_display("dummy_convoy_redeadify_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
			cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", cargo_reduction);
			cargo_bundle:set_duration(0);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
			local own_faction = caravan_handle:caravan_force():faction();
			if target_faction_object:subculture()=="wh3_main_sc_ogr_ogre_kingdoms" and not target_faction_object:name() == "wh3_main_ogr_ogre_kingdoms_qb1" then
				--for anyone searching for diplomatic_attitude_adjustment: the int ranges from -6 -> 6, and selects a value set in the DB
				payload_builder:diplomatic_attitude_adjustment(target_faction_object, 6);
			else
				local ogre_faction = caravans:get_best_ogre_faction(own_faction:name())
				
				if ogre_faction then
					out.design("Use best ogre faction " .. ogre_faction:name())
					payload_builder:diplomatic_attitude_adjustment(ogre_faction, 6);
				end
			end
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
			dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
		end,
		true
	},
	["banditAmbush"] = 
		--returns its probability [1]
		{function(world_conditions)
		
			local bandit_threat = world_conditions["bandit_threat"];
			local event_region = world_conditions["event_region"];
			local enemy_faction = event_region:owning_faction();
		
			local enemy_faction_name = enemy_faction:name();
			if enemy_faction_name == "rebels" then
				enemy_faction_name = "wh3_main_ogr_ogre_kingdoms_qb1";
			end
			
			local eventname = "banditAmbush".."?"
				..event_region:name().."*"
				..enemy_faction_name.."*"
				..tostring(bandit_threat).."*";
			
			local probability = math.floor(bandit_threat/20) +3;
			
			local caravan_faction = world_conditions["faction"];
			if enemy_faction:name() == caravan_faction:name() then
				probability = 0;
			end;
			
			return {probability,eventname}
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("banditAmbush action called")
			local dilemmas = {"wh3_main_dilemma_cth_caravan_battle_2A", "wh3_main_dilemma_cth_caravan_battle_2B"}
			local dilemma_name = dilemmas[cm:random_number(#dilemmas)]
			
			--Decode the string into arguments-- Need to specify the argument encoding
			local decoded_args = caravans:read_out_event_params(event_conditions,3);
			
			local is_ambush = true;
			local target_faction = decoded_args[2];
			local enemy_faction;
			local target_region = decoded_args[1];
			
			local bandit_threat = tonumber(decoded_args[3]);
			local attacking_force = caravans:generate_attackers(bandit_threat)
			
			-- there's a 33.3% chance of it being an ambush battle, this can be reduced by a bonus value
			local ambush_chance = 333;

			local character = caravan_handle:caravan_master():character();

			if not character:is_null_interface() then
				local bv_ambush_chance_reduction = cm:get_characters_bonus_value(character, "caravan_scouts");

				if bv_ambush_chance_reduction ~= 0 then
					ambush_chance = ambush_chance + ambush_chance * (bv_ambush_chance_reduction / 100);
				end;
			end;

			if cm:random_number(1000) > ambush_chance then
				-- regular land battle
				local enemy_cqi = caravans:attach_battle_to_dilemma(
					dilemma_name,
					caravan_handle,
					{attacking_force, 0},
					false,
					enemy_faction,
					target_region,
					nil,
					1
				);
				
				--Trigger dilemma to be handled by above function
				local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
				local settlement_target = cm:get_region(target_region):settlement();
				
				out.design("Triggering dilemma:"..dilemma_name)
				
				local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
				local payload_builder = cm:create_payload();
				
				payload_builder:text_display("dummy_convoy_redeadify_first");
				dilemma_builder:add_choice_payload("FIRST", payload_builder);
				payload_builder:clear();

				payload_builder:treasury_adjustment(-1000);
				
				dilemma_builder:add_choice_payload("SECOND", payload_builder);
				
				dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
				dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
				payload_builder:text_display("dummy_wh3_main_dilemma_cth_caravan_battle_1B_second");
				
				out.design("Triggering dilemma:"..dilemma_name)
				cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			else
				-- ambush battle
				caravans:spawn_caravan_battle_force(caravan_handle, attacking_force, target_region, true, true);
			end;
		end,
		true
	},
	["banditHungryOgres"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local bandit_threat = world_conditions["bandit_threat"];
			local event_region = world_conditions["event_region"];
			local enemy_faction_name = event_region:owning_faction():name();
			
			if enemy_faction_name == "rebels" then
				enemy_faction_name = "wh3_main_ogr_ogre_kingdoms_qb1";
			end
			local enemy_faction = cm:get_faction(enemy_faction_name);
			
			local random_unit ="NONE";
			local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
			
			if caravan_force_unit_list:num_items() > 1 then
				random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,1)):unit_key();
				
				if random_unit == "wh3_main_cth_cha_lord_caravan_master" or random_unit == "wh3_main_cth_cha_lord_magistrate_0" then
					random_unit = "NONE";
				end
				out.design("Random unit to be eaten: "..random_unit);
			end;
			
			--Construct targets
			local eventname = "banditHungryOgres".."?"
				..event_region:name().."*"
				..random_unit.."*"
				..tostring(bandit_threat).."*"
				..enemy_faction_name.."*";
				
			
			--Calculate probability
			local probability = 0;
			
			if random_unit == "NONE" then
				probability = 0;
			else
				probability = math.min(bandit_threat,10);
				
				if enemy_faction:subculture() == "wh3_main_sc_ogr_ogre_kingdoms" then
					probability = probability + 3;
				end
			end
			local caravan_faction = world_conditions["faction"];
			if enemy_faction:name() == caravan_faction:name() then
				probability = 0;
			end;
			
			return {probability,eventname}
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("banditHungryOgres action called")
			local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_3";
			local caravan = caravan_handle;
			
			--Decode the string into arguments-- Need to specify the argument encoding
			local decoded_args = caravans:read_out_event_params(event_conditions,3);
			
			local is_ambush = true;
			local target_faction = decoded_args[4];
			local enemy_faction;
			local target_region = decoded_args[1];
			local custom_option = nil;
			
			local random_unit = decoded_args[2];
			local bandit_threat = tonumber(decoded_args[3]);
			local attacking_force = caravans:generate_attackers(bandit_threat,"ogres")
			
			--Battle to option 1, eat unit to 2
			local enemy_force_cqi = caravans:attach_battle_to_dilemma(
				dilemma_name,
				caravan,
				{attacking_force, 0},
				false,
				enemy_faction,
				target_region,
				nil
			);
		
			--Trigger dilemma to be handled by above function
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			payload_builder:text_display("dummy_convoy_redeadify_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			local target_faction_object =  cm:get_faction(target_faction);
			local own_faction = caravan_handle:caravan_force():faction();
			if target_faction_object:subculture()=="wh3_main_sc_ogr_ogre_kingdoms" and not target_faction_object:name() == "wh3_main_ogr_ogre_kingdoms_qb1" then
				--for anyone searching for diplomatic_attitude_adjustment: the int ranges from -6 -> 6, and selects a value set in the DC
				payload_builder:diplomatic_attitude_adjustment(target_faction_object, 6);
			else
				local ogre_faction = caravans:get_best_ogre_faction(own_faction:name())
				
				if ogre_faction then
					out.design("Use best ogre faction " .. ogre_faction:name())
					payload_builder:diplomatic_attitude_adjustment(ogre_faction, 6);
				end
			end
			payload_builder:remove_unit(caravan:caravan_force(), random_unit);
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			out.design("Triggering dilemma:"..dilemma_name)
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_force_cqi));
			
			dilemma_builder:add_target("target_military_1", caravan:caravan_force());
			
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			
		end,
		true
	},
	["genericShortcut"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "genericShortcut".."?";
			local probability = 2;
			
			local character = world_conditions["caravan_master"]:character();

			if not character:is_null_interface() then
				probability = probability + cm:get_characters_bonus_value(character, "caravan_double_move")
			end;
			
			return {probability,eventname}
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("genericShortcut action called")
			local dilemma_list = {"wh3_main_dilemma_cth_caravan_1A", "wh3_main_dilemma_cth_caravan_1B"}
			local dilemma_name = dilemma_list[cm:random_number(#dilemma_list)];
			
			--Decode the string into arguments-- Need to specify the argument encoding
			--none to decode

			--Trigger dilemma to be handled by above function
			local faction_key = caravan_handle:caravan_force():faction():name();
			local force_cqi = caravan_handle:caravan_force():command_queue_index();
			
			caravans:attach_battle_to_dilemma(
				dilemma_name,
				caravan_handle,
				nil,
				false,
				nil,
				nil,
				{
					function()
						cm:move_caravan(caravan_handle);
					end,
					1
				}
			);
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local scout_skill = caravan_handle:caravan_master():character_details():character():bonus_values():scripted_value("caravan_scouting", "value");
			payload_builder:text_display("dummy_wh3_main_dilemma_cth_caravan_1A_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			payload_builder:treasury_adjustment(math.floor(-500*((100+scout_skill)/100)));
			payload_builder:text_display("dummy_wh3_main_dilemma_cth_caravan_1A_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		end,
		false
	},
	["genericCharacter"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "genericCharacter".."?";
			
			local probability = 1;
			
			local caravan_force = world_conditions["caravan"]:caravan_force();
			local hero_list = {"wh3_main_ogr_cha_hunter_0","wh_main_emp_cha_captain_0","wh2_main_hef_cha_noble_0","wh3_dlc25_dwf_cha_dragon_slayer"}
			
			if not cm:military_force_contains_unit_type_from_list(caravan_force, hero_list) then
				out.design("No characters - increase probability")
				probability = 5;
			end
			
			local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
			
			if caravan_force_unit_list:num_items() >= 19 then
				probability = 0;
			end
			
			return {probability,eventname}
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			out.design("genericCharacter action called")
			
			local AorB = {"A","B"};
			local choice = AorB[cm:random_number(#AorB,1)]
			
			local dilemma_name = "wh3_main_dilemma_cth_caravan_3"..choice;
			
			--Decode the string into arguments-- Need to specify the argument encoding
			--none to decode

			--Trigger dilemma to be handled by above function
			caravans:attach_battle_to_dilemma(
				dilemma_name,
				caravan_handle,
				nil,
				false,
				nil,
				nil
			);

			local hero_list = {"wh3_main_ogr_cha_hunter_0","wh_main_emp_cha_captain_0","wh2_main_hef_cha_noble_0","wh3_dlc25_dwf_cha_dragon_slayer"};
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			payload_builder:text_display("dummy_wh3_main_dilemma_cth_caravan_1A_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			if choice == "B" then
				payload_builder:treasury_adjustment(-500);
			end
			payload_builder:add_unit(caravan_handle:caravan_force(), hero_list[cm:random_number(#hero_list)], 1, 0);
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			payload_builder:clear();
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction()); -- TODO: surely the attach_battle_to_dilemma needs to be here
		end,
		false
	},
	["genericCargoReplenish"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "genericCargoReplenish".."?";
			local caravan_force = world_conditions["caravan"]:caravan_force();
			
			local probability = 4;
			
			if cm:military_force_average_strength(caravan_force) == 100 and world_conditions["caravan"]:cargo() >= 1000 then
				probability = 0
			end
			
			return {probability,eventname}
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("genericCargoReplenish action called")
			local dilemma_name = "wh3_main_dilemma_cth_caravan_2B";
			
			--Decode the string into arguments-- Need to specify the argument encoding
			--none to decode

			--Trigger dilemma to be handled by above function
			local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
			local force_cqi = caravan_handle:caravan_force():command_queue_index();
			
			caravans:attach_battle_to_dilemma(
				dilemma_name,
				caravan_handle,
				nil,
				false,
				nil,
				nil,
				{
					function()
						cm:set_caravan_cargo(caravan_handle, caravan_handle:cargo() + 200)
					end,
					1
				}
			);
				
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local replenish = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2");
			replenish:add_effect("wh_main_effect_force_all_campaign_replenishment_rate", "force_to_force_own", 8);
			replenish:add_effect("wh_main_effect_force_army_campaign_enable_replenishment_in_foreign_territory", "force_to_force_own", 1);
			replenish:set_duration(2);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), replenish);
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
			cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 200);
			cargo_bundle:set_duration(0);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		end,
		false
	},
	["genericCargoCorruption"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "genericCargoCorruption".."?";
			local caravan_force = world_conditions["caravan"]:caravan_force();
			
			local probability = 4;
			
			if cm:military_force_average_strength(caravan_force) == 100 and world_conditions["caravan"]:cargo() >= 1000 then
				probability = 0
			end
			
			return {probability,eventname}
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("genericCargoCorruption action called")
			local dilemma_name = "wh3_main_dilemma_cth_caravan_2A";
			
			--Decode the string into arguments-- Need to specify the argument encoding
			--none to decode

			--Trigger dilemma to be handled by above function
			local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
			local force_cqi = caravan_handle:caravan_force():command_queue_index();
			
			caravans:attach_battle_to_dilemma(
				dilemma_name,
				caravan_handle,
				nil,
				false,
				nil,
				nil,
				{
					function()
						cm:set_caravan_cargo(caravan_handle, caravan_handle:cargo() + 200)
					end,
					1
				}
			);
				
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();

			payload_builder:text_display("dummy_wh3_main_dilemma_cth_caravan_1A_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			local corruption_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_a");
			corruption_bundle:add_effect("wh3_main_effect_corruption_chaos_events_bad", "faction_to_province_own_factionwide", 2);
			corruption_bundle:set_duration(5);
			
			payload_builder:effect_bundle_to_faction(corruption_bundle);
			
			local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
			cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 200);
			cargo_bundle:set_duration(0);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		end,
		false
	},
	["recruitmentChoiceA"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "recruitmentChoiceA".."?";
			local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
			
			local probability = math.floor((20 - army_size)/2);
			
			return {probability,eventname}
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("recruitmentChoiceA action called")
			local dilemma_name = "wh3_main_dilemma_cth_caravan_4A";
			
			--Decode the string into arguments-- Need to specify the argument encoding
			--none to decode
			
			caravans:attach_battle_to_dilemma(
				dilemma_name,
				caravan_handle,
				nil,
				false,
				nil,
				nil,
				nil
			);
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local ranged_list = {"wh3_main_cth_inf_jade_warrior_crossbowmen_0","wh3_main_cth_inf_jade_warrior_crossbowmen_1","wh3_main_cth_inf_peasant_archers_0","wh3_main_ksl_inf_streltsi_0"};
			local melee_list = {"wh3_main_cth_inf_jade_warriors_0","wh3_main_cth_inf_jade_warriors_1","wh3_main_cth_inf_peasant_spearmen_1"};
			
			payload_builder:add_unit(caravan_handle:caravan_force(), ranged_list[cm:random_number(#ranged_list,1)], 2, 0);
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			payload_builder:add_unit(caravan_handle:caravan_force(), melee_list[cm:random_number(#melee_list,1)], 3, 0);
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			
		end,
		false
	},
	["recruitmentChoiceB"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "recruitmentChoiceB".."?";
			local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
			
			local probability = math.floor((20 - army_size)/2);
			
			return {probability,eventname}
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("recruitmentChoiceB action called")
			local dilemma_name = "wh3_main_dilemma_cth_caravan_4B";
			
			--Decode the string into arguments-- Need to specify the argument encoding
			--none to decode
			
			caravans:attach_battle_to_dilemma(
				dilemma_name,
				caravan_handle,
				nil,
				false,
				nil,
				nil,
				nil
			);
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local ranged_list = {"wh3_main_cth_inf_jade_warrior_crossbowmen_0","wh3_main_cth_inf_jade_warrior_crossbowmen_1","wh3_main_cth_inf_peasant_archers_0"};
			local melee_list = {"wh3_main_cth_inf_jade_warriors_0","wh3_main_cth_inf_jade_warriors_1","wh3_main_cth_inf_peasant_spearmen_1","wh3_main_ogr_inf_ogres_0"};
			
			payload_builder:add_unit(caravan_handle:caravan_force(), ranged_list[cm:random_number(#ranged_list,1)], 3, 0);
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			payload_builder:clear();
			
			payload_builder:add_unit(caravan_handle:caravan_force(), melee_list[cm:random_number(#melee_list,1)], 2, 0);
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			
		end,
		false
	},
	["giftFromInd"] = 
		--returns its probability [1]
		{function(world_conditions)

			local eventname = "giftFromInd".."?";
			local turn_number = cm:turn_number();
			
			local probability = 1 + math.floor(turn_number / 100);
			
			if turn_number < 25 then
				probability = 0;
			end
			
			return {probability,eventname}
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("giftFromInd action called")
			local dilemma_name = "wh3_main_dilemma_cth_caravan_5";
			
			caravans:attach_battle_to_dilemma(
				dilemma_name,
				caravan_handle,
				nil,
				false,
				nil,
				nil,
				{
					function()
						cm:set_caravan_cargo(caravan_handle, caravan_handle:cargo() + 1000)
					end,
					0
				}
			);
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			--FIRST double cargo capacity and value, and additional cargo
			payload_builder:character_trait_change(caravan_handle:caravan_master():character_details():character(),"wh3_main_trait_blessed_by_ind_riches",false)
			
			local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
			cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 1000);
			cargo_bundle:set_duration(0);
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);

			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			--SECOND trait and free units
			payload_builder:character_trait_change(caravan_handle:caravan_master():character_details():character(),"wh3_main_trait_blessed_by_ind_blades",false)
			local num_units = caravan_handle:caravan_force():unit_list():num_items()
		
			if num_units < 20 then
				payload_builder:add_unit(caravan_handle:caravan_force(), "wh3_main_cth_inf_dragon_guard_0", math.min(3, 20 - num_units), 9);
			end
			
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			
		end,
		false
	},
	["daemonIncursion"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			--Pick random unit
			local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
			
			local random_unit ="NONE";
			if caravan_force_unit_list:num_items() > 1 then
				random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,0)):unit_key();
				
				if random_unit == "wh3_main_cth_cha_lord_caravan_master" then
					random_unit ="NONE";
				end
				out.design("Random unit to be killed: "..random_unit);
			end;
			
			local bandit_threat = world_conditions["bandit_threat"];
			local event_region = world_conditions["event_region"];
			
			--Construct targets
			local eventname = "daemonIncursion".."?"
				..event_region:name().."*"
				..random_unit.."*"
				..tostring(bandit_threat).."*";
				
			
			--Calculate probability
			local probability = 1 + math.floor(cm:model():turn_number() / 100);
			
			local turn_number = cm:turn_number();
			if turn_number < 25 then
				probability = 0;
			end
			
			return {probability,eventname}
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("daemonIncursion action called")
			local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_4";
			local caravan = caravan_handle;
			
			--Decode the string into arguments-- Need to specify the argument encoding
			local decoded_args = caravans:read_out_event_params(event_conditions,3);
			
			local is_ambush = true;
			local target_faction;
			local enemy_faction = "wh3_main_kho_khorne_qb1";
			local target_region = decoded_args[1];
			
			local bandit_threat = tonumber(decoded_args[3]);
			local attacking_force = caravans:generate_attackers(bandit_threat,"daemon_incursion")
			
			--Battle to option 1, eat unit to 2
			local enemy_force_cqi = caravans:attach_battle_to_dilemma(
				dilemma_name,
				caravan,
				{attacking_force, 0},
				false,
				enemy_faction,
				target_region,
				nil
			);
		
			--Trigger dilemma to be handled by above function
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			--Battle the daemons - need a custom trait for winning this
			payload_builder:character_trait_change(caravan_handle:caravan_master():character_details():character(),"wh3_main_trait_caravan_daemon_hunter",false)
			
			local daemon_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_daemon_hunter");
			daemon_bundle:add_effect("wh3_main_effect_attribute_enable_causes_fear_vs_dae","faction_to_force_own",1);
			daemon_bundle:set_duration(0);
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), daemon_bundle);
			
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			
			payload_builder:clear();
			
			--Lose soldiers - coward trait?
			local random_unit = decoded_args[2];
			payload_builder:remove_unit(caravan:caravan_force(), random_unit);
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			out.design("Triggering dilemma:"..dilemma_name)
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_force_cqi));
			dilemma_builder:add_target("target_military_1", caravan:caravan_force());
			
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		end,
		true
	}
}

-- Ogre Bandit force A - low (5)
random_army_manager:new_force("ogre_bandit_low_a");
random_army_manager:add_mandatory_unit("ogre_bandit_low_a", "wh3_main_ogr_inf_ogres_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_low_a", "wh3_main_ogr_inf_gnoblars_0", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_low_a", "wh3_main_ogr_mon_sabretusk_pack_0", 1);

random_army_manager:add_unit("ogre_bandit_low_a", "wh3_main_ogr_inf_gnoblars_0", 1);
random_army_manager:add_unit("ogre_bandit_low_a", "wh3_main_ogr_mon_sabretusk_pack_0", 1);

-- Ogre Bandit force A - low (5)
random_army_manager:new_force("ogre_bandit_low_b");
random_army_manager:add_mandatory_unit("ogre_bandit_low_b", "wh3_main_ogr_inf_maneaters_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_low_b", "wh3_main_ogr_inf_gnoblars_0", 2);

random_army_manager:add_unit("ogre_bandit_low_b", "wh3_main_ogr_inf_gnoblars_0", 1);
random_army_manager:add_unit("ogre_bandit_low_b", "wh3_main_ogr_mon_sabretusk_pack_0", 1);

-- Ogre Bandit force A - medium (8)
random_army_manager:new_force("ogre_bandit_med_a");
random_army_manager:add_mandatory_unit("ogre_bandit_med_a", "wh3_main_ogr_inf_ogres_0", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_med_a", "wh3_main_ogr_inf_gnoblars_0", 3);
random_army_manager:add_mandatory_unit("ogre_bandit_med_a", "wh3_main_ogr_mon_sabretusk_pack_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_med_a", "wh3_main_ogr_cav_mournfang_cavalry_0", 1);

random_army_manager:add_unit("ogre_bandit_med_a", "wh3_main_ogr_inf_gnoblars_0", 1);
random_army_manager:add_unit("ogre_bandit_med_a", "wh3_main_ogr_mon_sabretusk_pack_0", 1);

-- Ogre Bandit force B - medium (8)
random_army_manager:new_force("ogre_bandit_med_b");
random_army_manager:add_mandatory_unit("ogre_bandit_med_b", "wh3_main_ogr_inf_ogres_0", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_med_b", "wh3_main_ogr_inf_gnoblars_0", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_med_b", "wh3_main_ogr_inf_gnoblars_1", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_med_b", "wh3_main_ogr_inf_leadbelchers_0", 1);

random_army_manager:add_unit("ogre_bandit_med_b", "wh3_main_ogr_inf_gnoblars_0", 1);
random_army_manager:add_unit("ogre_bandit_med_b", "wh3_main_ogr_mon_sabretusk_pack_0", 1);

-- Ogre Bandit force A - High (10)
random_army_manager:new_force("ogre_bandit_high_a");
random_army_manager:add_mandatory_unit("ogre_bandit_high_a", "wh3_main_ogr_cha_hunter_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_high_a", "wh3_main_ogr_inf_ogres_0", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_high_a", "wh3_main_ogr_inf_gnoblars_1", 3);
random_army_manager:add_mandatory_unit("ogre_bandit_high_a", "wh3_main_ogr_cav_mournfang_cavalry_0", 2);

random_army_manager:add_unit("ogre_bandit_high_a", "wh3_main_ogr_inf_gnoblars_0", 1);
random_army_manager:add_unit("ogre_bandit_high_a", "wh3_main_ogr_mon_sabretusk_pack_0", 1);

-- Ogre Bandit force B - High (10)
random_army_manager:new_force("ogre_bandit_high_b");
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_maneaters_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_ogres_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_gnoblars_0", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_gnoblars_1", 3);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_veh_gnoblar_scraplauncher_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_leadbelchers_0", 1);

random_army_manager:add_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_gnoblars_0", 1);
random_army_manager:add_unit("ogre_bandit_high_b", "wh3_main_ogr_mon_sabretusk_pack_0", 1);

-- Daemon Army
random_army_manager:new_force("daemon_incursion");
random_army_manager:add_mandatory_unit("daemon_incursion", "wh3_main_kho_inf_bloodletters_0", 3);
random_army_manager:add_mandatory_unit("daemon_incursion", "wh3_main_kho_inf_chaos_warhounds_0", 4);
random_army_manager:add_mandatory_unit("daemon_incursion", "wh3_main_kho_cav_gorebeast_chariot", 1);

random_army_manager:new_force("daemon_incursion_late");
random_army_manager:add_mandatory_unit("daemon_incursion_late", "wh3_main_kho_inf_bloodletters_0", 4);
random_army_manager:add_mandatory_unit("daemon_incursion_late", "wh3_main_kho_inf_chaos_warhounds_0", 4);
random_army_manager:add_mandatory_unit("daemon_incursion_late", "wh3_main_kho_cav_gorebeast_chariot", 2);
