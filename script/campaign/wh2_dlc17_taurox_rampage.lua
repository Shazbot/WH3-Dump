------------------------------------------------------------------------------------
------                              CONSTANTS                              ---------
------------------------------------------------------------------------------------
--these dont need to be saved because these never change and when the script is loaded they will always be set correctly
--taurox faction key and character name
local taurox_faction_key = "wh2_dlc17_bst_taurox";
local taurox_forename = "names_name_1163393566";

--this is the list of passive effect bundles that are applied to Taurox when he reaches bst_rampage thresholds
local rampage_passive_bundles = {
	{effect_bundle = "wh2_dlc17_taurox_bst_rampage_passive_tier_1", threshold = 50},
	{effect_bundle = "wh2_dlc17_taurox_bst_rampage_passive_tier_2", threshold = 100},
	{effect_bundle = "wh2_dlc17_taurox_bst_rampage_passive_tier_3", threshold = 150}
};

--setting the number of rituals here to be referenced by the Ritual and Pooled Resource functions
local number_of_rampage_ritual_options = 4;

--this is the increased base rampage gain post battle, this replaces the inital base value after earning a unique trait
local improved_battle_rampage = 9;

--this is used for a hidden trait, if number of battles won this turn is greater than this value trait is earned
local multiple_battles_threshold = 4;

--this is used for a hidden trait, if momentum is greater than this value trait is earned
local high_momentum_threshold = 8;

--Constants specifically governing Taurox's River of Blood effect
RiverOfBlood ={
	bundle_keys = { --- need to be in order of severity, lowest-> highest
		"wh2_dlc17_bundle_river_of_blood_01",
		"wh2_dlc17_bundle_river_of_blood_02",
		"wh2_dlc17_bundle_river_of_blood_03",
	},
	skill_key = "wh2_dlc17_skill_bst_taurox_unique_drowned_in_blood",
	skill_bonus_stacks = 1,
	duration = 5
}

------------------------------------------------------------------------------------
------                              VARIABLES                               ---------
------------------------------------------------------------------------------------
-- these will need to be saved and loaded because they may change during the campaign

--this table keeps track of every value that can affect the momentum value of Taurox's rampage
local momentum_matrix = {
	["rampage_base"] 			= 	{factor = "wh2_dlc17_taurox_bst_momentum_gained_base", 				amount = 3},
	["battle_won_first_of_turn"] = 	{factor = "wh2_dlc17_taurox_bst_momentum_gained_battle_won", 		amount = 2},
	["battle_won"] 				= 	{factor = "wh2_dlc17_taurox_bst_momentum_gained_battle_won", 		amount = 1},
	["battle_lost"] 			= 	{factor = "wh2_dlc17_taurox_bst_momentum_lost_battle_lost", 		amount = -2},
	["battle_retreat"] 			= 	{factor = "wh2_dlc17_taurox_bst_momentum_lost_battle_retreat", 		amount = -1},
	["end_turn"] 				= 	{factor = "wh2_dlc17_taurox_bst_momentum_lost_end_turn", 			amount = -1},
	["ap_replenish"] 			= 	{factor = "wh2_dlc17_taurox_bst_momentum_lost_ap_replenish", 		amount = -3},
	["ap_replenish_reduced"] 	= 	{factor = "wh2_dlc17_taurox_bst_momentum_lost_ap_replenish", 		amount = -2}
};

--this table is to keep track of what hidden traits have been unlocked and at what level
local hidden_traits = {
	["rampage_complete"] 		= 	{key = "wh2_dlc17_trait_taurox_hidden_rampage_complete", 				level = 0, max_level = 5, maxed_out = false,},
	["high_momentum"] 			= 	{key = "wh2_dlc17_trait_taurox_hidden_rampage_high_momentum", 			level = 0, max_level = 1, maxed_out = false,},
	["multiple_wins_same_turn"] = 	{key = "wh2_dlc17_trait_taurox_hidden_rampage_multiple_wins_same_turn", level = 0, max_level = 1, maxed_out = false,},
	["personal_kills"] 			= 	{key = "wh2_dlc17_trait_taurox_hidden_rampage_personal_kills", 			level = 0, max_level = 5, maxed_out = false,},
	["solo_army"]				=	{key = "wh2_dlc17_trait_taurox_hidden_rampage_solo_army", 				level = 0, max_level = 5, maxed_out = false,}
};

