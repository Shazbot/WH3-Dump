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

out.narrative("* wh3_narrative_nurgle.lua loaded");

local shared_prepend_str = shared_narrative_event_prepend_str;






------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	PLAGUES
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function nurgle_plagues_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("nurgle plagues", faction_key);

	






	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "nurgle_plagues_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartNurglePlaguesChainExpert",													-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartNurglePlaguesChainFull",														-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					shared_prepend_str .. "_nurgle_plagues_chain_completed"
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Pre Gain Devotion Trigger, trigger by Turn Countdown
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "nurgle_plagues_pre_concoct_plague_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartNurglePlaguesChainFull",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartNurglePlaguesPreConcoctPlagueQuery",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 4,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Has Concocted Plague
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "nurgle_plagues_query_has_concocted_plague";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.has_concocted_plagues(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNurglePlaguesPreConcoctPlagueQuery",											-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartNurglePlaguesSpreadPlague",													-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartNurglePlaguesConcoctPlague",													-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_threshold_plagues") or 1,																					-- list of advice strings, positive message triggered if any are in advice history
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Concoct a Plague
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "nurgle_plagues_event_concoct_plague";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.concoct_plague(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_nurgle_spread_plague_01",											-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_nurgle_concoct_plague_01",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_total") or 1,																								-- total rituals to perform
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(1000, faction_key)																											-- issue money or equivalent
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNurglePlaguesConcoctPlague",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartNurglePlaguesSpreadPlague",													-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Spread Plagues
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "nurgle_plagues_event_spread_plagues";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.spread_plagues(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_nurgle_spread_plague_01",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_spread_plague",									-- key of mission objective
				narrative.get(faction_key, name .. "_total") or 1,																								-- number of infection events
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(1000, faction_key),																										-- issue money or equivalent
					payload.ancillary_mission_payload(faction_key, "weapon", "common")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNurglePlaguesSpreadPlague",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartNurglePlaguesPreUnlockSymptomsTunCountdown",									-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown After Spreading Plague
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "nurgle_plagues_pre_unlock_symptoms_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartNurglePlaguesPreUnlockSymptomsTunCountdown",										-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartNurglePlaguesUnlockSymptoms",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 1,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Unlock Symptoms
	-----------------------------------------------------------------------------------------------------------
--[[
	do
		local name = "nurgle_plagues_event_unlock_symptoms";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.unlock_symptoms(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_nurgle_unlock_symptoms_01",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_unlock_symptoms",								-- key of mission objective
				narrative.get(faction_key, name .. "_total") or 1,																								-- number of symptoms
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(2000, faction_key)																												-- issue money or equivalent
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNurglePlaguesUnlockSymptoms",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "NurglePlaguesUnlockSymptomsCompleted",											-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "nurgle_plagues_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or shared_prepend_str .. "_nurgle_plagues_chain_completed",											-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "NurglePlaguesUnlockSymptomsCompleted",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown After Unlocking Symptoms
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "nurgle_plagues_post_unlocking_symptoms_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "NurglePlaguesUnlockSymptomsCompleted",												-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartNurglePlaguesUnlockManySymptoms",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 9,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;

]]














	narrative.todo_output("Add trigger for unlocking symptoms");
--REMOVED MISSION AS IT IS LONGER VALID FOR NEW PLAGUE SYSTEM
--[[	
	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn Countdown Pre Unlock Many Symptoms
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "nurgle_plagues_pre_unlocking_many_symptoms_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartNurglePlaguesChainExpert",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartNurglePlaguesUnlockManySymptoms",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 15,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Unlock Many Symptoms
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "nurgle_plagues_event_unlock_many_symptoms";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.unlock_symptoms(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_nurgle_unlock_symptoms_02",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_unlock_many_symptoms",							-- key of mission objective
				narrative.get(faction_key, name .. "_total") or 10,																								-- number of symptoms
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(2000, faction_key),																												-- issue money or equivalent
					payload.ancillary_mission_payload(faction_key, "armour", "rare")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNurglePlaguesUnlockManySymptoms",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;

]]




	narrative.output_chain_footer();

end;












------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	GROWTH
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function nurgle_growth_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("nurgle growth", faction_key);








	-----------------------------------------------------------------------------------------------------------
	--	Turn countdown before Low Corruption Trigger
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "nurgle_growth_pre_low_corruption_trigger_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartNarrativeEvents",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartNurgleGrowthLowCorruptionTrigger",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 4,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Low Corruption Trigger
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "nurgle_growth_low_corruption_trigger";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartNurgleGrowthLowCorruptionTrigger",												-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartNurgleGrowthRaiseCorruptionMission",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "FactionTurnStart",																				-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						local faction = context:faction();
						if faction:name() == faction_key then
							for i, region in model_pairs(faction:region_list()) do
								if cm:get_corruption_value_in_region(region, "wh3_main_corruption_nurgle") < 40 then
									return true;
								end;
							end;
						end;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;

	
	-----------------------------------------------------------------------------------------------------------
	-- Raise Corruption at home
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "nurgle_growth_raise_corruption";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_nurgle_increase_growth_01",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_nurgle_growth_01",												-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_raise_nurgle_corruption",						-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventHumanFactionTurnStart",
						condition =	function(context)
							local faction = context:faction(); 
							if faction:name() == faction_key then
								for i, region in model_pairs(faction:region_list()) do
									if cm:get_corruption_value_in_region(region, "wh3_main_corruption_nurgle") >= 70 then
										return true;
									end
								end;
							end;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						-- Return the region with the lowest Nurgle corruption
						local lowest_corruption = 5000;
						local lowest_corruption_region = false;
						local faction = cm:get_faction(faction_key);
						for i, region in model_pairs(faction:region_list()) do
							local current_corruption = cm:get_corruption_value_in_region(region, "wh3_main_corruption_nurgle");
							if current_corruption < lowest_corruption then
								lowest_corruption_region = region;
								lowest_corruption = current_corruption;
							end;
						end;

						if lowest_corruption_region then
							return lowest_corruption_region:name();
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(2000, faction_key),																												-- issue money
					payload.ancillary_mission_payload(faction_key, "enchanted_item", "common")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNurgleGrowthRaiseCorruptionMission",											-- script message(s) on which to trigger when received
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
--	CYCLICAL BUILDINGS
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function nurgle_cyclical_buildings_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("nurgle cyclical buildings", faction_key);

	local advice_history_string = shared_prepend_str .. "_nurgle_cyclical_buildings_chain_completed";













	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "nurgle_cyclical_buildings_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartNurgleCyclicalBuildingsChainExpert",											-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartNurgleCyclicalBuildingsChainFull",											-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					advice_history_string
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre-Construct Cyclical Building
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "nurgle_cyclical_buildings_trigger_pre_construct_building_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartNurgleCyclicalBuildingsChainFull",												-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartNurgleCyclicalBuildingsConstructCyclicalBuilding",								-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "NurgleCyclicalBuildingsCyclicalBuildingConstructed",									-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 11,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Trigger on Constructed Cyclical Building
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "nurgle_cyclical_buildings_trigger_has_constructed_cyclical_building";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartNurgleCyclicalBuildingsChainFull",												-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or {																						-- target message(s) to trigger
					"NurgleCyclicalBuildingsCyclicalBuildingConstructed",
					"StartNurgleCyclicalBuildingsTransitionToExpert"
				},
				narrative.get(faction_key, name .. "_cancel_messages") or "StartNurgleCyclicalBuildingsConstructCyclicalBuilding",								-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "BuildingCompleted",																			-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						local building = context:building();
						return building:has_lifecycle() and building:faction():name() == faction_key;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Construct Cyclical Building Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "nurgle_cyclical_buildings_event_construct_cyclical_building";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_nurgle_construct_cyclical_building_01",							-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_nurgle_cyclical_buildings_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_construct_cyclical_building",					-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "BuildingCompleted",
						condition =	function(context)
							local building = context:building();
							return building:has_lifecycle() and building:faction():name() == faction_key;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						local faction = cm:get_faction(faction_key);
						if faction then
							local settlement = cm:get_highest_level_settlement_for_faction(faction);
							if settlement then
								return settlement:region():name();
							end;
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(750, faction_key)																												-- issue money
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNurgleCyclicalBuildingsConstructCyclicalBuilding",								-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartNurgleCyclicalBuildingsTransitionToExpert",									-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "nurgle_cyclical_buildings_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or advice_history_string,																			-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNurgleCyclicalBuildingsTransitionToExpert",									-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;













	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn Countdown pre-Complete Cyclical Building
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "nurgle_cyclical_buildings_trigger_pre_complete_building_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {																						-- script message(s) on which to start
					"StartNurgleCyclicalBuildingsChainExpert",
					"StartNurgleCyclicalBuildingsTransitionToExpert",
				},
				narrative.get(faction_key, name .. "_target_messages") or "StartNurgleCyclicalBuildingsCompleteCyclicalBuilding",								-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 12,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Complete Cyclical Building Lifecycle Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "nurgle_cyclical_buildings_event_complete_cyclical_building_lifecycle";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_nurgle_cyclical_buildings_02",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_develop_cyclical_building",						-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "BuildingLifecycleDevelops",
						condition =	function(context)
							if context:has_restarted() and context:region():owning_faction():name() == faction_key then
								-- return true if the previous building level had no upgrades i.e. it was the top-level cyclical building
								local upgrades = cm:get_building_level_upgrades(context:previous());
								return #upgrades == 0;
							end;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(2000, faction_key),																												-- issue money
					payload.ancillary_mission_payload(faction_key, "armour", "rare")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNurgleCyclicalBuildingsCompleteCyclicalBuilding",								-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartNurgleCyclicalBuildingsTransitionToExpert",									-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")	or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"nurgle_cyclical_buildings_event_construct_cyclical_building"
				}
			);
		end;
	end;







	narrative.output_chain_footer();

