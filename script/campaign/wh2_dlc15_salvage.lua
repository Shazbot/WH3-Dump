salvage = {
	greenskin_subculture = "wh_main_sc_grn_greenskins",
	ai_cooldown = 10, -- This defines the interval (in turns) for AI unit upgrades
	bonus_scrap_tech = { -- Tech for bonus scrap/turn (player only)
		key = "tech_grn_final_1_1",
		value = 10,
		resource = "grn_salvage",
		factor = "technology",
	},
	faction_exclusive_available = { -- Factions which have a faction specific upgrade
		"wh2_dlc15_grn_bonerattlaz", 
		"wh_main_grn_crooked_moon", 
		"wh_main_grn_greenskins", 
		"wh_main_grn_orcs_of_the_bloody_hand"
	},
	faction_exclusive_upgrade_index = { -- Faction key to unique upgrade junctions
		wh2_dlc15_grn_bonerattlaz = "wh2_dlc15_grn_upgrade_sorcery_weapon",
		wh_main_grn_crooked_moon = "wh2_dlc15_grn_upgrade_fungus_flask",
		wh_main_grn_greenskins = "wh2_dlc15_grn_upgrade_immortual_armour",
		wh_main_grn_orcs_of_the_bloody_hand = "wh2_dlc15_grn_upgrade_idol_of_gork"
	},
	tech_keys = { -- List of techs which unlock salvage upgrades
		"tech_grn_end_1_1",
		"tech_grn_end_2_2",
		"tech_grn_end_3_3",
		"tech_grn_end_4_2",
		"tech_grn_end_5_1",
		"tech_grn_extra_1_1",
		"tech_grn_extra_1_2",
		"tech_grn_extra_1_3",
		"tech_grn_extra_1_4",
		"tech_grn_extra_3_1",
		"tech_grn_extra_3_2",
		"tech_grn_extra_3_3",
		"tech_grn_extra_3_4"
	},
	tech_keys_to_unit_upgrades = { -- Tech key to upgrade junctions
		tech_grn_end_1_1 = {
			"wh2_dlc15_grn_upgrade_combat_ammobag_artillery",
			"wh2_dlc15_grn_upgrade_winged_ammo_artillery"
		},
		tech_grn_end_2_2 = {
			"wh2_dlc15_grn_upgrade_reinforced_weapon_troll",
			"wh2_dlc15_grn_upgrade_water_flask_troll"
		},
		tech_grn_end_3_3 = {
			"wh2_dlc15_grn_upgrade_piercing_weapon_arachnarok",
			"wh2_dlc15_grn_upgrade_restraints_arachnarok"
		},
		tech_grn_end_4_2 = {
			"wh2_dlc15_grn_upgrade_jagged_weapon_giant_idol",
			"wh2_dlc15_grn_upgrade_stone_armour_giant_idol"
		},
		tech_grn_end_5_1 = {
			"wh2_dlc15_grn_upgrade_blinders_squig",
			"wh2_dlc15_grn_upgrade_jagged_weapon_black_orc",
			"wh2_dlc15_grn_upgrade_jagged_weapon_squig",
			"wh2_dlc15_grn_upgrade_piercing_weapon_black_orc",
			"wh2_dlc15_grn_upgrade_restraints_squig",
			"wh2_dlc15_grn_upgrade_scrap_saddles_squig"
		},
		tech_grn_extra_1_1 = {
			"wh2_dlc15_grn_upgrade_blinders_pump_wagon",
			"wh2_dlc15_grn_upgrade_chariot_armour_pump_wagon",
			"wh2_dlc15_grn_upgrade_jagged_weapon_pump_wagon",
			"wh2_dlc15_grn_upgrade_piercing_weapon_pump_wagon",
			"wh2_dlc15_grn_upgrade_enlarged_ammobag_goblin",
			"wh2_dlc15_grn_upgrade_heavy_ammo_goblin",
			"wh2_dlc15_grn_upgrade_jagged_weapon_goblin",
			"wh2_dlc15_grn_upgrade_scrap_armour_goblin",
			"wh2_dlc15_grn_upgrade_spiked_weapon_goblin",
			"wh2_dlc15_grn_upgrade_water_flask_goblin"
		},
		tech_grn_extra_1_2 = {
			"wh2_dlc15_grn_upgrade_blinders_wolf_rider",
			"wh2_dlc15_grn_upgrade_chariot_armour_wolf_rider",
			"wh2_dlc15_grn_upgrade_combat_ammobag_wolf_rider",
			"wh2_dlc15_grn_upgrade_jagged_weapon_wolf_rider",
			"wh2_dlc15_grn_upgrade_scrap_saddles_wolf_rider"
		},
		tech_grn_extra_1_3 = {
			"wh2_dlc15_grn_upgrade_combat_ammobag_spider_rider",
			"wh2_dlc15_grn_upgrade_jagged_weapon_spider_rider",
			"wh2_dlc15_grn_upgrade_scrap_saddles_spider_rider"
		},
		tech_grn_extra_1_4 = {
			"wh2_dlc15_grn_upgrade_combat_ammobag_night_goblin",
			"wh2_dlc15_grn_upgrade_liquor_flask_night_goblin",
			"wh2_dlc15_grn_upgrade_spiked_weapon_night_goblin",
			"wh2_dlc15_grn_upgrade_winged_ammo_night_goblin"
		},
		tech_grn_extra_3_1 = {
			"wh2_dlc15_grn_upgrade_combat_ammobag_orc",
			"wh2_dlc15_grn_upgrade_padded_shield_orc",
			"wh2_dlc15_grn_upgrade_reinforced_weapon_orc",
			"wh2_dlc15_grn_upgrade_scrap_armour_orc"
		},
		tech_grn_extra_3_2 = {
			"wh2_dlc15_grn_upgrade_blinders_orc_cav",
			"wh2_dlc15_grn_upgrade_chariot_armour_orc_cav",
			"wh2_dlc15_grn_upgrade_piercing_weapon_orc_cav",
			"wh2_dlc15_grn_upgrade_reinforced_weapon_orc_cav",
			"wh2_dlc15_grn_upgrade_scrap_saddles_orc_cav"
		},
		tech_grn_extra_3_3 = {
			"wh2_dlc15_grn_upgrade_combat_ammobag_salvage_orc",
			"wh2_dlc15_grn_upgrade_liquor_flask_salvage_orc",
			"wh2_dlc15_grn_upgrade_piercing_weapon_salvage_orc"
		},
		tech_grn_extra_3_4 = {
			"wh2_dlc15_grn_upgrade_piercing_weapon_salvage_orc_cav",
			"wh2_dlc15_grn_upgrade_reinforced_weapon_salvage_orc_cav",
			"wh2_dlc15_grn_upgrade_scrap_saddles_salvage_orc_cav"
		}
	}
}

