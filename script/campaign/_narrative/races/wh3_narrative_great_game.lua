------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	GREAT-GAME NARRATIVE EVENT CHAINS
--
--	PURPOSE
--
--	This file defines chains of narrative events for the Great Game, that are shared between all Chaos races (except
--	the Daemon Prince).
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

out.narrative("* wh3_narrative_great_game.lua loaded");

local shared_prepend_str = shared_narrative_event_prepend_str;

-- factions that should not run these narrative events
local excluded_factions = {
	wh3_dlc24_tze_the_deceivers = true,
	wh3_dlc25_nur_tamurkhan = true
}


local locked_unholy_manifestation_keys = {
	wh3_main_kho_khorne = {
		-- "wh3_main_ritual_kho_gg_1_upgraded",
		-- "wh3_main_ritual_kho_gg_1",
		"wh3_main_ritual_kho_gg_2_upgraded",
		"wh3_main_ritual_kho_gg_2",
		"wh3_main_ritual_kho_gg_3_upgraded",
		"wh3_main_ritual_kho_gg_3",
		"wh3_main_ritual_kho_gg_4_upgraded",
		"wh3_main_ritual_kho_gg_4"
	},
	wh3_main_nur_nurgle = {
		-- "wh3_main_ritual_nur_gg_1_upgraded",
		-- "wh3_main_ritual_nur_gg_1",
		"wh3_main_ritual_nur_gg_2_upgraded",
		"wh3_main_ritual_nur_gg_2",
		"wh3_main_ritual_nur_gg_3_upgraded",
		"wh3_main_ritual_nur_gg_3",
		"wh3_main_ritual_nur_gg_4_upgraded",
		"wh3_main_ritual_nur_gg_4"
	},
	wh3_main_sla_slaanesh = {
		-- "wh3_main_ritual_sla_gg_1_upgraded",
		-- "wh3_main_ritual_sla_gg_1",
		"wh3_main_ritual_sla_gg_2_upgraded",
		"wh3_main_ritual_sla_gg_2",
		"wh3_main_ritual_sla_gg_3_upgraded",
		"wh3_main_ritual_sla_gg_3",
		"wh3_main_ritual_sla_gg_4_upgraded",
		"wh3_main_ritual_sla_gg_4"
	},
	wh3_main_tze_tzeentch = {
		-- "wh3_main_ritual_tze_gg_1_upgraded",
		-- "wh3_main_ritual_tze_gg_1",
		"wh3_main_ritual_tze_gg_2_upgraded",
		"wh3_main_ritual_tze_gg_2",
		"wh3_main_ritual_tze_gg_3_upgraded",
		"wh3_main_ritual_tze_gg_3",
		"wh3_main_ritual_tze_gg_4_upgraded",
		"wh3_main_ritual_tze_gg_4"
	}
};

local function unlock_unholy_manifestation_condition(context, faction_key)
	if context:faction():name() == faction_key then

		local faction = context:faction();
		local rituals = faction:rituals();
		local locked_ums = locked_unholy_manifestation_keys[faction:culture()];

		for i = 1, #locked_ums do
			local ritual_name = locked_ums[i];
			if not rituals:ritual_status(ritual_name):script_locked() then
				return true;
			end;
		end;
	end;
end;






------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	GREAT GAME
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


