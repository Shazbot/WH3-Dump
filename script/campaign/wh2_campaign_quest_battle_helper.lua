
-----QUEST BATTLE HELPER-----------------------------------------------------------------------------------------
-----This script contains various functions to aid with quest battles that need to be called in either campaign-----
-----Author: Will Wright-------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------




----------------------------------------------------------------------------------------------
--------------------VARIABLES-----------------------------------------------------------------
----------------------------------------------------------------------------------------------



qbh = {}

----------------------------------------------------------------------------------------------
--------------------SETUP-------------------------------------------------------------------
----------------------------------------------------------------------------------------------


--- add any functions you want called in both campaigns here
function qbh:initialise()

	qbh:setup_qb_effect_bundle_listener("wh2_dlc15_bundle_talisman_of_hoeth_army_ability","wh2_dlc15_qb_hef_eltharion_talisman_of_hoeth_stage_3",true, "defender")
	qbh:setup_qb_effect_bundle_listener("wh2_dlc16_call_to_ceithin_har_enable","wh2_dlc16_qb_wef_sisters_dragon",true, "attacker")
	qbh:setup_qb_effect_bundle_listener("wh2_dlc17_qb_bundle_ancestor_rune_grimnir","wh2_dlc17_qb_dwf_thorek_lost_vault",true, "attacker")
end


--- add condition functions here, if required:


----------------------------------------------------------------------------------------------
--------------------FUNCTIONS-----------------------------------------------------------------
----------------------------------------------------------------------------------------------


--- @qbh:setup_qb_effect_bundle_listener
--- @desc create a listener that will apply an effect bundle to specified armies in a specified set piece battle.
--- @p effect_bundle_key The effect bundle to be applied. Accepts a string.
--- @p set_piece_battle_key The battle the listener should trigger for. Accepts a string.
--- @p condition Allows for conditional functions to be added. If function returns true, applies the bundle.
--- @p opt_side "attacker" or "defender". If nil, applies to both sides
--- @r nil

function qbh:setup_qb_effect_bundle_listener(effect_bundle_key,set_piece_battle_key,condition,opt_side) 
	
	--- check the side is valid now so any errors will get flagged up on boot
	if opt_side ~= nil and opt_side ~= "attacker" and opt_side ~= "defender" then
		out.design("Quest Battle Helper - setup_qb_effect_bundle_listener: invalid value set for 'side'. Accepts 'attacker', 'defender' or nil")
	end

	-- Create listener
	core:add_listener(
		effect_bundle_key.."EffectBundlePendingBattle",
		"PendingBattle",
		function()
			local pb = cm:model():pending_battle();
			return pb:set_piece_battle_key():find(set_piece_battle_key);
		end,
		function()
			local pb = cm:model():pending_battle();
			local defender = pb:defender();
			local attacker = pb:attacker()
			local defender_cqi = defender:military_force():command_queue_index();
			local attacker_cqi = attacker:military_force():command_queue_index();
			if condition then
				if opt_side == nil or opt_side == "defender" then
					out.design("Quest Battle Helper - setup_qb_effect_bundle_listener: Granting army abilities to defender belonging to " .. defender:faction():name());		
					cm:apply_effect_bundle_to_force(effect_bundle_key, defender_cqi, 0);
				end
				
				if opt_side == nil or opt_side == "attacker" then
					out.design("Quest Battle Helper- setup_qb_effect_bundle_listener: Applying effect bundle to attacker belonging to " .. attacker:faction():name());		
					cm:apply_effect_bundle_to_force(effect_bundle_key, attacker_cqi, 0);
				end
				cm:update_pending_battle();
			end
				
		end,
		true
	);
	
	-- player completes the quest battle
	core:add_listener(
		effect_bundle_key.."EffectBundleBattleCompleted",
		"BattleCompleted",
		function()
			local pb = cm:model():pending_battle();
			return pb:set_piece_battle_key():find(set_piece_battle_key);
		end,
		function()
			local pb = cm:model():pending_battle();
			local defender = pb:defender();
			local attacker = pb:attacker()
			
			-- remove army ability effect bundle from everybody with a still-valid force, just to be sure.
			if attacker then
				cm:remove_effect_bundle_from_force(effect_bundle_key, attacker:military_force():command_queue_index());
			end

			if defender then
				cm:remove_effect_bundle_from_force(effect_bundle_key, defender:military_force():command_queue_index());
			end
		end,
		true
	);
end



