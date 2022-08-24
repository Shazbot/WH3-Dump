local shadow_objectives = {
	["wh2_main_skv_clan_eshin"] = 0,
	["wh2_main_def_hag_graef"] = 0
};
local dust_xp_gain = 1200;
local shadow_battle_reminder = false;
local shadow_battle_counter = 0;

function add_shadow_objectives_listeners()
	out("#### Adding Shadow Objectives Listeners ####");

	if cm:model():campaign_name("wh2_main_great_vortex") then
		local player = cm:get_faction("wh2_main_def_hag_graef");

		if cm:is_new_game() == true and player:is_human() == true then
			local faction_list = cm:model():world():faction_list();
	
			for i = 0, faction_list:num_items() - 1 do
				local faction = faction_list:item_at(i);
				if faction:is_human() == false and faction:pooled_resource_manager():resource("wh2_main_ritual_currency"):is_null_interface() == false then
					cm:apply_effect_bundle("wh2_dlc14_bundle_malus_vortex_remove_resource", faction:name(), 0)
				end;
			end;
		end;

		core:add_listener(
			"shadow_FactionTurnStart",
			"FactionTurnStart",
			function(context)
				local faction = context:faction();
				return faction:is_human() == true and faction:name() == "wh2_main_def_hag_graef";
			end,
			function(context)
				shadow_FactionTurnStart(context:faction());
			end,
			true
		);
		core:add_listener(
			"shadow_RitualStartedEvent",
			"RitualStartedEvent",
			function(context)
				local faction = context:performing_faction();
				return faction:is_human() == true and faction:name() == "wh2_main_skv_clan_eshin";
			end,
			function(context)
				shadow_RitualStartedEvent(context);
			end,
			true
		);
		core:add_listener(
			"shadow_MissionSucceeded",
			"MissionSucceeded",
			function(context)
				local faction = context:faction();
				local faction_key = faction:name();
				return faction:is_human() == true and (faction_key == "wh2_main_skv_clan_eshin" or faction_key == "wh2_main_def_hag_graef");
			end,
			function(context)
				local faction = context:faction();
				local mission_key = context:mission():mission_record_key();
				shadow_MissionEnded(faction, mission_key, false);
			end,
			true
		);
		core:add_listener(
			"shadow_MissionCancelled",
			"MissionCancelled",
			function(context)
				local faction = context:faction();
				local faction_key = faction:name();
				return faction:is_human() == true and (faction_key == "wh2_main_skv_clan_eshin" or faction_key == "wh2_main_def_hag_graef");
			end,
			function(context)
				local faction = context:faction();
				local mission_key = context:mission():mission_record_key();
				shadow_MissionEnded(faction, mission_key, true);
			end,
			true
		);
		core:add_listener(
			"shadow_battle_reminder",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == "wh2_main_def_hag_graef" and shadow_battle_reminder;
			end,
			function(context)
				if shadow_battle_counter >= 10 then
					core:trigger_event("ScriptEventMalusVortexReminder");
					shadow_battle_reminder = false;
				else
					shadow_battle_counter = shadow_battle_counter + 1;
				end
			end,
			true
		);
		shadow_SetupArmies();
		shadow_UpdateMalusUI();
	end
end

