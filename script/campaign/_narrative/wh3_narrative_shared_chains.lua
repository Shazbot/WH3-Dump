------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	SHARED NARRATIVE EVENT CHAINS
--
--	PURPOSE
--
--	This file defines chains of narrative events that are shared between all races and all campaigns. These are mostly 
--	tutorial missions related to core game features like territorial capture, corruption, recruiting units, tech etc. 
--	
--	The start_narrative_events_shared_for_faction() function, which ultimately defines all shared narrative events, is added
--	to the narrative system with a call to narrative.add_loader. The function will be called when the narrative system is started,
--	on or around the first tick.
--
--	LOADED
--	This file is loaded by wh3_narrative_loader.lua, which in turn should be loaded by the per-campaign narrative 
--	script file. It should get loaded on start of script.
--	
--	AUTHORS
--	SV
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

out.narrative("* wh3_narrative_shared_chains.lua loaded");

local shared_prepend_str = shared_narrative_event_prepend_str;


--[[ *** Loader function now at the bottom of this file *** ]]





------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	SETTLEMENT CAPTURED CHAIN
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function start_narrative_shared_chain_settlement_captured(faction_key)

	-- output header
	narrative.output_chain_header("settlement_capture", faction_key);




	

	
	-----------------------------------------------------------------------------------------------------------
	--	Can Capture Territory Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_capture_query_can_capture_territory";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.can_capture_territory(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				-- StartNarrativeEvents message is overridden for chaos campaign
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				-- Also, for the chaos campaign a second injected positive message directly triggers the capture settlement mission
				narrative.get(faction_key, name .. "_positive_messages") or "StartSettlementCapturedQueryAdvice",												-- positive target message(s) - faction can capture territory
				narrative.get(faction_key, name .. "_negative_messages"),																						-- negative target message(s) - faction cannot capture territory
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_capture_query_advice";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementCapturedQueryAdvice",												-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSettlementCapturedChainExpert",												-- positive target message(s) - advice experienced
				-- in the Chaos campaign this is overridden to be blank - the settlement capture mission is
				-- triggered directly from the can_capture_territory query
				narrative.get(faction_key, name .. "_negative_messages") or "StartSettlementCapturedChainFull",													-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					shared_prepend_str .. "_shared_province_completed"
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Query whether player already fully controls a province
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_capture_query_full_province_ownership";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.controls_x_provinces(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementCapturedChainFull",													-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSettlementCapturedCaptureTwoProvinces",										-- positive target message(s) - player is one turn from completing province
				narrative.get(faction_key, name .. "_negative_messages") or "StartSettlementCapturedQueryOneTurnFromProvinceCapture",							-- negative target message(s) - player is not one turn from completing province
				narrative.get(faction_key, name .. "num_provinces") or 1,																						-- num provinces
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;

	-----------------------------------------------------------------------------------------------------------
	--	Query player's territorial holdings - are they one turn from province capture
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_capture_query_territorial_holdings";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.one_settlement_from_completing_province(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementCapturedQueryOneTurnFromProvinceCapture",							-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSettlementCapturedCaptureProvince",											-- positive target message(s) - player is one turn from completing province
				narrative.get(faction_key, name .. "_negative_messages") or "StartSettlementCapturedCaptureSettlement",											-- negative target message(s) - player is not one turn from completing province
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;

	-----------------------------------------------------------------------------------------------------------
	--	Capture Settlement
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_capture_event_capture_settlement";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.capture_settlement(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_shared_capture_settlement_01",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_capture_settlement_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_faction_key"),																								-- faction key of target faction - can be nil
				narrative.get(faction_key, name .. "_region_key"),																								-- region key of target settlement - can be table of multiple keys
				narrative.get(faction_key, name .. "_camera_target") or narrative.get(faction_key, "initial_enemy_faction_key"),								-- target to move camera to (can be string region/faction key, char cqi, table with x/y display positions, or nil)
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						1000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "med",																																	-- value of this mission
							glory_type = "khorne"																															-- glory type to issue
						}
					),
					payload.ancillary_mission_payload(faction_key, "enchanted_item", "common")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementCapturedCaptureSettlement",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartSettlementCapturedCaptureProvince",											-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list"),																							-- list of other narrative events to inherit rewards from (may be nil)
				true	-- high priority - replace this at some point
			);
		end;
	end;

	-----------------------------------------------------------------------------------------------------------
	--	Control Province
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_capture_event_control_province";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.control_provinces(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_shared_complete_province_01",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_complete_province_01",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_num_provinces") or 1,																						-- number of provinces
				narrative.get(faction_key, name .. "_province_keys"),																							-- opt list of province keys
				narrative.get(faction_key, name .. "_camera_target"),																							-- target to move camera to (can be string region/faction key, char cqi, table with x/y display positions, or nil)
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						5000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "high",																																	-- value of this mission
							glory_type = "undivided"																														-- glory type to issue
						}
					),
					payload.ancillary_mission_payload(faction_key, "armour", "common")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementCapturedCaptureProvince",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartSettlementCapturedPreEnactCommandment",										-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;

	-----------------------------------------------------------------------------------------------------------
	--	Query whether Enact Commandment narrative event has been triggered
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_capture_query_pre_enact_commandment";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.narrative_event_has_triggered(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementCapturedPreEnactCommandment",										-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSettlementCapturedCaptureMoreProvinces",										-- positive target message(s) - player is one turn from completing province
																-- redirected for Chaos campaign so that the Enact Commandment mission is never issued ...
				narrative.get(faction_key, name .. "_negative_messages") or "StartSettlementCapturedEnactCommandment",											-- negative target message(s) - player is not one turn from completing province
				narrative.get(faction_key, name .. "_ne_name") or "shared_settlement_capture_event_enact_commandment",											-- narrative event name
				narrative.get(faction_key, name .. "_pass_on_all") or true,																						-- pass on all
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;

	-----------------------------------------------------------------------------------------------------------
	--	Enact Commandment
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_capture_event_enact_commandment";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.enact_commandment(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_shared_enact_commandment_01",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_enact_commandment_01",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_total"),																									-- opt number of commandments to enact (default 1)
				narrative.get(faction_key, name .. "_commandment"),																								-- commandment to enact, can be nil
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						500,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "med",																																	-- value of this mission
							glory_type = "slaanesh,tzeentch"																												-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementCapturedEnactCommandment",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartSettlementCapturedQueryTwoProvincesOwned",									-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Query whether player already fully controls two provinces
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_capture_query_two_provinces_owned";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.controls_x_provinces(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementCapturedQueryTwoProvincesOwned",										-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSettlementCapturedChainTransitionToExpert",									-- positive target message(s) - player is one turn from completing province
				narrative.get(faction_key, name .. "_negative_messages") or "StartSettlementCapturedCaptureTwoProvinces",										-- negative target message(s) - player is not one turn from completing province
				narrative.get(faction_key, name .. "num_provinces") or 2,																						-- num provinces
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;

	
	-----------------------------------------------------------------------------------------------------------
	--	Control Two Provinces
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_settlement_capture_event_control_two_provinces";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.control_provinces(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				-- overriden for Kislev Atamans
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_complete_provinces_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_num_provinces") or 2,																						-- number of provinces
				narrative.get(faction_key, name .. "_province_keys"),																							-- opt list of province keys
				narrative.get(faction_key, name .. "_camera_target"),																							-- target to move camera to (can be string region/faction key, char cqi, table with x/y display positions, or nil)
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						3000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "med",																																	-- value of this mission
							glory_type = "khorne,nurgle,slaanesh,tzeentch,undivided"																						-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementCapturedCaptureTwoProvinces",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or {																					-- script message(s) to trigger when this mission is completed
					"SettlementCapturedCaptureTwoProvincesCompleted",		-- for Kislev Atamans
					"StartSettlementCapturedChainTransitionToExpert"	
				},
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;
	
	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_capture_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or shared_prepend_str .. "_shared_province_completed",												-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementCapturedChainTransitionToExpert",									-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;

	
	
	
	
	
	
	
	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Pre Control Many Provinces Turn Countdown
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_settlement_capture_trigger_pre_control_provinces_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSettlementCapturedChainExpert",													-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSettlementCapturedCaptureManyProvinces",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 12,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Pre Control Many Provinces Turn Countdown Transition to Expert
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_settlement_capture_trigger_pre_control_provinces_turn_countdown_transition";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSettlementCapturedChainTransitionToExpert",										-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSettlementCapturedCaptureManyProvinces",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 1,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Control Provinces
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_settlement_capture_event_control_provinces";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.control_provinces(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																	 							-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_complete_provinces_02",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_num_provinces") or 3,																						-- number of provinces
				narrative.get(faction_key, name .. "_province_keys"),																							-- opt list of province keys
				narrative.get(faction_key, name .. "_camera_target"),																							-- target to move camera to (can be string region/faction key, char cqi, table with x/y display positions, or nil)
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						5000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "v_high",																																-- value of this mission
							glory_type = "khorne,nurgle,slaanesh,tzeentch,undivided"																						-- glory type to issue
						}
					),
					payload.ancillary_mission_payload(faction_key, "talisman", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementCapturedCaptureManyProvinces",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;






	-- output footer
	narrative.output_chain_footer();
end;






















------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	UNIT RECRUITMENT CHAIN
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function start_narrative_shared_chain_unit_recruitment(faction_key)

	-- output header
	narrative.output_chain_header("unit_recruitment", faction_key);

	local advice_history_string = shared_prepend_str .. "_shared_recruit_units_completed";


	-----------------------------------------------------------------------------------------------------------
	--	Initial Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_unit_recruitment_query_advice";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartUnitRecruitmentChainExpert",													-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartUnitRecruitmentChainFull",													-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					advice_history_string
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Low Priority Turn-Start Trigger for Recruit Units
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_unit_recruitment_trigger_low_prio_recruit_units";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_start(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartUnitRecruitmentChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartUnitRecruitmentRecruitUnits",													-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_condition"),																								-- opt condition
				narrative.get(faction_key, name .. "_faction_starting_turn"),																					-- opt faction starting turn
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Recruit Units
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_unit_recruitment_event_recruit_units";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.recruit_units(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_shared_recruit_units_01",											-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_chaos_shared_recruit_units_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_num_units") or 5,			 																				-- number of units
				narrative.get(faction_key, name .. "_unit_keys"),																								-- opt unit keys
				narrative.get(faction_key, name .. "_exclude_existing") or true,																				-- exclude preexisting units
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						1000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "med",																																	-- value of this mission
							glory_type = "undivided"																														-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartUnitRecruitmentRecruitUnits",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartUnitRecruitmentTransitionToExpert",											-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list"),																							-- list of other narrative events to inherit rewards from (may be nil)
				true			-- high priority - replace this switch
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History After Recruit Units
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_unit_recruitment_recruit_units_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or advice_history_string,																			-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "StartUnitRecruitmentTransitionToExpert",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;












	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn Countdown Before Recruit Many Units
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_unit_recruitment_trigger_pre_recruit_many_units_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartUnitRecruitmentChainExpert",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartUnitRecruitmentRecruitManyUnits",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 8,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn Countdown Before Recruit Many Units (Transition)
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_unit_recruitment_trigger_pre_recruit_many_units_turn_countdown_transition";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartUnitRecruitmentTransitionToExpert",												-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartUnitRecruitmentRecruitManyUnits",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 6,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Recruit Many Units
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_unit_recruitment_event_recruit_many_units";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.recruit_units(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_recruit_units_02",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_num_units") or 30,		 																					-- number of units
				narrative.get(faction_key, name .. "_unit_keys"),				 																				-- opt unit keys
				narrative.get(faction_key, name .. "_exclude_existing") or true,																				-- exclude preexisting units
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						3000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "high",																																	-- value of this mission
							glory_type = "khorne,nurgle"																													-- glory type to issue
						}
					),
					payload.ancillary_mission_payload(faction_key, "banner", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartUnitRecruitmentRecruitManyUnits",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;





	-- output footer
	narrative.output_chain_footer();
end;



















------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	SETTLEMENT UPGRADE CHAIN
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function start_narrative_shared_chain_settlement_upgrade(faction_key)

	-- output header
	narrative.output_chain_header("settlement_upgrade", faction_key);


	-----------------------------------------------------------------------------------------------------------
	--	Can Capture Territory Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_upgrade_query_can_capture_territory";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.can_capture_territory(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSettlementUpgradeQueryAdvice",												-- positive target message(s) - faction can capture territory
				narrative.get(faction_key, name .. "_negative_messages"),																						-- negative target message(s) - faction cannot capture territory
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_upgrade_query_advice";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementUpgradeQueryAdvice",													-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSettlementUpgradeChainExpert",												-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartSettlementUpgradeChainFull",													-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					shared_prepend_str .. "_shared_upgrade_settlement"
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Trigger for First Growth Point Earned
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_upgrade_trigger_growth_point_1";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.growth_point_gained(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSettlementUpgradeChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSettlementUpgradeUpgradeAnySettlement",											-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_ensure_upgrade_available") or true,																		-- only trigger if growth point has led to upgrade being available
				narrative.get(faction_key, name .. "_province_keys")																							-- opt province key(s)
			);
		end;
	end;

	-----------------------------------------------------------------------------------------------------------
	--	Upgrade any settlement
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_upgrade_upgrade_any_settlement";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.upgrade_any_settlement(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_shared_upgrade_settlement_01",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_upgrade_settlement_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_building_level"),																							-- opt building level
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						1000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "low",																																	-- value of this mission
							glory_type = "nurgle"																															-- glory type to issue
						}
					),
					payload.ancillary_mission_payload(faction_key, "armour", "common")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementUpgradeUpgradeAnySettlement",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartSettlementUpgradePreUpgradeLevelThreeCountdown",								-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Before Upgrade to Level Three Query
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_settlement_upgrade_trigger_pre_level_three_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSettlementUpgradePreUpgradeLevelThreeCountdown",									-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSettlementUpgradeAdditionalUpgradeQuery",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 5,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Query max settlement level
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_upgrade_query_highest_level_settlement";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.highest_level_settlement_for_faction(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementUpgradeAdditionalUpgradeQuery",										-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSettlementUpgradeChainTransitionToExpert",									-- positive target message(s) - highest-level settlement >= query level
				narrative.get(faction_key, name .. "_negative_messages") or "StartSettlementUpgradeLevelThree",													-- negative target message(s) - highest-level settlement < query level
				narrative.get(faction_key, name .. "_query_level") or 3,																						-- query level
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;
	

	-----------------------------------------------------------------------------------------------------------
	--	Upgrade Settlement to Level 3
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_upgrade_upgrade_any_settlement_level_three";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.upgrade_any_settlement(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_shared_upgrade_settlement_02",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_upgrade_settlement_02",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_building_level") or 3,																						-- opt building level
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						1000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "med",																																	-- value of this mission
							glory_type = "nurgle"																															-- glory type to issue
						}
					),
					payload.ancillary_mission_payload(faction_key, "weapon", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementUpgradeLevelThree",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartSettlementUpgradeChainTransitionToExpert",									-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History After Upgrade Settlement
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_upgrade_upgrade_settlement_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or shared_prepend_str .. "_shared_upgrade_settlement",												-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementUpgradeChainTransitionToExpert",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;










	


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn Countdown Before Upgrade Settlement to Level 5
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_settlement_upgrade_trigger_pre_level_five_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSettlementUpgradeChainExpert",													-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSettlementUpgradeLevelFive",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 25,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Trigger Upgrade Settlement to Level 5 On Highest Settlement Level
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_settlement_upgrade_trigger_pre_level_five_settlement_level";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.highest_level_settlement(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {																						-- script message(s) on which to start
					"StartSettlementUpgradeChainExpert",
					"StartSettlementUpgradeChainTransitionToExpert"
				},
				narrative.get(faction_key, name .. "_target_messages") or "StartSettlementUpgradeLevelFive",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_level") or 4																								-- settlement level
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn Countdown Before Upgrade Settlement to Level 5 After Transitioning From Full Chain
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_settlement_upgrade_trigger_transition_level_five_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSettlementUpgradeChainTransitionToExpert",										-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSettlementUpgradeLevelFive",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 20,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Upgrade Settlement to Level 5
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_settlement_upgrade_upgrade_any_settlement_level_five";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.upgrade_any_settlement(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_upgrade_settlement_03",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_building_level") or 5,																						-- opt building level
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						5000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "v_high",																																-- value of this mission
							glory_type = "undivided"																														-- glory type to issue
						}
					),
					payload.ancillary_mission_payload(faction_key, "enchanted_item", "rare")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementUpgradeLevelFive",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "",																				-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list") or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"shared_settlement_upgrade_upgrade_any_settlement",
					"shared_settlement_upgrade_upgrade_any_settlement_level_three"
				}
			);
		end;
	end;








	-- output footer
	narrative.output_chain_footer();