end;










------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	GREAT GAME
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function nurgle_great_game_narrative_loader(faction_key)
	great_game_narrative_loader(
		faction_key, 
		"Nurgle",							-- chaos type name (for script messages)
		"wh3_main_corruption_nurgle", 		-- corruption pooled resource key
		"wh3_main_nur_nurgle"				-- culture
	);
end;











------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	PLAGUELORD'S BLESSINGS
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function nurgle_plaguelords_blessings_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("nurgle plaguelords blessings", faction_key);

	narrative.unimplemented_output("nurgle plaguelords blessings");

	-- check whether any techs contribute to this

	narrative.output_chain_footer();

end;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	TAMURKHAN'S NARRATIVE MISSIONS
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

tamurkhan_narrative_missions = {}

tamurkhan_narrative_missions.chieftain_hero =
{
	mission = "wh3_dlc25_camp_narrative_nurgle_chieftain_hero",
	objective_text = "wh3_dlc25_camp_narrative_mission_description_nurgle_chieftain_hero", 
	reward = {
		payload.money_direct(1000)
	},
	chieftain_key = "wh3_dlc25_nur_kayzk_the_befouled",
	chieftain_recruited = nil
}

tamurkhan_narrative_missions.chieftain_unit =
{
	advice = "wh3_dlc25_tamurkhan_cam_mission_chieftain_unit_001",
	mission = "wh3_dlc25_camp_narrative_nurgle_chieftain_unit",
	objective_text = "wh3_dlc25_camp_narrative_mission_description_nurgle_chieftain_unit",
	reward = {
		payload.pooled_resource_mission_payload("wh3_dlc25_chieftain_dominance", "wh3_dlc25_dominance_gain_events", 2), 
		payload.money_direct(2000)
	},
	unit_keys = {
		--wh3_dlc25_nur_kayzk_the_befouled
			"wh3_dlc25_nur_chieftain_cav_chaos_chariot_mnur",
			"wh3_dlc25_nur_chieftain_cav_rot_knights",
			"wh3_dlc25_nur_chieftain_mon_toad_dragon",

		--wh3_dlc25_nur_bray_shaman_wild_chieftain
			"wh3_dlc25_nur_chieftain_inf_centigors_1",
			"wh3_dlc25_nur_chieftain_inf_cygor_0",
			"wh3_dlc25_nur_chieftain_mon_ghorgon",

		--wh3_dlc25_nur_fimir_balefiend_shadow_chieftain
			"wh3_dlc25_nur_chieftain_mon_fimir_0",
			"wh3_dlc25_nur_chieftain_mon_fimir_1",
			"wh3_dlc25_nur_chieftain_mon_frost_wyrm_0",

		--wh3_dlc25_nur_skin_wolf_werekin_chieftain
			"wh3_dlc25_nur_chieftain_mon_skinwolves_0",
			"wh3_dlc25_nur_chieftain_mon_war_mammoth_0",
			"wh3_dlc25_nur_chieftain_mon_war_mammoth_1",

		--wh3_dlc25_nur_castellan_chieftain
			"wh3_dlc25_nur_chieftain_inf_chaos_dwarf_blunderbusses",
			"wh3_dlc25_nur_chieftain_inf_infernal_guard_fireglaives",
			"wh3_dlc25_nur_chieftain_veh_dreadquake_mortar",

		--wh3_dlc25_nur_exalted_hero_chieftain
			"wh3_dlc25_nur_chieftain_inf_aspiring_champions_0",
			"wh3_dlc25_nur_chieftain_art_hellcannon",
			"wh3_dlc25_nur_chieftain_mon_dragon_ogre_shaggoth",
	}
}