-- Called on campaign start/load
function salvage:initialise()
	out("#### wh2_dlc15_salvage: Adding Listeners ####");

	if cm:is_new_game() then
		self:new_game_setup()
	end
	
	-- Unlocks upgrades for humans as they unlock the appropriate techs
	core:add_listener(
		"listener_salvage_unit_upgrade_tech",
		"ResearchCompleted",
		function(context)
			return context:faction():is_human() and context:faction():subculture() == self.greenskin_subculture;
		end,
		function(context)
			local tech = context:technology();
			if self.tech_keys_to_unit_upgrades[tech] then
				for i = 1 , #self.tech_keys_to_unit_upgrades[tech] do
					local tech_key = self.tech_keys_to_unit_upgrades[tech][i]
					cm:faction_set_unit_purchasable_effect_lock_state(context:faction(), tech_key, tech_key, false);
				end
			end
		end,
		true
	);
	
	-- Handle bonus scrap for humans from tech, and automatic upgrades for AI
	cm:add_faction_turn_start_listener_by_subculture(
		"listener_greenskin_salvage_turn_start",
		self.greenskin_subculture,
		function(context)
			local faction = context:faction()

			-- Add extra salvage for humies if the required tech is unlocked
			local key = self.bonus_scrap_tech.key
			if faction:is_human() and faction:has_technology(key) then
				local resource = self.bonus_scrap_tech.resource
				local factor = self.bonus_scrap_tech.factor
				local value = self.bonus_scrap_tech.value
				cm:faction_add_pooled_resource(faction:name(), resource, factor, value);
			end

			-- Automatically Upgrade AI Units at set intervals as they don't have scrap
			if not faction:is_human() then
				self:upgrade_ai_units(faction)
			end
		end,
		true
	);
end

--Locks everything at beginning of campaign
function salvage:new_game_setup()

	local faction_list = cm:model():world():faction_list();
	for i = 0, faction_list:num_items() - 1 do

		local faction = faction_list:item_at(i);
		if faction:subculture() == self.greenskin_subculture then

			-- Lock faction specific upgrades for both AI and humans
			for i = 1, #self.faction_exclusive_available do
				if faction:name() ~= self.faction_exclusive_available[i] then
					local tech_key = self.faction_exclusive_upgrade_index[self.faction_exclusive_available[i]]
					cm:faction_set_unit_purchasable_effect_lock_state(faction, tech_key, "", true);
				end
			end

			-- Lock tech-specific upgrades for humans
			if faction:is_human() then
				for i = 1, #self.tech_keys do
					for j = 1, #self.tech_keys_to_unit_upgrades[self.tech_keys[i]] do
						local tech_key = self.tech_keys_to_unit_upgrades[self.tech_keys[i]][j]
						cm:faction_set_unit_purchasable_effect_lock_state(faction, tech_key, tech_key, true);
					end
				end
			end

		end
	end
end

-- Automatically Upgrade AI Units at set intervals
function salvage:upgrade_ai_units(faction)
	local turn = cm:model():turn_number();
	if turn % self.ai_cooldown == 0 then 

		local grn_force_list = faction:military_force_list();
		for i = 0, grn_force_list:num_items() - 1 do

			local grn_force = grn_force_list:item_at(i);
			local unit_list = grn_force:unit_list();

			for j = 0, unit_list:num_items() - 1 do

				local unit_interface = unit_list:item_at(j);
				local unit_purchasable_effect_list = unit_interface:get_unit_purchasable_effects();

				if unit_purchasable_effect_list:num_items() ~=0 then

					local rand = cm:random_number(unit_purchasable_effect_list:num_items()) -1;
					effect_interface = unit_purchasable_effect_list:item_at(rand);
					
					if grn_force:is_armed_citizenry() == false then
						-- We've got a valid unit and upgrade combo, so upgrade the unit
						cm:faction_purchase_unit_effect(faction, unit_interface, effect_interface);
					end	
				end	
			end
		end
	end
end