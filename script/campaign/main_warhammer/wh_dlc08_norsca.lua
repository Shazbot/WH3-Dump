NORSCA_SUBCULTURE = "wh_dlc08_sc_nor_norsca";
NORSCA_ADVICE = {};
NORSCA_LEGENDARY_LORDS = {
	wh_dlc08_nor_wulfrik = true,
	wh_dlc08_nor_throgg = true,
};

function Add_Norsca_Listeners()
	out("#### Adding Norsca Listeners ####");
	core:add_listener(
		"Norsca_CharacterEntersGarrison",
		"CharacterEntersGarrison",
		true,
		function(context) Norsca_CharacterEntersGarrison(context) end,
		true
	);

	if not cm:is_multiplayer() then
		core:add_listener(
			"Norsca_Settlement_Captured",
			"PanelOpenedCampaign",
			true,
			function(context) Norsca_Settlement_Captured(context) end,
			true
		);
	end;
end

function Norsca_Settlement_Captured(context)
	if context.string == "settlement_captured" then
		local turn_faction = cm:whose_turn_is_it_single();
		
		if turn_faction:is_null_interface() == false and turn_faction:is_human() == true and turn_faction:subculture() == NORSCA_SUBCULTURE then
			Play_Norsca_Advice("dlc08.camp.advice.nor.gods.001", norsca_info_text_gods);
		end
	end
end

function Norsca_CharacterEntersGarrison(context)
	local character = context:character();
	
	if character:has_region() == true and character:faction():subculture() == NORSCA_SUBCULTURE then
		local region = character:region();
		local region_name = region:name();
		
		if region_name == "wh3_main_combi_region_miragliano" then
			Play_Norsca_Advice("dlc08.camp.advice.nor.outposts_miragliano.001");
		elseif region_name == "wh3_main_combi_region_altdorf" then
			Play_Norsca_Advice("dlc08.camp.advice.nor.outposts_altdorf.001");
		elseif region_name == "wh3_main_combi_region_castle_drakenhof" then
			Play_Norsca_Advice("dlc08.camp.advice.nor.outposts_drakenhof.001");
		elseif region_name == "wh3_main_combi_region_couronne" then
			Play_Norsca_Advice("dlc08.camp.advice.nor.outposts_couronne.001");
		elseif region_name == "wh3_main_combi_region_black_crag" then
			Play_Norsca_Advice("dlc08.camp.advice.nor.outposts_black_crag.001");
		elseif region_name == "wh3_main_combi_region_karaz_a_karak" then
			Play_Norsca_Advice("dlc08.camp.advice.nor.outposts_karaz_a_karak.001");
		end
		
		cm:callback(function()
			if NORSCA_ADVICE["dlc08.camp.advice.nor.outposts.001"] ~= true then -- Early Check
				if region:building_exists("wh_main_nor_outpost_major_dwarfhold_1_coast") or region:building_exists("wh_main_nor_outpost_major_human_1_coast") or region:building_exists("wh_main_nor_outpost_minor_dwarfhold_1_coast") or region:building_exists("wh_main_nor_outpost_minor_human_1_coast") or
				region:building_exists("wh_main_nor_outpost_major_dwarfhold_2_coast") or region:building_exists("wh_main_nor_outpost_major_human_2_coast") or region:building_exists("wh_main_nor_outpost_minor_dwarfhold_2_coast") or region:building_exists("wh_main_nor_outpost_minor_human_2_coast") or
				region:building_exists("wh_main_nor_outpost_major_dwarfhold_3_coast") or region:building_exists("wh_main_nor_outpost_major_human_3_coast") or region:building_exists("wh_main_nor_outpost_minor_dwarfhold_3_coast") or region:building_exists("wh_main_nor_outpost_minor_human_3_coast") then
					Play_Norsca_Advice("dlc08.camp.advice.nor.outposts.001");
				end
			end
		end, 0.5);
	end
end

norsca_info_text_gods = {"war.camp.prelude.nor.gods.info_001", "war.camp.prelude.nor.gods.info_002", "war.camp.prelude.nor.gods.info_003"};
norsca_info_text_confederation = {"war.camp.prelude.nor.confederation.info_001", "war.camp.prelude.nor.confederation.info_002", "war.camp.prelude.nor.confederation.info_003"};
norsca_info_text_monsters = {"war.camp.prelude.nor.monsters.info_001", "war.camp.prelude.nor.monsters.info_002", "war.camp.prelude.nor.monsters.info_003"};

function Play_Norsca_Advice(advice, infotext)
	if cm:model():is_multiplayer() == false then
		if common.get_advice_level() >= 1 then
			local turn_faction = cm:whose_turn_is_it_single();
			
			if turn_faction:is_null_interface() == false and turn_faction:is_human() == true and turn_faction:subculture() == NORSCA_SUBCULTURE then
				if NORSCA_ADVICE[advice] ~= true then
					NORSCA_ADVICE[advice] = true;
					cm:clear_infotext();
					cm:show_advice(advice, true);
					
					if infotext ~= nil then
						cm:add_infotext(1, unpack(infotext));
					end
				end
			end
		end
	end
end

local woc_subculture = "wh_main_sc_chs_chaos"

function Is_Vassal_Of_Woc_Faction(faction_interface)
	if faction_interface ~= nil then
		local vassal_master = faction_interface:master()
		if not vassal_master:is_null_interface() then
			if vassal_master:subculture() == woc_subculture then
				return true
			end
		end
	end
	return false
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("NORSCA_ADVICE", NORSCA_ADVICE, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		NORSCA_ADVICE = cm:load_named_value("NORSCA_ADVICE", {}, context);
	end
);