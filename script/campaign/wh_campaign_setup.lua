
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Custom ui listeners
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

prepend_settlement_str = "settlement:";

-- outputs click information to the Lua - UI Script tab
output_uicomponent_on_click();

-- create some campaign helper objects
infotext = get_infotext_manager();
objectives = get_objectives_manager();
uim = cm:get_campaign_ui_manager();

-- attempt to check campaign documentation if we should
if core:is_tweaker_set("CHECK_CAMPAIGN_SCRIPT_DOCGEN") and vfs.exists("script/docgen/content/campaign/docgen_campaign_parser.lua") then
	require("script.docgen.content.campaign.docgen_campaign_parser");
end;

-- require files used across every campaign
require("wh3_campaign_bonus_values");
require("wh3_campaign_tech_tree");
require("wh3_campaign_generic_incidents");
require("wh3_campaign_achievements");
require("wh2_campaign_interactive_marker_manager");
force_require("wh_campaign_experience_triggers");
force_require("wh3_campaign_magic_items");

-- we don't save override states in WH, which means that if an override is locked and
-- the game is saved, it should be unlocked when the game is loaded again
uim:set_should_save_override_state(false);

cm:set_use_cinematic_borders_for_automated_cutscenes(false);

-- this has to be run on script load as the first tick can be too late to apply
-- experience triggers and some other things post-battle
cm:add_pre_first_tick_callback(
	function()
		cm:set_script_state("SCRIPT_FAILED_THIS_SESSION", false)
		
		-- load the experience triggers
		campaign_experience_triggers:setup_experience_triggers();
	end
);

function setup_wh_campaign(generic_battle_script_path_override)
	out("setup_wh_campaign() called");
	
	out.inc_tab();
	
	-- start custom listeners for player actions
	-- these listeners usually trigger further events to notify external scripts (e.g. advice interventions) of player actions
	start_custom_listeners();
	
	-- load battle script whenever a battle is launched from this campaign (this activates advice)
	if generic_battle_script_path_override ~= false then
		add_generic_battle_script_override(generic_battle_script_path_override);
	end;

	-- monitor for Chaos razing a region, then apply Chaos corruption_monitor
	setup_chaos_raze_region_monitor();
	
	-- monitor for player confederation taking place
	start_confederation_listeners();
	
	sea_region_shroud_effect_listener();
	
	local local_faction = cm:get_local_faction_name(true);
	
	if local_faction and cm:get_faction(local_faction) then
		-- monitor for player recruiting new armies
		player_army_count_listener();
		
		-- enable movement for the player's faction if this is not a new game (just in case the player somehow saved in the middle of an intervention)
		if not cm:is_new_game() then
			cm:enable_movement_for_faction(local_faction);
		end;
	else
		out("Autorun running, not applying upkeep penalties for additional armies");
	end;
	
	-- monitor rebel armies, and give them siege equipment
	setup_rebel_army_siege_equipment_monitor();
	
	-- listen for blood pack incidents firing, then apply effects
	blood_pack_incidents_listener();
	
	-- skaven menace below army ability
	menace_below_monitor();
	
	-- open geomantic web help page when geomantic web screen opened
	--show_geomantic_web_help_page_on_screen_open();
	
	-- apply free upkeep effect bundle to any military forces that are created for quest battles (they get destroyed afterwards but can mess up the UI on the pre battle screen)
	quest_battle_free_force();
	
	-- show an event when player performs a hero action that targets ruins that are not skaven owned
	show_target_ruins_success_event_message();
	
	-- apply effect bundle when human beastmen make positive diplomatic treaty
	beastmen_positive_diplomatic_event_listener();

	---prevent factions from declaring war on vassals
	vassal_diplomacy_lock_listeners()
	
	-- track when a faction has completed technology on their turn
	track_technology_researched()

	if not cm:model():campaign_name("wh3_main_prologue") then
		add_high_corruption_dummy_effect_listeners();
		add_plague_indicator_dummy_effect_listeners();

		GeneratedConstants:generate_constants()

		-- set-up any cross-campaign quest battle listeners
		qbh:initialise()

		-- automatically upgrade settlement building level to 1 when a faction resettles (i.e. has no regions and occupies one)
		setup_faction_resettle_listener();
	end;
	
	-- AI Beastmen armies can get stuck in encampment stance attempting to
	-- replenish losses that they suffer from low army morale attrition
	-- Mitch, 04/07/16
	local faction_list = cm:model():world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		
		if not current_faction:is_human() and not current_faction:is_quest_battle_faction() and not current_faction:is_dead() then
			local culture = current_faction:culture();
			
			if culture == "wh_dlc03_bst_beastmen" and not current_faction:has_effect_bundle("wh_dlc03_low_morale_attrition_immunity") then
				cm:apply_effect_bundle("wh_dlc03_low_morale_attrition_immunity", current_faction:name(), 0);
			elseif culture == "wh_main_grn_greenskins" and not current_faction:has_effect_bundle("wh2_main_bundle_greenskin_animosity_bonus") then
				cm:apply_effect_bundle("wh2_main_bundle_greenskin_animosity_bonus", current_faction:name(), 0);
			end;
		end;
	end;
	
	-- daemon prince tint
	setup_daemon_prince_tint_listener();
	
	-- randomise the daemon prince name when under ai controlled
	if cm:is_new_game() then
		local daemon_prince_faction = cm:get_faction("wh3_main_dae_daemon_prince");
		
		if daemon_prince_faction and not daemon_prince_faction:is_human() then
			cm:randomise_character_name(daemon_prince_faction:faction_leader());
		end;

		if start_global_interventions and not cm:is_multiplayer() then
			start_global_interventions();
		end;
	end;

	start_achievement_listeners();
	
	add_debug_listeners();
	
	-- turn on settlement labels in case they were disabled at the point a save game was created
	if common.get_context_value("IsScriptLockActive(\"disable_settlement_labels\")") then
		cm:override_ui("disable_settlement_labels", false);
	end;
	
	---if a quest associated with a unique item is cancelled, give the item anyway.
	setup_cancelled_quest_listener()
	
	--Marker Manager
	if not cm:is_new_game() then
		Interactive_Marker_Manager:reconstruct_markers()
	end

	out.dec_tab();
end;










