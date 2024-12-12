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

out.narrative("* wh3_narrative_ogres.lua loaded");

local shared_prepend_str = shared_narrative_event_prepend_str;






------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	CAMPS
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function ogre_camps_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("ogre camps", faction_key);

	local advice_history_string = shared_prepend_str .. "_ogre_camps_chain_completed";










	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "ogre_camps_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartOgreCampsChainExpert",														-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartOgreCampsChainFull",															-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					advice_history_string
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;




	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre-Deploy Camp
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "ogre_camps_trigger_pre_deploy_camp_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartOgreCampsChainFull",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartOgreCampsDeployCampMission",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 4,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;

	
	-----------------------------------------------------------------------------------------------------------
	--	Technology Trigger pre-Deploy Camp
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "ogre_camps_trigger_deploy_camp_on_technology";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.technology_research_completed(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartOgreCampsChainFull",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartOgreCampsDeployCampMission",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
																		-- Camp Huddle
				narrative.get(faction_key, name .. "_technologies") or "wh3_main_tech_ogr_0_0_0",																-- technology key(s)
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Deploy Camp Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "ogre_camps_event_deploy_camp";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_ogres_deploy_camp_01",											-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_ogres_deploy_camp_01",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_deploy_ogre_camp",								-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "CharacterCreated",
						condition =	function(context)
							local char = context:character();
							return char:faction():name() == faction_key and cm:char_is_general_with_army(char) and char:military_force():force_type():key() == "OGRE_CAMP";
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
					payload.money(500, faction_key)																													-- issue money
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartOgreCampsDeployCampMission",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartOgreCampsConstructCampBuildingMission",										-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Construct Camp Building Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "ogre_camps_event_construct_camp_building";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_ogres_construct_camp_building_01",								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_ogres_construct_camp_building_01",								-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_construct_ogre_camp_building",					-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "MilitaryForceBuildingCompleteEvent",
						condition =	function(context)
							local char = context:character();
							return char:faction():name() == faction_key and cm:char_is_general_with_army(char) and char:military_force():force_type():key() == "OGRE_CAMP";
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						local faction = cm:get_faction(faction_key);
						local mf_list = faction:military_force_list();
						for i, mf in model_pairs(mf_list) do
							if mf:force_type():key() == "OGRE_CAMP" and mf:has_general() then
								return mf:general_character():command_queue_index();
							end;
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.ancillary_mission_payload(faction_key, "banner", "common")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartOgreCampsConstructCampBuildingMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartOgreCampsTransitionToExpert",												-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "ogre_camps_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or advice_history_string,																			-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "StartOgreCampsTransitionToExpert",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;







	




	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn Countdown pre-Research Camp Technology
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "ogre_camps_trigger_pre_research_expert_tech_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {																						-- script message(s) on which to start
					"StartOgreCampsTransitionToExpert",
					"StartOgreCampsChainExpert"
				},
				narrative.get(faction_key, name .. "_target_messages") or "StartOgreCampsResearchExpertTechMission",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 25,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Research Camp Technology
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "ogre_camps_research_expert_tech";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.research_technology(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_ogres_research_camps_tech_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_num_technologies") or 1,																					-- num technologies
				narrative.get(faction_key, name .. "_technologies") or "wh3_main_tech_ogr_0_3_0",																-- opt mandatory technologies
				narrative.get(faction_key, name .. "_include_existing") or true,																				-- includes existing technologies
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(1000, faction_key),																												-- issue money or equivalent
					payload.ancillary_mission_payload(faction_key, "talisman", "rare")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartOgreCampsResearchExpertTechMission",											-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")	or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"ogre_camps_event_deploy_camp",
					"ogre_camps_event_construct_camp_building"
				}
			);
		end;
	end;	



	narrative.output_chain_footer();

end;












