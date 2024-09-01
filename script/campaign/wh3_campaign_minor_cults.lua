MINOR_CULT_LIST = {
	{key = "mc_order_of_vaul", cult = nil},
	{key = "mc_cult_of_painted_skin", cult = nil},
	{key = "mc_silver_pinnacle", cult = nil},
	{key = "mc_order_sacred_scythe", cult = nil},
	{key = "mc_dwarf_miners", cult = nil},
	{key = "mc_black_ark", cult = nil},
	{key = "mc_cult_of_haendryk", cult = nil},
	{key = "mc_cult_of_illumination", cult = nil},
	{key = "mc_cult_of_ulric", cult = nil},
	{key = "mc_cult_of_myrmidia", cult = nil},
	{key = "mc_cult_of_ranald", cult = nil},
	{key = "mc_cult_of_yellow_fang", cult = nil},
	{key = "mc_cult_of_exquisite_cadaver", cult = nil},
	{key = "mc_tilean_traders", cult = nil},
	{key = "mc_witch_hunters", cult = nil},
	{key = "mc_cult_of_shallya", cult = nil},
	{key = "mc_dwarf_rangers", cult = nil},
	{key = "mc_grail_knight_grave", cult = nil},
	{key = "mc_assassins", cult = nil},
	{key = "mc_cult_of_possessed", cult = nil},
};

local MINOR_CULT_REGIONS = {};
local spawn_cult_per_turn_chance = 10;
local spawn_cult_event_per_turn_chance = 20;
local quicker_event_triggers = false;
local cult_last_turn = false;