function start_custom_listeners()
	local local_faction = cm:get_local_faction_name(true);
	
	-- don't start in multiplayer or autorun mode
	if cm:is_multiplayer() or not local_faction then
		return false;
	end;
	
	local ui_root = core:get_ui_root();

	-- custom event generators
	-- these listen for events and conditions to occur and then fire custom script events when they do. Doing this greatly 
	-- reduces the amount of work that the intervention system has to do (and the amount of output it generates)
	
	core:start_custom_event_generator("PanelOpenedCampaign", function(context) return context.string == "diplomacy_dropdown" end, "ScriptEventDiplomacyPanelOpened");
	core:start_custom_event_generator("PanelClosedCampaign", function(context) return context.string == "diplomacy_dropdown" end, "ScriptEventDiplomacyPanelClosed");
	
	-- ScriptEventPreBattlePanelOpened generated by campaign manager
	core:start_custom_event_generator("PanelClosedCampaign", function(context) return context.string == "popup_pre_battle" end, "ScriptEventPreBattlePanelClosed");
	
	core:start_custom_event_generator("PanelOpenedCampaign", function(context) return context.string == "popup_battle_results" end, "ScriptEventPostBattlePanelOpened");
	core:start_custom_event_generator("PanelClosedCampaign", function(context) return context.string == "popup_battle_results" end, "ScriptEventPostBattlePanelClosed");
	
	core:start_custom_event_generator("PanelOpenedCampaign", function(context) return context.string == "move_options" end, "ScriptEventMoveOptionsPanelOpened");
	
	core:start_custom_event_generator("PanelOpenedCampaign", function(context) return context.string == "appoint_new_general" end, "ScriptEventAppointNewGeneralPanelOpened");
	
	-- diplomacy button clicked
	core:start_custom_event_generator(
		"ComponentLClickUp", 
		function(context) return UIComponent(context.component) == find_uicomponent(ui_root, "faction_buttons_docker", "button_diplomacy") end, 
		"ScriptEventPlayerOpensDiplomacyPanel"
	);
	
	-- diplomacy button shortcut used
	core:start_custom_event_generator(
		"ShortcutPressed", 
		function(context) return context.string == "show_diplomacy" end, 
		"ScriptEventPlayerOpensDiplomacyPanel"
	);
		
	-- raise lord button clicked
	core:start_custom_event_generator(
		"ComponentLClickUp", 
		function(context) return UIComponent(context.component) == find_uicomponent(ui_root, "character_panel", "raise_forces_options", "button_raise") end, 
		"ScriptEventRaiseForceButtonClicked"
	);
	
	-- player settlement comes under siege
	core:start_custom_event_generator(
		"CharacterBesiegesSettlement",
		function(context) return context:region():owning_faction():name() == local_faction end,
		"ScriptEventPlayerBesieged",
		function(context) return context:region() end
	)
	
	core:start_custom_event_generator(
		"CharacterCreated", 
		function(context) return context:character():faction():name() == local_faction end, 
		"ScriptEventPlayerFactionCharacterCreated", 
		function(context) return context:character() end
	);
	
	core:start_custom_event_generator(
		"BuildingCompleted", 
		function(context) return context:garrison_residence():faction():name() == local_faction end, 
		"ScriptEventPlayerBuildingCompleted", 
		function(context) return context:building(), context:garrison_residence() end
	);
	
	core:start_custom_event_generator(
		"GarrisonOccupiedEvent", 
		function(context) return context:character():faction():name() == local_faction end, 
		"ScriptEventPlayerCaptureSettlement", 
		function(context) return context:garrison_residence(), context:character() end
	);
	
	core:start_custom_event_generator(
		"RegionGainedDevelopmentPoint", 
		function(context) return context:region():owning_faction():name() == local_faction end, 
		"ScriptEventPlayerRegionGainedDevelopmentPoint", 
		function(context) return context:region() end
	);
		
	core:start_custom_event_generator(
		"CharacterSkillPointAvailable", 
		function(context) return context:character():faction():name() == local_faction end, 
		"ScriptEventPlayerCharacterSkillPointAvailable", 
		function(context) 
			return context:character();
		end
	);
	
	core:start_custom_event_generator(
		"CharacterFinishedMovingEvent", 
		function(context) return context:character():faction():name() == local_faction end, 
		"ScriptEventPlayerCharacterFinishedMovingEvent", 
		function(context) 
			return context:character();
		end
	);
	
	core:start_custom_event_generator(
		"PanelClosedCampaign", 
		function(context) 
			if context.string == "events" then
				-- test to see if the event_mission component is visible
				local uic = find_uicomponent(ui_root, "events", "event_mission");
				
				if uic and uic:Visible() then
					return true;
				end;
			end;
			return false
		end, 
		"ScriptEventPlayerAcceptsMission"
	);
	
	core:start_custom_event_generator(
		"RegionWindsOfMagicChanged",
		function(context) 
			local region = context:region();
			
			-- return true if the player owns the affected settlement			
			if region:owning_faction():name() == local_faction then
				out("===== RegionWindsOfMagicChanged event received and region " .. region:name() .. " is owned by " .. local_faction .. ", returning true");
				return true;
			end;
			
			-- also return true if the player has any forces in that region
			if cm:faction_has_armies_in_region(cm:get_faction(local_faction), region) then
				out("===== RegionWindsOfMagicChanged event received and " .. local_faction .. " has armies in region " .. region:name() .. ", returning true");
				return true;
			end;
			
			return false;
		end, 
		"ScriptEventPlayerRegionWindsOfMagicChanged"
	);	
	
	core:start_custom_event_generator(
		"PanelOpenedCampaign", 
		function(context) 
			if context.string == "character_panel" then
				
				local uic_settlement = find_uicomponent(ui_root, "hud_center", "button_group_settlement", "button_create_army");
				if uic_settlement and (uic_settlement:CurrentState() == "down" or uic_settlement:CurrentState() == "selected") then
					return true;
				end;
			
				-- horde army
				local uic_horde_army = find_uicomponent(ui_root, "hud_center", "button_group_army_settled", "button_create_army");
				if uic_horde_army and (uic_horde_army:CurrentState() == "down" or uic_horde_army:CurrentState() == "selected") then
					return true;
				end;
				
				return false;
			end;		
			
			return false;
		end, 
		"ScriptEventRecruitLordPanelOpened"
	);
	
	
	-- post missionsucceeded listener
	-- Fires an additional event a short while after a mission has succeeded, allowing client scripts to know when a 
	-- player mission's rewards have definitely* been received
	-- (*unsafe)
	core:add_listener(
		"post_player_missionsucceeded_listener",
		"MissionSucceeded",
		function(context)
			return context:faction():name() == local_faction;
		end,
		function(context)
			local mission_key = context:mission():mission_record_key();
		
			cm:callback(
				function()
					core:trigger_event("ScriptEventPlayerMissionSucceeded", mission_key);
				end,
				0.2
			);
		end,
		false
	);
	
	
	core:start_custom_event_generator(
		"PanelOpenedCampaign", 
		function(context) 
			if context.string == "character_panel" then
				
				local uic_settlement = find_uicomponent(ui_root, "hud_center", "button_group_settlement", "button_create_army");
				if uic_settlement and (uic_settlement:CurrentState() == "down" or uic_settlement:CurrentState() == "selected") then
					return true;
				end;
			
				-- horde army
				local uic_horde_army = find_uicomponent(ui_root, "hud_center", "button_group_army_settled", "button_create_army");
				if uic_horde_army and (uic_horde_army:CurrentState() == "down" or uic_horde_army:CurrentState() == "selected") then
					return true;
				end;
				
				return false;
			end;		
			
			return false;
		end, 
		"ScriptEventRecruitLordPanelOpened"
	);
	
	
	
	-- campaign interaction monitors
	-- these listen for the player interacting with the UI and store a flag of whether that interaction has occurred which other scripts can query
	
	-- has player closed unit exchange panel
	uim:add_campaign_panel_closed_interaction_monitor("unit_exchange_panel_closed", "unit_exchange");
	
	-- has player closed diplomacy panel
	uim:add_campaign_panel_closed_interaction_monitor("diplomacy_panel_closed", "dropdown_diplomacy");
	
	-- has player researched a technology
	uim:add_interaction_monitor("technology_researched", "ResearchStarted", function(context) return context:faction():name() == local_faction end);
	
	-- has player recruited a unit
	uim:add_interaction_monitor("unit_recruited", "RecruitmentItemIssuedByPlayer", function() return true end);
	
	-- has player constructed a building
	uim:add_interaction_monitor("building_constructed", "BuildingConstructionIssuedByPlayer", function() return true end);
	
	-- has player assigned a character to office
	uim:add_interaction_monitor("office_assigned", "CharacterAssignedToPost", function(context) return context:character():faction():name() == local_faction end);
	
	-- has player raised a force
	uim:add_interaction_monitor("force_raised", "ScriptEventRaiseForceButtonClicked");	
	
	-- has player autoresolved
	uim:add_interaction_monitor(
		"autoresolve_selected", 
		"ComponentLClickUp", 
		function(context) 
			local uic = UIComponent(context.component);
			return uic:Id() == "button_autoresolve" and uicomponent_descended_from(uic, "popup_pre_battle");
		end
	);
	
	-- bretonnian vows button clicked
	core:start_custom_event_generator(
		"ComponentLClickUp", 
		function(context) 
			return UIComponent(context.component) == find_uicomponent(ui_root, "character_details_panel", "TabGroup", "vows");
		end, 
		"ScriptEventBretonnianVowsButtonClicked"
	);
	
	-- forbidden workshop button clicked
	core:start_custom_event_generator(
		"ComponentLClickUp", 
		function(context) 
			return UIComponent(context.component) == find_uicomponent(ui_root, "faction_buttons_docker", "button_group_management", "button_ikit_workshop");
		end, 
		"ScriptEventForbiddenWorkshopButtonClicked"
	);
	
	-- forbidden worskhop panel opened
	
	core:start_custom_event_generator(
		"PanelOpenedCampaign", 
		function(context) 
			return context.string == "ikit_workshop_panel";
		end, 
		"ScriptEventIkitWorkshopPanelOpened"
	);
	
	-- elector count button clicked
	core:start_custom_event_generator(
		"ComponentLClickUp", 
		function(context) 
			return UIComponent(context.component) == find_uicomponent(ui_root, "faction_buttons_docker", "button_group_management", "button_elector_counts");
		end, 
		"ScriptEventElectorCountButtonClicked"
	);

	-- wulfharts hunter button clicked
	core:start_custom_event_generator(
		"ComponentLClickUp", 
		function(context) 
			return UIComponent(context.component) == find_uicomponent(ui_root, "faction_buttons_docker", "button_group_management", "button_hunters");
		end, 
		"ScriptEventWulfhartsHuntersButtonClicked"
	);

	-- nakai temple button clicked
	core:start_custom_event_generator(
		"ComponentLClickUp", 
		function(context) 
			return UIComponent(context.component) == find_uicomponent(ui_root, "topbar_list_parent", "nakai_temples", "button_nakai_temples");
		end, 
		"ScriptEventDotGPButtonClicked"
	);

	-- shadowy dealings panel opened
	core:start_custom_event_generator(
		"PanelOpenedCampaign", 
		function(context) 
			return context.string == "shadowy_dealings_panel";
		end, 
		"ScriptEventShadowyDealingsPanelOpened"
	);

	-- clan contracts button clicked
	core:start_custom_event_generator(
		"ComponentLClickUp", 
		function(context) 
			return UIComponent(context.component) == find_uicomponent(ui_root, "shadowy_dealings_panel", "middle_section", "clan_contracts_button");
		end, 
		"ScriptEventClanButtonClicked"
	);

	-- athel tamarha panel opened
	core:start_custom_event_generator(
		"PanelOpenedCampaign", 
		function(context) 
			return context.string == "athel_tamarha_dungeon";
		end, 
		"ScriptEventAthelTamarhaPanelOpened"
	);

	-- groms cauldron panel opened
	core:start_custom_event_generator(
		"PanelOpenedCampaign", 
		function(context) 
			return context.string == "groms_cauldron";
		end, 
		"ScriptEventGromsCauldronPanelOpened"
	);

	-- worldrootss button clicked
	core:start_custom_event_generator(
		"ComponentLClickUp", 
		function(context) 
			return UIComponent(context.component) == find_uicomponent(ui_root, "faction_buttons_docker", "button_group_management", "button_world_roots");
		end, 
		"ScriptEventWorldrootsButtonClicked"
	);

	-- technology panel opened	
	core:start_custom_event_generator(
		"PanelOpenedCampaign", 
		function(context) 
			return context.string == "button_technology";
		end, 
		"ScriptEventTechnologyPanelOpened"
	);

	-- dwarf forge panel opened	
	core:start_custom_event_generator(
		"PanelOpenedCampaign", 
		function(context) 
			return context.string == "button_mortuary_cult";
		end, 
		"ScriptEventDwarfForgePanelOpened"
	);

	-- monitor for player stances
	core:add_listener(
		"player_stance_monitor",
		"ForceAdoptsStance",
		true,
		function(context)
			local mf = context:military_force();
			local stance = tostring(context:stance_adopted());
			
			-- out("ForceAdoptsStance event triggered, stance is " .. tostring(stance) .. " [" .. mf:active_stance() .. "]");
			
			if mf:faction():name() == local_faction then				
				if stance == "1" then
					-- march
					common.set_advice_history_string_seen("march_stance");
					common.set_advice_history_string_seen("has_adopted_stance");
				elseif stance == "2" then
					-- ambush
					common.set_advice_history_string_seen("ambush_stance");
					common.set_advice_history_string_seen("has_adopted_stance");
				elseif stance == "3" then
					-- raiding
					common.set_advice_history_string_seen("raiding_stance");
					common.set_advice_history_string_seen("has_adopted_stance");
				elseif stance == "5" then
					-- mustering
					common.set_advice_history_string_seen("mustering_stance");
					-- common.set_advice_history_string_seen("has_adopted_stance");	 -- doesn't count
				elseif stance == "11" then
					-- channelling
					common.set_advice_history_string_seen("channelling_stance");
					common.set_advice_history_string_seen("has_adopted_stance");
				elseif stance == "12" then
					-- underway // beast-paths
					common.set_advice_history_string_seen("use_underway_stance");
					common.set_advice_history_string_seen("has_adopted_stance");
				elseif stance == "14" then
					-- raidin' camp
					common.set_advice_history_string_seen("raidin_camp_stance");
					common.set_advice_history_string_seen("has_adopted_stance");
				end;
			
			else
				-- fire an event if the force is raiding the player's territory
				if stance == "3" or stance == "14" then				
					if mf:has_general() then
						local char = mf:general_character();
						if char:has_region() then
							local owning_faction = char:region():owning_faction();
							if not owning_faction:is_null_interface() and owning_faction:name() == local_faction then
								core:trigger_event("ForceRaidingPlayerTerritory", mf);
							end;
						end;
					end;
				end;
			end;
		end,
		true
	);
	
	-- instruct the campaign manager to fire an event informing listeners what the player's lowest public order region is on turn start
	cm:find_lowest_public_order_region_on_turn_start(local_faction);
	
	-- get the campaign manager to send success/failure messages when hero actions are committed against the player faction
	cm:start_hero_action_listener(local_faction);
	
	-- get the campaign manager to send out a ScriptEventRegionRebels event after the FactionTurnEnd event (the RegionRebels event is sent before)
	cm:generate_region_rebels_event_for_faction(local_faction);
end;

vampiric_corruption_string = "wh3_main_corruption_vampiric";
chaos_corruption_string = "wh3_main_corruption_chaos";
skaven_corruption_string = "wh3_main_corruption_skaven";
khorne_corruption_string = "wh3_main_corruption_khorne";
nurgle_corruption_string = "wh3_main_corruption_nurgle";
tzeentch_corruption_string = "wh3_main_corruption_tzeentch";
slaanesh_corruption_string = "wh3_main_corruption_slaanesh";










--	Battle script override
--	Automatically loads a script in any battle launched from campaign. This activates advice in the battle.
function add_generic_battle_script_override(script_path_override)

	script_path_override = script_path_override or "script/battle/campaign_battle/battle_start.lua";

	-- NB: if we are in the post-battle phase (i.e. we have loaded back in to script after fighting the battle) these calls will be deferred by the
	-- campaign manager until after the battle is completed, as the custom battlefield records are saved in to the savegame and still needed in code
	cm:clear_custom_battlefields();
	cm:add_custom_battlefield(
		"generic",											-- string identifier
		0,													-- x co-ord
		0,													-- y co-ord
		5000,												-- radius around position
		false,												-- will campaign be dumped
		"",													-- loading override
		script_path_override,								-- script override
		"",													-- entire battle override
		0,													-- human alliance when battle override
		false,												-- launch battle immediately
		true,												-- is land battle (only for launch battle immediately)
		false												-- force application of autoresolver result
	);
end;


function remove_generic_battle_script_override()
	cm:remove_custom_battlefield("generic");
end;













-- apply Chaos corruption via an effect bundle to a region that is razed by an army belonging to Chaos
function setup_chaos_raze_region_monitor()
	core:add_listener(
		"chaos_raze_region_monitor",
		"CharacterRazedSettlement",
		function(context) return context:character():faction():subculture() == "wh_main_sc_chs_chaos" end,
		function(context)
			local char = context:character();			
			if char:has_region() then
				local region = char:region():name();				
				cm:apply_effect_bundle_to_region("wh_main_bundle_region_chaos_corruption", region, 5);
			else
				script_error("ERROR: chaos_raze_region_monitor listener triggered but character does not have a valid region - how can this be?");
			end;
		end,
		true
	);
end;














