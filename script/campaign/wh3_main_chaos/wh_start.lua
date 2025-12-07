
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	CAMPAIGN SCRIPT
--	This file gets loaded before any of the faction scripts
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

--- if the campaign type is set to either of these, then use the Realms gameplay
local realm_gameplay_campaign_types =
{
	MP_NORMAL = true,
	SP_NORMAL = true
}

local sp_gameplay_campaign_type = "SP_NORMAL_NO_ROC"
local champions_participant_factions = {
	"wh3_dlc20_chs_valkia",
	"wh3_dlc20_chs_vilitch",
	"wh3_dlc20_chs_azazel",
	"wh3_dlc20_chs_festus"
}

local chd_participant_factions = {
	"wh3_dlc23_chd_astragoth",
	"wh3_dlc23_chd_legion_of_azgorh",
	"wh3_dlc23_chd_zhatan"
}

local tod_participant_factions = {
	"wh_main_emp_wissenland",
	"wh3_dlc25_nur_tamurkhan",
	"wh3_dlc25_dwf_malakai"
}
cm:add_pre_first_tick_callback(
	function()
		out("**** Campaign Type is: "..cm:model():campaign_type())

		initiative_unlock_listeners();
		faction_initiatives_unlocker:initiatives_unlocker_listeners()
		
		load_followers();
		load_rare_items();
		item_fusing_listener();
		
		-- only load faction scripts if we have a local faction		
		if not cm:tol_campaign_key() then
			if cm:is_new_game() then
				local human_factions = cm:get_human_factions();
				
				if #human_factions > 0 then
					for i = 1, #human_factions do
						victory_objectives:generate_objectives(human_factions[i])
					end;
				else
					return false;
				end;
			end;
			
			-- If SCRIPTED_TWEAKER_21 is set then the central benchmark is disabled, allowing per-faction benchmarks to work
			if cm:is_multiplayer() or core:is_tweaker_set("SCRIPTED_TWEAKER_21") then
				cm:load_local_faction_script("_start");
			else
				-- load the faction scripts (or benchmark)
				-- loads the file in script/campaigns/<campaign_name>/factions/<faction_name>/<faction_name>_start.lua
				cm:show_benchmark_if_required(
					function()
						cm:load_local_faction_script("_start");
					end, 
					"campaign_benchmark_01"
					-- 348.7,		-- x
					-- 330.9,		-- y
					-- 10,			-- d
					-- 0,			-- b
					-- 10			-- h
				);

				if cm:is_benchmark_mode() then
					cm:force_terrain_patch_visible("wh3_main_patch_area_forge_of_souls");
					cm:force_terrain_patch_visible("wh3_main_patch_area_khorne_realm");
					cm:force_terrain_patch_visible("wh3_main_patch_area_nurgle_realm");
					cm:force_terrain_patch_visible("wh3_main_patch_area_slaanesh_realm");
					cm:force_terrain_patch_visible("wh3_main_patch_area_tzeentch_realm");
				end;
			end;
		end;
	end
);



-------------------------------------------------------
--	register functions to call when the first tick occurs
-------------------------------------------------------

cm:add_first_tick_callback_new(function() start_new_game_all_factions() end);
cm:add_first_tick_callback(function() start_game_all_factions() end);


-- Called when a new campaign game is started.
-- Put things here that need to be initialised only once, at the start 
-- of the first turn, but for all factions
-- This is run before start_game_all_factions()
function start_new_game_all_factions()
	out("start_new_game_all_factions() called");
	
	apply_default_diplomacy();
	
	-- put the camera at the player's faction leader at the start of a new game
	if not cm:tol_campaign_key() then
		local local_faction = cm:get_local_faction_name(true);
		
		if local_faction then
			cm:position_camera_at_primary_military_force(local_faction);
		end;
		
		create_starting_armies();
		initial_compass_cooldown();
	end;
	
	if campaign_ai_script then
		campaign_ai_script:kislev_background_income()
	end
end;


function initial_compass_cooldown()
	cm:set_next_winds_of_magic_compass_selection_cooldown(cm:get_faction("wh3_main_cth_the_northern_provinces"), 3);
	cm:set_next_winds_of_magic_compass_selection_cooldown(cm:get_faction("wh3_main_cth_the_western_provinces"), 4);
end


