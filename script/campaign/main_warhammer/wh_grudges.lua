
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	THE GREAT SCRIPT OF GRUDGES
--	This script delivers Grudge missions when playing as the Dwarfs
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local human_dwarf_factions = {};

-- grudges are tracked in a table containing a table for each player, which contains a list of cqis and faction keys
local grudges_list = false;
-- If enabled, debug-grudges will be generated on turn 1.
local debug_grudges = false;

local starting_grudges_to_faction_leaders = {
	["names_name_2147343883"] = { -- thorgrim
		"wh2_dlc17_grudge_legendary_enemy_skarsnik",
		"wh2_dlc17_grudge_legendary_enemy_queek",
		"wh2_dlc17_grudge_legendary_settlement_black_crag",
		"wh2_dlc17_grudge_legendary_settlement_karak_azgal",
	},
	["names_name_2147344414"] = { -- ungrim
		"wh2_dlc17_grudge_legendary_settlement_karak_ungor",
		"wh2_dlc17_grudge_legendary_settlement_silver_pinnacle",
		"wh2_dlc17_grudge_legendary_settlement_karak_vlag",
		"wh3_dlc21_grudge_legendary_enemy_throt",
	},
	["names_name_2147358029"] = { -- belegar
		"wh_dlc06_grudge_belegar_eight_peaks",
		"wh_main_grudge_the_dragonback_grudge",
		"wh2_dlc17_grudge_legendary_enemy_skarsnik",
		"wh2_dlc17_grudge_legendary_enemy_queek",
	},
	["names_name_2147358917"] = { -- grombrindal
		"wh3_main_grudge_legendary_grombrindal",
		"wh2_dlc17_grudge_legendary_enemy_high_elves",
		"wh2_dlc17_grudge_legendary_enemy_dark_elves",
	},
	["names_name_976644877"] = { -- thorek
		"wh2_dlc17_main_grudge_legendary_artefact_beard_rings_of_grimnir",
		"wh2_dlc17_main_grudge_legendary_artefact_blessed_pick_of_grungni",
		"wh2_dlc17_main_grudge_legendary_artefact_keepsake_of_gazuls_favoured",
		"wh2_dlc17_main_grudge_legendary_artefact_lost_gifts_of_valaya",
		"wh2_dlc17_main_grudge_legendary_artefact_morgrims_gears_of_war",
		"wh2_dlc17_main_grudge_legendary_artefact_ratons_collar_of_bestial_control",
		"wh2_dlc17_main_grudge_legendary_artefact_smednirs_metallurgy_cipher",
		"wh2_dlc17_main_grudge_legendary_artefact_thungnis_tongs_of_the_runesmith",
	}
};

