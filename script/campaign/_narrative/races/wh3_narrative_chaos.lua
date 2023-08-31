------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	CHAOS NARRATIVE EVENT CHAINS
--
--	PURPOSE
--
--	This file defines chains of miscellaneous narrative events for all Chaos races (including the Daemon Prince).
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

out.narrative("* wh3_narrative_chaos.lua loaded");

local shared_prepend_str = shared_narrative_event_prepend_str;








------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	CHAOS MOVEMENTS
--	Early/mid-game missions for Chaos races that incentivise them attacking humans
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


function chaos_movements_narrative_loader(faction_key)


	-- output header
	narrative.output_chain_header("chaos movements", faction_key);


	local human_cultures_indexed = {"wh3_main_cth_cathay", "wh3_main_ksl_kislev", "wh_main_emp_empire"};

	local human_cultures_lookup = table.indexed_to_lookup(human_cultures_indexed);

	-- human_cultures_lookup:
	--[[
	local human_cultures_lookup ={
		wh3_main_cth_cathay = true,
		wh3_main_ksl_kislev = true,
		wh_main_emp_empire = true
	};
	]]


	core:add_listener(
		"chaos_movements_field_battle_listener",
		"BattleCompleted",
		true,
		function()
			local pb = cm:model():pending_battle();
			if cm:turn_number() < 5 or pb:has_contested_garrison() or not pb:has_been_fought() then
				return;
			end;

			local human_mf_cqi = false;

			if cm:pending_battle_cache_faction_is_attacker(faction_key) then
				-- Our subject faction is the attacker, try and find a human-culture defender in the battle and store their mf cqi
				for i = 1, cm:pending_battle_cache_num_defenders() do
					local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
					
					local faction = cm:get_faction(current_faction_name);
					
					if faction then
						local current_faction_culture = faction:culture();

						if human_cultures_lookup[current_faction_culture] then
							human_mf_cqi = current_mf_cqi;
						end;

						if human_mf_cqi then
							break;
						end;
					end;
				end;
			elseif cm:pending_battle_cache_faction_is_defender(faction_key) then
				-- Our subject faction is the defender, try and find a human-culture attacker in the battle and store their mf cqi
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
					
					local faction = cm:get_faction(current_faction_name);
					
					if faction then
						local current_faction_culture = faction:culture();

						if human_cultures_lookup[current_faction_culture] then
							human_mf_cqi = current_mf_cqi;
						end;

						if human_mf_cqi then
							break;
						end;
					end;
				end;
			end;

			if human_mf_cqi then
				local defeated_human_armies = cm:get_saved_value("human_armies_defeated_by_" .. faction_key) or {};

				for i = 1, #defeated_human_armies do
					if defeated_human_armies[i] == human_mf_cqi then
						return;
					end;
				end;

				-- This human army has not been defeated before, so add it to the list and trigger an event
				table.insert(defeated_human_armies, human_mf_cqi);
				cm:set_saved_value("human_armies_defeated_by_" .. faction_key, defeated_human_armies);
				core:trigger_custom_event("ScriptEventBattleCompletedChaosDefeatsHuman", {faction = cm:get_faction(faction_key)});
			end;
		end,
		true
	);


	local function check_region_sacked_or_razed(faction_key, attacking_char, region_name)
		local settlements_sacked_razed = cm:get_saved_value("settlements_sacked_razed_by_" .. faction_key) or {};

		for i = 1, #settlements_sacked_razed do
			if settlements_sacked_razed[i] == region_name then
				return;
			end;
		end;

		-- This human settlement has not been sacked or razed by this faction before
		table.insert(settlements_sacked_razed, region_name);
		cm:set_saved_value("settlements_sacked_razed_by_" .. faction_key, settlements_sacked_razed);
		core:trigger_custom_event("ScriptEventChaosCharacterSackedOrRazedHumanRaceSettlement", {character = attacking_char});
	end;
	

	core:add_listener(
		"chaos_movements_sack_listener",
		"CharacterSackedSettlement",
		true,
		function(context)
			if cm:turn_number() < 5 or context:character():faction():name() ~= faction_key then
				return;
			end;

			local sacked_gr = context:garrison_residence();

			if not human_cultures_lookup[sacked_gr:faction():culture()] then
				return;
			end;

			check_region_sacked_or_razed(faction_key, context:character(), sacked_gr:region():name());
		end,
		true
	);

	core:add_listener(
		"chaos_movements_raze_listener",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			local settlement_option = context:settlement_option();
			return settlement_option == "occupation_decision_raze" or settlement_option == "occupation_decision_raze_without_occupy";
		end,
		function(context)
			if cm:turn_number() < 5 and context:character():faction():name() ~= faction_key then
				return;
			end;

			local culture_found = false;
			local previous_owner_culture = context:previous_owner_culture();
			for i = 1, #human_cultures_indexed do
				if previous_owner_culture == human_cultures_indexed[i] then
					culture_found = true;
					break;
				end;
			end;

			if not culture_found then
				return;
			end;

			check_region_sacked_or_razed(faction_key, context:character(), context:garrison_residence():region():name());
		end,
		true
	);






	-----------------------------------------------------------------------------------------------------------
	--	Message
	--	Translates StartNarrativeEvents message in to StartChaosMovementEvents, to provide a single
	--	point of entry
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chaos_movements_trigger_start";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.message(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "StartNarrativeEvents",																-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartChaosMovementEvents",															-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages")																							-- script message(s) on which to cancel
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger pre-Sack/Raze Human Settlements Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chaos_movements_trigger_turn_countdown_pre_sack_raze_human_settlements";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartChaosMovementEvents",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartChaosMovementPreSackRazeHumanSettlementsTrigger",								-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 14,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger for Sack/Raze Human Settlements Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chaos_movements_trigger_turn_countdown_sack_raze_human_settlements";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartChaosMovementPreSackRazeHumanSettlementsTrigger",								-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartChaosMovementSackRazeHumanSettlementsMission",									-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 5,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Trigger the Sack/Raze Human Settlements Mission if the player has already sacked/razed more than one human settlement
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chaos_movements_trigger_sack_raze_human_settlements_on_razing_human_settlements";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "StartChaosMovementPreSackRazeHumanSettlementsTrigger",								-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartChaosMovementSackRazeHumanSettlementsMission",									-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventChaosCharacterSackedOrRazedHumanRaceSettlement",									-- event name
				narrative.get(faction_key, name .. "_condition") or																								-- event condition
					function(context)
						if context:character():faction():name() == faction_key then
							local settlements_sacked_razed = cm:get_saved_value("settlements_sacked_razed_by_" .. faction_key);
							return is_table(settlements_sacked_razed) and #settlements_sacked_razed > 1;
						end;
					end,
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Sack or Raze Human Settlements Mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "chaos_movements_event_sack_raze_human_settlements";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_shared_chaos_invasion_01",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_chaos_sack_human_settlements",					-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventChaosCharacterSackedOrRazedHumanRaceSettlement",
						condition =	function(context)
							if context:character():faction():name() == faction_key then
								local settlements_sacked_razed = cm:get_saved_value("settlements_sacked_razed_by_" .. faction_key);
								return is_table(settlements_sacked_razed) and #settlements_sacked_razed > 5;
							end;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						-- Find the closest visible character of any of the target human cultures.
						-- NB this doesn't actually trigger as we have no advice, so we can have no camera scroll callback :S
						local function char_filter(char)
							return self:char_is_general(char);
						end;

						local closest_char = false;
						local closest_char_dist = 5000;

						for i = 1, #human_cultures_indexed do
							local current_closest_char, current_closest_char_dist = cm:get_closest_visible_character_of_culture(faction_key, human_cultures_indexed[i], char_filter);
							if current_closest_char_dist and current_closest_char_dist < closest_char_dist then
								closest_char, closest_char_dist = current_closest_char, current_closest_char_dist;
							end;
						end;

						if closest_char then
							return closest_char:command_queue_index();
						end;
					end,
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(
						20000,
						faction_key,																													-- faction key
						{																																-- params for potential money replacement
							value = "v_high",																												-- value of this mission  - see wh3_campaign_payload_remapping.lua
							glory_type = "khorne,nurgle"																									-- glory type to issue
						}
					)
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartChaosMovementSackRazeHumanSettlementsMission",									-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or "ChaosMovementSackRazeHumanSettlementsMissionIssued",								-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;













	


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown trigger for Starting Defeat Human Armies Mission
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chaos_movements_trigger_pre_defeat_human_armies_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "ChaosMovementSackRazeHumanSettlementsMissionIssued",									-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartChaosMovementDefeatHumanArmiesMission",											-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 5,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn-Start Trigger for Defeat Human Armies Mission on coming in to contact with Humans
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chaos_movements_trigger_pre_defeat_human_armies_on_human_contact";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_start(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "ChaosMovementSackRazeHumanSettlementsMissionIssued",									-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or "StartChaosMovementDefeatHumanArmiesMission",											-- script message(s) to fire when this narrative trigger triggers
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_condition") or 																							-- opt condition
					function(context, nt)
						-- Return true if the subject faction can reach any human faction this turn
						local faction = context:faction();
						if faction then
							local factions_met = faction:factions_met();
							for i, faction_met in model_pairs(factions_met) do
								if human_cultures_lookup[faction_met:culture()] then
									if cm:faction_can_reach_faction(faction, faction_met, true) then
										return true;
									end;
								end;
							end;
						end;
					end,
				narrative.get(faction_key, name .. "_faction_starting_turn"),																					-- opt faction starting turn
				narrative.get(faction_key, name .. "_immediate") or false																						-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Defeat Human Armies Mission
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "chaos_movements_event_defeat_human_armies";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_shared_chaos_invasion_02",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_chaos_defeat_human_armies",						-- key of mission objective text
				narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
					{
						event = "ScriptEventBattleCompletedChaosDefeatsHuman",
						condition =	function(context)
							if context:faction():name() == faction_key then 
								local human_armies_defeated = cm:get_saved_value("human_armies_defeated_by_" .. faction_key);
								return #human_armies_defeated > 5;
							end;
						end
					}
				},
				narrative.get(faction_key, name .. "_camera_scroll_callback") or																				-- camera scroll callback
					function()
						-- Find the closest visible garrison commander of any of the target human cultures.
						-- NB this doesn't actually trigger as we have no advice, so we can have no camera scroll callback :S
						local function char_filter(char)
							return self:char_is_garrison_commander(character); 
						end;

						local closest_char = false;
						local closest_char_dist = 5000;

						for i = 1, #human_cultures_indexed do
							local current_closest_char, current_closest_char_dist = cm:get_closest_visible_character_of_culture(faction_key, human_cultures_indexed[i], char_filter);
							if current_closest_char_dist and current_closest_char_dist < closest_char_dist then
								closest_char, closest_char_dist = current_closest_char, current_closest_char_dist;
							end;
						end;

						if closest_char then
							return closest_char:command_queue_index();
						end;

					end,					
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(
						5000, 
						faction_key,																													-- faction key
						{																																-- params for potential money replacement
							value = "high",																												-- value of this mission  - see wh3_campaign_payload_remapping.lua
							glory_type = "khorne"																										-- glory type to issue
						}
					),
					payload.ancillary_mission_payload(faction_key, "weapon", "rare")																	-- issue random rare weapon								
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartChaosMovementDefeatHumanArmiesMission",										-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
		end;
	end;








	narrative.output_chain_footer();

end;
