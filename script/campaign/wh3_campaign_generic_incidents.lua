core:add_listener(
	"ritual_started_event_feed",
	"RitualStartedEvent",
	true,
	function(context)
		local performing_faction = context:performing_faction();
		local ritual = context:ritual();
		local ritual_category = ritual:ritual_category();
		
		if performing_faction:is_human() then
			if ritual_category == "SKULLS_RITUAL" then
				cm:trigger_incident(performing_faction:name(), "wh3_main_incident_ritual_kho_the_skull_throne", true);
			elseif ritual_category == "MOTHERLAND_RITUAL" then
				local incident_mapping = {
					["wh3_main_ritual_ksl_winter_dazh"] = "wh3_main_incident_ritual_ksl_winter_dazh",
					["wh3_main_ritual_ksl_winter_dazh_upgraded"] = "wh3_main_incident_ritual_ksl_winter_dazh",
					["wh3_main_ritual_ksl_winter_salyak"] = "wh3_main_incident_ritual_ksl_winter_salyak",
					["wh3_main_ritual_ksl_winter_salyak_upgraded"] = "wh3_main_incident_ritual_ksl_winter_salyak",
					["wh3_main_ritual_ksl_winter_tor"] = "wh3_main_incident_ritual_ksl_winter_tor",
					["wh3_main_ritual_ksl_winter_tor_upgraded"] = "wh3_main_incident_ritual_ksl_winter_tor",
					["wh3_main_ritual_ksl_winter_ursun"] = "wh3_main_incident_ritual_ksl_winter_ursun",
					["wh3_main_ritual_ksl_winter_ursun_upgraded"] = "wh3_main_incident_ritual_ksl_winter_ursun"
				};
				
				-- Trigger event with the faction as context.
				core:trigger_event("ScriptEventFactionPerformsMotherlandRitual", performing_faction)

				cm:trigger_incident(performing_faction:name(), incident_mapping[ritual:ritual_key()], true);
			end;
		else
			if ritual_category == "MOTHERLAND_RITUAL" then
				-- Trigger event with the faction as context.
				core:trigger_event("ScriptEventFactionPerformsMotherlandRitual", performing_faction)
			end
		end
	end,
	true
);