local racial_grudge_info = {
	-- completion_morale_bonus: The effect bundle given when a certain grudge is satisfied. E.g. +morale against all human factions for crossing off a human grudge.
	-- mission_suffix: The three-letter suffix used to identify a given race or group of races, used on the end of various generic grudge mission keys to signify which race the grudge is about.
	wh_main_emp_empire = { completion_morale_bonus = "wh_main_payload_morale_versus_men", mission_suffix = "emp" },
	wh_main_brt_bretonnia = { completion_morale_bonus = "wh_main_payload_morale_versus_men", mission_suffix = "brt" },
	wh3_main_cth_cathay = { completion_morale_bonus = "wh_main_payload_morale_versus_men", mission_suffix = "cth" },
	wh3_main_ksl_kislev = { completion_morale_bonus = "wh_main_payload_morale_versus_men", mission_suffix = "ksl" },

	wh_main_vmp_vampire_counts = { completion_morale_bonus = "wh_main_payload_morale_versus_undead", mission_suffix = "vmp" },
	wh2_dlc11_cst_vampire_coast = { completion_morale_bonus = "wh_main_payload_morale_versus_undead", mission_suffix = "cst" },
	wh2_dlc09_tmb_tomb_kings = { completion_morale_bonus = "wh_main_payload_morale_versus_undead", mission_suffix = "tmb" },

	wh_dlc05_wef_wood_elves = { completion_morale_bonus = "wh_main_payload_morale_versus_elves", mission_suffix = "wef" },
	wh2_main_hef_high_elves = { completion_morale_bonus = "wh_main_payload_morale_versus_elves", mission_suffix = "hef" },
	wh2_main_def_dark_elves = { completion_morale_bonus = "wh_main_payload_morale_versus_elves", mission_suffix = "def" },

	wh_main_chs_chaos = { completion_morale_bonus = "wh_main_payload_morale_versus_chaos", mission_suffix = "chs" },
	wh_dlc08_nor_norsca = { completion_morale_bonus = "wh_main_payload_morale_versus_chaos", mission_suffix = "chs" },
	wh_dlc03_bst_beastmen = { completion_morale_bonus = "wh_main_payload_morale_versus_chaos", mission_suffix = "bst" },
	wh3_main_kho_khorne = { completion_morale_bonus = "wh_main_payload_morale_versus_chaos", mission_suffix = "dae" },
	wh3_main_tze_tzeentch = { completion_morale_bonus = "wh_main_payload_morale_versus_chaos", mission_suffix = "dae" },
	wh3_main_nur_nurgle = { completion_morale_bonus = "wh_main_payload_morale_versus_chaos", mission_suffix = "dae" },
	wh3_main_sla_slaanesh = { completion_morale_bonus = "wh_main_payload_morale_versus_chaos", mission_suffix = "dae" },
	wh3_main_dae_daemons = { completion_morale_bonus = "wh_main_payload_morale_versus_chaos", mission_suffix = "dae" },

	wh_main_grn_greenskins = { completion_morale_bonus = "wh_main_payload_morale_versus_greenskins", mission_suffix = "grn" },
	wh_main_dwf_dwarfs = { completion_morale_bonus = "wh_main_payload_morale_versus_dwarfs", mission_suffix = "dwf" },
	wh2_main_lzd_lizardmen = { completion_morale_bonus = "wh2_main_payload_morale_versus_lizardmen", mission_suffix = "lzd" },
	wh2_main_skv_skaven = { completion_morale_bonus = "wh2_main_payload_morale_versus_skaven", mission_suffix = "skv" },
	wh3_main_ogr_ogre_kingdoms = { completion_morale_bonus = "wh3_main_payload_morale_versus_ogre_kingdoms", mission_suffix = "ogr" },
};

local pooled_resource_payload = "faction_pooled_resource_transaction{resource dwf_oathgold;factor grudges;amount 30;context absolute;}";

function attempt_to_load_grudges_script()
	local human_factions = cm:get_human_factions();
	
	for i = 1, #human_factions do
		local current_faction = cm:get_faction(human_factions[i])
		
		if current_faction:culture() == "wh_main_dwf_dwarfs" then
			-- build a table of all human Dwarf factions
			table.insert(human_dwarf_factions, current_faction:name());
		end;
	end;
	
	-- if there is a human Dwarf faction, load the script
	if #human_dwarf_factions > 0 then
		grudges_setup();
	end;
end;

