caravans.event_tables["wh3_dlc23_chd_chaos_dwarfs"] = {

		--Format is [key] == {probability function, event function}
		["daemonsCargo"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_portals_part_2";
			local bandit_threat = world_conditions["bandit_threat"];
			local probability = 0;
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key]["wh3_dlc23_dilemma_chd_convoy_portals_part_1"] > 0 and caravans.events_cooldown[faction_key][dilemma_name] <= 0 then
				probability = 1
			end	
	
			local event_region = world_conditions["event_region"];
			local enemy_faction = "wh3_main_kho_khorne_qb1"
			
			local eventname = "daemonsCargo".."?"
				..event_region:name().."*"
				..enemy_faction.."*"
				..tostring(bandit_threat).."*";
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
		
			out.design("daemonsCargo action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_portals_part_2";
			local caravan = caravan_handle;
			
			--Decode the string into arguments-- read_out_event_params explains encoding
			local decoded_args = caravans:read_out_event_params(event_conditions,3);
			
			local is_ambush = false;
			local target_faction = decoded_args[2]; --enemy faction name
			local enemy_faction = decoded_args[2];
			local target_region = decoded_args[1]; --event region name
			local custom_option = nil;
			
			local bandit_threat = tonumber(decoded_args[3]);
		
			local attacking_force = caravans:generate_attackers(bandit_threat, "daemon_incursion_convoy");
			
			local cargo_amount = caravan_handle:cargo();
			
			--Dilemma option to remove cargo
			function remove_cargo()
				cm:set_caravan_cargo(caravan_handle, cargo_amount-100)
			end
			
			custom_option = remove_cargo;
			
			--Handles the custom options for the dilemmas, such as battles (only?)
			local enemy_cqi = caravans:attach_battle_to_dilemma(
													dilemma_name,
													caravan,
													attacking_force,
													is_ambush,
													target_faction,
													enemy_faction,
													target_region,
													custom_option
													);
			
			local target_faction_object = cm:get_faction(target_faction);
			
			--Trigger dilemma to be handled by above function
			local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			payload_builder:text_display("dummy_convoy_portal_2_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
			cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -100);
			cargo_bundle:set_duration(0);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
			local own_faction = caravan_handle:caravan_force():faction();
			payload_builder:text_display("dummy_convoy_portal_2_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
			dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			out.design(caravans.events_cooldown[faction_key][dilemma_name]);
			cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
		end,
		false},

		["cathayCargo"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local bandit_threat = world_conditions["bandit_threat"];
			local probability = 1;
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_cathay_caravan";
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

			if world_conditions["caravan"]:cargo() >= 1000 then
				probability = 0;
			end
			
			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
				probability = 0;
			end

			local event_region = world_conditions["event_region"];
			local enemy_faction = "wh3_main_cth_cathay_qb1"
			
			local eventname = "cathayCargo".."?"
				..event_region:name().."*"
				..enemy_faction.."*"
				..tostring(bandit_threat).."*";
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
		
			out.design("cathayCargo action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_cathay_caravan";
			local caravan = caravan_handle;
			
			--Decode the string into arguments-- read_out_event_params explains encoding
			local decoded_args = caravans:read_out_event_params(event_conditions,3);
			
			local is_ambush = false;
			local target_faction = decoded_args[2]; --enemy faction name
			local enemy_faction = decoded_args[2];
			local target_region = decoded_args[1]; --event region name
			local custom_option = nil;
			
			local bandit_threat = tonumber(decoded_args[3]);
		
			local attacking_force = caravans:generate_attackers(bandit_threat, "cathay_caravan_army");
			
			local cargo_amount = caravan_handle:cargo();
			
			--Dilemma option to add cargo
			function add_cargo()
				local cargo = caravan_handle:cargo();
				cm:set_caravan_cargo(caravan_handle, cargo+100)
			end
			
			custom_option = add_cargo;
			
			--Handles the custom options for the dilemmas, such as battles (only?)
			local enemy_cqi = caravans:attach_battle_to_dilemma(
													dilemma_name,
													caravan,
													attacking_force,
													is_ambush,
													target_faction,
													enemy_faction,
													target_region,
													custom_option
													);
			
			local target_faction_object = cm:get_faction(target_faction);
			
			--Trigger dilemma to be handled by above function
			local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
			cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
			cargo_bundle:set_duration(0);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
			local own_faction = caravan_handle:caravan_force():faction();
			
			payload_builder:text_display("dummy_convoy_cathay_caravan_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();

			payload_builder:text_display("dummy_convoy_cathay_caravan_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
			dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
		end,
		false},

		["genericShortcut"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "genericShortcut".."?";
			local probability = 1;
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_the_guide"
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
				probability = 0;
			end
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("genericShortcut action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_the_guide"			
			
			function extra_move()
				--check if more than 1 move from the end
				cm:move_caravan(caravan_handle);
			end
			custom_option = extra_move;
			
			caravans:attach_battle_to_dilemma(
				dilemma_name,
				caravan_handle,
				nil,
				false,
				nil,
				nil,
				nil,
				custom_option);
			
			local scout_skill = caravan_handle:caravan_master():character_details():character():bonus_values():scripted_value("caravan_scouting", "value");
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			local faction_key = caravan_handle:caravan_force():faction():name();

			local own_faction = caravan_handle:caravan_force():faction();

			payload_builder:text_display("dummy_convoy_guide_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();

			payload_builder:treasury_adjustment(math.floor(-500*((100+scout_skill)/100)));

			payload_builder:text_display("dummy_convoy_guide_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			dilemma_builder:add_target("default", caravan_handle:caravan_force());

			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
			
		end,
		false},

		["daemonsPortal"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "daemonsPortal".."?";
			local probability = 1;
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_portals_part_1"
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();	
			
			if world_conditions["caravan"]:cargo() >= 1000 then
				probability = 0
			end

			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
				probability = 0;
			end
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("daemonsPortal action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_portals_part_1"	
			local faction_key = caravan_handle:caravan_force():faction():name();	
			--Decode the string into arguments-- Need to specify the argument encoding
			--none to decode

			--Trigger dilemma to be handled by aboove function
			
			function add_cargo()
				local cargo = caravan_handle:cargo();
				cm:set_caravan_cargo(caravan_handle, cargo+100)
			end
			custom_option = add_cargo;
			
			caravans:attach_battle_to_dilemma(
				dilemma_name,
				caravan_handle,
				nil,
				false,
				nil,
				nil,
				nil,
				custom_option);
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
			cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
			cargo_bundle:set_duration(0);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
			local own_faction = caravan_handle:caravan_force():faction();	

			payload_builder:text_display("dummy_convoy_portal_1_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			payload_builder:text_display("dummy_convoy_portal_1_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());

			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			
		end,
		false},

		["daemonsRecruitment"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "daemonsRecruitment".."?";
			local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_portals_part_3_a";
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

			local probability = 0;

			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key]["wh3_dlc23_dilemma_chd_convoy_portals_part_2"] > 0 and caravans.events_cooldown[faction_key][dilemma_name] <= 0 then
				probability = math.floor((20 - army_size)/2); 
			end	
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("daemonsRecruitment action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_portals_part_3_a";
			local faction_key = caravan_handle:caravan_force():faction():name();
			--Decode the string into arguments-- Need to specify the argument encoding
			--none to decode
			
			caravans:attach_battle_to_dilemma(
						dilemma_name,
						caravan_handle,
						nil,
						false,
						nil,
						nil,
						nil,
						nil);
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local infantry_list = {"wh3_main_kho_inf_bloodletters_1","wh3_main_nur_inf_plaguebearers_1","wh3_main_sla_inf_daemonette_1","wh3_main_tze_inf_pink_horrors_1"};
			local monster_list = {"wh3_main_kho_cav_bloodcrushers_0","wh3_main_nur_cav_plague_drones_1","wh3_main_sla_mon_fiends_of_slaanesh_0", "wh3_main_pro_tze_mon_screamers_0"};
			
			payload_builder:add_unit(caravan_handle:caravan_force(), monster_list[cm:random_number(#monster_list,1)], 1, 0);
			payload_builder:text_display("dummy_convoy_portal_3_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			payload_builder:add_unit(caravan_handle:caravan_force(), infantry_list[cm:random_number(#infantry_list,1)], 1, 0);
			payload_builder:text_display("dummy_convoy_portal_3_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			
		end,
		false},

		["ogreRecruitment"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "ogreRecruitment".."?";
			local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_ogre_mercenaries";
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

			local probability = math.floor((20 - army_size)/2);

			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
				probability = 0;
			end
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("ogreRecruitment action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_ogre_mercenaries";
			local faction_key = caravan_handle:caravan_force():faction():name();
			--Decode the string into arguments-- Need to specify the argument encoding
			--none to decode
			
			caravans:attach_battle_to_dilemma(
						dilemma_name,
						caravan_handle,
						nil,
						false,
						nil,
						nil,
						nil,
						nil);
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local ogre_list = {"wh3_main_ogr_inf_maneaters_0","wh3_main_ogr_inf_maneaters_1","wh3_main_ogr_inf_maneaters_2"};
			
			payload_builder:add_unit(caravan_handle:caravan_force(), ogre_list[cm:random_number(#ogre_list,1)], 1, 0);
			payload_builder:treasury_adjustment(-1000);
			payload_builder:text_display("dummy_convoy_ogres_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			payload_builder:text_display("dummy_convoy_ogres_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			
		end,
		false},

		["skavenShortcut"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local bandit_threat = world_conditions["bandit_threat"];
			local probability = 1;
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_rats_in_a_tunnel";
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
				probability = 0;
			end
			
			local event_region = world_conditions["event_region"];
			local enemy_faction = "wh2_main_skv_skaven_qb1"
			
			local eventname = "skavenShortcut".."?"
				..event_region:name().."*"
				..enemy_faction.."*"
				..tostring(bandit_threat).."*";
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
		
			out.design("skavenShortcut action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_rats_in_a_tunnel";
			local caravan = caravan_handle;
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			--Decode the string into arguments-- read_out_event_params explains encoding
			local decoded_args = caravans:read_out_event_params(event_conditions,3);
			
			local is_ambush = false;
			local target_faction = decoded_args[2]; --enemy faction name
			local enemy_faction = decoded_args[2];
			local target_region = decoded_args[1]; --event region name
			local custom_option = nil;
			
			local bandit_threat = tonumber(decoded_args[3]);
		
			local attacking_force = caravans:generate_attackers(bandit_threat, "skaven_shortcut_army");
			
			local cargo_amount = caravan_handle:cargo();
			
			function extra_move()
				--check if more than 1 move from the end
				cm:move_caravan(caravan_handle);
			end
			custom_option = extra_move;
			
			--Handles the custom options for the dilemmas, such as battles (only?)
			local enemy_cqi = caravans:attach_battle_to_dilemma(
													dilemma_name,
													caravan,
													attacking_force,
													is_ambush,
													target_faction,
													enemy_faction,
													target_region,
													custom_option
													);
			
			local target_faction_object = cm:get_faction(target_faction);
			
			--Trigger dilemma to be handled by above function
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local own_faction = caravan_handle:caravan_force():faction();

			payload_builder:text_display("dummy_convoy_rats_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
			dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());

			payload_builder:clear();

			payload_builder:text_display("dummy_convoy_rats_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			
			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
		end,
		false},

		["dwarfsConvoy"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local bandit_threat = world_conditions["bandit_threat"];
			local probability = 1;
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_dwarfs";
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

			if world_conditions["caravan"]:cargo() >= 1000 then
				probability = 0
			end

			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
				probability = 0;
			end
			
			local event_region = world_conditions["event_region"];
			local enemy_faction = "wh_main_dwf_dwarfs_qb1"
			
			local eventname = "dwarfsConvoy".."?"
				..event_region:name().."*"
				..enemy_faction.."*"
				..tostring(bandit_threat).."*";
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
		
			out.design("dwarfsConvoy action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_dwarfs";
			local caravan = caravan_handle;
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			--Decode the string into arguments-- read_out_event_params explains encoding
			local decoded_args = caravans:read_out_event_params(event_conditions,3);
			
			local is_ambush = false;
			local target_faction = decoded_args[2]; --enemy faction name
			local enemy_faction = decoded_args[2];
			local target_region = decoded_args[1]; --event region name
			local custom_option = nil;
			
			local bandit_threat = tonumber(decoded_args[3]);
		
			local attacking_force = caravans:generate_attackers(bandit_threat, "dwarf_convoy_army");
			
			local cargo_amount = caravan_handle:cargo();
			
			--Dilemma option to add cargo
			function add_cargo()
				local cargo = caravan_handle:cargo();
				cm:set_caravan_cargo(caravan_handle, cargo+100)
			end
			
			custom_option = add_cargo;
			
			--Handles the custom options for the dilemmas, such as battles (only?)
			local enemy_cqi = caravans:attach_battle_to_dilemma(
													dilemma_name,
													caravan,
													attacking_force,
													is_ambush,
													target_faction,
													enemy_faction,
													target_region,
													custom_option
													);

													
			local target_faction_object = cm:get_faction(target_faction);
			
			--Trigger dilemma to be handled by above function
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
			cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
			cargo_bundle:set_duration(0);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
			local own_faction = caravan_handle:caravan_force():faction();

			payload_builder:text_display("dummy_convoy_dwarfs_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
			dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());

			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
			dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
		end,
		false},

		["ogreAmbush"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local bandit_threat = world_conditions["bandit_threat"];
			local probability = 1;
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_the_ambush";
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
			
			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
				probability = 0;
			end

			local event_region = world_conditions["event_region"];
			local enemy_faction = "wh3_main_ogr_ogre_kingdoms_qb1"
			
			local eventname = "ogreAmbush".."?"
				..event_region:name().."*"
				..enemy_faction.."*"
				..tostring(bandit_threat).."*";
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
		
			out.design("ogreAmbush action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_the_ambush";
			local caravan = caravan_handle;
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			--Decode the string into arguments-- read_out_event_params explains encoding
			local decoded_args = caravans:read_out_event_params(event_conditions,3);
			
			local is_ambush = false;
			local target_faction = decoded_args[2]; --enemy faction name
			local enemy_faction = decoded_args[2];
			local target_region = decoded_args[1]; --event region name
			local custom_option = nil;
			
			local bandit_threat = tonumber(decoded_args[3]);
		
			local attacking_force = caravans:generate_attackers(bandit_threat, "ogre_bandit_high_b");
			
			--Handles the custom options for the dilemmas, such as battles (only?)
			local enemy_cqi = caravans:attach_battle_to_dilemma(
													dilemma_name,
													caravan,
													attacking_force,
													is_ambush,
													target_faction,
													enemy_faction,
													target_region,
													custom_option
													);

			local target_faction_object = cm:get_faction(target_faction);
			
			--Trigger dilemma to be handled by above function
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();

			local own_faction = caravan_handle:caravan_force():faction();
			payload_builder:text_display("dummy_convoy_ambush_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
			dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());

			payload_builder:clear();
			payload_builder:text_display("dummy_convoy_ambush_second");										
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
		end,
		false},

		["hobgoblinTribute"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "hobgoblinTribute".."?";
			local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_hobgoblin_tribute";
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
			
			local probability = math.floor((20 - army_size)/2);

			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
				probability = 0;
			end
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("hobgoblinTribute action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_hobgoblin_tribute";
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			--Decode the string into arguments-- Need to specify the argument encoding
			--none to decode
			
			caravans:attach_battle_to_dilemma(
						dilemma_name,
						caravan_handle,
						nil,
						false,
						nil,
						nil,
						nil,
						nil);
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local hobgoblin_list = {"wh3_dlc23_chd_inf_hobgoblin_cutthroats","wh3_dlc23_chd_inf_hobgoblin_archers","wh3_dlc23_chd_inf_hobgoblin_sneaky_gits"};
			
			payload_builder:add_unit(caravan_handle:caravan_force(), hobgoblin_list[cm:random_number(#hobgoblin_list,1)], 2, 0);
			payload_builder:text_display("dummy_convoy_hobgoblin_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();

			local replenish = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2");
			replenish:add_effect("wh_main_effect_force_all_campaign_replenishment_rate", "force_to_force_own", 8);
			replenish:add_effect("wh_main_effect_force_army_campaign_enable_replenishment_in_foreign_territory", "force_to_force_own", 1);
			replenish:set_duration(2);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), replenish);
			payload_builder:text_display("dummy_convoy_hobgoblin_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			
		end,
		false},

		["hungryDaemons"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local bandit_threat = world_conditions["bandit_threat"];
			local event_region = world_conditions["event_region"];
			local enemy_faction_name = "wh_main_chs_chaos_qb1";
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
			
			local enemy_faction = cm:get_faction(enemy_faction_name);
			
			local random_unit ="NONE";
			local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
			
			if caravan_force_unit_list:num_items() > 1 then
				random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,1)):unit_key();
				
				if random_unit == "wh3_dlc23_chd_cha_overseer" or random_unit == "wh3_dlc23_chd_cha_convoy_overseer" then
					random_unit = "NONE";
				end
				out.design("Random unit to be eaten: "..random_unit);
			end;
			
			--Construct targets
			local eventname = "hungryDaemons".."?"
				..event_region:name().."*"
				..random_unit.."*"
				..tostring(bandit_threat).."*"
				..enemy_faction_name.."*";
				
			
			--Calculate probability
			local probability = 1;
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_hungry_daemons";
			
			if random_unit == "NONE" then
				probability = 0;
			else
				probability = 1;
				
				if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
					probability = 0;
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
			
			out.design("hungryDaemons action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_hungry_daemons";
			local caravan = caravan_handle;
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			--Decode the string into arguments-- Need to specify the argument encoding
			local decoded_args = caravans:read_out_event_params(event_conditions,3);
			
			local is_ambush = true;
			local target_faction = decoded_args[4];
			local enemy_faction = decoded_args[4];
			local target_region = decoded_args[1];
			local custom_option = nil;
			
			local random_unit = decoded_args[2];
			local bandit_threat = tonumber(decoded_args[3]);
			local attacking_force = caravans:generate_attackers(bandit_threat,"hungry_chaos_army")
			
			
			--Eat unit to option 2
			function eat_unit_outcome()
				if random_unit ~= nil then
					local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
					cm:remove_unit_from_character(
					caravan_master_lookup,
					random_unit);

				else
					out("Script error - should have a unit to eat?")
				end
			end
			
			custom_option = nil; --eat_unit_outcome;
			
			--Battle to option 1, eat unit to 2
			local enemy_force_cqi = caravans:attach_battle_to_dilemma(
														dilemma_name,
														caravan,
														attacking_force,
														false,
														target_faction,
														enemy_faction,
														target_region,
														custom_option
														);
		
			--Trigger dilemma to be handled by above function
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			payload_builder:text_display("dummy_convoy_hungry_daemons_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			local target_faction_object =  cm:get_faction(target_faction);
			
			payload_builder:remove_unit(caravan:caravan_force(), random_unit);

			payload_builder:text_display("dummy_convoy_hungry_daemons_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			out.design("Triggering dilemma:"..dilemma_name)
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_force_cqi));
			
			dilemma_builder:add_target("target_military_1", caravan:caravan_force());
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			
		end,
		false},

		["trainingCamp"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "trainingCamp".."?";
			local probability = 1;
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_training_camp";
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
				probability = 0;
			end
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions, caravan_handle)
			
			out.design("trainingCamp action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_training_camp";
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			--Decode the string into arguments-- Need to specify the argument encoding
			--none to decode
			
			caravans:attach_battle_to_dilemma(
						dilemma_name,
						caravan_handle,
						nil,
						false,
						nil,
						nil,
						nil,
						nil);
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();

			local experience = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_convoy_experience");
			experience:add_effect("wh2_main_effect_captives_unit_xp", "force_to_force_own", 2000);
			experience:set_duration(1);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), experience);
			payload_builder:text_display("dummy_convoy_training_camp_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();

			payload_builder:text_display("dummy_convoy_training_camp_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			
		end,
		false},

		["wayofLava"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "wayofLava".."?";
			
			local probability = 1;
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_way_of_lava";
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
			
			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
				probability = 0;
			end

			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions, caravan_handle)
			
			out.design("wayofLava action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_way_of_lava";
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			--Decode the string into arguments-- Need to specify the argument encoding
			--none to decode
			
			function extra_move()
				--check if more than 1 move from the end
				cm:move_caravan(caravan_handle);
			end
			custom_option = extra_move;
			
			caravans:attach_battle_to_dilemma(
				dilemma_name,
				caravan_handle,
				nil,
				false,
				nil,
				nil,
				nil,
				custom_option);
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();

			payload_builder:text_display("dummy_convoy_way_of_lava_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();

			local attrition = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_convoy_attrition");
			attrition:add_effect("wh_main_effect_campaign_enable_attrition", "force_to_force_own", 500);
			attrition:set_duration(3);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), attrition);
	
			payload_builder:text_display("dummy_convoy_way_of_lava_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			
		end,
		false},

		["offenceorDefence"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "offenceorDefence".."?";
			
			local probability = 1;
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_offence_or_defence";
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
				probability = 0;
			end
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions, caravan_handle)
			
			out.design("wayofLava action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_offence_or_defence";
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			--Decode the string into arguments-- Need to specify the argument encoding
			--none to decode
			
			caravans:attach_battle_to_dilemma(
				dilemma_name,
				caravan_handle,
				nil,
				false,
				nil,
				nil,
				nil,
				nil);
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();

			local offence = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_convoy_offence");
			offence:add_effect("wh_main_effect_force_stat_melee_attack", "force_to_force_own", 10);
			offence:add_effect("wh_main_effect_force_stat_weapon_strength", "force_to_force_own", 20);
			offence:set_duration(5);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), offence);

			payload_builder:text_display("dummy_convoy_offence_defence_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();

			local defence = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_convoy_defence");
			defence:add_effect("wh_main_effect_force_stat_melee_defence", "force_to_force_own", 10);
			defence:add_effect("wh_main_effect_force_stat_armour", "force_to_force_own", 20);
			defence:set_duration(5);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), defence);
	
			payload_builder:text_display("dummy_convoy_offence_defence_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			
		end,
		false},

		["localisedElfs"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local bandit_threat = world_conditions["bandit_threat"];
			local probability = 1;
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_localised_elfs";
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
			
			if world_conditions["caravan"]:cargo() >= 1000 then
				probability = 0;
			end

			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
				probability = 0;
			end
			
			local event_region = world_conditions["event_region"];
			local enemy_faction = "wh2_main_hef_high_elves_qb1"
			
			local eventname = "localisedElfs".."?"
				..event_region:name().."*"
				..enemy_faction.."*"
				..tostring(bandit_threat).."*";
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
		
			out.design("localisedElfs action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_localised_elfs";
			local caravan = caravan_handle;
			
			--Decode the string into arguments-- read_out_event_params explains encoding
			local decoded_args = caravans:read_out_event_params(event_conditions,3);
			
			local is_ambush = false;
			local target_faction = decoded_args[2]; --enemy faction name
			local enemy_faction = decoded_args[2];
			local target_region = decoded_args[1]; --event region name
			local custom_option = nil;
			
			local bandit_threat = tonumber(decoded_args[3]);
		
			local attacking_force = caravans:generate_attackers(bandit_threat, "high_elf_army");
			
			local cargo_amount = caravan_handle:cargo();
			
			--Dilemma option to add cargo
			function add_cargo()
				local cargo = caravan_handle:cargo();
				cm:set_caravan_cargo(caravan_handle, cargo+100)
			end
			
			custom_option = add_cargo;
			
			--Handles the custom options for the dilemmas, such as battles (only?)
			local enemy_cqi = caravans:attach_battle_to_dilemma(
													dilemma_name,
													caravan,
													attacking_force,
													is_ambush,
													target_faction,
													enemy_faction,
													target_region,
													custom_option
													);
			
			local target_faction_object = cm:get_faction(target_faction);
			
			--Trigger dilemma to be handled by above function
			local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
			cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
			cargo_bundle:set_duration(0);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
			local own_faction = caravan_handle:caravan_force():faction();
			
			payload_builder:text_display("dummy_convoy_localised_elfs_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();

			payload_builder:text_display("dummy_convoy_localised_elfs_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
			dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
		end,
		false},

		["readDeadify"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local bandit_threat = world_conditions["bandit_threat"];
			local event_region = world_conditions["event_region"];
			local enemy_faction_name = "wh_main_vmp_vampire_counts_qb1";
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
			
			local enemy_faction = cm:get_faction(enemy_faction_name);
			
			local random_unit ="NONE";
			local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
			
			if caravan_force_unit_list:num_items() > 1 then
				random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,1)):unit_key();
				
				if random_unit == "wh3_dlc23_chd_cha_overseer" or random_unit == "wh3_dlc23_chd_cha_convoy_overseer" then
					random_unit = "NONE";
				end
				out.design("Random unit to be eaten: "..random_unit);
			end;
			
			--Construct targets
			local eventname = "readDeadify".."?"
				..event_region:name().."*"
				..random_unit.."*"
				..tostring(bandit_threat).."*"
				..enemy_faction_name.."*";
				
			
			--Calculate probability
			local probability = 1;
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_redeadify";
			
			if random_unit == "NONE" then
				probability = 0;
			else
				probability = 1;
				if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
					probability = 0;
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
			
			out.design("hungryDaemons action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_redeadify";
			local caravan = caravan_handle;
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			--Decode the string into arguments-- Need to specify the argument encoding
			local decoded_args = caravans:read_out_event_params(event_conditions,3);
			
			local is_ambush = true;
			local target_faction = decoded_args[4];
			local enemy_faction = decoded_args[4];
			local target_region = decoded_args[1];
			local custom_option = nil;
			
			local random_unit = decoded_args[2];
			local bandit_threat = tonumber(decoded_args[3]);
			local attacking_force = caravans:generate_attackers(bandit_threat,"vampire_count_army")
			
			
			--Eat unit to option 2
			function eat_unit_outcome()
				if random_unit ~= nil then
					local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
					cm:remove_unit_from_character(
					caravan_master_lookup,
					random_unit);

				else
					out("Script error - should have a unit to eat?")
				end
			end
			
			custom_option = nil; --eat_unit_outcome;
			
			--Battle to option 1, eat unit to 2
			local enemy_force_cqi = caravans:attach_battle_to_dilemma(
														dilemma_name,
														caravan,
														attacking_force,
														false,
														target_faction,
														enemy_faction,
														target_region,
														custom_option
														);
		
			--Trigger dilemma to be handled by above function
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			payload_builder:text_display("dummy_convoy_redeadify_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			local target_faction_object =  cm:get_faction(target_faction);
			
			payload_builder:remove_unit(caravan:caravan_force(), random_unit);

			payload_builder:text_display("dummy_convoy_redeadify_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			out.design("Triggering dilemma:"..dilemma_name)
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_force_cqi));
			
			dilemma_builder:add_target("target_military_1", caravan:caravan_force());
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			
		end,
		false},
		
		["farfromHome"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local bandit_threat = world_conditions["bandit_threat"];
			local probability = 1;
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_far_from_home";
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
			
			if world_conditions["caravan"]:cargo() >= 1000 then
				probability = 0;
			end

			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
				probability = 0;
			end
			
			local event_region = world_conditions["event_region"];
			local enemy_faction = "wh2_dlc09_tmb_tombking_qb1"
			
			local eventname = "farfromHome".."?"
				..event_region:name().."*"
				..enemy_faction.."*"
				..tostring(bandit_threat).."*";
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
		
			out.design("farfromHome action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_far_from_home";
			local caravan = caravan_handle;
			
			--Decode the string into arguments-- read_out_event_params explains encoding
			local decoded_args = caravans:read_out_event_params(event_conditions,3);
			
			local is_ambush = false;
			local target_faction = decoded_args[2]; --enemy faction name
			local enemy_faction = decoded_args[2];
			local target_region = decoded_args[1]; --event region name
			local custom_option = nil;
			
			local bandit_threat = tonumber(decoded_args[3]);
		
			local attacking_force = caravans:generate_attackers(bandit_threat, "tomb_kings_army");
			
			local cargo_amount = caravan_handle:cargo();
			
			--Dilemma option to add cargo
			function add_cargo()
				local cargo = caravan_handle:cargo();
				cm:set_caravan_cargo(caravan_handle, cargo+100)
			end
			
			custom_option = add_cargo;
			
			--Handles the custom options for the dilemmas, such as battles (only?)
			local enemy_cqi = caravans:attach_battle_to_dilemma(
													dilemma_name,
													caravan,
													attacking_force,
													is_ambush,
													target_faction,
													enemy_faction,
													target_region,
													custom_option
													);
			
			local target_faction_object = cm:get_faction(target_faction);
			
			--Trigger dilemma to be handled by above function
			local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
			cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
			cargo_bundle:set_duration(0);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
			local own_faction = caravan_handle:caravan_force():faction();
			
			payload_builder:text_display("dummy_convoy_far_from_home_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();

			payload_builder:text_display("dummy_convoy_far_from_home_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
			dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
		end,
		false},

		["quickWayDown"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "quickWayDown".."?";
			local probability = 1;
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_quick_way_down"
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();	

			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
				probability = 0;
			end
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("quickWayDown action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_quick_way_down"	
			local faction_key = caravan_handle:caravan_force():faction():name();		
			--Decode the string into arguments-- Need to specify the argument encoding
			--none to decode
			
			local cargo_amount = caravan_handle:cargo();

			function remove_cargo()
				cm:set_caravan_cargo(caravan_handle, cargo_amount-50)
			end
			
			custom_option = remove_cargo;
			
			caravans:attach_battle_to_dilemma(
				dilemma_name,
				caravan_handle,
				nil,
				false,
				nil,
				nil,
				nil,
				custom_option);
			
			local scout_skill = caravan_handle:caravan_master():character_details():character():bonus_values():scripted_value("caravan_scouting", "value");
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local own_faction = caravan_handle:caravan_force():faction();

			local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
			cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -50);
			cargo_bundle:set_duration(0);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);

			payload_builder:text_display("dummy_convoy_quick_way_down_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();

			payload_builder:text_display("dummy_convoy_quick_way_down_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			dilemma_builder:add_target("default", caravan_handle:caravan_force());

			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
			
		end,
		false},

		["tradingDarkElfs"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local eventname = "tradingDarkElfs".."?";
			local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
			
			local probability = math.floor((20 - army_size)/2);
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_trading_dark_elfs";

			if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
				probability = 0;
			end
			
			return {probability,eventname}
			
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("tradingDarkElfs action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_trading_dark_elfs";
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			local cargo_amount = caravan_handle:cargo();

			function remove_cargo()
				cm:set_caravan_cargo(caravan_handle, cargo_amount-100)
			end
			
			custom_option = remove_cargo;

			caravans:attach_battle_to_dilemma(
						dilemma_name,
						caravan_handle,
						nil,
						false,
						nil,
						nil,
						nil,
						custom_option);
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
			cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -100);
			cargo_bundle:set_duration(0);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);

			local monster_list = {"wh2_dlc10_def_mon_kharibdyss_0","wh2_twa03_def_mon_war_mammoth_0","wh2_main_def_mon_black_dragon"};
			
			payload_builder:add_unit(caravan_handle:caravan_force(), monster_list[cm:random_number(#monster_list,1)], 1, 0);
			payload_builder:text_display("dummy_convoy_trading_dark_elfs_first");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			payload_builder:text_display("dummy_convoy_trading_dark_elfs_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			
		end,
		false},

		["powerOverwhelming"] = 
		--returns its probability [1]
		{function(world_conditions)
			
			local random_unit ="NONE";
			local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
			local event_region = world_conditions["event_region"];
			local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
			
			if caravan_force_unit_list:num_items() > 1 then
				random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,1)):unit_key();
				
				if random_unit == "wh3_dlc23_chd_cha_overseer" or random_unit == "wh3_dlc23_chd_cha_convoy_overseer" then
					random_unit = "NONE";
				end
				out.design("Random unit to be eaten: "..random_unit);
			end;
			
			--Construct targets
			local eventname = "powerOverwhelming".."?"
				..event_region:name().."*"
				..random_unit.."*";

			--Calculate probability
			local probability = 1;
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_power_overwhelming";

			if random_unit == "NONE" then
				probability = 0;
			else
				probability = 1;
				if caravans.events_cooldown[faction_key][dilemma_name] ~= nil and caravans.events_cooldown[faction_key][dilemma_name] > 0 then
					probability = 0;
				end
			end;

			return {probability,eventname}
		end,
		--enacts everything for the event: creates battle, fires dilemma etc. [2]
		function(event_conditions,caravan_handle)
			
			out.design("powerOverwhelming action called")
			local dilemma_name = "wh3_dlc23_dilemma_chd_convoy_power_overwhelming";
			local caravan = caravan_handle;
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			--Decode the string into arguments-- Need to specify the argument encoding
			local decoded_args = caravans:read_out_event_params(event_conditions,3);
			
			local is_ambush = true;
			local target_faction = decoded_args[4];
			local target_region = decoded_args[1];
			local custom_option = nil;
			
			local random_unit = decoded_args[2];
			
			function eat_unit_outcome()
				if random_unit ~= nil then
					local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
					cm:remove_unit_from_character(
					caravan_master_lookup,
					random_unit);

				else
					out("Script error - should have a unit to eat?")
				end
			end
			
			local faction_key = caravan_handle:caravan_force():faction():name();
			
			--Decode the string into arguments-- Need to specify the argument encoding
			--none to decode
			
			caravans:attach_battle_to_dilemma(
						dilemma_name,
						caravan_handle,
						nil,
						false,
						nil,
						nil,
						nil,
						nil);

		
			--Trigger dilemma to be handled by above function
			
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			local power = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_power_overwhelming");
			power:add_effect("wh_main_effect_force_all_campaign_replenishment_rate", "force_to_force_own", 5);
			power:add_effect("wh_main_effect_force_stat_speed", "force_to_force_own", 10);
			power:add_effect("wh_main_effect_force_stat_ap_damage", "force_to_force_own", 10);
			power:add_effect("wh_main_effect_force_stat_leadership_pct", "force_to_force_own", 15);
			power:add_effect("wh_main_effect_force_stat_ward_save", "force_to_force_own", 15);
			power:add_effect("wh_main_effect_force_army_campaign_enable_replenishment_in_foreign_territory", "force_to_force_own", 10);
			power:set_duration(10);
			
			payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), power);
			payload_builder:text_display("dummy_convoy_power_overwhelming_first");
			payload_builder:remove_unit(caravan:caravan_force(), random_unit);
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();

			payload_builder:text_display("dummy_convoy_power_overwhelming_second");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			out.design("Triggering dilemma:"..dilemma_name)
			
			dilemma_builder:add_target("default", caravan_handle:caravan_force());
			caravans.events_cooldown[faction_key][dilemma_name] = caravans.event_max_cooldown;
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
			
		end,
		false},
		
	};

-- Ogre Bandit force B - High (10)
random_army_manager:new_force("ogre_bandit_high_b");
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_maneaters_0", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_ogres_0", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_gnoblars_0", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_gnoblars_1", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_veh_gnoblar_scraplauncher_0", 2);

-- Daemon Army
random_army_manager:new_force("daemon_incursion_convoy");
random_army_manager:add_mandatory_unit("daemon_incursion_convoy", "wh3_main_kho_inf_chaos_warriors_0", 2);
random_army_manager:add_mandatory_unit("daemon_incursion_convoy", "wh3_main_kho_inf_chaos_warriors_2", 2);
random_army_manager:add_mandatory_unit("daemon_incursion_convoy", "wh3_main_kho_cav_gorebeast_chariot", 2);
random_army_manager:add_mandatory_unit("daemon_incursion_convoy", "wh3_main_kho_inf_bloodletters_1", 2);

-- Cathay Army
random_army_manager:new_force("cathay_caravan_army");
random_army_manager:add_mandatory_unit("cathay_caravan_army", "wh3_main_cth_inf_jade_warriors_0", 4);
random_army_manager:add_mandatory_unit("cathay_caravan_army", "wh3_main_cth_inf_jade_warriors_1", 3);
random_army_manager:add_mandatory_unit("cathay_caravan_army", "wh3_main_cth_inf_peasant_archers_0", 3);
random_army_manager:add_mandatory_unit("cathay_caravan_army", "wh3_main_cth_art_grand_cannon_0", 1);

-- Skaven Army
random_army_manager:new_force("skaven_shortcut_army");
random_army_manager:add_mandatory_unit("skaven_shortcut_army", "wh2_main_skv_inf_clanrats_1", 3);
random_army_manager:add_mandatory_unit("skaven_shortcut_army", "wh2_main_skv_inf_skavenslaves_0", 3);
random_army_manager:add_mandatory_unit("skaven_shortcut_army", "wh2_main_skv_inf_night_runners_0", 2);
random_army_manager:add_mandatory_unit("skaven_shortcut_army", "wh2_main_skv_inf_clanrats_0", 3);
random_army_manager:add_mandatory_unit("skaven_shortcut_army", "wh2_dlc12_skv_inf_ratling_gun_0", 1);

-- Dwarf Army
random_army_manager:new_force("dwarf_convoy_army");
random_army_manager:add_mandatory_unit("dwarf_convoy_army", "wh_main_dwf_inf_dwarf_warrior_0", 3);
random_army_manager:add_mandatory_unit("dwarf_convoy_army", "wh_main_dwf_inf_miners_1", 3);
random_army_manager:add_mandatory_unit("dwarf_convoy_army", "wh_main_dwf_inf_quarrellers_0", 3);
random_army_manager:add_mandatory_unit("dwarf_convoy_army", "wh_main_dwf_art_grudge_thrower", 2);

-- Chaos Army
random_army_manager:new_force("hungry_chaos_army");
random_army_manager:add_mandatory_unit("hungry_chaos_army", "wh_main_chs_inf_chaos_warriors_0", 2);
random_army_manager:add_mandatory_unit("hungry_chaos_army", "wh_main_chs_inf_chaos_warriors_1", 2);
random_army_manager:add_mandatory_unit("hungry_chaos_army", "wh_main_chs_mon_giant", 1);
random_army_manager:add_mandatory_unit("hungry_chaos_army", "wh_main_chs_mon_trolls", 1);
random_army_manager:add_mandatory_unit("hungry_chaos_army", "wh_main_chs_mon_chaos_spawn", 1);
random_army_manager:add_mandatory_unit("hungry_chaos_army", "wh_main_chs_mon_chaos_warhounds_0", 2);

-- High Elf Army
random_army_manager:new_force("high_elf_army");
random_army_manager:add_mandatory_unit("high_elf_army", "wh2_main_hef_inf_spearmen_0", 3);
random_army_manager:add_mandatory_unit("high_elf_army", "wh2_main_hef_inf_lothern_sea_guard_0", 3);
random_army_manager:add_mandatory_unit("high_elf_army", "wh2_main_hef_inf_archers_1", 2);
random_army_manager:add_mandatory_unit("high_elf_army", "wh2_dlc15_hef_mon_war_lions_of_chrace_0", 2);

-- Vampire Count Army
random_army_manager:new_force("vampire_count_army");
random_army_manager:add_mandatory_unit("vampire_count_army", "wh_main_vmp_inf_zombie", 6);
random_army_manager:add_mandatory_unit("vampire_count_army", "wh2_dlc09_tmb_mon_dire_wolves", 2);
random_army_manager:add_mandatory_unit("vampire_count_army", "wh2_dlc09_tmb_mon_fell_bats", 2);
random_army_manager:add_mandatory_unit("vampire_count_army", "wh_main_vmp_mon_crypt_horrors", 2);
random_army_manager:add_mandatory_unit("vampire_count_army", "wh_main_vmp_inf_skeleton_warriors_0", 4);

-- Tomb King Army
random_army_manager:new_force("tomb_kings_army");
random_army_manager:add_mandatory_unit("tomb_kings_army", "wh2_dlc09_tmb_inf_skeleton_spearmen_0", 4);
random_army_manager:add_mandatory_unit("tomb_kings_army", "wh2_dlc09_tmb_inf_skeleton_archers_0", 4);
random_army_manager:add_mandatory_unit("tomb_kings_army", "wh2_dlc09_tmb_inf_nehekhara_warriors_0", 2);
random_army_manager:add_mandatory_unit("tomb_kings_army", "wh2_dlc09_tmb_art_screaming_skull_catapult_0", 1);
random_army_manager:add_mandatory_unit("tomb_kings_army", "wh2_dlc09_tmb_mon_ushabti_0", 1);

-- Ogre Bandit force B - High (10) - Turn 50+
random_army_manager:new_force("ogre_bandit_high_b_late");
random_army_manager:add_mandatory_unit("ogre_bandit_high_b_late", "wh3_main_ogr_inf_maneaters_0", 3);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b_late", "wh3_main_ogr_inf_ogres_0", 3);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b_late", "wh3_main_ogr_mon_stonehorn_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b_late", "wh3_main_ogr_mon_gorgers_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b_late", "wh3_main_ogr_veh_ironblaster_0", 2);

-- Daemon Army - Turn 50+
random_army_manager:new_force("daemon_incursion_convoy_late");
random_army_manager:add_mandatory_unit("daemon_incursion_convoy_late", "wh3_dlc20_chs_inf_chosen_mkho", 3);
random_army_manager:add_mandatory_unit("daemon_incursion_convoy_late", "wh3_dlc20_chs_inf_chosen_mkho_dualweapons", 2);
random_army_manager:add_mandatory_unit("daemon_incursion_convoy_late", "wh3_main_kho_cav_skullcrushers_0", 2);
random_army_manager:add_mandatory_unit("daemon_incursion_convoy_late", "wh3_main_kho_mon_bloodthirster_0", 1);
random_army_manager:add_mandatory_unit("daemon_incursion_convoy_late", "wh3_main_kho_mon_soul_grinder_0", 1);

-- Cathay Army - Turn 50+
random_army_manager:new_force("cathay_caravan_army_late");
random_army_manager:add_mandatory_unit("cathay_caravan_army_late", "wh3_main_cth_inf_dragon_guard_0", 4);
random_army_manager:add_mandatory_unit("cathay_caravan_army_late", "wh3_main_cth_inf_dragon_guard_crossbowmen_0", 3);
random_army_manager:add_mandatory_unit("cathay_caravan_army_late", "wh3_main_cth_mon_terracotta_sentinel_0", 1);
random_army_manager:add_mandatory_unit("cathay_caravan_army_late", "wh3_main_cth_art_fire_rain_rocket_battery_0", 1);

-- Skaven Army - Turn 50+
random_army_manager:new_force("skaven_shortcut_army_late");
random_army_manager:add_mandatory_unit("skaven_shortcut_army_late", "wh2_main_skv_inf_stormvermin_1", 3);
random_army_manager:add_mandatory_unit("skaven_shortcut_army_late", "wh2_main_skv_inf_death_runners_0", 3);
random_army_manager:add_mandatory_unit("skaven_shortcut_army_late", "wh2_main_skv_inf_death_globe_bombardiers", 3);
random_army_manager:add_mandatory_unit("skaven_shortcut_army_late", "wh2_main_skv_mon_rat_ogres", 1);
random_army_manager:add_mandatory_unit("skaven_shortcut_army_late", "wh2_main_skv_mon_hell_pit_abomination", 1);

-- Dwarf Army - Turn 50+
random_army_manager:new_force("dwarf_convoy_army_late");
random_army_manager:add_mandatory_unit("dwarf_convoy_army_late", "wh_main_dwf_inf_longbeards", 3);
random_army_manager:add_mandatory_unit("dwarf_convoy_army_late", "wh_main_dwf_inf_ironbreakers", 3);
random_army_manager:add_mandatory_unit("dwarf_convoy_army_late", "wh_main_dwf_inf_irondrakes_0", 2);
random_army_manager:add_mandatory_unit("dwarf_convoy_army_late", "wh_main_dwf_art_organ_gun", 1);
random_army_manager:add_mandatory_unit("dwarf_convoy_army_late", "wh_main_dwf_veh_gyrocopter_1", 1);

-- Chaos Army -Turn 50+
random_army_manager:new_force("hungry_chaos_army_late");
random_army_manager:add_mandatory_unit("hungry_chaos_army_late", "wh_dlc01_chs_inf_chosen_2", 2);
random_army_manager:add_mandatory_unit("hungry_chaos_army_late", "wh_main_chs_inf_chosen_1", 2);
random_army_manager:add_mandatory_unit("hungry_chaos_army_late", "wh_dlc01_chs_mon_dragon_ogre", 2);
random_army_manager:add_mandatory_unit("hungry_chaos_army_late", "wh_main_chs_cav_chaos_knights_1", 2);
random_army_manager:add_mandatory_unit("hungry_chaos_army_late", "wh_main_chs_art_hellcannon", 2);

-- High Elf Army - Turn 50+
random_army_manager:new_force("high_elf_army_late");
random_army_manager:add_mandatory_unit("high_elf_army_late", "wh2_main_hef_inf_phoenix_guard", 3);
random_army_manager:add_mandatory_unit("high_elf_army_late", "wh2_main_hef_inf_swordmasters_of_hoeth_0", 3);
random_army_manager:add_mandatory_unit("high_elf_army_late", "wh2_dlc10_hef_inf_sisters_of_avelorn_0", 2);
random_army_manager:add_mandatory_unit("high_elf_army_late", "wh2_main_hef_mon_sun_dragon", 1);
random_army_manager:add_mandatory_unit("high_elf_army_late", "wh2_main_hef_mon_phoenix_frostheart", 1);

-- Vampire Count Army - Turn 50+
random_army_manager:new_force("vampire_count_army_late");
random_army_manager:add_mandatory_unit("vampire_count_army_late", "wh_main_vmp_inf_crypt_ghouls", 4);
random_army_manager:add_mandatory_unit("vampire_count_army_late", "wh_main_vmp_inf_grave_guard_0", 2);
random_army_manager:add_mandatory_unit("vampire_count_army_late", "wh_main_vmp_cav_black_knights_0", 2);
random_army_manager:add_mandatory_unit("vampire_count_army_late", "wh_main_vmp_mon_vargheists", 2);
random_army_manager:add_mandatory_unit("vampire_count_army_late", "wh_main_vmp_mon_terrorgheist", 1);

-- Tomb King Army - Turn 50+
random_army_manager:new_force("tomb_kings_army_late");
random_army_manager:add_mandatory_unit("tomb_kings_army_late", "wh2_dlc09_tmb_inf_tomb_guard_0", 4);
random_army_manager:add_mandatory_unit("tomb_kings_army_late", "wh2_dlc09_tmb_mon_ushabti_1", 2);
random_army_manager:add_mandatory_unit("tomb_kings_army_late", "wh2_dlc09_tmb_veh_skeleton_chariot_0", 2);
random_army_manager:add_mandatory_unit("tomb_kings_army_late", "wh2_dlc09_tmb_mon_tomb_scorpion_0", 1);
random_army_manager:add_mandatory_unit("tomb_kings_army_late", "wh2_dlc09_tmb_mon_khemrian_warsphinx_0", 1);