-- restrict confederation for duration of penalty
function start_confederation_listeners()
	core:add_listener(
		"confederation_listener",
		"FactionJoinsConfederation",
		true,
		function(context)
			local faction = context:confederation();
			local faction_name = faction:name();
			local faction_culture = faction:culture();
			local faction_subculture = faction:subculture();
			local faction_human = faction:is_human();
			local confederation_timeout = 5;
			
			local not_limited_confederation_factions = {
				--cultures or subcultures which are not limited when the player
				wh_dlc03_bst_beastmen = true,
				wh_dlc05_wef_wood_elves = true,
				wh_main_brt_bretonnia = true,
				wh_dlc08_sc_nor_norsca = true,
				wh_main_sc_grn_greenskins = true,
				wh3_main_sc_ksl_kislev = true,
				
				--Specific factions within a subculture that are limited
				wh2_dlc14_brt_chevaliers_de_lyonesse = false,
			}
			
			-- excludes Wood Elves, Beastmen, Norsca, Greenskins, Bretonnia (excluding Chevs de Leonesse), Kislev - they can confederate as often as they like but only if they aren't AI
			if faction_human == false or ((not_limited_confederation_factions[faction_subculture] ~= true and not_limited_confederation_factions[faction_culture] ~= true) or
			not_limited_confederation_factions[faction_name] == false) then
				if faction_human == false then
					confederation_timeout = 10;
				end

				out("Restricting confederation between [faction:" .. faction_name .. "] and [subculture:" .. faction_subculture .. "]");
				cm:force_diplomacy("faction:" .. faction_name, "subculture:" .. faction_subculture, "form confederation", false, true, false);
				cm:add_turn_countdown_event(faction_name, confederation_timeout, "ScriptEventConfederationExpired", faction_name);
			end
			
			local source_faction = context:faction();
			local source_faction_name = source_faction:name();
			
			-- remove deathhag after confederating/being confedrated with cult of pleasure
			if source_faction:culture() == "wh2_main_def_dark_elves" and faction_name == "wh2_main_def_cult_of_pleasure" then
				local char_list = faction:character_list();
				
				for i = 0, char_list:num_items() - 1 do
					local current_char = char_list:item_at(i);
					
					if current_char:has_skill("wh2_main_skill_all_dummy_agent_actions_def_death_hag") then
						cm:kill_character(current_char:command_queue_index(), true);
					end
				end
			elseif faction_culture == "wh2_main_def_dark_elves" and source_faction_name == "wh2_main_def_cult_of_pleasure" then
				local char_list = faction:character_list();
				
				for i = 0, char_list:num_items() - 1 do
					local current_char = char_list:item_at(i);
					
					if current_char:has_skill("wh2_main_skill_all_dummy_agent_actions_def_death_hag_chs") then
						cm:kill_character(current_char:command_queue_index(), true);
					end
				end
			elseif faction_name == "wh2_dlc13_lzd_spirits_of_the_jungle" then
				local defender_faction = cm:get_faction("wh2_dlc13_lzd_defenders_of_the_great_plan");
				
				cm:disable_event_feed_events(true, "", "wh_event_subcategory_diplomacy_treaty_broken", "");
				cm:disable_event_feed_events(true, "", "", "diplomacy_treaty_negotiated_vassal");

				local function handover_nakai_region()
					local nakai_faction = cm:get_faction("wh2_dlc13_lzd_spirits_of_the_jungle");
					local faction_regions = nakai_faction:region_list();
					
					for i = 0, faction_regions:num_items() - 1 do
						local region = faction_regions:item_at(i);
						cm:transfer_region_to_faction(region:name(), "wh2_dlc13_lzd_defenders_of_the_great_plan");
						nakai_temples:create_region_temple(region);
					end
				end
				
				if defender_faction then
					if defender_faction:is_dead() and faction:has_home_region() then
						local home_region = faction:home_region():name();

						local x, y = cm:find_valid_spawn_location_for_character_from_settlement(
							"wh2_dlc13_lzd_defenders_of_the_great_plan",
							home_region,
							false,
							true
						);

						cm:create_force(
							"wh2_dlc13_lzd_defenders_of_the_great_plan",
							"wh2_main_lzd_inf_skink_cohort_0",
							home_region,
							x, y,
							true,
							function(char_cqi, force_cqi)
								handover_nakai_region();
								cm:kill_character(char_cqi, true);
							end
						);
					else
						handover_nakai_region();
					end
					
					if defender_faction:is_vassal() == false then
						cm:force_make_vassal("wh2_dlc13_lzd_spirits_of_the_jungle", "wh2_dlc13_lzd_defenders_of_the_great_plan");
						cm:force_diplomacy("faction:wh2_dlc13_lzd_defenders_of_the_great_plan", "all", "all", false, false, false);
						cm:force_diplomacy("faction:wh2_dlc13_lzd_spirits_of_the_jungle", "faction:wh2_dlc13_lzd_defenders_of_the_great_plan", "war", false, false, true);
						cm:force_diplomacy("faction:wh2_dlc13_lzd_spirits_of_the_jungle", "faction:wh2_dlc13_lzd_defenders_of_the_great_plan", "break vassal", false, false, true);
						cm:force_diplomacy("faction:wh2_dlc13_lzd_defenders_of_the_great_plan", "all", "war", false, true, false);
						cm:force_diplomacy("faction:wh2_dlc13_lzd_defenders_of_the_great_plan", "all", "peace", false, true, false);
					end
				end
	
				cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_diplomacy_treaty_broken", "") end, 1);
				cm:callback(function() cm:disable_event_feed_events(false, "", "","diplomacy_treaty_negotiated_vassal") end, 1);
			elseif source_faction_name == "wh2_dlc13_lzd_spirits_of_the_jungle" then
				cm:disable_event_feed_events(true, "", "wh_event_subcategory_diplomacy_treaty_broken", "");
				cm:disable_event_feed_events(true, "", "", "diplomacy_treaty_negotiated_vassal");

				cm:force_confederation(faction_name, "wh2_dlc13_lzd_defenders_of_the_great_plan");

				cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_diplomacy_treaty_broken", "") end, 1);
				cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_treaty_negotiated_vassal") end, 1);
			end
		end,
		true
	);
	
	core:add_listener(
		"confederation_expired",
		"ScriptEventConfederationExpired",
		true,
		function(context)
			local faction_name = context.string;
			local faction = cm:get_faction(faction_name);
			local subculture = faction:subculture();
			
			out("Unrestricting confederation between [faction:" .. faction_name .. "] and [subculture: " .. subculture .. "]");
			cm:force_diplomacy("faction:" .. faction_name, "subculture:" .. subculture, "form confederation", true, true, false);

			---hack fix to stop this re-enabling confederation when it needs to stay disabled
			---please let's make this more robust!
			if subculture == "wh2_main_sc_hef_high_elves" then
				local grom_faction = cm:get_faction("wh2_dlc15_grn_broken_axe")
				if grom_faction ~= false and grom_faction:is_human() then
					cm:force_diplomacy("subculture:wh2_main_sc_hef_high_elves","faction:wh2_main_hef_yvresse","form confederation", false, true, false);
				end
			end
		end,
		true
	);
end;


---Listen for creation/breakage of vassal agreements and prevent people from declaring war on player's vassals directly.
--- Also force discovery of vassal masters upon meeting the vassal so that the AI always has the option to declare war on the master
function vassal_diplomacy_lock_listeners()

	if cm:is_new_game() then 
		cm:set_saved_value("human_vassals", {})
	end

	core:add_listener(
		"FactionBecomesVassalDiplomacyLock",
		"FactionBecomesVassal",
		true,
		function(context)
			local vassal = context:vassal()
			local master = vassal:master()

			--- only lock war declaration against player vassals to minimise knock-ons
			if master:is_human() then
				disable_wars_against_human_vassal(vassal:name(), true)
			end
	
			--loop through factions the vassal knows and introduce them to the master
			local factions_met = vassal:factions_met()
			local master_key = master:name()

			if not factions_met:is_empty() then
				for _, met_faction in model_pairs(factions_met) do
					local met_faction_key = met_faction:name()
					if not met_faction_key == master_key then
						cm:make_diplomacy_available(met_faction_key, master_key)
					end
				end
			end
		end,
		true
	);

	core:add_listener(
		"NegativeDiplomaticEventVassalageBroken",
		"NegativeDiplomaticEvent",
		function(context)
			return context:was_vassalage()
		end,
		function(context)
			local vassal = context:recipient()

			if context:proposer_was_vassal()then
				 vassal = context:proposer()
			end

			local vassal_key = vassal:name()
			local human_vassals = cm:get_saved_value("human_vassals")

			if human_vassals and human_vassals[vassal_key] then
				disable_wars_against_human_vassal(vassal_key, false)
			end
		end,
		true
	);

	core:add_listener(
		"FactionEncountersOtherFactionIntroduceMaster",
		"FactionEncountersOtherFaction",
		function(context)
			return context:other_faction():is_vassal()
		end,
		function(context)
			local faction = context:faction():name()
			local other_faction_master = context:other_faction():master():name()
			
			if faction ~= other_faction_master then
				cm:make_diplomacy_available(faction, other_faction_master)
			end
		end,
		true
	);

	---check at world start round just in case a faction has escaped vassalage (e.g. because master died) but hasn't been picked up by other listener
	core:add_listener(
		"WorldStartRoundVassalCheck",
		"WorldStartRound",
		true,
		function(context)
			local human_vassals = cm:get_saved_value("human_vassals")
			if human_vassals then
				for key, is_vassal in pairs(human_vassals) do
					if not cm:get_faction(key):is_vassal() then
						out.design("Faction in the human vassals register is no longer a vassal, disabling diplomatic restrictions")
						disable_wars_against_human_vassal(key, false)
					end
				end
			end
		end,
		true
	);
end


--- disables declarations of war against a specific faction and adds it to the register of human vassals
function disable_wars_against_human_vassal(faction_key, is_disable)
	for _, faction in model_pairs(cm:model():world():faction_list()) do
		local current_faction_key = faction:name()
		
		if current_faction_key ~= faction_key and not faction:is_human() then
			cm:force_diplomacy("faction:" .. current_faction_key, "faction:" .. faction_key, "war", not is_disable, true)
		end
	end

	local human_vassals = cm:get_saved_value("human_vassals")
	
	if is_disable then 
		human_vassals[faction_key] = true
	else
		human_vassals[faction_key] = nil
	end

	cm:set_saved_value("human_vassals", human_vassals)
end

-- increase upkeep for each additional army the player recruits or obtains via confederation
function player_army_count_listener()
	
	local human_factions = cm:get_human_factions();
	
	for i = 1, #human_factions do
		local human_faction_interface = cm:get_faction(human_factions[i])
		if upkeep_penalty_condition(human_faction_interface) then
			apply_upkeep_penalty(human_faction_interface)
		end
	end

	-- apply the effect bundles every time the player turn starts
	core:add_listener(
		"player_army_turn_start_listener",
		"ScriptEventHumanFactionTurnStart",
		function(context)
			return upkeep_penalty_condition(context:faction());
		end,
		function(context)
			apply_upkeep_penalty(context:faction());
		end,
		true
	);

	-- apply the effect bundles every time the player creates a new force
	core:add_listener(
		"player_army_created_listener",
		"MilitaryForceCreated",
		function(context)
			return upkeep_penalty_condition(context:military_force_created():faction());
		end,
		function(context)
			apply_upkeep_penalty(context:military_force_created():faction());
		end,
		true
	);
	
	-- apply the effect bundles every time the player confederates
	core:add_listener(
		"confederation_player_army_count_listener",
		"FactionJoinsConfederation",
		function(context)
			return upkeep_penalty_condition(context:confederation());
		end,
		function(context)
			apply_upkeep_penalty(context:confederation());
		end,
		true
	);
	
	core:add_listener(
		"disband_player_army_count",
		"UnitDisbanded",
		function(context)
			local unit = context:unit();
			
			return unit:has_unit_commander() and upkeep_penalty_condition(unit:faction());
		end,
		function(context)
			local faction = context:unit():faction();

			cm:callback(function()
				apply_upkeep_penalty(faction);
			end, 0.5)
		end,
		true
	);
end

function upkeep_penalty_condition(faction)
	return faction:is_human() and cm:faction_has_campaign_feature(faction:name(), "additional_army_upkeep")
end;

local leader_subtype_upkeep_exclusions = {
	wh2_main_def_black_ark = true,
	wh2_pro08_neu_gotrek = true,
	wh2_main_def_black_ark_blessed_dread = true,
};

local forcetype_upkeep_exclusions = {
	SEA_LOCKED_HORDE = true,
	DISCIPLE_ARMY = true,
	OGRE_CAMP = true,
	CARAVAN = true,
	CONVOY = true,
	SUPPORT_ARMY = true,
};

-- These are armies we consider 'non typical' and which shouldn't be counter when querying how many active armies a faction has.
non_standard_army_types = {
	OGRE_CAMP = true,
	CARAVAN = true,
	CONVOY = true,
};