function grudges_setup()
	out.grudges("grudges_setup() loaded");
	
	grudges_list = cm:get_saved_value("grudges_list");
	
	if not grudges_list then
		grudges_list = {};
		
		for i = 1, #human_dwarf_factions do
			table.insert(grudges_list, {["faction"] = human_dwarf_factions[i], ["cqi_list"] = {}, ["faction_list"] = {}});
		end;
	end;
	
	if cm:is_new_game() then
		for i = 1, #human_dwarf_factions do
			local current_faction_key = human_dwarf_factions[i]
			local current_faction = cm:get_faction(current_faction_key)
			
			if current_faction:is_human() then
				-- load starting grudges
				for faction_leader, missions in pairs(starting_grudges_to_faction_leaders) do
					if cm:general_with_forename_exists_in_faction_with_force(current_faction_key, faction_leader) then
						for j = 1, #missions do
							cm:trigger_mission(current_faction_key, missions[j], true)
						end
					end
				end

				-- monitor for the Dwarfs faction losing any regions that they own
				cm:start_faction_region_change_monitor(human_dwarf_factions[i]);
			end;
		end;
	end;
	
	-- listen for the result of the player's land battle
	for i = 1, #human_dwarf_factions do
		local current_faction_name = human_dwarf_factions[i];
		
		core:add_listener(
			"land_battle_result" .. i,
			"BattleCompleted",
			function()
				local pb = cm:model():pending_battle();
				
				return not pb:siege_battle() and cm:pending_battle_cache_faction_is_involved(current_faction_name) and pb:has_been_fought();
			end,
			function()
				local pb = cm:model():pending_battle();
				
				if (cm:pending_battle_cache_faction_is_attacker(current_faction_name) and pb:has_defender() and pb:defender():won_battle())
				or (cm:pending_battle_cache_faction_is_defender(current_faction_name) and pb:has_attacker() and pb:attacker():won_battle())
				then
					lost_battle_grudge(pb, current_faction_name);
				else
					remove_cqi(pb, current_faction_name);
				end;
			end,
			true
		);
	end;
	
	-- listen for the player losing a region (will not work on turn 1)
	core:add_listener(
		"lost_region",
		"ScriptEventFactionLostRegion",
		true,
		function(context)
			lost_region_grudge(context:region(), context:faction():name());
		end,
		true
	);
	
	-- listen for the player being raided (stance)
	core:add_listener(
		"region_raided",
		"ForceAdoptsStance",
		function(context)
			local mf = context:military_force();
			local raiding_faction = mf:faction();
			
			-- don't trigger if faction has no regions to raid in return
			if not raiding_faction:has_home_region() then return end
			
			local stance = context:stance_adopted();
			local general = mf:general_character();
			
			if (stance == 3 or stance == 14) and general:has_region() then
				local region = general:region();
				
				if not region:is_abandoned() then
					local raiding_faction_name = raiding_faction:name();
					local region_owner = region:owning_faction():name();
					
					for i = 1, #human_dwarf_factions do
						local current_faction_name = human_dwarf_factions[i];
						local current_faction = cm:get_faction(current_faction_name);
						
						if region_owner == current_faction_name and raiding_faction_name ~= current_faction_name and not raiding_faction:allied_with(current_faction) and raiding_faction:at_war_with(current_faction) then
							return true;
						end;
					end;
				end;
			end;
		end,
		function(context)
			local mf = context:military_force();
			
			if not mf:is_null_interface() then
				raiding_grudge(mf:command_queue_index(), mf:general_character():region():owning_faction():name());
			end
		end,
		true
	);
	
	-- listen for one of the player's settlements being sacked
	core:add_listener(
		"settlement_sacked",
		"CharacterSackedSettlement",
		function(context)
			local human_dwarf_settlement_was_target = false;
			
			for i = 1, #human_dwarf_factions do
				if context:garrison_residence():faction():name() == human_dwarf_factions[i] then
					human_dwarf_settlement_was_target = true;
				end;
			end;
			
			return human_dwarf_settlement_was_target;
		end,
		function(context)
			sacked_settlement_grudge(context:character(), context:garrison_residence():faction():name());
		end,
		true
	);
	
	-- listen for a player rebellion
	core:add_listener(
		"region_rebellion",
		"RegionRebels",
		function(context)
			local human_dwarf_region_was_target = false;
			local region = context:region();
			local owning_faction_name = region:owning_faction():name();
			
			for i = 1, #human_dwarf_factions do
				if owning_faction_name == human_dwarf_factions[i] then
					human_dwarf_region_was_target = true;
				end;
			end;
			
			return human_dwarf_region_was_target and cm:get_corruption_value_in_region(region, chaos_corruption_string) < 30 and cm:get_corruption_value_in_region(region, vampiric_corruption_string) < 30 and cm:get_corruption_value_in_region(region, skaven_corruption_string) < 30 and cm:get_corruption_value_in_region(region, khorne_corruption_string) < 30 and cm:get_corruption_value_in_region(region, nurgle_corruption_string) < 30 and cm:get_corruption_value_in_region(region, slaanesh_corruption_string) < 30 and cm:get_corruption_value_in_region(region, tzeentch_corruption_string) < 30;
		end,
		function(context)
			local region = context:region();
			
			end_rebellion_grudge(region:name(), region:owning_faction():name());
		end,
		true
	);

	if debug_grudges then
		launch_debug_grudges();
	end;
