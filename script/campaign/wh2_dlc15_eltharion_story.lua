local eltharion_faction_key = "wh2_main_hef_yvresse";
local eltharion_greenskin_targets = {"wh2_main_vor_southern_badlands_galbaraz", "wh2_main_vor_southlands_world_edge_mountains_karag_orrud", "wh2_main_vor_jungles_of_green_mist_spektazuma"};
local eltharion_relic_locations = {"wh2_main_vor_nagarythe_shrine_of_khaine", "wh2_main_vor_iron_peaks_ancient_city_of_quintex", "wh2_main_vor_naggarond_naggarond"};
local eltharion_greenskin_level = 3;
local eltharion_relic_level = 0;
local eltharion_grom_timer = 150;
local eltharion_greenskin_invasions = {
	invasions = {
		{turn = 2, pos = {700, 232}},
		{turn = 20, pos = {460, 280}},
		{turn = 45, pos = {670, 199}},
		{turn = 95, pos = {494, 290}}
	},
	cooldown = 20
};
local final_battle_mission_key = "wh2_dlc15_qb_hef_final_battle_eltharion"

local final_battle_mission_keys = {"wh2_dlc15_qb_hef_final_battle_eltharion_1","wh2_dlc15_qb_hef_final_battle_eltharion_2","wh2_dlc15_qb_hef_final_battle_eltharion"};

function add_eltharion_story_listeners()
	out("#### Adding Eltharion Story Listeners ####");
	local eltharion_interface = cm:model():world():faction_by_key(eltharion_faction_key);

	if eltharion_interface:is_null_interface() == false and eltharion_interface:is_human() == true and cm:model():campaign_name("wh2_main_great_vortex") == true then
		core:add_listener(
			"Eltharion_FactionTurnStart",
			"ScriptEventHumanFactionTurnStart",
			true,
			function(context)
				Eltharion_FactionTurnStart(context);
			end,
			true
		);
		core:add_listener(
			"Eltharion_MissionSucceeded",
			"MissionSucceeded",
			true,
			function(context)
				Eltharion_MissionSucceeded(context);
			end,
			true
		);
		core:add_listener(
			"Eltharion_FinalBattleCompleted",
			"BattleCompleted",
			function(context)
				local pb = cm:model():pending_battle();
				return pb:has_been_fought() and (pb:set_piece_battle_key() == "wh2_dlc15_qb_hef_final_battle_eltharion" or pb:set_piece_battle_key() == "wh2_dlc15_qb_hef_final_battle_eltharion_1" or pb:set_piece_battle_key() == "wh2_dlc15_qb_hef_final_battle_eltharion_2");
			end,
			function(context)
				local won = false;

				if cm:pending_battle_cache_defender_victory() then
					won = true;
				end;
				Eltharion_CompleteCampaign(won);
			end,
			true
		);
		if cm:is_new_game() == true then
			for i = 1, #eltharion_greenskin_targets do
				local mm = mission_manager:new(eltharion_faction_key, "wh2_dlc15_eltharion_greenskin_camp_"..i);
				mm:set_mission_issuer("CLAN_ELDERS");
				mm:add_new_objective("CAPTURE_REGIONS");
				mm:add_condition("region "..eltharion_greenskin_targets[i]);
				mm:add_condition("ignore_allies");
				mm:set_turn_limit(0);
				mm:set_should_whitelist(false);
				mm:add_payload("money 5000");
				mm:add_payload("effect_bundle{bundle_key wh2_dlc15_bundle_eltharion_greenskin_camp_reward_"..i..";turns 0;}");
				mm:trigger();
			end
		end
		Eltharion_UpdateGromTimer();
		Eltharion_SetupArmies();
		Eltharion_cinematic_triggers();
		Setup_final_battle_through_dilemma();
	end
end

function Eltharion_FactionTurnStart(context)
	local faction = context:faction();

	if faction:name() == eltharion_faction_key then
		local turn_number = cm:model():turn_number();
		Eltharion_UpdateGromTimer();

		local grom_faction_key = "wh2_dlc15_grn_broken_axe";
		local grom_faction = cm:get_faction(grom_faction_key);

		if grom_faction == false or grom_faction:is_human() then
			return
		end

		for i = 1, #eltharion_greenskin_invasions.invasions do
			if turn_number == eltharion_greenskin_invasions.invasions[i].turn then
				local unit_list = "";
				
				if turn_number > 100 then
					unit_list = random_army_manager:generate_force("grom_invasion_late", 19, false);
				elseif turn_number > 50 then
					unit_list = random_army_manager:generate_force("grom_invasion_mid", 19, false);
				else
					unit_list = random_army_manager:generate_force("grom_invasion_early", 19, false);
				end

				local spawn_pos = eltharion_greenskin_invasions.invasions[i].pos;
				local grn_invasion = invasion_manager:new_invasion("grn_invasion_"..i, grom_faction_key, unit_list, spawn_pos);
				--grn_invasion:set_target("REGION", "wh2_main_vor_northern_yvresse_tor_yvresse", eltharion_faction_key);
				grn_invasion:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
				grn_invasion:add_respawn(true, -1, eltharion_greenskin_invasions.cooldown);
				grn_invasion:start_invasion(nil, false, false, false);
			end
		end

		if turn_number == eltharion_grom_timer + 1 then
			cm:trigger_mission(eltharion_faction_key, Get_Final_Battle_Key(), true)
		end
	end
	cm:force_diplomacy("faction:wh2_main_hef_yvresse", "faction:wh2_dlc15_grn_broken_axe", "peace", false, false, true);
