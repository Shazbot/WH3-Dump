secrets_of_the_white_tower = {
	rituals_to_traits = {
		["wh3_dlc27_secrets_of_the_white_tower_being_summon_beasts"]=
		{
			"wh3_dlc27_trait_hef_white_tower_summon_mage_beasts_1",
			"wh3_dlc27_trait_hef_white_tower_summon_mage_beasts_2",
		},
		["wh3_dlc27_secrets_of_the_white_tower_being_summon_life"]=
		{
			"wh3_dlc27_trait_hef_white_tower_summon_mage_life_1",
			"wh3_dlc27_trait_hef_white_tower_summon_mage_life_2",
		},
		["wh3_dlc27_secrets_of_the_white_tower_brilliance_summon_heavens"]=
		{
			"wh3_dlc27_trait_hef_white_tower_summon_mage_heavens_1",
			"wh3_dlc27_trait_hef_white_tower_summon_mage_heavens_2",
		},
		["wh3_dlc27_secrets_of_the_white_tower_brilliance_summon_light"]=
		{
			"wh3_dlc27_trait_hef_white_tower_summon_mage_light_1",
			"wh3_dlc27_trait_hef_white_tower_summon_mage_light_2",

		},
		["wh3_dlc27_secrets_of_the_white_tower_darkness_summon_death"]=
		{
			"wh3_dlc27_trait_hef_white_tower_summon_mage_death_1",
			"wh3_dlc27_trait_hef_white_tower_summon_mage_death_2",
		},
		["wh3_dlc27_secrets_of_the_white_tower_darkness_summon_shadows"]=
		{
			"wh3_dlc27_trait_hef_white_tower_summon_mage_shadows_1",
			"wh3_dlc27_trait_hef_white_tower_summon_mage_shadows_2",
		},
		["wh3_dlc27_secrets_of_the_white_tower_high_loremaster_summon_high"]=
		{
			"wh3_dlc27_trait_hef_white_tower_summon_mage_high_1",
			"wh3_dlc27_trait_hef_white_tower_summon_mage_high_2",
		},
		["wh3_dlc27_secrets_of_the_white_tower_oblivion_summon_fire"]=
		{
			"wh3_dlc27_trait_hef_white_tower_summon_mage_fire_1",
			"wh3_dlc27_trait_hef_white_tower_summon_mage_fire_2",
		},
		["wh3_dlc27_secrets_of_the_white_tower_oblivion_summon_metal"]=
		{
			"wh3_dlc27_trait_hef_white_tower_summon_mage_metal_1",
			"wh3_dlc27_trait_hef_white_tower_summon_mage_metal_2",
		},
	},

	current_ritual_key = "", -- When a ritual to invoke an agent is started, we set this string and listen for character_recruited to change its traits.
	faction_key = "wh2_main_hef_order_of_loremasters",
	disable_pr_effect_bundle = "wh3_dlc27_disable_post_battle_pooled_resource_scrolls_of_power",
	nb_of_agents_bonus_value_key = "wh3_dlc27_agents_in_teclis_army",
	current_forces_in_battle = {},
	dilemma_teleport_key = "wh3_dlc27_hef_teclis_confederation_saphery",
	dilemma_teleport_region_key = "wh3_main_combi_region_white_tower_of_hoeth",
	remove_trespass_immunity_turn = -1,
	ritual_shackles_of_war_key = "wh3_dlc27_secrets_of_the_white_tower_oblivion_ritual_2", 
	ritual_shackles_of_war_duration = 2, 
	ritual_shackles_of_war = {},
	ritual_invocation_of_resilience = "wh3_dlc27_secrets_of_the_white_tower_being_ritual_1",
	ritual_unseen_approach_bundle_key = "wh3_dlc27_hef_white_tower_ritual_darkness_agent_guaranteed_success",
}