--- unit count enemy army required for Taurox solo wins to count. Update trait description in DB to match if changed.
local army_value_for_solo_trait = 2500;

--this is the base value of bst_rampage resource Taurox gains when winning a battle (other multipliers are applied in the function)
local base_battle_rampage = 6;

--this is the variable to track how many battles Taurox has won this turn
local consecutive_battles_won_this_turn = 0;

--this is used to keep track of available rituals that havent been claimed, once all 3 are claimed a rampage will restart
local completed_rampage_rituals = {
	["tier_1"] = {unlocked = false, completed = false}, 
	["tier_2"] = {unlocked = false, completed = false}, 
	["tier_3"] = {unlocked = false, completed = false}, 
};

function add_taurox_rampage_listeners()
	out("#### Adding Taurox Rampage Listeners ####");
	local taurox_interface = cm:get_faction(taurox_faction_key)


	--check if Taurox exists, we dont check for human here as we run the following listeners for AI as well	
	if taurox_interface then
		core:add_listener(
			"TauroxRampage_FactionTurnStart",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == taurox_faction_key;
			end,
			function(context)
				--if not the first turn of the campaign
				if cm:turn_number() >= 2 and cm:get_saved_value("taurox_rampage_active") then
					TauroxRampage_MomentumUpdate(momentum_matrix["end_turn"])
				end
			end,
			true
		);

		core:add_listener(
			"TauroxRampage_CharacterCompletedBattle",
			"CharacterCompletedBattle",
			function(context) 
				--Check if battle is over and if Taurox took part
				return (cm:model():pending_battle():has_been_fought()) and (context:character():get_forename() == taurox_forename)
			end,
			function(context) 
				TauroxRampage_BattleCompleted(context) 
			end,
			true
		);

		core:add_listener(
			"TauroxRampage_CharacterParticipatedAsSecondaryGeneralInBattle",
			"CharacterParticipatedAsSecondaryGeneralInBattle",
			function(context) 
				--Check if battle is over and if Taurox took part
				return (cm:model():pending_battle():has_been_fought()) and (context:character():get_forename() == taurox_forename)
			end,
			function(context) 
				TauroxRampage_BattleCompleted(context) 
			end,
			true
		);

		core:add_listener(
			"TauroxRampage_CharacterWithdrewFromBattle",
			"CharacterWithdrewFromBattle",
			function(context)
				local pb = cm:model():pending_battle();
				local character = context:character();
				
				return (context:character():get_forename() == taurox_forename) and (pb:has_defender()) and (pb:defender():get_forename() == taurox_forename);
			end,
			function(context)
				--Taurox retreated
				TauroxRampage_MomentumUpdate(momentum_matrix["battle_retreat"]);
			end,
			true
		);

		core:add_listener(
			"TauroxRampage_PooledResourceEffectChangedEvent",
			"PooledResourceEffectChangedEvent",
			function(context) 
				--Check if pooled resource is bst_rampage
				return context:resource():key() == "bst_rampage";
			end,
			function() 
				TauroxRampage_PooledResourceEffectChangedEvent() 
			end,
			true
		);

		--check if Taurox is human
		if taurox_interface:is_human() == true  then
			cm:add_faction_turn_start_listener_by_name(
				"TauroxRampage_FactionTurnStart",
				taurox_faction_key,
				function(context)
					--Reset Taurox battle victory counter
					consecutive_battles_won_this_turn = 0;
					cm:set_saved_value("taurox_battle_fought_this_turn", false)
				end,
				true
			);

			--only start these listeners if Taurox is human
			core:add_listener(
				"TauroxRampage_RitualCompletedEvent",
				"RitualCompletedEvent", 
				function(context)
					return context:performing_faction():name() == taurox_faction_key and context:ritual():ritual_key():find("wh2_dlc17_taurox_bst_rampage_tier_");
				end,
				function(context) 
					TauroxRampage_RitualCompletedEvent(context) 
				end,
				true
			);

			core:add_listener(
				"TauroxRampage_ComponentLClickUp",
				"ComponentLClickUp",
				function(context)					
					return context.string == "taurox_ap_button";
				end,
				function(context)
					CampaignUI.TriggerCampaignScriptEvent(0, "taurox_ap_button");
				end,
				true
			);

			core:add_listener(
				"TauroxRampage_UITrigger", 
				"UITrigger", 
				function(context)
					return context:trigger() == "taurox_ap_button";
				end, 
				function(context)
					local taurox_faction = cm:get_faction(taurox_faction_key);
					local taurox_character = taurox_faction:faction_leader();
					cm:replenish_action_points(cm:char_lookup_str(taurox_character));
					--Taurox replenishes AP
					if taurox_faction:has_effect_bundle("wh2_dlc17_taurox_bst_rampage_tier_2_option_4") then					
						TauroxRampage_MomentumUpdate(momentum_matrix["ap_replenish_reduced"]);
					else
						TauroxRampage_MomentumUpdate(momentum_matrix["ap_replenish"]);
					end
				end, 
				true
			);

		else
			--only start these listeners if Taurox is NOT human
			core:add_listener(
				"TauroxRampage_FactionTurnStartAI",
				"FactionTurnStart",
				function(context)
					return context:faction():name() == taurox_faction_key;				
				end,
				function(context)
					TauroxRampage_FactionTurnStartAI();
				end,
				true
			);			

		end
	end

