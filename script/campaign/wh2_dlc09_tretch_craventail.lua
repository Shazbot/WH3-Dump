local retreat_bundle_name = "wh2_dlc09_bundle_tretch_retreat";
local tretch_subtype = "wh2_dlc09_skv_tretch_craventail";
local tretch_faction_name = "wh2_dlc09_skv_clan_rictus";

-- apply an effect bundle to tretch's force when he retreats from a defensive battle
core:add_listener(
	"apply_tretch_retreat_bundle",
	"CharacterWithdrewFromBattle",
	function(context)
		local pb = cm:model():pending_battle();
		local character = context:character();
		
		return character:faction():name() == tretch_faction_name and character:character_subtype_key() == tretch_subtype and pb:has_defender() and pb:defender():character_subtype_key() == tretch_subtype;
	end,
	function(context)
		cm:apply_effect_bundle_to_characters_force(retreat_bundle_name, context:character():command_queue_index(), 0);
	end,
	true
);

-- the effect bundle is removed after a fought battle
core:add_listener(
	"remove_tretch_retreat_bundle",
	"BattleCompleted",
	function()
		return cm:model():pending_battle():has_been_fought();
	end,
	function(context)
		local pb = cm:model():pending_battle();
		
		if pb:has_attacker() then
			remove_tretch_retreat_bundle(pb:attacker());
		elseif pb:has_defender() then
			remove_tretch_retreat_bundle(pb:defender());
		end;
	end,
	true
);

function remove_tretch_retreat_bundle(character)
	if character:character_subtype_key() == tretch_subtype and character:has_military_force() and character:military_force():has_effect_bundle(retreat_bundle_name) then
		cm:remove_effect_bundle_from_characters_force(retreat_bundle_name, character:command_queue_index());
	end;
end;

-- apply an effect bundle to tretch's faction when breaking a diplomatic treaty
core:add_listener(
	"apply_tretch_diplomatic_bundle",
	"NegativeDiplomaticEvent",
	function(context)
		local proposer = context:proposer();
		
		return proposer:is_human() and proposer:name() == tretch_faction_name and (context:was_alliance() or context:was_military_alliance() or context:was_defensive_alliance() or context:was_military_access() or context:was_trade_agreement() or context:was_non_aggression_pact());
	end,
	function(context)
		cm:apply_effect_bundle("wh2_dlc09_bundle_tretch_treaty_broken", tretch_faction_name, 5);
	end,
	true
);