NORSCA_SUBCULTURE = "wh_dlc08_sc_nor_norsca";
NORSCA_CONFEDERATE_DILEMMA = "wh2_dlc08_nor_confederate_generic";
NORSCA_CONFEDERATE_FOR_LLS_DILEMMA = "wh2_dlc08_nor_confederate_generic_no_execution";
NORSCA_CONFEDERATE_DILEMMA_EXECUTION_OPTION = 1;
NORSCA_CONFEDERATION_PLAYER = "";
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

	-- In fights between Norscans, if a faction leader is defeated, launch the confederation dilemma.
	cm:add_immortal_character_defeated_listener(
		"NorscaLordDefeatedConfederateEvent",
		function(context)
			-- Start checking if we need a Norsca Confederate event if both attackers and defenders have Norsca armies involved.
			return cm:pending_battle_cache_subculture_is_attacker(NORSCA_SUBCULTURE) and cm:pending_battle_cache_subculture_is_defender(NORSCA_SUBCULTURE);
		end,
		Norsca_Launch_Confederate_Dilemma,
		true
	);
end

function Norsca_Settlement_Captured(context)
	if context.string == "settlement_captured" then
		local turn_faction = cm:whose_turn_is_it_single();
		
		if turn_faction:is_null_interface() == false and turn_faction:is_human() == true and turn_faction:subculture() == NORSCA_SUBCULTURE then
			Play_Norsca_Advice("dlc08.camp.advice.nor.gods.001", norsca_info_text_gods);
		end
	end
end

function Norsca_Launch_Confederate_Dilemma(victorious_fm, defeated_fm)
	local victorious_character = victorious_fm:character();
	local defeated_character = defeated_fm:character();

	if not victorious_character or victorious_character:is_null_interface() then
		script_error("ERROR: Victorious character could not be obtained from victorious family member when trying to launch Norsca confederation dilemma after a battle. "
			.. "Is the victorious character dead? How did this happen if they won the battle?");
		return;
	end

	if not defeated_character or defeated_character:is_null_interface() then
		script_error("ERROR: Defeated character could not be obtained from Defeated family member when trying to launch Norsca confederation dilemma after a battle. "
			.. "This function should have been called after the defeated character respawned post-battle. Why hasn't this happened?");
		return;
	end
	local defeated_faction = defeated_character:faction();

	if defeated_faction:is_human() or defeated_faction:subculture() ~= NORSCA_SUBCULTURE or not defeated_character:is_faction_leader() then
		return;
	end

	local victorious_faction = victorious_character:faction();

	if victorious_faction:subculture() == NORSCA_SUBCULTURE then
		if victorious_faction:is_human() and not Is_Vassal_Of_Woc_Faction(defeated_character:faction()) then
			-- For Legendary Lords, we need to use the dilemma that doesn't have the 'execute enemy boss' option.
			local confederate_dilemma_key = NORSCA_CONFEDERATE_DILEMMA;
			if NORSCA_LEGENDARY_LORDS[defeated_character:character_subtype_key()] ~= nil then
				confederate_dilemma_key = NORSCA_CONFEDERATE_FOR_LLS_DILEMMA;
			end

			-- Trigger dilemma to offer confederation
			cm:trigger_dilemma_with_targets(victorious_faction:command_queue_index(),
				confederate_dilemma_key,
				defeated_character:faction():command_queue_index(),
				0,
				defeated_character:command_queue_index(),
				0,
				0,
				0,
				function() Norsca_Listen_For_Execution_of_Enemy_Lord(defeated_character:family_member():command_queue_index()) end);
		else
			-- AI confederation
			if not Is_Vassal_Of_Woc_Faction(victorious_faction) and not Is_Vassal_Of_Woc_Faction(defeated_character:faction()) and not NORSCA_LEGENDARY_LORDS[defeated_character:character_subtype_key()] then
				cm:force_confederation(victorious_faction:name(), defeated_character:faction():name());
				out.design("###### AI NORSCA CONFEDERATION");
				out.design("Faction: ".. victorious_faction:name().." is confederating ".. defeated_character:faction():name());
			else
				out.design("###### BLOCKED AI NORSCA CONFEDERATION")
				out.design("One of these Factions: ".. victorious_faction:name()..", ".. defeated_character:faction():name().. " is the vassal of WoC faction or is a Legendary Lord")
			end
		end
	end
end;

function Norsca_Listen_For_Execution_of_Enemy_Lord(enemy_leader_family_member_key)
	-- Confederation via Defeat Leader
	core:add_listener(
		"Norsca_Confed_DilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		true,
		function(context)
			if context:dilemma() == NORSCA_CONFEDERATE_DILEMMA and context:choice() == NORSCA_CONFEDERATE_DILEMMA_EXECUTION_OPTION then
				-- Autosave on ironman.
				if cm:model():manual_saves_disabled() and not cm:is_multiplayer() then
					cm:callback(function() cm:autosave_at_next_opportunity() end, 0.5);
				end;

				Norsca_Force_Kill_Leader(enemy_leader_family_member_key);
			end;
		end,
		false
	);
end

function Norsca_Force_Kill_Leader(enemy_leader_family_member_key)
	local character_interface = cm:get_family_member_by_cqi(enemy_leader_family_member_key):character();
	local character_cqi = character_interface:command_queue_index();

	if NORSCA_LEGENDARY_LORDS[character_interface:character_subtype_key()] then
		script_error(string.format("ERROR: Attempt was made to force-kill one of the norsca legendary lords ('%s'): this should not be possible through events, as legendary lords should trigger a confederation dilemma with no execution option. Aborting process.",
			character_interface:character_subtype_key()));
		return;
	end
	out("KILLING CHARACTER: " .. character_interface:get_forename());
	cm:set_character_immortality("character_cqi:"..character_cqi, false);
	cm:kill_character(character_cqi, false);
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