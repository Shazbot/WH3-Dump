local vampire_coast_ships = {
	["wh2_dlc11_cst_harkon"] = {
		["wh2_dlc11_vampirecoast_ship_captains_cabin_1"] = "wh2_dlc11_art_set_cst_harkon_1",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_2"] = "wh2_dlc11_art_set_cst_harkon_1",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_3"] = "wh2_dlc11_art_set_cst_harkon_2",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_4"] = "wh2_dlc11_art_set_cst_harkon_3",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_5"] = "wh2_dlc11_art_set_cst_harkon_4"
	},
	["wh2_dlc11_cst_noctilus"] = {
		["wh2_dlc11_vampirecoast_ship_captains_cabin_1"] = "wh2_dlc11_art_set_cst_noctilus_1",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_2"] = "wh2_dlc11_art_set_cst_noctilus_1",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_3"] = "wh2_dlc11_art_set_cst_noctilus_2",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_4"] = "wh2_dlc11_art_set_cst_noctilus_3",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_5"] = "wh2_dlc11_art_set_cst_noctilus_4"
	},
	["wh2_dlc11_cst_aranessa"] = {
		["wh2_dlc11_vampirecoast_ship_captains_cabin_1"] = "wh2_dlc11_art_set_cst_aranessa_1",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_2"] = "wh2_dlc11_art_set_cst_aranessa_1",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_3"] = "wh2_dlc11_art_set_cst_aranessa_2",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_4"] = "wh2_dlc11_art_set_cst_aranessa_3",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_5"] = "wh2_dlc11_art_set_cst_aranessa_4"
	},
	["wh2_dlc11_cst_cylostra"] = {
		["wh2_dlc11_vampirecoast_ship_captains_cabin_1"] = "wh2_dlc11_art_set_cst_cylostra_1",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_2"] = "wh2_dlc11_art_set_cst_cylostra_1",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_3"] = "wh2_dlc11_art_set_cst_cylostra_2",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_4"] = "wh2_dlc11_art_set_cst_cylostra_3",
		["wh2_dlc11_vampirecoast_ship_captains_cabin_5"] = "wh2_dlc11_art_set_cst_cylostra_4"
	},
	["wh2_main_def_black_ark"] = {
		["wh2_main_horde_def_settlement_1"] = "wh2_main_art_set_def_black_ark_lokhir_1",
		["wh2_main_horde_def_settlement_2"] = "wh2_main_art_set_def_black_ark_lokhir_1",
		["wh2_main_horde_def_settlement_3"] = "wh2_main_art_set_def_black_ark_lokhir_2",
		["wh2_main_horde_def_settlement_4"] = "wh2_main_art_set_def_black_ark_lokhir_2",
		["wh2_main_horde_def_settlement_5"] = "wh2_main_art_set_def_black_ark_lokhir_3"
	}
};

function add_ship_upgrade_listeners()
	out("#### Adding Ship Upgrade Listeners ####");
	core:add_listener(
		"ShipMilitaryForceBuildingCompleteEvent",
		"MilitaryForceBuildingCompleteEvent",
		true,
		function(context) ShipBuildingModelUpdate(context:character(), context:building()) end,
		true
	);
	
	if cm:is_new_game() == true then
		-- Vampire Coast Legendary Lords
		local harkon = cm:model():world():faction_by_key("wh2_dlc11_cst_vampire_coast"):faction_leader():command_queue_index();
		local noctilus = cm:model():world():faction_by_key("wh2_dlc11_cst_noctilus"):faction_leader():command_queue_index();
		local aranessa = cm:model():world():faction_by_key("wh2_dlc11_cst_pirates_of_sartosa"):faction_leader():command_queue_index();
		local cylostra = cm:model():world():faction_by_key("wh2_dlc11_cst_the_drowned"):faction_leader():command_queue_index();
		cm:add_unit_model_overrides("character_cqi:"..harkon, "wh2_dlc11_art_set_cst_harkon_1");
		cm:add_unit_model_overrides("character_cqi:"..noctilus, "wh2_dlc11_art_set_cst_noctilus_1");
		cm:add_unit_model_overrides("character_cqi:"..aranessa, "wh2_dlc11_art_set_cst_aranessa_1");
		cm:add_unit_model_overrides("character_cqi:"..cylostra, "wh2_dlc11_art_set_cst_cylostra_1");
		
		-- Lokhir Fellhearts Black Ark
		local lokhir = cm:model():world():faction_by_key("wh2_dlc11_def_the_blessed_dread");
		local lokhir_chars = lokhir:character_list();
		
		for i = 0, lokhir_chars:num_items() - 1 do
			local this_char = lokhir_chars:item_at(i);
			
			if this_char:character_subtype("wh2_main_def_black_ark_blessed_dread") then
				cm:add_unit_model_overrides("character_cqi:"..this_char:command_queue_index(), "wh2_main_art_set_def_black_ark_lokhir_1");
			end
		end
	end
end

function ShipBuildingModelUpdate(character, building_key)
	if character:is_null_interface() == false then
		local subtype = character:character_subtype_key();
		
		if vampire_coast_ships[subtype] ~= nil then
			local cqi = character:command_queue_index();
			local art_set = vampire_coast_ships[subtype][building_key];
			
			if art_set ~= nil then
				cm:add_unit_model_overrides("character_cqi:"..cqi, art_set);
			end
		end
	end
end