end

--Checks if AI Taurox has any avialable rituals to do and force completes them for the AI
function TauroxRampage_FactionTurnStartAI()
	
	local ritual_key = "";
	local rand = cm:random_number(100);

	if (completed_rampage_rituals["tier_1"].unlocked == true and completed_rampage_rituals["tier_1"].completed == false) then
		--all 4 rituals are vlaid for AI
		if rand > 75 then
			ritual_key = "wh2_dlc17_taurox_bst_rampage_tier_1_option_1";
		elseif rand > 50 then
			ritual_key = "wh2_dlc17_taurox_bst_rampage_tier_1_option_2";
		elseif rand > 25 then
			ritual_key = "wh2_dlc17_taurox_bst_rampage_tier_1_option_3";
		else
			ritual_key = "wh2_dlc17_taurox_bst_rampage_tier_1_option_4";
		end
		
		cm:perform_ritual(taurox_faction_key, "", ritual_key);

		completed_rampage_rituals["tier_1"].completed = true;

	elseif (completed_rampage_rituals["tier_2"].unlocked == true and completed_rampage_rituals["tier_2"].completed == false) then

		--skip the moon ritual
		if rand > 66 then
			ritual_key = "wh2_dlc17_taurox_bst_rampage_tier_2_option_1";
		elseif rand > 33 then
			ritual_key = "wh2_dlc17_taurox_bst_rampage_tier_2_option_2";
		else
			ritual_key = "wh2_dlc17_taurox_bst_rampage_tier_2_option_4";
		end
		
		cm:perform_ritual(taurox_faction_key, "", ritual_key);

		completed_rampage_rituals["tier_2"].completed = true;

	elseif (completed_rampage_rituals["tier_3"].unlocked == true and completed_rampage_rituals["tier_3"].completed == false) then

		--all 4 rituals are valid for AI
		if rand > 75 then
			ritual_key = "wh2_dlc17_taurox_bst_rampage_tier_3_option_1";
		elseif rand > 50 then
			ritual_key = "wh2_dlc17_taurox_bst_rampage_tier_3_option_2";
		elseif rand > 25 then
			ritual_key = "wh2_dlc17_taurox_bst_rampage_tier_3_option_3";
		else
			ritual_key = "wh2_dlc17_taurox_bst_rampage_tier_3_option_4";
		end
		
		cm:perform_ritual(taurox_faction_key, "", ritual_key);

		completed_rampage_rituals["tier_3"].completed = true;

	end

end

