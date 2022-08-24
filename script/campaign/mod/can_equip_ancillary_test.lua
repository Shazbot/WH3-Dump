




function anc()
	local faction = cm:get_faction("wh3_main_cth_the_northern_provinces");
	if faction then
		faction:faction_leader():can_equip_ancillary("wh_main_anc_arcane_item_channelling_staff");
	end;
end;