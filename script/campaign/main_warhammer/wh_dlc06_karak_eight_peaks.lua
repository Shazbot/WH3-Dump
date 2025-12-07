
-- list of karak eight peaks faction keys that we can iterate over
karak_eight_peaks_factions = {
	"wh_main_dwf_karak_izor",
	"wh_main_grn_crooked_moon",
	"wh2_main_skv_clan_mors"
};

skarsniks_locked_buildings = {
	"wh_main_grn_military_1",
	"wh_main_grn_military_2",
	"wh_main_grn_military_3",
	"wh_main_grn_boars_2",
	"wh3_dlc26_grn_boars_3",
	"wh_dlc06_grn_boars_2_skarsnik",
	"wh3_dlc26_grn_boars_3_skarsnik",
}

local skarsnik_faction_name = "wh_main_grn_crooked_moon"

local karak_eight_peaks_region_name = "wh3_main_combi_region_karak_eight_peaks";

-- list of karak eight peaks faction keys that we can lookup easily
karak_eight_peaks_factions_lookup = {};
for i = 1, #karak_eight_peaks_factions do
	karak_eight_peaks_factions_lookup[karak_eight_peaks_factions[i]] = true;
end;


function is_karak_eight_peaks_owner_faction(faction_name)
	return not not karak_eight_peaks_factions_lookup[faction_name];
end;



function apply_karak_diplomacy()
	-- No peace for Belegar and Skarsnik
	cm:force_diplomacy("faction:wh_main_grn_crooked_moon", "faction:wh_main_dwf_karak_izor", "peace", false, false, true);
	cm:force_diplomacy("faction:wh_main_grn_greenskins", "faction:wh_main_grn_necksnappers", "form confederation", false, false, true);
	
	if cm:get_faction("wh_main_grn_crooked_moon"):is_human() or cm:get_faction("wh_main_dwf_karak_izor"):is_human() or cm:get_faction("wh2_main_skv_clan_mors"):is_human() then
		-- No diplomacy for the Mutinous Gits
		cm:force_diplomacy("faction:wh_main_grn_necksnappers", "all", "all", false, false, true);
		-- if the faction re-emerges, they will not be at war with the karak factions, so make sure war is still available
		cm:force_diplomacy("faction:wh_main_grn_necksnappers", "faction:wh_main_grn_crooked_moon", "war", true, true, true);
		cm:force_diplomacy("faction:wh_main_grn_necksnappers", "faction:wh_main_dwf_karak_izor", "war", true, true, true);
		cm:force_diplomacy("faction:wh_main_grn_necksnappers", "faction:wh2_main_skv_clan_mors", "war", true, true, true);
		
		if cm:is_multiplayer() then
			-- A non-Karak player won't know what's going on
			local human_factions = cm:get_human_factions();
			
			for i = 1, #human_factions do
				local current_faction_name = human_factions[i];
				
				if current_faction_name ~= "wh_main_dwf_karak_izor" and 
				   current_faction_name ~= "wh_main_grn_crooked_moon" and 
				   not merc_contracts:is_mercenary_faction(current_faction_name)
				then
					cm:force_diplomacy("faction:" .. current_faction_name, "faction:wh_main_grn_necksnappers", "all", true, true, false);
					cm:force_diplomacy("faction:" .. current_faction_name, "faction:wh_main_grn_necksnappers", "form confederation", false, false, true);
				end;
			end;
		end;
	end;
end;

local belegar_characters = {
	-- Belegar Ironhammer [Lord]
	{forename = "names_name_2147358029", surname = "names_name_2147358036", start_rank = 0, kill_if_AI = false, start_skills = {}},
	-- King Lunn Ironhammer [Thane]
	{forename = "names_name_2147358979", surname = "names_name_2147358036", start_rank = 5, kill_if_AI = false, start_skills = {"wh_main_skill_all_all_self_blade_master_starter", "wh_main_skill_all_all_self_devastating_charge", "wh_main_skill_all_all_self_hard_to_hit", "wh_main_skill_all_all_self_deadly_blade"}},
	-- Throni Ironbrow [Runesmith]
	{forename = "names_name_2147358988", surname = "names_name_2147358994", start_rank = 5, kill_if_AI = false, start_skills = {"wh2_dlc17_skill_dwf_runesmith_self_rune_of_speed", "wh_main_skill_dwf_runesmith_self_rune_of_wrath_&_ruin", "wh_main_skill_dwf_runesmith_self_rune_of_oath_&_steel", "wh_main_skill_dwf_runesmith_self_damping"}},
	-- Halkenhaf Stonebeard [Thane]
	{forename = "names_name_2147358982", surname = "names_name_2147358985", start_rank = 5, kill_if_AI = true, start_skills = {"wh_main_skill_all_all_self_blade_master_starter", "wh_main_skill_all_all_self_devastating_charge", "wh_main_skill_all_all_self_hard_to_hit", "wh_main_skill_all_all_self_deadly_blade"}},
	-- Dramar Hammerfist [Engineer]
	{forename = "names_name_2147359003", surname = "names_name_2147359010", start_rank = 5, kill_if_AI = true, start_skills = {"wh2_dlc17_skill_dwf_master_engineer_restock","wh2_main_skill_all_hero_assist_army_increase_mobility", "wh2_main_skill_all_hero_hinder_agent_wound", "wh2_main_skill_all_hero_passive_boost_income"}}
};

