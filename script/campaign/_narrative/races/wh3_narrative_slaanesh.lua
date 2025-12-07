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

out.narrative("* wh3_narrative_slaanesh.lua loaded");

local shared_prepend_str = shared_narrative_event_prepend_str;






------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	DEVOTEES
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function slaanesh_devotees_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("slaanesh devotees", faction_key);


	-- Listen for this faction proliferating cults and mark the savegame
	if not cm:get_saved_value("slaanesh_cults_proliferated_" .. faction_key) then
		core:add_listener(
			"slaanesh_devotees_narrative_monitor",
			"RitualStartedEvent",
			function(context)
				return context:performing_faction() == faction_key and context:ritual():ritual_key() == "wh3_main_ritual_sla_create_cults";
			end,
			function(context)
				cm:set_saved_value("slaanesh_cults_proliferated_" .. faction_key, true);
			end,
			false
		);
	end;

	-- Listen for this faction summoning disciple armies and mark the savegame
	if not cm:get_saved_value("disciple_army_summoned_" .. faction_key) then
		core:add_listener(
			"slaanesh_devotees_narrative_monitor",
			"MilitaryForceCreated",
			function(context)
				local mf = context:military_force_created();
				return mf:faction():name() == faction_key and mf:force_type():key() == "DISCIPLE_ARMY";
			end,
			function(context)
				cm:set_saved_value("disciple_army_summoned_" .. faction_key, true);
			end,
			false
		);
	end;

	-- Listen for this faction hosting pleasurable acts and mark the savegame
	if not cm:get_saved_value("pleasurable_act_hosted_" .. faction_key) then
		core:add_listener(
			"slaanesh_devotees_narrative_monitor",
			"RitualStartedEvent",
			function(context)
				return context:performing_faction() == faction_key and context:ritual():ritual_category() == "DEVOTEES_RITUAL";
			end,
			function(context)
				cm:set_saved_value("pleasurable_act_hosted_" .. faction_key, true);
			end,
			false
		);
	end;


	local advice_history_string = shared_prepend_str .. "_devotees_chain_completed";


	

	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_devotees_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSlaaneshDevoteesChainExpert",													-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartSlaaneshDevoteesChainFull",													-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					advice_history_string
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre Gain Devotees
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "slaanesh_devotees_pre_gain_devotees_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSlaaneshDevoteesChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSlaaneshDevoteesGainDevotees",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 3,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Devotees Close to threshold pre-Gain Devotees
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "slaanesh_devotees_trigger_pre_gain_devotees";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.pooled_resource_gained(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSlaaneshDevoteesChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSlaaneshDevoteesGainDevotees",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_pooled_resource_keys") or "wh3_main_sla_devotees",															-- pooled resource key
				narrative.get(faction_key, name .. "_threshold_value") or 750,																					-- threshold value
				narrative.get(faction_key, name .. "_less_than") or false																						-- less than rather than greater than
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Gain Devotees
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_devotees_event_gain_devotees";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.gain_pooled_resource(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_slaanesh_gain_devotees_01",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_slaanesh_devotees_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_resource_key") or "wh3_main_sla_devotees",																	-- pooled resource key
				narrative.get(faction_key, name .. "_quantity") or 1000,																						-- quantity
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(1000)																														-- issue money
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshDevoteesGainDevotees",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or "SlaaneshDevoteesGainDevoteesMissionIssued",										-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartSlaaneshDevoteesProliferatedCultsQuery",										-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Pre-Has Summoned Disciple Army Query
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "slaanesh_devotees_pre_summon_disciple_army_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "SlaaneshDevoteesGainDevoteesMissionIssued",											-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSlaaneshDevoteesDiscipleArmySummonedQuery",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 2,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Query Has Summoned Disciple Army
	-----------------------------------------------------------------------------------------------------------

	do		
		local name = "slaanesh_devotees_query_has_summoned_disciple_army";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshDevoteesDiscipleArmySummonedQuery",									-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages"),																						-- message(s) on value exists
				narrative.get(faction_key, name .. "_negative_messages") or "StartSlaaneshDevoteesSummonDiscipleArmyMission",
				narrative.get(faction_key, name .. "_value_key") or "disciple_army_summoned_" .. faction_key,													-- value key
				narrative.get(faction_key, name .. "_condition")																								-- condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Summon Disciple Army Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_devotees_event_summon_disciple_army";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_slaanesh_summon_disciple_army_01",								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_slaanesh_disciple_armies_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_summon_disciple_army",							-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "MilitaryForceCreated",
						condition =	function(context)
							local mf = context:military_force_created();
							return mf:faction():name() == faction_key and mf:force_type():key() == "DISCIPLE_ARMY";
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						local character = cm:get_closest_character_to_camera_from_faction(faction_key, true);
						if character then
							return character:command_queue_index();
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(1000),																														-- issue money
					payload.ancillary_mission_payload(faction_key, "talisman", "common")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshDevoteesSummonDiscipleArmyMission",									-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;

	
	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Pre-Has Hosted Pleasurable Acts Query
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "slaanesh_devotees_pre_host_pleasurable_act_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "SlaaneshDevoteesGainDevoteesMissionIssued",											-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSlaaneshDevoteesPleasurableActQuery",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 4,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Query Has Hosted Pleasurable Act
	-----------------------------------------------------------------------------------------------------------

	do		
		local name = "slaanesh_devotees_query_has_hosted_pleasurable_act";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshDevoteesPleasurableActQuery",											-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages"),																						-- message(s) on value exists
				narrative.get(faction_key, name .. "_negative_messages") or "StartSlaaneshDevoteesPleasurableActMission",
				narrative.get(faction_key, name .. "_value_key") or "pleasurable_act_hosted_" .. faction_key,													-- value key
				narrative.get(faction_key, name .. "_condition")																								-- condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Pleasurable Act Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_devotees_event_host_pleasurable_act";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.perform_ritual_scripted(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_slaanesh_pleasure_activity_01",									-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_slaanesh_pleasurable_acts_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_hold_pleasurable_act",							-- key of mission objective
				narrative.get(faction_key, name .. "_total") or 1,																								-- total rituals to perform
				narrative.get(faction_key, name .. "_ritual_keys"),																								-- ritual key(s)						
				narrative.get(faction_key, name .. "_ritual_category_keys") or "DEVOTEES_RITUAL",																-- ritual category key(s)
				narrative.get(faction_key, name .. "_target_faction_keys"),																						-- target faction key(s)
				narrative.get(faction_key, name .. "_listen_for_ritual_completed"),																				-- listen for ritual completing rather than starting
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(600, faction_key)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshDevoteesPleasurableActMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Query Has Proliferated Cults
	-----------------------------------------------------------------------------------------------------------

	do		
		local name = "slaanesh_devotees_query_has_proliferated_cults";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshDevoteesProliferatedCultsQuery",										-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages"),																						-- message(s) on value exists
				narrative.get(faction_key, name .. "_negative_messages") or "StartSlaaneshDevoteesProliferateCultsMission",
				narrative.get(faction_key, name .. "_value_key") or "slaanesh_cults_proliferated_" .. faction_key,												-- value key
				narrative.get(faction_key, name .. "_condition")																								-- condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Proliferate Cults Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_devotees_event_proliferate_cults";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.perform_ritual_scripted(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_slaanesh_establish_cult_01",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_slaanesh_proliferate_cults_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_proliferate_chaos_cults",						-- key of mission objective
				narrative.get(faction_key, name .. "_total") or 1,																								-- total rituals to perform
				narrative.get(faction_key, name .. "_ritual_keys") or "wh3_main_ritual_sla_create_cults",														-- ritual key(s)						
				narrative.get(faction_key, name .. "_ritual_category_keys"),																					-- ritual category key(s)
				narrative.get(faction_key, name .. "_target_faction_keys"),																						-- target faction key(s)
				narrative.get(faction_key, name .. "_listen_for_ritual_completed"),																				-- listen for ritual completing rather than starting
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(1000)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshDevoteesProliferateCultsMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "SlaaneshDevoteesTransitionToExpert",												-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_devotees_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or advice_history_string,																			-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "SlaaneshDevoteesTransitionToExpert",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;











	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn countdown before Earn Many Devotees Mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "slaanesh_devotees_trigger_expert_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {																						-- script message(s) on which to start
					"StartSlaaneshDevoteesChainExpert",
					"SlaaneshDevoteesTransitionToExpert"
				},
				narrative.get(faction_key, name .. "_target_messages") or "StartSlaaneshDevoteesEarnManyDevoteesMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 20,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Devotees Trigger For Earn Many Devotees Mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "slaanesh_devotees_trigger_expert_on_devotees";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {																						-- script message(s) on which to start
					"StartSlaaneshDevoteesChainExpert",
					"SlaaneshDevoteesTransitionToExpert"
				},
				narrative.get(faction_key, name .. "_target_messages") or "StartSlaaneshDevoteesEarnManyDevoteesMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventTrackedPooledResourceChanged",														-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						-- Trigger when faction gains a certain number of Devotees from Gifts of Slaanesh
						return context:has_faction() and
							context:faction():name() == faction_key and 
							context:resource():key() == "wh3_main_sla_devotees" and 
							context:resource_gained() >= 15000;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Earn Many Devotees Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_devotees_event_gain_many_devotees";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_slaanesh_devotees_02",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_gain_devotees_many",								-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventTrackedPooledResourceChanged",
						condition =	function(context)
							return context:resource():key() == "wh3_main_sla_devotees" and context:has_faction() and context:faction():name() == faction_key and context:resource_gained() >= 20000;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(2000),																														-- issue money
					payload.ancillary_mission_payload(faction_key, "banner", "rare")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshDevoteesEarnManyDevoteesMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list") or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"slaanesh_devotees_event_gain_devotees",
					"slaanesh_devotees_event_summon_disciple_army",
					"slaanesh_devotees_event_host_pleasurable_act",
					"slaanesh_devotees_event_proliferate_cults"
				}
			);
		end;
	end;




	narrative.output_chain_footer();

