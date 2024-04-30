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

out.narrative("* wh3_narrative_empire.lua loaded")

emp_narrative_missions = {}

emp_narrative_missions.gunnery_purchase =
{
	mission = "wh3_dlc25_camp_narrative_empire_gunnery_purchase",
	objective_text = "wh3_dlc25_camp_narrative_mission_description_empire_gunnery_purchase", 
	reward = {
		payload.ancillary_mission_payload_specific("wh_main_emp_wissenland", "wh3_dlc25_anc_armour_prototype_coat"), 
		payload.money_direct(1000)
	},
	ritual_start_key = "wh3_dlc25_ritual_emp_don_",
}

emp_narrative_missions.gunnery_upgrade = {
	advice = "wh3_dlc25_elspeth_cam_mission_gunnery_upgrade_001",
	mission = "wh3_dlc25_camp_narrative_empire_gunnery_upgrade",
	objective_text = "wh3_dlc25_camp_narrative_mission_description_empire_gunnery_upgrade",
	reward = {
		payload.pooled_resource_mission_payload("wh3_dlc25_emp_research", "other", 300), 
		payload.money_direct(2000)
	},
}

emp_narrative_missions.recruit_amethyst = {
	mission = "wh3_dlc25_camp_narrative_empire_recruit_amethyst",
	reward = {
		payload.pooled_resource_mission_payload("wh3_dlc25_emp_research", "other", 450), 
		payload.money_direct(3000)
	},
	unit_keys = {
		"wh3_dlc25_emp_inf_nuln_ironsides_morr",
		"wh3_dlc25_emp_cav_outriders_morr",
		"wh3_dlc25_emp_veh_marienburg_land_ship_morr",
		"wh3_dlc25_emp_art_helstorm_rocket_battery_morr",
	}
}

emp_narrative_missions.build_morr = {
	advice = "wh3_dlc25_elspeth_cam_mission_build_morr_001",
	mission = "wh3_dlc25_camp_narrative_empire_build_morr",
	objective_text = "wh3_dlc25_camp_narrative_mission_description_empire_build_morr",
	reward = {
		payload.effect_bundle_mission_payload("wh3_dlc25_effect_camp_narrative_gom_empire", 5), 
		payload.money_direct(1000)
	},
	ritual_key = "wh3_dlc25_emp_ritual_construct_black_tower"
}

emp_narrative_missions.teleport_morr = {
	mission = "wh3_dlc25_camp_narrative_empire_teleport_morr",
	objective_text = "wh3_dlc25_camp_narrative_mission_description_empire_teleport_morr",
	reward = {
		payload.money_direct(3000)
	},
	ritual_key = "wh3_dlc25_emp_ritual_elspeth_teleport"
}

emp_narrative_missions.imperial_authority = {
	advice = "wh3_dlc25_elspeth_cam_mission_imperial_authority_001",
	mission = "wh3_dlc25_camp_narrative_empire_imperial_authority",
	objective_text = "wh3_dlc25_camp_narrative_mission_description_empire_imperial_authority",
	reward = {
		payload.effect_bundle_mission_payload("wh3_dlc25_effect_camp_narrative_diplomacy_empire", 5), 
		payload.money_direct(3000)
	},
	pooled_resource = {
		key = "emp_imperial_authority_new",
		amount = 80
	}
}
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	Start all Chains
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function start_empire_narrative_events(faction_key)

	----------------------------------------------------
	--				IMPERIAL GUNNERY SCHOOL			  --
	----------------------------------------------------
	
	-----------------------------------------------------------------------------------------------------------
	--	Gunnery School Upgrade Countdown
	-----------------------------------------------------------------------------------------------------------
	do
		local name = "empire_gunnery_upgrade_turn_countdown"

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"ScriptEventStartEmpire_GunneryPurchase",					-- script message(s) on which to start
				"ScriptEventStartEmpire_GunneryUpgrade",					-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				1,															-- num turns to wait
				true														-- trigger immediately
			)
		end
	end

	----------------------------------------------------
	--					GARDENS OF MORR				  --
	----------------------------------------------------
	
	-----------------------------------------------------------------------------------------------------------
	--	Construct Garden of Morr Countdown
	-----------------------------------------------------------------------------------------------------------
	do
		local name = "empire_build_morr_turn_countdown"

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartEmpire_BuildMorr",							-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				4,															-- num turns to wait
				true														-- trigger immediately
			)
		end
	end
	
	----------------------------------------------------
	--			 	 IMPERIAL AUTHORITY 			  --
	----------------------------------------------------
	if cm:get_campaign_name() == "wh3_main_chaos" then 
		-- Handled in narrative_tod.lua
	else
		-----------------------------------------------------------------------------------------------------------
		--	Imperial Authority Countdown
		-----------------------------------------------------------------------------------------------------------
		do
			local name = "empire_imperial_authority_turn_countdown"

			if not narrative.get(faction_key, name .. "_block") then
				narrative_triggers.turn_countdown(
					name,														-- unique name for this narrative trigger
					faction_key,												-- key of faction to which it applies
					"StartNarrativeEvents",										-- script message(s) on which to start
					"ScriptEventStartEmpire_ImperialAuthority",					-- target message(s) to trigger
					nil,														-- script message(s) on which to cancel
					4,															-- num turns to wait
					true														-- trigger immediately
				)
			end
		end	

	end


	if faction_key == "wh_main_emp_wissenland" then
		emp_narrative_missions:initialise(faction_key)
	end