core:add_listener(
	"ritual_completed_event_feed",
	"RitualCompletedEvent",
	true,
	function(context)
		local performing_faction = context:performing_faction();
		local ritual = context:ritual();
		local ritual_category = ritual:ritual_category();
		local ritual_key = ritual:ritual_key();
		local performing_faction_cqi = performing_faction:command_queue_index();
		local performing_faction_is_human = performing_faction:is_human();
		
		if performing_faction_is_human then
			if ritual_category == "ASCENSION_RITUAL" then
				local incident_mapping = {
					["wh3_main_ritual_dae_ascend_khorne"] = "wh3_main_incident_ritual_dae_ascend_khorne",
					["wh3_main_ritual_dae_ascend_nurgle"] = "wh3_main_incident_ritual_dae_ascend_nurgle",
					["wh3_main_ritual_dae_ascend_slaanesh"] = "wh3_main_incident_ritual_dae_ascend_slaanesh",
					["wh3_main_ritual_dae_ascend_tzeentch"] = "wh3_main_incident_ritual_dae_ascend_tzeentch",
					["wh3_main_ritual_dae_ascend_undivided"] = "wh3_main_incident_ritual_dae_ascend_undivided"
				};
				
				cm:trigger_incident_with_targets(performing_faction_cqi, incident_mapping[ritual_key], 0, 0, performing_faction:faction_leader():command_queue_index(), 0, 0, 0);
			elseif ritual_category == "DEVOTEES_RITUAL" then
				local incident_mapping = {
					["wh3_main_ritual_sla_pleasure_arena"] = "wh3_main_incident_ritual_sla_pleasure_arena",
					["wh3_main_ritual_sla_pleasure_hunt"] = "wh3_main_incident_ritual_sla_pleasure_hunt",
					["wh3_main_ritual_sla_pleasure_party"] = "wh3_main_incident_ritual_sla_pleasure_party"
				};
				
				cm:trigger_incident_with_targets(performing_faction_cqi, incident_mapping[ritual_key], 0, 0, 0, 0, ritual:ritual_target():get_target_region():cqi(), 0);
			elseif ritual_category == "MEAT_RITUAL" then
				local incident_mapping = {
					["wh3_main_ritual_ogr_great_maw_bloody_and_raw"] = "wh3_main_incident_ritual_ogr_great_maw_bloody_and_raw",
					["wh3_main_ritual_ogr_great_maw_come_and_get_it"] = "wh3_main_incident_ritual_ogr_great_maw_come_and_get_it",
					["wh3_main_ritual_ogr_great_maw_fill_yer_bellies"] = "wh3_main_incident_ritual_ogr_great_maw_fill_yer_bellies",
					["wh3_main_ritual_ogr_great_maw_give_me_gut_magic"] = "wh3_main_incident_ritual_ogr_great_maw_give_me_gut_magic"
				};
				
				cm:trigger_incident_with_targets(performing_faction_cqi, incident_mapping[ritual_key], 0, 0, ritual:ritual_target():get_target_force():general_character():command_queue_index(), 0, 0, 0);
			elseif ritual_category:starts_with("GREAT_GAME") then
				local target = ritual:ritual_target():get_target_force();
				
				if not target:is_null_interface() and target:has_general() then
					local incident_mapping = {
						["wh3_main_ritual_kho_gg_4"] = "wh3_main_incident_ritual_kho_gg_4",
						["wh3_main_ritual_nur_gg_4"] = "wh3_main_incident_ritual_nur_gg_4",
						["wh3_main_ritual_sla_gg_2"] = "wh3_main_incident_ritual_sla_gg_2",
						["wh3_main_ritual_tze_gg_1"] = "wh3_main_incident_ritual_tze_gg_1",
						["wh3_main_ritual_tze_gg_4"] = "wh3_main_incident_ritual_tze_gg_4"
					};
					
					if incident_mapping[ritual_key] then
						cm:trigger_incident_with_targets(performing_faction_cqi, incident_mapping[ritual_key], 0, 0, target:general_character():command_queue_index(), 0, 0, 0);
					end;
				end;
			end;
		end;
		
		if ritual_category == "TZEENTCH_RITUAL" then
			local incident_mapping = {
				["wh3_main_ritual_tze_cotw_force_rebellion"] = "wh3_main_incident_ritual_tze_cotw_force_rebellion",
				["wh3_main_ritual_tze_cotw_halt_faction"] = "wh3_main_incident_ritual_tze_cotw_halt_faction",
				["wh3_main_ritual_tze_cotw_open_gates"] = "wh3_main_incident_ritual_tze_cotw_open_gates",
				["wh3_main_ritual_tze_cotw_reveal_shroud"] = "wh3_main_incident_ritual_tze_cotw_reveal_shroud",
				["wh3_main_ritual_tze_cotw_vilitch_reveal_shroud"] = "wh3_main_incident_ritual_tze_cotw_reveal_shroud",
				["wh3_main_ritual_tze_cotw_show_ai_intentions"] = "wh3_main_incident_ritual_tze_cotw_show_ai_intentions",
				["wh3_main_ritual_tze_cotw_vilitch_show_ai_intentions"] = "wh3_main_incident_ritual_tze_cotw_show_ai_intentions",
				["wh3_main_ritual_tze_cotw_track_army"] = "wh3_main_incident_ritual_tze_cotw_track_army",
				["wh3_dlc20_ritual_tze_cotw_vilitch_drain_magic"] = "wh3_dlc20_incident_ritual_tze_cotw_vilitch_drain_magic",
				["wh3_dlc20_ritual_tze_cotw_vilitch_muddle_minds"] = "wh3_dlc20_incident_ritual_tze_cotw_vilitch_muddle_minds",
				["wh3_dlc20_ritual_tze_cotw_vilitch_spawnification"] = "wh3_dlc20_incident_ritual_tze_cotw_vilitch_spawnification",
				["wh3_main_ritual_tze_cotw_borrow_time"] = "wh3_main_incident_ritual_tze_cotw_borrow_time"
			};
			
			local ritual_target = ritual:ritual_target();
			local target_type = ritual_target:target_type();
			
			local faction_cqi = 0;
			local character_cqi = 0;
			local region_cqi = 0;
			local target_faction = false;
			
			if target_type == "FACTION" then
				target_faction = ritual_target:get_target_faction();
				faction_cqi = target_faction:command_queue_index();
			elseif target_type == "MILITARY_FORCE" or target_type == "FORCE" then
				local target_force = ritual_target:get_target_force()
				character_cqi = target_force:general_character():command_queue_index();
				target_faction = target_force:faction()
			
			elseif target_type == "REGION" then
				local region = ritual_target:get_target_region();
				region_cqi = region:cqi();
				target_faction = region:owning_faction();
			end;
			
			if performing_faction_is_human and incident_mapping[ritual_key] then
				cm:trigger_incident_with_targets(performing_faction_cqi, incident_mapping[ritual_key], faction_cqi, 0, character_cqi, 0, region_cqi, 0);
			end;
			
			if target_faction and target_faction:is_human() then
				local incident_mapping = {
					["wh3_main_ritual_tze_cotw_force_rebellion"] = "wh3_main_incident_ritual_tze_cotw_force_rebellion_theirs",
					["wh3_main_ritual_tze_cotw_halt_faction"] = "wh3_main_incident_ritual_tze_cotw_halt_faction_theirs",
					["wh3_main_ritual_tze_cotw_open_gates"] = "wh3_main_incident_ritual_tze_cotw_open_gates_theirs",
					["wh3_dlc20_ritual_tze_cotw_vilitch_drain_magic"] = "wh3_dlc20_incident_ritual_tze_cotw_vilitch_drain_magic_theirs",
					["wh3_dlc20_ritual_tze_cotw_vilitch_muddle_minds"] = "wh3_dlc20_incident_ritual_tze_cotw_vilitch_muddle_minds_theirs",
					["wh3_dlc20_ritual_tze_cotw_vilitch_spawnification"] = "wh3_dlc20_incident_ritual_tze_cotw_vilitch_spawnification_theirs"
				};
				
				if incident_mapping[ritual_key] then
					cm:trigger_incident_with_targets(target_faction:command_queue_index(), incident_mapping[ritual_key], performing_faction_cqi, 0, character_cqi, 0, region_cqi, 0);
				end;
			end;
			
			-- special case for spread corruption
			if ritual_key == "wh3_dlc24_ritual_tze_cotw_the_changeling_spread_corruption" or ritual_key == "wh3_dlc24_ritual_tze_cotw_vilitch_spread_corruption" then
				cm:trigger_incident_with_targets(performing_faction_cqi, "wh3_dlc24_incident_ritual_tze_cotw_the_changeling_spread_corruption", 0, 0, character_cqi, 0, 0, 0);
				
				local character = cm:get_character_by_cqi(character_cqi);
				
				if character:has_region() then
					local region = character:region();
					
					if not region:is_abandoned() then
						local faction = region:owning_faction();
						if faction:is_human() then
							cm:trigger_incident_with_targets(faction:command_queue_index(), "wh3_dlc24_incident_ritual_tze_cotw_the_changeling_spread_corruption_theirs", 0, 0, character_cqi, 0, 0, 0);
						end;
					end;
				end;
			end;
		end;
	end,
	true
);