end;

function launch_debug_grudges()
	out("Debugging Grudge script ...");
	out.inc_tab();

	if #human_dwarf_factions == 0 then
		out("WARNING: No players are Dwarf factions. Withg no human Dwarfs, we can't generate any grudge missions for debugging.");
	else
		local all_factions = cm:model():world():faction_list();
		local covered_cultures = {};
		for f = 0, all_factions:num_items() - 1 do
			local faction = all_factions:item_at(f);
			local culture = faction:culture();
			if faction:has_home_region() and covered_cultures[culture] == nil then
				out("Attempting to create Lost Region grudge for culture: '" .. culture .. "'' for all dwarf players.");
				for h = 1, #human_dwarf_factions  do
					lost_region_grudge(faction:home_region(), human_dwarf_factions[h]);
				end;
				covered_cultures[culture] = true;
			end;
		end;
	end;

	out.dec_tab();
end;

function lost_region_grudge(region, faction_name)
	local region_name = region:name();
	
	out.grudges("lost_region_grudge() called for " .. faction_name .. ", with a region name of " .. region_name);
	
	local culture = region:owning_faction():culture();
	
	local mission_str = get_grudge_mission_string("wh_main_grudge_recapture_settlement_", culture, cm:random_number(2));
	
	if not mission_str then return end;
	
	local lost_region_grudge_mission = mission_manager:new(
		faction_name,
		mission_str
	);
	
	lost_region_grudge_mission:add_new_objective("CAPTURE_REGIONS");
	lost_region_grudge_mission:add_condition("region " .. region_name);
	lost_region_grudge_mission:add_payload(generate_payload(nil, culture));
	lost_region_grudge_mission:add_payload(pooled_resource_payload);
	lost_region_grudge_mission:set_should_cancel_before_issuing(false);
	
	lost_region_grudge_mission:trigger();
end;

function lost_battle_grudge(pb, faction_name)
	-- determine the cqi of the enemy attacker/defender here as we can't pass the pending battle object forward
	local cqi = 0;
	local culture = "";
	
	if pb:has_attacker() and pb:attacker():won_battle() and pb:attacker():has_military_force() and not pb:attacker():faction():is_quest_battle_faction() then
		if pb:attacker():faction():name() == faction_name then
			out.grudges("Tried to issue an ENGAGE_FORCE mission against the player - did the CQI change during AI turns?");
			return;
		end;
		
		cqi = pb:attacker():military_force():command_queue_index();
		culture = pb:attacker():faction():culture();
	elseif pb:has_defender() and pb:defender():has_military_force() and not pb:defender():faction():is_quest_battle_faction() then
		if pb:defender():faction():name() == faction_name then
			out.grudges("Tried to issue an ENGAGE_FORCE mission against the player - did the CQI change during AI turns?");
			return;
		end;
		
		cqi = pb:defender():military_force():command_queue_index();
		culture = pb:defender():faction():culture();
	else
		out.grudges("Tried to issue an ENGAGE_FORCE mission, but the CQI of the winning force could not be found!");
		return;
	end;
	
	if cm:get_faction(faction_name):is_factions_turn() then
		issue_lost_battle_grudge(cqi, culture, faction_name);
	else
		core:add_listener(
			"player_turn",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == faction_name;
			end,
			function()
				issue_lost_battle_grudge(cqi, culture, faction_name);
			end,
			false
		);
	end;
