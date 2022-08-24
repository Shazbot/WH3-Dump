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

out.narrative("* wh3_narrative_daemon_prince.lua loaded");

local shared_prepend_str = shared_narrative_event_prepend_str;






------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	DAEMONIC GLORY
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function daemon_prince_daemonic_glory_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("daemon prince daemonic glory", faction_key);


	local all_glory_types = {
		"wh3_main_dae_khorne_points",
		"wh3_main_dae_nurgle_points",
		"wh3_main_dae_slaanesh_points",
		"wh3_main_dae_tzeentch_points",
		"wh3_main_dae_undivided_points"
	}

	



	-----------------------------------------------------------------------------------------------------------
	--	pooled resource gained for first equip-daemonic-item mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "dp_glory_trigger_pooled_resource_gained_pre_equip_gift";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.pooled_resource_gained(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartNarrativeEvents",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartGloryEquipDaemonicGift",														-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_pooled_resource_key") or all_glory_types,																	-- pooled resource key(s)
				narrative.get(faction_key, name .. "_threshold_value") or 210																					-- threshold value
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Equip any Daemonic Gift
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "dp_glory_event_equip_gift";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.equip_any_daemonic_gift(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_advice_daemon_daemonic_progression_item_01",								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_daemon_prince_equip_daemonic_gift_01",							-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(																																	-- issue money or equivalent
						2000,																																			-- money reward, if we aren't giving something else for this faction
						faction_key,																																	-- faction key
						{																																				-- params for potential money replacement
							value = "low",																																	-- value of this mission
							glory_type = "khorne,nurgle,slaanesh,tzeentch,undivided"																						-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartGloryEquipDaemonicGift",														-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or "StartGloryEarnLotsOfGloryCountdown",												-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
				
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark Equip any Daemonic Gift mission as issued - Daemonic Glory scripted tour advice queries this
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "dp_glory_event_equip_gift_issued";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_saved_value(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_value_key") or faction_key .. "_dp_equip_gift_issued",														-- value key for savegame
				narrative.get(faction_key, name .. "_value") or true,																							-- value to save
				narrative.get(faction_key, name .. "_trigger_messages") or "StartGloryEarnLotsOfGloryCountdown",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")
			);
		end;
	end;
	


	-----------------------------------------------------------------------------------------------------------
	--	Pre Earn Glory Countdown
	-----------------------------------------------------------------------------------------------------------
	--[[
	do
		local name = "dp_glory_trigger_pre_earn_glory_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartGloryEarnGloryCountdown",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartGloryEarnGloryMission",															-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 1,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Pre Earn Glory glory trigger
	--	Trigger the earn glory mission if the player earns anything close to the completion value
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "dp_glory_trigger_pre_earn_glory_trigger";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.pooled_resource_gained(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartGloryEarnGloryCountdown",														-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartGloryEarnGloryMission",															-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_pooled_resource_key") or all_glory_types,																	-- pooled resource key(s)
				narrative.get(faction_key, name .. "_threshold_value") or 400																					-- threshold value
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Earn Glory
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "dp_glory_event_earn_glory";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.gain_pooled_resource_scripted(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_daemon_earn_daemonic_glory_01",									-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_daemon_prince_earn_glory_01",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_earn_1000_glory_total",							-- key of mission objective text
				narrative.get(faction_key, name .. "_pooled_resources") or all_glory_types,																		-- pooled resource(s)
				narrative.get(faction_key, name .. "_lower_threshold") or 1000,																					-- lower threshold value
				narrative.get(faction_key, name .. "_upper_threshold"),																							-- upper threshold value
				narrative.get(faction_key, name .. "is_additive") or true,																						-- is additive (value of all resources counts towards total)
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(2000),																														-- issue money
					payload.ancillary_mission_payload(faction_key, "banner", "common")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartGloryEarnGloryMission",														-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartGloryEarnLotsOfGloryCountdown",												-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;
	]]


	-----------------------------------------------------------------------------------------------------------
	--	Pre Earn Lots of Glory Countdown
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "dp_glory_trigger_pre_earn_lots_of_glory_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartGloryEarnLotsOfGloryCountdown",													-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartGloryEarnLotsOfGloryMission",													-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 15,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Pre Earn Glory glory trigger
	--	Trigger the earn glory mission if the player earns anything close to the completion value
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "dp_glory_trigger_pre_earn_lots_of_glory_trigger";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.pooled_resource_gained(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartGloryEarnLotsOfGloryCountdown",													-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartGloryEarnLotsOfGloryMission",													-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_pooled_resource_key") or all_glory_types,																	-- pooled resource key(s)
				narrative.get(faction_key, name .. "_threshold_value") or 2000																					-- threshold value
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Earn Lots of Glory
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "dp_glory_event_earn_lots_of_glory";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.gain_pooled_resource_scripted(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_daemon_prince_earn_glory_02",									-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_earn_3000_glory",								-- key of mission objective text
				narrative.get(faction_key, name .. "_pooled_resources") or all_glory_types,																		-- pooled resource(s)
				narrative.get(faction_key, name .. "_lower_threshold") or 3000,																					-- lower threshold value
				narrative.get(faction_key, name .. "_upper_threshold"),																							-- upper threshold value
				narrative.get(faction_key, name .. "_is_additive") or false,																					-- is additive (value of all resources counts towards total)
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(3000),
					payload.ancillary_mission_payload(faction_key, "armour", "uncommon")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartGloryEarnLotsOfGloryMission",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages") or "StartGloryAscendMission",															-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;





	

	-----------------------------------------------------------------------------------------------------------
	--	Perform Ascension/Dedication
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "dp_glory_event_perform_ascension";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.perform_ascension(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_daemon_ascend_01",												-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_daemon_prince_perform_ascension_01",								-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(3000),																														-- issue money or equivalent
					payload.ancillary_mission_payload(faction_key, "enchanted_item", "rare")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartGloryAscendMission",															-- script message(s) on which to trigger when received
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


local function start_daemon_prince_narrative_events(faction_key)

	daemon_prince_daemonic_glory_narrative_loader(faction_key);
	chaos_movements_narrative_loader(faction_key);
end;


-- Ensure that these narrative events are started for any player-controlled faction matching the culture
narrative.add_loader_for_culture("wh3_main_dae_daemons", start_daemon_prince_narrative_events);