end

function Eltharion_MissionSucceeded(context)
	local faction = context:faction();

	if faction:is_human() == true and faction:name() == eltharion_faction_key then
		local mission = context:mission();
		local mission_key = mission:mission_record_key();

		for i = 1, #eltharion_greenskin_targets do
			if eltharion_greenskin_targets[i] == mission_key then
				eltharion_greenskin_level = eltharion_greenskin_level - 1;
				return;
			end
		end
		for i = 1, #eltharion_relic_locations do
			if eltharion_relic_locations[i] == mission_key then
				eltharion_relic_level = eltharion_relic_level + 1;
				return;
			end
		end
	end
end

function Eltharion_UpdateGromTimer()
	local turn_number = cm:model():turn_number();
	local timer = eltharion_grom_timer - turn_number + 1;

	if timer < 0 then
		timer = 0;
	end
	common.set_context_value("grom_timer", timer);

	if timer == 0 then
		local grom_button = find_uicomponent(core:get_ui_root(), "layout", "groms_invasion_holder", "groms_invasion_content", "grom_invasion");

		if grom_button then
			grom_button:SetVisible(false);
		end
	end
end

function grom_timer_access(set)
	if set ~= nil then
		eltharion_grom_timer = 0;
		Eltharion_UpdateGromTimer();
	end
end

function Eltharion_SetupArmies()
	random_army_manager:new_force("grom_invasion_early");
	random_army_manager:add_mandatory_unit("grom_invasion_early", "wh_main_grn_inf_goblin_spearmen", 4);			-- Infantry 1
	random_army_manager:add_mandatory_unit("grom_invasion_early", "wh_main_grn_inf_night_goblins", 4);				-- Infantry 2
	random_army_manager:add_mandatory_unit("grom_invasion_early", "wh_main_grn_inf_goblin_archers", 4);				-- Ranged 1
	random_army_manager:add_mandatory_unit("grom_invasion_early", "wh2_dlc15_grn_mon_river_trolls_0", 2);			-- Monster 1
	random_army_manager:add_mandatory_unit("grom_invasion_early", "wh2_dlc15_grn_veh_snotling_pump_wagon_0", 1);	-- Monster 2
	random_army_manager:add_mandatory_unit("grom_invasion_early", "wh2_dlc15_grn_mon_stone_trolls_0", 1);			-- Monster 3
	random_army_manager:add_unit("grom_invasion_early", "wh2_dlc15_grn_mon_stone_trolls_0", 1);			-- Extra 1
	random_army_manager:add_unit("grom_invasion_early", "wh2_dlc15_grn_mon_stone_trolls_0", 1);			-- Extra 1

	random_army_manager:new_force("grom_invasion_mid");
	random_army_manager:add_mandatory_unit("grom_invasion_mid", "wh_main_grn_inf_night_goblins", 4);				-- Infantry 1
	random_army_manager:add_mandatory_unit("grom_invasion_mid", "wh_main_grn_inf_night_goblin_fanatics", 4);		-- Infantry 2
	random_army_manager:add_mandatory_unit("grom_invasion_mid", "wh_main_grn_inf_night_goblin_archers", 4);			-- Ranged 1
	random_army_manager:add_mandatory_unit("grom_invasion_mid", "wh2_dlc15_grn_mon_river_trolls_0", 2);				-- Monster 1
	random_army_manager:add_mandatory_unit("grom_invasion_mid", "wh2_dlc15_grn_veh_snotling_pump_wagon_0", 1);		-- Monster 2
	random_army_manager:add_mandatory_unit("grom_invasion_mid", "wh2_dlc15_grn_mon_stone_trolls_0", 1);				-- Monster 3
	random_army_manager:add_mandatory_unit("grom_invasion_mid", "wh2_dlc15_grn_mon_rogue_idol_0", 1);				-- Monster 4

	random_army_manager:new_force("grom_invasion_late");
	random_army_manager:add_mandatory_unit("grom_invasion_late", "wh_main_grn_inf_night_goblins", 4);				-- Infantry 1
	random_army_manager:add_mandatory_unit("grom_invasion_late", "wh_main_grn_inf_night_goblin_fanatics", 4);		-- Infantry 2
	random_army_manager:add_mandatory_unit("grom_invasion_late", "wh_main_grn_inf_night_goblin_fanatics_1", 4);		-- Ranged 1
	random_army_manager:add_mandatory_unit("grom_invasion_late", "wh2_dlc15_grn_mon_river_trolls_0", 2);			-- Monster 1
	random_army_manager:add_mandatory_unit("grom_invasion_late", "wh2_dlc15_grn_veh_snotling_pump_wagon_0", 1);		-- Monster 2
	random_army_manager:add_mandatory_unit("grom_invasion_late", "wh2_dlc15_grn_mon_stone_trolls_0", 1);			-- Monster 3
	random_army_manager:add_mandatory_unit("grom_invasion_late", "wh2_dlc15_grn_mon_rogue_idol_0", 1);				-- Monster 4
	random_army_manager:add_mandatory_unit("grom_invasion_late", "wh_main_grn_mon_arachnarok_spider_0", 1);			-- Monster 5