function secrets_of_the_white_tower:initialise()
	core:add_listener(
		"secrets_of_the_white_tower_ritual_started",
		"RitualStartedEvent",
		function(context)
			return secrets_of_the_white_tower.rituals_to_traits[context:ritual():ritual_key()]
		end,
		function(context)
			secrets_of_the_white_tower.current_ritual_key = context:ritual():ritual_key()
		end,
		true
	)

	core:add_listener(
		"secrets_of_the_white_tower_ritual_completed_shackles_of_war",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == secrets_of_the_white_tower.ritual_shackles_of_war_key
		end,
		function(context)
			local mf = context:ritual():ritual_target():get_target_force()
			if not mf then 
				return
			end
			
			local current_ritual = {
				duration = secrets_of_the_white_tower.ritual_shackles_of_war_duration,
				mf_cqi = mf:command_queue_index(),
			}
			table.insert(secrets_of_the_white_tower.ritual_shackles_of_war, current_ritual)
			cm:set_force_has_retreated_this_turn(mf)
		end,
		true
	)

	core:add_listener(
		"secrets_of_the_white_tower_ritual_completed_invocation_of_resilience",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == secrets_of_the_white_tower.ritual_invocation_of_resilience
		end,
		function(context)
			local mf = context:ritual():ritual_target():get_target_force()
			if not mf then 
				return
			end
			cm:heal_military_force(mf)
		end,
		true
	)

	core:add_listener(
		"secrets_of_the_white_tower_agent_recruited",
		"CharacterRecruited",
		function(context)
			return secrets_of_the_white_tower.current_ritual_key ~= "" and context:character():faction():name() == secrets_of_the_white_tower.faction_key
		end,
		function(context)
			local traits = context:character():all_traits()
			local new_traits = secrets_of_the_white_tower.rituals_to_traits[secrets_of_the_white_tower.current_ritual_key]
			local character_lookup = "character_cqi:"..context:character():cqi()

			if #new_traits <= 0 then 
				script_error("[SECRETS OF THE WHITE TOWER] ERROR: attempting to replace character traits but there are none for this ritual : " .. secrets_of_the_white_tower.current_ritual_key);
				return
			end

			-- Remove all existing traits.
			for i, trait in dpairs(traits) do 
				cm:force_remove_trait(character_lookup, trait)
			end

			cm:remove_all_background_skills(character_lookup)
			
			-- Get the traits from the table, and add them to the char. 
			for i, trait in dpairs(new_traits) do 
				cm:force_add_trait_to_character_details(context:character():character_details(), trait)
			end

			cm:set_character_immortality(character_lookup, true)
			secrets_of_the_white_tower.current_ritual_key = ""
		end,
		true
	)

	-- Listen to pending battles, and setup cqi tables
	core:add_listener(
		"secrets_of_the_white_tower_pending_battle",
		"PendingBattle",
		function(context)
			-- Find out if Teclis faction is in a battle and save the CQI.
			secrets_of_the_white_tower.current_forces_in_battle = {}
			local teclis_faction_in_battle = false

			local attacker = context:pending_battle():attacker()
			if attacker:faction():name() == secrets_of_the_white_tower.faction_key then
				table.insert(secrets_of_the_white_tower.current_forces_in_battle, attacker:military_force():command_queue_index())
				teclis_faction_in_battle = true
			end

			local defender = context:pending_battle():defender()
			if defender:faction():name() == secrets_of_the_white_tower.faction_key then
				table.insert(secrets_of_the_white_tower.current_forces_in_battle, defender:military_force():command_queue_index())
				teclis_faction_in_battle = true
			end

			local attacker_list = context:pending_battle():secondary_attackers()
			for i = 0, attacker_list:num_items() - 1 do
				local attacker = attacker_list:item_at(i)

				if attacker:faction():name() == secrets_of_the_white_tower.faction_key then
					table.insert(secrets_of_the_white_tower.current_forces_in_battle, attacker:military_force():command_queue_index())
					teclis_faction_in_battle = true
				end
			end

			local defender_list = context:pending_battle():secondary_defenders()
			for i = 0, defender_list:num_items() - 1 do
				local defender = defender_list:item_at(i)

				if defender:faction():name() == secrets_of_the_white_tower.faction_key then
					table.insert(secrets_of_the_white_tower.current_forces_in_battle, defender:military_force():command_queue_index())
					teclis_faction_in_battle = true
				end
			end

			return teclis_faction_in_battle
		end,
		function()
			for k, mf_cqi in ipairs(secrets_of_the_white_tower.current_forces_in_battle) do
				local mf = cm:get_military_force_by_cqi(mf_cqi)
				
				if mf:has_effect_bundle(secrets_of_the_white_tower.disable_pr_effect_bundle) then
					cm:remove_effect_bundle_from_force(secrets_of_the_white_tower.disable_pr_effect_bundle, mf_cqi)
				end

				if secrets_of_the_white_tower:get_agents_in_army_count(mf) <= 0 then
					cm:apply_effect_bundle_to_force(secrets_of_the_white_tower.disable_pr_effect_bundle, mf_cqi, 1)
				end
			end
		end,
		true
	)

	core:add_listener(
		"secrets_of_the_white_tower_dilemma_choice",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == secrets_of_the_white_tower.dilemma_teleport_key
		end,
		function(context)
			local choice = context:choice()
			local faction = context:faction()
			local region = cm:get_region(secrets_of_the_white_tower.dilemma_teleport_region_key) 
			
			secrets_of_the_white_tower:enable_trespass_immunity()
			secrets_of_the_white_tower.remove_trespass_immunity_turn = cm:turn_number() + 1

			if choice == 0 then
				-- Teleport armies/characters
				local character = faction:faction_leader()
				local x, y

				if not character then return end

				x, y = cm:find_valid_spawn_location_for_character_from_settlement(secrets_of_the_white_tower.faction_key, secrets_of_the_white_tower.dilemma_teleport_region_key, false, true, 10)

				if character:has_military_force() then
					local mf = character:military_force()
					cm:teleport_military_force_to(mf, x, y)
				end

				cm:scroll_camera_from_current(false, 3, {196, 430, 8, 0, 16}) --camv2 196.830826 16.445755 422.161743 196.830826 2.480171 433.676239
			end
		end,
		false
	)

	core:add_listener(
		"secrets_of_the_white_tower_military_force_destroyed",
		"MilitaryForceDestroyed",
		function(context)
			return #secrets_of_the_white_tower.ritual_shackles_of_war > 0
		end,
		function(context)
			local destroyed_force = context:military_force()
			local destroyed_force_cqi = destroyed_force:command_queue_index()
			for i, item in dpairs(secrets_of_the_white_tower.ritual_shackles_of_war) do
				if destroyed_force_cqi == item.mf_cqi then
					table.remove(secrets_of_the_white_tower.ritual_shackles_of_war, i);
				end
			end
		end,
		true
	)

	core:add_listener(
		"secrets_of_the_white_tower_update_shackles_of_war",
		"FactionTurnStart",
		function(context)
			if #secrets_of_the_white_tower.ritual_shackles_of_war > 0 then
				if context:faction():name() == secrets_of_the_white_tower.faction_key then 
					for i, item in dpairs(secrets_of_the_white_tower.ritual_shackles_of_war) do
						local mf = cm:get_military_force_by_cqi(item.mf_cqi)
						if mf and item.duration > 0 then
							return true
						elseif not mf then 
							table.remove(secrets_of_the_white_tower.ritual_shackles_of_war, i);
						end
					end
				end
			else
				return false
			end
		end,
		function(context)
			local mf
			for i, item in dpairs(secrets_of_the_white_tower.ritual_shackles_of_war) do
				mf = cm:get_military_force_by_cqi(item.mf_cqi)
				item.duration = item.duration - 1
				if mf and not mf:is_null_interface() then
					cm:set_force_has_retreated_this_turn(mf)
				end

				if item.duration <= 0 then 
					table.remove(secrets_of_the_white_tower.ritual_shackles_of_war, i);
				end
			end
		end,
		true
	)

	core:add_listener(
		"secrets_of_the_white_tower_remove_trepass_immunity",
		"FactionTurnStart",
		function(context)
			if secrets_of_the_white_tower.remove_trespass_immunity_turn >= 0  then
				local faction = context:faction()
				local turn_no = cm:turn_number()
				return turn_no > 0 and turn_no >= secrets_of_the_white_tower.remove_trespass_immunity_turn and faction:is_human() and faction:name() == secrets_of_the_white_tower.faction_key
			end
		end,
		function(context)
			local hef_factions = cm:get_factions_by_culture("wh2_main_hef_high_elves")
			local teclis_cqi = context:faction():command_queue_index()

			for _, faction in ipairs(hef_factions) do
				cm:remove_trespass_permission(teclis_cqi, faction:command_queue_index())
				secrets_of_the_white_tower.remove_trespass_immunity_turn = -1
			end
		end,
		true
	)

	core:add_listener(
		"secrets_of_the_white_tower_hero_target_action",
		"CharacterCharacterTargetAction",
		function(context)
			return context:target_character():faction():name() ~= secrets_of_the_white_tower.faction_key
		end,
		function(context)
			secrets_of_the_white_tower:check_hero_action_success(context)
		end,
		true
	)
	
	core:add_listener(
		"secrets_of_the_white_tower_hero_target_action_settlement",
		"CharacterGarrisonTargetAction", 
		true,
		function(context)
			secrets_of_the_white_tower:check_hero_action_success(context)
		end,
		true
	)