end;




















------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	TECHNOLOGY RESEARCH CHAIN
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function start_narrative_shared_chain_technology_research(faction_key)

	-- a switch to just block the whole chain
	if narrative.get(faction_key, "shared_technology_chain_block") then
		return;
	end;



	-- output header
	narrative.output_chain_header("technology_research", faction_key);






	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Before Starting Chain
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_technology_research_trigger_pre_chain";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartNarrativeEvents",																-- script message(s) on which to start
				-- target message is overriden in Chaos campaign
				narrative.get(faction_key, name .. "_target_messages") or "StartTechnologyResearchChain",														-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 1,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_technology_research_query_advice";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartTechnologyResearchChain",														-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartTechnologyResearchChainExpert",												-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartTechnologyResearchChainFull",													-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					shared_prepend_str .. "_shared_research_technology"
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Query Has Started Researching
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_technology_research_query_is_researching";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.is_researching(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartTechnologyResearchChainFull",													-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartTechnologyResearchChainExpert",												-- positive target message(s) - has started researching
				narrative.get(faction_key, name .. "_negative_messages") or "StartTechnologyResearchQueryAvailable",											-- negative target message(s) - has not started researching
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Query Has Technologies Available
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_technology_research_query_techs_available";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.has_available_technologies(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartTechnologyResearchQueryAvailable",												-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartTechnologyResearchResearchTechnology",										-- positive target message(s) - techs available
				narrative.get(faction_key, name .. "_negative_messages") or "StartTechnologyResearchPreConstructTechBuilding",									-- negative target message(s) - no techs available
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Research Technologies
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_technology_research_research_any_technology";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.research_technology(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_shared_research_technologies_01",									-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_research_technologies_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_num_technologies") or 1,																					-- num technologies
				narrative.get(faction_key, name .. "_technologies"),																							-- opt mandatory technologies
				narrative.get(faction_key, name .. "_include_existing") or false,																				-- includes existing technologies
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						500,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "v_low",																																-- value of this mission
							glory_type = "tzeentch"																															-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartTechnologyResearchResearchTechnology",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or {																					-- script message(s) to trigger when this mission is completed
					"StartTechnologyResearchChainExpert",
					"TechnologyResearchResearchCompleted"
				},
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Low Priority Trigger for Construct Technology Building
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_research_technology_trigger_low_prio_construct_technology_building";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_start(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartTechnologyResearchPreConstructTechBuilding",										-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartTechnologyResearchConstructTechBuilding",										-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages")	or "StartTechnologyResearchConstructTechBuildingNextTurn",								-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_condition"),																								-- opt condition
				narrative.get(faction_key, name .. "_faction_starting_turn"),																					-- opt faction starting turn
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Immediate Trigger if player begins construction of Technology Building
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_research_technology_trigger_player_begins_construction_technology_building";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.technology_building_construction_issued(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartTechnologyResearchPreConstructTechBuilding",										-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartTechnologyResearchConstructTechBuildingNextTurn",								-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages")	or "StartTechnologyResearchConstructTechBuilding",										-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Before Construct Technology Building
	--	(triggers the mission on the next turn if the player begins construction of a tech-enabling building,
	--	so we can be sure they get the mission before they complete it)
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_research_technology_trigger_pre_construction_technology_building";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartTechnologyResearchConstructTechBuildingNextTurn",								-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartTechnologyResearchConstructTechBuilding",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 1,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Construct Technology Building
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_technology_research_construct_technology_building";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.construct_technology_enabling_building(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_shared_construct_technology_building_01",							-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_construct_technology_building_01",							-- key of mission to deliver
				narrative.get(faction_key, name .. "_condition"),																								-- opt additional fn condition
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						500,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "low",																																-- value of this mission
							glory_type = "nurgle"																															-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartTechnologyResearchConstructTechBuilding",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartTechnologyResearchResearchTechnologyAfterBuilding",							-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Research Technologies After Building
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_technology_research_research_technology_after_building";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.research_technology(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				-- post-construct tech building mission uses different advice key to the previous variant
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_shared_research_technologies_02",									-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_research_technologies_02",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_num_technologies") or 1,																					-- num technologies
				narrative.get(faction_key, name .. "_technologies"),																							-- opt mandatory technologies
				narrative.get(faction_key, name .. "_include_existing") or false,																				-- includes existing technologies
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						500,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "v_low",																																-- value of this mission
							glory_type = "tzeentch"																															-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartTechnologyResearchResearchTechnologyAfterBuilding",							-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or {																					-- script message(s) to trigger when this mission is completed
					"StartTechnologyResearchChainExpert",
					"TechnologyResearchResearchCompleted"
				},
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History After Tech Research
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_technology_research_research_technology_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or shared_prepend_str .. "_shared_research_technology",												-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "TechnologyResearchResearchCompleted",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;

	







	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Before Research Many Technologies [EXPERT]
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_research_technology_trigger_pre_research_many_technologies_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartTechnologyResearchChainExpert",													-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartTechnologyResearchPreResearchMany",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 10,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Research Many Technologies [EXPERT]
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_research_technology_research_many_technologies";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.research_technology(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_research_technologies_03",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_num_technologies") or 8,																					-- num technologies
				narrative.get(faction_key, name .. "_technologies"),																							-- opt mandatory technologies
				narrative.get(faction_key, name .. "_include_existing") or false,																				-- includes existing technologies
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						3000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "high",																																	-- value of this mission
							glory_type = "tzeentch"																															-- glory type to issue
						}
					),
					payload.ancillary_mission_payload(faction_key, "talisman", "rare")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartTechnologyResearchPreResearchMany",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "",																				-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list") or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"shared_technology_research_research_any_technology",
					"shared_technology_research_construct_technology_building",
					"shared_technology_research_research_technology_after_building"
				}	
			);
		end;
	end;








	-- output footer
	narrative.output_chain_footer();