function add_minor_cults_listeners()
	out("#### Adding Minor Cults Listeners ####");
	for i = 1, #MINOR_CULT_LIST do
		out("\tMinor Cult "..i.." : "..MINOR_CULT_LIST[i].key);
		MINOR_CULT_LIST[i].cult.key = MINOR_CULT_LIST[i].key;
	end

	local minor_cult = cm:model():world():faction_by_key("wh3_main_rogue_minor_cults");

	if minor_cult:is_null_interface() == false then -- If the faction isn't in the startpos it's likely an old save and we can't use the feature
		cm:force_diplomacy("faction:wh3_main_rogue_minor_cults", "all", "all", false, false, true);
		local cults = minor_cult:foreign_slot_managers();

		for cult_index = 0, cults:num_items() - 1 do
			local cult = cults:item_at(cult_index);
			local region = cult:region();
			cm:foreign_slot_set_reveal_to_faction(region:owning_faction(), cult);
		end
		
		-- Each turn we get all non-triggered minor cults into a table, shuffle the table, iterate through and trigger the first valid one
		core:add_listener(
			"MinorCults_WorldStartRound",
			"WorldStartRound",
			true,
			function(context)
				local turn_number = cm:turn_number();
				local cult_created_this_turn = false;
				local event_triggered_this_turn = false;
				local skip_event_turn = true;

				if (cult_last_turn == false) or quicker_event_triggers == true then -- This avoid any chance of spawning/events one turn after another
					out("MINOR CULTS - WorldStartRound - "..turn_number);

					if cm:model():random_percent(spawn_cult_per_turn_chance) then
						cm:shuffle_table(MINOR_CULT_LIST);

						for i = 1, #MINOR_CULT_LIST do
							if MINOR_CULT_LIST[i].cult.saved_data.active == false then
								local region_key = MINOR_CULT_LIST[i].cult:is_valid(MINOR_CULT_REGIONS);

								if region_key ~= nil then
									local log = spawn_minor_cult(region_key, i);

									if MINOR_CULT_LIST[i].cult.event_data ~= nil then
										MINOR_CULT_LIST[i].cult.saved_data.event_cooldown = MINOR_CULT_LIST[i].cult.event_data.event_initial_delay;
									end
									
									MINOR_CULT_REGIONS[region_key] = MINOR_CULT_LIST[i].key;
									cult_created_this_turn = true;
									cult_last_turn = true;
									out("\t"..MINOR_CULT_LIST[i].key .. " - VALID - "..log);
									break;
								else
									out("\t"..MINOR_CULT_LIST[i].key .. " - INVALID");
								end
							else
								out("\t"..MINOR_CULT_LIST[i].key .. " - Already Active");
							end
						end
					else
						out("\tFailed Spawn Cult Chance ("..spawn_cult_per_turn_chance.."%)");
					end
				else
					out("\tFailed Cult Spawned Last Turn");
					cult_last_turn = false;
				end
					
				if cm:model():random_percent(spawn_cult_event_per_turn_chance) then
					skip_event_turn = false;
				else
					out("\tFailed Spawn Cult Event Chance ("..spawn_cult_event_per_turn_chance.."%)");
				end

				cm:shuffle_table(MINOR_CULT_LIST);

				for i = 1, #MINOR_CULT_LIST do
					out("MINOR CULT - Event - "..MINOR_CULT_LIST[i].key);
					out("\tCult Active - "..tostring(MINOR_CULT_LIST[i].cult.saved_data.active));
					if MINOR_CULT_LIST[i].cult.saved_data.active == true then
						if MINOR_CULT_LIST[i].cult.event_data ~= nil then
							out("\tEvent Limit - "..MINOR_CULT_LIST[i].cult.saved_data.event_triggers.."/"..MINOR_CULT_LIST[i].cult.event_data.event_limit);

							if MINOR_CULT_LIST[i].cult.saved_data.event_triggers < MINOR_CULT_LIST[i].cult.event_data.event_limit then
								out("\tEvent Cooldown - "..MINOR_CULT_LIST[i].cult.saved_data.event_cooldown);
								
								if MINOR_CULT_LIST[i].cult.saved_data.event_cooldown > 0 then
									MINOR_CULT_LIST[i].cult.saved_data.event_cooldown = MINOR_CULT_LIST[i].cult.saved_data.event_cooldown - 1;
								else
									local should_trigger = cm:model():random_percent(MINOR_CULT_LIST[i].cult.event_data.event_chance_per_turn);

									if should_trigger == true then
										local triggered = false;
										local region = cm:model():world():region_manager():region_by_key(MINOR_CULT_LIST[i].cult.saved_data.region_key);

										if region:is_null_interface() == false then
											local region_cqi = region:cqi();
											local faction = region:owning_faction();
											local faction_cqi = faction:command_queue_index();

											if MINOR_CULT_LIST[i].key == "mc_dwarf_miners" and event_triggered_this_turn == false and skip_event_turn == false then
												-- Dwarf Mining Company
												cm:trigger_dilemma_with_targets(faction_cqi, "wh3_main_minor_cult_earthquake", 0, 0, 0, 0, region_cqi, 0);
												triggered = true;
												
											elseif MINOR_CULT_LIST[i].key == "mc_cult_of_haendryk" and event_triggered_this_turn == false and skip_event_turn == false then
												-- Cult of Haendryk
												if faction:net_income() >= 500 then
													-- We're going to ask for half the players gross income over 11 turns as payment
													-- The loan amount given will be 10 turns worth of this rounded up
													local loan_turn_term = 11;
													local loan_turn_worth = 10;
													local loan_round_to_nearest = 100;

													local background_income = 3000;
													local trade_value = faction:trade_value();
													local real_income = faction:income() - trade_value - background_income;
													out("income - "..faction:income());
													out("real_income - "..real_income);

													local loan_amount = loan_round_to_nearest * math.ceil((real_income * loan_turn_worth) / loan_round_to_nearest);
													out("loan_amount - "..loan_amount);

													if loan_amount < 4000 then
														loan_amount = 4000;
													end

													-- CUSTOM DILEMMA
													local dilemma_builder = cm:create_dilemma_builder("wh3_main_minor_cult_loan");
													local payload_builder = cm:create_payload();

													local loan_effect_bundle = cm:create_new_custom_effect_bundle("wh3_main_minor_cult_loan");
													loan_effect_bundle:add_effect("wh_main_effect_economy_gdp_mod_all", "faction_to_region_own", -100);
													loan_effect_bundle:add_effect("wh2_main_effect_agent_action_passive_boost_income_effect_negative", "faction_to_region_own", -1000);
													loan_effect_bundle:add_effect("wh_main_effect_economy_trade_tariff_mod", "faction_to_faction_own", -100);
													loan_effect_bundle:set_duration(loan_turn_term);

													payload_builder:treasury_adjustment(loan_amount);
													payload_builder:effect_bundle_to_faction(loan_effect_bundle);
													dilemma_builder:add_choice_payload("FIRST", payload_builder);
													payload_builder:clear();

													payload_builder:text_display("dummy_do_nothing");
													dilemma_builder:add_choice_payload("SECOND", payload_builder);
													payload_builder:clear();

													cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
													triggered = true;
												end

											elseif MINOR_CULT_LIST[i].key == "mc_cult_of_yellow_fang" then
												-- Cult of the Yellow Fang
												local skaven_corruption = cm:get_corruption_value_in_region(region, "wh3_main_corruption_skaven");

												if skaven_corruption >= 100 then
													cm:trigger_incident_with_targets(faction_cqi, "wh3_main_minor_cult_skaven", 0, 0, 0, 0, region_cqi, 0);
													-- Remove the Cult after this event
													local cult_cqi = cm:model():world():faction_by_key("wh3_main_rogue_minor_cults"):command_queue_index();
													cm:remove_faction_foreign_slots_from_region(cult_cqi, region_cqi);
													triggered = true;
												end

											elseif MINOR_CULT_LIST[i].key == "mc_cult_of_exquisite_cadaver" and event_triggered_this_turn == false and skip_event_turn == false then
												-- Cult of the Exquisite Cadaver
												cm:trigger_incident_with_targets(faction_cqi, "wh3_main_minor_cult_wine", 0, 0, 0, 0, region_cqi, 0);
												triggered = true;

											elseif MINOR_CULT_LIST[i].key == "mc_tilean_traders" and event_triggered_this_turn == false and skip_event_turn == false then
												-- Tilean Trading Company
												cm:trigger_dilemma_with_targets(faction_cqi, "wh3_main_minor_cult_settlement_sale", 0, 0, 0, 0, region_cqi, 0);
												triggered = true;
											end

											if triggered == true then
												event_triggered_this_turn = true;
												MINOR_CULT_LIST[i].cult.saved_data.event_cooldown = MINOR_CULT_LIST[i].cult.event_data.event_cooldown;
												MINOR_CULT_LIST[i].cult.saved_data.event_triggers = MINOR_CULT_LIST[i].cult.saved_data.event_triggers + 1;
											end
										else
											out("\tRegion was null interface?");
										end
									end
								end
							end
						end
					end
				end
			end,
			true
		);
		
		core:add_listener(
			"MinorCults_ForeignSlotManagerRemovedEvent",
			"ForeignSlotManagerRemovedEvent",
			function(context)
				return context:owner():name() == "wh3_main_rogue_minor_cults";
			end,
			function(context)
				local owner_key = context:owner():name();
				local remover = context:remover();
				local region = context:region();
				local region_key = region:name();

				if MINOR_CULT_REGIONS[region_key] ~= nil then
					local cult_key = MINOR_CULT_REGIONS[region_key];

					for i = 1, #MINOR_CULT_LIST do
						if MINOR_CULT_LIST[i].key == cult_key then

							if cult_key == "mc_black_ark" then
								local char_list = remover:character_list();

								for j = 0, char_list:num_items() - 1 do
									local character = char_list:item_at(j);
									
									if character:has_region() and character:region():name() == region_key then
										cm:add_agent_experience(cm:char_lookup_str(character), 5000, false);
									end
								end
							elseif cult_key == "mc_cult_of_myrmidia" then
								cm:trigger_incident_with_targets(remover:command_queue_index(), "wh3_main_minor_cult_myrmidia", 0, 0, 0, 0, region:cqi(), 0);
							end
							
							if MINOR_CULT_LIST[i].cult.effect_bundle ~= nil then
								cm:remove_effect_bundle_from_region(MINOR_CULT_LIST[i].cult.effect_bundle, region_key);
							end
							if MINOR_CULT_LIST[i].cult.event_data ~= nil then
								MINOR_CULT_LIST[i].cult.saved_data.event_triggers = MINOR_CULT_LIST[i].cult.event_data.event_limit;
							end
							break;
						end
					end
				end
			end,
			true
		);

		core:add_listener(
			"MinorCults_DilemmaChoiceMadeEvent",
			"DilemmaChoiceMadeEvent",
			true,
			function(context)
				if context:dilemma() == "wh3_main_minor_cult_settlement_sale" then
					for i = 1, #MINOR_CULT_LIST do
						if MINOR_CULT_LIST[i].key == "mc_tilean_traders" then
							if context:choice() == 0 then
								-- Transfer region to Tilea
								cm:transfer_region_to_faction(MINOR_CULT_LIST[i].cult.saved_data.region_key, "wh_main_teb_tilea")
							end
							break;
						end
					end
				elseif context:dilemma() == "wh3_main_minor_cult_earthquake" then
					for i = 1, #MINOR_CULT_LIST do
						if MINOR_CULT_LIST[i].key == "mc_dwarf_miners" then
							if context:choice() == 1 then
								-- Remove Dwarfs
								local region = cm:get_region(MINOR_CULT_LIST[i].cult.saved_data.region_key);
								local faction = cm:model():world():faction_by_key(MINOR_CULT_LIST[i].cult.faction_key);
								cm:remove_faction_foreign_slots_from_region(faction:command_queue_index(), region:cqi());
							end
							break;
						end
					end
				end
			end,
			true
		);

		core:add_listener(
			"MinorCults_CharacterTurnStart",
			"CharacterTurnStart",
			true,
			function(context)
				local character = context:character();

				if character:has_ancillary("wh3_main_anc_enchanted_item_dreamwine") == false then
					-- Start trying to remove the trait
					if character:has_trait("wh3_trait_dreamwine") then
						if cm:model():random_percent(10) then
							cm:force_remove_trait("character_cqi:"..character:command_queue_index(),"wh3_trait_dreamwine");
						end
					end
				else
					-- Give the trait when wine is equipped
					if cm:model():random_percent(5) then
						campaign_traits:give_trait(character, "wh3_trait_dreamwine", 1, 100);
					end
				end

				if character:has_region() == true then
					local region = character:region();
					local fsm = region:foreign_slot_manager_for_faction("wh3_main_rogue_minor_cults");

					if fsm:is_null_interface() == false then
						local chance = 5;
						
						if character:in_settlement() then
							chance = 20;
						end

						if cm:model():random_percent(chance) then
							local slot_list = fsm:slots();
							
							for i = 0, slot_list:num_items() - 1 do
								local slot = slot_list:item_at(i);

								if slot:is_null_interface() == false and slot:has_building() == true then
									if slot:building() == "wh3_main_minor_cult_grail_knight_grave_1" then
										if region:public_order() >= 75 then
											if character:faction():subculture() ~= "wh_main_sc_brt_bretonnia" then
												campaign_traits:give_trait(character, "wh3_trait_blessing_of_the_lady", 1, 100);
											end
										end
										break;
									elseif slot:building() == "wh3_main_minor_cult_assassins_hideout_1" then
										campaign_traits:give_trait(character, "wh3_trait_assassins_training", 1, 100);
										break;
									end
								end
							end
						end
					end
				end
			end,
			true
		);
		
		core:add_listener(
			"MinorCults_RegionTurnStart",
			"RegionTurnStart",
			true,
			function(context)
				local region = context:region();

				if region:is_null_interface() == false and region:is_abandoned() == false then
					local fsm = region:foreign_slot_manager_for_faction("wh3_main_rogue_minor_cults");
					local has_illumination_cult = false;
					local has_order_of_vaul = false;

					if fsm:is_null_interface() == false then
						local slot_list = fsm:slots();
						
						for i = 0, slot_list:num_items() - 1 do
							local slot = slot_list:item_at(i);

							if slot:is_null_interface() == false and slot:has_building() == true then
								if slot:building() == "wh3_main_minor_cult_illumination_1" then
									has_illumination_cult = true;
								elseif slot:building() == "wh3_main_minor_cult_order_vaul_1" then
									has_order_of_vaul = true;
								end
							end
						end
					end

					if has_order_of_vaul == true then
						-- This buildings effect has a 20% chance of occuring
						if cm:model():random_percent(20) then 
							if region:public_order() >= 0 then
								local region_owner = region:owning_faction();
								local region_owner_key = region_owner:name();
								local ancillary_key = get_random_ancillary_key_for_faction(region_owner_key, false, false);
								out("Giving ancillary to ["..region_owner_key.."] from Order of Vaul - "..ancillary_key);
								cm:add_ancillary_to_faction(region_owner, ancillary_key, false);
							end
						end
					end
					
					if has_illumination_cult == true then
						-- This buildings effect has a 10% chance of occuring
						if cm:model():random_percent(10) then 
							local elector_factions = {
								"wh_main_emp_empire",
								"wh_main_emp_averland",
								"wh_main_emp_hochland",
								"wh_main_emp_middenland",
								"wh_main_emp_nordland",
								"wh_main_emp_ostermark",
								"wh_main_emp_ostland",
								"wh_main_emp_stirland",
								"wh_main_emp_talabecland",
								"wh_main_emp_wissenland"
							};
							cm:shuffle_table(elector_factions);

							for i = 1, #elector_factions do
								local elector = cm:model():world():faction_by_key(elector_factions[i]);

								if elector:is_null_interface() == false and elector:is_human() == false then
									if elector:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
										cm:faction_add_pooled_resource(elector_factions[i], "emp_loyalty", "buildings", 1);
										out("Illumination Cult giving "..elector_factions[i].." +1 Fealty");
										break;
									end
								end
							end
						end
					end
				end
			end,
			true
		);

		core:add_listener(
			"MinorCults_RegionFactionChangeEvent",
			"RegionFactionChangeEvent",
			true,
			function(context)
				local region = context:region();
				local region_key = region:name();
				
				for i = 1, #MINOR_CULT_LIST do
					if MINOR_CULT_LIST[i].cult.saved_data.active == true then
						if MINOR_CULT_LIST[i].cult.saved_data.region_key == region_key then
							local faction = cm:model():world():faction_by_key(MINOR_CULT_LIST[i].cult.faction_key);
							cm:remove_faction_foreign_slots_from_region(faction:command_queue_index(), region:cqi());
							if MINOR_CULT_LIST[i].cult.event_data ~= nil then
								MINOR_CULT_LIST[i].cult.saved_data.event_triggers = MINOR_CULT_LIST[i].cult.event_data.event_limit;
							end
							out("Minor Cult: Removing "..MINOR_CULT_LIST[i].key.." from "..region_key);
							break;
						end
					end
				end
			end,
			true
		);
	end
