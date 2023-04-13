------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	RACE-SPECIFIC NARRATIVE EVENT CHAINS
--
--	PURPOSE
--
--	This file defines chains of narrative events that are specific to a particular race. These are mostly 
--	tutorial missions related to race features like Khorne Skulls, Kislev Atamans, Cathay Compass etc. 
--	
--	The narrative loader function defined at the bottom of this file is added to the narrative system with a call
--	to narrative.add_loader_for_culture. The function will be called when the narrative system is started,
--	on or around the first tick, but only if there is a human-controlled faction in the campaign of the
--	relevant race.
--
--	LOADED
--	This file is currently loaded from wh3_narrative_shared_faction_data.lua, this may change in the future. It
--	is loaded when narrative.start() is called, as the faction data is loaded.
--	
--	AUTHORS
--	JM
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

out.narrative("* wh3_narrative_chaos_dwarfs.lua loaded");

narrative.add_exception_faction("wh3_dlc23_chd_astragoth")
narrative.add_exception_faction("wh3_dlc23_chd_legion_of_azgorh")
narrative.add_exception_faction("wh3_dlc23_chd_zhatan")

chd_narrative_missions = {}

chd_narrative_missions.fight_battle = {
	wh3_dlc23_chd_astragoth = "wh3_dlc23_astragoth_cam_mission_fight_battles_001",
	wh3_dlc23_chd_legion_of_azgorh = "wh3_dlc23_drazhoath_cam_mission_fight_battles_001",
	wh3_dlc23_chd_zhatan = "wh3_dlc23_zhatan_cam_mission_fight_battles_001",
	data = {
		mission = "wh3_dlc23_camp_narrative_chaos_dwarfs_fight_battles", 
		objective_text = "wh3_dlc23_camp_narrative_mission_description_chaos_dwarfs_fight_battles", 
		reward = {payload.effect_bundle_mission_payload("wh3_dlc23_effect_post_battle_loot_chd_fight_battles_camp_narrative", 5), payload.money_direct(1500)},
		battles_required = 3
	},
}

chd_narrative_missions.build_building = {
	raw_mats_building = {
		mission = "wh3_dlc23_camp_narrative_chaos_dwarfs_raw_mats_building",
		objective_text = "wh3_dlc23_camp_narrative_mission_description_chaos_dwarfs_build_raw_mats_building",
		reward = {payload.pooled_resource_mission_payload("wh3_dlc23_chd_labour_global_temp", "missions", 100), payload.money_direct(2000)},
		building_keys = {"wh3_dlc23_chd_outpost_mine_1", "wh3_dlc23_chd_outpost_mine_2", "wh3_dlc23_chd_outpost_mine_3"}
	},
	armaments_building = {
		mission = "wh3_dlc23_camp_narrative_chaos_dwarfs_armaments_building",
		objective_text = "wh3_dlc23_camp_narrative_mission_description_chaos_dwarfs_build_armaments_building",
		reward = {payload.pooled_resource_mission_payload("wh3_dlc23_chd_armaments", "missions", 75)},
		building_keys = {"wh3_dlc23_chd_factory_assembly_line_1", "wh3_dlc23_chd_factory_assembly_line_2", "wh3_dlc23_chd_factory_assembly_line_3"}
	},
}

chd_narrative_missions.conclave_seat = {
	wh3_dlc23_chd_astragoth = "wh3_dlc23_astragoth_cam_mission_claim_seat_001",
	wh3_dlc23_chd_legion_of_azgorh = "wh3_dlc23_drazhoath_cam_mission_claim_seat_001",
	wh3_dlc23_chd_zhatan = "wh3_dlc23_zhatan_cam_mission_claim_seat_001",
	data = {
		mission = "wh3_dlc23_camp_narrative_chaos_dwarfs_use_tower_of_zharr",
		objective_text = "wh3_dlc23_camp_narrative_mission_description_chaos_dwarfs_claim_seat",
		reward = {
			payload.pooled_resource_mission_payload("wh3_dlc23_chd_labour_global_temp", "missions", 100),
			payload.pooled_resource_mission_payload("wh3_dlc23_chd_conclave_influence", "missions", 25)
		},
		ritual_start_key = "wh3_dlc23_ritual_chd_toz_slot_t1_",
		ritual_keys = {
			"wh3_dlc23_ritual_chd_toz_slot_t1_industry_1",
			"wh3_dlc23_ritual_chd_toz_slot_t1_industry_2",
			"wh3_dlc23_ritual_chd_toz_slot_t1_industry_3",
			"wh3_dlc23_ritual_chd_toz_slot_t1_industry_4",
			"wh3_dlc23_ritual_chd_toz_slot_t1_military_1",
			"wh3_dlc23_ritual_chd_toz_slot_t1_military_2",
			"wh3_dlc23_ritual_chd_toz_slot_t1_military_3",
			"wh3_dlc23_ritual_chd_toz_slot_t1_military_4",
			"wh3_dlc23_ritual_chd_toz_slot_t1_sorcery_1",
			"wh3_dlc23_ritual_chd_toz_slot_t1_sorcery_2",
			"wh3_dlc23_ritual_chd_toz_slot_t1_sorcery_3",
			"wh3_dlc23_ritual_chd_toz_slot_t1_sorcery_4",
		}
	}
}