end;












------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	GIFTS OF SLAANESH
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function slaanesh_gifts_of_slaanesh_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("slaanesh gifts of slaanesh", faction_key);




	-- Listen for Gifts of Slaanesh being spread by this faction and mark the savegame	
	if not cm:get_saved_value("gift_of_slaanesh_spread_" .. faction_key) then
		core:add_listener(
			"slaanesh_gift_of_slaanesh_narrative_monitor",
			"FactionCharacterTagAddedEvent",
			function(context)
				return context:tagging_faction():name() == faction_key and context:tag_entry():tag_record_key() == "wh3_main_character_tag_gift_of_slaanesh";
			end,
			function(context)
				cm:set_saved_value("gift_of_slaanesh_spread_" .. faction_key, true);
			end,
			false
		);
	end;

	local advice_history_string = shared_prepend_str .. "_gift_of_slaanesh_chain_completed";





	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_gift_of_slaanesh_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSlaaneshGiftOfSlaaneshChainExpert",											-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartSlaaneshGiftOfSlaaneshChainFull",												-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					advice_history_string
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre Has Spread Gift of Slaanesh
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "slaanesh_gift_of_slaanesh_trigger_pre_has_spread_gift_query_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSlaaneshGiftOfSlaaneshChainFull",												-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSlaaneshGiftOfSlaaneshHasSpreadGiftQuery",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 11,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Has Spread Gift of Slaanesh
	-----------------------------------------------------------------------------------------------------------

	do		
		local name = "slaanesh_gift_of_slaanesh_query_has_spread_gift";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshGiftOfSlaaneshHasSpreadGiftQuery",										-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSlaaneshGiftOfSlaaneshTransitionToExpert",									-- message(s) on value exists
				narrative.get(faction_key, name .. "_negative_messages") or "StartSlaaneshGiftOfSlaaneshSpreadGiftMission",
				narrative.get(faction_key, name .. "_value_key") or "gift_of_slaanesh_spread_" .. faction_key,													-- value key
				narrative.get(faction_key, name .. "_condition")																								-- condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Spread a Gift of Slaanesh
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_gift_of_slaanesh_event_spread_gift";
		local character_tags = {
			"wh3_main_character_tag_gift_of_slaanesh",
			"wh3_dlc27_character_tag_gift_of_slaanesh_dechala",
			"wh3_dlc27_character_tag_gift_of_slaanesh_masque",
		}

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_slaanesh_bestow_gift_of_slaanesh_01",								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_slaanesh_gift_of_slaanesh_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_spread_gift_of_slaanesh",						-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "FactionCharacterTagAddedEvent",
						condition =	function(context)
							if context:tagging_faction():name() ~= faction_key then
								return false
							end

							local tag_record_key = context:tag_entry():tag_record_key()
							local is_valid_character_tag = table.find(character_tags, tag_record_key) ~= nil
							return is_valid_character_tag
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						local character = cm:get_closest_character_to_camera_from_faction(faction_key, true);
						if character then
							return character:command_queue_index();
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(2000, faction_key),																												-- issue money
					payload.ancillary_mission_payload(faction_key, "enchanted_item", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshGiftOfSlaaneshSpreadGiftMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartSlaaneshGiftOfSlaaneshTransitionToExpert",									-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_gift_of_slaanesh_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or advice_history_string,																			-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshGiftOfSlaaneshTransitionToExpert",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;











	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn countdown before Earn Devotees from Gift of Slaanesh Mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "slaanesh_gift_of_slaanesh_trigger_expert_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {																						-- script message(s) on which to start
					"StartSlaaneshGiftOfSlaaneshChainExpert",
					"StartSlaaneshGiftOfSlaaneshTransitionToExpert"
				},
				narrative.get(faction_key, name .. "_target_messages") or "StartSlaaneshGiftOfSlaaneshEarnDevoteesMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 20,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Devotees Trigger For Earn Devotees from Gift of Slaanesh Mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "slaanesh_gift_of_slaanesh_trigger_expert_on_devotees";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {																						-- script message(s) on which to start
					"StartSlaaneshGiftOfSlaaneshChainExpert",
					"StartSlaaneshGiftOfSlaaneshTransitionToExpert"
				},
				narrative.get(faction_key, name .. "_target_messages") or "StartSlaaneshGiftOfSlaaneshEarnDevoteesMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventTrackedPooledResourceChanged",														-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						-- Trigger when faction gains a certain number of Devotees from Gifts of Slaanesh
						return context:has_faction() and
							context:faction():name() == faction_key and 
							context:resource():key() == "wh3_main_sla_devotees" and 
							context:factor():key() == "gift_of_slaanesh" and 
							context:factor_gained() >= 220;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Earn Devotees from Gift of Slaanesh Mission
	-----------------------------------------------------------------------------------------------------------

	do		
		local name = "slaanesh_gift_of_slaanesh_earn_devotees_from_gifts";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_slaanesh_gift_of_slaanesh_02",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_earn_devotees_gift_of_slaanesh",					-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventTrackedPooledResourceChanged",
						condition =	function(context)
							return context:has_faction() and
								context:faction():name() == faction_key and 
								context:resource():key() == "wh3_main_sla_devotees" and 
								context:factor():key() == "gift_of_slaanesh" and 
								context:factor_gained() >= 300;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),	 																				-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(4000)																														-- issue money or equivalent
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshGiftOfSlaaneshEarnDevoteesMission",									-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")	or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"slaanesh_gift_of_slaanesh_event_spread_gift"
				}
			);
		end;
	end;




	narrative.output_chain_footer();