end;

function issue_lost_battle_grudge(cqi, culture, faction_name)
	local cqi = tostring(cqi);
	
	if cqi == "0" then
		out.grudges("Tried to issue an ENGAGE_FORCE mission for " .. faction_name .. ", but the CQI could not be found - has the force died?");
		return;
	end;
	
	for i = 1, #grudges_list do
		if grudges_list[i].faction == faction_name then
			for j = 1, #grudges_list[i].cqi_list do
				if grudges_list[i].cqi_list[j] == cqi then
					out.grudges("Tried to issue an ENGAGE_FORCE mission for " .. faction_name .. ", but the CQI of the winning force already has an active mission!");
					return;
				end;
			end;
		end;
	end;
	
	local mission_str = get_grudge_mission_string("wh_main_grudge_defeat_army_", culture);
	
	if not mission_str then return end;
	
	for i = 1, #grudges_list do
		if grudges_list[i].faction == faction_name then
			out.grudges("Adding CQI " .. cqi .. " to " .. faction_name .. "'s CQI list");
			table.insert(grudges_list[i].cqi_list, cqi);
		end;
	end;
	
	cm:set_saved_value("grudges_list", grudges_list);
	
	out.grudges("lost_battle_grudge() called for " .. faction_name .. ", with a CQI of " .. cqi .. " with culture " .. culture);
	
	local lost_battle_grudge_mission = mission_manager:new(
		faction_name,
		mission_str
	);

	lost_battle_grudge_mission:add_new_objective("ENGAGE_FORCE");
	lost_battle_grudge_mission:add_condition("cqi " .. cqi);
	lost_battle_grudge_mission:add_condition("requires_victory");
	lost_battle_grudge_mission:add_payload(generate_payload("army", culture));
	lost_battle_grudge_mission:add_payload(pooled_resource_payload);
	lost_battle_grudge_mission:set_should_cancel_before_issuing(false);
	
	lost_battle_grudge_mission:trigger();
end;

function sacked_settlement_grudge(char, faction_name)	
	local cqi = char:cqi();
	local faction = char:faction();
	local culture = faction:culture();
	
	local mission_str = get_grudge_mission_string("wh_main_grudge_defeat_sacking_army_", culture);
	
	if not mission_str then return end;
	
	core:add_listener(
		"player_turn",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == faction_name;
		end,
		function()
			local char_on_player_turn = cm:get_character_by_cqi(cqi);
			
			if not char_on_player_turn then
				out.grudges("Tried to issue an ENGAGE_FORCE mission for " .. faction_name .. ", but the CQI of the character could not be found - did they die during the AI turns?");
				return;
			end;
			
			if not char_on_player_turn:has_military_force() then
				out.grudges("Tried to issue an ENGAGE_FORCE mission for " .. faction_name .. ", but the sacking character does not have a military force!");
				return;
			end;
			
			local mf_cqi = tostring(char_on_player_turn:military_force():command_queue_index());
			
			for i = 1, #grudges_list do
				if grudges_list[i].faction == faction_name then
					for j = 1, #grudges_list[i].cqi_list do
						if grudges_list[i].cqi_list[j] == mf_cqi then
							out.grudges("Tried to issue an ENGAGE_FORCE mission for " .. faction_name .. ", but the CQI of the sacking character already has an active mission!");
							return;
						end;
					end;
				end;
			end;
			
			for i = 1, #grudges_list do
				if grudges_list[i].faction == faction_name then
					out.grudges("Adding CQI " .. mf_cqi .. " to " .. faction_name .. "'s CQI list");
					table.insert(grudges_list[i].cqi_list, mf_cqi);
				end;
			end;
			
			cm:set_saved_value("grudges_list", grudges_list);
			
			out.grudges("sacked_settlement_grudge() called for " .. faction_name .. ", with a CQI of " .. mf_cqi);
			
			local sacked_settlement_grudge_mission = mission_manager:new(
				faction_name,
				mission_str
			);
			
			sacked_settlement_grudge_mission:add_new_objective("ENGAGE_FORCE");
			sacked_settlement_grudge_mission:add_condition("cqi " .. mf_cqi);
			sacked_settlement_grudge_mission:add_condition("requires_victory");
			sacked_settlement_grudge_mission:add_payload(generate_payload("army", culture));
			sacked_settlement_grudge_mission:add_payload(pooled_resource_payload);
			sacked_settlement_grudge_mission:set_should_cancel_before_issuing(false);
			
			sacked_settlement_grudge_mission:trigger();
		end,
		false
	);