chd_narrative_missions.produce_resources = {
	raw_mats = {
		mission = "wh3_dlc23_camp_narrative_chaos_dwarfs_produce_raw_materials",
		objective_text = "wh3_dlc23_camp_narrative_mission_description_chaos_dwarfs_produce_raw_mats",
		reward = {payload.pooled_resource_mission_payload("wh3_dlc23_chd_labour_global_temp", "missions", 100), payload.money_direct(1000)},
		pooled_resource = "wh3_dlc23_chd_raw_materials",
		resource_factor = "wh3_dlc23_chd_mined",
		required_amount = 700
	},
	armaments = {
		mission = "wh3_dlc23_camp_narrative_chaos_dwarfs_produce_armaments",
		objective_text = "wh3_dlc23_camp_narrative_mission_description_chaos_dwarfs_produce_armaments",
		reward = {payload.pooled_resource_mission_payload("wh3_dlc23_chd_raw_materials", "missions", 200), payload.money_direct(2000)},
		pooled_resource = "wh3_dlc23_chd_armaments",
		resource_factor = "wh3_dlc23_chd_produced",
		required_amount = 400
	}
}

chd_narrative_missions.chd_features = {
	convoys = {
		mission = "wh3_dlc23_camp_narrative_chaos_dwarfs_convoy",
		objective_text = "wh3_dlc23_camp_narrative_mission_description_chaos_dwarfs_complete_convoy",
		reward = {
			payload.pooled_resource_mission_payload("wh3_dlc23_chd_armaments", "missions", 75),
			payload.effect_bundle_mission_payload("wh3_dlc23_effect_convoy_cargo_capacity_camp_narrative", 10)
		},
		convoy_incident = "wh3_dlc23_chd_convoy_unique_completed_"
	},
	hellforge = {
		mission = "wh3_dlc23_camp_narrative_chaos_dwarfs_hellforge_customization",
		objective_text = "wh3_dlc23_camp_narrative_mission_description_chaos_dwarfs_hellforge_customization",
		reward = {payload.pooled_resource_mission_payload("wh3_dlc23_chd_armaments", "missions", 75), payload.money_direct(2000)},
		hellforge_initiative = "wh3_dlc23_faction_initiative_chd_"
	}
}

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	Start all Chains
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function start_chaos_dwarfs_narrative_events(faction_key)

----------------------------------------------------
--					ECONOMY						  --
----------------------------------------------------

	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Fight Battles for Labour
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "chaos_dwarfs_fight_battles_trigger_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartChaosDwarfs_FightBattles",					-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				1,															-- num turns to wait
				true														-- trigger immediately
			);
		end;
	end;

	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Build Raw Materials Production building
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "chaos_dwarfs_build_raw_mats_production_trigger_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartChaosDwarfs_BuildRawMatsBuilding",			-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				1,															-- num turns to wait
				true														-- trigger immediately
			);
		end;
	end;

	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Build Armaments Production building
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "chaos_dwarfs_build_armaments_production_trigger_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartChaosDwarfs_BuildArmamentsBuilding",		-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				2,															-- num turns to wait
				true														-- trigger immediately
			);
		end;
	end;

	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Finish Convoy
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "chaos_dwarfs_finish_convoy_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartChaosDwarfs_Convoy",						-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				4,															-- num turns to wait
				true														-- trigger immediately
			);
		end;
	end;

	-----------------------------------------------------------------------------------------------------------
	--	Conclave Influence threshold met
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "chaos_dwarfs_toz_conclave_influence_aquired";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.pooled_resource_gained(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartChaosDwarfs_ClaimSeat",					-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				"wh3_dlc23_chd_conclave_influence",							-- pooled resource key
				75,															-- threshold value
				false														-- less than rather than greater than
			);
		end;
	end;

	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Complete Hell-Forge customization
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "chaos_dwarfs_hellforge_customization_trigger_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartChaosDwarfs_HellForgeCustomization",		-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				4,															-- num turns to wait
				true														-- trigger immediately
			);
		end;
	end;


	chd_narrative_missions:initialise(faction_key)
end


