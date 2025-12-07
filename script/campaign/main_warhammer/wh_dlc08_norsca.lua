NORSCA_SUBCULTURE = "wh_dlc08_sc_nor_norsca";
NORSCA_ADVICE = {};
NORSCA_LEGENDARY_LORDS = {
	wh_dlc08_nor_wulfrik = true,
	wh_dlc08_nor_throgg = true,
	wh3_dlc27_nor_sayl_the_faithless = true,
};
NORSCA_FACTION_KEYS = {
	wulfrik = "wh_dlc08_nor_norsca",
	throgg = "wh_dlc08_nor_wintertooth",
	sayl = "wh3_dlc27_nor_sayl",
}

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
		
		if turn_faction:is_null_interface() == false and turn_faction:is_human() == true and turn_faction:subculture() == NORSCA_SUBCULTURE and turn_faction:name() ~= NORSCA_FACTION_KEYS.sayl then
			Play_Norsca_Advice("dlc08.camp.advice.nor.gods.001", norsca_info_text_gods);
		elseif turn_faction:region_list():num_items() >= cm:campaign_var_int_value("nor_dark_allegiance_unlock_settlement_requirement") then
			Play_Norsca_Advice("dlc27.camp.advice.nor.gods.sayl.001", norsca_info_text_gods_sayl);
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
norsca_info_text_gods_sayl = {"dlc27.war.camp.prelude.nor.gods.sayl.info_001", "dlc27.war.camp.prelude.nor.gods.sayl.info_002", "dlc27.war.camp.prelude.nor.gods.sayl.info_003"};
norsca_info_text_confederation = {"war.camp.prelude.nor.confederation.info_001", "war.camp.prelude.nor.confederation.info_002", "war.camp.prelude.nor.confederation.info_003"};
norsca_info_text_monsters = {"war.camp.prelude.nor.monsters.info_001", "war.camp.prelude.nor.monsters.info_002", "war.camp.prelude.nor.monsters.info_003"};

function Play_Norsca_Advice(advice, infotext, ignore_advice_level)
	if ignore_advice_level == nil then
		ignore_advice_level = false
	end
	if cm:model():is_multiplayer() == false then
		if common.get_advice_level() >= 1 or ignore_advice_level then
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


-- Wulfrik campaign start actions 
wulfrik_campaign_start = {
	wulfrik_faction = "wh_dlc08_nor_norsca",
	start_dilemma_key = "wh3_dlc27_nor_wulfrik_start_dilemma",
	-- each dilemma choice will reveal a set of predefined coastal regions
	choice_to_region_mapping = {
		[0] = {"wh3_main_combi_region_marienburg"},
		[1] = {"wh3_main_combi_region_castle_alexandronov","wh3_main_combi_region_erengrad"},
		[2] = {"wh3_main_combi_region_bordeleaux"},
		[3] = {"wh3_main_combi_region_karond_kar","wh3_main_combi_region_nagrar"}
	}
}

function wulfrik_campaign_start:initialise()
	local wulfrik_faction_obj = cm:get_faction(self.wulfrik_faction)
	if not wulfrik_faction_obj then return false end

	-- start of turn trigger the following
	core:add_listener(
		"wulfrik_reveal_locations_dilemma_trigger",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.wulfrik_faction
		end,
		function(context)
			local faction = context:faction()

			-- on turn 5 wulfrik receives his dilemma to reveal shroud on a region
			if faction:is_human() == true then
				if cm:turn_number() == 5 and cm:get_campaign_name() == "main_warhammer" then
					cm:trigger_dilemma(self.wulfrik_faction, self.start_dilemma_key);
				end
			end

		end,
		true
	)

	-- listen to a choice being made on the above dilemma
	core:add_listener(
		"wulfrik_reveal_dilemma_choice_made",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == self.start_dilemma_key
		end,
		function(context)
			local choice = context:choice()
			local regions_to_reveal = self.choice_to_region_mapping[choice]
			-- for each region in the choice made we make it visible
			for _, region_key in ipairs(regions_to_reveal) do
				cm:make_region_visible_in_shroud(self.wulfrik_faction, region_key)
			end
		end,
		true
	)
end