-- Called each time a game is started/loaded.
-- Put things here that need to be initialised each time the game/script is
-- loaded here. This is run after start_new_game_all_factions()
function start_game_all_factions()
	out("start_game_all_factions() called");
	
	out.inc_tab();
	
	
	-- start all scripted behaviours that should apply across all campaigns
	setup_wh_campaign();
	
	start_narrative_events();
	
	q_setup();

	
	corruption_swing:setup();
	setup_encounters_at_sea_listeners();
	-- load the campaign quest battle listners script
	set_piece_battle_abilities:initialise();
	--add_gotrek_felix_listeners();
	ogre_bounties:setup_ogre_contracts();
	setup_khorne_skulls();
	setup_ice_court_ai();
	kislev_devotion:setup_kislev_devotion();
	setup_kislev_motherland();
	recruited_unit_health:initialise()
	setup_slaanesh_devotees();
	Seductive_Influence:initialise()
	setup_daemon_cults();
	great_game_start();
	setup_boris();
	dark_authority:initialise()
	norscan_homeland:initialise()
	eye_of_the_gods:initialise()
	vassal_dilemmas:initialise()
	chaos_realm_missions:initialise()
	greater_daemons:setup_greater_daemons();
	harmony:initialise()
	caravans:initialise()
	emp_techs:initialise()
	add_tech_tree_lords_listeners()
	ancillary_item_forge:initialise()
	subjugation:initialise()
	unholy_manifestations:initialise()

	-- Chaos Dwarfs
	chaos_dwarf_labour_loss:labour_loss()
	chaos_dwarf_efficiency:set_efficiency()
	tower_of_zharr:initialise()
	hellforge:setup_listeners()
	chaos_dwarf_labour_move:setup_listeners()
	chd_labour_raid:start_listeners()
	
	-- dlc24
	mother_ostankya_features:initialise()
	matters_of_state:initialise()
	the_changeling_features:initialise()

	-- dlc25
	nur_chieftains:initialise()
	malakai_battles:initialize()
	gunnery_school:initialise()
	nurgle_plagues:initialise()
	imperial_authority:roc_temp_initialise()
	spirit_of_grungni:initialise()
	empire_state_troops:initialise()
	imperial_authority:initialise()
	gardens_of_morr:initialise()

	-- dlc26
	ogre_camps:initialise()
	tyrants_demands:initialise()
	fragments_of_sorcery:initialise()

	-- dlc27
	pre_battle_challenges:initialise()
	nor_pillaging:initialise()

	-- General
	character_unlocking:setup_legendary_hero_unlocking();
	campaign_ai_script:setup_listeners();
	grudge_cycle:initialise()
	starting_grudge_missions:initialise()
	legendary_grudges:initialise()
	
	-- Update 5.2
	add_underdeep_listeners();
	
	scripted_technology_tree:start_technology_listeners();

	CUS:initialise()

	scripted_occupation_options:initialise()

	out("==== Custom Starts ====");
	custom_starts:add_campaign_custom_start_listeners();
	
	if not cm:tol_campaign_key() then
		local campaign_type = cm:model():campaign_type()
		Bastion:great_bastion_start()

		local realm_gameplay_disabled_override = core:is_tweaker_set("SCRIPTED_TWEAKER_40") 
		local is_autorun = not cm:get_local_faction(true)

		if realm_gameplay_campaign_types[campaign_type] and not realm_gameplay_disabled_override then
			setup_realms()
		elseif cm:are_any_factions_human(champions_participant_factions) and campaign_type == sp_gameplay_campaign_type then
			setup_ursun_saved()
			champions_narrative:initialise()
		elseif cm:are_any_factions_human(chd_participant_factions) and campaign_type == sp_gameplay_campaign_type then
			chaos_dwarfs_narrative:initialise()
		elseif cm:are_any_factions_human(tod_participant_factions) and campaign_type == sp_gameplay_campaign_type then
			tod_narrative:initialise()
		end
	end;
	
	-- add corruption after the custom starts have been applied (e.g. Boris Ursus)
	if cm:is_new_game() then
		add_starting_corruption();
	end
	
	out.dec_tab();
end;

cm:add_ui_created_callback_mp_new(
	function()
		cm:set_camera_height(10);		-- ensure the camera is not in strategic view when starting - it'll get moved after this
	end
);