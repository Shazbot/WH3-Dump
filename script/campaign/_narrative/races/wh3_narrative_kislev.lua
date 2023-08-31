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
--	DEVOTION / MOTHERLAND
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local kislev_devotion_excluded_factions = {
	wh3_dlc24_ksl_daughters_of_the_forest = true
}

local function kislev_devotion_narrative_loader(faction_key)

	if kislev_devotion_excluded_factions[faction_key] then return false end

	-- output header
	narrative.output_chain_header("kislev devotion", faction_key);


	-- determine the rival faction key
	local rival_faction_key;
	if faction_key == "wh3_main_ksl_the_ice_court" then
		rival_faction_key = "wh3_main_ksl_the_great_orthodoxy";
	elseif faction_key == "wh3_main_ksl_the_great_orthodoxy" then
		rival_faction_key = "wh3_main_ksl_the_ice_court";
	end;


	if not cm:get_saved_value(faction_key .. "_invoked_blessing") then
		core:add_listener(
			"kislev_devotion_blessing_listener",
			"RitualStartedEvent",
			function(context)
				return context:performing_faction():name() == faction_key and context:ritual():ritual_category() == "MOTHERLAND_RITUAL";
			end,
			function(context)
				cm:set_saved_value(faction_key .. "_invoked_blessing", true);
			end,
			true
		);
	end;




	

	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "kislev_devotion_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartKislevDevotionChainExpert",													-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartKislevDevotionChainFull",														-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					shared_prepend_str .. "_devotion_chain_completed"
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;












	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown before querying invocations
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "kislev_devotion_trigger_pre_query_invocations_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKislevDevotionChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKislevDevotionQueryInvocations",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 3,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Query Whether Invocation of the Motherland has already been made
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "kislev_devotion_query_invocation_already_made";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKislevDevotionQueryInvocations",												-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartKislevGainDevotionCountdown",													-- message(s) on value exists
				narrative.get(faction_key, name .. "_negative_messages") or "StartKislevInvokeMotherlandBlessing",												-- message(s) on value doesn't exist
				narrative.get(faction_key, name .. "_value_key") or faction_key .. "_invoked_blessing",															-- value key
				narrative.get(faction_key, name .. "_condition")																								-- condition function
			);
		end;
	end;

	
	-----------------------------------------------------------------------------------------------------------
	--	Invoke Blessing
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "kislev_devotion_event_invoke_blessing";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.perform_motherland_ritual(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_motherland_01",													-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_invoke_blessing_01",												-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(500)																																-- issue money or equivalent
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKislevInvokeMotherlandBlessing",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartKislevGainDevotionCountdown",												-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Pre Gain Devotion Turn Countdown Trigger
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "kislev_devotion_trigger_pre_gain_devotion_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKislevGainDevotionCountdown",													-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKislevGainDevotionQuery",														-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 2,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Pre Gain Devotion Query
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "kislev_devotion_query_pre_gain_devotion";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.has_pooled_resource(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKislevGainDevotionQuery",														-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or {																					-- message(s) on pooled resource greater than or equal to threshold
					"StartKislevPreDefeatChaosArmy",
					"StartKislevGainFiftySupportersTriggers"
				},
				narrative.get(faction_key, name .. "_negative_messages") or "StartKislevGainDevotion",															-- message(s) on pooled resource less than threshold
				narrative.get(faction_key, name .. "_pooled_resource") or "wh3_main_ksl_devotion",																-- pooled resource key/keys
				narrative.get(faction_key, name .. "_threshold") or 150,																						-- threshold value
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Gain Devotion Mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "kislev_devotion_event_gain_devotion";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.gain_devotion(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_gain_devotion_01",													-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_gain_devotion_01",												-- key of mission to deliver
				narrative.get(faction_key, name .. "_resource_quantity") or 150,																				-- number of provinces
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(1000)																																	-- issue money or equivalent
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKislevGainDevotion",															-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or "StartKislevPreDefeatChaosArmy",													-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartKislevGainFiftySupportersTriggers",											-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;

	
	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown before Defeat Chaos Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "kislev_devotion_turn_countdown_pre_defeat_chaos";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKislevPreDefeatChaosArmy",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKislevDefeatChaosArmy",															-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 1,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Defeat Chaos Army
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "kislev_devotion_event_defeat_chaos_army";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.defeat_chaos_army(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_motherland_02",													-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_defeat_chaos_army_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(2000),																															-- issue money or equivalent
					payload.ancillary_mission_payload(faction_key, "banner", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKislevDefeatChaosArmy",														-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or "",																				-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "",																				-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")	or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"kislev_devotion_event_invoke_blessing",
					"kislev_devotion_event_gain_devotion"
				}
			);
		end;
	end;


	












	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown before Gain Supporters Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "kislev_devotion_trigger_turn_countdown_pre_first_to_fifty_supporters";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKislevGainFiftySupportersTriggers",												-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKislevGainFiftySupporters",														-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 5,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Trigger Gain Supporters on Some Supporters Gained
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "kislev_devotion_trigger_first_to_fifty_supporters_on_supporters_gained";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.faction_pooled_resource_gained(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKislevGainFiftySupportersTriggers",												-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKislevGainFiftySupporters",														-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_pooled_resource_faction_key") or faction_key,																-- key of faction to monitor resource changes for
				narrative.get(faction_key, name .. "_pooled_resource_key") or "wh3_main_ksl_followers",															-- pooled resource key(s)
				narrative.get(faction_key, name .. "_threshold_value") or 5																						-- threshold value
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Trigger Gain Supporters on Rival Gains Some Supporters
	-----------------------------------------------------------------------------------------------------------

	if rival_faction_key then
		local name = "kislev_devotion_trigger_first_to_fifty_supporters_on_rival_supporters_gained";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.faction_pooled_resource_gained(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKislevGainFiftySupportersTriggers",												-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKislevGainFiftySupporters",														-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_pooled_resource_faction_key") or rival_faction_key,														-- key of faction to monitor resource changes for
				narrative.get(faction_key, name .. "_pooled_resource_key") or "wh3_main_ksl_followers",															-- pooled resource key(s)
				narrative.get(faction_key, name .. "_threshold_value") or 5																						-- threshold value
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	First to 50 Supporters Mission
	-----------------------------------------------------------------------------------------------------------

	if rival_faction_key then
		local name = "kislev_devotion_first_to_fifty_supporters";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.gain_pooled_resource_scripted(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_kislev_gain_supporters_01",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or 																							-- key of mission objective
					(faction_key == "wh3_main_ksl_the_ice_court" and 
						"wh3_main_narrative_mission_description_ice_court_beat_rival_to_fifty_supporters" or 	-- player is Ice Court
						"wh3_main_narrative_mission_description_orthodoxy_beat_rival_to_fifty_supporters"		-- player is Great Orthodoxy
					),
				narrative.get(faction_key, name .. "_pooled_resources") or "wh3_main_ksl_followers",															-- pooled resource(s) key(s)
				narrative.get(faction_key, name .. "_lower_threshold") or 50,																					-- lower threshold value
				narrative.get(faction_key, name .. "_upper_threshold"),																							-- upper threshold value
				narrative.get(faction_key, name .. "is_additive") or false,																						-- is additive (value of all resources counts towards total)
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(2000),																													-- issue money
					payload.ancillary_mission_payload(faction_key, "enchanted_item", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKislevGainFiftySupporters",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartKislevGainMaxSupporters",													-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Cancel First to 50 Supporters Mission if rival gets there first
	-----------------------------------------------------------------------------------------------------------

	if rival_faction_key then
		local name = "kislev_devotion_trigger_cancel_first_to_fifty_supporters";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.faction_pooled_resource_gained(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKislevGainFiftySupporters",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "CancelKislevGainFiftySupporters",													-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages") or "StartKislevGainMaxSupporters",														-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_pooled_resource_faction_key") or rival_faction_key,														-- key of faction to monitor resource changes for
				narrative.get(faction_key, name .. "_pooled_resource_key")or "wh3_main_ksl_followers",															-- pooled resource key(s)
				narrative.get(faction_key, name .. "_threshold_value") or 50																					-- threshold value
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Cancel First to 50 Supporters Mission if rival gets there first
	-----------------------------------------------------------------------------------------------------------

	if rival_faction_key then
		local name = "kislev_devotion_event_cancel_first_to_fifty_supporters"

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.cancel_mission(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_kislev_gain_supporters_01",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_trigger_messages") or "CancelKislevGainFiftySupporters",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or "StartKislevGainMaxSupporters"														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	First to Gain All Supporters Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "kislev_devotion_first_to_max_supporters";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.gain_pooled_resource_scripted(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_confederate_01",													-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_kislev_gain_supporters_02",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or 																							-- key of mission objective
					(faction_key == "wh3_main_ksl_the_ice_court" and 
						"wh3_main_narrative_mission_description_ice_court_beat_rival_to_max_supporters" or 		-- player is Ice Court
						"wh3_main_narrative_mission_description_orthodoxy_beat_rival_to_max_supporters"			-- player is Great Orthodoxy
					),
				narrative.get(faction_key, name .. "_pooled_resources") or "wh3_main_ksl_followers",															-- pooled resource(s) key(s)
				narrative.get(faction_key, name .. "_lower_threshold") or 600,																					-- lower threshold value
				narrative.get(faction_key, name .. "_upper_threshold"),																							-- upper threshold value
				narrative.get(faction_key, name .. "is_additive") or false,																						-- is additive (value of all resources counts towards total)
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(5000),																														-- issue money
					payload.ancillary_mission_payload(faction_key, "armour", "rare")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKislevGainMaxSupporters",														-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or "KislevDevotionMarkAdviceHistory",													-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "KislevGainMaxSupportersCompleted",												-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")	or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"kislev_devotion_event_gain_devotion",
					"kislev_devotion_event_defeat_chaos_army",
					"kislev_devotion_event_invoke_blessing"
				}
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History After All Supporters gained
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "kislev_devotion_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or shared_prepend_str .. "_devotion_chain_completed",												-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "KislevDevotionMarkAdviceHistory",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or "StartKislevDevotionChainExpert"													-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Cancel First to Max Supporters Mission if rival gets there first
	-----------------------------------------------------------------------------------------------------------

	if rival_faction_key then
		local name = "kislev_devotion_trigger_cancel_first_to_max_supporters";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.faction_pooled_resource_gained(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKislevGainMaxSupporters",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "CancelKislevGainMaxSupporters",														-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages") or "KislevGainMaxSupportersCompleted",													-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_pooled_resource_faction_key") or rival_faction_key,														-- key of faction to monitor resource changes for
				narrative.get(faction_key, name .. "_pooled_resource_key")or "wh3_main_ksl_followers",															-- pooled resource key(s)
				narrative.get(faction_key, name .. "_threshold_value") or 600																					-- threshold value
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Cancel First to Max Supporters Mission if rival gets there first
	-----------------------------------------------------------------------------------------------------------

	if rival_faction_key then
		local name = "kislev_devotion_event_cancel_first_to_max_supporters"

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.cancel_mission(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_kislev_gain_supporters_02",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_trigger_messages") or "CancelKislevGainMaxSupporters",														-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;
















	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] - Wait for the player to enact a motherland ritual
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "kislev_devotion_trigger_motherland_ritual_enacted";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.ritual_performed(
				name, 																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies 
				narrative.get(faction_key, name .. "_start_messages") or "StartKislevDevotionChainExpert",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKislevDevotionExpertMission",													-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_ritual_keys"),																								-- ritual key(s)
				narrative.get(faction_key, name .. "_ritual_keys") or "MOTHERLAND_RITUAL",																		-- ritual category/categories
				narrative.get(faction_key, name .. "_target_faction_keys")																						-- ritual target faction key(s)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- [EXPERT] - Also trigger expert chain if the rival faction gains any supporters
	-----------------------------------------------------------------------------------------------------------

	if rival_faction_key then
		local name = "kislev_devotion_trigger_expert_rival_gains_supporters";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.faction_pooled_resource_gained(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartKislevDevotionChainExpert",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartKislevDevotionExpertMission",													-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_pooled_resource_faction_key") or rival_faction_key,														-- key of faction to monitor resource changes for
				narrative.get(faction_key, name .. "_pooled_resource_key")or "wh3_main_ksl_followers",															-- pooled resource key(s)
				narrative.get(faction_key, name .. "_threshold_value") or 3																						-- threshold value
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] 
	
	--		[Ice Court/Great Orthodoxy] Redirect the message to start 50 Supporters Mission
	--		or
	--		[Non-Ice Court/Great Orthodoxy] Enact 10 Invocations of the Motherland
	-----------------------------------------------------------------------------------------------------------

	if rival_faction_key then
		local name = "kislev_devotion_expert_trigger_redirect";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.message(
				name, 																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies 
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKislevDevotionExpertMission",													-- script message(s) on which to trigger
				narrative.get(faction_key, name .. "_target_messages") or "StartKislevGainFiftySupportersTriggers",												-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages")																							-- script message(s) on which to cancel
			);
		end;
	else
		local name = "kislev_devotion_enact_ten_invocations";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.perform_ritual_scripted(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_perform_invocations_of_the_motherland_01",						-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or 																							-- key of mission objective
					"wh3_main_narrative_mission_description_ice_court_perform_ten_invocations_of_the_motherland",
				narrative.get(faction_key, name .. "_total") or 10,																								-- total rituals to perform
				narrative.get(faction_key, name .. "_ritual_keys"),																								-- ritual key(s)						
				narrative.get(faction_key, name .. "_ritual_category_keys") or "MOTHERLAND_RITUAL",																-- ritual category key(s)
				narrative.get(faction_key, name .. "_target_faction_keys"),																						-- target faction key(s)
				narrative.get(faction_key, name .. "_listen_for_ritual_completed"),																				-- listen for ritual completing rather than starting
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(500)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartKislevDevotionExpertMission",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")	or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"kislev_devotion_event_gain_devotion",
					"kislev_devotion_event_defeat_chaos_army",
					"kislev_devotion_event_invoke_blessing",
					"kislev_devotion_first_to_fifty_supporters",
					"kislev_devotion_first_to_max_supporters"
				}
			);
		end;
	end;	




	narrative.output_chain_footer();

end;












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

	kislev_devotion_narrative_loader(faction_key);
	kislev_ice_court_narrative_loader(faction_key);
	kislev_atamans_narrative_loader(faction_key);
end;


-- Ensure that these narrative events are started for any player-controlled faction matching the culture
narrative.add_loader_for_culture("wh3_main_ksl_kislev", start_kislev_narrative_events);