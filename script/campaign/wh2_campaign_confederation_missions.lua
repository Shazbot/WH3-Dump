---WH2 Confederation missions

--- generic handler for creating missions/dilemmas that allow one faction to confederate another.


confed_missions = {}

confed_missions_data = {
	----IMRIK/CALEDOR---
	["imrik_caledor"] = {
		factions = "wh2_dlc15_hef_imrik", ---- the faction(s) for whom the confed mission should trigger. Can be a string or a table of strings.
		target_faction = "wh2_main_hef_caledor", ---- the faction which will be confederated
		disable_diplomatic_confed = true, --- should we prevent anyone from confederating this faction prior to the dilemma? 
		disable_cai_targeting = true, --- do we prevent the AI from targeting the faction's home region?
		turn_number = 2, --- when is the earliest we want the mission/dilemma to trigger? Longer term this could be a bespoke listener
		mission_key = "wh2_dlc15_imrik_caledor_confederation_mission", --- point to a mission in the db. This is the mission that will trigger on the turn. Follow-up dilemmas defined in DB.
		dilemma_key = "wh2_dlc15_hef_imrik_confederation_caledor", --- point to a dilemma in the db. If no mission defined, this will trigger automatically on specified turn.
		confed_choices = {true,true,true,false}, -- booleans for each dilemma choice (0-1-2-3). True means that the choice will result in a confederation
		mission_generated = {},
		dilemma_completed = false --- saved variable, please leave as false
	},

	---WOOD ELVES---
	["wood_elves_talsyn"] = {
		factions = {"wh_dlc05_wef_argwylon","wh2_dlc16_wef_sisters_of_twilight"},
		target_faction = "wh_dlc05_wef_wood_elves",
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 0,
		require_diplomatic_knowledge = false,
		custom_callback = 
			function()
				return confed_missions:is_settlement_primary_building_at_level("wh3_main_combi_region_the_oak_of_ages", 3)
			end,
		mission_key = "wh2_dlc16_wef_confederation_mission_talsyn",
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_talsyn",
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},

	["wood_elves_torgovann"] = {
		factions = {"wh_dlc05_wef_wood_elves","wh_dlc05_wef_argwylon","wh2_dlc16_wef_sisters_of_twilight"},
		target_faction = "wh_dlc05_wef_torgovann",
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 0,
		require_diplomatic_knowledge = false,
		custom_callback =
			function()
				return confed_missions:is_settlement_primary_building_at_level("wh3_main_combi_region_the_oak_of_ages", 2)
			end,
		mission_key = "wh2_dlc16_wef_confederation_mission_torgovann",
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_torgovann",
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},

	["wood_elves_wydrioth"] = {
		factions = {"wh_dlc05_wef_wood_elves","wh_dlc05_wef_argwylon","wh2_dlc16_wef_sisters_of_twilight"},
		target_faction = "wh_dlc05_wef_wydrioth",
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 0,
		require_diplomatic_knowledge = false,
		custom_callback =
			function()
				return confed_missions:is_settlement_primary_building_at_level("wh3_main_combi_region_the_oak_of_ages", 2)
			end,
		mission_key = "wh2_dlc16_wef_confederation_mission_wydrioth",
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_wydrioth",
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},

	["wood_elves_sisters"] = {
		factions = {"wh_dlc05_wef_wood_elves","wh_dlc05_wef_argwylon"}, 
		target_faction = "wh2_dlc16_wef_sisters_of_twilight", 
		disable_diplomatic_confed = false,
		disable_cai_targeting = false, 
		turn_number = 0,
		require_diplomatic_knowledge = false,
		custom_callback = 
			function(faction_key)
				if not cm:faction_has_dlc_or_is_ai("TW_WH2_DLC16_TWILIGHT", faction_key) then
					return false
				end
				return confed_missions:is_settlement_primary_building_at_level("wh3_main_combi_region_the_oak_of_ages", 3)
			end,
		mission_key = "wh2_dlc16_wef_confederation_mission_sisters", 
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_sisters",
		confed_choices = {true,false,false,false}, 
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},

	["wood_elves_durthu"] = {
		factions = {"wh_dlc05_wef_wood_elves","wh2_dlc16_wef_sisters_of_twilight","wh2_dlc16_wef_drycha"},
		target_faction = "wh_dlc05_wef_argwylon",
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 0,
		require_diplomatic_knowledge = false,
		custom_callback = 
			function()
				return confed_missions:is_settlement_primary_building_at_level("wh3_main_combi_region_the_oak_of_ages", 3)
			end,
		mission_key = "wh2_dlc16_wef_confederation_mission_argwylon",
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_argwylon",
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},

	["durthu_drycha"] = {
		factions = {"wh_dlc05_wef_argwylon"},
		target_faction = "wh2_dlc16_wef_drycha",
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 2, 
		require_diplomatic_knowledge = true,
		mission_key = "wh2_dlc16_wef_confederation_mission_drycha", 
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_drycha", 
		confed_choices = {true,false,false,false}, 
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},

	["wood_elves_laurelorn"] = {
		factions = {"wh_dlc05_wef_wood_elves","wh_dlc05_wef_argwylon","wh2_dlc16_wef_sisters_of_twilight"}, 
		target_faction = "wh3_main_wef_laurelorn",
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 0,
		require_diplomatic_knowledge = true,
		mission_key = "wh2_dlc16_wef_confederation_mission_laurelorn",
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_laurelorn", 
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},

	["wood_elves_oreons_camp"] = {
		factions = {"wh_dlc05_wef_wood_elves","wh_dlc05_wef_argwylon","wh2_dlc16_wef_sisters_of_twilight"},
		target_faction = "wh2_main_wef_bowmen_of_oreon", 
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 0,
		require_diplomatic_knowledge = true,
		mission_key = "wh2_dlc16_wef_confederation_mission_bowmen_of_oreon",
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_bowmen_of_oreon",
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},

	["wood_elves_shanlin"] = {
		factions = {"wh_dlc05_wef_wood_elves","wh_dlc05_wef_argwylon","wh2_dlc16_wef_sisters_of_twilight"},
		target_faction = "wh3_dlc21_wef_spirits_of_shanlin",
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 0,
		require_diplomatic_knowledge = true,
		mission_key = "wh3_dlc21_wef_confederation_mission_shanlin",
		dilemma_key = "wh3_dlc21_wef_confederation_dilemma_shanlin", 
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},

	---Karond Kar
	["lokhir_rakarth_karond_kar"] = {
		factions = {"wh2_twa03_def_rakarth","wh2_dlc11_def_the_blessed_dread"},
		target_faction = "wh2_main_def_karond_kar", 
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 2,
		require_diplomatic_knowledge = false,
		mission_key = "wh2_twa03_def_confederation_mission_karond_kar",
		dilemma_key = "wh2_twa03_def_confederation_dilemma_karond_kar",
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false
	},

	----THOREK/KARAK AZUL---
	["thorek_karak_azul"] = {
		factions = "wh2_dlc17_dwf_thorek_ironbrow",
		target_faction = "wh_main_dwf_karak_azul",
		disable_diplomatic_confed = true,
		disable_cai_targeting = true,
		turn_number = 2,
		mission_key = "wh2_dlc17_dwf_thorek_karak_azul_confederation_mission",
		dilemma_key = "wh2_dlc17_dwf_thorek_confederation_karak_azul",
		confed_choices = {true,true,true,false},
		mission_generated = {},
		dilemma_completed = false
	},

	----CLAN ANGRUND/KARAK HIRN---
	["angrund_karak_hirn"] = {
		factions = {"wh_main_dwf_karak_izor"}, 
		target_faction = "wh_main_dwf_karak_hirn",
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 1,
		require_diplomatic_knowledge = false,
		mission_key = "wh3_dlc21_dwf_confederation_mission_angrund",
		dilemma_key = "wh3_dlc21_dwf_confederation_dilemma_angrund", 
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false
	}
}

