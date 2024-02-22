


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	SHARED NARRATIVE FACTION DATA
--
--	PURPOSE
--	This file defines the base per-faction data related to narrative events.
--
--	As new playable cultures are added to the game, they will need to be added to this file. Errors should be generated
--	if they aren't.
--	
--	The create_base_narrative_faction_data() function which defines all base faction data is added
--	to the narrative system with a call to narrative.add_loader. The function will be called when the narrative system is started,
--	on or around the first tick.
--
--	LOADED
--	This file is loaded by wh3_narrative_loader.lua, which in turn should be loaded by the per-campaign narrative 
--	script file. It should get loaded on start of script.
--	
--	AUTHORS
--	SV
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

out.narrative("* wh3_narrative_shared_faction_data.lua loaded");

package.path = package.path .. ";" .. cm:get_campaign_folder() .. "/_narrative/races/?.lua;"





-- A mapping of faction culture to what narrative event script file(s) should be loaded that contains their race-specific missions.
-- When new playable cultures are added an entry will need to be created here.
-- The system should complain with a useful error if you try and hook up playable cultures that aren't represented in this table.
local FACTION_CULTURES_TO_RACIAL_NARRATIVE_EVENTS_FILENAMES_MAP = {
	-- WH1
	wh_main_emp_empire = 			{"wh3_narrative_empire"},
	wh_main_dwf_dwarfs = 			{"wh3_narrative_dwarfs"},
	wh_main_grn_greenskins = 		{"wh3_narrative_greenskins"},
	wh_main_vmp_vampire_counts = 	{"wh3_narrative_vampire_counts"},
	wh_main_chs_chaos = 			{"wh3_narrative_chaos_warriors"},
	wh_main_brt_bretonnia = 		{"wh3_narrative_bretonnia"},
	wh_dlc03_bst_beastmen = 		{"wh3_narrative_beastmen"},
	wh_dlc05_wef_wood_elves = 		{"wh3_narrative_wood_elves"},
	wh_dlc08_nor_norsca = 			{"wh3_narrative_norsca"},

	-- WH2
	wh2_main_hef_high_elves = 		{"wh3_narrative_high_elves"},
	wh2_main_def_dark_elves = 		{"wh3_narrative_dark_elves"},
	wh2_main_lzd_lizardmen = 		{"wh3_narrative_lizardmen"},
	wh2_main_skv_skaven = 			{"wh3_narrative_skaven"},
	wh2_dlc09_tmb_tomb_kings = 		{"wh3_narrative_tomb_kings"},
	wh2_dlc11_cst_vampire_coast = 	{"wh3_narrative_vampire_coast"},

	-- WH3
	wh3_main_ksl_kislev = 			{"wh3_narrative_kislev"},
	wh3_main_cth_cathay = 			{"wh3_narrative_cathay"},
	wh3_main_kho_khorne = 			{"wh3_narrative_khorne", "wh3_narrative_great_game", "wh3_narrative_chaos"},
	wh3_main_nur_nurgle = 			{"wh3_narrative_nurgle", "wh3_narrative_great_game", "wh3_narrative_chaos"},
	wh3_main_sla_slaanesh = 		{"wh3_narrative_slaanesh", "wh3_narrative_great_game", "wh3_narrative_chaos"},
	wh3_main_tze_tzeentch = 		{"wh3_narrative_tzeentch", "wh3_narrative_great_game", "wh3_narrative_chaos"},
	wh3_main_dae_daemons = 			{"wh3_narrative_daemon_prince", "wh3_narrative_chaos"},
	wh3_main_ogr_ogre_kingdoms = 	{"wh3_narrative_ogres"},
	wh3_dlc23_chd_chaos_dwarfs = 	{"wh3_narrative_chaos_dwarfs"},
};


-- Add a human-controlled faction to the narrative events faction data and load racial scripts with culture-based filename looked up from the table above.
-- This function is called from add_narrative_data_for_playable_faction() below.
local function add_playable_faction_with_racial_mapping(faction)

	local faction_key = faction:name();

	narrative.add_playable_faction(faction_key);

	local culture = faction:culture();

	local filenames = FACTION_CULTURES_TO_RACIAL_NARRATIVE_EVENTS_FILENAMES_MAP[culture];

	if not filenames then
		script_error("WARNING: add_playable_faction_with_racial_mapping() called for faction with key [" .. faction_key .. "], with culture [" .. culture .. "], but no entry exists for this culture in the FACTION_CULTURES_TO_RACIAL_NARRATIVE_EVENTS_FILENAMES_MAP table - check this file and make sure it's added");
		return false;
	end;

	for i = 1, #filenames do
		local filename = filenames[i];
		local file_path = "script/campaign/_narrative/races/" .. filename;

		if common.vfs_exists(file_path .. ".lua") then
			cm:load_global_script(filename);
		else
			script_error("WARNING: add_playable_faction_with_racial_mapping() is attempting to load race-specific narrative events script for faction [" .. faction_key .. "] with culture [" .. faction:culture() .. "] but file [" .. file_path .. "] doesn't exist - no race-specific narrative events will be loaded");
		end;
	end;
