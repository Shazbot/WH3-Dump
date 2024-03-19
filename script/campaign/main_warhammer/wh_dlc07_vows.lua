local starting_vows = {
	{faction = "wh_main_brt_bretonnia", traits = {{key = "wh_dlc07_trait_brt_knights_vow_knowledge_pledge", points = 6}, {key = "wh_dlc07_trait_brt_questing_vow_campaign_pledge", points = 2}, {key = "wh_dlc07_trait_brt_grail_vow_untaint_pledge", points = 6}}},
	{faction = "wh_main_brt_bordeleaux", traits = {{key = "wh_dlc07_trait_brt_knights_vow_knowledge_pledge", points = 6}}},
	{faction = "wh2_dlc14_brt_chevaliers_de_lyonesse", traits = {{key = "wh_dlc07_trait_brt_knights_vow_knowledge_pledge", points = 6}, {key = "wh_dlc07_trait_brt_questing_vow_campaign_pledge", points = 2}}}
}	

local vow_to_troth = {
	["wh_dlc07_trait_brt_knights_vow_knowledge_pledge"] = "wh_dlc07_trait_brt_protection_troth_knowledge_pledge",
	["wh_dlc07_trait_brt_knights_vow_order_pledge"] = "wh_dlc07_trait_brt_protection_troth_order_pledge",
	["wh_dlc07_trait_brt_knights_vow_chivalry_pledge"] = "wh_dlc07_trait_brt_protection_troth_chivalry_pledge",
	["wh_dlc07_trait_brt_questing_vow_campaign_pledge"] = "wh_dlc07_trait_brt_wisdom_troth_campaign_pledge",
	["wh_dlc07_trait_brt_questing_vow_heroism_pledge"] = "wh_dlc07_trait_brt_wisdom_troth_heroism_pledge",
	["wh_dlc07_trait_brt_questing_vow_protect_pledge"] = "wh_dlc07_trait_brt_wisdom_troth_protect_pledge",
	["wh_dlc07_trait_brt_grail_vow_untaint_pledge"] = "wh_dlc07_trait_brt_virtue_troth_untaint_pledge",
	["wh_dlc07_trait_brt_grail_vow_valour_pledge"] = "wh_dlc07_trait_brt_virtue_troth_valour_pledge",
	["wh_dlc07_trait_brt_grail_vow_destroy_pledge"] = "wh_dlc07_trait_brt_virtue_troth_destroy_pledge",
	["wh_dlc07_trait_brt_knights_vow_knowledge_pledge_agent"] = "wh_dlc07_trait_brt_protection_troth_knowledge_pledge_agent",
	["wh_dlc07_trait_brt_knights_vow_order_pledge_agent"] = "wh_dlc07_trait_brt_protection_troth_order_pledge_agent",
	["wh_dlc07_trait_brt_knights_vow_chivalry_pledge_agent"] = "wh_dlc07_trait_brt_protection_troth_chivalry_pledge_agent",
	["wh_dlc07_trait_brt_questing_vow_campaign_pledge_agent"] = "wh_dlc07_trait_brt_wisdom_troth_campaign_pledge_agent",
	["wh_dlc07_trait_brt_questing_vow_heroism_pledge_agent"] = "wh_dlc07_trait_brt_wisdom_troth_heroism_pledge_agent",
	["wh_dlc07_trait_brt_questing_vow_protect_pledge_agent"] = "wh_dlc07_trait_brt_wisdom_troth_protect_pledge_agent",
	["wh_dlc07_trait_brt_grail_vow_untaint_pledge_agent"] = "wh_dlc07_trait_brt_virtue_troth_untaint_pledge_agent",
	["wh_dlc07_trait_brt_grail_vow_valour_pledge_agent"] = "wh_dlc07_trait_brt_virtue_troth_valour_pledge_agent",
	["wh_dlc07_trait_brt_grail_vow_destroy_pledge_agent"] = "wh_dlc07_trait_brt_virtue_troth_destroy_pledge_agent"
}

local vow_max_points = {
	["wh_dlc07_trait_brt_questing_vow_campaign_pledge"] = 2,
	["wh_dlc07_trait_brt_questing_vow_heroism_pledge"] = 2,
	["wh_dlc07_trait_brt_questing_vow_protect_pledge"] = 2,
	["wh_dlc07_trait_brt_grail_vow_untaint_pledge"] = 2
}