--Check if Taurox took part in a battle, if he did determine if he won that battle
function TauroxRampage_BattleCompleted(context)

	local taurox_character = context:character();
	local battle_won = taurox_character:won_battle();
	local taurox_military_force = taurox_character:military_force();

	--Check if Taurox won the battle
	if battle_won == true then
		--Check if attacker won 
		local attacker_result = cm:model():pending_battle():attacker_battle_result();
		
		--Check if Taurox was attacker (Taurox only earns bst_rampage when he is the attacker)
		--we check attacker_result and battle_won separately as we penalise Taurox for losing, but not for winning defensively
		if attacker_result:find("victory") then

			
			--check if taurox fought battle alone - (not making a constant instead of magic number here as we are checking if Taurox is alone not a specific variable number)
			if (taurox_military_force:unit_list():num_items() == 1) and (hidden_traits["solo_army"].maxed_out == false) and (cm:pending_battle_cache_defender_value() >= army_value_for_solo_trait) then
				TauroxRampage_TraitManager("solo_army");
			end

			consecutive_battles_won_this_turn = consecutive_battles_won_this_turn + 1;

			if (consecutive_battles_won_this_turn >= multiple_battles_threshold) and (hidden_traits["multiple_wins_same_turn"].maxed_out == false) then
				TauroxRampage_TraitManager("multiple_wins_same_turn");
				--increase base battle victory rampage value +5 (which is equivalent to +50% as shown on the effect)
				base_battle_rampage = improved_battle_rampage;
			end

			local taurox_value = cm:pending_battle_cache_attacker_value();
			local enemy_value = cm:pending_battle_cache_defender_value();

			--Work out comparative army strength between Taurox and enemy army
			local battle_value_multiplier = enemy_value / taurox_value;
			battle_value_multiplier = math.clamp(battle_value_multiplier, 0.8, 1.2);
			
			--this is the default multiplier if this is the first battle won this turn
			local number_of_victories_multiplier = 1;

			--Apply the following calculation to work out how much bst_rampage to add to Taurox
			if consecutive_battles_won_this_turn > 1 then
				--this muliplier gives bonus Rampage for winning multiple battles in a single turn
				number_of_victories_multiplier = 1 + (consecutive_battles_won_this_turn/2)
			end

			local total_rampage_value = base_battle_rampage * battle_value_multiplier * number_of_victories_multiplier;
			if total_rampage_value > 25 then
				total_rampage_value = 25;
			end
			cm:faction_add_pooled_resource(taurox_faction_key, "bst_rampage", "wh2_dlc17_taurox_bst_rampage_gain_battles", total_rampage_value);

			--we increase the momentum counter of Taurox
			local battle_type = "battle_won"
			if not cm:get_saved_value("taurox_battle_fought_this_turn") then
				battle_type = "battle_won_first_of_turn"
				cm:set_saved_value("taurox_battle_fought_this_turn", true)
			end
			TauroxRampage_MomentumUpdate(momentum_matrix[battle_type]);
		end

		--Apply River of Blood effects
		local region = context:character():region()
		local has_skill = context:character():has_skill(RiverOfBlood.skill_key)
		TauroxRampage_UpdateRiverOfBlood(region, has_skill)

	else
		--Taurox lost a battle
		--call the Momentum Update function with the appropraite value change
		TauroxRampage_MomentumUpdate(momentum_matrix["battle_lost"])
		--reset battles won this turn to 0
		consecutive_battles_won_this_turn = 0
	end

end
	

--Updates the momentum pooled resource amount with the passed integer argument
function TauroxRampage_MomentumUpdate(momentum_entry)
	if not cm:get_saved_value("taurox_rampage_active") then
		cm:set_saved_value("taurox_rampage_active", true)
	end

	local taurox_faction = cm:get_faction(taurox_faction_key);
	local current_momentum = taurox_faction:pooled_resource_manager():resource("bst_momentum"):value();
	cm:faction_add_pooled_resource(taurox_faction_key,"bst_momentum", momentum_entry.factor, momentum_entry.amount);
	
	current_momentum = taurox_faction:pooled_resource_manager():resource("bst_momentum"):value();

	--Check important thresholds of the new momentum value
	if current_momentum <= 0 then
		--momentum is 0 meaning Taurox's Rampage is over
		TauroxRampage_RampageRestart(false);

	elseif current_momentum <= 2 then
		--check is momentum change is low, if it is then fire momentum lost advice
		core:trigger_event("ScriptEventTauroxRampageMomentumLost");
	elseif current_momentum >= high_momentum_threshold and (hidden_traits["high_momentum"].maxed_out == false) then
		
		--momentum greater than high_momentum_threshold so hidden trait unlocked
		TauroxRampage_TraitManager("high_momentum");

		--increase base rampage momentum NOT the current momentum amount
		momentum_matrix["rampage_base"].amount = momentum_matrix["rampage_base"].amount + 1;

	end
end