function belegar_start_experience()	
	local faction = cm:get_faction("wh_main_dwf_karak_izor");
	
	if faction then
		cm:disable_event_feed_events(true, "wh_event_category_traits_ancillaries", "", "");
		cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
		
		local is_human = faction:is_human();
		local character_list = faction:character_list();
		
		for i = 0, character_list:num_items() - 1 do
			local current_char = character_list:item_at(i);
			local char_index = find_belegar_character(current_char);
			
			if char_index > 0 then
				local char_lookup_str = cm:char_lookup_str(current_char);
				
				if not is_human and belegar_characters[char_index].kill_if_AI then
					cm:kill_character(char_lookup_str, true);
				else
					local family_member_cqi = current_char:family_member():command_queue_index();
					local rank = belegar_characters[char_index].start_rank;
					
					if rank > 0 then
						cm:add_agent_experience(char_lookup_str, rank, true);
						
						cm:callback(
							function()
								local skills = belegar_characters[char_index].start_skills;
								local character = cm:get_family_member_by_cqi(family_member_cqi):character();
								for j = 1, #skills do
									cm:add_skill(character, skills[j], true, false);
								end;
							end,
							0.2
						);
					end;
				end;
			end;
		end;
		
		cm:callback(
			function()
				cm:disable_event_feed_events(false, "wh_event_category_traits_ancillaries", "", "");
				cm:disable_event_feed_events(false, "wh_event_category_character", "", "");
			end,
			1
		);
	end;
end;

function find_belegar_character(character)
	for i = 1, #belegar_characters do
		if character:get_forename() == belegar_characters[i].forename and character:get_surname() == belegar_characters[i].surname then
			return i;
		end;
	end;
	
	return 0;
end;