-- loop through the player's armys and apply
function apply_upkeep_penalty(faction)
	local difficulty = cm:model():combined_difficulty_level();
	local upkeep_penalty_effect_bundle_key = "wh3_main_bundle_force_additional_army_upkeep";
	
	local effect_bundle = cm:create_new_custom_effect_bundle(upkeep_penalty_effect_bundle_key);
	effect_bundle:set_duration(0);
	local upkeep_value = 1 -- easy
	if cm:model():campaign_name_key() == "wh3_main_chaos" then
		if difficulty == 0 then
			upkeep_value = 1 -- normal
		elseif difficulty == -1 then
			upkeep_value = 2 -- hard
		elseif difficulty == -2 then
			upkeep_value = 4 -- very hard
		elseif difficulty == -3 then
			upkeep_value = 4 -- legendary
		end;
	else
		-- Non-chaos campaigns (Immortal Empires)
		if difficulty == 0 then
			upkeep_value = 1 -- normal
		elseif difficulty == -1 then
			upkeep_value = 2 -- hard
		elseif difficulty == -2 then
			upkeep_value = 4 -- very hard
		elseif difficulty == -3 then
			upkeep_value = 4 -- legendary
		end;
	end
	
	effect_bundle:add_effect("wh_main_effect_force_all_campaign_upkeep_hidden", "force_to_force_own_factionwide", upkeep_value);
	common.set_context_value("supply_lines_upkeep_value", upkeep_value)
	
	local mf_list = faction:military_force_list();
	local army_list = {};
	
	for i = 0, mf_list:num_items() - 1 do
		local current_mf = mf_list:item_at(i);
		local force_type = current_mf:force_type():key()

		if current_mf:has_effect_bundle(upkeep_penalty_effect_bundle_key) then
			cm:remove_effect_bundle_from_force(upkeep_penalty_effect_bundle_key, current_mf:command_queue_index());
		end
		
		if not current_mf:is_armed_citizenry() and current_mf:has_general() and not current_mf:is_set_piece_battle_army() and not forcetype_upkeep_exclusions[force_type] and leader_subtype_upkeep_exclusions[current_mf:general_character():character_subtype_key()] == nil then
			table.insert(army_list, current_mf);
		end
	end
	
	-- if there is more than one army, apply the effect bundle to the second army onwards
	if #army_list > 1 then
		for i = 2, #army_list do
			local current_mf = army_list[i];
			
			if not current_mf:has_effect_bundle(upkeep_penalty_effect_bundle_key) then
				cm:apply_custom_effect_bundle_to_force(effect_bundle, current_mf);
			end
		end
	end
end













