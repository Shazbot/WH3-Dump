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
				narrative.get(faction_key, name .. "_num_turns") or 3,																							-- num turns to wait
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
















	narrative.todo_output("Add trigger for unlocking symptoms");

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
end;


-- Ensure that these narrative events are started for any player-controlled faction matching the culture
narrative.add_loader_for_culture("wh3_main_nur_nurgle", start_nurgle_narrative_events);