function chd_narrative_missions:initialise(faction_key)

	----------------------------------------------------
	--					ECONOMY					      --
	----------------------------------------------------
		
		--Fight Battles
		do
			local name = "chaos_dwarf_event_fight_battles";
			local advice = self.fight_battle[faction_key]
			local mission_info = self.fight_battle.data
	
			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,														-- unique name for this narrative event
					faction_key,												-- key of faction to which it applies
					advice,														-- key of advice to deliver
					mission_info.mission,										-- key of mission to deliver
					mission_info.objective_text,								-- key of mission objective text
					{															-- event/condition listeners
						{
							event = "BattleCompleted",
							condition =	function(context)
								local pb = cm:model():pending_battle()
								if not pb:has_been_fought() then
									return
								end

								local defeated_armies = cm:get_saved_value("armies_defeated_by_" .. faction_key) or 0
								if cm:pending_battle_cache_faction_is_attacker(faction_key) and pb:attacker_won() then
									defeated_armies = defeated_armies + 1
								elseif cm:pending_battle_cache_faction_is_defender(faction_key) and pb:defender_won() then
									defeated_armies = defeated_armies + 1
								end
								
								cm:set_saved_value("armies_defeated_by_" .. faction_key, defeated_armies)
								if defeated_armies >= mission_info.battles_required then return true end
								return false
							end
						}
					},
					nil,														-- camera scroll callback
					nil,														-- mission issuer (can be nil in which case default is used)
					mission_info.reward,										-- mission rewards
					"ScriptEventStartChaosDwarfs_FightBattles",					-- script message(s) on which to trigger when received
					nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					nil,														-- script message(s) to trigger when this mission is completed
					nil,
					true 														-- force the advice to always play
				);
			end
		end;

		--Build Raw Materials Building
		do
			local name = "chaos_dwarf_event_build_raw_mats_building";
			local mission_info = self.build_building.raw_mats_building
	
			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,														-- unique name for this narrative event
					faction_key,												-- key of faction to which it applies
					nil,														-- key of advice to deliver
					mission_info.mission,										-- key of mission to deliver
					mission_info.objective_text,								-- key of mission objective text
					{															-- event/condition listeners
						{
							event = "BuildingCompleted",
							condition =	function(context)
								if context:building():faction():name() == faction_key then
									local building_name = context:building():name()
									for i = 1, #mission_info.building_keys do
										if mission_info.building_keys[i] == building_name then
											return true
										end
									end
								end
								return false
							end
						}
					},
					nil,														-- camera scroll callback
					nil,														-- mission issuer (can be nil in which case default is used)
					mission_info.reward,										-- mission rewards
					"ScriptEventStartChaosDwarfs_BuildRawMatsBuilding",			-- script message(s) on which to trigger when received
					nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					"ScriptEventMissionSucceededRawMatsBuilding",				-- script message(s) to trigger when this mission is completed
					nil,
					true 														-- force the advice to always play
				);
			end
		end;

		--Build Armaments Building
		do
			local name = "chaos_dwarf_event_build_armaments_building";
			local mission_info = self.build_building.armaments_building
	
			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,														-- unique name for this narrative event
					faction_key,												-- key of faction to which it applies
					nil,														-- key of advice to deliver
					mission_info.mission,										-- key of mission to deliver
					mission_info.objective_text,								-- key of mission objective text
					{															-- event/condition listeners
						{
							event = "BuildingCompleted",
							condition =	function(context)
								if context:building():faction():name() == faction_key then
									local building_name = context:building():name()
									for i = 1, #mission_info.building_keys do
										if mission_info.building_keys[i] == building_name then
											return true
										end
									end
								end
								return false
							end
						}
					},
					nil,														-- camera scroll callback
					nil,														-- mission issuer (can be nil in which case default is used)
					mission_info.reward,										-- mission rewards
					"ScriptEventStartChaosDwarfs_BuildArmamentsBuilding",		-- script message(s) on which to trigger when received
					nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					"ScriptEventMissionSucceededArmamentsBuilding",				-- script message(s) to trigger when this mission is completed
					nil,
					true 														-- force the advice to always play
				);
			end
		end;

		--Claim Tower of Zharr seat
		do
			local name = "chaos_dwarf_event_claim_seat";
			local advice = self.conclave_seat[faction_key]
			local mission_info = self.conclave_seat.data
	
			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,														-- unique name for this narrative event
					faction_key,												-- key of faction to which it applies
					advice,														-- key of advice to deliver
					mission_info.mission,										-- key of mission to deliver
					mission_info.objective_text,								-- key of mission objective text
					{															-- event/condition listeners
						{
							event = "RitualCompletedEvent",
							condition =	function(context)
								if string.find(context:ritual():ritual_key(), mission_info.ritual_start_key) then
									local ritual_name = context:ritual():ritual_key()
									for i = 1, #mission_info.ritual_keys do
										if mission_info.ritual_keys[i] == ritual_name then
											return true
										end
									end
								end
								return false
							end
						}
					},
					nil,														-- camera scroll callback
					nil,														-- mission issuer (can be nil in which case default is used)
					mission_info.reward,										-- mission rewards
					"ScriptEventStartChaosDwarfs_ClaimSeat",					-- script message(s) on which to trigger when received
					nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					nil,														-- script message(s) to trigger when this mission is completed
					nil,
					true 														-- force the advice to always play
				);
			end
		end;

		--Produce X Raw Materials
		do
			local name = "chaos_dwarf_event_produce_raw_mats";
			local mission_info = self.produce_resources.raw_mats
	
			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,														-- unique name for this narrative event
					faction_key,												-- key of faction to which it applies
					nil,														-- key of advice to deliver
					mission_info.mission,										-- key of mission to deliver
					mission_info.objective_text,								-- key of mission objective text
					{															-- event/condition listeners
						{
							event = "FactionTurnStart",
							condition =	function(context)
								if context:faction():name() == faction_key then
									return context:faction():pooled_resource_manager():resource(mission_info.pooled_resource):value() >= mission_info.required_amount
								end
								return false
							end
						}
					},
					nil,														-- camera scroll callback
					nil,														-- mission issuer (can be nil in which case default is used)
					mission_info.reward,										-- mission rewards
					"ScriptEventMissionSucceededRawMatsBuilding",				-- script message(s) on which to trigger when received
					nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					nil,														-- script message(s) to trigger when this mission is completed
					nil,
					true 														-- force the advice to always play
				);
			end
		end;

		--Produce X Armaments
		do
			local name = "chaos_dwarf_event_produce_armaments";
			local mission_info = self.produce_resources.armaments
	
			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,														-- unique name for this narrative event
					faction_key,												-- key of faction to which it applies
					nil,														-- key of advice to deliver
					mission_info.mission,										-- key of mission to deliver
					mission_info.objective_text,								-- key of mission objective text
					{															-- event/condition listeners
						{
							event = "FactionTurnStart",
							condition =	function(context)
								if context:faction():name() == faction_key then
									return context:faction():pooled_resource_manager():resource(mission_info.pooled_resource):value() >= mission_info.required_amount
								end
								return false
							end
						}
					},
					nil,														-- camera scroll callback
					nil,														-- mission issuer (can be nil in which case default is used)
					mission_info.reward,										-- mission rewards
					"ScriptEventMissionSucceededArmamentsBuilding",				-- script message(s) on which to trigger when received
					nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					"ScriptEventMissionSucceededArmamentsProduction",			-- script message(s) to trigger when this mission is completed
					nil,
					true 														-- force the advice to always play
				);
			end
		end;

		--Complete a Convoy
		do
			local name = "chaos_dwarf_event_complete_convoy";
			local mission_info = self.chd_features.convoys
	
			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,														-- unique name for this narrative event
					faction_key,												-- key of faction to which it applies
					nil,														-- key of advice to deliver
					mission_info.mission,										-- key of mission to deliver
					mission_info.objective_text,								-- key of mission objective text
					{															-- event/condition listeners
						{
							event = "IncidentOccuredEvent",
							condition =
								function(context)
									return context:faction():name() == faction_key and string.find(context:dilemma(), mission_info.convoy_incident)
								end
						}
					},
					nil,														-- camera scroll callback
					nil,														-- mission issuer (can be nil in which case default is used)
					mission_info.reward,										-- mission rewards
					"ScriptEventStartChaosDwarfs_Convoy",						-- script message(s) on which to trigger when received
					nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					nil,														-- script message(s) to trigger when this mission is completed
					nil,
					true 														-- force the advice to always play
				);
			end
		end;

		--Complete Hell-forge Category customization
		do
			local name = "chaos_dwarf_event_hellforge_customization";
			local mission_info = self.chd_features.hellforge
	
			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,														-- unique name for this narrative event
					faction_key,												-- key of faction to which it applies
					nil,														-- key of advice to deliver
					mission_info.mission,										-- key of mission to deliver
					mission_info.objective_text,								-- key of mission objective text
					{															-- event/condition listeners
						{
							event = "FactionInitiativeActivationChangedEvent",
							condition =	function(context)
								return context:faction():name() == faction_key and string.find(context:initiative():record_key(), mission_info.hellforge_initiative) and context:active()
							end
						}
					},
					nil,														-- camera scroll callback
					nil,														-- mission issuer (can be nil in which case default is used)
					mission_info.reward,										-- mission rewards
					"ScriptEventStartChaosDwarfs_HellForgeCustomization",		-- script message(s) on which to trigger when received
					nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					nil,														-- script message(s) to trigger when this mission is completed
					nil,
					true 														-- force the advice to always play
				);
			end
		end;

end


-- Ensure that these narrative events are started for any player-controlled faction matching the culture
narrative.add_loader_for_culture("wh3_dlc23_chd_chaos_dwarfs", start_chaos_dwarfs_narrative_events)