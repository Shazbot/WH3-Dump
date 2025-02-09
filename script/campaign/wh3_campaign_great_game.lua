local belakor_faction_key = "wh3_main_chs_shadow_legion";

function chaos_get_culture_prefix(culture)
	if culture == "wh3_main_cth_cathay" then
		return "cth";
	elseif culture == "wh3_main_dae_daemons" then
		return "dae";
	elseif culture == "wh3_main_kho_khorne" then
		return "kho";
	elseif culture == "wh3_main_ksl_kislev" then
		return "ksl";
	elseif culture == "wh3_main_nur_nurgle" then
		return "nur";
	elseif culture == "wh3_main_ogr_ogre_kingdoms" then
		return "ogr";
	elseif culture == "wh3_main_sla_slaanesh" then
		return "sla";
	elseif culture == "wh3_main_tze_tzeentch" then
		return "tze";
	elseif culture == "wh_main_chs_chaos" then
		return "chs";
	else
		return "";
	end;
end;

function great_game_start()
	if cm:is_new_game() then
		update_available_rituals("1");
		
		if cm:get_campaign_name() == "main_warhammer" then
			-- belakor starts with a rift open
			cm:teleportation_network_open_node("wh3_main_combi_province_albion");
			cm:teleportation_network_open_node("wh3_main_combi_province_the_southern_wastes");
			cm:teleportation_network_open_node("wh3_main_combi_province_gryphon_wood");
		end;
	end;
	
	common.set_context_value("great_game_ascendant_god", cm:get_saved_value("great_game_ascendant_god") or "none");
	
	core:add_listener(
		"great_game_corruption_tracker",
		"CorruptionCounterIntervalEvent",
		true,
		function(context)
			local interval_string = context:interval();
			out.design("Update Great Game rituals: "..tostring(interval_string));
			
			update_available_rituals(interval_string, context:counter());
		end,
		true
	);
	
	core:add_listener(
		"great_game_event",
		"WorldStartRound",
		function()
			-- trigger every 10 rounds
			return cm:model():turn_number() % 10 == 0;
		end,
		function()
			-- select a god to be ascendant
			local gods = {
				"wh3_main_kho_khorne",
				"wh3_main_nur_nurgle",
				"wh3_main_sla_slaanesh",
				"wh3_main_tze_tzeentch"
			};
			
			-- exclude the current ascendant god, if one exists
			local available_gods = {};
			
			local current_ascended_god = cm:get_saved_value("great_game_ascendant_god") or "";
			
			-- weigh the roll, work out who has the most stuff
			local god_with_most_settlements = false;
			local god_with_most_armies = false;
			local god_with_most_money = false;
			
			local most_settlements = 0;
			local most_armies = 0;
			local most_money = 0;
			
			local faction_list = cm:model():world():faction_list();
			
			for i = 1, #gods do
				if current_ascended_god ~= gods[i] then
					table.insert(available_gods, gods[i]);
			
					local settlement_count = 0;
					local army_count = 0;
					local money_count = 0;
					
					for j = 0, faction_list:num_items() - 1 do
						local current_faction = faction_list:item_at(j);
						
						if current_faction:culture() == gods[i] and not current_faction:is_dead() then
							settlement_count = settlement_count + current_faction:region_list():num_items();
							army_count = army_count + current_faction:military_force_list():num_items();
							money_count = money_count + current_faction:treasury();
						end;
					end;
					
					if settlement_count > most_settlements then
						most_settlements = settlement_count;
						god_with_most_settlements = gods[i];
					end;
					
					if army_count > most_armies then
						most_armies = army_count;
						god_with_most_armies = gods[i];
					end;
					
					if money_count > most_money then
						most_money = money_count;
						god_with_most_money = gods[i];
					end;
				end;
			end;
			
			if god_with_most_settlements then
				table.insert(available_gods, god_with_most_settlements);
			end;
			
			if god_with_most_armies then
				table.insert(available_gods, god_with_most_armies);
			end;

			if god_with_most_money then
				table.insert(available_gods, god_with_most_money);
			end;
			
			local chosen_god = available_gods[cm:random_number(#available_gods)];
			
			-- set the script states - this is used to display the upgraded rituals to the player
			common.set_context_value("great_game_ascendant_god", chosen_god);
			cm:set_saved_value("great_game_ascendant_god", chosen_god);
			
			local human_factions = cm:get_human_factions();
			
			for i = 1, #human_factions do
				local current_human_faction = cm:get_faction(human_factions[i]);
				
				if faction_has_great_game_rituals(current_human_faction) then
					-- if the player's faction matches the chosen god, we show a green effect bundle, otherwise it's red
					local effect_bundle_suffix = "_bad";
					
					if current_human_faction:culture():find(chosen_god) then
						effect_bundle_suffix = "_good";
					end;
					
					cm:trigger_custom_incident(human_factions[i], "wh3_main_incident_great_game_ascend_" .. chosen_god, true, "payload{effect_bundle {bundle_key wh3_main_bundle_great_game_ascend_" .. chosen_god .. effect_bundle_suffix .. "_dummy;turns 10;}}");
				end;
			end;
			
			-- apply the effect bundle to all factions
			for i = 0, faction_list:num_items() - 1 do
				local current_faction = faction_list:item_at(i);
				
				if not current_faction:is_dead() and faction_has_great_game_rituals(current_faction) then
					local current_faction_name = current_faction:name();
					
					-- add the effect bundles for factions that belong to the ascendant god
					local does_faction_belong_to_ascendant_god = current_faction:culture() == chosen_god;
					
					if does_faction_belong_to_ascendant_god then
						if current_faction:has_effect_bundle("wh3_main_bundle_great_game_ascend_" .. chosen_god) then
							cm:remove_effect_bundle("wh3_main_bundle_great_game_ascend_" .. chosen_god, current_faction_name);
						end;
						
						cm:apply_effect_bundle("wh3_main_bundle_great_game_ascend_" .. chosen_god, current_faction_name, 11); -- 11 turns as one turn will be ticked down immediately for... reasons...
					end;
					
					-- unlock the upgraded rituals - this is done for every faction to disable any upgraded rituals that might be enabled
					local interval_string = false;
					local is_belakor = current_faction_name == belakor_faction_key
					
					if not is_belakor then
						local corruption_first_active_interval = common.get_context_value("CampaignRoot.FactionList.FirstContext(FactionRecordContext.Key==\"" .. current_faction_name .. "\").CorruptionCounterContext.ActiveIntervalList.FirstContext.Key");
						if corruption_first_active_interval then
							interval_string = tonumber(string.sub(corruption_first_active_interval, -1));
						end;
					end;
					
					if interval_string or is_belakor then
						unlock_gg_rituals(interval_string, current_faction, does_faction_belong_to_ascendant_god);
					end;
				end;
			end;
			
			-- Trigger event with the chosen god as context.
			core:trigger_event("ScriptEventNewGodAscendant", chosen_god)
		end,
		true
	);
	
	core:add_listener(
		"great_game_vfx_application",
		"RitualStartedEvent",
		function(context)
			return string.find(context:ritual():ritual_category(), "GREAT_GAME");
		end,
		function(context)
			local target = context:ritual():ritual_target();
			
			if target:target_type() == "MILITARY_FORCE" then
				local cqi = target:get_target_force():general_character():command_queue_index();
				
				out.design("Attempt to apply Great Game VFX to CQI: "..cqi);
				cm:add_character_vfx(cqi, "scripted_effect", false);
			end;
		end,
		true
	);
	
	if cm:get_saved_value("khorne_ritual_battle_active") then
		khorne_ritual_battle_cleanup();
	end;
	
	core:add_listener(
		"great_game_ritual_completed",
		"RitualCompletedEvent",
		function(context)
			return string.find(context:ritual():ritual_category(), "GREAT_GAME");
		end,
		function(context)
			local ritual = context:ritual();
			local ritual_key = ritual:ritual_key();
			if string.find(ritual_key, "wh3_main_ritual_kho_gg_1") then
				local target_force = ritual:ritual_target():get_target_force();
				
				cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
				cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
				
				cm:set_saved_value("khorne_ritual_battle_active", target_force:command_queue_index());
				generate_khorne_ritual_battle_force(target_force:general_character());
				khorne_ritual_battle_cleanup();
			elseif ritual_key == "wh3_main_ritual_nur_gg_4" then
				cm:heal_military_force(ritual:ritual_target():get_target_force())	
			elseif ritual_key == "wh3_main_ritual_nur_gg_4_upgraded" then
				heal_forces_in_province(ritual:ritual_target():get_target_region())
			elseif ritual_key == "wh3_main_ritual_belakor_gg_3" then
				local target_force = ritual:ritual_target():get_target_force();
				
				if not target_force:is_null_interface() and target_force:has_general() then
					cm:remove_effect_bundle_from_force("wh3_main_ritual_belakor_gg_3", target_force:command_queue_index());
				end;
			elseif ritual_key:starts_with("wh3_main_ritual_belakor_gg_4") then
				local target_force = ritual:ritual_target():get_target_force();
				
				if not target_force:is_null_interface() and target_force:has_general() then
					cm:remove_effect_bundle_from_force("wh3_main_ritual_belakor_gg_4", target_force:command_queue_index());
					
					local general = target_force:general_character();
					
					if general:has_region() then
						cm:teleportation_network_open_node(general:region():province():key());
					end;
				end;
			end;
		end,
		true
	);
	
	-- cut camera to character that's come out of the rift
	core:add_listener(
		"character_uses_belakor_rift",
		"TeleportationNetworkMoveCompleted",
		function(context)
			local character = context:character():character();
			if not character:is_null_interface() and context:success() and context:from_record():network_key() == "wh3_main_teleportation_network_belakor" then
				local faction = character:faction();
				
				return faction:is_human() and cm:get_local_faction_name(true) == faction:name();
			end;
		end,
		function(context)
			local cached_x, cached_y, cached_d, cached_b, cached_h = cm:get_camera_position();
			local character = context:character():character();
			
			cm:scroll_camera_from_current(true, 1, {character:display_position_x(), character:display_position_y(), 13, cached_b, 10});
		end,
		true
	);
	
	core:add_listener(
		"increase_belakor_ritual_uses",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_faction_won_battle(belakor_faction_key);
		end,
		function()
			local resource = false;
			
			if cm:pending_battle_cache_faction_won_battle_against_culture(belakor_faction_key, "wh3_main_kho_khorne") then
				resource = "wh3_main_ritual_belakor_gg_1_uses";
			elseif cm:pending_battle_cache_faction_won_battle_against_culture(belakor_faction_key, "wh3_main_nur_nurgle") then
				resource = "wh3_main_ritual_belakor_gg_2_uses";
			elseif cm:pending_battle_cache_faction_won_battle_against_culture(belakor_faction_key, "wh3_main_sla_slaanesh") then
				resource = "wh3_main_ritual_belakor_gg_3_uses";
			elseif cm:pending_battle_cache_faction_won_battle_against_culture(belakor_faction_key, "wh3_main_tze_tzeentch") then
				resource = "wh3_main_ritual_belakor_gg_4_uses";
			end;
			
			if resource then
				cm:faction_add_pooled_resource(belakor_faction_key, resource, "other", 1);
			end;
		end,
		true
	);
end;

function generate_khorne_ritual_battle_force(character, upgraded)
	local faction = character:faction();
	local faction_name = faction:name();
	
	local units = "wh3_main_kho_inf_bloodletters_0,wh3_main_kho_inf_bloodletters_0,wh3_main_kho_inf_bloodletters_0";
	
	if upgraded then
		units = "wh3_main_kho_inf_bloodletters_0,wh3_main_kho_inf_bloodletters_0,wh3_main_kho_inf_bloodletters_0,wh3_main_kho_inf_chaos_warriors_0,wh3_main_kho_mon_spawn_of_khorne_0,wh3_main_kho_inf_flesh_hounds_of_khorne_0,wh3_main_kho_veh_skullcannon_0";
	end;
	
	local old_invasion = invasion_manager:get_invasion("khorne_ritual_battle_invasion");
	
	if old_invasion then
		cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
		cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
		old_invasion:kill();
		cm:callback(
			function()
				cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
				cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
			end,
			0.2
		);
	end;
	
	local invasion_1 = invasion_manager:new_invasion("khorne_ritual_battle_invasion", "wh3_main_kho_khorne_qb1", units, {character:logical_position_x(), character:logical_position_y()});
	invasion_1:set_target("CHARACTER", character:command_queue_index(), faction_name);
	invasion_1:create_general(false, "wh3_main_kho_herald_of_khorne");
	invasion_1:apply_effect("wh3_dlc26_bundle_military_upkeep_free_force_kho_gg", -1);
	invasion_1:start_invasion(
		function(self)
			core:add_listener(
				"khorne_ritual_battle_war_declared",
				"FactionLeaderDeclaresWar",
				function(context)
					return context:character():faction():name() == "wh3_main_kho_khorne_qb1";
				end,
				function()
					cm:force_attack_of_opportunity(self:get_general():military_force():command_queue_index(), character:military_force():command_queue_index(), false);
				end,
				false
			);
			
			cm:force_declare_war("wh3_main_kho_khorne_qb1", faction_name, false, false);
		end,
		false,
		false,
		false
	);
	
	core:add_listener(
		"khorne_ritual_battle_end_of_round_cleanup",
		"EndOfRound", 
		true,
		function()
			kill_khorne_ritual_battle_invasion();
			cm:set_saved_value("khorne_ritual_battle_active", false);
		end,
		false
	);
end;

function khorne_ritual_battle_cleanup()
	core:add_listener(
		"khorne_ritual_battle_cleanup",
		"BattleCompleted",
		function()
			return cm:get_saved_value("khorne_ritual_battle_active");
		end,
		function()
			local target_force_cqi = cm:get_saved_value("khorne_ritual_battle_active");
			local mf = cm:get_military_force_by_cqi(target_force_cqi)

			if mf then
				if mf:has_effect_bundle("wh3_main_ritual_kho_gg_1") then
					cm:remove_effect_bundle_from_force("wh3_main_ritual_kho_gg_1", target_force_cqi);
				end

				if mf:has_effect_bundle("wh3_main_ritual_kho_gg_1_upgraded") then
					cm:remove_effect_bundle_from_force("wh3_main_ritual_kho_gg_1_upgraded", target_force_cqi);
				end
			end

			cm:set_saved_value("khorne_ritual_battle_active", false);
			
			kill_khorne_ritual_battle_invasion();
			
			--uim:override("retreat"):unlock();
			
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

function kill_khorne_ritual_battle_invasion()
	local im = invasion_manager;
	local invasion = im:get_invasion("khorne_ritual_battle_invasion");
	
	if invasion then
		cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
		cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
		invasion:kill();
		cm:callback(
			function()
				cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
				cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
			end,
			0.2
		);
	end;
end;


function heal_forces_in_province(region)
	local target_province_regions = region:province():regions()
	for j=0, target_province_regions:num_items() -1 do 
		local regions = target_province_regions:item_at(j)
		local region_chars = regions:characters_in_region()
			for z=0, region_chars:num_items() -1 do 
				local character = region_chars:item_at(z)
				if character:has_military_force() and character:has_region() and character:faction():subculture() == "wh3_main_sc_nur_nurgle" then
						cm:heal_military_force(character:military_force())
				end
			end	
	end
end


function update_available_rituals(interval_string, counter)
	local gg_level = tonumber(string.sub(interval_string, -1));
	
	if not gg_level then
		script_error("ERROR: update_available_rituals() has read an interval name with a numeric final character [" .. tostring(gg_level) .. "], but this couldn't be converted into a number - will not update rituals");
		return false;
	end;
	
	local faction_list = cm:model():world():faction_list();
	local current_ascended_god = cm:get_saved_value("great_game_ascendant_god") or "";
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		
		if not current_faction:is_dead() and faction_has_great_game_rituals(current_faction) then
			local culture = current_faction:culture();
			
			if not counter or counter == culture then
				unlock_gg_rituals(gg_level, current_faction, culture == current_ascended_god);
			end;
		end;
	end;
end;

function unlock_gg_rituals(gg_level, faction, use_upgraded_rituals)
	local culture = false;
	local is_belakor = false;
	local belakor_ritual_mapping = {
		"wh3_main_kho_khorne",
		"wh3_main_nur_nurgle",
		"wh3_main_sla_slaanesh",
		"wh3_main_tze_tzeentch"
	};
	
	if faction:name() == belakor_faction_key then
		culture = "belakor";
		is_belakor = true;
	else
		culture = chaos_get_culture_prefix(faction:culture());
	end;
	
	local current_ascended_god = cm:get_saved_value("great_game_ascendant_god") or "";
	
	for i = 1, 4 do
		local ritual_key = "wh3_main_ritual_" .. culture .. "_gg_" .. i;
		
		if (gg_level and i <= gg_level) or is_belakor then
			if use_upgraded_rituals or (is_belakor and belakor_ritual_mapping[i] == current_ascended_god) then
				cm:unlock_ritual(faction, ritual_key .. "_upgraded");
				cm:lock_ritual(faction, ritual_key);
			else
				cm:unlock_ritual(faction, ritual_key);
				cm:lock_ritual(faction, ritual_key .. "_upgraded");
			end;
		else
			cm:lock_ritual(faction, ritual_key);
			cm:lock_ritual(faction, ritual_key .. "_upgraded");
		end;
	end;
end;

function faction_has_great_game_rituals(faction)
	return faction:has_rituals() and faction:has_access_to_ritual_category("GREAT_GAME_1");
end;