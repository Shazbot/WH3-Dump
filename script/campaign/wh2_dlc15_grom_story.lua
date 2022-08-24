
--the mist murderers are scripted armies of due strength will spawn near grom's army and chase him when he steps in mist(Ulthuan).
--notice there's also a peoredic mist murderer sent to Grom's capital
local Grom_faction = "wh2_dlc15_grn_broken_axe";
local Mist_murderer_faction = "wh2_main_hef_yvresse";
local Eltharion_faction = "wh2_main_hef_yvresse";

local Mist_murderer_trait = {"wh2_dlc15_trait_mistwalker_shadow", "wh2_dlc15_trait_mistwalker_sentinel", "wh2_dlc15_trait_mistwalker_watcher"};
local Mist_murderer_effect = {"wh2_dlc14_bundle_objective_invasion", "wh2_dlc14_bundle_objective_invasion", "wh2_dlc14_bundle_objective_invasion"};
local Mist_murderer_count = 1;
--the list is where we keep track of who's currently being chased by which mist murderer invasion, this could potentionally be used to remove the force when their target is done
local Mist_murder_list = {};
local Mist_murderer_count_down = 5;
local Mist_murderer_cooldown = 15;
local Mist_murderer_progress = {
	{0 ,"mist_murderer_0", 1},
	{30, "mist_murderer_1", 2},
	{60, "mist_murderer_2", 2}
};

local Ulthuan_regions = {
	"wh3_main_combi_region_vauls_anvil_ulthuan",
	"wh3_main_combi_region_tor_sethai",
	"wh3_main_combi_region_whitepeak",
	"wh3_main_combi_region_tor_anroc",
	"wh3_main_combi_region_avethir",
	"wh3_main_combi_region_tor_dranil",
	"wh3_main_combi_region_tor_anlec",
	"wh3_main_combi_region_shrine_of_khaine",
	"wh3_main_combi_region_tor_achare",
	"wh3_main_combi_region_elisia",
	"wh3_main_combi_region_shrine_of_kurnous",
	"wh3_main_combi_region_mistnar",
	"wh3_main_combi_region_tor_koruali",
	"wh3_main_combi_region_tor_yvresse",
	"wh3_main_combi_region_elessaeli",
	"wh3_main_combi_region_tralinia",
	"wh3_main_combi_region_shrine_of_loec",
	"wh3_main_combi_region_cairn_thel",
	"wh3_main_combi_region_lothern",
	"wh3_main_combi_region_tower_of_lysean",
	"wh3_main_combi_region_tor_elyr",
	"wh3_main_combi_region_eagle_gate",
	"wh3_main_combi_region_whitefire_tor",
	"wh3_main_combi_region_griffon_gate",
	"wh3_main_combi_region_evershale",
	"wh3_main_combi_region_unicorn_gate",
	"wh3_main_combi_region_phoenix_gate",
	"wh3_main_combi_region_tor_saroir",
	"wh3_main_combi_region_gaean_vale",
	"wh3_main_combi_region_tor_finu",
	"wh3_main_combi_region_white_tower_of_hoeth",
	"wh3_main_combi_region_port_elistor",
	"wh3_main_combi_region_angerrial",
	"wh3_main_combi_region_shrine_of_asuryan"
};