function shadow_FactionTurnStart(malus_faction)
	local malekith_faction = cm:model():world():faction_by_key("wh2_main_def_naggarond");
	local malekith_amount = 0;

	if malekith_faction:is_null_interface() == false then
		if malekith_faction:pooled_resource_manager():resource("wh2_main_ritual_currency"):is_null_interface() == false then
			malekith_amount = malekith_faction:pooled_resource_manager():resource("wh2_main_ritual_currency"):value();
		end
	end

	local malus_amount = malus_faction:pooled_resource_manager():resource("wh2_main_ritual_currency"):value();
	local total_amount = malus_amount + malekith_amount;

	if shadow_objectives["wh2_main_def_hag_graef"] == 0 then
		if total_amount >= 60 then
			shadow_SpawnMalusEnemy(malus_faction, "shadow_eshin_moulder_malus", 1, 15, "wh2_dlc14_malus_vortex_objective_1", "effect_bundle{bundle_key wh2_dlc14_payload_malus_vortex_objective_1;turns 1;}");
			shadow_objectives["wh2_main_def_hag_graef"] = 1;
			core:trigger_event("ScriptEventMalusVortexOne");
		end
	elseif shadow_objectives["wh2_main_def_hag_graef"] == 1 then
		if total_amount >= 500 then
			shadow_SpawnMalusEnemy(malus_faction, "shadow_eshin_mors_malus", 2, 20, "wh2_dlc14_malus_vortex_objective_2", "effect_bundle{bundle_key wh2_dlc14_payload_malus_vortex_objective_2;turns 1;}");
			shadow_objectives["wh2_main_def_hag_graef"] = 2;
			core:trigger_event("ScriptEventMalusVortexTwo");
		end
	elseif shadow_objectives["wh2_main_def_hag_graef"] == 2 then
		if total_amount >= 1500 then
			shadow_SpawnMalusEnemy(malus_faction, "shadow_eshin_skyre_malus", 3, 20, "wh2_dlc14_malus_vortex_objective_3", "effect_bundle{bundle_key wh2_dlc14_payload_malus_vortex_objective_3;turns 1;}");
			shadow_objectives["wh2_main_def_hag_graef"] = 3;
			core:trigger_event("ScriptEventMalusVortexThree");
		end
	elseif shadow_objectives["wh2_main_def_hag_graef"] == 3 then
		if total_amount >= 3000 then
			shadow_SpawnMalusEnemy(malus_faction, "shadow_eshin_malus", 4, 20, "wh2_dlc14_malus_vortex_objective_4", "effect_bundle{bundle_key wh2_dlc14_payload_malus_vortex_objective_4;turns 1;}");
			shadow_objectives["wh2_main_def_hag_graef"] = 4;
			core:trigger_event("ScriptEventMalusVortexFour");
		end
	elseif shadow_objectives["wh2_main_def_hag_graef"] == 4 then
		if total_amount >= 5000 then
			shadow_objectives["wh2_main_def_hag_graef"] = 5;
			core:trigger_event("ScriptEventMalusVortexFive");
			core:svr_save_registry_bool("shadow_malus_call_to_arms", true);
			cm:register_instant_movie("warhammer2/shadow/shadow_malus_call_to_arms");
			cm:trigger_mission("wh2_main_def_hag_graef", "wh2_dlc14_qb_def_final_battle_malus", true);
			shadow_battle_reminder = true;
		end
	end
end

function shadow_SpawnMalusEnemy(faction, enemy, enemy_count, units, mission, payload)
	local faction_key = faction:name();
	local malus = faction:faction_leader();
	local malus_cqi = malus:command_queue_index();
	local mf_list = faction:military_force_list();
	local target_mf = nil;
	local pos_x, pos_y;

	for i = 1, enemy_count do
		local unit_count = units;
		local spawn_units, enemy_faction = random_army_manager:generate_force(enemy, unit_count, false);
		
		if malus:is_wounded() then
			--if faction leader is wounded then find a different force
			for i = 0, mf_list:num_items() - 1 do
				force = mf_list:item_at(i);
				target_mf = force;
				local force_character = target_mf:general_character():command_queue_index();
				pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_character(enemy_faction, "character_cqi:"..force_character, false, 50);
			end
			-- if there are still no suitable characters to spawn at, then spawn at region instead
			if target_mf == nil then
				local region_list = faction:region_list();
				for i = 0, region_list:num_items() - 1 do
					local region = region_list:item_at(i);
					pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(enemy_faction, region, false, false, 20);
					return;
				end
			end
		else
			pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_character(enemy_faction, "character_cqi:"..malus_cqi, false, 50);
		end
		
		if pos_x == -1 then
			pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_character(enemy_faction, "character_cqi:"..malus_cqi, false);
		end

		if pos_x > -1 then
			if i == 1 then
				local objective_invasion = invasion_manager:new_invasion(mission.."_"..i, enemy_faction, spawn_units, {pos_x, pos_y});
				objective_invasion:set_target("CHARACTER", malus_cqi, faction_key);
				objective_invasion:apply_effect("wh2_dlc14_bundle_objective_invasion", -1);
				objective_invasion.mission_key = mission;

				objective_invasion:start_invasion(
				function(self)
					local force = self:get_force();
					local force_cqi = force:command_queue_index();

					local mm = mission_manager:new("wh2_main_def_hag_graef", self.mission_key);
					mm:set_mission_issuer("CLAN_ELDERS");
					mm:add_new_objective("ENGAGE_FORCE");
					mm:add_condition("cqi "..force_cqi);
					mm:add_condition("requires_victory");
					mm:set_turn_limit(0);
					mm:set_should_whitelist(false);
					mm:add_payload(payload);
					mm:trigger();
					shadow_UpdateMalusUI();
				end, true, false, false);
			else
				local objective_invasion = invasion_manager:new_invasion(mission.."_"..i, enemy_faction, spawn_units, {pos_x, pos_y});
				objective_invasion:set_target("CHARACTER", malus_cqi, faction_key);
				objective_invasion:apply_effect("wh2_dlc14_bundle_objective_invasion", -1);
				objective_invasion:start_invasion(nil, true, false, false);
			end
		else
			script_error("ERROR: Trying to spawn a Vortex mission for Malus, no valid position for enemy army");
		end
	end
