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

out.narrative("* wh3_narrative_cathay.lua loaded");

local shared_prepend_str = shared_narrative_event_prepend_str;






------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	HARMONY
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function cathay_harmony_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("cathay harmony", faction_key);

	





	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	--	Currently this advice query triggers the "full" mission set regardless, as we don't have many
	--	missions for Cathay
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "cathay_harmony_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartCathayHarmonyChainFull",														-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartCathayHarmonyChainFull",														-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					shared_prepend_str .. "_harmony_chain_completed"
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Harmony Too High
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "cathay_harmony_trigger_harmony_too_high";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.pooled_resource_gained(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartCathayHarmonyChainFull",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartCathayRestoreHarmony",															-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_pooled_resource_keys") or "wh3_main_cth_harmony",															-- pooled resource key
				narrative.get(faction_key, name .. "_threshold_value") or 4,																					-- threshold value
				narrative.get(faction_key, name .. "_less_than") or false																						-- less than rather than greater than
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Harmony Too Low
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "cathay_harmony_trigger_harmony_too_low";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.pooled_resource_gained(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartCathayHarmonyChainFull",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartCathayRestoreHarmony",															-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_pooled_resource_keys") or "wh3_main_cth_harmony",															-- pooled resource key
				narrative.get(faction_key, name .. "_threshold_value") or -4,																					-- threshold value
				narrative.get(faction_key, name .. "_less_than") or true																						-- less than rather than greater than
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Restore Harmony
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "cathay_harmony_event_restore_harmony";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.gain_pooled_resource_scripted(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_cathay_restore_harmony_01",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_cathay_restore_harmony_01",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_restore_harmony",								-- key of mission objective text
				narrative.get(faction_key, name .. "_pooled_resources") or "wh3_main_cth_harmony",																	-- pooled resource(s)
				narrative.get(faction_key, name .. "_lower_threshold") or 0,																					-- lower threshold value
				narrative.get(faction_key, name .. "_upper_threshold") or 0,																							-- upper threshold value
				narrative.get(faction_key, name .. "_is_additive") or false,																					-- is additive (value of all resources counts towards total)
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(1000)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartCathayRestoreHarmony",															-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre-Construct Harmony Buildings
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "cathay_harmony_trigger_pre_construct_buildings_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartCathayHarmonyChainFull",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartCathayHarmonyConstructBuildings",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 6,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Construct Five Harmony Buildings
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "cathay_harmony_event_construct_five_harmony_buildings";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.constructs_building_with_condition(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_cathay_construct_harmony_building_01",							-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_cathay_construct_harmony_buildings_01",							-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_construct_three_harmony_buildings",				-- key of mission objective text
				narrative.get(faction_key, name .. "_condition") or 																							-- condition per building
					function(building, ne)
						for _, effect in model_pairs(building:effects()) do
							local effect_key = effect:key();
							if effect_key == "wh3_main_pooled_resource_harmony_buildings_yang" or effect_key == "wh3_main_pooled_resource_harmony_buildings_yin" then
								return true;
							end;
						end;
					end,
				narrative.get(faction_key, name .. "_count") or 3,																								-- lower threshold value
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(3000),
					payload.ancillary_mission_payload(faction_key, "arcane_item", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartCathayHarmonyConstructBuildings",												-- script message(s) on which to trigger when received
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
--	COMPASS
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function cathay_compass_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("cathay compass", faction_key);



	-- Listen for Compass direction changes from this faction, increment a counter in the savegame, and trigger an event
	core:call_once(
		"cathay_compass_narrative_monitor_" .. faction_key,
		function()
			core:add_listener(
				"cathay_compass_narrative_monitor",
				"WoMCompassUserDirectionSelectedEvent",
				true,
				function(context)
					if context:faction():name() == faction_key then
						local saved_value_key = "compass_direction_changes_" .. faction_key;
						local num_direction_changes = cm:get_saved_value(saved_value_key) or 0;
						cm:set_saved_value(saved_value_key, num_direction_changes + 1);
						core:trigger_custom_event("ScriptEventWoMCompassUserDirectionSelected", {faction = context:faction(), direction = context:direction()});
					end;
				end,
				true
			);
		end
	);


	
	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "cathay_compass_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartCathayCompassChainExpert",													-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartCathayCompassChainFull",														-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					shared_prepend_str .. "_compass_chain_completed"
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre-Altered Compass Query
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "cathay_compass_trigger_pre_altered_compass_query_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartCathayCompassChainFull",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartCathayCompassAlteredCompassQuery",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 3,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Has Altered Compass
	-----------------------------------------------------------------------------------------------------------

	do		
		local name = "cathay_compass_query_has_altered_compass";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																-- unique name for this narrative query
				faction_key,																														-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartCathayCompassAlteredCompassQuery",									-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartCathayCompassTransitionToExpert",									-- message(s) on value exists
				narrative.get(faction_key, name .. "_negative_messages") or "StartCathayCompassAlterCompassMission",
				narrative.get(faction_key, name .. "_value_key") or "compass_direction_changes_" .. faction_key,									-- value key
				narrative.get(faction_key, name .. "_condition")																					-- condition function
			);
		end;
	end;

	
	-----------------------------------------------------------------------------------------------------------
	--	Alter Compass
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "cathay_compass_event_alter_compass";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_cathay_compass_01",												-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_change_compass_direction",						-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventWoMCompassUserDirectionSelected",
						condition =	function(context)
							return context:faction():name() == faction_key;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(750)																																	-- issue money
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartCathayCompassAlterCompassMission",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartCathayCompassTransitionToExpert",											-- script message(s) to trigger when this mission is completed
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
				narrative.get(faction_key, name .. "_key") or shared_prepend_str .. "_compass_chain_completed",													-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "StartCathayCompassTransitionToExpert",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;












	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn countdown before alter compass many times
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "cathay_compass_trigger_expert_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {"StartCathayCompassChainExpert", "StartCathayCompassTransitionToExpert"},				-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartCathayCompassAlterCompassMultipleMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 18,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Alter Compass Multiple Times
	-----------------------------------------------------------------------------------------------------------
	

	do
		local name = "cathay_compass_event_alter_compass_multiple";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_cathay_compass_02",												-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_change_compass_direction_multiple",				-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventWoMCompassUserDirectionSelected",
						condition =	function(context)
							return context:faction():name() == faction_key and cm:get_saved_value("compass_direction_changes_" .. faction_key) >= 4;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(750),																																	-- issue money
					payload.ancillary_mission_payload(faction_key, "armour", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartCathayCompassAlterCompassMultipleMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list") or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"cathay_compass_event_alter_compass"
				}
			);
		end;
	end;


	narrative.output_chain_footer();

end;













------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	IVORY ROAD
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function cathay_ivory_road_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("cathay ivory road", faction_key);
	




	
	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "cathay_ivory_road_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartCathayIvoryRoadChainExpert",													-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartCathayIvoryRoadChainFull",													-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					shared_prepend_str .. "_ivory_road_chain_completed"
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre-Has Dispatched Caravan
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "cathay_ivory_road_trigger_pre_has_dispatched_caravan_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartCathayIvoryRoadChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartCathayIvoryRoadHasDispatchedCaravanQuery",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 6,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Has Dispatched Caravan
	-----------------------------------------------------------------------------------------------------------

	do		
		local name = "cathay_ivory_road_query_has_dispatched_caravan";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartCathayIvoryRoadHasDispatchedCaravanQuery",										-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartCathayIvoryRoadTransitionToExpert",											-- message(s) on value exists
				narrative.get(faction_key, name .. "_negative_messages") or "StartCathayIvoryRoadDispatchCaravan",												-- message(s) on value doesn't exist
				narrative.get(faction_key, name .. "_value_key") or "caravans_dispatched_" .. faction_key,														-- value key
				narrative.get(faction_key, name .. "_condition")																								-- condition function
			);
		end;
	end;

	
	-----------------------------------------------------------------------------------------------------------
	--	Dispatch Caravan
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "cathay_ivory_road_event_dispatch_caravan";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_cathay_trade_caravan_01",											-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_cathay_ivory_road_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_dispatch_caravan",								-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "CaravanSpawned",
						condition =	function(context)
							return context:faction():name() == faction_key;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(750)																																-- issue money
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartCathayIvoryRoadDispatchCaravan",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartCathayIvoryRoadTransitionToExpert",											-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "cathay_ivory_road_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or shared_prepend_str .. "_ivory_road_chain_completed",												-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "StartCathayIvoryRoadTransitionToExpert",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;














	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn countdown before dispatch multiple caravans many times
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "cathay_ivory_road_trigger_expert_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {"StartCathayIvoryRoadChainExpert", "StartCathayIvoryRoadTransitionToExpert"},			-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartCathayIvoryRoadCompleteCaravanJourneys",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 18,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Complete Five Caravan Journeys
	-----------------------------------------------------------------------------------------------------------
	

	do
		local name = "cathay_ivory_road_event_complete_multiple_caravan_journeys";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_cathay_ivory_road_02",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_dispatch_caravans_multiple",						-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventCaravanCompleted",
						condition =	function(context)
							return context:faction():name() == faction_key and cm:get_saved_value("caravans_completed_" .. faction_key) >= 5;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(750),																																-- issue money
					payload.ancillary_mission_payload(faction_key, "banner", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartCathayIvoryRoadCompleteCaravanJourneys",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")	or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"cathay_ivory_road_event_dispatch_caravan"
				}
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


local function start_cathay_narrative_events(faction_key)

	cathay_harmony_narrative_loader(faction_key);
	cathay_compass_narrative_loader(faction_key);
	cathay_ivory_road_narrative_loader(faction_key);
end;


-- Ensure that these narrative events are started for any player-controlled faction matching the culture
narrative.add_loader_for_culture("wh3_main_cth_cathay", start_cathay_narrative_events);