function great_game_narrative_loader(faction_key, chaos_type, chaos_corruption_type, culture)
	if excluded_factions[faction_key] then
		out.narrative("\t* not running great game narrative events for faction [" .. faction_key .. "] as they are part of the exclusion list");
		return;
	end;

	local chaos_type_lower = string.lower(chaos_type);

	-- output header
	narrative.output_chain_header(chaos_type_lower .. " great game", faction_key);
	

	local advice_history_string = shared_prepend_str .. "_great_game_chain_completed";






	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = chaos_type_lower .. "_great_game_advice_query";

		if not narrative.get(faction_key, name .. "_block") then

			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "Start" .. chaos_type .. "GreatGameChainExpert",									-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "Start" .. chaos_type .. "GreatGameChainFull",										-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					advice_history_string
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;
	


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown before Query Spread Corruption Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = chaos_type_lower .. "_great_game_turn_countdown_pre_query_corruption";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "Start" .. chaos_type .. "GreatGameChainFull",											-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "Start" .. chaos_type .. "GreatGameQueryCorruption",									-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or TURN_THRESHOLD_CHAOS_CULTS_CAN_SPAWN - 8,													-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Corruption In Adjacent Regions Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = chaos_type_lower .. "_great_game_adjacent_regions_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.corruption_in_adjacent_region(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "Start" .. chaos_type .. "GreatGameQueryCorruption",									-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or chaos_type .. "GreatGameCorruptionSpread",											-- positive target message(s) - corruption present in adjacent region of threshold
				narrative.get(faction_key, name .. "_negative_messages") or "Start" .. chaos_type .. "GreatGameCorruptionTriggers",								-- negative target message(s)
				narrative.get(faction_key, name .. "_corruption_key") or chaos_corruption_type,																	-- corruption type
				narrative.get(faction_key, name .. "_threshold_value") or CORRUPTION_THRESHOLD_CHAOS_CULTS_CAN_SPAWN,											-- threshold value
				narrative.get(faction_key, name .. "_culture_to_exclude") or culture,																			-- culture to exclude
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Pre Spread Corruption Trigger
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = chaos_type_lower .. "_great_game_pre_spread_corruption_trigger";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.corruption_in_adjacent_region(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "Start" .. chaos_type .. "GreatGameCorruptionTriggers",								-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "Start" .. chaos_type .. "GreatGameCorruptionMission",								-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_corruption_type") or chaos_corruption_type,																-- corruption type
				narrative.get(faction_key, name .. "_threshold_value") or CORRUPTION_THRESHOLD_CHAOS_CULTS_CAN_SPAWN - 20,										-- threshold value
				narrative.get(faction_key, name .. "_culture_to_exclude") or culture																			-- culture to exclude
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown before Spread Corruption Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = chaos_type_lower .. "_great_game_pre_spread_corruption_turn_countdown_trigger";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "Start" .. chaos_type .. "GreatGameCorruptionTriggers",								-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "Start" .. chaos_type .. "GreatGameCorruptionMission",								-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 4,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Spread Corruption Mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = chaos_type_lower .. "_great_game_event_spread_corruption";

		local prepend_str = shared_prepend_str .. "_" .. chaos_type_lower;
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.spread_corruption_to_adjacent_region(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or prepend_str .. "_spread_corruption_01",													-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or prepend_str .. "_spread_corruption_01",													-- key of mission to deliver
				narrative.get(faction_key, name .. "_corruption_key") or chaos_corruption_type,																	-- corruption key
				narrative.get(faction_key, name .. "_threshold_value") or CORRUPTION_THRESHOLD_CHAOS_CULTS_CAN_SPAWN,											-- threshold value
				narrative.get(faction_key, name .. "_culture_to_exclude") or culture,																			-- culture to exclude
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_spread_corruption_" .. chaos_type_lower,			-- mission text
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						3000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "high",																																	-- value of this mission
							glory_type = chaos_type_lower																													-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "Start" .. chaos_type .. "GreatGameCorruptionMission",								-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or chaos_type .. "GreatGameCorruptionSpread",											-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Unlock Unholy Manifestation mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = chaos_type_lower .. "_great_game_event_unlock_unholy_manifestation";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_chaos_unholy_manifestations_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_unlock_unholy_manifestation",					-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventHumanFactionTurnStart",
						condition =	function(context)
							return unlock_unholy_manifestation_condition(context, faction_key);
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(2000, faction_key),																												-- issue money
					payload.ancillary_mission_payload(faction_key, "talisman", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or chaos_type .. "GreatGameCorruptionSpread",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);

		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Chaos Cult Established Trigger
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = chaos_type_lower .. "_great_game_chaos_cult_trigger";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.foreign_slot_established(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or chaos_type .. "GreatGameCorruptionSpread",												-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "Start" .. chaos_type .. "GreatGameChaosCultBuildingMission",							-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_should_be_allied") or false																				-- should be an allied foreign slot
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Construct Cult Building Mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = chaos_type_lower .. "_great_game_event_construct_cult_building";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.construct_foreign_slot_building(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_chaos_construct_cult_building_01",									-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_" .. chaos_type_lower .. "_construct_cult_building_01",			-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_construct_chaos_cult_building",					-- mission text
				narrative.get(faction_key, name .. "_should_be_allied") or false,																				-- mission text
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						500,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "low",																																-- value of this mission
							glory_type = chaos_type_lower																													-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "Start" .. chaos_type .. "GreatGameChaosCultBuildingMission",						-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or chaos_type .. "GreatGameChaosCultBuildingMissionCompleted",						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")	or {																						-- list of other narrative events to inherit rewards from (may be nil)
					chaos_type_lower .. "_great_game_event_spread_corruption"
				}
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = chaos_type_lower .. "_great_game_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or advice_history_string,																			-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or chaos_type .. "GreatGameChaosCultBuildingMissionCompleted",							-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;











	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Pre Unlock Unholy Manifestation Corruption Trigger
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = chaos_type_lower .. "_great_game_pre_expert_unlock_unholy_manifestation_trigger";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.corruption_in_adjacent_region(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "Start" .. chaos_type .. "GreatGameChainExpert",										-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "Start" .. chaos_type .. "GreatGameUnlockUnholyManifestationExpert",					-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_corruption_type") or chaos_corruption_type,																-- corruption type
				narrative.get(faction_key, name .. "_threshold_value") or CORRUPTION_THRESHOLD_CHAOS_CULTS_CAN_SPAWN,											-- threshold value
				narrative.get(faction_key, name .. "_culture_to_exclude") or culture																			-- culture to exclude
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Pre Unlock Unholy Manifestation Turn Countdown Trigger
	-----------------------------------------------------------------------------------------------------------

	do
		local name = chaos_type_lower .. "_great_game_pre_expert_unlock_unholy_manifestation_turn_countdown_trigger";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "Start" .. chaos_type .. "GreatGameChainExpert",										-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "Start" .. chaos_type .. "GreatGameUnlockUnholyManifestationExpert",					-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 21,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;

	
	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Unlock Unholy Manifestation mission
	--	Mission triggered only in expert mode
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = chaos_type_lower .. "_great_game_event_unlock_unholy_manifestation_expert";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_chaos_unholy_manifestations_02",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_unlock_unholy_manifestation",					-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventHumanFactionTurnStart",
						condition =	function(context)
							return unlock_unholy_manifestation_condition(context, faction_key);
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(500, faction_key)																													-- issue money
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "Start" .. chaos_type .. "GreatGameUnlockUnholyManifestationExpert",					-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list") or {																						-- list of other narrative events to inherit rewards from (may be nil)
					chaos_type_lower .. "_great_game_event_spread_corruption",
					chaos_type_lower .. "_great_game_event_unlock_unholy_manifestation",
					chaos_type_lower .. "_great_game_event_construct_cult_building"
				}
			);

		end;
	end;






	narrative.output_chain_footer();

end;