local vow_legendary_lord_cultures = {
	["wh_main_chs_chaos"] = "wh_dlc07_trait_brt_grail_vow_untaint_pledge",
	["wh3_main_dae_daemons"] = "wh_dlc07_trait_brt_grail_vow_untaint_pledge",
	["wh3_main_kho_khorne"] = "wh_dlc07_trait_brt_grail_vow_untaint_pledge",
	["wh3_main_nur_nurgle"] = "wh_dlc07_trait_brt_grail_vow_untaint_pledge",
	["wh3_main_sla_slaanesh"] = "wh_dlc07_trait_brt_grail_vow_untaint_pledge",
	["wh3_main_tze_tzeentch"] = "wh_dlc07_trait_brt_grail_vow_untaint_pledge",
	["wh2_main_skv_skaven"] = "wh_dlc07_trait_brt_grail_vow_untaint_pledge",
	["wh_main_vmp_vampire_counts"] = "wh_dlc07_trait_brt_grail_vow_untaint_pledge",
	["wh2_dlc11_cst_vampire_coast"] = "wh_dlc07_trait_brt_grail_vow_untaint_pledge",
	["wh_dlc03_bst_beastmen"] = "wh_dlc07_trait_brt_questing_vow_protect_pledge",
	["wh_main_grn_greenskins"] = "wh_dlc07_trait_brt_questing_vow_protect_pledge",
	["wh2_main_def_dark_elves"] = "wh_dlc07_trait_brt_questing_vow_protect_pledge",
	["wh3_main_ogr_ogre_kingdoms"] = "wh_dlc07_trait_brt_questing_vow_protect_pledge"
}

local all_knights_vows = 
{
	"wh_dlc07_trait_brt_knights_vow_knowledge_pledge", 
	"wh_dlc07_trait_brt_knights_vow_order_pledge",
	"wh_dlc07_trait_brt_knights_vow_chivalry_pledge",
	"wh_dlc07_trait_brt_protection_troth_knowledge_pledge",
	"wh_dlc07_trait_brt_protection_troth_order_pledge",
	"wh_dlc07_trait_brt_protection_troth_chivalry_pledge",
	"wh_dlc07_trait_brt_knights_vow_knowledge_pledge_agent", 
    "wh_dlc07_trait_brt_knights_vow_order_pledge_agent",
    "wh_dlc07_trait_brt_knights_vow_chivalry_pledge_agent",
	"wh_dlc07_trait_brt_protection_troth_knowledge_pledge_agent",
	"wh_dlc07_trait_brt_protection_troth_order_pledge_agent",
	"wh_dlc07_trait_brt_protection_troth_chivalry_pledge_agent"
}
local all_questing_vows = 
{
	"wh_dlc07_trait_brt_questing_vow_campaign_pledge",
	"wh_dlc07_trait_brt_questing_vow_heroism_pledge",
	"wh_dlc07_trait_brt_questing_vow_protect_pledge",
	"wh_dlc07_trait_brt_wisdom_troth_campaign_pledge",
	"wh_dlc07_trait_brt_wisdom_troth_heroism_pledge",
	"wh_dlc07_trait_brt_wisdom_troth_protect_pledge",
	"wh_dlc07_trait_brt_questing_vow_campaign_pledge_agent",
    "wh_dlc07_trait_brt_questing_vow_heroism_pledge_agent",
    "wh_dlc07_trait_brt_questing_vow_protect_pledge_agent",
	"wh_dlc07_trait_brt_wisdom_troth_protect_pledge_agent",
	"wh_dlc07_trait_brt_wisdom_troth_heroism_pledge_agent",
	"wh_dlc07_trait_brt_wisdom_troth_campaign_pledge_agent"
}
local all_grail_vows = 
{
	"wh_dlc07_trait_brt_grail_vow_untaint_pledge",
	"wh_dlc07_trait_brt_grail_vow_valour_pledge",
	"wh_dlc07_trait_brt_grail_vow_destroy_pledge",
	"wh_dlc07_trait_brt_virtue_troth_untaint_pledge",
	"wh_dlc07_trait_brt_virtue_troth_valour_pledge",
	"wh_dlc07_trait_brt_virtue_troth_destroy_pledge",
	"wh_dlc07_trait_brt_grail_vow_untaint_pledge_agent",
    "wh_dlc07_trait_brt_grail_vow_valour_pledge_agent",
    "wh_dlc07_trait_brt_grail_vow_destroy_pledge_agent",
	"wh_dlc07_trait_brt_virtue_troth_destroy_pledge_fay",
	"wh_dlc07_trait_brt_virtue_troth_untaint_pledge_fay",
	"wh_dlc07_trait_brt_virtue_troth_valour_pledge_fay",
	"wh_dlc07_trait_brt_virtue_troth_destroy_pledge_agent",
	"wh_dlc07_trait_brt_virtue_troth_valour_pledge_agent",
	"wh_dlc07_trait_brt_virtue_troth_untaint_pledge_agent"
}

