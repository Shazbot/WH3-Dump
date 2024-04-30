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
--	SV
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

out.narrative("* wh3_narrative_dwarfs.lua loaded");

local shared_prepend_str = shared_narrative_event_prepend_str;

dwf_narrative_missions = {}

dwf_narrative_missions.army_ability =
{
	wh3_dlc25_dwf_malakai = "wh3_dlc25_malakai_cam_mission_use_army_ability_001",
	mission = "wh3_dlc25_camp_narrative_dwarfs_spirit_of_grungni_army_ability",
	objective_text = "wh3_dlc25_camp_narrative_mission_description_dwarfs_malakai_spirit_of_grungni_army_ability", 
	reward = {
		payload.effect_bundle_mission_payload("wh3_dlc25_effect_horde_growth_dwf_use_army_ability_camp_narrative", 4),
		payload.pooled_resource_mission_payload("dwf_oathgold", "missions", 100)
	},
	army_ability_key = "wh3_dlc25_army_abilities_spirit_of_grungni"
}

dwf_narrative_missions.build_building = {
	mission = "wh3_dlc25_camp_narrative_dwarfs_spirit_of_grungni_upgrade",
	objective_text = "wh3_dlc25_camp_narrative_mission_description_dwarfs_malakai_spirit_of_grungni_upgrade",
	reward = {
		payload.pooled_resource_mission_payload("dwf_oathgold", "missions", 100),
		payload.money_direct(2000)
	},
	building_keys = {"wh3_dlc25_dwarf_spirit_of_grungni_airship_hull_2", "wh3_dlc25_dwarf_spirit_of_grungni_airship_hull_3"}
}

dwf_narrative_missions.defeat_faction = {
	mission = "wh3_dlc25_camp_narrative_dwarfs_grudge_points",
	reward = {
		payload.effect_bundle_mission_payload("wh3_dlc25_effect_campaign_movement_dwf_defeat_baersonling_camp_narrative", 5),
		payload.pooled_resource_mission_payload("wh3_dlc25_dwf_grudge_points", "missions", 100)
	},
	faction_key = "wh_main_nor_baersonling"
}

dwf_narrative_missions.complete_ritual = {
	mission = "wh3_dlc25_camp_narrative_dwarfs_grudge_rewards",
	objective_text = "wh3_dlc25_camp_narrative_mission_description_dwarfs_malakai_grudge_rewards",
	reward = {
		payload.pooled_resource_mission_payload("dwf_oathgold", "missions", 100),
		payload.money_direct(2000)
	},
	ritual_key_starts_with = "wh3_dlc25_dwf_ritual_"
}

dwf_narrative_missions.complete_oaths = {
	mission = "wh3_dlc25_camp_narrative_dwarfs_oaths_unlock",
	objective_text = "wh3_dlc25_camp_narrative_mission_description_dwarfs_malakai_oaths_unlock",
	reward = {
		payload.effect_bundle_mission_payload("wh3_dlc25_effect_cannons_recruitment_dwf_oaths_mission_camp_narrative", 5),
		payload.money_direct(2000)
	},
	mission_key_starts_with = "wh3_dlc25_mis_dwf_malakai_"
}

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	Start all Chains
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function start_dwarfs_narrative_events(faction_key)

	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Upgrade Airship
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "dwarfs_kill_baersonling_trigger_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartDwarfs_UpgradeAirship",					-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				1,															-- num turns to wait
				true														-- trigger immediately
			);
		end;
	end;

	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Kill Baersonling
	-----------------------------------------------------------------------------------------------------------
	
	if cm:get_campaign_name() == "wh3_main_chaos" then
		do
			local name = "dwarfs_upgrade_airship_trigger_turn_countdown";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_triggers.turn_countdown(
					name,														-- unique name for this narrative trigger
					faction_key,												-- key of faction to which it applies
					"StartNarrativeEvents",										-- script message(s) on which to start
					"ScriptEventStartDwarfs_KillBaersonling",					-- target message(s) to trigger
					nil,														-- script message(s) on which to cancel
					2,															-- num turns to wait
					true														-- trigger immediately
				);
			end;
		end;
	end

	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Book of Grudges IE
	-----------------------------------------------------------------------------------------------------------
	
	if cm:get_campaign_name() == "main_warhammer" then
		do
			local name = "dwarfs_book_of_grudges_ie";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_triggers.turn_countdown(
					name,														-- unique name for this narrative trigger
					faction_key,												-- key of faction to which it applies
					"StartNarrativeEvents",										-- script message(s) on which to start
					"ScriptEventMissionSucceededKillFaction",					-- target message(s) to trigger
					nil,														-- script message(s) on which to cancel
					2,															-- num turns to wait
					true														-- trigger immediately
				);
			end;
		end;
	end

	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Oaths Mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "dwarfs_oath_mission_trigger_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartDwarfs_OathMission",						-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				4,															-- num turns to wait
				true														-- trigger immediately
			);
		end;
	end;

	if faction_key == "wh3_dlc25_dwf_malakai" then
		dwf_narrative_missions:initialise(faction_key)
	end
