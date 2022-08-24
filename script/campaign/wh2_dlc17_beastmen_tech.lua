local lock_tech_keys = {
	"tech_dlc17_bst_bretonnia_locked",
	"tech_dlc17_bst_dwarf_locked",
	"tech_dlc17_bst_empire_locked",
	"tech_dlc17_bst_high_elves_locked",
	"tech_dlc17_bst_wipe_out_faction",
	"tech_dlc17_bst_bloodgrounds_everywhere",
	"tech_dlc17_bst_chariot_only",
	"tech_dlc17_bst_fifteen_spells",
	"tech_dlc17_bst_four_battles",
	"tech_dlc17_bst_the_no_unit_loss",
	"tech_dlc17_bst_the_single_entity_tech",
	"tech_dlc17_bst_unfavoured_battle"
};

local beastmen_culture = "wh_dlc03_bst_beastmen";

local beastmen_players = {

};

local siege_battle_variable = 5;
local ritual_ruin_variable = 2;
local agent_actions_variable = 5;
local ambush_battle_variable = 5;
local climates_counter_variable = 3;
local culture_counter_variable = 4;
local same_turn_battles_win_variable = 4;
local faction_leader_variable = 5;
local unfavoured_variable = 3;
local summon_threshold = 10;
local hero_amount = 5;
local same_turn_reset = 3;
local hero_class = "com";

local listener_cache = {
    ["heroes_army"] = { 
        callback_resolved = false,
        military_forces = {}
    };
};

function add_beast_tech_lock_listeners()
	-- Starts the tech lock and unlock listeners if any of the Beastmen factions are human
	-- Checks if its a new game so this does not always lock the techs.
	if cm:is_new_game() == true then
		local faction_list = cm:model():world():faction_list();
		
		for i = 1, faction_list:num_items() - 1 do
			local current_faction = faction_list:item_at(i);
			
			if current_faction:culture() == beastmen_culture then
				local faction_key = current_faction:name();
				for j = 1, #lock_tech_keys do
					cm:lock_technology(faction_key, lock_tech_keys[j]);
				end
				
				out("\t\t"..faction_key..":");
				if current_faction:is_human() == true then
					if beastmen_players[faction_key] == nil then
						beastmen_players[faction_key] = {
							battle_win = 0,
							rituals_cast = 0,
							agent_actions = 0,
							percentage_wins = 0,
							climates_counter = 0,
							culture_counter = 0,
							same_turn_battle_wins = 0,
							unfavoured_counter = 0,
							summon_counter = 0,
							faction_leader_counter = 0,
							climate_done = {},
							culture_done = {},
							techs_unlocked = {},
						};
					end
				end
				cm:update_technology_unlock_progress_values(faction_key, "tech_dlc17_bst_bretonnia_locked", {0});
				cm:update_technology_unlock_progress_values(faction_key, "tech_dlc17_bst_bloodgrounds_everywhere", {0});
				cm:update_technology_unlock_progress_values(faction_key, "tech_dlc17_bst_dwarf_locked", {0});
				cm:update_technology_unlock_progress_values(faction_key, "tech_dlc17_bst_high_elves_locked", {0});
				cm:update_technology_unlock_progress_values(faction_key, "tech_dlc17_bst_the_no_unit_loss", {0});
				cm:update_technology_unlock_progress_values(faction_key, "tech_dlc17_bst_unfavoured_battle", {0});
				cm:update_technology_unlock_progress_values(faction_key, "tech_dlc17_bst_wipe_out_faction", {0});
				cm:update_technology_unlock_progress_values(faction_key, "tech_dlc17_bst_fifteen_spells", {0});
				cm:update_technology_unlock_progress_values(faction_key, "tech_dlc17_bst_chariot_only", {0});
				cm:update_technology_unlock_progress_values(faction_key, "tech_dlc17_bst_four_battles", {0});
			end
		end	
	end
	
	for key, data in pairs(beastmen_players) do
		TechLockUnlockListener(key, data);
		Reconstruct_HeroesPostBattle();
		GlobalUpgradesEvent();
	end 