local vow_agents = {
	["wh_main_brt_paladin"] = true,
	["wh2_dlc14_brt_henri_le_massif"] = true,
	["wh_main_brt_damsel_heavens"] = true,
	["wh_dlc07_brt_damsel_beasts"] = true,
	["wh_dlc07_brt_damsel_life"] = true
}

local function is_female(character)
	return character:character_details():character_subtype_has_female_name() and not character:character_subtype("wh2_dlc14_brt_repanse")
end

function add_vow_progress(character, trait, ai, agents)
	if character:is_null_interface() then
		return false
	end
	
	local faction = character:faction()
	
	if not ai and not faction:is_human() then
		return false -- Make sure AI doesn't get Vows when we don't want them to
	end
	
	local char_cqi = character:cqi()
	out.design("------------------------------------------------")
	out.design("add_vow_progress - " .. char_cqi .. " - " .. trait .. " - " .. tostring(ai) .. " - " .. tostring(agents))
	local max_trait_points = vow_max_points[trait] or 6
	out.design("\tMax Points - " .. max_trait_points)
	local incident = "wh_dlc07_incident_brt_vow_gained"
	local incident_uc = incident
	local trait_uc = trait
	
	if is_female(character) then
		out.design("\tFemale Character")
		trait = vow_to_troth[trait]
		out.design("\tTrait - " .. trait)
		incident = incident .. "_female"
		
		if trait:starts_with("wh_dlc07_trait_brt_virtue_troth") == true and character:character_subtype("wh_dlc07_brt_fay_enchantress") == true then
			trait = trait .. "_fay"
			out.design("\tFay Trait - " .. trait)
		end
	end
	
	local event_key = trait
	
	local faction_cqi = faction:command_queue_index()
	local points = character:trait_points(trait)
	out.design("\tPoints: " .. points)
	
	if (points > 0 or ai == true) and points < max_trait_points then
		out.design("\tAdding trait - " .. trait)
		cm:force_add_trait(cm:char_lookup_str(character), trait, false, 1)
		points = points + 1
		out.design("\tNew Points: " .. points)
		
		if points == max_trait_points and ai == false then
			out.design("\tTriggering event: " .. char_cqi)
			cm:trigger_incident_with_targets(faction_cqi, incident, 0, 0, char_cqi, 0, 0, 0)
			
			if event_key:starts_with("wh_dlc07_trait_brt_knights_vow") then 
				core:trigger_event("ScriptEventBretonniaKnightsVowCompleted", character)
			elseif event_key:starts_with("wh_dlc07_trait_brt_questing_vow") then
				core:trigger_event("ScriptEventBretonniaQuestingVowCompleted", character)
			elseif event_key:starts_with("wh_dlc07_trait_brt_grail_vow") then
				core:trigger_event("ScriptEventBretonniaGrailVowCompleted", character)
			elseif event_key:starts_with("wh_dlc07_trait_brt_virtue_troth") then
				core:trigger_event("ScriptEventBretonniaVirtueTrothCompleted", character) 
			end
		end
	end
	
	-- Do all heroes in this characters army
	if agents and character:has_military_force() then
		local force_characters = character:military_force():character_list()
		local force_character_count = force_characters:num_items()
		out.design("Checking agents (" .. force_character_count .. ")...")
		
		for i = 0, force_character_count - 1 do
			local current_char = force_characters:item_at(i)
			local subtype_key = current_char:character_subtype_key()
			if is_female(current_char) then
				trait = vow_to_troth[trait_uc] .. "_agent"
			else
				trait = trait_uc .. "_agent"
			end
			out.design("\t\tCharacter: " .. subtype_key)
			
			if vow_agents[subtype_key] then
				local agent_points = current_char:trait_points(trait)
				out.design("\t\t\tPoints: " .. agent_points)
				
				if (agent_points > 0 or ai == true) and agent_points < max_trait_points then
					out.design("\t\t\tAdding agent trait - " .. trait)
					char_cqi = current_char:command_queue_index()
					cm:force_add_trait(cm:char_lookup_str(current_char), trait, false, 1)
					agent_points = agent_points + 1
					out.design("\t\t\tNew Points: " .. agent_points)
					
					if agent_points == max_trait_points and ai == false then
						out.design("\t\t\tTriggering event: " .. char_cqi)
						cm:trigger_incident_with_targets(faction_cqi, incident_uc, 0, 0, char_cqi, 0, 0, 0)
					end
				end
			end
		end
	end
	out.design("------------------------------------------------")
