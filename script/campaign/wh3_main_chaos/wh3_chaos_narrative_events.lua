------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	CHAOS NARRATIVE EVENTS
--
--	PURPOSE
--	This file defines narrative events/queries/triggers that are specific to the Chaos campaign, shared between all races.
--	It also loads the shared narrative events - this is the only narrative-event related file that the campaign scripts
--	related to this campaign should need to load.
--
--	LOADED
--	Loaded on start of script when playing the Chaos campaign map.
--	
--	AUTHORS
--	SV
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

out.narrative("* wh3_chaos_narrative_events.lua loaded");




-- Ensure that shared narrative events and the narrative event loader are loaded first
package.path = package.path .. ";" .. cm:get_campaign_folder() .. "/_narrative/?.lua"
require("wh3_narrative_loader");

narrative.add_exception_faction("wh3_dlc20_chs_azazel")
narrative.add_exception_faction("wh3_dlc20_chs_festus")
narrative.add_exception_faction("wh3_dlc20_chs_valkia")
narrative.add_exception_faction("wh3_dlc20_chs_vilitch")
narrative.add_exception_faction("wh3_dlc23_chd_astragoth")
narrative.add_exception_faction("wh3_dlc23_chd_legion_of_azgorh")
narrative.add_exception_faction("wh3_dlc23_chd_zhatan")

------------------------------------------------------------------------------------------------------------------
-- Realm Intro Cutscenes
--
-- These functions are passed in to the narrative events that play the realm intro cutscenes. They configure
-- the cutscenes, adding actions or setting configuration options. The function(s) are called after the cutscene
-- is created and before it is triggered, and are passed the cutscene object as a single argument.
--
-- The actual cindyscene to play is set in the declaration of the narrative event, and doesn't need to be set
-- here.
------------------------------------------------------------------------------------------------------------------

--
-- SHARED
local function shared_realm_intro_config(c)	
	c:set_disable_shroud(true);
	cm:force_terrain_patch_visible("");
	
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_realms_preamble_01", function() cm:show_advice("wh3_main_camp_narrative_chs_realms_preamble_01") end);
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_realms_preamble_02", function() cm:show_advice("wh3_main_camp_narrative_chs_realms_preamble_02") end);
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_realms_preamble_03", function() cm:show_advice("wh3_main_camp_narrative_chs_realms_preamble_03") end);
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_realms_preamble_04", function() cm:show_advice("wh3_main_camp_narrative_chs_realms_preamble_04") end);
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_realms_preamble_05", function() cm:show_advice("wh3_main_camp_narrative_chs_realms_preamble_05") end);
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_realms_preamble_06", function() cm:show_advice("wh3_main_camp_narrative_chs_realms_preamble_06") end);

	c:set_show_advisor_close_button_on_end(true);

	c:set_skippable(
		true,
		function()
			cm:fade_scene(0, 0);
		end
	);

	c:action(
		function()
			common.trigger_soundevent("Play_Movie_warhammer3_chaos_realm_intro_in_stinger");
		end,
		0
	);

	c:set_fade_on_skip(false);		-- fading to black/back to picture handled by narrative events
end;



--
-- KHORNE REALM

-- setup trigger listeners for the first line of Khorne advice, which can be different based on the player's lord
local function khorne_realm_intro_setup_initial_advice_key(c, initial_advice_key_override)
	c:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_khorne_realm_intro_01",
		function() cm:show_advice(initial_advice_key_override or "wh3_main_camp_narrative_chs_khorne_realm_intro_01b") end
	);
end;

-- setup trigger listeners for shared khorne advice (other than the first line)
local function khorne_realm_intro_shared_config(c)
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_khorne_realm_intro_02", function() cm:show_advice("wh3_main_camp_narrative_chs_khorne_realm_intro_01") end);
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_khorne_realm_intro_03", function() cm:show_advice("wh3_main_camp_narrative_chs_khorne_realm_intro_02") end);
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_khorne_realm_intro_04", function() cm:show_advice("wh3_main_camp_narrative_chs_khorne_realm_intro_03") end);
	c:set_skip_camera(366.727264, 515.416321, 17.227818, 0, 23.436743);
end;

-- Default configuration for Khorne realm intros
local function khorne_realm_intro_short_config(c, initial_advice_key_override)
	shared_realm_intro_config(c);
	khorne_realm_intro_setup_initial_advice_key(c, initial_advice_key_override);
	khorne_realm_intro_shared_config(c);
	c:set_music_trigger_argument("realm_intro_khorne_short")
end;

local function khorne_realm_intro_long_config(c, initial_advice_key_override)
	shared_realm_intro_config(c);
	khorne_realm_intro_setup_initial_advice_key(c, initial_advice_key_override);
	khorne_realm_intro_shared_config(c);
	c:set_music_trigger_argument("realm_intro_khorne_long")
end;

local SKARBRAND_KHORNE_REALM_INTRO_ADVICE_KEY = "wh3_main_camp_narrative_chs_khorne_realm_intro_04";

-- If the player is Skarbrand, these functions are used as the realm intro cutscene configurators
local function khorne_realm_intro_short_config_skarbrand(c)
	khorne_realm_intro_long_config(c, SKARBRAND_KHORNE_REALM_INTRO_ADVICE_KEY);
	c:set_music_trigger_argument("realm_intro_khorne_short_skarbrand")
end;

local function khorne_realm_intro_long_config_skarbrand(c)
	khorne_realm_intro_long_config(c, SKARBRAND_KHORNE_REALM_INTRO_ADVICE_KEY);
	c:set_music_trigger_argument("realm_intro_khorne_long_skarbrand")
end;



--
-- NURGLE REALM

-- setup trigger listeners for shared Nurgle advice (other than the first line)
local function nurgle_realm_intro_shared_config(c)
	shared_realm_intro_config(c);
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_nurgle_realm_intro_02", function() cm:show_advice("wh3_main_camp_narrative_chs_nurgle_realm_intro_01") end);
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_nurgle_realm_intro_03", function() cm:show_advice("wh3_main_camp_narrative_chs_nurgle_realm_intro_02") end);
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_nurgle_realm_intro_04", function() cm:show_advice("wh3_main_camp_narrative_chs_nurgle_realm_intro_03") end);
	c:set_skip_camera(419.517731, 409.632935, 11.386414, 0, 16.380138);
end;

-- Standard first intro line
local function nurgle_realm_config_first_line_standard(c)
	c:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_nurgle_realm_intro_01b",
		function() cm:show_advice("wh3_main_camp_narrative_chs_nurgle_realm_intro_01b") end
	);
end;

-- Default configuration for Nurgle realm intros
local function nurgle_realm_intro_short_config(c)
	nurgle_realm_config_first_line_standard(c);
	nurgle_realm_intro_shared_config(c);
	c:set_music_trigger_argument("realm_intro_nurgle_short");
end;

local function nurgle_realm_intro_long_config(c)	
	nurgle_realm_config_first_line_standard(c);
	nurgle_realm_intro_shared_config(c);
	c:set_music_trigger_argument("realm_intro_nurgle_long");
end;

-- Kugath-specific intro line
local function nurgle_realm_config_first_line_kugath(c)
	c:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_nurgle_realm_intro_01",
		function() cm:show_advice("wh3_main_camp_narrative_chs_nurgle_realm_intro_04") end
	);
end;

-- If the player is Ku'gath, these functions are used as the realm intro cutscene configurators
local function nurgle_realm_intro_short_config_kugath(c)	
	nurgle_realm_config_first_line_kugath(c);
	nurgle_realm_intro_shared_config(c);
	c:set_music_trigger_argument("realm_intro_nurgle_short_kugath");
end;

local function nurgle_realm_intro_long_config_kugath(c)	
	nurgle_realm_config_first_line_kugath(c);
	nurgle_realm_intro_shared_config(c);
	c:set_music_trigger_argument("realm_intro_nurgle_long_kugath");
end;



--
-- SLAANESH REALM

-- setup trigger listeners for shared Slaanesh advice (other than the first line)
local function slaanesh_realm_intro_shared_config(c)
	shared_realm_intro_config(c);
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_slaanesh_realm_intro_02", function() cm:show_advice("wh3_main_camp_narrative_chs_slaanesh_realm_intro_01") end);
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_slaanesh_realm_intro_03", function() cm:show_advice("wh3_main_camp_narrative_chs_slaanesh_realm_intro_02") end);
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_slaanesh_realm_intro_04", function() cm:show_advice("wh3_main_camp_narrative_chs_slaanesh_realm_intro_03") end);
	c:set_skip_camera(451.582977, 501.44696, 16.672302, 0, 21.869736);
end;

-- Standard first intro line
local function slaanesh_realm_config_first_line_standard(c)
	c:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_slaanesh_realm_intro_01b",
		function() cm:show_advice("wh3_main_camp_narrative_chs_slaanesh_realm_intro_01b") end
	);
end;

-- Default configuration for Slaanesh realm intros
local function slaanesh_realm_intro_short_config(c)
	slaanesh_realm_config_first_line_standard(c);
	slaanesh_realm_intro_shared_config(c);
	c:set_music_trigger_argument("realm_intro_slaanesh_short");
end;

local function slaanesh_realm_intro_long_config(c)
	slaanesh_realm_config_first_line_standard(c);
	slaanesh_realm_intro_shared_config(c);
	c:set_music_trigger_argument("realm_intro_slaanesh_long");
end;

-- Nkari-specific intro line
local function slaanesh_realm_config_first_line_nkari(c)
	c:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_slaanesh_realm_intro_01",
		function() cm:show_advice("wh3_main_camp_narrative_chs_slaanesh_realm_intro_04") end
	);
end;

-- If the player is N'kari, these functions are used as the realm intro cutscene configurators
local function slaanesh_realm_intro_short_config_nkari(c)
	slaanesh_realm_config_first_line_nkari(c)
	slaanesh_realm_intro_shared_config(c);
	c:set_music_trigger_argument("realm_intro_slaanesh_short_nkari");
end;

local function slaanesh_realm_intro_long_config_nkari(c)
	slaanesh_realm_config_first_line_nkari(c)
	slaanesh_realm_intro_shared_config(c);
	c:set_music_trigger_argument("realm_intro_slaanesh_long_nkari");
end;



--
-- TZEENTCH REALM

-- setup trigger listeners for the first line of Tzeentch advice, which can be different based on the player's lord
local function tzeentch_realm_intro_setup_initial_advice_key(c, initial_advice_key_override)
	c:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_tzeentch_realm_intro_01",
		function() cm:show_advice(initial_advice_key_override or "wh3_main_camp_narrative_chs_tzeentch_realm_intro_01b") end
	);
end;

-- setup trigger listeners for shared Slaanesh advice (other than the first line)
local function tzeentch_realm_intro_shared_config(c)
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_tzeentch_realm_intro_02", function() cm:show_advice("wh3_main_camp_narrative_chs_tzeentch_realm_intro_01") end);
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_tzeentch_realm_intro_03", function() cm:show_advice("wh3_main_camp_narrative_chs_tzeentch_realm_intro_02") end);
	c:add_cinematic_trigger_listener("wh3_main_camp_narrative_chs_tzeentch_realm_intro_04", function() cm:show_advice("wh3_main_camp_narrative_chs_tzeentch_realm_intro_03") end);
	c:set_skip_camera(301.277802, 460.479492, 12.597046, 0, 15.46781);
end;

-- Default configuration for Tzeentch realm intros
local function tzeentch_realm_intro_short_config(c, initial_advice_key_override)
	shared_realm_intro_config(c);
	tzeentch_realm_intro_setup_initial_advice_key(c, initial_advice_key_override);
	tzeentch_realm_intro_shared_config(c);
	c:set_music_trigger_argument("realm_intro_tzeentch_short");
end;

local function tzeentch_realm_intro_long_config(c, initial_advice_key_override)
	shared_realm_intro_config(c);
	tzeentch_realm_intro_setup_initial_advice_key(c, initial_advice_key_override);
	tzeentch_realm_intro_shared_config(c);
	c:set_music_trigger_argument("realm_intro_tzeentch_long");
end;

local KAIROS_TZEENTCH_REALM_INTRO_ADVICE_KEY = "wh3_main_camp_narrative_chs_tzeentch_realm_intro_04";

-- If the player is N'kari, these functions are used as the realm intro cutscene configurators
local function tzeentch_realm_intro_short_config_kairos(c)
	tzeentch_realm_intro_short_config(c, KAIROS_TZEENTCH_REALM_INTRO_ADVICE_KEY);
	c:set_music_trigger_argument("realm_intro_tzeentch_short_kairos");
end;

local function tzeentch_realm_intro_long_config_kairos(c)
	tzeentch_realm_intro_long_config(c, KAIROS_TZEENTCH_REALM_INTRO_ADVICE_KEY);
	c:set_music_trigger_argument("realm_intro_tzeentch_long_kairos");
end;































------------------------------------------------------------------------------------------------------------------
-- Narrative Event customisation per-faction in this campaign
------------------------------------------------------------------------------------------------------------------

