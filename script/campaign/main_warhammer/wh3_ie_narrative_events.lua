------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	IE NARRATIVE EVENTS
--
--	PURPOSE
--	This file defines narrative events/queries/triggers that are specific to the IE campaign, shared between all races.
--	It also loads the shared narrative events - this is the only narrative-event related file that the campaign scripts
--	related to this campaign should need to load.
--
--	LOADED
--	Loaded on start of script when playing the IE campaign map.
--	
--	AUTHORS
--	SV/MS
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

out.narrative("* wh3_ie_narrative_events.lua loaded")



-- Ensure that shared narrative events and the narrative event loader are loaded first
package.path = package.path .. ";" .. cm:get_campaign_folder() .. "/_narrative/?.lua"
require("wh3_narrative_loader")



------------------------------------------------------------------------------------------------------------------
-- Narrative Event customisation per-faction in this campaign
------------------------------------------------------------------------------------------------------------------

local function customise_narrative_event_faction_data_for_campaign(faction_key)
	
	-- Customise the narrative event faction data table here, if required. Customisations added here are for this campaign only.
	-- Customisations for a faction for ALL campaigns should be made in the base data in wh3_narrative_shared_faction_data.lua.
	-- Customisations for all factions, but only for this campaign, are made in the campaign data declared elsewhere in this file.
	
	
	
	-- EMPIRE
	if faction_key == "wh_main_emp_empire" then
		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh_main_prelude_attack_enemy_empire_1")
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_advice_key", "war.camp.prelude.emp.attacking_enemy.001")
		
		-- capture settlement
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh_main_prelude_capture_grunburg_empire_1")
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_advice_key", "war.camp.prelude.emp.capture_settlement.001")
		
		-- construct tech building
		narrative.add_data_for_faction(faction_key, "shared_technology_research_construct_technology_building_mission_key", "wh_main_prelude_construct_technology_building_empire_1")
		narrative.add_data_for_faction(faction_key, "shared_technology_research_construct_technology_building_advice_key", "war.camp.prelude.emp.technology.001")
		
		-- research tech
		narrative.add_data_for_faction(faction_key, "shared_technology_research_research_any_technology_mission_key", "wh_main_prelude_research_technology_empire_1")
		narrative.add_data_for_faction(faction_key, "shared_technology_research_research_any_technology_advice_key", "war.camp.prelude.emp.technology.002")
	end
	
	
	
	-- DWARFS
	if faction_key == "wh_main_dwf_dwarfs" then
		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh_main_prelude_attack_enemy_dwarfs_1")
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_advice_key", "war.camp.prelude.dwf.attacking_enemy.001")
		
		-- capture settlement
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh_main_prelude_capture_pillars_of_grungni_dwarfs_1")
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_advice_key", "war.camp.prelude.dwf.capture_settlement.001")
	end
	
	
	
	-- VAMPIRE COUNTS
	if faction_key == "wh_main_vmp_schwartzhafen" then
		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh_main_prelude_attack_enemy_vampire_counts_1")
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_advice_key", "war.camp.prelude.vmp.attacking_enemy.001")
		
		-- capture settlement
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh_main_prelude_capture_eschen_vampire_counts_1")
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_advice_key", "war.camp.prelude.vmp.capture_settlement.001")
	end
	
	
	
	-- TOMB KINGS
	if faction_key == "wh2_dlc09_tmb_khemri" then
		narrative.add_data_for_faction(faction_key, "initial_enemy_faction_key", "wh2_dlc09_tmb_numas")
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_region_key", "wh3_main_combi_region_numas")
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_province_keys", "wh3_main_combi_province_land_of_the_dead")
	end
	
	
	
	-- KISLEV
	if faction_key == "wh3_dlc24_ksl_daughters_of_the_forest" then
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_dlc24_camp_narrative_ie_mother_ostankya_defeat_initial_enemy_01")
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_dlc24_camp_narrative_ie_mother_ostankya_capture_settlement_01")
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_dlc24_camp_narrative_ie_mother_ostankya_complete_province_01")
	end
	
	
	
	-- CATHAY
	if faction_key == "wh3_dlc24_cth_the_celestial_court" then
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_dlc24_camp_narrative_ie_yuan_bo_defeat_initial_enemy_01")
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_dlc24_camp_narrative_ie_yuan_bo_capture_settlement_01")
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_region_key", "wh3_main_combi_region_the_high_sentinel")
	end
end

narrative.add_data_setup_callback(
	function()
		local human_factions = cm:get_human_factions()
		for i = 1, #human_factions do
			customise_narrative_event_faction_data_for_campaign(human_factions[i])
		end
	end
)



------------------------------------------------------------------------------------------------------------------
-- Narrative Event customisation for all factions in this campaign
------------------------------------------------------------------------------------------------------------------

local function setup_campaign_narrative_event_data_all_factions()
	narrative.add_data_for_campaign("shared_event_defeat_initial_enemy_completed_messages",					{"StartSettlementCaptureChain"})
end

narrative.add_data_setup_callback(setup_campaign_narrative_event_data_all_factions)



------------------------------------------------------------------------------------------------------------------
-- Start Narrative Events
------------------------------------------------------------------------------------------------------------------

-- Called by the campaign script to start all narrative events for all player factions. This calls narrative.start_narrative_events_shared(), passing in 
-- the campaign-specific narrative event loader function.
function start_narrative_events()

	-- <Data setup callbacks and narrative event loaders are added elsewhere from this function>

	-- Setup all narrative data
	narrative.start()
end



------------------------------------------------------------------------------------------------------------------
-- Start Campaign-Specific Narrative Events
------------------------------------------------------------------------------------------------------------------

function start_narrative_events_ie_for_faction(faction_key)

end


-- Ensure that start_narrative_events_ie_for_faction() is called when narrative system is started
narrative.add_loader(start_narrative_events_ie_for_faction)