end

function add_starting_vows()
	for i = 1, #starting_vows do
		local faction = cm:get_faction(starting_vows[i].faction)
		
		if faction and faction:has_faction_leader() then
			local faction_leader = cm:char_lookup_str(faction:faction_leader())
			local traits = starting_vows[i].traits
			
			for j = 1, #traits do
				for k = 1, traits[j].points do
					cm:force_add_trait(faction_leader, traits[j].key, false)
				end
			end
		end
	end
end

--This will return true even if the pledge is not completed
local function ai_has_vow(character,possible_pledges)
	for i = 1, #possible_pledges do
		if character:has_trait(possible_pledges[i]) then 
			return true
		end
	end  
	return false
end

-- AI characters get the Vows per level
core:add_listener(
	"character_rank_up_vows_per_level_ai",
	"CharacterRankUp",
	true,
	function(context)
		local character = context:character()
		local faction = character:faction()
		
		if not faction:is_human() and faction:culture() == "wh_main_brt_bretonnia" and character:character_type("general") then
			local rank = character:rank()
			
			if rank >= 2 and not ai_has_vow(character, all_knights_vows) then
				for i = 1, 6 do
					add_vow_progress(character, "wh_dlc07_trait_brt_knights_vow_knowledge_pledge", true, false)
				end
			elseif rank >= 5 and not ai_has_vow(character, all_questing_vows) then
				for i = 1, 6 do
					add_vow_progress(character, "wh_dlc07_trait_brt_questing_vow_protect_pledge", true, false)
				end
			elseif rank >= 10 and not ai_has_vow(character, all_grail_vows) then
				for i = 1, 6 do
					add_vow_progress(character, "wh_dlc07_trait_brt_grail_vow_valour_pledge", true, false)
				end
			end
		elseif not faction:is_human() and faction:culture() == "wh_main_brt_bretonnia" and vow_agents[character:character_subtype_key()] then
			local rank = character:rank()
	
			if rank >= 2 and not ai_has_vow(character, all_knights_vows) then
				for i = 1, 6 do
					add_vow_progress(character, "wh_dlc07_trait_brt_knights_vow_knowledge_pledge_agent", true, false) 
				end
			elseif rank >= 5 and not ai_has_vow(character, all_questing_vows) then
				for i = 1, 6 do
					add_vow_progress(character, "wh_dlc07_trait_brt_questing_vow_protect_pledge_agent", true, false)
				end
			elseif rank >= 10 and not ai_has_vow(character, all_grail_vows) then
				for i = 1, 6 do
					add_vow_progress(character, "wh_dlc07_trait_brt_grail_vow_valour_pledge_agent", true, false)
				end
			end
		end
	end,
	true
)

-- Allows player to skip the early Vows at high enough Chivalry
core:add_listener(
	"Vow_CharacterCreated",
	"CharacterCreated",
	function(context)
		local character = context:character()
		return not context:has_respawned() and cm:char_is_general(character) and not character:is_wounded()
	end,
	function(context)
		local character = context:character()
		local faction = character:faction()
		
		if faction:is_human() and faction:culture() == "wh_main_brt_bretonnia" then
			local active_effect = faction:pooled_resource_manager():resource("brt_chivalry"):active_effect(0)
			
			if active_effect == "wh_dlc07_bretonnia_chivalry_bar_801_1000" then
				for i = 1, 6 do
					add_vow_progress(character, "wh_dlc07_trait_brt_knights_vow_knowledge_pledge", true, false)
					add_vow_progress(character, "wh_dlc07_trait_brt_questing_vow_protect_pledge", true, false)
				end
			elseif active_effect == "wh_dlc07_bretonnia_chivalry_bar_601_800" or active_effect == "wh_dlc07_bretonnia_chivalry_bar_401_600" then
				for i = 1, 6 do
					add_vow_progress(character, "wh_dlc07_trait_brt_knights_vow_knowledge_pledge", true, false)
				end
			end
		end
	end,
	true
)