end

------------------------------
---------FIRST TICK EVENT-----
------------------------------

core:add_listener(
	"secrets_of_the_white_tower_init_shared_state",
	"FirstTickAfterNewCampaignStarted",
	function(context)
		return true
	end,
	function(context)
		for ritual, traits in dpairs(secrets_of_the_white_tower.rituals_to_traits) do
			local trait_string = ""
			for i, trait in dpairs(traits) do
				trait_string = trait_string .. trait
				if i < #traits then
					trait_string = trait_string .. "/"
				end
			end
			cm:set_script_state(ritual, trait_string)
		end
	end,
	true
)

------------------------------
---------FUNCTION/UTILS-------
------------------------------

function secrets_of_the_white_tower:get_agents_in_army_count(mf)
	local agent_count = cm:get_forces_bonus_value(mf, secrets_of_the_white_tower.nb_of_agents_bonus_value_key)
	
	if is_number(agent_count) then
		return agent_count
	end

	return 0
end

function secrets_of_the_white_tower:enable_trespass_immunity()
	local hef_factions = cm:get_factions_by_culture("wh2_main_hef_high_elves")
	local teclis_cqi = cm:get_faction(secrets_of_the_white_tower.faction_key):command_queue_index()

	for _, faction in ipairs(hef_factions) do
		cm:add_trespass_permission(teclis_cqi, faction:command_queue_index())
	end
