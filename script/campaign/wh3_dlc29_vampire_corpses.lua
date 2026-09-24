vampire_corpses = {
	corpse_resource_key = "wh3_dlc29_vmp_corpses",
	power_resource_key = "wh3_dlc29_vmp_power",
	standard_corpse_conversion_rate = 1,
	capital_province_corpse_start_amount = 500,
	capital_province_corpses_per_turn = 200,
	province_ritual_corpses = {ritual = "wh3_main_ritual_vmp_power_corpses", amount = 3000},
	unit_resources = {
		["wh3_dlc29_vmp_cav_drakenhof_templars"] = "shyish",
		["wh3_dlc29_vmp_inf_lahmian_handmaidens_death"] = "shyish",
		["wh3_dlc29_vmp_inf_lahmian_handmaidens_shadow"] = "shyish",
		["wh3_dlc29_vmp_inf_spirit_host"] = "shyish",
		["wh3_dlc29_vmp_mon_zombie_dragon"] = "shyish",
		["wh3_dlc29_vmp_veh_coven_throne"] = "shyish",
		["wh3_main_vmp_blood_knights_sword_shield"] = "shyish",
		["wh_dlc02_vmp_cav_blood_knights_0"] = "shyish",
		["wh_dlc04_vmp_veh_mortis_engine_0"] = "shyish",
		["wh_main_vmp_cav_hexwraiths"] = "shyish",
		["wh_main_vmp_inf_cairn_wraiths"] = "shyish",
		["wh_main_vmp_mon_terrorgheist"] = "shyish",
		["wh_main_vmp_mon_vargheists"] = "shyish",
		["wh_main_vmp_mon_varghulf"] = "shyish",
		["wh_main_vmp_veh_black_coach"] = "shyish",
		["wh2_dlc11_cst_mon_mournguls_0"] = "corpses",
		["wh_dlc04_vmp_veh_corpse_cart_0"] = "corpses",
		["wh_dlc04_vmp_veh_corpse_cart_1"] = "corpses",
		["wh_dlc04_vmp_veh_corpse_cart_2"] = "corpses",
		["wh_main_vmp_cav_black_knights_0"] = "corpses",
		["wh_main_vmp_cav_black_knights_3"] = "corpses",
		["wh_main_vmp_inf_crypt_ghouls"] = "corpses",
		["wh_main_vmp_inf_grave_guard_0"] = "corpses",
		["wh_main_vmp_inf_grave_guard_1"] = "corpses",
		["wh3_main_vmp_inf_grave_guard_2"] = "corpses",
		["wh_main_vmp_inf_skeleton_warriors_0"] = "corpses",
		["wh_main_vmp_inf_skeleton_warriors_1"] = "corpses",
		["wh_main_vmp_inf_zombie"] = "corpses",
		["wh_main_vmp_mon_crypt_horrors"] = "corpses",
		["wh_main_vmp_mon_dire_wolves"] = "corpses",
		["wh_main_vmp_mon_fell_bats"] = "corpses"
	},
	unit_cost_overrides = {
		["wh_main_vmp_inf_skeleton_warriors_0"] = 400,
		["wh_main_vmp_inf_skeleton_warriors_1"] = 400,
		["wh_main_vmp_mon_fell_bats"] = 450,
		["wh_dlc04_vmp_veh_corpse_cart_0"] = 500,
		["wh_main_vmp_inf_grave_guard_0"] = 1450,
		["wh_main_vmp_inf_grave_guard_1"] = 1450,
		["wh3_main_vmp_inf_grave_guard_2"] = 1450,
		["wh3_dlc29_vmp_inf_lahmian_handmaidens_death"] = 520,
		["wh3_dlc29_vmp_inf_lahmian_handmaidens_shadow"] = 520,
		-- Tomb Kings Units
		["wh2_dlc09_tmb_inf_tomb_guard_0"] = 250,
		["wh2_dlc09_tmb_inf_tomb_guard_1"] = 300,
		["wh2_dlc09_tmb_mon_ushabti_0"] = 360,
		["wh2_dlc09_tmb_mon_tomb_scorpion_0"] = 400,
		["wh2_dlc09_tmb_mon_sepulchral_stalkers_0"] = 480,
		["wh2_dlc09_tmb_mon_necrosphinx_0"] = 800
	},
	refund_tech_corpses = "wh3_main_tech_vmp_necromancers_misc_7",
	refund_tech_shyish = "wh3_main_tech_vmp_vampires_main_4",
	captive_battle_data = {}
};

