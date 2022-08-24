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

out.narrative("* wh3_narrative_khorne.lua loaded");

local shared_prepend_str = shared_narrative_event_prepend_str;






------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	SKULLS
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function khorne_skulls_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("khorne skulls", faction_key);

	local advice_history_string = shared_prepend_str .. "_skulls_chain_completed";


	-- Listen for the skulls being sent to the skull th unholy manifestation being used
	if not cm:get_saved_value(faction_key .. "_sent_skulls") then
		core:add_listener(
			"khorne_skulls_skull_throne_listener",
			"RitualStartedEvent",
			function(context)
				if context:performing_faction():name() == faction_key then
					local ritual_key = context:ritual():ritual_key();
					return ritual_key == "wh3_main_ritual_kho_the_skull_throne";
				end
			end,
			function()
				cm:set_saved_value(faction_key .. "_sent_skulls", true);
			end,
			false
		);
	end;


	-- Listen for combat trials stance being adopted
	if not cm:get_saved_value(faction_key .. "_adopted_combat_trials_stance") then
		core:add_listener(
			"khorne_skulls_combat_trials_stance_listener",
			"ScriptEventCombatTrialsStanceAdopted",
			function(context)
				return context:military_force():faction():name() == faction_key;
			end,
			function()
				cm:set_saved_value(faction_key .. "_adopted_combat_trials_stance", true);
			end,
			false
		);
	end;
	


	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "khorne_skulls_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartKhorneSkullsChainExpert",														-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartKhorneSkullsChainFull",														-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					advice_history_string
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre-Gain Skulls
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "khorne_skulls_trigger_pre_gain_skulls_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKhorneSkullsChainFull",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKhorneSkullsGainSkullsMission",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 4,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Gain 500 Skulls in battle
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "khorne_skulls_gain_skulls_in_battle";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_khorne_gain_skulls_01",											-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_khorne_skulls_01",												-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_collect_skulls_in_battle",						-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventTrackedPooledResourceChanged",
						condition =	function(context)
							return context:has_faction() and 
								context:faction():name() == faction_key and 
								context:resource():key() == "wh3_main_kho_skulls" and 
								context:factor():key() == "kills" and 
								context:factor_gained() >= 500;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						local char = cm:get_highest_ranked_general_for_faction(faction_key);
						if char then
							return char:command_queue_index();
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(1000, faction_key)																												-- issue money or equivalent
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKhorneSkullsGainSkullsMission",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or {																					-- script message(s) to trigger when this mission is completed
					"KhorneSkullsGainSkullsMissionCompleted",
					"StartKhorneSkullsQueryNarrativeEventsTriggered"
				},
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Has Sent Skulls to Skull Throne Query
	-----------------------------------------------------------------------------------------------------------

	do		
		local name = "khorne_skulls_query_skull_throne";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "KhorneSkullsGainSkullsMissionCompleted",												-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages"),																						-- message(s) on value exists
				narrative.get(faction_key, name .. "_negative_messages") or "StartKhorneSkullsSendSkullsMission",
				narrative.get(faction_key, name .. "_value_key") or faction_key .. "_sent_skulls",																-- value key
				narrative.get(faction_key, name .. "_condition")																								-- condition function
			);
		end;
	end;
	

	-----------------------------------------------------------------------------------------------------------
	-- Send Skulls to Skull Throne Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "khorne_skulls_event_skull_throne";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.perform_ritual_scripted(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_khorne_send_skulls_01",											-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_khorne_skull_throne_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_send_skulls_to_skull_throne",					-- key of mission objective
				narrative.get(faction_key, name .. "_total") or 1,																								-- total rituals to perform
				narrative.get(faction_key, name .. "_ritual_keys") or "wh3_main_ritual_kho_the_skull_throne",													-- ritual key(s)						
				narrative.get(faction_key, name .. "_ritual_category_keys"),																					-- ritual category key(s)
				narrative.get(faction_key, name .. "_target_faction_keys"),																						-- target faction key(s)
				narrative.get(faction_key, name .. "_listen_for_ritual_completed"),																				-- listen for ritual completing rather than starting
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(500, faction_key),
					payload.ancillary_mission_payload(faction_key, "armour", "common")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKhorneSkullsSendSkullsMission",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartKhorneSkullsQueryNarrativeEventsTriggered",									-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;















	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre-Collect Skull Piles
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "khorne_skulls_trigger_pre_skull_piles_mission_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKhorneSkullsChainFull",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKhorneSkullsUseSkullPileMission",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 12,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Trigger on Skull Pile created in adjacent region
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "khorne_skulls_trigger_skull_piles_mission_on_skull_pile_created";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKhorneSkullsChainFull",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKhorneSkullsUseSkullPileMission",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventSkullPileCreated",																	-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						if cm:region_adjacent_to_faction(context:region(), cm:get_faction(faction_key)) then
							narrative.add_data_for_faction(faction_key, "khorne_skulls_skull_pile_x", context:logical_position_x());
							narrative.add_data_for_faction(faction_key, "khorne_skulls_skull_pile_y", context:logical_position_y());
						end;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Gain 250 Skulls from Skull Pile
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "khorne_skulls_gain_skulls_from_skull_pile";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_khorne_gain_skulls_02",											-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_khorne_skull_piles_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_collect_skulls_skull_piles",						-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventTrackedPooledResourceChanged",
						condition =	function(context)
							return context:has_faction() and 
								context:faction():name() == faction_key and 
								context:resource():key() == "wh3_main_kho_skulls" and 
								context:factor():key() == "collected_from_skull_piles" and 
								context:factor_gained() >= 250;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						local log_x = narrative.get(faction_key, "khorne_skulls_skull_pile_x");
						local log_y = narrative.get(faction_key, "khorne_skulls_skull_pile_y");

						if log_x and log_y then
							local dis_x, dis_y = cm:log_to_dis(log_x, log_x);
							return {dis_x, dis_y};
						end;						
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(1000, faction_key),																												-- issue money or equivalent
					payload.ancillary_mission_payload(faction_key, "banner", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKhorneSkullsUseSkullPileMission",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartKhorneSkullsQueryNarrativeEventsTriggered",									-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;









	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre-Enter Combat Trials Stance
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "khorne_skulls_trigger_pre_combat_trials_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKhorneSkullsChainFull",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKhorneSkullsQueryCombatTrialsStanceUsage",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 15,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Has Entered Combat Trials Stance
	-----------------------------------------------------------------------------------------------------------

	do		
		local name = "khorne_skulls_query_has_entered_combat_trials_stance";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKhorneSkullsQueryCombatTrialsStanceUsage",										-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages"),																						-- message(s) on value exists
				narrative.get(faction_key, name .. "_negative_messages") or "StartKhorneSkullsEnterCombatTrialsStanceMission",
				narrative.get(faction_key, name .. "_value_key") or faction_key .. "_adopted_combat_trials_stance",												-- value key
				narrative.get(faction_key, name .. "_condition")																								-- condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Gain 250 Skulls from Combat Trials stance
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "khorne_skulls_enter_combat_trials_stance";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_khorne_combat_trials_01",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_use_combat_trials_stance",						-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventTrackedPooledResourceChanged",
						condition =	function(context)
							return context:has_faction() and
								context:faction():name() == faction_key and 
								context:resource():key() == "wh3_main_kho_skulls" and 
								context:factor():key() == "combat_trials" and 
								context:factor_gained() >= 30;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						local char = cm:get_highest_ranked_general_for_faction(faction_key);
						if char then
							return char:command_queue_index();
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(600, faction_key),																												-- issue money or equivalent
					payload.ancillary_mission_payload(faction_key, "talisman", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKhorneSkullsEnterCombatTrialsStanceMission",									-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartKhorneSkullsQueryNarrativeEventsTriggered",									-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;












	-----------------------------------------------------------------------------------------------------------
	--	Query whether all previous narrative events have been triggered
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "khorne_skulls_query_all_narrative_events_triggered";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.narrative_event_has_triggered(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKhorneSkullsQueryNarrativeEventsTriggered",									-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartKhorneSkullsTransitionToExpert",												-- positive target message(s) - player is one turn from completing province
				narrative.get(faction_key, name .. "_negative_messages"),																						-- negative target message(s) - player is not one turn from completing province
				narrative.get(faction_key, name .. "_ne_name") or {																								-- narrative event name(s)
					"khorne_skulls_gain_skulls_in_battle",
					"khorne_skulls_gain_skulls_from_skull_pile"
				},
				narrative.get(faction_key, name .. "_pass_on_all") or true,																						-- pass on all
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "khorne_skulls_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or advice_history_string,																			-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKhorneSkullsTransitionToExpert",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;


	












	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Expert Mode
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "khorne_skulls_trigger_turn_countdown_pre_send_many_skulls";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKhorneSkullsChainExpert",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKhorneSkullsSendManySkulls",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 19,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Transition to Expert
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "khorne_skulls_trigger_turn_countdown_transition_to_expert";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKhorneSkullsTransitionToExpert",													-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKhorneSkullsSendManySkulls",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 5,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Trigger Expert Mode Mission on Skulls Collected
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "khorne_skulls_trigger_send_many_skulls_on_skulls_sent";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {																						-- script message(s) on which to start
					"StartKhorneSkullsChainExpert",
					"StartKhorneSkullsTransitionToExpert"
				},
				narrative.get(faction_key, name .. "_target_messages") or "StartKhorneSkullsSendManySkulls",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventTrackedPooledResourceChanged",														-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						-- Trigger when faction gains a certain number of Devotees from Gifts of Slaanesh
						return context:has_faction() and
							context:faction():name() == faction_key and 
							context:resource():key() == "wh3_main_kho_skulls" and 
							context:factor():key() == "the_skull_throne" and 
							context:resource_spent() >= 3000;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Send Many Skulls to Skull Throne Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "khorne_skulls_event_send_many_skulls";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_khorne_skulls_02",												-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_send_many_skulls_to_skull_throne",				-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventTrackedPooledResourceChanged",
						condition =	function(context)
							return context:has_faction() and
								context:faction():name() == faction_key and 
								context:resource():key() == "wh3_main_kho_skulls" and 
								context:factor():key() == "the_skull_throne" and 
								context:resource_spent() >= 8000;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.ancillary_mission_payload(faction_key, "enchanted_item", "rare")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKhorneSkullsSendManySkulls",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")	or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"khorne_skulls_gain_skulls_in_battle",
					"khorne_skulls_event_skull_throne",
					"khorne_skulls_gain_skulls_from_skull_pile",
					"khorne_skulls_enter_combat_trials_stance"
				}
			);
		end;
	end;




	narrative.output_chain_footer();