------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	MEAT
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function ogre_meat_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("ogre meat", faction_key);

	local advice_history_string = shared_prepend_str .. "_meat_chain_completed";

	local pr_meat_key = "wh3_main_ogr_meat";







	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "ogre_meat_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartOgreMeatChainExpert",															-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartOgreMeatChainFull",															-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					advice_history_string
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre-Start Meat Triggers
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "ogre_meat_trigger_pre_start_meat_triggers_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartOgreMeatChainFull",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartOgreMeatTriggers",																-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 5,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Trigger on Low Meat on any army
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "ogre_meat_trigger_low_meat";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartOgreMeatTriggers",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartOgreMeatLowMeatMission",														-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventTrackedPooledResourceChanged",														-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						if context:has_faction() and context:faction():name() == faction_key and context:resource():key() == pr_meat_key then
							local mf_list = context:faction():military_force_list();
							for i, mf in model_pairs(mf_list) do
								if not mf:is_armed_citizenry() then
									local prm = mf:pooled_resource_manager();
									local pr_meat = prm:resource(pr_meat_key);
									if not pr_meat:is_null_interface() and pr_meat:value() <= 20 then
										narrative.add_data_for_faction(faction_key, "ogre_meat_low_meat_mf_cqi", mf:command_queue_index())
										return true;
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
	-- Gain Meat Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "ogre_meat_event_gain_meat_mission";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_ogres_gain_meat_02",												-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_ogres_meat_01",													-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_restore_meat",									-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventTrackedPooledResourceChanged",
						condition =	function(context)
							if context:has_faction() and context:faction():name() == faction_key and context:resource():key() == pr_meat_key then
								local mf_list = context:faction():military_force_list();
								for i, mf in model_pairs(mf_list) do
									if not mf:is_armed_citizenry() then
										local prm = mf:pooled_resource_manager();
										local pr_meat = prm:resource(pr_meat_key);
										if not pr_meat:is_null_interface() and pr_meat:value() < 40 then
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
						local mf_cqi = narrative.get(faction_key, "ogre_meat_low_meat_mf_cqi");
						if mf_cqi then
							mf = cm:get_military_force_by_cqi(mf_cqi);
							if mf and mf:has_general() then
								return mf:general_character():command_queue_index();
							end;
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(500, faction_key)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartOgreMeatLowMeatMission",														-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Trigger on lots of Meat on any army
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "ogre_meat_trigger_high_meat";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartOgreMeatTriggers",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartOgreMeatSendToGreatMawMission",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventTrackedPooledResourceChanged",														-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						if context:has_faction() and context:faction():name() == faction_key and context:resource():key() == pr_meat_key then
							local mf_list = context:faction():military_force_list();
							for i, mf in model_pairs(mf_list) do
								if not mf:is_armed_citizenry() then
									local prm = mf:pooled_resource_manager();
									local pr_meat = prm:resource(pr_meat_key);
									if not pr_meat:is_null_interface() and pr_meat:value() > 60 then
										narrative.add_data_for_faction(faction_key, "ogre_meat_high_meat_mf_cqi", mf:command_queue_index())
										return true;
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
	-- Send Meat to Great Maw Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "ogre_meat_event_send_meat_to_great_maw_mission";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_ogres_send_meat_great_maw_01",									-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_ogres_great_maw_01",												-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_offer_to_great_maw",								-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventTrackedPooledResourceChanged",
						condition =	function(context)
							return context:has_faction() and
								context:faction():name() == faction_key and 
								context:resource():key() == pr_meat_key and 
								context:factor():key() == "offered_to_the_great_maw" and 
								context:factor_spent() > 0;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						local mf_cqi = narrative.get(faction_key, "ogre_meat_high_meat_mf_cqi");
						if mf_cqi then
							mf = cm:get_military_force_by_cqi(mf_cqi);
							if mf and mf:has_general() then
								return mf:general_character():command_queue_index();
							end;
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(1000, faction_key)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartOgreMeatSendToGreatMawMission",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "OgreMeatTransitionToExpert",														-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "ogre_meat_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or advice_history_string,																			-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "OgreMeatTransitionToExpert",														-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;










	


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn Countdown pre-Make Multiple Offerings to Great Maw
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "ogre_meat_trigger_pre_multiple_offerings_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartOgreMeatChainFull",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartOgreMultipleOfferingsToGreatMawMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 21,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn Countdown Transition to Expert
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "ogre_meat_trigger_pre_multiple_offerings_turn_countdown_transition";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "OgreMeatTransitionToExpert",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartOgreMultipleOfferingsToGreatMawMission",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 14,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Send Meat to Great Maw Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "ogre_meat_event_make_multiple_offerings_to_great_maw_mission";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_ogres_great_maw_02",												-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_offer_to_great_maw_multiple",					-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventTrackedPooledResourceChanged",
						condition =	function(context)
							return context:has_faction() and
								context:faction():name() == faction_key and 
								context:resource():key() == pr_meat_key and 
								context:factor():key() == "offered_to_the_great_maw" and 
								context:factor_spent() > 50;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						local mf_cqi = narrative.get(faction_key, "ogre_meat_high_meat_mf_cqi");
						if mf_cqi then
							mf = cm:get_military_force_by_cqi(mf_cqi);
							if mf and mf:has_general() then
								return mf:general_character():command_queue_index();
							end;
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(1000, faction_key),
					payload.ancillary_mission_payload(faction_key, "weapon", "rare")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartOgreMultipleOfferingsToGreatMawMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")	or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"ogre_meat_event_send_meat_to_great_maw_mission"
				}
			);
		end;
	end;





	narrative.output_chain_footer();

