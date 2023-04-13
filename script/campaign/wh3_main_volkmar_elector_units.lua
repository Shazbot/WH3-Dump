local volkmar_faction = "wh3_main_emp_cult_of_sigmar";
EMPIRE_ELECTOR_UNITS = {
	"wh2_dlc13_emp_cav_pistoliers_ror_0",
	"wh2_dlc13_emp_inf_handgunners_ror_0",
	"wh2_dlc13_emp_inf_swordsmen_ror_0",
	"wh2_dlc13_emp_inf_halberdiers_ror_0",
	"wh2_dlc13_emp_cav_empire_knights_ror_0",
	"wh2_dlc13_emp_cav_empire_knights_ror_2",
	"wh2_dlc13_emp_inf_greatswords_ror_0",
	"wh2_dlc13_emp_inf_spearmen_ror_0",
	"wh2_dlc13_emp_inf_crossbowmen_ror_0",
	"wh2_dlc13_emp_cav_empire_knights_ror_1",
	"wh2_dlc13_emp_art_mortar_ror_0",
	"wh2_dlc13_emp_cav_outriders_ror_0",
	"wh2_dlc13_emp_veh_steam_tank_ror_0"
};

function add_volkmar_elector_count_units_listener()
    out("#### Adding Volkmar Elector Units Listeners ####");

    local volkmar_interface = cm:get_faction(volkmar_faction);
    local player_cqi = cm:get_faction(volkmar_faction):command_queue_index();

    if volkmar_interface:is_human() then
        if cm:is_new_game() == true then
            for i = 1, #EMPIRE_ELECTOR_UNITS do
				cm:add_units_to_faction_mercenary_pool(player_cqi, EMPIRE_ELECTOR_UNITS[i], 1);
				local unit = EMPIRE_ELECTOR_UNITS[i];
				cm:add_event_restricted_unit_record_for_faction(unit, volkmar_faction, unit.."_lock");
			end
        end
    end

	core:add_listener(
		"Volkmar_PooledResourceEffectChangedEvent",
		"PooledResourceEffectChangedEvent",
		function(context) 
			--Check if pooled resource is Books destroyed
			return context:resource():key() == "wh3_main_emp_volkmar_books_destroyed";
		end,
		function() 
			VolkmarZeal_PooledResourceEffectChangedEvent() 
		end,
		true
	);
end