end;












------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	WIN STREAKS
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function khorne_win_streaks_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("khorne win streaks", faction_key);


	local advice_history_string = shared_prepend_str .. "_win_streaks_chain_completed";


	-- Listen for the Eternal War unholy manifestation being used
	if not cm:get_saved_value(faction_key .. "_has_used_eternal_war") then
		core:add_listener(
			"khorne_win_streaks_eternal_war_listener",
			"RitualStartedEvent",
			function(context)
				if context:performing_faction():name() == faction_key then
					local ritual_key = context:ritual():ritual_key();
					return ritual_key == "wh3_main_ritual_kho_gg_1" or "wh3_main_ritual_kho_gg_1_upgraded";
				end
			end,
			function()
				cm:set_saved_value(faction_key .. "_has_used_eternal_war", true);
			end,
			false
		);
	end;


	local function check_win_streaks_of_faction(faction_key, threshold_value)
		local check_defenders = true;
		for i = 1, cm:pending_battle_cache_num_attackers() do
			local current_char_cqi, current_mf_cqi, current_faction_key = cm:pending_battle_cache_get_attacker(i);

			-- This script runs before the win streak value is updated after battle, so we have to add 1 ourselves if the attacker won
			local victory_offset = cm:pending_battle_cache_attacker_victory() and 1 or 0;

			if current_faction_key == faction_key then
				check_defenders = false;
				local current_mf = cm:get_military_force_by_cqi(current_mf_cqi);
				if current_mf then
					local streak_value = current_mf:lookup_streak_value("wh3_main_kho_win_streak") + victory_offset;
					if streak_value >= threshold_value then
						return true;	
					end;
				end;
			end;
		end;

		if check_defenders then
			for i = 1, cm:pending_battle_cache_num_defenders() do
				local current_char_cqi, current_mf_cqi, current_faction_key = cm:pending_battle_cache_get_defender(i);

				-- This script runs before the win streak value is updated after battle, so we have to add 1 ourselves if the defender won
				local victory_offset = cm:pending_battle_cache_defender_victory() and 1 or 0;

				if current_faction_key == faction_key then
					local current_mf = cm:get_military_force_by_cqi(current_mf_cqi);
					if current_mf then
						local streak_value = current_mf:lookup_streak_value("wh3_main_kho_win_streak");
						if streak_value >= threshold_value then
							return true;	
						end;
					end;
				end;
			end;
		end;
	end;
	


	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "khorne_win_streaks_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartKhorneWinStreaksChainExpert",													-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartKhorneWinStreaksChainFull",													-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					advice_history_string
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre-Gain Small Win Streak
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "khorne_win_streaks_trigger_pre_small_win_streak_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKhorneWinStreaksChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKhorneWinStreakGainSmallWinStreakMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 3,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Trigger Gain Small Win Streak on Win Streak
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "khorne_win_streaks_trigger_has_small_win_streak";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKhorneWinStreaksChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKhorneWinStreakGainSmallWinStreakMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "BattleCompletedCameraMove",																	-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						return check_win_streaks_of_faction(faction_key, 2);
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Gain Small Win Streak Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "khorne_win_streak_event_gain_small_win_streak_mission";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_khorne_gain_win_streak_01",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_khorne_bloodletting_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_gain_win_streak",								-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "BattleCompletedCameraMove",
						condition =	function(context)
							return check_win_streaks_of_faction(faction_key, 3);
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						local char = cm:get_highest_ranked_general_for_faction(faction_key);
						if char then
							return char:command_queue_index();
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(1000, faction_key)																												-- issue money
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKhorneWinStreakGainSmallWinStreakMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or "StartKhorneWinStreakEternalWarCountdown",											-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartKhorneWinStreakTransitionToExpert",											-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre-Eternal War Query
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "khorne_win_streaks_pre_eternal_war_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKhorneWinStreakEternalWarCountdown",												-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKhorneWinStreakEternalWarQuery",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 2,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Has Used Eternal War Unholy Manifestation Query
	-----------------------------------------------------------------------------------------------------------

	do		
		local name = "khorne_win_streaks_query_eternal_war";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKhorneWinStreakEternalWarQuery",												-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages"),																						-- message(s) on value exists
				narrative.get(faction_key, name .. "_negative_messages") or "StartKhorneWinStreakEternalWarMission",
				narrative.get(faction_key, name .. "_value_key") or faction_key .. "_has_used_eternal_war",														-- value key
				narrative.get(faction_key, name .. "_condition")																								-- condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Use Eternal War Unholy Manifestation
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "khorne_win_streaks_use_eternal_war_mission";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.perform_ritual_scripted(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_khorne_bloodletting_summon_army_01",								-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_use_eternal_war",								-- key of mission objective
				narrative.get(faction_key, name .. "_total") or 1,																								-- total rituals to perform
				narrative.get(faction_key, name .. "_ritual_keys") or {																							-- ritual key(s)						
					"wh3_main_ritual_kho_gg_1_upgraded",
					"wh3_main_ritual_kho_gg_1"
				},
				narrative.get(faction_key, name .. "_ritual_category_keys"),																					-- ritual category key(s)
				narrative.get(faction_key, name .. "_target_faction_keys"),																						-- target faction key(s)
				narrative.get(faction_key, name .. "_listen_for_ritual_completed") or false,																	-- listen for ritual completing rather than starting
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(500, faction_key)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKhorneWinStreakEternalWarMission",												-- script message(s) on which to trigger when received
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
		local name = "khorne_win_streak_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or advice_history_string,																			-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKhorneWinStreakTransitionToExpert",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;















	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Trigger Gain Large Win Streak on Win Streak
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "khorne_win_streaks_trigger_has_large_win_streak";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {"StartKhorneWinStreaksChainExpert", "StartKhorneWinStreakTransitionToExpert"},		-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKhorneWinStreakGainLargeWinStreakMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "BattleCompletedCameraMove",																	-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						return check_win_streaks_of_faction(faction_key, 5);
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- [EXPERT]	Turn Countdown pre-Gain Large Win Streak
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "khorne_win_streaks_trigger_pre_large_win_streak_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {"StartKhorneWinStreaksChainExpert", "StartKhorneWinStreakTransitionToExpert"},		-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKhorneWinStreakGainLargeWinStreakMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 22,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Gain Large Win Streak Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "khorne_win_streak_event_gain_large_win_streak_mission";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_khorne_bloodletting_02",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_gain_win_streak_large",							-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "BattleCompletedCameraMove",
						condition =	function(context)
							return check_win_streaks_of_faction(faction_key, 3);
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						local char = cm:get_highest_ranked_general_for_faction(faction_key);
						if char then
							return char:command_queue_index();
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(5000, faction_key),																												-- issue money
					payload.ancillary_mission_payload(faction_key, "weapon", "rare")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKhorneWinStreakGainLargeWinStreakMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartKhorneWinStreakTransitionToExpert",											-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list") or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"khorne_win_streak_event_gain_small_win_streak_mission",
					"khorne_win_streaks_use_eternal_war_mission"
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

local function khorne_great_game_narrative_loader(faction_key)
	great_game_narrative_loader(
		faction_key, 
		"Khorne",							-- chaos type name (for script messages)
		"wh3_main_corruption_khorne", 		-- corruption pooled resource key
		"wh3_main_kho_khorne"				-- culture
	);
end;











------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	BLOOD FOR THE BLOOD GOD
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function khorne_blood_for_the_blood_god_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("khorne blood for the blood god", faction_key);

	narrative.unimplemented_output("khorne blood for the blood god");

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


local function start_khorne_narrative_events(faction_key)

	khorne_skulls_narrative_loader(faction_key);
	khorne_win_streaks_narrative_loader(faction_key);
	khorne_great_game_narrative_loader(faction_key);
	khorne_blood_for_the_blood_god_narrative_loader(faction_key);
	chaos_movements_narrative_loader(faction_key);
end;


-- Ensure that these narrative events are started for any player-controlled faction matching the culture
narrative.add_loader_for_culture("wh3_main_kho_khorne", start_khorne_narrative_events);