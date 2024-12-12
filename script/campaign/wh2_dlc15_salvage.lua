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
		"wh_main_grn_orcs_of_the_bloody_hand",
		"wh2_dlc15_grn_broken_axe",
		"wh3_dlc26_grn_gorbad_ironclaw"
	},
	faction_exclusive_upgrade_index = { -- Faction key to unique upgrade junctions
		wh2_dlc15_grn_bonerattlaz = "wh2_dlc15_grn_upgrade_sorcery_weapon",
		wh_main_grn_crooked_moon = "wh2_dlc15_grn_upgrade_fungus_flask",
		wh_main_grn_greenskins = "wh2_dlc15_grn_upgrade_immortual_armour",
		wh_main_grn_orcs_of_the_bloody_hand = "wh2_dlc15_grn_upgrade_idol_of_gork",
		wh2_dlc15_grn_broken_axe = "wh3_dlc26_grn_upgrade_less_lucky_banner",
		wh3_dlc26_grn_gorbad_ironclaw = "wh3_dlc26_grn_upgrade_big_banner_boyz"
	},
	tech_keys = { -- List of techs which unlock salvage upgrades
		"tech_grn_scrap_1",
		"tech_grn_scrap_2",
		"tech_grn_scrap_3",
		"tech_grn_scrap_4",
		"tech_grn_scrap_5",
		"tech_grn_scrap_6",
		"tech_grn_scrap_7",
		"tech_grn_scrap_8"
	},
	tech_keys_to_unit_upgrades = { -- Tech key to upgrade junctions
		tech_grn_scrap_1 = { -- Small Beasts
			"wh3_dlc26_grn_upgrade_shroom_powda",
			"wh3_dlc26_grn_upgrade_squig_spikes",
			"wh3_dlc26_grn_upgrade_mandibles"
		},	
		tech_grn_scrap_2 = { -- Goblin Weapons
			"wh2_dlc15_grn_upgrade_jagged_weapon",
			"wh3_dlc26_grn_upgrade_spikier_weapon",
			"wh2_dlc15_grn_upgrade_liquor_flask",
			"wh2_dlc15_grn_upgrade_water_flask"
		},
		tech_grn_scrap_3 = { -- Missiles
			"wh2_dlc15_grn_upgrade_heavy_ammo",
			"wh2_dlc15_grn_upgrade_combat_ammobag"
		},
		tech_grn_scrap_4 = { -- Orc Weapons
			"wh2_dlc15_grn_upgrade_reinforced_weapon",
			"wh2_dlc15_grn_upgrade_piercing_weapon",
			"wh2_dlc15_grn_upgrade_scrap_armour",
			"wh3_dlc26_grn_upgrade_bone_breastplates"
		},
		tech_grn_scrap_5 = { -- Artillery
			"wh3_dlc26_grn_upgrade_wing_suit",
			"wh3_dlc26_grn_upgrade_borrowed_bolts",
			"wh3_dlc26_grn_upgrade_bigga_rocks"
		},
		tech_grn_scrap_6 = { -- Chariot/Pumps
			"wh2_dlc15_grn_upgrade_chariot_armour",
			"wh3_dlc26_grn_upgrade_pump_plating"
		},
		tech_grn_scrap_7 = { -- Top tier weapons
			"wh3_dlc26_grn_upgrade_best_blades",
			"wh3_dlc26_grn_upgrade_sharpening_stones",
			"wh3_dlc26_grn_upgrade_biggest_stick"
		},
		tech_grn_scrap_8 = { -- Big Beasts
			"wh3_dlc26_grn_upgrade_big_squig_spikes",
			"wh3_dlc26_grn_upgrade_spiky_legs",
			"wh3_dlc26_grn_upgrade_spiky_claws",
			"wh3_dlc26_grn_upgrade_scrap_gauntlet",
			"wh3_dlc26_grn_upgrade_strapped_plates"
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
					local effect_key = self.tech_keys_to_unit_upgrades[tech][i]
					cm:faction_set_unit_purchasable_effect_lock_state(context:faction(), effect_key, tech, false);
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
					local effect_key = self.faction_exclusive_upgrade_index[self.faction_exclusive_available[i]]
					cm:faction_set_unit_purchasable_effect_lock_state(faction, effect_key, "grn_upgrade_faction_unique", true);
				end
			end

			-- Lock tech-specific upgrades for humans
			if faction:is_human() then
				for i = 1, #self.tech_keys do
					local tech_key = self.tech_keys[i]
					for j = 1, #self.tech_keys_to_unit_upgrades[tech_key] do
						local effect_key = self.tech_keys_to_unit_upgrades[tech_key][j]
						cm:faction_set_unit_purchasable_effect_lock_state(faction, effect_key, tech_key, true);
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