end

function shadow_RitualStartedEvent(context)
	local ritual = context:ritual();
	local ritual_key = ritual:ritual_key();
	local faction = context:performing_faction();

	if ritual_key == "wh2_dlc14_eshin_actions_vortex_mission_1" then
		shadow_SpawnSnikchEnemy(faction, "shadow_norsca_snikch", 16, "wh2_dlc14_snikch_vortex_objective_1");
		cm:lock_ritual_chain(faction, "wh2_dlc14_ritual_vortex_eshin");
	elseif ritual_key == "wh2_dlc14_eshin_actions_vortex_mission_2" then
		shadow_SpawnSnikchEnemy(faction, "shadow_beastmen_snikch", 20, "wh2_dlc14_snikch_vortex_objective_2");
		cm:lock_ritual_chain(faction, "wh2_dlc14_ritual_vortex_eshin");
	elseif ritual_key == "wh2_dlc14_eshin_actions_vortex_mission_3" then
		shadow_SpawnSnikchEnemy(faction, "shadow_chaos_snikch", 20, "wh2_dlc14_snikch_vortex_objective_3");
	end
end

function shadow_SpawnSnikchEnemy(faction, enemy, units, mission)
	local faction_key = faction:name();
	local snikch = faction:faction_leader();
	
	local unit_count = units;
	local spawn_units, enemy_faction = random_army_manager:generate_force(enemy, unit_count, false);
	local pos_x = -1;
	local pos_y = -1;
	local region_key = "";
	
	if snikch:has_region() == true then
		local snikch_cqi = snikch:command_queue_index();
		region_key = snikch:region():name();
		pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_character(enemy_faction, "character_cqi:"..snikch_cqi, false, 20);

		if pos_x == -1 then
			pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_character(enemy_faction, "character_cqi:"..snikch_cqi, false);
		end
	elseif faction:has_home_region() == true then
		local home_region = faction:home_region():name();
		region_key = home_region;
		pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(enemy_faction, home_region, false, false, 20);

		if pos_x == -1 then
			pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(enemy_faction, home_region, false, false);
		end
	end

	if pos_x > -1 then
		cm:create_force(
			enemy_faction,
			spawn_units,
			region_key,
			pos_x,
			pos_y,
			true,
			function(char_cqi, force_cqi)
				cm:apply_effect_bundle_to_characters_force("wh2_dlc14_bundle_objective_invasion", char_cqi, 0, true);
				cm:cai_disable_movement_for_character("character_cqi:"..char_cqi);
				cm:force_declare_war(enemy_faction, "wh2_main_skv_clan_eshin", false, false);

				local mm = mission_manager:new("wh2_main_skv_clan_eshin", mission);
				mm:set_mission_issuer("CLAN_ELDERS");
				mm:add_new_objective("ENGAGE_FORCE");
				mm:add_condition("cqi "..force_cqi);
				mm:add_condition("requires_victory");
				mm:set_turn_limit(0);
				mm:set_should_whitelist(false);
				mm:add_payload("effect_bundle{bundle_key wh2_dlc14_payload_snikch_vortex_mission_dummy;turns 1;}")
				mm:trigger();
				shadow_UpdateMalusUI();
			end
		);
	else
		script_error("ERROR: Trying to spawn a Vortex mission for Snikch, no valid position for enemy army");
	end