end;

function end_rebellion_grudge(region_name, faction_name)
	out.grudges("end_rebellion_grudge() called for " .. faction_name .. ", with a region name of " .. region_name);
	
	local end_rebellion_grudge_mission = mission_manager:new(
		faction_name,
		"wh_main_grudge_end_rebellion"
	);
	
	end_rebellion_grudge_mission:add_new_objective("END_REBELLION");
	end_rebellion_grudge_mission:add_condition("region " .. region_name);
	end_rebellion_grudge_mission:add_payload(generate_payload(nil));
	end_rebellion_grudge_mission:add_payload(pooled_resource_payload);
	end_rebellion_grudge_mission:set_should_cancel_before_issuing(false);
	
	end_rebellion_grudge_mission:trigger();
end;

function raiding_grudge(mf_cqi, faction_name)
	core:add_listener(
		"player_turn",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == faction_name;
		end,
		function()
			local cqi = tostring(mf_cqi);
			local mf = cm:model():military_force_for_command_queue_index(mf_cqi);
			
			if cqi == "0" then
				out.grudges("Tried to issue an RAID_SUB_CULTURE mission for " .. faction_name .. ", but the CQI could not be found - has the force died?");
				return;
			elseif mf:faction():name() == faction_name then
				script_error("Raiding grudge: tried to issue an RAID_SUB_CULTURE mission for " .. faction_name .. ", but the military force's faction matches the player's faction - how?");
				return;
			end;
			
			local raiding_faction =  mf:general_character():faction():name()
			local culture = mf:general_character():faction():culture();
			local subculture = mf:general_character():faction():subculture()
			
			for i = 1, #grudges_list do
				if grudges_list[i].faction == faction_name then
					for j = 1, #grudges_list[i].faction_list do
						if grudges_list[i].faction_list[j] == raiding_faction then
							out.grudges("Tried to issue an RAID_SUB_CULTURE mission for " .. faction_name .. ", but the faction of the raiding force already has an active mission!");
							return;
						end;
					end;
				end;
			end;
			
			local mission_str = get_grudge_mission_string("wh_main_grudge_defeat_raiding_army_", culture);
			
			if not mission_str then return end;
			
			for i = 1, #grudges_list do
				if grudges_list[i].faction == faction_name then
					out.grudges("Adding faction " .. raiding_faction .. " to " .. faction_name .. "'s faction list");
					table.insert(grudges_list[i].faction_list, raiding_faction);
				end;
			end;
			
			cm:set_saved_value("grudges_list", grudges_list);
			
			out.grudges("raiding_grudge() called for " .. faction_name .. ", with a CQI of " .. cqi .. " with culture " .. culture);
			
			local raiding_grudge_mission = mission_manager:new(
				faction_name,
				mission_str
			);
			
			raiding_grudge_mission:add_new_objective("RAID_SUB_CULTURE");
			raiding_grudge_mission:add_condition("subculture "..subculture);
			raiding_grudge_mission:add_payload(generate_payload("army", culture));
			raiding_grudge_mission:add_payload(pooled_resource_payload);
			raiding_grudge_mission:set_should_cancel_before_issuing(false);
			
			raiding_grudge_mission:trigger();
		end,
		false
	);