end

function spawn_minor_cult(region_key, cult_index)
	local region = cm:get_region(region_key);
	local mcf = cm:model():world():faction_by_key(MINOR_CULT_LIST[cult_index].cult.faction_key);
	cm:add_foreign_slot_set_to_region_for_faction(mcf:command_queue_index(), region:cqi(), MINOR_CULT_LIST[cult_index].cult.slot_key);

	local slot_manager = region:foreign_slot_manager_for_faction(MINOR_CULT_LIST[cult_index].cult.faction_key);
	cm:foreign_slot_set_reveal_to_faction(region:owning_faction(), slot_manager);

	if MINOR_CULT_LIST[cult_index].cult.effect_bundle ~= nil then
		cm:apply_effect_bundle_to_region(MINOR_CULT_LIST[cult_index].cult.effect_bundle, region_key, 0);
	end

	MINOR_CULT_LIST[cult_index].cult.saved_data.active = true;
	MINOR_CULT_LIST[cult_index].cult.saved_data.region_key = region_key;
	
	local faction_cqi = region:owning_faction():command_queue_index();
	cm:trigger_incident_with_targets(faction_cqi, MINOR_CULT_LIST[cult_index].cult.intro_incident_key, 0, 0, 0, 0, region:cqi(), 0);
	return MINOR_CULT_LIST[cult_index].cult.key.." - "..MINOR_CULT_LIST[cult_index].cult.slot_key.." - "..region_key;