local function customise_narrative_event_faction_data_for_campaign()
	
	-- Customise the narrative event faction data table here, if required. Customisations added here are for this campaign only.
	-- Customisations for a faction for ALL campaigns should be made in the base data in wh3_narrative_shared_faction_data.lua.
	-- Customisations for all factions, but only for this campaign, are made in the campaign data declared elsewhere in this file.



	-- Function to get the initial enemy province key - this is assumed to be the province of the initial enemy faction's home region
	local function get_initial_enemy_province_key(faction_key, region_key)
		if not validate.is_string(faction_key) then
			return false;
		end;

		if not validate.is_string(region_key) then
			return false;
		end;

		local savegame_value_key = faction_key .. "_narrative_initial_province";

		-- We look up a value from the savegame first. If one doesn't exist, we look up the province of the supplied region key.
		
		--query the model for the faction's home region's province, and then save that in to the
		-- savegame. We do this because this value will be looked up each time the savegame is loaded, and the faction may not exist after turn one, preventing us from
		-- looking up its home region.
		local savegame_province_key = cm:get_saved_value(savegame_value_key);
		if savegame_province_key then
			return savegame_province_key;
		end;
		
		local province_name;
		local region = cm:get_region(region_key);
		if region then
			province_name = region:province_name();
		else
			script_error("ERROR: get_initial_enemy_province_key() called but could not find a region with supplied key [" .. region_key .. "]");
			return false;
		end;

		cm:set_saved_value(savegame_value_key, province_name);

		return province_name;
	end;


	-- Function to get the initial enemy region key - this is assumed to be the closest region of the initial enemy faction to the player's legendary lord on turn one
	local function get_initial_enemy_region_key(player_faction_key, enemy_faction_key)
		if not validate.is_string(player_faction_key) then
			return false;
		end;
		
		if not validate.is_string(enemy_faction_key) then
			return false;
		end;

		local savegame_value_key = player_faction_key .. "_narrative_initial_region";

		-- We look up a value from the savegame first. First we get a key based on the player faction key, then we try a key based on the enemy faction key as we did that
		-- for a while and we should support these old savegames. If neither can be found, we find the closest region owned by the enemy faction to the player faction leader.
		-- Once the region key is determined we save this in to the savegame. We do this because this value will be looked up each time the savegame is loaded, and the faction
		-- may not exist after turn one, preventing us from looking this up again.
		local savegame_region_key = cm:get_saved_value(savegame_value_key);
		if savegame_region_key then
			return savegame_region_key;
		else
			savegame_region_key = cm:get_saved_value(enemy_faction_key .. "_narrative_initial_region");
			if savegame_region_key then
				return savegame_region_key;
			end;
		end;

		local player_faction = cm:get_faction(player_faction_key, true);
		local player_faction_leader = player_faction:faction_leader();

		local enemy_faction = cm:get_faction(enemy_faction_key, true);
		
		local region = cm:get_closest_region_for_faction(enemy_faction, player_faction_leader:logical_position_x(), player_faction_leader:logical_position_y());

		if not region then
			if player_faction:has_home_region() then
				region = player_faction:home_region();
				script_error("WARNING: get_initial_enemy_region_key() could not find an enemy region? How can this be? Enemy faction key is [" .. enemy_faction_key .. "], they control [" .. enemy_faction:region_list():num_items() .. "] region(s). Will return home region of player faction [" .. player_faction_key .. "] with key [" .. region:name() .. "] - expect weirdness");
			else
				script_error("ERROR: get_initial_enemy_region_key() could not find an enemy region? How can this be? Enemy faction key is [" .. enemy_faction_key .. "], they control [" .. enemy_faction:region_list():num_items() .. "] region(s). Furthermore, the player faction with key [" .. player_faction_key .. "] has no regions? Not returning a region");
				return false;
			end;
		end;

		local region_key = region:name();

		cm:set_saved_value(savegame_value_key, region_key);

		return region_key;
	end;



	-------------------------------------------------
	-------------------------------------------------
	-- KISLEV 
	-------------------------------------------------
	-------------------------------------------------

	-- For all Kislev factions: we add traits to the agent reward for the defeat-initial-enemy mission here
	local function add_initial_enemy_mission_agent_reward(faction_key, agent_subtype)

		narrative.add_data_for_faction(faction_key, "chs_event_post_defeat_initial_enemy_callback_callback",
			-- provide a callback which attempts to find the agent just spawned by the completion of the previous mission and apply traits
			function()
				local char = cm:get_most_recently_created_character_of_type(faction_key, nil, agent_subtype);
				if char then
					out.design("Narrative scripts have spawned agent of type " .. agent_subtype .. " for faction " .. faction_key);
					add_ice_court_traits_to_character_details(char:character_details());
				else
					script_error("WARNING: Couldn't add traits to character reward for initial enemy mission - no character of type " .. agent_subtype .. " could be found for faction " .. faction_key);
				end;
			end
		);
	end;
	
	
	--
	-- THE ICE COURT :: KATARIN
	--

	
	if cm:is_faction_human("wh3_main_ksl_the_ice_court") then
		local faction_key = "wh3_main_ksl_the_ice_court";																																-- key of faction to apply overrides for
		local initial_enemy_faction_key = "wh3_dlc20_nor_dolgan";																													-- key of their initial enemy faction
		local initial_enemy_region_key = get_initial_enemy_region_key(faction_key, initial_enemy_faction_key);																			-- key of the closest enemy faction region to player
		local initial_enemy_province_key = get_initial_enemy_province_key(initial_enemy_faction_key, initial_enemy_region_key)															-- province controlled by initial enemy faction
		local initial_enemy_mission_agent_reward_type = "wizard";
		local initial_enemy_mission_agent_reward_subtype = "wh3_main_ksl_frost_maiden_tempest";

		-- Initial enemy key - used by multiple narrative events
		narrative.add_data_for_faction(faction_key, "initial_enemy_faction_key", initial_enemy_faction_key);
	
		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_advice_key", "wh3_main_camp_narrative_chs_katarin_attack_enemy_01");								-- advice key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_main_camp_narrative_chaos_katarin_defeat_initial_enemy_01");					-- mission key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", 																				-- mission reward
			{
				payload.money(1000),
				payload.devotion(10),
				payload.agent_for_faction(faction_key, initial_enemy_mission_agent_reward_type, initial_enemy_mission_agent_reward_subtype);
			}
		);

		-- Kislev-only post-defeat initial enemy mission callback
		narrative.add_data_for_faction(faction_key, "chs_event_post_defeat_initial_enemy_callback_allow", true);																		-- activate this narrative event
		add_initial_enemy_mission_agent_reward(faction_key, initial_enemy_mission_agent_reward_subtype);																				-- set up a callback which adds traits to the defeat-initial-enemy reward agent

		-- embed agent trigger/mission
		narrative.add_data_for_faction(faction_key, "chs_trigger_character_created_for_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);								-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);														-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_mission_key", "wh3_main_camp_narrative_chaos_katarin_embed_hero_01");										-- mission key
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_mission_rewards", 
			{
				payload.money(500)
			}
		);

		-- recruit units mission
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_advice_key", "wh3_main_camp_narrative_chs_katarin_recruit_units_01");					-- advice key
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_mission_key", "wh3_main_camp_narrative_chaos_katarin_recruit_units_01");				-- mission key
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_mission_rewards", 
			{
				payload.money(500),
				payload.devotion(10)
			}
		);

		-- pre-capture settlement can-reach trigger
		narrative.add_data_for_faction(faction_key, "chs_trigger_settlement_capture_can_reach_target_faction_key", initial_enemy_faction_key);

		-- capture settlement 
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_advice_key", "wh3_main_camp_narrative_chs_katarin_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_main_camp_narrative_chaos_katarin_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_region_key", initial_enemy_region_key);
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_rewards", 
			{
				payload.money(1500),
				payload.devotion(20)
			}
		);

		-- capture province mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_advice_key", "wh3_main_camp_narrative_chs_katarin_capture_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_main_camp_narrative_chaos_katarin_complete_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_province_keys", initial_enemy_province_key);										-- specify the province that has to be captured for this mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_rewards", 
			{
				payload.money(5000),
				payload.devotion(50)
			}
		);

		-- Arcane item mission rewards for Kislev first to fifty supporters mission (default missions provide different items that other Kislev factions can equip)
		narrative.add_data_for_faction(
			faction_key,
			"kislev_devotion_first_to_fifty_supporters_mission_rewards",
			{																						
				payload.money_direct(2000),
				payload.ancillary_mission_payload(faction_key, "arcane_item", "uncommon")
			}
		);

		narrative.add_data_for_faction(
			faction_key,
			"kislev_atamans_event_appoint_ataman_mission_rewards",
			{																						
				payload.money_direct(2000),
				payload.ancillary_mission_payload(faction_key, "arcane_item", "rare")
			}
		);
	end;

	
	--
	-- THE GREAT ORTHODOXY :: KOSTALTYN
	--

	if cm:is_faction_human("wh3_main_ksl_the_great_orthodoxy") then
		local faction_key = "wh3_main_ksl_the_great_orthodoxy";																															-- key of faction to apply overrides for
		local initial_enemy_faction_key = "wh3_main_ksl_ungol_kindred";																													-- key of their initial enemy faction
		local initial_enemy_region_key = get_initial_enemy_region_key(faction_key, initial_enemy_faction_key);																			-- key of the closest enemy faction region to player
		local initial_enemy_province_key = get_initial_enemy_province_key(initial_enemy_faction_key, initial_enemy_region_key)															-- province controlled by initial enemy faction
		local initial_enemy_mission_agent_reward_type = "dignitary";
		local initial_enemy_mission_agent_reward_subtype = "wh3_main_ksl_patriarch";

		-- Initial enemy key - used by multiple narrative events
		narrative.add_data_for_faction(faction_key, "initial_enemy_faction_key", initial_enemy_faction_key);
	
		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_advice_key", "wh3_main_camp_narrative_chs_kostaltyn_attack_enemy_01");							-- advice key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_main_camp_narrative_chaos_kostaltyn_defeat_initial_enemy_01");				-- mission key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", 																				-- mission reward
			{
				payload.money(1000),
				payload.devotion(10),
				payload.agent_for_faction(faction_key, initial_enemy_mission_agent_reward_type, initial_enemy_mission_agent_reward_subtype);
			}
		);

		-- embed agent trigger/mission
		narrative.add_data_for_faction(faction_key, "chs_trigger_character_created_for_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);								-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);														-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_mission_key", "wh3_main_camp_narrative_chaos_kostaltyn_embed_hero_01");										-- mission key
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_mission_rewards", 
			{
				payload.money(500)
			}
		);

		-- recruit units mission
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_advice_key", "wh3_main_camp_narrative_chs_kostaltyn_recruit_units_01");				-- advice key
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_mission_key", "wh3_main_camp_narrative_chaos_kostaltyn_recruit_units_01");				-- mission key
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_mission_rewards", 
			{
				payload.money(500),
				payload.devotion(10)
			}
		);

		-- pre-capture settlement can-reach trigger
		narrative.add_data_for_faction(faction_key, "chs_trigger_settlement_capture_can_reach_target_faction_key", initial_enemy_faction_key);

		-- capture settlement 
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_advice_key", "wh3_main_camp_narrative_chs_kostaltyn_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_main_camp_narrative_chaos_kostaltyn_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_region_key", initial_enemy_region_key);
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_rewards", 
			{
				payload.money(1500),
				payload.devotion(20)
			}
		);

		-- capture province mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_advice_key", "wh3_main_camp_narrative_chs_kostaltyn_capture_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_main_camp_narrative_chaos_kostaltyn_complete_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_province_keys", initial_enemy_province_key);										-- specify the province that has to be captured for this mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_rewards", 
			{
				payload.money(5000),
				payload.devotion(50)
			}
		);
	end;
	
	
	--
	-- URSUN REVIVALISTS :: BORIS URSUS
	--

	if cm:is_faction_human("wh3_main_ksl_ursun_revivalists") then
		local faction_key = "wh3_main_ksl_ursun_revivalists";																															-- key of faction to apply overrides for
		local initial_enemy_faction_key = "wh3_main_grn_dark_land_orcs";																												-- key of their initial enemy faction
		local initial_enemy_region_key = get_initial_enemy_region_key(faction_key, initial_enemy_faction_key);																			-- key of the closest enemy faction region to player
		local initial_enemy_province_key = get_initial_enemy_province_key(initial_enemy_faction_key, initial_enemy_region_key)															-- province controlled by initial enemy faction
		local initial_enemy_mission_agent_reward_type = "wizard";
		local initial_enemy_mission_agent_reward_subtype = "wh3_main_ksl_frost_maiden_ice";

		-- Initial enemy key - used by multiple narrative events
		narrative.add_data_for_faction(faction_key, "initial_enemy_faction_key", initial_enemy_faction_key);
	
		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_advice_key", "wh3_main_camp_narrative_chs_boris_ursus_attack_enemy_01");							-- advice key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_main_camp_narrative_chaos_boris_ursus_defeat_initial_enemy_01");				-- mission key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", 																				-- mission reward
			{
				payload.money(1000),
				payload.devotion(10),
				payload.agent_for_faction(faction_key, initial_enemy_mission_agent_reward_type, initial_enemy_mission_agent_reward_subtype);
			}
		);

		-- Kislev-only post-defeat initial enemy mission callback
		narrative.add_data_for_faction(faction_key, "chs_event_post_defeat_initial_enemy_callback_allow", true);																		-- activate this narrative event
		add_initial_enemy_mission_agent_reward(faction_key, initial_enemy_mission_agent_reward_subtype);																				-- set up a callback which adds traits to the defeat-initial-enemy reward agent

		-- embed agent trigger/mission
		narrative.add_data_for_faction(faction_key, "chs_trigger_character_created_for_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);								-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);														-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_mission_key", "wh3_main_camp_narrative_chaos_boris_ursus_embed_hero_01");									-- mission key
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_mission_rewards", 
			{
				payload.money(500)
			}
		);

		-- recruit units mission
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_advice_key", "wh3_main_camp_narrative_chs_boris_ursus_recruit_units_01");				-- advice key
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_mission_key", "wh3_main_camp_narrative_chaos_boris_ursus_recruit_units_01");			-- mission key
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_mission_rewards", 
			{
				payload.money(500),
				payload.devotion(10)
			}
		);

		-- pre-capture settlement can-reach trigger
		narrative.add_data_for_faction(faction_key, "chs_trigger_settlement_capture_can_reach_target_faction_key", initial_enemy_faction_key);

		-- capture settlement 
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_advice_key", "wh3_main_camp_narrative_chs_boris_ursus_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_main_camp_narrative_chaos_boris_ursus_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_region_key", initial_enemy_region_key);
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_rewards", 
			{
				payload.money(1500),
				payload.devotion(20)
			}
		);

		-- capture province mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_advice_key", "wh3_main_camp_narrative_chs_boris_ursus_capture_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_main_camp_narrative_chaos_boris_ursus_complete_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_province_keys", initial_enemy_province_key);										-- specify the province that has to be captured for this mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_rewards", 
			{
				payload.money(5000),
				payload.devotion(50)
			}
		);
	end;





	-------------------------------------------------
	-------------------------------------------------
	-- DAEMON PRINCE
	-------------------------------------------------
	-------------------------------------------------
	
	
	--
	-- LEGION OF CHAOS (standard Daemon Prince)
	--

	if cm:is_faction_human("wh3_main_dae_daemon_prince") then
		local faction_key = "wh3_main_dae_daemon_prince";																																-- key of faction to apply overrides for
		local initial_enemy_faction_key = "wh_main_emp_nordland";																														-- key of their initial enemy faction
		local initial_unoccupied_region_key = "wh3_main_chaos_region_doomkeep"																											-- key of the initial ruined settlement
		local initial_enemy_region_key = get_initial_enemy_region_key(faction_key, initial_enemy_faction_key);																			-- key of the closest enemy faction region to player
		local initial_enemy_province_key = get_initial_enemy_province_key(initial_enemy_faction_key, initial_enemy_region_key)															-- province controlled by initial enemy faction
		
		-- Initial enemy key - used by multiple narrative events
		narrative.add_data_for_faction(faction_key, "initial_enemy_faction_key", initial_enemy_faction_key);

		narrative.add_data_for_faction(faction_key, "initial_unoccupied_region_key", initial_unoccupied_region_key);
	
		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_advice_key", "wh3_main_camp_narrative_chs_daemon_prince_attack_enemy_01");						-- advice key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_main_camp_narrative_chaos_daemon_prince_defeat_initial_enemy_01");			-- mission key
		
		-- Capture Initial Settlement mission (DP ONLY)
		narrative.add_data_for_faction(faction_key, "chs_event_daemon_prince_occupy_initial_settlement_countdown_allow", true);															-- enable the countdown to the mission
		narrative.add_data_for_faction(faction_key, "chs_event_daemon_prince_occupy_initial_settlement_allow", true);																	-- enable the first capture-settlement mission for DP
		narrative.add_data_for_faction(faction_key, "chs_event_daemon_prince_occupy_initial_settlement_completed_messages");															-- trigger messages on completion
		narrative.add_data_for_faction(faction_key, "chs_event_daemon_prince_occupy_initial_settlement_mission_rewards", 																-- mission reward
			function()
				return {
					payload.money(																																							-- issue money or equivalent
						1000,																																									-- money reward, if we aren't giving something else for this faction
						faction_key,																																							-- faction key
						{																																										-- params for potential money replacement
							value = "low",																																							-- value of this mission - see wh3_campaign_payload_remapping.lua
							glory_type = "slaanesh,undivided"																																		-- glory type to issue
						}
					)
				}
			end
		);

		-- embed agent trigger/mission
		narrative.add_data_for_faction(																																					-- agent subtype
			faction_key, 
			"chs_trigger_character_created_for_embed_agent_subtype", 
			cm:get_saved_value("daemon_prince_initial_enemy_mission_agent_reward_subtype")
		);
		narrative.add_data_for_faction(																																					-- agent subtype
			faction_key,
			"chs_event_embed_agent_subtype",
			cm:get_saved_value("daemon_prince_initial_enemy_mission_agent_reward_subtype")
		);
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_mission_key", "wh3_main_camp_narrative_chaos_daemon_prince_embed_hero_01");									-- mission key

		-- recruit units mission
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_trigger_messages", "");																-- remap the default recruit units mission so that it doesn't trigger for DP, which has four variants of its own
		
		-- enable the daemon-prince-specific recruit units missions
		narrative.add_data_for_faction(faction_key, "chs_event_daemon_prince_trigger_occupation_decision_as_khorne_allow", "");
		narrative.add_data_for_faction(faction_key, "chs_event_daemon_prince_trigger_occupation_decision_as_nurgle_allow", "");
		narrative.add_data_for_faction(faction_key, "chs_event_daemon_prince_trigger_occupation_decision_as_slaanesh_allow", "");
		narrative.add_data_for_faction(faction_key, "chs_event_daemon_prince_trigger_occupation_decision_as_tzeentch_allow", "");
		narrative.add_data_for_faction(faction_key, "chs_event_daemon_prince_recruit_units_khorne_allow", "");
		narrative.add_data_for_faction(faction_key, "chs_event_daemon_prince_recruit_units_nurgle_allow", "");
		narrative.add_data_for_faction(faction_key, "chs_event_daemon_prince_recruit_units_slaanesh_allow", "");
		narrative.add_data_for_faction(faction_key, "chs_event_daemon_prince_recruit_units_tzeentch_allow", "");

		-- pre-capture settlement can-reach trigger
		narrative.add_data_for_faction(faction_key, "chs_trigger_settlement_capture_can_reach_target_faction_key", initial_enemy_faction_key);

		-- capture settlement 
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_advice_key", "wh3_main_camp_narrative_chs_daemon_prince_capture_settlement_02");		-- advice key
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_main_camp_narrative_chaos_daemon_prince_capture_settlement_02");		-- mission key
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_region_key", initial_enemy_region_key);
		

		-- capture province mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_advice_key", "wh3_main_camp_narrative_chs_daemon_prince_capture_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_main_camp_narrative_chaos_daemon_prince_complete_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_province_keys", initial_enemy_province_key);										-- specify the province that has to be captured for this mission

		-- sack or raze human settlements mission
		narrative.add_data_for_faction(faction_key, "chaos_movements_event_sack_raze_human_settlements_mission_rewards", 																-- mission reward
			function()
				return {
					payload.money_direct(20000),
					payload.khorne_glory(200),
					payload.nurgle_glory(200),
					payload.slaanesh_glory(200),
					payload.tzeentch_glory(200),
					payload.undivided_glory(200)
				}
			end
		);

		-- defeat human armies mission
		narrative.add_data_for_faction(faction_key, "chaos_movements_event_defeat_human_armies_mission_rewards", 																		-- mission reward
			function()
				return {
					payload.money_direct(4000),
					payload.khorne_glory(80),
					payload.nurgle_glory(80),
					payload.slaanesh_glory(80),
					payload.tzeentch_glory(80),
					payload.undivided_glory(80),
					payload.ancillary_mission_payload(faction_key, "weapon", "rare")
				}
			end
		);

		-- block technology missions
		narrative.add_data_for_faction(faction_key, "shared_technology_research_trigger_pre_chain_block", true);																		-- prevent tech missions from starting

		-- block trade missions
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_trigger_pre_trade_turn_countdown_to_possible_block", true);
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_trigger_pre_trade_deal_agreed_block", true);

		-- Switch in "evil" diplomacy advice line variants
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_non_aggression_pact_mission_advice_key", "wh3_main_camp_narrative_shared_non_aggression_pact_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_trade_mission_advice_key", "wh3_main_camp_narrative_shared_trade_agreement_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_confederation_mission_advice_key", "wh3_main_camp_narrative_shared_war_confederation_02");
		
		-- block confederation missions - the Daemon Prince cannot confederate as there are no other factions of the same race
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_trigger_pre_confederation_turn_countdown_from_chain_start_block", true);
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_trigger_pre_confederation_turn_countdown_to_possible", true);
	end;
	
		

	
	
	-------------------------------------------------
	-------------------------------------------------
	-- KHORNE :: SKARBRAND
	-------------------------------------------------
	-------------------------------------------------
	

	--
	-- EXILES OF KHORNE
	--

	if cm:is_faction_human("wh3_main_kho_exiles_of_khorne") then
		local faction_key = "wh3_main_kho_exiles_of_khorne";																															-- key of faction to apply overrides for
		local initial_enemy_faction_key = "wh3_main_chs_gharhar";																														-- key of their initial enemy faction
		local initial_enemy_region_key = get_initial_enemy_region_key(faction_key, initial_enemy_faction_key);																			-- key of the closest enemy faction region to player
		local initial_enemy_province_key = get_initial_enemy_province_key(initial_enemy_faction_key, initial_enemy_region_key)															-- province controlled by initial enemy faction
		local initial_enemy_mission_agent_reward_type = "dignitary";
		local initial_enemy_mission_agent_reward_subtype = "wh3_main_kho_bloodreaper";

		-- Initial enemy key - used by multiple narrative events
		narrative.add_data_for_faction(faction_key, "initial_enemy_faction_key", initial_enemy_faction_key);

		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_advice_key", "wh3_main_camp_narrative_chs_skarbrand_attack_enemy_01");							-- advice key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_main_camp_narrative_chaos_skarbrand_defeat_initial_enemy_01");				-- mission key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", 																				-- mission reward
			{
				payload.money(																																							-- issue money or equivalent
					1000,																																									-- money reward, if we aren't giving something else for this faction
					faction_key																																								-- faction key
				),
				payload.agent_for_faction(faction_key, initial_enemy_mission_agent_reward_type, initial_enemy_mission_agent_reward_subtype)
			}
		);

		-- embed agent trigger/mission
		narrative.add_data_for_faction(faction_key, "chs_trigger_character_created_for_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);								-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);														-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_mission_key", "wh3_main_camp_narrative_chaos_skarbrand_embed_hero_01");										-- mission key

		-- recruit units mission
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_advice_key", "wh3_main_camp_narrative_chs_skarbrand_recruit_units_01");				-- advice key
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_mission_key", "wh3_main_camp_narrative_chaos_skarbrand_recruit_units_01");				-- mission key

		-- pre-capture settlement can-reach trigger
		narrative.add_data_for_faction(faction_key, "chs_trigger_settlement_capture_can_reach_target_faction_key", initial_enemy_faction_key);

		-- capture settlement 		
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_block", true);
		narrative.add_data_for_faction(faction_key, "chs_event_khorne_occupy_or_raze_initial_settlement_allow", true);
		narrative.add_data_for_faction(faction_key, "chs_event_khorne_occupy_or_raze_initial_settlement_region_key", initial_enemy_region_key);

		-- capture province mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_advice_key", "wh3_main_camp_narrative_chs_skarbrand_capture_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_main_camp_narrative_chaos_skarbrand_complete_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_province_keys", initial_enemy_province_key);										-- specify the province that has to be captured for this mission

		-- sack or raze human settlements mission
		narrative.add_data_for_faction(faction_key, "chaos_movements_event_sack_raze_human_settlements_mission_rewards", 																-- mission reward
			function()
				return {
					payload.money(20000, faction_key),
					payload.agent_for_faction(
						faction_key,
						"dignitary",
						"wh3_main_kho_cultist"
					)
				}
			end
		);

		-- Khorne realm flybys - we use a different key for the first line of advice
		narrative.add_data_for_faction(faction_key, "chs_event_khorne_realm_intro_long_config", khorne_realm_intro_long_config_skarbrand);
		narrative.add_data_for_faction(faction_key, "chs_event_khorne_realm_intro_short_config", khorne_realm_intro_short_config_skarbrand);

		-- Switch in "evil" diplomacy advice line variants
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_non_aggression_pact_mission_advice_key", "wh3_main_camp_narrative_shared_non_aggression_pact_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_trade_mission_advice_key", "wh3_main_camp_narrative_shared_trade_agreement_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_confederation_mission_advice_key", "wh3_main_camp_narrative_shared_war_confederation_02");

		-- block trade missions
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_trigger_pre_trade_turn_countdown_to_possible_block", true);
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_trigger_pre_trade_deal_agreed_block", true);
	end;
	
	

	
	
	-------------------------------------------------
	-------------------------------------------------
	-- NURGLE
	-------------------------------------------------
	-------------------------------------------------
	

	--
	-- POXMAKERS OF NURGLE :: KU'GATH PLAGUEFATHER
	--

	if cm:is_faction_human("wh3_main_nur_poxmakers_of_nurgle") then
		local faction_key = "wh3_main_nur_poxmakers_of_nurgle";																															-- key of faction to apply overrides for
		local initial_enemy_faction_key = "wh3_main_ogr_fleshgreeders";																													-- key of their initial enemy faction
		local initial_enemy_region_key = get_initial_enemy_region_key(faction_key, initial_enemy_faction_key);																			-- key of the closest enemy faction region to player
		local initial_enemy_province_key = get_initial_enemy_province_key(initial_enemy_faction_key, initial_enemy_region_key)															-- province controlled by initial enemy faction
		local initial_enemy_mission_agent_reward_type = "spy";
		local initial_enemy_mission_agent_reward_subtype = "wh3_main_nur_plagueridden_nurgle";

		-- Initial enemy key - used by multiple narrative events
		narrative.add_data_for_faction(faction_key, "initial_enemy_faction_key", initial_enemy_faction_key);
	
		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_advice_key", "wh3_main_camp_narrative_chs_kugath_attack_enemy_01");								-- advice key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_main_camp_narrative_chaos_kugath_defeat_initial_enemy_01");					-- mission key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", 																				-- mission reward
			{
				payload.money(																																							-- issue money or equivalent
					1000,																																									-- money reward, if we aren't giving something else for this faction
					faction_key																																								-- faction key
				),
				payload.agent_for_faction(faction_key, initial_enemy_mission_agent_reward_type, initial_enemy_mission_agent_reward_subtype)
			}
		);

		-- embed agent trigger/mission
		narrative.add_data_for_faction(faction_key, "chs_trigger_character_created_for_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);								-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);														-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_mission_key", "wh3_main_camp_narrative_chaos_kugath_embed_hero_01");											-- mission key

		-- recruit units mission
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_advice_key", "wh3_main_camp_narrative_chs_kugath_recruit_units_01");					-- advice key
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_mission_key", "wh3_main_camp_narrative_chaos_kugath_recruit_units_01");				-- mission key

		-- pre-capture settlement can-reach trigger
		narrative.add_data_for_faction(faction_key, "chs_trigger_settlement_capture_can_reach_target_faction_key", initial_enemy_faction_key);

		-- capture settlement 
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_advice_key", "wh3_main_camp_narrative_chs_kugath_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_main_camp_narrative_chaos_kugath_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_region_key", initial_enemy_region_key);

		-- capture province mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_advice_key", "wh3_main_camp_narrative_chs_kugath_capture_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_main_camp_narrative_chaos_kugath_complete_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_province_keys", initial_enemy_province_key);										-- specify the province that has to be captured for this mission

		-- sack or raze human settlements mission
		narrative.add_data_for_faction(faction_key, "chaos_movements_event_sack_raze_human_settlements_mission_rewards", 																-- mission reward
			function()
				return {
					payload.money(20000, faction_key),
					payload.agent_for_faction(
						faction_key,
						"dignitary",
						"wh3_main_nur_cultist"
					)
				}
			end
		);

		-- Nurgle realm flybys - we use a different key for the first line of advice
		narrative.add_data_for_faction(faction_key, "chs_event_nurgle_realm_intro_long_config", nurgle_realm_intro_long_config_kugath);
		narrative.add_data_for_faction(faction_key, "chs_event_nurgle_realm_intro_short_config", nurgle_realm_intro_short_config_kugath);

		-- Switch in "evil" diplomacy advice line variants
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_non_aggression_pact_mission_advice_key", "wh3_main_camp_narrative_shared_non_aggression_pact_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_trade_mission_advice_key", "wh3_main_camp_narrative_shared_trade_agreement_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_confederation_mission_advice_key", "wh3_main_camp_narrative_shared_war_confederation_02");

		-- block trade missions
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_trigger_pre_trade_turn_countdown_to_possible_block", true);
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_trigger_pre_trade_deal_agreed_block", true);
	end;
	
	
	

	
	
	-------------------------------------------------
	-------------------------------------------------
	-- SLAANESH
	-------------------------------------------------
	-------------------------------------------------


	--
	-- SEDUCERS OF SLAANESH :: N'KARI
	--

	if cm:is_faction_human("wh3_main_sla_seducers_of_slaanesh") then
		local faction_key = "wh3_main_sla_seducers_of_slaanesh";																														-- key of faction to apply overrides for
		local initial_enemy_faction_key = "wh3_main_kho_bloody_sword";																													-- key of their initial enemy faction
		local initial_enemy_region_key = get_initial_enemy_region_key(faction_key, initial_enemy_faction_key);																			-- key of the closest enemy faction region to player
		local initial_enemy_province_key = get_initial_enemy_province_key(initial_enemy_faction_key, initial_enemy_region_key)															-- province controlled by initial enemy faction
		local initial_enemy_mission_agent_reward_type = "engineer";
		local initial_enemy_mission_agent_reward_subtype = "wh3_main_sla_alluress_shadow";

		-- Initial enemy key - used by multiple narrative events
		narrative.add_data_for_faction(faction_key, "initial_enemy_faction_key", initial_enemy_faction_key);
	
		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_advice_key", "wh3_main_camp_narrative_chs_nkari_attack_enemy_01");								-- advice key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_main_camp_narrative_chaos_nkari_defeat_initial_enemy_01");					-- mission key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", 																				-- mission reward
			{
				payload.money(																																							-- issue money or equivalent
					1000,																																									-- money reward, if we aren't giving something else for this faction
					faction_key,																																							-- faction key
					{																																										-- params for potential money replacement
						value = "med",																																							-- value of this mission - see wh3_campaign_payload_remapping.lua
						glory_type = "khorne,tzeentch"																																			-- glory type to issue
					}
				),
				payload.agent_for_faction(faction_key, initial_enemy_mission_agent_reward_type, initial_enemy_mission_agent_reward_subtype)
			}
		);

		-- embed agent trigger/mission
		narrative.add_data_for_faction(faction_key, "chs_trigger_character_created_for_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);								-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);														-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_mission_key", "wh3_main_camp_narrative_chaos_nkari_embed_hero_01");											-- mission key

		-- recruit units mission
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_advice_key", "wh3_main_camp_narrative_chs_nkari_recruit_units_01");					-- advice key
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_mission_key", "wh3_main_camp_narrative_chaos_nkari_recruit_units_01");					-- mission key

		-- pre-capture settlement can-reach trigger
		narrative.add_data_for_faction(faction_key, "chs_trigger_settlement_capture_can_reach_target_faction_key", initial_enemy_faction_key);

		-- capture settlement 
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_advice_key", "wh3_main_camp_narrative_chs_nkari_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_main_camp_narrative_chaos_nkari_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_region_key", initial_enemy_region_key);

		-- capture province mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_advice_key", "wh3_main_camp_narrative_chs_nkari_capture_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_main_camp_narrative_chaos_nkari_complete_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_province_keys", initial_enemy_province_key);										-- specify the province that has to be captured for this mission

		-- sack or raze human settlements mission
		narrative.add_data_for_faction(faction_key, "chaos_movements_event_sack_raze_human_settlements_mission_rewards", 																-- mission reward
			function()
				return {
					payload.money(20000, faction_key),
					payload.agent_for_faction(
						faction_key,
						"dignitary",
						"wh3_main_sla_cultist"
					)
				}
			end
		);

		-- Slaanesh realm flybys - we use a different key for the first line of advice
		narrative.add_data_for_faction(faction_key, "chs_event_slaanesh_realm_intro_long_config", slaanesh_realm_intro_long_config_nkari);
		narrative.add_data_for_faction(faction_key, "chs_event_slaanesh_realm_intro_short_config", slaanesh_realm_intro_short_config_nkari);

		-- Switch in "evil" diplomacy advice line variants
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_non_aggression_pact_mission_advice_key", "wh3_main_camp_narrative_shared_non_aggression_pact_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_trade_mission_advice_key", "wh3_main_camp_narrative_shared_trade_agreement_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_confederation_mission_advice_key", "wh3_main_camp_narrative_shared_war_confederation_02");

		-- block trade missions
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_trigger_pre_trade_turn_countdown_to_possible_block", true);
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_trigger_pre_trade_deal_agreed_block", true);
	end;
	

	
	

	
	
	-------------------------------------------------
	-------------------------------------------------
	-- TZEENTCH
	-------------------------------------------------
	-------------------------------------------------


	--
	-- ORACLES OF TZEENTCH :: KAIROS FATEWEAVER
	--

	if cm:is_faction_human("wh3_main_tze_oracles_of_tzeentch") then
		local faction_key = "wh3_main_tze_oracles_of_tzeentch";																															-- key of faction to apply overrides for
		local initial_enemy_faction_key = "wh3_main_cth_imperial_wardens";																												-- key of their initial enemy faction
		local initial_settlement_target_faction_key = "wh3_main_chs_khazag";																											-- key of the faction that owns the target settlement
		local initial_enemy_region_key = "wh3_main_chaos_region_bloodwind_keep";																										-- key of the closest enemy faction region to player
		local initial_enemy_province_key = get_initial_enemy_province_key(initial_settlement_target_faction_key, initial_enemy_region_key)												-- province controlled by initial enemy faction
		local initial_enemy_mission_agent_reward_type = "runesmith";
		local initial_enemy_mission_agent_reward_subtype = "wh3_main_tze_iridescent_horror_tzeentch";
		
		-- Initial enemy key
		narrative.add_data_for_faction(faction_key, "initial_enemy_faction_key", initial_enemy_faction_key);
		
		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_advice_key", "wh3_main_camp_narrative_chs_kairos_attack_enemy_01");								-- advice key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_main_camp_narrative_chaos_kairos_defeat_initial_enemy_01");					-- mission key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", 																				-- mission reward
			{
				payload.grimoires(150)																																						-- grimoires reward
			}
		);

		-- recruit units mission
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_advice_key", "wh3_main_camp_narrative_chs_kairos_recruit_units_01");					-- advice key
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_mission_key", "wh3_main_camp_narrative_chaos_kairos_recruit_units_01");				-- mission key
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_mission_rewards", 																		-- mission reward
			{
				payload.grimoires(100)																																						-- grimoires reward
			}
		);

		-- pre-capture settlement can-reach trigger
		narrative.add_data_for_faction(faction_key, "chs_trigger_settlement_capture_can_reach_target_faction_key", initial_settlement_target_faction_key);

		-- capture settlement 
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_advice_key", "wh3_main_camp_narrative_chs_kairos_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_main_camp_narrative_chaos_kairos_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_region_key", initial_enemy_region_key);
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_camera_target", initial_settlement_target_faction_key);
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_rewards", 																-- mission reward
			{
				payload.money(																																							-- issue money or equivalent
					1000,																																									-- money reward, if we aren't giving something else for this faction
					faction_key																																								-- faction key
				),
				payload.agent_for_faction(faction_key, initial_enemy_mission_agent_reward_type, initial_enemy_mission_agent_reward_subtype)
			}
		);

		-- embed agent trigger/mission
		narrative.add_data_for_faction(faction_key, "chs_trigger_character_created_for_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);								-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);														-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_mission_key", "wh3_main_camp_narrative_chaos_kairos_embed_hero_01");											-- mission key

		-- capture province mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_advice_key", "wh3_main_camp_narrative_chs_kairos_capture_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_main_camp_narrative_chaos_kairos_complete_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_province_keys", initial_enemy_province_key);										-- specify the province that has to be captured for this mission

		-- sack or raze human settlements mission
		narrative.add_data_for_faction(faction_key, "chaos_movements_event_sack_raze_human_settlements_mission_rewards", 																-- mission reward
			function()
				return {
					payload.money(20000, faction_key),
					payload.agent_for_faction(
						faction_key,
						"dignitary",
						"wh3_main_tze_cultist"
					)
				}
			end
		);

		-- Tzeentch realm flybys - we use a different key for the first line of advice
		narrative.add_data_for_faction(faction_key, "chs_event_tzeentch_realm_intro_long_config", tzeentch_realm_intro_long_config_kairos);
		narrative.add_data_for_faction(faction_key, "chs_event_tzeentch_realm_intro_short_config", tzeentch_realm_intro_short_config_kairos);

		-- Switch in "evil" diplomacy advice line variants
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_non_aggression_pact_mission_advice_key", "wh3_main_camp_narrative_shared_non_aggression_pact_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_trade_mission_advice_key", "wh3_main_camp_narrative_shared_trade_agreement_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_confederation_mission_advice_key", "wh3_main_camp_narrative_shared_war_confederation_02");

		-- block trade missions
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_trigger_pre_trade_turn_countdown_to_possible_block", true);
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_trigger_pre_trade_deal_agreed_block", true);
	end;

	
	

	
	
	------------------------------
	------------------------------
	-- CATHAY
	------------------------------
	------------------------------
	

	--
	-- THE NORTHERN PROVINCES :: MIAO YING :: THE STORM DRAGON
	--

	if cm:is_faction_human("wh3_main_cth_the_northern_provinces") then
		local faction_key = "wh3_main_cth_the_northern_provinces";																														-- key of faction to apply overrides for
		local initial_enemy_faction_key = "wh3_main_cth_rebel_lords_of_nan_yang";																										-- key of their initial enemy faction
		local initial_enemy_region_key = get_initial_enemy_region_key(faction_key, initial_enemy_faction_key);																			-- key of the closest enemy faction region to player
		local initial_enemy_province_key = get_initial_enemy_province_key(initial_enemy_faction_key, initial_enemy_region_key)															-- province controlled by initial enemy faction
		local initial_enemy_mission_agent_reward_type = "wizard";
		local initial_enemy_mission_agent_reward_subtype = "wh3_main_cth_astromancer";
	
		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "initial_enemy_faction_key", initial_enemy_faction_key);																			-- initial enemy faction
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_advice_key", "wh3_main_camp_narrative_chs_miao_ying_attack_enemy_01");							-- advice key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_main_camp_narrative_chaos_miao_ying_defeat_initial_enemy_01");				-- mission key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", 																				-- mission reward
			{
				payload.money(																																							-- issue money or equivalent
					1000,																																									-- money reward, if we aren't giving something else for this faction
					faction_key,																																							-- faction key
					{																																										-- params for potential money replacement
						value = "med",																																							-- value of this mission - see wh3_campaign_payload_remapping.lua
						glory_type = "khorne"																																					-- glory type to issue
					}
				),
				payload.agent_for_faction(faction_key, initial_enemy_mission_agent_reward_type, initial_enemy_mission_agent_reward_subtype)
			}
		);

		-- embed agent trigger/mission
		narrative.add_data_for_faction(faction_key, "chs_trigger_character_created_for_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);								-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);														-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_mission_key", "wh3_main_camp_narrative_chaos_miao_ying_embed_hero_01");										-- mission key

		-- recruit units mission
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_advice_key", "wh3_main_camp_narrative_chs_miao_ying_recruit_units_01");					-- advice key
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_mission_key", "wh3_main_camp_narrative_chaos_miao_ying_recruit_units_01");					-- mission key

		-- pre-capture settlement can-reach trigger
		narrative.add_data_for_faction(faction_key, "chs_trigger_settlement_capture_can_reach_target_faction_key", initial_enemy_faction_key);

		-- capture settlement 
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_advice_key", "wh3_main_camp_narrative_chs_miao_ying_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_main_camp_narrative_chaos_miao_ying_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_region_key", initial_enemy_region_key);

		-- capture province mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_advice_key", "wh3_main_camp_narrative_chs_miao_ying_capture_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_main_camp_narrative_chaos_miao_ying_complete_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_province_keys", initial_enemy_province_key);										-- specify the province that has to be captured for this mission		

		-- capture snake gate mission
		narrative.add_data_for_faction(faction_key, "chs_event_cathay_pre_capture_snake_gate_turn_countdown_allow", true);
		narrative.add_data_for_faction(faction_key, "chs_event_cathay_pre_capture_snake_gate_can_reach_allow", true);
		narrative.add_data_for_faction(faction_key, "chs_event_cathay_capture_snake_gate_allow", true);
		
		-- destroy faction mission
		narrative.add_data_for_faction(faction_key, "chs_event_cathay_pre_eliminate_faction_turn_countdown_allow", true);
		narrative.add_data_for_faction(faction_key, "chs_event_cathay_eliminate_faction_allow", true);
	end;



	--
	-- THE WESTERN PROVINCES :: ZHAO MING :: THE IRON DRAGON
	--

	if cm:is_faction_human("wh3_main_cth_the_western_provinces") then
		local faction_key = "wh3_main_cth_the_western_provinces";																														-- key of faction to apply overrides for
		local initial_enemy_faction_key = "wh2_main_skv_clan_eshin";																													-- key of their initial enemy faction
		local initial_enemy_region_key = get_initial_enemy_region_key(faction_key, initial_enemy_faction_key);																			-- key of the closest enemy faction region to player
		local initial_enemy_province_key = get_initial_enemy_province_key(initial_enemy_faction_key, initial_enemy_region_key)															-- province controlled by initial enemy faction
		local initial_enemy_mission_agent_reward_type = "engineer";
		local initial_enemy_mission_agent_reward_subtype = "wh3_main_cth_alchemist";
	
		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "initial_enemy_faction_key", initial_enemy_faction_key);																			-- initial enemy faction
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_advice_key", "wh3_main_camp_narrative_chs_zhao_ming_attack_enemy_01");							-- advice key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_main_camp_narrative_chaos_zhao_ming_defeat_initial_enemy_01");				-- mission key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", 																				-- mission reward
			{
				payload.money(																																							-- issue money or equivalent
					1000,																																									-- money reward, if we aren't giving something else for this faction
					faction_key																																								-- faction key
				),
				payload.agent_for_faction(faction_key, initial_enemy_mission_agent_reward_type, initial_enemy_mission_agent_reward_subtype)
			}
		);

		-- embed agent trigger/mission
		narrative.add_data_for_faction(faction_key, "chs_trigger_character_created_for_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);								-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);														-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_mission_key", "wh3_main_camp_narrative_chaos_zhao_ming_embed_hero_01");										-- mission key

		-- recruit units mission
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_advice_key", "wh3_main_camp_narrative_chs_zhao_ming_recruit_units_01");					-- advice key
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_mission_key", "wh3_main_camp_narrative_chaos_zhao_ming_recruit_units_01");					-- mission key

		-- pre-capture settlement can-reach trigger
		narrative.add_data_for_faction(faction_key, "chs_trigger_settlement_capture_can_reach_target_faction_key", initial_enemy_faction_key);

		-- capture settlement 
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_advice_key", "wh3_main_camp_narrative_chs_zhao_ming_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_main_camp_narrative_chaos_zhao_ming_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_region_key", initial_enemy_region_key);

		-- capture province mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_advice_key", "wh3_main_camp_narrative_chs_zhao_ming_capture_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_main_camp_narrative_chaos_zhao_ming_complete_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_province_keys", initial_enemy_province_key);										-- specify the province that has to be captured for this mission

		-- cathay compass mission cooldown - Zhao Ming has a 4 turn wait before he can use the compass
		narrative.add_data_for_faction(faction_key, "cathay_compass_trigger_pre_altered_compass_query_turn_countdown_num_turns", 4);
	end;

	
	

	
	
	------------------------------
	------------------------------
	-- OGRE KINGDOMS
	------------------------------
	------------------------------
	

	--
	-- GREASUS GOLDTOOTH
	--

	if cm:is_faction_human("wh3_main_ogr_goldtooth") then
		local faction_key = "wh3_main_ogr_goldtooth";																																	-- key of faction to apply overrides for
		local initial_enemy_faction_key = "wh3_main_ogr_crossed_clubs";																													-- key of their initial enemy faction
		local initial_enemy_region_key = get_initial_enemy_region_key(faction_key, initial_enemy_faction_key);																			-- key of the closest enemy faction region to player
		local initial_enemy_province_key = get_initial_enemy_province_key(initial_enemy_faction_key, initial_enemy_region_key)															-- province controlled by initial enemy faction
		local initial_enemy_mission_agent_reward_type = "spy";
		local initial_enemy_mission_agent_reward_subtype = "wh3_main_ogr_hunter";
	
		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "initial_enemy_faction_key", initial_enemy_faction_key);																			-- initial enemy faction
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_advice_key", "wh3_main_camp_narrative_chs_greasus_attack_enemy_01");								-- advice key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_main_camp_narrative_chaos_greasus_defeat_initial_enemy_01");					-- mission key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", 																				-- mission reward
			{
				payload.money(																																							-- issue money or equivalent
					1000,																																									-- money reward, if we aren't giving something else for this faction
					faction_key,																																							-- faction key
					{																																										-- params for potential money replacement
						value = "med",																																							-- value of this mission - see wh3_campaign_payload_remapping.lua
						glory_type = "khorne"																																					-- glory type to issue
					}
				),
				payload.agent_for_faction(faction_key, initial_enemy_mission_agent_reward_type, initial_enemy_mission_agent_reward_subtype)
			}
		);

		-- embed agent trigger/mission
		narrative.add_data_for_faction(faction_key, "chs_trigger_character_created_for_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);								-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);														-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_mission_key", "wh3_main_camp_narrative_chaos_greasus_embed_hero_01");										-- mission key

		-- recruit units mission
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_advice_key", "wh3_main_camp_narrative_chs_greasus_recruit_units_01");					-- advice key
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_mission_key", "wh3_main_camp_narrative_chaos_greasus_recruit_units_01");				-- mission key

		-- pre-capture settlement can-reach trigger
		narrative.add_data_for_faction(faction_key, "chs_trigger_settlement_capture_can_reach_target_faction_key", initial_enemy_faction_key);

		-- capture settlement 
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_advice_key", "wh3_main_camp_narrative_chs_greasus_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_main_camp_narrative_chaos_greasus_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_region_key", initial_enemy_region_key);

		-- capture province mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_advice_key", "wh3_main_camp_narrative_chs_greasus_capture_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_main_camp_narrative_chaos_greasus_complete_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_province_keys", initial_enemy_province_key);										-- specify the province that has to be captured for this mission

		-- Text overrides for upgrade settlement missions
		narrative.todo_output("Move these text overrides to somewhere more central");
		narrative.add_data_for_faction(faction_key, "shared_settlement_upgrade_upgrade_any_settlement_level_three_mission_key", "wh3_main_camp_narrative_ogres_upgrade_settlement_02");
		narrative.add_data_for_faction(faction_key, "shared_settlement_upgrade_upgrade_any_settlement_level_five_mission_key", "wh3_main_camp_narrative_ogres_upgrade_settlement_03");

		-- Switch in "evil" diplomacy advice line variants
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_non_aggression_pact_mission_advice_key", "wh3_main_camp_narrative_shared_non_aggression_pact_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_trade_mission_advice_key", "wh3_main_camp_narrative_shared_trade_agreement_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_confederation_mission_advice_key", "wh3_main_camp_narrative_shared_war_confederation_02");
	end;



	--
	-- DISCIPLES OF THE MAW :: SKRAG
	--

	if cm:is_faction_human("wh3_main_ogr_disciples_of_the_maw") then
		local faction_key = "wh3_main_ogr_disciples_of_the_maw";																														-- key of faction to apply overrides for
		local initial_enemy_faction_key = "wh_main_dwf_karak_ziflin";																													-- key of their initial enemy faction
		local initial_enemy_region_key = get_initial_enemy_region_key(faction_key, initial_enemy_faction_key);																			-- key of the closest enemy faction region to player
		local initial_enemy_province_key = get_initial_enemy_province_key(initial_enemy_faction_key, initial_enemy_region_key)															-- province controlled by initial enemy faction
		local initial_enemy_mission_agent_reward_type = "wizard";
		local initial_enemy_mission_agent_reward_subtype = "wh3_main_ogr_butcher_beasts";
	
		-- defeat initial enemy mission
		narrative.add_data_for_faction(faction_key, "initial_enemy_faction_key", initial_enemy_faction_key);																			-- initial enemy faction
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_advice_key", "wh3_main_camp_narrative_chs_skrag_attack_enemy_01");								-- advice key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_key", "wh3_main_camp_narrative_chaos_skrag_defeat_initial_enemy_01");					-- mission key
		narrative.add_data_for_faction(faction_key, "shared_event_defeat_initial_enemy_mission_rewards", 																				-- mission reward
			{
				payload.money(																																							-- issue money or equivalent
					1000,																																									-- money reward, if we aren't giving something else for this faction
					faction_key																																								-- faction key
				),
				payload.agent_for_faction(faction_key, initial_enemy_mission_agent_reward_type, initial_enemy_mission_agent_reward_subtype)
			}
		);

		-- embed agent trigger/mission
		narrative.add_data_for_faction(faction_key, "chs_trigger_character_created_for_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);								-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_subtype", initial_enemy_mission_agent_reward_subtype);														-- agent subtype
		narrative.add_data_for_faction(faction_key, "chs_event_embed_agent_mission_key", "wh3_main_camp_narrative_chaos_skrag_embed_hero_01");											-- mission key

		-- recruit units mission
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_advice_key", "wh3_main_camp_narrative_chs_skrag_recruit_units_01");					-- advice key
		narrative.add_data_for_faction(faction_key, "shared_unit_recruitment_event_recruit_units_mission_key", "wh3_main_camp_narrative_chaos_skrag_recruit_units_01");					-- mission key

		-- pre-capture settlement can-reach trigger
		narrative.add_data_for_faction(faction_key, "chs_trigger_settlement_capture_can_reach_target_faction_key", initial_enemy_faction_key);

		-- capture settlement 
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_advice_key", "wh3_main_camp_narrative_chs_skrag_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_mission_key", "wh3_main_camp_narrative_chaos_skrag_capture_settlement_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_capture_settlement_region_key", initial_enemy_region_key);

		-- capture province mission
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_advice_key", "wh3_main_camp_narrative_chs_skrag_capture_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_mission_key", "wh3_main_camp_narrative_chaos_skrag_complete_province_01");
		narrative.add_data_for_faction(faction_key, "shared_settlement_capture_event_control_province_province_keys", initial_enemy_province_key);										-- specify the province that has to be captured for this mission

		-- Text overrides for upgrade settlement missions
		narrative.todo_output("Move these text overrides to somewhere more central");
		narrative.add_data_for_faction(faction_key, "shared_settlement_upgrade_upgrade_any_settlement_level_three_mission_key", "wh3_main_camp_narrative_ogres_upgrade_settlement_02");
		narrative.add_data_for_faction(faction_key, "shared_settlement_upgrade_upgrade_any_settlement_level_five_mission_key", "wh3_main_camp_narrative_ogres_upgrade_settlement_03");

		-- Switch in "evil" diplomacy advice line variants
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_non_aggression_pact_mission_advice_key", "wh3_main_camp_narrative_shared_non_aggression_pact_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_trade_mission_advice_key", "wh3_main_camp_narrative_shared_trade_agreement_02");
		narrative.add_data_for_faction(faction_key, "shared_diplomacy_event_confederation_mission_advice_key", "wh3_main_camp_narrative_shared_war_confederation_02");
	end;

