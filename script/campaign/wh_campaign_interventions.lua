
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	INTERVENTIONS SCRIPTS
--	Declare scripts for campaign interventions (when the advisor appears to
--	inform the player about a game feature) here
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

force_require("wh_campaign_scripted_tours");


-- Master switch and tweakers to turn off all global advice
local BOOL_START_GLOBAL_INTERVENTIONS = true;

-- SCRIPTED_TWEAKER_30 :: disable all narrative events and campaign advice triggers
-- SCRIPTED_TWEAKER_32 :: disable campaign advice triggers
if core:is_tweaker_set("SCRIPTED_TWEAKER_30") then
	script_error("INFO: not loading campaign advice triggers as SCRIPTED_TWEAKER_30 is set, disabling narrative events and campaign advice triggers");
	BOOL_START_GLOBAL_INTERVENTIONS = false;
elseif core:is_tweaker_set("SCRIPTED_TWEAKER_32") then
	script_error("INFO: not loading campaign advice triggers as SCRIPTED_TWEAKER_32 is set, disabling campaign advice triggers");
	BOOL_START_GLOBAL_INTERVENTIONS = false;
end;


local EXPENSIVE_ADVICE_DISABLED = true;


-- set to false for release
BOOL_INTERVENTIONS_DEBUG = true;


-- Number of turns that we wait after turn one before we call start_global_interventions_main() and activate the main body of advice monitors
local TURN_COUNTDOWN_TO_ALL_ADVICE_START = 3;
-- The advice delay was introduced by the WH3 dev team, but there are cases (e.g. the intro forest encounters for Wood Elves, which can fire on Turn 1) where
-- this blocks useful advice. For now, I've forcibly changed it back to zero for Immortal Empires.
if cm:get_campaign_name() == "main_warhammer" then
	TURN_COUNTDOWN_TO_ALL_ADVICE_START = 0;
end


-- Turns after the monitors start before we allow <race> seen advice to trigger
local BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN = 8;


-- global distance at which things are close enough to be pointed out 
-- (e.g. Greenskins are "close" and will be highlighted by the advisor if the shortest distance between
-- the player and any Greenskins character is less than this number)
local INTERVENTION_CLOSE_DISTANCE = 50;




local function get_local_faction_for_global_interventions(show_output)

	if cm:is_multiplayer() then
		if show_output then
			out.interventions("* not starting global interventions as this is a multiplayer game");
		end;
		return false;
	end;

	if core:is_tweaker_set("DISABLE_PRELUDE_CAMPAIGN_SCRIPTS") then
		if show_output then
			out.interventions("* not starting global interventions as tweaker DISABLE_PRELUDE_CAMPAIGN_SCRIPTS is set");
		end;
		return false;
	end;

	local local_faction = cm:get_local_faction();

	if not local_faction then
		if show_output then
			out.interventions("* not starting global interventions as no local faction could be found - is this an autorun?");
		end;
		return false;
	end;

	return true, local_faction;
end;



-- Start initial global advice monitors here.
-- Advice monitors that are required to start on turn one should be started in this function.
-- The majority of advice monitors should be started in start_global_interventions_main() instead.
function start_global_interventions()
	local campaign_name = cm:get_campaign_name()

	out.interventions("");
	out.interventions("* start_global_interventions()) called");
	out("* start_global_interventions() called - see output in interventions tab");
	out.interventions("");

	local should_proceed, local_faction = get_local_faction_for_global_interventions(true);

	if not should_proceed then
		return;
	end;
	-- guard against being called in benchmark mode
	if cm:is_benchmark_mode() then
		out.interventions("* not starting global interventions as this is a campaign benchmark");
		return;
	end;
	
	-- guard against being called in autoruns
	if not is_string(local_faction) or local_faction == "" then
		out.interventions("* not starting global interventions as this is a multiplayer game");
	end;
	local local_faction_name = local_faction:name();
	local subculture = local_faction:subculture();


	-- Start the turn countdown to call start_global_interventions_main()
	cm:add_turn_countdown_event(
		local_faction_name, 
		TURN_COUNTDOWN_TO_ALL_ADVICE_START, 
		"ScriptEventStartGlobalInterventionsMain"
	);

	
	--
	-- ADVICE MONITORS TO START ON TURN ONE GO HERE
	--

	-- Start scripted tour monitors
	start_scripted_tours();

	-- Diplomacy advice
	in_diplomacy_screen:start();
	in_diplomacy:start();
	in_war:start();
	in_alliances:start();
	in_trade_agreement_sought:start();
	in_non_aggression_pacts:start();

	-- pre and post battle
	in_pre_field_battle_options:start();
	in_pre_field_battle_options_victory_unsure:start();
	in_pre_field_battle_options_victory_unlikely:start();
	if(campaign_name == "wh3_main_chaos") then
		storm_of_magic_pre_battle:start();
	end
	in_ambush_defence:start();
	
	
	in_autoresolving:start();
	in_pre_minor_settlement_battle_options:start();
	
	if subculture == "wh3_main_sc_dae_daemons" then
		daemon_prince_post_battle:start()
	else
		in_post_normal_battle_victory_options:start();
		in_post_siege_battle_victory_options:start();
	end;
	
	in_post_battle_defeat_options:start();

	-- end turn warnings
	in_commandment_warning:start();
	in_war_warning:start();
	-- in_technology_warning:start();
end;





-- Listener to start start_global_interventions_main()
core:add_listener(
	"start_global_interventions_main",
	"ScriptEventStartGlobalInterventionsMain",
	true,
	function() start_global_interventions_main() end,
	false
);


function start_global_interventions_main()

	out.interventions("");
	out.interventions("* start_global_interventions_main() called");
	out("* start_global_interventions_main() called - see output in interventions tab");
	out.interventions("");
	
	local should_proceed, local_faction = get_local_faction_for_global_interventions(true);

	if not should_proceed then
		return;
	end;

	local local_faction_name = local_faction:name();
	local subculture = local_faction:subculture();
	
	
	


	--
	-- ADVICE MONITORS TO START A FEW TURNS AFTER TURN ONE GO HERE
	--
	
	
	-- money
	in_money:start();
	in_near_bankruptcy:start();
	in_bankruptcy:start();

	-- items
	item_sets:start()
	
	-- raising forces
	-- in_raise_forces:start();
	
	-- heroes
	-- in_hero_creation:start();
	in_hero_action_suffered:start();
	in_foreign_hero:start();
	in_movement_points_exhausted:start();
	in_unit_recruitment:start();
	in_stances:start();
	in_help_pages:start();
	in_enemy_reinforcements:start();
	in_player_reinforcements:start();
	in_enemy_raiding:start();
	in_unit_exchange:start();
	in_unit_merging:start();
	-- in_zones_of_control:start();
	in_attrition_general:start();
	in_global_recruitment:start();
	in_multi_turn_recruitment:start();
	in_plague:start();
	in_puzzle_dice:start();
	in_puzzle_clock:start();
	in_puzzle_numbers:start();
	in_puzzle_odd_one_out:start();
	
	in_under_empire_ai_discovered:start();
	in_under_empire_player_removes:start();

	-- Winds of Magic
	in_winds_of_magic_weak:start()

	-- War Coordination
	in_request_foreign_army:start()
	--
	-- subculture-exclusive interventions
	-- we generally do anyone-but-<subculture> interventions here and only-<subculture> interventions in the
	-- relevant faction file as it prevents the latter interventions from being loaded by all factions
	--
	
	-- anyone-but-greenskins and Lizardmen and High Elves
	if subculture ~= "wh_main_sc_grn_greenskins" and subculture ~= "wh2_main_sc_lzd_lizardmen" and subculture ~= "wh2_main_sc_hef_high_elves" then
		in_raiding_stance_possible:start();
	end;
	
	-- anyone-but-greenskins
	if subculture ~= "wh_main_sc_grn_greenskins" then
		in_greenskins:start();
	end;
	
	-- vampire counts
	if subculture ~= "wh_main_sc_vmp_vampire_counts" then
		in_vampire_counts:start();
	else
		in_vampires_racial_advice:start();
		in_vampires_raising_dead_advice:start();
		in_bloodlines:start();
	end
	
	-- vampire counts or vampire coast
	if subculture == "wh_main_sc_vmp_vampire_counts" or subculture == "wh2_dlc11_sc_cst_vampire_coast" then
		in_vmp_attrition_untainted:start();
	else
		-- anyone else
		in_attrition_vampire:start();
	end;
	
	-- anyone-but-dwarfs
	if subculture ~= "wh_main_sc_dwf_dwarfs" then
		in_dwarfs:start();
		in_winds_of_magic_changed:start();
	else
		--thorek only
		if local_faction == "wh2_dlc17_dwf_thorek_ironbrow" then
			in_forge_opened:start();
			in_artefacts_first_pair_recovered:start();
			in_artefacts_first_artefact_forged:start();
			in_artefacts_third_artefact_forged:start();
			in_artefacts_all_artefact_forged:start();
		end

		in_dwarfs_racial_advice:start();
		in_grudges_advice:start();
		in_dwarfs_underway_advice:start();
		in_oathgold:start();
		in_dwarf_runes:start();
		in_grudges_low_severity:start();
		in_grudges_high_severity:start();
	end;
	
	-- anyone-but-empire
	if subculture ~= "wh_main_sc_emp_empire" then
		in_empire:start();
	else
		in_empire_racial_advice:start();

		--anyone-but-wulfhart
		if local_faction_name ~= "wh2_dlc13_emp_the_huntmarshals_expedition" then
			--Presige
			in_prestige_gained:start();
			--Imperial Authority
			in_elector_counts_open_panel:start();
			in_elector_counts_occupy_capital:start();
			in_elector_counts_appoint_elector:start();
			in_imperial_authority_low_negative_authority:start();
			in_imperial_authority_high_negative_authority:start();
			in_imperial_authority_civil_war:start();
			in_imperial_authority_political_event:start();
			in_imperial_authority_invasion_event:start();
			in_imperial_authority_confederation_event:start();
			in_imperial_authority_declare_war_on_elector:start();
			in_imperial_authority_elector_killed:start();			
		else
			--Emperor's Mandate
			in_mandate_gained:start();
			in_mandate_level_2:start();
			in_mandate_level_3:start();
			in_mandate_losing_settlement:start();
			in_mandate_supplies_dilemma:start();
			--Hostility
			in_hostility_gained:start();
			in_hostility_level_1:start();
			in_hostility_level_3:start();
			in_hostility_level_5:start();
			in_hostility_defeat_spawned_army:start();
			in_hostility_resource_degrades:start();
			in_hostility_level_degrades:start();
			--Wulfhart's Hunters
			in_hunters_open_panel:start();
			in_hunters_first_hunter_unlocked:start();
			in_hunters_first_hunter_story_complete:start();
			in_hunters_all_hunters_unlocked:start();
			in_hunters_all_hunters_stories_completed:start();
		end;
	end;
	
	-- anyone-but-chaos
	if subculture ~= "wh_main_sc_chs_chaos" then
		-- not norsca
		if subculture ~= "wh_dlc08_sc_nor_norsca" then		
			in_chaos:start();
		end;
		
		-- beastmen and Chaos have no traditional ambush stance
		if subculture ~= "wh_dlc03_sc_bst_beastmen" then
			in_ambush_stance:start();
		end;
	else
		in_chaos_racial_advice:start();
	end
	
	-- anyone-but-beastmen
	if subculture ~= "wh_dlc03_sc_bst_beastmen" then
		in_beastmen:start();
	end;
	
	-- anyone-but-woodelves
	if subculture ~= "wh_dlc05_sc_wef_wood_elves" then
		in_wood_elves:start();
	end;
	
	if subculture ~= "wh_main_sc_chs_chaos" then
		in_attrition_chaos:start();
	end;
	
	-- Beastmen only
	if subculture == "wh_dlc03_sc_bst_beastmen" then
		in_beastmen_racial_advice:start();
		in_beastmen_horde_advice:start();
		in_beastmen_bestial_rage_advice:start();
		in_low_bestial_rage:start();
		in_beastmen_beast_paths_advice:start();
		in_beastmen_hidden_encampment_stance_advice:start();

		in_bloodgrounds_herdstone:start();
		in_bloodgrounds_regions:start();
		in_bloodgrounds_settlements:start();
		in_bloodgrounds_first_raze:start();
		in_bloodgrounds_all_razed:start();
		in_bloodgrounds_ritual_complete:start();
		in_beastmen_technology_panel_opened:start();
		in_marks_of_ruination_turn_two:start();
		in_marks_of_ruination_first_threshold:start();
		in_marks_of_ruination_completed:start();	
		
		-- Taurox only
		if local_faction == "wh2_dlc17_bst_taurox" then
			in_taurox_rampage_first_battle:start();
			in_taurox_rampage_first_threshold:start();
			in_taurox_rampage_momentum_lost:start();
			in_taurox_rampage_over:start();
			in_taurox_rampage_success:start();
		end

	end


	if not local_faction:is_allowed_to_capture_territory() then
		-- horde-only
		in_horde_growth:start();
	else
		-- non-horde-only
		in_settlement_climate:start();
		in_building_construction:start();
		in_hordes:start();
		in_enemy_port:start();
		in_resources:start();
		in_enemy_province_capital:start();
		in_buildings_damaged:start();
		in_player_besieged:start();
		in_enemy_threaten_settlement:start();
		
		-- public order
		in_public_order:start();
		in_revolt_imminent:start();
		
		-- don't start this advice for Dwarfs, as the advisor VO is invalid
		if subculture ~= "wh_main_sc_dwf_dwarfs" then
			in_region_rebels:start();
		end;
	end;
	
	-- greenskins
	if subculture == "wh_main_sc_grn_greenskins" then
		in_greenskins_underway_advice:start();
		in_raiding_camp_stance_possible:start();

		-- Waaagh! Advice
		in_wagh_resource_gained:start();	
		in_wagh_trigger:start();
		in_wagh_trigger_reminder:start();
		in_wagh_select:start();
		in_wagh_god_select:start();
		in_wagh_success:start();
		in_wagh_failure:start();
		in_wagh_transported_army:start();


		in_salvage_post_battle:start();
		in_salvage_acquired:start();		
		in_salvage_upgraded:start();

		if local_faction == "wh2_dlc15_grn_broken_axe" then
			-- Grom only
			in_groms_waaagh:start();
			in_food_merchant_first_appears:start();
			in_food_merchant_dilemma:start();
			in_groms_cauldron_panel_open:start();
			in_groms_cauldron_ingredient:start();
			in_groms_cauldron_recipe:start();
		end
	end

	-- wood elves
	if subculture == "wh_dlc05_sc_wef_wood_elves" then
		in_worldroots:start();
		in_worldroots_pacification:start();
		in_worldroots_markers:start();
		in_worldroots_button:start();
		in_worldroots_teleport:start();
		in_worldroots_amber:start();
		in_worldroots_rebirth:start();
		in_worldroots_invasions:start();
		in_elven_council:start();
		in_elven_halls:start();
		in_asrai_lookouts:start();
		in_spites:start();
		in_wef_final_battle:start();
		in_sword_of_khaine_available:start();
		in_sword_of_khaine_player_claimed:start();
		in_sword_of_khaine_ai_claimed:start();
		in_sword_of_khaine_stuck:start();
		in_sword_of_khaine_returned:start();
		in_sword_of_khaine_dilemma:start();
		if local_faction == "wh2_dlc16_wef_sisters_of_twilight" then
			in_forge_of_daith:start();
		end
		--aspect advice, wild spirits advice, and skip the racial wood elves advice
		if local_faction == "wh2_dlc16_wef_drycha" then
			in_aspects:start();
			in_wild_spirits:start();
		else 
			in_wood_elves_racial_advice:start();
		end
		--aspects advice
		if local_faction == "wh_dlc05_wef_argwylon" then			
			in_aspects:start();
		end
	end;
	
	-- bretonnians
	if subculture == "wh_main_sc_brt_bretonnia" then
		in_peasant_recruited:start();
		in_peasant_negative:start();
		in_peasant_positive:start();
		in_add_blessing_lady:start();
		in_remove_blessing_lady:start();
		in_first_chivalry_gained:start();
		in_first_chivalry_lost:start();
		in_chivalry_negative:start();
		in_chivalry_level_down:start();
		in_green_knight_intro:start();
		in_green_knight_available:start();
		in_green_knight_summon:start();
		in_green_knight_fade:start();
		
		if local_faction ~= "wh2_dlc14_brt_chevaliers_de_lyonesse" then
			in_chivalry_level_up:start();
			in_errantry_war_dilemma:start();
		else
			in_chivalry_level_up_repanse:start();
			in_errantry_war_dilemma_repanse:start();
			in_desert_thirst:start();
		end

		in_brt_racial_advice:start();
		in_bretonnian_vows_button_clicked:start();
		in_bretonnian_vows_knights_vow_completed:start();
		in_bretonnian_vows_questing_vow_completed:start();
		in_bretonnian_vows_grail_vow_completed:start();
	else
		in_bretonnia:start();
	end;
	
	-- WH2
	
	-- High Elves
	if subculture == "wh2_main_sc_hef_high_elves" then
		in_hef_racial_advice:start();
		in_hef_influence_advice:start();
		in_hef_intrigue_at_the_court_advice:start();
		in_sword_of_khaine_available:start();
		in_sword_of_khaine_player_claimed:start();
		in_sword_of_khaine_ai_claimed:start();
		in_sword_of_khaine_stuck:start();
		in_sword_of_khaine_returned:start();
		in_sword_of_khaine_dilemma:start();
	
		in_rites:start();
		
		if local_faction_name == "wh2_main_hef_nagarythe" then
			in_assassination_targets_first_targets:start();
			in_assassination_targets_first_kill:start();
			in_assassination_targets_kill_all_targets:start();
			in_assassination_targets_new_targets:start();
		elseif local_faction_name == "wh2_main_hef_avelorn" then
			in_power_of_nature:start();
			in_protector_of_ulthuan_inner_gained:start();
			in_protector_of_ulthuan_inner_lost:start();
			in_protector_of_ulthuan_unity:start();
			in_protector_of_ulthuan_outer_lost:start();
			in_mortal_worlds_torment_stage_one:start();
			in_mortal_worlds_torment_stage_two:start();
			in_mortal_worlds_torment_stage_three:start();
		elseif local_faction == "wh2_dlc15_hef_imrik" then
			in_imrik_dragon_spawn:start();
			in_imrik_dragon_enter:start();
			in_imrik_dragon_quest_trigger:start();
			in_imrik_dragon_quest_success_one:start();
			in_imrik_dragon_quest_success_two:start();
			in_imrik_dragon_quest_success_five:start();
			in_imrik_dragon_dilemma_non_quest:start();
			in_imrik_dragon_encounter_generic:start();
		elseif local_faction == "wh2_main_hef_yvresse" then
			in_mists_of_yvresse_unlocked:start();
			in_mists_of_yvresse_activated:start();
			in_yvresse_defence_introduction:start();
			in_yvresse_defence_reminder:start();
			in_yvresse_defence_increased_1:start();
			in_yvresse_defence_increased_2:start();
			in_yvresse_defence_increased_3:start();
			in_athel_tamarha_panel_open:start();
			in_athel_tamarha_mistwalker:start();
			in_athel_tamarha_prisoner:start();
			in_athel_tamarha_prison_action:start();
			in_athel_tamarha_upgrade:start();
			in_yvresse_reminder:start()
		end;
	else
		-- anyone but High Elves
		in_high_elves:start();
	end;
	
	local start_loyalty_interventions = false;
	
	-- Dark Elves
	if subculture == "wh2_main_sc_def_dark_elves" then
		in_def_racial_advice:start();
		in_def_black_arks:start();
		in_sword_of_khaine_available:start();
		in_sword_of_khaine_player_claimed:start();
		in_sword_of_khaine_ai_claimed:start();
		in_sword_of_khaine_stuck:start();
		in_sword_of_khaine_returned:start();
		in_sword_of_khaine_dilemma:start();
	
		in_rites:start();
		
		if local_faction_name == "wh2_main_def_har_ganeth" then
			in_death_night_turn_one:start();
			in_death_night_respected:start();
			in_death_night_depleted:start();
			in_death_night_ready:start();
			in_death_night_morathi:start();
			in_death_night_alarielle:start();
			in_blood_voyage_spawned:start();
			in_blood_voyage_destroyed:start();
		elseif local_faction == "wh2_main_def_hag_graef" then
			in_possession_start:start();	
			in_possession_elixir:start();	
			in_possession_full_control:start();	
			in_possession_full_possession:start();	
			in_possession_5:start();	
			in_whispers_issued:start();	
			in_whispers_succeeded:start();	
			in_malekith_favour:start();	
			in_malus_scrolls_early:start();	
			in_malus_scrolls_mid:start();	
		elseif local_faction == "wh2_twa03_def_rakarth" then
			in_rakarth_monster_pen:start();	
			in_rakarth_raiding:start();	
			in_rakarth_settlements:start();	
			in_rakarth_rite:start()
		end;
		
		start_loyalty_interventions = true;
	else
		-- anyone but Dark Elves
		in_dark_elves:start();
		in_black_arks:start();
	end;
		
	
	-- Lizardmen
	if subculture == "wh2_main_sc_lzd_lizardmen" then
		in_lzd_racial_advice:start();
		in_lzd_astromancy_advice:start();

		--anyone-but-Nakai
		if local_faction_name ~= "wh2_dlc13_lzd_spirits_of_the_jungle" then
			in_lzd_geomantic_web_advice:start();
		else
			-- Defence of hte Great Plan
			in_defence_of_the_great_plan_first_settlement_victory:start();
			in_defence_of_the_great_plan_first_time_gifting:start();
			in_defence_of_the_great_plan_open_panel:start();
			in_defence_of_the_great_plan_5_temples:start();
			in_defence_of_the_great_plan_temple_unit_available:start();
			in_defence_of_the_great_plan_1_god_complete:start();
			in_defence_of_the_great_plan_2_gods_complete:start();
			in_defence_of_the_great_plan_3_gods_complete:start();
			--Jungle Nexus
			in_jungle_nexus:start();
			--Warmblood Invaders

			--Final Battle
		end;
	
		in_rites:start();
		
		if local_faction_name == "wh2_dlc12_lzd_cult_of_sotek" then
			in_sacrifices_to_sotek_post_battle_option:start();
			in_sacrifices_to_sotek_pooled_increase:start();
			in_sacrifices_to_sotek_sacrifice_ready:start();
			in_sacrifices_to_sotek_sotek_available:start();
			in_sacrifices_to_sotek_unlocked_tier_2:start();
			in_sacrifices_to_sotek_unlocked_tier_3:start();
			in_prophecy_turn_one:start();
			in_prophecy_stage_1_completed:start();
			in_prophecy_stage_2_completed:start();
			in_prophecy_stage_3_completed:start();
		end;
		
		if local_faction == "wh2_dlc17_lzd_oxyotl" then
			in_threat_map_first_mission_complete:start();
			in_threat_map_panel_open_3:start();
			in_threat_map_panel_open_2:start();
			in_threat_map_panel_open_1:start();
			in_threat_map_first_mission_issued:start();
			in_silent_sanctums_constructed:start();
			in_silent_sanctums_point_gained:start();
		end

	else
		-- anyone but Lizardmen
		in_lizardmen:start();
	end;
	
	-- Skaven
	if subculture == "wh2_main_sc_skv_skaven" then
		in_skv_racial_advice:start();
		in_skv_skaven_underworld_advice:start();
		in_skv_skaven_food_advice:start();
		in_skv_stalking_advice:start();
		in_skv_skaven_corruption:start();
		in_rite_pestilent_scheme:start();
		in_rite_doom:start();
		in_skv_menace_below:start();
		
		in_under_empire_post_settlement_battle:start();
		in_under_empire_player_establishes:start();
		in_under_empire_building_completed:start();
		in_under_empire_player_discovered:start();
		in_under_empire_doomsphere_started:start();
		in_under_empire_doomsphere_completed:start();
		in_under_empire_player_war_camp_completed:start();
		in_under_empire_agent_in_region:start();
		
		
		in_rites:start();
		
		if local_faction_name == "wh2_main_skv_clan_skryre" then
			in_ikit_workshop_turn_one:start();
			in_ikit_workshop_button_clicked:start();
			in_ikit_workshop_panel_opened:start();
			in_ikit_workshop_upgrade_ready:start();
			in_ikit_workshop_completed_2_upgrades:start();
			in_ikit_workshop_first_victory:start();
			in_ikit_workshop_nuke_purchase_available:start();
			in_ikit_workshop_completed_5_upgrades:start();
			in_ikit_workshop_upgraded_workshop:start();
			in_ikit_workshop_prebattle_with_nuke:start();
			in_ikit_workshop_10_warp_fuel:start();
		elseif local_faction == "wh2_main_skv_clan_eshin" then
			in_shadowy_dealings_open_panel:start();
			in_shadowy_dealings_clan_contracts:start();
			in_shadowy_dealings_action_completed:start();
		elseif local_faction == "wh2_main_skv_clan_moulder" then
			in_flesh_lab_growth_juice:start();
			in_flesh_lab_monster_pack:start();
			in_flesh_lab_augment_unlocked:start();
			in_flesh_lab_upgrades:start();
		end;

		if local_faction ~= "wh2_main_skv_clan_eshin" then
			start_loyalty_interventions = true;
		end
	else
		-- anyone but Skaven
		in_skaven:start();
		in_skaven_underworld:start();
		
		in_under_empire_ai_war_camp_completed:start();
		in_under_empire_ai_doomsphere_completed:start();		
		in_under_empire_ai_doomsphere_completed_followup:start();		
	end;
	
	-- Tomb Kings
	if subculture == "wh2_dlc09_sc_tmb_tomb_kings" then
		in_tmb_racial_advice:start();
	else
		-- anyone but Tomb Kings
		in_tomb_kings:start();
	end;

	-- Vampire Coast
	if subculture == "wh2_dlc11_sc_cst_vampire_coast" then
		in_treasure_map_mission:start();
		in_full_treasure_map_log:start();
		in_first_treasure_map_mission_succeeded:start();
		in_fifth_treasure_map_mission_succeeded:start();
		in_treasure_not_found:start();
		in_player_infamy_grows:start();
		in_player_climbs_infamy_list:start();
		in_player_tops_infamy_list:start();
		in_rogue_army_sighted:start();
		in_pieces_of_eight_tab_opened:start();
		in_first_piece_of_eight_collected:start();
		in_fourth_piece_of_eight_collected:start();
		in_all_pieces_of_eight_collected:start();
		in_post_normal_battle_pirate_loyalty:start();
		in_low_pirate_loyalty:start();
		in_pirate_civil_war:start();
		in_fleet_office:start();
		in_post_siege_battle_pirate_cove:start();
		in_pre_island_battle_options:start();
	else
		-- anyone but Vampire Coast
		in_player_army_near_coast:start();
	end;
	
	-- loyalty interventions - defs and skv
	if start_loyalty_interventions then
		in_loyalty:start();
		in_low_loyalty:start();
		in_civil_war:start();
	end;
	
	-- Gotrek and Felix advice
	if subculture == "wh_main_sc_emp_empire" or subculture == "wh_main_sc_brt_bretonnia" or subculture == "wh_main_sc_dwf_dwarfs" or subculture == "wh_main_sc_teb_teb" then
		in_gotrek_and_felix_pub_built:start();
		in_gotrek_and_felix_dilemma_event:start();
		in_gotrek_and_felix_departed:start();
	end;

	-- WH3
	-- All Daemon Factions
	if subculture == "wh3_main_sc_kho_khorne" or subculture == "wh3_main_sc_nur_nurgle" or subculture == "wh3_main_sc_sla_slaanesh" or subculture == "wh3_main_sc_nur_nurgle" or subculture == "wh3_main_sc_dae_daemons" then
		winds_of_magic_low_reserve:start()
		winds_of_magic_high_reserve:start()
		exalted_greater_daemon:start()
	end
	
	-- Specific Factions
	if subculture == "wh3_main_sc_kho_khorne" then
		khorne_ascendancy:start()
	elseif subculture == "wh3_main_sc_nur_nurgle" then
		nurgle_ascendancy:start()
	elseif subculture == "wh3_main_sc_sla_slaanesh" then
		slaanesh_ascendancy:start()
		slaanesh_resurrect_faction:start()
	elseif subculture == "wh3_main_sc_tze_tzeentch" then
		tzeentch_ascendancy:start()
	elseif subculture == "wh3_main_sc_dae_daemons" then
		daemonic_progression_item:start()
	elseif subculture == "wh3_main_sc_ogr_ogre_kingdoms" then
		ogre_meat_pre_battle:start()
		ogre_contracts:start()
	elseif subculture == "wh3_main_sc_ksl_kislev" then
		low_devotion:start()
		ataman_dilemma:start()
		
		if local_faction_name == "wh3_main_ksl_the_ice_court" or local_faction_name == "wh3_main_ksl_the_great_orthodoxy" then
			motherland_ritual_player:start()
			motherland_ritual_other_player:start()
			motherland_ritual_other_player_followers:start()
		end
	end

	-- WH3: anyone-but
	-- anyone-but-ogres
	if subculture ~= "wh3_main_sc_ogr_ogre_kingdoms" then
		ogre_merc_recruitment:start()
		in_ogres:start()
	end

	-- anyone-but-khorne
	if subculture ~= "wh3_main_sc_kho_khorne" then
		in_khorne:start()
	end

	-- anyone-but-nurgle
	if subculture ~= "wh3_main_sc_nur_nurgle" then
		in_nurgle:start()
	end

	-- anyone-but-tzeentch
	if subculture ~= "wh3_main_sc_tze_tzeentch" then
		in_tzeentch:start()
	end

	-- anyone-but-slaanesh
	if subculture ~= "wh3_main_sc_sla_slaanesh" then
		in_slaanesh:start()
	end

	-- anyone-but-kislev
	if subculture ~= "wh3_main_sc_ksl_kislev" then
		in_kislev:start()
	end

	-- anyone-but-cathay
	if subculture ~= "wh3_main_sc_cth_cathay" then
		in_cathay:start()
	end

	-- TODO: revisit these - state religion no longer exists, can get culture but not reliable
	--[[ corruption advice
	do 
		local state_religion = faction:state_religion();
		
		if state_religion ~= "wh_main_religion_chaos" then
			in_corruption_chaos:start();			
		end;
		
		if state_religion ~= "wh_main_religion_undeath" then
			in_corruption_vampires:start();
		
		end;
		
		if state_religion ~= "wh2_main_religion_skaven" then
			in_corruption_skaven:start();
		end;
		
		if state_religion ~= "wh_main_religion_untainted" and state_religion ~= "wh2_main_religion_skaven" then
			in_corruption_untainted:start();
		end;
	end;]]
end;














---------------------------------------------------------------
--
--	pre field battle options 
--
---------------------------------------------------------------

-- intervention declaration
in_pre_field_battle_options = intervention:new(
	"pre_field_battle_options", 													-- string name
	90, 																			-- cost
	function() in_pre_field_battle_options_advice_trigger() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);


in_pre_field_battle_options:add_advice_key_precondition("war.camp.advice.pre_battle_options.001");
in_pre_field_battle_options:add_advice_key_precondition("war.camp.advice.pre_battle_options.002");
in_pre_field_battle_options:add_advice_key_precondition("war.camp.advice.pre_battle_options.003");
in_pre_field_battle_options:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_pre_field_battle_options:set_player_turn_only(false);
in_pre_field_battle_options:set_wait_for_battle_complete(false);


in_pre_field_battle_options:add_trigger_condition(
	"ScriptEventPreBattlePanelOpenedField",
	function(context)
		local player_strength = 0;
		local pb = cm:model():pending_battle();
		
		-- determine player's relative strength in this battle
		if cm:pending_battle_cache_faction_is_attacker(cm:get_local_faction_name()) then
			player_strength = pb:attacker_strength();
		else
			player_strength = pb:defender_strength();
		end;
		
		-- return true if the player has a reasonable chance of victory, or if it's not the player's turn
		return player_strength >= 50 or not cm:is_local_players_turn();
	end
);


in_pre_field_battle_options:set_completion_callback(
	function()
		cm:remove_callback("in_pre_field_battle_options_listener");
	end
);


function in_pre_field_battle_options_advice_trigger()
	local listener_str = "in_pre_field_battle_options";
	
	-- if the player closes panel immediately then just complete
	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function()
			cm:remove_callback(listener_str);
			in_pre_field_battle_options:complete();
		end,
		false
	);
	
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_pre_field_battle_options_advice_play();
		end,
		0.5,
		listener_str
	);
end;


function in_pre_field_battle_options_advice_play()
	in_pre_field_battle_options:play_advice_for_intervention(
		-- Battle is upon us! Study your options carefully, the enemy are close - blood will be spilt. 
		"war.camp.advice.pre_battle_options.001",
		{
			"war.camp.advice.pre_battle_options.info_001",
			"war.camp.advice.pre_battle_options.info_002",
			"war.camp.advice.pre_battle_options.info_003",
			"war.camp.advice.pre_battle_options.info_004"
		}
	);
	
	-- highlight battle options if we should
	start_highlight_normal_pre_field_battle_options(in_pre_field_battle_options, "in_pre_field_battle_options_listener");
end;
















---------------------------------------------------------------
--
--	pre field battle options victory unsure
--
---------------------------------------------------------------

-- intervention declaration
in_pre_field_battle_options_victory_unsure = intervention:new(
	"pre_field_battle_options_victory_unsure", 													-- string name
	90, 																						-- cost
	function() in_pre_field_battle_options_victory_unsure_advice_trigger() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 																-- show debug output
);

in_pre_field_battle_options_victory_unsure:add_advice_key_precondition("war.camp.advice.pre_battle_options.002");
in_pre_field_battle_options_victory_unsure:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_pre_field_battle_options_victory_unsure:set_wait_for_battle_complete(false);


in_pre_field_battle_options_victory_unsure:add_trigger_condition(
	"ScriptEventPreBattlePanelOpenedField",
	function(context)
		local player_strength = 0;
		local pb = cm:model():pending_battle();
		
		-- determine player's relative strength in this battle
		if cm:pending_battle_cache_faction_is_attacker(cm:get_local_faction_name()) then
			player_strength = pb:attacker_strength();
		else
			player_strength = pb:defender_strength();
		end;
		
		-- return true if victory is unsure and it's the player's turn
		return player_strength < 50 and player_strength >= 30 and cm:is_local_players_turn();
	end
);


in_pre_field_battle_options_victory_unsure:set_completion_callback(
	function()
		cm:remove_callback("in_pre_field_battle_options_victory_unsure_play");
	end
);


function in_pre_field_battle_options_victory_unsure_advice_trigger()
	local listener_str = "in_pre_field_battle_options_victory_unsure";
	
	-- if the player closes panel immediately then just complete
	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function()
			cm:remove_callback(listener_str);
			in_pre_field_battle_options_victory_unsure:complete();
		end,
		false
	);
	
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_pre_field_battle_options_victory_unsure_advice_play();
		end,
		0.5,
		listener_str
	);
end;


function in_pre_field_battle_options_victory_unsure_advice_play()
	
	in_pre_field_battle_options_victory_unsure:play_advice_for_intervention(
		-- Battle is upon us, my Lord! The enemy mass in great strength, see for yourself. You may wish to consider whether an attack would be wise.
		"war.camp.advice.pre_battle_options.002",
		{
			"war.camp.advice.pre_battle_options.info_001",
			"war.camp.advice.pre_battle_options.info_002",
			"war.camp.advice.pre_battle_options.info_005",
			"war.camp.advice.pre_battle_options.info_004"
		}
	);
	
	-- highlight battle options if we should
	start_highlight_normal_pre_field_battle_options(in_pre_field_battle_options_victory_unsure, "in_pre_field_battle_options_victory_unsure_play");
end;


















---------------------------------------------------------------
--
--	pre field battle options victory unlikely
--
---------------------------------------------------------------

-- intervention declaration
in_pre_field_battle_options_victory_unlikely = intervention:new(
	"pre_field_battle_options_victory_unlikely", 												-- string name
	90, 																						-- cost
	function() in_pre_field_battle_options_victory_unlikely_advice_trigger() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 																-- show debug output
);

in_pre_field_battle_options_victory_unlikely:add_advice_key_precondition("wh2.camp.advice.outmatched.001");
in_pre_field_battle_options_victory_unlikely:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_pre_field_battle_options_victory_unlikely:set_wait_for_battle_complete(false);


in_pre_field_battle_options_victory_unlikely:add_trigger_condition(
	"ScriptEventPreBattlePanelOpenedField",
	function(context)
		out("===== in_pre_field_battle_options_victory_unlikely responding to ScriptEventPreBattlePanelOpenedField");	
	
		local player_strength = 0;
		local pb = cm:model():pending_battle();
		
		-- determine player's relative strength in this battle
		if cm:pending_battle_cache_faction_is_attacker(cm:get_local_faction_name()) then
			player_strength = pb:attacker_strength();
		else
			player_strength = pb:defender_strength();
		end;
		
		out("===== in_pre_field_battle_options_victory_unlikely trigger processing, player_strength is " .. tostring(player_strength));
		
		-- return true if victory is unlikely and it's the player's turn
		return player_strength < 30 and cm:is_local_players_turn();
	end
);


in_pre_field_battle_options_victory_unlikely:set_completion_callback(
	function()
		cm:remove_callback("in_pre_field_battle_options_victory_unlikely_play");
	end
);


function in_pre_field_battle_options_victory_unlikely_advice_trigger()
	local listener_str = "in_pre_field_battle_options_victory_unlikely";
	
	-- if the player closes panel immediately then just complete
	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function()
			cm:remove_callback(listener_str);
			in_pre_field_battle_options_victory_unlikely:complete();
		end,
		false
	);
	
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_pre_field_battle_options_victory_unlikely_advice_play();
		end,
		0.5,
		listener_str
	);
end;


function in_pre_field_battle_options_victory_unlikely_advice_play()
	
	in_pre_field_battle_options_victory_unlikely:play_advice_for_intervention(
		-- The enemy mass in considerable force, my Lord! It may be wise to consider a retreat against such numbers.
		"wh2.camp.advice.outmatched.001",
		{
			"war.camp.advice.pre_battle_options.info_001",
			"war.camp.advice.pre_battle_options.info_002",
			"war.camp.advice.pre_battle_options.info_005",
			"war.camp.advice.pre_battle_options.info_004"
		}
	);
	
	-- highlight battle options if we should
	start_highlight_normal_pre_field_battle_options(in_pre_field_battle_options_victory_unlikely, "in_pre_field_battle_options_victory_unlikely_play");
end;









	
	
	
	
	
---------------------------------------------------------------
--
--	helper functions for pre field battle options interventions
--	(see above)
--
---------------------------------------------------------------	
	
function start_highlight_normal_pre_field_battle_options(intervention, listener_name)
	
	-- also complete when the pre-battle panel gets closed
	core:add_listener(
		"pre_field_battle_options_advice",
		"ScriptEventPreBattlePanelClosed",
		true,
		function(context)
			highlight_normal_pre_field_battle_options(intervention, false);
			core:remove_listener(listener_name);
			intervention:cancel_play_advice_for_intervention();
			
			-- complete intervention if it isn't already
			if intervention.is_active then
				intervention:complete();
			end;
		end,
		false
	);
	
	-- highlight battle options if advice is set to "high"
	if core:is_advice_level_high() then
		cm:callback(
			function() 
				highlight_normal_pre_field_battle_options(intervention, true) 
			end, 
			0.5, 
			listener_name
		);
		
		-- stop highlight if the character details panel is opened
		core:add_listener(
			listener_name,
			"PanelOpenedCampaign",
			function(context) return context.string == "character_details_panel" end,
			function(context)
				highlight_normal_pre_field_battle_options(intervention, false)
			end,
			true
		);
		
		-- start highlight if the character details panel is closed
		core:add_listener(
			listener_name,
			"PanelClosedCampaign",
			function(context) return context.string == "character_details_panel" end,
			function(context)
				cm:callback(function() highlight_normal_pre_field_battle_options(intervention, true) end, 0.5, listener_name);
			end,
			true
		);
	end;
end;


function highlight_normal_pre_field_battle_options(intervention, value)
	if value then	
		-- highlighting
		if intervention.options_highlighted then
			return;
		end;
		
		intervention.options_highlighted = true;
		
		local uic_button_set = find_uicomponent(core:get_ui_root(), "button_set_attack");
		
		if not uic_button_set then
			return false;
		end;
		
		highlight_all_visible_children(uic_button_set, 5);
		
		-- disable spell browser
		uim:override("spell_browser"):set_allowed(false);
		
	else	
		-- unhighlighting
		if not intervention.options_highlighted then
			return;
		end;
		
		intervention.options_highlighted = false;
		
		unhighlight_all_visible_children();
		
		-- enable spell browser
		uim:override("spell_browser"):set_allowed(true);
	end;
end;











---------------------------------------------------------------
--
--	autoresolving
--
---------------------------------------------------------------

-- intervention declaration
in_autoresolving = intervention:new(
	"autoresolving", 																		-- string name
	90, 																					-- cost
	function() in_autoresolving_advice_trigger() end,										-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);

in_autoresolving:add_advice_key_precondition("war.camp.advice.autoresolving.001");
in_autoresolving:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_autoresolving:set_player_turn_only(false);
in_autoresolving:set_wait_for_battle_complete(false);
in_autoresolving:set_reduce_pause_before_triggering(true);		-- do this so we get no grace period
in_autoresolving:give_priority_to_intervention("pre_field_battle_options");

in_autoresolving:add_precondition(function() return not uim:get_interaction_monitor_state("autoresolve_selected") end);

in_autoresolving:add_trigger_condition(
	"ScriptEventTriggerAutoresolvingAdvice",
	function()
		core:remove_listener("autoresolve_advice");
	
		-- only trigger if the autoresolve button is enabled
		local uic_deployment = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "regular_deployment");
		if uic_deployment then
			-- siege autoresolve button
			local uic_button_autoresolve_siege = find_uicomponent(uic_deployment, "button_set_siege", "button_autoresolve");
			if uic_button_autoresolve_siege and uic_button_autoresolve_siege:Visible(true) and uic_button_autoresolve_siege:CurrentState() ~= "inactive" then
				return true;
			end;
			
			-- field autoresolve button
			local uic_button_autoresolve_attack = find_uicomponent(uic_deployment, "button_set_attack", "button_autoresolve");
			if uic_button_autoresolve_attack and uic_button_autoresolve_attack:Visible(true) and uic_button_autoresolve_attack:CurrentState() ~= "inactive" then
				return true;
			end;
		end;

	end
);

in_autoresolving:add_trigger_condition(
	"ScriptEventPreBattlePanelOpenedField",
	function()
		if uim:get_interaction_monitor_state("autoresolve_selected") then
			out("\tstopping in_autoresolving as autoresolve option has previously been selected");
			in_autoresolving:stop();
			return false;
		end;
		
		-- a bit hacky - we may be able to trigger, but we have to wait for Pre Battle Panel to get fully on-screen so we can test the state of the autoresolve button.
		-- fire another event which this intervention picks up on (see script above).
		cm:callback(function() core:trigger_event("ScriptEventTriggerAutoresolvingAdvice") end, 0.5, "autoresolve_advice");
		
		-- listen for the panel closing, indicating that an option has already been chosen
		core:add_listener(
			"autoresolve_advice",
			"PanelClosedCampaign",
			function(context) return context.string == "popup_pre_battle" end,
			function()
				cm:remove_callback("autoresolve_advice");
			end,
			false
		);
		
		return false;
	end
);


function in_autoresolving_advice_trigger()
	local listener_str = "in_autoresolving";

	-- if the player closes the pre-battle panel immediately then just complete
	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function()
			cm:remove_callback(listener_str);
			in_autoresolving:complete();
		end,
		false
	);
	
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_autoresolving_advice_play();
		end,
		1,
		listener_str
	);
end;


function in_autoresolving_advice_play()

	in_autoresolving:play_advice_for_intervention(
		-- You need not grow weary of battle, my lord. You do not need to oversee every skirmish in person - there are many gods of war on this world and they will take an interest whether you do so or not...
		"war.camp.advice.autoresolving.001",
		{
			"war.camp.advice.autoresolving.info_001",
			"war.camp.advice.autoresolving.info_002",
			"war.camp.advice.autoresolving.info_003"
		}
	);
end;














---------------------------------------------------------------
--
--	pre minor settlement battle options
--
---------------------------------------------------------------

-- intervention declaration
in_pre_minor_settlement_battle_options = intervention:new(
	"pre_minor_settlement_battle_options", 													-- string name
	90, 																					-- cost
	function() in_pre_minor_settlement_battle_options_advice_trigger() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);


in_pre_minor_settlement_battle_options:add_advice_key_precondition("war.camp.advice.pre_battle_options.003");
in_pre_minor_settlement_battle_options:add_advice_key_precondition("war.camp.advice.siege_weapons.001");
in_pre_minor_settlement_battle_options:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_pre_minor_settlement_battle_options:set_player_turn_only(false);
in_pre_minor_settlement_battle_options:set_wait_for_battle_complete(false);


in_pre_minor_settlement_battle_options:add_trigger_condition(
	"ScriptEventPreBattlePanelOpenedMinorSettlement",
	true
);


function in_pre_minor_settlement_battle_options_advice_trigger()
	local listener_str = "in_pre_minor_settlement_battle_options";

	-- if the player closes pre-battle panel immediately then just complete
	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function()
			cm:remove_callback(listener_str) 
			in_pre_minor_settlement_battle_options:complete();
		end,
		false
	);
	
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_pre_minor_settlement_battle_options_advice_play();
		end,
		1,
		listener_str
	);
end;


function in_pre_minor_settlement_battle_options_advice_play()

	in_pre_minor_settlement_battle_options:play_advice_for_intervention(
		-- The city has been reached and your warriors are prepared for battle, mighty Lord. Study your options, nevertheless - encircling the enemy and starving them out may be the wisest course of action.
		"war.camp.advice.pre_battle_options.003",
		{
			"war.camp.advice.pre_battle_options.info_001",
			"war.camp.advice.pre_battle_options.info_002",
			"war.camp.advice.pre_battle_options.info_003",
			"war.camp.advice.pre_battle_options.info_004"
		}
	);
	
	-- also complete when the pre-battle panel gets closed
	core:add_listener(
		"pre_minor_settlement_battle_options_advice",
		"ScriptEventPreBattlePanelClosed",
		true,
		function(context)
			in_pre_minor_settlement_battle_options:cancel_play_advice_for_intervention();
			
			-- complete intervention if it isn't already
			if in_pre_minor_settlement_battle_options.is_active then
				in_pre_minor_settlement_battle_options:complete();
			end;
		end,
		false
	);
end;












---------------------------------------------------------------
--
--	post normal battle victory options
--
---------------------------------------------------------------

-- intervention declaration
in_post_normal_battle_victory_options = intervention:new(
	"post_normal_battle_victory_options", 										-- string name
	90, 																		-- cost
	function() in_post_normal_battle_victory_options_advice_trigger() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);


in_post_normal_battle_victory_options:add_advice_key_precondition("war.camp.advice.post_battle_options.001");
in_post_normal_battle_victory_options:add_advice_key_precondition("war.camp.advice.post_battle_options.002");
in_post_normal_battle_victory_options:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_post_normal_battle_victory_options:set_player_turn_only(false);
in_post_normal_battle_victory_options:set_wait_for_battle_complete(false);

in_post_normal_battle_victory_options:set_completion_callback(
	function()
		cm:remove_callback("in_post_normal_battle_victory_options_advice_play");
	end
);

in_post_normal_battle_victory_options:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context) return context.string == "popup_battle_results" and not cm:model():pending_battle():has_contested_garrison() and cm:pending_battle_cache_human_victory(); end
);


function in_post_normal_battle_victory_options_advice_trigger()	
	if cm:whose_turn_is_it_single():subculture() == "wh_dlc08_sc_nor_norsca" then
		in_post_normal_battle_victory_options:complete();
		return;
	end
	
	local listener_str = "in_post_normal_battle_victory_options";

	-- if the player closes post-battle options immediately then just complete
	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function() 
			cm:remove_callback(listener_str);
			in_post_normal_battle_victory_options:complete();
		end,
		false
	);
	
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_post_normal_battle_victory_options_advice_play();
		end,
		1,
		listener_str
	);
end;


function in_post_normal_battle_victory_options_advice_play()
	in_post_normal_battle_victory_options:play_advice_for_intervention(
		-- Victory is yours, my Lord! But what about the fate of those captured in battle? It can be beneficial to hold them, but sometimes leniency or brutality can be worth more.
		"war.camp.advice.post_battle_options.001",											-- advice key
		{																					-- infotext
			"war.camp.advice.post_battle_options.info_001",
			"war.camp.advice.post_battle_options.info_002",
			"war.camp.advice.post_battle_options.info_003"
		}
	);
	
	-- also complete when the post-battle panel gets closed
	core:add_listener(
		"post_normal_battle_victory_options_advice",
		"ScriptEventPostBattlePanelClosed",
		true,
		function(context)
			highlight_post_normal_battle_victory_options(in_post_normal_battle_victory_options, false);
			in_post_normal_battle_victory_options:cancel_play_advice_for_intervention();
			cm:remove_callback("in_post_normal_battle_victory_options_advice_play");
			
			if in_post_normal_battle_victory_options.is_active then
				in_post_normal_battle_victory_options:complete();
			end;
		end,
		false
	);
	
	-- highlight battle options if advice is set to "high"
	if core:is_advice_level_high() then
		cm:callback(function() highlight_post_normal_battle_victory_options(in_post_normal_battle_victory_options, true) end, 3, "in_post_normal_battle_victory_options_advice_play");
	end;
end;


function highlight_post_normal_battle_victory_options(intervention, value)
	if value then
		-- highlighting
		if intervention.options_highlighted then
			return;
		end;
		
		-- check that the component is on-screen and not animating
		local uic = find_uicomponent(core:get_ui_root(), "popup_battle_results", "mid");
		
		if uic then
			if not (uic:Visible() and is_fully_onscreen(uic) and uic:CurrentAnimationId() == "") then
				-- component has not come to rest on-screen, defer this call
				cm:callback(function() highlight_post_normal_battle_victory_options(intervention, value) end, 0.2, "in_post_normal_battle_victory_options_advice_play");
				return;
			end;
		end;
		
		intervention.options_highlighted = true;
		
		local uic_button_set = find_uicomponent(core:get_ui_root(), "button_set_win");
			
		if not uic_button_set then
			script_error("ERROR: highlight_post_normal_battle_victory_options() could not find uic_button_set, how can this be?");
			return false;
		end;
		
		highlight_all_visible_children(uic_button_set, 5);
		
		-- disable spell browser
		uim:override("spell_browser"):set_allowed(false);
		
	else
		-- unhighlighting
		if not intervention.options_highlighted then
			return;
		end;
		
		intervention.options_highlighted = false;
		
		unhighlight_all_visible_children();
		
		-- enable spell browser
		uim:override("spell_browser"):set_allowed(true);
	end;	
end;



---------------------------------------------------------------
--
--	post battle defeat
--
---------------------------------------------------------------

-- intervention declaration
in_post_battle_defeat_options = intervention:new(
	"post_battle_defeat_options", 												-- string name
	90, 																		-- cost
	function() in_post_battle_defeat_options_advice_trigger() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);


in_post_battle_defeat_options:add_advice_key_precondition("war.camp.advice.post_battle_defeat.001");
in_post_battle_defeat_options:add_advice_key_precondition("war.camp.advice.post_battle_options.001");
in_post_battle_defeat_options:add_advice_key_precondition("war.camp.advice.post_battle_options.002");
in_post_battle_defeat_options:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_post_battle_defeat_options:set_player_turn_only(false);
in_post_battle_defeat_options:set_wait_for_battle_complete(false);

in_post_battle_defeat_options:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context) return context.string == "popup_battle_results" and not cm:model():pending_battle():has_contested_garrison() and not cm:pending_battle_cache_human_victory(); end
);


function in_post_battle_defeat_options_advice_trigger()
	local listener_str = "in_post_battle_defeat_options";

	-- if the player closes post-battle options immediately then just complete
	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function()
			in_post_battle_defeat_options:complete();
			cm:remove_callback(listener_str) 
		end,
		false
	);
		
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_post_battle_defeat_options_advice_play();
		end,
		1,
		listener_str
	);
end;


function in_post_battle_defeat_options_advice_play()

	in_post_battle_defeat_options:play_advice_for_intervention(
		-- Your forces meet with defeat! Gather the survivors, rebuild your strength and take the fight back to the enemy!
		"war.camp.advice.post_battle_defeat.001"											-- advice key
	);
	
	-- also complete when the post-battle panel gets closed
	core:add_listener(
		"post_battle_defeat_options_advice",
		"ScriptEventPostBattlePanelClosed",
		true,
		function(context)
			in_post_battle_defeat_options:cancel_play_advice_for_intervention();
			
			if in_post_battle_defeat_options.is_active then
				in_post_battle_defeat_options:complete();
			end;
		end,
		false
	);
end;














---------------------------------------------------------------
--
--	post siege battle victory options
--
---------------------------------------------------------------

-- intervention declaration
in_post_siege_battle_victory_options = intervention:new(
	"post_siege_battle_victory_options", 										-- string name
	90, 																		-- cost
	function() in_post_siege_battle_victory_options_advice_trigger() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);


in_post_siege_battle_victory_options:add_advice_key_precondition("war.camp.advice.post_battle_options.002");
in_post_siege_battle_victory_options:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_post_siege_battle_victory_options:set_player_turn_only(false);
in_post_siege_battle_victory_options:set_wait_for_battle_complete(false);

in_post_siege_battle_victory_options:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context) return context.string == "popup_battle_results" and cm:model():pending_battle():has_contested_garrison() and cm:pending_battle_cache_human_victory(); end
);


function in_post_siege_battle_victory_options_advice_trigger()	
	core:add_listener(
		"in_post_siege_battle_victory_options",
		"PanelOpenedCampaign",
		function(context) return context.string == "settlement_captured" end,
		function() in_post_siege_battle_victory_options_advice_play() end,
		false	
	);
end;


function in_post_siege_battle_victory_options_advice_play()
	in_post_siege_battle_victory_options:play_advice_for_intervention(
		-- At last, the defences have fallen, my Lord. The fate of those that remain is yours to determine.
		"war.camp.advice.post_battle_options.002",											-- advice key
		{																					-- infotext
			"war.camp.advice.post_battle_options.info_001",
			"war.camp.advice.post_battle_options.info_004",
			"war.camp.advice.post_battle_options.info_003"
		}
	);
end;








---------------------------------------------------------------
--
--	ambush defence
--
---------------------------------------------------------------

-- intervention declaration
in_ambush_defence = intervention:new(
	"ambush_defence", 																-- string name
	60, 																			-- cost
	function() in_ambush_defence_advice_trigger() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);


in_ambush_defence:add_advice_key_precondition("war.camp.advice.ambushes.001");
in_ambush_defence:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_ambush_defence:set_player_turn_only(false);
in_ambush_defence:set_wait_for_battle_complete(false);
in_ambush_defence:set_must_trigger(true);

in_ambush_defence:add_trigger_condition(
	"ScriptEventPreBattlePanelOpenedAmbushPlayerDefender",
	true
);


function in_ambush_defence_advice_trigger()
	local listener_str = "in_ambush_defence";
	
	-- if the player closes panel immediately then just complete
	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function()
			cm:remove_callback(listener_str);
			in_ambush_defence:complete();
		end,
		false
	);
	
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_ambush_defence_advice_play();
		end,
		0.5,
		listener_str
	);
end;


function in_ambush_defence_advice_play()
	in_ambush_defence:play_advice_for_intervention(
		-- An ambush, my lord! Ready your warriors for battle!
		"war.camp.advice.ambushes.001",
		{
			"war.camp.advice.ambushes.info_001",
			"war.camp.advice.ambushes.info_002",
			"war.camp.advice.ambushes.info_003",
			"war.camp.advice.ambushes.info_004"			
		}
	);
end;





























---------------------------------------------------------------
--
--	commandment warning
--
---------------------------------------------------------------

-- intervention declaration
in_commandment_warning = intervention:new(
	"commandment_warning", 													-- string name
	90, 																	-- cost
	function() in_commandment_warning_advice_trigger() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_commandment_warning:add_advice_key_precondition("war.camp.advice.commandments.001");
in_commandment_warning:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_commandment_warning:set_reduce_pause_before_triggering(true);

in_commandment_warning:add_trigger_condition(
	"ScriptEventCommandmentWarningIssued",
	true
);


function in_commandment_warning_advice_trigger()
	local listener_str = "in_commandment_warning";
	
	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) 
			return context.string == "end_turn_warning"
		end,
		function()
			out.interventions("Terminating commandment advice as the end_turn_warning panel is being closed");
			in_commandment_warning:complete();
			cm:remove_callback(listener_str) 
		end,
		false
	);
	
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_commandment_warning_advice_play();
		end,
		0.5,
		listener_str
	);
end;


function in_commandment_warning_advice_play()

	in_commandment_warning:play_advice_for_intervention(
		-- Commandments may be issued over territory you rule, my Lord. Make the effort to rouse the populace, so that they may better serve your ends.
		"war.camp.advice.commandments.001",
		{
			"war.camp.advice.commandments.info_001",
			"war.camp.advice.commandments.info_002",
			"war.camp.advice.commandments.info_003"
		}
	);
end;







---------------------------------------------------------------
--
--	war warning
--
---------------------------------------------------------------

-- intervention declaration
in_war_warning = intervention:new(
	"war_warning", 															-- string name
	90, 																	-- cost
	function() in_war_warning_advice_trigger() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_war_warning:add_advice_key_precondition("war.camp.advice.war.002");
in_war_warning:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_war_warning:set_reduce_pause_before_triggering(true);
in_war_warning:set_wait_for_fullscreen_panel_dismissed(false);

in_war_warning:add_trigger_condition(
	"ScriptEventMoveOptionsPanelOpened",
	true
);


function in_war_warning_advice_trigger()
	local listener_str = "in_war_warning";

	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) return context.string == "move_options" end,
		function() 
			cm:remove_callback(listener_str);
			in_war_warning:complete();
		end,
		false
	);
	
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_war_warning_advice_play();
		end,
		0.5
	);
end;


function in_war_warning_advice_play()

	in_war_warning:play_advice_for_intervention(
		-- Such an action would surely lead to war! Proceed only if you desire conflict, my Lord.
		"war.camp.advice.war.002",
		{
			"war.camp.advice.war.info_004",
			"war.camp.advice.war.info_005",
			"war.camp.advice.war.info_006"
		}
	);
end;










---------------------------------------------------------------
--
--	technology warning
--
---------------------------------------------------------------

-- intervention declaration
--[[
in_technology_warning = intervention:new(
	"technology_warning", 													-- string name
	90, 																	-- cost
	function() in_technology_warning_advice_trigger() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_technology_warning:add_advice_key_precondition("war.camp.advice.technologies.001");
in_technology_warning:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_technology_warning:set_reduce_pause_before_triggering(true);


in_technology_warning:add_trigger_condition(
	"ScriptEventTechnologyWarningIssued",
	true
);


function in_technology_warning_advice_trigger()
	local listener_str = "in_technology_warning";

	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) return context.string == "end_turn_warning" end,
		function()
			in_technology_warning:complete();
			cm:remove_callback(listener_str);
		end,
		false
	);
	
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_technology_warning_advice_play();
		end,
		0.5,
		listener_str
	);
end;


function in_technology_warning_advice_play()
	local uic_end_turn_warning = find_uicomponent(core:get_ui_root(), "end_turn_warning");
	
	-- don't proceed if the end turn warning panel is not visible
	if not uic_end_turn_warning:Visible() then
		in_technology_warning:cancel();
		return;
	end;

	-- determine the priority of the end turn warning panel
	local priority = 1000;
	
	if uic_end_turn_warning then
		priority = uic_end_turn_warning:Priority();
	end;
	
	-- set the priority of the advisor to match
	core:cache_and_set_advisor_priority(priority);

	-- You would be advised to seek ways to further your methods of war, my lord. Put your best minds to work improving your knowledge and practises.
	cm:show_advice("war.camp.advice.technology.001", true);
	cm:clear_infotext();
	cm:add_infotext(1, 
		"war.camp.advice.technology.info_001",
		"war.camp.advice.technology.info_002",
		"war.camp.advice.technology.info_003"				
	);
	
	core:add_listener(
		"technology_warning",
		"PanelClosedCampaign",
		function(context) return context.string == "end_turn_warning" end,
		function()
			core:restore_advisor_priority();
			in_technology_warning:complete();
		end,
		false
	);
end;
]]






















---------------------------------------------------------------
--
--	public order
--
---------------------------------------------------------------

-- intervention declaration
in_public_order = intervention:new(
	"public_order", 														-- string name
	50, 																	-- cost
	function() in_public_order_advice_trigger() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);


in_public_order:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_public_order:add_advice_key_precondition("war.camp.advice.public_order.001");
in_public_order:set_turn_countdown_restart(8);

in_public_order:add_trigger_condition(
	"ScriptEventFactionTurnStartLowestPublicOrder",
	function(context)
	
		-- don't proceed if this isn't the player's faction
		if context:faction():name() ~= cm:get_local_faction_name() then
			return;
		end;
	
		-- don't process if we have triggered before and aren't on high advice
		if in_public_order:has_ever_triggered() and not core:is_advice_level_high() then
			return false;
		end;
		
		-- don't process if the revolt imminent advice is enqueued
		if in_revolt_imminent.is_enqueued_for_triggering then
			return false;
		end;
		
		local public_order = context:region():public_order();
		
		-- if the lowest public order is sufficiently low then stash the results and return true
		if public_order < -10 then
			in_public_order.lowest_public_order_region = context:region():name();
			return true;
		end;
		
		return false;
	end
);


function in_public_order_advice_trigger()
	cm:callback(function() in_public_order_advice_play() end, 0.5);
end;


function in_public_order_advice_play()

	-- retrieve our stashed region
	local lowest_public_order_region = in_public_order.lowest_public_order_region;
	
	if not is_string(lowest_public_order_region) then
		script_error("ERROR: in_public_order_advice_play() called but there is no cached lowest public order region, aborting");
		in_public_order:cancel();
		return false;
	end;
	
	-- Public order is becoming a problem here, my Lord. Those that inhabit this place begin to stir against your rule. Appease or suppress them to snuff out dissent.
	local advice_key = "war.camp.advice.public_order.001";
	
	local mm = false;
	
	-- if we've never listened to public order advice before then this may be our special-case advice, see if this is so
	if not common.get_advice_history_string_seen("prelude_public_order_advice") then		
		if lowest_public_order_region == prelude_public_order_region and is_string(prelude_public_order_advice_key) and is_string(prelude_public_order_province) and is_string(prelude_public_order_mission_key) then
			advice_key = prelude_public_order_advice_key;
			
			-- cancel this mission in case it's previously been issued (this can happen if the player resets their advice during play)
			cm:cancel_custom_mission(cm:get_local_faction_name(), prelude_public_order_mission_key);
			
			mm = mission_manager:new(cm:get_local_faction_name(), prelude_public_order_mission_key);
		
			mm:add_new_objective("AT_LEAST_X_PUBLIC_ORDER_IN_PROVINCES");
			mm:add_condition("total 10");
			mm:add_condition("province " .. prelude_public_order_province);
			mm:add_payload("money 3000");
		end;
	end;
	
	common.set_advice_history_string_seen("prelude_public_order_advice");
	
	local infotext = {
		"war.camp.advice.public_order.info_001",
		"war.camp.advice.public_order.info_002",
		"war.camp.advice.public_order.info_003"
	};
	
	in_public_order:scroll_camera_to_settlement_for_intervention( 
		lowest_public_order_region, 
		advice_key, 
		infotext, 
		mm
	);
end;














---------------------------------------------------------------
--
--	revolt imminent
--
---------------------------------------------------------------

-- intervention declaration
in_revolt_imminent = intervention:new(
	"revolt_imminent",	 														-- string name
	30, 																		-- cost
	function() in_revolt_imminent_trigger() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_revolt_imminent:add_trigger_condition(
	"ScriptEventFactionTurnStartLowestPublicOrder",
	function(context)
		
		-- don't proceed if this isn't the player's faction
		if context:faction():name() ~= cm:get_local_faction_name() then
			return;
		end;
	
		-- don't process if the public order advice is enqueued
		if in_public_order.is_enqueued_for_triggering or context:region():owning_faction():subculture()=="wh_main_sc_brt_bretonnia" then
			return false;
		end;
	
		local public_order = context:region():public_order();
				
		-- if the lowest public order is sufficiently low then stash the results and return true
		if public_order < -70 then
			in_revolt_imminent.region_name = context:region():name();
			return true;
		end;
		
		return false;
	end
);

in_revolt_imminent:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_revolt_imminent:add_advice_key_precondition("war.camp.advice.revolts.002");


function in_revolt_imminent_trigger()
	
	-- work out if we have a region to zoom to
	local region_name = in_revolt_imminent.region_name;
	
	local show_cutscene = true;
		
	-- The denizens are dangerously agitated, my Lord! Soon they will take up arms against you. Move swiftly to crush or appease them!
	local advice_key = "war.camp.advice.revolts.001";
	local infotext = {
		"war.camp.advice.revolts.info_004", 
		"war.camp.advice.revolts.info_005", 
		"war.camp.advice.revolts.info_006"
	};
	
	in_revolt_imminent:scroll_camera_to_settlement_for_intervention(
		region_name,
		advice_key,
		infotext
	);
end;











---------------------------------------------------------------
--
--	buildings damaged
--
---------------------------------------------------------------

-- intervention declaration
in_buildings_damaged = intervention:new(
	"buildings_damaged",	 													-- string name
	40, 																		-- cost
	function() in_buildings_damaged_trigger() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_buildings_damaged:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_buildings_damaged:add_advice_key_precondition("war.camp.advice.building_repair.002");
in_buildings_damaged:set_turn_countdown_restart(5);


in_buildings_damaged:add_trigger_condition(
	"ScriptEventPlayerBattleSequenceCompleted",
	function(context)
		local local_faction = cm:get_local_faction_name();
	
		-- only consider battles on the player's turn
		if not cm:is_factions_turn_by_key(local_faction) then 
			return false;
		end;
	
		local region_list = cm:get_faction(local_faction):region_list();
	
		for i = 0, region_list:num_items() - 1 do
			local current_region = region_list:item_at(i);
			local current_gr = current_region:garrison_residence();
			
			if not current_gr:is_under_siege() then
				local current_slot_list = current_region:slot_list();
				
				for j = 0, current_slot_list:num_items() - 1 do
					local current_slot = current_slot_list:item_at(j);
					
					if current_slot:has_building() then
						if current_slot:building():percent_health() < 100 then
							in_buildings_damaged.region_name = current_region:name();
							return true;
						end;
					end;
				end;
			end;
		end;
		
		return false;
	end
);

function in_buildings_damaged_trigger()
	
	-- work out if we have a region to zoom to
	local region_name = in_buildings_damaged.region_name;
	
	local show_cutscene = true;
		
	-- Facilities in this city are damaged, my Lord. Repair them to gain the full benefit that they can provide.
	local advice_key = "war.camp.advice.building_repair.002";
	local infotext = {
		"war.camp.advice.building_repair.info_001", 
		"war.camp.advice.building_repair.info_002", 
		"war.camp.advice.building_repair.info_003",
		"war.camp.advice.building_repair.info_004"
	};
	
	in_buildings_damaged:scroll_camera_to_settlement_for_intervention( 
		region_name, 
		advice_key, 
		infotext
	);
end;















---------------------------------------------------------------
--
--	diplomacy screen
--
---------------------------------------------------------------

-- intervention declaration
in_diplomacy_screen = intervention:new(
	"diplomacy_screen",					 												-- string name
	60, 																				-- cost
	function() in_diplomacy_screen_trigger() end,										-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_diplomacy_screen:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_diplomacy_screen:set_wait_for_fullscreen_panel_dismissed(false);
in_diplomacy_screen:add_precondition(function() return not uim:get_interaction_monitor_state("diplomacy_screen_closed") end);

-- trigger if the player opens the diplomacy panel on their turn and it hasn't opened previously
in_diplomacy_screen:add_trigger_condition(
	"ScriptEventPlayerOpensDiplomacyPanel",
	function()
		-- only trigger if it's the player's turn
		return not cm:is_factions_turn_by_key(cm:get_local_faction_name());
	end
);


function in_diplomacy_screen_trigger()
	
	-- Relations with foreign powers may be managed through diplomacy, my Lord. Consider your situation carefully before accepting any agreement.
	local advice_key = "war.camp.advice.diplomacy.003";
	local infotext = {
		"war.camp.advice.diplomacy.info_001",
		"war.camp.advice.diplomacy.info_002", 
		"war.camp.advice.diplomacy.info_003"
	};
	
	in_diplomacy_screen:play_advice_for_intervention( 
		advice_key, 
		infotext
	);
end;











-- If there's a chance that any of the items of diplomacy are going to want to fire we lock diplomacy audio on the diplomacy screen. This prevents
-- the opposing Lord from speaking, allowing the advisor to speak instead. This listener unlocks diplomacy audio when the panel closes.
local function lock_diplomacy_audio_and_unlock_on_diplomacy_panel_closed()
	uim:lock_diplomacy_audio();

	core:add_listener(
		"diplomacy_audio_unlock_listener",
		"ScriptEventDiplomacyPanelClosed",
		true,
		function(context)
			uim:unlock_diplomacy_audio();
		end,
		false
	);
end;




---------------------------------------------------------------
--
--	diplomacy
--
---------------------------------------------------------------

-- intervention declaration
in_diplomacy = intervention:new(
	"diplomacy",	 														-- string name
	10, 																	-- cost
	function() in_diplomacy_advice_trigger() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_diplomacy:add_precondition(function() return not uim:get_interaction_monitor_state("diplomacy_panel_closed") end);
in_diplomacy:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_diplomacy:set_player_turn_only(false);
in_diplomacy:set_wait_for_fullscreen_panel_dismissed(false);

in_diplomacy:add_trigger_condition(
	"ScriptEventDiplomacyPanelOpened",
	function()
		-- stop this intervention if the diplomacy panel has previously been interacted with
		if uim:get_interaction_monitor_state("diplomacy_panel_closed") then
			out("\tstopping in_diplomacy as diplomacy panel has previously been closed");
			in_diplomacy:stop();
			return false;
		end;
		
		-- only trigger if it's not the player's turn
		if not cm:is_factions_turn_by_key(cm:get_local_faction_name()) then
			-- Lock diplomacy audio
			lock_diplomacy_audio_and_unlock_on_diplomacy_panel_closed();
			return true;
		end;
	end
);


function in_diplomacy_advice_trigger()
	core:add_listener(
		"in_diplomacy_advice",
		"ScriptEventDiplomacyPanelContext",
		true,
		function(context) in_diplomacy_advice_process_context(context.string) end,
		false
	);
	
	cm:start_diplomacy_panel_context_listener();
end;


function in_diplomacy_advice_process_context(diplomacy_context)

	out("in_diplomacy_advice_process_context() called, diplomacy_context is " .. diplomacy_context);

	-- if the context is war then return
	if diplomacy_context == "war" then
		uim:unlock_diplomacy_audio();
		in_diplomacy:cancel();
		return;
	end;
	
	if diplomacy_context == "interactive" then
		-- A rival power desires a change in your mutual relations, my Lord. Consider their offer carefully.
		cm:show_advice("war.camp.advice.diplomacy.002", true);
	
	else
		-- A rival power desires a change in your mutual relations, my Lord.
		cm:show_advice("war.camp.advice.diplomacy.001", true);
	end
	
	cm:add_infotext(1, "war.camp.advice.diplomacy.info_001", "war.camp.advice.diplomacy.info_002", "war.camp.advice.diplomacy.info_003");
	
	-- diplomacy interventions don't properly support queueing, they end immediately due to the specific way they've been implemented
	in_diplomacy:complete();
end;












---------------------------------------------------------------
--
--	war
--
---------------------------------------------------------------

-- intervention declaration
in_war = intervention:new(
	"war",	 																-- string name
	10, 																	-- cost
	function() in_war_advice_trigger() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

-- this may well trigger at the same time as the diplomacy intervention above - a slightly weird situation
in_war:add_trigger_condition(
	"ScriptEventDiplomacyPanelOpened",
	function()
		if not cm:is_factions_turn_by_key(cm:get_local_faction_name()) then
			-- Lock diplomacy audio
			lock_diplomacy_audio_and_unlock_on_diplomacy_panel_closed();
			return true;
		end;
	end
);

in_war:add_advice_key_precondition("war.camp.advice.war.001");
in_war:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_war:set_player_turn_only(false);
in_war:set_wait_for_fullscreen_panel_dismissed(false);


function in_war_advice_trigger()
	core:add_listener(
		"in_war_advice",
		"ScriptEventDiplomacyPanelContext",
		true,
		function(context) in_war_advice_process_context(context.string) end,
		false
	);
	
	cm:start_diplomacy_panel_context_listener();
end;


function in_war_advice_process_context(diplomacy_context)

	out("in_war_advice_process_context() called, diplomacy_context is " .. diplomacy_context);

	-- if the context is not war then return
	if diplomacy_context ~= "war" then
		uim:unlock_diplomacy_audio();
		in_war:cancel();
		return;
	end;
	
	-- War is declared! A rival power take up arms against you, my Lord! Crush them without mercy!
	cm:show_advice("war.camp.advice.war.001", true);	
	cm:add_infotext(1, "war.camp.advice.war.info_001", "war.camp.advice.war.info_002", "war.camp.advice.war.info_003");
	
	-- diplomacy interventions don't properly support queueing, they end immediately due to the specific way they've been implemented
	in_war:complete();
end;











---------------------------------------------------------------
--
--	alliances
--
---------------------------------------------------------------

-- intervention declaration
in_alliances = intervention:new(
	"alliances",	 														-- string name
	10, 																	-- cost
	function() in_alliances_advice_trigger() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

-- this may well trigger at the same time as the diplomacy intervention above - a slightly weird situation
in_alliances:add_trigger_condition(
	"ScriptEventDiplomacyPanelOpened",
	function()
		if not cm:is_factions_turn_by_key(cm:get_local_faction_name()) then
			-- Lock diplomacy audio
			lock_diplomacy_audio_and_unlock_on_diplomacy_panel_closed();
			return true;
		end;
	end
);

in_alliances:give_priority_to_intervention("diplomacy");
in_alliances:add_advice_key_precondition("war.camp.advice.alliances.001");
in_alliances:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_alliances:set_player_turn_only(false);
in_alliances:set_wait_for_fullscreen_panel_dismissed(false);

function in_alliances_advice_trigger()
	core:add_listener(
		"in_alliance_advice",
		"ScriptEventDiplomacyPanelContext",
		true,
		function(context) in_alliance_advice_process_context(context.string) end,
		false
	);
	
	cm:start_diplomacy_panel_context_listener();
end;


function in_alliance_advice_process_context(diplomacy_context)

	-- if the context is not alliance then return
	if diplomacy_context ~= "alliance" then
		uim:unlock_diplomacy_audio();
		in_alliances:cancel();
		return;
	end;
	
	-- Emissaries from a foreign leader come requesting an alliance, my Lord. Consider the situation carefully before accepting any treaty.
	cm:show_advice("war.camp.advice.alliances.001", true);	
	cm:add_infotext(1, "war.camp.advice.alliances.info_001", "war.camp.advice.alliances.info_002", "war.camp.advice.alliances.info_003");
	
	-- diplomacy interventions don't properly support queueing, they end immediately due to the specific way they've been implemented
	in_alliances:complete();
end;









---------------------------------------------------------------
--
--	trade_agreement_sought
--
---------------------------------------------------------------

-- intervention declaration
in_trade_agreement_sought = intervention:new(
	"trade_agreement_sought",	 														-- string name
	10, 																				-- cost
	function() in_trade_agreement_sought_advice_trigger() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

-- this may well trigger at the same time as the diplomacy intervention above - a slightly weird situation
in_trade_agreement_sought:add_trigger_condition(
	"ScriptEventDiplomacyPanelOpened",
	function()
		if not cm:is_factions_turn_by_key(cm:get_local_faction_name()) then
			-- Lock diplomacy audio
			lock_diplomacy_audio_and_unlock_on_diplomacy_panel_closed();
			return true;
		end;
	end
);

in_trade_agreement_sought:give_priority_to_intervention("diplomacy");
in_trade_agreement_sought:add_advice_key_precondition("war.camp.advice.trade.001");
in_trade_agreement_sought:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_trade_agreement_sought:set_player_turn_only(false);
in_trade_agreement_sought:set_wait_for_fullscreen_panel_dismissed(false);

function in_trade_agreement_sought_advice_trigger()
	core:add_listener(
		"in_non_aggression_pact_advice",
		"ScriptEventDiplomacyPanelContext",
		true,
		function(context) in_trade_agreement_sought_advice_process_context(context.string) end,
		false
	);
	
	cm:start_diplomacy_panel_context_listener();
end;


function in_trade_agreement_sought_advice_process_context(diplomacy_context)

	-- if the context is not non_aggression_pact then return
	if diplomacy_context ~= "trade" then
		uim:unlock_diplomacy_audio();
		in_trade_agreement_sought:cancel();
		return;
	end;
	
	-- Commerce! The life-blood of every nation, even more important than war for some. A trade agreement is being offered by a rival power. Such a deal would foster trust as well as generate income, but you must decide if it's the right thing to do.
	cm:show_advice("war.camp.advice.trade.001", true);	
	cm:add_infotext(1, "war.camp.advice.trade.info_001", "war.camp.advice.trade.info_002", "war.camp.advice.trade.info_003");
	
	-- diplomacy interventions don't properly support queueing, they end immediately due to the specific way they've been implemented
	in_trade_agreement_sought:complete();
end;











---------------------------------------------------------------
--
--	non_aggression_pacts
--
---------------------------------------------------------------

-- intervention declaration
in_non_aggression_pacts = intervention:new(
	"non_aggression_pacts",	 															-- string name
	10, 																				-- cost
	function() in_non_aggression_pacts_advice_trigger() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

-- this may well trigger at the same time as the diplomacy intervention above - a slightly weird situation
in_non_aggression_pacts:add_trigger_condition(
	"ScriptEventDiplomacyPanelOpened",
	function()
		if not cm:is_factions_turn_by_key(cm:get_local_faction_name()) then
			-- Lock diplomacy audio
			lock_diplomacy_audio_and_unlock_on_diplomacy_panel_closed();
			return true;
		end;
	end
);

in_non_aggression_pacts:give_priority_to_intervention("diplomacy");
in_non_aggression_pacts:add_advice_key_precondition("war.camp.advice.non_aggression_pact.001");
in_non_aggression_pacts:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_non_aggression_pacts:set_player_turn_only(false);
in_non_aggression_pacts:set_wait_for_fullscreen_panel_dismissed(false);

function in_non_aggression_pacts_advice_trigger()
	core:add_listener(
		"in_non_aggression_pact_advice",
		"ScriptEventDiplomacyPanelContext",
		true,
		function(context) in_non_aggression_pact_advice_process_context(context.string) end,
		false
	);
	
	cm:start_diplomacy_panel_context_listener();
end;


function in_non_aggression_pact_advice_process_context(diplomacy_context)

	-- if the context is not non_aggression_pact then return
	if diplomacy_context ~= "nap" then
		uim:unlock_diplomacy_audio();
		in_non_aggression_pacts:cancel();
		return;
	end;
	
	-- Relations with the rulers of this place are may be conducive to a mutual arrangement. If it pleases you, seek a pact of non-aggression to foster trust between your peoples. Trade relations or an alliance may follow.
	cm:show_advice("war.camp.advice.non_aggression_pact.001", true);	
	cm:add_infotext(1, "war.camp.advice.non_aggression_pact.info_001", "war.camp.advice.non_aggression_pact.info_002", "war.camp.advice.non_aggression_pact.info_003");
	
	-- diplomacy interventions don't properly support queueing, they end immediately due to the specific way they've been implemented
	in_non_aggression_pacts:complete();
end;










---------------------------------------------------------------
--
--	region rebels
--
---------------------------------------------------------------

-- intervention declaration
in_region_rebels = intervention:new(
	"region_rebels",	 													-- string name
	5, 																		-- cost
	function() in_region_rebels_trigger() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_region_rebels:add_trigger_condition(
	"ScriptEventRegionRebels",
	function(context)
		local retval = (context:region():owning_faction():name() == cm:get_local_faction_name());
		
		-- return true, but store the character involved
		if retval then
			in_region_rebels.region_name = context:region():name();
			return true;
		end;
		
		return false;
	end
);

in_region_rebels:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_region_rebels:add_advice_key_precondition("war.camp.advice.revolts.002");


function in_region_rebels_trigger()
	
	-- work out if we have a region to zoom to
	local region_name = in_region_rebels.region_name;
	
	local show_cutscene = true;
		
	-- Your foolish subjects here have taken up arms against your rule, my Lord! Move against their uprising, or it may grow to threaten your grip on this place!
	local advice_key = "war.camp.advice.revolts.002";
	local infotext = {
		"war.camp.advice.revolts.info_001", 
		"war.camp.advice.revolts.info_002", 
		"war.camp.advice.revolts.info_003",
		"war.camp.advice.revolts.info_007"
	};
	
	in_region_rebels:scroll_camera_to_settlement_for_intervention(
		region_name,
		advice_key,
		infotext
	);
end;
















---------------------------------------------------------------
--
--	Hero creation
--
---------------------------------------------------------------

-- intervention declaration
--[[
in_hero_creation = intervention:new(
	"hero_creation",	 													-- string name
	0, 																		-- cost
	function() in_hero_creation_trigger() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);


in_hero_creation:add_trigger_condition(
	"ScriptEventPlayerFactionCharacterCreated",
	function(context)
		local character = context:character();
		
		if cm:char_is_agent(character) then
			-- return true, but store the character involved
			in_hero_creation.char_cqi = context:character():cqi();
			return true;
		end;
		
		return false;
	end
);

in_hero_creation:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hero_creation:add_advice_key_precondition("war.camp.advice.heroes.003");
in_hero_creation:set_min_turn(2);

function in_hero_creation_trigger()
	
	-- work out if we have a character to zoom to
	local char_cqi = in_hero_creation.char_cqi;
	local character = cm:get_character_by_cqi(char_cqi);
	
	-- A Hero has enrolled in your service, Sire. Such operatives can solve problems that no amount of money or effort would otherwise be able to crack.
	local advice_key = "war.camp.advice.heroes.003";
	local infotext = {
		"war.camp.advice.heroes.info_001",
		"war.camp.advice.heroes.info_002", 
		"war.camp.advice.heroes.info_005"
	};

	
	if not character or not cm:char_is_agent(character) then
		-- dont show cutscene
		in_hero_creation:play_advice_for_intervention( 
			advice_key, 
			infotext
		);
	else
		-- show cutscene
		in_hero_creation:scroll_camera_to_character_for_intervention( 
			char_cqi, 
			advice_key, 
			infotext
		);
	end;
	
	-- allow event message
	cm:whitelist_event_feed_event_type("faction_event_incidentevent_feed_target_incident_faction");
end;
]]


















---------------------------------------------------------------
--
--	Movement Points Exhausted
--
---------------------------------------------------------------

-- intervention declaration
in_movement_points_exhausted = intervention:new(
	"movement_points_exhausted",	 													-- string name
	40, 																				-- cost
	function() in_movement_points_exhausted_trigger() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);


in_movement_points_exhausted:add_trigger_condition(
	"ScriptEventPlayerCharacterFinishedMovingEvent",
	function(context)
		local character = context:character();
		
		-- return true if the character is of the player's faction, has a military force but hasn't fought a battle
		if character:faction():name() == cm:get_local_faction_name() and character:has_military_force() and character:action_points_remaining_percent() < 8 then
			local force_type = character:military_force():force_type():key();
			return force_type == "ARMY" or force_type == "HORDE";
		end;
	end
);

in_movement_points_exhausted:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_movement_points_exhausted:add_advice_key_precondition("war.camp.advice.army_movement.001");

function in_movement_points_exhausted_trigger()
	
	local advice_key = "war.camp.advice.army_movement.001";
	local infotext = {
		"war.camp.advice.army_movement.info_001",
		"war.camp.advice.army_movement.info_002", 
		"war.camp.advice.army_movement.info_003"
	};
	
	-- dont show cutscene
	in_movement_points_exhausted:play_advice_for_intervention( 
		advice_key, 
		infotext
	);
end;















---------------------------------------------------------------
--
--	Greenskins
--
---------------------------------------------------------------

-- intervention declaration
in_greenskins = intervention:new(
	"greenskins",					 													-- string name
	60, 																				-- cost
	function() in_greenskins_trigger() end,												-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_greenskins:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_greenskins:add_advice_key_precondition("war.camp.prelude.grn.greenskins.001");
in_greenskins:add_advice_key_precondition("war.camp.advice.greenskins.001");
in_greenskins:add_precondition(function() return cm:is_subculture_in_campaign("wh_main_sc_grn_greenskins") end)
in_greenskins:add_precondition(function() return cm:get_saved_value("advice_greenskins_seen") ~= true end)
in_greenskins:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);


in_greenskins:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)			
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh_main_sc_grn_greenskins");
				
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_greenskins_seen", true)
				return false
			end

			in_greenskins.char_cqi = char:cqi();
			return true;
		end;
		return false;
	end
);


function in_greenskins_trigger()

	local char_cqi = in_greenskins.char_cqi;
	
	-- Greenskins! A barbarous race of savage killers. They think of nothing except violence. Keep your weapons close at hand in any dealings with them.
	local advice_key = "war.camp.advice.greenskins.001";
	local infotext = {
		"war.camp.advice.greenskins.info_001",
		"war.camp.advice.greenskins.info_002", 
		"war.camp.advice.greenskins.info_003"
	};
	
	in_greenskins:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key, 
		infotext
	);
end;











---------------------------------------------------------------
--
--	Empire
--
---------------------------------------------------------------

-- intervention declaration
in_empire = intervention:new(
	"empire",					 													-- string name
	60, 																				-- cost
	function() in_empire_trigger() end,												-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_empire:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_empire:add_advice_key_precondition("war.camp.prelude.emp.empire.001");
in_empire:add_advice_key_precondition("war.camp.advice.empire.001");
in_empire:add_precondition(function() return cm:is_subculture_in_campaign("wh_main_sc_emp_empire") end)
in_empire:add_precondition(function() return cm:get_saved_value("advice_empire_seen") ~= true end)
in_empire:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_empire:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)				
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh_main_sc_emp_empire");
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_empire_seen", true)
				return false
			end

			in_empire.char_cqi = char:cqi();
			return true;
		end;
		return false;
	end
);


function in_empire_trigger()

	local char_cqi = in_empire.char_cqi;
	
	-- The forces of the Empire, my Lord. The men of the Old World are weak but great in number. They should be no match for your warriors.
	local advice_key = "war.camp.advice.empire.001";
	local infotext = {
		"war.camp.advice.empire.info_001",
		"war.camp.advice.empire.info_002", 
		"war.camp.advice.empire.info_003"
	};
	
	in_empire:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key,
		infotext
	);
end;


---------------------------------------------------------------
--
--	Dwarfs
--
---------------------------------------------------------------

-- intervention declaration
in_dwarfs = intervention:new(
	"dwarfs",					 														-- string name
	60, 																				-- cost
	function() in_dwarfs_trigger() end,													-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_dwarfs:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_dwarfs:add_advice_key_precondition("war.camp.prelude.dwf.dwarfs.001");
in_dwarfs:add_advice_key_precondition("war.camp.advice.dwarfs.001");
in_dwarfs:add_precondition(function() return cm:is_subculture_in_campaign("wh_main_sc_dwf_dwarfs") end)
in_dwarfs:add_precondition(function() return cm:get_saved_value("advice_dwarfs_seen") ~= true end)
in_dwarfs:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_dwarfs:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh_main_sc_dwf_dwarfs");
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_dwarfs_seen", true)
				return false
			end

			in_dwarfs.char_cqi = char:cqi();
			return true;
		end;
		return false;
	end
);


function in_dwarfs_trigger()

	local char_cqi = in_dwarfs.char_cqi;
	
	-- Dwarfs, my Lord. These runts rarely emerge from under their mountains. Don't be fooled by their stunted height - they are hardy, stubborn creatures and are not to be underestimated in battle.
	local advice_key = "war.camp.advice.dwarfs.001";
	local infotext = {
		"war.camp.advice.dwarfs.info_001",
		"war.camp.advice.dwarfs.info_002", 
		"war.camp.advice.dwarfs.info_003"
	};
		
	in_dwarfs:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key, 
		infotext
	);
end;











---------------------------------------------------------------
--
--	Vampire Counts
--
---------------------------------------------------------------

-- intervention declaration
in_vampire_counts = intervention:new(
	"vampire_counts",					 														-- string name
	60, 																						-- cost
	function() in_vampire_counts_trigger() end,													-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 																-- show debug output
);

in_vampire_counts:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_vampire_counts:add_advice_key_precondition("war.camp.prelude.vmp.vampires.001");
in_vampire_counts:add_advice_key_precondition("war.camp.advice.vampires.001");
in_vampire_counts:add_precondition(function() return cm:is_subculture_in_campaign("wh_main_sc_vmp_vampire_counts") end)
in_vampire_counts:add_precondition(function() return cm:get_saved_value("advice_vampire_counts_seen") ~= true end)
in_vampire_counts:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_vampire_counts:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh_main_sc_vmp_vampire_counts");
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_vampire_counts_seen", true)
				return false
			end

			in_vampire_counts.char_cqi = char:cqi();
			return true;
		end;
		return false;
	end
);


function in_vampire_counts_trigger()

	local char_cqi = in_vampire_counts.char_cqi;
	
	-- The undead, my Lord, under the thrall of their Vampire masters no doubt. Stay alert when dealing with the Midnight Aristocracy, lest their treachery overtake you.
	local advice_key = "war.camp.advice.vampires.001";
	local infotext = {
		"war.camp.advice.vampires.info_001",
		"war.camp.advice.vampires.info_002", 
		"war.camp.advice.vampires.info_003"
	};
		

	in_vampire_counts:scroll_camera_to_character_for_intervention( 
		char_cqi, 
		advice_key, 
		infotext
	);
end;


---------------------------------------------------------------
--
--	Vampires racial advice
--
---------------------------------------------------------------

-- intervention declaration
in_vampires_racial_advice = intervention:new(
	"in_vampires_racial_advice", 												-- string name
	50, 																		-- cost
	function() trigger_in_vampires_racial_advice() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_vampires_racial_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_vampires_racial_advice:add_precondition_unvisited_page("vampires");
in_vampires_racial_advice:add_advice_key_precondition("war.camp.prelude.vmp.vampires.001");
in_vampires_racial_advice:set_min_turn(2);

in_vampires_racial_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return true;
	end
);

function trigger_in_vampires_racial_advice()
	in_vampires_racial_advice:play_advice_for_intervention(
		-- Your kind are a nightmare made flesh, Sire. Yoke the power of the dead and you shall be unstoppable.
		"war.camp.prelude.vmp.vampires.001", 
		{
			"war.camp.advice.vampires.info_001",
			"war.camp.advice.vampires.info_002",
			"war.camp.advice.vampires.info_003"
		}
	)
end;


---------------------------------------------------------------
--
--	Raising Dead advice
--
---------------------------------------------------------------

-- intervention declaration
in_vampires_raising_dead_advice = intervention:new(
	"in_vampires_raising_dead_advice", 											-- string name
	60, 																		-- cost
	function() trigger_in_vampires_raising_dead_advice() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_vampires_raising_dead_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_vampires_raising_dead_advice:add_advice_key_precondition("war.camp.prelude.vmp.raising_dead.001");
in_vampires_raising_dead_advice:add_precondition_unvisited_page("raising_dead");
in_vampires_raising_dead_advice:set_min_turn(4);

in_vampires_raising_dead_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return true;
	end
);

function trigger_in_vampires_raising_dead_advice()
	in_vampires_raising_dead_advice:play_advice_for_intervention(
		-- The dead may be summoned to your will, my Lord. Rapidly augment your forces by raising the slain to your banner.
		"war.camp.prelude.vmp.raising_dead.001", 
		{
			"war.camp.advice.raising_dead.info_001",
			"war.camp.advice.raising_dead.info_002",
			"war.camp.advice.raising_dead.info_003"
		}
	)
end;


---------------------------------------------------------------
--
--	Bloodlines
--
---------------------------------------------------------------
in_bloodlines = intervention:new(
	"bloodlines",					 															-- string name
	50, 																						-- cost
	function() in_bloodlines_trigger() end,														-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 																-- show debug output
);

in_bloodlines:add_advice_key_precondition("wh2_dlc11.camp.advice.vmp.bloodlines.001");
in_bloodlines:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);

in_bloodlines:add_trigger_condition(
	"PooledResourceChanged",
	function(context)
		-- Some Vamp factions get a free Blood Kiss on game start under the 'faction' factor, and we don't want this to trigger the intervention.
		return context:resource():key() == "vmp_blood_kiss" and context:factor():key() ~= "faction" and context:amount() > 0;
	end
);

function in_bloodlines_trigger()
	in_bloodlines:play_advice_for_intervention(
		"wh2_dlc11.camp.advice.vmp.bloodlines.001",
		{
			"war.camp.hp.bloodlines.003",
			"war.camp.hp.bloodlines.004",
			"war.camp.hp.bloodlines.005"
		});
end;







---------------------------------------------------------------
--
--	chaos
--
---------------------------------------------------------------

-- intervention declaration
in_chaos = intervention:new(
	"chaos",					 														-- string name
	60, 																				-- cost
	function() in_chaos_trigger() end,													-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_chaos:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_chaos:add_advice_key_precondition("war.camp.advice.chaos.001");
in_chaos:add_precondition(function() return cm:is_subculture_in_campaign("wh_main_sc_chs_chaos") end)
in_chaos:add_precondition(function() return cm:get_saved_value("advice_chaos_seen") ~= true end)
in_chaos:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);			-- rename to warriors_of_chaos, and add vcoast

in_chaos:add_precondition(
	function()
		-- only proceed if the local faction is not chaos
		return cm:get_faction(cm:get_local_faction_name()):culture() ~= "wh_main_chs_chaos";
	end
);

in_chaos:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh_main_sc_chs_chaos");
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_chaos_seen", true)
				return false
			end

			in_chaos.char_cqi = char:cqi();
			return true;
		end;
		return false;
	end
);


function in_chaos_trigger()

	local char_cqi = in_chaos.char_cqi;
	
	-- The Ruinous Powers have been sighted nearby! The forces of Chaos wish to bring about the End Times. Beat them down at every opportunity.
	local advice_key = "war.camp.advice.chaos.001";
	local infotext = {
		"war.camp.advice.warriors_of_chaos.info_001",
		"war.camp.advice.warriors_of_chaos.info_002", 
		"war.camp.advice.warriors_of_chaos.info_003"
	};
	
	in_chaos:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key,
		infotext
	);
end;











---------------------------------------------------------------
--
--	Beastmen
--
---------------------------------------------------------------

-- intervention declaration
in_beastmen = intervention:new(
	"beastmen",					 														-- string name
	60, 																				-- cost
	function() in_beastmen_trigger() end,												-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_beastmen:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_beastmen:add_advice_key_precondition("dlc03.camp.advice.bst.beastmen.001");
in_beastmen:add_advice_key_precondition("war.camp.advice.beastmen.001");
in_beastmen:add_precondition(function() return cm:is_subculture_in_campaign("wh_dlc03_sc_bst_beastmen") end)
in_beastmen:add_precondition(function() return cm:get_saved_value("advice_beastmen_seen") ~= true end)
in_beastmen:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_beastmen:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh_dlc03_sc_bst_beastmen");
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then
			
			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_beastmen_seen", true)
				return false
			end

			in_beastmen.char_cqi = char:cqi();
			return true;
		end;
		return false;
	end
);


function in_beastmen_trigger()

	local char_cqi = in_beastmen.char_cqi;
	
	-- Be wary... The Children of Chaos are close. The Beastmen are servants of the Ruinous Powers, who crave the end of all civilisation. They care not which gods you follow; to them your warriors are prey!
	local advice_key = "war.camp.advice.beastmen.001";
	local infotext = {
		"war.camp.advice.beastmen.info_001",
		"war.camp.advice.beastmen.info_002", 
		"war.camp.advice.beastmen.info_003"
	};
		
	in_beastmen:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key, 
		infotext
	);
end;













---------------------------------------------------------------
--
--	money
--
---------------------------------------------------------------

-- intervention declaration
in_money = intervention:new(
	"money",					 														-- string name
	65, 																				-- cost
	function() in_money_trigger() end,													-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_money:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_money:add_advice_key_precondition("war.camp.advice.money.001");
in_money:add_advice_key_precondition("war.camp.advice.bankruptcy.001");
in_money:add_advice_key_precondition("war.camp.advice.bankruptcy.002");

in_money:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)		
		return context:faction():treasury() < 4000;
	end
);


function in_money_trigger()
	
	-- A vigil on expenditure must be maintained for your domain to prosper. Be sure to keep a close watch on your finances, lest ruin overtakes you.
	local advice_key = "war.camp.advice.money.001";
	local infotext = {
		"war.camp.advice.money.info_001",
		"war.camp.advice.money.info_002", 
		"war.camp.advice.money.info_003"
	};
	
	in_money:play_advice_for_intervention( 
		advice_key, 
		infotext
	);
end;













---------------------------------------------------------------
--
--	near bankruptcy
--
---------------------------------------------------------------

-- intervention declaration
in_near_bankruptcy = intervention:new(
	"near_bankruptcy",					 														-- string name
	30, 																						-- cost
	function() in_near_bankruptcy_trigger() end,												-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 																-- show debug output
);

in_near_bankruptcy:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_near_bankruptcy:add_advice_key_precondition("war.camp.advice.bankruptcy.001");
in_near_bankruptcy:add_advice_key_precondition("war.camp.advice.bankruptcy.002");

in_near_bankruptcy:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local faction = context:faction();
		return faction:losing_money() and faction:treasury() < 1000 and faction:treasury() > 0;
	end
);


function in_near_bankruptcy_trigger()
	
	-- Your treasury is running dry, my Lord. Soon you will be out of coin. Take action now to mitigate the threat of bankruptcy.
	local advice_key = "war.camp.advice.bankruptcy.001";
	local infotext = {
		"war.camp.advice.bankruptcy.info_001",
		"war.camp.advice.bankruptcy.info_002",
		"war.camp.advice.bankruptcy.info_004",
		"war.camp.advice.bankruptcy.info_003"
	};
	
	in_near_bankruptcy:play_advice_for_intervention( 
		advice_key, 
		infotext
	);
end;
















---------------------------------------------------------------
--
--	bankruptcy
--
---------------------------------------------------------------

-- intervention declaration
in_bankruptcy = intervention:new(
	"bankruptcy",					 														-- string name
	10, 																					-- cost
	function() in_bankruptcy_trigger() end,													-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);

in_bankruptcy:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_bankruptcy:add_advice_key_precondition("war.camp.advice.bankruptcy.002");

in_bankruptcy:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local faction = context:faction();
		return faction:losing_money() and faction:treasury() <= 0;
	end
);


function in_bankruptcy_trigger()
	
	-- The treasury is bare! Bankruptcy is upon you. Take all action necessary to restore a positive income, or your power and influence will quickly unravel!
	local advice_key = "war.camp.advice.bankruptcy.002";
	local infotext = {
		"war.camp.advice.bankruptcy.info_001",
		"war.camp.advice.bankruptcy.info_002",
		"war.camp.advice.bankruptcy.info_004",
		"war.camp.advice.bankruptcy.info_003"
	};
	
	in_bankruptcy:play_advice_for_intervention( 
		advice_key, 
		infotext
	);
	
	cm:whitelist_event_feed_event_type("faction_bankruptcyevent_feed_target_faction");
end;










---------------------------------------------------------------
--
--	hero action suffered
--
---------------------------------------------------------------

-- intervention declaration
in_hero_action_suffered = intervention:new(
	"hero_action_suffered",					 													-- string name
	10, 																						-- cost
	function() in_hero_action_suffered_trigger() end,											-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 																-- show debug output
);

in_hero_action_suffered:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hero_action_suffered:add_advice_key_precondition("war.camp.advice.heroic_actions.001");

in_hero_action_suffered:add_trigger_condition(
	"ScriptEventAgentActionSuccessAgainstCharacter",
	function(context)
		local char = context:character();
		in_hero_action_suffered.x = char:display_position_x();
		in_hero_action_suffered.y = char:display_position_y();
	
		return true;
	end
);

in_hero_action_suffered:add_trigger_condition(
	"ScriptEventAgentActionFailureAgainstCharacter",
	function(context)
		local char = context:character();
		in_hero_action_suffered.x = char:display_position_x();
		in_hero_action_suffered.y = char:display_position_y();
	
		return true;
	end
);

in_hero_action_suffered:add_trigger_condition(
	"ScriptEventAgentActionSuccessAgainstGarrison",
	function(context)
		local settlement = context:garrison_residence():settlement_interface();
		in_hero_action_suffered.x = settlement:display_position_x();
		in_hero_action_suffered.y = settlement:display_position_y();
	
		return true;
	end
);

in_hero_action_suffered:add_trigger_condition(
	"ScriptEventAgentActionFailureAgainstGarrison",
	function(context)
		local settlement = context:garrison_residence():settlement_interface();
		in_hero_action_suffered.x = settlement:display_position_x();
		in_hero_action_suffered.y = settlement:display_position_y();
	
		return true;
	end
);


function in_hero_action_suffered_trigger()
	
	-- Sabotage, my Lord! An enemy power has sent a Hero to disrupt the running of your domain. This act of aggression cannot be left unanswered. 
	local advice_key = "war.camp.advice.heroic_actions.001";
	local infotext = {
		"war.camp.advice.hero_actions.info_001",
		"war.camp.advice.hero_actions.info_002", 
		"war.camp.advice.hero_actions.info_003"
	};
	
	in_hero_action_suffered:scroll_camera_for_intervention(
		nil,
		in_hero_action_suffered.x, 
		in_hero_action_suffered.y, 
		advice_key, 
		infotext
	);
	
	cm:whitelist_event_feed_event_type("scripted_persistent_located_eventevent_feed_target_faction");
	cm:whitelist_event_feed_event_type("agent_action_vs_army_with_immortal_generalevent_feed_target_target_faction");
	cm:whitelist_event_feed_event_type("agent_action_vs_characterevent_feed_target_target_faction");
	cm:whitelist_event_feed_event_type("agent_action_vs_settlementevent_feed_target_target_faction");
end;
















---------------------------------------------------------------
--
--	raise forces
--
---------------------------------------------------------------
--[[
-- intervention declaration
in_raise_forces = intervention:new(
	"raise_forces",	 															-- string name
	50, 																		-- cost
	function() in_raise_forces_trigger() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_raise_forces:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_raise_forces:add_advice_key_precondition("war.camp.advice.raise_forces.001");
in_raise_forces:add_precondition(function() return not uim:get_interaction_monitor_state("force_raised") end);
in_raise_forces:set_min_turn(5);

in_raise_forces:add_trigger_condition(
	"ScriptEventPlayerBattleSequenceCompleted",
	function()
		-- return true if the player has no military forces following battle
		local faction = cm:get_faction(cm:get_local_faction_name());
		local mf_list = faction:military_force_list();
		
		for i = 0, mf_list:num_items() - 1 do
			local current_mf = mf_list:item_at(i);
			if not current_mf:is_armed_citizenry() and current_mf:unit_list():num_items() > 0 then
				return false;
			end;
		end;
		
		return true;
	end
);


in_raise_forces:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		-- return true if the player is gaining money, has more than 7000 money, and all the factions the player is at war with have more armies than the player
		local faction = cm:get_faction(cm:get_local_faction_name());
		
		if faction:losing_money() or faction:treasury() < 7000 then
			return false;
		end;
		
		-- count number of enemy armies
		local num_enemy_armies = 0;
		local faction_list = faction:factions_at_war_with();
		
		for i = 0, faction_list:num_items() - 1 do
			num_enemy_armies = num_enemy_armies + cm:num_mobile_forces_in_force_list(faction_list:item_at(i):military_force_list());
		end;
		
		-- count number of allied armies
		local mf_list = faction:military_force_list();
			
		if num_enemy_armies > cm:num_mobile_forces_in_force_list(faction:military_force_list()) then
			return true;
		end;
		
		return false;
	end
);


function in_raise_forces_trigger()
	
	in_raise_forces:play_advice_for_intervention(
		-- Your war efforts would be strengthened by the raising of a new army. Appoint another command, and you can open a second front against your foes.
		"war.camp.advice.raise_forces.001",
		{
			"war.camp.advice.raise_forces.info_001",
			"war.camp.advice.raise_forces.info_002",
			"war.camp.advice.raise_forces.info_003",
			"war.camp.advice.raise_forces.info_004"
		}
	);
end;
]]














---------------------------------------------------------------
--
--	unit_recruitment
--
---------------------------------------------------------------

-- intervention declaration
in_unit_recruitment = intervention:new(
	"unit_recruitment",	 													-- string name
	60, 																	-- cost
	function() in_unit_recruitment_advice_trigger() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_unit_recruitment:add_precondition(function() return not uim:get_interaction_monitor_state("unit_recruited") end);
in_unit_recruitment:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_unit_recruitment:set_min_turn(6);

in_unit_recruitment:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()
		if uim:get_interaction_monitor_state("unit_recruited") then
			in_unit_recruitment:stop();
			return false;
		end;
		
		return true;
	end
);


function in_unit_recruitment_advice_trigger()
	in_unit_recruitment:play_advice_for_intervention(
		-- Your armies must grow to meet the challenges ahead, my Lord. Be sure to recruit more fighting men, lest our enemies overtake us.
		"war.camp.advice.unit_recruitment.001",
		{
			"war.camp.advice.unit_recruitment.info_001",
			"war.camp.advice.unit_recruitment.info_002",
			"war.camp.advice.unit_recruitment.info_003"
		}
	);
end;










---------------------------------------------------------------
--
--	building_construction
--
---------------------------------------------------------------

-- intervention declaration
in_building_construction = intervention:new(
	"building_construction",	 											-- string name
	60, 																	-- cost
	function() in_building_construction_advice_trigger() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_building_construction:add_precondition(function() return not uim:get_interaction_monitor_state("building_constructed") end);
in_building_construction:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_building_construction:set_min_turn(7);

in_building_construction:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()
		return true;
	end
);


function in_building_construction_advice_trigger()
	in_building_construction:play_advice_for_intervention(
		-- Do not neglect the development of your cities, my lord. No great power can flourish by leaving its urban centres to decay.
		"war.camp.advice.buildings.001",
		{
			"war.camp.advice.buildings.info_001",
			"war.camp.advice.buildings.info_002",
			"war.camp.advice.buildings.info_003"
		}
	);
end;







---------------------------------------------------------------
--
--	stances
--
---------------------------------------------------------------

-- intervention declaration
in_stances = intervention:new(
	"stances",	 												-- string name
	60, 														-- cost
	function() in_stances_advice_trigger() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_stances:add_precondition(function() return not common.get_advice_history_string_seen("has_adopted_stance") end);
in_stances:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_stances:set_min_turn(14);

in_stances:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		-- only trigger if the player is at war
		return context:faction():at_war();
	end
);



function in_stances_advice_trigger()
	in_stances:play_advice_for_intervention(
		-- Consider varying your tactics when manoeuvring in the face of the enemy, my lord. Placing an ambush, or setting a defensive camp, may bring about victory where a straight engagement would fail.
		"war.camp.advice.stances.001",
		{
			"war.camp.advice.stances.info_001",
			"war.camp.advice.stances.info_002",
			"war.camp.advice.stances.info_003",
			"war.camp.advice.stances.info_004"
		}
	);
end;






---------------------------------------------------------------
--
--	Ambush Stance
--
---------------------------------------------------------------

-- intervention declaration
in_ambush_stance = intervention:new(
	"ambush_stance",	 														-- string name
	50, 																		-- cost
	function() in_ambush_stance_trigger() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_ambush_stance:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_ambush_stance:add_precondition(function() return not common.get_advice_history_string_seen("ambush_stance") end);
in_ambush_stance:add_advice_key_precondition("war.camp.advice.ambushes.002");
in_ambush_stance:give_priority_to_intervention("stances");
in_ambush_stance:set_min_turn(15);

in_ambush_stance:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		-- return true the player is at war
		return cm:get_faction(cm:get_local_faction_name()):at_war();
	end
);

function in_ambush_stance_trigger()
	
	-- Consider laying an ambush for the enemy, Sire. Fall upon them when they least expect it.
	local advice_key = "war.camp.advice.ambushes.002";
	local infotext = {
		"war.camp.advice.ambushes.info_001",
		"war.camp.advice.ambushes.info_002",
		"war.camp.advice.ambushes.info_003"
	};

	in_ambush_stance:play_advice_for_intervention(
		advice_key,
		infotext
	);
end;











---------------------------------------------------------------
--
--	help_pages
--
---------------------------------------------------------------

-- intervention declaration
in_help_pages = intervention:new(
	"help_pages",					 														-- string name
	80, 																					-- cost
	function() in_help_pages_trigger() end,													-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);

in_help_pages:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_help_pages:add_advice_key_precondition("war.camp.advice.help_pages.001");
in_help_pages:set_min_turn(7);

in_help_pages:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)		
		return true;
	end
);


function in_help_pages_trigger()
	
	-- Assistance is available should you need it, my lord. You may rely upon it.
	local advice_key = "war.camp.advice.help_pages.001";
	local infotext = {
		"war.camp.advice.help_pages.info_001",
		"war.camp.advice.help_pages.info_002", 
		"war.camp.advice.help_pages.info_003"
	};
	
	in_help_pages:play_advice_for_intervention( 
		advice_key, 
		infotext
	);
end;















---------------------------------------------------------------
--
--	Enemy Reinforcements
--
---------------------------------------------------------------

-- intervention declaration
in_enemy_reinforcements = intervention:new(
	"enemy_reinforcements",	 												-- string name
	80, 																	-- cost
	function() in_enemy_reinforcements_trigger() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);


in_enemy_reinforcements:add_trigger_condition(
	"ScriptEventPreBattlePanelOpened",
	function(context)
	
		local pending_battle = cm:model():pending_battle();
		
		-- don't process if this battle has been fought
		if pending_battle:has_been_fought() then
			return false;
		end;
		
		-- don't process if this is a siege or ambush battle
		local battle_type = pending_battle:battle_type();
		if string.find(battle_type, "settlement") or string.find(battle_type, "ambush") then
			return false;
		end;
		
		-- don't process if this is a quest battle
		if cm:pending_battle_cache_is_quest_battle() then
			return false;
		end;
		
		if cm:pending_battle_cache_faction_is_attacker(cm:get_local_faction_name()) then
			if cm:pending_battle_cache_num_defenders() > 1 then
				return true;
			end;
		else
			if cm:pending_battle_cache_num_attackers() > 1 then
				return true;
			end;
		end;
		
		return false;
	end
);

in_enemy_reinforcements:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_enemy_reinforcements:add_advice_key_precondition("war.camp.advice.reinforcements.001");
in_enemy_reinforcements:set_player_turn_only(false);
in_enemy_reinforcements:set_wait_for_battle_complete(false);

function in_enemy_reinforcements_trigger()
	-- The enemy bring reinforcements to the fight! Will an attack be wise?
	local advice_key = "war.camp.advice.reinforcements.001";
	local infotext = {
		"war.camp.advice.reinforcements.info_001",
		"war.camp.advice.reinforcements.info_002", 
		"war.camp.advice.reinforcements.info_003"
	};
	
	in_enemy_reinforcements:play_advice_for_intervention( 
		advice_key, 
		infotext
	);
end;















---------------------------------------------------------------
--
--	Player Reinforcements
--
---------------------------------------------------------------

-- intervention declaration
in_player_reinforcements = intervention:new(
	"player_reinforcements",	 											-- string name
	80, 																	-- cost
	function() in_player_reinforcements_trigger() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);


in_player_reinforcements:add_trigger_condition(
	"ScriptEventPreBattlePanelOpened",
	function(context)
	
		local pending_battle = cm:model():pending_battle();
	
		-- don't process if this battle has been fought
		if pending_battle:has_been_fought() then
			return false;
		end;
		
		-- don't process if this is a siege battle
		if string.find(pending_battle:battle_type(), "settlement") then
			return false;
		end;
		
		-- don't process if this is a quest battle
		if cm:pending_battle_cache_is_quest_battle() then
			return false;
		end;
		
		if cm:pending_battle_cache_faction_is_attacker(cm:get_local_faction_name()) then
			if cm:pending_battle_cache_num_attackers() > 1 then
				return true;
			end;
		else
			if cm:pending_battle_cache_num_defenders() > 1 then
				return true;
			end;
		end;
		
		return false;
	end
);

in_player_reinforcements:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_player_reinforcements:add_advice_key_precondition("war.camp.advice.reinforcements.001");
in_player_reinforcements:add_advice_key_precondition("war.camp.advice.reinforcements.002");
in_player_reinforcements:set_player_turn_only(false);
in_player_reinforcements:set_wait_for_battle_complete(false);

function in_player_reinforcements_trigger()
	-- Your army will be joined by reinforcements in battle, my lord, should you decide to fight. All the better to surround the enemy and drive them off the field.
	local advice_key = "war.camp.advice.reinforcements.002";
	local infotext = {
		"war.camp.advice.reinforcements.info_001",
		"war.camp.advice.reinforcements.info_002", 
		"war.camp.advice.reinforcements.info_003"
	};
	
	in_player_reinforcements:play_advice_for_intervention( 
		advice_key, 
		infotext
	);
end;










---------------------------------------------------------------
--
--	enemy raiding
--
---------------------------------------------------------------

-- intervention declaration
in_enemy_raiding = intervention:new(
	"enemy_raiding",					 												-- string name
	20, 																				-- cost
	function() in_enemy_raiding_trigger() end,											-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_enemy_raiding:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_enemy_raiding:add_advice_key_precondition("war.camp.advice.raiding.001");

in_enemy_raiding:add_trigger_condition(
	"ForceRaidingPlayerTerritory",
	function(context)
		in_enemy_raiding.mf_cqi = context:military_force():command_queue_index();
		return true;
	end
);


function in_enemy_raiding_trigger()
	local mf_cqi = in_enemy_raiding.mf_cqi;
	local char_cqi = false;
	local faction_name = false;
	
	if mf_cqi then
		local mf = cm:model():military_force_for_command_queue_index(mf_cqi);
		if is_militaryforce(mf) and mf:has_general() then
			char_cqi = mf:general_character():cqi();
			faction_name = mf:general_character():faction():name();
		end;
	end;
		
	-- My Lord, the enemy raid your lands and slaughter your people! Take up arms against them, make them pay dearly for their transgressions!
	local advice_key = "war.camp.advice.raiding.001";
	local infotext = {
		"war.camp.advice.raiding.info_001",
		"war.camp.advice.raiding.info_002", 
		"war.camp.advice.raiding.info_003"
	};
	
	in_enemy_raiding:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key,
		infotext
	);
end;


























---------------------------------------------------------------
--
--	Unit Exchange
--
---------------------------------------------------------------

-- intervention declaration
in_unit_exchange = intervention:new(
	"unit_exchange",	 													-- string name
	60, 																	-- cost
	function() in_unit_exchange_trigger() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_unit_exchange:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_unit_exchange:add_advice_key_precondition("war.camp.advice.unit_exchange.001");
in_unit_exchange:add_precondition(function() return not uim:get_interaction_monitor_state("unit_exchange_panel_closed") end);
in_unit_exchange:set_min_turn(16);

in_unit_exchange:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local mf_list = cm:get_faction(cm:get_local_faction_name()):military_force_list();
		local mf_count = 0;
		
		for i = 0, mf_list:num_items() - 1 do
			if not mf_list:item_at(i):is_armed_citizenry() then
				mf_count = mf_count + 1;
				if mf_count > 1 then
					return true;
				end;
			end;
		end;
		
		return false;
	end
);

function in_unit_exchange_trigger()
	
	local advice_key = "war.camp.advice.unit_exchange.001";
	local infotext = {
		"war.camp.advice.unit_exchange.info_001",
		"war.camp.advice.unit_exchange.info_002", 
		"war.camp.advice.unit_exchange.info_003"
	};
	
	in_unit_exchange:play_advice_for_intervention( 
		advice_key, 
		infotext
	);
end;












---------------------------------------------------------------
--
--	Raiding Stance Possible
--
---------------------------------------------------------------

-- intervention declaration
in_raiding_stance_possible = intervention:new(
	"raiding_stance_possible",	 											-- string name
	60, 																	-- cost
	function() in_raiding_stance_possible_trigger() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_raiding_stance_possible:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_raiding_stance_possible:add_advice_key_precondition("war.camp.advice.raiding.002");
in_raiding_stance_possible:add_precondition(function() return not uim:get_interaction_monitor_state("raiding_stance") and not uim:get_interaction_monitor_state("raiding_camp_stance") end);
in_raiding_stance_possible:set_min_turn(7);

in_raiding_stance_possible:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local player_faction = cm:get_faction(cm:get_local_faction_name());
		return cm:faction_has_armies_in_enemy_territory(player_faction);
	end
);

function in_raiding_stance_possible_trigger()
	
	local advice_key = "war.camp.advice.raiding.002";
	local infotext = {
		"war.camp.advice.raiding.info_001",
		"war.camp.advice.raiding.info_002", 
		"war.camp.advice.raiding.info_003"
	};
	
	in_raiding_stance_possible:play_advice_for_intervention( 
		advice_key, 
		infotext
	);
end;




















---------------------------------------------------------------
--
--	Archaon Encountered
--
---------------------------------------------------------------

-- intervention declaration
in_archaon_encountered = intervention:new(
	"archaon_encountered",	 												-- string name
	0, 																		-- cost
	function() in_archaon_encountered_trigger() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_archaon_encountered:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_archaon_encountered:add_precondition(function() return not cm:get_saved_value("archaon_encountered") end);

in_archaon_encountered:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local archaon_name = "names_name_2147343903";
		
		local chaos_char_list = cm:get_faction("wh_main_chs_chaos"):character_list();
		for i = 0, chaos_char_list:num_items() - 1 do
			local char = chaos_char_list:item_at(i);
			if char:forename(archaon_name) then
				if char:is_visible_to_faction(cm:get_local_faction_name()) then
					in_archaon_encountered.char_cqi = char:cqi();
					return true;
				end;
			end;
		end;
		
		return false;
	end
);

function in_archaon_encountered_trigger()

	-- get archaon cqi
	local char_cqi = in_archaon_encountered.char_cqi;
	
	-- The Everchosen himself, Archaon, has been sighted. He leads a host of immeasurable power. Do not face him in battle unprepared!
	local advice_key = "war.camp.advice.archaeon.001";
	
	cm:set_saved_value("archaon_encountered", true);
	
	in_archaon_encountered:scroll_camera_to_character_for_intervention(
		char_cqi,
		advice_key
	);
end;










---------------------------------------------------------------
--
--	Archaon Defeated
--
---------------------------------------------------------------

-- intervention declaration
in_archaon_defeated = intervention:new(
	"archaon_defeated",	 													-- string name
	0, 																		-- cost
	function() in_archaon_defeated_trigger() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_archaon_defeated:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_archaon_defeated:add_precondition(function() return not cm:get_saved_value("archaon_defeated") end);
in_archaon_defeated:set_player_turn_only(false);
in_archaon_defeated:set_wait_for_battle_complete(false);
in_archaon_defeated:set_reduce_pause_before_triggering(true);		-- do this so we get no grace period



in_archaon_defeated:add_trigger_condition(
	"ScriptEventHumanWinsBattle",
	function(context)
		local chaos_faction_leader = cm:get_faction("wh_main_chs_chaos"):faction_leader();
		
		-- return true if player was attacker/archaon was defender, or player was defender/archaon was attacker
		return (cm:pending_battle_cache_faction_is_attacker(cm:get_local_faction_name()) and cm:pending_battle_cache_char_is_defender(chaos_faction_leader)) or 
			(cm:pending_battle_cache_faction_is_defender(cm:get_local_faction_name()) and cm:pending_battle_cache_char_is_attacker(chaos_faction_leader));
	end
);

function in_archaon_defeated_trigger()
	
	-- The world rejoices: Archaeon is defeated! This is a great victory, mighty Lord, though I suspect you have not seen the last of your demonic foe. Beware of his return.
	local advice_key = "war.camp.advice.archaeon_defeated.001";
	
	cm:set_saved_value("archaon_defeated");
	
	in_archaon_defeated:play_advice_for_intervention(
		-- The world rejoices: Archaeon is defeated! This is a great victory, mighty Lord, though I suspect you have not seen the last of your demonic foe. Beware of his return.
		"war.camp.advice.archaeon_defeated.001"
	);
end;

















---------------------------------------------------------------
--
--	Player Besieged
--
---------------------------------------------------------------

-- intervention declaration
in_player_besieged = intervention:new(
	"player_besieged",	 													-- string name
	0, 																		-- cost
	function() in_player_besieged_trigger() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_player_besieged:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_player_besieged:add_advice_key_precondition("war.camp.advice.siege_warfare.002");
in_player_besieged:add_whitelist_event_type("conquest_siege_establishedevent_feed_target_conquest_besieged_faction")

in_player_besieged:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local region_list = cm:get_faction(cm:get_local_faction_name()):region_list();
		
		for i = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(i);
			if region:garrison_residence():is_under_siege() then
				in_player_besieged.region_key = region:name();
				return true;				
			end;
		end;
		
		return false;
	end
);

function in_player_besieged_trigger()
	local region_key = in_player_besieged.region_key;
	
	-- The enemy have encircled your city, my Lord! Send a force to aid the city defenders before they are starved into submission.
	local advice_key = "war.camp.advice.siege_warfare.002";
	local infotext = {
		"war.camp.advice.siege_warfare.info_001",
		"war.camp.advice.siege_warfare.info_002",
		"war.camp.advice.siege_warfare.info_003"
	};
	
	in_player_besieged:scroll_camera_to_settlement_for_intervention( 
		region_key,
		advice_key,
		infotext
	);
end;
















---------------------------------------------------------------
--
--	Enemy Port Sighted
--
---------------------------------------------------------------

-- intervention declaration
in_enemy_port = intervention:new(
	"enemy_port",	 														-- string name
	50, 																	-- cost
	function() in_enemy_port_trigger() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_enemy_port:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_enemy_port:add_advice_key_precondition("war.camp.advice.ports.001");
in_enemy_port:set_min_turn(16);

in_enemy_port:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local player_faction = context:faction();
		local player_faction_name = player_faction:name();
		local region_list = player_faction:region_list();

		local checked_adjacent_regions = {};

		local closest_distance = false;
		local closest_enemy_region = false;

		for i, region in model_pairs(region_list) do
			local adjacent_regions = region:adjacent_region_list();

			for j, adjacent_region in model_pairs(adjacent_regions) do
				if not checked_adjacent_regions[adjacent_region:name()] then
					checked_adjacent_regions[adjacent_region:name()] = true;

					if not adjacent_region:is_abandoned() and adjacent_region:owning_faction():at_war_with(player_faction) and adjacent_region:settlement():is_port() then
						local gc = cm:get_garrison_commander_of_region(adjacent_region);

						if gc and gc:is_visible_to_faction(player_faction_name) then
							local _, current_closest_distance = cm:get_closest_character_from_faction(player_faction, gc:logical_position_x(), gc:logical_position_y());

							if not closest_distance or current_closest_distance < closest_distance then
								closest_distance = current_closest_distance;
								closest_enemy_region = adjacent_region;
							end;
						end;
					end;
				end;
			end;
		end;

		if closest_enemy_region then
			in_enemy_port.region_key = closest_enemy_region:name();
			return true;
		end;
	end
);

function in_enemy_port_trigger()
	local region_key = in_enemy_port.region_key;
	
	-- An enemy port, my Lord. Here, the enemy build ships and ply trade with their remote allies. Capture it, and you may do the same.
	local advice_key = "war.camp.advice.ports.001";
	local infotext = {
		"war.camp.advice.ports.info_001",
		"war.camp.advice.ports.info_002",
		"war.camp.advice.ports.info_003"
	};
	
	in_enemy_port:scroll_camera_to_settlement_for_intervention( 
		region_key, 
		advice_key, 
		infotext
	);
end;













---------------------------------------------------------------
--
--	Player Army Near Coast
--
---------------------------------------------------------------

-- intervention declaration
in_player_army_near_coast = intervention:new(
	"player_army_near_coast",	 											-- string name
	50, 																	-- cost
	function() in_player_army_near_coast_trigger() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_player_army_near_coast:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_player_army_near_coast:add_advice_key_precondition("war.camp.advice.armies_at_sea.001");
in_player_army_near_coast:set_min_turn(8);

in_player_army_near_coast:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		-- return true if any of the player's military forces are either at sea or in a region that contains a port
		local player_faction = cm:get_faction(cm:get_local_faction_name());
		
		local mf_list = player_faction:military_force_list();
		
		for i = 1, mf_list:num_items() - 1 do
			local current_mf = mf_list:item_at(i);
			
			if not current_mf:is_armed_citizenry() and current_mf:has_general() then
				local char = current_mf:general_character();
				if char:has_region() and char:region():settlement():is_port() then
					in_player_army_near_coast.char_cqi = char:cqi();
					return true;
				end;
			end;
		end;
		
		return false;
	end
);

function in_player_army_near_coast_trigger()
	local char_cqi = in_player_army_near_coast.char_cqi;
	
	-- Your armies can take to the water should you wish it, Sire. Have them build boats on shore, or set sail from a nearby port.
	local advice_key = "war.camp.advice.armies_at_sea.001";
	local infotext = {
		"war.camp.advice.armies_at_sea.info_001",
		"war.camp.advice.armies_at_sea.info_002",
		"war.camp.advice.armies_at_sea.info_003",
		"war.camp.advice.armies_at_sea.info_004"
	};
	
	in_player_army_near_coast:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key, 
		infotext
	);
end;















---------------------------------------------------------------
--
--	Resources
--
---------------------------------------------------------------

-- intervention declaration
in_resources = intervention:new(
	"resources",	 														-- string name
	60, 																	-- cost
	function() in_resources_trigger() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_resources:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_resources:add_advice_key_precondition("war.camp.advice.resources.001");
in_resources:set_min_turn(15);

in_resources:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)						
		-- return true if the garrison commander of any settlement that is controlled by an enemy of the player is visible to the player, false otherwise	
		local player_faction = cm:get_faction(cm:get_local_faction_name());
		local war_list = player_faction:factions_at_war_with();	
		for i = 0, war_list:num_items() - 1 do
			local current_faction = war_list:item_at(i);
			local region_list = current_faction:region_list();
						
			for j = 0, region_list:num_items() - 1 do
				local current_region = region_list:item_at(j);
				
				if not current_region:is_abandoned() and current_region:any_resource_available() then
					local gr = current_region:garrison_residence();
					
					if gr:has_army() and gr:army():has_general() then
						if gr:can_be_occupied_by_faction(cm:get_local_faction_name()) and gr:army():general_character():is_visible_to_faction(cm:get_local_faction_name()) then
							in_resources.region_key = current_region:name();
							return true;
						end;
					end;
				end;
			end;
		end;
		return false;
	end
);

function in_resources_trigger()
	local region_key = in_resources.region_key;
	
	-- Natural resources are abundant in this place, my Lord. Capture it, and its riches would be yours.
	local advice_key = "war.camp.advice.resources.001";
	local infotext = {
		"war.camp.advice.resources.info_001",
		"war.camp.advice.resources.info_002",
		"war.camp.advice.resources.info_003"
	};
	
	in_resources:scroll_camera_to_settlement_for_intervention( 
		region_key, 
		advice_key, 
		infotext
	);
end;












---------------------------------------------------------------
--
--	settlement_climate
--
---------------------------------------------------------------

-- intervention declaration

in_settlement_climate = intervention:new(
	"settlement_climate",	 												-- string name
	40, 																	-- cost
	function() in_settlement_climate_trigger() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_settlement_climate:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_settlement_climate:add_advice_key_precondition("wh2.camp.advice.inhospitable_climates.001");
in_settlement_climate:set_min_turn(6);

in_settlement_climate:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)				
		-- return true if a visible settlement of any faction the player is at war with would be difficult to occupy, false otherwise
		local player_faction = cm:get_faction(cm:get_local_faction_name());
		local war_list = player_faction:factions_at_war_with();
		
		for i = 0, war_list:num_items() - 1 do
			local current_faction = war_list:item_at(i);
			local region_list = current_faction:region_list();
			for j = 0, region_list:num_items() - 1 do
				local current_region = region_list:item_at(j);
				
				-- return true if the climate suitability is very poor and the target settlement is visible to the player
				if player_faction:get_climate_suitability(current_region:settlement():get_climate()) == "suitability_verypoor" then
					local gr = current_region:garrison_residence();
					if gr:has_army() and gr:army():has_general() then
						if gr:army():general_character():is_visible_to_faction(cm:get_local_faction_name()) then
							in_settlement_climate.region_key = current_region:name();
							return true;
						end;
					end;
				end;
			end;
		end;
		return false;
	end
);

function in_settlement_climate_trigger()
	local region_key = in_settlement_climate.region_key;
	
	-- Your kind are not well-suited to this country, my Lord. Do not rush to establish a permanent presence here: it may be wiser to pillage all that you can and fall back to more hospitable lands.
	local advice_key = "wh2.camp.advice.inhospitable_climates.001";
	local infotext = {
		"wh2.camp.advice.settlement_climates.info_001",
		"wh2.camp.advice.settlement_climates.info_002",
		"wh2.camp.advice.settlement_climates.info_003"
	};
	
	in_settlement_climate:scroll_camera_to_settlement_for_intervention( 
		region_key, 
		advice_key, 
		infotext
	);
end;










---------------------------------------------------------------
--
--	unit_merging
--
---------------------------------------------------------------

-- intervention declaration
in_unit_merging = intervention:new(
	"unit_merging",	 														-- string name
	60, 																	-- cost
	function() in_unit_merging_trigger() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_unit_merging:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_unit_merging:add_advice_key_precondition("war.camp.advice.unit_merging.001");
in_unit_merging:set_min_turn(12);

in_unit_merging:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)		
		-- return true any of the player's non-armed-citzenry military forces have more than one unit of the same type at less than 50% health
		local player_faction = cm:get_faction(cm:get_local_faction_name());
		local mf_list = player_faction:military_force_list();
		
		for i = 0, mf_list:num_items() - 1 do
			local current_mf = mf_list:item_at(i);
			
			if not current_mf:is_armed_citizenry() then
				local unit_list = current_mf:unit_list();
				
				local damaged_units = {};
				
				for j = 0, unit_list:num_items() - 1 do
					local current_unit = unit_list:item_at(j);
					
					if current_unit:percentage_proportion_of_full_strength() < 50 then
						local unit_key = current_unit:unit_key();
						
						if damaged_units[unit_key] then
							in_unit_merging.mf_cqi = current_mf:command_queue_index();
							
							if current_mf:has_general() then
								in_unit_merging.char_cqi = current_mf:general_character():cqi();
							end;
							return true;
						else
							damaged_units[unit_key] = true;
						end;
					end;					
				end;
			end;
		end;

		return false;
	end
);

function in_unit_merging_trigger()
	local char_cqi = in_unit_merging.char_cqi;
	
	-- Consider merging some units in this army, my Lord. They will be better placed to survive the battles that are to come.
	local advice_key = "war.camp.advice.unit_merging.001";
	local infotext = {
		"war.camp.advice.unit_merging.info_001",
		"war.camp.advice.unit_merging.info_002",
		"war.camp.advice.unit_merging.info_003"
	};
	
	in_unit_merging:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key,
		infotext
	);
end;










---------------------------------------------------------------
--
--	winds_of_magic_changed
--
---------------------------------------------------------------

-- intervention declaration
in_winds_of_magic_changed = intervention:new(
	"winds_of_magic_changed",	 											-- string name
	70, 																	-- cost
	function() in_winds_of_magic_changed_trigger() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_winds_of_magic_changed:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_winds_of_magic_changed:add_advice_key_precondition("war.camp.advice.winds_of_magic.001");
in_winds_of_magic_changed:set_min_turn(5);

in_winds_of_magic_changed:add_trigger_condition(
	"ScriptEventPlayerRegionWindsOfMagicChanged",
	true
);

function in_winds_of_magic_changed_trigger()
	
	-- The Winds of Magic blow across the land, my Lord. Those who can harness it gain access to formidable power.
	local advice_key = "war.camp.advice.winds_of_magic.001";
	local infotext = {
		"war.camp.advice.winds_of_magic.info_001",
		"war.camp.advice.winds_of_magic.info_002",
		"war.camp.advice.winds_of_magic.info_003"
	};
	
	in_winds_of_magic_changed:play_advice_for_intervention( 
		advice_key, 
		infotext
	);
	
	-- allow event message
	cm:whitelist_event_feed_event_type("world_winds_of_magic_changeevent_feed_target_faction");
end;











---------------------------------------------------------------
--
--	enemy_province_capital
--
---------------------------------------------------------------

-- intervention declaration
in_enemy_province_capital = intervention:new(
	"enemy_province_capital",	 											-- string name
	70, 																	-- cost
	function() in_enemy_province_capital_trigger() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_enemy_province_capital:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_enemy_province_capital:add_advice_key_precondition("war.camp.advice.siege_warfare.001");
in_enemy_province_capital:set_min_turn(6);

in_enemy_province_capital:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)		
		-- return true if an adjacent enemy holds a province capital
		local player_faction = context:faction();
		local player_faction_name = player_faction:name();

		local checked_adjacent_regions = {};

		local closest_distance = false;
		local closest_enemy_region = false;

		local region_list = player_faction:region_list();

		for i, region in model_pairs(region_list) do
			local adjacent_regions = region:adjacent_region_list();

			for j, adjacent_region in model_pairs(adjacent_regions) do
				if not checked_adjacent_regions[adjacent_region:name()] then
					checked_adjacent_regions[adjacent_region:name()] = true;

					if adjacent_region:is_province_capital() and not adjacent_region:is_abandoned() and adjacent_region:owning_faction():at_war_with(player_faction) then
						local gc = cm:get_garrison_commander_of_region(adjacent_region);

						if gc and gc:is_visible_to_faction(player_faction_name) then
							local adjacent_settlement = adjacent_region:settlement();
							local _, current_closest_distance = cm:get_closest_character_from_faction(player_faction, gc:logical_position_x(), gc:logical_position_y());

							if not closest_distance or current_closest_distance < closest_distance then
								closest_distance = current_closest_distance;
								closest_enemy_region = adjacent_region;
							end;
						end;
					end;
				end;
			end;
		end;

		if closest_enemy_region then
			in_enemy_province_capital.region_key = closest_enemy_region:name();
			return true;
		end;
	end
);

function in_enemy_province_capital_trigger()
	local region_key = in_enemy_province_capital.region_key;
	
	-- Major enemy cities will be fortified, Sire. The capture of such citadels will likely mean a long siege.
	local advice_key = "war.camp.advice.siege_warfare.001";
	local infotext = {
		"war.camp.advice.siege_warfare.info_001",
		"war.camp.advice.siege_warfare.info_002",
		"war.camp.advice.siege_warfare.info_003"
	};
	
	in_enemy_province_capital:scroll_camera_to_settlement_for_intervention(
		region_key,
		advice_key,
		infotext
	);
end;
















---------------------------------------------------------------
--
--	Zones of Control
--
---------------------------------------------------------------

-- intervention declaration
--[[
in_zones_of_control = intervention:new(
	"zones_of_control",	 														-- string name
	50, 																		-- cost
	function() in_zones_of_control_trigger() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_zones_of_control:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_zones_of_control:add_precondition(function() return not cm:help_page_seen("zones_of_control") end);
in_zones_of_control:add_advice_key_precondition("war.camp.advice.zones_of_control.001");
in_zones_of_control:set_min_turn(11);

in_zones_of_control:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		-- return true the player is at war
		return cm:get_faction(cm:get_local_faction_name()):at_war();
	end
);

function in_zones_of_control_trigger()
	
	-- Use your armies to exert control over the theatre of war, Sire. Place men in passes to control their use, and study the enemy positions to find the best avenues of attack.
	local advice_key = "war.camp.advice.zones_of_control.001";
	local infotext = {
		"war.camp.advice.zones_of_control.info_001",
		"war.camp.advice.zones_of_control.info_002",
		"war.camp.advice.zones_of_control.info_003"
	};

	in_zones_of_control:play_advice_for_intervention(
		advice_key,
		infotext
	);
end;
]]

















---------------------------------------------------------------
--
--	Horde sighted
--
---------------------------------------------------------------

-- intervention declaration
in_hordes = intervention:new(
	"hordes",	 																-- string name
	30, 																		-- cost
	function() in_hordes_trigger() end,											-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_hordes:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hordes:add_advice_key_precondition("war.camp.advice.hordes.001");
in_hordes:set_min_turn(7);

in_hordes:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		local player_faction = cm:get_faction(cm:get_local_faction_name());
		local faction_list = player_faction:factions_met();
			
		for i = 0, faction_list:num_items() - 1 do
			local current_faction = faction_list:item_at(i);
			
			if current_faction:culture() ~= "wh2_main_def_dark_elves" and wh_faction_is_horde(current_faction) and not string.find(current_faction:name(), "intervention") then
				local mf_list = current_faction:military_force_list();
				
				for j = 1, mf_list:num_items() - 1 do
					local current_mf = mf_list:item_at(j);
					
					if current_mf:has_general() and current_mf:general_character():is_visible_to_faction(cm:get_local_faction_name()) then
						in_hordes.char_cqi = current_mf:general_character():cqi();
						in_hordes.faction_name = current_faction:name();
						return true;
					end;
				end;
			end;
		end;
		return false;
	end
);

function in_hordes_trigger()

	local char_cqi = in_hordes.char_cqi;
	
	-- A horde has been observed nearby, my Lord. Such people march with their whole civilisation in tow. Drive them away if they attempt to settle in your lands, as they bring great disruption as they travel.
	local advice_key = "war.camp.advice.hordes.001";
	local infotext = {
		"war.camp.advice.hordes.info_001",
		"war.camp.advice.hordes.info_002",
		"war.camp.advice.hordes.info_003"
	};
	
	in_hordes:scroll_camera_to_character_for_intervention(
		char_cqi,
		advice_key,
		infotext
	);
end;
















---------------------------------------------------------------
--
--	Attrition chaos (player is non-chaos)
--
---------------------------------------------------------------

-- intervention declaration
in_attrition_chaos = intervention:new(
	"attrition_chaos",	 														-- string name
	30, 																		-- cost
	function() in_attrition_chaos_trigger() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_attrition_chaos:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_attrition_chaos:set_reduce_pause_before_triggering(true);		-- do this so we get no grace period
-- in_attrition_chaos:add_advice_key_precondition("war.camp.advice.corruption.005");

in_attrition_chaos:add_precondition(
	function()
		return not common.get_advice_history_string_seen("chaos_attrition");
	end
);

in_attrition_chaos:add_trigger_condition(
	"CharacterEntersAttritionalArea",
	function(context)
		local character = context:character();
		if character:faction():name() == cm:get_local_faction_name() and character:has_region() and character:action_points_remaining_percent() > 0 then			
			if cm:get_highest_corruption_in_region(character:region()) == chaos_corruption_string then
				in_attrition_chaos.char_cqi = character:cqi();
				return true;
			end;
		end;
		return false;
	end
);

function in_attrition_chaos_trigger()
	local char_cqi = in_attrition_chaos.char_cqi;
	
	common.set_advice_history_string_seen("chaos_attrition");
	
	-- The foul taint of this place weakens your warriors, my Lord. Do not linger here without good reason.
	local advice_key = "war.camp.advice.corruption.005";
	local infotext = {
		"war.camp.advice.attrition.info_001",
		"war.camp.advice.attrition.info_002",
		"war.camp.advice.attrition.info_004",
		"war.camp.advice.attrition.info_003"
	};
	
	in_attrition_chaos:scroll_camera_to_character_for_intervention(
		char_cqi,
		advice_key,
		infotext
	);
end;












---------------------------------------------------------------
--
--	Attrition vampire (player is non-vampire)
--
---------------------------------------------------------------

-- intervention declaration
in_attrition_vampire = intervention:new(
	"attrition_vampire",	 													-- string name
	30, 																		-- cost
	function() in_attrition_vampire_trigger() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_attrition_vampire:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_attrition_vampire:set_reduce_pause_before_triggering(true);		-- do this so we get no grace period
in_attrition_vampire:add_advice_key_precondition("war.camp.advice.corruption.005");

in_attrition_vampire:add_precondition(
	function()
		return not common.get_advice_history_string_seen("vampire_attrition");
	end
);

in_attrition_vampire:add_trigger_condition(
	"CharacterEntersAttritionalArea",
	function(context)
		local character = context:character();
		if character:faction():name() == cm:get_local_faction_name() and character:has_region() and character:action_points_remaining_percent() > 0 then			
			if cm:get_highest_corruption_in_region(character:region()) == vampiric_corruption_string then
				in_attrition_vampire.char_cqi = character:cqi();
				return true;
			end;
		end;
		return false;
	end
);


function in_attrition_vampire_trigger()
	local char_cqi = in_attrition_vampire.char_cqi;
	
	common.set_advice_history_string_seen("vampire_attrition");
	
	-- The foul taint of this place weakens your warriors, my Lord. Do not linger here without good reason.
	local advice_key = "war.camp.advice.corruption.005";
	local infotext = {
		"war.camp.advice.attrition.info_001",
		"war.camp.advice.attrition.info_002",
		"war.camp.advice.attrition.info_005",
		"war.camp.advice.attrition.info_003"
	};
	
	in_attrition_vampire:scroll_camera_to_character_for_intervention(
		char_cqi,
		advice_key,
		infotext
	);
end;











---------------------------------------------------------------
--
--	Attrition general (not related to corruption)
--
---------------------------------------------------------------

-- intervention declaration
in_attrition_general = intervention:new(
	"attrition_general",	 													-- string name
	30, 																		-- cost
	function() in_attrition_general_trigger() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_attrition_general:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_attrition_general:set_reduce_pause_before_triggering(true);		-- do this so we get no grace period
in_attrition_general:add_advice_key_precondition("war.camp.advice.attrition.001");

in_attrition_general:add_trigger_condition(
	"CharacterEntersAttritionalArea",
	function(context)
		local character = context:character();
		
		if character:faction():name() == cm:get_local_faction_name() and character:action_points_remaining_percent() > 0 and character:faction():treasury() > 0 then
			if not character:has_region() then
				-- character has no region - they must be at sea, so return true
				in_attrition_general.char_cqi = character:cqi();
				return true;
			end;			
			
			local region = character:region();
			local region_corruption = cm:get_highest_corruption_in_region(region);
			local faction = character:faction();
			
			-- if player char is vampire counts, return true if they're in vampire territory and false otherwise
			if faction:culture() == "wh_main_vmp_vampire_counts" then
				if region_corruption == vampiric_corruption_string then
					in_attrition_general.char_cqi = character:cqi();
					return true;
				end;
				
			-- otherwise if player char is chaos or beastmen, return true if they're in chaos territory and false otherwise
			elseif faction:culture() == "wh_main_chs_chaos" or faction:culture() == "wh_dlc08_nor_norsca" or faction:culture() == "wh_dlc03_bst_beastmen" then
				if region_corruption == chaos_corruption_string then
					in_attrition_general.char_cqi = character:cqi();
					return true;
				end;
			
			-- otherwise return true if the region has no corruption
			elseif not region_corruption then
				in_attrition_general.char_cqi = character:cqi();
				return true;
			end;
		end;
		return false;
	end
);

function in_attrition_general_trigger()
	local char_cqi = in_attrition_general.char_cqi;
	
	-- Your army suffers in the miserable conditions they find themselves, my lord. Move them on, or more warriors will fall to the elements.
	local advice_key = "war.camp.advice.attrition.001";
	local infotext = {
		"war.camp.advice.attrition.info_001",
		"war.camp.advice.attrition.info_002",
		"war.camp.advice.attrition.info_007"
	};
	
	in_attrition_general:scroll_camera_to_character_for_intervention(
		char_cqi,
		advice_key,
		infotext
	);
end;











---------------------------------------------------------------
--
--	Attrition untainted
--	triggers for vampire factions when they enter
--	untainted territory
--
---------------------------------------------------------------

-- intervention declaration
in_vmp_attrition_untainted = intervention:new(
	"vmp_attrition_untainted",	 												-- string name
	30, 																		-- cost
	function() in_vmp_attrition_untainted_trigger() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_vmp_attrition_untainted:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_vmp_attrition_untainted:set_reduce_pause_before_triggering(true);		-- do this so we get no grace period
in_vmp_attrition_untainted:add_advice_key_precondition("wh2.camp.advice.undead_attrition.001");

in_vmp_attrition_untainted:add_trigger_condition(
	"CharacterEntersAttritionalArea",
	function(context)
		local character = context:character();
		
		-- return true if a player character suffers attrition in an untainted region
		if character:faction():name() == cm:get_local_faction_name() and character:has_region() and not cm:get_highest_corruption_in_region(character:region()) then
			in_vmp_attrition_untainted.char_cqi = character:cqi();
			return true;
		end;
		return false;
	end
);


function in_vmp_attrition_untainted_trigger()
	local char_cqi = in_vmp_attrition_untainted.char_cqi;
	
	-- Move quickly through the land of the living, dark Lord. The dead should not linger in untainted country.
	local advice_key = "wh2.camp.advice.undead_attrition.001";
	local infotext = {
		"war.camp.advice.attrition.info_001",
		"war.camp.advice.attrition.info_006",
		"war.camp.advice.attrition.info_007"
	};
	
	in_vmp_attrition_untainted:scroll_camera_to_character_for_intervention(
		char_cqi,
		advice_key,
		infotext
	);
end;











---------------------------------------------------------------
--
--	Enemy Threaten Settlement
--
---------------------------------------------------------------

-- intervention declaration
in_enemy_threaten_settlement = intervention:new(
	"enemy_threaten_settlement",	 											-- string name
	50, 																		-- cost
	function() in_enemy_threaten_settlement_trigger() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_enemy_threaten_settlement:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_enemy_threaten_settlement:add_advice_key_precondition("war.camp.advice.garrison_armies.002");
in_enemy_threaten_settlement:set_min_turn(8);
in_enemy_threaten_settlement:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_enemy_threaten_settlement:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local player_faction = cm:get_faction(cm:get_local_faction_name());
		local player_faction_regions = player_faction:region_list();
		local enemy_factions = player_faction:factions_at_war_with();
		
		-- go through each military force of each enemy of the player
		for i = 0, enemy_factions:num_items() - 1 do
			local current_faction = enemy_factions:item_at(i);
			local enemy_force_list = current_faction:military_force_list();
			
			for j = 0, enemy_force_list:num_items() - 1 do
				local current_mf = enemy_force_list:item_at(j);
				
				if current_mf:has_general() and not current_mf:is_armed_citizenry() then
					local current_mf_general = current_mf:general_character();
					local current_mf_num_units = current_mf:unit_list():num_items();
					
					-- for each enemy enemy force, test whether it can reach each of the settlements controlled by the player
					for k = 0, player_faction_regions:num_items() - 1 do
						local current_player_region = player_faction_regions:item_at(k);
						local current_player_gr = current_player_region:garrison_residence();
						
						if not current_player_gr:is_under_siege() then
							local garrison_army = cm:get_armed_citizenry_from_garrison(current_player_gr);
							
							if garrison_army and garrison_army:has_general() then
								local garrison_commander = garrison_army:general_character();
								
								if cm:character_can_reach_character(current_mf_general, garrison_commander) then
									-- the enemy army commander can reach the settlement this turn
									local num_defending_units = garrison_army:unit_list():num_items();
									
									-- see if there are any other player forces nearby
									local current_player_settlement = current_player_region:settlement();
									local settlement_x = current_player_settlement:logical_position_x();
									local settlement_y = current_player_settlement:logical_position_y();
									
									local closest_player_army_commander = cm:get_closest_general_to_position_from_faction(player_faction, settlement_x, settlement_y);
									
									if distance_squared(settlement_x, settlement_y, closest_player_army_commander:logical_position_x(), closest_player_army_commander:logical_position_y()) < 36 then
										num_defending_units = num_defending_units + closest_player_army_commander:military_force():unit_list():num_items();
									end;
									
									-- compare the size of the enemy force against the garrison army + any other local allies
									if num_defending_units < current_mf_num_units then
										-- this force is threatening enough to the settlement and any other local defenders, return true
										in_enemy_threaten_settlement.char_cqi = current_mf_general:cqi();
										return true;
									end;
								end;
							end;
						end;
					end;
				end;
			end;
		end;
		
		return false;
	end
);



function in_enemy_threaten_settlement_trigger()
	local char_cqi = in_enemy_threaten_settlement.char_cqi;
	
	-- The enemy threaten your city here, my Lord! The garrison stand ready to defend it, but consider sending extra troops.
	local advice_key = "war.camp.advice.garrison_armies.002";
	local infotext = {
		"war.camp.advice.garrison_armies.info_001",
		"war.camp.advice.garrison_armies.info_002",
		"war.camp.advice.garrison_armies.info_003"
	};

	if cm:get_character_by_cqi(char_cqi) then
		in_enemy_threaten_settlement:scroll_camera_to_character_for_intervention( 
			char_cqi, 
			advice_key, 
			infotext
		);
	else
		in_enemy_threaten_settlement:play_advice_for_intervention(
			advice_key,
			infotext
		);
	end;
end;















---------------------------------------------------------------
--
--	Foreign Hero Spotted
--
---------------------------------------------------------------

-- intervention declaration
in_foreign_hero = intervention:new(
	"foreign_hero",	 															-- string name
	50, 																		-- cost
	function() in_foreign_hero_trigger() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_foreign_hero:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_foreign_hero:add_advice_key_precondition("war.camp.advice.heroes.002");
in_foreign_hero:set_min_turn(3);

-- stop monitor if the player has a hero
in_foreign_hero:add_precondition(
	function()		
		local char_list = cm:get_faction(cm:get_local_faction_name()):character_list();
		
		for i = 0, char_list:num_items() - 1 do
			if cm:char_is_agent(char_list:item_at(i)) then
				-- player has hero, stopping
				return false;
			end;
		end;
		return true;
	end
);

in_foreign_hero:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
	
		local player_faction = cm:get_faction(cm:get_local_faction_name());
		local foreign_factions = player_faction:factions_met();
		
		-- go through each character of each faction that the player has met, and return true if that character is a hero that is visible
		for i = 0, foreign_factions:num_items() - 1 do
			local char_list = foreign_factions:item_at(i):character_list();
			
			for j = 0, char_list:num_items() - 1 do
				local current_char = char_list:item_at(j);
				
				if current_char:is_visible_to_faction(cm:get_local_faction_name()) and cm:char_is_agent(current_char) then
					in_foreign_hero.char_cqi = current_char:cqi();
					return true;					
				end;
			end;
		end;
		
		return false;
	end
);

function in_foreign_hero_trigger()
	local char_cqi = in_foreign_hero.char_cqi;
	
	-- That is a Hero serving a foreign power, my Lord. Consider recruiting such an operative into your service. One being with the right skills can solve problems that no amount of coin or labour would otherwise be able to crack.
	local advice_key = "war.camp.advice.heroes.002";
	local infotext = {
		"war.camp.advice.heroes.info_001",
		"war.camp.advice.heroes.info_002",
		"war.camp.advice.heroes.info_005"
	};

	if cm:get_character_by_cqi(char_cqi) then
		in_foreign_hero:scroll_camera_to_character_for_intervention( 
			char_cqi, 
			advice_key, 
			infotext
		);
	else
		in_foreign_hero:play_advice_for_intervention(
			advice_key,
			infotext
		);
	end;
end;








---------------------------------------------------------------
--
--	Global Recruitment opened
--
---------------------------------------------------------------

-- intervention declaration
in_global_recruitment = intervention:new(
	"global_recruitment",	 													-- string name
	80, 																		-- cost
	function() in_global_recruitment_trigger() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_global_recruitment:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_global_recruitment:set_wait_for_fullscreen_panel_dismissed(false);
in_global_recruitment:add_advice_key_precondition("wh2.camp.advice.global_recruitment.001");

in_global_recruitment:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		if context.string ~= "units_recruitment" then
			return false;
		end;
		
		-- return true if the global recruitment queue has any children
		local uic_global_list = find_uicomponent(core:get_ui_root(), "main_units_panel", "global", "list_box");
		
		return uic_global_list and uic_global_list:ChildCount() > 0;
	end
);

function in_global_recruitment_trigger()	
	in_global_recruitment:play_advice_for_intervention(
		-- Global recruitment is available to boost your armies far from home, my Lord. Yet such flexibility comes at a price - build your forces close to home, where possible.
		"wh2.camp.advice.global_recruitment.001",
		{
			"wh2.camp.advice.unit_recruitment.info_001",
			"wh2.camp.advice.unit_recruitment.info_002",
			"wh2.camp.advice.unit_recruitment.info_003",
			"wh2.camp.advice.unit_recruitment.info_004"
		}
	);
end;








---------------------------------------------------------------
--
--	Horde Growth
--
---------------------------------------------------------------

-- intervention declaration
in_horde_growth = intervention:new(
	"horde_growth",	 															-- string name
	30, 																		-- cost
	function() in_horde_growth_trigger() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_horde_growth:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_horde_growth:add_advice_key_precondition("war.camp.advice.growth.002");
in_horde_growth:set_min_turn(2);


in_horde_growth:add_trigger_condition(
	"MilitaryForceDevelopmentPointChange",
	function(context)
		local mf_faction = context:military_force():faction();
		
		if mf_faction:name() ~= cm:get_local_faction_name() or mf_faction:subculture() == "wh2_main_sc_def_dark_elves" then
			return false;
		end;
		
		if mf_faction:name() == cm:get_local_faction_name() and mf_faction:subculture() ~= "wh2_main_sc_def_dark_elves" and context:point_change() > 0 and context:military_force():has_general() then
			in_horde_growth.char_cqi = context:military_force():general_character():cqi();
			return true;
		end;
		return false;
	end
);

function in_horde_growth_trigger()
	local char_cqi = in_horde_growth.char_cqi;
	
	-- Your following grows, mighty Lord. Put your new hands to work: have them raise new infrastructure to improve your camp, and further your war effort.
	local advice_key = "war.camp.advice.growth.002";
	local infotext = {
		"war.camp.advice.horde_growth.info_001",
		"war.camp.advice.horde_growth.info_002",
		"war.camp.advice.horde_growth.info_003",
		"war.camp.advice.horde_growth.info_004"
	};

	if cm:get_character_by_cqi(char_cqi) then
		in_horde_growth:scroll_camera_to_character_for_intervention( 
			char_cqi, 
			advice_key, 
			infotext
		);
	else
		in_horde_growth:play_advice_for_intervention(
			advice_key,
			infotext
		);
	end;
end;





---------------------------------------------------------------
--
--	elven council/gathering of the ancients panel
--
---------------------------------------------------------------

-- intervention declaration
in_elven_council = intervention:new(
	"elven_council",	 														-- string name
	5, 																			-- cost
	function() in_elven_council_trigger() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_elven_council:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_elven_council:add_advice_key_precondition("dlc05.camp.advice.wef.elven_council.001");
in_elven_council:add_advice_key_precondition("dlc05.camp.advice.wef.gathering_of_the_ancients.001");
in_elven_council:set_wait_for_fullscreen_panel_dismissed(false);


in_elven_council:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		return context.string == "offices";
	end
);

function in_elven_council_trigger()
	local faction_name = cm:whose_turn_is_it_single()

	-- The strength of the forest realms is governed by the Elven Council. Here, the noble Lords and Ladies of Athel Loren bestow the forest's great wisdom and knowledge upon their subjects.
	local advice_key
	local infotext = {}

	if faction_name == "wh_dlc05_wef_argwylon" then
		advice_key = "dlc05.camp.advice.wef.gathering_of_the_ancients.001";
		infotext = {
			"war.camp.advice.gathering_of_the_ancients.info_001",
			"war.camp.advice.gathering_of_the_ancients.info_002",
			"war.camp.advice.gathering_of_the_ancients.info_003"
		};
	else
		advice_key = "dlc05.camp.advice.wef.elven_council.001";
		infotext = {
			"war.camp.advice.elven_council.info_001",
			"war.camp.advice.elven_council.info_002",
			"war.camp.advice.elven_council.info_003"
		};
	end;
	
	in_elven_council:play_advice_for_intervention(
		advice_key,
		infotext
	);
end;










---------------------------------------------------------------
--
--	amber
--
---------------------------------------------------------------
--[[
-- intervention declaration
in_amber = intervention:new(
	"amber",	 												-- string name
	40, 														-- cost
	function() in_amber_advice_trigger() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_amber:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_amber:set_min_turn(5);
in_amber:add_advice_key_precondition("dlc05.camp.advice.wef.amber.001");

in_amber:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()
		return true;
	end
);


function in_amber_advice_trigger()
	in_amber:play_advice_for_intervention(
		-- Formed from resin from the Oak of Ages' broken roots, Amber can be found across the world. If Athel Loren is to be protected from those who wish the forest harm, then as much as possible must be recovered.
		"dlc05.camp.advice.wef.amber.001",
		{
			"war.camp.advice.amber.info_001",
			"war.camp.advice.amber.info_002",
			"war.camp.advice.amber.info_003"
		}
	);
end;










---------------------------------------------------------------
--
--	negative amber
--
---------------------------------------------------------------

-- intervention declaration
in_negative_amber = intervention:new(
	"negative_amber",	 												-- string name
	40, 																-- cost
	function() in_negative_amber_advice_trigger() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_negative_amber:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_negative_amber:add_advice_key_precondition("dlc05.camp.advice.wef.amber.002");

in_negative_amber:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local player_faction = cm:get_faction(cm:get_local_faction_name())
		
		return player_faction:total_food() < 0;
	end
);


function in_negative_amber_advice_trigger()
	in_negative_amber:play_advice_for_intervention(
		-- Your Amber wealth has been depleted, my Lord. Now, there is a deficit - this will cause issues if the situation is left unresolved. Find more and return it to Athel Loren with haste!
		"dlc05.camp.advice.wef.amber.002",
		{
			"war.camp.advice.amber.info_001",
			"war.camp.advice.amber.info_002",
			"war.camp.advice.amber.info_003"
		}
	);
end;
]]--








--[[
---------------------------------------------------------------
--
--	oak of ages
--
---------------------------------------------------------------

-- intervention declaration
in_oak_of_ages = intervention:new(
	"oak_of_ages",	 											-- string name
	20, 														-- cost
	function() in_oak_of_ages_advice_trigger() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_oak_of_ages:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_oak_of_ages:set_min_turn(3);
in_oak_of_ages:add_advice_key_precondition("dlc05.camp.advice.wef.oak_of_ages.001");

in_oak_of_ages:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()
		local oak_of_ages_region_name = "wh3_main_combi_region_the_oak_of_ages";
		
		if cm:model():campaign_name("wh_dlc05_wood_elves") == true then
			oak_of_ages_region_name = "wh_dlc05_oak_of_ages";
		end;
		
		local oak_of_ages_region = cm:get_region(oak_of_ages_region_name);
		local player_faction = cm:get_faction(cm:get_local_faction_name());
		
		if oak_of_ages_region:owning_faction() == player_faction then
			in_oak_of_ages.region_name = oak_of_ages_region_name;			
			return true;
		else
			return false;
		end;
	end
);

in_oak_of_ages:add_trigger_condition(
	"SettlementSelected",
	function(context)
		local region = context:garrison_residence():region();
		local region_name = region:name();
		local player_faction = cm:get_faction(cm:get_local_faction_name());
		
		return (region_name == "wh3_main_combi_region_the_oak_of_ages" or region_name == "wh_dlc05_oak_of_ages") and region:owning_faction() == player_faction and player_faction:is_factions_turn();
	end
);


function in_oak_of_ages_advice_trigger()
	local region_name = in_oak_of_ages.region_name;
	
	-- The Oak of Ages is the source of all life in the forest. Treat it with care and it will flourish; neglect its wellbeing and leave Athel Loren wide open before the forces of destruction!
	local advice_key = "dlc05.camp.advice.wef.oak_of_ages.001";
	local infotext = {
		"war.camp.advice.oak_of_ages.info_001",
		"war.camp.advice.oak_of_ages.info_002",
		"war.camp.advice.oak_of_ages.info_003"
	}

	if region_name then
		in_oak_of_ages:scroll_camera_to_settlement_for_intervention(
			region_name,
			advice_key,
			infotext
		);
	else
		in_oak_of_ages:play_advice_for_intervention(
			advice_key,
			infotext
		);
	end;
end;










---------------------------------------------------------------
--
--	oak of ages construction level 2
--
---------------------------------------------------------------

-- intervention declaration
in_oak_of_ages_construction_2 = intervention:new(
	"oak_of_ages_construction_2",	 									-- string name
	5, 																	-- cost
	function() in_oak_of_ages_construction_2_advice_trigger() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_oak_of_ages_construction_2:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_oak_of_ages:add_advice_key_precondition("dlc05.camp.advice.wef.oak_of_ages.002");

in_oak_of_ages_construction_2:add_trigger_condition(
	"BuildingCompleted",
	function(context)
		if cm:model():campaign_name("wh_dlc05_wood_elves") == false then
			local building = context:building();
			local building_name = building:name();
		
			if (building_name == "wh_dlc05_wef_oak_of_ages_2" or building_name == "wh_dlc05_wef_oak_of_ages_mini_2") and building:faction():name() == cm:get_local_faction_name() then
				in_oak_of_ages_construction_2.region_name = building:region():name();
				return true;
			else
				return false;
			end
		end
	end
);


function in_oak_of_ages_construction_2_advice_trigger()
	local region_name = in_oak_of_ages_construction_2.region_name;
	
		-- The mighty Oak of Ages blooms, pushing its canopy further over Athel Loren’s enchanting glades.
		advice_key = "dlc05.camp.advice.wef.oak_of_ages.003";
		-- Magnificent, my Lord! The Oak of Ages flourishes under your benevolent nurture.
		advice_key = "dlc05.camp.advice.wef.oak_of_ages.004";
		-- The forest rejoices, my Lord, at the wonder that is the Oak of Ages! The Asrai know now that nothing is to be feared, and all will be as the forest intends.
		advice_key = "dlc05.camp.advice.wef.oak_of_ages.005";

	in_oak_of_ages_construction_2:scroll_camera_to_settlement_for_intervention(
		region_name,
		-- At Athel Loren's centre, the glorious Oak of Ages blossoms into life.
		"dlc05.camp.advice.wef.oak_of_ages.002",
		{
			"war.camp.advice.oak_of_ages.info_001",
			"war.camp.advice.oak_of_ages.info_002",
			"war.camp.advice.oak_of_ages.info_003"
		}
	);
end;










---------------------------------------------------------------
--
--	oak of ages construction level 3
--
---------------------------------------------------------------

-- intervention declaration
in_oak_of_ages_construction_3 = intervention:new(
	"oak_of_ages_construction_3",	 									-- string name
	5, 																	-- cost
	function() in_oak_of_ages_construction_3_advice_trigger() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_oak_of_ages_construction_3:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_oak_of_ages:add_advice_key_precondition("dlc05.camp.advice.wef.oak_of_ages.003");

in_oak_of_ages_construction_3:add_trigger_condition(
	"BuildingCompleted",
	function(context)
		if cm:model():campaign_name("wh_dlc05_wood_elves") == false then
			local building = context:building();
			local building_name = building:name();
		
			if (building_name == "wh_dlc05_wef_oak_of_ages_3" or building_name == "wh_dlc05_wef_oak_of_ages_mini_3") and building:faction():name() == cm:get_local_faction_name() then
				in_oak_of_ages_construction_3.region_name = building:region():name();
				return true;
			else
				return false;
			end
		end
	end
);


function in_oak_of_ages_construction_3_advice_trigger()
	local region_name = in_oak_of_ages_construction_3.region_name;

	in_oak_of_ages_construction_3:scroll_camera_to_settlement_for_intervention(
		region_name,
		-- The mighty Oak of Ages blooms, pushing its canopy further over Athel Loren’s enchanting glades.
		"dlc05.camp.advice.wef.oak_of_ages.003",
		{
			"war.camp.advice.oak_of_ages.info_001",
			"war.camp.advice.oak_of_ages.info_002",
			"war.camp.advice.oak_of_ages.info_003"
		}
	);
end;










---------------------------------------------------------------
--
--	oak of ages construction level 4
--
---------------------------------------------------------------

-- intervention declaration
in_oak_of_ages_construction_4 = intervention:new(
	"oak_of_ages_construction_4",	 									-- string name
	5, 																	-- cost
	function() in_oak_of_ages_construction_4_advice_trigger() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_oak_of_ages_construction_4:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_oak_of_ages:add_advice_key_precondition("dlc05.camp.advice.wef.oak_of_ages.004");

in_oak_of_ages_construction_4:add_trigger_condition(
	"BuildingCompleted",
	function(context)
		if cm:model():campaign_name("wh_dlc05_wood_elves") == false then
			local building = context:building();
			local building_name = building:name();
		
			if (building_name == "wh_dlc05_wef_oak_of_ages_4" or building_name == "wh_dlc05_wef_oak_of_ages_mini_4") and building:faction():name() == cm:get_local_faction_name() then
				in_oak_of_ages_construction_4.region_name = building:region():name();
				return true;
			else
				return false;
			end
		end
	end
);


function in_oak_of_ages_construction_4_advice_trigger()
	local region_name = in_oak_of_ages_construction_4.region_name;		

	in_oak_of_ages_construction_4:scroll_camera_to_settlement_for_intervention(
		region_name,
		-- Magnificent, my Lord! The Oak of Ages flourishes under your benevolent nurture.
		"dlc05.camp.advice.wef.oak_of_ages.004",
		{
			"war.camp.advice.oak_of_ages.info_001",
			"war.camp.advice.oak_of_ages.info_002",
			"war.camp.advice.oak_of_ages.info_003"
		}
	);
end;










---------------------------------------------------------------
--
--	oak of ages construction level 5
--
---------------------------------------------------------------

-- intervention declaration
in_oak_of_ages_construction_5 = intervention:new(
	"oak_of_ages_construction_5",	 									-- string name
	5, 																	-- cost
	function() in_oak_of_ages_construction_5_advice_trigger() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_oak_of_ages_construction_5:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_oak_of_ages:add_advice_key_precondition("dlc05.camp.advice.wef.oak_of_ages.005");

in_oak_of_ages_construction_5:add_trigger_condition(
	"BuildingCompleted",
	function(context)
		if cm:model():campaign_name("wh_dlc05_wood_elves") == false then
			local building = context:building();
		
			if building:name() == "wh_dlc05_wef_oak_of_ages_5" and building:faction():name() == cm:get_local_faction_name() then
				in_oak_of_ages_construction_5.region_name = building:region():name();
				return true;
			else
				return false;
			end
		end
	end
);


function in_oak_of_ages_construction_5_advice_trigger()
	local region_name = in_oak_of_ages_construction_5.region_name;

	in_oak_of_ages_construction_5:scroll_camera_to_settlement_for_intervention(
		region_name,
		-- The forest rejoices, my Lord, at the wonder that is the Oak of Ages! The Asrai know now that nothing is to be feared, and all will be as the forest intends.
		"dlc05.camp.advice.wef.oak_of_ages.005",
		{
			"war.camp.advice.oak_of_ages.info_001",
			"war.camp.advice.oak_of_ages.info_002",
			"war.camp.advice.oak_of_ages.info_003"
		}
	);
end;



]]--






---------------------------------------------------------------
--
--	elven halls
--
---------------------------------------------------------------

-- intervention declaration
in_elven_halls = intervention:new(
	"elven_halls",	 													-- string name
	20, 																-- cost
	function() in_elven_halls_advice_trigger() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_elven_halls:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_elven_halls:add_advice_key_precondition("dlc05.camp.advice.wef.elven_halls.001");

in_elven_halls:add_trigger_condition(
	"SettlementSelected",
	function(context)
		local region = context:garrison_residence():region();
		
		return region:owning_faction():name() == cm:get_local_faction_name() and region:slot_list():item_at(0):building():chain() == "wh_dlc05_wef_settlement_major";
	end
);


function in_elven_halls_advice_trigger()
	in_elven_halls:play_advice_for_intervention(
		-- Mighty halls stand tall among Athel Loren's multifarious glades. Although not protected by walls of brick and stone, intruders are kept at bay by the forest itself, extending a branch or root and dragging trespassers to a smothering, leafy doom.
		"dlc05.camp.advice.wef.elven_halls.001",
		{
			"war.camp.advice.elven_halls.info_001",
			"war.camp.advice.elven_halls.info_002",
			"war.camp.advice.elven_halls.info_003"
		}
	);
end;










---------------------------------------------------------------
--
--	asrai lookouts
--
---------------------------------------------------------------

-- intervention declaration
in_asrai_lookouts = intervention:new(
	"asrai_lookouts",	 													-- string name
	20, 																	-- cost
	function() in_asrai_lookouts_advice_trigger() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_asrai_lookouts:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_asrai_lookouts:set_min_turn(3);
in_asrai_lookouts:add_advice_key_precondition("dlc05.camp.advice.wef.asrai_lookouts.001");

in_asrai_lookouts:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local player_faction = cm:get_faction(cm:get_local_faction_name());
		local player_regions = player_faction:region_list();
		local enemy_region = nil;
		
		for i = 0, player_regions:num_items() - 1 do
			local current_region = player_regions:item_at(i);
			local current_adjacent_regions = current_region:adjacent_region_list();
			
			for j = 0, current_adjacent_regions:num_items() - 1 do
				local current_adjacent_region = current_adjacent_regions:item_at(j);
				local current_adjacent_region_owner = current_adjacent_region:owning_faction();
				
				if current_adjacent_region_owner:culture() ~= "wh_dlc05_wef_wood_elves" and current_adjacent_region_owner:at_war_with(player_faction) then
					enemy_region = current_adjacent_region:name();
					in_asrai_lookouts.region_name = enemy_region;
					
					break;
				end;
			end;
			
			break;
		end;
		
		if enemy_region then
			return true;
		else
			return false;
		end;
	end
);


function in_asrai_lookouts_advice_trigger()
	local region_name = in_asrai_lookouts.region_name;

	in_asrai_lookouts:scroll_camera_to_settlement_for_intervention(
		region_name,
		-- The lands beyond the forest are rich and prosperous. Claim them for the Asrai and ensure their return to nature's loving, leafy embrace.
		"dlc05.camp.advice.wef.asrai_lookouts.001",
		{
			"war.camp.advice.asrai_lookouts.info_001",
			"war.camp.advice.asrai_lookouts.info_002",
			"war.camp.advice.asrai_lookouts.info_003"
		}
	);
end;










---------------------------------------------------------------
--
--	asrai lookout constructed
--
---------------------------------------------------------------
--[[
-- intervention declaration
in_asrai_lookout_constructed = intervention:new(
	"asrai_lookout_constructed",	 										-- string name
	10, 																	-- cost
	function() in_asrai_lookout_constructed_advice_trigger() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_asrai_lookout_constructed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_asrai_lookout_constructed:add_advice_key_precondition("dlc05.camp.advice.wef.asrai_lookouts.002");

in_asrai_lookout_constructed:add_trigger_condition(
	"GarrisonOccupiedEvent",
	function(context)
		local player_faction = cm:get_faction(cm:get_local_faction_name());
		local garrison_residence = context:garrison_residence();
		
		if context:character():faction() == player_faction then
			local chain = garrison_residence:region():slot_list():item_at(0):building():chain();
			
			-- don't trigger the intervention if the player is capturing a Wood Elf settlement
			if string.find(chain, "wef_settlement") then
				return false;
			else
				in_asrai_lookout_constructed.region_name = garrison_residence:region():name();
				return true;
			end;
		end;
	end
);


function in_asrai_lookout_constructed_advice_trigger()
	local region_name = in_asrai_lookout_constructed.region_name;

	in_asrai_lookout_constructed:scroll_camera_to_settlement_for_intervention(
		region_name,
		-- It is time to establish your first Asrai Lookout beyond Athel Loren's woodland boughs. Establishing such outposts is vitally important, if you wish to conquer the Old World, with a precious piece of Amber your reward for each one constructed.
		"dlc05.camp.advice.wef.asrai_lookouts.002",
		{
			"war.camp.advice.asrai_lookouts.info_001",
			"war.camp.advice.asrai_lookouts.info_002",
			"war.camp.advice.asrai_lookouts.info_003"
		}
	);
end;










---------------------------------------------------------------
--
--	asrai lookout lost
--
---------------------------------------------------------------

-- intervention declaration
in_asrai_lookout_lost = intervention:new(
	"asrai_lookout_lost",	 												-- string name
	20, 																	-- cost
	function() in_asrai_lookout_lost_advice_trigger() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_asrai_lookout_lost:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_asrai_lookout_lost:add_advice_key_precondition("dlc05.camp.advice.wef.asrai_lookouts.003");

in_asrai_lookout_lost:add_trigger_condition(
	"ScriptEventFactionLostRegion",
	function(context)
		local chain = context:region():slot_list():item_at(0):building():chain();
		
		if string.find(chain, "wef_settlement") or string.find(chain, "oak_of_ages") then
			return false;
		else
			in_asrai_lookout_lost.region_name = context:region():name();
			return true;
		end;
	end
);


function in_asrai_lookout_lost_advice_trigger()
	local region_name = in_asrai_lookout_lost.region_name;

	in_asrai_lookout_lost:scroll_camera_to_settlement_for_intervention(
		region_name,
		-- Like the Worldroots before it, an Asrai Lookout has succumbed to the enemy, my Lord. Alas, a piece of Amber has been lost along with it.
		"dlc05.camp.advice.wef.asrai_lookouts.003",
		{
			"war.camp.advice.asrai_lookouts.info_001",
			"war.camp.advice.asrai_lookouts.info_002",
			"war.camp.advice.asrai_lookouts.info_003"
		}
	);
end;

]]--








---------------------------------------------------------------
--
--	worldroots
--
---------------------------------------------------------------

-- intervention declaration
in_worldroots = intervention:new(
	"worldroots",	 											-- string name
	5, 															-- cost
	function() in_worldroots_advice_trigger() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_worldroots:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_worldroots:set_min_turn(3);
in_worldroots:add_advice_key_precondition("dlc05.camp.advice.wef.worldroots.001");

in_worldroots:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()
		return true;
	end
);


function in_worldroots_advice_trigger()
	in_worldroots:play_advice_for_intervention(
		-- Deep beneath the earth lie the Worldroots, a network of enclosed passageways that connect the great forests of the Old World. Make use of them to quickly travel through otherwise hostile terrain.
		"dlc05.camp.advice.wef.worldroots.001",
		{
			"war.camp.advice.worldroots.info_001",
			"war.camp.advice.worldroots.info_002",
			"war.camp.advice.worldroots.info_003"
		}
	);
end;










---------------------------------------------------------------
--
--	wood elves final battle
--
---------------------------------------------------------------

-- intervention declaration
in_wef_final_battle = intervention:new(
	"wef_final_battle",	 										-- string name
	50, 														-- cost
	function() in_wef_final_battle_advice_trigger() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_wef_final_battle:set_min_advice_level(ADVICE_LEVEL_HIGH);

in_wef_final_battle:add_trigger_condition(
	"MissionIssued",
	function(context)
		local mission_key = context:mission():mission_record_key();
		return context:faction():name() == cm:get_local_faction_name() and (mission_key == "wh_dlc05_qb_wef_grand_defense_of_the_oak" or mission_key == "wh_dlc05_qb_wef_mini_silver_spire");
	end
);


function in_wef_final_battle_advice_trigger()
	in_wef_final_battle:play_advice_for_intervention(
		-- Though the invading hordes are falling back, my Lord, the Asrai now face one final battle. Let the Horn of Kurnous blast one last time in triumph, and rid the world of these foul creatures forever!
		"dlc05.camp.advice.wef.finale.001",
		{}
	);
end;





---------------------------------------------------------------
--
--	Wood Elves
--
---------------------------------------------------------------

-- intervention declaration
in_wood_elves = intervention:new(
	"wood_elves",					 													-- string name
	60, 																				-- cost
	function() in_wood_elves_trigger() end,												-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_wood_elves:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_wood_elves:add_advice_key_precondition("dlc05.camp.advice.wef.wood_elves.001");
in_wood_elves:add_precondition(function() return cm:is_subculture_in_campaign("wh_dlc05_sc_wef_wood_elves") end)
in_wood_elves:add_precondition(function() return cm:get_saved_value("advice_wood_elves_seen") ~= true end)
in_wood_elves:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);


in_wood_elves:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)			
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh_dlc05_sc_wef_wood_elves");
				
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_wood_elves_seen", true)
				return false
			end

			in_wood_elves.char_cqi = char:cqi();
			return true;
		end;
		return false;
	end
);


function in_wood_elves_trigger()

	local char_cqi = in_wood_elves.char_cqi;
	
	-- The elves of Athel Loren are a rare sight. These mysterious beings keep their own company and seldom emerge from their forests. Whilst they are not great in number, cross them at your peril.
	local advice_key = "dlc05.camp.advice.wef.wood_elves.001";
	local infotext = {
		"war.camp.advice.wood_elves.info_001",
		"war.camp.advice.wood_elves.info_002",
		"war.camp.advice.wood_elves.info_003"
	};
	
	in_wood_elves:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key, 
		infotext
	);
end;






---------------------------------------------------------------
--
--	Wood Elves racial advice
--
---------------------------------------------------------------


-- intervention declaration
in_wood_elves_racial_advice = intervention:new(
	"in_wood_elves_racial_advice", 												-- string name
	25, 																		-- cost
	function() trigger_in_wood_elves_racial_advice() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_wood_elves_racial_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_wood_elves_racial_advice:add_precondition_unvisited_page("wood_elves");
in_wood_elves_racial_advice:add_advice_key_precondition("dlc05.camp.advice.wef.wood_elves.002");
in_wood_elves_racial_advice:set_min_turn(2);

in_wood_elves_racial_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		return true;
	end
);


function trigger_in_wood_elves_racial_advice()		
	in_wood_elves_racial_advice:play_advice_for_intervention(	
		-- You, the Asrai of Athel Loren, live in harmony with the great forest you call home. Yet there are those abroad who would endanger this paradise. Wield the sublime fury of nature against your foes and protect this woodland against all that may threaten it.
		"dlc05.camp.advice.wef.wood_elves.002", 
		{
			"war.camp.advice.wood_elves.info_001",
			"war.camp.advice.wood_elves.info_002",
			"war.camp.advice.wood_elves.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Peasant recruited
--
---------------------------------------------------------------

-- peasant recruited declaration
in_peasant_recruited = intervention:new(
	"in_peasant_recruited",			 									-- string name
	5, 																	-- cost
	function() trigger_in_peasant_recruited() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_peasant_recruited:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_peasant_recruited:add_advice_key_precondition("dlc07.camp.advice.brt.peasant_economy.001");

in_peasant_recruited:add_trigger_condition(
	"UnitTrained",
	function(context)
		if Is_Peasant_Unit(context:unit():unit_key()) and context:unit():faction():is_human() then
			if context:unit():has_force_commander() then
				in_peasant_recruited.char_cqi = context:unit():force_commander():command_queue_index();
				return true;
			end
		end
	end
);


function trigger_in_peasant_recruited()
	local char_cqi = in_peasant_recruited.char_cqi;
	
	-- The peasants of Bretonnia are the workforce of our farms and mills. Enlisting too many to bolster your forces will come at a cost to your farming income.
	local advice_key = "dlc07.camp.advice.brt.peasant_economy.001";
	local infotext = {
		"war.camp.advice.peasants.info_001",
		"war.camp.advice.peasants.info_002",
		"war.camp.advice.peasants.info_003"
	};
	
	in_peasant_recruited:play_advice_for_intervention(
		-- A blessing has been bestowed upon these men. The Lady will protect them for their heroism.
		advice_key, 
		infotext
	);
end;



---------------------------------------------------------------
--
--	Peasant negative income
--
---------------------------------------------------------------

-- peasant negative declaration
in_peasant_negative = intervention:new(
	"in_peasant_negative",			 									-- string name
	5, 																	-- cost
	function() trigger_in_peasant_negative() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_peasant_negative:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_peasant_negative:add_advice_key_precondition("dlc07.camp.advice.brt.peasant_economy.002");

in_peasant_negative:add_trigger_condition(
	"ScriptEventNegativePeasantEconomy",
	function()	
		return true;
	end
);


function trigger_in_peasant_negative()
	-- Our fields and orchards are short of workers and with it our income dwindles. See that manpower is improved to reap the benefits of the land.
	local advice_key = "dlc07.camp.advice.brt.peasant_economy.002";
	local infotext = {
		"war.camp.advice.peasants.info_001",
		"war.camp.advice.peasants.info_002",
		"war.camp.advice.peasants.info_003"
	};
	in_peasant_negative:play_advice_for_intervention(	
		-- A blessing has been bestowed upon these men. The Lady will protect them for their heroism.
		advice_key, 
		infotext
	);
end;



---------------------------------------------------------------
--
--	Peasant positive income
--
---------------------------------------------------------------

-- peasant positive declaration
in_peasant_positive = intervention:new(
	"in_peasant_positive",			 									-- string name
	5, 																	-- cost
	function() trigger_in_peasant_postivie() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_peasant_positive:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_peasant_positive:add_advice_key_precondition("dlc07.camp.advice.brt.peasant_economy.003");

in_peasant_positive:add_trigger_condition(
	"ScriptEventPositivePeasantEconomy",
	function()	
		return true;
	end
);


function trigger_in_peasant_postivie()
	-- Workers return to the fields. Crops now grow with abundance and our coffers are full with gold once more.
	local advice_key = "dlc07.camp.advice.brt.peasant_economy.003";
	local infotext = {
		"war.camp.advice.peasants.info_001",
		"war.camp.advice.peasants.info_002",
		"war.camp.advice.peasants.info_003"
	};
	in_peasant_positive:play_advice_for_intervention(
		-- A blessing has been bestowed upon these men. The Lady will protect them for their heroism.
		advice_key, 
		infotext
	);
end;



---------------------------------------------------------------
--
--	Add Lady's Blessing
--
---------------------------------------------------------------

-- add_blessing_lady declaration
in_add_blessing_lady = intervention:new(
	"in_add_blessing_lady",			 									-- string name
	5, 																	-- cost
	function() trigger_in_add_blessing_lady() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_add_blessing_lady:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_add_blessing_lady:set_turn_countdown_restart(1);
in_add_blessing_lady:set_wait_for_battle_complete(false);

in_add_blessing_lady:add_trigger_condition(
	"ScriptEventAddBlessing",
	function()	
		return true;
	end
);


function trigger_in_add_blessing_lady()

	-- pick random advice with no infotext
	local advice_keys = {
		"dlc07.camp.advice.brt.blessing_lady.001",
		"dlc07.camp.advice.brt.blessing_lady.002",
		"dlc07.camp.advice.brt.blessing_lady.003"
	};
	
	in_add_blessing_lady:play_advice_for_intervention(	
		advice_keys[cm:random_number(#advice_keys)],
		{
			"war.camp.advice.blessing_lady.info_001",
			"war.camp.advice.blessing_lady.info_002",
			"war.camp.advice.blessing_lady.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Remove Lady's Blessing
--
---------------------------------------------------------------

-- remove_blessing_lady declaration
in_remove_blessing_lady = intervention:new(
	"in_remove_blessing_lady",			 									-- string name
	5, 																	-- cost
	function() trigger_in_remove_blessing_lady() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_remove_blessing_lady:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_remove_blessing_lady:add_advice_key_precondition("dlc07.camp.advice.brt.blessing_lady.004");
in_remove_blessing_lady:set_wait_for_battle_complete(false);
in_remove_blessing_lady:set_turn_countdown_restart(1);

in_remove_blessing_lady:add_trigger_condition(
	"ScriptEventRemoveBlessing",
	function()	
		return true;
	end
);


function trigger_in_remove_blessing_lady()

	in_remove_blessing_lady:play_advice_for_intervention(	
		-- The Lady no longer favours these men, for they retreat from battle.
		"dlc07.camp.advice.brt.blessing_lady.004", 
		{
			"war.camp.advice.blessing_lady.info_001",
			"war.camp.advice.blessing_lady.info_002",
			"war.camp.advice.blessing_lady.info_003"
		}
	);
end;




---------------------------------------------------------------
--
--	Chivalry gained first time
--
---------------------------------------------------------------

-- first_chivalry_gained declaration
in_first_chivalry_gained = intervention:new(
	"in_first_chivalry_gained",			 								-- string name
	5, 																	-- cost
	function() trigger_in_first_chivalry_gained() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_first_chivalry_gained:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_first_chivalry_gained:add_advice_key_precondition("dlc07.camp.advice.brt.chivalry.001a");
in_first_chivalry_gained:set_wait_for_battle_complete(false);

in_first_chivalry_gained:add_trigger_condition(
	"CharacterCompletedBattle",
	function(context)
		local character = context:character();
		local faction = character:faction();
		
		local previous_food = cm:get_saved_value("ScriptPreviousFoodValue_" .. faction:name()) or 0;
		
		local current_food = faction:total_food();
		
		if faction:is_human() and faction:subculture() == "wh_main_sc_brt_bretonnia" and character:won_battle() and current_food > previous_food then
			return true;
		end;
	end
);


function trigger_in_first_chivalry_gained()

	in_first_chivalry_gained:play_advice_for_intervention(	
		-- A display of noble action and good intent, my Lord. Good things will come to those that possess these virtues.
		"dlc07.camp.advice.brt.chivalry.001a", 
		{
			"war.camp.advice.chivalry.info_001",
			"war.camp.advice.chivalry.info_002",
			"war.camp.advice.chivalry.info_003"
		}
	);
end;




---------------------------------------------------------------
--
--	Chivalry lost first time
--
---------------------------------------------------------------

-- first_chivalry_lost declaration
in_first_chivalry_lost = intervention:new(
	"in_first_chivalry_lost",			 									-- string name
	5, 																	-- cost
	function() trigger_in_first_chivalry_lost() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_first_chivalry_lost:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_first_chivalry_lost:add_advice_key_precondition("dlc07.camp.advice.brt.chivalry.002");

in_first_chivalry_lost:add_trigger_condition(
	"ScriptEventFoodValueDown",
	function()	
		return true;
	end
);


function trigger_in_first_chivalry_lost()

	in_first_chivalry_lost:play_advice_for_intervention(	
		-- These are troubled times indeed when such unchivalrous actions are deemed just. Let us turn a blind eye to them for now.
		"dlc07.camp.advice.brt.chivalry.002", 
		{
			"war.camp.advice.chivalry.info_001",
			"war.camp.advice.chivalry.info_002",
			"war.camp.advice.chivalry.info_003"
		}
	);
end;




---------------------------------------------------------------
--
--	Chivalry negative
--
---------------------------------------------------------------

-- chivalry_negative declaration
in_chivalry_negative = intervention:new(
	"in_chivalry_negative",			 									-- string name
	5, 																	-- cost
	function() trigger_in_chivalry_negative() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_chivalry_negative:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_chivalry_negative:add_advice_key_precondition("dlc07.camp.advice.brt.chivalry.006a");

in_chivalry_negative:add_trigger_condition(
	"ScriptEventFoodValueDown",
	function()
		local faction = cm:whose_turn_is_it_single();
		return faction:is_human() and faction:total_food() < 0;
	end
);


function trigger_in_chivalry_negative()

	in_chivalry_negative:play_advice_for_intervention(	
		-- These are troubled times indeed when such unchivalrous actions are deemed just. Let us turn a blind eye to them for now.
		"dlc07.camp.advice.brt.chivalry.006a", 
		{
			"war.camp.advice.chivalry.info_001",
			"war.camp.advice.chivalry.info_002",
			"war.camp.advice.chivalry.info_003"
		}
	);
end;


---------------------------------------------------------------
--
--	Chivalry level up
--
---------------------------------------------------------------

-- chivalry_level_up declaration
in_chivalry_level_up = intervention:new(
	"in_chivalry_level_up",			 									-- string name
	5, 																	-- cost
	function() trigger_in_chivalry_level_up() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_chivalry_level_up:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
--in_chivalry_level_up:add_advice_key_precondition("dlc07.camp.advice.brt.chivalry.007a");
in_chivalry_level_up:set_turn_countdown_restart(1);

in_chivalry_level_up:add_trigger_condition(
	"ScriptEventFoodLevelUp",
	function()	
		return true;
	end
);

function trigger_in_chivalry_level_up()
	local advice_keys = {
		"dlc07.camp.advice.brt.chivalry.007",
		"dlc07.camp.advice.brt.chivalry.008",
		"dlc07.camp.advice.brt.chivalry.009"
	};
	
	in_chivalry_level_up:play_advice_for_intervention(	
		-- A display of noble action and good intent, my Lord. Good things will come to those that possess these virtues.
		advice_keys[cm:random_number(#advice_keys)],
		{
			"war.camp.advice.chivalry.info_001",
			"war.camp.advice.chivalry.info_002",
			"war.camp.advice.chivalry.info_003"
		}
	);
end;

-- chivalry_level_up declaration
in_chivalry_level_up_repanse = intervention:new(
	"in_chivalry_level_up_repanse",			 									-- string name
	5, 																	-- cost
	function() trigger_in_chivalry_level_up_repanse() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_chivalry_level_up_repanse:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
--in_chivalry_level_up_repanse:add_advice_key_precondition("dlc07.camp.advice.brt.chivalry.007");
in_chivalry_level_up_repanse:set_turn_countdown_restart(1);

in_chivalry_level_up_repanse:add_trigger_condition(
	"ScriptEventFoodLevelUp",
	function()	
		return true;
	end
);

function trigger_in_chivalry_level_up_repanse()
	local advice_keys = {
		"dlc07.camp.advice.brt.chivalry.007a",
		"dlc07.camp.advice.brt.chivalry.008.repanse",
		"dlc07.camp.advice.brt.chivalry.009.repanse"
	};
	
	in_chivalry_level_up_repanse:play_advice_for_intervention(	
		-- A display of noble action and good intent, my Lord. Good things will come to those that possess these virtues.
		advice_keys[cm:random_number(#advice_keys)],
		{
			"war.camp.advice.chivalry.info_001",
			"war.camp.advice.chivalry.info_002",
			"war.camp.advice.chivalry.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Chivalry level down
--
---------------------------------------------------------------

-- chivalry_level_down declaration
in_chivalry_level_down = intervention:new(
	"in_chivalry_level_down",			 									-- string name
	5, 																	-- cost
	function() trigger_in_chivalry_level_down() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_chivalry_level_down:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
--in_chivalry_level_down:add_advice_key_precondition("dlc07.camp.advice.brt.chivalry.007");
in_chivalry_level_down:set_turn_countdown_restart(1);

in_chivalry_level_down:add_trigger_condition(
	"ScriptEventFoodLevelDown",
	function()	
		return true;
	end
);

function trigger_in_chivalry_level_down()
	local advice_keys = {
		"dlc07.camp.advice.brt.chivalry.003a",
		"dlc07.camp.advice.brt.chivalry.004",
		"dlc07.camp.advice.brt.chivalry.005"
	};
	
	in_chivalry_level_down:play_advice_for_intervention(	
		-- A display of noble action and good intent, my Lord. Good things will come to those that possess these virtues.
		advice_keys[cm:random_number(#advice_keys)],
		{
			"war.camp.advice.chivalry.info_001",
			"war.camp.advice.chivalry.info_002",
			"war.camp.advice.chivalry.info_003"
		}
	);
end;


---------------------------------------------------------------
--
--	Green knight intro
--
---------------------------------------------------------------

-- green_knight_intro declaration
in_green_knight_intro = intervention:new(
	"in_green_knight_intro",			 									-- string name
	5, 																	-- cost
	function() trigger_in_green_knight_intro() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_green_knight_intro:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_green_knight_intro:add_advice_key_precondition("dlc07.camp.advice.brt.green_knight.001");

in_green_knight_intro:add_trigger_condition(
	"ScriptEventFoodValueUp",
	function()	
		local faction = cm:whose_turn_is_it_single();
		return faction:is_human() and faction:total_food() >= 100;
	end
);


function trigger_in_green_knight_intro()

	in_green_knight_intro:play_advice_for_intervention(	
		-- Folklore tells of a mighty champion who will emerge from the mist to protect the Dukes of Bretonnia in their hour of need, cleansing the land of its enemies.
		"dlc07.camp.advice.brt.green_knight.001", 
		{
			"war.camp.advice.green_knight.info_001",
			"war.camp.advice.green_knight.info_002",
			"war.camp.advice.green_knight.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Green knight Available
--
---------------------------------------------------------------

-- green_knight_available declaration
in_green_knight_available = intervention:new(
	"in_green_knight_available",			 									-- string name
	5, 																	-- cost
	function() trigger_in_green_knight_available() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_green_knight_available:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_green_knight_available:add_advice_key_precondition("dlc07.camp.advice.brt.green_knight.002");

in_green_knight_available:add_trigger_condition(
	"ScriptEventFoodLevelUp",
	function()
		local faction = cm:whose_turn_is_it_single();
		return faction:is_human() and faction:total_food() >= 400;
	end
);


function trigger_in_green_knight_available()

	in_green_knight_available:play_advice_for_intervention(	
		-- Folklore tells of a mighty champion who will emerge from the mist to protect the Dukes of Bretonnia in their hour of need, cleansing the land of its enemies.
		"dlc07.camp.advice.brt.green_knight.002", 
		{
			"war.camp.advice.green_knight.info_001",
			"war.camp.advice.green_knight.info_002",
			"war.camp.advice.green_knight.info_003"
		}
	);
end;




---------------------------------------------------------------
--
--	Green knight Summon
--
---------------------------------------------------------------

-- green_knight_summon declaration
in_green_knight_summon = intervention:new(
	"in_green_knight_summon",			 									-- string name
	5, 																	-- cost
	function() trigger_in_green_knight_summon() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_green_knight_summon:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_green_knight_summon:add_advice_key_precondition("dlc07.camp.advice.brt.green_knight.003");

in_green_knight_summon:add_trigger_condition(
	"ScriptEventGreenKnightSummoned",
	function()
		return true;
	end
);


function trigger_in_green_knight_summon()

	in_green_knight_summon:play_advice_for_intervention(	
		-- Folklore tells of a mighty champion who will emerge from the mist to protect the Dukes of Bretonnia in their hour of need, cleansing the land of its enemies.
		"dlc07.camp.advice.brt.green_knight.003", 
		{
			"war.camp.advice.green_knight.info_001",
			"war.camp.advice.green_knight.info_002",
			"war.camp.advice.green_knight.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Green knight Fade
--
---------------------------------------------------------------

-- green_knight_fade declaration
in_green_knight_fade = intervention:new(
	"in_green_knight_faded",			 									-- string name
	5, 																	-- cost
	function() trigger_in_green_knight_fade() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_green_knight_fade:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_green_knight_fade:add_advice_key_precondition("dlc07.camp.advice.brt.green_knight.004");

in_green_knight_fade:add_trigger_condition(
	"ScriptEventGreenKnightFade",
	function()
		return true;
	end
);


function trigger_in_green_knight_fade()

	in_green_knight_fade:play_advice_for_intervention(	
		-- Folklore tells of a mighty champion who will emerge from the mist to protect the Dukes of Bretonnia in their hour of need, cleansing the land of its enemies.
		"dlc07.camp.advice.brt.green_knight.004", 
		{
			"war.camp.advice.green_knight.info_001",
			"war.camp.advice.green_knight.info_002",
			"war.camp.advice.green_knight.info_003"
		}
	);
end;


---------------------------------------------------------------
--
--	Errantry War Dilemma
--
---------------------------------------------------------------

-- errantry_war_dilemma declaration
in_errantry_war_dilemma = intervention:new(
	"in_errantry_war_dilemma",			 									-- string name
	5, 																	-- cost
	function() trigger_in_errantry_war_dilemma() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_errantry_war_dilemma:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_errantry_war_dilemma:add_advice_key_precondition("dlc07.camp.advice.brt.errantry_war.003");

in_errantry_war_dilemma:add_trigger_condition(
	"ScriptEventFoodLevelUp",
	function()
		local faction = cm:whose_turn_is_it_single();
		return faction:is_human() and faction:total_food() >= 800;
	end
);


function trigger_in_errantry_war_dilemma()
	in_errantry_war_dilemma:play_advice_for_intervention(
		-- Bretonnia stands strong as the protector of honour and chivalry. Yet one last challenge must still be met, in the wastes of the Old World. Our king prepares for battle on the grandest of scales and calls forth an Errantry War. I ask  you now to bestow your great virtues upon us and lead the Knightly Orders to their final victory over our enemy!
		"dlc07.camp.advice.brt.errantry_war.003"											-- advice key
	);
end;

-- errantry_war_dilemma declaration
in_errantry_war_dilemma_repanse = intervention:new(
	"in_errantry_war_dilemma_repanse",			 									-- string name
	5, 																	-- cost
	function() trigger_in_errantry_war_dilemma_repanse() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_errantry_war_dilemma_repanse:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_errantry_war_dilemma_repanse:add_advice_key_precondition("dlc07.camp.advice.brt.errantry_war.003.repanse");

in_errantry_war_dilemma_repanse:add_trigger_condition(
	"ScriptEventFoodLevelUp",
	function()
		if cm:model():world():whose_turn_is_it():is_human() and  cm:model():world():whose_turn_is_it():total_food() >= 800 then
			return true;
		end
	end
);


function trigger_in_errantry_war_dilemma_repanse()
	in_errantry_war_dilemma_repanse:play_advice_for_intervention(
		-- Bretonnia stands strong as the protector of honour and chivalry. Yet one last challenge must still be met, in the wastes of the Old World. Our king prepares for battle on the grandest of scales and calls forth an Errantry War. I ask  you now to bestow your great virtues upon us and lead the Knightly Orders to their final victory over our enemy!
		"dlc07.camp.advice.brt.errantry_war.003.repanse"											-- advice key
	);
end;

---------------------------------------------------------------
--
--	Bretonnia
--
---------------------------------------------------------------

-- intervention declaration
in_bretonnia = intervention:new(
	"bretonnia",					 														-- string name
	60, 																				-- cost
	function() in_bretonnia_trigger() end,												-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_bretonnia:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_bretonnia:add_advice_key_precondition("war.camp.advice.race.bretonnia.001");
in_bretonnia:add_advice_key_precondition("war.camp.advice.race.bretonnia.002");
in_bretonnia:add_precondition(function() return cm:is_subculture_in_campaign("wh_main_sc_brt_bretonnia") end)
in_bretonnia:add_precondition(function() return cm:get_saved_value("advice_bretonnia_seen") ~= true end)
in_bretonnia:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_bretonnia:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh_main_sc_brt_bretonnia");
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then
			
			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_bretonnia_seen", true)
				return false
			end

			in_bretonnia.char_cqi = char:cqi();
			return true;
		end;
		return false;
	end
);


function in_bretonnia_trigger()

	local char_cqi = in_bretonnia.char_cqi;
	
	-- The forces of Bretonnia have been sighted nearby. Their Knights claim to be the most brave and valiant warriors in all the world, but they have not yet come up against you, mighty Lord.
	local advice_key = "war.camp.advice.race.bretonnia.001";
	local infotext = {
		"war.camp.advice.bretonnia.info_001",
		"war.camp.advice.bretonnia.info_002",
		"war.camp.advice.bretonnia.info_003"
	};
		
	in_bretonnia:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key, 
		infotext
	);
end;










---------------------------------------------------------------
--
--	Bretonnia racial advice
--
---------------------------------------------------------------


-- intervention declaration
in_brt_racial_advice = intervention:new(
	"in_brt_racial_advice", 													-- string name
	25, 																		-- cost
	function() trigger_in_brt_racial_advice() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_brt_racial_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_brt_racial_advice:add_precondition_unvisited_page("bretonnia");
in_brt_racial_advice:add_advice_key_precondition("war.camp.advice.race.bretonnia.002");
in_brt_racial_advice:set_min_turn(2);

in_brt_racial_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		return true;
	end
);


function trigger_in_brt_racial_advice()		
	in_brt_racial_advice:play_advice_for_intervention(	
		-- The Kingdom of Bretonnia is a bastion of honour and virtue against the darkness. Your brave Knights defend the realm against all manner of black-hearted brigands and foul beasts. Rally the Dukes to your banner and, with the blessings of the Lady, you shall be victorious!
		"war.camp.advice.race.bretonnia.002", 
		{
			"war.camp.advice.bretonnia.info_001",
			"war.camp.advice.bretonnia.info_002",
			"war.camp.advice.bretonnia.info_003"
		}
	)
end;











---------------------------------------------------------------
--
--	High Elf racial advice
--
---------------------------------------------------------------


-- intervention declaration
in_hef_racial_advice = intervention:new(
	"in_hef_racial_advice", 													-- string name
	25, 																		-- cost
	function() trigger_in_hef_racial_advice() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_hef_racial_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hef_racial_advice:add_precondition_unvisited_page("high_elves");
in_hef_racial_advice:add_advice_key_precondition("war.camp.advice.race.high_elves.002");
in_hef_racial_advice:set_min_turn(2);

in_hef_racial_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		return true;
	end
);


function trigger_in_hef_racial_advice()		
	in_hef_racial_advice:play_advice_for_intervention(	
		-- You, the Asur of Ulthuan, are guardians of this world, great Lord. Your intellects are keen, your warriors highly skilled, and the homelands they defend are like paradise. Truly your noble kind stand at the pinnacle of the world order.
		"war.camp.advice.race.high_elves.002", 
		{
			"wh2.camp.advice.high_elves.info_001",
			"wh2.camp.advice.high_elves.info_002",
			"wh2.camp.advice.high_elves.info_003"
		}
	)
end;












---------------------------------------------------------------
--
--	High Elves
--
---------------------------------------------------------------

-- intervention declaration
in_high_elves = intervention:new(
	"high_elves",					 													-- string name
	60, 																				-- cost
	function() in_high_elves_trigger() end,												-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_high_elves:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_high_elves:add_advice_key_precondition("war.camp.advice.race.high_elves.001");
in_high_elves:add_advice_key_precondition("war.camp.advice.race.high_elves.002");
in_high_elves:add_precondition(function() return cm:is_subculture_in_campaign("wh2_main_sc_hef_high_elves") end)
in_high_elves:add_precondition(function() return cm:get_saved_value("advice_high_elves_seen") ~= true end)
in_high_elves:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_high_elves:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh2_main_sc_hef_high_elves");
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_high_elves_seen", true)
				return false
			end

			in_high_elves.char_cqi = char:cqi();
			return true;
		end;
		return false;
	end
);


function in_high_elves_trigger()

	local char_cqi = in_high_elves.char_cqi;
	
	-- The Elves of Ulthuan fancy themselves the noble guardians of this world, upholding it against the ‘lesser races’. Yet in their hubris they fail to see that their star is waning, eclipsed by those they think beneath them - such is their arrogance!
	local advice_key = "war.camp.advice.race.high_elves.001";
	local infotext = {
		"wh2.camp.advice.high_elves.info_001",
		"wh2.camp.advice.high_elves.info_002", 
		"wh2.camp.advice.high_elves.info_003"
	};
	
	in_high_elves:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key, 
		infotext
	);
end;










---------------------------------------------------------------
--
--	Dark Elf racial advice
--
---------------------------------------------------------------


-- intervention declaration
in_def_racial_advice = intervention:new(
	"in_def_racial_advice", 													-- string name
	25, 																		-- cost
	function() trigger_in_def_racial_advice() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_def_racial_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_def_racial_advice:add_precondition_unvisited_page("dark_elves");
in_def_racial_advice:add_advice_key_precondition("war.camp.advice.race.dark_elves.002");
in_def_racial_advice:set_min_turn(2);

in_def_racial_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		return true;
	end
);


function trigger_in_def_racial_advice()		
	in_def_racial_advice:play_advice_for_intervention(	
		-- You, the Druchii of Naggaroth, bring slaughter and cruelty on the lesser races in the name of your Dark God of Bloodshed. Master the arts of sorcery and savagery that come so easily to your merciless kin, and all the world shall be your prize!
		"war.camp.advice.race.dark_elves.002", 
		{
			"wh2.camp.advice.dark_elves.info_001",
			"wh2.camp.advice.dark_elves.info_002",
			"wh2.camp.advice.dark_elves.info_003"
		}
	)
end;













---------------------------------------------------------------
--
--	Dark Elves
--
---------------------------------------------------------------

-- intervention declaration
in_dark_elves = intervention:new(
	"dark_elves",					 													-- string name
	60, 																				-- cost
	function() in_dark_elves_trigger() end,												-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_dark_elves:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_dark_elves:add_advice_key_precondition("war.camp.advice.race.dark_elves.001");
in_dark_elves:add_advice_key_precondition("war.camp.advice.race.dark_elves.002");
in_dark_elves:add_precondition(function() return cm:is_subculture_in_campaign("wh2_main_sc_def_dark_elves") end)
in_dark_elves:add_precondition(function() return cm:get_saved_value("advice_dark_elves_seen") ~= true end)
in_dark_elves:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_dark_elves:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh2_main_sc_def_dark_elves");
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_dark_elves_seen", true)
				return false
			end


			in_dark_elves.char_cqi = char:cqi();
			return true;
		end;
		return false;
	end
);


function in_dark_elves_trigger()

	local char_cqi = in_dark_elves.char_cqi;
	
	-- Be wary, my Lord, for the Dark Elves have been sighted! These pitiless killers are as dangerous on the battlefield as they are treacherous round the table. I advise great caution.
	local advice_key = "war.camp.advice.race.dark_elves.001";
	local infotext = {
		"wh2.camp.advice.dark_elves.info_001",
		"wh2.camp.advice.dark_elves.info_002", 
		"wh2.camp.advice.dark_elves.info_003"
	};
	
	in_dark_elves:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key, 
		infotext
	);
end;














---------------------------------------------------------------
--
--	Lizardmen racial advice
--
---------------------------------------------------------------


-- intervention declaration
in_lzd_racial_advice = intervention:new(
	"in_lzd_racial_advice", 													-- string name
	25, 																		-- cost
	function() trigger_in_lzd_racial_advice() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_lzd_racial_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_lzd_racial_advice:add_precondition_unvisited_page("lizardmen");
in_lzd_racial_advice:add_advice_key_precondition("war.camp.advice.race.lizardmen.002");
in_lzd_racial_advice:set_min_turn(2);

in_lzd_racial_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		return true;
	end
);


function trigger_in_lzd_racial_advice()		
	in_lzd_racial_advice:play_advice_for_intervention(	
		-- Your cold-blooded kind are the true guardians of the world, ancient Lord. Yet the younger races care little for the designs of the Old Ones. Deploy your ferocious warriors and wield your most potent sorcery – you shall impose the order you seek!
		"war.camp.advice.race.lizardmen.002", 
		{
			"wh2.camp.advice.lizardmen.info_001",
			"wh2.camp.advice.lizardmen.info_002",
			"wh2.camp.advice.lizardmen.info_003"
		}
	)
end;













---------------------------------------------------------------
--
--	Lizardmen
--
---------------------------------------------------------------

-- intervention declaration
in_lizardmen = intervention:new(
	"lizardmen",					 													-- string name
	60, 																				-- cost
	function() in_lizardmen_trigger() end,												-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_lizardmen:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_lizardmen:add_advice_key_precondition("war.camp.advice.race.lizardmen.001");
in_lizardmen:add_advice_key_precondition("war.camp.advice.race.lizardmen.002");
in_lizardmen:add_precondition(function() return cm:is_subculture_in_campaign("wh2_main_sc_lzd_lizardmen") end)
in_lizardmen:add_precondition(function() return cm:get_saved_value("advice_lizardmen_seen") ~= true end)
in_lizardmen:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_lizardmen:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh2_main_sc_lzd_lizardmen");
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_lizardmen_seen", true)
				return false
			end

			in_lizardmen.char_cqi = char:cqi();
			return true;
		end;
		return false;
	end
);


function in_lizardmen_trigger()

	local char_cqi = in_lizardmen.char_cqi;
	
	-- The cold-blooded beasts of the Lustrian jungles draw near. Be wary of the Lizardmen, my Lord: their motives are often hard to fathom, but the ferocity of their warriors and the sharpness of their claws are in little doubt.
	local advice_key = "war.camp.advice.race.lizardmen.001";
	local infotext = {
		"wh2.camp.advice.lizardmen.info_001",
		"wh2.camp.advice.lizardmen.info_002", 
		"wh2.camp.advice.lizardmen.info_003"
	};
	
	in_lizardmen:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key, 
		infotext
	);
end;














---------------------------------------------------------------
--
--	Skaven racial advice
--
---------------------------------------------------------------


-- intervention declaration
in_skv_racial_advice = intervention:new(
	"in_skv_racial_advice", 													-- string name
	25, 																		-- cost
	function() trigger_in_skv_racial_advice() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_skv_racial_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_skv_racial_advice:add_precondition_unvisited_page("skaven");
in_skv_racial_advice:add_advice_key_precondition("war.camp.advice.race.skaven.002");
in_skv_racial_advice:set_min_turn(2);

in_skv_racial_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		return true;
	end
);


function trigger_in_skv_racial_advice()
	in_skv_racial_advice:play_advice_for_intervention(	
		-- Your clan is the dark menace that lurks unseen, Warlord. You are masters of concealment and deception, and the oblivious fools that dwell above ground shall all come to know of your power in time!
		"war.camp.advice.race.skaven.002", 
		{
			"wh2.camp.advice.skaven.info_001",
			"wh2.camp.advice.skaven.info_002",
			"wh2.camp.advice.skaven.info_003"
		}
	)
end;












---------------------------------------------------------------
--
--	Skaven
--
---------------------------------------------------------------

-- intervention declaration
in_skaven = intervention:new(
	"skaven",					 														-- string name
	60, 																				-- cost
	function() in_skaven_trigger() end,													-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_skaven:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_skaven:add_advice_key_precondition("war.camp.advice.race.skaven.001");
in_skaven:add_advice_key_precondition("war.camp.advice.race.skaven.002");
in_skaven:add_precondition(function() return cm:is_subculture_in_campaign("wh2_main_sc_skv_skaven") end)
in_skaven:add_precondition(function() return cm:get_saved_value("advice_skaven_seen") ~= true end)
in_skaven:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_skaven:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh2_main_sc_skv_skaven");
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then
			
			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_skaven_seen", true)
				return false
			end

			in_skaven.char_cqi = char:cqi();
			return true;
		end;
		return false;
	end
);


function in_skaven_trigger()

	local char_cqi = in_skaven.char_cqi;
	
	-- Skaven, my Lord! These verminous ratmen are rarely seen above ground. Place no trust in their words and keep their squalid messengers at arm’s length, lest some foul contagion overtake you!
	local advice_key = "war.camp.advice.race.skaven.001";
	local infotext = {
		"wh2.camp.advice.skaven.info_001",
		"wh2.camp.advice.skaven.info_002", 
		"wh2.camp.advice.skaven.info_003"
	};
	
	in_skaven:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key, 
		infotext
	);
end;


















---------------------------------------------------------------
--
--	Tomb Kings racial advice
--
---------------------------------------------------------------


-- intervention declaration
in_tmb_racial_advice = intervention:new(
	"in_tmb_racial_advice", 													-- string name
	25, 																		-- cost
	function() trigger_in_tmb_racial_advice() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_tmb_racial_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_tmb_racial_advice:add_precondition_unvisited_page("tomb_kings");
in_tmb_racial_advice:add_advice_key_precondition("war.camp.advice.race.tomb_kings.002");
in_tmb_racial_advice:add_advice_key_precondition("war.camp.advice.race.tomb_kings.003");
in_tmb_racial_advice:set_min_turn(2);

in_tmb_racial_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		return true;
	end
);


function trigger_in_tmb_racial_advice()

	-- Long have your kind existed in tormented Undeath, mighty Lord, prematurely raised by Nagash’s dark sorcery. Rally the Undying legions to your banner and the world can belong to the Tomb Kings once again!
	local advice_key = "war.camp.advice.race.tomb_kings.002";
	
	-- if the player is playing as Arkhan, use a different line
	if cm:get_faction(cm:get_local_faction_name()):name() == "wh2_dlc09_tmb_followers_of_nagash" then
		-- The time of brooding is over, sire. Now is the moment to execute your plan, for the Age of Resurrection is upon us. The Great Necromancer shall return with you at his side - rally your legions and sweep aside any who dare challenge the Liche King!
		advice_key = "war.camp.advice.race.tomb_kings.003";
	end;
	

	in_tmb_racial_advice:play_advice_for_intervention(	
		advice_key, 
		{
			"dlc09.camp.advice.tomb_kings.info_001",
			"dlc09.camp.advice.tomb_kings.info_002",
			"dlc09.camp.advice.tomb_kings.info_003"
		}
	)
end;












---------------------------------------------------------------
--
--	Tomb Kings
--
---------------------------------------------------------------

-- intervention declaration
in_tomb_kings = intervention:new(
	"tomb_kings",					 														-- string name
	60, 																					-- cost
	function() in_tomb_kings_trigger() end,													-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);

in_tomb_kings:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_tomb_kings:add_advice_key_precondition("war.camp.advice.race.tomb_kings.001");
in_tomb_kings:add_advice_key_precondition("war.camp.advice.race.tomb_kings.002");
in_tomb_kings:add_advice_key_precondition("war.camp.advice.race.tomb_kings.003");
in_tomb_kings:add_precondition(function() return cm:is_subculture_in_campaign("wh2_main_sc_skv_tomb_kings") end)
in_tomb_kings:add_precondition(function() return cm:get_saved_value("advice_tomb_kings_seen") ~= true end)
in_tomb_kings:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_tomb_kings:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh2_main_sc_skv_tomb_kings");
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_tomb_kings_seen", true)
				return false
			end

			in_tomb_kings.char_cqi = char:cqi();
			return true;
		end;
		return false;
	end
);


function in_tomb_kings_trigger()

	local char_cqi = in_tomb_kings.char_cqi;
		
	in_tomb_kings:scroll_camera_to_character_for_intervention( 
		char_cqi,
		-- Be wary, for the Tomb Kings of Nehekhara draw into sight. They stalk the land in perpetual Undeath, seeking to reclaim the world from the living. Keep a watch on their movements, my Lord, for they are formidable adversaries still.
		"war.camp.advice.race.tomb_kings.001", 
		{
			"dlc09.camp.advice.tomb_kings.info_001",
			"dlc09.camp.advice.tomb_kings.info_002",
			"dlc09.camp.advice.tomb_kings.info_003"
		}
	);
end;















---------------------------------------------------------------
--
--	influence advice
--
---------------------------------------------------------------


-- intervention declaration
in_hef_influence_advice = intervention:new(
	"in_hef_influence_advice", 												-- string name
	40, 																	-- cost
	function() trigger_in_hef_influence_advice() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_hef_influence_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hef_influence_advice:add_precondition_unvisited_page("influence");
in_hef_influence_advice:add_advice_key_precondition("wh2.camp.advice.influence.001");
in_hef_influence_advice:set_min_turn(4);

in_hef_influence_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return true;
	end
);

function trigger_in_hef_influence_advice()
	in_hef_influence_advice:play_advice_for_intervention(	
		-- Your kind thrive on the machinations of statecraft, noble Lord. Influence won amongst your peers in the halls of the Asur is a currency like no other, and can be spent on favours both home and abroad.
		"wh2.camp.advice.influence.001", 
		{
			"wh2.camp.advice.influence.info_001",
			"wh2.camp.advice.influence.info_002",
			"wh2.camp.advice.influence.info_003"
		}
	)
end;









---------------------------------------------------------------
--
--	intrigue at the court advice
--
---------------------------------------------------------------


-- intervention declaration
in_hef_intrigue_at_the_court_advice = intervention:new(
	"in_hef_intrigue_at_the_court_advice", 									-- string name
	40, 																	-- cost
	function() trigger_in_hef_intrigue_at_the_court_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_hef_intrigue_at_the_court_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hef_intrigue_at_the_court_advice:add_precondition_unvisited_page("intrigue_at_the_court");
in_hef_intrigue_at_the_court_advice:add_advice_key_precondition("wh2.camp.advice.intrigue_at_the_court.001");
in_hef_intrigue_at_the_court_advice:set_min_turn(6);

in_hef_intrigue_at_the_court_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return true;
	end
);

function trigger_in_hef_intrigue_at_the_court_advice()
	in_hef_intrigue_at_the_court_advice:play_advice_for_intervention(	
		-- Great powers may rise and fall by a few whispered words within the court of the Phoenix King. Use your influence to sway events to your advantage, my Lord.
		"wh2.camp.advice.intrigue_at_the_court.001", 
		{
			"wh2.camp.advice.intrigue_at_the_court.info_001",
			"wh2.camp.advice.intrigue_at_the_court.info_002",
			"wh2.camp.advice.intrigue_at_the_court.info_003"
		}
	)
end;








---------------------------------------------------------------
--
--	skaven underworld advice
--
---------------------------------------------------------------


-- intervention declaration
in_skv_skaven_underworld_advice = intervention:new(
	"in_skv_skaven_underworld_advice", 										-- string name
	40, 																	-- cost
	function() trigger_in_skv_skaven_underworld_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_skv_skaven_underworld_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_skv_skaven_underworld_advice:add_precondition_unvisited_page("skaven_underworld");
in_skv_skaven_underworld_advice:add_advice_key_precondition("wh2.camp.advice.skaven_underworld.001");
in_skv_skaven_underworld_advice:set_min_turn(4);

in_skv_skaven_underworld_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return true;
	end
);

function trigger_in_skv_skaven_underworld_advice()
	in_skv_skaven_underworld_advice:play_advice_for_intervention(	
		-- Even those surface-dwellers who have heard tales of the Skaven Under-Empire regard them as little more than myths. Few know the true extent of the cities your kind build beneath the ruins of other races, devious Lord. Subterfuge is amongst the greatest weapons of the Skaven.
		"wh2.camp.advice.skaven_underworld.001", 
		{
			"wh2.camp.advice.skaven_underworld.info_001",
			"wh2.camp.advice.skaven_underworld.info_002",
			"wh2.camp.advice.skaven_underworld.info_003"
		}
	)
end;









---------------------------------------------------------------
--
--	skaven food advice
--
---------------------------------------------------------------


-- intervention declaration
in_skv_skaven_food_advice = intervention:new(
	"in_skv_skaven_food_advice", 											-- string name
	40, 																	-- cost
	function() trigger_in_skv_skaven_food_advice() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_skv_skaven_food_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_skv_skaven_food_advice:add_precondition_unvisited_page("skaven_food");
in_skv_skaven_food_advice:add_advice_key_precondition("wh2.camp.advice.skaven_food.001");
in_skv_skaven_food_advice:set_min_turn(5);

in_skv_skaven_food_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return true;
	end
);

function trigger_in_skv_skaven_food_advice()
	in_skv_skaven_food_advice:play_advice_for_intervention(	
		-- Your kind burns energy - blessed, or perhaps cursed with a high metabolism - they will not fight on an empty stomach. Be sure to keep your forces fed, lest they chitter and conspire to turn on their commanders as a source of nourishment!
		"wh2.camp.advice.skaven_food.001", 
		{
			"wh2.camp.advice.skaven_food.info_001",
			"wh2.camp.advice.skaven_food.info_002",
			"wh2.camp.advice.skaven_food.info_003"
		}
	)
end;












---------------------------------------------------------------
--
--	stalking advice
--
---------------------------------------------------------------


-- intervention declaration
in_skv_stalking_advice = intervention:new(
	"in_skv_stalking_advice", 												-- string name
	40, 																	-- cost
	function() trigger_in_skv_stalking_advice() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_skv_stalking_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_skv_stalking_advice:add_precondition_unvisited_page("stalking");
in_skv_stalking_advice:add_advice_key_precondition("wh2.camp.advice.stalking.001");
in_skv_stalking_advice:give_priority_to_intervention("stances");
in_skv_stalking_advice:set_min_turn(5);

in_skv_stalking_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return true;
	end
);

function trigger_in_skv_stalking_advice()
	in_skv_stalking_advice:play_advice_for_intervention(	
		-- Your kind are known for stalking your foes, my Lord. Approach unseen, and you may bring them to battle unprepared.
		"wh2.camp.advice.stalking.001", 
		{
			"wh2.camp.advice.stalking.info_001",
			"wh2.camp.advice.stalking.info_002",
			"wh2.camp.advice.stalking.info_003"
		}
	)
end;




---------------------------------------------------------------
--
--	astromancy advice
--
---------------------------------------------------------------


-- intervention declaration
in_lzd_astromancy_advice = intervention:new(
	"in_lzd_astromancy_advice", 											-- string name
	40, 																	-- cost
	function() trigger_in_lzd_astromancy_advice() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_lzd_astromancy_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_lzd_astromancy_advice:add_precondition_unvisited_page("astromancy");
in_lzd_astromancy_advice:add_advice_key_precondition("wh2.camp.advice.astromancy.001");
in_lzd_astromancy_advice:give_priority_to_intervention("stances");
in_lzd_astromancy_advice:set_min_turn(8);

in_lzd_astromancy_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return true;
	end
);

function trigger_in_lzd_astromancy_advice()
	in_lzd_astromancy_advice:play_advice_for_intervention(	
		-- Astromancy may be used by your cold-blooded kin to divine the movements of the enemy, revered master. Your keen senses can make you nearly impervious to surprise.
		"wh2.camp.advice.astromancy.001", 
		{
			"wh2.camp.advice.astromancy.info_001",
			"wh2.camp.advice.astromancy.info_002",
			"wh2.camp.advice.astromancy.info_003"
		}
	)
end;







---------------------------------------------------------------
--
--	geomantic web advice
--
---------------------------------------------------------------

-- intervention declaration
in_lzd_geomantic_web_advice = intervention:new(
	"in_lzd_geomantic_web_advice", 											-- string name
	40, 																	-- cost
	function() trigger_in_lzd_geomantic_web_advice() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_lzd_geomantic_web_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_lzd_geomantic_web_advice:add_precondition_unvisited_page("geomantic_web");
in_lzd_geomantic_web_advice:add_advice_key_precondition("wh2.camp.advice.geomantic_web.001");
in_lzd_geomantic_web_advice:set_min_turn(4);

in_lzd_geomantic_web_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return true;
	end
);

function trigger_in_lzd_geomantic_web_advice()
	in_lzd_geomantic_web_advice:play_advice_for_intervention(	
		-- Unseen by warmblood eyes, the Geomantic Web binds the energies of your most sacred temple-cities together, revered master. Encourage its growth, and its power will surely underpin the restoration of cold-blooded order to the world.
		"wh2.camp.advice.geomantic_web.001", 
		{
			"wh2.camp.advice.geomantic_web.info_001",
			"wh2.camp.advice.geomantic_web.info_002",
			"wh2.camp.advice.geomantic_web.info_003"
		}
	)
end;










---------------------------------------------------------------
--
--	rites advice
--
---------------------------------------------------------------

-- intervention declaration
in_rites = intervention:new(
	"in_rites",					 											-- string name
	0,	 																	-- cost
	function() trigger_in_rites_advice() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_rites:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_rites:add_advice_key_precondition("wh2.camp.advice.rites.001");
in_rites:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_rites:add_trigger_condition(
	"ScriptEventRiteUnlocked",
	function(context)
		return context:faction():name() == cm:get_local_faction_name();
	end
);

function trigger_in_rites_advice()
	in_rites:play_advice_for_intervention(	
		-- Invocations of great potency may be performed by your most potent wielders of magic, mighty Lord. Summon them together, and they may perform rites to grant you considerable powers - albeit at a price.
		"wh2.camp.advice.rites.001", 
		{
			"wh2.camp.advice.rites.info_001",
			"wh2.camp.advice.rites.info_002",
			"wh2.camp.advice.rites.info_003",
			"wh2.camp.advice.rites.info_004"
		}
	);
end;





---------------------------------------------------------------
--
--	pestilent scheme rites advice
--
---------------------------------------------------------------

-- intervention declaration
in_rite_pestilent_scheme = intervention:new(
	"in_rite_pestilent_scheme",												-- string name
	0,	 																	-- cost
	function() trigger_in_rite_pestilent_scheme_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_rite_pestilent_scheme:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_rite_pestilent_scheme:add_advice_key_precondition("wh2.camp.advice.plagues.002");
in_rite_pestilent_scheme:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");
in_rite_pestilent_scheme:give_priority_to_intervention("in_rites");

in_rite_pestilent_scheme:add_trigger_condition(
	"ScriptEventRiteUnlocked",
	function(context)
		return context:faction():name() == cm:get_local_faction_name() and context.string == "wh2_main_ritual_skv_pestilence";
	end
);

function trigger_in_rite_pestilent_scheme_advice()
	in_rite_pestilent_scheme:play_advice_for_intervention(
		-- No boundaries are acknowledged by your kind in the pursuit of warfare, verminous Lord. A deadly contagion, concocted by your most skilled incubators, is now ready for use against your enemy. Recruit a plague priest and send him amongst the enemy.
		"wh2.camp.advice.plagues.002",
		{
			"wh2.camp.advice.plagues.info_001",
			"wh2.camp.advice.plagues.info_002",
			"wh2.camp.advice.plagues.info_003"
		}
	);
end;




---------------------------------------------------------------
--
--	doom scheme rites advice
--
---------------------------------------------------------------

-- intervention declaration
in_rite_doom = intervention:new(
	"in_rite_doom",															-- string name
	0,	 																	-- cost
	function() trigger_in_rite_doom_advice() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_rite_doom:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_rite_doom:add_advice_key_precondition("wh2.camp.advice.doom_engineers.001");
in_rite_doom:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");
in_rite_doom:give_priority_to_intervention("in_rites");

in_rite_doom:add_trigger_condition(
	"ScriptEventRiteUnlocked",
	function(context)
		return context:faction():name() == cm:get_local_faction_name() and context.string == "wh2_main_ritual_skv_doooom";
	end
);

function trigger_in_rite_doom_advice()
	in_rite_doom:play_advice_for_intervention(
		-- A scheme of great and terrible destruction has been concocted by your devious engineers, my Lord. Laden one with explosives and have him visit your enemy. Doom will come upon them!
		"wh2.camp.advice.doom_engineers.001",
		nil
	);
end;






---------------------------------------------------------------
--
--	black arks advice
--
---------------------------------------------------------------

-- intervention declaration
in_def_black_arks = intervention:new(
	"in_def_black_arks",													-- string name
	30,	 																	-- cost
	function() trigger_in_def_black_arks_advice() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_def_black_arks:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_def_black_arks:add_advice_key_precondition("wh2.camp.advice.black_arks.001");
in_def_black_arks:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");
in_def_black_arks:give_priority_to_intervention("in_rites");

in_def_black_arks:add_trigger_condition(
	"ScriptEventRiteUnlocked",
	function(context)
		return context:faction():name() == cm:get_local_faction_name() and context.string == "wh2_main_ritual_skv_doooom";
	end
);

in_def_black_arks:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		-- also test to see if the rite has already been unlocked
		return cm:get_saved_value("wh2_main_ritual_def_mathlann_" .. cm:get_local_faction_name() .. "_unlocked");
	end
);

function trigger_in_def_black_arks_advice()
	in_def_black_arks:play_advice_for_intervention(
		-- Amongst all the sea-going weapons of the world, none are so feared as the floating fortresses of the Druchii. Perform a sacrifice to Mathlann, God of the Sea, and a dreaded Black Ark will be made available to support your forces abroad.
		"wh2.camp.advice.black_arks.001",
		{
			"wh2.camp.advice.black_arks.info_001",
			"wh2.camp.advice.black_arks.info_002",
			"wh2.camp.advice.black_arks.info_003"
		}
	);
end;





















---------------------------------------------------------------
--
--	loyalty advice
--
---------------------------------------------------------------

-- intervention declaration
in_loyalty = intervention:new(
	"in_loyalty",															-- string name
	40,	 																	-- cost
	function() trigger_in_loyalty_advice() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_loyalty:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_loyalty:add_advice_key_precondition("wh2.camp.advice.loyalty.001");
in_loyalty:add_advice_key_precondition("wh2.camp.advice.loyalty.002");
in_loyalty:add_advice_key_precondition("wh2.camp.advice.loyalty.003");
in_loyalty:set_wait_for_fullscreen_panel_dismissed(false);

in_loyalty:add_trigger_condition(
	"ScriptEventRecruitLordPanelOpened",
	function(context)
		return true;
	end
);

function trigger_in_loyalty_advice()
	in_loyalty:play_advice_for_intervention(
		-- A word in your ear: despite the great power you command, the loyalty of your followers cannot always be presumed. Keep a close watch on your subordinates, Lord, and be sure to bring those that lack a little faith into line, either through strength or favour.
		"wh2.camp.advice.loyalty.001",
		{
			"wh2.camp.advice.loyalty.info_001",
			"wh2.camp.advice.loyalty.info_002",
			"wh2.camp.advice.loyalty.info_003"
		}
	);
end;








---------------------------------------------------------------
--
--	low loyalty advice
--
---------------------------------------------------------------

-- intervention declaration
in_low_loyalty = intervention:new(
	"in_low_loyalty",														-- string name
	80,	 																	-- cost
	function() trigger_in_low_loyalty_advice() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_low_loyalty:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_low_loyalty:set_min_turn(7);
in_low_loyalty:set_turn_countdown_restart(8);
in_low_loyalty:add_advice_key_precondition("wh2.camp.advice.loyalty.002");

in_low_loyalty:add_whitelist_event_type("character_loyalty_lowevent_feed_target_character_faction");
in_low_loyalty:add_whitelist_event_type("character_loyalty_criticalevent_feed_target_character_faction");


in_low_loyalty:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local character_list = cm:get_faction(cm:get_local_faction_name()):character_list();
		for i = 0, character_list:num_items() - 1 do
			local current_char = character_list:item_at(i);
			
			if not current_char:is_faction_leader() and current_char:has_military_force() and current_char:loyalty() <= 3 then
				in_low_loyalty.char_cqi = current_char:cqi();
				return true;
			end;
		end;
	
		return false;
	end
);


function trigger_in_low_loyalty_advice()

	-- One of your subordinates shows questionable devotion to your cause, it would seem. Consider taking steps to appease or otherwise deal with them. Disloyalty cannot be left to fester.
	local advice_key = "wh2.camp.advice.loyalty.002";
	local infotext = {
		"wh2.camp.advice.loyalty.info_001",
		"wh2.camp.advice.loyalty.info_002",
		"wh2.camp.advice.loyalty.info_003"
	};
	
	if not in_low_loyalty.char_cqi or not core:is_advice_level_high() then
		in_low_loyalty:play_advice_for_intervention(
			advice_key,
			infotext
		);
	else
		in_low_loyalty:scroll_camera_to_character_for_intervention( 
			in_low_loyalty.char_cqi,
			advice_key, 
			infotext
		);
	end;
end;









---------------------------------------------------------------
--
--	civil_war
--
---------------------------------------------------------------

-- intervention declaration

in_civil_war = intervention:new(
	"civil_war",	 														-- string name
	15, 																	-- cost
	function() in_civil_war_trigger() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_civil_war:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_civil_war:add_advice_key_precondition("wh2.camp.advice.loyalty.003");
in_civil_war:add_whitelist_event_type("faction_civil_war_characterevent_feed_target_faction_instigator_faction");

in_civil_war:add_trigger_condition(
	"FactionCivilWarOccured",
	function(context)
		-- return true if this is a civil war against the player
		if context:faction():name() == cm:get_local_faction_name() then
			in_civil_war.char_cqi = context:opponent():faction_leader():cqi();
			return true;
		end;
		return false;
	end
);

function in_civil_war_trigger()
	local char_cqi = in_civil_war.char_cqi;
	
	-- Grave news, my Lord, for a traitor in your midst has turned against you. A subordinate has broken away from your rule, and has convinced a portion of your armed forces into following them. Such flagrant treachery cannot go unanswered: muster your forces, and crush them utterly!
	local advice_key = "wh2.camp.advice.loyalty.003";
	local infotext = {
		"wh2.camp.advice.loyalty.info_001",
		"wh2.camp.advice.loyalty.info_002",
		"wh2.camp.advice.loyalty.info_003"
	};
	
	if cm:get_character_by_cqi(char_cqi) then
		in_civil_war:scroll_camera_to_character_for_intervention(
			char_cqi,
			advice_key,
			infotext
		);
	else
		in_civil_war:play_advice_for_intervention(
			advice_key,
			infotext
		);
	end;
end;




























---------------------------------------------------------------
--
--	chaos corruption
--
---------------------------------------------------------------

-- intervention declaration
in_corruption_chaos = intervention:new(
	"corruption_chaos",	 											-- string name
	40, 															-- cost
	function() in_corruption_chaos_advice_trigger() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_corruption_chaos:add_advice_key_precondition("war.camp.advice.corruption.001");
in_corruption_chaos:set_min_turn(9);
in_corruption_chaos:set_turn_countdown_restart(10);
in_corruption_chaos:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);

in_corruption_chaos:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local region, proportion = cm:get_most_pious_region_for_faction_for_religion(cm:get_faction(cm:get_local_faction_name()), "wh_main_religion_chaos");
		
		if proportion > 0.3 then
			in_corruption_chaos.region_name = region:name();
			return true;
		end;
		
		return false;
	end
);


function in_corruption_chaos_advice_trigger()
	local region = cm:get_region(in_corruption_chaos.region_name);
	
	if not region or region:owning_faction():name() ~= cm:get_local_faction_name() then
		-- failsafe
		in_corruption_chaos:complete();
	else
		-- A taint of Chaos festers in this place. Take steps to reduce corruption spreading further amongst your followers, or they may turn against you to serve a new master...
		local advice = "war.camp.advice.corruption.001";
		local infotext = {
			"war.camp.advice.corruption.info_001",
			"war.camp.advice.corruption.info_002",
			"war.camp.advice.corruption.info_007",
			"war.camp.advice.corruption.info_004"
		};
	
		in_corruption_chaos:scroll_camera_to_settlement_for_intervention(
			in_corruption_chaos.region_name,
			advice,
			infotext
		);
	end;
end;







---------------------------------------------------------------
--
--	vampires corruption
--
---------------------------------------------------------------

-- intervention declaration
in_corruption_vampires = intervention:new(
	"corruption_vampires",	 										-- string name
	40, 															-- cost
	function() in_corruption_vampires_advice_trigger() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_corruption_vampires:add_advice_key_precondition("wh2.camp.advice.undead_corruption.001");
in_corruption_vampires:set_min_turn(9);
in_corruption_vampires:set_turn_countdown_restart(10);
in_corruption_vampires:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);

in_corruption_vampires:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local region, proportion = cm:get_most_pious_region_for_faction_for_religion(cm:get_faction(cm:get_local_faction_name()), "wh_main_religion_undeath");
		
		if proportion > 0.3 then
			in_corruption_vampires.region_name = region:name();
			return true;
		end;
		
		return false;
	end
);


function in_corruption_vampires_advice_trigger()
	local region = cm:get_region(in_corruption_vampires.region_name);
	
	if not region or region:owning_faction():name() ~= cm:get_local_faction_name() then
		-- failsafe
		in_corruption_vampires:complete();
	else
		-- The taint of Undeath festers in this place, my Lord. Take steps to reduce corruption spreading further amongst your followers, or they may turn against you to serve a new master...
		local advice = "wh2.camp.advice.undead_corruption.001";
		local infotext = {
			"war.camp.advice.corruption.info_001",
			"war.camp.advice.corruption.info_002",
			"war.camp.advice.corruption.info_008",
			"war.camp.advice.corruption.info_004"
		};
	
		in_corruption_vampires:scroll_camera_to_settlement_for_intervention(
			in_corruption_vampires.region_name,
			advice,
			infotext
		);
	end;
end;







---------------------------------------------------------------
--
--	untainted corruption
--
---------------------------------------------------------------

-- intervention declaration
in_corruption_untainted = intervention:new(
	"corruption_untainted",	 										-- string name
	40, 															-- cost
	function() in_corruption_untainted_advice_trigger() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_corruption_untainted:add_advice_key_precondition("wh2.camp.advice.untainted_corruption.001");
in_corruption_untainted:set_min_turn(9);
in_corruption_untainted:set_turn_countdown_restart(10);
in_corruption_untainted:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);

in_corruption_untainted:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local region, proportion = cm:get_most_pious_region_for_faction_for_religion(cm:get_faction(cm:get_local_faction_name()), "wh_main_religion_untainted");
		
		if proportion > 0.3 then
			in_corruption_untainted.region_name = region:name();
			return true;
		end;
		
		return false;
	end
);


function in_corruption_untainted_advice_trigger()
	local region = cm:get_region(in_corruption_untainted.region_name);
	
	if not region or region:owning_faction():name() ~= cm:get_local_faction_name() then
		-- failsafe
		in_corruption_untainted:complete();
	else
		-- The population of this place have not yet succumbed to your rule, my Lord. Take steps to spread your kind’s customs through these untainted lands.
		local advice = "wh2.camp.advice.untainted_corruption.001";
		local infotext = {
			"war.camp.advice.corruption.info_001",
			"war.camp.advice.corruption.info_002",
			"war.camp.advice.corruption.info_009",
			"war.camp.advice.corruption.info_004"
		};
	
		in_corruption_untainted:scroll_camera_to_settlement_for_intervention(
			in_corruption_untainted.region_name,
			advice,
			infotext
		);
	end;
end;








---------------------------------------------------------------
--
--	skaven corruption
--
---------------------------------------------------------------

-- intervention declaration
in_corruption_skaven = intervention:new(
	"corruption_skaven",	 										-- string name
	40, 															-- cost
	function() in_corruption_skaven_advice_trigger() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_corruption_skaven:add_advice_key_precondition("wh2.camp.advice.skaven_corruption.001");
in_corruption_skaven:set_min_turn(9);
in_corruption_skaven:set_turn_countdown_restart(10);
in_corruption_skaven:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);

in_corruption_skaven:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local region, proportion = cm:get_most_pious_region_for_faction_for_religion(cm:get_faction(cm:get_local_faction_name()), "wh2_main_religion_skaven");
		
		if proportion > 0.3 then
			in_corruption_skaven.region_name = region:name();
			return true;
		end;
		
		return false;
	end
);


function in_corruption_skaven_advice_trigger()
	local region = cm:get_region(in_corruption_skaven.region_name);
	
	if not region or region:owning_faction():name() ~= cm:get_local_faction_name() then
		-- failsafe
		in_corruption_skaven:complete();
	else
		-- The foul scent of vermin permeates this place, my Lord. Do not risk the undermining of your rule by the Skaven - take steps to reduce their chittered lies spreading among your followers.
		local advice = "wh2.camp.advice.skaven_corruption.002";
		local infotext = {
			"war.camp.advice.corruption.info_001",
			"war.camp.advice.corruption.info_002",
			"war.camp.advice.corruption.info_010",
			"war.camp.advice.corruption.info_004"
		};
	
		in_corruption_skaven:scroll_camera_to_settlement_for_intervention(
			in_corruption_skaven.region_name,
			advice,
			infotext
		);
	end;
end;







---------------------------------------------------------------
--
--	skaven corruption as skaven
--
---------------------------------------------------------------

-- intervention declaration
in_skv_skaven_corruption = intervention:new(
	"skv_skaven_corruption",	 									-- string name
	40, 															-- cost
	function() in_skv_skaven_corruption_advice_trigger() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_skv_skaven_corruption:add_advice_key_precondition("wh2.camp.advice.skaven_corruption.001");
in_skv_skaven_corruption:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_skv_skaven_corruption:set_min_turn(9);

in_skv_skaven_corruption:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local region_list = cm:get_faction(cm:get_local_faction_name()):region_list();
				
		for i = 0, region_list:num_items() - 1 do
			local current_region = region_list:item_at(i);
			
			if cm:get_corruption_value_in_region(current_region, skaven_corruption_string) > 35 then
				in_skv_skaven_corruption.region_name = current_region:name();
				return true;
			end;
		end;
				
		return false;
	end
);


function in_skv_skaven_corruption_advice_trigger()
	-- Your kind have the tendency to fill out any place they occupy, my Lord. In time your fetid presence begins to increase disquiet within a province.
	local advice = "wh2.camp.advice.skaven_corruption.001";
	local infotext = {
		"war.camp.advice.skaven_corruption.info_001",
		"war.camp.advice.skaven_corruption.info_002",
		"war.camp.advice.skaven_corruption.info_003"
	};

	in_skv_skaven_corruption:scroll_camera_to_settlement_for_intervention(
		in_skv_skaven_corruption.region_name,
		advice,
		infotext
	);
end;













---------------------------------------------------------------
--
--	multi turn recruitment
--
---------------------------------------------------------------

-- intervention declaration
in_multi_turn_recruitment = intervention:new(
	"multi_turn_recruitment",	 									-- string name
	40, 															-- cost
	function() in_multi_turn_recruitment_advice_trigger() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_multi_turn_recruitment:add_advice_key_precondition("wh2.camp.advice.multi_turn_recruitment.001");
in_multi_turn_recruitment:set_wait_for_fullscreen_panel_dismissed(false);
in_multi_turn_recruitment:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);

in_multi_turn_recruitment:add_trigger_condition(
	"RecruitmentItemIssuedByPlayer",
	function(context)
		if context:time_to_build() < 2 then
			return false;
		end;
		
		-- also find the local recruitment queue capacity list and ensure that it's full
		local uic_capacity_list = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "local1", "recruitment_cap", "capacity_listview");
		
		if uic_capacity_list then
			for i = 0, uic_capacity_list:ChildCount() - 1 do
				local uic_child = UIComponent(uic_capacity_list:Find(i));
				
				if uic_child:Id() ~= "used_slot" then
					return false;
				end;
			end;
		end;
		
		return true;
	end
);


function in_multi_turn_recruitment_advice_trigger()
	in_multi_turn_recruitment:play_advice_for_intervention(
		-- Your recruitment facilities are at maximum capacity, my Lord. Training of additional recruits will begin as soon as possible.
		"wh2.camp.advice.multi_turn_recruitment.001",
		{
			"war.camp.advice.unit_recruitment.info_001",
			"war.camp.advice.unit_recruitment.info_002",
			"war.camp.advice.unit_recruitment.info_003"
		}
	);
end;










---------------------------------------------------------------
--
--	Black Arks
--
---------------------------------------------------------------

-- intervention declaration
in_black_arks = intervention:new(
	"black_arks",					 													-- string name
	40, 																				-- cost
	function() in_black_arks_trigger() end,												-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_black_arks:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_black_arks:add_advice_key_precondition("wh2.camp.advice.black_arks.002");
in_black_arks:set_min_turn(7);

in_black_arks:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
	
		local local_faction = cm:get_local_faction_name();
	
		-- go through all def factions, find any black ark among them, and see if any of these are visible to the player
		local faction_list = cm:model():world():faction_list();
		
		for i = 0, faction_list:num_items() - 1 do
			local current_faction = faction_list:item_at(i);
			
			if current_faction:subculture() == "wh2_main_sc_def_dark_elves" then
				local char_list = current_faction:character_list();
				
				for j = 0, char_list:num_items() - 1 do
					if char_list:item_at(j):character_subtype("wh2_main_def_black_ark") and char_list:item_at(j):is_visible_to_faction(local_faction) then
						in_black_arks.char_cqi = char_list:item_at(j):cqi();
						return true;
					end;
				end;
			end;
		end;
		return false;
	end
);


function in_black_arks_trigger()

	local char_cqi = in_black_arks.char_cqi;
	
	-- The skies beyond the horizon darken, my Lord – a Black Ark approaches. The Dark Elves use their mighty floating fortresses of war to support their forces abroad. Such mighty weapons must be engaged with great caution, for they bring doom on those unprepared.
	local advice_key = "wh2.camp.advice.black_arks.002";
	local infotext = {
		"wh2.camp.advice.black_arks.info_001",
		"wh2.camp.advice.black_arks.info_002", 
		"wh2.camp.advice.black_arks.info_003"
	};
	
	if cm:get_character_by_cqi(char_cqi) then
		in_black_arks:scroll_camera_to_character_for_intervention(
			char_cqi,
			advice_key,
			infotext
		);
		
	else
		in_black_arks:play_advice_for_intervention(
			advice_key,
			infotext
		);
	end;
end;















---------------------------------------------------------------
--
--	skv menace below
--
---------------------------------------------------------------

-- intervention declaration
in_skv_menace_below = intervention:new(
	"skv_menace_below", 															-- string name
	95, 																			-- cost
	function() in_skv_menace_below_advice_trigger() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);


in_skv_menace_below:add_advice_key_precondition("wh2.camp.advice.menace_below.001");
in_skv_menace_below:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_skv_menace_below:set_player_turn_only(false);
in_skv_menace_below:set_wait_for_battle_complete(false);
in_skv_menace_below:set_min_turn(3);


in_skv_menace_below:add_trigger_condition(
	"ScriptEventPreBattlePanelOpened",
	function(context)
		-- find menace below panel, and return true if it's visible
		local uic_menace_below_panel = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "allies_combatants_panel", "ability_charge_panel");
		
		return uic_menace_below_panel and uic_menace_below_panel:Visible();
	end
);


function in_skv_menace_below_advice_trigger()
	local listener_str = "in_skv_menace_below";
	
	-- if the player closes panel immediately then just complete
	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function()
			cm:remove_callback(listener_str);
			in_skv_menace_below:complete();
		end,
		false
	);
	
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_skv_menace_below_advice_play();
		end,
		0.5,
		listener_str
	);
end;


function in_skv_menace_below_advice_play()
	in_skv_menace_below:play_advice_for_intervention(
		-- Verminous reinforcements may occasionally be summoned from below the battlefield, mighty Lord. It is not for nothing that your kind are infamous for the employing the element of surprise in war.
		"wh2.camp.advice.menace_below.001",
		{
			"wh2.camp.advice.menace_below.info_001",
			"wh2.camp.advice.menace_below.info_002",
			"wh2.camp.advice.menace_below.info_003"
		}
	);
end;








---------------------------------------------------------------
--
--	skaven underworld
--
---------------------------------------------------------------

-- intervention declaration
in_skaven_underworld = intervention:new(
	"skaven_underworld", 															-- string name
	40, 																			-- cost
	function() in_skaven_underworld_advice_trigger() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);


in_skaven_underworld:add_advice_key_precondition("wh2.camp.advice.skaven_underworld.002");
in_skaven_underworld:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_skaven_underworld:set_player_turn_only(false);
in_skaven_underworld:set_wait_for_battle_complete(false);


in_skaven_underworld:add_trigger_condition(
	"GarrisonResidenceExposedToFaction",
	function(context)
		local pb = cm:model():pending_battle();	
		return pb:has_attacker() and pb:has_contested_garrison() and context:encountering_faction():name() == cm:get_local_faction_name();
	end
);


function in_skaven_underworld_advice_trigger()
	local listener_str = "in_skaven_underworld";
	
	-- if the player closes panel immediately then just complete
	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function()
			cm:remove_callback(listener_str);
			in_skaven_underworld:complete();
		end,
		false
	);
	
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_skaven_underworld_advice_play();
		end,
		0.5,
		listener_str
	);
end;


function in_skaven_underworld_advice_play()
	in_skaven_underworld:play_advice_for_intervention(
		-- Beware, my Lord, for the Skaven infest these ruins! Legends told of mighty burrows hollowed out by the ratmen beneath ruined cities - it now seems that these legends were true!
		"wh2.camp.advice.skaven_underworld.002",
		{
			"wh2.camp.advice.skaven_underworld.info_001",
			"wh2.camp.advice.skaven_underworld.info_002",
			"wh2.camp.advice.skaven_underworld.info_003"
		}
	);
end;














---------------------------------------------------------------
--
--	plague
--
---------------------------------------------------------------

-- intervention declaration

in_plague = intervention:new(
	"plague",	 															-- string name
	15, 																	-- cost
	function() in_plague_trigger() end,										-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_plague:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_plague:add_advice_key_precondition("wh2.camp.advice.plagues.001");

in_plague:add_trigger_condition(
	"MilitaryForceInfectionEvent",
	function(context)
		if context:is_creation() and context:faction():culture() == "wh2_main_skv_skaven" and context:target_force():faction():name() == cm:get_local_faction_name() then
			if context:target_force():has_general() then
				in_plague.char_cqi = context:target_force():general_character():cqi();
			end;
			return true;
		end;
		return false;
	end
);



in_plague:add_trigger_condition(
	"RegionInfectionEvent",
	function(context)
		if context:is_creation() and context:faction():culture() == "wh2_main_skv_skaven" and context:target_region():owning_faction():name() == cm:get_local_faction_name() then
			in_plague.region_name = context:target_region():name();
			return true;
		end;
		return false;
	end
);




function in_plague_trigger()
	local char_cqi = in_plague.char_cqi;
	
	-- A plague has come upon your kind, my Lord! Such a virulent outbreak I have never witnessed... Consider isolating those struck down until the disease runs its course. Contact with the unfortunate sufferers will inevitably risk the contagion spreading.
	local advice_key = "wh2.camp.advice.plagues.001";
	local infotext = {
		"wh2.camp.advice.plagues.info_001",
		"wh2.camp.advice.plagues.info_002",
		"wh2.camp.advice.plagues.info_003"
	};
	
	if in_plague.char_cqi and cm:get_character_by_cqi(in_plague.char_cqi) then
		in_plague:scroll_camera_to_character_for_intervention(
			in_plague.char_cqi,
			advice_key,
			infotext
		);
	
	elseif in_plague.region_name then
		in_plague:scroll_camera_to_settlement_for_intervention( 
			in_plague.region_name, 
			advice_key, 
			infotext
		);
		
	else
		in_plague:play_advice_for_intervention(
			advice_key,
			infotext
		);
	end;
end;




---------------------------------------------------------------
--
--	Death Night advice (Turn One)
--
---------------------------------------------------------------

-- intervention declaration
in_death_night_turn_one = intervention:new(
	"in_death_night_turn_one",					 							-- string name
	40,	 																	-- cost
	function() trigger_in_death_night_turn_one_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_death_night_turn_one:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_death_night_turn_one:add_advice_key_precondition("dlc10.camp.advice.def.death_night.001");
in_death_night_turn_one:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");
in_death_night_turn_one:set_min_turn(3);


in_death_night_turn_one:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()
		return true;
	end
);

function trigger_in_death_night_turn_one_advice()
	in_death_night_turn_one:play_advice_for_intervention(	
		-- Queen Hellebron, your time of murder draws ever near! Soon you must bathe in its glory to restore your lustre. Prepare your slaves and make ready for Death Night!
		"dlc10.camp.advice.def.death_night.001", 
		{
			"wh2.camp.advice.death_night.info_001",
			"wh2.camp.advice.death_night.info_002",
			"wh2.camp.advice.death_night.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Death Night advice (Respected Stage)
--
---------------------------------------------------------------

-- intervention declaration
in_death_night_respected = intervention:new(
	"in_death_night_respected",					 							-- string name
	40,	 																	-- cost
	function() trigger_in_death_night_respected_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_death_night_respected:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_death_night_respected:set_must_trigger(true);
in_death_night_respected:add_advice_key_precondition("dlc10.camp.advice.def.death_night.002");
in_death_night_respected:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_death_night_respected:add_trigger_condition(
	"ScriptEventDeathNightLevel3",
	function()
		return true;
	end
);

function trigger_in_death_night_respected_advice()
	in_death_night_respected:play_advice_for_intervention(	
		-- My Queen, your subjects grow restless. Blood running in the streets is but a distant memory. To show restraint would be seen as weakness, and weakness seldom lasts long in Naggaroth.
		"dlc10.camp.advice.def.death_night.002", 
		{
			"wh2.camp.advice.death_night.info_001",
			"wh2.camp.advice.death_night.info_002",
			"wh2.camp.advice.death_night.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Death Night advice (Depeleted Stage)
--
---------------------------------------------------------------

-- intervention declaration
in_death_night_depleted = intervention:new(
	"in_death_night_depleted",					 							-- string name
	40,	 																	-- cost
	function() trigger_in_death_night_depleted_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_death_night_depleted:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_death_night_depleted:set_must_trigger(true);
in_death_night_depleted:add_advice_key_precondition("dlc10.camp.advice.def.death_night.003");
in_death_night_depleted:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_death_night_depleted:add_trigger_condition(
	"ScriptEventDeathNightLevel1",
	function()
		return true;
	end
);

function trigger_in_death_night_depleted_advice()
	in_death_night_depleted:play_advice_for_intervention(	
		-- Without the bloodletting of Death Night, the frustrations of our people have boiled over into lawlessness. The nobility openly question your rule; wash away these traitors in a tide of blood!
		"dlc10.camp.advice.def.death_night.003", 
		{
			"wh2.camp.advice.death_night.info_001",
			"wh2.camp.advice.death_night.info_002",
			"wh2.camp.advice.death_night.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Death Night advice (Ready)
--
---------------------------------------------------------------

-- intervention declaration
in_death_night_ready = intervention:new(
	"in_death_night_ready",					 								-- string name
	40,	 																	-- cost
	function() trigger_in_death_night_ready_advice() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_death_night_ready:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_death_night_ready:set_must_trigger(true);
in_death_night_ready:add_advice_key_precondition("dlc10.camp.advice.def.death_night.004");
in_death_night_ready:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_death_night_ready:add_trigger_condition(
	"ScriptEventRiteUnlocked",
	function()
		return true;
	end
);

function trigger_in_death_night_ready_advice()
	in_death_night_ready:play_advice_for_intervention(	
		-- Your slavers have done well, highness. The pens echo with these wretches' tortured wails! Release them, and let Death Night sweep over the city!
		"dlc10.camp.advice.def.death_night.004", 
		{
			"wh2.camp.advice.death_night.info_001",
			"wh2.camp.advice.death_night.info_002",
			"wh2.camp.advice.death_night.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Death Night advice (Triggered)
--
---------------------------------------------------------------

-- intervention declaration
in_death_night_triggered = intervention:new(
	"in_death_night_triggered",					 							-- string name
	40,	 																	-- cost
	function() trigger_in_death_night_triggered_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_death_night_triggered:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_death_night_triggered:set_must_trigger(true);
in_death_night_triggered:add_advice_key_precondition("dlc10.camp.advice.def.death_night.005");
in_death_night_triggered:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_death_night_triggered:add_trigger_condition(
	"ScriptEventDeathNightTriggered",
	function()
		return true;
	end
);

function trigger_in_death_night_triggered_advice()
	in_death_night_triggered:play_advice_for_intervention(	
		-- Laws no longer apply. The gates are sealed and only the strongest will survive this deadliest of nights - the tortured screams of your slaves will surely return Khaine's favour!
		"dlc10.camp.advice.def.death_night.005", 
		{
			"wh2.camp.advice.death_night.info_001",
			"wh2.camp.advice.death_night.info_002",
			"wh2.camp.advice.death_night.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Death Night advice (Morathi)
--
---------------------------------------------------------------

-- intervention declaration
in_death_night_morathi = intervention:new(
	"in_death_night_morathi",					 							-- string name
	40,	 																	-- cost
	function() trigger_in_death_night_morathi_advice() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_death_night_morathi:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_death_night_morathi:set_must_trigger(true);
in_death_night_morathi:add_advice_key_precondition("dlc10.camp.advice.def.death_night.008");
in_death_night_morathi:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_death_night_morathi:add_trigger_condition(
	"ScriptEventDeathMorathiDefeated",
	function()
		return true;
	end
);

function trigger_in_death_night_morathi_advice()
	in_death_night_morathi:play_advice_for_intervention(	
		-- Morathi's Cauldron of Blood is yours, my queen! Eternal youth and power are now much closer.
		"dlc10.camp.advice.def.death_night.008", 
		{
			"wh2.camp.advice.death_night.info_001",
			"wh2.camp.advice.death_night.info_002",
			"wh2.camp.advice.death_night.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Death Night advice (Alarielle)
--
---------------------------------------------------------------

-- intervention declaration
in_death_night_alarielle = intervention:new(
	"in_death_night_alarielle",					 							-- string name
	40,	 																	-- cost
	function() trigger_in_death_night_alarielle_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_death_night_alarielle:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_death_night_alarielle:set_must_trigger(true);
in_death_night_alarielle:add_advice_key_precondition("dlc10.camp.advice.def.death_night.009");
in_death_night_alarielle:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_death_night_alarielle:add_trigger_condition(
	"ScriptEventDeathAlarielleDefeated",
	function()
		return true;
	end
);

function trigger_in_death_night_alarielle_advice()
	in_death_night_alarielle:play_advice_for_intervention(	
		-- Avelorn belongs to you, cruel Blood Queen. The sacred shrines of Isha will soon be soaked in bloody offerings to Khaine!
		"dlc10.camp.advice.def.death_night.009", 
		{
			"wh2.camp.advice.death_night.info_001",
			"wh2.camp.advice.death_night.info_002",
			"wh2.camp.advice.death_night.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Blood Voyage advice (Spawned)
--
---------------------------------------------------------------


-- intervention declaration
in_blood_voyage_spawned = intervention:new(
	"in_blood_voyage_spawned",					 							-- string name
	40,	 																	-- cost
	function() trigger_in_blood_voyage_spawned_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_blood_voyage_spawned:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_blood_voyage_spawned:set_must_trigger(true);
in_blood_voyage_spawned:add_advice_key_precondition("dlc10.camp.advice.def.death_night.006");
in_blood_voyage_spawned:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_blood_voyage_spawned:add_trigger_condition(
	"ScriptEventDeathBloodVoyage",
	function()
		return true;
	end
);


function trigger_in_blood_voyage_spawned_advice()
	in_blood_voyage_spawned:play_advice_for_intervention(	
		-- Death Night is over, my queen, but in the aftermath come the gore-stained survivors. Overtaken by the madness of Khaine, these Blood-Voyaging warriors are intent on continuing their rampage!
		"dlc10.camp.advice.def.death_night.006", 
		{
			"wh2.camp.advice.blood_voyage.info_001",
			"wh2.camp.advice.blood_voyage.info_002",
			"wh2.camp.advice.blood_voyage.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Blood Voyage advice (Destroyed)
--
---------------------------------------------------------------


-- intervention declaration
in_blood_voyage_destroyed = intervention:new(
	"in_blood_voyage_destroyed",					 						-- string name
	40,	 																	-- cost
	function() trigger_in_blood_voyage_destroyed_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_blood_voyage_destroyed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_blood_voyage_destroyed:set_must_trigger(true);
in_blood_voyage_destroyed:add_advice_key_precondition("dlc10.camp.advice.def.death_night.007");
in_blood_voyage_destroyed:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_blood_voyage_destroyed:add_trigger_condition(
	"ScriptEventDeathBloodVoyageDead",
	function()
		return true;
	end
);

function trigger_in_blood_voyage_destroyed_advice()
	in_blood_voyage_destroyed:play_advice_for_intervention(	
		-- Fighting to the last, the Blood Voyage has fallen with Khaine's name on their lips. Convenient then that the spoils of their raid should fall to you...
		"dlc10.camp.advice.def.death_night.007", 
		{
			"wh2.camp.advice.blood_voyage.info_001",
			"wh2.camp.advice.blood_voyage.info_002",
			"wh2.camp.advice.blood_voyage.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Sword of Khaine advice (Available)
--
---------------------------------------------------------------

-- intervention declaration
in_sword_of_khaine_available = intervention:new(
	"in_sword_of_khaine_available",					 								-- string name
	40,	 																			-- cost
	function() trigger_in_sword_of_khaine_available_advice() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_sword_of_khaine_available:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_sword_of_khaine_available:set_must_trigger(true);
in_sword_of_khaine_available:add_advice_key_precondition("dlc10.camp.advice.def.sword_of_khaine.001");
in_sword_of_khaine_available:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_sword_of_khaine_available:add_trigger_condition(
	"ScriptEventSwordAvailable",
	function()
		return true;
	end
);

function trigger_in_sword_of_khaine_available_advice()
	in_sword_of_khaine_available:play_advice_for_intervention(	
		-- The Sword of Khaine calls to you. The Shrine of Khaine must be secured if you wish to wield Aenarion's blade.
		"dlc10.camp.advice.def.sword_of_khaine.001", 
		{
			"wh2.camp.advice.sword_of_khaine.info_001",
			"wh2.camp.advice.sword_of_khaine.info_002",
			"wh2.camp.advice.sword_of_khaine.info_003"
		}
	);
end;


---------------------------------------------------------------
--
--	Sword of Khaine advice (claimed by player)
--
---------------------------------------------------------------

-- intervention declaration
in_sword_of_khaine_player_claimed = intervention:new(
	"in_sword_of_khaine_player_claimed",					 				-- string name
	40,	 																	-- cost
	function() trigger_in_sword_of_khaine_player_claimed_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_sword_of_khaine_player_claimed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_sword_of_khaine_player_claimed:set_must_trigger(true);
in_sword_of_khaine_player_claimed:add_advice_key_precondition("dlc10.camp.advice.def.sword_of_khaine.002");
in_sword_of_khaine_player_claimed:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_sword_of_khaine_player_claimed:add_trigger_condition(
	"ScriptEventSwordClaimedByPlayer",
	function()
		return true;
	end
);

function trigger_in_sword_of_khaine_player_claimed_advice()
	in_sword_of_khaine_player_claimed:play_advice_for_intervention(	
		-- Glorious! You now wield the Sword of Khaine. Use its immense power to annihilate your enemies!
		"dlc10.camp.advice.def.sword_of_khaine.002", 
		{
			"wh2.camp.advice.sword_of_khaine.info_001",
			"wh2.camp.advice.sword_of_khaine.info_002",
			"wh2.camp.advice.sword_of_khaine.info_003"
		}
	);
end;


---------------------------------------------------------------
--
--	Sword of Khaine advice (claimed by AI)
--
---------------------------------------------------------------

-- intervention declaration
in_sword_of_khaine_ai_claimed = intervention:new(
	"in_sword_of_khaine_ai_claimed",					 					-- string name
	40,	 																	-- cost
	function() trigger_in_sword_of_khaine_ai_claimed_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_sword_of_khaine_ai_claimed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_sword_of_khaine_ai_claimed:set_must_trigger(true);
in_sword_of_khaine_ai_claimed:add_advice_key_precondition("dlc10.camp.advice.def.sword_of_khaine.003");
in_sword_of_khaine_ai_claimed:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_sword_of_khaine_ai_claimed:add_trigger_condition(
	"ScriptEventSwordClaimedByAI",
	function()
		return true;
	end
);

function trigger_in_sword_of_khaine_ai_claimed_advice()
	in_sword_of_khaine_ai_claimed:play_advice_for_intervention(	
		-- The Sword of Khaine has been unleashed into the world. However, another has secured it for themselves. Its power cannot be trusted to them - should you get the opportunity, strip the Widowmaker from their grasp!
		"dlc10.camp.advice.def.sword_of_khaine.003", 
		{
			"wh2.camp.advice.sword_of_khaine.info_001",
			"wh2.camp.advice.sword_of_khaine.info_002",
			"wh2.camp.advice.sword_of_khaine.info_004",
			"wh2.camp.advice.sword_of_khaine.info_005"
		}
	);
end;


---------------------------------------------------------------
--
--	Sword of Khaine advice (Stuck on character)
--
---------------------------------------------------------------

-- intervention declaration
in_sword_of_khaine_stuck = intervention:new(
	"in_sword_of_khaine_stuck",					 							-- string name
	40,	 																	-- cost
	function() trigger_in_sword_of_khaine_stuck_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_sword_of_khaine_stuck:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_sword_of_khaine_stuck:set_must_trigger(true);
in_sword_of_khaine_stuck:add_advice_key_precondition("dlc10.camp.advice.def.sword_of_khaine.004");
in_sword_of_khaine_stuck:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_sword_of_khaine_stuck:add_trigger_condition(
	"ScriptEventSwordStuck",
	function()
		return true;
	end
);

function trigger_in_sword_of_khaine_stuck_advice()
	in_sword_of_khaine_stuck:play_advice_for_intervention(	
		-- The power of Khaine courses through your veins. A word of caution: remember the curse it laid upon Aenarion. Stay focused or you will sacrifice your sanity to sword!
		"dlc10.camp.advice.def.sword_of_khaine.004", 
		{
			"wh2.camp.advice.sword_of_khaine.info_001",
			"wh2.camp.advice.sword_of_khaine.info_002",
			"wh2.camp.advice.sword_of_khaine.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Sword of Khaine advice (Sword Returned)
--
---------------------------------------------------------------

-- intervention declaration
in_sword_of_khaine_returned = intervention:new(
	"in_sword_of_khaine_returned",					 						-- string name
	40,	 																	-- cost
	function() trigger_in_sword_of_khaine_returned_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_sword_of_khaine_returned:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_sword_of_khaine_returned:set_must_trigger(true);
in_sword_of_khaine_returned:add_advice_key_precondition("dlc10.camp.advice.def.sword_of_khaine.005");
in_sword_of_khaine_returned:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_sword_of_khaine_returned:add_trigger_condition(
	"ScriptEventSwordReturned",
	function()
		return true;
	end
);

function trigger_in_sword_of_khaine_returned_advice()
	in_sword_of_khaine_returned:play_advice_for_intervention(	
		-- You are one with the Sword of Khaine. Its power consumes you and your every thought. These bonds are now for all eternity and with them, a curse of brutal strength and endless torment!
		"dlc10.camp.advice.def.sword_of_khaine.006",
		{
			"wh2.camp.advice.sword_of_khaine.info_001",
			"wh2.camp.advice.sword_of_khaine.info_002",
			"wh2.camp.advice.sword_of_khaine.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Sword of Khaine advice (Dilemma First)
--
---------------------------------------------------------------

-- intervention declaration
in_sword_of_khaine_dilemma = intervention:new(
	"in_sword_of_khaine_dilemma",					 								-- string name
	40,	 																			-- cost
	function() trigger_in_sword_of_khaine_dilemma_advice() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_sword_of_khaine_dilemma:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_sword_of_khaine_dilemma:set_must_trigger(true);
in_sword_of_khaine_dilemma:add_advice_key_precondition("dlc10.camp.advice.def.sword_of_khaine.006");
in_sword_of_khaine_dilemma:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_sword_of_khaine_dilemma:add_trigger_condition(
	"ScriptEventSwordDilemmaFirst",
	function()
		return true;
	end
);

function trigger_in_sword_of_khaine_dilemma_advice()
	in_sword_of_khaine_dilemma:play_advice_for_intervention(	
		-- As it always does, the sword has returned to Khaine's Shrine. Perhaps this is for the best, or might there now be an opportunity?
		"dlc10.camp.advice.def.sword_of_khaine.006", 
		{
			"wh2.camp.advice.sword_of_khaine.info_001",
			"wh2.camp.advice.sword_of_khaine.info_002",
			"wh2.camp.advice.sword_of_khaine.info_006",
			"wh2.camp.advice.sword_of_khaine.info_005"
		}
	);
end;



---------------------------------------------------------------
--
--	Marked for Death advice (First Targets)
--
---------------------------------------------------------------

-- intervention declaration
in_assassination_targets_first_targets = intervention:new(
	"assassination_targets_first_targets",					 				-- string name
	40,	 																	-- cost
	function() trigger_assassination_targets_first_targets_advice() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_assassination_targets_first_targets:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_assassination_targets_first_targets:set_must_trigger(true);
in_assassination_targets_first_targets:add_advice_key_precondition("dlc10.camp.advice.hef.assassination_targets.001");
in_assassination_targets_first_targets:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_assassination_targets_first_targets:add_trigger_condition(
	"ScriptEventCampaignIntroComplete",
	function()
		return true;
	end
);


function trigger_assassination_targets_first_targets_advice()
	in_assassination_targets_first_targets:play_advice_for_intervention(	
		-- Loec's ravens bring news and names, my king. Three enemies of the Shadowlands have been selected and marked for death by your hand!
		"dlc10.camp.advice.hef.assassination_targets.001", 
		{
			"wh2.camp.advice.marked_for_death.info_001",
			"wh2.camp.advice.marked_for_death.info_002",
			"wh2.camp.advice.marked_for_death.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Marked for Death advice (First Kill)
--
---------------------------------------------------------------

-- intervention declaration
in_assassination_targets_first_kill = intervention:new(
	"assassination_targets_first_kill",					 					-- string name
	40,	 																	-- cost
	function() trigger_assassination_targets_first_kill_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_assassination_targets_first_kill:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_assassination_targets_first_kill:set_must_trigger(true);
in_assassination_targets_first_kill:add_advice_key_precondition("dlc10.camp.advice.hef.assassination_targets.002");
in_assassination_targets_first_kill:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_assassination_targets_first_kill:add_trigger_condition(
	"ScriptEventAssassinationFirstTargetKilled",
	function()
		return true;
	end);

function trigger_assassination_targets_first_kill_advice()
	in_assassination_targets_first_kill:play_advice_for_intervention(	
		-- Good! This enemy of Nagarythe will threaten our lands no longer, your highness.
		"dlc10.camp.advice.hef.assassination_targets.002", 
		{
			"wh2.camp.advice.marked_for_death.info_001",
			"wh2.camp.advice.marked_for_death.info_002",
			"wh2.camp.advice.marked_for_death.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Marked for Death advice (Kill All Targets)
--
---------------------------------------------------------------

-- intervention declaration
in_assassination_targets_kill_all_targets = intervention:new(
	"assassination_targets_kill_all_targets",					 			-- string name
	40,	 																	-- cost
	function() trigger_assassination_targets_kill_all_targets() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_assassination_targets_kill_all_targets:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_assassination_targets_kill_all_targets:set_must_trigger(true);
in_assassination_targets_kill_all_targets:add_advice_key_precondition("dlc10.camp.advice.hef.assassination_targets.003");
in_assassination_targets_kill_all_targets:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_assassination_targets_kill_all_targets:add_trigger_condition(
	"ScriptEventAssassinationAllTargetsKilled",
	function()
		return true;
	end);

function trigger_assassination_targets_kill_all_targets()
	in_assassination_targets_kill_all_targets:play_advice_for_intervention(	
		-- You are Aenarion reborn, my king! All that stood before Nagarythe have been put to the sword and silenced for good.
		"dlc10.camp.advice.hef.assassination_targets.003", 
		{
			"wh2.camp.advice.marked_for_death.info_001",
			"wh2.camp.advice.marked_for_death.info_002",
			"wh2.camp.advice.marked_for_death.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Marked for Death advice (New Targets)
--
---------------------------------------------------------------

-- intervention declaration
in_assassination_targets_new_targets = intervention:new(
	"assassination_targets_new_targets",					 				-- string name
	40,	 																	-- cost
	function() trigger_assassination_targets_new_targets_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_assassination_targets_new_targets:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_assassination_targets_new_targets:set_must_trigger(true);
in_assassination_targets_new_targets:add_advice_key_precondition("dlc10.camp.advice.hef.assassination_targets.004");
in_assassination_targets_new_targets:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_assassination_targets_new_targets:add_trigger_condition(
	"ScriptEventAssassinationNewTargets",
	function()
		return true;
	end);

function trigger_assassination_targets_new_targets_advice()
	in_assassination_targets_new_targets:play_advice_for_intervention(	
		-- Eternal vigilance is required, my liege! Three more targets have been marked by Loec. Their lives must be extinguished.
		"dlc10.camp.advice.hef.assassination_targets.004", 
		{
			"wh2.camp.advice.marked_for_death.info_001",
			"wh2.camp.advice.marked_for_death.info_002",
			"wh2.camp.advice.marked_for_death.info_003"
		}
	);
end;




---------------------------------------------------------------
--
--	Defender of Ulthuan advice (Inner Gained)
--
---------------------------------------------------------------

-- intervention declaration
in_protector_of_ulthuan_inner_gained = intervention:new(
	"in_protector_of_ulthuan_inner_gained",					 				-- string name
	40,	 																	-- cost
	function() trigger_in_protector_of_ulthuan_inner_gained_advice() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_protector_of_ulthuan_inner_gained:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_protector_of_ulthuan_inner_gained:set_must_trigger(true);
in_protector_of_ulthuan_inner_gained:add_advice_key_precondition("dlc10.camp.advice.hef.protector_of_ulthuan.001");
in_protector_of_ulthuan_inner_gained:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_protector_of_ulthuan_inner_gained:add_trigger_condition(
	"ScriptEventDefenderOfUlthuanInnerRegained",
	function()
		return true;
	end
);


function trigger_in_protector_of_ulthuan_inner_gained_advice()
	in_protector_of_ulthuan_inner_gained:play_advice_for_intervention(	
		-- Your highness, Ulthuan once more belongs to the Asur. But beware, foreign interlopers will always covet the riches of our homeland.
		"dlc10.camp.advice.hef.protector_of_ulthuan.001", 
		{
			"wh2.camp.advice.defender_of_ulthuan.info_001",
			"wh2.camp.advice.defender_of_ulthuan.info_002",
			"wh2.camp.advice.defender_of_ulthuan.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Defender of Ulthuan advice (Inner Lost)
--
---------------------------------------------------------------

-- intervention declaration
in_protector_of_ulthuan_inner_lost = intervention:new(
	"in_protector_of_ulthuan_inner_lost",					 				-- string name
	40,	 																	-- cost
	function() trigger_in_protector_of_ulthuan_inner_lost_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_protector_of_ulthuan_inner_lost:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_protector_of_ulthuan_inner_lost:set_must_trigger(true);
in_protector_of_ulthuan_inner_lost:add_advice_key_precondition("dlc10.camp.advice.hef.protector_of_ulthuan.002");
in_protector_of_ulthuan_inner_lost:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_protector_of_ulthuan_inner_lost:add_trigger_condition(
	"ScriptEventDefenderOfUlthuanInnerLost",
	function()
		return true;
	end
);

function trigger_in_protector_of_ulthuan_inner_lost_advice()
	in_protector_of_ulthuan_inner_lost:play_advice_for_intervention(	
		-- The breach has been sealed, but the task is not yet over. We must sally forth from the fortress and push the invaders from our shores once and for all!
		"dlc10.camp.advice.hef.protector_of_ulthuan.002", 
		{
			"wh2.camp.advice.defender_of_ulthuan.info_001",
			"wh2.camp.advice.defender_of_ulthuan.info_002",
			"wh2.camp.advice.defender_of_ulthuan.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Defender of Ulthuan advice (Unity)
--
---------------------------------------------------------------

-- intervention declaration
in_protector_of_ulthuan_unity = intervention:new(
	"in_protector_of_ulthuan_unity",					 					-- string name
	40,	 																	-- cost
	function() trigger_in_protector_of_ulthuan_unity_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_protector_of_ulthuan_unity:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_protector_of_ulthuan_unity:set_must_trigger(true);
in_protector_of_ulthuan_unity:add_advice_key_precondition("dlc10.camp.advice.hef.protector_of_ulthuan.003");
in_protector_of_ulthuan_unity:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_protector_of_ulthuan_unity:add_trigger_condition(
	"ScriptEventDefenderOfUlthuanUnited",
	function()
		return true;
	end
);

function trigger_in_protector_of_ulthuan_unity_advice()
	in_protector_of_ulthuan_unity:play_advice_for_intervention(	
		-- The sacred lands of inner Ulthuan are no longer controlled by the Asur! Retaking the fortress gates must be a priority. From there we can seize back control of our lands from the enemy.
		"dlc10.camp.advice.hef.protector_of_ulthuan.003", 
		{
			"wh2.camp.advice.defender_of_ulthuan.info_001",
			"wh2.camp.advice.defender_of_ulthuan.info_002",
			"wh2.camp.advice.defender_of_ulthuan.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Defender of Ulthuan advice (Outer Lost)
--
---------------------------------------------------------------

-- intervention declaration
in_protector_of_ulthuan_outer_lost = intervention:new(
	"in_protector_of_ulthuan_outer_lost",					 				-- string name
	40,	 																	-- cost
	function() trigger_in_protector_of_ulthuan_outer_lost_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_protector_of_ulthuan_outer_lost:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_protector_of_ulthuan_outer_lost:set_must_trigger(true);
in_protector_of_ulthuan_outer_lost:add_advice_key_precondition("dlc10.camp.advice.hef.protector_of_ulthuan.004");
in_protector_of_ulthuan_outer_lost:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_protector_of_ulthuan_outer_lost:add_trigger_condition(
	"ScriptEventDefenderOfUlthuanOuterLost",
	function()
		return true;
	end
);

function trigger_in_protector_of_ulthuan_outer_lost_advice()
	in_protector_of_ulthuan_outer_lost:play_advice_for_intervention(	
		-- Disaster! My queen, invaders have a beachhead upon sacred Ulthuan. They must be repulsed before they can push over the Annulii Mountains.
		"dlc10.camp.advice.hef.protector_of_ulthuan.004", 
		{
			"wh2.camp.advice.defender_of_ulthuan.info_001",
			"wh2.camp.advice.defender_of_ulthuan.info_002",
			"wh2.camp.advice.defender_of_ulthuan.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Power of Nature advice
--
---------------------------------------------------------------

-- intervention declaration
in_power_of_nature = intervention:new(
	"in_power_of_nature",					 							    -- string name
	40,	 																 	-- cost
	function() trigger_in_power_of_nature_advice() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_power_of_nature:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_power_of_nature:set_must_trigger(true);
in_power_of_nature:set_min_turn(2);
in_power_of_nature:add_advice_key_precondition("dlc10.camp.advice.hef.power_of_nature.001");
in_power_of_nature:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_power_of_nature:add_trigger_condition(
	"ScriptEventPowerOfNatureTriggered",
	function()
		return true;
	end
);

function trigger_in_power_of_nature_advice()
	in_power_of_nature:play_advice_for_intervention(	
		-- Wherever you hold court, the land heals, your highness. Even long after you have departed, the land will still glow with your radiant light.
		"dlc10.camp.advice.hef.power_of_nature.001", 
		{
			"wh2.camp.advice.power_of_nature.info_001",
			"wh2.camp.advice.power_of_nature.info_002",
			"wh2.camp.advice.power_of_nature.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Mortal Worlds Torment advice (Stage 1)
--
---------------------------------------------------------------


-- intervention declaration
in_mortal_worlds_torment_stage_one = intervention:new(
	"in_mortal_worlds_torment_stage_one",					 				-- string name
	40,	 																	-- cost
	function() trigger_in_mortal_worlds_torment_stage_one_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_mortal_worlds_torment_stage_one:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_mortal_worlds_torment_stage_one:set_must_trigger(true);
in_mortal_worlds_torment_stage_one:set_min_turn(2);
in_mortal_worlds_torment_stage_one:add_advice_key_precondition("dlc10.camp.advice.mortal_worlds_torment.001");
in_mortal_worlds_torment_stage_one:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_mortal_worlds_torment_stage_one:add_trigger_condition(
	"ScriptEventMortalWorldsTorment1",
	function()
		return true;
	end
);

function trigger_in_mortal_worlds_torment_stage_one_advice()
	in_mortal_worlds_torment_stage_one:play_advice_for_intervention(	
		-- My queen, the torrent of the Dark Gods stirs. We must act before this trickle becomes a flood.
		"dlc10.camp.advice.mortal_worlds_torment.001",
		{
			"wh2.camp.advice.mortal_worlds_torment.info_001",
			"wh2.camp.advice.mortal_worlds_torment.info_002",
			"wh2.camp.advice.mortal_worlds_torment.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Mortal Worlds Torment advice (Stage 2)
--
---------------------------------------------------------------


-- intervention declaration
in_mortal_worlds_torment_stage_two = intervention:new(
	"in_mortal_worlds_torment_stage_two",					 				-- string name
	40,	 																	-- cost
	function() trigger_in_mortal_worlds_torment_stage_two_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_mortal_worlds_torment_stage_two:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_mortal_worlds_torment_stage_two:set_must_trigger(true);
in_mortal_worlds_torment_stage_two:add_advice_key_precondition("dlc10.camp.advice.mortal_worlds_torment.002");
in_mortal_worlds_torment_stage_two:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_mortal_worlds_torment_stage_two:add_trigger_condition(
	"ScriptEventMortalWorldsTorment2",
	function()
		return true;
	end
);

function trigger_in_mortal_worlds_torment_stage_two_advice()
	in_mortal_worlds_torment_stage_two:play_advice_for_intervention(	
		-- The followers of the Dark Gods grow in ever greater numbers. To do nothing will see your power diminish further!
		"dlc10.camp.advice.mortal_worlds_torment.002", 
		{
			"wh2.camp.advice.mortal_worlds_torment.info_001",
			"wh2.camp.advice.mortal_worlds_torment.info_002",
			"wh2.camp.advice.mortal_worlds_torment.info_003"
		}
	);
end;



---------------------------------------------------------------
--
--	Mortal Worlds Torment advice (Stage 3)
--
---------------------------------------------------------------


-- intervention declaration
in_mortal_worlds_torment_stage_three = intervention:new(
	"in_mortal_worlds_torment_stage_three",					 				-- string name
	40,	 																	-- cost
	function() trigger_in_mortal_worlds_torment_stage_three_advice() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_mortal_worlds_torment_stage_three:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_mortal_worlds_torment_stage_three:set_must_trigger(true);
in_mortal_worlds_torment_stage_three:add_advice_key_precondition("dlc10.camp.advice.mortal_worlds_torment.003");
in_mortal_worlds_torment_stage_three:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_mortal_worlds_torment_stage_three:add_trigger_condition(
	"ScriptEventMortalWorldsTorment3",
	function()
		return true;
	end
);

function trigger_in_mortal_worlds_torment_stage_three_advice()
	in_mortal_worlds_torment_stage_three:play_advice_for_intervention(	
		-- Grave tidings, your highness! The world cries out in torment as the Ruinous Powers threaten to overturn the Forces of Order.
		"dlc10.camp.advice.mortal_worlds_torment.003", 
		{
			"wh2.camp.advice.mortal_worlds_torment.info_001",
			"wh2.camp.advice.mortal_worlds_torment.info_002",
			"wh2.camp.advice.mortal_worlds_torment.info_003"
		}
	);
end;







---------------------------------------------------------------
--
--	Treasure Map Mission Issuing
--
---------------------------------------------------------------


-- intervention declaration
in_treasure_map_mission = intervention:new(
	"in_treasure_map_mission",					 							-- string name
	40,	 																	-- cost
	function() trigger_in_treasure_map_mission() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_treasure_map_mission:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_treasure_map_mission:set_must_trigger(true, true);
in_treasure_map_mission:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.treasure_hunts.002");
in_treasure_map_mission:add_whitelist_event_type("faction_event_mission_issuedevent_feed_target_mission_faction");

in_treasure_map_mission:add_trigger_condition(
	"ScriptEventIssueTreasureMapMission",
	true
);

function trigger_in_treasure_map_mission()
	in_treasure_map_mission:play_advice_for_intervention(	
		-- A new map, Admiral – can it's riddle can be solved?
		"wh2_dlc11.camp.advice.cst.treasure_hunts.002", 
		{
			"dlc11.camp.advice.treasure_maps.info_001",
			"dlc11.camp.advice.treasure_maps.info_002",
			"dlc11.camp.advice.treasure_maps.info_003"
		}
	);
	
end;





---------------------------------------------------------------
--
--	Full Treasure Map Log
--
---------------------------------------------------------------


-- intervention declaration
in_full_treasure_map_log = intervention:new(
	"in_full_treasure_map_log",					 							-- string name
	40,	 																	-- cost
	function() trigger_in_full_treasure_map_log() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_full_treasure_map_log:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_full_treasure_map_log:set_must_trigger(true, true);
in_full_treasure_map_log:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.treasure_hunts.003");
in_full_treasure_map_log:add_whitelist_event_type("faction_event_mission_successevent_feed_target_mission_faction");

in_full_treasure_map_log:add_trigger_condition(
	"ScriptEventIssueTreasureMapMissionFullLog",
	true
);

function trigger_in_full_treasure_map_log()
	
	in_full_treasure_map_log:play_advice_for_intervention(	
		-- You have quite the map collection now, admiral!
		"wh2_dlc11.camp.advice.cst.treasure_hunts.003", 
		{
			"dlc11.camp.advice.treasure_maps.info_001",
			"dlc11.camp.advice.treasure_maps.info_004",
			"dlc11.camp.advice.treasure_maps.info_003"
		}
	);
end;





---------------------------------------------------------------
--
--	First Treasure Map Mission Succeeded
--
---------------------------------------------------------------


-- intervention declaration
in_first_treasure_map_mission_succeeded = intervention:new(
	"in_first_treasure_map_mission_succeeded",					 							-- string name
	99,	 																					-- cost
	function() trigger_in_first_treasure_map_mission_succeeded() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);

in_first_treasure_map_mission_succeeded:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_first_treasure_map_mission_succeeded:set_must_trigger(true, true);
in_first_treasure_map_mission_succeeded:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.treasure_hunts.004");
in_first_treasure_map_mission_succeeded:add_whitelist_event_type("faction_event_mission_successevent_feed_target_mission_faction");

in_first_treasure_map_mission_succeeded:add_trigger_condition(
	"ScriptEventFirstTreasureMapMissionSucceeded",
	function()
		return true;
	end
);

function trigger_in_first_treasure_map_mission_succeeded()
	
	in_first_treasure_map_mission_succeeded:play_advice_for_intervention(	
		-- Your treasure trove grows in size, admiral. Yet more can be yours if you so desire it.
		"wh2_dlc11.camp.advice.cst.treasure_hunts.004", 
		{
			"dlc11.camp.advice.treasure_maps.info_001",
			"dlc11.camp.advice.treasure_maps.info_002",
			"dlc11.camp.advice.treasure_maps.info_003"
		}
	);
end;






---------------------------------------------------------------
--
--	Fifth Treasure Map Mission Succeeded
--
---------------------------------------------------------------


-- intervention declaration
in_fifth_treasure_map_mission_succeeded = intervention:new(
	"in_fifth_treasure_map_mission_succeeded",					 							-- string name
	99,	 																					-- cost
	function() trigger_in_fifth_treasure_map_mission_succeeded() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);

in_fifth_treasure_map_mission_succeeded:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_fifth_treasure_map_mission_succeeded:set_must_trigger(true, true);
in_fifth_treasure_map_mission_succeeded:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.treasure_hunts.005");
in_fifth_treasure_map_mission_succeeded:add_whitelist_event_type("faction_event_mission_successevent_feed_target_mission_faction");

in_fifth_treasure_map_mission_succeeded:add_trigger_condition(
	"ScriptEventFifthTreasureMapMissionSucceeded",
	function()
		return true;
	end
);

function trigger_in_fifth_treasure_map_mission_succeeded()
	
	in_fifth_treasure_map_mission_succeeded:play_advice_for_intervention(	
		-- Your wealth is unsurpassed, admiral. Others falter as you grow ever stronger.
		"wh2_dlc11.camp.advice.cst.treasure_hunts.005", 
		{
			"dlc11.camp.advice.treasure_maps.info_001",
			"dlc11.camp.advice.treasure_maps.info_002",
			"dlc11.camp.advice.treasure_maps.info_003"
		}
	);
end;








---------------------------------------------------------------
--
--	Treasure Not Found
--
---------------------------------------------------------------


-- intervention declaration
in_treasure_not_found = intervention:new(
	"in_treasure_not_found",					 						-- string name
	99,	 																-- cost
	function() trigger_in_treasure_not_found() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_treasure_not_found:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_treasure_not_found:set_must_trigger(true, true);
in_treasure_not_found:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.treasure_hunts.009");
in_treasure_not_found:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_treasure_not_found:add_trigger_condition(
	"ScriptEventTreasureSearchFailed",
	function(context)
		return true;
	end
);

function trigger_in_treasure_not_found()
	
	in_treasure_not_found:play_advice_for_intervention(	
		-- Alas, this treasure remains well hidden.
		"wh2_dlc11.camp.advice.cst.treasure_hunts.009", 
		{
			"dlc11.camp.advice.treasure_maps.info_001",
			"dlc11.camp.advice.treasure_maps.info_002",
			"dlc11.camp.advice.treasure_maps.info_007",
			"dlc11.camp.advice.treasure_maps.info_006"
		}
	);
end;









---------------------------------------------------------------
--
--	Ulthuan Monster First Attack
--
---------------------------------------------------------------


-- intervention declaration
in_ulthuan_monster_first_attack = intervention:new(
	"in_ulthuan_monster_first_attack",					 									-- string name
	50,	 																					-- cost
	function() trigger_in_ulthuan_monster_first_attack() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);

in_ulthuan_monster_first_attack:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_ulthuan_monster_first_attack:set_must_trigger(true, true);
in_ulthuan_monster_first_attack:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.sea_monster.001");
in_ulthuan_monster_first_attack:add_whitelist_event_type("scripted_persistent_located_eventevent_feed_target_faction");
in_ulthuan_monster_first_attack:take_priority_over_intervention("in_ulthuan_monster_second_attack");
in_ulthuan_monster_first_attack:take_priority_over_intervention("in_ulthuan_monster_attacks_player_settlement");

in_ulthuan_monster_first_attack:add_trigger_condition(
	"ScriptEventUlthuanMonsterAttacksSea",
	function(context)
		if context.number >= 1 then
			-- this is the first attack this campaign
			in_ulthuan_monster_first_attack.vector = context:vector();
			in_ulthuan_monster_first_attack.region_key = context.string;
			return true;
		end;
	end
);

in_ulthuan_monster_first_attack:add_trigger_condition(
	"ScriptEventUlthuanMonsterAttacksSettlement",
	function(context)
		if context.number >= 1 then
			-- this is the first attack this campaign
			in_ulthuan_monster_first_attack.vector = context:vector();
			in_ulthuan_monster_first_attack.region_key = context.string;
			return true;
		end;
	end
);

function trigger_in_ulthuan_monster_first_attack()
	
	in_ulthuan_monster_first_attack:scroll_camera_for_intervention(
		in_ulthuan_monster_first_attack.region_key,
		in_ulthuan_monster_first_attack.vector:get_x(),
		in_ulthuan_monster_first_attack.vector:get_z(),
		-- Amanar! The mighty and ancient sea-beast attacks any and all, my lord, leaving destruction in its wake.
		"wh2_dlc11.camp.advice.cst.sea_monster.001", 
		{
			"dlc11.camp.advice.amanar.info_001",
			"dlc11.camp.advice.amanar.info_002",
			"dlc11.camp.advice.amanar.info_003"
		}
	);
end;









---------------------------------------------------------------
--
--	Ulthuan Monster Second Attack
--
---------------------------------------------------------------


-- intervention declaration
in_ulthuan_monster_second_attack = intervention:new(
	"in_ulthuan_monster_second_attack",					 									-- string name
	50,	 																					-- cost
	function() trigger_in_ulthuan_monster_second_attack() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);

in_ulthuan_monster_second_attack:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_ulthuan_monster_second_attack:set_must_trigger(true, true);
in_ulthuan_monster_second_attack:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.sea_monster.002");
in_ulthuan_monster_second_attack:add_whitelist_event_type("scripted_persistent_located_eventevent_feed_target_faction");
in_ulthuan_monster_second_attack:take_priority_over_intervention("in_ulthuan_monster_attacks_player_settlement");

in_ulthuan_monster_second_attack:add_trigger_condition(
	"ScriptEventUlthuanMonsterAttacksSea",
	function(context)
		if context.number >= 2 then
			-- this is the second attack this campaign
			in_ulthuan_monster_second_attack.vector = context:vector();
			in_ulthuan_monster_second_attack.region_key = context.string;
			return true;
		end;
	end
);


in_ulthuan_monster_second_attack:add_trigger_condition(
	"ScriptEventUlthuanMonsterAttacksSettlement",
	function(context)
		if context.number >= 2 then
			-- this is the second attack this campaign
			in_ulthuan_monster_second_attack.vector = context:vector();
			in_ulthuan_monster_second_attack.region_key = context.string;
			return true;
		end;
	end
);


function trigger_in_ulthuan_monster_second_attack()
	
	in_ulthuan_monster_second_attack:scroll_camera_for_intervention(
		in_ulthuan_monster_second_attack.region_key,
		in_ulthuan_monster_second_attack.vector:get_x(),
		in_ulthuan_monster_second_attack.vector:get_z(),
		-- Amanar! The mighty and ancient sea-beast attacks any and all, my lord, leaving destruction in its wake.
		"wh2_dlc11.camp.advice.cst.sea_monster.002", 
		{
			"dlc11.camp.advice.amanar.info_001",
			"dlc11.camp.advice.amanar.info_002",
			"dlc11.camp.advice.amanar.info_003"
		}
	);
end;











---------------------------------------------------------------
--
--	Ulthuan Monster Attacks Player Settlement
--
---------------------------------------------------------------


-- intervention declaration
in_ulthuan_monster_attacks_player_settlement = intervention:new(
	"in_ulthuan_monster_attacks_player_settlement",					 						-- string name
	50,	 																					-- cost
	function() trigger_in_ulthuan_monster_attacks_player_settlement() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);

in_ulthuan_monster_attacks_player_settlement:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_ulthuan_monster_attacks_player_settlement:set_must_trigger(true, true);
in_ulthuan_monster_attacks_player_settlement:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.sea_monster.003");
in_ulthuan_monster_attacks_player_settlement:add_whitelist_event_type("scripted_persistent_located_eventevent_feed_target_faction");

in_ulthuan_monster_attacks_player_settlement:add_trigger_condition(
	"ScriptEventUlthuanMonsterAttacksSettlement",
	function(context)
		local region = cm:get_region(context.string);
		if region and region:owning_faction():name() == cm:get_local_faction_name() then	
			in_ulthuan_monster_attacks_player_settlement.vector = context:vector();
			in_ulthuan_monster_attacks_player_settlement.region_key = context.string;
			return true;
		end;
	end
);

function trigger_in_ulthuan_monster_attacks_player_settlement()
	
	in_ulthuan_monster_attacks_player_settlement:scroll_camera_for_intervention(
		in_ulthuan_monster_attacks_player_settlement.region_key,
		in_ulthuan_monster_attacks_player_settlement.vector:get_x(),
		in_ulthuan_monster_attacks_player_settlement.vector:get_z(),
		-- The beast's lash leaves your settlement in devastation, admiral, I fear it may return again to strike further havoc and carnage.
		"wh2_dlc11.camp.advice.cst.sea_monster.003", 
		{
			"dlc11.camp.advice.amanar.info_001",
			"dlc11.camp.advice.amanar.info_002",
			"dlc11.camp.advice.amanar.info_003"
		}
	);
end;














---------------------------------------------------------------
--
--	Ulthuan Monster Under Player Control
--
---------------------------------------------------------------


-- intervention declaration
in_ulthuan_monster_under_player_control = intervention:new(
	"in_ulthuan_monster_under_player_control",					 							-- string name
	40,	 																					-- cost
	function() trigger_in_ulthuan_monster_under_player_control() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);

in_ulthuan_monster_under_player_control:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_ulthuan_monster_under_player_control:set_must_trigger(true, true);
in_ulthuan_monster_under_player_control:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.sea_monster.004");

in_ulthuan_monster_under_player_control:add_trigger_condition(
	"ScriptEventUlthuanMonsterUnderPlayerControl",
	function(context)
		return true;
	end
);

function trigger_in_ulthuan_monster_under_player_control()
	
	in_ulthuan_monster_under_player_control:play_advice_for_intervention(
		-- Finally Amanar is yours to control! Use his power against all those that oppose you!
		"wh2_dlc11.camp.advice.cst.sea_monster.004", 
		{
			"dlc11.camp.advice.amanar.info_001",
			"dlc11.camp.advice.amanar.info_004",
			"dlc11.camp.advice.amanar.info_003"
		}
	);
end;









---------------------------------------------------------------
--
--	Player Infamy Grows
--
---------------------------------------------------------------


-- intervention declaration
in_player_infamy_grows = intervention:new(
	"in_player_infamy_grows",					 											-- string name
	40,	 																					-- cost
	function() trigger_in_player_infamy_grows() end,										-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);

in_player_infamy_grows:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_player_infamy_grows:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.infamy.001");
in_player_infamy_grows:take_priority_over_intervention("in_player_climbs_infamy_list");

in_player_infamy_grows:add_trigger_condition(
	"ScriptEventPlayerInfamyIncreases",
	function(context)
		return true;
	end
);

function trigger_in_player_infamy_grows()
	
	in_player_infamy_grows:play_advice_for_intervention(
		-- A pirate indeed, admiral, for your actions speak ever louder as your infamy grows.
		"wh2_dlc11.camp.advice.cst.infamy.001",
		{
			"dlc11.camp.advice.infamy.info_001",
			"dlc11.camp.advice.infamy.info_002",
			"dlc11.camp.advice.infamy.info_003"
		}
	);
end;









---------------------------------------------------------------
--
--	Player Climbs Infamy List
--
---------------------------------------------------------------


-- intervention declaration
in_player_climbs_infamy_list = intervention:new(
	"in_player_climbs_infamy_list",					 										-- string name
	40,	 																					-- cost
	function() trigger_in_player_climbs_infamy_list() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);

in_player_climbs_infamy_list:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_player_climbs_infamy_list:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.infamy.002");
in_player_climbs_infamy_list:take_priority_over_intervention("in_player_tops_infamy_list");

in_player_climbs_infamy_list:add_trigger_condition(
	"ScriptEventPlayerClimbsInfamyList",
	function(context)
		return true;
	end
);

function trigger_in_player_climbs_infamy_list()
	
	in_player_climbs_infamy_list:play_advice_for_intervention(
		-- Your infamous actions are making waves with others – they will surely fear your name upon the high seas!
		"wh2_dlc11.camp.advice.cst.infamy.002",
		{
			"dlc11.camp.advice.infamy.info_001",
			"dlc11.camp.advice.infamy.info_002",
			"dlc11.camp.advice.infamy.info_003"
		}
	);
end;








---------------------------------------------------------------
--
--	Player tops Infamy List
--
---------------------------------------------------------------


-- intervention declaration
in_player_tops_infamy_list = intervention:new(
	"in_player_tops_infamy_list",					 										-- string name
	40,	 																					-- cost
	function() trigger_in_player_tops_infamy_list() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);

in_player_tops_infamy_list:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_player_tops_infamy_list:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.shanty.007");

in_player_tops_infamy_list:add_trigger_condition(
	"ScriptEventPlayerTopsInfamyList",
	function(context)
		return true;
	end
);

function trigger_in_player_tops_infamy_list()
	
	in_player_tops_infamy_list:play_advice_for_intervention(
		-- All salute you, admiral, for you are the most infamous of men, women and beasts that roam these seas. You are the true Pirate Lord.
		"wh2_dlc11.camp.advice.cst.shanty.007",
		{
			"dlc11.camp.advice.infamy.info_001",
			"dlc11.camp.advice.infamy.info_002",
			"dlc11.camp.advice.infamy.info_004",
			"dlc11.camp.advice.infamy.info_005"
		}
	);
end;


---------------------------------------------------------------
--
--	Rogue Pirate spotted
--
---------------------------------------------------------------


-- intervention declaration
in_rogue_army_sighted = intervention:new(
	"in_rogue_army_sighted",					 								-- string name
	10,	 																		-- cost
	function() trigger_in_rogue_army_sighted() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_rogue_army_sighted:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_rogue_army_sighted:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.pirates.001");

in_rogue_army_sighted:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
	
		local rogue_pirate_factions = {
			"wh2_dlc11_cst_rogue_boyz_of_the_forbidden_coast",
			"wh2_dlc11_cst_rogue_freebooters_of_port_royale",
			"wh2_dlc11_cst_rogue_the_churning_gulf_raiders",
			"wh2_dlc11_cst_rogue_bleak_coast_buccaneers",
			"wh2_dlc11_cst_rogue_grey_point_scuttlers",
			"wh2_dlc11_cst_rogue_tyrants_of_the_black_ocean",
			"wh2_dlc11_cst_rogue_terrors_of_the_dark_straights"
		};
		
		local player_faction_name = cm:get_local_faction_name();
		local player_character_list = cm:get_faction(player_faction_name):character_list();
		
		local closest_distance_squared = 50000000;
		local closest_character = false;
		
		-- for each of the rogue pirate factions, measure the distance from each their characters to each of the player's characters
		for i = 1, #rogue_pirate_factions do
			local current_pirate_faction = cm:get_faction(rogue_pirate_factions[i]);
			
			if current_pirate_faction then
				for j = 0, current_pirate_faction:character_list():num_items() - 1 do
					local current_pirate_character = current_pirate_faction:character_list():item_at(j);
					
					if current_pirate_character:is_visible_to_faction(player_faction_name) then
						for k = 0, player_character_list:num_items() - 1 do
							local current_distance_squared = distance_squared(player_character_list:item_at(k):logical_position_x(), player_character_list:item_at(k):logical_position_y(), current_pirate_character:logical_position_x(), current_pirate_character:logical_position_y());
							if current_distance_squared < closest_distance_squared then
								-- this is the closest player <-> rogue pirate distance yet measured, record it
								closest_distance_squared = current_distance_squared;
								closest_character = current_pirate_character;
							end;
						end;
					end;
				end;
				
				-- we have finished looking through a rogue pirate faction - is the closest character close enough to the player to trigger the advice
				if closest_character and closest_distance_squared ^ 0.5 < INTERVENTION_CLOSE_DISTANCE then
					in_rogue_army_sighted.char_cqi = closest_character:cqi();
					out.interventions("\tin_rogue_army_sighted has found a candidate character of cqi [" .. closest_character:cqi() .. "] and faction [" .. closest_character:faction():name() .. "] within distance " .. closest_distance_squared ^ 0.5 .. " of the player - attempting to trigger");
					return true;
				end;
			end;
		end;
	end
);

function trigger_in_rogue_army_sighted()
	
	in_rogue_army_sighted:scroll_camera_to_character_for_intervention(
		in_rogue_army_sighted.char_cqi,
		-- Pirates have been spotted close by. Showing them your broadside would be a good way to further your infamy, or gain a treasure map, should you wish to attack them.
		"wh2_dlc11.camp.advice.cst.pirates.001",
		{
			"dlc11.camp.advice.rogue_pirates.info_001",
			"dlc11.camp.advice.rogue_pirates.info_002",
			"dlc11.camp.advice.rogue_pirates.info_003"
		}
	);
end;










---------------------------------------------------------------
--
--	Pieces of Eight tab opened
--
---------------------------------------------------------------


-- intervention declaration
in_pieces_of_eight_tab_opened = intervention:new(
	"in_pieces_of_eight_tab_opened",					 						-- string name
	10,	 																		-- cost
	function() trigger_in_pieces_of_eight_tab_opened() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_pieces_of_eight_tab_opened:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_pieces_of_eight_tab_opened:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.pieces_of_eight.001");
in_pieces_of_eight_tab_opened:set_wait_for_fullscreen_panel_dismissed(false);

in_pieces_of_eight_tab_opened:add_trigger_condition(
	"ComponentLClickUp",
	function(context)
		return context.string == "pieces" and uicomponent_descended_from(UIComponent(context.component), "treasure_hunts");
	end
);

function trigger_in_pieces_of_eight_tab_opened()
	
	in_pieces_of_eight_tab_opened:play_advice_for_intervention(
		-- Cursed trinkets, admiral, that have twisted and altered the minds of those that first claimed them. Now the servants of others, these puppets will be yours to command should you claim the Piece of Eight which corrupted them!
		"wh2_dlc11.camp.advice.cst.pieces_of_eight.001",
		{
			"dlc11.camp.advice.pieces_of_eight.info_001",
			"dlc11.camp.advice.pieces_of_eight.info_002",
			"dlc11.camp.advice.pieces_of_eight.info_003",
			"dlc11.camp.advice.pieces_of_eight.info_004"
		}
	);
end;









---------------------------------------------------------------
--
--	First Piece of Eight collected
--
---------------------------------------------------------------


-- intervention declaration
in_first_piece_of_eight_collected = intervention:new(
	"in_first_piece_of_eight_collected",					 						-- string name
	10,	 																			-- cost
	function() trigger_in_first_piece_of_eight_collected() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_first_piece_of_eight_collected:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
-- in_first_piece_of_eight_collected:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.pieces_of_eight.002");
in_first_piece_of_eight_collected:add_whitelist_event_type("faction_event_mission_successevent_feed_target_mission_faction");
in_first_piece_of_eight_collected:take_priority_over_intervention("in_fourth_piece_of_eight_collected");


in_first_piece_of_eight_collected:add_trigger_condition(
	"ScriptEventPieceOfEightCollected",
	function(context)
		return true;
	end
);

function trigger_in_first_piece_of_eight_collected()
	
	in_first_piece_of_eight_collected:play_advice_for_intervention(
		-- This is quite the treasure and certainly more than meets the eye! You now have control over an elite unit to serve should you wish, admiral.
		"wh2_dlc11.camp.advice.cst.pieces_of_eight.002",
		{
			"dlc11.camp.advice.pieces_of_eight.info_001",
			"dlc11.camp.advice.pieces_of_eight.info_002",
			"dlc11.camp.advice.pieces_of_eight.info_003",
			"dlc11.camp.advice.pieces_of_eight.info_005"
		}
	);
end;










---------------------------------------------------------------
--
--	Fourth Piece of Eight collected
--
---------------------------------------------------------------


-- intervention declaration
in_fourth_piece_of_eight_collected = intervention:new(
	"in_fourth_piece_of_eight_collected",					 					-- string name
	10,	 																		-- cost
	function() trigger_in_fourth_piece_of_eight_collected() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_fourth_piece_of_eight_collected:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_fourth_piece_of_eight_collected:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.pieces_of_eight.003");
in_fourth_piece_of_eight_collected:add_whitelist_event_type("faction_event_mission_successevent_feed_target_mission_faction");

in_fourth_piece_of_eight_collected:add_trigger_condition(
	"ScriptEventPieceOfEightCollected",
	function(context)
		return context.number >= 4;
	end
);

function trigger_in_fourth_piece_of_eight_collected()
	
	in_fourth_piece_of_eight_collected:play_advice_for_intervention(
		-- A fine collection you have there, admiral, one that grows ever closer to completion.
		"wh2_dlc11.camp.advice.cst.pieces_of_eight.003",
		{
			"dlc11.camp.advice.pieces_of_eight.info_001",
			"dlc11.camp.advice.pieces_of_eight.info_002",
			"dlc11.camp.advice.pieces_of_eight.info_003"
		}
	);
end;









---------------------------------------------------------------
--
--	All Pieces of Eight collected
--
---------------------------------------------------------------


-- intervention declaration
in_all_pieces_of_eight_collected = intervention:new(
	"in_all_pieces_of_eight_collected",					 						-- string name
	10,	 																		-- cost
	function() trigger_in_all_pieces_of_eight_collected() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_all_pieces_of_eight_collected:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_all_pieces_of_eight_collected:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.pieces_of_eight.004");
in_all_pieces_of_eight_collected:add_whitelist_event_type("faction_event_mission_successevent_feed_target_mission_faction");

in_all_pieces_of_eight_collected:add_trigger_condition(
	"ScriptEventPieceOfEightCollected",
	function(context)
		return context.number == 8;
	end
);

function trigger_in_all_pieces_of_eight_collected()
	
	in_all_pieces_of_eight_collected:play_advice_for_intervention(
		-- I see no treasure is left untouched by you, admiral. You command all of the Pieces of Eight and the creatures that are cursed by them.
		"wh2_dlc11.camp.advice.cst.pieces_of_eight.004",
		{
			"dlc11.camp.advice.pieces_of_eight.info_001",
			"dlc11.camp.advice.pieces_of_eight.info_002",
			"dlc11.camp.advice.pieces_of_eight.info_003"
		}
	);
end;













---------------------------------------------------------------
--
--	post-battle Pirate loyalty
--
---------------------------------------------------------------

-- intervention declaration
in_post_normal_battle_pirate_loyalty = intervention:new(
	"post_normal_battle_pirate_loyalty", 										-- string name
	90, 																		-- cost
	function() in_post_normal_battle_pirate_loyalty_advice_trigger() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);


in_post_normal_battle_pirate_loyalty:add_advice_key_precondition("war.camp.advice.post_battle_options.001");
in_post_normal_battle_pirate_loyalty:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_post_normal_battle_pirate_loyalty:set_player_turn_only(false);
in_post_normal_battle_pirate_loyalty:set_wait_for_battle_complete(false);
in_post_normal_battle_pirate_loyalty:give_priority_to_intervention("post_normal_battle_victory_options");


in_post_normal_battle_pirate_loyalty:add_trigger_condition(
	"ScriptEventHumanWinsFieldBattle",
	function(context)
		local player_faction_key = cm:get_local_faction_name();
		local player_non_legendary_lord_commanding = false;
		
		if player_faction_key then
			-- return true if we have a player non-faction-leader commanding in this battle
			if cm:pending_battle_cache_faction_is_attacker(player_faction_key) then
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local char_cqi, mf_cqi, faction_key = cm:pending_battle_cache_get_attacker(i);
					
					if faction_key == player_faction_key then
						local character = cm:get_character_by_cqi(char_cqi);
						if character and not character:is_faction_leader() then
							return true;
						end;
					end
				end;
				
			elseif cm:pending_battle_cache_faction_is_defender(player_faction_key) then
				for i = 1, cm:pending_battle_cache_num_defenders() do
					local char_cqi, mf_cqi, faction_key = cm:pending_battle_cache_get_defender(i);
					
					if faction_key == player_faction_key then
						local character = cm:get_character_by_cqi(char_cqi);
						if character and not character:is_faction_leader() then
							return true;
						end;
					end
				end;
			end;
		end
	end
);


function in_post_normal_battle_pirate_loyalty_advice_trigger()
	
	local listener_str = "in_post_normal_battle_pirate_loyalty";

	-- if the player closes post-battle options immediately then just complete
	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function() 
			cm:remove_callback(listener_str);
			in_post_normal_battle_pirate_loyalty:complete();
		end,
		false
	);
	
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_post_normal_battle_pirate_loyalty_advice_play(listener_str);
		end,
		1,
		listener_str
	);
end;


function in_post_normal_battle_pirate_loyalty_advice_play(listener_str)
	in_post_normal_battle_pirate_loyalty:play_advice_for_intervention(
		-- Pirates are fickle, admiral, and are sure to betray you if not kept loyal with gold and trinkets.
		"wh2_dlc11.camp.advice.cst.loyalty.001",											-- advice key
		{																					-- infotext
			"dlc11.camp.advice.vampiric_loyalty.info_001",
			"dlc11.camp.advice.vampiric_loyalty.info_002",
			"dlc11.camp.advice.vampiric_loyalty.info_003",
			"dlc11.camp.advice.vampiric_loyalty.info_006"
		}
	);
	
	-- also complete when the post-battle panel gets closed
	core:add_listener(
		listener_str,
		"ScriptEventPostBattlePanelClosed",
		true,
		function(context)
			in_post_normal_battle_pirate_loyalty:cancel_play_advice_for_intervention();
			
			if in_post_normal_battle_pirate_loyalty.is_active then
				in_post_normal_battle_pirate_loyalty:complete();
			end;
		end,
		false
	);
end;














---------------------------------------------------------------
--
--	low pirate loyalty advice
--
---------------------------------------------------------------

-- intervention declaration
in_low_pirate_loyalty = intervention:new(
	"in_low_pirate_loyalty",												-- string name
	80,	 																	-- cost
	function() trigger_in_low_pirate_loyalty_advice() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_low_pirate_loyalty:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_low_pirate_loyalty:set_min_turn(7);
in_low_pirate_loyalty:set_turn_countdown_restart(8);
in_low_pirate_loyalty:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.loyalty.002");

in_low_pirate_loyalty:add_whitelist_event_type("character_loyalty_lowevent_feed_target_character_faction");
in_low_pirate_loyalty:add_whitelist_event_type("character_loyalty_criticalevent_feed_target_character_faction");


in_low_pirate_loyalty:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local character_list = cm:get_faction(cm:get_local_faction_name()):character_list();
		for i = 0, character_list:num_items() - 1 do
			local current_char = character_list:item_at(i);
			
			if current_char:has_military_force() and current_char:character_type("general") and current_char:loyalty() <= 3 then
				in_low_pirate_loyalty.char_cqi = current_char:cqi();
				return true;
			end;
		end;
	
		return false;
	end
);


function trigger_in_low_pirate_loyalty_advice()

	-- Disloyalty is a dangerous trait - you never know when a mutiny might occur.
	local advice_key = "wh2_dlc11.camp.advice.cst.loyalty.002";
	local infotext = {
		"dlc11.camp.advice.vampiric_loyalty.info_001",
		"dlc11.camp.advice.vampiric_loyalty.info_002",
		"dlc11.camp.advice.vampiric_loyalty.info_004",
		"dlc11.camp.advice.vampiric_loyalty.info_006"
	};
	
	if not in_low_pirate_loyalty.char_cqi or not core:is_advice_level_high() then
		in_low_pirate_loyalty:play_advice_for_intervention(
			advice_key,
			infotext
		);
	else
		in_low_pirate_loyalty:scroll_camera_to_character_for_intervention( 
			in_low_pirate_loyalty.char_cqi,
			advice_key, 
			infotext
		);
	end;
end;















---------------------------------------------------------------
--
--	pirate civil war
--
---------------------------------------------------------------

-- intervention declaration

in_pirate_civil_war = intervention:new(
	"pirate_civil_war",	 													-- string name
	15, 																	-- cost
	function() in_pirate_civil_war_trigger() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_pirate_civil_war:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_pirate_civil_war:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.loyalty.003");
in_pirate_civil_war:add_whitelist_event_type("faction_civil_war_characterevent_feed_target_faction_instigator_faction");

in_pirate_civil_war:add_trigger_condition(
	"FactionCivilWarOccured",
	function(context)
		-- return true if this is a civil war against the player
		if context:faction():name() == cm:get_local_faction_name() then
			in_pirate_civil_war.char_cqi = context:opponent():faction_leader():cqi();
			return true;
		end;
		return false;
	end
);

function in_pirate_civil_war_trigger()
	local char_cqi = in_pirate_civil_war.char_cqi;
	
	-- Mutiny is afoot, admiral, teach these dogs a swift lesson.
	local advice_key = "wh2_dlc11.camp.advice.cst.loyalty.003";
	local infotext = {
		"dlc11.camp.advice.vampiric_loyalty.info_001",
		"dlc11.camp.advice.vampiric_loyalty.info_002",
		"dlc11.camp.advice.vampiric_loyalty.info_005",
		"dlc11.camp.advice.vampiric_loyalty.info_006"
	};
	
	if cm:get_character_by_cqi(char_cqi) then
		in_pirate_civil_war:scroll_camera_to_character_for_intervention(
			char_cqi,
			advice_key,
			infotext
		);
	else
		in_pirate_civil_war:play_advice_for_intervention(
			advice_key,
			infotext
		);
	end;
end;















---------------------------------------------------------------
--
--	fleet office
--
---------------------------------------------------------------

-- intervention declaration
in_fleet_office = intervention:new(
	"fleet_office",		 														-- string name
	5, 																			-- cost
	function() in_fleet_office_trigger() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_fleet_office:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_fleet_office:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.offices.001");
in_fleet_office:set_wait_for_fullscreen_panel_dismissed(false);


in_fleet_office:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		return context.string == "offices";
	end
);

function in_fleet_office_trigger()	
	in_fleet_office:play_advice_for_intervention(
		-- You are now Admiral of the Fleet; position others in seats of influence to improve your naval power.
		"wh2_dlc11.camp.advice.cst.offices.001",
		{
			"dlc11.camp.advice.fleet_office.info_001",
			"dlc11.camp.advice.fleet_office.info_002",
			"dlc11.camp.advice.fleet_office.info_003"
		}
	);
end;








---------------------------------------------------------------
--
--	post siege battle pirate cove
--
---------------------------------------------------------------

-- intervention declaration
in_post_siege_battle_pirate_cove = intervention:new(
	"post_siege_battle_pirate_cove", 											-- string name
	90, 																		-- cost
	function() in_post_siege_battle_pirate_cove_advice_trigger() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);


in_post_siege_battle_pirate_cove:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.pirate_coves.001");
in_post_siege_battle_pirate_cove:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_post_siege_battle_pirate_cove:set_player_turn_only(false);
in_post_siege_battle_pirate_cove:set_wait_for_battle_complete(false);
in_post_siege_battle_pirate_cove:give_priority_to_intervention("post_siege_battle_victory_options");

in_post_siege_battle_pirate_cove:add_trigger_condition(
	"ScriptEventPlayerWinsSettlementBattle",
	function()
		-- only trigger if the pending battle is at a port that the player doesn't own
		local pb = cm:model():pending_battle();
		
		if pb:has_contested_garrison() and pb:contested_garrison():settlement_interface():is_port() and pb:contested_garrison():faction():name() ~= cm:get_local_faction_name() then
			return true;
		end;
		
		return false;
	end
);


function in_post_siege_battle_pirate_cove_advice_trigger()	
	core:add_listener(
		"in_post_siege_battle_pirate_cove",
		"PanelOpenedCampaign",
		function(context) return context.string == "settlement_captured" end,
		function() in_post_siege_battle_pirate_cove_advice_play() end,
		false	
	);
end;


function in_post_siege_battle_pirate_cove_advice_play()
	in_post_siege_battle_pirate_cove:play_advice_for_intervention(
		-- This settlement is at your mercy! Claim it for yourself or use it as a lair by establishing a Pirate Cove here, admiral.
		"wh2_dlc11.camp.advice.cst.pirate_coves.001",										-- advice key
		{																					-- infotext
			"dlc11.camp.advice.pirate_coves.info_001",
			"dlc11.camp.advice.pirate_coves.info_002",
			"dlc11.camp.advice.pirate_coves.info_003"
		}
	);
end;
















---------------------------------------------------------------
--
--	pre island battle options
--
---------------------------------------------------------------

-- intervention declaration
in_pre_island_battle_options = intervention:new(
	"pre_island_battle_options", 													-- string name
	90, 																			-- cost
	function() in_pre_island_battle_options_advice_trigger() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);


in_pre_island_battle_options:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.island_battle.001");
in_pre_island_battle_options:give_priority_to_intervention("autoresolving");
in_pre_island_battle_options:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_pre_island_battle_options:set_player_turn_only(false);
in_pre_island_battle_options:set_wait_for_battle_complete(false);


in_pre_island_battle_options:add_trigger_condition(
	"ScriptEventPreBattlePanelOpenedField",
	function(context)
		local pb = cm:model():pending_battle();
		
		-- do not proceed if this is not a land_normal battle at sea
		if not (pb:battle_type() == "land_normal" and pb:naval_battle()) then
			return false;
		end;
				
		local player_strength = 0;
		
		-- determine player's relative strength in this battle
		if cm:pending_battle_cache_faction_is_attacker(cm:get_local_faction_name()) then
			player_strength = pb:attacker_strength();
		else
			player_strength = pb:defender_strength();
		end;
		
		-- return true if the player has a reasonable chance of victory, or if it's not the player's turn
		return player_strength >= 50 or not cm:is_local_players_turn();
	end
);


in_pre_island_battle_options:set_completion_callback(
	function()
		cm:remove_callback("in_pre_island_battle_options_listener");
	end
);


function in_pre_island_battle_options_advice_trigger()
	local listener_str = "in_pre_island_battle_options";
	
	-- if the player closes panel immediately then just complete
	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function()
			cm:remove_callback(listener_str);
			in_pre_island_battle_options:complete();
		end,
		false
	);
	
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_pre_island_battle_options_advice_play();
		end,
		0.5,
		listener_str
	);
end;


function in_pre_island_battle_options_advice_play()
	in_pre_island_battle_options:play_advice_for_intervention(
		-- Admiral, a nearby island may gift you an advantage in seeing off this foe.
		"wh2_dlc11.camp.advice.cst.island_battle.001"
	);
end;














---------------------------------------------------------------
--
--	puzzle dice
--
---------------------------------------------------------------

-- intervention declaration
in_puzzle_dice = intervention:new(
	"puzzle_dice", 																-- string name
	90, 																		-- cost
	function() in_puzzle_dice_trigger() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);


in_puzzle_dice:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.puzzle_dice.001");
in_puzzle_dice:set_wait_for_dilemma(false);
in_puzzle_dice:set_min_advice_level(ADVICE_LEVEL_HIGH);


in_puzzle_dice:add_trigger_condition(
	"DilemmaIssuedEvent",
	function(context)
		return string.find(context:dilemma(), "wh2_dlc11_th_puzzle_4") and context:faction():name() == cm:get_local_faction_name()
	end
);


function in_puzzle_dice_trigger()
	in_puzzle_dice:play_advice_for_intervention(
		-- A puzzle of the Old Ones, ancient beings the reptiles still claim to serve. Solving this will bestow many great riches upon you. Perhaps the answer has something to do with the rotation of these curious dice? 
		"wh2_dlc11.camp.advice.cst.puzzle_dice.001"
	);
end;














---------------------------------------------------------------
--
--	puzzle clock
--
---------------------------------------------------------------

-- intervention declaration
in_puzzle_clock = intervention:new(
	"puzzle_clock", 																-- string name
	90, 																		-- cost
	function() in_puzzle_clock_trigger() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);


in_puzzle_clock:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.puzzle_clock.001");
in_puzzle_clock:set_wait_for_dilemma(false);
in_puzzle_clock:set_min_advice_level(ADVICE_LEVEL_HIGH);


in_puzzle_clock:add_trigger_condition(
	"DilemmaIssuedEvent",
	function(context)
		return string.find(context:dilemma(), "wh2_dlc11_th_puzzle_2") and context:faction():name() == cm:get_local_faction_name()
	end
);


function in_puzzle_clock_trigger()
	in_puzzle_clock:play_advice_for_intervention(
		-- A puzzle of the ancients which surely hides great treasure. The coloured lines around the face hold the key to solving this puzzle. 
		"wh2_dlc11.camp.advice.cst.puzzle_clock.001"
	);
end;










---------------------------------------------------------------
--
--	puzzle numbers
--
---------------------------------------------------------------

-- intervention declaration
in_puzzle_numbers = intervention:new(
	"puzzle_numbers", 															-- string name
	90, 																		-- cost
	function() in_puzzle_numbers_trigger() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);


in_puzzle_numbers:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.puzzle_numbers.001");
in_puzzle_numbers:set_wait_for_dilemma(false);
in_puzzle_numbers:set_min_advice_level(ADVICE_LEVEL_HIGH);


in_puzzle_numbers:add_trigger_condition(
	"DilemmaIssuedEvent",
	function(context)
		return string.find(context:dilemma(), "wh2_dlc11_th_puzzle_1") and context:faction():name() == cm:get_local_faction_name()
	end
);


function in_puzzle_numbers_trigger()
	in_puzzle_numbers:play_advice_for_intervention(
		-- A puzzle of the Old Ones – solving it will grant you many riches. It appears that this is a numeric grid, like a 'to wound' chart, where the rows and columns are of great importance.
		"wh2_dlc11.camp.advice.cst.puzzle_numbers.001"
	);
end;










---------------------------------------------------------------
--
--	puzzle odd-one-out
--
---------------------------------------------------------------

-- intervention declaration
in_puzzle_odd_one_out = intervention:new(
	"puzzle_odd_one_out", 														-- string name
	90, 																		-- cost
	function() in_puzzle_odd_one_out_trigger() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);


in_puzzle_odd_one_out:add_advice_key_precondition("wh2_dlc11.camp.advice.cst.puzzle_odd_one_out.001");
in_puzzle_odd_one_out:set_wait_for_dilemma(false);
in_puzzle_odd_one_out:set_min_advice_level(ADVICE_LEVEL_HIGH);


in_puzzle_odd_one_out:add_trigger_condition(
	"DilemmaIssuedEvent",
	function(context)
		return string.find(context:dilemma(), "wh2_dlc11_th_puzzle_1") and context:faction():name() == cm:get_local_faction_name()
	end
);


function in_puzzle_odd_one_out_trigger()
	in_puzzle_odd_one_out:play_advice_for_intervention(
		-- The Old Ones liked to test their disciples. Now it is a pirate's turn! It appears the symbols are the cypher to open this treasure.
		"wh2_dlc11.camp.advice.cst.puzzle_odd_one_out.001"
	);
end;





---------------------------------------------------------------
--
--	Sacrifices to Sotek (After battle: Seeing Post Battle Option)
--
---------------------------------------------------------------

-- intervention declaration
in_sacrifices_to_sotek_post_battle_option = intervention:new(
	"in_sacrifices_to_sotek_post_battle_option", 									-- string name
	50, 																		-- cost
	function() in_sacrifices_to_sotek_post_battle_option_trigger() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);


in_sacrifices_to_sotek_post_battle_option:add_advice_key_precondition("wh2_dlc12.camp.advice.lzd.sacrifices_to_sotek.001");
in_sacrifices_to_sotek_post_battle_option:set_player_turn_only(false);
in_sacrifices_to_sotek_post_battle_option:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_sacrifices_to_sotek_post_battle_option:set_wait_for_battle_complete(false);
in_sacrifices_to_sotek_post_battle_option:give_priority_to_intervention("post_normal_battle_victory_options");


in_sacrifices_to_sotek_post_battle_option:add_trigger_condition(
	"ScriptEventHumanWinsFieldBattle",
	true
);


function in_sacrifices_to_sotek_post_battle_option_trigger()
	in_sacrifices_to_sotek_post_battle_option:play_advice_for_intervention(
		-- 	The survivors of battle have been rounded up and their fate is in your hands my Lord, one option is to take these captives and prepare them as an offering to Sotek.
		"wh2_dlc12.camp.advice.lzd.sacrifices_to_sotek.001",
		{
			"wh2.camp.advice.lizardmen_sacrifice_to_sotek.info_001",
			"wh2.camp.advice.lizardmen_sacrifice_to_sotek.info_002",
			"wh2.camp.advice.lizardmen_sacrifice_to_sotek.info_003"
		}
	);
end;


---------------------------------------------------------------
--
--	Sacrifices to Sotek (Sacrifices Pooled Resource Increased)
--
---------------------------------------------------------------


-- intervention declaration
in_sacrifices_to_sotek_pooled_increase = intervention:new(
	"in_sacrifices_to_sotek_pooled_increase", 									-- string name
	30, 																		-- cost
	function() in_sacrifices_to_sotek_pooled_increase_trigger() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);


in_sacrifices_to_sotek_pooled_increase:add_advice_key_precondition("wh2_dlc12.camp.advice.lzd.sacrifices_to_sotek.002");
in_sacrifices_to_sotek_pooled_increase:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_sacrifices_to_sotek_pooled_increase:give_priority_to_intervention("in_sacrifices_to_sotek_post_battle_option");

in_sacrifices_to_sotek_pooled_increase:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		
		for i = 0, context:faction():pooled_resource_manager():resources():num_items() - 1 do
			
			if context:faction():pooled_resource_manager():resources():item_at(i):key() == "lzd_sacrificial_offerings" then
			
				if context:faction():pooled_resource_manager():resources():item_at(i):value() > 0 then
					return true;
				end;
			end;
		end;
		return false;
	end
);


function in_sacrifices_to_sotek_pooled_increase_trigger()
	in_sacrifices_to_sotek_pooled_increase:play_advice_for_intervention(
		-- 	Great Prophet Tehenhauin, Sotek demands more sacrifices before he can materialise at his full strength. Sacrificing captives to him will grant a variety of rewards depending on the type of offering undertaken.
		"wh2_dlc12.camp.advice.lzd.sacrifices_to_sotek.002"
	);
end;


---------------------------------------------------------------
--
--	Sacrifices to Sotek (Enough Captives to Perform Sacrifice)
--
---------------------------------------------------------------


-- intervention declaration
in_sacrifices_to_sotek_sacrifice_ready = intervention:new(
	"in_sacrifices_to_sotek_sacrifice_ready", 										-- string name
	90, 																		-- cost
	function() in_sacrifices_to_sotek_sacrifice_ready_trigger() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);


in_sacrifices_to_sotek_sacrifice_ready:add_advice_key_precondition("wh2_dlc12.camp.advice.lzd.sacrifices_to_sotek.003");
in_sacrifices_to_sotek_sacrifice_ready:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_sacrifices_to_sotek_sacrifice_ready:give_priority_to_intervention("in_sacrifices_to_sotek_post_battle_option");
in_sacrifices_to_sotek_sacrifice_ready:give_priority_to_intervention("in_sacrifices_to_sotek_pooled_increase");


in_sacrifices_to_sotek_sacrifice_ready:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		for i = 0, context:faction():pooled_resource_manager():resources():num_items() - 1 do
			
			if context:faction():pooled_resource_manager():resources():item_at(i):key() == "lzd_sacrificial_offerings" then
			
				if context:faction():pooled_resource_manager():resources():item_at(i):value() >= 100 then
					return true;
				end;
			end;
		end;
		return false;
	end
);


function in_sacrifices_to_sotek_sacrifice_ready_trigger()
	in_sacrifices_to_sotek_sacrifice_ready:play_advice_for_intervention(
		-- 	My Lord, you have captured enough enemies of Sotek that an offering can be made granting a boon from the Great Serpent God.
		"wh2_dlc12.camp.advice.lzd.sacrifices_to_sotek.003"
	);
end;



---------------------------------------------------------------
--
--	Sacrifices to Sotek (Sotek Army Ability Sacrifice available)
--
---------------------------------------------------------------


-- intervention declaration
in_sacrifices_to_sotek_sotek_available = intervention:new(
	"in_sacrifices_to_sotek_sotek_available",										-- string name
	30,	 																			-- cost
	function() trigger_in_sacrifices_to_sotek_sotek_available_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_sacrifices_to_sotek_sotek_available:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_sacrifices_to_sotek_sotek_available:add_advice_key_precondition("wh2_dlc12.camp.advice.lzd.sacrifices_to_sotek.004");
in_sacrifices_to_sotek_sotek_available:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");
in_sacrifices_to_sotek_sotek_available:give_priority_to_intervention("in_rites");


in_sacrifices_to_sotek_sotek_available:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		
		
		for i = 0, context:faction():pooled_resource_manager():resources():num_items() - 1 do
			
			if context:faction():pooled_resource_manager():resources():item_at(i):key() == "lzd_sacrificial_offerings" then
			
				if (context:faction():pooled_resource_manager():resources():item_at(i):value() >= 1000) and (cm:get_saved_value("pos_3_1")) then
					return true;
				end
			end;
		end;		
		return false;
		
	end
);

function trigger_in_sacrifices_to_sotek_sotek_available_advice()
	in_sacrifices_to_sotek_sotek_available:play_advice_for_intervention(
		-- The time has come Chosen of Sotek, complete the largest offering yet in Sotek’s honour. His arrival will bring doom to the perfidious Rat-spawn that remain in Lustria.
		"wh2_dlc12.camp.advice.lzd.sacrifices_to_sotek.004"
	);
end;

---------------------------------------------------------------
--
--	Sacrifices to Sotek (Unlocked New Tier of Sacrifices to Sotek: Part 1)
--
---------------------------------------------------------------

-- intervention declaration
in_sacrifices_to_sotek_unlocked_tier_2 = intervention:new(
	"in_sacrifices_to_sotek_unlocked_tier_2",											-- string name
	0,	 																				-- cost
	function() trigger_in_sacrifices_to_sotek_unlocked_tier_2_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_sacrifices_to_sotek_unlocked_tier_2:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_sacrifices_to_sotek_unlocked_tier_2:add_advice_key_precondition("wh2_dlc12.camp.advice.lzd.sacrifices_to_sotek.005");
in_sacrifices_to_sotek_unlocked_tier_2:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");
in_sacrifices_to_sotek_unlocked_tier_2:give_priority_to_intervention("in_rites");

in_sacrifices_to_sotek_unlocked_tier_2:add_trigger_condition(
	"ScriptEventSacrificeTier2Unlocked",
	true
);

function trigger_in_sacrifices_to_sotek_unlocked_tier_2_advice()
	in_sacrifices_to_sotek_unlocked_tier_2:play_advice_for_intervention(
		-- Mighty Prophet Tehenhauin, we have gained access to new offerings – these rewards are even greater, but the cost is equally large. Many thousands will need to be sacrificed in Sotek’s name.
		"wh2_dlc12.camp.advice.lzd.sacrifices_to_sotek.005"
	);
end;


---------------------------------------------------------------
--
--	Sacrifices to Sotek (Unlocked New Tier of Sacrifices to Sotek: Part 2)
--
---------------------------------------------------------------


-- intervention declaration
in_sacrifices_to_sotek_unlocked_tier_3 = intervention:new(
	"in_sacrifices_to_sotek_unlocked_tier_3",											-- string name
	0,	 																				-- cost
	function() trigger_in_sacrifices_to_sotek_unlocked_tier_3_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_sacrifices_to_sotek_unlocked_tier_3:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_sacrifices_to_sotek_unlocked_tier_3:add_advice_key_precondition("wh2_dlc12.camp.advice.lzd.sacrifices_to_sotek.006");
in_sacrifices_to_sotek_unlocked_tier_3:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");
in_sacrifices_to_sotek_unlocked_tier_3:give_priority_to_intervention("in_rites");

in_sacrifices_to_sotek_unlocked_tier_3:add_trigger_condition(
	"ScriptEventSacrificeTier3Unlocked",
	true
);

function trigger_in_sacrifices_to_sotek_unlocked_tier_3_advice()
	in_sacrifices_to_sotek_unlocked_tier_3:play_advice_for_intervention(
		-- Even more offerings are now available to you my Lord; as Sotek’s power grows so do the boons he bestows on his most fervent follower.
		"wh2_dlc12.camp.advice.lzd.sacrifices_to_sotek.006"
	);
end;


---------------------------------------------------------------
--
--	Prophecy of  Sotek (First turn)
--
---------------------------------------------------------------


-- intervention declaration
in_prophecy_turn_one = intervention:new(
	"in_prophecy_turn_one",					 							-- string name
	0,	 																-- cost
	function() trigger_in_prophecy_turn_one_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_prophecy_turn_one:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_prophecy_turn_one:add_advice_key_precondition("wh2_dlc12.camp.advice.lzd.prophecy_of_sotek.001");
in_prophecy_turn_one:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");
in_prophecy_turn_one:set_min_turn(1);


in_prophecy_turn_one:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()
		return true;
	end
);

function trigger_in_prophecy_turn_one_advice()
	in_prophecy_turn_one:play_advice_for_intervention(	
		-- The Prophecy is unfolding as it has once before. Your fellow Skinks follow you, Chosen of Sotek, but the Saurus have not yet been released by their Slann Masters to aid in your crusade. Prove your claim as Chosen of Sotek and earn their support.
		"wh2_dlc12.camp.advice.lzd.prophecy_of_sotek.001"
	);
end;

---------------------------------------------------------------
--
--	Prophecy of  Sotek (Completing Stage 1)
--
---------------------------------------------------------------


-- intervention declaration
in_prophecy_stage_1_completed = intervention:new(
	"in_prophecy_stage_1_completed",										-- string name
	30,	 																			-- cost
	function() trigger_in_prophecy_stage_1_completed_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_prophecy_stage_1_completed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_prophecy_stage_1_completed:add_advice_key_precondition("wh2_dlc12.camp.advice.lzd.prophecy_of_sotek.002");
in_prophecy_stage_1_completed:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_prophecy_stage_1_completed:add_trigger_condition(
	"ScriptEventPoSStage1Completed",
	true
);

function trigger_in_prophecy_stage_1_completed_advice()
	in_prophecy_stage_1_completed:play_advice_for_intervention(
		-- The Prophecy cannot be denied, Sotek has foreseen these events and only his blessing can rescue Lustria from certain doom. Unite the Lizardmen to defeat the Rat-spawn menace.
		"wh2_dlc12.camp.advice.lzd.prophecy_of_sotek.002"
	);
end;

---------------------------------------------------------------
--
--	Prophecy of  Sotek (Completing Stage 2)
--
---------------------------------------------------------------

-- intervention declaration
in_prophecy_stage_2_completed = intervention:new(
	"in_prophecy_stage_2_completed",										-- string name
	30,	 																			-- cost
	function() trigger_in_prophecy_stage_2_completed_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_prophecy_stage_2_completed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_prophecy_stage_2_completed:add_advice_key_precondition("wh2_dlc12.camp.advice.lzd.prophecy_of_sotek.003");
in_prophecy_stage_2_completed:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_prophecy_stage_2_completed:add_trigger_condition(
	"ScriptEventPoSStage2Completed",
	true
);

function trigger_in_prophecy_stage_2_completed_advice()
	in_prophecy_stage_2_completed:play_advice_for_intervention(
		-- The Great Serpent God grows stronger, but his arrival will require more sacrifices. It will take thousands to sate the appetite of the saviour of Lustria. 
		"wh2_dlc12.camp.advice.lzd.prophecy_of_sotek.003"
	);
end;

---------------------------------------------------------------
--
--	Prophecy of  Sotek (Completing Stage 3)
--
---------------------------------------------------------------

-- intervention declaration
in_prophecy_stage_3_completed = intervention:new(
	"in_prophecy_stage_3_completed",										-- string name
	30,	 																			-- cost
	function() trigger_in_prophecy_stage_3_completed_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_prophecy_stage_3_completed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_prophecy_stage_3_completed:add_advice_key_precondition("wh2_dlc12.camp.advice.lzd.prophecy_of_sotek.004");
in_prophecy_stage_3_completed:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_prophecy_stage_3_completed:add_trigger_condition(
	"ScriptEventSacrificeTier5Unlocked",
	true
);

function trigger_in_prophecy_stage_3_completed_advice()
	in_prophecy_stage_3_completed:play_advice_for_intervention(
		-- The Prophecy has been fulfilled! Sotek has granted his blessings unto you. The ultimate sacrifice can now be performed – summoning Sotek himself to aid you in battle!
		"wh2_dlc12.camp.advice.lzd.prophecy_of_sotek.004"
	);
end;


---------------------------------------------------------------
--
--	Bretonnian Vows (First time Vows panel is opened)
--
---------------------------------------------------------------


-- intervention declaration
in_bretonnian_vows_button_clicked = intervention:new(
	"in_bretonnian_vows_button_clicked",	 								-- string name
	0, 																		-- cost
	function() trigger_in_bretonnian_vows_button_clicked_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);


in_bretonnian_vows_button_clicked:add_trigger_condition(
	"ScriptEventBretonnianVowsButtonClicked",
	function()
		return true;
	end
);

in_bretonnian_vows_button_clicked:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_bretonnian_vows_button_clicked:add_advice_key_precondition("wh2_dlc12.camp.advice.brt.vows.001");
in_bretonnian_vows_button_clicked:set_wait_for_fullscreen_panel_dismissed(false);


function trigger_in_bretonnian_vows_button_clicked_advice()
	in_bretonnian_vows_button_clicked:play_advice_for_intervention( 
		-- Servants of the Lady can Pledge themselves to a cause, proving their faith and dutifulness to the Lady. There are multiple ways one can gain their prestige; choose a Pledge that will most benefit Bretonnia and the Lady. 
		"wh2_dlc12.camp.advice.brt.vows.001",
		{
			"wh2.camp.advice.bretonnian_vows.info_001",
			"wh2.camp.advice.bretonnian_vows.info_002",
			"wh2.camp.advice.bretonnian_vows.info_003"
		}
	);
end;


---------------------------------------------------------------
--
--	Bretonnian Vows (Completing Knights Vow)
--
---------------------------------------------------------------


-- intervention declaration
in_bretonnian_vows_knights_vow_completed = intervention:new(
	"in_bretonnian_vows_knights_vow_completed",										-- string name
	0,	 																			-- cost
	function() trigger_in_bretonnian_vows_knights_vow_completed_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_bretonnian_vows_knights_vow_completed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_bretonnian_vows_knights_vow_completed:add_advice_key_precondition("wh2_dlc12.camp.advice.brt.vows.002");
in_bretonnian_vows_knights_vow_completed:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_bretonnian_vows_knights_vow_completed:add_trigger_condition(
	"ScriptEventBretonniaKnightsVowCompleted",
	function(context)			
		in_bretonnian_vows_knights_vow_completed.char_cqi = context:character():cqi();
		return true;
	end	
);

function trigger_in_bretonnian_vows_knights_vow_completed_advice()

	local char_cqi = in_bretonnian_vows_knights_vow_completed.char_cqi;
	
	-- A servant of Bretonnia has completed their Pledge, earning them acknowledgement of the Lady of the Lake. They may now take up a new Pledge to further prove their loyalty to the Lady.
	local advice_key = "wh2_dlc12.camp.advice.brt.vows.002";
	
	if cm:get_character_by_cqi(char_cqi) then
		in_bretonnian_vows_knights_vow_completed:scroll_camera_to_character_for_intervention(
			char_cqi,
			advice_key
		);
	else
		in_bretonnian_vows_knights_vow_completed:play_advice_for_intervention(
			advice_key
		);
	end;
	
end;


---------------------------------------------------------------
--
--	Bretonnian Vows (Completing Questing Vow)
--
---------------------------------------------------------------


-- intervention declaration
in_bretonnian_vows_questing_vow_completed = intervention:new(
	"in_bretonnian_vows_questing_vow_completed",										-- string name
	0,	 																			-- cost
	function() trigger_in_bretonnian_vows_questing_vow_completed_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_bretonnian_vows_questing_vow_completed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_bretonnian_vows_questing_vow_completed:add_advice_key_precondition("wh2_dlc12.camp.advice.brt.vows.003");
in_bretonnian_vows_questing_vow_completed:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_bretonnian_vows_questing_vow_completed:add_trigger_condition(
	"ScriptEventBretonniaQuestingVowCompleted",
	function(context)			
		in_bretonnian_vows_questing_vow_completed.char_cqi = context:character():cqi();
		return true;
	end	
);

function trigger_in_bretonnian_vows_questing_vow_completed_advice()
	
	local char_cqi = in_bretonnian_vows_questing_vow_completed.char_cqi;
	
	-- Another Pledge fulfilled, all Bretonnia recognise their efforts and so does the Lady of the Lake herself. Completing just one more Pledge will prove beyond doubt to all in the land that they are the pinnacle of Chivalry.
	local advice_key = "wh2_dlc12.camp.advice.brt.vows.003";
	
	if cm:get_character_by_cqi(char_cqi) then
		in_bretonnian_vows_questing_vow_completed:scroll_camera_to_character_for_intervention(
			char_cqi,
			advice_key
		);
	else
		in_bretonnian_vows_questing_vow_completed:play_advice_for_intervention(
			advice_key
		);
	end;
	
	
end;


---------------------------------------------------------------
--
--	Bretonnian Vows (Completing Grail Vow)
--
---------------------------------------------------------------

-- intervention declaration
in_bretonnian_vows_grail_vow_completed = intervention:new(
	"in_bretonnian_vows_grail_vow_completed",										-- string name
	0,	 																			-- cost
	function() trigger_in_bretonnian_vows_grail_vow_completed_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_bretonnian_vows_grail_vow_completed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_bretonnian_vows_grail_vow_completed:add_advice_key_precondition("wh2_dlc12.camp.advice.brt.vows.004");
in_bretonnian_vows_grail_vow_completed:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_bretonnian_vows_grail_vow_completed:add_trigger_condition(
	"ScriptEventBretonniaGrailVowCompleted",
	function(context)			
		in_bretonnian_vows_grail_vow_completed.char_cqi = context:character():cqi();
		return true;
	end	
);

function trigger_in_bretonnian_vows_grail_vow_completed_advice()

	local char_cqi = in_bretonnian_vows_grail_vow_completed.char_cqi;
	
	-- The Lady of the Lake has presented herself to your servant, they have earned her blessing and gifted them a piece of her own power. There are few in this world that can stand against those touched by the Lady and their service for our cause is a great boon.
	local advice_key = "wh2_dlc12.camp.advice.brt.vows.004";
	
	if cm:get_character_by_cqi(char_cqi) then
		in_bretonnian_vows_grail_vow_completed:scroll_camera_to_character_for_intervention(
			char_cqi,
			advice_key
		);
	else
		in_bretonnian_vows_grail_vow_completed:play_advice_for_intervention(
			advice_key
		);
	end;
	
end;


---------------------------------------------------------------
--
--	Forbidden Workshop  (First Turn)
--
---------------------------------------------------------------


-- intervention declaration
in_ikit_workshop_turn_one = intervention:new(
	"in_ikit_workshop_turn_one",					 					-- string name
	0,	 																-- cost
	function() trigger_in_ikit_workshop_turn_one_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_ikit_workshop_turn_one:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_ikit_workshop_turn_one:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.ikit_workshop.001");
in_ikit_workshop_turn_one:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");
in_ikit_workshop_turn_one:set_min_turn(1);


in_ikit_workshop_turn_one:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()
		return true;
	end
);

function trigger_in_ikit_workshop_turn_one_advice()
	in_ikit_workshop_turn_one:play_advice_for_intervention(	
		-- 
		"wh2_dlc12.camp.advice.skv.ikit_workshop.001",
		{
			"wh2.camp.advice.skaven_forbidden_workshop.info_001",
			"wh2.camp.advice.skaven_forbidden_workshop.info_002",
			"wh2.camp.advice.skaven_forbidden_workshop.info_003"
		}
	);
end;




---------------------------------------------------------------
--
--	Forbidden Workshop  (Workshop Button Clicked)
--
---------------------------------------------------------------


-- intervention declaration
in_ikit_workshop_button_clicked = intervention:new(
	"in_ikit_workshop_button_clicked",	 									-- string name
	0, 																		-- cost
	function() trigger_in_ikit_workshop_button_clicked_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);


in_ikit_workshop_button_clicked:add_trigger_condition(
	"ScriptEventForbiddenWorkshopButtonClicked",
	function()
		return true;
	end
);

in_ikit_workshop_button_clicked:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_ikit_workshop_button_clicked:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.ikit_workshop.002");
in_ikit_workshop_button_clicked:set_wait_for_fullscreen_panel_dismissed(false);


function trigger_in_ikit_workshop_button_clicked_advice()
	in_ikit_workshop_button_clicked:play_advice_for_intervention( 
		--  
		"wh2_dlc12.camp.advice.skv.ikit_workshop.002"
	);
end;



---------------------------------------------------------------
--
--	Forbidden Workshop  (Workshop Panel Opened)
--
---------------------------------------------------------------

-- intervention declaration
in_ikit_workshop_panel_opened = intervention:new(
	"in_ikit_workshop_panel_opened",	 									-- string name
	0, 																		-- cost
	function() trigger_in_ikit_workshop_panel_opened_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);


in_ikit_workshop_panel_opened:add_trigger_condition(
	"ScriptEventIkitWorkshopPanelOpened",
	true
);

in_ikit_workshop_panel_opened:set_min_advice_level(ADVICE_LEVEL_HIGH);
in_ikit_workshop_panel_opened:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.ikit_workshop.003");
in_ikit_workshop_panel_opened:set_wait_for_fullscreen_panel_dismissed(false);
in_ikit_workshop_panel_opened:give_priority_to_intervention("in_ikit_workshop_button_clicked");


function trigger_in_ikit_workshop_panel_opened_advice()
	in_ikit_workshop_panel_opened:play_advice_for_intervention( 
		--  
		"wh2_dlc12.camp.advice.skv.ikit_workshop.003"
	);
end;


---------------------------------------------------------------
--
--	Forbidden Workshop  (Enough Warp Fuel to purchase upgrade)
--
---------------------------------------------------------------



-- intervention declaration
in_ikit_workshop_upgrade_ready = intervention:new(
	"in_ikit_workshop_upgrade_ready", 											-- string name
	60, 																		-- cost
	function() in_ikit_workshop_upgrade_ready_trigger() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);


in_ikit_workshop_upgrade_ready:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.ikit_workshop.004");
in_ikit_workshop_upgrade_ready:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);


in_ikit_workshop_upgrade_ready:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		for i = 0, context:faction():pooled_resource_manager():resources():num_items() - 1 do
			
			if context:faction():pooled_resource_manager():resources():item_at(i):key() == "skv_reactor_core" then
			
				if context:faction():pooled_resource_manager():resources():item_at(i):value() >= 2 then
					return true;
				end;
			end;
		end;
		return false;
		
	end
);


function in_ikit_workshop_upgrade_ready_trigger()
	in_ikit_workshop_upgrade_ready:play_advice_for_intervention(
		-- 	
		"wh2_dlc12.camp.advice.skv.ikit_workshop.004"
	);
end;




---------------------------------------------------------------
--
--	Forbidden Workshop  (After 2 Workshop purchases)
--
---------------------------------------------------------------


-- intervention declaration
in_ikit_workshop_completed_2_upgrades = intervention:new(
	"in_ikit_workshop_completed_2_upgrades",										-- string name
	20,	 																			-- cost
	function() trigger_in_ikit_workshop_completed_2_upgrades_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_ikit_workshop_completed_2_upgrades:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_ikit_workshop_completed_2_upgrades:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.ikit_workshop.005");


in_ikit_workshop_completed_2_upgrades:add_trigger_condition(
	"ScriptEventPlayer2WorkshopUpgrades",
	true
);

function trigger_in_ikit_workshop_completed_2_upgrades_advice()
	in_ikit_workshop_completed_2_upgrades:play_advice_for_intervention(
		-- 
		"wh2_dlc12.camp.advice.skv.ikit_workshop.005"
	);
end;





---------------------------------------------------------------
--
--	Forbidden Workshop  (After Ikits first battle victory)
--
---------------------------------------------------------------

-- intervention declaration
in_ikit_workshop_first_victory = intervention:new(
	"in_ikit_workshop_first_victory",					 					-- string name
	20,	 																-- cost
	function() trigger_in_ikit_workshop_first_victory_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_ikit_workshop_first_victory:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_ikit_workshop_first_victory:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.ikit_workshop.006");
in_ikit_workshop_first_victory:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_ikit_workshop_first_victory:add_trigger_condition(
	"ScriptEventHumanWinsBattle",
	function()
		return true;
	end
);

function trigger_in_ikit_workshop_first_victory_advice()
	in_ikit_workshop_first_victory:play_advice_for_intervention(	
		-- 
		"wh2_dlc12.camp.advice.skv.ikit_workshop.006"
	);
end;





---------------------------------------------------------------
--
--	Forbidden Workshop  (Enough Warp Fuel to build Doomsphere (Nuke))
--
---------------------------------------------------------------



-- intervention declaration
in_ikit_workshop_nuke_purchase_available = intervention:new(
	"in_ikit_workshop_nuke_purchase_available", 								-- string name
	60, 																		-- cost
	function() in_ikit_workshop_nuke_purchase_available_trigger() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);


in_ikit_workshop_nuke_purchase_available:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.ikit_workshop.007");
in_ikit_workshop_nuke_purchase_available:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);


in_ikit_workshop_nuke_purchase_available:add_trigger_condition(
	"ScriptEventPlayerNukeReadyToBuy",
	true
);


function in_ikit_workshop_nuke_purchase_available_trigger()
	in_ikit_workshop_nuke_purchase_available:play_advice_for_intervention(
		-- 	
		"wh2_dlc12.camp.advice.skv.ikit_workshop.007"
	);
end;



---------------------------------------------------------------
--
--	Forbidden Workshop  (After 5 Workshop purchases)
--
---------------------------------------------------------------

-- intervention declaration
in_ikit_workshop_completed_5_upgrades = intervention:new(
	"in_ikit_workshop_completed_5_upgrades",										-- string name
	20,	 																			-- cost
	function() trigger_in_ikit_workshop_completed_5_upgrades_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_ikit_workshop_completed_5_upgrades:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_ikit_workshop_completed_5_upgrades:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.ikit_workshop.008");
--in_ikit_workshop_completed_5_upgrades:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_ikit_workshop_completed_5_upgrades:add_trigger_condition(
	"ScriptEventPlayer5WorkshopUpgrades",
	true
);

function trigger_in_ikit_workshop_completed_5_upgrades_advice()
	in_ikit_workshop_completed_5_upgrades:play_advice_for_intervention(
		-- 
		"wh2_dlc12.camp.advice.skv.ikit_workshop.008"
	);
end;





---------------------------------------------------------------
--
--	Forbidden Workshop  (Workshop has upgraded)
--
---------------------------------------------------------------

-- intervention declaration
in_ikit_workshop_upgraded_workshop = intervention:new(
	"in_ikit_workshop_upgraded_workshop",										-- string name
	30,	 																			-- cost
	function() trigger_in_ikit_workshop_upgraded_workshop_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_ikit_workshop_upgraded_workshop:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_ikit_workshop_upgraded_workshop:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.ikit_workshop.009");
in_ikit_workshop_upgraded_workshop:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");
in_ikit_workshop_upgraded_workshop:give_priority_to_intervention("in_rites");


in_ikit_workshop_upgraded_workshop:add_trigger_condition(
	"ScriptEventPlayerWorkshopUpgraded",
	true
);

function trigger_in_ikit_workshop_upgraded_workshop_advice()
	in_ikit_workshop_upgraded_workshop:play_advice_for_intervention(
		-- 
		"wh2_dlc12.camp.advice.skv.ikit_workshop.009"
	);
end;



---------------------------------------------------------------
--
--	Forbidden Workshop  (Pre-battle with a Nuke available)
--
---------------------------------------------------------------


-- intervention declaration
in_ikit_workshop_prebattle_with_nuke = intervention:new(
	"in_ikit_workshop_prebattle_with_nuke", 															-- string name
	0, 																			-- cost
	function() in_ikit_workshop_prebattle_with_nuke_advice_trigger() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);


in_ikit_workshop_prebattle_with_nuke:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.ikit_workshop.010");
in_ikit_workshop_prebattle_with_nuke:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_ikit_workshop_prebattle_with_nuke:set_player_turn_only(false);
in_ikit_workshop_prebattle_with_nuke:set_wait_for_battle_complete(false);


in_ikit_workshop_prebattle_with_nuke:add_trigger_condition(
	"ScriptEventPreBattlePanelOpened",
	function(context)
		
		local faction_key = cm:get_local_faction_name();
		if faction_key then
			local faction = cm:get_faction(faction_key);
			
			local attacker = cm:pending_battle_cache_faction_is_attacker(faction_key);

			for i = 0, faction:pooled_resource_manager():resources():num_items() - 1 do
				
				if faction:pooled_resource_manager():resources():item_at(i):key() == "skv_nuke" then
				
					if faction:pooled_resource_manager():resources():item_at(i):value() >= 1 then
						return true;
					end;
				end;
			end;
		end
		return false;		
	end
);


function in_ikit_workshop_prebattle_with_nuke_advice_trigger()
	local listener_str = "in_ikit_workshop_prebattle_with_nuke";
	
	-- if the player closes panel immediately then just complete
	core:add_listener(
		listener_str,
		"PanelClosedCampaign",
		function(context) return context.string == "popup_pre_battle" end,
		function()
			cm:remove_callback(listener_str);
			in_ikit_workshop_prebattle_with_nuke:complete();
		end,
		false
	);
	
	cm:callback(
		function()
			core:remove_listener(listener_str);
			in_ikit_workshop_prebattle_with_nuke_advice_play();
		end,
		0.5,
		listener_str
	);
end;


function in_ikit_workshop_prebattle_with_nuke_advice_play()
	in_ikit_workshop_prebattle_with_nuke:play_advice_for_intervention(
		-- 
		"wh2_dlc12.camp.advice.skv.ikit_workshop.010"
	);
end;


---------------------------------------------------------------
--
--	Forbidden Workshop  (Having 10 Warp Fuel)
--
---------------------------------------------------------------

-- intervention declaration
in_ikit_workshop_10_warp_fuel = intervention:new(
	"in_ikit_workshop_10_warp_fuel", 											-- string name
	60, 																		-- cost
	function() in_ikit_workshop_10_warp_fuel_trigger() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);


in_ikit_workshop_10_warp_fuel:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.ikit_workshop.011");
in_ikit_workshop_10_warp_fuel:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);


in_ikit_workshop_10_warp_fuel:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		for i = 0, context:faction():pooled_resource_manager():resources():num_items() - 1 do
			
			if context:faction():pooled_resource_manager():resources():item_at(i):key() == "skv_reactor_core" then
			
				if context:faction():pooled_resource_manager():resources():item_at(i):value() >= 10 then
					return true;
				end;
			end;
		end;
		return false;
		
	end
);


function in_ikit_workshop_10_warp_fuel_trigger()
	in_ikit_workshop_10_warp_fuel:play_advice_for_intervention(
		-- 	
		"wh2_dlc12.camp.advice.skv.ikit_workshop.011"
	);
end;


---------------------------------------------------------------
--
--	Skaven Under-Empire  (Captures a settlement - post turn 5)
--
---------------------------------------------------------------

-- intervention declaration
in_under_empire_post_settlement_battle = intervention:new(
	"in_under_empire_post_settlement_battle", 										-- string name
	90, 																			-- cost
	function() in_under_empire_post_settlement_battle_advice_trigger() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);


in_under_empire_post_settlement_battle:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.under_empire.001");
in_under_empire_post_settlement_battle:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_under_empire_post_settlement_battle:set_player_turn_only(false);
in_under_empire_post_settlement_battle:set_wait_for_battle_complete(false);
in_under_empire_post_settlement_battle:give_priority_to_intervention("post_siege_battle_victory_options");
in_under_empire_post_settlement_battle:set_min_turn(5);

in_under_empire_post_settlement_battle:add_trigger_condition(
	"ScriptEventPlayerWinsSettlementBattle",
	function()
		-- only trigger if the pending battle is at a settlement that the player doesn't own
		local pb = cm:model():pending_battle();
		
		if pb:has_contested_garrison() and pb:contested_garrison():faction():name() ~= cm:get_local_faction_name() then
			return true;
		end;
		
		return false;
	end
);


function in_under_empire_post_settlement_battle_advice_trigger()	
	core:add_listener(
		"in_under_empire_post_settlement_battle",
		"PanelOpenedCampaign",
		function(context) return context.string == "settlement_captured" end,
		function() in_under_empire_post_settlement_battle_advice_play() end,
		false	
	);
end;


function in_under_empire_post_settlement_battle_advice_play()
	in_under_empire_post_settlement_battle:play_advice_for_intervention(
		-- 
		"wh2_dlc12.camp.advice.skv.under_empire.001"
	);
end;


---------------------------------------------------------------
--
--	Skaven Under-Empire  (Player establishes UE)
--
---------------------------------------------------------------


-- intervention declaration
in_under_empire_player_establishes = intervention:new(
	"in_under_empire_player_establishes",										-- string name
	30,	 																			-- cost
	function() trigger_in_under_empire_player_establishes_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_under_empire_player_establishes:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_under_empire_player_establishes:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.under_empire.002");
in_under_empire_player_establishes:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_under_empire_player_establishes:add_trigger_condition(
	"ScriptEventPlayerUnderEmpireEstablished",
	true
);

function trigger_in_under_empire_player_establishes_advice()
	in_under_empire_player_establishes:play_advice_for_intervention(
		-- 
		"wh2_dlc12.camp.advice.skv.under_empire.002"
	);
end;


---------------------------------------------------------------
--
--	Skaven Under-Empire  (Player constructs building in UE)
--
---------------------------------------------------------------


-- intervention declaration
in_under_empire_building_completed = intervention:new(
	"in_under_empire_building_completed",										-- string name
	0,	 																			-- cost
	function() trigger_in_under_empire_building_completed_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_under_empire_building_completed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_under_empire_building_completed:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.under_empire.003");
in_under_empire_building_completed:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_under_empire_building_completed:add_trigger_condition(
	"ScriptEventUnderEmpireDoomsphereStarted",
	function(context)			
		in_under_empire_building_completed.region = context:region():name();
		return true;
	end	
);

function trigger_in_under_empire_building_completed_advice()

	local region_name = in_under_empire_building_completed.region;
	
	-- 
	local advice_key = "wh2_dlc12.camp.advice.skv.under_empire.003";
	
	
	in_under_empire_building_completed:scroll_camera_to_settlement_for_intervention(
		region_name,
		advice_key
	);
	
end;


---------------------------------------------------------------
--
--	Skaven Under-Empire  (Players discoverability threshold crossed)
--
---------------------------------------------------------------


-- intervention declaration
in_under_empire_player_discovered = intervention:new(
	"in_under_empire_player_discovered",											-- string name
	0,	 																			-- cost
	function() trigger_in_under_empire_player_discovered_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_under_empire_player_discovered:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_under_empire_player_discovered:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.under_empire.004");
in_under_empire_player_discovered:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_under_empire_player_discovered:add_trigger_condition(
	"ScriptEventUnderEmpirePlayerDiscovered",
	function(context)			
		in_under_empire_player_discovered.region = context:region():name();
		return true;
	end	
);

function trigger_in_under_empire_player_discovered_advice()

	local region_name = in_under_empire_player_discovered.region;
	
	-- 
	local advice_key = "wh2_dlc12.camp.advice.skv.under_empire.004";
	
	
	in_under_empire_player_discovered:scroll_camera_to_settlement_for_intervention(
		region_name,
		advice_key
	);
	
end;

---------------------------------------------------------------
--
--	Skaven Under-Empire  (Player discovers UE under settlement)
--
---------------------------------------------------------------



-- intervention declaration
in_under_empire_ai_discovered = intervention:new(
	"in_under_empire_ai_discovered",											-- string name
	0,	 																			-- cost
	function() trigger_in_under_empire_ai_discovered_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_under_empire_ai_discovered:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_under_empire_ai_discovered:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.under_empire.005");
in_under_empire_ai_discovered:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_under_empire_ai_discovered:add_trigger_condition(
	"ScriptEventUnderEmpireAIDiscovered",
	function(context)			
		in_under_empire_ai_discovered.region = context:region():name();
		return true;
	end	
);

function trigger_in_under_empire_ai_discovered_advice()

	local region_name = in_under_empire_ai_discovered.region;
	
	-- 
	local advice_key = "wh2_dlc12.camp.advice.skv.under_empire.005";
	
	
	in_under_empire_ai_discovered:scroll_camera_to_settlement_for_intervention(
		region_name,
		advice_key
	);
	
end;



---------------------------------------------------------------
--
--	Skaven Under-Empire  (Player removes a UE from settlement)
--
---------------------------------------------------------------



-- intervention declaration
in_under_empire_player_removes = intervention:new(
	"in_under_empire_player_removes",											-- string name
	0,	 																		-- cost
	function() trigger_in_under_empire_player_removes_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_under_empire_player_removes:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_under_empire_player_removes:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.under_empire.006");
in_under_empire_player_removes:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_under_empire_player_removes:add_trigger_condition(
	"ScriptEventUnderEmpireRemovedByPlayer",
	function(context)			
		in_under_empire_player_removes.region = context:region():name();
		return true;
	end	
);

function trigger_in_under_empire_player_removes_advice()

	local region_name = in_under_empire_player_removes.region;
	
	-- 
	local advice_key = "wh2_dlc12.camp.advice.skv.under_empire.006";
	
	
	in_under_empire_player_removes:scroll_camera_to_settlement_for_intervention(
		region_name,
		advice_key
	);
	
end;


---------------------------------------------------------------
--
--	Skaven Under-Empire  (Start building Doomsphere in UE)
--
---------------------------------------------------------------

-- intervention declaration
in_under_empire_doomsphere_started = intervention:new(
	"in_under_empire_doomsphere_started",										-- string name
	0,	 																			-- cost
	function() trigger_in_under_empire_doomsphere_started_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_under_empire_doomsphere_started:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_under_empire_doomsphere_started:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.under_empire.007");
in_under_empire_doomsphere_started:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");
in_under_empire_doomsphere_started:give_priority_to_intervention("in_under_empire_building_completed");

in_under_empire_doomsphere_started:add_trigger_condition(
	"ScriptEventUnderEmpireDoomsphereStarted",
	function(context)			
		in_under_empire_doomsphere_started.region = context:region():name();
		return true;
	end	
);

function trigger_in_under_empire_doomsphere_started_advice()

	local region_name = in_under_empire_doomsphere_started.region;
	
	-- 
	local advice_key = "wh2_dlc12.camp.advice.skv.under_empire.007";
	
	in_under_empire_doomsphere_started:scroll_camera_to_settlement_for_intervention(
		region_name,
		advice_key
	);
	
end;

---------------------------------------------------------------
--
--	Skaven Under-Empire  (Doomsphere explodes settlement)
--
---------------------------------------------------------------


-- intervention declaration
in_under_empire_doomsphere_completed = intervention:new(
	"in_under_empire_doomsphere_completed",										-- string name
	0,	 																			-- cost
	function() trigger_in_under_empire_doomsphere_completed_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_under_empire_doomsphere_completed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_under_empire_doomsphere_completed:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.under_empire.008");
in_under_empire_doomsphere_completed:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_under_empire_doomsphere_completed:add_trigger_condition(
	"ScriptEventUnderEmpireDoomsphereCompleted",
	function(context)			
		in_under_empire_doomsphere_completed.region = context:region():name();
		return true;
	end	
);

function trigger_in_under_empire_doomsphere_completed_advice()

	local region_name = in_under_empire_doomsphere_completed.region;
	
	-- 
	local advice_key = "wh2_dlc12.camp.advice.skv.under_empire.008";
	
	in_under_empire_doomsphere_completed:scroll_camera_to_settlement_for_intervention(
		region_name,
		advice_key
	);
	
end;


---------------------------------------------------------------
--
--	Skaven Under-Empire  (Players War Camp completed)
--
---------------------------------------------------------------

-- intervention declaration
in_under_empire_player_war_camp_completed = intervention:new(
	"in_under_empire_player_war_camp_completed",										-- string name
	0,	 																			-- cost
	function() trigger_in_under_empire_player_war_camp_completed_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_under_empire_player_war_camp_completed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_under_empire_player_war_camp_completed:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.under_empire.010");
in_under_empire_player_war_camp_completed:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_under_empire_player_war_camp_completed:add_trigger_condition(
	"ScriptEventUnderEmpirePlayerWarCamp",
	function(context)			
		in_under_empire_player_war_camp_completed.region = context:region():name();
		return true;
	end	
);

function trigger_in_under_empire_player_war_camp_completed_advice()

	local region_name = in_under_empire_player_war_camp_completed.region;
	
	-- 
	local advice_key = "wh2_dlc12.camp.advice.skv.under_empire.010";
	
	in_under_empire_player_war_camp_completed:scroll_camera_to_settlement_for_intervention(
		region_name,
		advice_key
	);
	
end;


---------------------------------------------------------------
--
--	Skaven Under-Empire  (War Camp completed under player settlement)
--
---------------------------------------------------------------

-- intervention declaration
in_under_empire_ai_war_camp_completed = intervention:new(
	"in_under_empire_ai_war_camp_completed",										-- string name
	0,	 																			-- cost
	function() trigger_in_under_empire_ai_war_camp_completed_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_under_empire_ai_war_camp_completed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_under_empire_ai_war_camp_completed:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.under_empire.011");
in_under_empire_ai_war_camp_completed:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_under_empire_ai_war_camp_completed:add_trigger_condition(
	"ScriptEventUnderEmpireAIWarCamp",
	function(context)			
		in_under_empire_ai_war_camp_completed.region = context:region():name();
		return true;
	end	
);

function trigger_in_under_empire_ai_war_camp_completed_advice()

	local region_name = in_under_empire_ai_war_camp_completed.region;
	-- 
	local advice_key = "wh2_dlc12.camp.advice.skv.under_empire.011";

	in_under_empire_ai_war_camp_completed:scroll_camera_to_settlement_for_intervention(
		region_name,
		advice_key
	);
	
end;

---------------------------------------------------------------
--
--	Skaven Under-Empire  (Agent in region of players UE)
--
---------------------------------------------------------------



-- intervention declaration
in_under_empire_agent_in_region = intervention:new(
	"in_under_empire_agent_in_region",										-- string name
	0,	 																			-- cost
	function() trigger_in_under_empire_agent_in_region_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_under_empire_agent_in_region:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_under_empire_agent_in_region:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.under_empire.012");
in_under_empire_agent_in_region:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_under_empire_agent_in_region:add_trigger_condition(
	"ScriptEventUnderEmpireAgentInRegion",
	function(context)			
		in_under_empire_agent_in_region.char_cqi = context:character():cqi();
		return true;
	end	
);

function trigger_in_under_empire_agent_in_region_advice()

	local char_cqi = in_under_empire_agent_in_region.char_cqi;
	
	-- 
	local advice_key = "wh2_dlc12.camp.advice.skv.under_empire.012";
	
	if cm:get_character_by_cqi(char_cqi) then
		in_under_empire_agent_in_region:scroll_camera_to_character_for_intervention( 
		char_cqi, 
		advice_key
	);
	else
		in_under_empire_agent_in_region:play_advice_for_intervention(
			advice_key
		);
	end;
	
end;

---------------------------------------------------------------
--
--	Skaven Under-Empire  (Doomsphere explodes under player settlement)
--
---------------------------------------------------------------


-- intervention declaration
in_under_empire_ai_doomsphere_completed = intervention:new(
	"in_under_empire_ai_doomsphere_completed",										-- string name
	0,	 																			-- cost
	function() trigger_in_under_empire_ai_doomsphere_completed_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_under_empire_ai_doomsphere_completed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_under_empire_ai_doomsphere_completed:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.under_empire.013");
in_under_empire_ai_doomsphere_completed:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");


in_under_empire_ai_doomsphere_completed:add_trigger_condition(
	"ScriptEventUnderEmpireAIDoomsphereCompleted",
	function(context)			
		in_under_empire_ai_doomsphere_completed.region = context:region():name();
		cm:callback(function()
			core:trigger_event("ScriptEventUnderEmpireAIDoomsphereCompletedFollowUp",context);
			end, 0.5);
		return true;
	end	
);

function trigger_in_under_empire_ai_doomsphere_completed_advice()

	local region_name = in_under_empire_ai_doomsphere_completed.region;
	
	-- 
	local advice_key = "wh2_dlc12.camp.advice.skv.under_empire.003";
	
	in_under_empire_ai_doomsphere_completed:scroll_camera_to_settlement_for_intervention(
		region_name,
		advice_key
	);
	
end;

---------------------------------------------------------------
--
--	Skaven Under-Empire  (Doomsphere explodes under player settlement - follow up)
--
---------------------------------------------------------------


-- intervention declaration
in_under_empire_ai_doomsphere_completed_followup = intervention:new(
	"in_under_empire_ai_doomsphere_completed_followup",										-- string name
	0,	 																			-- cost
	function() trigger_in_under_empire_ai_doomsphere_completed_followup_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_under_empire_ai_doomsphere_completed_followup:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_under_empire_ai_doomsphere_completed_followup:add_advice_key_precondition("wh2_dlc12.camp.advice.skv.under_empire.014");
in_under_empire_ai_doomsphere_completed_followup:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_under_empire_ai_doomsphere_completed_followup:add_trigger_condition(
	"ScriptEventUnderEmpireAIDoomsphereCompletedFollowUp",
	function(context)			
		in_under_empire_ai_doomsphere_completed_followup.region = context:region():name();
		return true;
	end	
);

function trigger_in_under_empire_ai_doomsphere_completed_followup_advice()

	local region_name = in_under_empire_ai_doomsphere_completed_followup.region;
	
	-- 
	local advice_key = "wh2_dlc12.camp.advice.skv.under_empire.014";
	
	in_under_empire_ai_doomsphere_completed_followup:scroll_camera_to_settlement_for_intervention(
		region_name,
		advice_key
	);
	
end;


---------------------------------------------------------------
--
--	Empire racial advice
--
---------------------------------------------------------------

-- intervention declaration
in_empire_racial_advice = intervention:new(
	"in_empire_racial_advice", 													-- string name
	25, 																		-- cost
	function() trigger_in_empire_racial_advice() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_empire_racial_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_empire_racial_advice:add_precondition_unvisited_page("empire");
in_empire_racial_advice:add_advice_key_precondition("war.camp.prelude.emp.empire.001");
in_empire_racial_advice:set_min_turn(2);

in_empire_racial_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		return true;
	end
);

function trigger_in_empire_racial_advice()
	in_empire_racial_advice:play_advice_for_intervention(
		-- Your Empire is a beacon of civility in a savage world, my Emperor. It is your task - nay, your privilege, to see that it does not fall to the countless evils that threaten its borders. Study your own strengths, and that of your enemy, carefully.
		"war.camp.prelude.emp.empire.001", 
		{
			"war.camp.advice.empire.info_001",
			"war.camp.advice.empire.info_002",
			"war.camp.advice.empire.info_003"
		}
	)
end;


---------------------------------------------------------------
--
--	Elector Counts (First Time Opening Panel)
--
---------------------------------------------------------------

-- intervention declaration
in_elector_counts_open_panel = intervention:new(
	"in_elector_counts_open_panel",													-- string name
	20,	 																			-- cost
	function() trigger_in_elector_counts_open_panel_advice() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_elector_counts_open_panel:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_elector_counts_open_panel:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.elector_counts.001");
in_elector_counts_open_panel:set_wait_for_fullscreen_panel_dismissed(false);


in_elector_counts_open_panel:add_trigger_condition(
	"ScriptEventElectorCountButtonClicked",
	true
);

function trigger_in_elector_counts_open_panel_advice()
	in_elector_counts_open_panel:play_advice_for_intervention(
		-- The Elector Counts of the mighty Empire! Each may have their own agenda, but perhaps you can convince them to unite as one. 
		"wh2_dlc13.camp.advice.emp.elector_counts.001",
		{
			"wh2.camp.advice.empire_summon_elector_counts.info_001",
			"wh2.camp.advice.empire_summon_elector_counts.info_002",
			"wh2.camp.advice.empire_summon_elector_counts.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Elector Counts (First Time Occupying a Capital)
--
---------------------------------------------------------------

-- intervention declaration
in_elector_counts_occupy_capital = intervention:new(
	"in_elector_counts_occupy_capital",													-- string name
	20,	 																				-- cost
	function() trigger_in_elector_counts_occupy_capital_advice() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_elector_counts_occupy_capital:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_elector_counts_occupy_capital:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.elector_counts.002");


in_elector_counts_occupy_capital:add_trigger_condition(
	"ScriptEventElectorCapitalTaken",
	true
);

function trigger_in_elector_counts_occupy_capital_advice()
	in_elector_counts_occupy_capital:play_advice_for_intervention(
		-- A state capital falls under your control, my lord. This would be a good time to appoint a new Count to benefit from this region's resources.
		"wh2_dlc13.camp.advice.emp.elector_counts.002"
	);
end;

---------------------------------------------------------------
--
--	Elector Counts (First Time Appointing Elector Count Position)
--
---------------------------------------------------------------

-- intervention declaration
in_elector_counts_appoint_elector = intervention:new(
	"in_elector_counts_appoint_elector",												-- string name
	20,	 																				-- cost
	function() trigger_in_elector_counts_appoint_elector_advice() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_elector_counts_appoint_elector:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_elector_counts_appoint_elector:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.elector_counts.003");
in_elector_counts_appoint_elector:set_wait_for_fullscreen_panel_dismissed(false);


in_elector_counts_appoint_elector:add_trigger_condition(
	"ScriptEventElectorAppointed",
	true
);

function trigger_in_elector_counts_appoint_elector_advice()
	in_elector_counts_appoint_elector:play_advice_for_intervention(
		-- A fine choice indeed - gods-willing, this state will now be governed well.
		"wh2_dlc13.camp.advice.emp.elector_counts.003"
	);
end;

---------------------------------------------------------------
--
--	Imperial Authority (Low Negative Authority)
--
---------------------------------------------------------------

-- intervention declaration
in_imperial_authority_low_negative_authority = intervention:new(
	"in_imperial_authority_low_negative_authority",											-- string name
	20,	 																					-- cost
	function() trigger_in_imperial_authority_low_negative_authority_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);

in_imperial_authority_low_negative_authority:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_imperial_authority_low_negative_authority:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.imperial_authority.002");


in_imperial_authority_low_negative_authority:add_trigger_condition(
	"PooledResourceEffectChangedEvent",
	function(context)
		local faction = context:faction();
		local resource = context:resource();
		if resource:key() == "emp_imperial_authority" and faction:name() == cm:get_local_faction_name() then
			if resource:value() <= -2 then
				return true;
			end
		end;
		return false;
	end
);

function trigger_in_imperial_authority_low_negative_authority_advice()
	in_imperial_authority_low_negative_authority:play_advice_for_intervention(
		-- Your Imperial Authority has lessened my Lord. Your lesser lords are growing more weary of your inability to command respect within the Empire. You must be more careful when dealing with Imperial matters.
		"wh2_dlc13.camp.advice.emp.imperial_authority.002"
	);
end;

---------------------------------------------------------------
--
--	Imperial Authority (High Negative Authority)
--
---------------------------------------------------------------

-- intervention declaration
in_imperial_authority_high_negative_authority = intervention:new(
	"in_imperial_authority_high_negative_authority",										-- string name
	20,	 																					-- cost
	function() trigger_in_imperial_authority_high_negative_authority_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 															-- show debug output
);

in_imperial_authority_high_negative_authority:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_imperial_authority_high_negative_authority:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.imperial_authority.003");
in_imperial_authority_high_negative_authority:give_priority_to_intervention("in_imperial_authority_low_negative_authority");


in_imperial_authority_high_negative_authority:add_trigger_condition(
	"PooledResourceEffectChangedEvent",
	function(context)
		local faction = context:faction();
		local resource = context:resource();
		if resource:key() == "emp_imperial_authority" and faction:name() == cm:get_local_faction_name() then
			return resource:value() <= -10;
		end;
		return false;
	end
);

function trigger_in_imperial_authority_high_negative_authority_advice()
	in_imperial_authority_high_negative_authority:play_advice_for_intervention(
		-- Civil War! The Electors have banded together to drive you out of the Empire. There is no turning back now; politics must be replaced by blood and steel.
		"wh2_dlc13.camp.advice.emp.imperial_authority.003"
	);
end;

---------------------------------------------------------------
--
--	Imperial Authority (Civil War)
--
---------------------------------------------------------------

-- intervention declaration
in_imperial_authority_civil_war = intervention:new(
	"in_imperial_authority_civil_war",													-- string name
	20,	 																				-- cost
	function() trigger_in_imperial_authority_civil_war_advice() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_imperial_authority_civil_war:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_imperial_authority_civil_war:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.imperial_authority.004");
in_imperial_authority_civil_war:set_wait_for_dilemma(false);


in_imperial_authority_civil_war:add_trigger_condition(
	"DilemmaIssuedEvent",
	function(context)
		local faction = context:faction();
		local dilemma = context:dilemma();
		return dilemma == "wh2_dlc13_emp_elector_civil_war" and faction:name() == cm:get_local_faction_name();
	end
);

function trigger_in_imperial_authority_civil_war_advice()
	in_imperial_authority_civil_war:play_advice_for_intervention(
		-- Two Electors have decided that their disagreement can only be concluded with war. You can use political pressure to stop this squabble, or perhaps choose a side.
		"wh2_dlc13.camp.advice.emp.imperial_authority.004"
	);
end;

---------------------------------------------------------------
--
--	Imperial Authority (Political Event)
--
---------------------------------------------------------------

-- intervention declaration
in_imperial_authority_political_event = intervention:new(
	"in_imperial_authority_political_event",											-- string name
	20,	 																				-- cost
	function() trigger_in_imperial_authority_political_event_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_imperial_authority_political_event:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_imperial_authority_political_event:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.imperial_authority.005");
in_imperial_authority_political_event:set_wait_for_dilemma(false);


in_imperial_authority_political_event:add_trigger_condition(
	"DilemmaIssuedEvent",
	function(context)
		local faction = context:faction();
		local dilemma = context:dilemma();
		return dilemma:find("wh2_dlc13_emp_elector_politics_") and faction:name() == cm:get_local_faction_name();
	end
);

function trigger_in_imperial_authority_political_event_advice()
	in_imperial_authority_political_event:play_advice_for_intervention(
		-- The internal politics of the Empire are never easy my lord, but this is an opportunity to show other Electors your might.
		"wh2_dlc13.camp.advice.emp.imperial_authority.005"
	);
end;

---------------------------------------------------------------
--
--	Imperial Authority (Invasion Event)
--
---------------------------------------------------------------

-- intervention declaration
in_imperial_authority_invasion_event = intervention:new(
	"in_imperial_authority_invasion_event",												-- string name
	20,	 																				-- cost
	function() trigger_in_imperial_authority_invasion_event_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_imperial_authority_invasion_event:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_imperial_authority_invasion_event:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.imperial_authority.006");
in_imperial_authority_invasion_event:set_wait_for_dilemma(false);


in_imperial_authority_invasion_event:add_trigger_condition(
	"DilemmaIssuedEvent",
	function(context)
		local faction = context:faction();
		local dilemma = context:dilemma();
		return dilemma:find("wh2_dlc13_emp_elector_invasion_") and faction:name() == cm:get_local_faction_name();
	end
);

function trigger_in_imperial_authority_invasion_event_advice()
	in_imperial_authority_invasion_event:play_advice_for_intervention(
		-- Enemies have forever been on the doorstep of the Empire, my lord. An Elector requires aid and would surely be thankful for it, but it may be costly to render assistance at this time.
		"wh2_dlc13.camp.advice.emp.imperial_authority.006"
	);
end;

---------------------------------------------------------------
--
--	Imperial Authority (Confederation Event)
--
---------------------------------------------------------------

-- intervention declaration
in_imperial_authority_confederation_event = intervention:new(
	"in_imperial_authority_confederation_event",										-- string name
	20,	 																				-- cost
	function() trigger_in_imperial_authority_confederation_event_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_imperial_authority_confederation_event:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_imperial_authority_confederation_event:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.imperial_authority.007");
in_imperial_authority_confederation_event:set_wait_for_dilemma(false);


in_imperial_authority_confederation_event:add_trigger_condition(
	"DilemmaIssuedEvent",
	function(context)
		local faction = context:faction();
		local dilemma = context:dilemma();
		return dilemma:find("wh2_dlc13_emp_elector_confederate_") and faction:name() == cm:get_local_faction_name();
	end
);

function trigger_in_imperial_authority_confederation_event_advice()
	in_imperial_authority_confederation_event:play_advice_for_intervention(
		-- Not all Electors are always self-serving - some act with the best interests of their subjects at heart. A count has come to you with an offer of confederation for mutual benefit. Be wary that this will require quite some Imperial Authority to achieve.
		"wh2_dlc13.camp.advice.emp.imperial_authority.007"
	);
end;

---------------------------------------------------------------
--
--	Imperial Authority (Declare War on Elector)
--
---------------------------------------------------------------

-- intervention declaration
in_imperial_authority_declare_war_on_elector = intervention:new(
	"in_imperial_authority_declare_war_on_elector",										-- string name
	20,	 																				-- cost
	function() trigger_in_imperial_authority_declare_war_on_elector_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_imperial_authority_declare_war_on_elector:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_imperial_authority_declare_war_on_elector:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.imperial_authority.008");


in_imperial_authority_declare_war_on_elector:add_trigger_condition(
	"ScriptEventImperialAuthorityWarDeclaredOnElector",
	true
);

function trigger_in_imperial_authority_declare_war_on_elector_advice()
	in_imperial_authority_declare_war_on_elector:play_advice_for_intervention(
		-- War between those within the Empire does not serve any benefit. Other Electors now look upon you with disquieted gazes.
		"wh2_dlc13.camp.advice.emp.imperial_authority.008"
	);
end;

---------------------------------------------------------------
--
--	Imperial Authority (Elector Count is Killed)
--
---------------------------------------------------------------

-- intervention declaration
in_imperial_authority_elector_killed = intervention:new(
	"in_imperial_authority_elector_killed",												-- string name
	20,	 																				-- cost
	function() trigger_in_imperial_authority_elector_killed_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_imperial_authority_elector_killed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_imperial_authority_elector_killed:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.imperial_authority.009");

in_imperial_authority_elector_killed:add_trigger_condition(
	"ScriptEventImperialAuthorityElectorKilled",
	true
);

function trigger_in_imperial_authority_elector_killed_advice()
	in_imperial_authority_elector_killed:play_advice_for_intervention(
		-- A piece of the Empire falls this day. Others have looked to you to protect the Empire's borders but they now begin to lose trust.
		"wh2_dlc13.camp.advice.emp.imperial_authority.009"
	);
end;

---------------------------------------------------------------
--
--	Prestige (Prestige Gained)
--
---------------------------------------------------------------

-- intervention declaration
in_prestige_gained = intervention:new(
	"in_prestige_gained",														-- string name
	20,	 																		-- cost
	function() trigger_in_prestige_gained_advice() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_prestige_gained:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_prestige_gained:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.prestige.001");

in_prestige_gained:add_trigger_condition(
	"ScriptEventPrestigeGained",
	function(context)
		return context:faction():name() == cm:get_local_faction_name();
	end
);

function trigger_in_prestige_gained_advice()
	in_prestige_gained:play_advice_for_intervention(
		-- A prestigious act indeed. All those who lead within the Empire must be willing to fight.
		"wh2_dlc13.camp.advice.emp.prestige.001",
		{
			"wh2.camp.advice.empire_imperial_authority.info_001",
			"wh2.camp.advice.empire_imperial_authority.info_002",
			"wh2.camp.advice.empire_imperial_authority.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Gotrek and Felix (Pub Built Event)
--
---------------------------------------------------------------

-- intervention declaration
in_gotrek_and_felix_pub_built = intervention:new(
	"in_gotrek_and_felix_pub_built",											-- string name
	20,	 																		-- cost
	function() trigger_in_gotrek_and_felix_pub_built_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_gotrek_and_felix_pub_built:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_gotrek_and_felix_pub_built:add_advice_key_precondition("wh2_pro08.camp.advice.neu.felix_gotrek.001");

in_gotrek_and_felix_pub_built:add_trigger_condition(
	"ScriptEventGotrekAndFelixPubBuilt",
	true
);

function trigger_in_gotrek_and_felix_pub_built_advice()
	in_gotrek_and_felix_pub_built:play_advice_for_intervention(
		-- Perhaps you know the intrepid adventurers well; a drinking establishment will not go unnoticed by them.
		"wh2_pro08.camp.advice.neu.felix_gotrek.001",
		{
			"wh2.camp.advice.gotrek_and_felix.info_001",
			"wh2.camp.advice.gotrek_and_felix.info_002",
			"wh2.camp.advice.gotrek_and_felix.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Gotrek and Felix (Dilemma Event)
--
---------------------------------------------------------------

-- intervention declaration
in_gotrek_and_felix_dilemma_event = intervention:new(
	"in_gotrek_and_felix_dilemma_event",											-- string name
	20,	 																		-- cost
	function() trigger_in_gotrek_and_felix_dilemma_event_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_gotrek_and_felix_dilemma_event:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_gotrek_and_felix_dilemma_event:add_advice_key_precondition("wh2_pro08.camp.advice.neu.felix_gotrek.002");
in_gotrek_and_felix_dilemma_event:set_wait_for_dilemma(false);

in_gotrek_and_felix_dilemma_event:add_trigger_condition(
	"DilemmaIssuedEvent",
	function(context)
		local faction = context:faction();
		local dilemma = context:dilemma();
		return dilemma == "wh2_pro08_dilemma_gotrek_felix" and faction:name() == cm:get_local_faction_name();
	end
);

function trigger_in_gotrek_and_felix_dilemma_event_advice()
	in_gotrek_and_felix_dilemma_event:play_advice_for_intervention(
		-- Now is your chance, my lord. Have the great adventurers join you and witness their legendary might for yourself.
		"wh2_pro08.camp.advice.neu.felix_gotrek.002"
	);
end;

---------------------------------------------------------------
--
--	Gotrek and Felix (First Time the Duo Depart)
--
---------------------------------------------------------------

-- intervention declaration
in_gotrek_and_felix_departed = intervention:new(
	"in_gotrek_and_felix_departed",												-- string name
	20,	 																		-- cost
	function() trigger_in_gotrek_and_felix_departed_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_gotrek_and_felix_departed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_gotrek_and_felix_departed:add_advice_key_precondition("wh2_pro08.camp.advice.neu.felix_gotrek.003");

in_gotrek_and_felix_departed:add_trigger_condition(
	"ScriptEventGotrekAndFelixDepart",
	true
);

function trigger_in_gotrek_and_felix_departed_advice()
	in_gotrek_and_felix_departed:play_advice_for_intervention(
		-- The adventurers would not be kept by your side forever, my lord, as there is always a bigger tale that needs to be told. Fear not, for they will return.
		"wh2_pro08.camp.advice.neu.felix_gotrek.003"
	);
end;

---------------------------------------------------------------
--
--	Emperor's Mandate (Reaches 5 Mandate)
--
---------------------------------------------------------------

-- intervention declaration
in_mandate_gained = intervention:new(
	"in_mandate_gained",													-- string name
	20,	 																	-- cost
	function() trigger_in_mandate_gained_advice() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_mandate_gained:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_mandate_gained:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.emperors_mandate.001");

in_mandate_gained:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local faction = context:faction();
		local resource = faction:pooled_resource_manager():resource("emp_progress");
		return resource:value() >= 5 and faction:name() == cm:get_local_faction_name();
	end
);

function trigger_in_mandate_gained_advice()
	in_mandate_gained:play_advice_for_intervention(
		-- You have made valuable progress, my lord. The Emperor will look upon the expedition favourably and reward you with greater supplies in due course.
		"wh2_dlc13.camp.advice.emp.emperors_mandate.001",
		{
			"wh2.camp.advice.empire_emperors_mandate.info_001",
			"wh2.camp.advice.empire_emperors_mandate.info_002",
			"wh2.camp.advice.empire_emperors_mandate.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Emperor's Mandate (Reach Level 2)
--
---------------------------------------------------------------

-- intervention declaration
in_mandate_level_2 = intervention:new(
	"in_mandate_level_2",													-- string name
	20,	 																	-- cost
	function() trigger_in_mandate_level_2_advice() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_mandate_level_2:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_mandate_level_2:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.emperors_mandate.002");
in_mandate_level_2:give_priority_to_intervention("in_mandate_gained");

in_mandate_level_2:add_trigger_condition(
	"PooledResourceEffectChangedEvent",
	function(context)
		local faction = context:faction();
		local resource = context:resource();
		if resource:key() == "emp_progress" and faction:name() == cm:get_local_faction_name() then
			return resource:value() >= 20;
		end;
		return false;
	end
);

function trigger_in_mandate_level_2_advice()
	in_mandate_level_2:play_advice_for_intervention(
		-- The Empire's grip gains yet more strength; expect greater reinforcements from home. For the Emperor!
		"wh2_dlc13.camp.advice.emp.emperors_mandate.002"
	);
end;

---------------------------------------------------------------
--
--	Emperor's Mandate (Reach Level 3)
--
---------------------------------------------------------------

-- intervention declaration
in_mandate_level_3 = intervention:new(
	"in_mandate_level_3",													-- string name
	20,	 																	-- cost
	function() trigger_in_mandate_level_3_advice() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_mandate_level_3:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_mandate_level_3:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.emperors_mandate.003");
in_mandate_level_3:give_priority_to_intervention("in_mandate_level_2");

in_mandate_level_3:add_trigger_condition(
	"PooledResourceEffectChangedEvent",
	function(context)
		local faction = context:faction();
		local resource = context:resource();
		if resource:key() == "emp_progress" and faction:name() == cm:get_local_faction_name() then
			return resource:value() >= 40;
		end;
		return false;
	end
);

function trigger_in_mandate_level_3_advice()
	in_mandate_level_3:play_advice_for_intervention(
		-- Emperor Karl Franz sends word of his high praise for you and the expedition. See to it that your progress doesn't falter and the Empire continues to rule supreme.
		"wh2_dlc13.camp.advice.emp.emperors_mandate.003"
	);
end;

---------------------------------------------------------------
--
--	Emperor's Mandate (First Time Losing Settlement)
--
---------------------------------------------------------------

-- intervention declaration
in_mandate_losing_settlement = intervention:new(
	"in_mandate_losing_settlement",											-- string name
	20,	 																	-- cost
	function() trigger_in_mandate_losing_settlement_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_mandate_losing_settlement:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_mandate_losing_settlement:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.emperors_mandate.004");

in_mandate_losing_settlement:add_trigger_condition(
	"ScriptEventMandateLostSettlement",
	true
);

function trigger_in_mandate_losing_settlement_advice()
	in_mandate_losing_settlement:play_advice_for_intervention(
		-- This is contrary to the Emperor's wishes. Ensure that no other settlements are lost, for reinforcements will not be forthcoming.
		"wh2_dlc13.camp.advice.emp.emperors_mandate.004"
	);
end;

---------------------------------------------------------------
--
--	Emperor's Mandate (First Supplies Dilemma)
--
---------------------------------------------------------------

-- intervention declaration
in_mandate_supplies_dilemma = intervention:new(
	"in_mandate_supplies_dilemma",											-- string name
	0,	 																	-- cost
	function() trigger_in_mandate_supplies_dilemma_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_mandate_supplies_dilemma:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_mandate_supplies_dilemma:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.emperors_mandate.005");
in_mandate_supplies_dilemma:set_wait_for_dilemma(false);

in_mandate_supplies_dilemma:add_trigger_condition(
	"DilemmaIssuedEvent",
	function(context)
		local faction = context:faction();
		local dilemma = context:dilemma();
		return dilemma:find("wh2_dlc13_wulfhart_imperial_guards") and faction:name() == cm:get_local_faction_name();
	end
);

function trigger_in_mandate_supplies_dilemma_advice()
	in_mandate_supplies_dilemma:play_advice_for_intervention(
		-- Your endeavours have received great acclaim. You now have a wide array of reinforcing troops and ordnance to choose from.
		"wh2_dlc13.camp.advice.emp.emperors_mandate.005"
	);
end;

---------------------------------------------------------------
--
--	Hostility (First Time Hostility Gained)
--
---------------------------------------------------------------

-- intervention declaration
in_hostility_gained = intervention:new(
	"in_hostility_gained",											-- string name
	0,	 															-- cost
	function() trigger_in_hostility_gained_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_hostility_gained:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hostility_gained:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.hostility.001");

in_hostility_gained:add_trigger_condition(
	"PooledResourceEffectChangedEvent",
	function(context)
		local faction = context:faction();
		local resource = context:resource();
		return resource:key() == "emp_wanted" and faction:name() == cm:get_local_faction_name();
	end
);

function trigger_in_hostility_gained_advice()
	in_hostility_gained:play_advice_for_intervention(
		-- Your actions have not gone unnoticed, my lord. The local inhabitants watch your every move.
		"wh2_dlc13.camp.advice.emp.hostility.001",
		{
			"wh2.camp.advice.empire_hostility.info_001",
			"wh2.camp.advice.empire_hostility.info_002",
			"wh2.camp.advice.empire_hostility.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Hostility (Level 1)
--
---------------------------------------------------------------

-- intervention declaration
in_hostility_level_1 = intervention:new(
	"in_hostility_level_1",											-- string name
	20,	 															-- cost
	function() trigger_in_hostility_level_1_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_hostility_level_1:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hostility_level_1:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.hostility.002");
in_hostility_level_1:give_priority_to_intervention("in_hostility_gained");

in_hostility_level_1:add_trigger_condition(
	"PooledResourceEffectChangedEvent",
	function(context)
		local faction = context:faction();
		local resource = context:resource();
		if resource:key() == "emp_wanted" and faction:name() == cm:get_local_faction_name() then
			return resource:value() >= 10;
		end;
		return false;
	end
);

function trigger_in_hostility_level_1_advice()
	in_hostility_level_1:play_advice_for_intervention(
		-- Your recent triumphs will give you faster supplies in due course, my lord. But the Lizardmen grow increasingly restless and hostile towards you.
		"wh2_dlc13.camp.advice.emp.hostility.002"
	);
end;

---------------------------------------------------------------
--
--	Hostility (Level 3)
--
---------------------------------------------------------------

-- intervention declaration
in_hostility_level_3 = intervention:new(
	"in_hostility_level_3",											-- string name
	20,	 															-- cost
	function() trigger_in_hostility_level_3_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_hostility_level_3:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hostility_level_3:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.hostility.003");
in_hostility_level_3:give_priority_to_intervention("in_hostility_level_1");

in_hostility_level_3:add_trigger_condition(
	"PooledResourceEffectChangedEvent",
	function(context)
		local faction = context:faction();
		local resource = context:resource();
		if resource:key() == "emp_wanted" and faction:name() == cm:get_local_faction_name() then
			return resource:value() >= 30;
		end;
		return false;
	end
);

function trigger_in_hostility_level_3_advice()
	in_hostility_level_3:play_advice_for_intervention(
		-- My lord, these lands grow ever more hostile towards you. Tread carefully or risk the wrath of the Lizardmen.
		"wh2_dlc13.camp.advice.emp.hostility.003"
	);
end;

---------------------------------------------------------------
--
--	Hostility (Level 5)
--
---------------------------------------------------------------

-- intervention declaration
in_hostility_level_5 = intervention:new(
	"in_hostility_level_5",											-- string name
	20,	 															-- cost
	function() trigger_in_hostility_level_5_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_hostility_level_5:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hostility_level_5:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.hostility.004");
in_hostility_level_5:give_priority_to_intervention("in_hostility_level_3");

in_hostility_level_5:add_trigger_condition(
	"PooledResourceEffectChangedEvent",
	function(context)
		local faction = context:faction();
		local resource = context:resource();
		if resource:key() == "emp_wanted" and faction:name() == cm:get_local_faction_name() then
			return resource:value() >= 50;
		end;
		return false;
	end
);

function trigger_in_hostility_level_5_advice()
	in_hostility_level_5:play_advice_for_intervention(
		-- You've kicked the hornets nest and released untold horrors, my lord. Make ready for war, the expedition will surely now come under attack.
		"wh2_dlc13.camp.advice.emp.hostility.004"
	);
end;

---------------------------------------------------------------
--
--	Hostility (Defeat Spawned Army)
--
---------------------------------------------------------------

-- intervention declaration
in_hostility_defeat_spawned_army = intervention:new(
	"in_hostility_defeat_spawned_army",											-- string name
	20,	 																		-- cost
	function() trigger_in_hostility_defeat_spawned_army_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_hostility_defeat_spawned_army:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hostility_defeat_spawned_army:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.hostility.005");

in_hostility_defeat_spawned_army:add_trigger_condition(
	"CharacterConvalescedOrKilled",
	function(context)
		local faction = context:character():faction();
		return faction:name() == "wh2_dlc13_lzd_avengers" and faction:is_dead() == true;
	end
);

function trigger_in_hostility_defeat_spawned_army_advice()
	in_hostility_defeat_spawned_army:play_advice_for_intervention(
		-- These so-called guardians are no more. Make use of this time before they regroup and hostility rises again.
		"wh2_dlc13.camp.advice.emp.hostility.005"
	);
end;
---------------------------------------------------------------
--
--	Hostility (Hostility Resource Degrades)
--
---------------------------------------------------------------

-- intervention declaration
in_hostility_resource_degrades = intervention:new(
	"in_hostility_resource_degrades",											-- string name
	20,	 																		-- cost
	function() trigger_in_hostility_resource_degrades_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_hostility_resource_degrades:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hostility_resource_degrades:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.hostility.006");

in_hostility_resource_degrades:add_trigger_condition(
	"ScriptEventHostilityDecreased",
	true
);

function trigger_in_hostility_resource_degrades_advice()
	in_hostility_resource_degrades:play_advice_for_intervention(
		-- The inhabitants of these lands worry little due to your recent inaction. Their hostility towards you has decreased.
		"wh2_dlc13.camp.advice.emp.hostility.006"
	);
end;

---------------------------------------------------------------
--
--	Hostility (Hostility Level Degrades)
--
---------------------------------------------------------------

-- intervention declaration
in_hostility_level_degrades = intervention:new(
	"in_hostility_level_degrades",												-- string name
	20,	 																		-- cost
	function() trigger_in_hostility_level_degrades_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_hostility_level_degrades:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hostility_level_degrades:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.hostility.007");
in_hostility_level_degrades:give_priority_to_intervention("in_hostility_resource_degrades");

in_hostility_level_degrades:add_trigger_condition(
	"PooledResourceEffectChangedEvent",
	function(context)
		local faction = context:faction();
		local resource = context:resource();
		if resource:key() == "emp_wanted" and faction:name() == cm:get_local_faction_name() then
			local old_effect = context:old_effect();
			if old_effect ~= "" then
				local old_level = string.sub(old_effect, string.len(old_effect));
				if tonumber(old_level) > 1 then
					local new_effect = context:new_effect();
					local new_level = 0;
					
					if new_effect ~= "" then
						new_level = string.sub(new_effect, string.len(new_effect));
					end;
					
					return tonumber(old_level) > tonumber(new_level);
				end
			end;
		end;
		return false;
	end
);

function trigger_in_hostility_level_degrades_advice()
	in_hostility_level_degrades:play_advice_for_intervention(
		-- Your recent inaction has lowered the Lizardmen's hostility towards you. Should you continue to sit idle, however, the Emperor will send supplies less frequently.
		"wh2_dlc13.camp.advice.emp.hostility.007"
	);
end;

---------------------------------------------------------------
--
--	Wulfharts Hunters (First Time Opening Panel)
--
---------------------------------------------------------------

-- intervention declaration
in_hunters_open_panel = intervention:new(
	"in_hunters_open_panel",														-- string name
	20,	 																			-- cost
	function() trigger_in_hunters_open_panel_advice() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_hunters_open_panel:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hunters_open_panel:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.wulfharts_hunters.001");
in_hunters_open_panel:set_wait_for_fullscreen_panel_dismissed(false);


in_hunters_open_panel:add_trigger_condition(
	"ScriptEventWulfhartsHuntersButtonClicked",
	true
);

function trigger_in_hunters_open_panel_advice()
	in_hunters_open_panel:play_advice_for_intervention(
		-- There are rumours of fine hunters, trackers and scouts in the New World. Should you convince them to join the expedition, their skills could be quite invaluable.
		"wh2_dlc13.camp.advice.emp.wulfharts_hunters.001",
		{
			"wh2.camp.advice.empire_wulfharts_hunters.info_001",
			"wh2.camp.advice.empire_wulfharts_hunters.info_002",
			"wh2.camp.advice.empire_wulfharts_hunters.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Wulfharts Hunters (First Hunter Unlocked)
--
---------------------------------------------------------------

-- intervention declaration
in_hunters_first_hunter_unlocked = intervention:new(
	"in_hunters_first_hunter_unlocked",												-- string name
	20,	 																			-- cost
	function() trigger_in_hunters_first_hunter_unlocked_advice() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_hunters_first_hunter_unlocked:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hunters_first_hunter_unlocked:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.wulfharts_hunters.002");

in_hunters_first_hunter_unlocked:add_trigger_condition(
	"HunterUnlocked",
	true
);

function trigger_in_hunters_first_hunter_unlocked_advice()
	in_hunters_first_hunter_unlocked:play_advice_for_intervention(
		-- Quite the acquisition, my lord. Their unique skills will certainly bolster the expedition.
		"wh2_dlc13.camp.advice.emp.wulfharts_hunters.002"
	);
end;

---------------------------------------------------------------
--
--	Wulfharts Hunters (First Hunter Story Completed)
--
---------------------------------------------------------------

-- intervention declaration
in_hunters_first_hunter_story_complete = intervention:new(
	"in_hunters_first_hunter_story_complete",										-- string name
	20,	 																			-- cost
	function() trigger_in_hunters_first_hunter_story_complete_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_hunters_first_hunter_story_complete:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hunters_first_hunter_story_complete:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.wulfharts_hunters.003");

in_hunters_first_hunter_story_complete:add_trigger_condition(
	"ScriptEventHunterStoryCompleted",
	true
);

function trigger_in_hunters_first_hunter_story_complete_advice()
	in_hunters_first_hunter_story_complete:play_advice_for_intervention(
		-- Having completed their journey in the company of the expedition, this hunter will be ready for anything now.
		"wh2_dlc13.camp.advice.emp.wulfharts_hunters.003"
	);
end;
---------------------------------------------------------------
--
--	Wulfharts Hunters (All Hunters Unlocked)
--
---------------------------------------------------------------

-- intervention declaration
in_hunters_all_hunters_unlocked = intervention:new(
	"in_hunters_all_hunters_unlocked",												-- string name
	20,	 																			-- cost
	function() trigger_in_hunters_all_hunters_unlocked_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_hunters_all_hunters_unlocked:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hunters_all_hunters_unlocked:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.wulfharts_hunters.004");

in_hunters_all_hunters_unlocked:add_trigger_condition(
	"HunterUnlocked",
	function()
		return cm:get_saved_value("hunter_kalara_unlocked") and cm:get_saved_value("hunter_jorek_unlocked") and cm:get_saved_value("hunter_hertwig_unlocked") and cm:get_saved_value("hunter_rodrik_unlocked");
	end
);

function trigger_in_hunters_all_hunters_unlocked_advice()
	in_hunters_all_hunters_unlocked:play_advice_for_intervention(
		-- With the acquisition of the master hunters, you have built up quite the formidable fighting force. Wulfhart's Hunters are truly the elite!
		"wh2_dlc13.camp.advice.emp.wulfharts_hunters.004"
	);
end;

---------------------------------------------------------------
--
--	Wulfharts Hunters (All Hunter Stories Completed)
--
---------------------------------------------------------------

-- intervention declaration
in_hunters_all_hunters_stories_completed = intervention:new(
	"in_hunters_all_hunters_stories_completed",										-- string name
	20,	 																			-- cost
	function() trigger_in_hunters_all_hunters_stories_completed_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_hunters_all_hunters_stories_completed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_hunters_all_hunters_stories_completed:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.wulfharts_hunters.005");

in_hunters_all_hunters_stories_completed:add_trigger_condition(
	"ScriptEventHunterStoryCompleted",
	function()
		return cm:get_saved_value("hunter_kalara_complete") and cm:get_saved_value("hunter_jorek_complete") and cm:get_saved_value("hunter_hertwig_complete") and cm:get_saved_value("hunter_rodrik_complete");
	end
);

function trigger_in_hunters_all_hunters_stories_completed_advice()
	in_hunters_all_hunters_stories_completed:play_advice_for_intervention(
		-- Each hunter now stands before the Huntsmarshal, ready for any challenge the expedition may face. 
		"wh2_dlc13.camp.advice.emp.wulfharts_hunters.005"
	);
end;

---------------------------------------------------------------
--
--	Wulfharts Campaign (Gor-Rok Defeated)
--
---------------------------------------------------------------

-- intervention declaration
in_wulfhart_campaign_gorrok_defeated = intervention:new(
	"in_wulfhart_campaign_gorrok_defeated",											-- string name
	20,	 																			-- cost
	function() trigger_in_wulfhart_campaign_gorrok_defeated_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_wulfhart_campaign_gorrok_defeated:set_allow_when_advice_disabled();

in_wulfhart_campaign_gorrok_defeated:add_trigger_condition(
	"GorRokDefeated",
	true
);

function trigger_in_wulfhart_campaign_gorrok_defeated_advice()
	in_wulfhart_campaign_gorrok_defeated:play_advice_for_intervention(
		-- Your actions have sent shockwaves throughout the jungles of Lustria. No temple-city will feel safe now that the Huntsmarshal has defeated the Great White Lizard.
		"wh2_dlc13.camp.advice.emp.gor_rok.002"
	);
end;

---------------------------------------------------------------
--
--	Wulfharts Campaign (Final Battle Triggered)
--
---------------------------------------------------------------

-- intervention declaration
in_wulfhart_campaign_final_battle = intervention:new(
	"in_wulfhart_campaign_final_battle",											-- string name
	20,	 																			-- cost
	function() trigger_in_wulfhart_campaign_final_battle_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_wulfhart_campaign_final_battle:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_wulfhart_campaign_final_battle:add_advice_key_precondition("wh2_dlc13.camp.advice.emp.wulfhart_final_battle.001");

in_wulfhart_campaign_final_battle:add_trigger_condition(
	"MissionIssued",
	function(context)
		local faction = context:faction();
		local mission_key = context:mission():mission_record_key();

		return faction:name() == cm:get_local_faction_name() and mission_key == "wh2_dlc13_qb_emp_final_battle_wulfhart";		
	end
);

function trigger_in_wulfhart_campaign_final_battle_advice()
	in_wulfhart_campaign_final_battle:play_advice_for_intervention(
		-- One still stands in your way, Huntsmarshal. See that your arrow strikes him true and be rid of the Spirit of the Jungle once and for all.
		"wh2_dlc13.camp.advice.emp.wulfhart_final_battle.001"
	);
end;


---------------------------------------------------------------
--
--	Chaos racial advice
--
---------------------------------------------------------------

-- intervention declaration
in_chaos_racial_advice = intervention:new(
	"in_chaos_racial_advice", 													-- string name
	25, 																		-- cost
	function() trigger_in_chaos_racial_advice() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_chaos_racial_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_chaos_racial_advice:add_precondition_unvisited_page("chaos");
in_chaos_racial_advice:add_advice_key_precondition("war.camp.prelude.chs.chaos.001");
in_chaos_racial_advice:set_min_turn(2);

in_chaos_racial_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		return true;
	end
);

function trigger_in_chaos_racial_advice()
	in_chaos_racial_advice:play_advice_for_intervention(	
		-- Your kind are the will of the Dark Gods made manifest, mighty lord. Harness the gifts afforded to you by the Ruinous Powers and you shall be unstoppable.
		"war.camp.prelude.chs.chaos.001", 
		{
			"war.camp.advice.warriors_of_chaos.info_001",
			"war.camp.advice.warriors_of_chaos.info_002",
			"war.camp.advice.warriors_of_chaos.info_003"
		}
	)
end;


---------------------------------------------------------------
--
--	Defence of the Great Plan (First settlement battle victory)
--
---------------------------------------------------------------

-- intervention declaration
in_defence_of_the_great_plan_first_settlement_victory = intervention:new(
	"in_defence_of_the_great_plan_first_settlement_victory", 									-- string name
	90, 																						-- cost
	function() trigger_in_defence_of_the_great_plan_first_settlement_victory_trigger() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 																-- show debug output
);


in_defence_of_the_great_plan_first_settlement_victory:add_advice_key_precondition("wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.001");
in_defence_of_the_great_plan_first_settlement_victory:give_priority_to_intervention("war.camp.advice.post_battle_options.002");
in_defence_of_the_great_plan_first_settlement_victory:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_defence_of_the_great_plan_first_settlement_victory:set_player_turn_only(false);
in_defence_of_the_great_plan_first_settlement_victory:set_wait_for_battle_complete(false);

in_defence_of_the_great_plan_first_settlement_victory:add_trigger_condition(
	"ScriptEventPlayerWinsSettlementBattle",
	function()
		-- only trigger if the pending battle is at a settlement that the player doesn't own
		local pb = cm:model():pending_battle();
		
		if pb:has_contested_garrison() and pb:contested_garrison():faction():name() ~= cm:get_local_faction_name() then
			return true;
		end;
		
		return false;
	end
);


function trigger_in_defence_of_the_great_plan_first_settlement_victory_trigger()
	in_defence_of_the_great_plan_first_settlement_victory:play_advice_for_intervention(
		-- The Old Ones look upon you with great favour, my lord. Aligning yourself with one of them may prove fruitful to your progress.
		"wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.001",
		{
			"wh2.camp.advice.lizardmen_defence_great_plan.info_001",
			"wh2.camp.advice.lizardmen_defence_great_plan.info_002",
			"wh2.camp.advice.lizardmen_defence_great_plan.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Defence of the Great Plan (First time user gifts a settlement)
--
---------------------------------------------------------------

-- intervention declaration
in_defence_of_the_great_plan_first_time_gifting = intervention:new(
	"in_defence_of_the_great_plan_first_time_gifting",											-- string name
	20,	 																						-- cost
	function() trigger_in_defence_of_the_great_plan_first_time_gifting_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 																-- show debug output
);

in_defence_of_the_great_plan_first_time_gifting:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_defence_of_the_great_plan_first_time_gifting:add_advice_key_precondition("wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.002");
in_defence_of_the_great_plan_first_time_gifting:give_priority_to_intervention("wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.001");

in_defence_of_the_great_plan_first_time_gifting:add_trigger_condition(
	"CharacterPerformsSettlementOccupationDecision",
	function(context)
		local faction = context:character():faction();
		local occupation_decision = context:occupation_decision();
		if occupation_decision == "1132333820" or occupation_decision == "1485462950" or occupation_decision == "1999603937" then
			return faction:name() == cm:get_local_faction_name();
		end
		return false;		
	end
);

function trigger_in_defence_of_the_great_plan_first_time_gifting_advice()
	in_defence_of_the_great_plan_first_time_gifting:play_advice_for_intervention(
		-- A wise choice indeed. The Defenders of the Great Plan will now guard this sacred temple for you in reverence to your chosen Old One.
		"wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.002"
	);
end;

---------------------------------------------------------------
--
--	Defence of the Great Plan (First time opening panel)
--
---------------------------------------------------------------

-- intervention declaration
in_defence_of_the_great_plan_open_panel = intervention:new(
	"in_defence_of_the_great_plan_open_panel",													-- string name
	20,	 																						-- cost
	function() trigger_in_defence_of_the_great_plan_open_panel_advice() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 																-- show debug output
);

in_defence_of_the_great_plan_open_panel:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_defence_of_the_great_plan_open_panel:add_advice_key_precondition("wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.003");
in_defence_of_the_great_plan_open_panel:set_wait_for_fullscreen_panel_dismissed(false);

in_defence_of_the_great_plan_open_panel:add_trigger_condition(
	"ScriptEventDotGPButtonClicked",
	true
);

function trigger_in_defence_of_the_great_plan_open_panel_advice()
	in_defence_of_the_great_plan_open_panel:play_advice_for_intervention(
		-- Your dedication to the Old Ones can be measured here, my lord. Each can bestow a variety of benefits for you to make use of, should you gift them enough temples.
		"wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.003"
	);
end;

---------------------------------------------------------------
--
--	Defence of the Great Plan (Reach 5 temples with one God)
--
---------------------------------------------------------------

-- intervention declaration
in_defence_of_the_great_plan_5_temples = intervention:new(
	"in_defence_of_the_great_plan_5_temples",													-- string name
	20,	 																						-- cost
	function() trigger_in_defence_of_the_great_plan_5_temples_advice() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 																-- show debug output
);

in_defence_of_the_great_plan_5_temples:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_defence_of_the_great_plan_5_temples:add_advice_key_precondition("wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.004");

in_defence_of_the_great_plan_5_temples:add_trigger_condition(
	"ScriptEventDotGP5Temples",
	true
);

function trigger_in_defence_of_the_great_plan_5_temples_advice()
	in_defence_of_the_great_plan_5_temples:play_advice_for_intervention(
		-- Your dedication to the Old Ones has grown again, my lord. Many temples are now protected by the Defenders of the Great Plan.
		"wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.004"
	);
end;

---------------------------------------------------------------
--
--	Defence of the Great Plan (First Temple Unit available)
--
---------------------------------------------------------------

-- intervention declaration
in_defence_of_the_great_plan_temple_unit_available = intervention:new(
	"in_defence_of_the_great_plan_temple_unit_available",										-- string name
	20,	 																						-- cost
	function() trigger_in_defence_of_the_great_plan_temple_unit_available_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 																-- show debug output
);

in_defence_of_the_great_plan_temple_unit_available:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_defence_of_the_great_plan_temple_unit_available:add_advice_key_precondition("wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.005");

in_defence_of_the_great_plan_temple_unit_available:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local faction = context:faction();
		local resource = faction:pooled_resource_manager():resource("lzd_old_ones_favour");
		if resource:value() > 100 and faction:name() == cm:get_local_faction_name()then
			local defenders_interface = cm:model():world():faction_by_key("wh2_dlc13_lzd_defenders_of_the_great_plan"); 
			return defenders_interface:region_list():num_items() > 5;
		end
	end
);

function trigger_in_defence_of_the_great_plan_temple_unit_available_advice()
	in_defence_of_the_great_plan_temple_unit_available:play_advice_for_intervention(
		-- Your dedication to the Old Ones has grown again, my lord. Many temples are now protected by the Defenders of the Great Plan.
		"wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.005"
	);
end;

---------------------------------------------------------------
--
--	Defence of the Great Plan (Fully Develop One God)
--
---------------------------------------------------------------

-- intervention declaration
in_defence_of_the_great_plan_1_god_complete = intervention:new(
	"in_defence_of_the_great_plan_1_god_complete",												-- string name
	20,	 																						-- cost
	function() trigger_in_defence_of_the_great_plan_1_god_complete_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 																-- show debug output
);

in_defence_of_the_great_plan_1_god_complete:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_defence_of_the_great_plan_1_god_complete:add_advice_key_precondition("wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.006");

in_defence_of_the_great_plan_1_god_complete:add_trigger_condition(
	"ScriptEventDotGPGodCompleted",
	true
);

function trigger_in_defence_of_the_great_plan_1_god_complete_advice()
	in_defence_of_the_great_plan_1_god_complete:play_advice_for_intervention(
		-- You have chosen well, my lord. Behold the benefits on offer for fully aligning yourself with your chosen Old One.
		"wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.006"
	);
end;

---------------------------------------------------------------
--
--	Defence of the Great Plan (Fully Develop Two Gods)
--
---------------------------------------------------------------

-- intervention declaration
in_defence_of_the_great_plan_2_gods_complete = intervention:new(
	"in_defence_of_the_great_plan_2_gods_complete",											-- string name
	20,	 																						-- cost
	function() trigger_in_defence_of_the_great_plan_2_gods_complete_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 																-- show debug output
);

in_defence_of_the_great_plan_2_gods_complete:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_defence_of_the_great_plan_2_gods_complete:add_advice_key_precondition("wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.007");

in_defence_of_the_great_plan_2_gods_complete:add_trigger_condition(
	"ScriptEventDotGPGodCompleted",
	function()
		if cm:get_saved_value("quetzl_completed") and cm:get_saved_value("xholankha_completed") then
			return true;
		elseif cm:get_saved_value("quetzl_completed") and cm:get_saved_value("itzl_completed") then
			return true;
		elseif cm:get_saved_value("xholankha_completed") and cm:get_saved_value("itzl_completed") then
			return true;
		end
		return false;
	end
);

function trigger_in_defence_of_the_great_plan_2_gods_complete_advice()
	in_defence_of_the_great_plan_2_gods_complete:play_advice_for_intervention(
		-- A second Old One now looks over you. There is untold strength in their guidance and wisdom.
		"wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.007"
	);
end;

---------------------------------------------------------------
--
--	Defence of the Great Plan (Fully Develop Three Gods)
--
---------------------------------------------------------------

-- intervention declaration
in_defence_of_the_great_plan_3_gods_complete = intervention:new(
	"in_defence_of_the_great_plan_3_gods_complete",											-- string name
	20,	 																						-- cost
	function() trigger_in_defence_of_the_great_plan_3_gods_complete_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 																-- show debug output
);

in_defence_of_the_great_plan_3_gods_complete:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_defence_of_the_great_plan_3_gods_complete:add_advice_key_precondition("wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.008");

in_defence_of_the_great_plan_3_gods_complete:add_trigger_condition(
	"ScriptEventDotGPGodCompleted",
	function()
		return cm:get_saved_value("quetzl_completed") and cm:get_saved_value("xholankha_completed") and cm:get_saved_value("itzl_completed");
	end
);

function trigger_in_defence_of_the_great_plan_3_gods_complete_advice()
	in_defence_of_the_great_plan_3_gods_complete:play_advice_for_intervention(
		-- The Great Plan is in motion! The Old Ones now look upon you favourably.
		"wh2_dlc13.camp.advice.lzd.defence_of_the_great_plan.008"
	);
end;

---------------------------------------------------------------
--
--	Jungle Nexus (Recruit a new Horde)
--
---------------------------------------------------------------

-- intervention declaration
in_jungle_nexus = intervention:new(
	"in_jungle_nexus",											-- string name
	20,	 														-- cost
	function() trigger_in_jungle_nexus_advice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_jungle_nexus:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_jungle_nexus:add_advice_key_precondition("wh2_dlc13.camp.advice.lzd.jungle_nexus.001");

in_jungle_nexus:add_trigger_condition(
	"CharacterCreated",
	function(context)
		local character = context:character();
		local faction = context:character():faction();
		return character:has_military_force() == true and faction:name() == cm:get_local_faction_name();
	end
);

function trigger_in_jungle_nexus_advice()
	in_jungle_nexus:play_advice_for_intervention(
		-- The jungle nexus grows, my lord. See that the horde draws from your great strength and recruits the most formidable warriors.
		"wh2_dlc13.camp.advice.lzd.jungle_nexus.001",
		{
			"wh2.camp.advice.lizardmen_jungle_nexus.info_001",
			"wh2.camp.advice.lizardmen_jungle_nexus.info_002",
			"wh2.camp.advice.lizardmen_jungle_nexus.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Warmblood Invaders (Turn 2)
--
---------------------------------------------------------------

-- intervention declaration
in_warm_blood_invaders_turn_2 = intervention:new(
	"in_warm_blood_invaders_turn_2",											-- string name
	0,	 																		-- cost
	function() trigger_in_warm_blood_invaders_turn_2_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_warm_blood_invaders_turn_2:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_warm_blood_invaders_turn_2:add_advice_key_precondition("wh2_dlc13.camp.advice.lzd.warmblood_invaders.001");

in_warm_blood_invaders_turn_2:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local faction = context:faction();
		local turn = cm:turn_number();
		return turn > 1 and faction:name() == cm:get_local_faction_name();
	end
);

function trigger_in_warm_blood_invaders_turn_2_advice()
	in_warm_blood_invaders_turn_2:play_advice_for_intervention(
		-- Warmbloods invade Lustria with ill intent, plundering as they please. Left unchallenged, they will surely pose a grave threat to the Great Plan.
		"wh2_dlc13.camp.advice.lzd.warmblood_invaders.001",
		{
			"wh2.camp.advice.lizardmen_warmblood_invaders.info_001",
			"wh2.camp.advice.lizardmen_warmblood_invaders.info_002",
			"wh2.camp.advice.lizardmen_warmblood_invaders.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Warmblood Invaders (First Hunter Killed)
--
---------------------------------------------------------------

-- intervention declaration
in_warm_blood_invaders_hunter_killed = intervention:new(
	"in_warm_blood_invaders_hunter_killed",										-- string name
	20,	 																		-- cost
	function() trigger_in_warm_blood_invaders_hunter_killed_advice() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_warm_blood_invaders_hunter_killed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_warm_blood_invaders_hunter_killed:add_advice_key_precondition("wh2_dlc13.camp.advice.lzd.warmblood_invaders.002");

in_warm_blood_invaders_hunter_killed:add_trigger_condition(
	"ScriptEventWarmbloodInvadersHunterKilled",
	function()
		return cm:get_saved_value("hunter_jorek_killed") or cm:get_saved_value("hunter_kalara_killed") or cm:get_saved_value("hunter_rodrik_killed") or cm:get_saved_value("hunter_hertwig_killed");
	end
);

function trigger_in_warm_blood_invaders_hunter_killed_advice()
	in_warm_blood_invaders_hunter_killed:play_advice_for_intervention(
		-- One hunter has been silenced, but others may still reside in Lustria. See to it that they are gone from these shores.
		"wh2_dlc13.camp.advice.lzd.warmblood_invaders.002"
	);
end;

---------------------------------------------------------------
--
--	Warmblood Invaders (All Hunters Killed)
--
---------------------------------------------------------------

-- intervention declaration
in_warm_blood_invaders_all_hunters_killed = intervention:new(
	"in_warm_blood_invaders_all_hunters_killed",								-- string name
	20,	 																		-- cost
	function() trigger_in_warm_blood_invaders_all_hunters_killed() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_warm_blood_invaders_all_hunters_killed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_warm_blood_invaders_all_hunters_killed:add_advice_key_precondition("wh2_dlc13.camp.advice.lzd.warmblood_invaders.003");

in_warm_blood_invaders_all_hunters_killed:add_trigger_condition(
	"ScriptEventWarmbloodInvadersHunterKilled",
	function()
		return cm:get_saved_value("hunter_jorek_killed") and cm:get_saved_value("hunter_kalara_killed") and cm:get_saved_value("hunter_rodrik_killed") and cm:get_saved_value("hunter_hertwig_killed");
	end
);

function trigger_in_warm_blood_invaders_all_hunters_killed()
	in_warm_blood_invaders_all_hunters_killed:play_advice_for_intervention(
		-- The mightiest of the warmblood hunters have been defeated. Soon they will all meet this fate, and the Great Plan shall come to fruition.
		"wh2_dlc13.camp.advice.lzd.warmblood_invaders.003"
	);
end;

---------------------------------------------------------------
--
--	Wulfharts Campaign (Final Battle Triggered)
--
---------------------------------------------------------------

-- intervention declaration
in_nakai_campaign_final_battle = intervention:new(
	"in_nakai_campaign_final_battle",											-- string name
	20,	 																		-- cost
	function() trigger_in_nakai_campaign_final_battle_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_nakai_campaign_final_battle:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_nakai_campaign_final_battle:add_advice_key_precondition("wh2_dlc13.camp.advice.lzd.nakai_final_battle.001");

in_nakai_campaign_final_battle:add_trigger_condition(
	"MissionIssued",
	function(context)
		local faction = context:faction();
		local mission_key = context:mission():mission_record_key();

		return faction:name() == cm:get_local_faction_name() and mission_key == "wh2_dlc13_qb_lzd_final_battle_nakai";		
	end
);

function trigger_in_nakai_campaign_final_battle_advice()
	in_nakai_campaign_final_battle:play_advice_for_intervention(
		-- One still stands in your way, my lord - the chief hunter. Crush him beneath your mighty tread, for you are the Spirit of the Jungle. The Great Plan must prevail!
		"wh2_dlc13.camp.advice.lzd.nakai_final_battle.001"
	);
end;

---------------------------------------------------------------
--
--	Desert thirst
--
---------------------------------------------------------------

-- intervention declaration
in_desert_thirst = intervention:new(
	"in_desert_thirst",										-- string name
	20,	 													-- cost
	function() trigger_in_desert_thirst() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 							-- show debug output
);

in_desert_thirst:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_desert_thirst:add_advice_key_precondition("wh2_dlc14.camp.advice.brt.desert_thirst.001");

in_desert_thirst:add_trigger_condition(
	"CharacterEntersGarrison",
	function(context)
		return context:character():faction():name() == cm:get_local_faction_name();		
	end
);

function trigger_in_desert_thirst()
	in_desert_thirst:play_advice_for_intervention(
		-- My Lady, our men have refilled their waterskins and quenched their thirst. Such things are of grave importance when traversing these scorching desert lands.
		"wh2_dlc14.camp.advice.brt.desert_thirst.001", 
		{
			"wh2.camp.advice.bretonnia_desert_thirst.info_001",
			"wh2.camp.advice.bretonnia_desert_thirst.info_002",
			"wh2.camp.advice.bretonnia_desert_thirst.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Shadowy Dealings (Open Panel)
--
---------------------------------------------------------------

-- intervention declaration
in_shadowy_dealings_open_panel = intervention:new(
	"in_shadowy_dealings_open_panel",										-- string name
	0,	 																	-- cost
	function() trigger_in_shadowy_dealings_open_panel() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_shadowy_dealings_open_panel:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_shadowy_dealings_open_panel:add_advice_key_precondition("wh2_dlc14.camp.advice.skv.shadowry_dealings.001");

in_shadowy_dealings_open_panel:add_trigger_condition(
	"ScriptEventShadowyDealingsPanelOpened",
	true
);

function trigger_in_shadowy_dealings_open_panel()
	in_shadowy_dealings_open_panel:play_advice_for_intervention(
		-- With the most skilled assassins of all Skaven, Clan Eshin have the ability to be anywhere and everywhere at any given moment.
		-- You are the Grand Nightlord’s most senior operative, unmatched in subterfuge. Use your oversight of Eshin’s shady network to achieve the clan’s ends.
		"wh2_dlc14.camp.advice.skv.shadowry_dealings.001", 
		{
			"wh2.camp.advice.skaven_shadowy_dealings.info_001",
			"wh2.camp.advice.skaven_shadowy_dealings.info_002",
			"wh2.camp.advice.skaven_shadowy_dealings.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Shadowy Dealings (Clan Contracts Button Clicked)
--
---------------------------------------------------------------

-- intervention declaration
in_shadowy_dealings_clan_contracts = intervention:new(
	"in_shadowy_dealings_clan_contracts",										-- string name
	20,	 																		-- cost
	function() trigger_in_shadowy_dealings_clan_contracts() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_shadowy_dealings_clan_contracts:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_shadowy_dealings_clan_contracts:add_advice_key_precondition("wh2_dlc14.camp.advice.skv.shadowry_dealings.003");

in_shadowy_dealings_clan_contracts:add_trigger_condition(
	"ScriptEventClanButtonClicked",
	true
);

function trigger_in_shadowy_dealings_clan_contracts()
	in_shadowy_dealings_clan_contracts:play_advice_for_intervention(
		-- Various clans seek us out for special contracts, my lord. Completing one of these will increase our reputation with them, 
		-- making the troops they provide more affordable, but will also anger the targeted clan.
		"wh2_dlc14.camp.advice.skv.shadowry_dealings.003"
	);
end;

---------------------------------------------------------------
--
--	Shadowy Dealings (Action Completed)
--
---------------------------------------------------------------

-- intervention declaration
in_shadowy_dealings_action_completed = intervention:new(
	"in_shadowy_dealings_action_completed",										-- string name
	20,	 																		-- cost
	function() trigger_in_shadowy_dealings_action_completed() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_shadowy_dealings_action_completed:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_shadowy_dealings_action_completed:add_advice_key_precondition("wh2_dlc14.camp.advice.skv.shadowry_dealings.004");

in_shadowy_dealings_action_completed:add_trigger_condition(
	"RitualCompletedEvent",
	function(context)
		return context:ritual():ritual_key():find("wh2_dlc14_eshin_actions_");
	end
	
);



function trigger_in_shadowy_dealings_action_completed()
	in_shadowy_dealings_action_completed:play_advice_for_intervention(
		-- Various clans seek us out for special contracts, my lord. Completing one of these will increase our reputation with them, 
		-- making the troops they provide more affordable, but will also anger the targeted clan.
		"wh2_dlc14.camp.advice.skv.shadowry_dealings.004"
	);
end;


---------------------------------------------------------------
--
--	Malus Possession (Campaign Start)
--
---------------------------------------------------------------

-- intervention declaration
in_possession_start = intervention:new(
	"in_possession_start",										-- string name
	20,	 														-- cost
	function() trigger_in_possession_start() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_possession_start:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_possession_start:add_advice_key_precondition("wh2_dlc14.camp.advice.def.possession.001");

in_possession_start:add_trigger_condition(
	"ScriptEventPlayerStartsOpenCampaignFromNormal",
	true	
);


function trigger_in_possession_start()
	in_possession_start:play_advice_for_intervention(
		-- My lord, Tz’Arkan is a powerful Daemon that resides within you. His control is strong, but with his curse comes great powers and abilities to use against your enemies.
		"wh2_dlc14.camp.advice.def.possession.001", 
		{
			"wh2.camp.advice.dark_elves_possession_tzarkan.info_001",
			"wh2.camp.advice.dark_elves_possession_tzarkan.info_002",
			"wh2.camp.advice.dark_elves_possession_tzarkan.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Malus Possession (Use Elixir)
--
---------------------------------------------------------------

-- intervention declaration
in_possession_elixir = intervention:new(
	"in_possession_elixir",										-- string name
	0,	 														-- cost
	function() trigger_in_possession_elixir() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_possession_elixir:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_possession_elixir:add_advice_key_precondition("wh2_dlc14.camp.advice.def.possession.002");

in_possession_elixir:add_trigger_condition(
	"ScriptEventElixirButtonClicked",
	true	
);


function trigger_in_possession_elixir()
	in_possession_elixir:play_advice_for_intervention(
		-- Well done my lord! This elixir helps you limit Tz’Arkan’s presence and reduces his possession over you. Use it wisely.
		"wh2_dlc14.camp.advice.def.possession.002"
	);
end;

---------------------------------------------------------------
--
--	Malus Possession (-10 Possession)
--
---------------------------------------------------------------

-- intervention declaration
in_possession_full_control = intervention:new(
	"in_possession_full_control",								-- string name
	0,	 														-- cost
	function() trigger_in_possession_full_control() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_possession_full_control:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_possession_full_control:add_advice_key_precondition("wh2_dlc14.camp.advice.def.possession.003");

in_possession_full_control:add_trigger_condition(
	"PooledResourceEffectChangedEvent",
	function(context)
		local faction = context:faction();
		local resource = context:resource();
		if resource:key() == "def_malus_sanity" and faction:name() == cm:get_local_faction_name() then
			if resource:value() <= -10 then
				return true;
			end
		end;
		return false;
	end
);


function trigger_in_possession_full_control()
	in_possession_full_control:play_advice_for_intervention(
		-- You have attained full control, my lord, resulting in increased stability across your regions and higher loyalty from your commanders, as well as granting you the Rite of the Warmaster. 
		-- However, greater control also reduces your battle prowess.
		"wh2_dlc14.camp.advice.def.possession.003"
	);
end;

---------------------------------------------------------------
--
--	Malus Possession (Post Battle Full Possession)
--
---------------------------------------------------------------

-- intervention declaration
in_possession_full_possession = intervention:new(
	"in_possession_full_possession",								-- string name
	0,	 														-- cost
	function() trigger_in_possession_full_possession() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_possession_full_possession:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_possession_full_possession:add_advice_key_precondition("wh2_dlc14.camp.advice.def.possession.004");

in_possession_full_possession:add_trigger_condition(
	"ScriptEventMalusPossessedPostBattle",
	true
);


function trigger_in_possession_full_possession()
	in_possession_full_possession:play_advice_for_intervention(
		-- Tz’Arkan has full possession, my lord, making you unmatched on the battlefield. However, your commanders and warriors are more distrustful of you, resulting in reduced loyalty and troop replenishment. 
		-- By taking the elixir, you can reduce possession and increase your control.
		"wh2_dlc14.camp.advice.def.possession.004"
	);
end;

---------------------------------------------------------------
--
--	Malus Possession (Possession Hits 5)
--
---------------------------------------------------------------

-- intervention declaration
in_possession_5 = intervention:new(
	"in_possession_5",											-- string name
	0,	 														-- cost
	function() trigger_in_possession_5() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_possession_5:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_possession_5:add_advice_key_precondition("wh2_dlc14.camp.advice.def.possession.005");

in_possession_5:add_trigger_condition(
	"PooledResourceEffectChangedEvent",
	function(context)
		local faction = context:faction();
		local resource = context:resource();
		if resource:key() == "def_malus_sanity" and faction:name() == cm:get_local_faction_name() then
			if resource:value() >= 5 then
				return true;
			end
		end;
		return false;
	end
);


function trigger_in_possession_5()
	in_possession_5:play_advice_for_intervention(
		-- My Lord, Tz'Arkan's possession of you grows stronger with time. It is important to be vigilant of its consequences and to ensure that it is kept under control.
		"wh2_dlc14.camp.advice.def.possession.005"
	);
end;

---------------------------------------------------------------
--
--	Tz'arkan Whispers (Mission Received)
--
---------------------------------------------------------------

-- intervention declaration
in_whispers_issued = intervention:new(
	"in_whispers_issued",										-- string name
	30,	 														-- cost
	function() trigger_in_whispers_issued() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_whispers_issued:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_whispers_issued:add_advice_key_precondition("wh2_dlc14.camp.advice.def.tzarkans_whispers.001");

in_whispers_issued:add_trigger_condition(
	"MissionIssued",
	function(context)
		local mission = context:mission():mission_record_key();
		local faction = context:faction();
		if faction:name() == cm:get_local_faction_name() then
			return mission == "wh2_dlc14_tzarkan_declare_war" or mission == "wh2_dlc14_tzarkan_kill_entities" or mission == "wh2_dlc14_tzarkan_raze_or_sack";
		end;
	end	
);


function trigger_in_whispers_issued()
	in_whispers_issued:play_advice_for_intervention(
		-- The malevolent whispers of the Daemon plague your inner thoughts, my Lord, and with them come new targets and pursuits. 
		-- Heed these dark desires and the rewards may be bountiful, or choose to ignore them until new ones emerge to replace them.
		"wh2_dlc14.camp.advice.def.tzarkans_whispers.001"
	);
end;

---------------------------------------------------------------
--
--	Tz'arkan Whispers (Mission Succeeded)
--
---------------------------------------------------------------

-- intervention declaration
in_whispers_succeeded = intervention:new(
	"in_whispers_succeeded",										-- string name
	30,	 														-- cost
	function() trigger_in_whispers_succeeded() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_whispers_succeeded:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_whispers_succeeded:add_advice_key_precondition("wh2_dlc14.camp.advice.def.tzarkans_whispers.002");

in_whispers_succeeded:add_trigger_condition(
	"MissionSucceeded",
	function(context)
		local mission = context:mission():mission_record_key();
		local faction = context:faction();
		if faction:name() == cm:get_local_faction_name() then
			return mission == "wh2_dlc14_tzarkan_declare_war" or mission == "wh2_dlc14_tzarkan_kill_entities" or mission == "wh2_dlc14_tzarkan_raze_or_sack";
		end;
	end	
);


function trigger_in_whispers_succeeded()
	in_whispers_succeeded:play_advice_for_intervention(
		-- A dark whisper from the depths of your subconscious has guided you this far, but at what cost? You have been rewarded, but have also paid the price.
		"wh2_dlc14.camp.advice.def.tzarkans_whispers.002"
	);
end;

---------------------------------------------------------------
--
--	Malekith Favour 
--
---------------------------------------------------------------

-- intervention declaration
in_malekith_favour = intervention:new(
	"in_malekith_favour",										-- string name
	20,	 														-- cost
	function() trigger_in_malekith_favour() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_malekith_favour:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_malekith_favour:add_advice_key_precondition("wh2_dlc14.camp.advice.def.malekiths_favour.001");

in_malekith_favour:add_trigger_condition(
	"ScriptEventWitchKingRiteUnlocked",
	true
);


function trigger_in_malekith_favour()
	in_malekith_favour:play_advice_for_intervention(
		-- You can now request assistance from the Witch King himself by presenting him with a gift of slaves. 
		-- Perform the rite and a Hero of your choice will be sent to aid you. The larger Malekith’s realm, the more powerful the Hero sent.
		"wh2_dlc14.camp.advice.def.malekiths_favour.001"
	);
end;

---------------------------------------------------------------
--
--	Malus Scrolls (Early Game)
--
---------------------------------------------------------------

-- intervention declaration
in_malus_scrolls_early = intervention:new(
	"in_malus_scrolls_early",									-- string name
	20,	 														-- cost
	function() trigger_in_malus_scrolls_early() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_malus_scrolls_early:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_malus_scrolls_early:add_advice_key_precondition("wh2_dlc14.camp.advice.def.malus_scrolls.001");

in_malus_scrolls_early:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return false;
	end
);


function trigger_in_malus_scrolls_early()
	in_malus_scrolls_early:play_advice_for_intervention(
		-- It is imperative that we gather the Scrolls of Hekarti, my lord. 
		-- Through them the Witch King’s strength will grow, and no-one will dare oppose the Naggarothi.
		"wh2_dlc14.camp.advice.def.malus_scrolls.001"
	);
end;

---------------------------------------------------------------
--
--	Malus Scrolls (Mid Game)
--
---------------------------------------------------------------

-- intervention declaration
in_malus_scrolls_mid = intervention:new(
	"in_malus_scrolls_mid",									-- string name
	20,	 														-- cost
	function() trigger_in_malus_scrolls_mid() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_malus_scrolls_mid:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_malus_scrolls_mid:add_advice_key_precondition("wh2_dlc14.camp.advice.def.malus_scrolls.002");

in_malus_scrolls_mid:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return false;
	end
);

function trigger_in_malus_scrolls_mid()
	in_malus_scrolls_mid:play_advice_for_intervention(
		-- My lord, there are still many Scrolls of Hekarti remaining to be found throughout these lands. Gather more and strengthen our cause.
		"wh2_dlc14.camp.advice.def.malus_scrolls.002"
	);
end;


---------------------------------------------------------------
--
--	Imrik Dragon Marker Spawn
--
---------------------------------------------------------------

-- intervention declaration
in_imrik_dragon_spawn = intervention:new(
	"in_imrik_dragon_spawn",									-- string name
	0,	 														-- cost
	function() trigger_in_imrik_dragon_spawn() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_imrik_dragon_spawn:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_imrik_dragon_spawn:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.dragon_taming.001");

in_imrik_dragon_spawn:add_trigger_condition(
	"ScriptEventImrikDragonMarkerSpawn",
	true
);


function trigger_in_imrik_dragon_spawn()
	in_imrik_dragon_spawn:play_advice_for_intervention(
		-- The herald of an ancient, powerful Dragon has appeared nearby, my lord. This is most fortuitous, for you have long sought to commune with such a creature – 
		-- in fact, it is the very reason you roam outside of Ulthuan.
		"wh2_dlc15.camp.advice.hef.dragon_taming.001",
		{
			"wh2_dlc15.camp.advice.dragon_taming.info_001",
			"wh2_dlc15.camp.advice.dragon_taming.info_002",
			"wh2_dlc15.camp.advice.dragon_taming.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Imrik Dragon Marker Enter
--
---------------------------------------------------------------

-- intervention declaration
in_imrik_dragon_enter = intervention:new(
	"in_imrik_dragon_enter",									-- string name
	0,	 														-- cost
	function() trigger_in_imrik_dragon_enter() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_imrik_dragon_enter:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_imrik_dragon_enter:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.dragon_taming.002");
in_imrik_dragon_enter:set_wait_for_dilemma(false);

in_imrik_dragon_enter:add_trigger_condition(
	"ScriptEventImrikDragonMarkerEnter",
	true
);


function trigger_in_imrik_dragon_enter()
	in_imrik_dragon_enter:play_advice_for_intervention(
		-- As the Dragon Prince, the mighty Drakes you encounter not only understand you, but also have much to offer. You may seek their affiliation or wisdom, but bringing them under your command will take much more.
		"wh2_dlc15.camp.advice.hef.dragon_taming.002",
		{
			"wh2_dlc15.camp.advice.dragon_taming.info_001",
			"wh2_dlc15.camp.advice.dragon_taming.info_002",
			"wh2_dlc15.camp.advice.dragon_taming.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Imrik Dragon Quest Battle Trigger
--
---------------------------------------------------------------

-- intervention declaration
in_imrik_dragon_quest_trigger = intervention:new(
	"in_imrik_dragon_quest_trigger",									-- string name
	0,	 																-- cost
	function() trigger_in_imrik_dragon_quest_trigger() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_imrik_dragon_quest_trigger:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_imrik_dragon_quest_trigger:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.dragon_taming.003");

in_imrik_dragon_quest_trigger:add_trigger_condition(
	"ScriptEventImrikDragonBattleSpawn",
	true
);


function trigger_in_imrik_dragon_quest_trigger()
	in_imrik_dragon_quest_trigger:play_advice_for_intervention(
		-- A mighty Dragon awaits you in battle, my lord! You know very well that it is no small feat to defeat a Dragon, but doing so will bring recompense, not least its loyalty and service in your army.
		"wh2_dlc15.camp.advice.hef.dragon_taming.003",
		{
			"wh2_dlc15.camp.advice.dragon_taming.info_001",
			"wh2_dlc15.camp.advice.dragon_taming.info_002",
			"wh2_dlc15.camp.advice.dragon_taming.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Imrik Dragon Quest Battle Success First
--
---------------------------------------------------------------

-- intervention declaration
in_imrik_dragon_quest_success_one = intervention:new(
	"in_imrik_dragon_quest_success_one",									-- string name
	0,	 																	-- cost
	function() trigger_in_imrik_dragon_quest_success_one() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_imrik_dragon_quest_success_one:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_imrik_dragon_quest_success_one:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.dragon_taming.004");

in_imrik_dragon_quest_success_one:add_trigger_condition(
	"ScriptEventImrikDragonBattleWinOne",
	true
);


function trigger_in_imrik_dragon_quest_success_one()
	in_imrik_dragon_quest_success_one:play_advice_for_intervention(
		-- It is a momentous day, mighty Dragon Prince, for you have proven your strength to this Dragon and earned its esteem. Power respects power, and now the Drake stands ready to be recruited into your battle ranks.
		"wh2_dlc15.camp.advice.hef.dragon_taming.004"
	);
end;

---------------------------------------------------------------
--
--	Imrik Dragon Quest Battle Success Second
--
---------------------------------------------------------------

-- intervention declaration
in_imrik_dragon_quest_success_two = intervention:new(
	"in_imrik_dragon_quest_success_two",									-- string name
	0,	 																	-- cost
	function() trigger_in_imrik_dragon_quest_success_two() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_imrik_dragon_quest_success_two:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_imrik_dragon_quest_success_two:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.dragon_taming.005");

in_imrik_dragon_quest_success_two:add_trigger_condition(
	"ScriptEventImrikDragonBattleWinTwo",
	true
);


function trigger_in_imrik_dragon_quest_success_two()
	in_imrik_dragon_quest_success_two:play_advice_for_intervention(
		-- Challenging and defeating another mighty Drake has brought it into your battle ranks, Dragon Prince! Many more exist out in the world, some more formidable than others, 
		-- but all worth convening with to gain their wisdom and loyalty.
		"wh2_dlc15.camp.advice.hef.dragon_taming.005"
	);
end;

---------------------------------------------------------------
--
--	Imrik Dragon Quest Battle Success Five
--
---------------------------------------------------------------

-- intervention declaration
in_imrik_dragon_quest_success_five = intervention:new(
	"in_imrik_dragon_quest_success_five",									-- string name
	0,	 																	-- cost
	function() trigger_in_imrik_dragon_quest_success_five() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_imrik_dragon_quest_success_five:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_imrik_dragon_quest_success_five:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.dragon_taming.006");

in_imrik_dragon_quest_success_five:add_trigger_condition(
	"ScriptEventImrikDragonBattleWinFive",
	true
);


function trigger_in_imrik_dragon_quest_success_five()
	in_imrik_dragon_quest_success_five:play_advice_for_intervention(
		-- Congratulations, my lord! Your search for the most powerful Dragons in the world is now complete, as the best of them have pledged their loyalty to you. 
		-- With these mighty allies, your enemies will think twice before drawing the ire of Caledor!
		"wh2_dlc15.camp.advice.hef.dragon_taming.006"
	);
end;

---------------------------------------------------------------
--
--	Imrik Dragon Non-Quest Dilemma Option
--
---------------------------------------------------------------

-- intervention declaration
in_imrik_dragon_dilemma_non_quest = intervention:new(
	"in_imrik_dragon_dilemma_non_quest",									-- string name
	0,	 																	-- cost
	function() trigger_in_imrik_dragon_dilemma_non_quest() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_imrik_dragon_dilemma_non_quest:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_imrik_dragon_dilemma_non_quest:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.dragon_taming.007");

in_imrik_dragon_dilemma_non_quest:add_trigger_condition(
	"ScriptEventImrikDragonDilemmaNonBattle",
	true
);


function trigger_in_imrik_dragon_dilemma_non_quest()
	in_imrik_dragon_dilemma_non_quest:play_advice_for_intervention(
		-- Your first encounter with a Dragon outside of Ulthuan was a fruitful one, my lord. Such meetings are rare, however, and it will be some time before another shows itself to convene with you.
		"wh2_dlc15.camp.advice.hef.dragon_taming.007"
	);
end;

---------------------------------------------------------------
--
--	Imrik Dragon Encounter Generic
--
---------------------------------------------------------------

-- intervention declaration
in_imrik_dragon_encounter_generic = intervention:new(
	"in_imrik_dragon_encounter_generic",									-- string name
	0,	 																	-- cost
	function() trigger_in_imrik_dragon_encounter_generic() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_imrik_dragon_encounter_generic:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_imrik_dragon_encounter_generic:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.dragon_taming.008");

in_imrik_dragon_encounter_generic:add_trigger_condition(
	"ScriptEventImrikDragonEncounterGeneric",
	true
);


function trigger_in_imrik_dragon_encounter_generic()
	in_imrik_dragon_encounter_generic:play_advice_for_intervention(
		-- A Dragon has appeared nearby, my lord. It appears to be of a lesser ilk than some of the more ancient specimens you have encountered, but still has much to offer should you choose to approach it.
		"wh2_dlc15.camp.advice.hef.dragon_taming.008"
	);
end;


---------------------------------------------------------------
--
--	Greenskin Underway
--
---------------------------------------------------------------

-- intervention declaration
in_greenskins_underway_advice = intervention:new(
	"in_greenskins_underway_advice", 											-- string name
	60, 																		-- cost
	function() trigger_in_greenskins_underway_advice() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_greenskins_underway_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_greenskins_underway_advice:add_precondition_unvisited_page("underway");
in_greenskins_underway_advice:add_advice_key_precondition("war.camp.prelude.grn.underways.001");
in_greenskins_underway_advice:add_advice_key_precondition("war.camp.prelude.dwf.underways.001");
in_greenskins_underway_advice:set_min_turn(4);

in_greenskins_underway_advice:add_precondition(
	function()
		return not common.get_advice_history_string_seen("use_underway_stance")
	end
);

in_greenskins_underway_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return true;
	end
);

function trigger_in_greenskins_underway_advice()
	out("trigger_in_greenskins_underway_advice() called");
	
	in_greenskins_underway_advice:play_advice_for_intervention(
		-- Be sure to make use of the Underway when moving your boys through difficult terrain, mighty Lord. Much time can be saved when moving below ground.
		"war.camp.prelude.grn.underways.001", 
		{
			"war.camp.advice.underway.info_001",
			"war.camp.advice.underway.info_002",
			"war.camp.advice.underway.info_003",
			"war.camp.advice.underway.info_004"
		}
	);
end;


---------------------------------------------------------------
--
--	Raidin' Camp Stance Possible
--
---------------------------------------------------------------

-- intervention declaration
in_raiding_camp_stance_possible = intervention:new(
	"raiding_camp_stance_possible",	 										-- string name
	60, 																	-- cost
	function() in_raiding_camp_stance_possible_trigger() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_raiding_camp_stance_possible:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_raiding_camp_stance_possible:add_advice_key_precondition("war.camp.advice.raiding.003");
in_raiding_camp_stance_possible:add_precondition(function() return not uim:get_interaction_monitor_state("raidin_camp_stance") end);
in_raiding_camp_stance_possible:set_min_turn(6);

in_raiding_camp_stance_possible:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()
		return cm:faction_has_armies_in_enemy_territory(cm:get_local_faction());
	end
);

function in_raiding_camp_stance_possible_trigger()
	in_raiding_camp_stance_possible:play_advice_for_intervention(
		-- Consider raising a camp in the lands of the enemy, savage Lord. It shall become a base from which your warriors may raid the countryside.
		"war.camp.advice.raiding.003", 
		{
			"war.camp.advice.raiding.info_001",
			"war.camp.advice.raiding.info_002", 
			"war.camp.advice.raiding.info_004",
			"war.camp.advice.raiding.info_005"
		}
	);
end;


---------------------------------------------------------------
--
--	Waaagh resource gained
--
---------------------------------------------------------------

-- intervention declaration
in_wagh_resource_gained = intervention:new(
	"wagh_resource_gained",									-- string name
	20,	 														-- cost
	function() trigger_in_wagh_resource_gained() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_wagh_resource_gained:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_wagh_resource_gained:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.waaagh.001");

in_wagh_resource_gained:add_trigger_condition(
	"ScriptEventWaghBattle",
	true
);

function trigger_in_wagh_resource_gained()
	in_wagh_resource_gained:play_advice_for_intervention(
		-- Your path of violence and destruction has begun, mighty lord, your reputation growing with every victim and settlement that falls before you. Continue warmongering and you will eventually gain momentum enough to make the Call to Waaagh!!
		"wh2_dlc15.camp.advice.grn.waaagh.001",
		{
			"war.camp.advice.waaagh.info_001",
			"war.camp.advice.waaagh.info_002",
			"war.camp.advice.waaagh.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Waaagh ready to trigger
--
---------------------------------------------------------------

-- intervention declaration
in_wagh_trigger = intervention:new(
	"wagh_trigger",									-- string name
	20,	 														-- cost
	function() trigger_in_wagh_trigger() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_wagh_trigger:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_wagh_trigger:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.waaagh.002");

in_wagh_trigger:add_trigger_condition(
	"ScriptEventWaghResourceMax",
	true
);

function trigger_in_wagh_trigger()
	in_wagh_trigger:play_advice_for_intervention(
		-- It is time, my lord! Your reputation has grown to such an extent that other mobs flock from miles around to fight under your command. Make the Call to Waaagh! against a rival’s capital and claim your first trophy!!!
		"wh2_dlc15.camp.advice.grn.waaagh.002",
		{
			"war.camp.advice.waaagh.info_001",
			"war.camp.advice.waaagh.info_002",
			"war.camp.advice.waaagh.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Waaagh ready to trigger reminder
--
---------------------------------------------------------------

-- intervention declaration
in_wagh_trigger_reminder = intervention:new(
	"wagh_trigger_reminder",									-- string name
	20,	 														-- cost
	function() trigger_in_wagh_trigger_reminder() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_wagh_trigger_reminder:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_wagh_trigger_reminder:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.waaagh.003");
in_wagh_trigger_reminder:give_priority_to_intervention("wagh_trigger");

in_wagh_trigger_reminder:add_trigger_condition(
	"ScriptEventWaghReminder",
	true
);

function trigger_in_wagh_trigger_reminder()
	in_wagh_trigger_reminder:play_advice_for_intervention(
		-- Your horde still chomps at the bit to unleash its violent energies, my lord, while the mobs amass in frenzied anticipation to join you. Make the Call to Waaagh!!!!
		"wh2_dlc15.camp.advice.grn.waaagh.003",
		{
			"war.camp.advice.waaagh.info_001",
			"war.camp.advice.waaagh.info_002",
			"war.camp.advice.waaagh.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Waaagh target selection
--
---------------------------------------------------------------

-- intervention declaration
in_wagh_select = intervention:new(
	"wagh_select",									-- string name
	20,	 														-- cost
	function() trigger_in_wagh_select() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_wagh_select:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_wagh_select:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.waaagh.004");

in_wagh_select:add_trigger_condition(
	"ScriptEventWaghSelect",
	true
);

function trigger_in_wagh_select()
	in_wagh_select:play_advice_for_intervention(
		-- The living green tidal wave of destruction crests, ready to sweep over your ill-fated victims! Choose your mark and a trophy shall await you in their capital to claim once it is razed or occupied.!!!!
		"wh2_dlc15.camp.advice.grn.waaagh.004"
	);
end;

---------------------------------------------------------------
--
--	Waaagh god selection
--
---------------------------------------------------------------

-- intervention declaration
in_wagh_god_select = intervention:new(
	"wagh_god_select",									-- string name
	20,	 														-- cost
	function() trigger_in_wagh_god_select() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_wagh_god_select:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_wagh_god_select:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.waaagh.005");
in_wagh_god_select:give_priority_to_intervention("wagh_select");

in_wagh_god_select:add_trigger_condition(
	"ScriptEventWaghSelect",
	true
);

function trigger_in_wagh_god_select()
	in_wagh_god_select:play_advice_for_intervention(
		-- The Waaagh! is the will of the boisterous and belligerent brother-gods of the Greenskins, Gork and Mork. Calling one in either of their names will bring their favour, be it brutally cunning or cunningly brutal!!!!!
		"wh2_dlc15.camp.advice.grn.waaagh.005"
	);
end;

---------------------------------------------------------------
--
--	Waaagh success
--
---------------------------------------------------------------

-- intervention declaration
in_wagh_success = intervention:new(
	"wagh_success",									-- string name
	20,	 														-- cost
	function() trigger_in_wagh_success() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_wagh_success:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_wagh_success:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.waaagh.006");

in_wagh_success:add_trigger_condition(
	"PlayerWaghEndedSuccessful",
	true
);

function trigger_in_wagh_success()
	in_wagh_success:play_advice_for_intervention(
		-- Well done, my lord! You have successfully completed your Waaagh! and claimed your trophy. Not only do rival Warbosses gaze upon it with envy, but it will also boost the tribe until you claim your next trophy!!!!
		"wh2_dlc15.camp.advice.grn.waaagh.006"
	);
end;

---------------------------------------------------------------
--
--	Waaagh failure
--
---------------------------------------------------------------

-- intervention declaration
in_wagh_failure = intervention:new(
	"wagh_failure",									-- string name
	20,	 														-- cost
	function() trigger_in_wagh_failure() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_wagh_failure:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_wagh_failure:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.waaagh.007");

in_wagh_failure:add_trigger_condition(
	"PlayerWaghEndedUnsuccessful",
	true
);

function trigger_in_wagh_failure()
	in_wagh_failure:play_advice_for_intervention(
		-- Alas, your Waaagh! has failed, my lord. You did not conquer your target’s capital in time, so the mobs have dispersed. There will be no trophy this time, so now you must gather your destructive momentum once again.!!!!
		"wh2_dlc15.camp.advice.grn.waaagh.007"
	);
end;

---------------------------------------------------------------
--
--	Waaagh transported army
--
---------------------------------------------------------------

-- intervention declaration
in_wagh_transported_army = intervention:new(
	"wagh_transported_army",									-- string name
	20,	 														-- cost
	function() trigger_in_wagh_transported_army() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_wagh_transported_army:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_wagh_transported_army:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.waaagh.008");

in_wagh_transported_army:add_trigger_condition(
	"ScriptEventWaghTransportedArmies",
	true
);

function trigger_in_wagh_transported_army()
	in_wagh_transported_army:play_advice_for_intervention(
		-- The Waaagh! has amassed! Every army under your command is now accompanied by additional mobs who will follow your hordes into battle, but only for the duration of the Waaagh!!!!!
		"wh2_dlc15.camp.advice.grn.waaagh.008"
	);
end;

---------------------------------------------------------------
--
--	Yvresse Reminder - Eltharion ME 
--
---------------------------------------------------------------

-- intervention declaration
in_yvresse_reminder = intervention:new(
	"yvresse_warning",									-- string name
	20,	 												-- cost
	function() trigger_yvresse_warning() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 						-- show debug output
);

in_yvresse_reminder:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_yvresse_reminder:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.yvresse.001");

in_yvresse_reminder:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		if cm:turn_number() == 2 and cm:get_campaign_name() == "main_warhammer" then
			return true
		end
	end
);

function trigger_yvresse_warning()
	in_yvresse_reminder:scroll_camera_to_settlement_for_intervention(
		"wh2_main_yvresse_tralinia",
		-- Be warned, the devious Greenskins have advanced towards Tor Yvresse in your absence! The city’s defences can cope for now, but you may want to take steps towards bolstering them or return to deal with the invasion yourself.
		"wh2_dlc15.camp.advice.hef.yvresse.001"
	);
end;

---------------------------------------------------------------
--
--	Mists of Yvresse - Rite Unlocked
--
---------------------------------------------------------------

-- intervention declaration
in_mists_of_yvresse_unlocked = intervention:new(
	"in_mists_of_yvresse_unlocked",									-- string name
	20,	 															-- cost
	function() trigger_in_mists_of_yvresse_unlocked() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_mists_of_yvresse_unlocked:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_mists_of_yvresse_unlocked:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.mist_of_yvresse.001");

in_mists_of_yvresse_unlocked:add_trigger_condition(
	"ScriptEventMistsOfYvresseUnlocked",
	true
);

function trigger_in_mists_of_yvresse_unlocked()
	in_mists_of_yvresse_unlocked:play_advice_for_intervention(
		-- It is said that the goddess Ladrielle watches over all Asur that enter the Mists of Yvresse. 
		-- By performing a sacred rite in her name, the Mists’ power will be temporarily amplified.
		"wh2_dlc15.camp.advice.hef.mist_of_yvresse.001"
	);
end;

---------------------------------------------------------------
--
--	Mists of Yvresse - Rite Activated
--
---------------------------------------------------------------

-- intervention declaration
in_mists_of_yvresse_activated = intervention:new(
	"in_mists_of_yvresse_activated",								-- string name
	20,	 															-- cost
	function() trigger_in_mists_of_yvresse_activated() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_mists_of_yvresse_activated:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_mists_of_yvresse_activated:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.mist_of_yvresse.002");

in_mists_of_yvresse_activated:add_trigger_condition(
	"RitualCompletedEvent",
	function(context)
		return context:ritual():ritual_key() == "wh2_dlc15_ritual_hef_ladrielle";
	end	
);

function trigger_in_mists_of_yvresse_activated()
	in_mists_of_yvresse_activated:play_advice_for_intervention(
		-- The Mists may be restored, but more can be done to increase their potency. 
		-- Increasing Yvresse’s defences will further the Mists’ reach, while repairing the Waystone within Athel Tamarha will amplify their power.
		"wh2_dlc15.camp.advice.hef.mist_of_yvresse.002"
	);
end;

---------------------------------------------------------------
--
--	Yvresse Defence - Introduction
--
---------------------------------------------------------------

-- intervention declaration
in_yvresse_defence_introduction = intervention:new(
	"in_yvresse_defence_introduction",								-- string name
	20,	 															-- cost
	function() trigger_in_yvresse_defence_introduction() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_yvresse_defence_introduction:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_yvresse_defence_introduction:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.yvresse_defences.001");

in_yvresse_defence_introduction:add_trigger_condition(
	"ScriptEventPlayerStartsOpenCampaignFromNormal",
	true
);

function trigger_in_yvresse_defence_introduction()
	in_yvresse_defence_introduction:play_advice_for_intervention(
		-- Tor Yvresse still reels from Grom’s last invasion, the city a shadow of its prior grandeur. 
		-- Rebuilding it and improving Athel Tamarha’s facilities will increase Yvresse’s defences, renew the Mists and reinvigorate the city.
		"wh2_dlc15.camp.advice.hef.yvresse_defences.001",
		{
			"wh2_dlc15.camp.advice.athel_tamarha.info_001",
			"wh2_dlc15.camp.advice.athel_tamarha.info_002",
			"wh2_dlc15.camp.advice.athel_tamarha.info_003"
		}
		
	);
end;

---------------------------------------------------------------
--
--	Yvresse Defence - Reminder
--
---------------------------------------------------------------

-- intervention declaration
in_yvresse_defence_reminder = intervention:new(
	"in_yvresse_defence_reminder",								-- string name
	20,	 															-- cost
	function() trigger_in_yvresse_defence_reminder() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_yvresse_defence_reminder:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_yvresse_defence_reminder:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.yvresse_defences.002");

in_yvresse_defence_reminder:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local faction = context:faction();
		local turn = cm:turn_number();
		return turn > 5 and faction:name() == cm:get_local_faction_name();
	end
);

function trigger_in_yvresse_defence_reminder()
	in_yvresse_defence_reminder:play_advice_for_intervention(
		-- Yvresse still lies exposed, Warden! The Mists are in a weakened state and in dire need of restoration. 
		-- Do not delay – increase Yvresse’s defences using Athel Tamarha or by bolstering your capital. 
		"wh2_dlc15.camp.advice.hef.yvresse_defences.002"
	);
end;

---------------------------------------------------------------
--
--	Yvresse Defence - Defence Increased 1
--
---------------------------------------------------------------

-- intervention declaration
in_yvresse_defence_increased_1 = intervention:new(
	"in_yvresse_defence_increased_1",								-- string name
	20,	 															-- cost
	function() trigger_in_yvresse_defence_increased_1() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_yvresse_defence_increased_1:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_yvresse_defence_increased_1:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.yvresse_defences.003");

in_yvresse_defence_increased_1:add_trigger_condition(
	"ScriptEventYvresseDefenceOne",
	true
);

function trigger_in_yvresse_defence_increased_1()
	in_yvresse_defence_increased_1:play_advice_for_intervention(
		-- Well done, Warden! You have increased Yvresse’s defences and restored the Mists' effects. 
		-- Your forces can now move through your capital’s region with greater ease, while enemies will suffer casualties there as they lose their way in the murk.
		"wh2_dlc15.camp.advice.hef.yvresse_defences.003"
	);
end;

---------------------------------------------------------------
--
--	Yvresse Defence - Defence Increased 2
--
---------------------------------------------------------------

-- intervention declaration
in_yvresse_defence_increased_2 = intervention:new(
	"in_yvresse_defence_increased_2",								-- string name
	20,	 															-- cost
	function() trigger_in_yvresse_defence_increased_2() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_yvresse_defence_increased_2:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_yvresse_defence_increased_2:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.yvresse_defences.004");

in_yvresse_defence_increased_2:add_trigger_condition(
	"ScriptEventYvresseDefenceTwo",
	true
);

function trigger_in_yvresse_defence_increased_2()
	in_yvresse_defence_increased_2:play_advice_for_intervention(
		-- Yvresse’s defences have been increased again, Warden, furthering the Mists' reach. All controlled regions of Yvresse are now protected by their enchantments, bolstering our forces there. 
		-- Rebuilding efforts within Tor Yvresse itself also make good progress.
		"wh2_dlc15.camp.advice.hef.yvresse_defences.004"
	);
end;

---------------------------------------------------------------
--
--	Yvresse Defence - Defence Increased 3
--
---------------------------------------------------------------

-- intervention declaration
in_yvresse_defence_increased_3 = intervention:new(
	"in_yvresse_defence_increased_3",								-- string name
	20,	 															-- cost
	function() trigger_in_yvresse_defence_increased_3() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_yvresse_defence_increased_3:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_yvresse_defence_increased_3:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.yvresse_defences.005");

in_yvresse_defence_increased_3:add_trigger_condition(
	"ScriptEventYvresseDefenceThree",
	true
);

function trigger_in_yvresse_defence_increased_3()
	in_yvresse_defence_increased_3:play_advice_for_intervention(
		-- You have successfully increased Yvresse defences to their maximum. Your allies on the outer regions of Ulthuan thank you, for the Mists now protect their lands too. 
		-- The enemies of the Asur will now think twice before encroaching on your sacred soil!
		"wh2_dlc15.camp.advice.hef.yvresse_defences.005"
	);
end;

---------------------------------------------------------------
--
--	Athel Tamarha - First Time Opening Panel
--
---------------------------------------------------------------

-- intervention declaration
in_athel_tamarha_panel_open = intervention:new(
	"in_athel_tamarha_panel_open",								-- string name
	0,	 														-- cost
	function() trigger_in_athel_tamarha_panel_open() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_athel_tamarha_panel_open:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_athel_tamarha_panel_open:set_wait_for_fullscreen_panel_dismissed(false);
in_athel_tamarha_panel_open:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.athel_tamara.001");

in_athel_tamarha_panel_open:add_trigger_condition(
	"ScriptEventAthelTamarhaPanelOpened",
	true
);

function trigger_in_athel_tamarha_panel_open()
	in_athel_tamarha_panel_open:play_advice_for_intervention(
		-- The secret citadel of Athel Tamarha enables you to improve your capacity to protect Yvresse, Warden. 
		-- Many of its facilities lie in ruin, so use your supplies to make it fully operational once more.
		"wh2_dlc15.camp.advice.hef.athel_tamara.001", 
		{
			"wh2_dlc15.camp.advice.athel_tamarha.info_001",
			"wh2_dlc15.camp.advice.athel_tamarha.info_002",
			"wh2_dlc15.camp.advice.athel_tamarha.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Athel Tamarha - First Mistwalker Recruited
--
---------------------------------------------------------------

-- intervention declaration
in_athel_tamarha_mistwalker = intervention:new(
	"in_athel_tamarha_mistwalker",								-- string name
	0,	 														-- cost
	function() trigger_in_athel_tamarha_mistwalker() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_athel_tamarha_mistwalker:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_athel_tamarha_mistwalker:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.athel_tamara.002");

in_athel_tamarha_mistwalker:add_trigger_condition(
	"UnitTrained",
	function(context)
		return context:unit():unit_key():find("wh2_dlc15_hef_inf_mistwalkers_");
	end
);

function trigger_in_athel_tamarha_mistwalker()
	in_athel_tamarha_mistwalker:play_advice_for_intervention(
		-- A regiment of Mistwalkers has been recruited – a great boon to your forces. 
		-- This advanced class of warriors have better equipment and training than regular troops, which can be further improved in Athel Tamarha.
		"wh2_dlc15.camp.advice.hef.athel_tamara.002"
	);
end;

---------------------------------------------------------------
--
--	Athel Tamarha - First Prisoner Captured
--
---------------------------------------------------------------

-- intervention declaration
in_athel_tamarha_prisoner = intervention:new(
	"in_athel_tamarha_prisoner",							-- string name
	0,	 													-- cost
	function() trigger_in_athel_tamarha_prisoner() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 							-- show debug output
);

in_athel_tamarha_prisoner:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_athel_tamarha_prisoner:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.athel_tamara.003");

in_athel_tamarha_prisoner:add_trigger_condition(
	"IncidentOccuredEvent",
	function(context)
		return context:dilemma():find("wh2_dlc15_incident_hef_prisoner_captured") and context:faction():name() == cm:get_local_faction_name();
	end
);

function trigger_in_athel_tamarha_prisoner()
	in_athel_tamarha_prisoner:play_advice_for_intervention(
		-- You have successfully captured one of the enemy, Warden! The prisoner is being detained in Athel Tamarha, where you can act against them to help your cause.
		"wh2_dlc15.camp.advice.hef.athel_tamara.003"
	);
end;

---------------------------------------------------------------
--
--	Athel Tamarha - First Prisoner Action Taken
--
---------------------------------------------------------------

-- intervention declaration
in_athel_tamarha_prison_action = intervention:new(
	"in_athel_tamarha_prison_action",							-- string name
	0,	 														-- cost
	function() trigger_in_athel_tamarha_prison_action() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_athel_tamarha_prison_action:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_athel_tamarha_prison_action:set_wait_for_fullscreen_panel_dismissed(false);
in_athel_tamarha_prison_action:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.athel_tamara.004");

in_athel_tamarha_prison_action:add_trigger_condition(
	"PrisonActionTakenEvent",
	true
);

function trigger_in_athel_tamarha_prison_action()
	in_athel_tamarha_prison_action:play_advice_for_intervention(
		-- The Warden’s duties are not for the faint-hearted, but you have done what is necessary and taken action against one of your prisoners. 
		-- Though your intentions are for the greater good, time will tell whether your chosen measures were justified.
		"wh2_dlc15.camp.advice.hef.athel_tamara.004"
	);
end;

---------------------------------------------------------------
--
--	Athel Tamarha - First Athel Tamarha Upgrade
--
---------------------------------------------------------------

-- intervention declaration
in_athel_tamarha_upgrade = intervention:new(
	"in_athel_tamarha_upgrade",									-- string name
	0,	 														-- cost
	function() trigger_in_athel_tamarha_upgrade() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_athel_tamarha_upgrade:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_athel_tamarha_upgrade:set_wait_for_fullscreen_panel_dismissed(false);
in_athel_tamarha_upgrade:add_advice_key_precondition("wh2_dlc15.camp.advice.hef.athel_tamara.005");

in_athel_tamarha_upgrade:add_trigger_condition(
	"RitualCompletedEvent",
	function(context)
		return context:ritual():ritual_category() == "ATHEL_TAMARHA_RITUAL";
	end
);

function trigger_in_athel_tamarha_upgrade()
	in_athel_tamarha_upgrade:play_advice_for_intervention(
		-- A prudent course of action, Warden! Every repair and improvement to Athel Tamarha's facilities will aid you in the fight against Ulthuan’s enemies.
		"wh2_dlc15.camp.advice.hef.athel_tamara.005"
	);
end;

---------------------------------------------------------------
--
--	Grom's Waaagh! - Introduction
--
---------------------------------------------------------------

-- intervention declaration
in_groms_waaagh = intervention:new(
	"in_groms_waaagh",												-- string name
	20,	 															-- cost
	function() trigger_in_groms_waaagh() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_groms_waaagh:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_groms_waaagh:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.groms_waaagh.001");

in_groms_waaagh:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
			return false;
	end
);

function trigger_in_groms_waaagh()
	in_groms_waaagh:play_advice_for_intervention(
		-- Tor Yvresse is your ultimate prize, but do not be hasty! First build up your strength and follow the guidance of your Shaman’s head before making the crossing. 
		-- The Warden will be waiting, protected by the Mists that blanket his realm.
		"wh2_dlc15.camp.advice.grn.groms_waaagh.001"		
	);
end;

---------------------------------------------------------------
--
--	Food Merchant - First Appears
--
---------------------------------------------------------------

-- intervention declaration
in_food_merchant_first_appears = intervention:new(
	"in_food_merchant_first_appears",												-- string name
	20,	 																			-- cost
	function() trigger_in_food_merchant_first_appears() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_food_merchant_first_appears:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_food_merchant_first_appears:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.food_merchant.001");

in_food_merchant_first_appears:add_trigger_condition(
	"ScriptEventFoodMerchantSpawned",
	true
);

function trigger_in_food_merchant_first_appears()
	in_food_merchant_first_appears:play_advice_for_intervention(
		-- A food merchant has appeared nearby, a River Troll Hag drawn close by the smell of your simmering cauldron. The net slung over her shoulder is sure to contain some exotic ingredients, or she may offer you other 'off-the-menu' rewards.
		"wh2_dlc15.camp.advice.grn.food_merchant.001"		
	);
end;

---------------------------------------------------------------
--
--	Food Merchant - Dilemma
--
---------------------------------------------------------------

-- intervention declaration
in_food_merchant_dilemma = intervention:new(
	"in_food_merchant_dilemma",												-- string name
	20,	 																	-- cost
	function() trigger_in_food_merchant_dilemma() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_food_merchant_dilemma:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_food_merchant_dilemma:set_wait_for_dilemma(false);
in_food_merchant_dilemma:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.food_merchant.002");

in_food_merchant_dilemma:add_trigger_condition(
	"DilemmaIssuedEvent",
	function(context)
		return context:dilemma():find("wh2_dlc15_dilemma_food_merchant_") and context:faction():name() == cm:get_local_faction_name();
	end
);

function trigger_in_food_merchant_dilemma()
	in_food_merchant_dilemma:play_advice_for_intervention(
		-- Food merchants are mystical creatures with strange powers and even stranger cooking ingredients. She can sell you her disgusting foodstuffs or meddle in your recipes, but also challenges you to cook for her in return for great rewards.
		"wh2_dlc15.camp.advice.grn.food_merchant.002"		
	);
end;

---------------------------------------------------------------
--
--	Grom's Cauldron - First Time Opening Panel
--
---------------------------------------------------------------

-- intervention declaration
in_groms_cauldron_panel_open = intervention:new(
	"in_groms_cauldron_panel_open",								-- string name
	0,	 														-- cost
	function() trigger_in_groms_cauldron_panel_open() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_groms_cauldron_panel_open:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_groms_cauldron_panel_open:set_wait_for_fullscreen_panel_dismissed(false);
in_groms_cauldron_panel_open:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.groms_cauldron.001");

in_groms_cauldron_panel_open:add_trigger_condition(
	"ScriptEventGromsCauldronPanelOpened",
	true
);

function trigger_in_groms_cauldron_panel_open()
	in_groms_cauldron_panel_open:play_advice_for_intervention(
		-- You are an insatiable eater, mighty lord, and your minions are no different. 
		-- Collecting ingredients and throwing them in your special cauldron can imbue you and the tribe with nutritious rewards, with more exotic recipes bestowing even greater powers.
		"wh2_dlc15.camp.advice.grn.groms_cauldron.001", 
		{
			"wh2_dlc15.camp.advice.groms_cauldron.info_001",
			"wh2_dlc15.camp.advice.groms_cauldron.info_002",
			"wh2_dlc15.camp.advice.groms_cauldron.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Grom's Cauldron - First Ingredient Unlocked
--
---------------------------------------------------------------

-- intervention declaration
in_groms_cauldron_ingredient = intervention:new(
	"in_groms_cauldron_ingredient",								-- string name
	0,	 														-- cost
	function() trigger_in_groms_cauldron_ingredient() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_groms_cauldron_ingredient:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_groms_cauldron_ingredient:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.groms_cauldron.002");

in_groms_cauldron_ingredient:add_trigger_condition(
	"IngredientUnlocked",
	true
);

function trigger_in_groms_cauldron_ingredient()
	in_groms_cauldron_ingredient:play_advice_for_intervention(
		-- You have uncovered a new cooking ingredient, my lord! Extract its benefits by tossing it into the cauldron, or combine it with other ingredients to create more potent recipes.
		"wh2_dlc15.camp.advice.grn.groms_cauldron.002"
	);
end;

---------------------------------------------------------------
--
--	Grom's Cauldron - First Recipe Unlocked
--
---------------------------------------------------------------

-- intervention declaration
in_groms_cauldron_recipe = intervention:new(
	"in_groms_cauldron_recipe",									-- string name
	0,	 														-- cost
	function() trigger_in_groms_cauldron_recipe() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_groms_cauldron_recipe:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_groms_cauldron_recipe:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.groms_cauldron.003");

in_groms_cauldron_recipe:add_trigger_condition(
	"FactionCookedDish",
	true
);

function trigger_in_groms_cauldron_recipe()
	in_groms_cauldron_recipe:play_advice_for_intervention(
		-- You have successfully cooked your first recipe! The benefits of its unique combination of ingredients will wear off once the cauldron is depleted, but a new recipe can be prepared at any time to replace the current effects.
		"wh2_dlc15.camp.advice.grn.groms_cauldron.003"
	);
end;

---------------------------------------------------------------
--
--	Salvage - Post Battle First Salvage
--
---------------------------------------------------------------

-- intervention declaration
in_salvage_post_battle = intervention:new(
	"in_salvage_post_battle",									-- string name
	0,	 														-- cost
	function() trigger_in_salvage_post_battle() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_salvage_post_battle:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_salvage_post_battle:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.salvage.001");
in_salvage_post_battle:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_salvage_post_battle:add_trigger_condition(
	"ScriptEventPlayerWinsBattle",
	function()
		return true;
	end
);

function trigger_in_salvage_post_battle()
	in_salvage_post_battle:play_advice_for_intervention(
		-- You have obtained some scrap, my lord! The spoils of war are not just the looted wealth of defeated foes, but also scrap materials from their weapons and armour, which can be repurposed to equip your own troops.
		"wh2_dlc15.camp.advice.grn.salvage.001", 
		{
			"wh2_dlc15.camp.advice.scrap.info_001",
			"wh2_dlc15.camp.advice.scrap.info_002",
			"wh2_dlc15.camp.advice.scrap.info_003"
		}
	);
end;

---------------------------------------------------------------
--
--	Salvage - Army Selected After Salvage Acquired
--
---------------------------------------------------------------

-- intervention declaration
in_salvage_acquired = intervention:new(
	"in_salvage_acquired",									-- string name
	0,	 														-- cost
	function() trigger_in_salvage_acquired() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_salvage_acquired:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_salvage_acquired:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.salvage.002");

in_salvage_acquired:add_trigger_condition(
	"CharacterSelectedWithUnitUpgradeUnlockedAndAffordable",
	true
);

function trigger_in_salvage_acquired()
	in_salvage_acquired:play_advice_for_intervention(
		-- Remember that you can use your scrap to fashion better weapons and armour for your mobs – some are a rag-tag bunch which could certainly do with them!
		"wh2_dlc15.camp.advice.grn.salvage.002"
	);
end;

---------------------------------------------------------------
--
--	Salvage - Unit Upgraded
--
---------------------------------------------------------------

-- intervention declaration
in_salvage_upgraded = intervention:new(
	"in_salvage_upgraded",										-- string name
	0,	 														-- cost
	function() trigger_in_salvage_upgraded() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_salvage_upgraded:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_salvage_upgraded:add_advice_key_precondition("wh2_dlc15.camp.advice.grn.salvage.003");

in_salvage_upgraded:add_trigger_condition(
	"UnitEffectPurchased",
	true
);

function trigger_in_salvage_upgraded()
	in_salvage_upgraded:play_advice_for_intervention(
		-- Such ingenuity, my lord! Using your scrap, you have successfully improved your battle capabilities. It is the mark of a most resourceful Warboss to not waste good scrap materials, from whomever they may have been pilfered.
		"wh2_dlc15.camp.advice.grn.salvage.003"
	);
end;

---------------------------------------------------------------
--
--	Forge of Daith - Turn 3 Incident
--
---------------------------------------------------------------

-- intervention declaration
in_forge_of_daith = intervention:new(
	"in_forge_of_daith",										-- string name
	0,	 														-- cost
	function() trigger_in_forge_of_daith() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_forge_of_daith:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_forge_of_daith:add_advice_key_precondition("wh2_dlc16.camp.advice.wef.forge_of_daith.001");
in_forge_of_daith:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_forge_of_daith:add_trigger_condition(
	"ScriptEventForgeOfDaithFirstIncident",
	true
);

function trigger_in_forge_of_daith()
	in_forge_of_daith:play_advice_for_intervention(
		-- The master smith of Vaul's Anvil, Daith, has crafted special items for you. He will periodically approach you with the choice of crafting new items or upgrading your existing items.
		"wh2_dlc16.camp.advice.wef.forge_of_daith.001", 
		{
			"wh2_dlc16.camp.advice.forge_of_daith.info_001",
			"wh2_dlc16.camp.advice.forge_of_daith.info_002",
			"wh2_dlc16.camp.advice.forge_of_daith.info_003"
		}
	);
end;


---------------------------------------------------------------
--
--	Worldroots - Pacification
--
---------------------------------------------------------------

-- intervention declaration
in_worldroots_pacification = intervention:new(
	"in_worldroots_pacification",								-- string name
	0,	 														-- cost
	function() trigger_in_worldroots_pacification() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_worldroots_pacification:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_worldroots_pacification:add_advice_key_precondition("wh2_dlc16.camp.advice.wef.worldroots.001.pacification");
in_worldroots_pacification:give_priority_to_intervention("in_post_normal_battle_victory_options");

in_worldroots_pacification:add_trigger_condition(
	"ScriptEventPlayerWinsFieldBattle",
	true
);

function trigger_in_worldroots_pacification()
	in_worldroots_pacification:play_advice_for_intervention(
		-- Defeating this army has benefited the local forest. To help it heal fully, ensure that the surrounding regions are controlled by you or an ally, or simply raze them. Hostile borders will always cause a forest to suffer.
		"wh2_dlc16.camp.advice.wef.worldroots.001.pacification"
	);
end;

---------------------------------------------------------------
--
--	Worldroots - Oak of Ages
--
---------------------------------------------------------------

-- intervention declaration
in_worldroots_oak_of_ages = intervention:new(
	"in_worldroots_oak_of_ages",							-- string name
	0,	 													-- cost
	function() trigger_in_worldroots_oak_of_ages() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 							-- show debug output
);

in_worldroots_oak_of_ages:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_worldroots_oak_of_ages:add_advice_key_precondition("wh2_dlc16.camp.advice.wef.worldroots.002.athel_loren");
in_worldroots_oak_of_ages:give_priority_to_intervention("in_oak_of_ages");

--Make sure this only fires in Mortal Empires when you are playing as Wood Elves, using the intervention:start() function to manage that
in_worldroots_oak_of_ages:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	true
);

function trigger_in_worldroots_oak_of_ages()
	in_worldroots_oak_of_ages:play_advice_for_intervention(
		-- Although Athel Loren and the Oak of Ages are of utmost importance to your kind, restoring the great forest will require a much greater healing effort than of anywhere else. However, healing other forests will also contribute to Athel Loren’s health.
		"wh2_dlc16.camp.advice.wef.worldroots.002.athel_loren"
	);
end;

---------------------------------------------------------------
--
--	Worldroots - Markers
--
---------------------------------------------------------------

-- intervention declaration
in_worldroots_markers = intervention:new(
	"in_worldroots_markers",								-- string name
	0,	 													-- cost
	function() trigger_in_worldroots_markers() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 							-- show debug output
);

in_worldroots_markers:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_worldroots_markers:add_advice_key_precondition("wh2_dlc16.camp.advice.wef.worldroots.003.forest_encounters");
in_worldroots_markers:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_worldroots_markers:add_trigger_condition(
	"ScriptEventMarkerSpawned",
	function(context)
		-- The reliance on key-searching here isn't ideal and could potentially end up encompassing markers with 'invasion' in the name that aren't specifically worldroot-related.
		-- But that'd be an extensive change.
		local is_worldroots_intro_invasion = (context.string:find("invasion") and context.string:find("intro")) ~= nil

		if is_worldroots_intro_invasion then
			in_worldroots_markers.x = context.stored_table[1];
			in_worldroots_markers.y = context.stored_table[2];
		end

		return is_worldroots_intro_invasion
	end	
);

function trigger_in_worldroots_markers()
	local region_name = nil;

	local region_data = cm:model():world():region_data_at_position(in_worldroots_markers.x, in_worldroots_markers.y);
	if region_data ~= nil and not region_data:is_null_interface() and not region_data:is_sea() then
		region_name = region_data:key();
	end
	out("Found region!: " .. tostring(region_name));

	local x_coord, y_coord = cm:log_to_dis(in_worldroots_markers.x, in_worldroots_markers.y);
	-- A threat to the forest has appeared nearby! Aggressions against the forest are not uncommon, but some threats are more pressing than others. This particular attack is imminent!  Send an army to disrupt these aggressors before they reach full strength.
	local advice_key = "wh2_dlc16.camp.advice.wef.worldroots.003.forest_encounters";
	
	in_worldroots_markers:scroll_camera_for_intervention(
		region_name,
		x_coord,
		y_coord,
		advice_key
	);


end;

---------------------------------------------------------------
--
--	Worldroots - Button
--
---------------------------------------------------------------

-- intervention declaration
in_worldroots_button = intervention:new(
	"in_worldroots_button",								-- string name
	0,	 													-- cost
	function() trigger_in_worldroots_button() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 							-- show debug output
);

in_worldroots_button:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_worldroots_button:add_advice_key_precondition("wh2_dlc16.camp.advice.wef.worldroots.004.worldroots");
in_worldroots_button:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_worldroots_button:add_trigger_condition(
	"ScriptEventWorldrootsButtonClicked",
	true
);

in_worldroots_button:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()			
		--Using turn_number here instead of the setmin_turn intervention function because we have 2 trigger conditions and if the players clicks the button on turn 1 we want to play the advice on click as well
		local turn_number = cm:turn_number();
		return turn_number > 3;
	end	
);

function trigger_in_worldroots_button()
	local uic_worldroots = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "button_world_roots");
	if not uic_worldroots then
		script_error("ERROR: trigger_in_worldroots_button() could not find the worldroots ui, how can this be?");
		return false;
	end;			
	-- pulse the ui wait 5 seconds, stop pulsing UI
	pulse_uicomponent(uic_worldroots, true, 5);
	cm:callback(function() pulse_uicomponent(uic_worldroots, false, 5) end, 5);
	
	in_worldroots_button:play_advice_for_intervention(
		-- The Worldroots form a network that connects the most important forests of the world. Healing them not only strengthens the Worldroots, but also grants you powerful benefits.
		"wh2_dlc16.camp.advice.wef.worldroots.004.worldroots"
	);
end;

---------------------------------------------------------------
--
--	Worldroots - Teleport
--
---------------------------------------------------------------

-- intervention declaration
in_worldroots_teleport = intervention:new(
	"in_worldroots_teleport",								-- string name
	0,	 													-- cost
	function() trigger_in_worldroots_teleport() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 							-- show debug output
);

in_worldroots_teleport:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_worldroots_teleport:add_advice_key_precondition("wh2_dlc16.camp.advice.wef.worldroots.005.teleportation");
in_worldroots_teleport:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_worldroots_teleport:add_trigger_condition(
	"ScriptEventDeeprootsUnlocked",
	true
);



function trigger_in_worldroots_teleport()
	
	local uic_worldroots = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "button_world_roots");
	if not uic_worldroots then
		script_error("ERROR: trigger_in_worldroots_teleport() could not find the worldroots button, how can this be?");
		return false;
	end;

	local glade_list = {
		"wh3_main_combi_region_the_oak_of_ages",
		"wh3_main_combi_region_the_witchwood",
		"wh3_main_combi_region_gryphon_wood",
		"wh3_main_combi_region_oreons_camp",
		"wh3_main_combi_region_forest_of_gloom",
		"wh3_main_combi_region_the_sacred_pools",
		"wh3_main_combi_region_gaean_vale",
		"wh3_main_combi_region_laurelorn_forest"
	}
	local region_name = "";
	local faction_name = cm:get_local_faction_name();

	if faction_name == "wh_dlc05_wef_wood_elves" or faction_name == "wh_dlc05_wef_argwylon" then
		--No Oak of Ages
		table.remove(glade_list, 1);
		region_name = "wh3_main_combi_region_the_oak_of_ages";
	elseif faction_name == "wh2_dlc16_wef_sisters_of_twilight" then
		--No Witchwood
		table.remove(glade_list, 2);
		region_name = "wh3_main_combi_region_the_witchwood";
	elseif faction_name == "wh2_dlc16_wef_drycha" then
		--No Gryphon Wood
		table.remove(glade_list, 3);
		region_name = "wh3_main_combi_region_gryphon_wood";
	else
		out("How did this faction get here??? - " .. faction_name);
	end

	for i = 1, #glade_list do
		local worldroots_teleport = "worldroots_forest_"..glade_list[i];

		local uic_teleport = find_uicomponent(core:get_ui_root(), "3d_ui_parent", worldroots_teleport, "worldroots_forest_actual", "button_teleport");

		-- if the script can't find the teleport button just ignore it and move on, otherwise chance of soft lock.
		if uic_teleport ~= false  then
			-- pulse the ui wait 5 seconds, stop pulsing UI
			pulse_uicomponent(uic_teleport, true, 5);
			cm:callback(function() pulse_uicomponent(uic_teleport, false, 5) end, 5);
		end;		
	end

	-- The deepest Worldroots are known as the Deeproots, which your forces can uses to travel great distances. Any army in a forest region can travel to another, but after traversing the Deeproots it will be some time before another journey can be made.
	local advice_key = "wh2_dlc16.camp.advice.wef.worldroots.005.teleportation"

	
	in_worldroots_teleport:play_advice_for_intervention(
		advice_key
	);
end;

---------------------------------------------------------------
--
--	Worldroots - Amber
--
---------------------------------------------------------------

-- intervention declaration
in_worldroots_amber = intervention:new(
	"in_worldroots_amber",									-- string name
	0,	 													-- cost
	function() trigger_in_worldroots_amber() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 							-- show debug output
);

in_worldroots_amber:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_worldroots_amber:add_advice_key_precondition("wh2_dlc16.camp.advice.wef.worldroots.006.amber");

in_worldroots_amber:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return context:faction():pooled_resource_manager():resource("wef_amber"):value() > 0;
	end
);

function trigger_in_worldroots_amber()
	local uic_tech = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "button_technology");
	local uic_amber = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar", "canopic_jars_holder");	
	if not uic_tech then
		script_error("ERROR: trigger_in_worldroots_amber() could not find the technology button, how can this be?");
		return false;
	end;		
	if not uic_amber then
		script_error("ERROR: trigger_in_worldroots_amber() could not find the amber ui, how can this be?");
		return false;
	end;
	-- pulse the ui wait 5 seconds, stop pulsing UI
	pulse_uicomponent(uic_tech, true, 5);
	pulse_uicomponent(uic_amber, true, 5);
	cm:callback(function() pulse_uicomponent(uic_tech, false, 5) end, 5);
	cm:callback(function() pulse_uicomponent(uic_amber, false, 5) end, 5);
	
	in_worldroots_amber:play_advice_for_intervention(
		-- You have obtained some Amber. Offer it to the spirits of the Elders through your research of technologies in return for their blessings. Amber can be gained by completing Rituals of Rebirth after healing forests, but is a limited resource, so spend it wisely.
		"wh2_dlc16.camp.advice.wef.worldroots.006.amber"
	);
end;

---------------------------------------------------------------
--
--	Worldroots - Ritual of Rebirth
--
---------------------------------------------------------------

-- intervention declaration
in_worldroots_rebirth = intervention:new(
	"in_worldroots_rebirth",									-- string name
	0,	 													-- cost
	function() trigger_in_worldroots_rebirth() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 							-- show debug output
);

in_worldroots_rebirth:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_worldroots_rebirth:add_advice_key_precondition("wh2_dlc16.camp.advice.wef.worldroots.007.ritual_available");

in_worldroots_rebirth:add_trigger_condition(
	"ScriptEventForestRitualAvailable",
	function(context)
		in_worldroots_rebirth.region = context.string;
		return true;
	end
);

function trigger_in_worldroots_rebirth()

	local region_name = in_worldroots_rebirth.region;

	local worldroots_ritual = "label_settlement:"..region_name;
	
	local uic_ritual = find_uicomponent(core:get_ui_root(), "3d_ui_parent", worldroots_ritual, "worldroots_forest_actual", "button_ritual");
	
	--- sometimes game can't find bits of the 3DUI - in this case, don't do any fancy stuff, just pan the camera, or we risk a soft lock
	if uic_ritual ~= false then
		--Simulate click on ritual button so that the start ritual button shows
		uic_ritual:SimulateLClick()
		local uic_perform_ritual = find_uicomponent(core:get_ui_root(), "3d_ui_parent", worldroots_ritual, "worldroots_forest_actual", "ritual_panel", "button_perform_ritual");	
		if uic_perform_ritual ~= false then
			pulse_uicomponent(uic_ritual, true, 5);
			pulse_uicomponent(uic_perform_ritual, true, 5);
			cm:callback(function() pulse_uicomponent(uic_ritual, false, 5) end, 5);
			cm:callback(function() pulse_uicomponent(uic_perform_ritual, false, 5) end, 5);
		else
			script_error("ERROR: trigger_in_worldroots_rebirth() could not find the worldroots perform ritual button, how can this be?");
		end;
	else
		script_error("ERROR: trigger_in_worldroots_rebirth() could not find the worldroots ritual button, how can this be?");
	end;


	-- Well done! This forest’s health has improved enough to enable a Ritual of Rebirth, which will permanently guarantee its rejuvenation. But beware – hostile forces will attempt to disrupt the ritual once it begins.
	local advice_key = "wh2_dlc16.camp.advice.wef.worldroots.007.ritual_available"
	
	in_worldroots_rebirth:scroll_camera_to_settlement_for_intervention(
		region_name,
		advice_key
	);
end;

---------------------------------------------------------------
--
--	Worldroots - Invasions
--
---------------------------------------------------------------

-- intervention declaration
in_worldroots_invasions = intervention:new(
	"in_worldroots_invasions",								-- string name
	0,	 													-- cost
	function() trigger_in_worldroots_invasions() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 							-- show debug output
);

in_worldroots_invasions:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_worldroots_invasions:add_advice_key_precondition("wh2_dlc16.camp.advice.wef.worldroots.008.ritual_begun");
in_worldroots_invasions:add_whitelist_event_type("scripted_persistent_eventevent_feed_target_faction");

in_worldroots_invasions:add_trigger_condition(
	"ScriptEventMarkerSpawned",
	function(context)
		-- The reliance on key-searching here isn't ideal and could potentially end up encompassing markers with 'invasion' in the name that aren't specifically worldroot-related.
		-- But that'd be an extensive change.
		local is_worldroots_ritual_invasion = context.string:find("invasion") and not context.string:find("intro")

		if is_worldroots_ritual_invasion then
			in_worldroots_invasions.ref = context.string;
			in_worldroots_invasions.x = context.stored_table[1];
			in_worldroots_invasions.y = context.stored_table[2];
		end

		return is_worldroots_ritual_invasion
	end	
);

function trigger_in_worldroots_invasions()
	local x_coord, y_coord = cm:log_to_dis(in_worldroots_invasions.x, in_worldroots_invasions.y);
	-- Enemies muster nearby to disrupt the ritual! They can be weakened if attacked before the appearance of their forces, even if the ensuing battle is lost. The ritual cannot be stopped, but you will receive additional rewards if you control the forest at its conclusion.
	local advice_key = "wh2_dlc16.camp.advice.wef.worldroots.008.ritual_begun";
	
	in_worldroots_invasions:scroll_camera_for_intervention(
		"wh3_main_combi_region_the_oak_of_ages", -- need to pass the scroll_camera_for_intervention a region to lift the shroud, we don't actually need to lift the shroud so just pass Oak of Ages
		x_coord,
		y_coord,
		advice_key
	);

end;

---------------------------------------------------------------
--
--	Aspects
--
---------------------------------------------------------------

-- intervention declaration
in_aspects = intervention:new(
	"in_aspects",									-- string name
	0,	 											-- cost
	function() trigger_in_aspects() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 					-- show debug output
);

in_aspects:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_aspects:set_min_turn(3);
in_aspects:add_advice_key_precondition("wh2_dlc16.camp.advice.wef.drycha.001.aspects");

in_aspects:add_trigger_condition(
	"CharacterSelected",
	function(context)
		local faction = context:character():faction();
		if faction:name() == cm:get_local_faction_name() then
			local treasury = faction:treasury();
			if context:character():has_military_force() then
				local mf = context:character():military_force();	
				local unit_list = mf:unit_list();
				for i = 0, unit_list:num_items() - 1 do
					local unit = unit_list:item_at(i);
					if unit:unit_key():find("dryads") then
						in_aspects.unit_pos = i + 1;
						return treasury >= 500; 
					end
				end
			end
		end
		return false;
	end
);

function trigger_in_aspects()
	
	local uic_unit = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "units", "LandUnit "..in_aspects.unit_pos);
	
	if not uic_unit then
		script_error("ERROR: trigger_in_aspects() could not find the unit refrenced, how can this be?");
		return false;
	end;

	-- pulse the ui wait 5 seconds, stop pulsing UI
	pulse_uicomponent(uic_unit, true, 5);
	cm:callback(function() pulse_uicomponent(uic_unit, false, 5) end, 5);
	
	in_aspects:play_advice_for_intervention(
		-- Mighty Tree Spirit, the others who walk in your stead can be gifted Aspects of the Elders, granting them benefits that will improve their battle capabilities.
		"wh2_dlc16.camp.advice.wef.drycha.001.aspects"
	);
end;

---------------------------------------------------------------
--
--	Wild Spirits
--
---------------------------------------------------------------

-- intervention declaration
in_wild_spirits = intervention:new(
	"in_wild_spirits",									-- string name
	0,	 											-- cost
	function() trigger_in_wild_spirits() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 					-- show debug output
);

in_wild_spirits:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_wild_spirits:set_min_turn(2);
in_wild_spirits:add_advice_key_precondition("wh2_dlc16.camp.advice.wef.drycha.002.forest_spirits");

in_wild_spirits:add_trigger_condition(
	"CharacterSelected",
	function(context)
		local faction = context:character():faction();
		if faction:name() == cm:get_local_faction_name() then
			return context:character():has_military_force();
		end
		return false;
	end
);

function trigger_in_wild_spirits()
	
	local uic_ws = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "hud_center", "small_bar", "button_group_army", "button_mercenaries");
	
	if not uic_ws then
		script_error("ERROR: trigger_in_wild_spirits() could not find the wild spirits pool referenced, how can this be?");
		return false;
	end;

	-- pulse the ui wait 5 seconds, stop pulsing UI
	pulse_uicomponent(uic_ws, true, 5, false, "active");
	cm:callback(function()
		uic_ws = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "hud_center", "small_bar", "button_group_army", "button_mercenaries");

		if(uic_ws ~= nil) then
			pulse_uicomponent(uic_ws, false, 5, false, "active") 
		end
	end, 5);

	--Open panel if it isn't already
	cm:callback(function() 
		uic_ws = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "hud_center", "small_bar", "button_group_army", "button_mercenaries");
		if(uic_ws ~= nil and uic_ws:Visible(true) == true and uic_ws:CurrentState() ~= "selected" and uic_ws:CurrentState() ~= "selected_hover") then
			uic_ws:SimulateLClick(); 
		end
	end, 2);	

	in_wild_spirits:play_advice_for_intervention(
		-- The forest lends its fauna to your cause wherever you roam, ancient one. A limited number of wild beasts and forest spirits can be swiftly summoned to your side, even when in enemy territory.
		"wh2_dlc16.camp.advice.wef.drycha.002.forest_spirits"
	);
end;

---------------------------------------------------------------
--
--	Spites
--
---------------------------------------------------------------

-- intervention declaration
in_spites = intervention:new(
	"in_spites",									-- string name
	30,	 											-- cost
	function() trigger_in_spites() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 					-- show debug output
);

in_spites:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_spites:add_advice_key_precondition("wh2_dlc16.camp.advice.wef.drycha.003.spites");
in_spites:give_priority_to_intervention("in_lord_creation");

in_spites:add_trigger_condition(
	"ScriptEventRaiseForceButtonClicked",
	true
);

function trigger_in_spites()
	
	in_spites:play_advice_for_intervention(
		-- The malevolent nature of the Tree Spirits who lead your forces is accentuated by their accompanying Spites. These mischievous nature-spirits grant benefits and abilities to the Ancient Treemen whose cracks and hollows they inhabit.
		"wh2_dlc16.camp.advice.wef.drycha.003.spites"
	);
end;

---------------------------------------------------------------
--
--	Flesh Lab - Growth Juice
--
---------------------------------------------------------------

-- intervention declaration
in_flesh_lab_growth_juice = intervention:new(
	"in_flesh_lab_growth_juice",								-- string name
	10,	 														-- cost
	function() trigger_in_flesh_lab_growth_juice() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_flesh_lab_growth_juice:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_flesh_lab_growth_juice:add_advice_key_precondition("wh2_dlc16.camp.advice.skv.flesh_lab.001.growth_juice");
in_flesh_lab_growth_juice:give_priority_to_intervention("in_post_normal_battle_victory_options");

in_flesh_lab_growth_juice:add_trigger_condition(
	"ScriptEventPlayerWinsBattle",
	true
);

function trigger_in_flesh_lab_growth_juice()
	
	in_flesh_lab_growth_juice:play_advice_for_intervention(
		-- You have gained some Growth Juice, my lord! It is concocted from the bodily extracts of your defeated enemies’ cadavers and fed into the Growth Vat, where abominable things are grown. Over time, Growth Juice gradually increases in quantity of its own accord.
		"wh2_dlc16.camp.advice.skv.flesh_lab.001.growth_juice"
	);
end;

---------------------------------------------------------------
--
--	Flesh Lab - Monster Packs
--
---------------------------------------------------------------

-- intervention declaration
in_flesh_lab_monster_pack = intervention:new(
	"in_flesh_lab_monster_pack",								-- string name
	10,	 														-- cost
	function() trigger_in_flesh_lab_monster_pack() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_flesh_lab_monster_pack:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_flesh_lab_monster_pack:add_advice_key_precondition("wh2_dlc16.camp.advice.skv.flesh_lab.002.monster_packs");

in_flesh_lab_monster_pack:add_trigger_condition(
	"IncidentOccuredEvent",
	function(context)
		return context:dilemma():find("wh2_dlc16_skv_throt_flesh_lab_batch_available");
	end
);

function trigger_in_flesh_lab_monster_pack()
	
	in_flesh_lab_monster_pack:play_advice_for_intervention(
		-- Your accumulated Growth Juice has allowed a fully-grown pack of monsters and minions to form within the vat which you can now claim for swift recruitment into your armies. However, collecting even more Growth Juice will allow the growth of more powerful monster packs.
		"wh2_dlc16.camp.advice.skv.flesh_lab.002.monster_packs"
	);
end;

---------------------------------------------------------------
--
--	Flesh Lab - Augment Unlocked
--
---------------------------------------------------------------

-- intervention declaration
in_flesh_lab_augment_unlocked = intervention:new(
	"in_flesh_lab_augment_unlocked",							-- string name
	10,	 														-- cost
	function() trigger_in_flesh_lab_augment_unlocked() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_flesh_lab_augment_unlocked:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_flesh_lab_augment_unlocked:add_advice_key_precondition("wh2_dlc16.camp.advice.skv.flesh_lab.005.augment_unlocked");
in_flesh_lab_augment_unlocked:set_wait_for_fullscreen_panel_dismissed(false);

in_flesh_lab_augment_unlocked:add_trigger_condition(
	"UnitEffectPurchased",
	function(context)
		--Listening for this particular Augment
		local effect_key = context:effect():record_key();
			
		--Throt's starting Wolf Rats already have mon_aug_0 and mon_aug_2 so if mon_aug_1 is purchased we know 2 augments are unlocked
		if effect_key == "wh2_dlc16_throt_flesh_lab_mon_aug_1" then
			return true;
		--check for the augment being an infantry augment
		elseif effect_key:find("wh2_dlc16_throt_flesh_lab_inf_aug_") then
			local unit = context:unit();
			local effects_list = unit:get_unit_purchased_effects();

			--Loop for all applied effects to this unit
			for i = 0, effects_list:num_items() - 1 do
				local effect_interface = effects_list:item_at(i);
				local effect = effects_list:item_at(i):record_key();
				
				-- inf_aug__1 has to be purchased for any more Augments in the infantry list to be unlocked and if i is greater than 0 that means that either inf_aug_0 or inf_aug_2 must have been purchased as well
				if effect == "wh2_dlc16_throt_flesh_lab_inf_aug_1" and i > 0 then				
					return true;
				end
			end	
		end
		return false;
	end
);

function trigger_in_flesh_lab_augment_unlocked()
	
	in_flesh_lab_augment_unlocked:play_advice_for_intervention(
		-- A new augmentation is available to strengthen your units, my lord! 
		"wh2_dlc16.camp.advice.skv.flesh_lab.005.augment_unlocked"
	);
end;

---------------------------------------------------------------
--
--	Flesh Lab - Lab Upgrades
--
---------------------------------------------------------------

-- intervention declaration
in_flesh_lab_upgrades = intervention:new(
	"in_flesh_lab_upgrades",									-- string name
	10,	 														-- cost
	function() trigger_in_flesh_lab_upgrades() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_flesh_lab_upgrades:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_flesh_lab_upgrades:add_advice_key_precondition("wh2_dlc16.camp.advice.skv.flesh_lab.007.upgrade_lab");
in_flesh_lab_upgrades:set_wait_for_fullscreen_panel_dismissed(false);

in_flesh_lab_upgrades:add_trigger_condition(
	"RitualCompletedEvent",
	function(context)
		return context:ritual():ritual_key():find("wh2_dlc16_throt_flesh_lab_monster");
	end
);

function trigger_in_flesh_lab_upgrades()
	
	in_flesh_lab_upgrades:play_advice_for_intervention(
		-- Upgrade the Flesh Laboratory whenever possible, my lord. 
		"wh2_dlc16.camp.advice.skv.flesh_lab.007.upgrade_lab"
	);
end;


---------------------------------------------------------------
--
--	Rakarth - Monster Pens
--
---------------------------------------------------------------

-- intervention declaration
in_rakarth_monster_pen = intervention:new(
	"in_rakarth_monster_pens",									-- string name
	10,	 														-- cost
	function() trigger_in_rakarth_monster_pen() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_rakarth_monster_pen:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_rakarth_monster_pen:add_advice_key_precondition("wh2_twa03.camp.advice.def.monster_pens.001.monster_pens");

in_rakarth_monster_pen:add_trigger_condition(
	"ScriptEventRakarthBeastIncidentGenerated",
	function(context)
		return true
	end
);

function trigger_in_rakarth_monster_pen()
	
	in_rakarth_monster_pen:play_advice_for_intervention(
		-- monsters go into the monster pens
		"wh2_twa03.camp.advice.def.monster_pens.001.monster_pens"
	);

end;

---------------------------------------------------------------
--
--	Rakarth - Raiding
--
---------------------------------------------------------------

-- intervention declaration
in_rakarth_raiding = intervention:new(
	"in_rakarth_raiding",									-- string name
	25,	 														-- cost
	function() trigger_in_rakarth_raiding() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_rakarth_raiding:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_rakarth_raiding:add_advice_key_precondition("wh2_twa03.camp.advice.def.monster_pens.002.raiding");

in_rakarth_raiding:add_trigger_condition(
	"ScriptEventRakarthBeastIncidentGenerated",
	function(context)
		return true
	end
);

function trigger_in_rakarth_raiding()
	
	in_rakarth_raiding:play_advice_for_intervention(
		-- you can raid for more monsters
		"wh2_twa03.camp.advice.def.monster_pens.002.raiding"
	);
end;


---------------------------------------------------------------
--
--	Rakarth - Settlements
--
---------------------------------------------------------------

-- intervention declaration
in_rakarth_settlements = intervention:new(
	"in_rakarth_settlements",									-- string name
	10,	 														-- cost
	function() trigger_in_rakarth_settlements() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_rakarth_settlements:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_rakarth_settlements:add_advice_key_precondition("wh2_twa03.camp.advice.def.monster_pens.003.settlements");

in_rakarth_settlements:add_trigger_condition(
	"CharacterPerformsSettlementOccupationDecision",
	function(context)
		return context:character():character_subtype("wh2_twa03_def_rakarth")
	end
);

function trigger_in_rakarth_settlements()
	
	in_rakarth_settlements:play_advice_for_intervention(
		-- some creatures can be taken from enemy settlements
		"wh2_twa03.camp.advice.def.monster_pens.003.settlements"
	);
end;


---------------------------------------------------------------
--
--	Rakarth - Rite
--
---------------------------------------------------------------

-- intervention declaration
in_rakarth_rite = intervention:new(
	"in_rakarth_rite",									-- string name
	10,	 														-- cost
	function() trigger_in_rakarth_rite() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_rakarth_rite:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_rakarth_rite:add_advice_key_precondition("wh2_twa03.camp.advice.def.monster_pens.004.rite");

in_rakarth_rite:add_trigger_condition(
	"ScriptEventRakarthRiteUnlocked",
	function(context)
		return true
	end
);

function trigger_in_rakarth_rite()
	
	in_rakarth_rite:play_advice_for_intervention(
		-- there's a rite for more monsters
		"wh2_twa03.camp.advice.def.monster_pens.004.rite"
	);
end;


---------------------------------------------------------------
--
--	Silent Sanctum - Sanctum Point Gained
--
---------------------------------------------------------------
-- After first Sanctum Point gained

in_silent_sanctums_point_gained = intervention:new(
	"in_silent_sanctums_point_gained",							-- string name
	10,	 														-- cost
	function() trigger_in_silent_sanctums_point_gained() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
)

in_silent_sanctums_point_gained:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_silent_sanctums_point_gained:add_advice_key_precondition("wh2_dlc17.camp.advice.lzd.silent_sanctums.001.sanctum_point");

in_silent_sanctums_point_gained:add_trigger_condition(
	"ScriptEventOxyFirstStoneGained",
	true
)

function trigger_in_silent_sanctums_point_gained()
	in_silent_sanctums_point_gained:play_advice_for_intervention(
		"wh2_dlc17.camp.advice.lzd.silent_sanctums.001.sanctum_point",
		{
			"wh2_dlc17.camp.advice.sanctum_gems.info_001",
			"wh2_dlc17.camp.advice.sanctum_gems.info_002",
			"wh2_dlc17.camp.advice.sanctum_gems.info_003",
			"wh2_dlc17.camp.advice.sanctum_gems.info_004"
		}
	)
end

---------------------------------------------------------------
--
--	Silent Sanctum - Sanctum Constructed
--
---------------------------------------------------------------
-- After first Sanctum constructed

in_silent_sanctums_constructed = intervention:new(
	"in_silent_sanctums_constructed",							-- string name
	10,	 														-- cost
	function() trigger_in_silent_sanctums_constructed() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
)

in_silent_sanctums_constructed:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_silent_sanctums_constructed:add_advice_key_precondition("wh2_dlc17.camp.advice.lzd.silent_sanctums.002.sanctum_built");

in_silent_sanctums_constructed:add_trigger_condition(
	"ScriptEventOxyFirstSanctumConstructed",
	true
)

function trigger_in_silent_sanctums_constructed()
	in_silent_sanctums_constructed:play_advice_for_intervention("wh2_dlc17.camp.advice.lzd.silent_sanctums.002.sanctum_built")
end

---------------------------------------------------------------
--
--	Threat Map - First Mission Issued
--
---------------------------------------------------------------
-- When first chaos event triggered

in_threat_map_first_mission_issued = intervention:new(
	"in_threat_map_first_mission_issued",							-- string name
	10,	 															-- cost
	function() trigger_in_threat_map_first_mission_issued() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
)

in_threat_map_first_mission_issued:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_threat_map_first_mission_issued:add_advice_key_precondition("wh2_dlc17.camp.advice.lzd.chaos_threat_map.001.first_event")

in_threat_map_first_mission_issued:add_trigger_condition(
	"ScriptEventOxyThreatMapCreated",
	true
)

function trigger_in_threat_map_first_mission_issued()
	in_threat_map_first_mission_issued:play_advice_for_intervention("wh2_dlc17.camp.advice.lzd.chaos_threat_map.001.first_event")
end

---------------------------------------------------------------
--
--	Threat Map - Panel First Opened (1/3)
--
---------------------------------------------------------------
--When threat map first opened

in_threat_map_panel_open_1 = intervention:new(
	"in_threat_map_panel_open_1",							-- string name
	10,	 													-- cost
	function() trigger_in_threat_map_panel_open_1() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 							-- show debug output
)

in_threat_map_panel_open_1:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_threat_map_panel_open_1:add_advice_key_precondition("wh2_dlc17.camp.advice.lzd.chaos_threat_map.002.threat_map")

in_threat_map_panel_open_1:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		out.design(context.string)
		if(context.string == "oxyotl_threat_map") then
			return true
		end
		return false
	end
)

function trigger_in_threat_map_panel_open_1()
	in_threat_map_panel_open_1:play_advice_for_intervention(
		"wh2_dlc17.camp.advice.lzd.chaos_threat_map.002.threat_map",
		{
			"wh2_dlc17.camp.advice.threat_map.info_001",
			"wh2_dlc17.camp.advice.threat_map.info_002",
			"wh2_dlc17.camp.advice.threat_map.info_003",
			"wh2_dlc17.camp.advice.threat_map.info_004"
		}
	)
end

---------------------------------------------------------------
--
--	Threat Map - Panel First Opened (2/3)
--
---------------------------------------------------------------

in_threat_map_panel_open_2 = intervention:new(
	"in_threat_map_in_threat_map_panel_open_2",							-- string name
	11,	 																-- cost
	function() trigger_in_threat_map_panel_open_2() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_threat_map_panel_open_2:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_threat_map_panel_open_2:add_advice_key_precondition("wh2_dlc17.camp.advice.lzd.chaos_threat_map.003.threat_map")

in_threat_map_panel_open_2:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		out.design(context.string)
		if(context.string == "oxyotl_threat_map") then
			return true
		end
		return false
	end
)

function trigger_in_threat_map_panel_open_2()
	in_threat_map_panel_open_2:play_advice_for_intervention(
		"wh2_dlc17.camp.advice.lzd.chaos_threat_map.003.threat_map",
		{
			"wh2_dlc17.camp.advice.threat_missions.info_001",
			"wh2_dlc17.camp.advice.threat_missions.info_002",
			"wh2_dlc17.camp.advice.threat_missions.info_003"
		}
	)
end

---------------------------------------------------------------
--
--	Threat Map - Panel First Opened (3/3)
--
---------------------------------------------------------------

in_threat_map_panel_open_3 = intervention:new(
	"in_threat_map_in_threat_map_panel_open_3",							-- string name
	12,	 																-- cost
	function() trigger_in_threat_map_panel_open_3() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_threat_map_panel_open_3:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_threat_map_panel_open_3:add_advice_key_precondition("wh2_dlc17.camp.advice.lzd.chaos_threat_map.004.threat_map")

in_threat_map_panel_open_3:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		out.design(context.string)
		if(context.string == "oxyotl_threat_map") then
			return true
		end
		return false
	end
)

function trigger_in_threat_map_panel_open_3()
	in_threat_map_panel_open_3:play_advice_for_intervention(
		"wh2_dlc17.camp.advice.lzd.chaos_threat_map.004.threat_map",
		{
			"wh2_dlc17.camp.advice.threat_travel.info_001",
			"wh2_dlc17.camp.advice.threat_travel.info_002",
			"wh2_dlc17.camp.advice.threat_travel.info_003",
			"wh2_dlc17.camp.advice.threat_travel.info_004",
			"wh2_dlc17.camp.advice.threat_travel.info_005"
		}
	)
end

---------------------------------------------------------------
--
--	Threat Map - First Complete
--
---------------------------------------------------------------
--After first chaos mission complete

in_threat_map_first_mission_complete = intervention:new(
	"in_threat_map_first_mission_complete",							-- string name
	15,	 															-- cost
	function() trigger_in_threat_map_first_mission_complete() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
)

in_threat_map_first_mission_complete:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_threat_map_first_mission_complete:add_advice_key_precondition("wh2_dlc17.camp.advice.lzd.chaos_threat_map.005.mission_complete")

in_threat_map_first_mission_complete:add_trigger_condition(
	"ScriptEventOxyThreatMapSuccess",
	true
)

function trigger_in_threat_map_first_mission_complete()
	in_threat_map_first_mission_complete:play_advice_for_intervention(
		"wh2_dlc17.camp.advice.lzd.chaos_threat_map.005.mission_complete"
	)
end

---------------------------------------------------------------
--
--	Taurox Rampage - First Battle
--
---------------------------------------------------------------

in_taurox_rampage_first_battle = intervention:new(
	"in_taurox_rampage_first_battle",							-- string name
	5,	 																-- cost
	function() trigger_in_taurox_rampage_first_battle() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_taurox_rampage_first_battle:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_taurox_rampage_first_battle:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.taurox.rampage.001.resource")
in_taurox_rampage_first_battle:set_wait_for_battle_complete(false);

in_taurox_rampage_first_battle:add_trigger_condition(
	"ScriptEventPlayerWinsBattle",
	true
);

function trigger_in_taurox_rampage_first_battle()
	in_taurox_rampage_first_battle:play_advice_for_intervention("wh2.dlc17.camp.advice.bst.taurox.rampage.001.resource")
end

---------------------------------------------------------------
--
--	Taurox Rampage - First Rampage Threshold
--
---------------------------------------------------------------

in_taurox_rampage_first_threshold = intervention:new(
	"in_taurox_rampage_first_threshold",							-- string name
	0,	 																	-- cost
	function() trigger_in_taurox_rampage_first_threshold() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
)

in_taurox_rampage_first_threshold:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_taurox_rampage_first_threshold:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.taurox.rampage.002.threshold")

in_taurox_rampage_first_threshold:add_trigger_condition(
	"ScriptEventTauroxRampageThresholdReached",
	true
);

function trigger_in_taurox_rampage_first_threshold()
	in_taurox_rampage_first_threshold:play_advice_for_intervention("wh2.dlc17.camp.advice.bst.taurox.rampage.002.threshold")
end

---------------------------------------------------------------
--
--	Taurox Rampage - Momentum Lost
--
---------------------------------------------------------------

in_taurox_rampage_momentum_lost = intervention:new(
	"in_taurox_rampage_momentum_lost",							-- string name
	0,	 																-- cost
	function() trigger_in_taurox_rampage_momentum_lost() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_taurox_rampage_momentum_lost:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_taurox_rampage_momentum_lost:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.taurox.rampage.003.momentum")

in_taurox_rampage_momentum_lost:add_trigger_condition(
	"ScriptEventTauroxRampageMomentumLost",
	true
);

function trigger_in_taurox_rampage_momentum_lost()
	in_taurox_rampage_momentum_lost:play_advice_for_intervention("wh2.dlc17.camp.advice.bst.taurox.rampage.003.momentum")
end

---------------------------------------------------------------
--
--	Taurox Rampage - Rampage Over
--
---------------------------------------------------------------

in_taurox_rampage_over = intervention:new(
	"in_taurox_rampage_over",							-- string name
	0,	 														-- cost
	function() trigger_in_taurox_rampage_over() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
)

in_taurox_rampage_over:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_taurox_rampage_over:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.taurox.rampage.004.over")

in_taurox_rampage_over:add_trigger_condition(
	"ScriptEventTauroxRampageOver",
	true
);

function trigger_in_taurox_rampage_over()
	in_taurox_rampage_over:play_advice_for_intervention("wh2.dlc17.camp.advice.bst.taurox.rampage.004.over")
end

---------------------------------------------------------------
--
--	Taurox Rampage - Rampage Success
--
---------------------------------------------------------------

in_taurox_rampage_success = intervention:new(
	"in_taurox_rampage_success",							-- string name
	0,	 															-- cost
	function() trigger_in_taurox_rampage_success() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
)

in_taurox_rampage_success:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_taurox_rampage_success:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.taurox.rampage.005.max")

in_taurox_rampage_success:add_trigger_condition(
	"ScriptEventTauroxRampageSuccess",
	true
);

function trigger_in_taurox_rampage_success()
	in_taurox_rampage_success:play_advice_for_intervention("wh2.dlc17.camp.advice.bst.taurox.rampage.005.max")
end

---------------------------------------------------------------
--
--	beastmen racial advice
--
---------------------------------------------------------------

-- intervention declaration
in_beastmen_racial_advice = intervention:new(
	"in_beastmen_racial_advice", 												-- string name
	25, 																		-- cost
	function() trigger_in_beastmen_racial_advice() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_beastmen_racial_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_beastmen_racial_advice:add_precondition_unvisited_page("beastmen");
in_beastmen_racial_advice:add_advice_key_precondition("dlc03.camp.advice.bst.beastmen.001");
in_beastmen_racial_advice:set_min_turn(2);

in_beastmen_racial_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		return true;
	end
);

function trigger_in_beastmen_racial_advice()
	in_beastmen_racial_advice:play_advice_for_intervention(
		-- You are the Children of Chaos, as much a part of the Ruinous Powers as the horns that sprout from your head. Your kind yearns for destruction; to root out order and civilisation and despoil it! March forth, and spread the corrupting taint of the Dark Gods!
		"dlc03.camp.advice.bst.beastmen.001", 
		{
			"war.camp.advice.beastmen.info_001",
			"war.camp.advice.beastmen.info_002",
			"war.camp.advice.beastmen.info_003"
		}
	)
end;

---------------------------------------------------------------
--
--	beastmen horde advice
--
---------------------------------------------------------------

-- intervention declaration
in_beastmen_horde_advice = intervention:new(
	"in_beastmen_horde_advice", 													-- string name
	40, 																			-- cost
	function() trigger_in_beastmen_horde_advice() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_beastmen_horde_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_beastmen_horde_advice:add_precondition_unvisited_page("hordes");
in_beastmen_horde_advice:add_advice_key_precondition("dlc03.camp.advice.bst.hordes.001");
in_beastmen_horde_advice:give_priority_to_intervention("in_beastmen_racial_advice");
in_beastmen_horde_advice:set_min_turn(3);

in_beastmen_horde_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		return true;
	end
);

function trigger_in_beastmen_horde_advice()
	in_beastmen_horde_advice:play_advice_for_intervention(	
		-- Your warriors live their lives on the march, mighty lord. The hordes have no need for towns or cities. Raze all that you find in the name of the Dark Gods!
		"dlc03.camp.advice.bst.hordes.001", 
		{
			"war.camp.advice.hordes.info_001",
			"war.camp.advice.hordes.info_002",
			"war.camp.advice.hordes.info_003"
		}
	)
end;

---------------------------------------------------------------
--
--	Bestial Rage advice
--
---------------------------------------------------------------

-- intervention declaration
in_beastmen_bestial_rage_advice = intervention:new(
	"in_beastmen_bestial_rage_advice", 											-- string name
	60, 																		-- cost
	function() trigger_in_beastmen_bestial_rage_advice() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_beastmen_bestial_rage_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_beastmen_bestial_rage_advice:add_precondition_unvisited_page("bestial_rage");
in_beastmen_bestial_rage_advice:add_advice_key_precondition("dlc03.camp.advice.bst.bestial_rage.001");
in_beastmen_bestial_rage_advice:give_priority_to_intervention("in_beastmen_racial_advice");
in_beastmen_bestial_rage_advice:set_min_turn(3);

in_beastmen_bestial_rage_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return true;
	end
);

function trigger_in_beastmen_bestial_rage_advice()
	in_beastmen_bestial_rage_advice:play_advice_for_intervention(
		-- There is rage inside you; I can feel it, just as there is in all true-horns! It is a gift from the Granter of Savage Hate - keep the fury contained within and then unleash it at the right moment!
		"dlc03.camp.advice.bst.bestial_rage.001", 
		{
			"war.camp.advice.bestial_rage.info_001",
			"war.camp.advice.bestial_rage.info_002",
			"war.camp.advice.bestial_rage.info_003",
			"war.camp.advice.bestial_rage.info_005"
		}
	);
end;

---------------------------------------------------------------
--
--	low bestial rage
--
---------------------------------------------------------------

-- intervention declaration
in_low_bestial_rage = intervention:new(
	"low_bestial_rage",	 												-- string name
	25, 																-- cost
	function() in_low_bestial_rage_advice_trigger() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_low_bestial_rage:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_low_bestial_rage:add_advice_key_precondition("dlc03.camp.advice.bst.bestial_rage.002");

in_low_bestial_rage:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local mf_list = context:faction():military_force_list();
		
		for i = 0, mf_list:num_items() - 1 do
			local current_mf = mf_list:item_at(i);
			
			if not current_mf:is_armed_citizenry() and current_mf:morale() < 40 then
				in_low_bestial_rage.mf_cqi = current_mf:command_queue_index();
				return true;
			end;
		end;
		
		return false;
	end
);

function in_low_bestial_rage_advice_trigger()
	local mf_cqi = in_low_bestial_rage.mf_cqi;
	local char_cqi = false;
	
	if is_number(mf_cqi) then
		local mf = cm:model():military_force_for_command_queue_index(mf_cqi);
		
		if is_militaryforce(mf) and mf:has_general() then
			char_cqi = mf:general_character():cqi();
		end;
	end;
	
	in_low_bestial_rage:scroll_camera_to_character_for_intervention( 
		char_cqi,
		-- The Gors must fight and feast on flesh, my Lord. If they remain passive too long, their bestial instincts will see them turn on each other.
		"dlc03.camp.advice.bst.bestial_rage.002", 
		{
			"war.camp.advice.bestial_rage.info_001",
			"war.camp.advice.bestial_rage.info_002",
			"war.camp.advice.bestial_rage.info_004",
			"war.camp.advice.bestial_rage.info_005"
		}
	);
end;

---------------------------------------------------------------
--
--	Beast Paths advice
--
---------------------------------------------------------------

-- intervention declaration
in_beastmen_beast_paths_advice = intervention:new(
	"in_beastmen_beast_paths_advice", 											-- string name
	60, 																		-- cost
	function() trigger_in_beastmen_beast_paths_advice() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_beastmen_beast_paths_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_beastmen_beast_paths_advice:add_precondition_unvisited_page("beast_paths");
in_beastmen_beast_paths_advice:give_priority_to_intervention("in_beastmen_bestial_rage_advice");
in_beastmen_beast_paths_advice:set_min_turn(4);

in_beastmen_beast_paths_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return true;
	end
);

function trigger_in_beastmen_beast_paths_advice()
	in_beastmen_beast_paths_advice:play_advice_for_intervention(
		-- The beast-paths are hidden ways known only to the Cloven Ones. Use them, my brutal Lord, to traverse the forests.
		"dlc03.camp.advice.bst.beast_paths.001", 
		{
			"war.camp.advice.beast_paths.info_001",
			"war.camp.advice.beast_paths.info_002",
			"war.camp.advice.beast_paths.info_003",
			"war.camp.advice.beast_paths.info_004"
		}
	);
end;

---------------------------------------------------------------
--
--	Hidden Encampment Stance advice
--
---------------------------------------------------------------

-- intervention declaration
in_beastmen_hidden_encampment_stance_advice = intervention:new(
	"in_beastmen_hidden_encampment_stance_advice", 										-- string name
	60, 																				-- cost
	function() trigger_in_beastmen_hidden_encampment_stance_advice() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 														-- show debug output
);

in_beastmen_hidden_encampment_stance_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_beastmen_hidden_encampment_stance_advice:set_min_turn(3);

-- return true if the player starts a turn with an army in enemy territory with < 80% strength
in_beastmen_hidden_encampment_stance_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local player_faction = cm:get_local_faction();
		local mf_list = player_faction:military_force_list();
		
		for i = 0, mf_list:num_items() - 1 do
			local current_mf = mf_list:item_at(i);
			
			if current_mf:has_general() then
				local current_char = current_mf:general_character(); 
				if current_char:has_region() and current_char:region():owning_faction():at_war_with(player_faction) and current_mf:active_stance() ~= "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SETTLE" and cm:military_force_average_strength(current_mf) < 80 then
					return true;
				end;
			end;
		end;
		
		return false;
	end
);

-- also returns true if the player finishes a battle with an army in enemy territory with < 80% strength
in_beastmen_hidden_encampment_stance_advice:add_trigger_condition(
	"ScriptEventPlayerBattleSequenceCompleted",
	function(context)
		local player_faction = cm:get_local_faction();
		local mf_list = player_faction:military_force_list();
		
		for i = 0, mf_list:num_items() - 1 do
			local current_mf = mf_list:item_at(i);
			
			if current_mf:has_general() then
				local current_char = current_mf:general_character(); 
				if current_char:has_region() and current_char:region():owning_faction():at_war_with(player_faction) and current_mf:active_stance() ~= "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SETTLE" and cm:military_force_average_strength(current_mf) < 80 then
					return true;
				end;
			end;
		end;
		
		return false;
	end
);

function trigger_in_beastmen_hidden_encampment_stance_advice()
	in_beastmen_hidden_encampment_stance_advice:play_advice_for_intervention(
		-- Consider making camp, Beastlord. An encampment will draw more Gors to your cause, allowing your followers time to lick their wounds and give tribute to the Dark Gods.
		"dlc03.camp.advice.bst.encampment.001",
		{
			"war.camp.advice.stances.info_001",
			"war.camp.advice.stances.info_002",
			"war.camp.advice.stances.info_003",
			"war.camp.advice.stances.info_004"
		}
	);
end;

---------------------------------------------------------------
--
--	Bloodgrounds - Herdstone
--
---------------------------------------------------------------

in_bloodgrounds_herdstone = intervention:new(
	"in_bloodgrounds_herdstone",							-- string name
	0,	 															-- cost
	function() trigger_in_bloodgrounds_herdstone() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
)

in_bloodgrounds_herdstone:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_bloodgrounds_herdstone:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.bloodgrounds.001.herdstone")
in_bloodgrounds_herdstone:set_wait_for_fullscreen_panel_dismissed(false);
in_bloodgrounds_herdstone:set_must_trigger(true, true);
in_bloodgrounds_herdstone:set_wait_for_battle_complete(false);

in_bloodgrounds_herdstone:add_trigger_condition(
	"ScriptEventPlayerWinsSettlementAttackBattle",
	function()
		-- only trigger if the pending battle is at a settlement that the player doesn't own
		local pb = cm:model():pending_battle();
		
		if pb:has_contested_garrison() and pb:contested_garrison():faction():name() ~= cm:get_local_faction_name() then
			return true;
		end;
		
		return false;
	end
);

function trigger_in_bloodgrounds_herdstone()
	in_bloodgrounds_herdstone:play_advice_for_intervention("wh2.dlc17.camp.advice.bst.bloodgrounds.001.herdstone")
end

---------------------------------------------------------------
--
--	Bloodgrounds - Herdstone Regions
--
---------------------------------------------------------------

in_bloodgrounds_regions = intervention:new(
	"in_bloodgrounds_regions",							-- string name
	0,	 														-- cost
	function() trigger_in_bloodgrounds_regions() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
)

in_bloodgrounds_regions:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_bloodgrounds_regions:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.bloodgrounds.002.regions")

in_bloodgrounds_regions:add_trigger_condition(
	"ScriptEventBloodgroundsHerdstoneCreated",
	true
);

function trigger_in_bloodgrounds_regions()
	in_bloodgrounds_regions:play_advice_for_intervention("wh2.dlc17.camp.advice.bst.bloodgrounds.002.regions")
end

---------------------------------------------------------------
--
--	Bloodgrounds - Bloodgrounds Settlements
--
---------------------------------------------------------------

in_bloodgrounds_settlements = intervention:new(
	"in_bloodgrounds_settlements",							-- string name
	0,	 															-- cost
	function() trigger_in_bloodgrounds_settlements() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
)

in_bloodgrounds_settlements:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_bloodgrounds_settlements:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.bloodgrounds.003.settlement")
in_bloodgrounds_settlements:set_wait_for_fullscreen_panel_dismissed(false);
in_bloodgrounds_settlements:set_must_trigger(true, true);
in_bloodgrounds_settlements:set_wait_for_battle_complete(false);

in_bloodgrounds_settlements:add_trigger_condition(
	"ScriptEventPlayerWinsSettlementAttackBattle",
	function()
		-- only trigger if the pending battle is at a settlement that the player doesn't own
		local pb = cm:model():pending_battle();
		local faction_name = cm:get_local_faction_name();
		local faction = cm:get_faction(faction_name);

		local herdstone_count = faction:pooled_resource_manager():resource("bst_herdstone_shard"):value();
		
		if pb:has_contested_garrison() and pb:contested_garrison():faction():name() ~= faction_name and herdstone_count == 0 then
			return true;
		end;
		
		return false;
	end
);
function trigger_in_bloodgrounds_settlements()
	in_bloodgrounds_settlements:play_advice_for_intervention("wh2.dlc17.camp.advice.bst.bloodgrounds.003.settlement")
end

---------------------------------------------------------------
--
--	Bloodgrounds - First Raze
--
---------------------------------------------------------------

in_bloodgrounds_first_raze = intervention:new(
	"in_bloodgrounds_first_raze",							-- string name
	0,	 															-- cost
	function() trigger_in_bloodgrounds_first_raze() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
)

in_bloodgrounds_first_raze:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_bloodgrounds_first_raze:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.bloodgrounds.004.post")

in_bloodgrounds_first_raze:add_trigger_condition(
	"CharacterPerformsSettlementOccupationDecision",
	function(context)
		local faction = context:character():faction();
		local occupation_decision = context:occupation_decision();
		if occupation_decision == "1172" or occupation_decision == "411" then
			return faction:name() == cm:get_local_faction_name();
		end
		return false;		
	end
);

function trigger_in_bloodgrounds_first_raze()
	in_bloodgrounds_first_raze:play_advice_for_intervention("wh2.dlc17.camp.advice.bst.bloodgrounds.004.post")
end

---------------------------------------------------------------
--
--	Bloodgrounds - All Razed
--
---------------------------------------------------------------

in_bloodgrounds_all_razed = intervention:new(
	"in_bloodgrounds_all_razed",							-- string name
	0,	 															-- cost
	function() trigger_in_bloodgrounds_all_razed() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
)

in_bloodgrounds_all_razed:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_bloodgrounds_all_razed:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.bloodgrounds.005.razed")

in_bloodgrounds_all_razed:add_trigger_condition(
	"ScriptEventRitualofRuinUnlocked",
	true
);

function trigger_in_bloodgrounds_all_razed()
	in_bloodgrounds_all_razed:play_advice_for_intervention("wh2.dlc17.camp.advice.bst.bloodgrounds.005.razed")
end

---------------------------------------------------------------
--
--	Bloodgrounds - Ritual Complete
--
---------------------------------------------------------------

in_bloodgrounds_ritual_complete = intervention:new(
	"in_bloodgrounds_ritual_complete",							-- string name
	0,	 														-- cost
	function() trigger_in_bloodgrounds_ritual_complete() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
)

in_bloodgrounds_ritual_complete:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH)
in_bloodgrounds_ritual_complete:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.bloodgrounds.006.finished")

in_bloodgrounds_ritual_complete:add_trigger_condition(
	"ScriptEventRitualofRuinPerformed",
	true
);

function trigger_in_bloodgrounds_ritual_complete()
	in_bloodgrounds_ritual_complete:play_advice_for_intervention("wh2.dlc17.camp.advice.bst.bloodgrounds.006.finished")
end

---------------------------------------------------------------
--
--	Beastmen - Technology Panel
--
---------------------------------------------------------------

-- intervention declaration
in_beastmen_technology_panel_opened = intervention:new(
	"in_beastmen_technology_panel_opened",							-- string name
	0,	 															-- cost
	function() trigger_in_beastmen_technology_panel_opened() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_beastmen_technology_panel_opened:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_beastmen_technology_panel_opened:set_wait_for_fullscreen_panel_dismissed(false);
in_beastmen_technology_panel_opened:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.technologies.001.first");

in_beastmen_technology_panel_opened:add_trigger_condition(
	"ScriptEventTechnologyPanelOpened",
	true
);

function trigger_in_beastmen_technology_panel_opened()
	in_beastmen_technology_panel_opened:play_advice_for_intervention("wh2.dlc17.camp.advice.bst.technologies.001.first")
end;

---------------------------------------------------------------
--
--	Marks of Ruination - Turn 2
--
---------------------------------------------------------------

-- intervention declaration
in_marks_of_ruination_turn_two = intervention:new(
	"in_marks_of_ruination_turn_two",							-- string name
	0,	 														-- cost
	function() trigger_in_marks_of_ruination_turn_two() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

in_marks_of_ruination_turn_two:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_marks_of_ruination_turn_two:set_wait_for_fullscreen_panel_dismissed(false);
in_marks_of_ruination_turn_two:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.progression.001.start");

in_marks_of_ruination_turn_two:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local faction = context:faction();
		local turn = cm:turn_number();
		return turn > 1 and faction:name() == cm:get_local_faction_name();
	end
);

function trigger_in_marks_of_ruination_turn_two()
	in_marks_of_ruination_turn_two:play_advice_for_intervention("wh2.dlc17.camp.advice.bst.progression.001.start")
end;

---------------------------------------------------------------
--
--	Marks of Ruination - First Threshold
--
---------------------------------------------------------------

-- intervention declaration
in_marks_of_ruination_first_threshold = intervention:new(
	"in_marks_of_ruination_first_threshold",							-- string name
	0,	 																-- cost
	function() trigger_in_marks_of_ruination_first_threshold() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_marks_of_ruination_first_threshold:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_marks_of_ruination_first_threshold:set_wait_for_fullscreen_panel_dismissed(false);
in_marks_of_ruination_first_threshold:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.progression.002.increased");

in_marks_of_ruination_first_threshold:add_trigger_condition(
	"ScriptEventMarksofRuinationThreshold",
	true
);

function trigger_in_marks_of_ruination_first_threshold()
	in_marks_of_ruination_first_threshold:play_advice_for_intervention("wh2.dlc17.camp.advice.bst.progression.002.increased")
end;

---------------------------------------------------------------
--
--	Marks of Ruination - Completed
--
---------------------------------------------------------------

-- intervention declaration
in_marks_of_ruination_completed = intervention:new(
	"in_marks_of_ruination_completed",								-- string name
	0,	 															-- cost
	function() trigger_in_marks_of_ruination_completed() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_marks_of_ruination_completed:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_marks_of_ruination_completed:set_wait_for_fullscreen_panel_dismissed(false);
in_marks_of_ruination_completed:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.progression.003.final");

in_marks_of_ruination_completed:add_trigger_condition(
	"ScriptEventMarksofRuinationCompleted",
	true
);

function trigger_in_marks_of_ruination_completed()
	in_marks_of_ruination_completed:play_advice_for_intervention("wh2.dlc17.camp.advice.bst.progression.003.final")
end;

---------------------------------------------------------------
--
--	Dwarf Forge - First time opened
--
---------------------------------------------------------------

-- intervention declaration
in_forge_opened = intervention:new(
	"in_forge_opened",								-- string name
	0,	 											-- cost
	function() trigger_in_forge_opened() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 					-- show debug output
);

in_forge_opened:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_forge_opened:set_wait_for_fullscreen_panel_dismissed(false);
in_forge_opened:add_advice_key_precondition("wh2_dlc17.camp.advice.dwf.thorek_story.001");

in_forge_opened:add_trigger_condition(
	"ScriptEventDwarfForgePanelOpened",
	true
);

function trigger_in_forge_opened()
	in_forge_opened:play_advice_for_intervention("wh2_dlc17.camp.advice.dwf.thorek_story.001")
end;

---------------------------------------------------------------
--
--	Dwarf Forge - First artefact part recovered
--
---------------------------------------------------------------

-- intervention declaration
in_forge_first_part_recovered = intervention:new(
	"in_forge_first_part_recovered",								-- string name
	0,	 															-- cost
	function() trigger_in_forge_first_part_recovered() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_forge_first_part_recovered:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_forge_first_part_recovered:set_wait_for_fullscreen_panel_dismissed(false);
in_forge_first_part_recovered:add_advice_key_precondition("wh2_dlc17.camp.advice.dwf.thorek_story.002");

in_forge_first_part_recovered:add_trigger_condition(
	"ScriptEventForgeArtefactPartReceived",
	true
);

function trigger_in_forge_first_part_recovered()
	in_forge_first_part_recovered:play_advice_for_intervention("wh2_dlc17.camp.advice.dwf.thorek_story.002")
end;


---------------------------------------------------------------
--
--	Dwarf Artefacts - First pair recovered
--
---------------------------------------------------------------

-- intervention declaration
in_artefacts_first_pair_recovered = intervention:new(
	"in_artefacts_first_pair_recovered",							-- string name
	0,	 															-- cost
	function() trigger_in_artefacts_first_pair_recovered() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_artefacts_first_pair_recovered:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_artefacts_first_pair_recovered:set_wait_for_fullscreen_panel_dismissed(false);
in_artefacts_first_pair_recovered:add_advice_key_precondition("wh2_dlc17.camp.advice.dwf.thorek_artefacts.001");

in_artefacts_first_pair_recovered:add_trigger_condition(
	"ScriptEventForgeArtefactPair",
	true
);

function trigger_in_artefacts_first_pair_recovered()
	in_artefacts_first_pair_recovered:play_advice_for_intervention("wh2_dlc17.camp.advice.dwf.thorek_artefacts.001")
end;

---------------------------------------------------------------
--
--	Dwarf Artefacts - First artefact forged
--
---------------------------------------------------------------

-- intervention declaration
in_artefacts_first_artefact_forged = intervention:new(
	"in_artefacts_first_artefact_forged",							-- string name
	0,	 															-- cost
	function() trigger_in_artefacts_first_artefact_forged() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_artefacts_first_artefact_forged:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_artefacts_first_artefact_forged:set_wait_for_fullscreen_panel_dismissed(false);
in_artefacts_first_artefact_forged:add_advice_key_precondition("wh2_dlc17.camp.advice.dwf.thorek_artefacts.002");

in_artefacts_first_artefact_forged:add_trigger_condition(
	"ScriptEventArtefactsForgedOne",
	true
);

function trigger_in_artefacts_first_artefact_forged()
	in_artefacts_first_artefact_forged:play_advice_for_intervention("wh2_dlc17.camp.advice.dwf.thorek_artefacts.002")
end;

---------------------------------------------------------------
--
--	Dwarf Artefacts - Third artefact forged
--
---------------------------------------------------------------

-- intervention declaration
in_artefacts_third_artefact_forged = intervention:new(
	"in_artefacts_third_artefact_forged",							-- string name
	0,	 															-- cost
	function() trigger_in_artefacts_third_artefact_forged() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_artefacts_third_artefact_forged:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_artefacts_third_artefact_forged:set_wait_for_fullscreen_panel_dismissed(false);
in_artefacts_third_artefact_forged:add_advice_key_precondition("wh2_dlc17.camp.advice.dwf.thorek_artefacts.003");

in_artefacts_third_artefact_forged:add_trigger_condition(
	"ScriptEventArtefactsForgedThree",
	true
);

function trigger_in_artefacts_third_artefact_forged()
	in_artefacts_third_artefact_forged:play_advice_for_intervention("wh2_dlc17.camp.advice.dwf.thorek_artefacts.003")
end;

---------------------------------------------------------------
--
--	Dwarf Artefacts - All artefact forged
--
---------------------------------------------------------------

-- intervention declaration
in_artefacts_all_artefact_forged = intervention:new(
	"in_artefacts_all_artefact_forged",								-- string name
	0,	 															-- cost
	function() trigger_in_artefacts_all_artefact_forged() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

in_artefacts_all_artefact_forged:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_artefacts_all_artefact_forged:set_wait_for_fullscreen_panel_dismissed(false);
in_artefacts_all_artefact_forged:add_advice_key_precondition("wh2_dlc17.camp.advice.dwf.thorek_artefacts.004");

in_artefacts_all_artefact_forged:add_trigger_condition(
	"ScriptEventArtefactsForgedAll",
	true
);

function trigger_in_artefacts_all_artefact_forged()
	in_artefacts_all_artefact_forged:play_advice_for_intervention("wh2_dlc17.camp.advice.dwf.thorek_artefacts.004")
end;


---------------------------------------------------------------
--
--	Grudges advice
--
---------------------------------------------------------------

in_grudges_advice = intervention:new(
	"grudges_advice", 														-- string name
	20, 																	-- cost
	function() in_grudges_advice_trigger() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_grudges_advice:add_advice_key_precondition("war.camp.prelude.dwf.grudges.001");
in_grudges_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_grudges_advice:set_must_trigger(true, true);

in_grudges_advice:add_trigger_condition(
	"ScriptEventPlayerAcceptsMission",
	true
);

function in_grudges_advice_trigger()
	in_grudges_advice:play_advice_for_intervention(
		-- Misdeeds committed against your kind are recorded in the venerable Book of Grudges - the Dammaz Kron. Once documented, no transgression should remain unpunished, my King.
		"war.camp.prelude.dwf.grudges.001",
		{
			"war.camp.advice.grudges.info_001",
			"war.camp.advice.grudges.info_002",
			"war.camp.advice.grudges.info_003"
		}
	);
end;


---------------------------------------------------------------
--
--	Dwarfs racial advice
--
---------------------------------------------------------------

-- intervention declaration
in_dwarfs_racial_advice = intervention:new(
	"in_dwarfs_racial_advice", 													-- string name
	50, 																		-- cost
	function() trigger_in_dwarfs_racial_advice() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

in_dwarfs_racial_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_dwarfs_racial_advice:add_precondition_unvisited_page("dwarfs");
in_dwarfs_racial_advice:add_advice_key_precondition("war.camp.prelude.dwf.dwarfs.001");
in_dwarfs_racial_advice:set_min_turn(2);

in_dwarfs_racial_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)	
		return true;
	end
);

function trigger_in_dwarfs_racial_advice()
	in_dwarfs_racial_advice:play_advice_for_intervention(
		-- As you know all too well, the power of the Dawi has reverberated through these mountains for millennia. Harness that strength, and you will have all you need to restore the Karaz Ankor to its former glory.
		"war.camp.prelude.dwf.dwarfs.001", 
		{
			"war.camp.advice.dwarfs.info_001",
			"war.camp.advice.dwarfs.info_002",
			"war.camp.advice.dwarfs.info_003"
		}
	)
end;


---------------------------------------------------------------
--
--	Dwarf Underway
--
---------------------------------------------------------------

-- intervention declaration
in_dwarfs_underway_advice = intervention:new(
	"in_dwarfs_underway_advice", 											-- string name
	60, 																	-- cost
	function() trigger_in_dwarfs_underway_advice() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

in_dwarfs_underway_advice:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
in_dwarfs_underway_advice:add_precondition_unvisited_page("underway");
in_dwarfs_underway_advice:add_advice_key_precondition("war.camp.prelude.grn.underways.001");
in_dwarfs_underway_advice:add_advice_key_precondition("war.camp.prelude.dwf.underways.001");
in_dwarfs_underway_advice:set_min_turn(4);

in_dwarfs_underway_advice:add_precondition(
	function()
		return not common.get_advice_history_string_seen("use_underway_stance")
	end
);

in_dwarfs_underway_advice:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		return true;
	end
);

function trigger_in_dwarfs_underway_advice()
	in_dwarfs_underway_advice:play_advice_for_intervention(
		-- Be sure to make use of the Underway when moving your folk around the mountains, Sire. Much time can be saved when travelling below ground.
		"war.camp.prelude.dwf.underways.001", 
		{
			"war.camp.advice.underway.info_001",
			"war.camp.advice.underway.info_002",
			"war.camp.advice.underway.info_003",
			"war.camp.advice.underway.info_004"
		}
	)
end;


---------------------------------------------------------------
--
--	Oathgold
--
---------------------------------------------------------------

-- intervention declaration
in_oathgold = intervention:new(
	"in_oathgold",								-- string name
	0,	 										-- cost
	function() trigger_in_oathgold() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 				-- show debug output
);

in_artefacts_all_artefact_forged:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_artefacts_all_artefact_forged:add_advice_key_precondition("wh2_dlc17.camp.advice.dwf.oathgold");

in_oathgold:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context)
		local faction = context:faction();
		local resource = faction:pooled_resource_manager():resource("dwf_oathgold");
		return resource:value() > 100 and faction:name() == cm:get_local_faction_name();
	end
);

function trigger_in_oathgold()
	in_oathgold:play_advice_for_intervention("wh2_dlc17.camp.advice.dwf.oathgold");
end;

---------------------------------------------------------------
--
--	Dwarf Runes
--
---------------------------------------------------------------

-- intervention declaration
in_dwarf_runes = intervention:new(
	"in_dwarf_runes",							-- string name
	0,	 										-- cost
	function() trigger_in_dwarf_runes() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 				-- show debug output
);

in_dwarf_runes:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_dwarf_runes:add_advice_key_precondition("wh2_dlc17.camp.advice.dwf.runes.001");

in_dwarf_runes:add_trigger_condition(
	"RitualCompletedEvent",
	function(context)
		return context:ritual():ritual_key():find("anc_rune");
	end	
);

function trigger_in_dwarf_runes()
	in_dwarf_runes:play_advice_for_intervention("wh2_dlc17.camp.advice.dwf.runes.001");
end;

---------------------------------------------------------------
--
--	Grudges - Low Severity
--
---------------------------------------------------------------

-- intervention declaration
in_grudges_low_severity = intervention:new(
	"in_grudges_low_severity",							-- string name
	0,	 												-- cost
	function() trigger_in_grudges_low_severity() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 						-- show debug output
);

in_grudges_low_severity:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_grudges_low_severity:add_advice_key_precondition("wh2_dlc17.camp.advice.dwf.grudges.001");

in_grudges_low_severity:add_trigger_condition(
	"CampaignEffectsBundleAwarded",
	function(context)
		return context:faction():has_effect_bundle("wh_main_bundle_grudges_low");
	end	
);

function trigger_in_grudges_low_severity()
	in_grudges_low_severity:play_advice_for_intervention("wh2_dlc17.camp.advice.dwf.grudges.001");
end;

---------------------------------------------------------------
--
--	Grudges - High Severity
--
---------------------------------------------------------------

-- intervention declaration
in_grudges_high_severity = intervention:new(
	"in_grudges_high_severity",							-- string name
	0,	 												-- cost
	function() trigger_in_grudges_high_severity() end,	-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 						-- show debug output
);

in_grudges_high_severity:set_min_advice_level(ADVICE_LEVEL_MINIMAL_LOW_HIGH);
in_grudges_high_severity:add_advice_key_precondition("wh2_dlc17.camp.advice.dwf.grudges.002");

in_grudges_high_severity:add_trigger_condition(
	"CampaignEffectsBundleAwarded",
	function(context)
		return context:faction():has_effect_bundle("wh_main_bundle_grudges_extreme");
	end	
);

function trigger_in_grudges_high_severity()
	in_grudges_high_severity:play_advice_for_intervention("wh2_dlc17.camp.advice.dwf.grudges.002");
end;

---------------------------------------------------------------
--
--	Storm of Magic Pre battle Screen
--
---------------------------------------------------------------

-- intervention declaration
storm_of_magic_pre_battle = intervention:new(
	"storm_of_magic_pre_battle",												-- string name
	20,	 																		-- cost
	function() trigger_storm_of_magic_pre_battle() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

storm_of_magic_pre_battle:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH)
storm_of_magic_pre_battle:add_advice_key_precondition("wh3_main_camp_advice_storm_of_magic_01");
storm_of_magic_pre_battle:set_wait_for_fullscreen_panel_dismissed(false)
storm_of_magic_pre_battle:set_wait_for_battle_complete(false)

storm_of_magic_pre_battle:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		return context.string == "popup_pre_battle" and region_in_chaos_realm(cm:model():pending_battle():region_data():key()) and (cm:get_local_faction() == cm:model():pending_battle():attacker():faction() or cm:get_local_faction() == cm:model():pending_battle():defender():faction())
	end
)

function trigger_storm_of_magic_pre_battle()
	storm_of_magic_pre_battle:play_advice_for_intervention(
		-- The Winds of Magic howl and rage! The coming battle will be dominated by their fury!
		"wh3_main_camp_advice_storm_of_magic_01",
		{
			"war.camp.advice.storm_of_magic.info_001",
			"war.camp.advice.storm_of_magic.info_002",
			"war.camp.advice.storm_of_magic.info_003"
		}
	)
end


---------------------------------------------------------------
--
--	Daemon Prince Post Battle Screen
--
---------------------------------------------------------------

-- intervention declaration
daemon_prince_post_battle = intervention:new(
	"daemon_prince_post_battle",												-- string name
	20,	 																		-- cost
	function() trigger_daemon_prince_post_battle() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

daemon_prince_post_battle:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH)
daemon_prince_post_battle:add_advice_key_precondition("wh3_main_camp_advice_daemonic_glory_01")
daemon_prince_post_battle:set_wait_for_fullscreen_panel_dismissed(false)
daemon_prince_post_battle:set_wait_for_battle_complete(false)

daemon_prince_post_battle:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		return context.string == "popup_battle_results" and cm:pending_battle_cache_human_victory();
	end
)

function trigger_daemon_prince_post_battle()
	daemon_prince_post_battle:play_advice_for_intervention(
		-- Victory in battle affords an opportunity to honour the Gods of Chaos. Yet which of the Ruinous Powers to exalt is your decision.
		"wh3_main_camp_advice_daemonic_glory_01",
		{
			"war.camp.advice.daemon_prince_offer_gods.info_001",
			"war.camp.advice.daemon_prince_offer_gods.info_002",
			"war.camp.advice.daemon_prince_offer_gods.info_003",
			"war.camp.advice.daemon_prince_offer_gods.info_004"
		}
	)
end

---------------------------------------------------------------
--
--	Khorne Ascendancy
--
---------------------------------------------------------------

-- intervention declaration
khorne_ascendancy = intervention:new(
	"khorne_ascendancy",												-- string name
	20,	 																-- cost
	function() trigger_khorne_ascendancy() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

khorne_ascendancy:set_min_advice_level(ADVICE_LEVEL_HIGH)
khorne_ascendancy:add_advice_key_precondition("wh3_main_camp_advice_khorne_ascendant_01")


khorne_ascendancy:add_trigger_condition(
	"ScriptEventNewGodAscendant",
	function(context) return context.string == "wh3_main_kho_khorne" end
)

function trigger_khorne_ascendancy()
	khorne_ascendancy:play_advice_for_intervention(
		-- Khorne is ascendant in the Great Game! His belligerence and rage overflows – redouble your aggressions against His hated enemies!
		"wh3_main_camp_advice_khorne_ascendant_01",
		{
			"war.camp.advice.chaos_god_ascendant.info_001", 							-- {{tr:hp_campaign_title_the_great_game}}
			"war.camp.advice.chaos_god_ascendant.info_002", 							-- {{tr:hp_campaign_description_the_great_game}}
			"war.camp.advice.chaos_god_ascendant.info_003",								-- {{tr:hp_campaign_point_3_the_great_game}}
			"war.camp.advice.chaos_god_ascendant.info_004"								-- Learn more about The Great Game [[url:script_link_campaign_the_great_game]]here[[/url]].
		}
	)
end

---------------------------------------------------------------
--
--	Nurgle Ascendancy
--
---------------------------------------------------------------

-- intervention declaration
nurgle_ascendancy = intervention:new(
	"nurgle_ascendancy",												-- string name
	20,	 																-- cost
	function() trigger_nurgle_ascendancy() end,							-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

nurgle_ascendancy:set_min_advice_level(ADVICE_LEVEL_HIGH)
nurgle_ascendancy:add_advice_key_precondition("wh3_main_camp_advice_nurgle_ascendant_01")


nurgle_ascendancy:add_trigger_condition(
	"ScriptEventNewGodAscendant",
	function(context) return context.string == "wh3_main_nur_nurgle" end
)

function trigger_nurgle_ascendancy()
	nurgle_ascendancy:play_advice_for_intervention(
		-- The Great Game turns once more; Grandfather Nurgle is now ascendant! Now is the time to make war against the enemies of the Plague Lord!
		"wh3_main_camp_advice_nurgle_ascendant_01",
		{
			"war.camp.advice.chaos_god_ascendant.info_001", 							-- {{tr:hp_campaign_title_the_great_game}}
			"war.camp.advice.chaos_god_ascendant.info_002", 							-- {{tr:hp_campaign_description_the_great_game}}
			"war.camp.advice.chaos_god_ascendant.info_003",								-- {{tr:hp_campaign_point_3_the_great_game}}
			"war.camp.advice.chaos_god_ascendant.info_004"								-- Learn more about The Great Game [[url:script_link_campaign_the_great_game]]here[[/url]].
		}
	)
end

---------------------------------------------------------------
--
--	Tzeentch Ascendancy
--
---------------------------------------------------------------

-- intervention declaration
tzeentch_ascendancy = intervention:new(
	"tzeentch_ascendancy",												-- string name
	20,	 																-- cost
	function() trigger_tzeentch_ascendancy() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

tzeentch_ascendancy:set_min_advice_level(ADVICE_LEVEL_HIGH)
tzeentch_ascendancy:add_advice_key_precondition("wh3_main_camp_advice_tzeentch_ascendant_01")


tzeentch_ascendancy:add_trigger_condition(
	"ScriptEventNewGodAscendant",
	function(context) return context.string == "wh3_main_tze_tzeentch" end
)

function trigger_tzeentch_ascendancy()
	tzeentch_ascendancy:play_advice_for_intervention(
		-- The Great Game has turned once more, as the Changer of Ways always knew it would. The Raven God is now ascendant! The time to strike His enemies is at hand!
		"wh3_main_camp_advice_tzeentch_ascendant_01",
		{
			"war.camp.advice.chaos_god_ascendant.info_001", 							-- {{tr:hp_campaign_title_the_great_game}}
			"war.camp.advice.chaos_god_ascendant.info_002", 							-- {{tr:hp_campaign_description_the_great_game}}
			"war.camp.advice.chaos_god_ascendant.info_003",								-- {{tr:hp_campaign_point_3_the_great_game}}
			"war.camp.advice.chaos_god_ascendant.info_004"								-- Learn more about The Great Game [[url:script_link_campaign_the_great_game]]here[[/url]].
		}
	)
end

---------------------------------------------------------------
--
--	Slaanesh Ascendancy
--
---------------------------------------------------------------

-- intervention declaration
slaanesh_ascendancy = intervention:new(
	"slaanesh_ascendancy",												-- string name
	20,	 																-- cost
	function() trigger_slaanesh_ascendancy() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

slaanesh_ascendancy:set_min_advice_level(ADVICE_LEVEL_HIGH)
slaanesh_ascendancy:add_advice_key_precondition("wh3_main_camp_advice_slaanesh_ascendant_01")


slaanesh_ascendancy:add_trigger_condition(
	"ScriptEventNewGodAscendant",
	function(context) return context.string == "wh3_main_sla_slaanesh" end
)

function trigger_slaanesh_ascendancy()
	slaanesh_ascendancy:play_advice_for_intervention(
		-- The Great Game turns to favour Slaanesh! Inflict yourself upon His rivals, for now they will know true pain!
		"wh3_main_camp_advice_slaanesh_ascendant_01",
		{
			"war.camp.advice.chaos_god_ascendant.info_001", 							-- {{tr:hp_campaign_title_the_great_game}}
			"war.camp.advice.chaos_god_ascendant.info_002", 							-- {{tr:hp_campaign_description_the_great_game}}
			"war.camp.advice.chaos_god_ascendant.info_003",								-- {{tr:hp_campaign_point_3_the_great_game}}
			"war.camp.advice.chaos_god_ascendant.info_004"								-- Learn more about The Great Game [[url:script_link_campaign_the_great_game]]here[[/url]].
		}
	)
end

---------------------------------------------------------------
--
--	Ogre Meat Pre battle Screen
--
---------------------------------------------------------------

-- intervention declaration
ogre_meat_pre_battle = intervention:new(
	"ogre_meat_pre_battle",														-- string name
	20,	 																		-- cost
	function() trigger_ogre_meat_pre_battle() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 												-- show debug output
);

ogre_meat_pre_battle:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH)
ogre_meat_pre_battle:add_advice_key_precondition("wh3_main_camp_advice_ogre_meat_pre_battle_01");
ogre_meat_pre_battle:set_wait_for_fullscreen_panel_dismissed(false)
ogre_meat_pre_battle:set_wait_for_battle_complete(false)

ogre_meat_pre_battle:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		if context.string ~= "popup_pre_battle"  then 
			return
		end
		
		local player_military_force = false
		local player_ogre_meat = false
		
		if cm:get_local_faction() == cm:model():pending_battle():attacker():military_force():faction() then
			player_military_force = cm:model():pending_battle():attacker():military_force()
		elseif cm:get_local_faction() == cm:model():pending_battle():defender():faction() then
			player_military_force = cm:model():pending_battle():defender():military_force()
		else
			return
		end

		player_ogre_meat = player_military_force:pooled_resource_manager():resource("wh3_main_ogr_meat")
		out(player_military_force:faction():subculture())
		if player_military_force and not player_ogre_meat:is_null_interface() then
			out(player_ogre_meat:value())
			return player_ogre_meat:value() > 0
		end
	end
)

function trigger_ogre_meat_pre_battle()
	ogre_meat_pre_battle:play_advice_for_intervention(
		"wh3_main_camp_advice_ogre_meat_pre_battle_01", 						-- The time for battle is nigh! Distribute provisions before the fighting begins, for your brutish kind are known to fight better with full bellies.
		{
			"war.camp.advice.ogre_meat_pre_battle.info_001", 					-- {{tr:hp_campaign_title_meat}}	
			"war.camp.advice.ogre_meat_pre_battle.info_002", 					-- {{tr:hp_campaign_description_meat}}	
			"war.camp.advice.ogre_meat_pre_battle.info_003",					-- {{tr:hp_campaign_point_5_meat}}
			"war.camp.advice.ogre_meat_pre_battle.info_004"						-- Learn more about Meat [[url:script_link_campaign_meat]]here[[/url]].
		}
	)
end

---------------------------------------------------------------
--
--	Ogre Contracts
--
---------------------------------------------------------------

-- intervention declaration
ogre_contracts = intervention:new(
	"ogre_contracts",														-- string name
	20,	 																	-- cost
	function() trigger_ogre_contracts() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

ogre_contracts:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH)
ogre_contracts:add_advice_key_precondition("wh3_main_camp_advice_ogre_contracts_01")

ogre_contracts:add_trigger_condition(
	"ScriptEventOgreContractsIssued",
	function(context) 
		return context.string == cm:get_local_faction_name()
	end
)

function trigger_ogre_contracts()
	ogre_contracts:play_advice_for_intervention(
		"wh3_main_camp_advice_ogre_contracts_01", 						-- Your 'friends' abroad must want someone pulverised, for a contract has been issued. Fulfil it, and a sizeable bounty will be yours.
		{
			"war.camp.advice.ogre_contract.info_001", 					-- {{tr:hp_campaign_title_contracts}}
			"war.camp.advice.ogre_contract.info_002", 					-- {{tr:hp_campaign_description_contracts}}
			"war.camp.advice.ogre_contract.info_003",					-- Contracts may be browsed and accepted on the [[sl_tooltip:campaign_contracts_panel]]Contracts panel[[/sl_tooltip]]. They may only be accepted on the turn that they are issued.
			"war.camp.advice.ogre_contract.info_004"					-- Learn more about Contracts [[url:script_link_campaign_contracts]]here[[/url]].
		}
	)
end

---------------------------------------------------------------
--
--	Low Devotion
--
---------------------------------------------------------------

-- intervention declaration
low_devotion = intervention:new(
	"low_devotion",														-- string name
	20,	 																-- cost
	function() trigger_low_devotion() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

low_devotion:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH)
low_devotion:add_advice_key_precondition("wh3_main_camp_advice_kislev_low_devotion_01")

low_devotion:add_trigger_condition(
	"ScriptEventChaosIncursionAgainstFaction",
	function(context) 
		return context:faction() == cm:get_local_faction()
	end
)

function trigger_low_devotion()
	low_devotion:play_advice_for_intervention(
		-- Devotion is low amongst your people. Their malaise has let Chaos into their towns and villages. Now, the forces of the Ruinous Powers mass against you from within!
		"wh3_main_camp_advice_kislev_low_devotion_01",
		{
			"war.camp.advice.low_devotion.info_001",
			"war.camp.advice.low_devotion.info_002",
			"war.camp.advice.low_devotion.info_003",
			"war.camp.advice.low_devotion.info_004"
		}
	)
end

---------------------------------------------------------------
--
--	Motherland Ritual Player
--
---------------------------------------------------------------

-- intervention declaration
motherland_ritual_player = intervention:new(
	"motherland_ritual_player",														-- string name
	20,	 																			-- cost
	function() trigger_motherland_ritual_player() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

motherland_ritual_player:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH)
motherland_ritual_player:add_advice_key_precondition("wh3_main_camp_narrative_kislev_gain_support_01")

motherland_ritual_player:add_trigger_condition(
	"ScriptEventFactionPerformsMotherlandRitual",
	function(context) 
		return context:faction() == cm:get_local_faction()
	end
)

function trigger_motherland_ritual_player()
	motherland_ritual_player:play_advice_for_intervention(
		-- Your invocation draws the benevolence of the winter gods upon your people. While it persists, it brings an opportunity to win support in your struggle against your bitter rivals.
		"wh3_main_camp_narrative_kislev_gain_support_01",
		{
			"war.camp.advice.motherland_ritual_player.info_001",
			"war.camp.advice.motherland_ritual_player.info_002",
			"war.camp.advice.motherland_ritual_player.info_003",
			"war.camp.advice.motherland_ritual_player.info_004"
		}
	)
end

---------------------------------------------------------------
--
--	Motherland Ritual Other Player
--
---------------------------------------------------------------

-- intervention declaration
motherland_ritual_other_player = intervention:new(
	"motherland_ritual_other_player",												-- string name
	20,	 																			-- cost
	function() trigger_motherland_ritual_other_player() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

motherland_ritual_other_player:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH)
motherland_ritual_other_player:add_advice_key_precondition("wh3_main_camp_advice_kislev_rival_gaining_support_01")

motherland_ritual_other_player:add_trigger_condition(
	"ScriptEventFactionPerformsMotherlandRitual",
	function(context) 
		return context:faction() ~= cm:get_local_faction() and (cm:get_local_faction_name() == "wh3_main_ksl_the_ice_court" or cm:get_local_faction_name() == "wh3_main_ksl_the_great_orthodoxy")
	end
)

function trigger_motherland_ritual_other_player()
	motherland_ritual_other_player:play_advice_for_intervention(
		"wh3_main_camp_advice_kislev_rival_gaining_support_01", 					-- Your rival calls upon the gods, and now they begin to draw the support of the Kislev people against you. Be sure to respond in kind.
		{
			"war.camp.advice.motherland_ritual_player.info_001", 					-- {{tr:hp_campaign_title_motherland}}
			"war.camp.advice.motherland_ritual_player.info_002", 					-- {{tr:hp_campaign_description_motherland}}
			"war.camp.advice.motherland_ritual_player.info_003",					-- Learn more about the Motherland [[url:script_link_campaign_motherland]]here[[/url]].
		}
	)
end

---------------------------------------------------------------
--
--	Motherland Ritual Other Player Followers
--
---------------------------------------------------------------

-- intervention declaration
motherland_ritual_other_player_followers = intervention:new(
	"motherland_ritual_other_player_followers",										-- string name
	20,	 																			-- cost
	function() trigger_motherland_ritual_other_player_followers() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

motherland_ritual_other_player_followers:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH)
motherland_ritual_other_player_followers:add_advice_key_precondition("wh3_main_camp_advice_kislev_rival_gaining_support_02")

motherland_ritual_other_player_followers:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function() 

		local player_followers =  cm:model():world():faction_by_key(cm:get_local_faction_name()):pooled_resource_manager():resource("wh3_main_ksl_followers")
		local player_followers_count = false
		local enemy_followers = false
		local enemy_followers_count = false

		if cm:get_local_faction_name() == "wh3_main_ksl_the_ice_court" then
			enemy_followers = cm:model():world():faction_by_key("wh3_main_ksl_the_great_orthodoxy"):pooled_resource_manager():resource("wh3_main_ksl_followers")
		else
			enemy_followers = cm:model():world():faction_by_key("wh3_main_ksl_the_ice_court"):pooled_resource_manager():resource("wh3_main_ksl_followers")
		end

		if not player_followers:is_null_interface() then
			player_followers_count = player_followers:value()
		end

		if not enemy_followers:is_null_interface() then
			enemy_followers_count = enemy_followers:value()
		end

		-- Activate this if the enemy has more than X number of followers than player
		if player_followers_count and enemy_followers_count then
			return (enemy_followers_count - player_followers_count) >= 50
		end
	end
)

function trigger_motherland_ritual_other_player_followers()
	motherland_ritual_other_player_followers:play_advice_for_intervention(
		"wh3_main_camp_advice_kislev_rival_gaining_support_02", 									-- Be wary, for your rival has raised much support against you! Take urgent steps to rally the Kislev people to your cause, or look instead to undermine your adversaries through less fair means..
		{
			"war.camp.advice.motherland_ritual_other_player_followers.info_001", 					-- {{tr:hp_campaign_title_motherland}}
			"war.camp.advice.motherland_ritual_other_player_followers.info_002", 					-- {{tr:hp_campaign_description_motherland}}
			"war.camp.advice.motherland_ritual_other_player_followers.info_003",					-- Learn more about the Motherland [[url:script_link_campaign_motherland]]here[[/url]].
		}
	)
end

---------------------------------------------------------------
--
--	Slaanesh Resurrect Faction
--
---------------------------------------------------------------

-- intervention declaration
slaanesh_resurrect_faction = intervention:new(
	"slaanesh_resurrect_faction",										-- string name
	20,	 																-- cost
	function() trigger_slaanesh_resurrect_faction() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

slaanesh_resurrect_faction:set_min_advice_level(ADVICE_LEVEL_HIGH)
slaanesh_resurrect_faction:add_advice_key_precondition("wh3_main_camp_advice_slaanesh_liberation_01")
slaanesh_resurrect_faction:set_wait_for_fullscreen_panel_dismissed(false)
slaanesh_resurrect_faction:set_wait_for_battle_complete(false)

slaanesh_resurrect_faction:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context) 
		if context.string ~= "settlement_captured" then return end

		local uic = find_uicomponent("settlement_captured", "button_parent")
		local uic_2 = false

		if uic then 
			-- Find the post battle option if it exists.
			uic_2 = find_child_uicomponent(uic, "782952222")
		end

		return uic_2
	end
)

function trigger_slaanesh_resurrect_faction()
	slaanesh_resurrect_faction:play_advice_for_intervention(
		"wh3_main_camp_advice_slaanesh_liberation_01", 								-- Remnants of the mortal civilisation that once inhabited these lands may still be found cowering in caves and hovels. They would make excellent playthings for Slaanesh!
		{
			"war.camp.advice.slaanesh_resurrect_faction.info_001", 					-- {{tr:hp_campaign_title_seductive_influence}}
			"war.camp.advice.slaanesh_resurrect_faction.info_002", 					-- {{tr:hp_campaign_point_10_seductive_influence}}
			"war.camp.advice.slaanesh_resurrect_faction.info_003",					-- {{tr:hp_campaign_point_11_seductive_influence}}
			"war.camp.advice.slaanesh_resurrect_faction.info_004"					-- Learn more about Seductive Influence [[url:script_link_campaign_seductive_influence]]here[[/url]].
		}
	)
end

---------------------------------------------------------------
--
--	Winds of Magic Weak
--
---------------------------------------------------------------
do
	local character_pan_cqi = false

	-- intervention declaration
	in_winds_of_magic_weak = intervention:new(
		"winds_of_magic_weak",										-- string name
		20,	 														-- cost
		function() trigger_winds_of_magic_weak() end,				-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
	);

	in_winds_of_magic_weak:set_min_advice_level(ADVICE_LEVEL_HIGH)
	in_winds_of_magic_weak:add_advice_key_precondition("wh3_main_camp_advice_winds_of_magic_weak_01")
	in_winds_of_magic_weak:set_min_turn(11)

	in_winds_of_magic_weak:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function(context) 			
			local mf_list = context:faction():military_force_list();

			for i = 0, mf_list:num_items() - 1 do
				local current_mf = mf_list:item_at(i);
				
				if not current_mf:is_armed_citizenry() and current_mf:has_general() then
					local current_char = current_mf:general_character();
					
					if current_char:has_region() then
						local wom_strength_level, wom_strength_key = current_char:region_data():winds_of_magic_strength();

						if wom_strength_level < 2 then
							in_winds_of_magic_weak.char_cqi = current_char:command_queue_index();
							return true;
						end;
					end;
				end
			end
		end
	)

	function trigger_winds_of_magic_weak()
		-- There is a lull in the Winds of Magic – can you sense the calm? Be wary, for the longer it persists, the weaker your Sorcerers become.
		local advice_key = "wh3_main_camp_advice_winds_of_magic_weak_01";

		local infotext = {
			"war.camp.advice.winds_of_magic_weak.info_001",
			"war.camp.advice.winds_of_magic_weak.info_002",
			"war.camp.advice.winds_of_magic_weak.info_003",
			"war.camp.advice.winds_of_magic_weak.info_004"
		};

		local char_cqi = in_winds_of_magic_weak.char_cqi;

		if char_cqi then
			in_winds_of_magic_weak:scroll_camera_to_character_for_intervention( 
				in_winds_of_magic_weak.char_cqi,
				advice_key,
				infotext				
			);
		else
			in_winds_of_magic_weak:play_advice_for_intervention(
				advice_key,
				infotext
			);
		end;
	end
end

---------------------------------------------------------------
--
--	Winds of Magic Low Reserve
--
---------------------------------------------------------------
do
	local character_pan_cqi = false

	-- intervention declaration
	winds_of_magic_low_reserve = intervention:new(
		"winds_of_magic_low_reserve",										-- string name
		20,	 																-- cost
		function() trigger_winds_of_magic_low_reserve() end,				-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
	);

	winds_of_magic_low_reserve:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH)
	winds_of_magic_low_reserve:add_advice_key_precondition("wh3_main_camp_advice_magic_reserves_low_01")
	winds_of_magic_low_reserve:set_min_turn(5)

	winds_of_magic_low_reserve:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function() 
			local military_force_list = cm:get_local_faction():military_force_list()
			local magic_resource = nil
			
			-- Reset character cqi
			character_pan_cqi = false
		
			for i = 0, military_force_list:num_items() - 1 do
				
				-- If garrison force, skip.
				if not military_force_list:item_at(i):is_armed_citizenry() then 
					
					-- Find magic
					magic_resource = military_force_list:item_at(i):pooled_resource_manager():resource("wh3_main_winds_of_magic")

					if not magic_resource:is_null_interface() then
						if magic_resource:value() <= 20 then
							character_pan_cqi = military_force_list:item_at(i):general_character():command_queue_index()
						end
					end
				end	
			end

			return character_pan_cqi
		end
	)

	function trigger_winds_of_magic_low_reserve()
		winds_of_magic_low_reserve:scroll_camera_to_character_for_intervention( 
			character_pan_cqi, 
			"wh3_main_camp_advice_magic_reserves_low_01", 							-- The Winds of Magic are weak and fickle – your power has dwindled! Be wary of engaging the enemy while so enfeebled!
			{
				"war.camp.advice.winds_of_magic_low_reserve.info_001", 				-- {{tr:hp_campaign_title_winds_of_magic}}
				"war.camp.advice.winds_of_magic_low_reserve.info_002", 				-- Daemonic forces of [[sl:campaign_chaos]]Chaos[[/sl]] are sensitive to their [[sl_tooltip:campaign_winds_of_magic_power_reserve_bar]]power reserves[[/sl_tooltip]] of magic. High reserves grant beneficial effects in battle, while low levels - such as you currently experience - prevent [[img:icon_replenishment]][[/img]][[sl:campaign_unit_replenishment]]unit replenishment[[/sl]]
				"war.camp.advice.winds_of_magic_low_reserve.info_003",				-- {{tr:hp_campaign_point_5_winds_of_magic}}
				"war.camp.advice.winds_of_magic_low_reserve.info_004"				-- Learn more about the Winds of Magic [[url:script_link_campaign_winds_of_magic]]here[[/url]].
			}
		)
	end
end

---------------------------------------------------------------
--
--	Winds of Magic High Reserve
--
---------------------------------------------------------------
do
	local character_pan_cqi = false

	-- intervention declaration
	winds_of_magic_high_reserve = intervention:new(
		"winds_of_magic_high_reserve",										-- string name
		20,	 																-- cost
		function() trigger_winds_of_magic_high_reserve() end,				-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
	);

	winds_of_magic_high_reserve:set_min_advice_level(ADVICE_LEVEL_HIGH)
	winds_of_magic_high_reserve:add_advice_key_precondition("wh3_main_camp_advice_magic_reserves_high_01")
	winds_of_magic_high_reserve:add_advice_key_precondition("wh3_main_camp_advice_magic_reserves_low_01")
	winds_of_magic_high_reserve:set_min_turn(5)

	winds_of_magic_high_reserve:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function() 
			local military_force_list = cm:get_local_faction():military_force_list()
			local magic_resource = nil
			
			-- Reset character cqi
			character_pan_cqi = false
		
			for i = 0, military_force_list:num_items() - 1 do
				
				-- If garrison force, skip.
				if not military_force_list:item_at(i):is_armed_citizenry() then 
					
					-- Find magic
					magic_resource = military_force_list:item_at(i):pooled_resource_manager():resource("wh3_main_winds_of_magic")

					if not magic_resource:is_null_interface() then
						if magic_resource:value() >= 80 then
							character_pan_cqi = military_force_list:item_at(i):general_character():command_queue_index()
						end
					end
				end	
			end

			return character_pan_cqi
		end
	)

	function trigger_winds_of_magic_high_reserve()
		winds_of_magic_high_reserve:scroll_camera_to_character_for_intervention( 
			character_pan_cqi, 
			"wh3_main_camp_advice_magic_reserves_high_01", 							-- Your Daemonic kin are empowered by the Winds of Magic blowing strongly across the skies. Their energies course through you!
			{
				"war.camp.advice.winds_of_magic_high_reserve.info_001", 				-- {{tr:hp_campaign_title_winds_of_magic}}
				"war.camp.advice.winds_of_magic_high_reserve.info_002", 				-- {{tr:hp_campaign_point_4_winds_of_magic}}
				"war.camp.advice.winds_of_magic_high_reserve.info_003",					-- {{tr:hp_campaign_point_5_winds_of_magic}}
				"war.camp.advice.winds_of_magic_high_reserve.info_004"					-- Learn more about the Winds of Magic [[url:script_link_campaign_winds_of_magic]]here[[/url]].
			}
		)
	end
end

---------------------------------------------------------------
--
--	Exalted Greater Daemon
--
---------------------------------------------------------------
do 
	local character_cqi = false

	-- intervention declaration
	exalted_greater_daemon = intervention:new(
		"exalted_greater_daemon",											-- string name
		20,	 																-- cost
		function() trigger_exalted_greater_daemon() end,					-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
	);

	exalted_greater_daemon:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH)
	exalted_greater_daemon:add_advice_key_precondition("wh3_main_camp_advice_exalted_greater_daemon_01")

	exalted_greater_daemon:add_trigger_condition(
		"ScriptEventHeraldUpgradeChance",
		function(context) 
			if not context:character():is_null_interface() then
				if context:character():faction():name() == cm:get_local_faction_name() then
					character_cqi = context:character():command_queue_index()
					return true
				end
			end
		end
	)

	function trigger_exalted_greater_daemon()
		exalted_greater_daemon:scroll_camera_to_character_for_intervention( 
			character_cqi, 
			"wh3_main_camp_advice_exalted_greater_daemon_01", 							-- Rejoice, for a Greater Daemon has risen – just as your herald foretold! Once summoned, this exalted lord of slaughter will take their place at the head of your army, and lead the charge against the mortal realms!
			{
				"war.camp.advice.exalted_greater_daemon.info_001", 						-- {{tr:hp_campaign_title_exalted_greater_daemons}}
				"war.camp.advice.exalted_greater_daemon.info_002", 						-- {{tr:hp_campaign_description_exalted_greater_daemons}}
				"war.camp.advice.exalted_greater_daemon.info_003",						-- Learn more about Exalted Greater Daemons [[url:script_link_campaign_exalted_greater_daemons]]here[[/url]].
			}
		)
	end
end

---------------------------------------------------------------
--
--	Item Fusing
--
---------------------------------------------------------------

-- intervention declaration
item_fusing = intervention:new(
	"item_fusing",														-- string name
	20,	 																-- cost
	function() trigger_item_fusing() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

item_fusing:set_min_advice_level(ADVICE_LEVEL_HIGH)
item_fusing:add_advice_key_precondition("wh3_main_camp_advice_item_fusing_01")
item_fusing:set_min_turn(5)

item_fusing:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function() 
		local number_of_ancillaries = common.get_context_value("CcoCampaignFaction", cm:get_local_faction():command_queue_index(), "AncillaryList.Size")
		if is_number(number_of_ancillaries) then
			if number_of_ancillaries >= 10 then
				return true
			end
		end
	end
)

function trigger_item_fusing()
	item_fusing:play_advice_for_intervention(
		"wh3_main_camp_advice_item_fusing_01", 								-- Your smiths may reforge enchanted weapons and armour anew. Send armaments to be reduced to their core essences, and combined to forge new items of greater magical power.
		{
			"war.camp.advice.item_fusing.info_001", 						-- Magic Item Fusing
			"war.camp.advice.item_fusing.info_002", 						-- {{tr:hp_campaign_magic_items_add_01}}
			"war.camp.advice.item_fusing.info_003",							-- {{tr:hp_campaign_point_5_magic_items}} {{tr:hp_campaign_magic_items_add_02}} 
			"war.camp.advice.item_fusing.info_004",							-- Learn more about Magic Items [[url:script_link_campaign_magic_items]]here[[/url]].
		}
	)
end

---------------------------------------------------------------
--
--	Ogre Merc Recruitment
--
---------------------------------------------------------------
do
	local character_pan_cqi = false

	-- intervention declaration
	ogre_merc_recruitment = intervention:new(
		"ogre_merc_recruitment",											-- string name
		20,	 																-- cost
		function() trigger_ogre_merc_recruitment() end,						-- trigger callback
		BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
	);

	ogre_merc_recruitment:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH);
	ogre_merc_recruitment:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);
	ogre_merc_recruitment:add_advice_key_precondition("wh3_main_camp_advice_ogre_mercenary_recruitment_01")

	ogre_merc_recruitment:add_trigger_condition(
		"ScriptEventPlayerFactionTurnStart",
		function() 		
			local visible_characters_list = cm:get_local_faction():get_foreign_visible_characters_for_player()
			
			for i = 0, visible_characters_list:num_items() - 1 do
				if visible_characters_list:item_at(i):character_subtype_key() == "wh3_main_ogr_tyrant_camp" and not visible_characters_list:item_at(i):faction():at_war_with(cm:get_local_faction()) then
					character_pan_cqi = visible_characters_list:item_at(i):command_queue_index()
					return true
				end
			end
		end
	)

	function trigger_ogre_merc_recruitment()
		ogre_merc_recruitment:scroll_camera_to_character_for_intervention( 
			character_pan_cqi,
			-- An Ogre camp has been sighted nearby! Such brutish creatures are generally best kept at the sharp end of a sword, yet on occasion it has been known for outsiders to yoke their strength.
			"wh3_main_camp_advice_ogre_mercenary_recruitment_01"
		)
		
	end
end

---------------------------------------------------------------
--
--	Daemonic Progression Item
--
---------------------------------------------------------------

-- intervention declaration
daemonic_progression_item = intervention:new(
	"daemonic_progression_item",										-- string name
	20,	 																-- cost
	function() trigger_daemonic_progression_item() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

daemonic_progression_item:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH)
daemonic_progression_item:add_advice_key_precondition("wh3_main_camp_advice_daemon_daemonic_progression_item_01")

daemonic_progression_item:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function(context) 		
		local player_resources = context:faction():pooled_resource_manager():resources()
		for i = 0, player_resources:num_items() - 1 do
			if player_resources:item_at(i):key() == "wh3_main_dae_nurgle_points" and player_resources:item_at(i):value() >= 210 then
				return true
			elseif player_resources:item_at(i):key() == "wh3_main_dae_tzeentch_points" and player_resources:item_at(i):value() >= 210 then
				return true
			elseif player_resources:item_at(i):key() == "wh3_main_dae_undivided_points" and player_resources:item_at(i):value() >= 210 then
				return true
			elseif player_resources:item_at(i):key() == "wh3_main_dae_slaanesh_points" and player_resources:item_at(i):value() >= 210 then
				return true
			elseif player_resources:item_at(i):key() == "wh3_main_dae_khorne_points" and player_resources:item_at(i):value() >= 210 then
				return true
			end
		end;
	end
)

function trigger_daemonic_progression_item()
	daemonic_progression_item:scroll_camera_to_character_for_intervention( 
		cm:get_local_faction():faction_leader():command_queue_index(), 
		"wh3_main_camp_advice_daemon_daemonic_progression_item_01", 						-- Your standing grows within the pantheon of Chaos, and the Ruinous Powers offer gifts that may transform your very being. Choose wisely from among them.
		{
			"war.camp.advice.daemonic_progression_item.info_001", 							-- {{tr:hp_campaign_title_daemonic_glory}}
			"war.camp.advice.daemonic_progression_item.info_002", 							-- [[sl:campaign_daemons_of_chaos]]Daemons of Chaos[[/sl]] unlock [[sl_tooltip:campaign_daemonic_gifts]]Daemonic Gifts[[/sl_tooltip]] as they earn [[sl:campaign_daemonic_glory]]Daemonic Glory[[/sl]] with the Ruinous Powers. {{tr:hp_campaign_daemonic_glory_add_02}}
			"war.camp.advice.daemonic_progression_item.info_003",							-- {{tr:hp_campaign_daemonic_glory_add_01}}
			"war.camp.advice.daemonic_progression_item.info_004",							-- Learn more about Daemonic Glory [[url:script_link_campaign_daemonic_glory]]here[[/url]].
		}
	)
end

---------------------------------------------------------------
--
--	Request Foreign Army
--
---------------------------------------------------------------

-- intervention declaration
in_request_foreign_army = intervention:new(
	"request_foreign_army",												-- string name
	20,	 																-- cost
	function() trigger_request_foreign_army() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_request_foreign_army:set_min_advice_level(ADVICE_LEVEL_LOW_HIGH)
in_request_foreign_army:add_advice_key_precondition("wh3_main_camp_advice_request_foreign_army_01")
in_request_foreign_army:set_min_turn(5)

in_request_foreign_army:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()
		local player_faction = cm:get_local_faction()
		local all_factions_list = cm:model():world():faction_list()

		for i = 0, all_factions_list:num_items() - 1 do
			if all_factions_list:item_at(i) ~= player_faction and all_factions_list:item_at(i):military_allies_with(player_faction) then

				-- Store faciton string (for some reason this is necessary).
				local factions_string = player_faction:name().."."..all_factions_list:item_at(i):name()

				-- Cycle through list of military forces that can be loaned.
				for i = 0, common.get_context_value("CcoCampaignFactionInteraction", factions_string, "MilitaryForcesToLoanList.Size") - 1 do

					-- If the force can be loaned (if the player has sufficient alliegance) then start advice.
					if common.get_context_value("CcoCampaignFactionInteraction", factions_string, "MilitaryForcesToLoanList.At("..i..").CanPlayerLoan") then
						return true	
					end
				end

			end
		end
	end
)

function trigger_request_foreign_army()
	in_request_foreign_army:play_advice_for_intervention(
		"wh3_main_camp_advice_request_foreign_army_01", 								-- In times of crisis you may petition your allies for direct control over a portion of their military. Close allies, with whom much allegiance has been built, may accede to the request.
		{
			"war.camp.advice.request_foreign_army.info_001", 							-- {{tr:hp_campaign_title_war_coordination}}
			"war.camp.advice.request_foreign_army.info_002", 							-- Factions in an [[img:icon_military_alliance]][[/img]][[sl:campaign_alliance]]alliance[[/sl]] can spend the [[img:icon_allegiance]][[/img]][[sl:campaign_allegiance]]allegiance[[/sl]] built up between them to request direct control of an [[sl:campaign_armies]]army[[/sl] belonging to the other.
			"war.camp.advice.request_foreign_army.info_003",							-- {{tr:hp_campaign_war_coordination_add_01}}
			"war.camp.advice.request_foreign_army.info_004",							-- Learn more about the War Co-ordination [[url:script_link_campaign_war_coordination]]here[[/url]].
		}
	)
end


---------------------------------------------------------------
--
--	Khorne
--
---------------------------------------------------------------

-- intervention declaration
in_khorne = intervention:new(
	"khorne",					 													-- string name
	60, 																			-- cost
	function() in_khorne_trigger() end,												-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_khorne:set_min_advice_level(ADVICE_LEVEL_HIGH)
in_khorne:add_advice_key_precondition("war.camp.advice.races.khorne.001")
in_khorne:add_precondition(function() return cm:is_subculture_in_campaign("wh3_main_sc_kho_khorne") end)
in_khorne:add_precondition(function() return cm:get_saved_value("advice_khorne_seen") ~= true end)
in_khorne:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_khorne:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()				
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh3_main_sc_kho_khorne")
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_khorne_seen", true)
				return false
			end

			in_khorne.char_cqi = char:cqi()
			return true
		end
		return false
	end
)


function in_khorne_trigger()

	local char_cqi = in_khorne.char_cqi;
	
	-- Keep your weapons to hand, for the followers of Khorne have been sighted nearby! Those who serve the Chaos God of Rage practice little but pillage and slaughter. Be prepared to meet them in battle.
	local advice_key = "war.camp.advice.races.khorne.001"
	
	local infotext = {
		"war.camp.advice.khorne.info_001",
		"war.camp.advice.khorne.info_002", 
		"war.camp.advice.khorne.info_003"
	};
	
	in_khorne:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key,
		infotext
	);
end

---------------------------------------------------------------
--
--	Nurgle
--
---------------------------------------------------------------

-- intervention declaration
in_nurgle = intervention:new(
	"nurgle",					 													-- string name
	60, 																			-- cost
	function() in_nurgle_trigger() end,												-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_nurgle:set_min_advice_level(ADVICE_LEVEL_HIGH)
in_nurgle:add_advice_key_precondition("war.camp.advice.races.nurgle.001")
in_nurgle:add_precondition(function() return cm:is_subculture_in_campaign("wh3_main_sc_nur_nurgle") end)
in_nurgle:add_precondition(function() return cm:get_saved_value("advice_nurgle_seen") ~= true end)
in_nurgle:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_nurgle:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()				
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh3_main_sc_nur_nurgle")
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_nurgle_seen", true)
				return false
			end

			in_nurgle.char_cqi = char:cqi()
			return true
		end
		return false
	end
)


function in_nurgle_trigger()

	local char_cqi = in_nurgle.char_cqi;
	
	-- Cover your mouths, for the foetid scent that drifts on the air foreshadows the servants of Nurgle! All those who stand against the Chaos God of Pestilence meet with disease and death – beware!
	local advice_key = "war.camp.advice.races.nurgle.001"
	
	local infotext = {
		"war.camp.advice.nurgle.info_001",
		"war.camp.advice.nurgle.info_002", 
		"war.camp.advice.nurgle.info_003"
	};
	
	in_nurgle:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key,
		infotext
	);
end

---------------------------------------------------------------
--
--	Slaanesh
--
---------------------------------------------------------------

-- intervention declaration
in_slaanesh = intervention:new(
	"slaanesh",					 													-- string name
	60, 																			-- cost
	function() in_slaanesh_trigger() end,											-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_slaanesh:set_min_advice_level(ADVICE_LEVEL_HIGH)
in_slaanesh:add_advice_key_precondition("war.camp.advice.races.slaanesh.001")
in_slaanesh:add_precondition(function() return cm:is_subculture_in_campaign("wh3_main_sc_sla_slaanesh") end)
in_slaanesh:add_precondition(function() return cm:get_saved_value("advice_slaanesh_seen") ~= true end)
in_slaanesh:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_slaanesh:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()				
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh3_main_sc_sla_slaanesh")
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_slaanesh_seen", true)
				return false
			end

			in_slaanesh.char_cqi = char:cqi()
			return true
		end
		return false
	end
)


function in_slaanesh_trigger()

	local char_cqi = in_slaanesh.char_cqi;
	
	-- That perfume, those screams... the forces of Slaanesh must be close at hand! Be wary, for these decadent, amoral sadists will seek to tempt your followers into the service of the Chaos God of Pleasure.
	local advice_key = "war.camp.advice.races.slaanesh.001"
	
	local infotext = {
		"war.camp.advice.slaanesh.info_001",
		"war.camp.advice.slaanesh.info_002", 
		"war.camp.advice.slaanesh.info_003"
	};
	
	in_slaanesh:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key,
		infotext
	);
end

---------------------------------------------------------------
--
--	Tzeentch
--
---------------------------------------------------------------

-- intervention declaration
in_tzeentch = intervention:new(
	"tzeentch",					 													-- string name
	60, 																			-- cost
	function() in_tzeentch_trigger() end,											-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_tzeentch:set_min_advice_level(ADVICE_LEVEL_HIGH)
in_tzeentch:add_advice_key_precondition("war.camp.advice.races.tzeentch.001")
in_tzeentch:add_precondition(function() return cm:is_subculture_in_campaign("wh3_main_sc_tze_tzeentch") end)
in_tzeentch:add_precondition(function() return cm:get_saved_value("advice_tzeentch_seen") ~= true end)
in_tzeentch:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_tzeentch:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()				
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh3_main_sc_tze_tzeentch")
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_tzeentch_seen", true)
				return false
			end

			in_tzeentch.char_cqi = char:cqi()
			return true
		end
		return false
	end
)


function in_tzeentch_trigger()

	local char_cqi = in_tzeentch.char_cqi;
	
	-- My scrying fails me... the servants of Tzeentch must be close by! The Changer of Ways blocks my foresight, such are His powers of magic and manipulation. Engage the Great Conspirator or His adherents at your peril!
	local advice_key = "war.camp.advice.races.tzeentch.001"
	
	local infotext = {
		"war.camp.advice.tzeentch.info_001",
		"war.camp.advice.tzeentch.info_002", 
		"war.camp.advice.tzeentch.info_003"
	};
	
	in_tzeentch:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key,
		infotext
	);
end

---------------------------------------------------------------
--
--	Kislev
--
---------------------------------------------------------------

-- intervention declaration
in_kislev = intervention:new(
	"kislev",					 													-- string name
	60, 																			-- cost
	function() in_kislev_trigger() end,												-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_kislev:set_min_advice_level(ADVICE_LEVEL_HIGH)
in_kislev:add_advice_key_precondition("war.camp.advice.races.kislev.001")
in_kislev:add_precondition(function() return cm:is_subculture_in_campaign("wh3_main_sc_ksl_kislev") end)
in_kislev:add_precondition(function() return cm:get_saved_value("advice_kislev_seen") ~= true end)
in_kislev:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_kislev:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()				
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh3_main_sc_ksl_kislev")
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_kislev_seen", true)
				return false
			end

			in_kislev.char_cqi = char:cqi()
			return true
		end
		return false
	end
)


function in_kislev_trigger()

	local char_cqi = in_kislev.char_cqi;
	
	-- The forces of Kislev are close at hand. These frostbitten warriors from the northern edge of the world pride themselves as the hardiest of all the kingdoms of men. You may get to test this claim soon, I sense.
	local advice_key = "war.camp.advice.races.kislev.001"
	
	local infotext = {
		"war.camp.advice.kislev.info_001",
		"war.camp.advice.kislev.info_002", 
		"war.camp.advice.kislev.info_003"
	};
	
	in_kislev:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key,
		infotext
	);
end

---------------------------------------------------------------
--
--	Cathay
--
---------------------------------------------------------------

-- intervention declaration
in_cathay = intervention:new(
	"cathay",					 													-- string name
	60, 																			-- cost
	function() in_cathay_trigger() end,												-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_cathay:set_min_advice_level(ADVICE_LEVEL_HIGH)
in_cathay:add_advice_key_precondition("war.camp.advice.races.cathay.001")
in_cathay:add_precondition(function() return cm:is_subculture_in_campaign("wh3_main_sc_cth_cathay") end)
in_cathay:add_precondition(function() return cm:get_saved_value("advice_cathay_seen") ~= true end)
in_cathay:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);

in_cathay:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()				
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh3_main_sc_cth_cathay")
		
		if char and distance < INTERVENTION_CLOSE_DISTANCE then

			-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_cathay_seen", true)
				return false
			end

			in_cathay.char_cqi = char:cqi()
			return true
		end
		return false
	end
)


function in_cathay_trigger()

	local char_cqi = in_cathay.char_cqi;
	
	-- The defenders of the Celestial Empire have been sighted nearby. You may scoff, yet I advise caution: while the forces of Cathay may be individually weak, when united their powers in battle are quite formidable.
	local advice_key = "war.camp.advice.races.cathay.001"
	
	local infotext = {
		"war.camp.advice.cathay.info_001",
		"war.camp.advice.cathay.info_002", 
		"war.camp.advice.cathay.info_003"
	};
	
	in_cathay:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key,
		infotext
	);
end

---------------------------------------------------------------
--
--	Ogres
--
---------------------------------------------------------------

-- intervention declaration
in_ogres = intervention:new(
	"ogres",					 													-- string name
	60, 																			-- cost
	function() in_ogres_trigger() end,												-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
);

in_ogres:set_min_advice_level(ADVICE_LEVEL_HIGH)
in_ogres:add_advice_key_precondition("war.camp.advice.race.ogres.001")
in_ogres:add_precondition(function() return cm:is_subculture_in_campaign("wh3_main_sc_ogr_ogre_kingdoms") end)
in_ogres:add_precondition(function() return cm:get_saved_value("advice_ogres_seen") ~= true end)
in_ogres:add_precondition(function() return not EXPENSIVE_ADVICE_DISABLED end);


in_ogres:add_trigger_condition(
	"ScriptEventPlayerFactionTurnStart",
	function()				
		
		local char, distance = cm:get_closest_visible_character_of_subculture(cm:get_local_faction_name(), "wh3_main_sc_ogr_ogre_kingdoms")
		
		-- stop this intervention and prevent it restarting if we see characters of this subculture before the minimum turn
		if char and distance < INTERVENTION_CLOSE_DISTANCE then
			if cm:turn_number() < BOOL_ALLOW_SEEN_FACTION_ADVICE_TURN then
				cm:set_saved_value("advice_ogres_seen", true)
				return false
			end

			in_ogres.char_cqi = char:cqi()
			return true
		end
		return false
	end
)


function in_ogres_trigger()

	local char_cqi = in_ogres.char_cqi;
	
	-- Ogres, my lord. These brutish nomads are as strong as they are stupid, but do not underestimate them. They are hardy warriors and will cannibalise any foe that dares to cross them.
	local advice_key = "war.camp.advice.race.ogres.001"
	
	local infotext = {
		"war.camp.advice.ogres.info_001",
		"war.camp.advice.ogres.info_002", 
		"war.camp.advice.ogres.info_003"
	};
	
	in_ogres:scroll_camera_to_character_for_intervention( 
		char_cqi,
		advice_key,
		infotext
	);
end

---------------------------------------------------------------
--
--	Ataman Dilemma
--
---------------------------------------------------------------

-- intervention declaration
ataman_dilemma = intervention:new(
	"ataman_dilemma",												-- string name
	20,	 															-- cost
	function() trigger_ataman_dilemma() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 									-- show debug output
);

ataman_dilemma:set_min_advice_level(ADVICE_LEVEL_HIGH)
ataman_dilemma:add_advice_key_precondition("wh3_main_camp_advice_kislev_atamans_dilemma_01")
ataman_dilemma:set_min_turn(5)

ataman_dilemma:add_trigger_condition(
	"ProvinceGovernorshipNewDecisionAvailable",
	function(context)
		local province_key = context:province():key();
		local region_list = cm:get_local_faction():region_list()
		for i = 0, region_list:num_items() - 1 do
			if region_list:item_at(i):province():key() == province_key then
				return true
			end
		end
	end
)

function trigger_ataman_dilemma()
	ataman_dilemma:play_advice_for_intervention(
		"wh3_main_camp_advice_kislev_atamans_dilemma_01", 						-- While wise, your Ataman will seek your counsel from time to time. Be sure to offer your guidance where necessary.
		{
			"war.camp.advice.ataman_dilemma.info_001", 							-- {{tr:hp_campaign_title_atamans}}
			"war.camp.advice.ataman_dilemma.info_002", 							-- {{tr:hp_campaign_description_atamans}}
			"war.camp.advice.ataman_dilemma.info_003",							-- {{tr:hp_campaign_point_3_atamans}}
			"war.camp.advice.ataman_dilemma.info_004",							-- Learn more about Atamans [[url:script_link_campaign_atamans]]here[[/url]].
		}
	)
end

---------------------------------------------------------------
--
--	Item Sets
--
---------------------------------------------------------------

-- intervention declaration
item_sets = intervention:new(
	"item_sets",														-- string name
	20,	 																-- cost
	function() trigger_item_sets() end,									-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

item_sets:set_min_advice_level(ADVICE_LEVEL_HIGH)
item_sets:add_advice_key_precondition("wh3_main_camp_advice_item_sets_01")
item_sets:set_min_turn(5)

item_sets:add_trigger_condition(
	"FactionGainedAncillary",
	function() 
		for i = 0, common.get_context_value("CcoCampaignFaction", cm:get_local_faction():command_queue_index(), "AncillaryList.Size") - 1 do 
			if common.get_context_value("CcoCampaignFaction", cm:get_local_faction():command_queue_index(), "AncillaryList.At("..i..").AncillaryRecordContext.AncillarySetContext") then
				return true
			end
		end	
	end
)

function trigger_item_sets()
	item_sets:play_advice_for_intervention(
		"wh3_main_camp_advice_item_sets_01", 								-- Your newly-gained armament is magically bound to a number of companion pieces. Combine all parts of the suit and its bearer will wield great power indeed.
		{
			"war.camp.hp.magic_items.info_001",
			"war.camp.hp.magic_items.info_002",
			"war.camp.hp.magic_items.info_003"
		}
	)
end