end

function debug_minor_cult_events()
	local human_factions = cm:get_human_factions()
				
	for i = 1, #human_factions do
		local emp = cm:model():world():faction_by_key(human_factions[i]);
		local emp_region_cqi = cm:get_region("wh3_main_combi_region_altdorf"):cqi();

		cm:trigger_incident_with_targets(emp:command_queue_index(), "wh3_main_minor_cult_intro", 0, 0, 0, 0, emp_region_cqi, 0);
		cm:trigger_incident_with_targets(emp:command_queue_index(), "wh3_main_minor_cult_myrmidia", 0, 0, 0, 0, emp_region_cqi, 0);
		cm:trigger_incident_with_targets(emp:command_queue_index(), "wh3_main_minor_cult_skaven", 0, 0, 0, 0, emp_region_cqi, 0);
		cm:trigger_incident_with_targets(emp:command_queue_index(), "wh3_main_minor_cult_wine", 0, 0, 0, 0, emp_region_cqi, 0);

		cm:trigger_dilemma_with_targets(emp:command_queue_index(), "wh3_main_minor_cult_earthquake", 0, 0, 0, 0, emp_region_cqi, 0);
		cm:trigger_dilemma_with_targets(emp:command_queue_index(), "wh3_main_minor_cult_loan", 0, 0, 0, 0, emp_region_cqi, 0);
		cm:trigger_dilemma_with_targets(emp:command_queue_index(), "wh3_main_minor_cult_settlement_sale", 0, 0, 0, 0, emp_region_cqi, 0);
	end
