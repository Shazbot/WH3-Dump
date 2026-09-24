
out.design("*** Schemers script loaded ***");

thanquol_schemers = {}

------------------
------DATA--------
------------------
thanquol_schemers.faction = "wh3_dlc29_skv_clan_scruten"
thanquol_schemers.agent_subtypes = 
{
	"wh3_dlc29_skv_schemer_grey_seer",
	"wh3_dlc29_skv_schemer_master_assassin",
	"wh3_dlc29_skv_schemer_warlord",
	"wh3_dlc29_skv_schemer_warlock_master",
}
thanquol_schemers.initially_unlocked =
{
	"wh3_dlc29_skv_schemer_grey_seer",
}
thanquol_schemers.character_unlocked_shared_state = "schemer_unlocked"
thanquol_schemers.magic_plan_subtypes = 
{
	verminlord = 
	{
		rat_group = "wh3_dlc29_magic_summon_verminlord_dummy_1",
		shop_unlock_token = "wh3_dlc29_magic_upgrade_verminlord_1",
	},
	undercity = 
	{
		rat_group = "wh3_dlc29_magic_create_undercity_1",
	},
	pull_moon = 
	{
		rat_group = "wh3_dlc29_magic_pull_moon_1",
	}
}
thanquol_schemers.block_stance_switching_effect_bundle = "wh3_dlc29_skv_schemer_no_stances"

------------------
----FUNCTIONS-----
------------------

-- Adding this listener must come before initialise(), then it is too late
core:add_listener (
	"SchemersInitialFixup",
	"FirstTickAfterNewCampaignStarted",
	true,
	function(context)
		local thanquol_faction = cm:get_faction(thanquol_schemers.faction)
		if not thanquol_faction then
			return
		end

		local char_list = thanquol_faction:character_list()
		for i = 0, char_list:num_items() - 1 do
			local character = char_list:item_at(i)
			local character_subtype_key = character:character_subtype_key()
			if table.find(thanquol_schemers.agent_subtypes, character_subtype_key) ~= nil then
				cm:apply_effect_bundle_to_characters_force(thanquol_schemers.block_stance_switching_effect_bundle, character:command_queue_index(), 0)
				cm:enter_limbo(cm:char_lookup_str(character))

				if table.find(thanquol_schemers.initially_unlocked, character_subtype_key) then
					cm:set_script_state(character:family_member(), thanquol_schemers.character_unlocked_shared_state, true)
				else
					cm:set_script_state(character:family_member(), thanquol_schemers.character_unlocked_shared_state, false)
				end
			end
		end

		cm:set_script_state(thanquol_faction, thanquol_schemers.magic_plan_subtypes.verminlord.rat_group, false)
		cm:set_script_state(thanquol_faction, thanquol_schemers.magic_plan_subtypes.undercity.rat_group, false)
		cm:set_script_state(thanquol_faction, thanquol_schemers.magic_plan_subtypes.pull_moon.rat_group, false)
	end,
	true
)

function thanquol_schemers:initialise()
	local thanquol_faction = cm:get_faction(thanquol_schemers.faction)
	if not thanquol_faction then
		return
	end

	core:add_listener(
		"SchemerRecruited",
		"CharacterRecruited",
		function(context)
			local character_subtype_key = context:character():character_subtype_key()
			return table.find(thanquol_schemers.agent_subtypes, character_subtype_key) ~= nil
		end,
		function(context)
			local character_str = cm:char_lookup_str(context:character())
			cm:apply_effect_bundle_to_characters_force(thanquol_schemers.block_stance_switching_effect_bundle, context:character():command_queue_index(), 0)
			cm:enter_limbo(character_str)
			cm:zero_action_points(character_str)
		end,
		true
	)

	core:add_listener(
		"SchemerTurnStart",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == thanquol_faction:name()
		end,
		function(context)
			local char_list = thanquol_faction:character_list()
			local schemers_count = 0
			for i = 0, char_list:num_items() - 1 do
				local character = char_list:item_at(i)
				local character_subtype_key = character:character_subtype_key()
				if table.find(thanquol_schemers.agent_subtypes, character_subtype_key) ~= nil then
					if	character:is_in_limbo() then
						schemers_count = schemers_count + 1
					end
					cm:zero_action_points(cm:char_lookup_str(character))
				end
			end
			cm:pooled_resource_factor_transaction(thanquol_faction:pooled_resource_manager():resource("skaven_food"), "army_upkeep", schemers_count)
		end,
		true
	)

	core:add_listener(
		"SchemerReplaced",
		"CharacterReplacingGeneral",
		function(context)
			local character = context:character()
			local force = character:military_force()
			return character:faction():name() == thanquol_schemers.faction and force:force_type():key() == "CHAOTIC_PLAN_SCHEMERS"
		end,
		function(context)
			local character_str = cm:char_lookup_str(context:character())
			cm:kill_character_and_commanded_unit(character_str, true, true)
		end,
		true
	)

	core:add_listener(
		"SchemerChaoticMilitaryPlanExecuted",
		"MilitaryChaoticPlanCompletedEvent",
		true,
		function(context)
			local region = context:region()

			local faction = context:faction()
			local opposing_faction = region:owning_faction()
			local schemer_family_member = context:schemer()
			local schemer_character = schemer_family_member:character()
			local schemer_character_lookup = cm:char_lookup_str(schemer_character)

			local x, y = thanquol_schemers:find_battle_coords_from_region(faction:name(), region:name())
			cm:leave_limbo(schemer_character_lookup, x, y, true)
			if opposing_faction and not opposing_faction:is_null_interface() and not opposing_faction:is_rebel() then
				cm:force_declare_war(faction:name(), opposing_faction:name(), false, false, false)
			end

			cm:replenish_action_points(schemer_character_lookup)
			cm:attack_region(schemer_character_lookup, region:name(), true)
			cm:zero_action_points(schemer_character_lookup)
		end,
		true
	)

	core:add_listener(
		"SchemerChaoticPlanPrepareForBattle",
		"ChaoticPlanSettlementAttackedEvent",
		true,
		function(context)
			local active_plan = context:plan()
			if not active_plan or active_plan:is_null_interface() then
				return
			end

			local schemer = active_plan:schemer():character()
			local x, y = thanquol_schemers:find_battle_coords_from_region(thanquol_faction:name(), active_plan:region():name())
			cm:leave_limbo(cm:char_lookup_str(schemer), x, y, true)
		end,
		true
	)
end

function thanquol_schemers:find_battle_coords_from_region(faction_key, region_key)
	
	local x,y = cm:find_valid_spawn_location_for_character_from_settlement(
		faction_key,
		region_key,
		false,
		true,
		3
		)
	
	return x,y
end


function thanquol_schemers.get_schemer_family_member(agent_subtype_key)
	local thanquol_faction = cm:get_faction(thanquol_schemers.faction)
	if not thanquol_faction then
		return nil
	end

	local char_list = thanquol_faction:character_list()
	for i = 0, char_list:num_items() - 1 do
		local character = char_list:item_at(i)
		local current_subtype_key = character:character_subtype_key()
		if agent_subtype_key == current_subtype_key then
			return character:family_member()
		end
	end
end

function thanquol_schemers.unlock_schemer(family_member)
	if not is_familymember(family_member) then
		return
	end
	
	cm:set_script_state(family_member, thanquol_schemers.character_unlocked_shared_state, true)
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		--TODO
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			--TODO
		end
	end
)