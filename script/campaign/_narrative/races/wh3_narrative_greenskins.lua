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

out.narrative("* wh3_narrative_greenskins.lua loaded");

local shared_prepend_str = shared_narrative_event_prepend_str;





------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	Da Plan
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function grn_da_plan_narrative_loader(faction_key)

	-- output header
	narrative.output_chain_header("greenskins da plan", faction_key);

	


	local advice_history_key = shared_prepend_str .. "_da_plan_chain_completed"



	-----------------------------------------------------------------------------------------------------------
	--	Da Plan Equip a tactic
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "greenskins_da_plan_trigger_campaign_start_equip_tactic";


		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc26_camp_narrative_grn_da_plan_01",												-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc26_narrative_mission_description_grn_da_plan_equip_tactic",								-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "CharacterInitiativeActivationChangedEvent",
						condition =	function(context)
							return context:active() and string.find(context:initiative():record_key(), "da_plan")
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
				narrative.get(faction_key, name .. "_completed_messages")	or "StartGrnDaPlanTacticsUnlocks", 													-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Da Plan Unlock by challenge
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "greenskins_da_plan_trigger_unlock_tactic_by_challenge";


		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc26_camp_narrative_grn_da_plan_02",											-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc26_narrative_mission_description_grn_da_plan_unlock_by_challenge",						-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptedDaPlanTacticUnlockedByChallange",
						condition =	function(context)
							return context:faction():name() == faction_key
						end
					}
				},	
				narrative.get(faction_key, name .. "_camera_scroll_callback"),				
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money_direct(5000)																							
				},
				narrative.get(faction_key, name .. "_trigger_messages") 	or "StartGrnDaPlanTacticsUnlocks",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"), 																						-- script message(s) to trigger when this mission is completed
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


local function start_greenskins_narrative_events(faction_key)
	grn_da_plan_narrative_loader(faction_key)
end;


-- Ensure that these narrative events are started for any player-controlled faction matching the culture
narrative.add_loader_for_culture("wh_main_grn_greenskins", start_greenskins_narrative_events);