-----------------------
----- KNIGHTS VOW -----
-----------------------

-- Pledge to Knowledge
core:add_listener(
	"research_completed_pledge_to_knowledge",
	"ResearchCompleted",
	function(context)
		local faction = context:faction()
		return faction:is_human() and faction:culture() == "wh_main_brt_bretonnia"
	end,
	function(context)
		local character_list = context:faction():character_list()
		
		for i = 0, character_list:num_items() - 1 do
			local current_char = character_list:item_at(i)
			
			if cm:char_is_general_with_army(current_char) then
				add_vow_progress(current_char, "wh_dlc07_trait_brt_knights_vow_knowledge_pledge", false, false)
			end
		end
	end,
	true
)

-- Pledge to Order
core:add_listener(
	"building_completed_pledge_to_knowledge",
	"BuildingCompleted",
	function(context)
		local faction = context:building():faction()
		return not faction:is_null_interface() and faction:is_human() and faction:culture() == "wh_main_brt_bretonnia"
	end,
	function(context)
		local building = context:building()
		local building_region = building:region():name()
		local characters = building:faction():character_list()
		
		for i = 0, characters:num_items() - 1 do
			local current_character = characters:item_at(i)
			
			if current_character:has_region() and current_character:region():name() == building_region then
				if vow_agents[current_character:character_subtype_key()] then
					add_vow_progress(current_character, "wh_dlc07_trait_brt_knights_vow_order_pledge_agent", false, false)
				else
					add_vow_progress(current_character, "wh_dlc07_trait_brt_knights_vow_order_pledge", false, false)
				end
			end
		end
	end,
	true
)

-- Pledge to Chivalry
core:add_listener(
	"character_rank_up_pledge_to_chivalry",
	"CharacterRankUp",
	function(context)
		local faction = context:character():faction()
		
		return faction:is_human() and faction:culture() == "wh_main_brt_bretonnia"
	end,
	function(context)
		local character = context:character()
		local ranks_gained = context:ranks_gained()
		
		if character:character_type("general") then
			for i = 1, ranks_gained do
				add_vow_progress(character, "wh_dlc07_trait_brt_knights_vow_chivalry_pledge", false, false)
			end
		elseif vow_agents[character:character_subtype_key()] then
			local trait = "wh_dlc07_trait_brt_knights_vow_chivalry_pledge_agent"
			
			if is_female(character) then
				trait = vow_to_troth[trait]
			end
			
			if character:trait_points(trait) > 0 then
				for i = 1, ranks_gained do
					cm:force_add_trait(cm:char_lookup_str(character), trait, false)
				end
			end
		end
	end,
	true
)

-- Pledge to Knowledge (Agent)
local function add_pledge_to_knowledge_trait(context)
	local character = context:character()
	local faction = character:faction()
	
	if faction:is_human() and faction:culture() == "wh_main_brt_bretonnia" and (context:mission_result_critial_success() or context:mission_result_success()) then
		local trait = "wh_dlc07_trait_brt_knights_vow_knowledge_pledge_agent"
		
		if is_female(character) then
			trait = vow_to_troth[trait]
		end
		
		if vow_agents[character:character_subtype_key()] and character:trait_points(trait) > 0 then
			cm:force_add_trait(cm:char_lookup_str(character), trait, false)
		end
	end
end

core:add_listener(
	"character_character_target_action_pledge_to_knowledge",
	"CharacterCharacterTargetAction",
	function(context)
		return context:ability() ~= "assist_army"
	end,
	function(context)
		add_pledge_to_knowledge_trait(context)
	end,
	true
)

core:add_listener(
	"character_garrison_target_action_pledge_to_knowledge",
	"CharacterGarrisonTargetAction",
	true,
	function(context)
		add_pledge_to_knowledge_trait(context)
	end,
	true
)

------------------------
----- QUESTING VOW -----
------------------------