end

function secrets_of_the_white_tower:check_hero_action_success(context)
	local faction = context:character():faction()
	if (context:mission_result_critial_success() or context:mission_result_success()) and 
		faction:name() == secrets_of_the_white_tower.faction_key and 
		faction:has_effect_bundle(secrets_of_the_white_tower.ritual_unseen_approach_bundle_key) then

		cm:remove_effect_bundle(secrets_of_the_white_tower.ritual_unseen_approach_bundle_key, secrets_of_the_white_tower.faction_key)
	end
end

------------------------------
---------SAVING/LOADING-------
------------------------------

cm:add_saving_game_callback(
	function(context)		
		cm:save_named_value("secrets_of_the_white_tower.ritual_shackles_of_war", secrets_of_the_white_tower.ritual_shackles_of_war, context)
		cm:save_named_value("secrets_of_the_white_tower.remove_trespass_immunity_turn", secrets_of_the_white_tower.remove_trespass_immunity_turn, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			secrets_of_the_white_tower.ritual_shackles_of_war = cm:load_named_value("secrets_of_the_white_tower.ritual_shackles_of_war", secrets_of_the_white_tower.ritual_shackles_of_war, context)
			secrets_of_the_white_tower.remove_trespass_immunity_turn = cm:load_named_value("secrets_of_the_white_tower.remove_trespass_immunity_turn", secrets_of_the_white_tower.remove_trespass_immunity_turn, context)
		end
	end
)