end;











------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	BIG NAMES
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function ogre_big_names_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("ogre big names", faction_key);

	


	local advice_history_key = shared_prepend_str .. "_big_names_chain_completed"
















	-----------------------------------------------------------------------------------------------------------
	--	Advice Query
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "ogre_big_names_advice_query";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.advice_history_for_narrative_chain(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartOgreBigNamesChainExpert",														-- positive target message(s) - advice experienced
				narrative.get(faction_key, name .. "_negative_messages") or "StartOgreBigNamesChainFull",														-- negative target message(s) - advice not experienced
				narrative.get(faction_key, name .. "_all_advice_strings") or {																					-- list of advice strings, positive message triggered if all are in advice history
					advice_history_key
				},
				narrative.get(faction_key, name .. "_condition")																								-- opt condition function
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown pre-Has Earned Big Name Query
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "ogre_big_names_trigger_pre_has_big_name_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartOgreBigNamesChainFull",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartOgreBigNamesHasBigNameQuery",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 6,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Has Earned Big Name Query
	-----------------------------------------------------------------------------------------------------------

	do		
		local name = "ogre_big_names_query_has_earned_big_name";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																			-- unique name for this narrative query
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartOgreBigNamesHasBigNameQuery",													-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or "StartOgreBigNamesTransitionToExpert",												-- message(s) on value exists
				narrative.get(faction_key, name .. "_negative_messages") or "StartOgreBigNamesEarnBigName",														-- message(s) on value doesn't exist
				narrative.get(faction_key, name .. "_value_key") or "num_big_names_unlocked_" .. faction_key,													-- value key
				narrative.get(faction_key, name .. "_condition")																								-- condition function
			);
		end;
	end;

	
	-----------------------------------------------------------------------------------------------------------
	--	Earn Big Name
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "ogre_big_names_event_earn_big_name";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_ogres_earn_big_name_01",											-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_ogres_big_names_01",												-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_adopt_big_name",									-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "CharacterInitiativeActivationChangedEvent",
						condition =	function(context)
							return context:character():faction():name() == faction_key;
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
					payload.money(750)																																-- issue money
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartOgreBigNamesEarnBigName",														-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartOgreBigNamesTransitionToExpert",												-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Advice History For Expert Mode
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "ogre_big_names_mark_advice_history";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_advice_string_seen(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_key") or advice_history_key,																				-- advice string key
				narrative.get(faction_key, name .. "_trigger_messages") or "StartOgreBigNamesTransitionToExpert",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;














	-----------------------------------------------------------------------------------------------------------
	--	[EXPERT] Turn countdown before earn multiple Big Names
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "ogre_big_names_trigger_expert_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {"StartOgreBigNamesChainExpert", "StartOgreBigNamesTransitionToExpert"},				-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartOgreBigNamesEarnManyBigNames",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 18,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- [EXPERT] Trigger earn multiple big names when faction earns two Big Names
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "ogre_big_names_trigger_expert_big_names_earned";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or {"StartOgreBigNamesChainExpert", "StartOgreBigNamesTransitionToExpert"},				-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartOgreBigNamesEarnManyBigNames",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventBigNameUnlocked",																	-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						return context:character():faction():name() == faction_key and cm:get_saved_value("num_big_names_unlocked_" .. faction_key) >= 2;
					end,
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Earn Many Big Names
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "ogre_big_names_event_earn_multiple_big_names";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_ogres_big_names_02",												-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_earn_big_names_multiple",						-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventBigNameUnlocked",
						condition =	function(context)
							return context:character():faction():name() == faction_key and cm:get_saved_value("num_big_names_unlocked_" .. faction_key) >= 5;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(4000),																															-- issue money
					payload.ancillary_mission_payload(faction_key, "armour", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartOgreBigNamesEarnManyBigNames",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")	or {																						-- list of other narrative events to inherit rewards from (may be nil)
					"ogre_big_names_event_earn_big_name"
				}
			);
		end;
	end;

		
	narrative.output_chain_footer();