end;














------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	HEROES CHAIN
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function start_narrative_shared_chain_heroes(faction_key)


	
	-- a switch to just block the whole chain
	if narrative.get(faction_key, "shared_heroes_chain_block") then
		return;
	end;





	-- output header
	narrative.output_chain_header("heroes", faction_key);
	




	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_heroes_query_advice";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartHeroesChainExpert",															-- positive target message(s) - advice experienced
				-- overridden in Chaos campaign, so that only expert missions are started
				narrative.get(faction_key, name .. "_negative_messages") or "StartHeroesChainFull",																-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					shared_prepend_str .. "_shared_heroes"
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Can Capture Territory Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_heroes_query_can_capture_territory";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.can_capture_territory(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartHeroesChainFull",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartHeroesQueryConstructionLocked",												-- positive target message(s) - faction can capture territory
				narrative.get(faction_key, name .. "_negative_messages"),																						-- negative target message(s) - faction cannot capture territory
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	--	TBD: query, are any player heroes locked behind building construction?
		-- needs code
	

	--	TBD: trigger, low priority if player can construct hero building
		-- needs code


	--	TBD: trigger, immediate if player begins construction of building that permits hero recruitment (either for mission to construct building, or to cancel previous low-priority trigger)
		-- needs code


	--	TBD: mission, construct hero building

	narrative.unimplemented_output("Heroes chain - construct hero building mission");



	-----------------------------------------------------------------------------------------------------------
	--	Does Player Have Hero Query
	--	Can the player already recruit a hero at the start of the campaign - if so, then move to
	--	issue a mission to recruit one
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_heroes_query_does_player_faction_contain_hero";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.contains_any_hero(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartHeroesChainFull",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartHeroesFactionHasHero",														-- positive target message(s)
				narrative.get(faction_key, name .. "_negative_messages") or "StartHeroesCanRecruitHero",														-- negative target message(s)
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Can Player Recruit Hero Query
	--	Can the player already recruit a hero at the start of the campaign - if so, then move to
	--	issue a mission to recruit one
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_heroes_query_can_player_recruit_hero";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.can_recruit_hero_of_type(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartHeroesCanRecruitHero",															-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartHeroesPreRecruitHero",														-- positive target message(s)
				narrative.get(faction_key, name .. "_negative_messages"),																						-- negative target message(s)
				narrative.get(faction_key, name .. "_hero_types") or cm:get_all_agent_types(),																	-- negative target message(s)
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;
	

	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Before Recruit Hero
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_heroes_trigger_pre_recruit_hero_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartHeroesPreRecruitHero",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartHeroesRecruitHero",																-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "HeroesChainHeroCreated",																-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 3,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Recruit Hero
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_heroes_recruit_hero";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.recruit_any_hero(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_shared_recruit_hero_01",											-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_recruit_hero_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						1000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "med",																																	-- value of this mission
							glory_type = "slaanesh"																															-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartHeroesRecruitHero",															-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "HeroesRecruitHeroCompleted",														-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Hero Created Trigger
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_heroes_trigger_hero_created";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.agent_created(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartHeroesChainFull",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "HeroesChainIssueUseHero",															-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "HeroesChainIssueUseHeroNoAdvice",													-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Use Hero Against Enemy
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_heroes_use_hero_against_enemy";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.use_hero(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_shared_deploy_hero_01",											-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_deploy_hero_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						500,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "low",																																	-- value of this mission
							glory_type = "slaanesh"																															-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "HeroesChainIssueUseHero",															-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "HeroesChainHeroUsed",																-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Use Hero Against Enemy (no advice)
	--	The advice that was written isn't suitable for use if the hero hasn't just been recruited, so
	--	if the hero has been hanging around since turn one we trigger the mission without advice
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_heroes_use_hero_against_enemy_no_advice";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.use_hero(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_deploy_hero_02",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																-- issue money or equivalent
						500,																																		-- money reward, if we aren't giving something else for this faction
						faction_key,																																-- faction key
						{																																			-- params for potential money replacement
							value = "low",																																-- value of this mission
							glory_type = "slaanesh"																														-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "HeroesChainIssueUseHeroNoAdvice",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "HeroesChainHeroUsed",																-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Before Use Hero (if player has one on campaign start)
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_heroes_trigger_pre_use_hero_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartHeroesFactionHasHero",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "HeroesChainIssueUseHeroNoAdvice",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or {"HeroesChainHeroUsed", "HeroesChainIssueUseHero"},									-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 5,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Trigger on Hero Action Performed
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_heroes_trigger_hero_action_performed";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.hero_action_performed(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartHeroesFactionHasHero",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "HeroesChainHeroUsed",																-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "",																					-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns"),																								-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;















	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Before Expert Mission (from startup)
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_heroes_trigger_pre_expert_from_startup";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartHeroesChainExpert",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "HeroesChainIssueExpertMission",														-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 10,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Before Expert Mission (from chain completed)
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_heroes_trigger_pre_expert_from_chain_completed";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "HeroesChainHeroUsed",																	-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "HeroesChainIssueExpertMission",														-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 5,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Trigger immediately if any player hero gets close to battles won threshold
	-----------------------------------------------------------------------------------------------------------

	local HEROES_CHAIN_EXPERT_MISSION_BATTLES_TARGET = 10;
	
	do
		local name = "shared_heroes_trigger_pre_expert_threshold_approached";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.any_hero_won_x_battles(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {"StartHeroesChainExpert", "HeroesChainHeroUsed"},										-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "HeroesChainPreIssueExpertMission",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_victories") or HEROES_CHAIN_EXPERT_MISSION_BATTLES_TARGET - 2,											-- threshold number of victories
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;

	
	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_heroes_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or shared_prepend_str .. "_shared_heroes",															-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "HeroesChainIssueExpertMission",														-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Win X Battles With Any Hero [EXPERT]
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_heroes_win_x_battles";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.win_battles_with_hero(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_win_battles_with_hero_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_win_threshold") or HEROES_CHAIN_EXPERT_MISSION_BATTLES_TARGET,												-- target number of battles to win
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						4000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "high",																																	-- value of this mission
							glory_type = "khorne,slaanesh"																													-- glory type to issue
						}
					),
					payload.ancillary_mission_payload(faction_key, "armour", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "HeroesChainIssueExpertMission",														-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "HeroesChainHeroUsed",																-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-- output footer
	narrative.output_chain_footer();

end;











------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	FINANCE CHAIN
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function start_narrative_shared_chain_finance(faction_key)

	-- output header
	narrative.output_chain_header("finance", faction_key);

	local moderate_income = 3000;
	


	
	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_query_advice";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or {"StartFinanceChainExpert", "StartFinanceChainAux"},								-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or {"StartFinanceChainFull", "StartFinanceChainAux"},									-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					shared_prepend_str .. "_shared_gain_moderate_income"
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown before Gain Moderate Income Trigger
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_trigger_pre_gain_moderate_income_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartFinanceChainFull",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartFinanceGainModerateIncomeTrigger",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 3,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Pre Gain Moderate Income Trigger
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_trigger_pre_gain_moderate_income";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.net_income(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartFinanceGainModerateIncomeTrigger",												-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartFinanceGainModerateIncome",														-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_income") or moderate_income - 1000,																		-- opt condition
				narrative.get(faction_key, name .. "_trigger_when_lower") or true																				-- opt faction starting turn
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Gain Moderate Income
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_gain_moderate_income";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.gain_income(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_shared_gain_income_01",											-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_gain_income_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_income") or moderate_income, 																						-- number of units
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																-- issue money or equivalent
						500,																																		-- money reward, if we aren't giving something else for this faction
						faction_key,																																-- faction key
						{																																			-- params for potential money replacement
							value = "low",																																-- value of this mission
							glory_type = "nurgle"																														-- glory type to issue
						}
					),
					payload.ancillary_mission_payload(faction_key, "enchanted_item", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartFinanceGainModerateIncome",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "FinanceGainModerateIncomeCompleted",												-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History After Moderate Income Gained
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_moderate_income_gained_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or shared_prepend_str .. "_shared_gain_moderate_income",												-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "FinanceGainModerateIncomeCompleted",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or "StartFinanceChainExpert"															-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;









	-----------------------------------------------------------------------------------------------------------
	--	Aux Advice Query
	--	If the player has never received reduce-upkeep advice before then this auxiliary chain starts
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_query_advice_pre_positive_income";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartFinanceChainAux",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages"),																						-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartFinancePreRegainPositiveIncome",												-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					shared_prepend_str .. "_shared_reduce_upkeep"
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Regain Positive Income Trigger
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_trigger_pre_regain_positive_income";

		local function condition(context, nt)
			return context:faction():losing_money();
		end;

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_start(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartFinancePreRegainPositiveIncome",													-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartFinanceRegainPositiveIncome",													-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_condition") or condition,																					-- opt condition
				narrative.get(faction_key, name .. "_faction_starting_turn"),																					-- opt faction starting turn
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Regain Positive Income
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_trigger_regain_positive_income";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.gain_income(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_shared_regain_positive_income_01",									-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_regain_positive_income_01",								-- key of mission to deliver
				narrative.get(faction_key, name .. "_income") or 200,																							-- income
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																-- issue money or equivalent
						500,																																		-- money reward, if we aren't giving something else for this faction
						faction_key,																																-- faction key
						{																																			-- params for potential money replacement
							value = "low",																																-- value of this mission
							glory_type = "nurgle"																														-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartFinanceRegainPositiveIncome",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Reduce Upkeep Trigger
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_trigger_pre_reduce_upkeep";

		local function condition(context, nt)
			local faction = context:faction();
			return faction:losing_money() and faction:upkeep_income_percent() > 85;
		end;

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_start(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartFinanceRegainPositiveIncome",													-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartFinancReduceUpkeep",															-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_condition") or condition,																					-- opt condition
				narrative.get(faction_key, name .. "_faction_starting_turn"),																					-- opt faction starting turn
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Reduce Upkeep Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_reduce_upkeep";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.reduce_upkeep(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or shared_prepend_str .. "_shared_reduce_upkeep_01",											-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_reduce_upkeep_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_reduce_upkeep",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_threshold") or 80,																							-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																-- issue money or equivalent
						500,																																		-- money reward, if we aren't giving something else for this faction
						faction_key,																																-- faction key
						{																																			-- params for potential money replacement
							value = "low",																																-- value of this mission
							glory_type = "nurgle"																														-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartFinancReduceUpkeep",															-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "FinanceReduceUpkeepCompleted",													-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History After Reduce Upkeep
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_moderate_income_gained_reduce_upkeep";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or shared_prepend_str .. "_shared_reduce_upkeep",													-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "FinanceReduceUpkeepCompleted",														-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;










	

	
	local substantial_income = 6000;

	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Trigger Gain Substantial Income Mission if player income raises to within 500 of it
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_trigger_pre_gain_substantial_income_on_income";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.net_income(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartFinanceChainExpert",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartFinanceGainSubstantialIncome",													-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages") or "CancelFinanceGainSubstantialIncomeTriggerOnNearSubstantialIncome",					-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_income") or substantial_income - 500,																		-- opt condition
				narrative.get(faction_key, name .. "_trigger_when_lower") or false																				-- opt faction starting turn
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] A certain period after the expert chain starts, begin a trigger which monitors for player
	--	gaining an income 1000 less than the substantial income (rather than 500)
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_trigger_pre_gain_less_substantial_income_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartFinanceChainExpert",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or {																						-- target message(s) to trigger
					"StartFinanceGainLessSubstantialIncomeTrigger",
					"CancelFinanceGainSubstantialIncomeTriggerOnNearSubstantialIncome"
				},
				narrative.get(faction_key, name .. "_cancel_messages") or "StartFinanceGainSubstantialIncome",													-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 50,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Pre Gain Higher Income Trigger on Income
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_trigger_gain_less_substantial_income";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.net_income(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartFinanceGainLessSubstantialIncomeTrigger",										-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartFinanceGainSubstantialIncome",													-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_income") or substantial_income - 1000,																		-- opt condition
				narrative.get(faction_key, name .. "_trigger_when_lower") or false																				-- opt faction starting turn
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Failsafe Turn Countdown before Gain Substantial Income
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_trigger_pre_gain_substantial_income_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartFinanceChainExpert",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartFinanceGainSubstantialIncome",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 58,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Gain Substantial Income
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_finance_gain_substantial_income";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.gain_income(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or shared_prepend_str .. "_shared_gain_substantial_income_01",								-- key of mission to deliver
				narrative.get(faction_key, name .. "_income") or substantial_income, 																			-- income
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																-- issue money or equivalent
						3000,																																		-- money reward, if we aren't giving something else for this faction
						faction_key,																																-- faction key
						{																																			-- params for potential money replacement
							value = "high",																																-- value of this mission
							glory_type = "undivided"																													-- glory type to issue
						}
					),
					payload.ancillary_mission_payload(faction_key, "banner", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartFinanceGainSubstantialIncome",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list") or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"shared_finance_gain_moderate_income"
				}
			);
		end;
	end;










	-- output footer
	narrative.output_chain_footer();