--Updates what passive effect bundles ar applied to Taurox when bst_rampage thresholds change
function TauroxRampage_PooledResourceEffectChangedEvent()
	local taurox_faction = cm:get_faction(taurox_faction_key, true);	

	--get current bst_rampage value
	local current_rampage_value = taurox_faction:pooled_resource_manager():resource("bst_rampage"):value();
	local current_active_effect = "no_bundle";
	
	--we save the rampage tier so we can pass this as an argument to lock/unlock the rampage riutals later
	local current_rampage_tier = 0;

	--loop down from highest threshold to lowest checking bst_rampage value is higher than the threshold
	for i = #rampage_passive_bundles, 1, -1 do 
		if current_rampage_value >= rampage_passive_bundles[i].threshold then
			current_active_effect = rampage_passive_bundles[i].effect_bundle;
			current_rampage_tier = i;
			break;
		end
	end

	--if we have a valid bundle apply it, else we apply nothing
	if current_active_effect ~= "no_bundle" then 

		--trigger event for advice to play first time threshold reached
		core:trigger_event("ScriptEventTauroxRampageThresholdReached");

		--unlock the next Rampage Ritual tier, pass the current_rampage_tier to the RitualUnlock function
		TauroxRampage_RitualManager(current_rampage_tier, taurox_faction, true);
		
		completed_rampage_rituals["tier_" .. tostring(current_rampage_tier)].unlocked = true;

		--fire incident to tell player Rampage rituals is ready	
		cm:trigger_incident(taurox_faction_key, "wh2_dlc17_bst_taurox_rampage_threshold_reached_tier_"..tostring(current_rampage_tier), true);

	end

	--check if we are at max rampage tier and how many times we have reached the max tier
	if (current_rampage_tier == 3)  then
		TauroxRampage_RampageRestart(true);

		if (hidden_traits["rampage_complete"].maxed_out == false) then
			-- add a tier onto the HIDDEN TRAIT
			TauroxRampage_TraitManager("rampage_complete")
		end
	end
end

--Controls Locking/Unlocking of rituals based on bst_rampage threshold
function TauroxRampage_RitualManager(current_tier, faction_interface, should_unlock)

	for i = 1, number_of_rampage_ritual_options do 
		
		local ritual_key = "wh2_dlc17_taurox_bst_rampage_tier_" .. current_tier .. "_option_" .. i;
		
		if should_unlock == true then
			cm:unlock_ritual(faction_interface, ritual_key, 0);
		else
			cm:lock_ritual(faction_interface, ritual_key);
		end
		
	end

end

function TauroxRampage_RitualCompletedEvent(context)

	--get the full ritual key
	local ritual_key = context:ritual():ritual_key();
	local taurox_faction = context:performing_faction();
	local taurox_character = taurox_faction:faction_leader();

	--get the ritual tier by getting the 35th character (as a string)
	--35 is the string location of the ritual tier in all of tauroxs rampage ritual keys
	local rampage_tier = string.sub(ritual_key,35,35);
	--get the option choice by removing getting the final character (as a string)
	local option_choice = string.sub(ritual_key,-1,-1);

	--call TauroxRampage_RitualManager to lock all the other rituals AND re-enable end turn functionality
	TauroxRampage_RitualManager(rampage_tier, taurox_faction, false)
	
	--each ritual comes with a dread reward as well
	local dread_reward = {
		["1"] = 50,
		["2"] = 100,
		["3"] = 200,
	};

	if rampage_tier == "1" then
		--all the tier 1 rituls grant an effect bundle to Tauro with the same name as the ritual - to target Taurox specifically we do it in script
		cm:apply_effect_bundle_to_character(ritual_key, taurox_character, 5);

		--we check if its unlocked before marking it complete because we reset all these to false when a rampage is over but a player may not have used an unlocked ritual if they lose their rampage
		--if a ritual is unlocked BUT the player is at a threshold below that rituals tier then the UI will force the player to choose a ritual before they can continue their turn
		if completed_rampage_rituals["tier_1"].unlocked == true then
			completed_rampage_rituals["tier_1"].completed = true;
		end
	elseif rampage_tier == "2" then
		--tier 2 option 3 changes moon phases which is handled in the wh_dlc03_beastmen_moon.lua file, everthing else is effect bundles on Taurox
		if option_choice == "1" or option_choice == "2" then
			cm:apply_effect_bundle_to_character(ritual_key, taurox_character, 5)
		end
		if completed_rampage_rituals["tier_2"].unlocked == true then
			completed_rampage_rituals["tier_2"].completed = true;
		end
	elseif rampage_tier == "3" then
		
		if completed_rampage_rituals["tier_3"].unlocked == true then
			completed_rampage_rituals["tier_3"].completed = true;
		end
	end
	
	cm:faction_add_pooled_resource(taurox_faction_key, "bst_dread", "wh2_dlc17_bst_dread_gain_taurox_rampage", dread_reward[rampage_tier]);

end