tamurkhan_narrative_missions.deference =
{
	advice = "wh3_dlc25_tamurkhan_cam_mission_deference_001",
	mission = "wh3_dlc25_camp_narrative_nurgle_deference",
	objective_text = "wh3_dlc25_camp_narrative_mission_description_nurgle_deference", 
	reward = {
		payload.pooled_resource_mission_payload("wh3_dlc25_chieftain_dominance", "wh3_dlc25_dominance_gain_events", 4), 
		payload.money_direct(3000)
	},
	deference_key = "wh3_dlc25_chieftain_deference_kazyk",	
}

tamurkhan_narrative_missions.kill_khorne =
{
	mission = "wh3_dlc25_camp_narrative_nurgle_kill_khorne", 
	reward = {
		payload.pooled_resource_mission_payload("wh3_main_nur_infections", "missions", 200),
		payload.pooled_resource_mission_payload("wh3_dlc25_chieftain_dominance", "wh3_dlc25_dominance_gain_events", 2), 
		payload.money_direct(1000)
	},
	faction_key = "wh3_main_kho_crimson_skull",
}

tamurkhan_narrative_missions.kill_tzeentch =
{
	advice = "wh3_dlc25_tamurkhan_cam_mission_kill_tzeentch_001",
	mission = "wh3_dlc25_camp_narrative_nurgle_kill_tzeentch",
	reward = {
		payload.pooled_resource_mission_payload("wh3_main_nur_infections", "missions", 400), 
		payload.pooled_resource_mission_payload("wh3_dlc25_chieftain_dominance", "wh3_dlc25_dominance_gain_events", 4), 
		payload.money_direct(2000)
	},
	faction_key = "wh3_main_tze_flaming_scribes",
}


