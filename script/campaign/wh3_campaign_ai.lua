-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
--	CAMPAIGN AI SCRIPT
--	This script contains a wide variety of functions which affect AI behaviour, which aren't specifically related to another script. Some are only active on the RoC map and some are only 
--  active on IE, while others are active on both maps, so please take care	that you are targetting the correct combination of maps when modifying this script. 
--
--  Handles the following parts of the CAI behaviour:
--  - Adjusting strategic threat based on the number of souls gathered
--  - Norsca VS Cathay bastion AI logic
--  - First Turn behaviour for AI major factions in the IE map
--  - Functions to improve chaos dwarf occupation logic
--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


campaign_ai_script = {
	script_triggered_settlement_attack = false,
	soul_threat_modifier = 100,

	chaos_bastion_related_factions_list = {
		"wh3_main_rogue_kurgan_warband",
		"wh3_main_cth_celestial_loyalists",
		"wh3_main_cth_imperial_wardens",
		"wh3_main_cth_the_jade_custodians",
		"wh3_main_cth_the_northern_provinces",
		"wh3_main_cth_the_western_provinces",
	},
	chaos_bastions_list = {
		"wh3_main_chaos_region_dragon_gate",
		"wh3_main_chaos_region_snake_gate",
		"wh3_main_chaos_region_turtle_gate",
	},
	soul_keys = {
		"wh3_main_realm_complete_khorne",
		"wh3_main_realm_complete_nurgle",
		"wh3_main_realm_complete_slaanesh",
		"wh3_main_realm_complete_tzeentch",
	},
	chaos_dwarf_primary_building_chain_keys = {
		outpost = "wh3_dlc23_chd_settlement_outpost",
		factory = "wh3_dlc23_chd_settlement_factory",
		tower = "wh3_dlc23_chd_settlement_tower",
	},
}