function eight_peaks_setup()
	local skarsnik = cm:get_faction("wh_main_grn_crooked_moon");
	local belegar = cm:get_faction("wh_main_dwf_karak_izor");
	local queek = cm:get_faction("wh2_main_skv_clan_mors");
	local gits = cm:get_faction("wh_main_grn_necksnappers");
	
	if (skarsnik and skarsnik:is_human()) or (belegar and belegar:is_human()) or (queek and queek:is_human()) and gits and gits:has_faction_leader() then
		-- Stop Eight Peaks defender movement
		local gits_leader = gits:faction_leader():command_queue_index();
		local gits_leader_str = cm:char_lookup_str(gits_leader);
		
		cm:cai_disable_movement_for_character(gits_leader_str);
		
		-- Give him some extra units
		cm:grant_unit("settlement:" .. karak_eight_peaks_region_name, "wh_main_grn_inf_black_orcs");
		cm:grant_unit("settlement:" .. karak_eight_peaks_region_name, "wh_main_grn_inf_black_orcs");
		cm:grant_unit("settlement:" .. karak_eight_peaks_region_name, "wh_main_grn_inf_orc_big_uns");
		cm:grant_unit("settlement:" .. karak_eight_peaks_region_name, "wh_main_grn_inf_orc_big_uns");
		cm:grant_unit("settlement:" .. karak_eight_peaks_region_name, "wh_main_grn_inf_orc_big_uns");
		cm:grant_unit("settlement:" .. karak_eight_peaks_region_name, "wh_main_grn_inf_night_goblin_archers");
		cm:grant_unit("settlement:" .. karak_eight_peaks_region_name, "wh_main_grn_inf_night_goblin_archers");
		cm:grant_unit("settlement:" .. karak_eight_peaks_region_name, "wh_main_grn_inf_orc_arrer_boyz");
		cm:grant_unit("settlement:" .. karak_eight_peaks_region_name, "wh_main_grn_inf_orc_arrer_boyz");
		
		if cm:is_multiplayer() then
			cm:grant_unit("settlement:" .. karak_eight_peaks_region_name, "wh_main_grn_inf_orc_big_uns");
			cm:grant_unit("settlement:" .. karak_eight_peaks_region_name, "wh_main_grn_mon_trolls");
			cm:grant_unit("settlement:" .. karak_eight_peaks_region_name, "wh_main_grn_mon_arachnarok_spider_0");
		else
			local difficulty = cm:get_difficulty();
			
			if difficulty > 1 then
				cm:grant_unit("settlement:" .. karak_eight_peaks_region_name, "wh_main_grn_inf_orc_big_uns");
			end;
			
			if difficulty > 2 then
				cm:grant_unit("settlement:" .. karak_eight_peaks_region_name, "wh_main_grn_mon_trolls");
			end;
			
			if difficulty > 3 then
				cm:grant_unit("settlement:" .. karak_eight_peaks_region_name, "wh_main_grn_mon_arachnarok_spider_0");
			end;
		end;
		
		-- Give him XP
		cm:add_agent_experience(gits_leader_str, 2000);
		
		-- Give them some effects to survive
		cm:apply_effect_bundle_to_characters_force("wh_dlc06_bundle_eight_peaks_defender", gits_leader, 0);
	end;
	
	--Add Skarsnik building restriction on the Orc recruitment chain
	for i = 1, #skarsniks_locked_buildings do
		cm:add_event_restricted_building_record_for_faction(skarsniks_locked_buildings[i], skarsnik_faction_name, "skarsnik_building_lock")
	end

	if skarsnik and skarsnik:is_human() then
		
		-- Skarsnik does NOT own Karak Eight Peaks to start with
		cm:apply_effect_bundle("wh_dlc06_skarsnik_karak_owned_false", "wh_main_grn_crooked_moon", 0);
		
		if not cm:is_multiplayer() then
			cm:apply_effect_bundle("wh_dlc06_rival_hidden_boost", "wh_main_dwf_karak_izor", 0);
		end;
	else
		cm:apply_effect_bundle("wh_dlc06_skarsnik_anti_trait", "wh_main_grn_crooked_moon", 0);
	end;
	
	if belegar and belegar:is_human() then
		
		-- Belegar does NOT own Karak Eight Peaks to start with
		cm:apply_effect_bundle("wh_dlc06_belegar_karak_owned_false_first", "wh_main_dwf_karak_izor", 0);
		
		if not cm:is_multiplayer() then
			cm:apply_effect_bundle("wh_dlc06_rival_hidden_boost", "wh_main_grn_crooked_moon", 0);
		end;
	end;
	
	if queek and queek:is_human() then
		
		-- Queek does NOT own Karak Eight Peaks to start with
		cm:apply_effect_bundle("wh2_main_queek_karak_owned_false", "wh2_main_skv_clan_mors", 0);
	end;
end;