end;






-- Function to get the closest enemy to the player by getting the closest enemy settlement to the faction leader
local function get_initial_enemy_keys(faction_key)
	if not validate.is_string(faction_key) then
		return false
	end

	local enemy_faction_save_value = faction_key .. "_narrative_initial_faction"
	local enemy_region_save_value = faction_key .. "_narrative_initial_region"
	local enemy_province_save_value = faction_key .. "_narrative_initial_province"
	
	local savegame_faction_key = cm:get_saved_value(enemy_faction_save_value)
	if savegame_faction_key then
		return savegame_faction_key, cm:get_saved_value(enemy_region_save_value), cm:get_saved_value(enemy_province_save_value)
	elseif not cm:is_new_game() then
		return -- this is an old save game that did not have narrative missions set
	end;
	
	local faction = cm:get_faction(faction_key)
	local enemies = faction:factions_at_war_with()
	
	if enemies:is_empty() then
		script_error("ERROR: get_initial_enemy_keys() called but could not find any enemies for faction [" .. faction_key .. "]")
		return false
	end
	
	local character = faction:faction_leader()
	if not character:has_military_force() then
		local character_list = faction:character_list()
		for i = 0, character_list:num_items() -1 do
			local secondary_character = character_list:item_at(i)
			if secondary_character:has_military_force() and not secondary_character:military_force():is_armed_citizenry() then
				character = secondary_character
				break
			end
		end
	end
	local x = character:logical_position_x()
	local y = character:logical_position_y()
	local closest_enemy_regions = {}
	
	for _, enemy_faction in model_pairs(enemies) do
		table.insert(closest_enemy_regions, cm:get_closest_region_for_faction(enemy_faction, x, y))
	end
	
	local closest_dist = 9999999
	local closest_region
	
	for i = 1, #closest_enemy_regions do
		local current_region = closest_enemy_regions[i]
		local current_settlement = current_region:settlement()
		local current_x = current_settlement:logical_position_x()
		local current_y = current_settlement:logical_position_y()
		
		local current_dist = distance_squared(x, y, current_x, current_y)
		if current_dist < closest_dist then
			closest_dist = current_dist
			closest_region = current_region
		end
	end
	
	local enemy_faction_key = closest_region:owning_faction():name()
	local enemy_region_key = closest_region:name()
	local enemy_province_key = closest_region:province_name()
	
	cm:set_saved_value(enemy_faction_save_value, enemy_faction_key)
	cm:set_saved_value(enemy_region_save_value, enemy_region_key)
	cm:set_saved_value(enemy_province_save_value, enemy_province_key)
	
	return enemy_faction_key, enemy_region_key, enemy_province_key
end