end;












------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	CONTRACTS
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function ogre_contracts_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("ogre contracts", faction_key);

	


	local advice_history_key = shared_prepend_str .. "_contracts_chain_completed"



	-----------------------------------------------------------------------------------------------------------
	--	Listener for the War Contracts event
	-----------------------------------------------------------------------------------------------------------
	do
		local name = "ogre_contracts_trigger_war_contract";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages"),																							-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartOgreContractsCompleteMission",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "WarContractAcceptedEvent",																		-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						return context:hired_faction():name() == faction_key
					end,
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
			);
		end;
	end

	-----------------------------------------------------------------------------------------------------------
	--	Campaign Start complete a contract
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "ogre_contracts_trigger_campaign_start_complete_contract";
		
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc26_camp_narrative_ogres_contracts_02",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc26_narrative_mission_description_complete_ogre_contract",						-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
				{
						event = "WarContractSuccessEvent",
						condition =	function(context)
							return context:hired_faction():name() == faction_key
						end
					}
				},	
				narrative.get(faction_key, name .. "_camera_scroll_callback"),				
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(5000)																							
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartOgreContractsCompleteMission",													-- script message(s) on which to trigge ]]r when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"), 																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;

		
	narrative.output_chain_footer();
	
end;




-----------------------------------------------------------------------------------------------------------
--	Campaign Start accept a contract
-----------------------------------------------------------------------------------------------------------
--[[ 
do
	local name = "ogre_contracts_trigger_campaign_start_accept_contract";


	if not narrative.get(faction_key, name .. "_block") then
		narrative_events.generic(
			name,																																			-- unique name for this narrative event
			faction_key,																																	-- key of faction to which it applies
			narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
			narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc26_camp_narrative_ogres_contracts_01",											-- key of mission to deliver
			narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc26_narrative_mission_description_accept_ogre_contract",							-- key of mission objective text
			narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
				{
					event = "WarContractAcceptedEvent",
					condition =	function(context)
						return context:hired_faction():name() == faction_key
					end
				}
			},	
			narrative.get(faction_key, name .. "_camera_scroll_callback"),				
			narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
			narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
				payload.money_direct(1000)																							
			},
			narrative.get(faction_key, name .. "_trigger_messages") 	or "StartNarrativeEvents",															-- script message(s) on which to trigger when received
			narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			narrative.get(faction_key, name .. "_completed_messages")	or "StartOgreContractsCompleteMission", 											-- script message(s) to trigger when this mission is completed
			narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
		);
	end;
end;
 ]]
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	Start all Chains
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function start_ogre_narrative_events(faction_key)

	ogre_camps_narrative_loader(faction_key);
	ogre_meat_narrative_loader(faction_key);
	ogre_big_names_narrative_loader(faction_key);
	ogre_contracts_narrative_loader(faction_key)
end;


-- Ensure that these narrative events are started for any player-controlled faction matching the culture
narrative.add_loader_for_culture("wh3_main_ogr_ogre_kingdoms", start_ogre_narrative_events);