function campaign_ai_script:setup_listeners()
	
	-- ====================== COMBI ONLY LISTENERS ================ --
	if cm:model():campaign_name_key() == "wh3_main_combi" then
		core:add_listener(
			--Force the AI to embed its starting hero (if it has one) and then force it to attack the closest army, then give control back to the AI. 
			"AIGameStartHeroEmbed",
			"FactionBeginTurnPhaseNormal",
			function(context)
				--Skips the human factions
				faction = context:faction()
				if cm:turn_number() == 1 and faction:is_human() == false then 
					return faction:is_contained_in_faction_set("all_vanilla_playable_factions")
				else 
					return false
				end
			end,
			function(context)
				local faction = context:faction()
				cm:cai_set_global_script_context("cai_global_script_context_alpha")
				cm:cai_disable_movement_for_faction(faction:name())
				self:embed_starting_hero(faction)
				self:fight_starting_battles(faction)
				cm:cai_enable_movement_for_faction(faction:name())
			end, 
			true
		)

		core:add_listener(
			--When the AI attacks a settlement, force it immediately to launch the attack, unless we caused it to attack a settlement earlier.
			"AIGameStartForceSiegeAttack",
			"CharacterBesiegesSettlement",
			function(context)
				--Skips the human factions
				faction = context:character():faction()
				if cm:turn_number() == 1 and faction:is_human() == false then 
					return faction:is_contained_in_faction_set("all_vanilla_playable_factions")
				else 
					return false
				end
			end,
			function(context)
				if self.script_triggered_settlement_attack == false then
					char = context:character()
					cm:attack_region(cm:char_lookup_str(char), char:region():name())
				end
				self.script_triggered_settlement_attack = false
			end,
			true
		)

		core:add_listener(
			"AICleanUp", 
			"WorldStartRound", 
			function(context)
				if cm:turn_number() > 1 then
					return true
				end
			end,
			function(context)
				core:remove_listener("AIGameStartHeroEmbed")
				core:remove_listener("AIGameStartForceSiegeAttack")
				cm:cai_clear_global_script_context()
			end,
			false
		)
	end	

	-- ====================== CHAOS ONLY LISTENERS ================ --
	if cm:model():campaign_name_key() == "wh3_main_chaos" then
		out.design("Initial Bastion state check");
		if (self:count_standing_bastions() ~= (table.getn(self.chaos_bastions_list))) then
			out.design("============== Campaign started with at least razed Bastion settlement, switching related AI factions to appropriate context ==============")
			self:set_bastion_related_factions_to_context("cai_faction_script_context_special_2")
		end;
		
		out.design("===== CHAOS VS CATHAY BASTION SETUP =====");
		-- BASTION RAZED
		core:add_listener(
			"bastion_settlement_razed",
			"CharacterRazedSettlement",
			function(context)
				local region = context:garrison_residence():region();
				return ((region:name() == "wh3_main_chaos_region_dragon_gate") or (region:name() == "wh3_main_chaos_region_snake_gate") or (region:name() == "wh3_main_chaos_region_turtle_gate"))
			end,
			function(context)
				--If the Kurgan Warband is not already in "special_2" context, switch to it; Same with Cathay factions
				out.design("============== Bastion settlement razed script running ==============")
				local warband = cm:model():world():faction_by_key("wh3_main_rogue_kurgan_warband")
				if not (warband:is_null_interface()) then
					if not (cm:cai_get_faction_script_context("wh3_main_rogue_kurgan_warband") == "cai_faction_script_context_special_2") then
						--Kurgan Warband now switches to "free for all" mode, Cathay factions try to capture back the gates
						out.design("============== Bastion settlement was destroyed, related factions will now be set to cai_faction_script_context_special_2 context ==============")
						self:set_bastion_related_factions_to_context("cai_faction_script_context_special_2")
					end
				end
				
			end,
			true
		)
		
		-- BASTION COLONISED
		core:add_listener(
			"bastion_settlement_colonised",
			"CharacterPerformsSettlementOccupationDecision",
			function(context)
				local region = context:garrison_residence():region()
				local is_colonised = ((context:settlement_option() == "occupation_decision_colonise") or (context:settlement_option() == "occupation_decision_resettle"))
				local is_bastion = ((region:name() == "wh3_main_chaos_region_dragon_gate") or (region:name() == "wh3_main_chaos_region_snake_gate") or (region:name() == "wh3_main_chaos_region_turtle_gate"))
				return (is_colonised and is_bastion)
			end,
			function(context)
				out.design("============== Bastion settlement colonised script running ==============")
				if not ((cm:model():world():faction_by_key("wh3_main_rogue_kurgan_warband"):is_null_interface()) or (cm:cai_get_faction_script_context("wh3_main_rogue_kurgan_warband") == "cai_faction_script_context_type_default")) then
					-- Check number of "standing" gates, if it's N-1, then change the context back to default
					out.design("============== Bastion settlement was colonised, checking if all bastions are standing ==============")
					if (self:count_standing_bastions() == (table.getn(self.chaos_bastions_list))) then
						out.design("============== No more ruined gates, related factions will now be set to default faction context ==============")
						self:set_bastion_related_factions_to_context("cai_faction_script_context_type_default")
					end
				end
			end,
			true
		)
		
			-- FACTION TURN START - update threat score penalty for souls
		out.design("===== THREAT INCREASE FOR EACH SOUL SETUP =====")
		core:add_listener(
			"update_threat_score_for_souls",
			"FactionTurnStart",
			function(context)
				local faction = context:faction()
				return faction:can_be_human() -- this should filter for only major factions
			end,
			function(context)
				local faction = context:faction()
				local faction_name = faction:name()
				-- run a function that counts souls
				local soul_cnt = self:count_souls_for_faction(faction)
				if soul_cnt > 0 then
					-- set threat level modifier based on souls
					local modifier = soul_cnt * self.soul_threat_modifier
					out.design("============== Updated base threat score for faction: "..faction_name.." == "..modifier.."  ==============")
					cm:set_base_strategic_threat_score(faction, modifier)
				end
			end,
			true
		)
	end

	-- ====================== LISTENERS IN BOTH CAMPAIGNS ================ --
	core:add_listener(
		"update_chd_factory_outpost_ratio",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			if faction:subculture() == "wh3_dlc23_sc_chd_chaos_dwarfs" and faction:is_human() == false then
				return faction:can_be_human()
			end
		end,
		function(context)
			local faction = context:faction()
			self:calculate_and_set_chaos_dwarf_building_ratios(faction)
		end,
		true
	)
end

-- ================================= IE GAME START RELATED FUNCTIONS ================================= --
function campaign_ai_script:embed_starting_hero(faction)
	local list = faction:military_force_list()
	for i=0, list:num_items()-1 do
		local force = list:item_at(i)
		if force:is_armed_citizenry() == false and force:is_navy() == false then
			local general = force:general_character()
			local position_x = general:logical_position_x()
			local position_y = general:logical_position_y()

			local character, x = cm:get_closest_hero_to_position_from_faction(faction, position_x, position_y)
			if character and character:is_null_interface() == false and character:is_embedded_in_military_force() == false then
				cm:embed_agent_in_force(character, force)
			end
		end
	end
end