end

function emp_narrative_missions:initialise(faction_key)

	----------------------------------------------------
	--				IMPERIAL GUNNERY SCHOOL			  --
	----------------------------------------------------
	
	-----------------------------------------------------------------------------------------------------------
	--	Gunnery School Purchase
	-----------------------------------------------------------------------------------------------------------
	do
		local name = "empire_event_gunnery_purchase"
		local mission_info = self.gunnery_purchase

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
							return string.find(context:ritual():ritual_key(), mission_info.ritual_start_key)
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"StartNarrativeEvents",										-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				"ScriptEventStartEmpire_GunneryPurchase",					-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			)
		end
	end

	-----------------------------------------------------------------------------------------------------------
	--	Gunnery School Upgrade
	-----------------------------------------------------------------------------------------------------------
	do
		local name = "empire_event_gunnery_upgrade"
		local mission_info = self.gunnery_upgrade

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				mission_info.advice,										-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.objective_text,								-- key of mission objective text
				{															-- event/condition listeners
					{
						event = "GunnerySchoolTierComplete2",
						condition =	true
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartEmpire_GunneryUpgrade",					-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				"ScriptEventStartEmpire_RecruitAmethyst",					-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			)
		end
	end

	-----------------------------------------------------------------------------------------------------------
	--	Recruit Amethyst Unit
	-----------------------------------------------------------------------------------------------------------
	do
		local name = "empire_event_recruit_amethyst"
		local mission_info = self.recruit_amethyst

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.recruit_units(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				nil,														-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				1,															-- number of units to recruit
				mission_info.unit_keys,										-- keys of valid units
				true,														-- exclude pre existing units from count
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartEmpire_RecruitAmethyst",					-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			)
		end
	end

	----------------------------------------------------
	--					GARDENS OF MORR				  --
	----------------------------------------------------
	
	-----------------------------------------------------------------------------------------------------------
	--	Construct Garden of Morr
	-----------------------------------------------------------------------------------------------------------
	do
		local name = "empire_event_build_morr"
		local mission_info = self.build_morr

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				mission_info.advice,										-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.objective_text,								-- key of mission objective text
				{															-- event/condition listeners
					{
						event = "RitualCompletedEvent",
						condition =	function(context)
							return string.find(context:ritual():ritual_key(), mission_info.ritual_key) 
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartEmpire_BuildMorr",										-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				"ScriptEventStartEmpire_TeleportMorr",						-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			)
		end
	end

	-----------------------------------------------------------------------------------------------------------
	--	Teleport to Garden of Morr
	-----------------------------------------------------------------------------------------------------------
	do
		local name = "empire_event_teleport_morr"
		local mission_info = self.teleport_morr

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
							return string.find(context:ritual():ritual_key(), mission_info.ritual_key) 
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartEmpire_TeleportMorr",						-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			)
		end
	end

	----------------------------------------------------
	--			 	 IMPERIAL AUTHORITY 			  --
	----------------------------------------------------

	-----------------------------------------------------------------------------------------------------------
	--	Imperial Authority
	-----------------------------------------------------------------------------------------------------------
	do
		local name = "empire_event_imperial_authority"
		local mission_info = self.imperial_authority

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.gain_pooled_resource(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				mission_info.advice,										-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.pooled_resource.key,						
				mission_info.pooled_resource.amount,
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartEmpire_ImperialAuthority",					-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil
			)
		end
	end
end

-- Ensure that these narrative events are started for any player-controlled faction matching the culture
narrative.add_loader_for_culture("wh_main_emp_empire", start_empire_narrative_events)