-- Create base narrative data for a particular human-controlled faction.
-- This function is called from create_base_narrative_faction_data() below.
local function add_narrative_data_for_playable_faction(faction_key)
	local faction = cm:get_faction(faction_key, true);

	if not faction then
		return;
	end;

	add_playable_faction_with_racial_mapping(faction);
	
	
	-- set the starting enemy keys for each faction
	local enemy_faction_key, enemy_region_key, enemy_province_key = get_initial_enemy_keys(faction_key)
	narrative.add_data_for_faction(faction_key, "initial_enemy_faction_key", enemy_faction_key)
	narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_region_key", enemy_region_key)
	narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_province_keys", enemy_province_key)


	--
	--	Per-faction/culture overrides here
	--
	local culture = faction:culture();





	-- KISLEV
	if culture == "wh3_main_ksl_kislev" then

		-- A hack for Kislev agents - for Ice Witches, which are of type "wizard", the cm function can_recruit_agent() which is used by the narrative query can_recruit_hero_of_type
		-- reports that they can be recruited, but there aren't any available as they have to pass through the Ice Court first. We work around this by passing in a table which 
		-- explicitly excludes the "wizard" type to this function.
		local all_agent_types = cm:get_all_agent_types();
		local kislev_hero_type_for_can_recruit_hero_test = {};
		for i = 1, #all_agent_types do
			if all_agent_types[i] ~= "wizard" then
				table.insert(kislev_hero_type_for_can_recruit_hero_test, all_agent_types[i]);
			end;
		end;

		narrative.add_data_for_faction(faction_key, "shared_heroes_query_can_player_recruit_hero_hero_types", kislev_hero_type_for_can_recruit_hero_test);
	end;
	
	-- Mother Ostankya
	if faction_key == "wh3_dlc24_ksl_daughters_of_the_forest" then
		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_dlc24_camp_narrative_chaos_mother_ostankya_defeat_initial_enemy_01");	-- mission key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", 																		-- mission reward
			{
				payload.spirit_essence(10),
				payload.text_display("dummy_mother_ostankya_hex_5")
			}
		);
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_completed_messages", "StartMotherOstankyaHexMission")

		-- recruit units mission
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_block", true); -- don't trigger this mission

		-- use hex mission
		do
			local name = "mother_ostankya_event_hex";
			local mission_rewards = {payload.spirit_essence(20)}
			
			if cm:get_campaign_name() == "wh3_main_chaos" then
				table.insert(mission_rewards, payload.agent_for_faction(faction_key, "runesmith", "wh3_dlc24_ksl_hag_witch_beasts"))
			end

			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc24_camp_narrative_mother_ostankya_hex_01",										-- key of mission to deliver
					narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc24_narrative_mission_description_hex",											-- key of mission objective text
					narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
						{
							event = "RitualCompletedEvent",
							condition =	function(context)
								return context:performing_faction():name() == faction_key and context:ritual():ritual_category() == "OSTANKYA_HEX_RITUAL";
							end
						}
					},
					narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or mission_rewards,
					narrative.get(faction_key, name .. "_trigger_messages") or "StartMotherOstankyaHexMission",														-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages") or "StartSettlementCaptureChain",														-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;
		end;
		
		-- capture settlement 
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_dlc24_camp_narrative_chaos_mother_ostankya_capture_settlement_01")
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_advice_key", "")
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_completed_messages", {"StartSettlementCapturedChainFull", "StartMotherOstankyaWitchsHutMission"})

		-- capture province mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_dlc24_camp_narrative_chaos_mother_ostankya_complete_province_01");
		
		-- use witchs hut mission
		do
			local name = "mother_ostankya_event_witchs_hut";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc24_camp_narrative_mother_ostankya_witchs_hut_01",									-- key of mission to deliver
					narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc24_narrative_mission_description_witchs_hut",									-- key of mission objective text
					narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
						{
							event = "FactionCookedDish",
							condition =	function(context)
								return context:faction():name() == faction_key;
							end
						}
					},
					narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {
						payload.spirit_essence(5)																													-- issue money or equivalent
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "StartMotherOstankyaWitchsHutMission",												-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages") or "StartSettlementCaptureChain",														-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;
		end;
		
		-- consume spirit essence mission
		do
			local name = "mother_ostankya_event_gain_spirit_essence";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.consume_pooled_resource(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc24_camp_narrative_mother_ostankya_gain_spirit_essence_01",						-- key of mission to deliver
					narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc24_narrative_mission_description_ostankya_consume_spirit_essence",				-- key of mission objective text
					narrative.get(faction_key, name .. "_resource_key") or "wh3_dlc24_ksl_spirit_essence",															-- key of pooled resource
					narrative.get(faction_key, name .. "_resource_quantity") or mother_ostankya_features.hex_data.covens_cursemark.spirit_essence_requirement,		-- quantity of pooled resource
					narrative.get(faction_key, name .. "_factors") or {"hexes", "witchs_hut_brews"},																-- factors
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {
						payload.money(1000)																													-- issue money or equivalent
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "StartMotherOstankyaHexMission",														-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;
		end;
	end;
	
	
	
	
	
	-- TZEENTCH
	
	-- The Changeling
	if faction_key == "wh3_dlc24_tze_the_deceivers" then
		--[[ defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_dlc24_camp_narrative_the_changeling_defeat_initial_enemy_01");	-- mission key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", 																	-- mission reward
			{
				payload.grimoires(100),
				payload.agent_at_faction_leader("engineer", "wh3_dlc24_tze_the_changeling_cultist_special")
			}
		)
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_completed_messages", "StartChangelingEstablishCultMission")]]

		-- block missions that aren't relevant
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_block", true);
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_trade_mission_block", true);
		narrative.add_data_for_faction(faction_key, "shared_finance_gain_moderate_income_block", true);
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_non_aggression_pact_mission_block", true);
		narrative.add_data_for_faction(faction_key, "chaos_movements_trigger_start_block", true);
		
		-- establish cult mission
		local mission_key = "wh3_dlc24_camp_narrative_the_changeling_establish_cult_01";
		local region_key = narrative.get(faction_key, "shared_settlement_capture_event_capture_settlement_region_key")
		
		do
			local name = "the_changeling_event_establish_cult";
			
			if not narrative.get(faction_key, name .. "_block") then
				
				narrative_events.generic(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or mission_key,																				-- key of mission to deliver
					narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc24_narrative_mission_description_establish_cult",								-- key of mission objective text
					narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
						{
							event = "ForeignSlotManagerCreatedEvent",
							condition =	function(context)
								return context:requesting_faction():name() == faction_key and context:region():name() == region_key;
							end
						}
					},
					narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
						payload.grimoires(75),
						payload.agent_at_faction_leader("engineer", "wh3_dlc24_tze_the_changeling_cultist_special")
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "StartSettlementCaptureChain",														-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages") or "SetCultMissionCompletionState",													-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages") or "EstablishCultMissionCompleted",													-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;
		end;
		
		-- set the mission completion state for the above mission (adds the required region to the mission panel) - has to be done at the point the mission is issued
		do
			local name = "the_changeling_event_establish_cult_completion_state";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.callback(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_callback") or																								-- callback to call
						function()
							cm:set_scripted_mission_entity_completion_states(mission_key, mission_key .. "_1", {{cm:get_region(region_key), false}})
						end,
					narrative.get(faction_key, name .. "_trigger_messages") or "SetCultMissionCompletionState",														-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				);
			end;
		end;
		
		-- establish cult with hero mission
		do
			local name = "the_changeling_event_establish_cult_with_hero";
			
			if not narrative.get(faction_key, name .. "_block") then
				
				narrative_events.generic(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc24_camp_narrative_the_changeling_establish_cult_with_hero_01",					-- key of mission to deliver
					narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc24_narrative_mission_description_establish_cult_with_hero",						-- key of mission objective text
					narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
						{
							event = "CharacterGarrisonTargetAction",
							condition =	function(context)
								return the_changeling_features.bonus_cultist_buildings[context:agent_action_key()];
							end
						}
					},
					narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
						payload.grimoires(50),
						payload.text_display("dummy_wh3_dlc24_the_changeling_free_form")
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "EstablishCultMissionCompleted",														-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;
		end;
	end;
	
	
	
	
	
	-- CATHAY
	
	-- Yuan Bo, the Jade Dragon

	if faction_key == "wh3_dlc24_cth_the_celestial_court" then
		-- defeat initial enemy mission
		local mission_rewards = {payload.money(1000, faction_key)}
		
		if cm:get_campaign_name() == "wh3_main_chaos" then
			table.insert(mission_rewards, payload.agent_for_faction(faction_key, "champion", "wh3_dlc24_cth_gate_master"))
		end
		
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_dlc24_camp_narrative_chaos_yuan_bo_defeat_initial_enemy_01");				-- mission key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", mission_rewards);
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_completed_messages", "StartSettlementCaptureChain")

		-- recruit units mission
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_block", true); -- don't trigger this mission

		-- capture settlement 
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_dlc24_camp_narrative_chaos_yuan_bo_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_completed_messages", {"StartSettlementCapturedChainFull", "StartYuanBoMattersOfStateMission"})

		-- capture province mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_dlc24_camp_narrative_yuan_bo_complete_province_01");
		
		-- use matters of state mission
		do
			local name = "yuan_bo_event_matters_of_state";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc24_camp_narrative_yuan_bo_matters_of_state_01",									-- key of mission to deliver
					narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc24_narrative_mission_description_matters_of_state",								-- key of mission objective text
					narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
						{
							event = "RitualCompletedEvent",
							condition =	function(context)
								return context:performing_faction():name() == faction_key and context:ritual():ritual_category() == "YUAN_BO_ACTION";
							end
						}
					},
					narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {
						payload.money(																																-- issue money or equivalent
							1000,																																	-- money reward, if we aren't giving something else for this faction
							faction_key																																-- faction key
						)
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "StartYuanBoMattersOfStateMission",													-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;
		end;
	end;
	
	
	
	
	
	-- DAEMON PRINCE
	
	-- Daemon Prince

	if faction_key == "wh3_main_dae_daemon_prince" then
		narrative.add_data_for_faction(faction_key, "shared_technology_chain_block", true); -- daemon prince has no technology
	end;
	
	
	
	
	
	-- BEASTMEN

	if culture == "wh_dlc03_bst_beastmen" then
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_block", true); -- beastmen cannot control entire provinces, just single herdstone regions
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_two_provinces_block", true);
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_provinces_block", true);
		narrative.add_data_for_faction(faction_key, "shared_finance_query_advice_block", true); -- beastmen do not get income
	end;
end;








-- Create base narrative data for all human-controlled factions
local function create_base_narrative_faction_data()
	-- Load racial mappings for all human factions in this campaign game, based on their culture
	local human_factions = cm:get_human_factions();
	
	for i = 1, #human_factions do
		local faction_key = human_factions[i]
		
		add_narrative_data_for_playable_faction(faction_key)
	end;		
end;

narrative.add_data_setup_callback(create_base_narrative_faction_data)
