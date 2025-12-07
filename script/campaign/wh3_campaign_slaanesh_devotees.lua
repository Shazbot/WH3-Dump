local public_order_to_reduce_by = 50;

local config = {
	scripted_bonus_values = {
		block_replenishment = {
			sbv = "foreign_slot_block_settlement_garrison_replenish_nkari",
			effect_bundle = "wh3_dlc27_bundle_no_replenishment_force",
		}
	}
}

function setup_slaanesh_devotees()
	common.set_context_value("public_order_to_reduce_by", public_order_to_reduce_by);
	
	-- restore the value if we're loading a save file
	local local_faction = cm:get_local_faction_name(true);
	
	if local_faction and local_faction ~= "wh3_dlc27_sla_the_tormentors" and cm:get_faction(local_faction):culture() == "wh3_main_sla_slaanesh" then
		local saved_devotees_to_add = cm:get_saved_value("devotees_to_add");
		
		if saved_devotees_to_add and saved_devotees_to_add > 0 then
			common.set_context_value("devotees_value_" .. local_faction, saved_devotees_to_add);
		end;
	end;
	
	-- calculate the amount of devotees to award after capturing a settlement
	core:add_listener(
		"slaanesh_character_attacks_settlement",
		"PendingBattle",
		function(context)
			local pb = context:pending_battle();
			
			return pb:siege_battle() and pb:has_attacker() and pb:attacker():faction():culture() == "wh3_main_sla_slaanesh" and pb:attacker():faction():name() ~= "wh3_dlc27_sla_the_tormentors";
		end,
		function(context)
			local pb = context:pending_battle();
			local attacker = pb:attacker();
			local attacker_faction = attacker:faction();
			local region = pb:region_data():region();
			local po = region:public_order() * 0.2
			local gdp = region:gdp() * 0.01
			
			local devotees_to_add = 50 + po + gdp;
			
			cm:set_saved_value("devotees_to_add", devotees_to_add);
			
			if attacker_faction:is_human() then
				common.set_context_value("devotees_value_" .. attacker:faction():name(), devotees_to_add);
			end;
		end,
		true
	);
	
	local function award_devotees_after_capture(context, settlement_sacked)
		local devotees_to_add = cm:get_saved_value("devotees_to_add");
		local faction = context:character():faction();
		local faction_name = faction:name();
		
		if devotees_to_add and devotees_to_add > 0 then
			local factor = "settlements_looted";
			
			if settlement_sacked then
				factor = "settlements_sacked";
			end;
			
			cm:faction_add_pooled_resource(faction_name, "wh3_main_sla_devotees", factor, devotees_to_add);
		end;
		
		-- reset the value for the next battle
		cm:set_saved_value("devotees_to_add", 0);
		
		if faction:is_human() then
			common.set_context_value("devotees_value_" .. faction_name, 0);
		end;
	end;
	
	-- apply the devotees after looting a settlement
	core:add_listener(
		"slaanesh_character_loots_settlement",
		"CharacterLootedSettlement",
		function(context)
			local character_faction = context:character():faction()

			return character_faction:culture() == "wh3_main_sla_slaanesh" and character_faction:name() ~= "wh3_dlc27_sla_the_tormentors"
		end,
		function(context)
			award_devotees_after_capture(context, false);
		end,
		true
	);
	
	-- apply the devotees after sacking a settlement
	core:add_listener(
		"slaanesh_character_loots_settlement",
		"CharacterSackedSettlement",
		function(context)
			local character_faction = context:character():faction()

			return character_faction:culture() == "wh3_main_sla_slaanesh" and character_faction:name() ~= "wh3_dlc27_sla_the_tormentors"
		end,
		function(context)
			award_devotees_after_capture(context, true);
		end,
		true
	);
	
	-- set public order after ritual is performed
	core:add_listener(
		"slaanesh_province_ritual_performed",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == "wh3_main_ritual_sla_pleasure_arena";
		end,
		function(context)
			local region = context:ritual():ritual_target():get_target_region();
			local public_order = region:public_order()
			local new_value = public_order + (0 - public_order_to_reduce_by);
			
			cm:set_public_order_of_province_for_region(region:name(), new_value);
		end,
		true
	);
	
	-- create cults after ritual is performed
	core:add_listener(
		"slaanesh_create_cults_ritual_performed",
		"RitualCompletedEvent",
		function(context)
			local faction = context:performing_faction();
			return context:ritual():ritual_key() == "wh3_main_ritual_sla_create_cults" or context:ritual():ritual_key() == "wh3_dlc27_ritual_sla_create_cults_dechala";
		end,
		function(context)
			local faction = context:performing_faction();
			local valid_region_list = {};
			local cultures_to_check = {
				"wh3_main_ksl_kislev",
				"wh3_main_cth_cathay",
				"wh_main_emp_empire",
				"wh_main_brt_bretonnia",
				"wh_dlc08_nor_norsca",
				"wh2_main_def_dark_elves",
				"wh2_main_hef_high_elves",
				"wh_dlc05_wef_wood_elves"
			};
			
			local region_list = cm:model():world():region_manager():region_list();
			
			for i = 0, region_list:num_items() - 1 do
				local current_region = region_list:item_at(i);
				
				if current_region:foreign_slot_managers():is_empty() then
					for j = 1, #cultures_to_check do
						if current_region:owning_faction():culture() == cultures_to_check[j] then
							table.insert(valid_region_list, current_region:cqi());
							break;
						end;
					end;
				end;
			end;
			
			valid_region_list = cm:random_sort(valid_region_list);

			for i = 1, math.min(3, #valid_region_list) do
				local faction_cqi = faction:command_queue_index();

				local fs = false
				if context:ritual():ritual_key() == "wh3_dlc27_ritual_sla_create_cults_dechala" then
					fs = cm:add_foreign_slot_set_to_region_for_faction(faction_cqi, valid_region_list[i], "wh3_dlc27_slot_set_sla_cult_dechala");
				else
					fs = cm:add_foreign_slot_set_to_region_for_faction(faction_cqi, valid_region_list[i], "wh3_main_slot_set_sla_cult");
				end
				local region = fs:region();

				cm:trigger_incident_with_targets(faction_cqi, "wh3_main_incident_cult_created", 0, 0, 0, 0, region:cqi(), region:settlement():cqi());
			end;
		end,
		true
	);
	
	-- disciple armies spawn
	core:add_listener(
		"slaanesh_disciple_army_spawned",
		"MilitaryForceCreated",
		function(context)
			return context:military_force_created():general_character():character_subtype("wh3_main_sla_herald_of_slaanesh_slaanesh_disciple_army");
		end,
		function(context)
			local cqi = context:military_force_created():general_character():command_queue_index();
			
			cm:apply_effect_bundle_to_characters_force("wh3_main_bundle_sla_disciple_army", cqi, 0);
			cm:replenish_action_points(cm:char_lookup_str(cqi), 1);
		end,
		true
	);
	
	-- calculate the amount of devotees to provide when raiding
	local function calculate_slaanesh_raiding_devotees(mf)
		local value = 0;
		
		if mf:has_general() then
			local general = mf:general_character();
			local units = 0.05 * mf:unit_list():num_items();			
			
			if general:has_region() then
				local region = general:region();
				local gdp = 0.01 * region:gdp();
				local po = 0.2 * region:public_order()
				
				value = (5 + gdp + po) * units ;
			end;
		end;
		
		if mf:faction():is_human() and (value > 0 or common.get_context_value("ScriptObjectContext(\"raiding_devotees_value_" .. mf:command_queue_index() .. "\").NumericValue") > 0) then
			common.set_context_value("raiding_devotees_value_" .. mf:command_queue_index(), value);
		end;
		
		return value;
	end;
	
	-- set the amount of devotees to provide when raiding for ui display
	local human_factions = cm:get_human_factions();
	
	for i = 1, #human_factions do
		local current_human_faction = cm:get_faction(human_factions[i]);
		
		if current_human_faction:culture() == "wh3_main_sla_slaanesh" and current_human_faction:name() ~= "wh3_dlc27_sla_the_tormentors" then
			local mf_list = current_human_faction:military_force_list();
			
			for j = 0, mf_list:num_items() - 1 do
				local current_mf = mf_list:item_at(j);
				
				if current_mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" then
					calculate_slaanesh_raiding_devotees(current_mf);
				end;
			end;
		end;
	end;
	
	-- set the amonut of devotees to provide when raiding for ui display when an army enters the raiding stance
	core:add_listener(
		"slaanesh_raiding_calculate_devotees",
		"ForceAdoptsStance",
		function(context)
			local faction = context:military_force():faction();
			
			return faction:is_human() and faction:culture() == "wh3_main_sla_slaanesh" and faction:name() ~= "wh3_dlc27_sla_the_tormentors";
		end,
		function(context)
			local mf = context:military_force();
			
			if context:stance_adopted() == 3 then
				calculate_slaanesh_raiding_devotees(mf);
			else
				common.set_context_value("raiding_devotees_value_" .. mf:command_queue_index(), 0);
			end;
		end,
		true
	);
	
	-- update the amount of devotees if the character moves in raiding stance
	core:add_listener(
		"slaanesh_raiding_calculate_devotees_post_movement",
		"CharacterFinishedMovingEvent",
		function(context)
			local character = context:character();
			local faction = character:faction();
			
			return faction:is_human() and faction:culture() == "wh3_main_sla_slaanesh" and faction:name() ~= "wh3_dlc27_sla_the_tormentors" and cm:char_is_general_with_army(character) and character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID";
		end,
		function(context)
			calculate_slaanesh_raiding_devotees(context:character():military_force());
		end,
		true
	);
	
	-- add the devotees for armies raiding
	core:add_listener(
		"slaanesh_raiding_add_devotees",
		"FactionTurnStart",
		function(context)
			local faction = context:faction();
			return faction:culture() == "wh3_main_sla_slaanesh" and faction:name() ~= "wh3_dlc27_sla_the_tormentors";
		end,
		function(context)
			local faction = context:faction();
			local mf_list = faction:military_force_list();
			
			for i = 0, mf_list:num_items() - 1 do
				local current_mf = mf_list:item_at(i);
				
				if current_mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" then
					local devotees_to_add = calculate_slaanesh_raiding_devotees(current_mf);
					
					if devotees_to_add > 0 then
						cm:faction_add_pooled_resource(faction:name(), "wh3_main_sla_devotees", "raiding", devotees_to_add);
					end;
				end;
			end;
		end,
		true
	);

	-- create cult on ritual trigger
	core:add_listener(
		"create_cult_in_settlement",
		"RitualStartedEvent",
		function(context)
			local ritual_key = context:ritual():ritual_key()
			local ritual_list = {
				"wh3_main_ritual_sla_gg_2",
				"wh3_main_ritual_sla_gg_2_upgraded"
			}
			
			if table.contains(ritual_list, ritual_key) then
				return true 
			end

			return false
		end,
		function(context)
			local faction = context:performing_faction()
			local faction_cqi = faction:command_queue_index();
			local target_region = context:ritual_target_region()

			cm:trigger_incident_with_targets(faction_cqi, "wh3_main_incident_cult_created", 0, 0, 0, 0, target_region:cqi(), target_region:settlement():cqi());

		end,
		true
	);


	-- Cult building effect - block garrison replenishment - N'Kari only
	core:add_listener(
		"block_garrison_replenish",
		"FactionTurnStart",
		function(context)
			local fsm = context:faction():foreign_slot_managers()
			return not fsm:is_empty() and context:faction():name() == "wh3_main_sla_seducers_of_slaanesh"
		end,
		function(context)
			local faction = context:faction()
			local fsm = faction:foreign_slot_managers()

			for i = 0, fsm:num_items() - 1 do
				local slot_region = fsm:item_at(i):region()
				local region_value = cm:get_regions_bonus_value(slot_region, config.scripted_bonus_values.block_replenishment.sbv)

				if region_value > 0 then
					local garrison_residence_interface = slot_region:garrison_residence()
					if garrison_residence_interface and garrison_residence_interface:is_null_interface() == false then
						local garrison_mf = cm:get_armed_citizenry_from_garrison(garrison_residence_interface)
						local effect_bundle = config.scripted_bonus_values.block_replenishment.effect_bundle

						if garrison_mf and garrison_mf:is_null_interface() == false and not garrison_mf:has_effect_bundle(effect_bundle) then
							local garrison_mf_cqi = garrison_mf:command_queue_index()
							cm:apply_effect_bundle_to_force(effect_bundle, garrison_mf_cqi, 0)
						end
					end
				end
			end
		end,
		true
	);

	local function remove_block_garrison_replenish_on_loss(region)
		local block_replenish_scripted_value = cm:get_regions_bonus_value(region, config.scripted_bonus_values.block_replenishment.sbv)

		if block_replenish_scripted_value <= 0 then
			local garrison_residence_interface = region:garrison_residence()
			if garrison_residence_interface and garrison_residence_interface:is_null_interface() == false then
				local garrison_mf = cm:get_armed_citizenry_from_garrison(garrison_residence_interface)
				local effect_bundle = config.scripted_bonus_values.block_replenishment.effect_bundle

				if garrison_mf and garrison_mf:is_null_interface() == false and garrison_mf:has_effect_bundle(effect_bundle) then
					local garrison_mf_cqi = garrison_mf:command_queue_index()
					cm:remove_effect_bundle_from_force(effect_bundle, garrison_mf_cqi)
				end
			end
		end
	end

	core:add_listener(
		"remove_block_garrison_replenish_building_loss",
		"ForeignSlotBuildingDismantledEvent",
		function(context)
			return context:slot_manager():faction():name() == "wh3_main_sla_seducers_of_slaanesh"
		end,
		function(context)
			local region = context:slot_manager():region()
			remove_block_garrison_replenish_on_loss(region)
		end,
		true
	);

	core:add_listener(
		"remove_block_garrison_replenish_fsm_loss",
		"ForeignSlotManagerRemovedEvent",
		function(context)
			return context:owner():name() == "wh3_main_sla_seducers_of_slaanesh"
		end,
		function(context)
			local region = context:region()
			remove_block_garrison_replenish_on_loss(region)
		end,
		true
	);
	
end