-- blacktoof missions and prophecies seesion --
--blacktoof misiosns, this is the genuine sequence of how they are executed
local BlacktoofMissions = {"wh2_dlc15_grn_grom_black_toof_1", "wh2_dlc15_grn_grom_black_toof_2", "wh2_dlc15_grn_grom_black_toof_3", "wh2_dlc15_grn_grom_black_toof_3_2", "wh2_dlc15_grn_grom_black_toof_4", "wh2_dlc15_grn_grom_black_toof_5"
};
--overriding the mission key for mortal empire, the final battle shouldn't happen in it. add your overwrite if u need one
local BlacktoofMissions_ME_override = {"", "", "", "", "", "wh2_dlc15_grn_grom_black_toof_5_ME"
};
--this is the mission objective for scripted missions, if not scripted, please leave empty string
local BlacktoofMissionsStrings = {"", "wh2_dlc15_obejctive_grom_mission_2", "wh2_dlc15_obejctive_grom_mission_3", "wh2_dlc15_obejctive_grom_mission_3_2", "wh2_dlc15_obejctive_grom_mission_4", ""
};
--this is the payloads
local BlacktoofMissionsPayload = {{}, {"faction_pooled_resource_transaction{resource grn_salvage;factor looting;amount 100;context absolute;}", "money 1200"}, {"faction_pooled_resource_transaction{resource grn_salvage;factor looting;amount 150;context absolute;}", "money 1500"}, {"effect_bundle{bundle_key wh2_dlc15_grom_unlock_special_recipe;turns 0;}", "money 1500"}, {"effect_bundle{bundle_key wh2_dlc15_grn_narration_groms_ready;turns 0;}"}, {}
};
--keeps track of blacktoofmission progress
local BlacktoofMissionsCurrent = 1;
--blacktoof's prophecies tracker, currently they all fire at once, alternatively we random these mission, we keep a list of em
local BlacktoofProphecies = {1, 2 ,3};
--potentially we'll do it randomly at 3 interval of the campaign, this is to define that interval
local BlacktoofPropheciesInterval = {20, 35, 50};

--yvrese block mechnism, this keeps the state through games if we should block it or it's currently being block
local ShouldLockYvresse = false;
local BlockingYvresse = false;