function confed_missions:setup()
	--validate now
	for mission_ref, mission_info in pairs(confed_missions_data) do
		if not is_string(mission_info.factions) and not is_table(mission_info.factions) then
			script_error("ERROR: trying to generate a confederation mission but faction key [" .. tostring(mission_info.factions) .. "] is not a string or a table");
		end

		if is_string(mission_info.factions) then 
			mission_info.factions = {mission_info.factions}
		end

		if not is_string(mission_info.target_faction) then
			script_error("ERROR: trying to generate a confederation mission for [" .. tostring(mission_info.factions) .. "] but target_faction is not a string");
		end

		if not is_boolean(mission_info.disable_diplomatic_confed) then
			script_error("ERROR: trying to generate a confederation mission for [" .. tostring(mission_info.factions) .. "] but disable_diplomatic confed is not a bool");
		end

		local confed_choices = mission_info.confed_choices

		if #confed_choices ~=4 then
			script_error("ERROR: trying to generate a confederation dilemma for [" .. tostring(mission_info.factions) .. "] but don't have 4 dilemma bools - this might break!");
		end

		for i = 1, #confed_choices do
			if not is_boolean(confed_choices[i]) then
				script_error("ERROR: trying to generate a confederation dilemma for [" .. tostring(mission_info.factions) .. "] but we've found a dilemma choice that's not a boolean!");
			end
		end
	end

	confed_missions:setup_listeners()