--Controls the gifting of traits
function TauroxRampage_TraitManager(trait)
	
	local taurox_faction = cm:get_faction(taurox_faction_key);
	local taurox_character = taurox_faction:faction_leader();

	--add special HIDDEN TRAIT
	cm:force_add_trait(cm:char_lookup_str(taurox_character), hidden_traits[trait].key, true);

	--add one level to the trait
	hidden_traits[trait].level = hidden_traits[trait].level + 1;

	--if the trait is at its max level then mark it as maxed out
	if hidden_traits[trait].level == hidden_traits[trait].max_level then
		hidden_traits[trait].maxed_out = true;
	end

end

--restarts Rampage, this could be because of loss or victory - need to inform the function whether to reset momentum or not
function TauroxRampage_RampageRestart(victory)
	local taurox_faction = cm:get_faction(taurox_faction_key);
	
	local current_rampage_value = taurox_faction:pooled_resource_manager():resource("bst_rampage"):value()
	cm:faction_add_pooled_resource(taurox_faction_key, "bst_rampage", "wh2_dlc17_taurox_bst_rampage_used_rampage_over", -current_rampage_value);

	--Restarting Rampage because player completed all 3 rituals, need to manually restart momentum in this scenario
	if victory == true then
		local current_momentum_value = taurox_faction:pooled_resource_manager():resource("bst_momentum"):value()
		--remove any remaining momentum
		cm:faction_add_pooled_resource(taurox_faction_key,"bst_momentum", "wh2_dlc17_taurox_bst_momentum_lost_rampage_over", -current_momentum_value);
		
		-- fire event for Successfully reaching final tier of Rampage
		core:trigger_event("ScriptEventTauroxRampageSuccess");
	else
		cm:trigger_incident(taurox_faction_key, "wh2_dlc17_bst_taurox_rampage_over_loss", true);
	end

	--reset momentum
	cm:faction_add_pooled_resource(taurox_faction_key,"bst_momentum", momentum_matrix["rampage_base"].factor, momentum_matrix["rampage_base"].amount);
	
	--reset all ritual statuses
	completed_rampage_rituals["tier_1"].unlocked = false;
	completed_rampage_rituals["tier_2"].unlocked = false;
	completed_rampage_rituals["tier_3"].unlocked = false;
	completed_rampage_rituals["tier_1"].completed = false;
	completed_rampage_rituals["tier_2"].completed = false;
	completed_rampage_rituals["tier_3"].completed = false;

	cm:set_saved_value("taurox_rampage_active", false)
	
	--fire event for rampage over advice
	core:trigger_event("ScriptEventTauroxRampageOver");

end



function TauroxRampage_UpdateRiverOfBlood(region, has_skill)
	if region:is_null_interface() then
		---return in case this is a sea region or somehow occurred outside of a region
		return
	end

	local bundle_level = 0
	local region_key = region:name()

	for i, bundle_key in ipairs(RiverOfBlood.bundle_keys) do
		if region:has_effect_bundle(bundle_key) then
			cm:remove_effect_bundle_from_region(bundle_key, region_key)
			bundle_level = i
		end
	end

	bundle_level = bundle_level + 1

	if has_skill then
		bundle_level = bundle_level + RiverOfBlood.skill_bonus_stacks
	end

	if bundle_level > #RiverOfBlood.bundle_keys then
		bundle_level = #RiverOfBlood.bundle_keys
	end

	cm:apply_effect_bundle_to_region(RiverOfBlood.bundle_keys[bundle_level], region_key, RiverOfBlood.duration)

end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("momentum_matrix", momentum_matrix, context);
		cm:save_named_value("hidden_traits", hidden_traits, context);
		cm:save_named_value("consecutive_battles_won_this_turn", consecutive_battles_won_this_turn, context);	
		cm:save_named_value("base_battle_rampage", base_battle_rampage, context);
		cm:save_named_value("completed_rampage_rituals", completed_rampage_rituals, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			momentum_matrix = cm:load_named_value("momentum_matrix", momentum_matrix, context);
			hidden_traits = cm:load_named_value("hidden_traits", hidden_traits, context);
			consecutive_battles_won_this_turn = cm:load_named_value("consecutive_battles_won_this_turn", consecutive_battles_won_this_turn, context);		
			base_battle_rampage = cm:load_named_value("base_battle_rampage", base_battle_rampage, context);
			completed_rampage_rituals = cm:load_named_value("completed_rampage_rituals", completed_rampage_rituals, context);
		end
	end
);