local function tamurkhan_narrative_events(faction_key)
	----------------------------------------------------
	--				TAMURKHAN CHIEFTAINS			  --
	----------------------------------------------------
	
	-----------------------------------------------------------------------------------------------------------
	--	Chieftain Unit
	-----------------------------------------------------------------------------------------------------------
	do
		local name = "tamurkhan_chieftain_unit_turn_countdown"

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"ScriptEventStartTamurkhan_ChieftainHero",					-- script message(s) on which to start
				"ScriptEvent_StartChieftainUnitMission",					-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				1,															-- num turns to wait
				true														-- trigger immediately
			)
		end
	end

	-----------------------------------------------------------------------------------------------------------
	--	Chieftain Deference
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "tamurkhan_deference_turn_countdown"

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"ScriptEventStartTamurkhan_ChieftainHero",					-- script message(s) on which to start
				"ScriptEventStartTamurkhan_Deference",						-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				2,															-- num turns to wait
				true														-- trigger immediately
			)
		end
	end

	----------------------------------------------------
	--					DEFEAT FACTIONS				  --
	----------------------------------------------------
	if cm:get_campaign_name() == "wh3_main_chaos" then
		-----------------------------------------------------------------------------------------------------------
		--	Kill Khorne
		-----------------------------------------------------------------------------------------------------------
		do
			local name = "tamurkhan_kill_khorne_turn_countdown"

			if not narrative.get(faction_key, name .. "_block") then
				narrative_triggers.turn_countdown(
					name,														-- unique name for this narrative trigger
					faction_key,												-- key of faction to which it applies
					"StartNarrativeEvents",										-- script message(s) on which to start
					"ScriptEventStartTamurkhan_KillKhorne",						-- target message(s) to trigger
					nil,														-- script message(s) on which to cancel
					1,															-- num turns to wait
					true														-- trigger immediately
				)
			end
		end
		
		-----------------------------------------------------------------------------------------------------------
		--	Kill Tzeentch
		-----------------------------------------------------------------------------------------------------------
		do
			local name = "tamurkhan_kill_tzeentch_turn_countdown"

			if not narrative.get(faction_key, name .. "_block") then
				narrative_triggers.turn_countdown(
					name,														-- unique name for this narrative trigger
					faction_key,												-- key of faction to which it applies
					"ScriptEventStartTamurkhan_KhorneKilled",					-- script message(s) on which to start
					"ScriptEventStartTamurkhan_KillTzeentch",					-- target message(s) to trigger
					nil,														-- script message(s) on which to cancel
					1,															-- num turns to wait
					true														-- trigger immediately
				)
			end
		end	
	end
	tamurkhan_narrative_missions:initialise(faction_key)