function Add_Karak_Eight_Peaks_Listeners()
	out("#### Adding Karak Eight Peaks Listeners ####");

	for i = 1, #karak_eight_peaks_factions do
		cm:add_faction_turn_start_listener_by_name(
			"karak_faction_turn_start",
			karak_eight_peaks_factions[i],
			function()
				local region = cm:get_region(karak_eight_peaks_region_name);
				
				if region:is_abandoned() then
					eight_peaks_check("");
				else
					eight_peaks_check(region:owning_faction():name());
				end
			end, 
			true
		);
	end;

	cm:add_faction_turn_start_listener_by_name(
		"karak_faction_turn_start", 
		"wh_main_grn_necksnappers", 
		function(context)
			local faction = context:faction();
			if faction:has_faction_leader() then
				local skarsnik = cm:get_faction("wh_main_grn_crooked_moon");
				local belegar = cm:get_faction("wh_main_dwf_karak_izor");
				local queek = cm:get_faction("wh2_main_skv_clan_mors");
				
				if (skarsnik and skarsnik:is_human()) or (belegar and belegar:is_human()) or (skarsnik and skarsnik:is_human()) then
					cm:add_agent_experience(cm:char_lookup_str(faction:faction_leader():command_queue_index()), 200);
				end;
			end;
		end,
		true
	);

	cm:add_faction_turn_start_listener_by_name(
		"karak_faction_turn_start", 
		"wh_main_grn_greenskins", 
		function(context)
			cm:force_diplomacy("faction:wh_main_grn_greenskins", "faction:wh_main_grn_necksnappers", "form confederation", false, false, true);
		end,
		true
	);
	
	core:add_listener(
		"karak_eight_peaks_occupied",
		"GarrisonOccupiedEvent",
		function(context)
			return context:garrison_residence():region():name() == karak_eight_peaks_region_name;
		end,
		function(context)
			local character = context:character();
			local faction = character:faction();
			
			if not character:is_null_interface() and not faction:is_null_interface() then
				eight_peaks_check(faction:name());
			else
				eight_peaks_check(context:garrison_residence():region():owning_faction():name());
			end;
		end,
		true
	);

	core:add_listener(
		"karak_faction_joins_confederation",
		"FactionJoinsConfederation",
		function(context)
			local faction_name = context:faction():name();
			local confederation_name = context:confederation():name();
			
			return is_karak_eight_peaks_owner_faction(faction_name) or is_karak_eight_peaks_owner_faction(confederation_name);
		end,
		function(context)

			local region = cm:get_region(karak_eight_peaks_region_name)

			if region and not region:is_abandoned() then
				eight_peaks_check(region:owning_faction():name());
			end;
		end,
		true
	);

	core:add_listener(
		"gits_faction_becomes_vassal",
		"FactionBecomesVassal",
		function(context)
			return context:faction():name() == "wh_main_grn_crooked_moon";
		end,
		function(context)
			local gits = cm:get_faction("wh_main_grn_necksnappers");
			
			if gits and gits:is_vassal() then
				if gits:is_ally_vassal_or_client_state_of(context:faction()) then
					cm:force_diplomacy("faction:wh_main_grn_necksnappers", "all", "all", true, true, true);
				end;
			end;
		end,
		true
	);
	
	local karak_icon_marker_added = false;
	local camera_moving = false;

	core:add_listener(
		"karak_icon_clicked",
		"ComponentLClickUp",
		function(context)
			return context.string == "glow" and not cm:is_multiplayer() and not cm:model():pending_battle():is_active() and is_karak_eight_peaks_owner_faction(cm:whose_turn_is_it_single():name());
		end,
		function()
			local region = cm:get_region(karak_eight_peaks_region_name);
			local owner = "";
			
			if region and not region:is_abandoned() then
				owner = region:owning_faction():name();
			end;
			
			if not camera_moving then
				local cam_horizontal = 14.768
				local cam_bearing = 0.0
				local cam_vert = 12.0
				local settlement = region:settlement()
				local x_coord = settlement:display_position_x()
				local y_coord = settlement:display_position_y()
				
				cm:scroll_camera_from_current(false, 3, {x_coord, y_coord, cam_horizontal, cam_bearing, cam_vert});

				camera_moving = true;

				cm:callback(function() camera_moving = false end, 3);
			end;
			
			if owner ~= cm:whose_turn_is_it_single():name() and not karak_icon_marker_added then
				karak_icon_marker_added = true;
				
				cm:add_marker("karak_eight_peaks_marker", "pointer", 509, 359, 1);
				
				cm:callback(
					function()
						cm:remove_marker("karak_eight_peaks_marker");
						karak_icon_marker_added = false;
					end,
					10
				);
			end;
		end,
		true
	);

	core:add_listener(
		"skarsnik_occupation_dismantle_check",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:character():faction():name() == skarsnik_faction_name
		end,
		function(context)
			local occupation_decision = context:occupation_decision_type()
			
			if occupation_decision == "occupation_decision_loot" or occupation_decision == "occupation_decision_occupy" then

				local region = cm:get_region(karak_eight_peaks_region_name)
				if region and not region:is_abandoned() then
					if region:owning_faction():name() ~= skarsnik_faction_name then
						local region_slot_list = context:garrison_residence():region():slot_list()
						--check to see if the building exists in any of the regions
						skarsniks_locked_buildings_removal(region_slot_list)
					end
				end
			end
		end,
		true
	)

end;

function skarsniks_locked_buildings_removal(region_slot_list)
	for i = 1, #skarsniks_locked_buildings do
	--check to see if the building exists in any of the regions
		if region_slot_list:buliding_type_exists(skarsniks_locked_buildings[i]) then
			for j = 0, region_slot_list:num_items() - 1 do
				
				--find the slot it exists in and remove it
				local slot = region_slot_list:item_at(j)
				if slot:has_building() and slot:building():name() == skarsniks_locked_buildings[i] then
					cm:instantly_dismantle_building_in_region(slot)
				end
			end
		end
	end
end

