


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

	if faction_key == "wh3_dlc26_ogr_golgfag" then
		-- golgfag starts with no starting enemies by design.
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
	

	-- HIGH ELVES

	-- Teclis

	if faction_key == "wh2_main_hef_order_of_loremasters" then
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_dlc27_teclis_saphery_confederation_mission"); -- Teclis has a unique mission for obtaining his first province, so this mission chain is not needed
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_rewards", {payload.money(1500, faction_key), payload.pooled_resource_mission_payload("wh3_dlc27_hef_scrolls_of_power", "wh3_dlc27_hef_scrolls_of_power_other", 50)});
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_block", true);
	end;
	
	
	-- BEASTMEN

	if culture == "wh_dlc03_bst_beastmen" then
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_block", true); -- beastmen cannot control entire provinces, just single herdstone regions
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_two_provinces_block", true);
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_provinces_block", true);
		narrative.add_data_for_faction(faction_key, "shared_finance_query_advice_block", true); -- beastmen do not get income
		narrative.add_data_for_faction(faction_key, "shared_technology_chain_block", true); -- beastmen technology works differently to how these missions expect it to
	end;





	-- OGRE KINGDOMS

	if culture == "wh3_main_ogr_ogre_kingdoms" then
		-- Text overrides for upgrade settlement missions
		narrative.add_data_for_faction(faction_key, "shared_settlement_upgrade_upgrade_any_settlement_level_three_mission_key", "wh3_main_camp_narrative_ogres_upgrade_settlement_02");
		narrative.add_data_for_faction(faction_key, "shared_settlement_upgrade_upgrade_any_settlement_level_five_mission_key", "wh3_main_camp_narrative_ogres_upgrade_settlement_03");

		-- Switch in "evil" diplomacy advice line variants
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_non_aggression_pact_mission_advice_key", "wh3_main_camp_narrative_shared_non_aggression_pact_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_trade_mission_advice_key", "wh3_main_camp_narrative_shared_trade_agreement_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_confederation_mission_advice_key", "wh3_main_camp_narrative_shared_war_confederation_02");
		narrative.add_data_for_faction(faction_key, "ogre_contracts_trigger_war_contract_block", true)
	end


	-- Golgfag
	if faction_key == "wh3_dlc26_ogr_golgfag" then
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_block", true);
		narrative.add_data_for_faction(faction_key, "ogre_contracts_trigger_war_contract_block", false)
	end





	-- KHORNE

	-- Arbaal
	if faction_key == "wh3_dlc26_kho_arbaal" then
		narrative.add_data_for_faction(faction_key, "khorne_win_streaks_use_eternal_war_mission_block", true);
		narrative.add_data_for_faction(faction_key, "chaos_movements_trigger_start_block", true);
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_query_advice_block", true);
		narrative.add_data_for_faction(faction_key, "shared_heroes_query_advice_block", true);

		-- defeat initial enemy
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_dlc26_camp_narrative_arbaal_defeat_initial_enemy_01");
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", {payload.money(500, faction_key), payload.khornes_favour(1)});

		-- capture settlement
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_dlc26_camp_narrative_arbaal_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_rewards", {payload.money(750, faction_key), payload.khornes_favour(1)});

		-- trigger challenges when favour reaches 5
		do
			local name = "arbaal_gains_khorne_favour";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_triggers.faction_pooled_resource_gained(
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages") or "StartNarrativeEvents",																-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or {"StartArbaalChallengeMission", "StartArbaalBoonMission"},							-- script message(s) to fire when this narrative trigger triggers
					narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
					narrative.get(faction_key, name .. "_pooled_resource_faction_key") or faction_key,																-- key of faction to monitor resource changes for
					narrative.get(faction_key, name .. "_pooled_resource_key") or "wh3_dlc26_kho_arbaal_wrath_of_khorne_progress",									-- pooled resource key(s)
					narrative.get(faction_key, name .. "_threshold_value") or 5																						-- threshold value
				);
			end;
		end;

		-- complete a challenge mission
		do
			local name = "arbaal_complete_challenge_mission";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc26_camp_narrative_arbaal_complete_a_challenge_01",								-- key of mission to deliver
					narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc26_narrative_mission_description_arbaal_challenge",								-- key of mission objective text
					narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
						{
							event = "MissionSucceeded",
							condition =	function(context)
								return context:mission():mission_record_key():starts_with("wh3_dlc26_arbaal_wrath_of_khorne_mission_")
							end
						}
					},
					narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {
						payload.money(																																-- issue money or equivalent
							1000,																																	-- money reward, if we aren't giving something else for this faction
							faction_key																																-- faction key
						),
						payload.skulls(500)
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "StartArbaalChallengeMission",														-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;
		end;

		-- activate a boon mission
		do
			local name = "arbaal_activate_boon_mission";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc26_camp_narrative_arbaal_activate_a_boon_01",										-- key of mission to deliver
					narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc26_narrative_mission_description_arbaal_activate_boon",							-- key of mission objective text
					narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
						{
							event = "FactionInitiativeActivationChangedEvent",
							condition =	function(context)
								return context:active()
							end
						}
					},
					narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {
						payload.skulls(200)
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "StartArbaalBoonMission",															-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;
		end;
	end

	-- Skulltaker
	if faction_key == "wh3_dlc26_kho_skulltaker" then
		-- defeat initial enemy
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_dlc26_camp_narrative_skulltaker_defeat_initial_enemy_01");
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", {payload.money(500, faction_key), payload.champions_essence(5)});

		-- capture settlement
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_dlc26_camp_narrative_skulltaker_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_rewards", {payload.money(750, faction_key), payload.champions_essence(5)});

		-- trigger empower skull mission when essence reaches 25
		do
			local name = "skulltaker_gains_champions_essence";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_triggers.faction_pooled_resource_gained(
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages") or "StartNarrativeEvents",																-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or {"StartSkulltakerEmpowerSkullMission"},												-- script message(s) to fire when this narrative trigger triggers
					narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
					narrative.get(faction_key, name .. "_pooled_resource_faction_key") or faction_key,																-- key of faction to monitor resource changes for
					narrative.get(faction_key, name .. "_pooled_resource_key") or "wh3_dlc26_kho_champions_essence_faction",										-- pooled resource key(s)
					narrative.get(faction_key, name .. "_threshold_value") or 25																					-- threshold value
				);
			end;
		end;

		-- empower skull mission
		do
			local name = "skulltaker_empower_skull";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc26_camp_narrative_skulltaker_empower_skull_01",									-- key of mission to deliver
					narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc26_narrative_mission_description_skulltaker_empower_skull",						-- key of mission objective text
					narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
						{
							event = "RitualCompletedEvent",
							condition =	function(context)
								return context:performing_faction():name() == faction_key and context:ritual():ritual_category() == "CLOAK_OF_SKULLS";
							end
						}
					},
					narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {payload.money(1000)},
					narrative.get(faction_key, name .. "_trigger_messages") or "StartSkulltakerEmpowerSkullMission",												-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;
		end;
	end

	-- GREENSKINS

	if culture == "wh_main_grn_greenskins" then
		narrative.add_data_for_faction(faction_key, "greenskins_da_plan_trigger_campaign_start_equip_tactic_block", true)
	end

	-- Gorbad
	if faction_key == "wh3_dlc26_grn_gorbad_ironclaw" then
		narrative.add_data_for_faction(faction_key, "greenskins_da_plan_trigger_campaign_start_equip_tactic_block", false)
	end


	--SLAANESH

	--Dechala
	if faction_key == "wh3_dlc27_sla_the_tormentors" then
		narrative.add_data_for_faction(faction_key, "slaanesh_gift_of_slaanesh_earn_devotees_from_gifts_block", true);
		narrative.add_data_for_faction(faction_key, "slaanesh_devotees_event_gain_devotees_block", true);
		narrative.add_data_for_faction(faction_key, "slaanesh_devotees_trigger_expert_on_devotees_block", true);
		narrative.add_data_for_faction(faction_key, "slaanesh_devotees_event_gain_many_devotees_block", true);
		narrative.add_data_for_faction(faction_key, "slaanesh_seductive_influence_advice_query_block", true);
		narrative.add_data_for_faction(faction_key, "slaanesh_seductive_influence_query_has_unlocked_option_block", true);
		narrative.add_data_for_faction(faction_key, "slaanesh_seductive_influence_unlock_diplomatic_option_block", true);
		narrative.add_data_for_faction(faction_key, "slaanesh_seductive_influence_trigger_expert_on_options_unlocked_block", true);
		narrative.add_data_for_faction(faction_key, "slaanesh_seductive_influence_earn_max_influence_block", true);
		narrative.add_data_for_faction(faction_key, "slaanesh_seduction_event_seduce_unit_block", true);
		narrative.add_data_for_faction(faction_key, "slaanesh_seduction_research_seduction_technology_block", true);
	end


	-- The Masque of Slaanesh
	if faction_key == "wh3_dlc27_sla_masque_of_slaanesh" then

		narrative.add_data_for_faction(faction_key, "slaanesh_seductive_influence_query_has_unlocked_option_block", true);
		narrative.add_data_for_faction(faction_key, "slaanesh_seductive_influence_unlock_diplomatic_option_block", true);
		narrative.add_data_for_faction(faction_key, "slaanesh_seductive_influence_trigger_expert_on_options_unlocked_block", true);
		narrative.add_data_for_faction(faction_key, "slaanesh_seductive_influence_earn_max_influence_block", true);
		
		local tempo_level_threshold = 2

		local tempo_initiatives_keys_level_1_substring = "wh3_dlc27_eternal_dance_tempo_1"

		local tempo_initiatives_keys_level_3_army_abilities_substring = "wh3_dlc27_eternal_dance_tempo_3_ability"

		local tempo_initiatives_keys_level_4_substring = "wh3_dlc27_eternal_dance_tempo_4"

		local tempo_rituals_keys_substring = "wh3_dlc27_sla_ritual_masque_of"


		-- Reach Tempo level 2
		do
			local name = "masque_tempo_level_2";
			
			if not narrative.get(faction_key, name .. "_block") then
				narrative_triggers.generic( --TODO: This trigger doesnt work
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages") or "StartNarrativeEvents",																-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or "MasqueLevel1TempoReached",											-- target message(s) to trigger
					narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
					narrative.get(faction_key, name .. "_event") or "CharacterInitiativeActivationChangedEvent",																-- event name
					narrative.get(faction_key, name .. "_condition") or																								-- event condition
						function(context)
							-- Return true if the player has unlocked level 1 of Masque's Tempo
							return string.find(context:initiative():record_key(), tempo_initiatives_keys_level_1_substring)
						end,
					narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
				);

				narrative_events.generic(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc27_camp_narrative_sla_masque_up_tempo_01",					-- key of mission to deliver
					narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc27_mission_narrative_sla_masque_up_tempo_01",						-- key of mission objective text
					narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
						{
							event = "EternalDanceTempoThresholdUpgraded",
							condition =	function(context)
								-- Return true when the player has unlocked level 2 of Masque's Tempo
								if context.stored_table.general:faction():name() == faction_key then 
									return context.stored_table.tempo_level >= tempo_level_threshold 
								end
							end
						}
					},
					narrative.get(faction_key, name .. "_camera_scroll_callback"),																			-- camera scroll callback
					narrative.get(faction_key, name .. "_mission_issuer"),																					-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {
						payload.money(500),
						payload.ancillary_mission_payload(faction_key, "general", "common")
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "MasqueLevel1TempoReached",
					narrative.get(faction_key, name .. "_on_issued_messages") or "MasqueLevel2TempoStarted",										-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages") or "MasqueLevel2TempoCompleted",										-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																						-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;

		end;

		-- Choose an army ability, triggered on reaching Tempo level 3
		do
			local name = "masque_tempo_level_3";
			
			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc27_camp_narrative_sla_masque_up_tempo_02",					-- key of mission to deliver
					narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc27_mission_narrative_sla_masque_up_tempo_02",						-- key of mission objective text
					narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
						{
							event = "CharacterInitiativeActivationChangedEvent",
							condition =	function(context)

								return string.find(context:initiative():record_key(), tempo_initiatives_keys_level_3_army_abilities_substring)
							end
						}
					},
					narrative.get(faction_key, name .. "_camera_scroll_callback"),																			-- camera scroll callback
					narrative.get(faction_key, name .. "_mission_issuer"),																					-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {
						payload.money(1000),
						payload.ancillary_mission_payload(faction_key, "arcane_item", "common")
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "MasqueLevel2TempoCompleted",
					narrative.get(faction_key, name .. "_on_issued_messages") or "MasqueLevel3TempoStarted",										-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages") or "MasqueLevel3TempoCompleted",										-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																						-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;

		end;

		do
			local name = "masque_tempo_level_4";
			
			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc27_camp_narrative_sla_masque_up_tempo_03",					-- key of mission to deliver
					narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc27_mission_narrative_sla_masque_up_tempo_03",						-- key of mission objective text
					narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
						{
							event = "CharacterInitiativeActivationChangedEvent",
							condition =	function(context)
								return string.find(context:initiative():record_key(), tempo_initiatives_keys_level_4_substring)
							end
						}
					},
					narrative.get(faction_key, name .. "_camera_scroll_callback"),																			-- camera scroll callback
					narrative.get(faction_key, name .. "_mission_issuer"),																					-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {
						payload.money(1250),
						payload.ancillary_mission_payload(faction_key, "arcane_item", "uncommon")
					},														-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_trigger_messages") or "MasqueLevel3TempoCompleted",
					narrative.get(faction_key, name .. "_on_issued_messages") or "MasqueLevel4TempoStarted",										-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages") or "MasqueLevel4TempoCompleted",										-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																						-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;

		end;

		do
			local name = "masque_tempo_ritual_cast";
			
			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc27_camp_narrative_sla_masque_up_tempo_04",					-- key of mission to deliver
					narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc27_mission_narrative_sla_masque_up_tempo_04",						-- key of mission objective text
					narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
						{
							event = "RitualEvent",
							condition =	function(context)
								return string.find(context:initiative():record_key(), tempo_rituals_keys_substring)
							end
						}
					},
					narrative.get(faction_key, name .. "_camera_scroll_callback"),																			-- camera scroll callback
					narrative.get(faction_key, name .. "_mission_issuer"),																					-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {
						payload.money(1500),
						payload.ancillary_mission_payload(faction_key, "general", "uncommon")
					},															
					narrative.get(faction_key, name .. "_trigger_messages") or "MasqueLevel4TempoCompleted",								-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages") or "MasqueLevel4Ritual",										-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages") or "MasqueLevel4RitualCompleted",										-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																						-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;

		end;
	end
	--Throgg
	if faction_key == "wh_dlc08_nor_wintertooth" then
		--[[ trigger Trollkind mission on turn 2
		do
			local name = "wh3_dlc27_wintertooth_trollkind_trigger";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_triggers.turn_countdown(
				name,																																			-- unique name for this narrative trigger
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages") or "DefeatInitialEnemyCompleted",															-- script message(s) on which to start
				narrative.get(faction_key, name .. "_completed_messages") or "StartWintertoothTrollkindMission",												-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_num_turns") or 2,																							-- num turns to wait
				narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
			);
			end;
		end;]]
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_completed_messages", {"StartSettlementCapturedChainFull", "StartWintertoothTrollkindMission"})
		do
			local name = "wh3_dlc27_wintertooth_trollkin_resource";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.gain_pooled_resource_scripted(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc27_wintertooth_trollkin_resource_01",												-- key of mission to deliver
				narrative.get(faction_key, name .. "_mission_text") or "wh3_dlc27_narrative_mission_description_wintertooth_trollkin_resource",								-- key of mission objective text
				narrative.get(faction_key, name .. "_pooled_resources") or "wh3_dlc27_nor_kinfolk",																	-- pooled resource(s)
				narrative.get(faction_key, name .. "_lower_threshold") or 30,																					-- lower threshold value
				narrative.get(faction_key, name .. "_upper_threshold"),																							-- upper threshold value
				narrative.get(faction_key, name .. "_is_additive") or false,																					-- is additive (value of all resources counts towards total)
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {
						payload.money(1000),
						payload.text_display("dummy_wh3_dlc27_wintertooth_trollkind_dilemma")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartWintertoothTrollkindMission",															-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
			end;
		end;
	end
	-- Lokhir Felheart
	if faction_key == "wh2_dlc11_def_the_blessed_dread" then
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_two_provinces_completed_messages", {"SettlementCapturedCaptureTwoProvincesCompleted", "StartSettlementCapturedChainTransitionToExpert", "StartEasternIslesChain"})
		do
			local name = "wh3_dlc27_def_blessed_dread_control_eastern_isles"
			if not narrative.get(faction_key, name .. "_block") then
			narrative_events.control_provinces(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
				narrative.get(faction_key, name .. "_mission_key") or "wh3_dlc27_def_blessed_dread_control_eastern_isles",										-- key of mission to deliver
				narrative.get(faction_key, name .. "_num_provinces") or 1,																						-- number of provinces
				narrative.get(faction_key, name .. "_province_keys") or "wh3_main_combi_province_eastern_colonies",																							-- opt list of province keys
				narrative.get(faction_key, name .. "_camera_target"),																							-- target to move camera to (can be string region/faction key, char cqi, table with x/y display positions, or nil)
				narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
				narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
					payload.money(1000),																															-- issue money or equivalent
					payload.slaves(400),
					payload.text_display("dummy_wh3_dlc27_blessed_dread_sea_lanes_unlocked")
				},
				narrative.get(faction_key, name .. "_trigger_messages") or "StartEasternIslesChain",															-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				narrative.get(faction_key, name .. "_completed_messages"),
				narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
			);
			end
		end
	end
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
