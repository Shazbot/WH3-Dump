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

out.narrative("* wh3_narrative_kislev.lua loaded");

local shared_prepend_str = shared_narrative_event_prepend_str .. "_kislev";


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	THE ICE COURT
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function kislev_ice_court_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("kislev ice court", faction_key);


	local ice_court_subtypes_lookup = {
		wh3_main_ksl_frost_maiden_ice = true,
		wh3_main_ksl_frost_maiden_tempest = true,
		wh3_main_ksl_ice_witch_ice = true,
		wh3_main_ksl_ice_witch_tempest = true
	};


	core:add_listener(
		"kislev_ice_court_character_created",
		"CharacterCreated",
		true,
		function(context)
			local character = context:character();

			-- We assume that a character of the subject faction, of an appropriate subtype and with more than one trait on creation has come from the Ice Court
			if character:faction():name() == faction_key and ice_court_subtypes_lookup[character:character_subtype_key()] and character:number_of_traits() > 1 then
				
				local num_characters_recruited = cm:get_saved_value("ice_court_chars_" .. faction_key) or 0;
				cm:set_saved_value("ice_court_chars_" .. faction_key, num_characters_recruited + 1);
				core:trigger_custom_event("ScriptEventIceCourtCharacterCreated", {character = character});
			end;
		end,
		true
	)

	local advice_history_key = shared_prepend_str .. "_kislev_ice_court_completed";

	local ice_court_technology_keys = {
		"wh3_main_tech_ksl_1_06",			-- Ice Sculpting
		"wh3_main_tech_ksl_2_03",			-- Ice Court Indoctrination
		"wh3_main_tech_ksl_3_03",			-- Ice Court Discipline
		"wh3_main_tech_ksl_4_03"			-- Ice Court Control
	};




	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "kislev_ice_court_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartKislevIceCourtChainExpert",													-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartKislevIceCourtChainFull",														-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					advice_history_key
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown before Research Ice Court Tech mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "kislev_ice_court_trigger_pre_research_ice_court_tech_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKislevIceCourtChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKislevIceCourtResearchTechMission",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "CancelKislevIceCourtResearchTechMission",											-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 12,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Player Starts Researching Ice Court Tech Mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "kislev_ice_court_trigger_ice_court_tech_researching";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.technology_research_started(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKislevIceCourtChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or																						-- target message(s) to trigger
					{
						"CancelKislevIceCourtResearchTechMission", "StartKislevIceCourtRecruitCharacterShortCountdown"
					},
				narrative.get(faction_key, name .. "_cancel_messages"), 																						-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_technologies") or ice_court_technology_keys,																-- list of techs that the researching tech has to be contained in
				narrative.get(faction_key, name .. "_condition") 																								-- additional condition
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Research Ice Court Technology
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "kislev_ice_court_event_research_ice_court_tech";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.research_technology(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_kislev_unlock_ice_court_01",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_kislev_ice_court_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_num_technologies") or 3,																					-- num technologies
				narrative.get(faction_key, name .. "_technologies") or ice_court_technology_keys,																-- opt mandatory technologies
				narrative.get(faction_key, name .. "_include_existing") or false,																				-- includes existing technologies
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(1000, faction_key)																												-- issue money or equivalent
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKislevIceCourtResearchTechMission",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "cathay_compass_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or advice_history_key,																				-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "StartCathayCompassTransitionToExpert",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;


















	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn countdown before recruit Ice Court character mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "kislev_ice_court_trigger_expert_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKislevIceCourtChainExpert",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKislevIceCourtRecruitCharacterMission",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 16,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Player Starts Researching Ice Court Tech Mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "kislev_ice_court_trigger_ice_court_tech_researching_expert";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.technology_research_started(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKislevIceCourtChainExpert",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKislevIceCourtRecruitCharacterShortCountdown",									-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "StartKislevIceCourtRecruitCharacterMission",											-- script message(s) on which to cancel
					
				narrative.get(faction_key, name .. "_technologies") or ice_court_technology_keys,																-- list of techs that the researching tech has to be contained in
				narrative.get(faction_key, name .. "_condition") 																								-- additional condition
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Short turn countdown before recruit Ice Court character mission, triggered from player 
	--	researching an Ice Court tech before the mission was issued
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "kislev_ice_court_trigger_expert_turn_countdown_short";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKislevIceCourtRecruitCharacterShortCountdown",									-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKislevIceCourtRecruitCharacterMission",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 4,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Recruit a character through the Ice Court
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "kislev_ice_court_event_recruit_ice_court_char";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_kislev_ice_court_02",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_recruit_through_ice_court",						-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventIceCourtCharacterCreated",
						condition =	function(context)
							return true;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(2000, faction_key),																												-- issue money
					payload.ancillary_mission_payload(faction_key, "talisman", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKislevIceCourtRecruitCharacterMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "KislevIceCourtRecruitCharacterMissionCompleted",									-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	--	We only mark in this case when the expert mission is completed, as the chain is very short
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "kislev_ice_court_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or advice_history_key,																				-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "KislevIceCourtRecruitCharacterMissionCompleted",									-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;


	narrative.output_chain_footer();
end;











------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	ATAMAMS
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local kislev_atamans_excluded_factions = {
	wh3_dlc24_ksl_daughters_of_the_forest = true
}

local function kislev_atamans_narrative_loader(faction_key)

	if kislev_atamans_excluded_factions[faction_key] then return false end

	-- output header
	narrative.output_chain_header("kislev atamans", faction_key);
	






	-----------------------------------------------------------------------------------------------------------
	-- Trigger when Two Provinces Captured
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "kislev_atamans_trigger_two_provinces_held";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages"),																							-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKislevAtamansAppointAtamanMission",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "GarrisonOccupiedEvent",																		-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						return context:character():faction():name() == faction_key and cm:num_provinces_controlled_by_faction(cm:get_faction(faction_key)) >= 2;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;



	-----------------------------------------------------------------------------------------------------------
	--	Appoint an Ataman mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "kislev_atamans_event_appoint_ataman";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_kislev_atamans_02",												-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_appoint_ataman",									-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ProvinceGovernorAppointed",
						condition =	function(context)
							return context:faction():name() == faction_key;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(2000, faction_key),																												-- issue money
					payload.ancillary_mission_payload(faction_key, "banner", "rare")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKislevAtamansAppointAtamanMission",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	narrative.output_chain_footer();

end;













------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	Start all Chains
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function start_kislev_narrative_events(faction_key)
	kislev_ice_court_narrative_loader(faction_key);
	kislev_atamans_narrative_loader(faction_key);
end;


-- Ensure that these narrative events are started for any player-controlled faction matching the culture
narrative.add_loader_for_culture("wh3_main_ksl_kislev", start_kislev_narrative_events);