end;











------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	SEDUCTION (PROMISE OF PERFECTION)
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function slaanesh_seduction_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("slaanesh seduction", faction_key);



	-- Listen for unit seduction for this faction and mark the savegame	
	if not cm:get_saved_value("unit_bribed_" .. faction_key) then
		core:add_listener(
			"slaanesh_seduction_narrative_monitor",
			"FactionBribesUnit",
			function(context)
				return context:faction():name() == faction_key;
			end,
			function(context)
				cm:set_saved_value("unit_bribed_" .. faction_key, true);
			end,
			false
		);
	end;

	local advice_history_string = shared_prepend_str .. "_seduction_chain_completed";




	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_seduction_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSlaaneshSeductionChainExpert",												-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartSlaaneshSeductionChainFull",													-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					advice_history_string
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre Has Seduced Unit Query
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "slaanesh_seduction_trigger_pre_has_seduced_unit_query_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSlaaneshSeductionChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSlaaneshSeductionHasSeducedUnitQuery",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 9,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Has Seduced Unit
	-----------------------------------------------------------------------------------------------------------

	do		
		local name = "slaanesh_seduction_query_has_seduced_unit";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshSeductionHasSeducedUnitQuery",											-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSlaaneshSeductionTransitionToExpert",											-- message(s) on value exists
				narrative.get(faction_key, name .. "_negative_messages") or "StartSlaaneshSeductionSeduceUnitMission",
				narrative.get(faction_key, name .. "_value_key") or "unit_bribed_" .. faction_key,																-- value key
				narrative.get(faction_key, name .. "_condition")																								-- condition function
			);
		end;
	end;

	
	-----------------------------------------------------------------------------------------------------------
	-- Seduce a Unit
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_seduction_event_seduce_unit";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_slaanesh_promise_of_perfection_01",								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_slaanesh_seduction_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_seduce_units",									-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "FactionBribesUnit",
						condition =	function(context)
							return context:faction():name() == faction_key;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						local character = cm:get_closest_character_to_camera_from_faction(faction_key, true);
						if character then
							return character:command_queue_index();
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(750, faction_key)																													-- issue money
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshSeductionSeduceUnitMission",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartSlaaneshSeductionTransitionToExpert",										-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_seduction_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or advice_history_string,																			-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshSeductionTransitionToExpert",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;











	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn countdown before researching Seduce Units technology
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "slaanesh_seduction_trigger_expert_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {"StartSlaaneshSeductionChainExpert", "StartSlaaneshSeductionTransitionToExpert"},		-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSlaaneshSeductionResearchSeductionTech",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 15,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Research Seduce Unit Technology
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_seduction_research_seduction_technology";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.research_technology(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_slaanesh_seduction_02",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_num_technologies") or 1,																					-- num technologies
																		-- The Promise
				narrative.get(faction_key, name .. "_technologies") or "wh3_main_tech_sla_2_6",																	-- opt mandatory technologies
				narrative.get(faction_key, name .. "_include_existing") or false,																				-- includes existing technologies
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(3000, faction_key),																												-- issue money or equivalent
					payload.ancillary_mission_payload(faction_key, "armour", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshSeductionResearchSeductionTech",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")	or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"slaanesh_seduction_event_seduce_unit"
				}
			);
		end;
	end;



	narrative.output_chain_footer();