-- because rebels and rogue armies do not get siege equipment via the cultural trait system, we have to add them to the force manually
-- to only suitable way to determine which siege equipment to apply to which force is to perform a search on the unit key :(
function setup_rebel_army_siege_equipment_monitor()	
	core:add_listener(
		"rebel_army_monitor",
		"FactionTurnStart",
		function(context)
			local faction = context:faction();
			
			return faction:is_rebel() or faction:culture() == "wh2_main_rogue";
		end,
		function(context)
			local char_list = context:faction():character_list();
			for i = 0, char_list:num_items() - 1 do
				current_char = char_list:item_at(i);
				if current_char:has_military_force() then
					local cqi = current_char:military_force():command_queue_index();
					local unit_key = current_char:military_force():unit_list():item_at(0):unit_key();
					determine_siege_equipment_bundle(cqi, unit_key)
				end;
			end;
		end,
		true
	);
end;

function determine_siege_equipment_bundle(cqi, unit_key)
	if string.find(unit_key, "_emp_") then
		cm:apply_effect_bundle_to_force("wh_main_bundle_force_siege_equipment_emp", cqi, 0);
	elseif string.find(unit_key, "_dwf_") then
		cm:apply_effect_bundle_to_force("wh_main_bundle_force_siege_equipment_dwf", cqi, 0);
	elseif string.find(unit_key, "_brt_") then
		cm:apply_effect_bundle_to_force("wh_main_bundle_force_siege_equipment_brt", cqi, 0);
	elseif string.find(unit_key, "_grn_") then
		cm:apply_effect_bundle_to_force("wh_main_bundle_force_siege_equipment_grn", cqi, 0);
	elseif string.find(unit_key, "_vmp_") then
		cm:apply_effect_bundle_to_force("wh_main_bundle_force_siege_equipment_vmp", cqi, 0);
	elseif string.find(unit_key, "_chs_") then
		cm:apply_effect_bundle_to_force("wh_main_bundle_force_siege_equipment_chs", cqi, 0);
	elseif string.find(unit_key, "_bst_") then
		cm:apply_effect_bundle_to_force("wh_dlc03_bundle_force_siege_equipment_bst", cqi, 0);
	elseif string.find(unit_key, "_wef_") then
		cm:apply_effect_bundle_to_force("wh_dlc05_bundle_force_siege_equipment_wef", cqi, 0);
	elseif string.find(unit_key, "_nor_") then
		cm:apply_effect_bundle_to_force("wh_dlc08_bundle_force_siege_equipment_nor", cqi, 0);
	elseif string.find(unit_key, "_hef_") then
		cm:apply_effect_bundle_to_force("wh2_main_bundle_force_siege_equipment_hef", cqi, 0);
	elseif string.find(unit_key, "_def_") then
		cm:apply_effect_bundle_to_force("wh2_main_bundle_force_siege_equipment_def", cqi, 0);
	elseif string.find(unit_key, "_lzd_") then
		cm:apply_effect_bundle_to_force("wh2_main_bundle_force_siege_equipment_lzd", cqi, 0);
	elseif string.find(unit_key, "_skv_") then
		cm:apply_effect_bundle_to_force("wh2_main_bundle_force_siege_equipment_skv", cqi, 0);
	elseif string.find(unit_key, "_tmb_") then
		cm:apply_effect_bundle_to_force("wh2_dlc09_bundle_force_siege_equipment_tmb", cqi, 0);
	elseif string.find(unit_key, "_cst_") then
		cm:apply_effect_bundle_to_force("wh2_dlc11_bundle_force_siege_equipment_cst", cqi, 0);
	elseif string.find(unit_key, "_dae_") then
		cm:apply_effect_bundle_to_force("wh3_main_bundle_force_siege_equipment_dae", cqi, 0);
	elseif string.find(unit_key, "_cth_") then
		cm:apply_effect_bundle_to_force("wh3_main_bundle_force_siege_equipment_cth", cqi, 0);
	elseif string.find(unit_key, "_ksl_") then
		cm:apply_effect_bundle_to_force("wh3_main_bundle_force_siege_equipment_ksl", cqi, 0);
	elseif string.find(unit_key, "_kho_") then
		cm:apply_effect_bundle_to_force("wh3_main_bundle_force_siege_equipment_kho", cqi, 0);
	elseif string.find(unit_key, "_nur_") then
		cm:apply_effect_bundle_to_force("wh3_main_bundle_force_siege_equipment_nur", cqi, 0);
	elseif string.find(unit_key, "_sla_") then
		cm:apply_effect_bundle_to_force("wh3_main_bundle_force_siege_equipment_sla", cqi, 0);
	elseif string.find(unit_key, "_tze_") then
		cm:apply_effect_bundle_to_force("wh3_main_bundle_force_siege_equipment_tze", cqi, 0);
	elseif string.find(unit_key, "_ogr_") then
		-- do nothing, ogres do not have siege equipment
	elseif string.find(unit_key, "_chd_") then
		cm:apply_effect_bundle_to_force("wh3_dlc23_bundle_force_siege_equipment_chd", cqi, 0);
	else
		script_error("ERROR: determine_siege_equipment_bundle() called but cannot find a suitable effect bundle to apply to rebel/rogue army unit with key [" .. unit_key .. "]");
	end;
end;







function blood_pack_incidents_listener()
	if cm:is_dlc_flag_enabled_by_everyone("TW_WH3_BLOODPACK") then
		local incidents = {
			{incident = "wh_dlc02_incident_all_charge_carnage", payload = "wh_dlc02_payload_all_charge_carnage"},
			{incident = "wh_dlc02_incident_all_magic_carnage", payload = "wh_dlc02_payload_all_magic_carnage"},
			{incident = "wh_dlc02_incident_all_weapon_carnage", payload = "wh_dlc02_payload_all_weapon_carnage"}
		}
		
		core:add_listener(
			"trigger_blood_event",
			"WorldStartRound",
			function()
				return cm:model():turn_number() >= 10 and cm:random_number(100) <= 10 and not cm:get_saved_value("global_blood_cooldown")
			end,
			function()
				local chosen_incident = incidents[cm:random_number(#incidents)]
				local incident_key = chosen_incident.incident
				local payload_key = chosen_incident.payload
				
				if cm:get_saved_value(incident_key) then
					return
				end
				
				cm:set_saved_value(incident_key, true)
				cm:set_saved_value("global_blood_cooldown", true)

				cm:add_round_turn_countdown_event(30, "ScriptEventBloodEventExpires", incident_key)
				cm:add_round_turn_countdown_event(15, "ScriptEventBloodEventExpires", "global_blood_cooldown")
				
				local human_factions = cm:get_human_factions()
				
				for i = 1, #human_factions do
					cm:trigger_incident(human_factions[i], incident_key)
				end

				local faction_list = cm:model():world():faction_list()
				
				for i = 0, faction_list:num_items() - 1 do
					local faction = faction_list:item_at(i)
					
					if not faction:is_human() and not faction:is_dead() then
						local custom_payload = cm:create_payload()
						custom_payload:components_from_record(payload_key, faction, faction)
						cm:apply_payload(custom_payload, faction)
					end
				end
			end,
			true
		)
		
		core:add_listener(
			"blood_event_expires",
			"ScriptEventBloodEventExpires",
			true,
			function(context)
				cm:set_saved_value(context.string, false)
			end,
			true
		)
		
	end
end
	
function show_how_to_play_event(faction_name, end_callback, delay)
	
	if end_callback and not is_function(end_callback) then
		script_error("ERROR: show_how_to_play_event() called but supplied end callback [" .. tostring(end_callback) .. "] is not a function");
		return false;
	end;
	
	if delay and not is_number(delay) then
		script_error("ERROR: show_how_to_play_event() called but supplied end callback delay [" .. tostring(delay) .. "] is not a number");
		return false;
	end;
	
	if faction_name then
		if not is_string(faction_name) then
			script_error("ERROR: show_how_to_play_event() called but supplied faction name [" .. tostring(faction_name) .. "] is not a string");
			return false;
		end;
		
		local title = "event_feed_strings_text_wh2_scripted_event_how_they_play_title";
		local primary_detail = "factions_screen_name_" .. faction_name;
		local secondary_detail = "";
		local pic = nil;
		
		
		if faction_name == "wh_main_grn_greenskins" then
			secondary_detail = "event_feed_strings_text_wh_main_event_feed_string_scripted_event_intro_greenskins_secondary_detail";
			pic = 593;
		elseif faction_name == "wh2_dlc11_vmp_the_barrow_legion" or faction_name == "wh3_main_vmp_caravan_of_blue_roses" then
			secondary_detail = "event_feed_strings_text_wh_main_event_feed_string_scripted_event_intro_vampires_secondary_detail";
			pic = 594;
		elseif faction_name == "wh_main_vmp_vampire_counts" then
			secondary_detail = "event_feed_strings_text_wh_main_event_feed_string_scripted_event_intro_drakenhof_secondary_detail";
			pic = 594;
		elseif faction_name == "wh_main_dwf_dwarfs" or faction_name == "wh3_main_dwf_the_ancestral_throng" then
			secondary_detail = "event_feed_strings_text_wh_main_event_feed_string_scripted_event_intro_dwarfs_secondary_detail";
			pic = 592;
		elseif faction_name == "wh_main_dwf_karak_kadrin" then
			secondary_detail = "event_feed_strings_text_wh_main_event_feed_string_scripted_event_intro_dwarfs_secondary_detail";
			pic = 592;
		elseif faction_name == "wh3_dlc25_dwf_malakai" then
			title = "event_feed_strings_text_wh3_scripted_event_path_to_victory_title";
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_malakai_secondary_detail";
			pic = 592;
		elseif faction_name == "wh_main_chs_chaos" or faction_name == "wh3_dlc20_chs_kholek" or faction_name == "wh3_dlc20_chs_sigvald" or faction_name == "wh3_main_chs_shadow_legion" then
			secondary_detail = "event_feed_strings_text_wh_main_event_feed_string_scripted_event_intro_warriors_of_chaos_secondary_detail";
			pic = 595;
		
		------------------------
		-- Empire
		------------------------
			-- Karl Franz
		elseif faction_name == "wh_main_emp_empire" then
			title = "event_feed_strings_text_wh3_scripted_event_path_to_victory_title";
			secondary_detail = "event_feed_strings_text_wh_main_event_feed_string_scripted_event_intro_empire_karl_franz_secondary_detail";
			pic = 591;
			-- Balthasar Gelt
		elseif faction_name == "wh2_dlc13_emp_golden_order" then
			title = "event_feed_strings_text_wh3_scripted_event_path_to_victory_title";
			secondary_detail = "event_feed_strings_text_wh_main_event_feed_string_scripted_event_intro_empire_balthasar_gelt_secondary_detail";
			pic = 591;
			-- Volkmar the Grim
		elseif faction_name == "wh3_main_emp_cult_of_sigmar" then
			secondary_detail = "event_feed_strings_text_wh_main_event_feed_string_scripted_event_intro_empire_volkmar_the_grim_secondary_detail";
			pic = 591;
		-- Markus Wulfhart
		elseif faction_name == "wh2_dlc13_emp_the_huntmarshals_expedition" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_huntsmarshals_expedition_secondary_detail";
			pic = 591;
		elseif faction_name == "wh_main_emp_wissenland" then
			title = "event_feed_strings_text_wh3_scripted_event_path_to_victory_title";
			if cm:model():campaign_name_key() == "wh3_main_chaos" then
				secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_wissenland_secondary_detail_roc";
			else
				secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_wissenland_secondary_detail_ie";
			end
			pic = 591;
		--
		-- WH1 DLC
		--
		elseif faction_name == "wh_main_grn_orcs_of_the_bloody_hand" then
			secondary_detail = "event_feed_strings_text_wh_dlc06_event_feed_string_scripted_event_intro_wurrzag_secondary_detail";
			pic = 593;
		elseif faction_name == "wh_main_dwf_karak_izor" then
			secondary_detail = "event_feed_strings_text_wh_dlc06_event_feed_string_scripted_event_intro_belegar_secondary_detail";
			pic = 602;
		elseif faction_name == "wh_main_grn_crooked_moon" then
			secondary_detail = "event_feed_strings_text_wh_dlc06_event_feed_string_scripted_event_intro_skarsnik_secondary_detail";
			pic = 603;
		elseif faction_name == "wh_dlc03_bst_beastmen" then
			secondary_detail = "event_feed_strings_text_wh_main_event_feed_string_scripted_event_intro_beastmen_secondary_detail";
			pic = 596;
		elseif faction_name == "wh2_dlc17_bst_malagor" then
			secondary_detail = "event_feed_strings_text_wh_main_event_feed_string_scripted_event_intro_beastmen_secondary_detail";
			pic = 596;
		elseif faction_name == "wh_dlc05_bst_morghur_herd" then
			secondary_detail = "event_feed_strings_text_wh_main_event_feed_string_scripted_event_intro_beastmen_secondary_detail";
			pic = 596;
		elseif faction_name == "wh2_dlc17_bst_taurox" then
			secondary_detail = "event_feed_strings_text_wh2_dlc17_event_feed_string_scripted_event_intro_beastmen_taurox_secondary_detail";
			pic = 596;
		------------------------
		-- DLC05 - Wood Elves
		------------------------ 	
		elseif faction_name == "wh_dlc05_wef_wood_elves" then
			secondary_detail = "event_feed_strings_text_wh_dlc05_event_feed_string_scripted_event_intro_orion_secondary_detail";
			pic = 605;
		elseif faction_name == "wh_dlc05_wef_argwylon" then
			secondary_detail = "event_feed_strings_text_wh_dlc05_event_feed_string_scripted_event_intro_argwylon_secondary_detail";
			pic = 605;
		elseif faction_name == "wh2_dlc16_wef_sisters_of_twilight" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_sisters_of_twilight_secondary_detail_ME";
			pic = 798;
		elseif faction_name == "wh2_dlc16_wef_drycha" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_drycha_secondary_detail";
			pic = 605;
		-----------------------
		-- DLC07 - Bretonnia
		-----------------------
		-- King Louen
		elseif faction_name == "wh_main_brt_bretonnia" then
			secondary_detail = "event_feed_strings_text_wh_dlc07_event_feed_string_scripted_event_intro_bretonnia_secondary_detail";
			pic = 751;
		-- Alberic 	
		elseif faction_name == "wh_main_brt_bordeleaux" then
			secondary_detail = "event_feed_strings_text_wh_dlc07_event_feed_string_scripted_event_intro_bretonnia_secondary_detail";
			pic = 752;
		-- Fay Enchantress	
		elseif faction_name == "wh_main_brt_carcassonne" then
			secondary_detail = "event_feed_strings_text_wh_dlc07_event_feed_string_scripted_event_intro_bretonnia_secondary_detail";
			pic = 753;
		-- Repanse
		elseif faction_name == "wh2_dlc14_brt_chevaliers_de_lyonesse" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_chevaliers_de_lyonesse_secondary_detail";
			pic = 753;	
		-----------------------
		-- DLC08 - Norsca
		-----------------------
		-- Wulfrik the Wanderer
		elseif faction_name == "wh_dlc08_nor_norsca" then
			secondary_detail = "event_feed_strings_text_wh_dlc08_event_feed_string_scripted_event_intro_norsca_secondary_detail";
			pic = 800;
		-- Throgg
		elseif faction_name == "wh_dlc08_nor_wintertooth" then
			secondary_detail = "event_feed_strings_text_wh_dlc08_event_feed_string_scripted_event_intro_norsca_secondary_detail";
			pic = 800;
		------------------------
		-- PRO2 - Isabella
		------------------------
		elseif faction_name == "wh_main_vmp_schwartzhafen" then
			secondary_detail = "event_feed_strings_text_wh_pro02_event_feed_string_scripted_event_intro_isabella_secondary_detail";
			pic = 770;
			
		------------------------
		-- WH2
		------------------------
		
		------------------------
		-- Dwarfs
		------------------------
		elseif faction_name == "wh2_dlc17_dwf_thorek_ironbrow" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_thorek_ironbrow_secondary_detail";
			pic = 1701;

		
		------------------------
		-- Greenskins
		------------------------
		
		-- Grom
		elseif faction_name == "wh2_dlc15_grn_broken_axe" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_broken_axe_secondary_detail";
			pic = 797;
		
		-- Azhag
		elseif faction_name == "wh2_dlc15_grn_bonerattlaz" then
			secondary_detail = "event_feed_strings_text_wh_main_event_feed_string_scripted_event_intro_greenskins_secondary_detail";
			pic = 593;
		
		------------------------
		-- High Elves
		------------------------	
		
		-- Tyrion
		elseif faction_name == "wh2_main_hef_eataine" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_eataine_secondary_detail";
			pic = 771;
			
		-- Teclis
		elseif faction_name == "wh2_main_hef_order_of_loremasters" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_order_of_loremasters_secondary_detail";
			pic = 772;
			
		-- Alarielle the Radiant
		elseif faction_name == "wh2_main_hef_avelorn" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_avelorn_secondary_detail";
			pic = 780;
			
		-- Alith Anar
		elseif faction_name == "wh2_main_hef_nagarythe" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_nagarythe_secondary_detail";
			pic = 781;

		-- Eltharion
		elseif faction_name == "wh2_main_hef_yvresse" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_yvresse_secondary_detail";
			pic = 795;

		-- Imrik
		elseif faction_name == "wh2_dlc15_hef_imrik" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_caledor_secondary_detail";
			pic = 796;

		------------------------
		-- Dark Elves
		------------------------
		
		-- Malekith
		elseif faction_name == "wh2_main_def_naggarond" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_naggarond_secondary_detail";
			pic = 773;
			
		-- Morathi
		elseif faction_name == "wh2_main_def_cult_of_pleasure" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_cult_of_pleasure_secondary_detail";
			pic = 774;
			
		-- Crone Hellebron
		elseif faction_name == "wh2_main_def_har_ganeth" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_har_ganeth_secondary_detail";
			pic = 779;
			
		-- Lokhir Fellheart
		elseif faction_name == "wh2_dlc11_def_the_blessed_dread" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_the_blessed_dread_secondary_detail";
			pic = 782;

		-- Malus Darkblade
		elseif faction_name == "wh2_main_def_hag_graef" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_hag_graef_secondary_detail";
			pic = 782;
				
		-- Rakarth
		elseif faction_name == "wh2_twa03_def_rakarth" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_rakarth_secondary_detail";
			pic = 782;

		------------------------
		-- Lizardmen
		------------------------
		
		-- Lord Mazdamundi
		elseif faction_name == "wh2_main_lzd_hexoatl" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_hexoatl_secondary_detail";
			pic = 775;
		
		-- Kroq-Gar
		elseif faction_name == "wh2_main_lzd_last_defenders" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_last_defenders_secondary_detail";
			pic = 776;
			
		-- Tehenhuain
		elseif faction_name == "wh2_dlc12_lzd_cult_of_sotek" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_cult_of_sotek_secondary_detail";
			pic = 788;

		-- Tiktaq'to
		elseif faction_name == "wh2_main_lzd_tlaqua" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_tlaqua_secondary_detail";
			pic = 776;
			
		-- Nakai
		elseif faction_name == "wh2_dlc13_lzd_spirits_of_the_jungle" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_spirits_of_the_jungle_secondary_detail_ME";
			pic = 776;

		-- Gor-Rok
		elseif faction_name == "wh2_main_lzd_itza" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_itza_secondary_detail";
			pic = 776;
		
		-- Oxyotl
		elseif faction_name == "wh2_dlc17_lzd_oxyotl" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_oxyotl_secondary_detail_me";
			pic = 801;
		
		------------------------
		-- Skaven
		------------------------		
		
		-- Queek Headtaker
		elseif faction_name == "wh2_main_skv_clan_mors" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_clan_mors_secondary_detail";
			pic = 777;
		
		-- Lord Skrolk
		elseif faction_name == "wh2_main_skv_clan_pestilens" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_clan_pestilens_secondary_detail";
			pic = 778;
		
		-- Tretch Craventail
		elseif faction_name == "wh2_dlc09_skv_clan_rictus" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_clan_rictus_secondary_detail";
			pic = 778;
		
		-- Ikit Claw
		elseif faction_name == "wh2_main_skv_clan_skryre" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_clan_skryre_secondary_detail";
			pic = 787;	

		-- Death Master Snikch
		elseif faction_name == "wh2_main_skv_clan_eshin" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_clan_eshin_secondary_detail";
			pic = 787;		
		
		-- Throt the Unclean
		elseif faction_name == "wh2_main_skv_clan_moulder" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_clan_moulder_secondary_detail";
			pic = 799;
		
		-----------------------
		-- Tomb Kings
		-----------------------
		
		elseif cm:get_faction(faction_name):culture() == "wh2_dlc09_tmb_tomb_kings" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_tomb_kings_secondary_detail_ME";
			pic = 606;
			
		-----------------------
		--Vampire Coast
		-----------------------
		
		elseif faction_name == "wh2_dlc11_cst_vampire_coast" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_vampire_coast_secondary_detail_ME";
			pic = 786;
		
		--Count Noctilus
		elseif faction_name == "wh2_dlc11_cst_noctilus" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_vampire_coast_secondary_detail_ME";
			pic = 785;
		
		--Aranessa Saltspite
		elseif faction_name == "wh2_dlc11_cst_pirates_of_sartosa" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_vampire_coast_secondary_detail_ME";
			pic = 783;
		
		--Cylostra Direfin
		elseif faction_name == "wh2_dlc11_cst_the_drowned" then
			secondary_detail = "event_feed_strings_text_wh2_scripted_event_how_they_play_vampire_coast_secondary_detail_ME";
			pic = 784;
		
		
		
		
		------------------------
		-- WH3
		------------------------
		
		------------------------
		-- Kislev
		------------------------
		
		elseif faction_name == "wh3_main_ksl_the_ice_court" or faction_name == "wh3_main_ksl_the_great_orthodoxy" or faction_name == "wh3_main_ksl_ursun_revivalists" then
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_kislev_secondary_detail";
			pic = 15;
		elseif faction_name == "wh3_dlc24_ksl_daughters_of_the_forest" then
			title = "event_feed_strings_text_wh3_scripted_event_path_to_victory_title";
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_kislev_mother_ostankya_secondary_detail";
			pic = 38;
		
		------------------------
		-- Daemon Prince
		------------------------
		
		elseif faction_name == "wh3_main_dae_daemon_prince" then
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_daemon_prince_secondary_detail";
			pic = 10;
		
		------------------------
		-- Khorne
		------------------------
		
		elseif faction_name == "wh3_main_kho_exiles_of_khorne" then
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_khorne_secondary_detail";
			pic = 11;
		
		------------------------
		-- Nurgle
		------------------------
		
		elseif faction_name == "wh3_main_nur_poxmakers_of_nurgle" then
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_nurgle_secondary_detail";
			pic = 12;
		elseif faction_name == "wh3_dlc25_nur_tamurkhan" then
			title = "event_feed_strings_text_wh3_scripted_event_path_to_victory_title";
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_tamurkhan_secondary_detail";
			pic = 12;
		elseif faction_name == "wh3_dlc25_nur_epidemius" then
			title = "event_feed_strings_text_wh3_scripted_event_path_to_victory_title";
			secondary_detail = "ui_text_replacements_localised_text_how_they_play_epidemius";
			pic = 12;
		
		------------------------
		-- Slaanesh
		------------------------
		
		elseif faction_name == "wh3_main_sla_seducers_of_slaanesh" then
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_slaanesh_secondary_detail";
			pic = 13;
		
		------------------------
		-- Tzeentch
		------------------------
		
		elseif faction_name == "wh3_main_tze_oracles_of_tzeentch" then
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_tzeentch_secondary_detail";
			pic = 14;
		elseif faction_name == "wh3_dlc24_tze_the_deceivers" then
			title = "event_feed_strings_text_wh3_scripted_event_path_to_victory_title";
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_tzeentch_changeling_secondary_detail";
			pic = 39;

		------------------------
		-- Cathay
		------------------------
		
		elseif faction_name == "wh3_main_cth_the_northern_provinces" or faction_name == "wh3_main_cth_the_western_provinces" then
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_cathay_secondary_detail";
			pic = 17;
		elseif faction_name == "wh3_dlc24_cth_the_celestial_court" then
			title = "event_feed_strings_text_wh3_scripted_event_path_to_victory_title";
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_cathay_yuan_bo_secondary_detail";
			pic = 40;
		
		------------------------
		-- WH3 DLC
		------------------------

		------------------------
		-- Ogre Kingdoms
		------------------------
		
		elseif faction_name == "wh3_main_ogr_goldtooth" or faction_name == "wh3_main_ogr_disciples_of_the_maw" then
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_ogre_kingdoms_secondary_detail";
			pic = 16;

		------------------------
		-- Champions
		------------------------

		elseif faction_name == "wh3_dlc20_chs_azazel" then
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_champions_of_chaos_azazel_secondary_detail";
			pic = 595;
		elseif faction_name == "wh3_dlc20_chs_festus" then
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_champions_of_chaos_festus_secondary_detail";
			pic = 595;
		elseif faction_name == "wh3_dlc20_chs_valkia" then
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_champions_of_chaos_valkia_secondary_detail";
			pic = 595;
		elseif faction_name == "wh3_dlc20_chs_vilitch" then
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_champions_of_chaos_vilitch_secondary_detail";
			pic = 595;

		------------------------
		-- Chaos Dwarfs
		------------------------

		elseif faction_name == "wh3_dlc23_chd_astragoth" or faction_name == "wh3_dlc23_chd_legion_of_azgorh" or faction_name == "wh3_dlc23_chd_zhatan" then
			secondary_detail = "event_feed_strings_text_wh3_scripted_event_how_they_play_chaos_dwarfs_secondary_detail";
			pic = 597;
		else
			script_error("ERROR: show_how_to_play_event() called but couldn't recognise supplied faction name [" .. faction_name .. "]. Please add it to script/campaign/wh_campaign_setup.lua");
			
			if end_callback then end_callback() end;
			
			return false;
		end
		
		if cm:get_campaign_name() == "main_warhammer" then
			cm:show_message_event(
				faction_name,
				title,
				primary_detail,
				secondary_detail,
				true,
				pic,
				end_callback,
				delay
			);
		else
			cm:show_message_event(
				faction_name,
				title,
				primary_detail,
				secondary_detail,
				true,
				pic,
				end_callback,
				delay
			);
		end;
	else
		local human_factions = cm:get_human_factions();
		
		for i = 1, #human_factions do
			show_how_to_play_event(human_factions[i], end_callback, delay);
		end;
	end;
end;


local rank_up_character_turn_start_lookup = {};

function add_rank_up_character_turn_start_listener(character_subtype, rank_requirement)

	-- create a subtable corresponding to this character_subtype if it doesn't already exist, and then add an entry for this rank requirement
	if not is_table(rank_up_character_turn_start_lookup[character_subtype]) then
		rank_up_character_turn_start_lookup[character_subtype] = {};
		table.insert(rank_up_character_turn_start_lookup[character_subtype], rank_requirement);
	else
		table.insert(rank_up_character_turn_start_lookup[character_subtype], rank_requirement);
		table.sort(rank_up_character_turn_start_lookup[character_subtype]);		-- sort the table so that it's always in ascending order of rank
	end;

	core:call_once(
		"rank_up_character_turn_start_listener",
		function()
			core:add_listener(
				"rank_up_character_turn_start_listener",
				"CharacterTurnStart",
				true,
				function(context)
					local character_subtype_key = context:character():character_subtype_key();

					if rank_up_character_turn_start_lookup[character_subtype_key] and #rank_up_character_turn_start_lookup[character_subtype_key] > 0 then
						-- a character subtype table exists for this character subtype
						if rank_up_character_turn_start_lookup[character_subtype_key][1] <= context:character():rank() then
							-- the lowest rank in the table is less than the rank the character just achieved - trigger a script event which the quest listeners will respond to
							table.remove(rank_up_character_turn_start_lookup[character_subtype_key], 1);
							core:trigger_event("ScriptEventQuestCharacterTurnStart", context:character());
						end;
					end;
				end,
				true
			);
		end
	);
end;


--- When we create quest listeners, we also generate a lookup table to allow us to quickly check cancelled missions and grant the ancillary
--- Format is mission_key = {subtype, ancillary}
local quest_cancellation_data = {}

function setup_cancelled_quest_listener()
	core:add_listener(
		"quest_item_mission_cancelled_listener",
		"MissionCancelled",
		function(context)
			return quest_cancellation_data[context:mission():mission_record_key()]
		end,
		function(context) 
			local cancelled_quest = quest_cancellation_data[context:mission():mission_record_key()]
			add_ancillary_to_agent_of_subtype_in_faction(cancelled_quest[2], cancelled_quest[1], context:faction()) 
		end,
		true	
	);
end

function add_ancillary_to_agent_of_subtype_in_faction(subtype_key, ancillary_key, faction_interface) 
	local character_list = faction_interface:character_list();
	for _, character in model_pairs(character_list) do
		if character:character_subtype_key() == subtype_key then
			cm:force_add_ancillary(character, ancillary_key, true, false);
			return true;
		end
	end
end

-- trigger quests (data is set up in the respective campaign folder)
function set_up_rank_up_listener(quests, subtype, infotext)
	for i = 1, #quests do
		-- grab some local data for this quest record
		local current_quest_record = quests[i];
		
		local current_type = current_quest_record[1];
		local current_ancillary_key = current_quest_record[2];
		local current_mission_key = current_quest_record[3];
		local current_rank_req = cco("CcoCharacterAncillaryQuestUiDetailRecord", current_ancillary_key .. subtype):Call("Rank");
		
		if not current_rank_req then
			script_error("set_up_rank_up_listener() called but could not find a rank for ancillary [" .. current_ancillary_key .. "] for agent subtype [" .. subtype .. "] - does it exist in the character_ancillary_quest_ui_details table?")
		end
		
		local current_mp_mission_key = current_quest_record[4];
		local current_advice_key = current_quest_record[5];
		local current_x = 0;
		local current_y = 0;
		
		if current_mission_key then
			local current_cco = cco("CcoMissionRecord", current_mission_key);
			current_x = current_cco:Call("LocationX");
			current_y = current_cco:Call("LocationY");
		end;
		
		local current_region_key = current_quest_record[6];
		local current_intervention_name = false;
		local current_saved_name = false;

		-- quest battles can't be cancelled, so don't bother storing info for them.
		if current_x == 0 and current_mission_key then
			quest_cancellation_data[current_mission_key] = {current_ancillary_key, subtype}
		end
		
		if current_mission_key then
			current_intervention_name = "in_" .. current_mission_key;
			current_saved_name = current_mission_key .. "_issued";
		else
			-- ai only, we don't have a mission for the player
			current_saved_name = current_ancillary_key .. "_issued";
		end;
		
		out.design("[Quests] establishing rank up listener for char type [" .. subtype .. "] and rank [" .. current_rank_req .. "] for mission [" .. tostring(current_mission_key) .. "]");
		out.design("\tadvice key is " .. tostring(current_advice_key) .. ", x is " .. tostring(current_x) .. " and y is " .. tostring(current_y));
		
		-- pre-declare the intervention and trigger function, so that they exist in this scope as a local
		local current_intervention = false;
		local current_intervention_trigger = false;
		
		-- only establish the intervention properly in single-player mode, however
		if not cm:is_multiplayer() and current_intervention_name then
			out.design("\testablishing intervention as it's a singleplayer campaign");
			
			--------------------------------------------
			-- called when the intervention is triggered
			function current_intervention_trigger()
				out.design("[Quests] intervention triggering for [" .. current_mission_key .. "], character subtype [" .. subtype .. "]");
				
				-- save this value in order to not issue this quest multiple times
				cm:set_saved_value(current_saved_name, true);
				
				-- stop listener
				core:remove_listener(current_mission_key);
				
				-- set up a mission manager to trigger
				local mm = mission_manager:new(cm:get_local_faction_name(), current_mission_key);
				if current_type == "dilemma" then
					mm:set_is_dilemma_in_db(true);				-- first arg is true as this is triggered from within an intervention
					out.design("\tthis quest is a dilemma");
				elseif current_type == "incident" then
					mm:set_is_incident_in_db();
					out.design("\tthis quest is an incident");
				else
					mm:set_is_mission_in_db();
					out.design("\tthis quest is a mission");
				end;
				
				-- decide whether to show infotext or not
				local infotext_to_show = false
				if not common.get_advice_history_string_seen("quests_infotext") then
					infotext_to_show = infotext;
					common.set_advice_history_string_seen("quests_infotext");
				end;
				
				if current_advice_key and current_x > 0 and current_y > 0 then
					out.design("\tscrolling the camera with advice");
					
					-- we have advice to deliver and a position
					current_intervention:scroll_camera_for_intervention(
						current_region_key,
						current_x,
						current_y,
						current_advice_key,
						infotext_to_show,
						mm,
						4
					);
				elseif current_advice_key then
					-- we have advice, but no position
					out.design("\tplaying advice with no camera movement");
					
					current_intervention:play_advice_for_intervention(
						current_advice_key,
						infotext_to_show,
						mm
					);
				elseif current_x > 0 and current_y > 0 then
					-- we have a position but no advice
					out.design("\tscrolling camera with no advice");
					
					local cam_x, cam_y, cam_d, cam_b, cam_h = cm:get_camera_position();
					
					local cutscene = campaign_cutscene:new(
						current_mission_key,
						4,
						function()
							-- trigger mission when cutscene finishes
							mm:trigger(
								function()
									-- restore shroud and complete when mission is accepted
									cm:restore_shroud_from_snapshot();
									current_intervention:complete() 
								end
							);
						end
					);
					
					cutscene:set_skippable(true);
					cutscene:set_skip_camera(current_x, current_y, cam_d, cam_b, cam_h);
					cutscene:set_disable_settlement_labels(false);
					cutscene:set_dismiss_advice_on_end(false);
					cutscene:set_restore_shroud(false);
					
					-- make the target region visible if we have one
					if current_region_key then
						cutscene:action(function() cm:make_region_visible_in_shroud(cm:get_local_faction_name(), current_region_key) end, 0);
					end;
					cutscene:action(function() cm:scroll_camera_from_current(true, 4, {current_x, current_y, cam_d, cam_b, cam_h}) end, 0);
					
					cutscene:start();
				else
					-- we have no position or advice, just trigger
					out.design("\tno advice or position to scroll to, just issuing mission");
					
					mm:trigger(function() current_intervention:complete() end);
					
					-- failsafe check - if we're still running three seconds after triggering the mission/incident/dilemma, and no event panel is on-screen,
					-- then complete anyway and complain about it on the console
					cm:callback(
						function() 
							if current_intervention.is_active and not cm:get_campaign_ui_manager():is_event_panel_open() then
								local type_for_display = "mission";
								
								if current_type == "dilemma" then
									type_for_display = "dilemma";
								elseif current_type == "incident" then
									type_for_display = "incident";
								end;
								
								script_error("ERROR - attempted to trigger " .. type_for_display .. " [" .. current_mission_key .. "] as part of quest chain but no event message seems to have been generated. Proceeding anyway, but the quest chain will be broken. This is a serious error, please notify designers.");
								
								-- cancel the dismiss listener registered with the mission manager
								mm:cancel_dismiss_callback_listeners();
								
								current_intervention:complete();
							end;
						end, 
						3
					);
				end;
			end;
			--------------------------------------------
			--------------------------------------------
			
			-- declare the intervention itself
			current_intervention = intervention:new(
				current_intervention_name,							-- string name
				0,	 												-- cost
				function() current_intervention_trigger() end,		-- trigger callback
				BOOL_INTERVENTIONS_DEBUG	 						-- show debug output
			);

			current_intervention:set_must_trigger(true);
		end;
		
		-- establish listeners for this character rank-up event if the quest chain has not already been started
		if cm:get_saved_value(current_saved_name) then
			out.design("\tthis quest has already been triggered, not establishing listeners");
		else
			out.design("\tthis quest has not been triggered, establishing listeners");

			-- Register listener for this character ranking up
			-- We now only have one CharacterTurnStart listener, which communicates using the ScriptEventQuestCharacterTurnStart event when a quest battle character has actually ranked up in a way we're interested in
			add_rank_up_character_turn_start_listener(subtype, current_rank_req);
			
			-- start ScriptEventQuestCharacterTurnStart listener
			core:add_listener(
				current_ancillary_key,
				"ScriptEventQuestCharacterTurnStart",
				function(context)
					return context:character():character_subtype(subtype) and context:character():rank() >= current_rank_req 
				end,
				function(context)
					local character = context:character();
					out.design("[Quests] Character [" .. cm:char_lookup_str(character) .. "] of subtype [" .. subtype .. "] has achieved rank [" .. current_rank_req .. "]");
					
					-- if the character is player controlled then begin the quest chain
					if current_type == "reward" or not character:faction():is_human() then
						out.design("\tcharacter is not player-controlled, or this quest is just an ancillary reward, immediately giving them ancillary [" .. current_ancillary_key .. "]");
						
						-- save this value in order to not issue this quest multiple times
						cm:set_saved_value(current_saved_name, true);
						
						-- character is AI-controlled or its a reward, give them the ancillary
						cm:force_add_ancillary(character, current_ancillary_key, false, false);
					elseif cm:is_multiplayer() or cm:get_saved_value("advice_is_disabled") then
						-- save this value in order to not issue this quest multiple times
						cm:set_saved_value(current_saved_name, true);	-- don't do this if the intervention is going to be triggered
						
						-- character is player-controlled and this is a multiplayer game, trigger the mission/dilemma etc
						if current_type == "mission" then
							if cm:is_multiplayer() and current_mp_mission_key then
								current_mission_key = current_mp_mission_key;
							end;
							
							out.design("\tcharacter is player controlled and this is an mp game or advice is disabled, triggering mission " .. current_mission_key);
							cm:trigger_mission(character:faction():name(), current_mission_key, true);
						elseif current_type == "dilemma" then
							out.design("\tcharacter is player controlled and this is an mp game or advice is disabled, triggering dilemma " .. current_mission_key);
							cm:trigger_dilemma(character:faction():name(), current_mission_key);
						elseif current_type == "incident" then
							out.design("\tcharacter is player controlled and this is an mp game or advice is disabled, triggering incident " .. current_mission_key);
							cm:trigger_incident(character:faction():name(), current_mission_key, true);
						elseif current_type == "ai_only" then
							-- don't do anything
						else
							out.design("\tcouldn't determine mission type [" .. tostring(current_type) .. "] - see script error");
							script_error("ERROR: Tried to start a quest, but the event type [" .. tostring(current_type) .. " could not be parsed!");
						end;
					elseif current_mission_key then
						-- character is player-controlled and this is a single-player game, sending a scriptevent that will trigger the intervention
						out.design("\tthis is a single-player campaign, triggering a message for the intervention");
						core:trigger_event("ScriptEventTriggerQuestChain", current_mission_key);
					end;
				end,
				false
			);
			
			-- if it's a single-player game, then set up the intervention monitors
			if not cm:is_multiplayer() and current_intervention then
				-- listen for the scriptevent message, triggered from the monitor above if the player levels up a char on their turn
				current_intervention:add_trigger_condition(
					"ScriptEventTriggerQuestChain",
					function(context)
						return context.string == current_mission_key;
					end
				);
				
				current_intervention:start();
			end;
		end;
	end;
end;



function set_up_backup_mission(origin_mission, backup_mission, subtype)
	core:add_listener(
		origin_mission .. "_backup",
		"MissionGenerationFailed",
		function(context) return context:mission() == origin_mission end,
		function()
			out("Could not issue quest chain mission key [" .. origin_mission .. "] to faction owning agent subtype [" .. subtype .. "] - going to issue mission key [ " .. backup_mission .. "]");
			
			-- get the character's faction name, it might have changed if they've been confederated
			local faction_name = nil;
			local faction_list = cm:model():world():faction_list();
			
			for i = 0, faction_list:num_items() - 1 do
				local current_faction = faction_list:item_at(i);
				local char_list = current_faction:character_list();
				
				for j = 0, char_list:num_items() - 1 do
					local current_char = char_list:item_at(j);
					
					if current_char:character_subtype(subtype) then
						faction_name = current_char:faction():name();
						break;
					end;
				end;
				
				if faction_name then
					break;
				end;
			end;
			
			if faction_name then
				cm:trigger_mission(faction_name, backup_mission, true);
			end;
		end,
		false
	);
end;

-- apply effect bundle to skaven forces laying siege if skaven corruption is high
function menace_below_monitor()
	core:add_listener(
		"menace_below_monitor",
		"PendingBattle",
		function()
			local pb = cm:model():pending_battle();
			local attacker = pb:attacker();
			local defender = pb:defender();

			return (attacker:faction():culture() == "wh2_main_skv_skaven" or defender:faction():culture() == "wh2_main_skv_skaven") and defender:has_region() and cm:get_corruption_value_in_region(defender:region(), skaven_corruption_string) > 0;
		end,
		function()
			local pb = cm:model():pending_battle();
			local attacker = pb:attacker();
			local defender = pb:defender();
			local skaven_proportion = cm:get_corruption_value_in_region(defender:region(), skaven_corruption_string);
			local effect_bundle = "wh2_main_bundle_laying_siege_menace_below_corruption_bonus_"
			
			if skaven_proportion >= 60 then
				effect_bundle = effect_bundle .. "3";
			elseif skaven_proportion >= 30 then
				effect_bundle = effect_bundle .. "2";
			else
				effect_bundle = effect_bundle .. "1";
			end;
			
			local game_interface = cm:get_game_interface();
			
			if attacker:faction():culture() == "wh2_main_skv_skaven" then
				local attacker_cqi = attacker:cqi();
				
				remove_menace_below_effect_bundles(attacker_cqi)
				game_interface:apply_effect_bundle_to_characters_force(effect_bundle, attacker_cqi, 0);
			end;
			
			if defender:faction():culture() == "wh2_main_skv_skaven" then
				local defender_cqi = defender:cqi();
				
				remove_menace_below_effect_bundles(defender_cqi)
				game_interface:apply_effect_bundle_to_characters_force(effect_bundle, defender_cqi, 0);
			end;

			game_interface:update_pending_battle();
		end,
		true
	);
	
	core:add_listener(
		"menace_below_cleanup",
		"BattleCompleted",
		function()
			local pb = cm:model():pending_battle();
			
			if pb:has_been_fought() then
				local attacker_cqi, attacker_force_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
				local defender_cqi, defender_force_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
				local attacker = cm:get_faction(attacker_faction_name);
				local defender = cm:get_faction(defender_faction_name);				
				
				return (attacker and attacker:culture() == "wh2_main_skv_skaven") or (defender and defender:culture() == "wh2_main_skv_skaven");
			else
				return (pb:has_attacker() and pb:attacker():faction():culture() == "wh2_main_skv_skaven") or (pb:has_defender() and pb:defender():faction():culture() == "wh2_main_skv_skaven");
			end;
		end,
		function()			
			local pb = cm:model():pending_battle();
			
			if pb:has_attacker() then
				remove_menace_below_effect_bundles(pb:attacker():cqi());
			end;
			
			if pb:has_defender() then
				remove_menace_below_effect_bundles(pb:defender():cqi());
			end;
		end,
		true
	);
end;

function remove_menace_below_effect_bundles(cqi)
	local effect_bundle = "wh2_main_bundle_laying_siege_menace_below_corruption_bonus_";
	local game_interface = cm:get_game_interface();
	
	for i = 1, 3 do
		game_interface:remove_effect_bundle_from_characters_force(effect_bundle .. tostring(i), cqi);
	end;
end;

-- scripted effect that reveals all sea regions
-- add any buildings or techs that use it here
local sea_region_effect_buildings = {
	"wh2_dlc11_special_dragon_tooth_lighthouse_1"
};

local sea_region_effect_techs = {
	"wh2_main_tech_hef_5_06"
};

function sea_region_shroud_effect_listener()
	core:add_listener(
		"sea_region_tech_listener",
		"ResearchCompleted",
		function(context)
			return context:faction():is_human() and sea_region_has_tech(context:faction());
		end,
		function(context)
			reveal_all_sea_regions(context:faction():name());
		end,
		true
	);
	
	core:add_listener(
		"sea_region_building_listener",
		"BuildingCompleted",
		function(context)
			return context:building():faction():is_human() and sea_region_has_constructed_building(context:building():name());
		end,
		function(context)
			reveal_all_sea_regions(context:building():faction():name());
		end,
		true
	);
	
	core:add_listener(
		"sea_region_faction_turn_start_listener",
		"ScriptEventHumanFactionTurnStart",
		function(context)
			local faction = context:faction();
			return sea_region_has_tech(faction) or sea_region_has_building(faction);
		end,
		function(context)
			reveal_all_sea_regions(context:faction():name());
		end,
		true
	);
end;

function sea_region_has_tech(faction)	
	for i = 1, #sea_region_effect_techs do
		 if faction:has_technology(sea_region_effect_techs[i]) then
			return true;
		end;
	end;
end;

function sea_region_has_constructed_building(building)
	for i = 1, #sea_region_effect_buildings do
		 if building == sea_region_effect_buildings[i] then
			return true;
		end;
	end;
end;

function sea_region_has_building(faction)
	local region_list = faction:region_list();
	
	for i = 0, region_list:num_items() - 1 do
		local current_region = region_list:item_at(i);
		
		for j = 1, #sea_region_effect_buildings do
			 if current_region:building_exists(sea_region_effect_buildings[j]) then
				return true;
			end;
		end;
	end;
end;

function reveal_all_sea_regions(faction_name)
	local regions = cm:model():world():sea_region_data();
	
	for i = 0, regions:num_items() - 1 do
		local current_region_name = regions:item_at(i):key();
		
		if not current_region_name:find("sea_lake") then
			cm:make_region_visible_in_shroud(faction_name, current_region_name);
		end;
	end;
end;







-- show the geomantic web help page when the geomantic web screen is opened
function show_geomantic_web_help_page_on_screen_open()
	core:add_listener(
		"show_geomantic_web_help_page_on_screen_open_listener",
		"ComponentLClickUp",
		function(context) return context.string == "button_geomantic_web" and UIComponent(UIComponent(context.component):Parent()):Id() == "button_group_management" end,
		function(context)
			local button_state = UIComponent(context.component):CurrentState();
			local hpm = get_help_page_manager();
			
			if (button_state == "down" and not hpm:is_panel_visible()) or (button_state == "selected_down" and hpm:is_panel_visible() and hpm:get_last_help_page() == "script_link_campaign_geomantic_web") then
				hp_geomantic_web:link_clicked();
			end;
		end,
		true
	);
end;




function quest_battle_free_force()
	core:add_listener(
		"quest_battle_free_force",
		"PendingBattle",
		function(context)
			return context:pending_battle():set_piece_battle_key() ~= "";
		end,
		function(context)
			local function apply_free_upkeep(mf)
				cm:apply_effect_bundle_to_force("wh_main_bundle_military_upkeep_free_force", mf:command_queue_index(), 0);
			end;
			
			local pb = context:pending_battle();
			
			if pb:has_attacker() then
				local attacker = pb:attacker();
				
				if attacker:has_military_force() then
					local attacker_mf = attacker:military_force();
					
					if attacker_mf:is_set_piece_battle_army() then
						apply_free_upkeep(attacker_mf);
					end;
				end;
			end;
			
			if pb:has_defender() then
				local defender = pb:defender();
				
				if defender:has_military_force() then
					local defender_mf = defender:military_force();
					
					if defender_mf:is_set_piece_battle_army() then
						apply_free_upkeep(defender_mf);
					end;
				end;
			end;
			
			local secondary_attackers = pb:secondary_attackers();
			
			for i = 0, secondary_attackers:num_items() - 1 do
				local current_secondary_attacker = secondary_attackers:item_at(i);
				
				if current_secondary_attacker:has_military_force() then
					local current_secondary_attacker_mf = current_secondary_attacker:military_force();
					
					if current_secondary_attacker_mf:is_set_piece_battle_army() then
						apply_free_upkeep(current_secondary_attacker_mf);
					end;
				end;
			end;
			
			local secondary_defenders = pb:secondary_defenders();
			
			for i = 0, secondary_defenders:num_items() - 1 do
				local current_secondary_defender = secondary_defenders:item_at(i);
				
				if current_secondary_defender:has_military_force() then
					local current_secondary_defender_mf = current_secondary_defender:military_force();
					
					if current_secondary_defender_mf:is_set_piece_battle_army() then
						apply_free_upkeep(current_secondary_defender_mf);
					end;
				end;
			end;
		end,
		true
	);
end;




-- show an event when player performs scout ruins on a settlement that isn't owned by skaven
function show_target_ruins_success_event_message()
	core:add_listener(
		"show_target_ruins_success_event_message_listener",
		"CharacterGarrisonTargetAction",
		function(context)
			local agent_action_key = context:agent_action_key();
			
			return (agent_action_key:find("scout_settlement") or agent_action_key == "wh2_dlc09_agent_action_engineer_hinder_settlement_necrotect_ritual") and context:character():faction():is_human() and context:garrison_residence():faction():culture() ~= "wh2_main_skv_skaven";
		end,
		function(context)
			local settlement = context:garrison_residence():settlement_interface();
			local id = 900;
			local primary = "event_feed_strings_text_wh2_event_feed_string_scripted_event_scout_ruins_success_primary_detail";
			local secondary = "event_feed_strings_text_wh2_event_feed_string_scripted_event_scout_ruins_success_secondary_detail";
			local flavour = "event_feed_strings_text_wh2_event_feed_string_scripted_event_scout_ruins_success_flavour_text";
			
			if context:agent_action_key() == "wh2_dlc09_agent_action_engineer_hinder_settlement_necrotect_ritual" then
				id = 901;
				primary = "event_feed_strings_text_wh2_dlc09_event_feed_string_scripted_event_colonise_ruins_success_primary_detail";
				secondary = "event_feed_strings_text_wh2_dlc09_event_feed_string_scripted_event_colonise_ruins_success_secondary_detail";
				flavour = "event_feed_strings_text_wh2_dlc09_event_feed_string_scripted_event_colonise_ruins_success_flavour_text";
			end;
			
			cm:show_message_event_located(
				context:character():faction():name(),
				primary,
				secondary,
				flavour,
				settlement:logical_position_x(),
				settlement:logical_position_y(),
				true,
				id
			);
		end,
		true
	);
end;



function disable_tax_and_public_order_for_regions(regions)
	for i = 1, #regions do
		cm:exempt_province_from_tax_for_all_factions_and_set_default(regions[i], true);
		cm:set_public_order_disabled_for_province_for_region_for_all_factions_and_set_default(regions[i], true);
	end;
end;



function track_technology_researched()
	core:add_listener(
		"research_completed_save_value",
		"ResearchCompleted",
		true,
		function(context)
			cm:set_saved_value("tech_researched_this_turn_" .. context:faction():name(), true)
		end,
		true
	)
	
	core:add_listener(
		"faction_turn_start_research_completed_save_value",
		"FactionTurnEnd",
		true,
		function(context)
			local faction_name = context:faction():name()
			
			if cm:get_saved_value("tech_researched_this_turn_" .. faction_name) then
				cm:set_saved_value("tech_researched_this_turn_" .. faction_name, false)
			end
		end,
		true
	)
end



-- apply an effect bundle to a human beastmen faction when positive diplomatic event occurs
function beastmen_positive_diplomatic_event_listener()
	core:add_listener(
		"beastmen_positive_diplomatic_event",
		"PositiveDiplomaticEvent",
		true,
		function(context)
			local function apply_diplomatic_effect_bundle(faction_name, context)
				if context:is_alliance() then
					cm:apply_effect_bundle("wh_dlc03_bundle_beastmen_alliance_made", faction_name, 5);
				elseif context:is_peace_treaty() then
					cm:apply_effect_bundle("wh_dlc03_bundle_beastmen_peace_made", faction_name, 5);
				elseif context:is_non_aggression_pact() then
					cm:apply_effect_bundle("wh_dlc03_bundle_beastmen_non_aggression_made", faction_name, 5);
				end
			end
			
			local proposer = context:proposer();
			local recipient = context:recipient();
			
			if proposer:is_human() and proposer:culture() == "wh_dlc03_bst_beastmen" then
				apply_diplomatic_effect_bundle(proposer:name(), context);
			end
			
			if recipient:is_human() and recipient:culture() == "wh_dlc03_bst_beastmen" then
				apply_diplomatic_effect_bundle(recipient:name(), context);
			end
		end,
		true
	);
end;


function wh_faction_is_horde(faction)
	return faction:is_allowed_to_capture_territory() == false;
end;


function setup_faction_resettle_listener()
	core:add_listener(
		"faction_resettles",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:settlement_option() == "occupation_decision_resettle" and context:character():faction():culture() ~= "wh2_main_skv_skaven";
		end,
		function(context)
			cm:instantly_set_settlement_primary_slot_level(context:garrison_residence():settlement_interface(), 1);
		end,
		true
	);
end;


function setup_daemon_prince_tint_listener()
	core:add_listener(
		"daemon_prince_tint_listener",
		"CharacterArmoryItemEquipped",
		function(context)
			return context:character():faction():name() == "wh3_main_dae_daemon_prince";
		end,
		function(context)
		
			--NOTE: If updating any of below logic, please tell UI team to update logic in SETUP_UNIT_CUSTOM_INFO::calculate_character_tint_from_variant_list
			-- Ideally we would find a way to share up this essentially duplicated logic...
		
			local character = context:character();
			local armory = character:family_member():armory();
			local categories = {"khorne", "nurgle", "slaanesh", "tzeentch"};
			local most_equipped_of_category = 0;
			local category_equipped = false;
			
			for i = 1, #categories do
				local number_of_equipped_items = armory:number_of_equipped_items_of_ui_type(categories[i]);
				
				if number_of_equipped_items > most_equipped_of_category then
					category_equipped = categories[i];
					most_equipped_of_category = number_of_equipped_items;
				end;
			end;
			
			local tweaker_daemon = common.tweaker_value("daemon_prince_max_equipment_can_equip") or "9";
			local max_number_of_daemon_slots = tonumber(tweaker_daemon);
			
			local colour_amount = math.round(255 / max_number_of_daemon_slots * most_equipped_of_category);
			
			if category_equipped then
				cm:set_tint_colour_for_character(character, "wh3_main_daemon_prince_" .. category_equipped .. "_primary", colour_amount, "wh3_main_daemon_prince_" .. category_equipped .. "_secondary", colour_amount);
				cm:set_tint_activity_state_for_character(character, true);
			else
				cm:set_tint_activity_state_for_character(character, false);
			end;
		end,
		true
	);
end;


function apply_default_diplomacy()
	local world = cm:model():world();
	
	-- Beastmen can only declare war and peace, except with certain cultures
	cm:force_diplomacy("culture:wh_dlc03_bst_beastmen", "all", "all", false, false, true);
	cm:force_diplomacy("culture:wh_dlc03_bst_beastmen", "all", "war", true, true, true);
	cm:force_diplomacy("culture:wh_dlc03_bst_beastmen", "all", "payments", true, true, true);
	cm:force_diplomacy("culture:wh_dlc03_bst_beastmen", "all", "peace", true, true, true);
	
	local beastmen_diplomacy_permitted = world:lookup_factions_from_faction_set("beastmen_diplomacy_permitted")
	for _, faction in model_pairs(beastmen_diplomacy_permitted) do
		cm:force_diplomacy("culture:wh_dlc03_bst_beastmen", "faction:" .. faction:name(), "all", true, true, true);
	end;
	
	-- Beastmen confederation is unlocked via tech tree
	cm:force_diplomacy("culture:wh_dlc03_bst_beastmen", "culture:wh_dlc03_bst_beastmen", "form confederation", false, false, true);
	
	-- Restrict Dwarf confederation between Legendary Lords
	local dwarf_playable_factions = world:lookup_factions_from_faction_set("dwarf_playable_factions")
	local human_dwarf_faction = false
	-- Check if there are any human dwarf factions
	for _, faction in model_pairs(dwarf_playable_factions) do
		if faction:is_human() then
			human_dwarf_faction = true
		end
	end
	-- If there are any human dwarf factions block confederation between the Legendary Lords
	if human_dwarf_faction then
		for _, source_faction in model_pairs(dwarf_playable_factions) do
			for __, target_faction in model_pairs(dwarf_playable_factions) do
				if source_faction ~= target_faction then
					cm:force_diplomacy("faction:" .. source_faction:name(), "faction:" .. target_faction:name(), "form confederation", false, false, true)
				end
			end
		end
	end

	-- The Empire cannot be at peace with Empire Secessionists
	if cm:get_faction("wh_main_emp_empire_separatists") then
		cm:force_diplomacy("faction:wh_main_emp_empire", "faction:wh_main_emp_empire_separatists", "peace", false, false, true);
	end;
	
	-- restrict trade
	local factions_without_trade = world:lookup_factions_from_faction_set("factions_without_trade")
	for _, faction in model_pairs(factions_without_trade) do
		cm:force_diplomacy("faction:" .. faction:name(), "all", "trade agreement,break trade", false, false, true);
	end;
	
	-- Kislev confederation and war restriction for supporter feature
	local ice_court_faction_is_human = cm:get_faction("wh3_main_ksl_the_ice_court"):is_human();
	local orthodoxy_faction_is_human = cm:get_faction("wh3_main_ksl_the_great_orthodoxy"):is_human();
	
	cm:force_diplomacy("faction:wh3_main_ksl_the_ice_court", "faction:wh3_main_ksl_the_great_orthodoxy", "war", false, false, true);
	
	-- re-enable war when both kislev factions are player controlled
	if ice_court_faction_is_human and orthodoxy_faction_is_human then
		cm:force_diplomacy("faction:wh3_main_ksl_the_ice_court", "faction:wh3_main_ksl_the_great_orthodoxy", "war", true, true, true);
	end;
	
	-- player cannot confederate the other kislev faction
	if ice_court_faction_is_human or orthodoxy_faction_is_human then
		cm:force_diplomacy("faction:wh3_main_ksl_the_ice_court", "faction:wh3_main_ksl_the_great_orthodoxy", "form confederation", false, false, true);
	end;
	
	-- Kurgan Warband war restriction on Chaos aligned factions
	local kurgan_warband_war_exceptions = world:lookup_factions_from_faction_set("kurgan_warband_war_exceptions")
	for _, faction in model_pairs(kurgan_warband_war_exceptions) do
		cm:force_diplomacy("faction:wh3_main_rogue_kurgan_warband", "faction:" .. faction:name(), "war", false, false);
	end;
	
	-- some cultures cannot request a faction to become a vassal
	cm:force_diplomacy("all", "all", "vassal", false, true, true);
	
	local factions_with_vassals = world:lookup_factions_from_faction_set("factions_with_vassals")
	for _, faction in model_pairs(factions_with_vassals) do
		cm:force_diplomacy("faction:" .. faction:name(), "all", "vassal", true, true, false);
	end;
	
	-- sentinels cannot do diplomacy with anyone, but anyone can declare war on the sentinels
	if cm:get_faction("wh2_dlc09_tmb_the_sentinels") then
		cm:force_diplomacy("faction:wh2_dlc09_tmb_the_sentinels", "all", "all", false, false, true);
		cm:force_diplomacy("all", "faction:wh2_dlc09_tmb_the_sentinels", "war", true, true, false);
	end;
	-- nobody can vassal Settra
	if cm:get_faction("wh2_dlc09_tmb_khemri") then
		cm:force_diplomacy("all", "faction:wh2_dlc09_tmb_khemri", "vassal", false, false, false);
	end;
	
	-- loop through all human factions to lock off diplomacy options that can't be locked using the system above
	local human_player_keys = cm:get_human_factions();
	local is_multiplayer = cm:is_multiplayer();
	
	for i = 1, #human_player_keys do
		local current_faction = cm:get_faction(human_player_keys[i]);
		
		-- enable payments and add a trade agreement between multiplayer team mates
		if is_multiplayer then
			local team_mates = current_faction:team_mates();
			
			for j = 0, team_mates:num_items() - 1 do
				local current_team_mate = team_mates:item_at(j);
				local current_team_mate_name = current_team_mate:name();
				
				cm:force_diplomacy("faction:" .. human_player_keys[i], "faction:" .. current_team_mate_name, "payments", true, true, true);
				
				if not current_faction:trade_agreement_with(current_team_mate) then
					cm:force_make_trade_agreement(human_player_keys[i], current_team_mate_name);
				end;
			end;
		end;
	end;
end;


function add_debug_listeners()
	core:add_listener(
		"DEBUG_FactionListner",
		"DebugFactionEvent",
		true,
		function(context)
			out("Faction Event: " .. context:id());
		end,
		true
	);
	
	core:add_listener(
		"DEBUG_RegionListner",
		"DebugRegionEvent",
		true,
		function(context)
			local region = context:region();
			out("Region Event: " .. context:id());
		end,
		true
	);
	
	core:add_listener(
		"DEBUG_CharacterListner",
		"DebugCharacterEvent",
		true,
		function(context)
			local character = context:character();
			out("Character Event: " .. context:id());
		end,
		true
	);
end;