end

function shadow_MissionEnded(faction, mission_key, aborted)
	local snikch_character = faction:faction_leader();

	if aborted == false and mission_key == "wh2_dlc14_qb_def_final_battle_malus" then
		if shadow_objectives["wh2_main_def_hag_graef"] == 5 then
			core:svr_save_registry_bool("shadow_malus_win", true);
			cm:register_instant_movie("warhammer2/shadow/shadow_malus_win");
			core:trigger_event("MalusWinsFinalBattle");
			shadow_battle_reminder = false;
		end
	end

	if mission_key == "wh2_dlc14_snikch_vortex_objective_1" then
		cm:unlock_ritual_chain(faction, "wh2_dlc14_ritual_vortex_eshin");
	elseif mission_key == "wh2_dlc14_snikch_vortex_objective_2" then
		cm:unlock_ritual_chain(faction, "wh2_dlc14_ritual_vortex_eshin");
	elseif mission_key == "wh2_dlc14_snikch_vortex_objective_3" then
		cm:trigger_mission("wh2_main_skv_clan_eshin", "wh2_dlc14_qb_skv_final_battle_snikch", true);
	elseif aborted == false and mission_key == "wh2_dlc14_qb_skv_final_battle_snikch" then
		cm:apply_effect_bundle("wh2_dlc14_bundle_dust_cap_5", faction, 0);
		cm:apply_effect_bundle_to_character("wh2_dlc14_bundle_snikch_tzarkan", snikch_character, 0);
	end
end

function shadow_UpdateMalusUI()
	local ui_root = core:get_ui_root();
	local malus_vortex_bar = find_uicomponent(ui_root, "malus_vortex_bar");
	
	if malus_vortex_bar then
		malus_vortex_bar:InterfaceFunction("SetPrimaryFaction", "wh2_main_def_naggarond");
		malus_vortex_bar:InterfaceFunction("SetMissionKeys",
		"wh2_dlc14_malus_vortex_objective_1",
		"wh2_dlc14_malus_vortex_objective_2",
		"wh2_dlc14_malus_vortex_objective_3",
		"wh2_dlc14_malus_vortex_objective_4",
		"wh2_dlc14_malus_vortex_objective_5");
	end
end