end

function TechLockUnlockListener(key, beastmen_player)
	out("#### Adding Beastmen Tech Lock Listeners ####");
	
	--Create a Headstone to unlock this tech, this is the first tech that should be unlockable by players in the first turn to get them invested in the panel
	core:add_listener(
		"HerdstoneCreated",
		"ScriptEventBloodgroundCreated",
		function(context)
			return key == context:faction():name();
		end,
		function (context)
			cm:unlock_technology(key, "tech_dlc17_bst_empire_locked");
			cm:unlock_technology(key, "tech_dlc17_bst_empire_unlock_1");
			cm:unlock_technology(key, "tech_dlc17_bst_empire_unlock_2");
			cm:unlock_technology(key, "tech_dlc17_bst_empire_unlock_3");
			cm:unlock_technology(key, "tech_dlc17_bst_empire_unlock_4");
			Tech_unlock_notify(key, "tech_dlc17_bst_empire_locked");
		end,
		true
	);	
	
	--Win Siege Battles to Unlock this Tech
	core:add_listener(
		"unlock_tech_battles",
		"CharacterCompletedBattle",
		function(context)
			return key == context:character():faction():name();
		end,
		function (context)
			local character = context:character();
			if cm:char_is_general_with_army(character) and character:won_battle() and context:pending_battle():siege_battle() == true and context:pending_battle():battle_type() == "settlement_standard" then
				if beastmen_player.battle_win < siege_battle_variable then
					beastmen_player.battle_win = beastmen_player.battle_win+1;
					cm:update_technology_unlock_progress_values(key, "tech_dlc17_bst_dwarf_locked", {(beastmen_player.battle_win)});
					
					if beastmen_player.battle_win == siege_battle_variable then
						cm:unlock_technology(key, "tech_dlc17_bst_dwarf_locked");
						cm:unlock_technology(key, "tech_dlc17_bst_dwarf_unlock_1");
						cm:unlock_technology(key, "tech_dlc17_bst_dwarf_unlock_2");
						cm:unlock_technology(key, "tech_dlc17_bst_dwarf_unlock_3");
						cm:unlock_technology(key, "tech_dlc17_bst_dwarf_unlock_4");
						Tech_unlock_notify(key, "tech_dlc17_bst_dwarf_locked");
					end
				end
			end
		end,
		true
	);	
	
	--Perform 3 Rituals of Ruin to Unlock this tech
	core:add_listener(
		"unlock_tech_ritual",
		"ScriptEventRitualofRuinPerformed",
		true,
		function(context)
			if beastmen_player.rituals_cast < ritual_ruin_variable then
				beastmen_player.rituals_cast = beastmen_player.rituals_cast + 1;
				cm:update_technology_unlock_progress_values(key, "tech_dlc17_bst_bretonnia_locked", {(beastmen_player.rituals_cast)});
				
				if beastmen_player.rituals_cast == ritual_ruin_variable then
					cm:unlock_technology(key, "tech_dlc17_bst_bretonnia_locked");
					cm:unlock_technology(key, "tech_dlc17_bst_bretonnia_unlock_1");
					cm:unlock_technology(key, "tech_dlc17_bst_bretonnia_unlock_2");
					cm:unlock_technology(key, "tech_dlc17_bst_bretonnia_unlock_3");
					cm:unlock_technology(key, "tech_dlc17_bst_bretonnia_unlock_4");
					Tech_unlock_notify(key, "tech_dlc17_bst_bretonnia_locked");
				end	
			end	
		end,
		true
	);	
	
	--Perform successful agent actions against enemies to unlock this Tech (Part 1 This checks agent actions against characters)
	core:add_listener(
		"unlock_tech_agents",
		"CharacterCharacterTargetAction",
		function(context)
			return key == context:character():faction():name();
		end,
		function (context)
			if context:target_character():faction():name() ~= key and (context:mission_result_critial_success() or context:mission_result_success()) and beastmen_player.agent_actions < agent_actions_variable then
				beastmen_player.agent_actions = beastmen_player.agent_actions +1;
				cm:update_technology_unlock_progress_values(key, "tech_dlc17_bst_the_no_unit_loss", {(beastmen_player.agent_actions)});
				
				if beastmen_player.agent_actions == agent_actions_variable then
					cm:unlock_technology(key, "tech_dlc17_bst_the_no_unit_loss");
					Tech_unlock_notify(key, "tech_dlc17_bst_the_no_unit_loss");
				end
			end
		end,
		true
	);

	--Perform successful agent actions against enemies to unlock this Tech (Part 2 This checks agent actions against settlements)
	core:add_listener(
		"unlock_tech_agents",
		"CharacterGarrisonTargetAction",
		function(context)
			return key == context:character():faction():name();
		end,
		function (context)
			if (context:mission_result_critial_success() or context:mission_result_success()) and beastmen_player.agent_actions < agent_actions_variable then
				beastmen_player.agent_actions = beastmen_player.agent_actions +1;
				cm:update_technology_unlock_progress_values(key, "tech_dlc17_bst_the_no_unit_loss", {(beastmen_player.agent_actions)});
				
				if beastmen_player.agent_actions == agent_actions_variable then
					cm:unlock_technology(key, "tech_dlc17_bst_the_no_unit_loss");
					Tech_unlock_notify(key, "tech_dlc17_bst_the_no_unit_loss");
				end
			end
		end,
		true
	);	
	
	--Win Ambush battles to unlock
	core:add_listener(
		"unlock_tech_casualty",
		"CharacterCompletedBattle",
		function(context)
			return key == context:character():faction():name();
		end,
		function (context)
		local character = context:character();
			if cm:char_is_general_with_army(character) and character:won_battle() and (context:pending_battle():night_battle() == true or context:pending_battle():ambush_battle() == true) then
				beastmen_player.percentage_wins = beastmen_player.percentage_wins + 1;
				cm:update_technology_unlock_progress_values(key, "tech_dlc17_bst_high_elves_locked", {(beastmen_player.percentage_wins)});
							
				if beastmen_player.percentage_wins == ambush_battle_variable then
					cm:unlock_technology(key, "tech_dlc17_bst_high_elves_locked");
					cm:unlock_technology(key, "tech_dlc17_bst_high_elves_1");
					cm:unlock_technology(key, "tech_dlc17_bst_high_elves_2");
					cm:unlock_technology(key, "tech_dlc17_bst_high_elves_3");
					cm:unlock_technology(key, "tech_dlc17_bst_high_elves_4");
					Tech_unlock_notify(key, "tech_dlc17_bst_high_elves_locked");
				end	
			end
		end,
		true
	);	
	
	--Have 3 characters reach rank 15 to unlock
	core:add_listener(
		"unlock_tech_rank_up",
		"CharacterRankUp",
		function(context)
			return key == context:character():faction():name();
		end,
		function (context)
			local character = context:character();
			
			if character:rank() == 15 and beastmen_player.unfavoured_counter < unfavoured_variable then
				beastmen_player.unfavoured_counter = beastmen_player.unfavoured_counter + 1;
				cm:update_technology_unlock_progress_values(key, "tech_dlc17_bst_unfavoured_battle", {(beastmen_player.unfavoured_counter)});
				
				if beastmen_player.unfavoured_counter == unfavoured_variable then
					cm:unlock_technology(key, "tech_dlc17_bst_unfavoured_battle");
					Tech_unlock_notify(key, "tech_dlc17_bst_unfavoured_battle");
				end
			end
		
		end,
		true
	);
	
	--Kill 5 Faction Leaders to unlock this tech
	core:add_listener(
	"faction_leader_unlock_tech",
	"CharacterCompletedBattle",
	function(context)
		return key == context:character():faction():name();
	end,
	function (context)
		local character = context:character();
		local faction = character:faction();
		
		if cm:char_is_general_with_army(character) and character:won_battle() and faction:is_human() then
			local enemies = cm:pending_battle_cache_get_enemies_of_char(character);
			
			for i = 1, #enemies do
				local enemy = enemies[i];
				
				if enemy ~= nil and enemy:is_null_interface() == false then
					local enemy_faction = enemy:faction();
					
					if enemy:is_faction_leader() and beastmen_player.faction_leader_counter < faction_leader_variable then
						beastmen_player.faction_leader_counter = beastmen_player.faction_leader_counter + 1;
						cm:update_technology_unlock_progress_values(key, "tech_dlc17_bst_chariot_only", {(beastmen_player.faction_leader_counter)});
						out("FACTION LEADER BATTLE");
						
						if beastmen_player.faction_leader_counter == faction_leader_variable then
							cm:unlock_technology(key, "tech_dlc17_bst_chariot_only");
							Tech_unlock_notify(key, "tech_dlc17_bst_chariot_only");
						end
						
					end
				end
			end
		end
	end,
	true
	);
	
	--Win a  Battle with at least 5 Heroes.
	core:add_listener(
		"unlock_tech_heroes_check",
		"PendingBattle",
		function(context)
			return not listener_cache["heroes_army"][1];
		end,
		function(context)
			local check_if_this_function_should_ever_be_triggered = false;
			local mf_to_be_checked = {};
			for i = 1, cm:pending_battle_cache_num_attackers() do
				local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
				local faction = cm:get_faction(current_faction_name) 
				if faction and not faction:is_null_interface() and faction:culture() == beastmen_culture and faction:is_human() then
					table.insert(mf_to_be_checked, this_mf_cqi);
				end
			end
			if #mf_to_be_checked == 0 then
				return;
			end
			local mf_to_set_listener = {};
			for k = 1, #mf_to_be_checked do
				local attacker_mf = cm:get_military_force_by_cqi(mf_to_be_checked[k]);
				local bst_unit_list = attacker_mf:unit_list();
				local counter = 0;
				
				for i = 0, bst_unit_list:num_items() -1 do
					local unit = bst_unit_list:item_at(i);
					local unit_class = unit:unit_class();
					if unit_class == hero_class then
						counter = counter + 1;
					end
				end
				
				if counter >= hero_amount then
				-- set up post battle listener for triggering the tech upon victory
					table.insert(mf_to_set_listener, mf_to_be_checked[k]);
				end	
											
			end
			if #mf_to_set_listener == 0 then
				return;
			else
				listener_cache["heroes_army"][2] = mf_to_set_listener;
				listener_cache["heroes_army"][1] = true;
				--cache the mf, and reconstruct the listeners at the beginning
				Reconstruct_HeroesPostBattle();
			end
		end,
		true
	);

	--Summon 10 Units in Battles
	core:add_listener(
		"unlock_tech_battles",
		"CharacterCompletedBattle",
		function(context)
			return key == context:character():faction():name();
		end,
		function (context)
			local character = context:character();
			local faction = character:faction();
			local faction_cqi = faction:command_queue_index();
			--check if technology has been unlocked for this faction and return if this has been unlocked
			local spell_uses = cm:model():pending_battle():get_how_many_times_ability_has_been_used_in_battle(faction_cqi, "wh_dlc03_spell_beasts_transformation_of_kadon") + cm:model():pending_battle():get_how_many_times_ability_has_been_used_in_battle(faction_cqi, "wh_dlc03_spell_wild_savage_dominion") + cm:model():pending_battle():get_how_many_times_ability_has_been_used_in_battle(faction_cqi, "wh2_dlc17_spell_bound_savage_dominion")
			beastmen_player.summon_counter = spell_uses + beastmen_player.summon_counter;
			out(beastmen_player.summon_counter);
			cm:update_technology_unlock_progress_values(key, "tech_dlc17_bst_fifteen_spells", {(beastmen_player.summon_counter)});
			if cm:char_is_general_with_army(character) and beastmen_player.summon_counter >= summon_threshold then
				cm:unlock_technology(key, "tech_dlc17_bst_fifteen_spells");
				Tech_unlock_notify(key, "tech_dlc17_bst_fifteen_spells");
			end
		end,
		true
	);	
	
	--Set Bloodground in 3 different climates(will need to be updated when we add the new occupation option)
	core:add_listener(
		"Blooground_different_climate",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return key == context:character():faction():name() and Bloodgrounds.herdstone_settlement_options[context:occupation_decision()];
		end,
		function(context)
			local character = context:character();
			local settlement = context:garrison_residence():settlement_interface();
			local climate = settlement:get_climate();
			
			
			if next(beastmen_player.climate_done) ~= nil then
				for i = 1, #beastmen_player.climate_done do
					if climate ~= beastmen_player.climate_done[i] and beastmen_player.climates_counter < climates_counter_variable then
						table.insert(beastmen_player.climate_done, climate);
						beastmen_player.climates_counter = beastmen_player.climates_counter +1;
						cm:update_technology_unlock_progress_values(key, "tech_dlc17_bst_bloodgrounds_everywhere", {(beastmen_player.climates_counter)});
						if beastmen_player.climates_counter == climates_counter_variable then
							cm:unlock_technology(key, "tech_dlc17_bst_bloodgrounds_everywhere");
							Tech_unlock_notify(key, "tech_dlc17_bst_bloodgrounds_everywhere");
						end
					end
				end	
			else 
				table.insert(beastmen_player.climate_done, climate);
				beastmen_player.climates_counter = beastmen_player.climates_counter +1;
				cm:update_technology_unlock_progress_values(key, "tech_dlc17_bst_bloodgrounds_everywhere", {(beastmen_player.climates_counter)});
			end
		end,
		true
	);
	
	--Win battles against enemies of 4 Different Cultures
	core:add_listener(
		"Battle_Different_Culture",
		"CharacterCompletedBattle",
		function(context)
			return key == context:character():faction():name();
		end,
		function (context)
			local character = context:character();
			if cm:char_is_general_with_army(character) and character:won_battle() then
				local enemies = cm:pending_battle_cache_get_enemies_of_char(character);
				for i = 1, #enemies do
					local enemy = enemies[i];
					local enemy_faction = enemy:faction();
					local enemy_culture = enemy_faction:culture();
					if next(beastmen_player.culture_done) ~= nil then
						for j = 1, #beastmen_player.culture_done do
							if enemy_culture ~= beastmen_player.culture_done[j] and beastmen_player.culture_counter < culture_counter_variable then
								table.insert(beastmen_player.culture_done, enemy_culture);
								beastmen_player.culture_counter = beastmen_player.culture_counter + 1;
								cm:update_technology_unlock_progress_values(key, "tech_dlc17_bst_wipe_out_faction", {(beastmen_player.culture_counter)});

								if beastmen_player.culture_counter == culture_counter_variable then
									cm:unlock_technology(key, "tech_dlc17_bst_wipe_out_faction");
									Tech_unlock_notify(key, "tech_dlc17_bst_wipe_out_faction");
								end
							end
						end	
					else
						table.insert(beastmen_player.culture_done, enemy_culture);
						beastmen_player.culture_counter = beastmen_player.culture_counter + 1;
						cm:update_technology_unlock_progress_values(key, "tech_dlc17_bst_wipe_out_faction", {(beastmen_player.culture_counter)});
					end
				end		
			end
		end,
		true
	);

	--Win 5 Battles in 1 Turn to unlock this tech
	core:add_listener(
		"unlock_tech_battles",
		"CharacterCompletedBattle",
		function(context)
			return key == context:character():faction():name();
		end,
		function (context)
			local character = context:character();
			if cm:char_is_general_with_army(character) and character:won_battle() and beastmen_player.same_turn_battle_wins < same_turn_battles_win_variable then
				beastmen_player.same_turn_battle_wins = beastmen_player.same_turn_battle_wins + 1;
				cm:update_technology_unlock_progress_values(key, "tech_dlc17_bst_four_battles", {(beastmen_player.same_turn_battle_wins)});
				
				if beastmen_player.same_turn_battle_wins == same_turn_battles_win_variable then
					cm:unlock_technology(key, "tech_dlc17_bst_four_battles");
					Tech_unlock_notify(key, "tech_dlc17_bst_four_battles");
				end
			end
		end,
		true
	);
	
	--This function resets the same turn battle win counter, how do I turn this off after the player has unlocked the tech?
	core:add_listener(
		"FactionTurnEnd_Reset_Same_Turn_Battles_Win_Counter",
		"FactionTurnEnd",
		function(context)
			return key == context:faction():name();
		end,
		function(context)
			if beastmen_player.same_turn_battle_wins <= same_turn_reset then
				beastmen_player.same_turn_battle_wins = 0;
				cm:update_technology_unlock_progress_values(key, "tech_dlc17_bst_four_battles", {0});
			end
		end,
		true
	);