end;

narrative.add_data_setup_callback(customise_narrative_event_faction_data_for_campaign);









------------------------------------------------------------------------------------------------------------------
-- Narrative Event customisation for all factions in this campaign
------------------------------------------------------------------------------------------------------------------

local function setup_campaign_narrative_event_data_all_factions()


	-- RECRUITMENT
		
	-- The full unit recruitment chain always triggers - both answers to the advice query are StartUnitRecruitmentChainFull
	narrative.add_data_for_campaign("shared_unit_recruitment_query_advice_positive_messages",							"StartUnitRecruitmentChainFull");

	-- Initial Recruit Units mission triggers after the defeat initial enemy mission is completed, target number of units is reduced, and completion of the mission also starts the settlement capture chain
	narrative.add_data_for_campaign("shared_unit_recruitment_event_recruit_units_trigger_messages",						{"StartUnitRecruitmentRecruitUnits", "DefeatInitialEnemyCompleted"});
	narrative.add_data_for_campaign("shared_unit_recruitment_event_recruit_units_num_units",							2);
	narrative.add_data_for_campaign("shared_unit_recruitment_event_recruit_units_completed_messages",					{"StartUnitRecruitmentTransitionToExpert", "StartSettlementCaptureChain"});

	-- Make the Recruit Many Units mission trigger soon after the recruit units mission is issued, and reduce the target number of units
	narrative.add_data_for_campaign(
		"shared_unit_recruitment_trigger_pre_recruit_many_units_turn_countdown_transition_num_turns",
		2
	);
	narrative.add_data_for_campaign(
		"shared_unit_recruitment_trigger_pre_recruit_many_units_turn_countdown_transition_immediate",
		true
	);
	narrative.add_data_for_campaign("shared_unit_recruitment_event_recruit_many_units_num_units",						20);





	-- SETTLEMENT CAPTURE

	-- Customise when settlement captured chain starts
	narrative.add_data_for_campaign("shared_settlement_capture_query_can_capture_territory_trigger_messages",			"StartSettlementCaptureChain");

	-- Settlement captured chain: the can-capture-territory mission directly triggers the capture-settlement mission. This means the chain never enters expert mode.
	narrative.add_data_for_campaign("shared_settlement_capture_query_can_capture_territory_positive_messages",			"StartChaosCaptureSettlementMission");

	-- Start the capture-settlement mission when the chain starts
	narrative.add_data_for_campaign("shared_settlement_capture_event_capture_settlement_trigger_messages",				"StartChaosCaptureSettlementMission");
	
	-- Uncouple the negative message for the settlement capture advice query - we only want to start settlement missions from StartChaosCaptureSettlementMission
	-- narrative.add_data_for_campaign("shared_settlement_capture_query_advice_negative_messages",							"");

	-- Capture Province mission is specific to the target province
	-- narrative.add_data_for_campaign("shared_settlement_capture_event_control_province_province_keys",				--[[ now set up for each faction]]);

	-- Extend delay on expert mission triggering
	narrative.add_data_for_campaign("shared_settlement_capture_trigger_pre_control_provinces_num_turns",				10);

	-- Redirect this query so that the Enact Commandment mission never gets issued
	narrative.add_data_for_campaign("shared_settlement_capture_query_pre_enact_commandment_negative_messages",			"StartSettlementCapturedQueryTwoProvincesOwned");




	-- TECHNOLOGY
	-- No technology missions for some reason
	narrative.add_data_for_campaign("shared_technology_chain_block", 													true);


	-- HEROES
	-- No heroes missions either
	narrative.add_data_for_campaign("shared_heroes_chain_block",					 									true);


	-- FINANCE
	-- Disable the less-substantial income triggers
	narrative.add_data_for_campaign("shared_finance_trigger_pre_gain_less_substantial_income_turn_countdown_block",		true);
	narrative.add_data_for_campaign("shared_finance_trigger_gain_less_substantial_income_block",						true);
	