function add_grom_story_listeners()
	out("#### Adding Grom Story Listeners ####");
	--don't do anything if grom is not player
	if not cm:get_faction(Grom_faction) or (cm:get_faction(Grom_faction) and not cm:get_faction(Grom_faction):is_human()) then
		return;
	end
	
	out("setup grom's stuff");
	setup_mist_murderer_template();

	--start blacktoof quest chain and apply yvress block mechanic(only for vortex)
	local turn_blacktoof_mission = 2;
	if cm:model():turn_number() <= turn_blacktoof_mission then
		core:add_listener(
			"Grom_starts_campaign",
			"FactionTurnStart", 
			function(context)
				if context:faction():name() == Grom_faction and cm:model():turn_number() == turn_blacktoof_mission then
					return true;
				else
					return false;
				end
			end,
			function(context)
				local faction = context:faction();
				--setup the blacktoof guild-mission
				cm:trigger_mission(Grom_faction, "wh2_dlc15_grn_grom_black_toof_1", true);
				core:trigger_event("BlackToofMissionIssued");
			end,
			false
		);
	end
	
	--setup mist murderers only when playing grom against AI
	if not cm:get_faction(Eltharion_faction):is_null_interface() and not cm:get_faction(Eltharion_faction):is_human() then
		--block yvresse if it happens
		if cm:is_new_game() then
			--initial setup at beginning of campaign
			ShouldLockYvresse = false;
		else
			-- do nothing
		end
		cm:add_faction_turn_start_listener_by_name(
			"Spawning_mist_murderers",
			Grom_faction,
			function(context)
				--send periodic challenger to grom
				refresh_murderer_target();
			end,
			true
		);
	
		--to remove a mist murderer after battle, and from the murder list
		core:add_listener(
		"remove_mist_murders",
		"BattleCompleted",
		function()
			return cm:model():pending_battle():has_been_fought();
		end,
		function()
			local mist_murderer_included_in_battle = {	["atk"] = {},
														["def"] = {}
														};
			local mist_murder_target_included_in_battle = {	["atk"] = {},
															["def"] = {}
														};
			for i = 1, cm:pending_battle_cache_num_attackers() do
				local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
				local character = cm:get_character_by_cqi(this_char_cqi);
				for i=1,#Mist_murder_list do
					if this_char_cqi == Mist_murder_list[i][1] then
						--u found the murderer
						table.insert(mist_murderer_included_in_battle["atk"], i);
					elseif this_char_cqi == Mist_murder_list[i][2] then
						table.insert(mist_murder_target_included_in_battle["atk"], i);
					end
				end
			end
			
			for i = 1, cm:pending_battle_cache_num_defenders() do
				local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_num_defenders(i);
				local character = cm:get_character_by_cqi(this_char_cqi);
				for i=1,#Mist_murder_list do
					if this_char_cqi == Mist_murder_list[i][1] then
						--u found the murderer
						table.insert(mist_murderer_included_in_battle["def"], i);
					elseif this_char_cqi == Mist_murder_list[i][2] then
						table.insert(mist_murder_target_included_in_battle["def"], i);
					end
				end
			end
			
			--delete the invasion accordingly
			--remove_mist_murderers();
				
		end,
		true
		);
	
	end
	
	--setup blacktoof scripted missions
	if BlacktoofMissionsCurrent <= #BlacktoofMissions then
		core:add_listener(
			"follow_up_mission_trigger_blacktoof_mission",
			"MissionSucceeded",
			function(context)
				return true;
			end,
			function(context)
				local check_result = false;
				local mission_key = context:mission():mission_record_key();
				--trigger the scripted missions
				for i = 1, #BlacktoofMissions-1 do
					if mission_key == BlacktoofMissions[i] then
						trigger_black_toof_mission(i+1);
					end;
				end;
				--setup the last stage of blacktoof missions
				--give yvresse to grom if not
				--remove yvresse block after final battle
				if mission_key == BlacktoofMissions[#BlacktoofMissions] then
					core:remove_listener("Yvresse_block_listerner_for_player");
					cm:remove_effect_bundle("wh2_dlc15_grom_yvresse_blockade", Grom_faction);
					ShouldLockYvresse = false;
				end	
				--trigger blacktoof's prophecy
				if mission_key == BlacktoofMissions[#BlacktoofMissions - 2] then
					for i = 1, #BlacktoofProphecies do
						setup_black_toofs_prophecies(BlacktoofProphecies[i]);
					end
				end	
				--trigger the special blacktoof revenge objective
				if mission_key == "wh2_dlc15_grn_grom_black_toof_4" then
					cm:complete_scripted_mission_objective(Grom_faction, "wh_main_long_victory", "complete_blacktoof_revenge", true);
				end	
			end,
		true
		);
		setup_black_toof_mission_listener(BlacktoofMissionsCurrent);
	end
	setup_black_toof_prophecies_listener();
	
	
	
	--listener to find and disable occupation for Yvresse
	core:add_listener(
			"Yvresse_block_listerner_for_player",
			"ScriptEventPendingBattle",
			function(context)
				--check if this is yvresse siege battle
				local all_attacker_char_cqi, all_defender_char_cqi, grom_atking, grom_defing, in_yvresse = get_grom_enemies_from_battle();
				
				if BlockingYvresse == true then
					local uim = cm:get_campaign_ui_manager();
					uim:override("occupy_button"):unlock();
					uim:override("loot_button"):unlock();
					BlockingYvresse = false;
				end
				if context:pending_battle():siege_battle() and in_yvresse and ShouldLockYvresse then
					return true;
				else
					return false;
				end
			end,
			function(context)
				local uim = cm:get_campaign_ui_manager();
				uim:override("occupy_button"):lock();
				uim:override("loot_button"):lock();
				BlockingYvresse = true;
			end,
		true
		);
	
	if ShouldLockYvresse == false then
		core:remove_listener("Yvresse_block_listerner_for_player");
		cm:remove_effect_bundle("wh2_dlc15_grom_yvresse_blockade", Grom_faction);
	end


	-- Apply Doom Diver ability in the Final Battle Quest Battle
	core:add_listener(
		"FinalBattleGrom_ArmyAbilities",
		"PendingBattle",
		function()
			local pb = cm:model():pending_battle();
			return pb:set_piece_battle_key():find("wh2_dlc15_qb_grn_final_battle_grom");
		end,
		function()
			local pb = cm:model():pending_battle();
			
			local attacker = pb:attacker();
			local attacker_cqi = attacker:military_force():command_queue_index();
				
			out.design("Granting army abilities to attacker belonging to " .. attacker:faction():name());
				
			cm:apply_effect_bundle_to_force("wh2_dlc15_bundle_doom_diver_strike_army_ability", attacker_cqi, 0);
			cm:update_pending_battle();
		end,
		true
	);


	-- player completes the quest battle
	core:add_listener(
		"FinalBattleGrom_BattleCompleted",
		"BattleCompleted",
		function()
			local pb = cm:model():pending_battle();
			return pb:set_piece_battle_key():find("wh2_dlc15_qb_grn_final_battle_grom");
		end,
		function()
			local pb = cm:model():pending_battle();
			
			local attacker = pb:attacker();
			local char_cqi = false;
			local mf_cqi = false;
			local faction_name = false;
			local has_been_fought = pb:has_been_fought();
			
			if has_been_fought then
				-- if the battle was fought, the attacker may have died, so get them from the pending battle cache
				char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(1);
			else
				-- if the player retreated, the pending battle cache won't have stored the attacker, so get it from the attacker character (who should still be alive as they retreated!)
				faction_name = attacker:faction():name();
			end;

			-- player has completed Grom Final Battle QB
			if attacker then
				-- remove army ability effect bundle
				cm:remove_effect_bundle_from_force("wh2_dlc15_bundle_doom_diver_strike_army_ability", attacker:military_force():command_queue_index());
			end;
		end,
		true
	);

end

function setup_random_black_toofs_prophecies()
	local rand = cm:random_number(#BlacktoofProphecies);
	setup_black_toofs_prophecies(rand);
	table.remove(BlacktoofProphecies, rand);
end

--this will setup 1 of the 3 prophecies from blacktoof
function setup_black_toofs_prophecies(index)
	if index == 1 then
		setup_black_toofs_scripted_prophecies();
	elseif index == 2 then
		cm:trigger_mission(Grom_faction, "wh2_dlc15_grom_blacktoof_prophecy_1", true);
	elseif index == 3 then
		cm:trigger_mission(Grom_faction, "wh2_dlc15_grom_blacktoof_prophecy_2", true);
	end
end

function setup_black_toofs_scripted_prophecies()
	local mission_key = "wh2_dlc15_grom_blacktoof_prophecy_0";
	local script_key = "prophecies_0";
	local condition = "wh2_dlc15_obejctive_grom_mission_extra";
	local reward = {"effect_bundle{bundle_key wh2_dlc15_grom_unlock_special_recipe;turns 0;}", "money 8000"};
	local mm = mission_manager:new(Grom_faction, mission_key);
	mm:add_new_objective("SCRIPTED");
	mm:add_condition("script_key "..script_key);
	--mm:add_condition("override_text mission_text_text_".."wh2_dlc11_objective_override_lokhir_sen_encounter");
	mm:add_condition("override_text mission_text_text_"..condition);
	mm:set_mission_issuer("BLACK_TOOF");

	for i = 1, #reward do
		mm:add_payload(reward[i]);
	end
	
	mm:set_should_whitelist(false);
	mm:trigger();
	
	setup_black_toof_prophecies_listener();
end

function setup_black_toof_prophecies_listener()
	core:add_listener(
		"wh2_dlc15_grom_blacktoof_prophecy_0",
		"GromUnlockedAllTheCauldronSlots",
		function(context)
			return true;
		end,
		function(context)
			cm:complete_scripted_mission_objective(Grom_faction, "wh2_dlc15_grom_blacktoof_prophecy_0", "prophecies_0", true);
		end,
	true
	);
end

function refresh_murderer_target()
	local list_to_remove = {};
	for i = 1, #Mist_murder_list do
		local mist_murderer = invasion_manager:get_invasion(Mist_murder_list[i][3]);
		if mist_murderer == nil then
			table.insert(list_to_remove, i);
		else
			if mist_murderer:has_target() then
				--do nothing
			else
				mist_murderer:set_target("REGION",  cm:get_faction(Grom_faction):home_region():name(), Grom_faction);
			end
		end
	end
	local counter = 0;
	for i = 1, #list_to_remove do
		table.remove(Mist_murder_list, list_to_remove[i-counter]);
		counter = counter + 1;
	end
end

function remove_mist_murderers(index_to_remove)
	local cache_list = {};
	for i = 1, #Mist_murder_list do
		local check_res = false;
		for j = 1, #index_to_remove do
			if i == index_to_remove[j] then
				check_res = true
			end
		end
		if check_res then
			--do no thing
		else
			table.insert(cache_list, Mist_murder_list[i]);
		end
	end
	Mist_murder_list = cache_list;
end


function trigger_black_toof_mission(index)
	if index > #BlacktoofMissions then
		out("trying to trigger blacktoof mission but out of index");
		return;
	else
		BlacktoofMissionsCurrent = index;
		setup_black_toof_scripted_mission(BlacktoofMissionsCurrent);
	end
end

function setup_black_toof_scripted_mission(index)
	local mission_record = BlacktoofMissions[index];
	if BlacktoofMissions_ME_override[index] ~= "" then
		mission_record = BlacktoofMissions_ME_override[index];
	end
	if index == #BlacktoofMissions then
		cm:trigger_mission(Grom_faction, mission_record, true);
	elseif BlacktoofMissionsStrings[index] ~= {} then
		local mission_key = mission_record;
		local mm = mission_manager:new(Grom_faction, mission_key);
		mm:add_new_objective("SCRIPTED");
		mm:add_condition("script_key grom_mission_"..tostring(index));
		--mm:add_condition("override_text mission_text_text_".."wh2_dlc11_objective_override_lokhir_sen_encounter");
		
		mm:add_condition("override_text mission_text_text_"..BlacktoofMissionsStrings[index]);

		for i = 1, #BlacktoofMissionsPayload[index] do
			mm:add_payload(BlacktoofMissionsPayload[index][i]);
		end
		mm:set_should_whitelist(false);
		mm:trigger();
		
		setup_black_toof_mission_listener(index);
	end
end

function setup_black_toof_mission_listener(index)
	if index == 2 then
		--listen to the event when a dish is cooked
		core:add_listener(
			"balcktoof_listerner"..index,
			"FactionCookedDish",
			function(context)
				return true;
			end,
			function(context)
				cm:complete_scripted_mission_objective(Grom_faction, BlacktoofMissions[index], "grom_mission_"..tostring(index), true);
			end,
		true
		);
	elseif index == 3 then
		--listen to the event when a food merchant is met
		core:add_listener(
			"balcktoof_listerner"..index,
			"ScriptEventGromsCauldronGromMeetsTheFoodMerchantress",
			function(context)
				return true;
			end,
			function(context)
				cm:complete_scripted_mission_objective(Grom_faction, BlacktoofMissions[index], "grom_mission_"..tostring(index), true);
			end,
		true
		);	
	elseif index == 4 then
		--listen to the event when a food merchant is met
		core:add_listener(
			"balcktoof_listerner"..index,
			"GromHasUnlockedEnoughIngredients",
			function(context)
				return true;
			end,
			function(context)
				cm:complete_scripted_mission_objective(Grom_faction, BlacktoofMissions[index], "grom_mission_"..tostring(index), true);
			end,
		true
		);
	elseif index == 5 then
		--listen to the event when Grom's trait is lv3
		core:add_listener(
			"balcktoof_listerner"..index,
			"GromEatenEnoughRecipes",
			function(context)
				return true;
			end,
			function(context)
				cm:complete_scripted_mission_objective(Grom_faction, BlacktoofMissions[index], "grom_mission_"..tostring(index), true);
			end,
		true
		);
	else
		out("trying to trigger blacktoof mission listener but out of index");
		return;
	end
	
end

function setup_mist_murderer_template()
	random_army_manager:new_force("mist_murderer_0");
	random_army_manager:add_mandatory_unit("mist_murderer_0", "wh2_main_hef_inf_spearmen_0", 6);
	random_army_manager:add_mandatory_unit("mist_murderer_0", "wh2_dlc15_hef_inf_mistwalkers_sentinels_0", 2);
	random_army_manager:add_mandatory_unit("mist_murderer_0", "wh2_dlc15_hef_inf_silverin_guard_0", 2);
	random_army_manager:add_mandatory_unit("mist_murderer_0", "wh2_main_hef_inf_archers_1", 4);
	random_army_manager:add_unit("mist_murderer_0", "wh2_dlc15_hef_mon_war_lions_of_chrace_0", 1);
	random_army_manager:add_unit("mist_murderer_0", "wh2_main_hef_inf_archers_1", 2);
	random_army_manager:add_unit("mist_murderer_0", "wh2_main_hef_art_eagle_claw_bolt_thrower", 1);
	
	random_army_manager:new_force("mist_murderer_1");
	random_army_manager:add_mandatory_unit("mist_murderer_1", "wh2_dlc15_hef_inf_mistwalkers_sentinels_0", 3);
	random_army_manager:add_mandatory_unit("mist_murderer_1", "wh2_main_hef_inf_spearmen_0", 2);
	random_army_manager:add_mandatory_unit("mist_murderer_1", "wh2_dlc15_hef_inf_silverin_guard_0", 4);
	random_army_manager:add_mandatory_unit("mist_murderer_1", "wh2_dlc15_hef_inf_mistwalkers_griffon_knights_0", 2);
	random_army_manager:add_mandatory_unit("mist_murderer_1", "wh2_main_hef_inf_archers_1", 2);
	random_army_manager:add_unit("mist_murderer_1", "wh2_main_hef_cav_ellyrian_reavers_1", 2);
	random_army_manager:add_unit("mist_murderer_1", "wh2_dlc15_hef_mon_war_lions_of_chrace_0", 2);
	random_army_manager:add_unit("mist_murderer_1", "wh2_main_hef_cav_tiranoc_chariot", 2);
	random_army_manager:add_unit("mist_murderer_1", "wh2_main_hef_art_eagle_claw_bolt_thrower", 1);
	
	random_army_manager:new_force("mist_murderer_2");
	random_army_manager:add_mandatory_unit("mist_murderer_2", "wh2_dlc15_hef_inf_mistwalkers_faithbearers_0", 4);
	random_army_manager:add_mandatory_unit("mist_murderer_2", "wh2_dlc15_hef_inf_mistwalkers_skyhawks_0", 4);
	random_army_manager:add_mandatory_unit("mist_murderer_2", "wh2_dlc15_hef_inf_silverin_guard_0", 4);
	random_army_manager:add_mandatory_unit("mist_murderer_2", "wh2_dlc15_hef_inf_mistwalkers_griffon_knights_0", 4);
	random_army_manager:add_unit("mist_murderer_2", "wh2_dlc15_hef_mon_arcane_phoenix_0", 1);
	random_army_manager:add_unit("mist_murderer_2", "wh2_main_hef_cav_dragon_princes", 2);
	random_army_manager:add_unit("mist_murderer_2", "wh2_dlc15_hef_veh_lion_chariot_of_chrace_0", 2);
	random_army_manager:add_unit("mist_murderer_2", "wh2_main_hef_cav_tiranoc_chariot", 2);
end

function spawn_a_mist_murderer(target, target_region_key, goes_to_the_list)
	local unit_list = random_army_manager:generate_force("mist_murderer_0", 18);
	cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
	for i = 1, #Mist_murderer_progress do
		if cm:model():turn_number() > Mist_murderer_progress[i][1] then
			unit_list = random_army_manager:generate_force(Mist_murderer_progress[i][2], 18);
		end
	end
	
	--do nothing if Grom is not there, or it is multiplayer campaign
	if cm:get_faction(Grom_faction):is_null_interface() or cm:get_faction(Grom_faction):home_region():is_null_interface() or cm:is_multiplayer() then
		return
	end
	
	local force_leader = nil;
	local radius = 6;
	local radius_yvresse = 9;
	local target_char_cqi = 0;
	local target_region = "";
	if target ~= nil then
		--this force will target certain character_cqi
		target_char_cqi = cm:get_military_force_by_cqi(target):general_character():command_queue_index();
	elseif target_region_key == nil then
		--this force will target grom's capital	
		target_region = cm:get_faction(Grom_faction):home_region():name();
	else
		--this force will target provided region
		target_region = target_region_key;
	end
	local loc = {-1, -1};
	if target == nil and cm:model():campaign_name("main_warhammer") then	
		loc[1], loc[2] = cm:find_valid_spawn_location_for_character_from_position(Mist_murderer_faction, 315, 336, true, radius_yvresse);
	else
		loc[1], loc[2] = cm:find_valid_spawn_location_for_character_from_character(Mist_murderer_faction, "character_cqi:"..target_char_cqi, true, radius);
	end
	--loca[1], loc[2] = {282, 272};
	local Mist_murderer = nil;
	local Mist_murderer_type = cm:random_number(#Mist_murderer_trait);
	Mist_murderer = invasion_manager:new_invasion("Mist_murderer_NO_"..tostring(Mist_murderer_count), Mist_murderer_faction, unit_list, loc);
	Mist_murderer.target = Grom_faction;
	Mist_murderer.human = false;
	Mist_murderer:apply_effect(Mist_murderer_effect[Mist_murderer_type], 0);
	Mist_murderer:start_invasion(
		function(self)
			force_leader = self:get_general();
			if not force_leader:region():is_null_interface() then
				cm:make_region_visible_in_shroud(Grom_faction, force_leader:region():name());
			end;
			
			cm:force_add_trait("character_cqi:"..force_leader:command_queue_index(), Mist_murderer_trait[Mist_murderer_type], true);
					
			cm:force_declare_war(Mist_murderer_faction, Grom_faction, false, false, false);
			
			if target == nil then
				Mist_murderer:set_target("REGION",  target_region, Grom_faction);
			else
				Mist_murderer:set_target("CHARACTER", target_char_cqi, Grom_faction);
			end
			
			if goes_to_the_list == true and target ~= nil then
				table.insert(Mist_murder_list, {force_leader:command_queue_index(), target_char_cqi, "Mist_murderer_NO_"..tostring(Mist_murderer_count)});
			end
				
			--the event feed for spawning the army
			cm:show_message_event_located(
				Grom_faction,
				"event_feed_strings_text_wh2_dlc15_event_feed_string_scripted_event_mist_murderer_"..tostring(Mist_murderer_type).."_title",
				"event_feed_strings_text_wh2_dlc15_event_feed_string_scripted_event_mist_murderer_"..tostring(Mist_murderer_type).."_primary_detail",
				"event_feed_strings_text_wh2_dlc15_event_feed_string_scripted_event_mist_murderer_"..tostring(Mist_murderer_type).."_secondary_detail",
				loc[1], 
				loc[2],
				false,
				1312
			);
		end,
		false,
		false,
		false
	);
	Mist_murderer_count = Mist_murderer_count + 1;
	cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 1);
end

function check_element_in_table(element, tab)
	for i = 1, #tab do
		if element == tab[i] then
			return true;
		end
	end
	return false;
end

function remove_element_in_table(element, tab)
	for i = 1, #tab do
		if element == tab[i] then
			table.remove(tab, i);
		end
	end
end

function check_grom_forces()
	local grom_faction_interface = cm:get_faction(Grom_faction);
	local grom_army_list = grom_faction_interface:military_force_list();
	local army_in_ulthuan = {};
	if cm:model():turn_number() == 1 then
		return army_in_ulthuan;
	end
	for i = 1, grom_army_list:num_items() do
		local current_force = grom_army_list:item_at(i-1);
		local region_name = current_force:general_character():region():name();
		
		--check if this force is in ulthuan
		if not current_force:is_armed_citizenry() and current_force:has_general() and not current_force:general_character():is_null_interface() and check_element_in_table(region_name, Ulthuan_regions) then
			table.insert(army_in_ulthuan, current_force:command_queue_index());
		end
	end
	return army_in_ulthuan;
end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("Mist_murderer_count_down", Mist_murderer_count_down, context);
		cm:save_named_value("Mist_murderer_count", Mist_murderer_count, context);
		cm:save_named_value("Mist_murder_list", Mist_murder_list, context);
		cm:save_named_value("BlacktoofMissionsCurrent", BlacktoofMissionsCurrent, context);
		cm:save_named_value("ShouldLockYvresse", ShouldLockYvresse, context);
		cm:save_named_value("BlockingYvresse", BlockingYvresse, context);
		cm:save_named_value("BlacktoofProphecies", BlacktoofProphecies, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			Mist_murderer_count_down = cm:load_named_value("Mist_murderer_count_down", Mist_murderer_count_down, context);
			Mist_murderer_count = cm:load_named_value("Mist_murderer_count", Mist_murderer_count, context);
			Mist_murder_list = cm:load_named_value("Mist_murder_list", Mist_murder_list, context);
			BlacktoofMissionsCurrent = cm:load_named_value("BlacktoofMissionsCurrent", BlacktoofMissionsCurrent, context);
			ShouldLockYvresse = cm:load_named_value("ShouldLockYvresse", ShouldLockYvresse, context);
			BlockingYvresse = cm:load_named_value("BlockingYvresse", BlockingYvresse, context);
			BlacktoofProphecies = cm:load_named_value("BlacktoofProphecies", BlacktoofProphecies, context);
		end
	end
);