function vampire_corpses:initialise()
	-- Add starting amount of Corpses to all Vampire factions starting provinces
	local vampire_factions = cm:get_factions_by_subculture("wh_main_sc_vmp_vampire_counts");

	for _, faction in ipairs(vampire_factions) do
		if faction:has_home_region() == true then
			local home_province = faction:home_region():province();
			local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, home_province);

			if pooled_resource_manager:is_null_interface() == false then
				local pooled_resource = pooled_resource_manager:resource(self.corpse_resource_key);

				if pooled_resource:is_null_interface() == false then
					cm:pooled_resource_factor_transaction(pooled_resource, "hidden", self.capital_province_corpse_start_amount);
				end
			end
		end
	end

	self:add_listeners();
end

function vampire_corpses:add_listeners()
	core:add_listener(
		"CharacterSkillPointAllocatedCorpses",
		"CharacterSkillPointAllocated",
		true,
		function(context)
			local character = context:character();
			local faction = character:faction();

			if faction:culture() == "wh_main_vmp_vampire_counts" then
				self:update_corpse_transport_loss(faction);
			end
		end,
		true
	);
	core:add_listener(
		"CharacterConvalescedOrKilledCorpses",
		"CharacterConvalescedOrKilled",
		true,
		function(context)
			local character = context:character();
			local faction = character:faction();

			if faction:culture() == "wh_main_vmp_vampire_counts" then
				self:update_corpse_transport_loss(faction);
			end
		end,
		true
	);
	core:add_listener(
		"ResearchCompletedCorpses",
		"ResearchCompleted",
		true,
		function(context)
			local faction = context:faction();

			if faction:culture() == "wh_main_vmp_vampire_counts" then
				self:update_corpse_transport_loss(faction);
			end
		end,
		true
	);
	core:add_listener(
		"RitualCompletedEventBloodlinesEffects",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == self.province_ritual_corpses.ritual;
		end,
		function(context)
			local region = context:ritual_target_region();
			
			if region:is_null_interface() == false then
				local faction = context:performing_faction();
				local province = region:province();
				local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, province);

				if pooled_resource_manager:is_null_interface() == false then
					local pooled_resource = pooled_resource_manager:resource(self.corpse_resource_key);

					if pooled_resource:is_null_interface() == false then
						cm:pooled_resource_factor_transaction(pooled_resource, "vmp_provincial_actions", self.province_ritual_corpses.amount);
					end
				end
			end
		end,
		true
	);
	core:add_listener(
		"FactionTurnStartCorpses",
		"FactionTurnStart",
		function(context)
			return context:faction():culture() == "wh_main_vmp_vampire_counts";
		end,
		function(context)
			local faction = context:faction();

			if faction:has_home_region() == true then
				local home_province = faction:home_region():province();
				local home_province_key = home_province:key();
				local province_list = faction:provinces();
				local faction_power = faction:pooled_resource_manager():resource(self.power_resource_key);
				local capital_coprse_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, home_province);
				local capital_corpses = capital_coprse_manager:resource(self.corpse_resource_key);
				
				local transport_target_corpses = nil;
				local transport_target_region = self:get_corpse_transport_region(faction);

				if transport_target_region then
					local transport_target_corpses_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, transport_target_region:province());
					transport_target_corpses = transport_target_corpses_manager:resource(self.corpse_resource_key);
				end

				if cm:is_new_game() == false then
					-- This is the innate background Corpse gain for your faction capital
					cm:pooled_resource_factor_transaction(capital_corpses, "technology", self.capital_province_corpses_per_turn);
				end
				
				for i = 0, province_list:num_items() - 1 do
					local province_manager = province_list:item_at(i);
					local province = province_manager:province();

					local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, province);
					local corpse_resource = pooled_resource_manager:resource(self.corpse_resource_key);
					
					-- Priority order: Convert locally, convert all, transport
					local corpse_conversion = province_manager:bonus_values():scripted_value("corpse_conversion", "value");
					local corpse_conversion_all = province_manager:bonus_values():scripted_value("corpse_conversion_all", "value");
					local corpse_transport = province_manager:bonus_values():scripted_value("corpse_transport", "value");

					if corpse_conversion > 0 then
						local corpse_amount = corpse_resource:value();

						if corpse_amount > 0 then
							local converted_amount = math.min(corpse_conversion, corpse_amount);
							cm:pooled_resource_factor_transaction(corpse_resource, "vmp_corpse_converted", -converted_amount);

							-- Apply the conversion rate and give the converted resource
							converted_amount = (converted_amount * self.standard_corpse_conversion_rate);
							cm:pooled_resource_factor_transaction(faction_power, "vmp_power_converted", converted_amount);
						end
					end
					
					if corpse_conversion_all > 0 then
						local corpse_amount = corpse_resource:value();
						
						if corpse_amount >= corpse_conversion_all then
							cm:pooled_resource_factor_transaction(corpse_resource, "vmp_corpse_converted", -corpse_conversion_all);

							-- Apply the conversion rate of 50% and give the converted resource
							local converted_amount = corpse_conversion_all * 0.5;
							cm:pooled_resource_factor_transaction(faction_power, "vmp_power_converted", converted_amount);
						end
					end
					
					if corpse_transport > 0 then
						local corpse_amount = corpse_resource:value();

						if corpse_amount >= corpse_transport then
							local corpse_transport_loss = province_manager:bonus_values():scripted_value("corpse_transport_loss", "value");
							local transport_loss_ratio = corpse_transport_loss / 100;
							local transport_losses = corpse_transport * transport_loss_ratio;
							local transported_amount = corpse_transport - transport_losses;

							if transport_target_corpses and province:key() ~= transport_target_region:province_name() then
								-- Send the Corpses to the location of the Mortis Nexus
								cm:pooled_resource_factor_transaction(corpse_resource, "vmp_corpse_transported_out", -transported_amount);
								cm:pooled_resource_factor_transaction(corpse_resource, "vmp_corpse_transported_out_lost", -transport_losses);
								cm:pooled_resource_factor_transaction(transport_target_corpses, "vmp_corpse_transported_in", transported_amount);
							elseif province:key() ~= home_province_key then
								-- Backup - Send to the capital, as long as this isn't the capital province
								cm:pooled_resource_factor_transaction(corpse_resource, "vmp_corpse_transported_out", -transported_amount);
								cm:pooled_resource_factor_transaction(corpse_resource, "vmp_corpse_transported_out_lost", -transport_losses);
								cm:pooled_resource_factor_transaction(capital_corpses, "vmp_corpse_transported_in", transported_amount);
							end
						end
					end
				end

				local foreign_slot_managers = faction:foreign_slot_managers();

				for fsm_index = 0, foreign_slot_managers:num_items() - 1 do
					local foreign_slot_manager = foreign_slot_managers:item_at(fsm_index);
					local region = foreign_slot_manager:region();

					if region:is_province_capital() == true then -- This check is for Covens, which can only be in province capitals
						local province = region:province();
						local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, province);
						local corpse_resource = pooled_resource_manager:resource(self.corpse_resource_key);
						local corpse_conversion = cm:get_regions_bonus_value(region, "corpse_conversion");

						if corpse_conversion > 0 then
							local corpse_amount = corpse_resource:value();

							if corpse_amount > 0 then
								local converted_amount = math.min(corpse_conversion, corpse_amount);
								cm:pooled_resource_factor_transaction(corpse_resource, "vmp_corpse_converted", -converted_amount);
								
								converted_amount = (converted_amount * self.standard_corpse_conversion_rate);
								cm:pooled_resource_factor_transaction(faction_power, "vmp_power_converted", converted_amount);
							end
						end
					end
				end
			end
		end,
		true
	);
	core:add_listener(
		"RegionTurnStartVampiricClimate",
		"RegionTurnStart",
		true,
		function(context)
			local region = context:region();
			
			if cm:is_new_game() == false then
				self:update_region_corpses(region);
			end
			self:update_region_climate(region);
		end,
		true
	);
	core:add_listener(
		"BuildingCompletedVampiricClimate",
		"BuildingCompleted",
		function(context)
			return context:building():name() == "wh_main_VAMPIRES_climate_1";
		end,
		function(context)
			local region = context:garrison_residence():region();
			local province_regions = region:province():regions();

			for i = 0, province_regions:num_items() - 1 do
				local province_region = province_regions:item_at(i);
				self:update_region_climate(province_region);
			end
		end,
		true
	);
	core:add_listener(
		"BuildingDemolishedVampiricClimate",
		"BuildingDemolished", 
		function(context)
			return context:building():name() == "wh_main_VAMPIRES_climate_1";
		end,
		function(context)
			local region = context:garrison_residence():region();
			local province_regions = region:province():regions();

			for i = 0, province_regions:num_items() - 1 do
				local province_region = province_regions:item_at(i);
				self:update_region_climate(province_region, true);
			end
		end,
		true
	);
	core:add_listener(
		"CharacterRazedSettlementVampiricClimate",
		"CharacterRazedSettlement",
		true,
		function(context)
			local region = context:garrison_residence():region();
			local province_regions = region:province():regions();

			for i = 0, province_regions:num_items() - 1 do
				local province_region = province_regions:item_at(i);
				self:update_region_climate(province_region);
			end
		end,
		true
	);
	core:add_listener(
		"UnitDisbandedCorpses",
		"UnitDisbanded",
		function(context)
			local unit = context:unit();
			local unit_key = unit:unit_key();
			local force = unit:military_force();

			if force:has_garrison_residence() == true and force:garrison_residence():is_under_siege() == true then
				-- Forces under siege never get refunds to avoid the exploit where armies about to die should optimally just disband everything
				return false;
			end

			if unit:has_force_commander() == false then
				return false;
			end

			local faction = unit:force_commander():faction();
			return faction:is_human() == true and faction:culture() == "wh_main_vmp_vampire_counts" and self.unit_resources[unit_key];
		end,
		function(context)
			local unit = context:unit();
			local unit_key = unit:unit_key();
			local force_commander = unit:force_commander();
			local faction = force_commander:faction();
			local resource_key = "";
			
			-- This tech gives Shyish refunds
			if self.unit_resources[unit_key] == "shyish" and faction:has_technology(self.refund_tech_shyish) then
				resource_key = "shyish";
			-- This tech gives Corpse refunds
			elseif self.unit_resources[unit_key] == "corpses" and faction:has_technology(self.refund_tech_corpses) then
				resource_key = "corpses";
			-- If neither of the above this is likely a gold cost unit
			else
				return false;
			end

			local force = context:unit():military_force();

			if force:is_null_interface() == false then
				local gold_cost = unit:get_unit_custom_battle_cost();
				local corpses = vampire_corpses_distribution:unit_corpse_cost(gold_cost);

				if resource_key == "shyish" then
					-- The Shyish cost of a unit is its corpse cost divided by 4
					corpses = corpses / 4;
				end

				if self.unit_cost_overrides[unit_key] then
					corpses = self.unit_cost_overrides[unit_key];
				end

				local max_refund = cm:get_factions_bonus_value(faction, "vampire_refund_max");

				if max_refund == nil or max_refund == 0 then
					max_refund = 80;
				end

				local unit_health = unit:percentage_proportion_of_full_strength();
				unit_health = math.min(unit_health / 100, max_refund / 100);
				corpses = corpses * unit_health;
				corpses = math.ceil(corpses);
				corpses = math.max(corpses, 5);

				if resource_key == "shyish" then
					local faction_key = faction:name();
					cm:faction_add_pooled_resource(faction_key, "wh3_dlc29_vmp_power", "vmp_units_disbanded", corpses);
				elseif resource_key == "corpses" then
					-- Corpses are refudned to the province in which this force is currently located
					if force_commander:has_region() == true then
						local province = force_commander:region():province();
						local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, province);

						if pooled_resource_manager:is_null_interface() == false then
							local pooled_resource = pooled_resource_manager:resource("wh3_dlc29_vmp_corpses");

							if pooled_resource:is_null_interface() == false then
								cm:pooled_resource_factor_transaction(pooled_resource, "vmp_units_disbanded", corpses);
							end
						end
					end
				end
			end
		end,
		true
	);
	core:add_listener(
		"ScriptEventHumanWinsBattleCorpsesCaptives",
		"ScriptEventHumanWinsBattle",
		function(context)
			return context:faction():culture() == "wh_main_vmp_vampire_counts";
		end,
		function(context)
			local faction = context:faction();
			local pending_battle = context:pending_battle();
			local battle_data = {
				is_sea = false,
				province_key = false,
				force_cqi = 0
			};

			if pending_battle:is_null_interface() == false then
				local region_data = pending_battle:region_data();

				if region_data:is_null_interface() == false then
					battle_data.is_sea = region_data:is_sea();

					if battle_data.is_sea == false then
						local region = region_data:region();

						if region:is_null_interface() == false then
							battle_data.province_key = region:province():key();
						end
					end
				end

				local winning_character = false;

				if pending_battle:attacker_won() == true and pending_battle:has_attacker() == true then
					local attacker = pending_battle:attacker();

					if attacker:is_null_interface() == false and attacker:faction():name() == faction:name() then
						winning_character = attacker;
					end
				elseif pending_battle:defender_won() == true and pending_battle:has_defender() == true then
					local defender = pending_battle:defender();

					if defender:is_null_interface() == false and defender:faction():name() == faction:name() then
						winning_character = defender;
					end
				end

				if winning_character then
					if winning_character:has_military_force() == true then
						battle_data.force_cqi = winning_character:military_force():command_queue_index();
					end

					-- Fallback for sea encounters represented by an island battlefield.
					if winning_character:has_region() == false then
						battle_data.is_sea = true;
						battle_data.province_key = false;
					end
				end
			end
			self.captive_battle_data[faction:name()] = battle_data;
		end,
		true
	);
	core:add_listener(
		"PooledResourceChangedExecutedCaptivesCorpses",
		"PooledResourceChanged",
		function(context)
			local pooled_resource = context:resource();

			return pooled_resource:is_null_interface() == false
				and pooled_resource:key() == "wh3_dlc29_vmp_corpses_dummy"
				and context:has_faction() == true
				and context:amount() > 0;
		end,
		function(context)
			self:transfer_captive_corpses(context:faction(), context:resource(), context:amount());
		end,
		true
	);