function campaign_ai_script:fight_starting_battles(faction)
	local list = faction:military_force_list()
	local enemy_faction_list = faction:factions_at_war_with() 

	for i=0, list:num_items()-1 do
		local force = list:item_at(i)
		if force:is_armed_citizenry() == false and force:is_navy() == false and force:has_garrison_residence() == false then
			local general = force:general_character()
			local char_lookup_str = cm:char_lookup_str(general)
			local position_x = general:logical_position_x()
			local position_y = general:logical_position_y()

			local enemy_force, in_range = self:find_correct_enemy_force(force, enemy_faction_list, position_x, position_y)
			if in_range == false then --If no enemy army is in range this turn then we break and allow the AI to get on with the rest of its turn 
				break
			end
			cm:attack_queued(char_lookup_str, cm:char_lookup_str(enemy_force:general_character()))
			out.design("Our force " .. common.get_localised_string(general:get_forename()) .. " is attacking an enemy army led by ".. common.get_localised_string(enemy_force:general_character():get_forename()))
		end
	end
end

function campaign_ai_script:find_correct_enemy_force(our_force, enemy_faction_list, x, y)
	for i=0, enemy_faction_list:num_items()-1 do
		enemy_force = cm:get_closest_military_force_from_faction(enemy_faction_list:item_at(i):name(), x, y, true)
		if enemy_force:is_armed_citizenry() == false then
			if cm:character_can_reach_character(our_force:general_character(), enemy_force:general_character()) == true then
				if enemy_force:has_garrison_residence() == true then
					self.script_triggered_settlement_attack = true
				end
				return enemy_force, true
			end
		elseif enemy_force:is_armed_citizenry() == true then
			if cm:character_can_reach_settlement(our_force:general_character(), enemy_force:garrison_residence():settlement_interface()) == true then
				self.script_triggered_settlement_attack = true
				return enemy_force, true
			end
		end
	end
	return enemy_force, false
end

-- ================================= BASTION RELATED FUNCTIONS ================================= --
function campaign_ai_script:count_standing_bastions()
	local cnt = 0
	for i, v in pairs(self.chaos_bastions_list) do
		-- Get region by name, check if it's not a ruin
		local region = cm:model():world():region_manager():region_by_key(v)
		if (region:is_null_interface()) then
			if (region:is_abandoned()) then 
				out.design("Region: "..region:name().." ABANDONED")
			else 
				out.design("Region: "..region:name().." NOT abandoned")
			end;
			
			if (region:is_abandoned() == false) then
				cnt = cnt+1
			end
		end
	end
	
	return cnt
end

function campaign_ai_script:set_bastion_related_factions_to_context(target_context)
	for i, v in pairs(self.chaos_bastion_related_factions_list) do
		cm:cai_set_faction_script_context(v, target_context)
		out.design("============== This faction: "..v.." is now using this context: "..cm:cai_get_faction_script_context(v).." ==============")
	end
end

-- ================================= SOULS RELATED FUNCTIONS ================================= --
function campaign_ai_script:count_souls_for_faction(faction)
	local cnt = 0

	for i = 1, #self.soul_keys do 
		if faction:pooled_resource_manager():resource(self.soul_keys[i]):is_null_interface() and faction:pooled_resource_manager():resource(self.soul_keys[i]) == 1 then
			cnt = cnt+1
		end
	end

	return cnt
end

-- ================================= CHAOS DWARF OCCUPATION RELATED FUNCTIONS ================================= --
function campaign_ai_script:calculate_and_set_chaos_dwarf_building_ratios(faction)
	local factory_count = 0
	local outpost_count = 0
	local tower_count = 0
	local region_list = faction:region_list()

	for i=0, region_list:num_items()-1 do
		local building = region_list:item_at(i):settlement():primary_building_chain()
		if building == self.chaos_dwarf_primary_building_chain_keys.factory then
			factory_count = factory_count + 1
		elseif building == self.chaos_dwarf_primary_building_chain_keys.outpost then
			outpost_count = outpost_count + 1
		elseif building == self.chaos_dwarf_primary_building_chain_keys.tower then
			tower_count = tower_count + 1
		end
	end

	local other_count = factory_count + outpost_count

	if outpost_count == 0 then
		outpost_ratio = 0
	elseif factory_count == 0 then
		outpost_ratio = 10
	else 
		outpost_ratio = outpost_count/factory_count
	end

	if tower_count == 0 then
		tower_ratio = 0.01
	elseif other_count == 0 then
		tower_ratio = 10
	else
		tower_ratio = tower_count/other_count
	end

	outpost_ratio = outpost_ratio - 1.5 --It takes 1.5 outposts to fuel each factory, so we get a negative number if we need outposts and a positive number if we need factories, which we can use in DAVE to get the acutal occupation weights
	tower_ratio = 1/tower_ratio

	cm:set_script_state(faction, "faction_chaos_dwarf_outpost_ratio", outpost_ratio)
	cm:set_script_state(faction, "faction_chaos_dwarf_tower_ratio", tower_ratio)
end