-- Pledge to Campaign
core:add_listener(
	"character_completed_battle_pledge_to_campaign",
	"BattleCompleted",
	function(context)
		local pb = context:model():pending_battle()
		
		return pb:battle_type() == "settlement_standard" and cm:pending_battle_cache_attacker_victory() and cm:pending_battle_cache_human_is_attacker() and cm:pending_battle_cache_culture_is_attacker("wh_main_brt_bretonnia")
	end,
	function()
		for i = 1, cm:pending_battle_cache_num_attackers() do
			local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(i)

			local character = cm:get_character_by_cqi(attacker_char_cqi)
			local faction = cm:get_faction(attacker_faction_name)

			if character and faction and faction:is_human() and faction:culture() == "wh_main_brt_bretonnia" and character:has_region() then
				local climate = character:region():settlement():get_climate()
				
				if climate == "climate_desert" or climate == "climate_jungle" then
					add_vow_progress(character, "wh_dlc07_trait_brt_questing_vow_campaign_pledge", false, true)
				end
			end
		end
	end,
	true
)

-- Pledge to Manann
core:add_listener(
	"character_completed_battle_pledge_to_heroism",
	"CharacterCompletedBattle",
	function(context)
		local character = context:character()
		if character:won_battle() and character:is_at_sea() then
			local faction = character:faction()
			return faction:is_human() and faction:culture() == "wh_main_brt_bretonnia"
		end
	end,
	function(context)
		add_vow_progress(context:character(), "wh_dlc07_trait_brt_questing_vow_heroism_pledge", false, true)
	end,
	true
)

---------------------
----- GRAIL VOW -----
---------------------

-- Pledge to Valour
-- Pledge to Protect
-- Pledge to Untaint
core:add_listener(
	"character_completed_battle_grail_vow",
	"BattleCompleted",
	true,
	function()
		if cm:pending_battle_cache_attacker_victory() then
			for i = 1, cm:pending_battle_cache_num_attackers() do
				local attacker_fm = cm:get_family_member_by_cqi(cm:pending_battle_cache_get_attacker_fm_cqi(i))
				
				if attacker_fm then
					-- Check the family member has a character interface, as a non-legendary reinforcing character can both win and die
					local attacker_character = attacker_fm:character()
					if not attacker_character:is_null_interface() and attacker_character:faction():culture() == "wh_main_brt_bretonnia" then
						add_vow_progress(attacker_character, "wh_dlc07_trait_brt_grail_vow_valour_pledge", false, true)

						for j = 1, cm:pending_battle_cache_num_defenders() do
							local defender_character_details = cm:get_family_member_by_cqi(cm:pending_battle_cache_get_defender_fm_cqi(j)):character_details()
							
							if not defender_character_details:is_null_interface() and defender_character_details:is_unique() then
								local defeated_character_vow = vow_legendary_lord_cultures[defender_character_details:faction():culture()]
								
								if defeated_character_vow ~= nil then
									add_vow_progress(attacker_character, defeated_character_vow, false, true)
								end
							end
						end
					end
				end
			end
		elseif cm:pending_battle_cache_defender_victory() then
			for i = 1, cm:pending_battle_cache_num_defenders() do
				local defender_fm = cm:get_family_member_by_cqi(cm:pending_battle_cache_get_defender_fm_cqi(i))
				
				if defender_fm then
					-- Check the family member has a character interface, as a non-legendary reinforcing character can both win and die
					local defender_character = defender_fm:character()
					if not defender_character:is_null_interface() and defender_character:faction():culture() == "wh_main_brt_bretonnia" then
						add_vow_progress(defender_character, "wh_dlc07_trait_brt_grail_vow_valour_pledge", false, true)

						for j = 1, cm:pending_battle_cache_num_attackers() do
							local attacker_character_details = cm:get_family_member_by_cqi(cm:pending_battle_cache_get_attacker_fm_cqi(j)):character_details()
							
							if not attacker_character_details:is_null_interface() and attacker_character_details:is_unique() then
								local defeated_character_vow = vow_legendary_lord_cultures[attacker_character_details:faction():culture()]
								
								if defeated_character_vow ~= nil then
									add_vow_progress(defender_character, defeated_character_vow, false, true)
								end
							end
						end
					end
				end
			end
		end
	end,
	true
)

-- Pledge to Destroy
core:add_listener(
	"character_razed_setlement_pledge_to_destroy",
	"CharacterRazedSettlement",
	true,
	function(context)
		local character = context:character()
		local faction = character:faction()
		
		if faction:is_human() and faction:culture() == "wh_main_brt_bretonnia" and context:garrison_residence():region():is_province_capital() then
			add_vow_progress(character, "wh_dlc07_trait_brt_grail_vow_destroy_pledge", false, true)
		end
	end,
	true
)