end;

narrative.add_data_setup_callback(setup_campaign_narrative_event_data_all_factions);











------------------------------------------------------------------------------------------------------------------
-- Start Narrative Events
------------------------------------------------------------------------------------------------------------------

-- Called by the campaign script to start all narrative events for all player factions. This calls narrative.start_narrative_events_shared(), passing in 
-- the campaign-specific narrative event loader function.
function start_narrative_events()

	-- <Data setup callbacks and narrative event loaders are added elsewhere from this function>

	-- Setup all narrative data
	narrative.start();
end;










------------------------------------------------------------------------------------------------------------------
-- Start Campaign-Specific Narrative Events
------------------------------------------------------------------------------------------------------------------

function start_narrative_events_chaos_for_faction(faction_key)
	
	-- output header
	narrative.output_chain_header("chaos_campaign_narrative", faction_key);
	
	local shared_prepend_str = shared_narrative_event_prepend_str;

	if not narrative.exception_factions[faction_key] then

		-----------------------------------------------------------------------------------------------------------
		--	CHAOS MISSION ONE: Attack Initial Enemy
		-----------------------------------------------------------------------------------------------------------
	

		-----------------------------------------------------------------------------------------------------------
		--	Post Defeat Initial Enemy
		--	We try and pick up the character spawned as part of the attack-initial-enemy mission reward,
		--	and apply bonuses to it. The callback that does this must be provided in faction/campaign data
		-----------------------------------------------------------------------------------------------------------

		do
			local name = "chs_event_post_defeat_initial_enemy_callback";

			if narrative.get(faction_key, name .. "_allow") then		-- disabled by default
				narrative_events.callback(
					name,																																-- unique name for this narrative event
					faction_key,																														-- key of faction to which it applies
					-- this must be provided in faction narrative data when this narrative event is allowed
					narrative.get(faction_key, name .. "_callback"),																					-- key of advice to deliver
					narrative.get(faction_key, name .. "_trigger_messages") or "DefeatInitialEnemyCompleted"											-- script message(s) on which to trigger when received
				);
			end;
		end;






		-----------------------------------------------------------------------------------------------------------
		--	Character Created
		--	This trigger starts the embed-agent mission whenever the first agent appears (it should be
		--	a reward for another early-game mission)
		-----------------------------------------------------------------------------------------------------------

		do
			local name = "chs_trigger_character_created_for_embed_agent";

			local condition_callback;

			local matching_subtype = narrative.get(faction_key, name .. "_subtype");
			if matching_subtype then
				function condition_callback(context)
					return context:character():character_subtype_key() == matching_subtype
				end
			else
				function condition_callback(context)
					return true;
				end;
			end;

			if not narrative.get(faction_key, name .. "_block") then
				narrative_triggers.agent_created(
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages") or "StartNarrativeEvents",																-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or "StartEmbedAgentMission",																-- target message(s) to trigger
					narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
					narrative.get(faction_key, name .. "_condition") or condition_callback																			-- condition function
				);
			end;
		end;


		-----------------------------------------------------------------------------------------------------------
		--	Embed Agent
		-----------------------------------------------------------------------------------------------------------

		do
			local name = "chs_event_embed_agent";

			local matching_subtype = narrative.get(faction_key, name .. "_subtype");

			if matching_subtype and not narrative.get(faction_key, name .. "_block") then
				narrative_events.embed_agent(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_chs_shared_hero_spawned_01",										-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key"),		-- overriden for each faction															-- key of mission to deliver
					narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_embed_agent",									-- key of mission objective
					narrative.get(faction_key, name .. "_subtypes") or matching_subtype,																			-- performing character subtype key(s)
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
						payload.money(																																	-- issue money or equivalent
							500,																																			-- money reward, if we aren't giving something else for this faction
							faction_key,																																	-- faction key
							{																																				-- params for potential money replacement
								value = "v_low",																																-- value of this mission  - see wh3_campaign_payload_remapping.lua
								glory_type = "slaanesh,nurgle"																													-- glory type to issue
							}
						)
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "StartEmbedAgentMission",															-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list"),																							-- list of other narrative events to inherit rewards from (may be nil)
					true																																			-- trigger with high priority (replace this mechanism)
				);
			end;
		end;
		

		-----------------------------------------------------------------------------------------------------------
		--	DAEMON PRINCE: Turn Two Start
		--	This trigger starts the occupy ruined settlement mission on turn two, for the Daemon Prince only
		-----------------------------------------------------------------------------------------------------------

		do
			local name = "chs_event_daemon_prince_occupy_initial_settlement_countdown";

			if narrative.get(faction_key, name .. "_allow") then
				narrative_triggers.turn_countdown(
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages") or "StartNarrativeEvents",																-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or "StartDPOccupyInitialSettlementMission",												-- target message(s) to trigger
					narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
					narrative.get(faction_key, name .. "_num_turns") or 1,																							-- num turns to wait
					narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
				);
			end;
		end;


		-----------------------------------------------------------------------------------------------------------
		--	DAEMON PRINCE: Occupy ruined settlement, for the Daemon Prince only
		-----------------------------------------------------------------------------------------------------------

		do
			local name = "chs_event_daemon_prince_occupy_initial_settlement";

			local target_region = narrative.get(faction_key, "initial_unoccupied_region_key");

			if narrative.get(faction_key, name .. "_allow") then	-- disabled by default
				narrative_events.capture_settlement(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_chs_daemon_prince_capture_settlement_01",							-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_chaos_daemon_prince_capture_settlement_01",						-- key of mission to deliver
					narrative.get(faction_key, name .. "_faction_key"),																								-- faction key of target faction - can be nil
					narrative.get(faction_key, name .. "_region_key") or target_region,																				-- region key of target settlement - can be table of multiple keys
					narrative.get(faction_key, name .. "_camera_target") or 																						-- target to move camera to (can be string region/faction key, char cqi, table with x/y display positions, or nil)
						function()
							return target_region;
						end,
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards"),																							-- mission rewards
					narrative.get(faction_key, name .. "_trigger_messages") or {"DefeatInitialEnemyCompleted", "StartDPOccupyInitialSettlementMission"},			-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages"), -- overridden in faction data														-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list"),																							-- list of other narrative events to inherit rewards from (may be nil)
					true	-- high priority - replace this at some point
				);
			end;
		end;


		-----------------------------------------------------------------------------------------------------------
		--	DAEMON PRINCE: Occupy Ruined Settlement as Khorne trigger, for the Daemon Prince only
		-----------------------------------------------------------------------------------------------------------
		
		do
			local name = "chs_event_daemon_prince_trigger_occupation_decision_as_khorne";

			if narrative.get(faction_key, name .. "_allow") then
				local initial_unoccupied_region_key = narrative.get(faction_key, "initial_unoccupied_region_key");

				narrative_triggers.generic(
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages") or {"DefeatInitialEnemyCompleted", "StartDPOccupyInitialSettlementMission"},				-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or "DPDedicatedInitialSettlementToKhorne",												-- target message(s) to trigger
					narrative.get(faction_key, name .. "_cancel_messages") or {																						-- script message(s) on which to cancel
						"DPDedicatedInitialSettlementToNurgle",
						"DPDedicatedInitialSettlementToSlaanesh",
						"DPDedicatedInitialSettlementToTzeentch"
					},
					narrative.get(faction_key, name .. "_event") or "CharacterPerformsSettlementOccupationDecision",												-- event name
					narrative.get(faction_key, name .. "_condition") or																								-- event condition
						function(context)
							return context:character():faction():name() == faction_key and 
								context:garrison_residence():region():name() == initial_unoccupied_region_key and
								context:occupation_decision() == "1913205844"
						end,
					narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
				);
			end;
		end;


		-----------------------------------------------------------------------------------------------------------
		--	DAEMON PRINCE: Occupy Ruined Settlement as Nurgle trigger, for the Daemon Prince only
		-----------------------------------------------------------------------------------------------------------
		
		do
			local name = "chs_event_daemon_prince_trigger_occupation_decision_as_nurgle";

			if narrative.get(faction_key, name .. "_allow") then
				local initial_unoccupied_region_key = narrative.get(faction_key, "initial_unoccupied_region_key");

				narrative_triggers.generic(
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages") or {"DefeatInitialEnemyCompleted", "StartDPOccupyInitialSettlementMission"},				-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or "DPDedicatedInitialSettlementToNurgle",												-- target message(s) to trigger
					narrative.get(faction_key, name .. "_cancel_messages") or {																						-- script message(s) on which to cancel
						"DPDedicatedInitialSettlementToKhorne",
						"DPDedicatedInitialSettlementToSlaanesh",
						"DPDedicatedInitialSettlementToTzeentch"
					},
					narrative.get(faction_key, name .. "_event") or "CharacterPerformsSettlementOccupationDecision",												-- event name
					narrative.get(faction_key, name .. "_condition") or																								-- event condition
						function(context)
							return context:character():faction():name() == faction_key and 
								context:garrison_residence():region():name() == initial_unoccupied_region_key and
								context:occupation_decision() == "1716173921"
						end,
					narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
				);
			end;
		end;


		-----------------------------------------------------------------------------------------------------------
		--	DAEMON PRINCE: Occupy Ruined Settlement as Slaanesh trigger, for the Daemon Prince only
		-----------------------------------------------------------------------------------------------------------
		
		do
			local name = "chs_event_daemon_prince_trigger_occupation_decision_as_slaanesh";

			if narrative.get(faction_key, name .. "_allow") then
				local initial_unoccupied_region_key = narrative.get(faction_key, "initial_unoccupied_region_key");

				narrative_triggers.generic(
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages") or {"DefeatInitialEnemyCompleted", "StartDPOccupyInitialSettlementMission"},				-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or "DPDedicatedInitialSettlementToSlaanesh",												-- target message(s) to trigger
					narrative.get(faction_key, name .. "_cancel_messages") or {																						-- script message(s) on which to cancel
						"DPDedicatedInitialSettlementToKhorne",
						"DPDedicatedInitialSettlementToNurgle",
						"DPDedicatedInitialSettlementToTzeentch"
					},
					narrative.get(faction_key, name .. "_event") or "CharacterPerformsSettlementOccupationDecision",												-- event name
					narrative.get(faction_key, name .. "_condition") or																								-- event condition
						function(context)
							return context:character():faction():name() == faction_key and 
								context:garrison_residence():region():name() == initial_unoccupied_region_key and
								context:occupation_decision() == "1968313178"
						end,
					narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
				);
			end;
		end;


		-----------------------------------------------------------------------------------------------------------
		--	DAEMON PRINCE: Occupy Ruined Settlement as Tzeentch trigger, for the Daemon Prince only
		-----------------------------------------------------------------------------------------------------------
		
		do
			local name = "chs_event_daemon_prince_trigger_occupation_decision_as_tzeentch";

			if narrative.get(faction_key, name .. "_allow") then
				local initial_unoccupied_region_key = narrative.get(faction_key, "initial_unoccupied_region_key");

				narrative_triggers.generic(
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages") or {"DefeatInitialEnemyCompleted", "StartDPOccupyInitialSettlementMission"},				-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or "DPDedicatedInitialSettlementToTzeentch",												-- target message(s) to trigger
					narrative.get(faction_key, name .. "_cancel_messages") or {																						-- script message(s) on which to cancel
						"DPDedicatedInitialSettlementToKhorne",
						"DPDedicatedInitialSettlementToNurgle",
						"DPDedicatedInitialSettlementToSlaanesh"
					},
					narrative.get(faction_key, name .. "_event") or "CharacterPerformsSettlementOccupationDecision",												-- event name
					narrative.get(faction_key, name .. "_condition") or																								-- event condition
						function(context)
							return context:character():faction():name() == faction_key and 
								context:garrison_residence():region():name() == initial_unoccupied_region_key and
								context:occupation_decision() == "260200307"
						end,
					narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
				);
			end;
		end;


		-----------------------------------------------------------------------------------------------------------
		--	DAEMON PRINCE: Recruit Units after Khorne dedication
		-----------------------------------------------------------------------------------------------------------

		do
			local name = "chs_event_daemon_prince_recruit_units_khorne";

			if narrative.get(faction_key, name .. "_allow") then
				local initial_unoccupied_region_key = narrative.get(faction_key, "initial_unoccupied_region_key");

				narrative_events.recruit_units(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_chs_daemon_prince_recruit_units_01",								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_chaos_daemon_prince_recruit_units_khorne_01",					-- key of mission to deliver
					narrative.get(faction_key, name .. "_num_units") or 2,			 																				-- number of units
					narrative.get(faction_key, name .. "_unit_keys"),																								-- opt unit keys
					narrative.get(faction_key, name .. "_exclude_existing") or true,																				-- exclude preexisting units
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
						payload.agent(
							initial_unoccupied_region_key,
							"dignitary",
							"wh3_main_kho_bloodreaper"
						)
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "DPDedicatedInitialSettlementToKhorne",												-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages") or "UnitRecruitmentRecruitUnitsCompleted",											-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list"),																							-- list of other narrative events to inherit rewards from (may be nil)
					true			-- high priority - replace this switch
				);
			end;
		end;


		-----------------------------------------------------------------------------------------------------------
		--	DAEMON PRINCE: Recruit Units after Nurgle dedication
		-----------------------------------------------------------------------------------------------------------

		do
			local name = "chs_event_daemon_prince_recruit_units_nurgle";

			if narrative.get(faction_key, name .. "_allow") then
				local initial_unoccupied_region_key = narrative.get(faction_key, "initial_unoccupied_region_key");

				narrative_events.recruit_units(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_chs_daemon_prince_recruit_units_01",								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_chaos_daemon_prince_recruit_units_nurgle_01",					-- key of mission to deliver
					narrative.get(faction_key, name .. "_num_units") or 2,			 																				-- number of units
					narrative.get(faction_key, name .. "_unit_keys"),																								-- opt unit keys
					narrative.get(faction_key, name .. "_exclude_existing") or true,																				-- exclude preexisting units
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
						payload.agent(
							initial_unoccupied_region_key,
							"spy",
							"wh3_main_nur_plagueridden_nurgle"
						)
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "DPDedicatedInitialSettlementToNurgle",												-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages") or "UnitRecruitmentRecruitUnitsCompleted",											-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list"),																							-- list of other narrative events to inherit rewards from (may be nil)
					true			-- high priority - replace this switch
				);
			end;
		end;


		-----------------------------------------------------------------------------------------------------------
		--	DAEMON PRINCE: Recruit Units after Slaanesh dedication
		-----------------------------------------------------------------------------------------------------------

		do
			local name = "chs_event_daemon_prince_recruit_units_slaanesh";

			if narrative.get(faction_key, name .. "_allow") then
				local initial_unoccupied_region_key = narrative.get(faction_key, "initial_unoccupied_region_key");

				narrative_events.recruit_units(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_chs_daemon_prince_recruit_units_01",								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_chaos_daemon_prince_recruit_units_slaanesh_01",					-- key of mission to deliver
					narrative.get(faction_key, name .. "_num_units") or 2,			 																				-- number of units
					narrative.get(faction_key, name .. "_unit_keys"),																								-- opt unit keys
					narrative.get(faction_key, name .. "_exclude_existing") or true,																				-- exclude preexisting units
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
						payload.agent(
							initial_unoccupied_region_key,
							"engineer",
							"wh3_main_sla_alluress_slaanesh"
						)
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "DPDedicatedInitialSettlementToSlaanesh",											-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages") or "UnitRecruitmentRecruitUnitsCompleted",											-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list"),																							-- list of other narrative events to inherit rewards from (may be nil)
					true			-- high priority - replace this switch
				);
			end;
		end;


		-----------------------------------------------------------------------------------------------------------
		--	DAEMON PRINCE: Recruit Units after Tzeentch dedication
		-----------------------------------------------------------------------------------------------------------

		do
			local name = "chs_event_daemon_prince_recruit_units_tzeentch";

			if narrative.get(faction_key, name .. "_allow") then
				local initial_unoccupied_region_key = narrative.get(faction_key, "initial_unoccupied_region_key");

				narrative_events.recruit_units(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_chs_daemon_prince_recruit_units_01",								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_chaos_daemon_prince_recruit_units_tzeentch_01",					-- key of mission to deliver
					narrative.get(faction_key, name .. "_num_units") or 2,			 																				-- number of units
					narrative.get(faction_key, name .. "_unit_keys"),																								-- opt unit keys
					narrative.get(faction_key, name .. "_exclude_existing") or true,																				-- exclude preexisting units
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
						payload.agent(
							initial_unoccupied_region_key,
							"runesmith",
							"wh3_main_tze_iridescent_horror_tzeentch"
						)
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "DPDedicatedInitialSettlementToTzeentch",											-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages") or "UnitRecruitmentRecruitUnitsCompleted",											-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list"),																							-- list of other narrative events to inherit rewards from (may be nil)
					true			-- high priority - replace this switch
				);
			end;
		end;


		-----------------------------------------------------------------------------------------------------------
		--	KHORNE: Occupy or raze initial settlement, for Khorne only
		-----------------------------------------------------------------------------------------------------------

		do
			local name = "chs_event_khorne_occupy_or_raze_initial_settlement";

			if narrative.get(faction_key, name .. "_allow") then	-- disabled by default
				narrative_events.raze_or_own_settlements(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_chs_skarbrand_capture_settlement_01",								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_chaos_skarbrand_capture_settlement_01",							-- key of mission to deliver
					narrative.get(faction_key, name .. "_region_key"), -- overridden in faction data																-- region key of target settlement - can be table of multiple keys
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
						payload.money(1000, faction_key)																												-- issue money or equivalent
					},
					-- messages set up to mirror shared_settlement_capture_event_capture_settlement narrative event
					narrative.get(faction_key, name .. "_trigger_messages") or "StartChaosCaptureSettlementMission", 												-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages") or "StartSettlementCapturedCaptureProvince", 											-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;
		end;



		-----------------------------------------------------------------------------------------------------------
		--	NORTHERN PROVINCES: Capture Snake Gate, for Cathay Northern Provinces only
		-----------------------------------------------------------------------------------------------------------

		-- Turn countdown prior to mission
		do
			local name = "chs_event_cathay_pre_capture_snake_gate_turn_countdown";

			if narrative.get(faction_key, name .. "_allow") then	-- disabled by default
				narrative_triggers.turn_countdown(
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages") or "StartSettlementCaptureChain",															-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or "StartCathayCaptureSnakeGateMission",													-- target message(s) to trigger
					narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
					narrative.get(faction_key, name .. "_num_turns") or 1,																							-- num turns to wait
					narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
				);
			end;
		end;


		-- Can-reach test prior to mission
		do
			local name = "chs_event_cathay_pre_capture_snake_gate_can_reach";

			if narrative.get(faction_key, name .. "_allow") then	-- disabled by default
				narrative_triggers.can_reach_settlement(
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages"),																							-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or "StartCathayCaptureSnakeGateMission",													-- target message(s) to trigger
					narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
					narrative.get(faction_key, name .. "_target_regions") or "wh3_main_chaos_region_snake_gate",													-- num turns to wait
					narrative.get(faction_key, name .. "_include_agents") or false																					-- trigger immediately
				);
			end;
		end;


		-- Mission itself
		do
			local name = "chs_event_cathay_capture_snake_gate";

			if narrative.get(faction_key, name .. "_allow") then	-- disabled by default
				narrative_events.capture_settlement(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_chaos_miao_ying_capture_snake_gate_01",							-- key of mission to deliver
					narrative.get(faction_key, name .. "_faction_key"),																								-- faction key of target faction - can be nil
					narrative.get(faction_key, name .. "_region_key") or "wh3_main_chaos_region_snake_gate",														-- region key of target settlement - can be table of multiple keys
					narrative.get(faction_key, name .. "_camera_target"),																							-- target to move camera to (can be string region/faction key, char cqi, table with x/y display positions, or nil)
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
						payload.money(1000),
						payload.ancillary_mission_payload(faction_key, "weapon", "common")
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "StartCathayCaptureSnakeGateMission",												-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages"), -- overridden in faction data														-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;
		end;



		-----------------------------------------------------------------------------------------------------------
		--	NORTHERN PROVINCES: Eliminate faction, for Cathay Northern Provinces only
		-----------------------------------------------------------------------------------------------------------

		-- Turn countdown prior to mission
		do
			local name = "chs_event_cathay_pre_eliminate_faction_turn_countdown";

			if narrative.get(faction_key, name .. "_allow") then	-- disabled by default
				narrative_triggers.turn_countdown(
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages") or "StartSettlementCapturedCaptureProvince",												-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or "StartCathayEliminateFactionMission",													-- target message(s) to trigger
					narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
					narrative.get(faction_key, name .. "_num_turns") or 1,																							-- num turns to wait
					narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
				);
			end;
		end;

		-- Mission itself
		do
			local name = "chs_event_cathay_eliminate_faction";

			if narrative.get(faction_key, name .. "_allow") then	-- disabled by default
				narrative_events.destroy_faction(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key") or "wh3_main_camp_narrative_chs_miao_ying_destroy_enemy_01",									-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_chaos_miao_ying_eliminate_faction_01",							-- key of mission to deliver
					narrative.get(faction_key, name .. "_target_faction_key") or "wh3_main_tze_sarthoraels_watchers",												-- faction key(s) of target faction(s)
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
						payload.money(3000),																															-- issue money
						payload.ancillary_mission_payload(faction_key, "weapon", "uncommon")
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "StartCathayEliminateFactionMission",												-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages"), 																						-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list"),																							-- list of other narrative events to inherit rewards from (may be nil)
					true	-- high priority - replace this at some point
				);
			end;
		end;






		

		-----------------------------------------------------------------------------------------------------------
		--	Settlement Capture can-reach
		--	This trigger starts the settlement capture narrative chain if the player can reach the 
		--	target faction (if it hasn't been started already)
		-----------------------------------------------------------------------------------------------------------

		do
			local name = "chs_trigger_settlement_capture_can_reach";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_triggers.can_reach_faction(
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages") or "StartNarrativeEvents",																-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or "StartSettlementCaptureChain",														-- target message(s) to trigger
					narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
					narrative.get(faction_key, name .. "_target_faction_key"), --[[ to be overridden]]																-- num turns to wait
					narrative.get(faction_key, name .. "_include_armies") or false																					-- include target faction's roaming armies in can-reach test
				);
			end;
		end;



		-----------------------------------------------------------------------------------------------------------
		--	Settlement Capture Turn Four Start
		--	This trigger starts the settlement capture narrative chain on turn four (if it hasn't been started already)
		-----------------------------------------------------------------------------------------------------------

		do
			local name = "chs_trigger_settlement_capture_turn_countdown";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_triggers.turn_countdown(
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages") or "StartNarrativeEvents",																-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or "StartSettlementCaptureChain",														-- target message(s) to trigger
					narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
					narrative.get(faction_key, name .. "_num_turns") or 4,																							-- num turns to wait
					narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
				);
			end;
		end;




		-----------------------------------------------------------------------------------------------------------
		--	Trigger on rifts opened
		-----------------------------------------------------------------------------------------------------------
		
		do
			local name = "chs_trigger_rifts_opened";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_triggers.generic(
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages") or "StartNarrativeEvents",																-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or "StartSharedChaosCloseRiftsMissionCountdown",											-- target message(s) to trigger
					narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
					narrative.get(faction_key, name .. "_event") or "ScriptEventUrsunsRoarTriggered",																-- event name
					narrative.get(faction_key, name .. "_condition") or	true,																						-- event condition
					narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately or via intervention
				);
			end;
		end;

		
		-----------------------------------------------------------------------------------------------------------
		--	Turn Countdown to Close Rifts Mission
		-----------------------------------------------------------------------------------------------------------

		do
			local name = "chs_trigger_close_rifts_turn_countdown";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_triggers.turn_countdown(
					name,																																			-- unique name for this narrative trigger
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_start_messages") or "StartSharedChaosCloseRiftsMissionCountdown",											-- script message(s) on which to start
					narrative.get(faction_key, name .. "_target_messages") or "StartSharedChaosCloseRiftsMission",													-- target message(s) to trigger
					narrative.get(faction_key, name .. "_cancel_messages"),																							-- script message(s) on which to cancel
					narrative.get(faction_key, name .. "_num_turns") or 2,																							-- num turns to wait
					narrative.get(faction_key, name .. "_immediate") or true																						-- trigger immediately
				);
			end;
		end;


		-----------------------------------------------------------------------------------------------------------
		-- Close Rifts Mission
		-----------------------------------------------------------------------------------------------------------

		do
			local name = "chs_event_close_rifts_mission";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.generic(
					name,																																			-- unique name for this narrative event
					faction_key,																																	-- key of faction to which it applies
					narrative.get(faction_key, name .. "_advice_key"),																								-- key of advice to deliver
					narrative.get(faction_key, name .. "_mission_key") or "wh3_main_camp_narrative_shared_close_chaos_rift_01",										-- key of mission to deliver
					narrative.get(faction_key, name .. "_mission_text") or "wh3_main_narrative_mission_description_close_a_rift",									-- key of mission objective text
					narrative.get(faction_key, name .. "_event_listeners") or {																						-- event/condition listeners
						{
							event = "ScriptEventRiftClosureBattleWon",
							condition =	function(context)
								return context:character():faction():name() == faction_key;
							end
						}
					},
					narrative.get(faction_key, name .. "_camera_scroll_callback"),																					-- camera scroll callback
					narrative.get(faction_key, name .. "_mission_issuer"),																							-- mission issuer (can be nil in which case default is used)
					narrative.get(faction_key, name .. "_mission_rewards") or {																						-- mission rewards
						payload.money(																																	-- issue money or equivalent
							750,																																			-- money reward, if we aren't giving something else for this faction
							faction_key,																																	-- faction key
							{																																				-- params for potential money replacement
								value = "low",																																-- value of this mission  - see wh3_campaign_payload_remapping.lua
								glory_type = "tzeentch,slaanesh"																												-- glory type to issue
							}
						)
					},
					narrative.get(faction_key, name .. "_trigger_messages") or "StartSharedChaosCloseRiftsMission",													-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages"),																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
					narrative.get(faction_key, name .. "_completed_messages"),																						-- script message(s) to trigger when this mission is completed
					narrative.get(faction_key, name .. "_inherit_list")																								-- list of other narrative events to inherit rewards from (may be nil)
				);
			end;
		end;


		

		-----------------------------------------------------------------------------------------------------------
		--	Mark Realm Intros as seen (triggered later, shared between realms)
		-----------------------------------------------------------------------------------------------------------

		do
			local name = "chs_event_any_realm_intro_seen";

			if not narrative.get(faction_key, name .. "_block") then
				narrative_events.set_saved_value(
					name,																																-- unique name for this narrative event
					faction_key,																														-- key of faction to which it applies
					narrative.get(faction_key, name .. "_seen_key") or "any_realm_cindyscene_played_" .. faction_key,									-- value key for savegame
					narrative.get(faction_key, name .. "_seen_value") or true,																			-- value to save
					narrative.get(faction_key, name .. "_trigger_messages") or "RealmIntroShown",														-- script message(s) on which to trigger when received
					narrative.get(faction_key, name .. "_on_issued_messages")
				);
			end;
		end;










		-----------------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------
		--	Realms of Chaos
		-----------------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------


		start_narrative_events_chaos_realm_for_faction(
			faction_key,
			-- realm_data
			{
				realm_name = "khorne",
				realm_msg_name = "Khorne",
				realm_cindyscene_short = "realm_kh_m01",
				realm_cindyscene_long = "realm_pre_kh_m01",
				cutscene_config_short = khorne_realm_intro_short_config,
				cutscene_config_long = khorne_realm_intro_long_config,
				realm_info_index = 165,
				post_realm_intro_sound_event = "Play_wh3_main_camp_narrative_chs_khorne_realm_intro_05_1"
			}
		);


		start_narrative_events_chaos_realm_for_faction(
			faction_key,
			-- realm_data
			{
				realm_name = "nurgle",
				realm_msg_name = "Nurgle",
				realm_cindyscene_short = "realm_ng_m01",
				realm_cindyscene_long = "realm_pre_ng_m01",
				cutscene_config_short = nurgle_realm_intro_short_config,
				cutscene_config_long = nurgle_realm_intro_long_config,
				realm_info_index = 166,
				post_realm_intro_sound_event = "Play_wh3_main_camp_narrative_chs_nurgle_realm_intro_05_1"
			}
		);


		start_narrative_events_chaos_realm_for_faction(
			faction_key,
			-- realm_data
			{
				realm_name = "slaanesh",
				realm_msg_name = "Slaanesh",
				realm_cindyscene_short = "realm_sl_m01",
				realm_cindyscene_long = "realm_pre_sl_m01",
				cutscene_config_short = slaanesh_realm_intro_short_config,
				cutscene_config_long = slaanesh_realm_intro_long_config,
				realm_info_index = 167,
				post_realm_intro_sound_event = "Play_wh3_main_camp_narrative_chs_slaanesh_realm_intro_05_1"
			}
		);


		start_narrative_events_chaos_realm_for_faction(
			faction_key,
			-- realm_data
			{
				realm_name = "tzeentch",
				realm_msg_name = "Tzeentch",
				realm_cindyscene_short = "realm_tz_m01",
				realm_cindyscene_long = "realm_pre_tz_m01",
				cutscene_config_short = tzeentch_realm_intro_short_config,
				cutscene_config_long = tzeentch_realm_intro_long_config,
				realm_info_index = 168,
				post_realm_intro_sound_event = "Play_wh3_main_camp_narrative_chs_tzeentch_realm_intro_05_1"
			}
		);


	end

	-- output footer
	narrative.output_chain_footer();
end;


-- Ensure that start_narrative_events_chaos_for_faction() is called when narrative system is started
narrative.add_loader(start_narrative_events_chaos_for_faction);













function start_narrative_events_chaos_realm_for_faction(faction_key, realm_data)

	local realm_name = realm_data.realm_name;
	local realm_msg_name = realm_data.realm_msg_name;


	out.narrative("");
	out.narrative("Starting narrative events for realm of " .. realm_msg_name);
	out.inc_tab("narrative");


	-----------------------------------------------------------------------------------------------------------
	-- Player Opens Realm
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chs_trigger_" .. realm_name .. "_player_enters_realm";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.generic(
				name,																																-- unique name for this narrative event
				faction_key,																														-- key of faction to which it applies
				narrative.get(faction_key, name .. "_start_messages"),																				-- script message(s) on which to start
				narrative.get(faction_key, name .. "_target_messages") or realm_msg_name .. "PlayerOpensRealm",										-- target message(s) to trigger
				narrative.get(faction_key, name .. "_cancel_messages"),																				-- script message(s) on which to cancel
				narrative.get(faction_key, name .. "_event") or "ScriptEventPlayerOpensRealm",														-- event name
				narrative.get(faction_key, name .. "_condition") or																					-- event condition
					function(context)
						return context:realm() == realm_data.realm_name and context:faction():name() == faction_key;
					end,
				narrative.get(faction_key, name .. "_immediate") or true																			-- trigger immediately or via intervention
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Start must-trigger intervention to ride over any open event panels
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chs_event_" .. realm_name .. "_player_enters_realm_must_trigger_intervention";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.intervention(
				name,																																-- unique name for this narrative event
				faction_key,																														-- key of faction to which it applies
				narrative.get(faction_key, name .. "_config_callback") or																			-- opt intervention config callback
					function(inv)
						inv:set_must_trigger(true, true);
						inv:set_wait_for_fullscreen_panel_dismissed(false);
					end,
				narrative.get(faction_key, name .. "_trigger_callback") or																			-- opt intervention config callback
					function(triggering_message, allow_issue_completed_callback)

						-- prevent intervention/narrative event from completing immediately
						allow_issue_completed_callback(false);

						-- fade to black
						cm:fade_scene(0, 0.5);

						-- we're trying to track down a bug with a 
						local fade_back_interval = 1.5;
						if core:is_tweaker_set("SCRIPTED_TWEAKER_11") then
							fade_back_interval = 11.5;
						end;

						-- fade to picture after a short delay, and allow intervention/narrative event to complete
						cm:callback(
							function()
								allow_issue_completed_callback(true);
								cm:fade_scene(1, 1);
							end,
							fade_back_interval
						);
						
					end,
				narrative.get(faction_key, name .. "_trigger_messages") or realm_msg_name .. "PlayerOpensRealm",									-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or "ShowRealmIntro" .. realm_msg_name										-- script message(s) to issue when movie played
			);
		end;
	end;

	
	-----------------------------------------------------------------------------------------------------------
	-- Which cindyscene to play
	-----------------------------------------------------------------------------------------------------------

	do
		-- tweaker setting to force short realm intro
		if core:is_tweaker_set("SCRIPTED_TWEAKER_07") then
			cm:set_saved_value("any_realm_cindyscene_played_" .. faction_key, true);
		end;
		
		local name = "chs_query_" .. realm_name .. "_realm_which_cindyscene";
		
		if not narrative.get(faction_key, name .. "_block") then
			narrative_queries.savegame_value_exists(
				name,																																-- unique name for this narrative query
				faction_key,																														-- key of faction to which it applies
				narrative.get(faction_key, name .. "_trigger_messages") or "ShowRealmIntro" .. realm_msg_name,										-- message(s) on which to trigger
				narrative.get(faction_key, name .. "_positive_messages") or {																		-- message(s) on value exists
					"ShowRealmIntro" .. realm_msg_name .. "Short", 
					"RealmIntroShown"
				},
				narrative.get(faction_key, name .. "_negative_messages") or {																		-- message(s) on value does not exist
					"ShowRealmIntro" .. realm_msg_name .. "Long", 
					"RealmIntroShown"
				},
				narrative.get(faction_key, name .. "_value_key") or "any_realm_cindyscene_played_" .. faction_key,									-- value key
				narrative.get(faction_key, name .. "_condition")																					-- condition function
			);
		end;
	end;
	

	-----------------------------------------------------------------------------------------------------------
	-- Cindyscene [LONG]
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chs_event_" .. realm_name .. "_realm_intro_long";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.cindy_cutscene(
				name,																																-- unique name for this narrative event
				faction_key,																														-- key of faction to which it applies
				narrative.get(faction_key, name .. "_cindyscene") or realm_data.realm_cindyscene_long,												-- path to cindyscene (can be nil)
				narrative.get(faction_key, name .. "_blend_in_duration") or 0,																		-- cindyscene blend in duration (can be nil)
				narrative.get(faction_key, name .. "_blend_out_duration") or 0,																		-- cindyscene blend out duration (can be nil)
				narrative.get(faction_key, name .. "_config") or realm_data.cutscene_config_long,													-- cutscene configuration/action list - this should be specified in override data, and should be a function that takes the cutscene object as a single arg
				narrative.get(faction_key, name .. "_trigger_messages") or "ShowRealmIntro" .. realm_msg_name .. "Long",							-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or realm_msg_name .. "RealmIntroFinished"									-- script message(s) to issue when movie played
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Cindyscene [SHORT]
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chs_event_" .. realm_name .. "_realm_intro_short";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.cindy_cutscene(
				name,																																-- unique name for this narrative event
				faction_key,																														-- key of faction to which it applies
				narrative.get(faction_key, name .. "_cindyscene") or realm_data.realm_cindyscene_short,												-- path to cindyscene (can be nil)
				narrative.get(faction_key, name .. "_blend_in_duration") or 0,																		-- cindyscene blend in duration (can be nil)
				narrative.get(faction_key, name .. "_blend_out_duration") or 0,																		-- cindyscene blend out duration (can be nil)
				narrative.get(faction_key, name .. "_config") or realm_data.cutscene_config_short,													-- cutscene configuration/action list - this should be specified in override data, and should be a function that takes the cutscene object as a single arg
				narrative.get(faction_key, name .. "_trigger_messages") or "ShowRealmIntro" .. realm_msg_name .. "Short",							-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or realm_msg_name .. "RealmIntroFinished"									-- script message(s) to issue when movie played
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Mark this realm intro as seen - this is queried by the realm scripts
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chs_event_" .. realm_name .. "_intro_seen";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.set_saved_value(
				name,																																-- unique name for this narrative event
				faction_key,																														-- key of faction to which it applies
				narrative.get(faction_key, name .. "_seen_key") or realm_name .. "_realm_cindyscene_played_" .. faction_key,						-- value key for savegame
				narrative.get(faction_key, name .. "_seen_value") or true,																			-- value to save
				narrative.get(faction_key, name .. "_trigger_messages") or realm_msg_name .. "RealmIntroFinished",									-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Post Realm Cindyscene Fade In
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chs_event_" .. realm_name .. "_post_realm_intro_fade_out";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.camera_fade(
				name,																																			-- unique name for narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_interval") or 0,																							-- interval to wait in s
				narrative.get(faction_key, name .. "_to_black") or true,																						-- to black
				narrative.get(faction_key, name .. "_trigger_messages") or realm_msg_name .. "RealmIntroFinished",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) on which to trigger when received
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	-- Reposition the game camera while screen is black
	-- Also play a post-realm-intro sound event
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chs_event_" .. realm_name .. "_reposition_game_camera";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.callback(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_callback") or																								-- callback to call
					function(ne, faction_key, triggering_message, allow_issue_completed_callback)
						if cm:get_local_faction_name(true) ~= faction_key then
							ne:out("Not repositioning camera as this is a multiplayer game and faction [" .. faction_key .. "] is not the local faction");
							return;
						end;

						-- Play post-realm-intro sound event
						common.trigger_soundevent(realm_data.post_realm_intro_sound_event);
						common.trigger_soundevent("Play_Movie_warhammer3_chaos_realm_intro_out_stinger");
						
						local faction = cm:get_faction(faction_key);
						local char = get_first_general_in_realm(faction, realm_name);
						if not char then
							if cm:is_multiplayer() then
								local char = cm:get_highest_ranked_general_for_faction(faction);
								if char then
									ne:out("Not found any general for faction [" .. faction_key .. "] in " .. realm_name .. " realm, repositioning camera at player's main army");
								else
									local settlement = cm:get_highest_level_settlement_for_faction(faction);
									if settlement then
										char = cm:get_garrison_commander_of_region(settlement:region());
										if char then
											ne:out("Not found any general for faction [" .. faction_key .. "] in " .. realm_name .. " realm, repositioning camera at player's main settlement");
										else
											script_error("ERROR: " .. name .. " couldn't find any general character for faction " .. faction_key .. " in " .. realm_name .. " realm in multiplayer mode, nor could we find a mobile army or a garrison commander to fall back on - how can this be? The camera will not be repositioned by the player's army");
											return;
										end;
									end;
								end;
							else
								script_error("ERROR: " .. name .. " couldn't find any general character for faction " .. faction_key .. " in " .. realm_name .. " realm - how can this be? The camera will not be repositioned by the player's army");
								return;
							end;							
						end;

						if char then
							local x, y = cm:char_display_pos(char);
							local d = 12;
							local b = 0;
							local h = 14.6;

							allow_issue_completed_callback(false);

							cm:callback(
								function()
									cm:set_camera_position(x, y, d, b, h);
									ne:out("Repositioned game camera at [" .. table.concat({x, y, d, b, h}, ", ") .. "]");
									allow_issue_completed_callback(true);
								end,
								0.5
							);
						end;						
					end,
				narrative.get(faction_key, name .. "_trigger_messages") or realm_msg_name .. "RealmIntroFinished",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Post Realm Cindyscene delay
	-----------------------------------------------------------------------------------------------------------

	-- Wait a short interval after the realm cindyscene is finished. The game camera should be black at this point.
	do
		local name = "chs_event_" .. realm_name .. "_post_realm_intro_interval";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.interval(
				name,																																			-- unique name for narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_interval") or 1,																							-- interval to wait in s
				narrative.get(faction_key, name .. "_trigger_messages") or realm_msg_name .. "RealmIntroFinished",												-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or realm_msg_name .. "FadeToPicture"													-- script message(s) on which to trigger when received
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Post Realm Cindyscene Fade In
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chs_event_" .. realm_name .. "_post_realm_intro_fade_in";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.camera_fade(
				name,																																			-- unique name for narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_interval") or 1,																							-- interval to wait in s
				narrative.get(faction_key, name .. "_to_black") or false,																						-- to black
				narrative.get(faction_key, name .. "_trigger_messages") or realm_msg_name .. "FadeToPicture",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or realm_msg_name .. "IssueHowToPlay"													-- script message(s) on which to trigger when received
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Show Realm How-To-Play
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chs_event_" .. realm_name .. "_realm_how_to_play";

		if not narrative.get(faction_key, name .. "_block") then
			local title_text_key = "event_feed_strings_text_wh3_main_event_feed_string_scripted_event_realm_entered_title";
			local primary_text_key = "event_feed_strings_text_wh3_main_event_feed_string_scripted_event_" .. realm_name .. "_realm_entered_primary_detail";
			local secondary_text_key = "event_feed_strings_text_wh3_main_event_feed_string_scripted_event_" .. realm_name .. "_realm_entered_secondary_detail";
			local is_persistent = true;		
			local index = realm_data.realm_info_index;

			narrative_events.event_message(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_title_text") or title_text_key,																			-- title text key
				narrative.get(faction_key, name .. "_primary_text") or primary_text_key,																		-- primary text key
				narrative.get(faction_key, name .. "_secondary_text") or secondary_text_key,																	-- secondary text key
				narrative.get(faction_key, name .. "_persistent") or is_persistent,																				-- is persistent
				narrative.get(faction_key, name .. "_index") or index,																							-- index
				narrative.get(faction_key, name .. "_trigger_messages") or realm_msg_name .. "IssueHowToPlay",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages") or realm_msg_name .. "HowToPlayIssued"												-- script message(s) to trigger when issued
			);
		end;
	end;
	

	-----------------------------------------------------------------------------------------------------------
	-- Trigger the survival battle mission (in external scripts)
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "chs_event_" .. realm_name .. "_win_set_piece_battle";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_events.callback(
				name,																																			-- unique name for this narrative event
				faction_key,																																	-- key of faction to which it applies
				narrative.get(faction_key, name .. "_callback") or																								-- callback to call
					function(ne, faction_key, triggering_message, allow_issue_completed_callback)
						-- Notify external scripts
						core:trigger_custom_event(
							"ScriptEventRealmIntroCompleted", 
							{
								realm = realm_name,
								faction = cm:get_faction(faction_key)
							}
						);
						
						-- For the Khorne and Nurgle realms we issue a mission instead of the final battle mission
						if realm_name == "khorne" then
							issue_khorne_realm_mission(faction_key, true);
						elseif realm_name == "nurgle" then
							issue_nurgle_realm_mission(faction_key, true);
						else
							trigger_realm_final_battle(faction_key, realm_name);
						end;
					end,
				narrative.get(faction_key, name .. "_trigger_messages") or realm_msg_name .. "HowToPlayIssued",													-- script message(s) on which to trigger when received
				narrative.get(faction_key, name .. "_on_issued_messages")																						-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
			);
		end;
	end;

	out.dec_tab("narrative");
end;

