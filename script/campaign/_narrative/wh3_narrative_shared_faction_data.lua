


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








-- Create base narrative data for a particular human-controlled faction.
-- This function is called from create_base_narrative_faction_data() below.
local function add_narrative_data_for_playable_faction(faction_key)
	local faction = cm:get_faction(faction_key, true);

	if not faction then
		return;
	end;

	add_playable_faction_with_racial_mapping(faction);


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
end;








-- Create base narrative data for all human-controlled factions
local function create_base_narrative_faction_data()
	-- Load racial mappings for all human factions in this campaign game, based on their culture
	local human_factions = cm:get_human_factions();
	for i = 1, #human_factions do
		add_narrative_data_for_playable_faction(human_factions[i]);
	end;		
end;

narrative.add_data_setup_callback(create_base_narrative_faction_data)