end

function Reconstruct_HeroesPostBattle()
	core:add_listener(
		"HeroBattleCompleted",
		"BattleCompleted",
		function()
			return cm:model():pending_battle():has_been_fought() and listener_cache["heroes_army"][1];
		end,
		function (context)
			listener_cache["heroes_army"][1] = false;
			if #listener_cache["heroes_army"][2]  == 0 then
				return;
			end
			for i = 1, #listener_cache["heroes_army"][2] do
				local key = cm:get_military_force_by_cqi(listener_cache["heroes_army"][2][i]):faction():name();
				if cm:pending_battle_cache_attacker_victory() == true then
					cm:unlock_technology(key, "tech_dlc17_bst_the_single_entity_tech");
					Tech_unlock_notify(key, "tech_dlc17_bst_the_single_entity_tech");
				end
			end
		end,
		true
	);
end

function GlobalUpgradesEvent()
	core:add_listener(
		"mark_of_ruin_hero_category_purchase",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_category() == "BEASTMEN_RITUAL_UPGRADES"
		end,
		function(context)
			local ritual_key = context:ritual():ritual_key()
			local faction = context:performing_faction():name() 
			GlobalUpgradeNotify(faction, ritual_key);
		end,
		true
	);
end

function GlobalUpgradeNotify(faction, ritual_key)
	local title = "event_feed_strings_text_wh2_dlc17_bst_upgrade_unlock_title"
	local primary_detail = "factions_screen_name_" .. faction
	local secondary_detail = "event_feed_strings_text_wh2_dlc17_bst_upgrade_unlock_"..ritual_key
	local pic = 1802

	cm:show_message_event(
		faction,
		title,
		primary_detail,
		secondary_detail,
		true,
		pic
	)
end
	
function Tech_unlock_notify(key, tech_name)
	if beastmen_players[key].techs_unlocked[tech_name] == nil then
		beastmen_players[key].techs_unlocked[tech_name] = true

		local title = "event_feed_strings_text_wh2_dlc17_bst_tech_unlock_title"
		local primary_detail = "factions_screen_name_" .. key
		local secondary_detail = "event_feed_strings_text_wh2_dlc17_bst_tech_unlock_"..tech_name
		local pic = 1801

		cm:show_message_event(
			key,
			title,
			primary_detail,
			secondary_detail,
			true,
			pic
		)
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("listener_cache", listener_cache, context);
		cm:save_named_value("beastmen_players", beastmen_players, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			listener_cache = cm:load_named_value("listener_cache", listener_cache, context);
			beastmen_players = cm:load_named_value("beastmen_players", beastmen_players, context);
		end
	end
);