end

core:add_listener(
	"SettlementSeenEventCorpses",
	"SettlementSeenEvent",
	function(context)
		return context:is_first_time() == true and context:faction():culture() == "wh_main_vmp_vampire_counts";
	end,
	function(context)
		local faction = context:faction();
		local province = context:settlement():region():province();
		cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, province);
	end,
	true
);

function vampire_corpses:get_corpse_transport_region(faction)
	local region_list = faction:region_list();

	for _, region in model_pairs(region_list) do
		if region:building_exists("wh_main_VAMPIRES_shyish_capital_1") then
			return region;
		end
	end
	return nil;
end

function vampire_corpses:update_corpse_transport_loss(faction)
	local intended_value = cm:get_factions_bonus_value(faction, "corpse_transport_loss_indicator") or 0;
	local transport_loss_resource = faction:pooled_resource_manager():resource("wh3_dlc29_vmp_corpse_transport");
	local current_value = transport_loss_resource:value();
	local new_value = intended_value - current_value;
	
	if new_value ~= 0 then
		local faction_key = faction:name();
		cm:faction_add_pooled_resource(faction_key, "wh3_dlc29_vmp_corpse_transport", "other", new_value);
	end
end

function vampire_corpses:update_region_corpses(region)
	local faction = region:owning_faction();
	local province = region:province();
	local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, province);
	local corpse_resource = pooled_resource_manager:resource(self.corpse_resource_key);

	local corpse_gain_bv = cm:get_regions_bonus_value(region, "corpse_building_gain");
	local corpse_loss_bv = cm:get_regions_bonus_value(region, "corpse_building_loss");
	local corpse_mod_bv = cm:get_regions_bonus_value(region, "corpse_multiplier_mod");

	local total_corpse_change = corpse_gain_bv - corpse_loss_bv;

	if total_corpse_change > 0 then
		local mod_value = 1 + (corpse_mod_bv / 100);
		total_corpse_change = total_corpse_change * mod_value;
		cm:pooled_resource_factor_transaction(corpse_resource, "vmp_buildings_positive", total_corpse_change);
	elseif total_corpse_change < 0 then
		cm:pooled_resource_factor_transaction(corpse_resource, "vmp_buildings_negative", total_corpse_change);
	end

	local corpse_gain_characters = cm:get_regions_bonus_value(region, "corpse_character_gain");

	if corpse_gain_characters > 0 then
		cm:pooled_resource_factor_transaction(corpse_resource, "characters", corpse_gain_characters);
	end