end;

function dwf_narrative_missions:initialise(faction_key)

	-- Use Army Ability in battle
	do
		local name = "dwarf_event_use_army_ability";
		local mission_info = self.army_ability

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				nil,														-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.objective_text,								-- key of mission objective text
				{															-- event/condition listeners
					{
						event = "BattleCompleted",
						condition =	function(context)
							local pb = cm:model():pending_battle()
							local faction_cqi = cm:get_faction(faction_key):command_queue_index()
							if pb:has_been_fought() and pb:get_how_many_times_ability_has_been_used_in_battle(faction_cqi, mission_info.army_ability_key) > 0 then
								return true
							end
							return false
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"StartNarrativeEvents",										-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			);
		end
	end;

	-- Build Airship Hull Building
	do
		local name = "dwarf_event_build_airship_hull_building";
		local mission_info = self.build_building

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				nil,														-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.objective_text,								-- key of mission objective text
				{															-- event/condition listeners
					{
						event = "MilitaryForceBuildingCompleteEvent",
						condition =	function(context)
							local building_name = context:building()
							for i = 1, #mission_info.building_keys do
								if mission_info.building_keys[i] == building_name then
									return true
								end
							end
							return false
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartDwarfs_UpgradeAirship",					-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			);
		end
	end;

	-- Kill Baersonling
	do
		local name = "dwarf_event_kill_baersonling";
		local mission_info = self.defeat_faction

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.destroy_faction(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				nil,														-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.faction_key,									-- key of mission to target
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartDwarfs_KillBaersonling",					-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				"ScriptEventMissionSucceededKillFaction",					-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			)
		end
	end;

	-- Redeem Grudge reward
	do
		local name = "dwarf_event_redeem_grudge_reward";
		local mission_info = self.complete_ritual

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				nil,														-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.objective_text,								-- key of mission objective text
				{															-- event/condition listeners
					{
						event = "RitualCompletedEvent",
						condition =	function(context)
							return context:performing_faction():name() == faction_key and context:ritual():ritual_key():starts_with(mission_info.ritual_key_starts_with)
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventMissionSucceededKillFaction",					-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			);
		end
	end;

	-- Complete Oath mission
	do
		local name = "dwarf_event_oath_mission";
		local mission_info = self.complete_oaths

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				nil,														-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.objective_text,								-- key of mission objective text
				{															-- event/condition listeners
					{
						event = "MissionSucceeded",
						condition =	function(context)
							if context:mission():mission_record_key():starts_with(mission_info.mission_key_starts_with) then
								return true
							end
							return false
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartDwarfs_OathMission",						-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			);
		end
	end;

end

-- Ensure that these narrative events are started for any player-controlled faction matching the culture
narrative.add_loader_for_culture("wh_main_dwf_dwarfs", start_dwarfs_narrative_events);