end

function Eltharion_cinematic_triggers()
	-- core:add_listener(
		-- "Eltha_COA_cine",
		-- "MissionIssued",
		-- function(context)
			-- local check_res = false;
			-- for i = 1, #final_battle_mission_keys do
				-- if context:mission():mission_record_key() == final_battle_mission_keys[i] then
					-- check_res = true;
				-- end
			-- end
			-- return check_res;
		-- end,
		-- function()
			-- core:svr_save_registry_bool("warden_eltharion_call_to_arms", true);
			-- cm:register_instant_movie("warhammer2/hunter/warden_eltharion_call_to_arms");
		-- end,
		-- false
	-- );
	
	core:add_listener(
		"Eltha_WIN_cine",
		"MissionSucceeded",
		function(context)
			local check_res = false;
			for i = 1, #final_battle_mission_keys do
				if context:mission():mission_record_key() == final_battle_mission_keys[i] then
					check_res = true;
					cm:complete_scripted_mission_objective(eltharion_faction_key, "wh_main_long_victory", "complete_eltharion_final_battle", true);
				end
			end
			return check_res;
		end,
		function()
			core:svr_save_registry_bool("warden_eltharion_win", true);
			cm:register_instant_movie("warhammer2/warden/warden_eltharion_win");
		end,
		false
	);
end

function Get_Final_Battle_Key()
	core:svr_save_registry_bool("warden_eltharion_call_to_arms", true);
	cm:register_instant_movie("warhammer2/warden/warden_eltharion_call_to_arms");
	local faction = cm:get_faction(eltharion_faction_key);
	if faction ~= false and faction:pooled_resource_manager():resource("yvresse_defence") then
		local yvresse_defence = faction:pooled_resource_manager():resource("yvresse_defence"):value();
		--out(value"####### yvresse defence value found")
		if yvresse_defence <= 24 then
			return final_battle_mission_keys[1];
		elseif yvresse_defence >= 25 and yvresse_defence <= 49 then
			return final_battle_mission_keys[1];
		elseif yvresse_defence >= 50 and yvresse_defence <= 74 then
			return final_battle_mission_keys[2];
		elseif yvresse_defence >= 75 then
			return final_battle_mission_keys[3];
		end
	end
end

function Setup_final_battle_through_dilemma()
	core:add_listener(
		"Grom_offer_DilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == "wh2_dlc15_hef_grom_invasion_offer";
		end,
		function(context)
			local choice = context:choice();
			if choice == 0 then
				cm:trigger_mission(eltharion_faction_key, Get_Final_Battle_Key(), true);
			end
		end,
		true
	);
end

function Eltharion_CompleteCampaign(value)
	if value then		
		cm:disable_event_feed_events(true, "", "", "faction_campaign_victory_objective_complete");
	else
		cm:disable_event_feed_events(true, "", "", "faction_event_mission_aborted");
	end;
	
	local campaign_type = cm:model():campaign_type();
	
	if campaign_type == 0 then
		out("if this is false then eltharion should lose campaign: "..tostring(value))
		cm:complete_scripted_mission_objective(eltharion_faction_key, "wh_main_long_victory", "final_battle_condition", value);
		cm:complete_scripted_mission_objective(eltharion_faction_key, "wh2_main_vor_domination_victory", "domination", value);
	elseif campaign_type == 4 then
		cm:complete_scripted_mission_objective(eltharion_faction_key, "wh_main_mp_coop_victory", "final_battle_condition", value);
	else
		cm:complete_scripted_mission_objective(eltharion_faction_key, "wh_main_mp_versus_victory", "final_battle_condition", value);
	end;
end;
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("eltharion_grom_timer", eltharion_grom_timer, context);
		cm:save_named_value("eltharion_greenskin_level", eltharion_greenskin_level, context);
		cm:save_named_value("eltharion_relic_level", eltharion_relic_level, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			eltharion_grom_timer = cm:load_named_value("eltharion_grom_timer", eltharion_grom_timer, context);
			eltharion_greenskin_level = cm:load_named_value("eltharion_greenskin_level", eltharion_greenskin_level, context);
			eltharion_relic_level = cm:load_named_value("eltharion_relic_level", eltharion_relic_level, context);
		end
	end
);