end


function confed_missions:setup_listeners()
	core:add_listener(
		"ConfedMissionsWorldStartRound",
		"WorldStartRound",
		true,
		function(context)
			for mission_ref, mission in pairs(confed_missions_data) do
				local is_dead = cm:get_faction(mission.target_faction):is_dead()
				
				for i = 1, #mission.factions do
					if is_dead then
						if mission.mission_generated[mission.factions[i]] then
							cm:cancel_custom_mission(mission.factions[i], mission.mission_key)
						end
					elseif cm:get_faction(mission.factions[i]):is_human() and confed_missions:is_mission_valid_for_faction(mission.factions[i], mission_ref) then
						confed_missions:trigger_mission(mission.factions[i], mission_ref)
					end
				end
			end
		end,
		true
	)

	core:add_listener(
		"ConfedMissionsDilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		function(context)
			local dilemma_key = context:dilemma()
			for mission_ref,mission in pairs(confed_missions_data) do
				if dilemma_key == mission.dilemma_key then
					return true
				end
			end
			return false
		end,
		function(context)
			local dilemma_key = context:dilemma()
			local faction_key = context:faction():name()
			local confed_mission
			for mission_ref,mission in pairs(confed_missions_data) do
				if dilemma_key == mission.dilemma_key then
					confed_mission = mission
				end
			end

			local choice = context:choice() + 1 -- have to add +1 here as the model starts the choices at 0
			if confed_mission.confed_choices[choice]  == true then 
				cm:force_confederation(faction_key, confed_mission.target_faction)
			end

			---regardless of choice, clean up any restrictions previously imposed
			if confed_mission.disable_cai_targeting then
				self:enable_cai_targeting_against_faction_capital(confed_mission)
			end

			if confed_mission.disable_diplomatic_confed then
				self:enable_diplomatic_confed(confed_mission)
			end
			
			if confed_mission.force_peace_post_dilemma and not cm:get_faction(confed_mission.target_faction):is_dead() then
				cm:force_make_peace(faction_key, confed_mission.target_faction)
			end
			
			confed_mission.dilemma_completed = true
		end,
		true
	)
end

---fire the mission. Can safely be called from other scripts if you want to by-pass the listeners and faction/turn conditions
function confed_missions:trigger_mission(faction_key, confed_mission_ref)

	local mission = confed_missions_data[confed_mission_ref]

	if mission == nil then
		script_error("Confed Missions: trying to force trigger a mission with key"..confed_mission_ref.."but that mission can't be found")
	end

	cm:trigger_mission(faction_key, mission.mission_key, true)
	mission.mission_generated[faction_key] = true
	if mission.disable_diplomatic_confed then
		confed_missions:disable_diplomatic_confed(mission)
	end
	if mission.disable_cai_targeting then
		confed_missions:disable_cai_targeting_against_faction_capital(mission)
	end