end

function vampire_corpses:update_region_climate(region, force_off)
	force_off = force_off or false;
	local convert_climate = cm:get_regions_bonus_value(region, "convert_climate_vampiric") or 0;
	
	if force_off == true then
		climate_change:remove_climate_override(region, "vampire_corpses")
		return false;
	elseif convert_climate > 0 then
		climate_change:add_climate_override(region, "vampire_corpses")
		return true;
	else
		climate_change:remove_climate_override(region, "vampire_corpses")
		return false;
	end
end

function vampire_corpses:transfer_captive_corpses(faction, dummy_resource, corpse_amount)
		if faction:is_null_interface() == true or dummy_resource:is_null_interface() == true or corpse_amount <= 0 then
			return false;
		end

		local battle_data = self.captive_battle_data[faction:name()];

		if not battle_data then
			out("[vampire_corpses_captives] No cached battle location for " .. faction:name());
			return false;
		end

		if battle_data.is_sea == true then
			cm:pooled_resource_factor_transaction(dummy_resource, "captives_killed", -corpse_amount);
			out("[vampire_corpses_captives] Cleared " .. corpse_amount .. " dummy Corpses after a sea battle");

			if faction:has_home_region() == true then
				-- Send the Corpses to the capital instead
				local home_province = faction:home_region():province();
				local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, home_province);

				if pooled_resource_manager:is_null_interface() == false then
					local pooled_resource = pooled_resource_manager:resource(self.corpse_resource_key);

					if pooled_resource:is_null_interface() == false then
						cm:pooled_resource_factor_transaction(pooled_resource, "captives_killed", corpse_amount);
					end
				end
			end
			return false;
		end

		if not battle_data.province_key then
			out("[vampire_corpses_captives] The cached land battle has no province key");
			return false;
		end

		local province = cm:get_province(battle_data.province_key);

		if not province or province:is_null_interface() == true then
			out("[vampire_corpses_captives] Could not retrieve province " .. battle_data.province_key);
			return false;
		end

		local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, province);

		if pooled_resource_manager:is_null_interface() == true then
			out("[vampire_corpses_captives] Could not create the persistent Corpses manager for " .. battle_data.province_key);
			return false;
		end

		local corpse_resource = pooled_resource_manager:resource(self.corpse_resource_key);

		if corpse_resource:is_null_interface() == true then
			out("[vampire_corpses_captives] The real Corpses resource is missing from " .. battle_data.province_key);
			return false;
		end

		cm:pooled_resource_factor_transaction(corpse_resource, "captives_killed", corpse_amount);
		cm:pooled_resource_factor_transaction(dummy_resource, "captives_killed", -corpse_amount);
		out("[vampire_corpses_captives] Transferred " .. corpse_amount .. " captive Corpses to " .. battle_data.province_key);
		return true;
	end