end;











------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	RAISING ARMIES
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function start_narrative_shared_chain_raising_armies(faction_key)

	-- output header
	narrative.output_chain_header("raising armies", faction_key);


	


	-----------------------------------------------------------------------------------------------------------
	--	Message
	--	Translates StartNarrativeEvents message in to StartSharedRaisingArmyEvents, to provide a single
	--	point of entry
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_raising_armies_trigger_start";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.message(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedRaisingArmyEvents",														-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages")																							-- script message(s) on which to cancel
			);
		end;
	end;








	-----------------------------------------------------------------------------------------------------------
	--	Trigger on faction has no armies
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_raising_armies_trigger_on_no_armies";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedRaisingArmyEvents",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedRaisingArmiesHasNoArmiesMission",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventPlayerBattleSequenceCompleted",														-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						if cm:pending_battle_cache_faction_is_involved(faction_key) then
							local faction = cm:get_faction(faction_key);
							if faction then
								local mf_list = faction:military_force_list();
								for i, mf in model_pairs(mf_list) do
									if not mf:is_armed_citizenry() then
										return false;
									end;
								end;
								return true;
							end;
						end;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Raising Armies on No Armies
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_raising_armies_event_recruit_army_on_no_armies";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_shared_raise_army_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_raise_army",										-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "MilitaryForceCreated",
						condition =	function(context)
							local mf = context:military_force_created();
							return not mf:is_armed_citizenry() and mf:faction():name() == faction_key;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(2000)																														-- issue money
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedRaisingArmiesHasNoArmiesMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;











	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger pre-Raise Additional Army Triggers
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_raising_armies_trigger_pre_raise_army_triggers_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedRaisingArmyEvents",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedRaisingArmyTriggers",														-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 10,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Trigger on faction is ready to raise second army
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_raising_armies_trigger_on_ready_to_raise_second_army";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedRaisingArmyTriggers",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedRaisingArmiesRaiseArmyMission",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventHumanFactionTurnStart",																-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						-- return true if the faction is gaining money, has more than 15000 money, and all the enemies to the faction have 3 or more armies
						local faction = context:faction();

						if faction:losing_money() or faction:treasury() < 15000 or cm:num_mobile_forces_in_force_list(faction:military_force_list(), non_standard_army_types) ~= 1 then
							return false;
						end;
						
						-- count number of enemy armies
						local num_enemy_armies = 0;
						local faction_list = faction:factions_at_war_with();
						for i = 0, faction_list:num_items() - 1 do
							num_enemy_armies = num_enemy_armies + cm:num_mobile_forces_in_force_list(faction_list:item_at(i):military_force_list(), non_standard_army_types);
						end;
													
						return num_enemy_armies >= 3;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger pre-Raise Additional Army
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_raising_armies_trigger_pre_raise_army_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedRaisingArmyTriggers",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedRaisingArmiesRaiseArmyMission",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 4,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Raising a Second Army
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_raising_armies_event_recruit_army";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "war.camp.advice.raise_forces.001",														-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_shared_raise_army_02",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_raise_additional_army",							-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "MilitaryForceCreated",
						condition =	function(context)
							local mf = context:military_force_created();
							return not mf:is_armed_citizenry() and mf:faction():name() == faction_key;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						local faction = cm:get_faction(faction_key);
						if faction then
							local garrison_commander = cm:get_closest_character_from_filter_to_camera_from_faction(
								faction,
								function(char)
									return cm:char_is_garrison_commander(char);
								end
							);
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																-- issue money or equivalent
						1000,																																		-- money reward, if we aren't giving something else for this faction
						faction_key,																																-- faction key
						{																																			-- params for potential money replacement
							value = "low",																																-- value of this mission
							glory_type = "khorne,nurgle"																												-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedRaisingArmiesRaiseArmyMission",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;










	-- output footer
	narrative.output_chain_footer();
end;














------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	DIPLOMACY
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function start_narrative_shared_chain_diplomacy(faction_key)

	-- output header
	narrative.output_chain_header("diplomacy", faction_key);

	local advice_history_string = shared_prepend_str .. "_diplomacy_chain_completed";

	local DIPLOMACY_MISSIONS_AGREEMENT_CLOSE_THRESHOLD = -3;
	local DIPLOMACY_MISSIONS_AGREEMENT_A_BIT_CLOSE_THRESHOLD = -6;



	-- Listen for a diplomatic outpost being created
	if not cm:get_saved_value(faction_key .. "_diplomatic_outpost_created") then
		core:add_listener(
			"shared_diplomacy_outpost_creation_listener",
			"ForeignSlotManagerCreatedEvent",
			function(context)
				return context:requesting_faction():name() == faction_key and context:is_allied();
			end,
			function(context)
				cm:set_saved_value(faction_key .. "_diplomatic_outpost_created", true);
			end,
			false
		);
	end;

	-- Listen for a war co-ordination request being issued
	if not cm:get_saved_value(faction_key .. "_war_coordination_request_issued") then
		core:add_listener(
			"war_coordination_target_listener",
			"WarCoordinationRequestIssued",
			function(context)
				return context:faction():name() == faction_key;
			end,
			function(context)
				cm:set_saved_value(faction_key .. "_war_coordination_request_issued", true);
			end,
			false
		);
	end;





	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSharedDiplomacyChainExpert",													-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartSharedDiplomacyChainFull",													-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					advice_history_string
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;









	------------------------------------------------------------------------------------------------------------------------
	--	NON-AGGRESSION PACTS
	------------------------------------------------------------------------------------------------------------------------


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger pre non-aggression-pact possible trigger
	--	After this trigger fires, the NAP mission will be triggered if the faction is close to being able to
	--	agree a NAP with another faction (or after another countdown)
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_non_aggression_pact_turn_countdown_to_possible";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyNonAggressionPactPossibleTriggers",								-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "SharedDiplomacyNonAggressionPactMissionAgreed",										-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 8,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Detect a Non Aggression Pact being agreed before the mission is issued
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_non_aggression_pact_deal_agreed";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "SharedDiplomacyNonAggressionPactMissionAgreed",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "StartSharedDiplomacyNonAggressionPactMission",										-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "PositiveDiplomaticEvent",																		-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						return context:is_non_aggression_pact() and (context:proposer():name() == faction_key or context:recipient():name() == faction_key)
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger pre non-aggression-pact mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_non_aggression_pact_mission_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyNonAggressionPactPossibleTriggers",								-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyNonAggressionPactMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "SharedDiplomacyNonAggressionPactMissionAgreed",										-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 22,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;

	
	-----------------------------------------------------------------------------------------------------------
	--	Detect when a non-aggression pact is likely to be possible
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_non_aggression_pact_mission_agreement_is_possible";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyNonAggressionPactPossibleTriggers",								-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyNonAggressionPactMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "SharedDiplomacyNonAggressionPactMissionAgreed",										-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventHumanFactionTurnStart",																-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						local highest_score = false;

						local faction = context:faction();
						if faction:name() == faction_key then
							local factions_met = faction:factions_met();
							for i, met_faction in model_pairs(factions_met) do
								if not faction:non_aggression_pact_with(met_faction) then
									local score, can_issue = cm:cai_evaluate_quick_deal_action(faction, met_faction, "diplomatic_option_nonaggression_pact");
									if can_issue then
										if not highest_score or score > highest_score then
											highest_score = score;
										end;
									end;
								end;
							end;
						end;

						return highest_score and highest_score > DIPLOMACY_MISSIONS_AGREEMENT_CLOSE_THRESHOLD;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Agree Non-Aggression Pact Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_event_non_aggression_pact_mission";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_shared_non_aggression_pact_01",									-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_shared_non_aggression_pact_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "mis_activity_sign_non_aggression_pact_any",												-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "PositiveDiplomaticEvent",
						condition =	function(context)
							return context:is_non_aggression_pact() and (context:proposer():name() == faction_key or context:recipient():name() == faction_key)
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						500,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "low",																																	-- value of this mission
							glory_type = "undivided"																														-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedDiplomacyNonAggressionPactMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "SharedDiplomacyNonAggressionPactMissionAgreed",									-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;














	------------------------------------------------------------------------------------------------------------------------
	--	TRADE
	------------------------------------------------------------------------------------------------------------------------

	narrative.todo_output("Trade missions should automatically detect if the faction cannot trade");


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger pre trade agreement possible trigger
	--	After this trigger fires, the trade mission will be triggered if the faction is close to being able to
	--	agree trade with another faction (or after another countdown)
	--	Trade events are fired after non-aggression pact agreed.
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_trade_turn_countdown_to_possible";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "SharedDiplomacyNonAggressionPactMissionAgreed",										-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyTradeAgreementPossibleTriggers",									-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "SharedDiplomacyTradeAgreementMade",													-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 1,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Detect a Trade Agreement being made before the mission is issued
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_trade_deal_agreed";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "SharedDiplomacyTradeAgreementMade",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "StartSharedDiplomacyTradeAgreementMission",											-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "PositiveDiplomaticEvent",																		-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						return context:is_trade_agreement() and (context:proposer():name() == faction_key or context:recipient():name() == faction_key)
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger pre Trade Agreement mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_trade_mission_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyTradeAgreementPossibleTriggers",									-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyTradeAgreementMission",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "SharedDiplomacyTradeAgreementMade",													-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 18,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Detect when a trade agreement is likely to be possible
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_trade_mission_agreement_is_possible";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyTradeAgreementPossibleTriggers",									-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyTradeAgreementMission",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "SharedDiplomacyTradeAgreementMade",													-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventHumanFactionTurnStart",																-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						local highest_score = false;

						local faction = context:faction();
						if faction:name() == faction_key then
							local factions_met = faction:factions_met();
							for i, met_faction in model_pairs(factions_met) do
								if not faction:trade_agreement_with(met_faction) then
									local score, can_issue = cm:cai_evaluate_quick_deal_action(faction, met_faction, "diplomatic_option_trade_agreement");
									if can_issue then
										if not highest_score or score > highest_score then
											highest_score = score;
										end;
									end;
								end;
							end;
						end;

						return highest_score and highest_score > DIPLOMACY_MISSIONS_AGREEMENT_CLOSE_THRESHOLD;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Make Trade Agreement Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_event_trade_mission";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_shared_trade_agreement_01",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_shared_trade_agreement_01",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "mis_activity_make_trade_any",															-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "PositiveDiplomaticEvent",
						condition =	function(context)
							return context:is_trade_agreement() and (context:proposer():name() == faction_key or context:recipient():name() == faction_key)
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						1000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "med",																																	-- value of this mission
							glory_type = "nurgle"																														-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedDiplomacyTradeAgreementMission",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "SharedDiplomacyTradeAgreementMade",												-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;














	

	------------------------------------------------------------------------------------------------------------------------
	--	MILITARY ALLIANCES
	------------------------------------------------------------------------------------------------------------------------




	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger pre Military Alliance triggers
	--	This will start the military alliance triggers if a non-aggression pact has not been made by this time
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_military_alliance_turn_countdown_from_chain_start";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyTriggerMilitaryAllianceEvents",									-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or {																						-- script message(s) on which to cancel
					"SharedDiplomacyMilitaryAllianceAgreed",
					"SharedDiplomacyNonAggressionPactMissionAgreed",
				},
				narrative.get(faction_key, name .. "_num_turns") or 32,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Query Whether Military Alliance Already Formed
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_event_query_military_alliance_already_formed";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or {																					-- message(s) on which to trigger
					"SharedDiplomacyNonAggressionPactMissionAgreed",
					"StartSharedDiplomacyTriggerMilitaryAllianceEvents"
				},
				narrative.get(faction_key, name .. "_positive_messages"),																						-- message(s) on value exists
				narrative.get(faction_key, name .. "_negative_messages") or "StartSharedDiplomacyMilitaryAllianceInitialCountdown",
				narrative.get(faction_key, name .. "_value_key") or faction_key .. "_military_alliance_formed",													-- value key
				narrative.get(faction_key, name .. "_condition")																								-- condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger pre Form Military Alliance trigger
	--	After this trigger fires, the military alliance mission will be triggered if the faction is close to
	--	being able to agree a military alliance with another faction (or after another countdown)
	--	Military Alliance events are fired after trade agreement is made.
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_military_alliance_turn_countdown_to_possible";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyMilitaryAllianceInitialCountdown",								-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyMilitaryAlliancePossibleTriggers",								-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or {																						-- script message(s) on which to cancel
					"SharedDiplomacyMilitaryAllianceAgreed",
					"SharedDiplomacyFactionHasHadMilitaryAlliance"
				},
				narrative.get(faction_key, name .. "_num_turns") or 8,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Detect a Military Alliance happening before the mission is issued
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_military_alliance_agreed";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "SharedDiplomacyMilitaryAllianceAgreed",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "StartSharedDiplomacyMilitaryAllianceMission",										-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "PositiveDiplomaticEvent",																		-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						return context:is_military_alliance() and (context:proposer():name() == faction_key or context:recipient():name() == faction_key)
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Detect when a Military Alliance is close to being possible
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_military_alliance_mission_agreement_is_possible";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyMilitaryAlliancePossibleTriggers",								-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyMilitaryAllianceMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or {																						-- script message(s) on which to cancel
					"StartSharedDiplomacyMilitaryAllianceABitPossibleTrigger",
					"SharedDiplomacyMilitaryAllianceAgreed"
				},
				narrative.get(faction_key, name .. "_event") or "ScriptEventHumanFactionTurnStart",																-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						local highest_score = false;

						local faction = context:faction();
						if faction:name() == faction_key then
							local factions_met = faction:factions_met();
							for i, met_faction in model_pairs(factions_met) do
								if not faction:military_allies_with(met_faction) then
									local score, can_issue = cm:cai_evaluate_quick_deal_action(faction, met_faction, "diplomatic_option_military_alliance");
									if can_issue then
										if not highest_score or score > highest_score then
											highest_score = score;
										end;
									end;
								end;
							end;
						end;

						return highest_score and highest_score > DIPLOMACY_MISSIONS_AGREEMENT_CLOSE_THRESHOLD;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger pre Military Alliance mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_military_alliance_mission_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyMilitaryAlliancePossibleTriggers",								-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyMilitaryAllianceABitPossibleTrigger",							-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or {																						-- script message(s) on which to cancel
					"StartSharedDiplomacyMilitaryAllianceMission",
					"SharedDiplomacyMilitaryAllianceAgreed",
					"SharedDiplomacyFactionHasHadMilitaryAlliance"
				},
				narrative.get(faction_key, name .. "_num_turns") or 10,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Detect when a Military Alliance is less close to being possible
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_military_alliance_mission_agreement_is_a_bit_possible";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyMilitaryAllianceABitPossibleTrigger",								-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyMilitaryAllianceMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "SharedDiplomacyMilitaryAllianceAgreed",												-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventHumanFactionTurnStart",																-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						local highest_score = false;

						local faction = context:faction();
						if faction:name() == faction_key then
							local factions_met = faction:factions_met();
							for i, met_faction in model_pairs(factions_met) do
								if not faction:military_allies_with(met_faction) then
									local score, can_issue = cm:cai_evaluate_quick_deal_action(faction, met_faction, "diplomatic_option_military_alliance");
									if can_issue then
										if not highest_score or score > highest_score then
											highest_score = score;
										end;
									end;
								end;
							end;
						end;

						return highest_score and highest_score > DIPLOMACY_MISSIONS_AGREEMENT_A_BIT_CLOSE_THRESHOLD;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Form Military Alliance Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_event_form_military_alliance_mission";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_shared_military_alliance_01",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_shared_military_alliance_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_enter_military_alliance",						-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "PositiveDiplomaticEvent",
						condition =	function(context)
							return context:is_military_alliance() and (context:proposer():name() == faction_key or context:recipient():name() == faction_key);
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						2000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "high",																																	-- value of this mission
							glory_type = "khorne"																															-- glory type to issue
						}
					),
					payload.ancillary_mission_payload(faction_key, "banner", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedDiplomacyMilitaryAllianceMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or {																					-- script message(s) to trigger when this mission is completed
					"SharedDiplomacyMilitaryAllianceAgreed",
					"StartSharedDiplomacyEarnAllegianceMission"
				},
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Savegame of Military Alliance
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_event_military_alliance_mark_savegame";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_saved_value(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_value_key") or faction_key .. "_military_alliance_formed",													-- value key for savegame
				narrative.get(faction_key, name .. "_value") or true,																							-- value to save
				narrative.get(faction_key, name .. "_trigger_messages") or {																					-- script message(s) on which to trigger when received
					"SharedDiplomacyMilitaryAllianceAgreed",
					"SharedDiplomacyFactionHasHadMilitaryAlliance"
				},
				narrative.get(faction_key, name .. "_on_issued_messages")
			);
		end;
	end;











	------------------------------------------------------------------------------------------------------------------------
	--	CONFEDERATION
	------------------------------------------------------------------------------------------------------------------------


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger pre confederation triggers
	--	This will start the confederation triggers if a non-aggression pact has not been made by this time
	-----------------------------------------------------------------------------------------------------------

	narrative.todo_output("Confederation missions should automatically detect if the faction cannot agree a confederation (including if there is no-one of the same race)");

	do
		local name = "shared_diplomacy_trigger_pre_confederation_turn_countdown_from_chain_start";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyTriggerConfederationEvents",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or {																						-- script message(s) on which to cancel
					"SharedDiplomacyConfederationAgreed",
					"SharedDiplomacyNonAggressionPactMissionAgreed"
				},
				narrative.get(faction_key, name .. "_num_turns") or 50,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger pre Confedation trigger
	--	After this trigger fires, the confederation mission will be triggered if the faction is close to being able 
	--	to agree confederation with another faction (or after another countdown)
	--	Confederation events are fired after non-aggression-pact is made.
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_confederation_turn_countdown_to_possible";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {																						-- script message(s) on which to start
					"SharedDiplomacyNonAggressionPactMissionAgreed",
					"StartSharedDiplomacyTriggerConfederationEvents"
				},
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyConfederationPossibleTriggers",									-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "SharedDiplomacyConfederationAgreed",													-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 10,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Detect a confederation happening before the mission is issued
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_confederation_deal_agreed";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyChainFull",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "SharedDiplomacyConfederationAgreed",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "StartSharedDiplomacyConfederationMission",											-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "FactionJoinsConfederation",																	-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						return context:confederation():name() == faction_key;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Detect when a confederation is likely to be possible
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_confederation_mission_agreement_is_possible";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyConfederationPossibleTriggers",									-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyConfederationMission",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or {																						-- script message(s) on which to cancel
					"SharedDiplomacyConfederationAgreed",
					"StartSharedDiplomacyConfederationABitPossibleTriggers"
				},
				narrative.get(faction_key, name .. "_event") or "ScriptEventHumanFactionTurnStart",																-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						local highest_score = false;

						local faction = context:faction();
						if faction:name() == faction_key then
							local factions_met = faction:factions_met();
							for i, met_faction in model_pairs(factions_met) do
								local score, can_issue = cm:cai_evaluate_quick_deal_action(faction, met_faction, "diplomatic_option_confederation");
								if can_issue then
									if not highest_score or score > highest_score then
										highest_score = score;
									end;
								end;
							end;
						end;

						return highest_score and highest_score > DIPLOMACY_MISSIONS_AGREEMENT_CLOSE_THRESHOLD;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger pre Confederation mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_confederation_mission_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyConfederationPossibleTriggers",									-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyConfederationABitPossibleTriggers",								-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "SharedDiplomacyConfederationAgreed",													-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 10,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Detect when a confederation is less close to being possible
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_confederation_mission_agreement_is_a_bit_possible";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyConfederationABitPossibleTriggers",								-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyConfederationMission",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages") or "SharedDiplomacyConfederationAgreed",													-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventHumanFactionTurnStart",																-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						local highest_score = false;

						local faction = context:faction();
						if faction:name() == faction_key then
							local factions_met = faction:factions_met();
							for i, met_faction in model_pairs(factions_met) do
								local score, can_issue = cm:cai_evaluate_quick_deal_action(faction, met_faction, "diplomatic_option_confederation");
								if can_issue then
									if not highest_score or score > highest_score then
										highest_score = score;
									end;
								end;
							end;
						end;

						return highest_score and highest_score > DIPLOMACY_MISSIONS_AGREEMENT_A_BIT_CLOSE_THRESHOLD;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Confederate Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_event_confederation_mission";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_shared_war_confederation_01",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_shared_confederate_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "mis_activity_confederate_faction_any",													-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "FactionJoinsConfederation",
						condition =	function(context)
							return context:confederation():name() == faction_key;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						2000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "high",																																	-- value of this mission
							glory_type = "slaanesh"																															-- glory type to issue
						}
					),
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedDiplomacyConfederationMission",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "SharedDiplomacyConfederationAgreed",												-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;













	------------------------------------------------------------------------------------------------------------------------
	--	QUERY MILITARY ALLIANCE ON STARTUP
	------------------------------------------------------------------------------------------------------------------------


	-----------------------------------------------------------------------------------------------------------
	--	Has Military Alliance Query on Chain Start
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_query_military_alliance_chain_start";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.has_military_alliance(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedDiplomacyChainFull",														-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSharedDiplomacyPreEarnAllegianceTurnCountdown",								-- positive target message(s)
				narrative.get(faction_key, name .. "_negative_messages") or "StartSharedDiplomacyQueryHasDefensiveAlliance",									-- negative target message(s)
				narrative.get(faction_key, name .. "_target_faction"),																							-- opt target faction(s)
				narrative.get(faction_key, name .. "_target_culture"),																							-- opt target cultures(s)
				narrative.get(faction_key, name .. "_target_subculture"),																						-- opt target subcultures(s)
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Has Defensive Alliance Query on Chain Start
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_query_defensive_alliance_chain_start";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.has_defensive_alliance(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedDiplomacyQueryHasDefensiveAlliance",										-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSharedDiplomacyPreEarnAllegianceTurnCountdown",								-- positive target message(s)
				narrative.get(faction_key, name .. "_negative_messages"),																						-- negative target message(s)
				narrative.get(faction_key, name .. "_target_faction"),																							-- opt target faction(s)
				narrative.get(faction_key, name .. "_target_culture"),																							-- opt target cultures(s)
				narrative.get(faction_key, name .. "_target_subculture"),																						-- opt target subcultures(s)
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger post Chain Start Alliance Queries
	--	Potentially triggers the Earn Allegiance mission if the faction started the game
	--	with an alliance and still has one by this point
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_post_chain_start_alliance_queries_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyPreEarnAllegianceTurnCountdown",									-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyPreEarnAllegianceQueries",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 7,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Has Military Alliance Query pre Earn Allegiance Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_query_military_alliance_pre_earn_allegiance";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.has_military_alliance(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedDiplomacyPreEarnAllegianceQueries",										-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or {																					-- positive target message(s)
					"StartSharedDiplomacyEarnAllegianceMission",
					"SharedDiplomacyFactionHasHadMilitaryAlliance"
				},
				narrative.get(faction_key, name .. "_negative_messages") or "StartSharedDiplomacyPreEarnAllegianceDefensiveAllianceQuery",						-- negative target message(s)
				narrative.get(faction_key, name .. "_target_faction"),																							-- opt target faction(s)
				narrative.get(faction_key, name .. "_target_culture"),																							-- opt target cultures(s)
				narrative.get(faction_key, name .. "_target_subculture"),																						-- opt target subcultures(s)
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Has Defensive Alliance Query pre Earn Allegiance Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_query_defensive_alliance_pre_earn_allegiance";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.has_defensive_alliance(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedDiplomacyPreEarnAllegianceDefensiveAllianceQuery",						-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSharedDiplomacyEarnAllegianceMission",										-- positive target message(s)
				narrative.get(faction_key, name .. "_negative_messages"),																						-- negative target message(s)
				narrative.get(faction_key, name .. "_target_faction"),																							-- opt target faction(s)
				narrative.get(faction_key, name .. "_target_culture"),																							-- opt target cultures(s)
				narrative.get(faction_key, name .. "_target_subculture"),																						-- opt target subcultures(s)
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;






	









	

	------------------------------------------------------------------------------------------------------------------------
	--	ALLEGIANCE and OUTPOSTS
	------------------------------------------------------------------------------------------------------------------------


	-----------------------------------------------------------------------------------------------------------
	--	Earn Allegiance Mission
	--	Triggered a short time after the start of the game if the faction started the campaign with a
	--	military alliance, or after the faction completes the military alliance mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_event_earn_allegiance_mission";

		local allegiance_threshold = 20;

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_shared_earn_allegiance_01",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_shared_earn_allegiance_01",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_earn_allegiance",								-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventHumanFactionTurnStart",
						condition =	function(context)
							local faction = context:faction();
							if faction:name() == faction_key then
								local allied_factions = faction:factions_allied_with();
								local wc_interface = cm:war_coordination();

								for i, allied_faction in model_pairs(allied_factions) do
									local allegiance = wc_interface:get_faction_favour_points_toward_faction(faction, allied_faction);
									if allegiance >= allegiance_threshold then
										return true;
									end;
								end;
							end;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						-- scroll the camera to the closest visible settlement of the known faction with the highest existing allegiance
						local faction = cm:get_faction(faction_key);
						if not faction then
							return;
						end;

						local highest_allegiance = -1;
						local highest_allegiance_faction = false;

						local factions_met = faction:factions_met();
						local wc_interface = cm:war_coordination();

						for i, faction_met in model_pairs(factions_met) do
							if faction:allied_with(faction_met) then
								local allegiance = wc_interface:get_faction_favour_points_toward_faction(faction_met, faction);
								if allegiance > highest_allegiance then
									highest_allegiance = allegiance;
									highest_allegiance_faction = faction_met;
								end;
							end;
						end;

						if not highest_allegiance_faction then
							return false;
						end;

						local closest_region = cm:get_closest_settlement_from_faction_to_faction(highest_allegiance_faction, faction);
						if closest_region then
							local closest_gc = cm:get_garrison_commander_of_region(closest_region);
							if closest_gc and closest_gc:is_visible_to_faction(faction_key) then
								return closest_region:name();
							end;
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						800,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "low",																																	-- value of this mission
							glory_type = "tzeentch"																															-- glory type to issue
						}
					),
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedDiplomacyEarnAllegianceMission",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "SharedDiplomacyAllegianceEarned",													-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Has Military Alliance Query pre Earn Allegiance Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_query_military_alliance_pre_construct_outpost";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.has_military_alliance(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedDiplomacyEarnAllegianceMission",											-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartSharedDiplomacyPreConstructOutpostQuery",										-- positive target message(s)
				narrative.get(faction_key, name .. "_negative_messages"),																						-- negative target message(s)
				narrative.get(faction_key, name .. "_target_faction"),																							-- opt target faction(s)
				narrative.get(faction_key, name .. "_target_culture"),																							-- opt target cultures(s)
				narrative.get(faction_key, name .. "_target_subculture"),																						-- opt target subcultures(s)
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Query Whether Outpost Constructed
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_query_outpost_constructed";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedDiplomacyPreConstructOutpostQuery",										-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "SharedDiplomacyOutpostConstructed",												-- message(s) on value exists
				narrative.get(faction_key, name .. "_negative_messages") or "StartSharedDiplomacyConstructOutpostTrigger",
				narrative.get(faction_key, name .. "_value_key") or faction_key .. "_diplomatic_outpost_created",												-- value key
				narrative.get(faction_key, name .. "_condition")																								-- condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Trigger When Outpost can be constructed
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_can_construct_outpost";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartSharedDiplomacyConstructOutpostTrigger",											-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyConstructOutpostMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventHumanFactionTurnStart",																-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context, nt)
						-- Return true if this faction has an ally that controls any province capital that doesn't already contain an allied foreign slot
						local faction = cm:get_faction(faction_key);
						if faction then
							for i, allied_faction in model_pairs(faction:factions_military_allies_with()) do
								local allied_regions_list = allied_faction:region_list();
								for j, allied_faction_region in model_pairs(allied_regions_list) do
									if allied_faction_region:is_province_capital() then
										local allied_foreign_slot_present = false;

										local fsm_list = allied_faction_region:foreign_slot_managers();
										for k, fsm in model_pairs(fsm_list) do
											if fsm:faction():military_allies_with(allied_faction) then
												allied_foreign_slot_present = true;
												break;
											end;
										end;

										if not allied_foreign_slot_present then
											return true;
										end;
									end;
								end;
							end;
						end;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;
	

	-----------------------------------------------------------------------------------------------------------
	--	Construct Outpost Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_event_construct_outpost_mission";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_shared_construct_outpost_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_construct_outpost",								-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ForeignSlotManagerCreatedEvent",
						condition =	function(context)
							return context:requesting_faction():name() == faction_key and context:is_allied();
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						1200,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "med",																																	-- value of this mission
							glory_type = "nurgle,slaanesh"																													-- glory type to issue
						}
					),
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedDiplomacyConstructOutpostMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "SharedDiplomacyOutpostConstructed",												-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;














	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger pre War Co-ordination Target mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_trigger_pre_war_coordination_mission_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "SharedDiplomacyAllegianceEarned",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedDiplomacyWarCoordinationQuery",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 4,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Query Whether War Co-ordination Target requested
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_query_war_coordination_target_requested";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedDiplomacyWarCoordinationQuery",											-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages"),																						-- message(s) on value exists
				narrative.get(faction_key, name .. "_negative_messages") or "StartSharedDiplomacyWarCoordinationMission",
				narrative.get(faction_key, name .. "_value_key") or faction_key .. "_war_coordination_request_issued",											-- value key
				narrative.get(faction_key, name .. "_condition")																								-- condition function
			);
		end;
	end;

	-----------------------------------------------------------------------------------------------------------
	--	Set War Co-ordination Target
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_event_set_war_coordination_target_mission";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_shared_war_coordination_01",										-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_shared_set_war_coordination_target_01",							-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_set_war_coordination_target",					-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "WarCoordinationRequestIssued",
						condition =	function(context)
							return context:faction():name() == faction_key;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						800,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "low",																																	-- value of this mission
							glory_type = "khorne"																															-- glory type to issue
						}
					),
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedDiplomacyWarCoordinationMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "SharedDiplomacyWarCoordinationRequestIssued",										-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;













	-----------------------------------------------------------------------------------------------------------
	--	Query whether all relevant narrative event in the diplomacy chain have been triggered, and then transition to expert mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_diplomacy_query_check_for_transition_to_expert";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.narrative_event_has_triggered(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or {																					-- message(s) on which to trigger
					"SharedDiplomacyConfederationAgreed",
					"SharedDiplomacyOutpostConstructed",
					"SharedDiplomacyWarCoordinationRequestIssued"
				},
				narrative.get(faction_key, name .. "_positive_messages") or "StartSharedDiplomacyTransitionToExpert",											-- positive target message(s) - player is one turn from completing province
				narrative.get(faction_key, name .. "_negative_messages"),																						-- negative target message(s) - player is not one turn from completing province
				narrative.get(faction_key, name .. "_ne_name") or {																								-- narrative event name(s)
					"shared_diplomacy_event_confederation_mission",
					"shared_diplomacy_event_construct_outpost_mission",
					"shared_diplomacy_event_set_war_coordination_target_mission"
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
		local name = "shared_diplomacy_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or advice_history_string,																			-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedDiplomacyTransitionToExpert",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;








	
	narrative.todo_output("Implement expert mission for diplomatic chain");








	



	-- output footer
	narrative.output_chain_footer();
end;















------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	GIFT OF SLAANESH
--	Issue a mission to get rid of a Gift of Slaanesh when one is received
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function start_narrative_shared_chain_received_gifts_of_slaanesh(faction_key)

	-- output header
	narrative.output_chain_header("received gifts of slaanesh", faction_key);

	

	-- cqi of character that received the gift
	local tagged_character_cqi = false;


	-----------------------------------------------------------------------------------------------------------
	--	Trigger When Gift of Slaanesh is received
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "shared_gift_of_slaanesh_trigger_on_gift_received";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartNarrativeEvents",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartSharedGiftOfSlaaneshLoseGiftMission",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "FactionCharacterTagAddedEvent",																-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						-- Return true if this is Gift of Slaanesh and the receiving character is in the subject faction, also caching the character's cqi
						local tag_entry = context:tag_entry();
						if tag_entry == "wh3_main_character_tag_gift_of_slaanesh" then
							local receiving_char = tag_entry:character():character();
							if receiving_char:faction():name() == faction_key then
								tagged_character_cqi = receiving_char:command_queue_index();
								return true;
							end
						end
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Lose Gift of Slaanesh
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "shared_gift_of_slaanesh_event_lose_gift";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_shared_received_gift_of_slaanesh_01",							-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_lose_gifts_of_slaanesh",							-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventHumanFactionTurnStart",
						condition =	function(context)
							local faction = context:faction();
							if faction:name() == faction_key then
								-- Return false if any character in the faction has a Gift of Slaanesh
								local tagging_system = faction:model():world():faction_character_tagging_system();
								
								for i, character in model_pairs(faction:character_list()) do
									local family_member = character:family_member();
									if tagging_system:is_character_tagged(family_member) then
										if tagging_system:character_tag(family_member):tag_record_key() == "wh3_main_character_tag_gift_of_slaanesh" then
											return false;
										end;
									end;
								end;

								return true;
							end;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						if tagged_character_cqi then
							return tagged_character_cqi;
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(3000),																															-- issue money
					payload.ancillary_mission_payload(faction_key, "talisman", "common")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedGiftOfSlaaneshLoseGiftMission",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;






	-- output footer
	narrative.output_chain_footer();
end;















------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	Start all Chains
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function start_narrative_events_shared_for_faction(faction_key)

	-----------------------------------------------------------------------------------------------------------
	--	Pre Intro Story Panel Delay
	-----------------------------------------------------------------------------------------------------------

	-- Triggers the how-they-play event for the player's faction, after the intro cutscene is finished.
	do
		local name = "pre_intro_story_panel_delay";

		if not narrative.get(faction_key, "suppress_pre_intro_story_panel_delay") then
			narrative_events.interval(
				name,																																			-- unique name for narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_interval") or 0.5,																							-- interval to wait in s
				narrative.get(faction_key, name .. "_trigger_messages") or "PreStartIntroStory",																-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or "StartIntroStory"																	-- script message(s) on which to trigger when received
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Intro Story Panel
	-----------------------------------------------------------------------------------------------------------

	-- Triggers the intro story panel the player's faction, now MP only
	do
		local name = "intro_story_panel";

		if not narrative.get(faction_key, "suppress_intro_story_panel") then
			narrative_events.callback(
				name,																																			-- unique name for narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_callback") or 																								-- callback to call
					function(ne, faction_key, triggering_message, allow_issue_completed_callback)
						if cm:is_multiplayer() then
							core:trigger_event("ScriptEventShowIntroStoryPanel", cm:get_faction(faction_key));
						end;
					end,
				narrative.get(faction_key, name .. "_trigger_messages") or "StartIntroStory",																	-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or "StartPreHowTheyPlay"																-- script message(s) on which to trigger when received
			);
		end;
	end;

	

	-----------------------------------------------------------------------------------------------------------
	--	Pre How They Play
	-----------------------------------------------------------------------------------------------------------

	-- Triggers the how-they-play event for the player's faction, after the intro cutscene is finished.
	do
		local name = "pre_how_they_play_delay";

		if not narrative.get(faction_key, "suppress_pre_how_they_play_delay") then
			narrative_events.interval(
				name,																																			-- unique name for narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_interval") or 0.5,																							-- interval to wait in s
				narrative.get(faction_key, name .. "_trigger_messages") or "StartPreHowTheyPlay",																-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or "StartHowTheyPlay"																	-- script message(s) on which to trigger when received
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	How They Play
	-----------------------------------------------------------------------------------------------------------

	-- Triggers the how-they-play event for the player's faction, after the intro cutscene is finished.
	do
		local name = "how_they_play";

		if not narrative.get(faction_key, "suppress_how_they_play_event") then
			narrative_events.how_they_play(
				name,																																			-- unique name for narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartHowTheyPlay",																	-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or "StartNarrativeEvents"																-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Start Narrative Events
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chs_event_start";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages"),																							-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "PreStartIntroStory",																	-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_script_event") or "ScriptEventIntroCutsceneFinished",														-- script event to listen for
				narrative.get(faction_key, name .. "_event_condition") or true,																					-- event condition
				narrative.get(faction_key, "_immediate_trigger") or true 																						-- immediate trigger
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Start Narrative Events [Multiplayer]
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chs_event_start_mp";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages"),																							-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "PreStartIntroStory",																	-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_script_event") or "ScriptEventStartNarrativeEventsMP",														-- script event to listen for
				narrative.get(faction_key, name .. "_event_condition") or true,																					-- event condition
				narrative.get(faction_key, "_immediate_trigger") or true 																						-- immediate trigger
			);
		end;
	end;

	if not narrative.exception_factions[faction_key] then
		start_narrative_shared_chain_settlement_captured(faction_key);
		start_narrative_shared_chain_unit_recruitment(faction_key);
		start_narrative_shared_chain_settlement_upgrade(faction_key);
		start_narrative_shared_chain_technology_research(faction_key);
		start_narrative_shared_chain_heroes(faction_key);
		start_narrative_shared_chain_finance(faction_key);
		start_narrative_shared_chain_raising_armies(faction_key);
		start_narrative_shared_chain_diplomacy(faction_key);
		start_narrative_shared_chain_received_gifts_of_slaanesh(faction_key);
	end
end;


-- Ensure that start_narrative_events_shared_for_faction() is called when narrative system is started
narrative.add_loader(start_narrative_events_shared_for_faction)