function shadow_SetupArmies()
	-- Snikch Enemies
	random_army_manager:new_force("shadow_norsca_snikch");
	random_army_manager:set_faction("shadow_norsca_snikch", "wh2_main_nor_skeggi");
	random_army_manager:add_mandatory_unit("shadow_norsca_snikch", "wh_main_nor_mon_chaos_warhounds_1", 2);
	random_army_manager:add_mandatory_unit("shadow_norsca_snikch", "wh_main_nor_cav_marauder_horsemen_0", 1);
	random_army_manager:add_mandatory_unit("shadow_norsca_snikch", "wh_main_nor_mon_chaos_trolls", 1);
	random_army_manager:add_mandatory_unit("shadow_norsca_snikch", "wh_dlc08_nor_mon_norscan_giant_0", 1);
	random_army_manager:add_unit("shadow_norsca_snikch", "wh_dlc08_nor_inf_marauder_spearman_0", 1);	
	random_army_manager:add_unit("shadow_norsca_snikch", "wh_main_nor_inf_chaos_marauders_0", 1);
	random_army_manager:add_unit("shadow_norsca_snikch", "wh_dlc08_nor_inf_marauder_hunters_1", 1);
	random_army_manager:add_unit("shadow_norsca_snikch", "wh_main_nor_inf_chaos_marauders_1", 1);
	
	random_army_manager:new_force("shadow_beastmen_snikch");
	random_army_manager:set_faction("shadow_beastmen_snikch", "wh2_main_bst_ripper_horn");
	random_army_manager:add_mandatory_unit("shadow_beastmen_snikch", "wh_dlc03_bst_inf_cygor_0", 2);
	random_army_manager:add_mandatory_unit("shadow_beastmen_snikch", "wh_dlc03_bst_mon_giant_0", 1);
	random_army_manager:add_mandatory_unit("shadow_beastmen_snikch", "wh_dlc03_bst_inf_minotaurs_0", 2);
	random_army_manager:add_mandatory_unit("shadow_beastmen_snikch", "wh_dlc03_bst_inf_minotaurs_1", 2);
	random_army_manager:add_mandatory_unit("shadow_beastmen_snikch", "wh_dlc03_bst_inf_centigors_1", 1);
	random_army_manager:add_mandatory_unit("shadow_beastmen_snikch", "wh_dlc03_bst_inf_centigors_0", 1);
	random_army_manager:add_unit("shadow_beastmen_snikch", "wh_dlc03_bst_feral_manticore", 1);	
	random_army_manager:add_unit("shadow_beastmen_snikch", "wh_dlc03_bst_inf_gor_herd_1", 4);
	random_army_manager:add_unit("shadow_beastmen_snikch", "wh_dlc03_bst_inf_gor_herd_0", 4);
	random_army_manager:add_unit("shadow_beastmen_snikch", "wh_dlc03_bst_inf_ungor_spearmen_1", 4);
	random_army_manager:add_unit("shadow_beastmen_snikch", "wh_dlc03_bst_inf_ungor_spearmen_0", 4);
	
	random_army_manager:new_force("shadow_chaos_snikch");
	random_army_manager:set_faction("shadow_chaos_snikch", "wh2_main_rogue_def_chs_vashnaar");
	random_army_manager:add_mandatory_unit("shadow_chaos_snikch", "wh_dlc01_chs_mon_dragon_ogre_shaggoth", 1);
	random_army_manager:add_mandatory_unit("shadow_chaos_snikch", "wh_dlc01_chs_mon_dragon_ogre", 2);
	random_army_manager:add_mandatory_unit("shadow_chaos_snikch", "wh_main_chs_cav_chaos_knights_1", 2);
	random_army_manager:add_mandatory_unit("shadow_chaos_snikch", "wh_dlc01_chs_inf_chosen_2", 2);
	random_army_manager:add_mandatory_unit("shadow_chaos_snikch", "wh_main_chs_inf_chosen_1", 2);
	random_army_manager:add_mandatory_unit("shadow_chaos_snikch", "wh_main_chs_art_hellcannon", 1);
	random_army_manager:add_unit("shadow_chaos_snikch", "wh_main_chs_inf_chaos_warriors_1", 5);	
	random_army_manager:add_unit("shadow_chaos_snikch", "wh_dlc01_chs_inf_chaos_warriors_2", 5);
	random_army_manager:add_unit("shadow_chaos_snikch", "wh_main_chs_inf_chosen_0", 5);	
	random_army_manager:add_unit("shadow_chaos_snikch", "wh_dlc01_chs_inf_forsaken_0", 2);
	random_army_manager:add_unit("shadow_chaos_snikch", "wh_main_chs_mon_trolls", 2);
	random_army_manager:add_unit("shadow_chaos_snikch", "wh_main_chs_cav_chaos_chariot", 1);


	-- Malus Enemies
	random_army_manager:new_force("shadow_eshin_moulder_malus");
	random_army_manager:set_faction("shadow_eshin_moulder_malus", "wh2_main_skv_clan_moulder");
	random_army_manager:add_mandatory_unit("shadow_eshin_moulder_malus", "wh2_main_skv_mon_rat_ogres", 4);
	random_army_manager:add_unit("shadow_eshin_moulder_malus", "wh2_main_skv_inf_skavenslaves_0", 1);	
	random_army_manager:add_unit("shadow_eshin_moulder_malus", "wh2_main_skv_inf_skavenslave_slingers_0", 1);
	random_army_manager:add_unit("shadow_eshin_moulder_malus", "wh2_main_skv_inf_clanrats_0", 1);
	random_army_manager:add_unit("shadow_eshin_moulder_malus", "wh2_main_skv_inf_clanrats_1", 1);
	 
	random_army_manager:new_force("shadow_eshin_mors_malus");
	random_army_manager:set_faction("shadow_eshin_mors_malus", "wh2_main_skv_clan_mors");
	random_army_manager:add_mandatory_unit("shadow_eshin_mors_malus", "wh2_main_skv_inf_stormvermin_0", 4);
	random_army_manager:add_mandatory_unit("shadow_eshin_mors_malus", "wh2_main_skv_inf_stormvermin_1", 4);
	random_army_manager:add_mandatory_unit("shadow_eshin_mors_malus", "wh2_main_skv_mon_rat_ogres", 1);
	random_army_manager:add_unit("shadow_eshin_mors_malus", "wh2_main_skv_inf_clanrats_1", 1);
	random_army_manager:add_unit("shadow_eshin_mors_malus", "wh2_main_skv_inf_clanrat_spearmen_1", 1);
		
	random_army_manager:new_force("shadow_eshin_skyre_malus");
	random_army_manager:set_faction("shadow_eshin_skyre_malus", "wh2_main_skv_clan_skyre");
	random_army_manager:add_mandatory_unit("shadow_eshin_skyre_malus", "wh2_main_skv_art_warp_lightning_cannon", 2);
	random_army_manager:add_mandatory_unit("shadow_eshin_skyre_malus", "wh2_main_skv_veh_doomwheel", 2);
	random_army_manager:add_mandatory_unit("shadow_eshin_skyre_malus", "wh2_main_skv_mon_rat_ogres", 1);
	random_army_manager:add_unit("shadow_eshin_skyre_malus", "wh2_dlc12_skv_inf_ratling_gun_0", 1);	
	random_army_manager:add_unit("shadow_eshin_skyre_malus", "wh2_dlc12_skv_inf_warplock_jezzails_0", 1);
	random_army_manager:add_unit("shadow_eshin_skyre_malus", "wh2_main_skv_inf_clanrat_spearmen_0", 2); 
	random_army_manager:add_unit("shadow_eshin_skyre_malus", "wh2_main_skv_inf_clanrats_0", 2);	
	random_army_manager:add_unit("shadow_eshin_skyre_malus", "wh2_main_skv_inf_clanrats_1", 2); 
	random_army_manager:add_unit("shadow_eshin_skyre_malus", "wh2_main_skv_inf_clanrat_spearmen_1", 2); 
	 
	random_army_manager:new_force("shadow_eshin_malus");
	random_army_manager:set_faction("shadow_eshin_malus", "wh2_main_skv_clan_eshin");
	random_army_manager:add_mandatory_unit("shadow_eshin_malus", "wh2_dlc14_skv_inf_eshin_triads_0", 4);
	random_army_manager:add_mandatory_unit("shadow_eshin_malus", "wh2_main_skv_art_warp_lightning_cannon", 2);
	random_army_manager:add_mandatory_unit("shadow_eshin_malus", "wh2_main_skv_mon_rat_ogres", 1);
	random_army_manager:add_unit("shadow_eshin_malus", "wh2_dlc14_skv_inf_poison_wind_mortar_0", 1);	
	random_army_manager:add_unit("shadow_eshin_malus", "wh2_main_skv_inf_death_globe_bombardiers", 1);
	random_army_manager:add_unit("shadow_eshin_malus", "wh2_main_skv_inf_death_runners_0", 2); 
	random_army_manager:add_unit("shadow_eshin_malus", "wh2_main_skv_inf_gutter_runner_slingers_1", 2);	
	random_army_manager:add_unit("shadow_eshin_malus", "wh2_main_skv_inf_gutter_runners_1", 2); 
	random_army_manager:add_unit("shadow_eshin_malus", "wh2_main_skv_inf_stormvermin_1", 2); 
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("shadow_objectives", shadow_objectives, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			shadow_objectives = cm:load_named_value("shadow_objectives", shadow_objectives, context);
		end
	end
);