function VolkmarZeal_PooledResourceEffectChangedEvent()
	--get current Books Destroyed value
	local volkmar_interface = cm:get_faction(volkmar_faction);
    local player_cqi = volkmar_interface:command_queue_index();
	local current_books_destroyed = volkmar_interface:pooled_resource_manager():resource("wh3_main_emp_volkmar_books_destroyed"):value();

	--check the current book destroyed number and give the unit and ancillary corresponding to the number of books destroyed
	if current_books_destroyed == 1 then
		cm:remove_event_restricted_unit_record_for_faction("wh2_dlc13_emp_inf_spearmen_ror_0", volkmar_faction);
		cm:remove_event_restricted_unit_record_for_faction("wh2_dlc13_emp_inf_swordsmen_ror_0", volkmar_faction);
		cm:add_units_to_faction_mercenary_pool(player_cqi, "wh2_dlc13_emp_inf_spearmen_ror_0", 1);
		cm:add_units_to_faction_mercenary_pool(player_cqi, "wh2_dlc13_emp_inf_swordsmen_ror_0", 1);
		cm:add_ancillary_to_faction(volkmar_interface, "wh2_dlc13_anc_weapon_runefang_averland", false);
	elseif current_books_destroyed == 2 then
		cm:remove_event_restricted_unit_record_for_faction("wh2_dlc13_emp_inf_crossbowmen_ror_0", volkmar_faction);
		cm:remove_event_restricted_unit_record_for_faction("wh2_dlc13_emp_inf_halberdiers_ror_0", volkmar_faction);
		cm:add_units_to_faction_mercenary_pool(player_cqi, "wh2_dlc13_emp_inf_crossbowmen_ror_0", 1);
		cm:add_units_to_faction_mercenary_pool(player_cqi, "wh2_dlc13_emp_inf_halberdiers_ror_0", 1);
		cm:add_ancillary_to_faction(volkmar_interface, "wh2_dlc13_anc_talisman_sylvania_journal", false);
	elseif current_books_destroyed == 3 then
		cm:remove_event_restricted_unit_record_for_faction("wh2_dlc13_emp_cav_pistoliers_ror_0", volkmar_faction);
		cm:remove_event_restricted_unit_record_for_faction("wh2_dlc13_emp_inf_handgunners_ror_0", volkmar_faction);	
		cm:add_units_to_faction_mercenary_pool(player_cqi, "wh2_dlc13_emp_cav_pistoliers_ror_0", 1);
		cm:add_units_to_faction_mercenary_pool(player_cqi, "wh2_dlc13_emp_inf_handgunners_ror_0", 1);
		cm:add_ancillary_to_faction(volkmar_interface, "wh2_dlc13_anc_weapon_runefang_ostland", false);
	elseif current_books_destroyed == 4 then
		cm:remove_event_restricted_unit_record_for_faction("wh2_dlc13_emp_art_mortar_ror_0", volkmar_faction);
		cm:remove_event_restricted_unit_record_for_faction("wh2_dlc13_emp_cav_outriders_ror_0", volkmar_faction);	
		cm:add_units_to_faction_mercenary_pool(player_cqi, "wh2_dlc13_emp_art_mortar_ror_0", 1);
		cm:add_units_to_faction_mercenary_pool(player_cqi, "wh2_dlc13_emp_cav_outriders_ror_0", 1);
		cm:add_ancillary_to_faction(volkmar_interface, "wh2_dlc13_anc_weapon_runefang_hochland", false);
	elseif current_books_destroyed == 5 then
		cm:remove_event_restricted_unit_record_for_faction("wh2_dlc13_emp_cav_empire_knights_ror_0", volkmar_faction);
		cm:remove_event_restricted_unit_record_for_faction("wh2_dlc13_emp_cav_empire_knights_ror_2", volkmar_faction);
		cm:add_units_to_faction_mercenary_pool(player_cqi, "wh2_dlc13_emp_cav_empire_knights_ror_0", 1);	
		cm:add_units_to_faction_mercenary_pool(player_cqi, "wh2_dlc13_emp_cav_empire_knights_ror_2", 1);
		cm:add_ancillary_to_faction(volkmar_interface, "wh2_dlc13_anc_weapon_runefang_nordland", false);
	elseif current_books_destroyed == 6 then	
		cm:remove_event_restricted_unit_record_for_faction("wh2_dlc13_emp_cav_empire_knights_ror_1", volkmar_faction);
		cm:add_units_to_faction_mercenary_pool(player_cqi, "wh2_dlc13_emp_cav_empire_knights_ror_1", 1);
		cm:add_ancillary_to_faction(volkmar_interface, "wh2_dlc13_anc_weapon_runefang_talabecland", false);
	elseif current_books_destroyed == 7 then	
		cm:remove_event_restricted_unit_record_for_faction("wh2_dlc13_emp_inf_greatswords_ror_0", volkmar_faction);
		cm:add_units_to_faction_mercenary_pool(player_cqi, "wh2_dlc13_emp_inf_greatswords_ror_0", 1);
		cm:add_ancillary_to_faction(volkmar_interface, "wh2_dlc13_anc_weapon_runefang_middenland", false);
	elseif current_books_destroyed == 8 then
		cm:remove_event_restricted_unit_record_for_faction("wh2_dlc13_emp_veh_steam_tank_ror_0", volkmar_faction);
		cm:add_units_to_faction_mercenary_pool(player_cqi, "wh2_dlc13_emp_veh_steam_tank_ror_0", 1);
		cm:add_ancillary_to_faction(volkmar_interface, "wh2_dlc13_anc_weapon_runefang_reikland", false);							
	end
end