--[[core:add_listener(
	"cathay_harmony_event_feed",
	"FactionTurnStart",
	function(context)
		local faction = context:faction();
		return faction:is_human() and faction:culture() == "wh3_main_cth_cathay";
	end,
	function(context)
		local faction = context:faction();
		local faction_name = faction:name();
		local value = faction:pooled_resource_manager():resource("wh3_main_cth_harmony"):value();
		
		local event = "wh3_main_incident_cth_harmony_balanced";
		
		if value > 0 then
			event = "wh3_main_incident_cth_harmony_yang";
		elseif value < 0 then
			event = "wh3_main_incident_cth_harmony_yin";
		end;
		
		local save_value = cm:get_saved_value(faction_name .. "_harmony_event_last_shown");
		
		-- if the save value doesn't exist, no event has been shown, so only show the event once the harmony balance changes
		if save_value == nil then
			save_value = event;
			cm:set_saved_value(faction_name .. "_harmony_event_last_shown", event);
		end;
		
		-- the harmony balance has changed since we last showed an event, show a new one
		if save_value ~= event then
			cm:trigger_incident(faction_name, event, true);
			cm:set_saved_value(faction_name .. "_harmony_event_last_shown", event);
		end;
	end,
	true
);]]

core:add_listener(
	"camp_destroyed_event_feed",
	"CharacterConvalescedOrKilled",
	function(context)
		local character = context:character();
		
		return character:faction():is_human() and character:character_subtype("wh3_main_ogr_tyrant_camp");
	end,
	function(context)
		local character = context:character();
		
		cm:trigger_incident_with_targets(character:faction():command_queue_index(), "wh3_main_incident_ogr_camp_destroyed", 0, 0, character:command_queue_index(), 0, 0, 0);
	end,
	true
);

-- Music hookup for Daemonic Ascension Rituals for the daemon prince
core:add_listener(
	"acension_ritual_music_trigger",
	"RitualCompletedEvent",
	function(context)
		return context:performing_faction():is_human() and context:ritual():ritual_category() == "ASCENSION_RITUAL";
	end,
	function(context)
		cm:activate_music_trigger("ScriptedEvent_Positive", "wh3_main_sc_dae_daemons");
	end,
	true
);