end;











------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	SEDUCTIVE INFLUENCE
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function slaanesh_seductive_influence_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("slaanesh seductive influence", faction_key);

	
	
	-- Listen for Gifts of Slaanesh being spread by this faction and mark the savegame	
	if not cm:get_saved_value("seductive_influence_unlocked_" .. faction_key) then
		core:add_listener(
			"slaanesh_seductive_influence_narrative_monitor",
			"PooledResourceEffectChangedEvent",
			function(context)
				return string.starts_with(context:new_effect(), "wh3_main_bundle_seductive_influence") and
					not string.starts_with(context:new_effect(), "wh3_main_bundle_seductive_influence_1") and
					not string.starts_with(context:new_effect(), "wh3_main_bundle_seductive_influence_2");
			end,
			function(context)
				cm:set_saved_value("seductive_influence_unlocked_" .. faction_key, true);
			end,	
			false
		);
	end;

	local advice_history_string = shared_prepend_str .. "_seductive_influence_chain_completed";


	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_seductive_influence_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSlaaneshSeductiveInfluenceChainExpert",										-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartSlaaneshSeductiveInfluenceChainFull",											-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					advice_history_string
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre Has Unlocked Seductive Influence Query
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "slaanesh_seductive_influence_trigger_pre_has_unlocked_option_query_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSlaaneshSeductiveInfluenceChainFull",											-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSlaaneshSeductiveInfluenceHasUnlockedOptionQuery",								-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 14,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Has Unlocked Seductive Influence Option
	-----------------------------------------------------------------------------------------------------------

	do		
		local name = "slaanesh_seductive_influence_query_has_unlocked_option";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshSeductiveInfluenceHasUnlockedOptionQuery",								-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or {																					-- message(s) on value exists
					"StartSlaaneshSeductiveInfluenceChainExpert",
					"SlaaneshSeductiveInfluenceMarkAdviceHistory"
				},
				narrative.get(faction_key, name .. "_negative_messages") or "StartSlaaneshSeductiveInfluenceUnlockOptionMission",
				narrative.get(faction_key, name .. "_value_key") or "seductive_influence_unlocked_" .. faction_key,												-- value key
				narrative.get(faction_key, name .. "_condition")																								-- condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Unlock Seductive Influence Diplomatic Option
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_seductive_influence_unlock_diplomatic_option";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_slaanesh_seductive_influence_01",									-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_slaanesh_seductive_influence_01",								-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_unlock_seductive_influence_diplomatic_option",	-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "PooledResourceEffectChangedEvent",
						condition =	function(context)
							return string.starts_with(context:new_effect(), "wh3_main_bundle_seductive_influence") and
								not string.starts_with(context:new_effect(), "wh3_main_bundle_seductive_influence_1") and
								not string.starts_with(context:new_effect(), "wh3_main_bundle_seductive_influence_2");
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"), 																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(4000, faction_key)																												-- issue money
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSlaaneshSeductiveInfluenceUnlockOptionMission",								-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or {																					-- script message(s) to trigger when this mission is completed
					"SlaaneshSeductiveInfluenceUnlockOptionMissionCompleted",
					"SlaaneshSeductiveInfluenceMarkAdviceHistory"
				},
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "slaanesh_seductive_influence_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or advice_history_string,																			-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "SlaaneshSeductiveInfluenceMarkAdviceHistory",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;














	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Seductive Influence Trigger For Unlock Max Seductive Influence Mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "slaanesh_seductive_influence_trigger_expert_on_options_unlocked";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {																						-- script message(s) on which to start
					-- We start this trigger when either full or expert messages are sent, as it's conceivable that the player satisfies this
					-- trigger before the first mission can be issued
					"StartSlaaneshSeductiveInfluenceChainFull",
					"StartSlaaneshSeductiveInfluenceChainExpert"
				},
				narrative.get(faction_key, name .. "_target_messages") or "StartSlaaneshSeductiveInfluenceGainMaxInfluenceMission",								-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "PooledResourceEffectChangedEvent",																-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					-- Unlock when Seductive Influence with any faction increases to the third bracket
					function(context)
						return string.starts_with(context:new_effect(), "wh3_main_bundle_seductive_influence_3");
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Seductive Influence Unlock Max Seductive Influence Mission
	-----------------------------------------------------------------------------------------------------------

	do		
		local name = "slaanesh_seductive_influence_earn_max_influence";

		local target_faction_key = false;

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_slaanesh_seductive_influence_02",									-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_slaanesh_seductive_influence_02",								-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_unlock_seductive_influence_vassalise_option",	-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "PooledResourceEffectChangedEvent",
						condition =	function(context)
							if string.starts_with(context:new_effect(), "wh3_main_bundle_seductive_influence_max") then
								if context:has_faction() then
									target_faction_key = context:faction():name();
								end;
								return true;
							end;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or 																				-- camera scroll callback
					function()
						-- Zoom to the closest character of the faction with the highest Seductive Influence value
						local faction = cm:get_faction(faction_key);
						local factions_met = faction:factions_met();
						local highest_si = 0;
						local highest_si_faction = false;

						for i, faction_met in model_pairs(factions_met) do
							local prm_manager = faction_met:pooled_resource_manager();
							local si_resource = prm_manager:resource("wh3_main_sla_seductive_influence");
							if not si_resource:is_null_interface() then
								local current_si = si_resource:percentage_of_capacity();
								if current_si > highest_si then
									highest_si = current_si;
									highest_si_faction = faction_met;
								end;
							end;
						end;

						if highest_si_faction then
							local character = cm:get_closest_character_to_camera_from_faction(highest_si_faction:name(), true, nil, faction_key);
							if character then
								return character:command_queue_index();
							end;
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(4000),																														-- issue money or equivalent
					payload.devotees(500),
					payload.ancillary_mission_payload(faction_key, "weapon", "rare")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or {																					-- script message(s) on which to trigger when received
					"StartSlaaneshSeductiveInfluenceGainMaxInfluenceMission",
					"SlaaneshSeductiveInfluenceUnlockOptionMissionCompleted"
				},
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")	or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"slaanesh_seductive_influence_unlock_diplomatic_option"
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

local function slaanesh_great_game_narrative_loader(faction_key)
	great_game_narrative_loader(
		faction_key, 
		"Slaanesh",							-- chaos type name (for script messages)
		"wh3_main_corruption_slaanesh", 	-- corruption pooled resource key
		"wh3_main_sla_slaanesh"				-- culture
	);
end;











------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	SENSUOUS SEDUCTIONS
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function slaanesh_sensuous_seductions_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("slaanesh sensuous seductions", faction_key);

	narrative.unimplemented_output("slaanesh sensuous seductions");

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


local function start_slaanesh_narrative_events(faction_key)

	slaanesh_devotees_narrative_loader(faction_key);
	slaanesh_gifts_of_slaanesh_narrative_loader(faction_key);
	slaanesh_seduction_narrative_loader(faction_key);
	slaanesh_seductive_influence_narrative_loader(faction_key);
	slaanesh_great_game_narrative_loader(faction_key);
	slaanesh_sensuous_seductions_narrative_loader(faction_key);
	chaos_movements_narrative_loader(faction_key);
end;


-- Ensure that these narrative events are started for any player-controlled faction matching the culture
narrative.add_loader_for_culture("wh3_main_sla_slaanesh", start_slaanesh_narrative_events);