end


function confed_missions:is_mission_valid_for_faction(faction_key, mission_key)
	local mission_is_valid = false
	local mission = confed_missions_data[mission_key]
	if mission == nil then
		return false
	end
	for index, valid_faction_key in ipairs(mission.factions) do
		if valid_faction_key == faction_key then 
			mission_is_valid = true
		end
	end

	if mission.mission_generated[faction_key] then 
		return false
	end

	local target_faction = cm:get_faction(mission.target_faction)
	if target_faction == false or target_faction:is_null_interface() or target_faction:is_human() or target_faction:is_dead() then
		return false
	end

	local current_turn = cm:turn_number()
	if mission.turn_number ~= nil and mission.turn_number > current_turn then
		return false
	end

	if is_function(mission.custom_callback) and mission.custom_callback(faction_key) == false then
		return false
	end

	if mission.require_diplomatic_knowledge then
		local faction_list = cm:get_faction(faction_key):factions_met();
		local faction_is_known = false
		for i = 0, faction_list:num_items() - 1 do
			local current_faction = faction_list:item_at(i);
			
			if current_faction:name() == mission.target_faction then
				faction_is_known = true
				break
			end;
		end

		if faction_is_known == false then
			return false
		end
	end
		
	return mission_is_valid
end 

function confed_missions:disable_cai_targeting_against_faction_capital(confed_mission)
	local target_faction_key =  confed_mission.target_faction
	local target_faction_interface = cm:get_faction(target_faction_key)
	
	if not target_faction_interface:is_dead() and not target_faction_interface:home_region():is_null_interface() and not confed_mission.dilemma_completed then
		local target_faction_home_region = target_faction_interface:home_region():name()
		cm:cai_disable_targeting_against_settlement("settlement:"..target_faction_home_region);
	end
end

function confed_missions:enable_cai_targeting_against_faction_capital(confed_mission)
	local target_faction_key =  confed_mission.target_faction
	local target_faction_interface = cm:get_faction(target_faction_key)
	if not target_faction_interface:is_dead() and not target_faction_interface:home_region():is_null_interface() then
		local target_faction_home_region = target_faction_interface:home_region():name()
		cm:cai_enable_targeting_against_settlement("settlement:"..target_faction_home_region);
	end
end

function confed_missions:disable_diplomatic_confed(confed_mission)
	if not confed_mission.dilemma_completed then
		local target_faction_key =  confed_mission.target_faction
		cm:force_diplomacy("faction:"..target_faction_key, "all", "form confederation", false, false, true)
	end
end

function confed_missions:enable_diplomatic_confed(confed_mission)
	local target_faction_key =  confed_mission.target_faction
	cm:force_diplomacy("faction:"..target_faction_key, "all","form confederation", true, true, true)
end

function confed_missions:is_settlement_primary_building_at_level(region_key, building_level)
	local region_interface = cm:get_region(region_key)

	if region_interface == false then
		return
	end

	return region_interface:settlement():primary_slot():building():building_level() >= building_level
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		out.savegame("Saving confed missions data")
		for key, mission in pairs(confed_missions_data) do
			cm:save_named_value(key, {mission.mission_generated, mission.dilemma_completed}, context);
		end
		out.savegame("Finished saving confed missions data")
	end
);

cm:add_loading_game_callback(
	function(context)
		out.savegame("Loading confed missions data")
		if cm:is_new_game() == false then
			for key, mission in pairs(confed_missions_data) do
				local saved_mission_data = cm:load_named_value(key, {}, context);
				if saved_mission_data[1] ~= nil then
					mission.mission_generated = saved_mission_data[1]
				end
				if saved_mission_data[2] ~= nil then
					mission.dilemma_completed = saved_mission_data[2]
				end
			end
		end
		out.savegame("Finished loading confed missions data")
	end
);