function eight_peaks_check(karak_owner)
	out("######## eight_peaks_check() ########");
	out("\tFaction: "..tostring(karak_owner));
	
	local owner_save_value = cm:get_saved_value("eight_peaks_event_" .. karak_owner);
	
	if is_karak_eight_peaks_owner_faction(karak_owner) then
		out("\towner_save_value = " .. tostring(owner_save_value));
		
		if not owner_save_value then
			local settlement = cm:get_region(karak_eight_peaks_region_name):settlement();
			
			cm:show_message_event_located(
				karak_owner,
				"event_feed_strings_text_wh_dlc06_event_feed_string_scripted_event_captured_karak_eight_peaks_title",
				"event_feed_strings_text_wh_dlc06_event_feed_string_scripted_event_captured_karak_eight_peaks_primary_detail_" .. karak_owner,
				"event_feed_strings_text_wh_dlc06_event_feed_string_scripted_event_captured_karak_eight_peaks_secondary_detail_" .. karak_owner,
				settlement:logical_position_x(),
				settlement:logical_position_y(),
				true,
				601
			);
			
			owner_save_value = true;
			
			cm:set_saved_value("eight_peaks_event_" .. karak_owner, true);
		end;
	end;
	
	if karak_owner == "wh_main_dwf_karak_izor" then
		out("\tRemoving Belegar effect: wh_dlc06_belegar_karak_owned_false_first");
		cm:remove_effect_bundle("wh_dlc06_belegar_karak_owned_false_first", "wh_main_dwf_karak_izor");
	end;
	
	local belegar_owner = (karak_owner == "wh_main_dwf_karak_izor");
	local skarsnik_owner = (karak_owner == "wh_main_grn_crooked_moon");
	local queek_owner = (karak_owner == "wh2_main_skv_clan_mors");
	out("\tBELEGAR OWNS KARAK EIGHT PEAKS : " .. tostring(belegar_owner));
	out("\tSKARSNIK OWNS KARAK EIGHT PEAKS : " .. tostring(skarsnik_owner));
	out("\tQUEEK OWNS KARAK EIGHT PEAKS : " .. tostring(queek_owner));
	
	out("\tRemoving effects...");
	cm:remove_effect_bundle("wh_dlc06_belegar_karak_owned_false", "wh_main_dwf_karak_izor");
	cm:remove_effect_bundle("wh_dlc06_belegar_karak_owned_true", "wh_main_dwf_karak_izor");
	cm:remove_effect_bundle("wh_dlc06_skarsnik_karak_owned_false", "wh_main_grn_crooked_moon");
	cm:remove_effect_bundle("wh_dlc06_skarsnik_karak_owned_true", "wh_main_grn_crooked_moon");
	cm:remove_effect_bundle("wh2_main_queek_karak_owned_false", "wh2_main_skv_clan_mors");
	cm:remove_effect_bundle("wh2_main_queek_karak_owned_true", "wh2_main_skv_clan_mors");
	
	out("\tApplying effects...");
	
	if not cm:get_faction("wh_main_dwf_karak_izor"):has_effect_bundle("wh_dlc06_belegar_karak_owned_false_first") then
		out("\twh_dlc06_belegar_karak_owned_" .. tostring(belegar_owner));
		cm:apply_effect_bundle("wh_dlc06_belegar_karak_owned_" .. tostring(belegar_owner), "wh_main_dwf_karak_izor", 0);
	end;
	
	out("\twh2_main_queek_karak_owned_" .. tostring(queek_owner));
	cm:apply_effect_bundle("wh2_main_queek_karak_owned_" .. tostring(queek_owner), "wh2_main_skv_clan_mors", 0);
	
	out("\twh_dlc06_skarsnik_karak_owned_" .. tostring(skarsnik_owner));
	cm:apply_effect_bundle("wh_dlc06_skarsnik_karak_owned_" .. tostring(skarsnik_owner), "wh_main_grn_crooked_moon", 0);
	if skarsnik_owner == true then
		for i = 1, #skarsniks_locked_buildings do
			cm:remove_event_restricted_building_record_for_faction(skarsniks_locked_buildings[i], skarsnik_faction_name)
		end
	else
		for i = 1, #skarsniks_locked_buildings do
			cm:add_event_restricted_building_record_for_faction(skarsniks_locked_buildings[i], skarsnik_faction_name, "skarsnik_building_lock")
			local skarsnik_region_list = cm:get_faction("wh_main_grn_crooked_moon"):region_list()

			--loop through all of Skarsniks regions
			for j = 0, skarsnik_region_list:num_items() - 1 do
				local region_slot_list = skarsnik_region_list:item_at(j):slot_list()

				--check to see if the building exists in any of the regions
				skarsniks_locked_buildings_removal(region_slot_list)
			end
		end
	end
	out("#############################");
end;