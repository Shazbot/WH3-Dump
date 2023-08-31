----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	SET_PIECE_BATTLE_ABILITIES
--- @desc Aggregates campaign listeners required for set piece battles to avoid duplication in every battle script 
--- to do: create function that can plug in battle key, attacker/defender/ability effect bundle keys 
--- to do: find relevant campaign listeners from various scripts for quest battles and add them here
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
set_piece_battle_abilities = {}

function set_piece_battle_abilities:initialise()


--------------------
-------ZHATAN-------
--------------------

-- Apply army abilities 

	core:add_listener(
	"ArmyAbilities",
	"PendingBattle",
		function()
			local pb = cm:model():pending_battle();
			return pb:set_piece_battle_key():find("wh3_dlc23_qb_chd_zhatan_chaos_runeshield");
		end,
		function()
			local pb = cm:model():pending_battle();
			local attacker = pb:attacker();
			local attacker_cqi = attacker:military_force():command_queue_index();
			out.design("Granting army abilities to force belonging to" .. attacker:faction():name());
			cm:apply_effect_bundle_to_force("wh3_dlc23_bundle_chaos_runeshield_quest_battle_army_abilities", attacker_cqi, 1);
			cm:update_pending_battle();
		end,
	true
	);

	-- player completes the quest battle
	core:add_listener(
		"BattleCompleted",
		"BattleCompleted",
		function()
			local pb = cm:model():pending_battle();
			return pb:set_piece_battle_key():find("wh3_dlc23_qb_chd_zhatan_chaos_runeshield");
		end,
		function()
			local pb = cm:model():pending_battle();
			local attacker = pb:attacker();
			local char_cqi = false;
			local mf_cqi = false;
			local faction_name = false;
			local has_been_fought = pb:has_been_fought();
			if has_been_fought then
				-- if the battle was fought, the character may have died, so get them from the pending battle cache
				char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(1);
			else
				-- if the player retreated, the pending battle cache won't have stored the faction, so get it from the character (who should still be alive as they retreated!)
				faction_name = attacker:faction():name();
			end;
			-- player has completed QB
			if attacker then
			-- remove army ability effect bundle
			cm:remove_effect_bundle_from_force("wh3_dlc23_bundle_chaos_runeshield_quest_battle_army_abilities", attacker:military_force():command_queue_index());
			end;
		end,
		true
	);

--------------------
------YUAN BO-------
--------------------

-- Apply army abilities 

	core:add_listener(
		"ArmyAbilities",
		"PendingBattle",
		function()
			local pb = cm:model():pending_battle();
			return pb:set_piece_battle_key():find("wh3_dlc24_cth_yuan_bo_dragons_fang");
		end,
		function()
			local pb = cm:model():pending_battle();
			local attacker = pb:attacker();
			local attacker_cqi = attacker:military_force():command_queue_index();
			out.design("Granting army abilities to force belonging to" .. attacker:faction():name());
			cm:apply_effect_bundle_to_force("wh3_dlc24_bundle_dragons_fang_army_abilities", attacker_cqi, 1);
			cm:update_pending_battle();
		end,
		true
	);

	-- player completes the quest battle
	core:add_listener(
		"BattleCompleted",
		"BattleCompleted",
		function()
			local pb = cm:model():pending_battle();
			return pb:set_piece_battle_key():find("wh3_dlc24_cth_yuan_bo_dragons_fang");
		end,
		function()
			local pb = cm:model():pending_battle();
			local attacker = pb:attacker();
			local char_cqi = false;
			local mf_cqi = false;
			local faction_name = false;
			local has_been_fought = pb:has_been_fought();
			if has_been_fought then
				-- if the battle was fought, the character may have died, so get them from the pending battle cache
				char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(1);
			else
				-- if the player retreated, the pending battle cache won't have stored the faction, so get it from the character (who should still be alive as they retreated!)
				faction_name = attacker:faction():name();
			end;
			-- player has completed QB
			if attacker then
			-- remove army ability effect bundle
			cm:remove_effect_bundle_from_force("wh3_dlc24_bundle_dragons_fang_army_abilities", attacker:military_force():command_queue_index());
			end;
		end,
		true
	);
end