end;

-- generate a random payload for the grudge
function generate_payload(mis_type, culture)
	local payloads = {
		"money 500",
		"money 750",
		"money 1000",
	}
	
	local effect_bundles_army = {
		"effect_bundle{bundle_key wh_main_payload_call_to_arms_army;turns 5;}",
		"effect_bundle{bundle_key wh_main_payload_morale_army;turns 5;}"
	};

	local racial_morale_bonus
	if racial_grudge_info[culture] then
		racial_morale_bonus = racial_grudge_info[culture].completion_morale_bonus;
	end

	if racial_morale_bonus == nil then
		out.grudges(string.format("When building a reward payload for grudge of type '%s', no morale bonus was associated with culture '%s'. This grudge will not grant a morale bonus against this culture on completion.",
			tostring(mis_type), tostring(culture)));
	else
		table.insert(payloads, string.format("effect_bundle{bundle_key %s;turns 5;}", racial_morale_bonus));
	end
	
	if mis_type == "army" then
		for i = 1, #effect_bundles_army do
			table.insert(payloads, effect_bundles_army[i]);
		end;
	end;
	
	local roll = cm:random_number(#payloads);
	local chosen_payload = payloads[roll];

	out.grudges("Generated the following payload: " .. chosen_payload);
	return chosen_payload;
end;


-- removes a CQI from the table when the force has been defeated (assume the mission has been completed)
function remove_cqi(pb, faction_name)
	local cqi = 0;
	
	-- get the losing force's CQI
	if pb:has_attacker() and not pb:attacker():won_battle() and pb:attacker():has_military_force() then
		cqi = pb:attacker():military_force():command_queue_index();
	elseif pb:has_defender() and pb:defender():has_military_force() then
		cqi = pb:defender():military_force():command_queue_index();
	else
		out.grudges("Tried to remove a CQI from the CQI tracker, but the CQI of the losing force could not be found!")
		return
	end;
	
	cqi = tostring(cqi);
	out.grudges("remove_cqi() called for " .. faction_name .. ", with a CQI of " .. cqi);
	
	for i = 1, #grudges_list do
		if grudges_list[i].faction == faction_name then
			for j = 1, #grudges_list[i].cqi_list do
				if grudges_list[i].cqi_list[j] == cqi then
					table.remove(grudges_list[i].cqi_list, j);
				end;
			end;
		end;
	end;
	
	cm:set_saved_value("grudges_list", grudges_list);
end;

function get_grudge_mission_string(mission_str, culture, roll)
	if culture:find("wh_dlc03") then
		mission_str = mission_str:gsub("wh_main", "wh_dlc03");
	elseif culture:find("wh_dlc05") then
		mission_str = mission_str:gsub("wh_main", "wh_dlc05");
	elseif culture:find("wh2_main") then
		mission_str = mission_str:gsub("wh_main", "wh2_main");
	elseif culture:find("wh2_dlc09") then
		mission_str = mission_str:gsub("wh_main", "wh2_dlc09");
	elseif culture:find("wh2_dlc11") then
		mission_str = mission_str:gsub("wh_main", "wh2_dlc11");
	elseif culture:find("wh3_main") then
		mission_str = mission_str:gsub("wh_main", "wh3_main");
	end;
	
	local culture_mission_suffix;
	if racial_grudge_info[culture] then
		culture_mission_suffix = racial_grudge_info[culture].mission_suffix;
	end;

	if culture_mission_suffix == nil then
		return false;
	end;

	mission_str = mission_str .. culture_mission_suffix;
	
	return mission_str;
end;