end

function debug_create_cult(key)
	for i = 1, #MINOR_CULT_LIST do
		if MINOR_CULT_LIST[i].key == key then
			local valid_from_turn = MINOR_CULT_LIST[i].cult.valid_from_turn;
			local chance_if_valid = MINOR_CULT_LIST[i].cult.chance_if_valid;

			MINOR_CULT_LIST[i].cult.valid_from_turn = 0;
			MINOR_CULT_LIST[i].cult.chance_if_valid = 100;

			if MINOR_CULT_LIST[i].cult.saved_data.active == false then
				local region_key = MINOR_CULT_LIST[i].cult:is_valid(MINOR_CULT_REGIONS);

				if region_key ~= nil then
					local log = spawn_minor_cult(region_key, i);
					MINOR_CULT_REGIONS[region_key] = MINOR_CULT_LIST[i].key;
					out("\t"..MINOR_CULT_LIST[i].key .. " - VALID - "..log);
					cult_created_this_turn = true;
					break;
				else
					out("\t"..MINOR_CULT_LIST[i].key .. " - INVALID");
				end
			else
				out("\t"..MINOR_CULT_LIST[i].key .. " - Already Active");
			end

			MINOR_CULT_LIST[i].cult.valid_from_turn = valid_from_turn;
			MINOR_CULT_LIST[i].cult.chance_if_valid = chance_if_valid;
			break;
		end
	end
end

function debug_max_cult_chance()
	spawn_cult_per_turn_chance = 100;
	spawn_cult_event_per_turn_chance = 100;
	quicker_event_triggers = true;
end

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("MINOR_CULT_REGIONS", MINOR_CULT_REGIONS, context);

		for i = 1, #MINOR_CULT_LIST do
			cm:save_named_value("MinorCult_"..MINOR_CULT_LIST[i].key, MINOR_CULT_LIST[i].cult.saved_data, context);
		end
	end
);

cm:add_loading_game_callback(
	function(context)
		MINOR_CULT_REGIONS = cm:load_named_value("MINOR_CULT_REGIONS", MINOR_CULT_REGIONS, context);

		for i = 1, #MINOR_CULT_LIST do
			MINOR_CULT_LIST[i].cult.saved_data = cm:load_named_value("MinorCult_"..MINOR_CULT_LIST[i].key, MINOR_CULT_LIST[i].cult.saved_data, context);
		end
	end
);