end

function tamurkhan_narrative_missions:initialise(faction_key)

	----------------------------------------------------
	--				TAMURKHAN CHIEFTAINS			  --
	----------------------------------------------------
	
	-----------------------------------------------------------------------------------------------------------
	--	Chieftain Hero
	-----------------------------------------------------------------------------------------------------------
	do
		local name = "tamurkhan_event_chieftain_hero"
		local mission_info = self.chieftain_hero

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				nil,														-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.objective_text,								-- key of mission objective text
				{															-- event/condition listeners
					{
						event = "UniqueAgentSpawned",
						condition =	function(context)
							return context:unique_agent_details():character():character_subtype_key() == mission_info.chieftain_key							
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"StartNarrativeEvents",										-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				"ScriptEventStartTamurkhan_ChieftainHero",					-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			)
		end
	end

	-----------------------------------------------------------------------------------------------------------
	--	Chieftain Units
	-----------------------------------------------------------------------------------------------------------
	do
		local name = "tamurkhan_event_chieftain_unit"
		local mission_info = self.chieftain_unit		

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				mission_info.advice,										-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.objective_text,								-- key of mission objective text
				{															-- event/condition listeners
					{
						event = "UnitCreated",
						condition =	function(context)
							local unit_key = context:unit():unit_key()
							local chieftain_units = mission_info.unit_keys
							for i = 1, #chieftain_units do
								if unit_key == chieftain_units[i] then
									return true
								end
							end
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEvent_StartChieftainUnitMission",					-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			)
		end

	end

	-----------------------------------------------------------------------------------------------------------
	--	Chieftain Deference
	-----------------------------------------------------------------------------------------------------------
	do
		local name = "tamurkhan_event_deference"
		local mission_info = self.deference		

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				mission_info.advice,										-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.objective_text,								-- key of mission objective text
				{															-- event/condition listeners
					{
						event = "PooledResourceChanged",
						condition =	function(context)
							local resource = context:resource()							
							if resource:key() == mission_info.deference_key then									
								if context:faction():name() == faction_key and resource:value() >= 7 then
									return true
								end
							end							
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartTamurkhan_Deference",						-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			)
		end
	end

	----------------------------------------------------
	--			 	 DEFEAT FACTIONS	 			  --
	----------------------------------------------------

	-----------------------------------------------------------------------------------------------------------
	--	Kill Khorne
	-----------------------------------------------------------------------------------------------------------
	do
		local name = "tamurkhan_event_kill_khorne"
		local mission_info = self.kill_khorne

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.destroy_faction(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				nil,														-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.faction_key,									-- key of mission to target
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartTamurkhan_KillKhorne",						-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				"ScriptEventStartTamurkhan_KhorneKilled",					-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			)
		end
	end

	-----------------------------------------------------------------------------------------------------------
	--	Kill Tzeentch
	-----------------------------------------------------------------------------------------------------------
	do
		local name = "tamurkhan_event_kill_tzeentch"
		local mission_info = self.kill_tzeentch

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.destroy_faction(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				mission_info.advice,										-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.faction_key,									-- key of mission to target
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartTamurkhan_KillTzeentch",					-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			)
		end
	end


end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	Start all Chains
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function start_nurgle_narrative_events(faction_key)

	nurgle_plagues_narrative_loader(faction_key);
	nurgle_growth_narrative_loader(faction_key);
	nurgle_cyclical_buildings_narrative_loader(faction_key);
	nurgle_great_game_narrative_loader(faction_key);
	nurgle_plaguelords_blessings_narrative_loader(faction_key);
	chaos_movements_narrative_loader(faction_key);

	if faction_key == "wh3_dlc25_nur_tamurkhan" then
		tamurkhan_narrative_events(faction_key)
	end

end;


-- Ensure that these narrative events are started for any player-controlled faction matching the culture
narrative.add_loader_for_culture("wh3_main_nur_nurgle", start_nurgle_narrative_events);